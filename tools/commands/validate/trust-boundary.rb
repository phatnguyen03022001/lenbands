#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "set"

$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)
require "lenbands"
require "lenbands/yaml_loader"

root = File.expand_path("../../..", __dir__)
diff_path = nil
while ARGV.any?
  case ARGV.shift
  when "--diff" then diff_path = ARGV.shift
  else abort "usage: trust-boundary.rb [--diff git-name-status.txt]"
  end
end

load_mapping = lambda do |relative|
  Lenbands::YamlLoader.load_file(File.join(root, relative), mapping: true)
rescue Lenbands::YamlError => e
  abort "agent trust-boundary validation unavailable: #{relative}: #{e.message}"
end

policy = load_mapping.call("artifacts/operations/agent-trust-policy.yaml")
change_governance = load_mapping.call("artifacts/operations/change-governance.yaml")
hosting_state = load_mapping.call("artifacts/operations/hosting-control-state.yaml")
toolchain = load_mapping.call("tools/toolchain.yaml")
errors = []

errors << "agent trust policy schema_version must be 1.0.0" unless policy["schema_version"] == "1.0.0"
errors << "agent trust policy must be source_of_truth within its scope" unless policy["source_of_truth"] == true
errors << "change governance must be source_of_truth" unless change_governance["source_of_truth"] == true
errors << "change governance must require external authorization outside the candidate tree" unless change_governance.dig("external_authorization", "location") == "outside_candidate_tree"
errors << "change governance must invalidate authorization after candidate mutation" unless change_governance.dig("external_authorization", "candidate_mutation_invalidates_authorization") == true
errors << "change governance must forbid repository self-authorization" unless change_governance.dig("external_authorization", "repository_file_must_not_claim_authorization") == true

host_rules = Array(hosting_state["rules"])
errors << "hosting state must reject repository policy as GitHub enforcement evidence" unless host_rules.include?("repository_policy_files_are_not_evidence_of_github_enforcement")
errors << "hosting state must reject repository CI as branch-protection evidence" unless host_rules.include?("repository_ci_success_is_not_branch_protection_evidence")
errors << "hosting state observation source missing" if hosting_state["observation_source"].to_s.empty?

commands = Array(toolchain["public_commands"]).map { |item| item["command"] }.to_set
Array(policy["required_public_commands"]).each { |command| errors << "required public command missing: #{command}" unless commands.include?(command) }

verify_body = File.read(File.join(root, "tools/commands/verify.sh"))
Array(policy["required_verify_targets"]).each { |target| errors << "verify omits protected target: #{target}" unless verify_body.include?(target) }
freeze_body = File.read(File.join(root, "tools/commands/gate/toolchain-freeze.sh"))
Array(policy["required_freeze_targets"]).each { |target| errors << "toolchain freeze omits protected target: #{target}" unless freeze_body.include?(target) }

codeowners_path = File.join(root, ".github/CODEOWNERS")
workflow_path = File.join(root, ".github/workflows/toolchain-trust.yml")
errors << "CODEOWNERS missing" unless File.file?(codeowners_path)
errors << "toolchain trust workflow missing" unless File.file?(workflow_path)
if File.file?(workflow_path)
  workflow = File.read(workflow_path)
  %w[tools/bin/lenbands\ doctor tools/bin/lenbands\ verify tools/bin/lenbands\ gate\ toolchain validate\ trust-boundary].each do |marker|
    errors << "toolchain trust workflow missing #{marker.gsub('\\ ', ' ')}" unless workflow.include?(marker.gsub("\\ ", " "))
  end
  errors << "checkout action must be pinned to a full commit SHA" unless workflow.match?(/uses:\s*actions\/checkout@[0-9a-f]{40}\b/)
  errors << "checkout credentials must not persist" unless workflow.include?("persist-credentials: false")
  errors << "trust workflow must use read-only contents permission" unless workflow.match?(/permissions:\s*\n\s+contents:\s+read/)
  errors << "trust workflow must not use pull_request_target" if workflow.include?("pull_request_target")
  errors << "trust workflow must bind an exact CANDIDATE_SHA" unless workflow.include?("CANDIDATE_SHA:")
  errors << "trust workflow must checkout the exact candidate SHA" unless workflow.include?('ref: ${{ env.CANDIDATE_SHA }}')
  errors << "trust workflow must assert exact candidate checkout" unless workflow.include?('git rev-parse HEAD') && workflow.include?('$CANDIDATE_SHA')
  errors << "protected diff must compare against exact candidate SHA" unless workflow.include?('git diff --name-status "$BASE_SHA" "$CANDIDATE_SHA"')
end

matcher = lambda do |path, patterns|
  Array(patterns).any? { |pattern| File.fnmatch(pattern, path, File::FNM_PATHNAME | File::FNM_EXTGLOB) }
end

if diff_path
  abort "diff file missing: #{diff_path}" unless File.file?(diff_path)
  changes = File.readlines(diff_path, chomp: true).map do |line|
    fields = line.split("\t")
    status = fields.shift.to_s
    paths = status.start_with?("R", "C") ? fields.last(2) : fields.first(1)
    [status, paths]
  end

  protected_changes = []
  declaration_paths = []
  declaration_pattern = change_governance.dig("candidate_declaration", "path_pattern").to_s
  changes.each do |status, paths|
    paths.each do |path|
      protected_changes << path if matcher.call(path, policy["protected_paths"])
      if !path.end_with?(".meta.yaml") && !declaration_pattern.empty? && File.fnmatch(declaration_pattern, path, File::FNM_PATHNAME | File::FNM_EXTGLOB)
        declaration_paths << path
      end
      if matcher.call(path, policy["immutable_append_only_paths"]) && !status.start_with?("A")
        errors << "immutable evidence may only be added, not #{status}: #{path}"
      end
    end
  end

  if protected_changes.any? && change_governance.dig("candidate_declaration", "required_for_protected_change") == true
    errors << "protected changes require exactly one changed candidate declaration" unless declaration_paths.length == 1
    declaration_paths.each do |path|
      absolute = File.join(root, path)
      unless File.file?(absolute)
        errors << "candidate declaration missing: #{path}"
        next
      end
      begin
        declaration = Lenbands::YamlLoader.load_file(absolute, mapping: true)
      rescue Lenbands::YamlError => e
        errors << "#{path}: #{e.message}"
        next
      end

      Array(change_governance.dig("candidate_declaration", "required_fields")).each do |field|
        errors << "#{path}: missing #{field}" unless declaration.key?(field)
      end
      change_governance.fetch("candidate_declaration").fetch("invariants").each do |field, expected|
        errors << "#{path}: #{field} must be #{expected.inspect}" unless declaration[field] == expected
      end
      Array(change_governance.dig("candidate_declaration", "prohibited_self_claims")).each do |field|
        errors << "#{path}: self-claim field #{field} is forbidden; authorization/proof is external" if declaration.key?(field)
      end
      errors << "#{path}: change_id must be non-empty" if declaration["change_id"].to_s.empty?
      errors << "#{path}: change_scope must be non-empty" if declaration["change_scope"].to_s.empty?
    end
  end
end

if errors.empty?
  suffix = diff_path ? ", diff_checked=true" : ""
  puts "agent trust-boundary validation passed (protected=#{Array(policy["protected_paths"]).length}, self_authorization=false#{suffix})"
else
  warn errors.join("\n")
  warn "agent trust-boundary validation failed: #{errors.length} issue(s)"
  exit 1
end
