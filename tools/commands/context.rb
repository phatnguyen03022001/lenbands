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
  framework_path = File.join(root, "blueprint/framework/README.md")
  raise "required context file missing: blueprint/framework/README.md" unless File.file?(framework_path)
  framework = File.read(framework_path)[/framework_version:\s*(\d+\.\d+\.\d+)/, 1]
  raise "framework_version missing from blueprint/framework/README.md" if framework.nil?
  manifest = load_yaml.call("artifacts/operations/capability-manifest.yaml")
  domain = load_yaml.call("artifacts/operations/domain-automation-contract.yaml")
  trust = load_yaml.call("artifacts/operations/agent-trust-policy.yaml")
  packs = manifest["capability_families"]
  raise "capability_families must be an array" unless packs.is_a?(Array)
  domains = domain["domains"]
  raise "domain automation domains must be a mapping" unless domains.is_a?(Hash)

  context = {
  "project" => "LenBands IELTS application",
  "framework_version" => framework,
  "reading_order" => [
    "README.md",
    "blueprint/README.md",
    "blueprint/01-product.md through blueprint/08-roadmap.md as needed",
    "blueprint/framework/README.md",
    "artifacts/README.md and artifacts/CONVENTION.md",
    "artifacts/operations/architecture-frozen.md before protected changes"
  ],
  "authority" => {
    "product_semantics" => "blueprint/",
    "ielts_semantics" => "blueprint/framework/",
    "business_and_runtime_contracts" => "artifacts/",
    "learner_content" => "knowledge-assets/",
    "tooling" => "projection-validation-evidence-only"
  },
  "hard_rules" => [
    "controlled vocabulary or unknown_*; never invent domain IDs",
    "no learner essay/audio/error text in event or log payloads",
    "no AI label or AI icon in learner UI",
    "no generic runtime/framework reimplementation",
    "no readiness or approval claim without immutable evidence",
    "immutable evidence is append-only"
  ],
  "p0" => packs.map { |pack| {"pack_id" => pack["family_id"], "family_id" => pack["implementation_family_id"], "readiness" => pack["readiness_state"], "blockers" => Array(pack["readiness_blockers"])} },
  "domain_automation" => domains.transform_values { |value| {"coverage_state" => value["coverage_state"], "gaps" => value["gaps"]} },
  "protected_paths" => trust["protected_paths"],
  "required_before_handoff" => [
    "tools/bin/lenbands doctor",
    "tools/bin/lenbands verify",
    "tools/bin/lenbands gate toolchain",
    "tools/bin/lenbands gate p0 (exit 3 is expected until evidence exists)"
  ]
  }

  if format == "--yaml"
    puts context.to_yaml
  else
    puts "LenBands agent context (framework #{framework})"
    puts "Authority: Blueprint/product; Framework/IELTS; Artifacts/contracts; Knowledge Assets/content"
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
