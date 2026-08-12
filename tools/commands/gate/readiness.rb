#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "digest"

$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)
require "lenbands"
require "lenbands/yaml_loader"

root = File.expand_path("../../..", __dir__)
mode = ARGV.fetch(0, "p0")
abort "usage: readiness.rb <p0|repository>" unless %w[p0 repository].include?(mode)
load_yaml = lambda do |path|
  Lenbands::YamlLoader.load_file(File.join(root, path), mapping: true)
rescue Lenbands::YamlError => e
  abort "readiness gate cannot load authority input: #{e.message}"
end
blockers = []

manifest = load_yaml.call("artifacts/operations/capability-manifest.yaml")
Array(manifest["capability_families"]).each do |pack|
  blockers << "#{pack["family_id"]}: readiness_state=#{pack["readiness_state"]}" unless pack["readiness_state"] == "ready"
  blockers.concat(Array(pack["readiness_blockers"]).map { |item| "#{pack["family_id"]}: #{item}" })
  next unless pack["readiness_state"] == "ready"
  blockers << "#{pack["family_id"]}: ready pack retains blockers" unless Array(pack["readiness_blockers"]).empty?
  Array(pack["artifacts_current"]).each do |artifact|
    path = artifact["path"].to_s
    blockers << "#{pack["family_id"]}: artifact not declared approved: #{path}" unless artifact["status"] == "approved"
    next if path.empty?
    stem = path.sub(/\.(?:md|yaml|yml)\z/, "")
    meta_path = "#{stem}.meta.yaml"
    unless File.file?(File.join(root, meta_path))
      blockers << "#{pack["family_id"]}: artifact metadata missing: #{meta_path}"
      next
    end
    meta = load_yaml.call(meta_path)
    blockers << "#{pack["family_id"]}: artifact metadata not approved: #{meta_path}" unless meta["status"] == "approved"
    blockers << "#{pack["family_id"]}: artifact approval identity missing: #{meta_path}" if meta["reviewed_by"].to_s.empty? || meta["reviewed_at"].to_s.empty?
  end
end
acceptance = load_yaml.call("artifacts/operations/acceptance/p0-acceptance-manifest.yaml")
evidence_root_value = acceptance["evidence_root"].to_s.sub(%r{/+\z}, "")
evidence_root_absolute = nil
if evidence_root_value.empty? || evidence_root_value.start_with?(File::SEPARATOR) || evidence_root_value.split(File::SEPARATOR).include?("..")
  blockers << "acceptance evidence_root must be a non-empty repository-relative path"
else
  candidate = File.expand_path(evidence_root_value, root)
  repository_prefix = root + File::SEPARATOR
  if candidate.start_with?(repository_prefix)
    evidence_root_absolute = candidate
  else
    blockers << "acceptance evidence_root escapes repository"
  end
end
Array(acceptance["packs"]).each do |pack|
  unless pack["status"] == "passed"
    blockers << "#{pack["pack_id"]}: acceptance=#{pack["status"]}"
    next
  end
  refs = pack["evidence_refs"] || {}
  Array(pack["required_evidence"]).each do |evidence_id|
    reference = refs[evidence_id]
    unless reference.is_a?(Hash)
      blockers << "#{pack["pack_id"]}: passed acceptance missing evidence_ref #{evidence_id}"
      next
    end
    path = reference["path"].to_s
    checksum = reference["checksum"].to_s
    absolute = File.expand_path(path, root)
    contained = evidence_root_absolute && absolute.start_with?(evidence_root_absolute + File::SEPARATOR)
    blockers << "#{pack["pack_id"]}: evidence path escapes evidence root #{path}" unless contained
    unless File.file?(absolute)
      blockers << "#{pack["pack_id"]}: evidence file missing #{path}"
      next
    end
    actual = "sha256:#{Digest::SHA256.file(absolute).hexdigest}"
    blockers << "#{pack["pack_id"]}: evidence checksum mismatch #{evidence_id}" unless checksum == actual
  end
end
corpus = load_yaml.call("artifacts/operations/benchmark/gold-corpus-manifest.yaml")
blockers << "gold corpus is not ready/rights-verified/label-verified" unless corpus["status"] == "ready" && corpus["rights_status"] == "verified" && corpus["label_status"] == "verified"
if corpus["status"] == "ready"
  blockers << "gold corpus is below minimum authorized case count" if corpus["gold_case_count"].to_i < corpus["minimum_gold_cases_policy"].to_i
  Array(corpus["cases"]).each do |item|
    reference = item["rights_evidence_ref"].to_s
    blockers << "gold corpus case #{item["case_id"]}: rights evidence missing #{reference}" if reference.empty? || !File.file?(File.join(root, reference))
  end
end
policy = load_yaml.call("artifacts/operations/benchmark/numeric-threshold-policy.yaml")
blockers << "numeric threshold policy is not armed and approved" unless policy["armed"] == true && policy["approval_state"] == "approved"
if policy["armed"] == true && policy["approval_state"] == "approved"
  approval = policy.dig("approval_requirements", "approval_record").to_s
  blockers << "numeric threshold approval record missing" if approval.empty? || !File.file?(File.join(root, approval))
end
if mode == "repository"
  %w[go.mod pyproject.toml package.json].each do |name|
    blockers << "application dependency manifest missing: #{name}" unless Dir.glob(File.join(root, "{apps,services,engines}/**/#{name}")).any?
  end
end

if blockers.empty?
  puts "#{mode} readiness gate passed"
else
  warn "#{mode} readiness gate blocked (#{blockers.length} blockers):"
  blockers.uniq.each { |blocker| warn "- #{blocker}" }
  exit 3
end
