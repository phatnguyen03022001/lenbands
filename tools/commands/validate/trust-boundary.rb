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

begin
  policy = Lenbands::YamlLoader.load_file(File.join(root, "artifacts/operations/agent-trust-policy.yaml"), mapping: true)
  toolchain = Lenbands::YamlLoader.load_file(File.join(root, "tools/toolchain.yaml"), mapping: true)
rescue Lenbands::YamlError => e
  abort "agent trust-boundary validation unavailable: #{e.message}"
end
errors = []
errors << "agent trust policy schema_version must be 1.0.0" unless policy["schema_version"] == "1.0.0"
errors << "agent trust policy must be source_of_truth within its scope" unless policy["source_of_truth"] == true

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
  attestation_paths = []
  changes.each do |status, paths|
    paths.each do |path|
      protected_changes << path if matcher.call(path, policy["protected_paths"])
      attestation_paths << path if File.fnmatch(policy.dig("attestation", "path_pattern").to_s, path, File::FNM_PATHNAME | File::FNM_EXTGLOB) && !path.end_with?(".meta.yaml")
      if matcher.call(path, policy["immutable_append_only_paths"]) && !status.start_with?("A")
        errors << "immutable evidence may only be added, not #{status}: #{path}"
      end
    end
  end

  if protected_changes.any? && policy.dig("attestation", "required_for_protected_change") == true
    errors << "protected changes require one changed attestation" if attestation_paths.empty?
    attestation_paths.each do |path|
      absolute = File.join(root, path)
      unless File.file?(absolute)
        errors << "attestation missing: #{path}"
        next
      end
      begin
        attestation = Lenbands::YamlLoader.load_file(absolute, mapping: true)
      rescue Lenbands::YamlError => e
        errors << "#{path}: #{e.message}"
        next
      end
      Array(policy.dig("attestation", "required_fields")).each { |field| errors << "#{path}: missing #{field}" unless attestation.key?(field) }
      policy.fetch("attestation").fetch("invariants").each do |field, expected|
        errors << "#{path}: #{field} must be #{expected.inspect}" unless attestation[field] == expected
      end
      errors << "#{path}: external_review_required must be true" unless attestation["external_review_required"] == true
      if attestation["authority_boundaries_changed"] == true || attestation["readiness_claimed"] == true
        errors << "#{path}: authority/readiness change requires approval_ref" if attestation["approval_ref"].to_s.empty?
      end
      commands_run = Array(attestation["commands_run"])
      %w[tools/bin/lenbands\ verify tools/bin/lenbands\ gate\ toolchain].each do |command|
        command = command.gsub("\\ ", " ")
        errors << "#{path}: commands_run missing #{command}" unless commands_run.include?(command)
      end
    end
  end
end

if errors.empty?
  suffix = diff_path ? ", diff_checked=true" : ""
  puts "agent trust-boundary validation passed (protected=#{Array(policy["protected_paths"]).length}#{suffix})"
else
  warn errors.join("\n")
  warn "agent trust-boundary validation failed: #{errors.length} issue(s)"
  exit 1
end
