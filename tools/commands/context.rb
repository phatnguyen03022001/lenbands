#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "date"

root = File.expand_path("../..", __dir__)
format = ARGV.empty? ? "text" : ARGV.shift
abort "usage: tools/bin/lenbands context [--yaml]" unless ARGV.empty? && %w[text --yaml].include?(format)

load_yaml = lambda do |relative_path|
  path = File.join(root, relative_path)
  raise "required context file missing: #{relative_path}" unless File.file?(path)
  data = YAML.safe_load(File.read(path), permitted_classes: [Date], aliases: false)
  raise "context YAML root must be a mapping: #{relative_path}" unless data.is_a?(Hash)
  data
rescue Psych::Exception, SystemCallError => e
  raise "cannot read context source #{relative_path}: #{e.message}"
end

begin
  docs = load_yaml.call("DOCS.yaml")
  manifest = load_yaml.call("artifacts/operations/capability-manifest.yaml")
  domain = load_yaml.call("artifacts/operations/domain-automation-contract.yaml")
  trust = load_yaml.call("artifacts/operations/agent-trust-policy.yaml")
  framework_path = docs.dig("authority", "ielts_framework", "path").to_s
  raise "DOCS.yaml missing ielts_framework authority" if framework_path.empty?
  framework_body = File.read(File.join(root, framework_path))
  framework = framework_body[/framework_version:\s*(\d+\.\d+\.\d+)/, 1]
  raise "framework_version missing from #{framework_path}" if framework.nil?
  packs = Array(manifest["capability_families"])
  domains = domain.fetch("domains")
  canonical = docs.fetch("authority").transform_values { |entry| entry.is_a?(Hash) ? entry["path"] : nil }.compact

  context = {
    "project" => "LenBands IELTS application",
    "framework_version" => framework,
    "authority_registry" => "DOCS.yaml",
    "reading_order" => ["DOCS.yaml", "task_specific_authority_from_DOCS", "referenced_contracts_only"],
    "canonical_authorities" => canonical,
    "hard_rules" => [
      "resolve authority through DOCS.yaml before README/index/search results",
      "historical/transitional aliases never override canonical owners",
      "controlled vocabulary or explicit unresolved disposition; never invent domain IDs",
      "no learner raw assessment content in analytics/general logs",
      "no readiness, calibration, approval or evidence claim without bound evidence",
      "runtime mechanism is not product semantics; buy commodity capabilities by default"
    ],
    "p0" => packs.map { |pack| {"pack_id" => pack["family_id"], "family_id" => pack["implementation_family_id"], "readiness" => pack["readiness_state"], "blockers" => Array(pack["readiness_blockers"])} },
    "domain_automation" => domains.transform_values { |value| {"coverage_state" => value["coverage_state"], "gaps" => value["gaps"]} },
    "protected_paths" => trust["protected_paths"],
    "required_before_handoff" => [
      "tools/bin/lenbands doctor",
      "tools/bin/lenbands verify",
      "tools/bin/lenbands gate toolchain",
      "tools/bin/lenbands gate p0 (exit 3 is expected until genuine evidence exists)"
    ]
  }

  if format == "--yaml"
    puts context.to_yaml
  else
    puts "LenBands agent context (framework #{framework})"
    puts "Authority registry: DOCS.yaml"
    puts "P0: #{packs.map { |pack| "#{pack["family_id"]}=#{pack["readiness_state"]}" }.join(' ')}"
    puts "Domain automation: #{domains.map { |name, value| "#{name}=#{value["coverage_state"]}" }.join(' ')}"
    puts "Hard rules:"
    context["hard_rules"].each { |rule| puts "- #{rule}" }
    puts "Read in order:"
    context["reading_order"].each { |path| puts "- #{path}" }
    puts "Before handoff:"
    context["required_before_handoff"].each { |command| puts "- #{command}" }
  end
rescue StandardError => e
  warn "agent context unavailable: #{e.message}"
  exit 2
end
