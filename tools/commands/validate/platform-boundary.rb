#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "set"

root = File.expand_path("../../..", __dir__)
errors = []
load_yaml = lambda do |relative|
  begin
    data = YAML.safe_load(File.read(File.join(root, relative)), aliases: false)
    data.is_a?(Hash) ? data : {}
  rescue StandardError => e
    errors << "#{relative}: #{e.message}"
    {}
  end
end

runtime = load_yaml.call("artifacts/engineering/runtime-contract.yaml")
errors << "runtime contract must be source_of_truth" unless runtime["source_of_truth"] == true
principles = Array(runtime["principles"]).to_set
%w[domain_semantics_are_provider_neutral managed_capabilities_are_preferred_over_custom_infrastructure execution_mechanisms_are_replaceable_adapters_not_product_authority].each do |principle|
  errors << "runtime contract missing #{principle}" unless principles.include?(principle)
end
errors << "cache must default disabled" unless runtime.dig("persistence", "cache", "default_state") == "disabled"
mechanisms = Array(runtime["non_authoritative_mechanisms"]).to_set
%w[redis_streams kafka custom_worker_fleet go_api python_request_service custom_workflow_engine].each do |mechanism|
  errors << "runtime contract must explicitly demote #{mechanism}" unless mechanisms.include?(mechanism)
end

adr_path = File.join(root, "artifacts/engineering/decisions/ADR-0004-composition-first-application-platform.md")
adr = File.read(adr_path)
%w[managed composition-first provider-neutral do not build].each do |marker|
  errors << "ADR-0004 missing policy marker #{marker.inspect}" unless adr.downcase.include?(marker)
end
%w[Redis\ Streams Go\ API Python\ worker].each do |marker|
  value = marker.gsub("\\ ", " ")
  errors << "ADR-0004 reintroduces fixed mechanism #{value}" if adr.include?(value)
end

sourcing_path = File.join(root, "artifacts/business/decisions/platform-sourcing.md")
errors << "platform sourcing decision missing" unless File.file?(sourcing_path)
if File.file?(sourcing_path)
  sourcing = File.read(sourcing_path).downcase
  errors << "platform sourcing must preserve buy-first boundary" unless sourcing.include?("buy") && sourcing.include?("provider")
end

# Source-code presence must be backed by a native dependency manifest and lock/checksum,
# but this validator does not prescribe which language or service topology must exist.
source_globs = {
  "JavaScript/TypeScript" => {files: %w[**/*.ts **/*.tsx **/*.js **/*.jsx], manifests: %w[package.json], locks: %w[pnpm-lock.yaml package-lock.json yarn.lock bun.lock bun.lockb]},
  "Python" => {files: %w[**/*.py], manifests: %w[pyproject.toml], locks: %w[uv.lock poetry.lock requirements.lock]},
  "Go" => {files: %w[**/*.go], manifests: %w[go.mod], locks: %w[go.sum]}
}
roots = %w[apps services engines packages]
source_globs.each do |name, spec|
  files = roots.flat_map { |base| spec[:files].flat_map { |glob| Dir.glob(File.join(root, base, glob)) } }
  next if files.empty?
  manifests = roots.flat_map { |base| spec[:manifests].flat_map { |item| Dir.glob(File.join(root, base, "**", item)) } }
  locks = roots.flat_map { |base| spec[:locks].flat_map { |item| Dir.glob(File.join(root, base, "**", item)) } }
  errors << "#{name} source exists without a native manifest" if manifests.empty?
  errors << "#{name} source exists without a committed lock/checksum" if locks.empty?
end

forbidden_roots = %w[runtime-framework workflow-engine job-framework auth-framework orm-framework fsrs-engine]
roots.each do |base|
  forbidden_roots.each do |name|
    path = File.join(root, base, name)
    errors << "forbidden custom commodity framework requires evidence-backed sourcing exception: #{path.delete_prefix(root + '/')}" if Dir.exist?(path)
  end
end

if errors.empty?
  puts "platform boundary validation passed (managed-first, provider-neutral, no fixed runtime topology)"
else
  warn errors.join("\n")
  warn "platform boundary validation failed: #{errors.length} issue(s)"
  exit 1
end
