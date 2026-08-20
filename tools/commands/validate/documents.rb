#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "date"
require "set"

$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)
require "lenbands"
require "lenbands/artifact_lifecycle"
require "lenbands/yaml_loader"

root = File.expand_path("../../..", __dir__)
errors = []
relative = ->(path) { path.delete_prefix(root + "/") }
load_yaml = lambda do |path|
  Lenbands::YamlLoader.load_file(path) || {}
rescue Lenbands::YamlError => e
  errors << "invalid YAML #{relative.call(path)}: #{e.message}"
  {}
end

# YAML.safe_load accepts duplicate mapping keys by keeping the last value. Every document
# YAML file must therefore pass the duplicate-key-aware loader, including sidecars and
# OpenAPI, before metadata/semantic validation can make any readiness claim.
Dir.glob(File.join(root, "{blueprint,artifacts,knowledge-assets}/**/*.{yaml,yml}")).sort.each do |path|
  load_yaml.call(path)
end

allowed_statuses = %w[draft review approved deprecated archived].to_set
required_meta = %w[type status version owner representation derived_from purpose created_at updated_at]
meta_paths = Dir.glob(File.join(root, "artifacts/**/*.meta.yaml")).sort
meta_data = {}

meta_paths.each do |path|
  data = load_yaml.call(path)
  meta_data[path] = data
  label = relative.call(path)
  errors << "invalid status: #{label}" unless allowed_statuses.include?(data["status"])
  required_meta.each { |field| errors << "missing #{field}: #{label}" unless data.key?(field) }
  if data["status"] == "approved"
    %w[reviewed_by reviewed_at].each { |field| errors << "approved artifact missing #{field}: #{label}" unless data.key?(field) }
  end
end

Dir.glob(File.join(root, "artifacts/**/*.md")).sort.each do |path|
  label = relative.call(path)
  next if label.start_with?("artifacts/templates/") || File.basename(path) == "README.md"
  head = File.readlines(path, chomp: true).first(30)
  errors << "embedded lifecycle metadata must use sibling sidecar: #{label}" if Lenbands::ArtifactLifecycle.embedded_metadata?(head)
end

Dir.glob(File.join(root, "artifacts/**/*.{yaml,yml}")).sort.each do |path|
  next if path.end_with?(".meta.yaml", ".meta.yml")
  stem = path.sub(/\.(?:yaml|yml)\z/, "")
  errors << "missing metadata: #{relative.call(path)}" unless File.file?("#{stem}.meta.yaml") || File.file?("#{stem}.meta.yml")
end

features_path = File.join(root, "blueprint/03-features.md")
features = File.read(features_path)
capability_refs = features.scan(/`([A-Z][A-Z0-9_]*\.[A-Za-z][A-Za-z0-9_]*)`/).flatten.to_set
artifact_ids = meta_data.values.map { |data| data["artifact_id"] }.compact.to_set
meta_data.each do |path, data|
  refs = Array(data["derived_from"])
  label = relative.call(path)
  errors << "empty derived_from: #{label}" if refs.empty?
  refs.each do |ref_value|
    ref = ref_value.to_s
    if ref.include?("/") || ref.match?(/\.(?:md|html|ya?ml|json)\z/)
      errors << "path-like derived_from reference #{ref}: #{label}"
    elsif !capability_refs.include?(ref) && !artifact_ids.include?(ref)
      errors << "unknown stable reference #{ref}: #{label}"
    end
  end
end

%w[business experience engineering operations].each do |lens|
  Dir.glob(File.join(root, "artifacts/#{lens}/**/*.md")).sort.each do |path|
    next if File.basename(path) == "README.md"
    meta = path.sub(/\.md\z/, ".meta.yaml")
    errors << "missing metadata: #{relative.call(path)}" unless File.file?(meta)
  end
end

Dir.glob(File.join(root, "artifacts/operations/catalogs/*.md")).sort.each do |path|
  next if File.basename(path) == "README.md"
  body = File.read(path)
  %w[generated_from generated_at schema_version].each do |field|
    errors << "generated catalog missing #{field}: #{relative.call(path)}" unless body.include?("`#{field}`")
  end
end

capability_catalog_path = File.join(root, "artifacts/operations/catalogs/capability-index.md")
if File.file?(capability_catalog_path)
  catalog_ids = File.read(capability_catalog_path).scan(/^\| `([A-Z][A-Z0-9_]*\.[A-Za-z][A-Za-z0-9_]*)` \|/).flatten.to_set
  expected = capability_refs.reject { |id| id == "DOMAIN.Capability" }.to_set
  (expected - catalog_ids).sort.each { |id| errors << "capability index missing #{id}" }
  (catalog_ids - expected).sort.each { |id| errors << "capability index has unknown #{id}" }
end

extract_p0 = lambda do |text|
  text.each_line.map do |line|
    match = line.match(/^\| `?(P0-0[1-6])`?[^|]*\| ([^|]+) \|/)
    next unless match
    [match[1], match[2].scan(/`([A-Z][A-Z0-9_]*\.[A-Za-z][A-Za-z0-9_]*)`/).flatten.sort]
  end.compact.to_h
end
matrix_path = File.join(root, "artifacts/operations/build-readiness-matrix.md")
if File.file?(matrix_path)
  feature_rows = extract_p0.call(features)
  matrix_rows = extract_p0.call(File.read(matrix_path))
  (1..6).each do |number|
    id = format("P0-%02d", number)
    errors << "P0 capability mismatch for #{id}" unless feature_rows[id] == matrix_rows[id]
  end
end

phase_path = File.join(root, "artifacts/operations/catalogs/capability-phase-index.md")
if File.file?(phase_path)
  phase_ids = File.read(phase_path).scan(/^\| `([A-Z][A-Z0-9_]*\.[A-Za-z][A-Za-z0-9_]*)` \|/).flatten.to_set
  errors << "capability phase index missing: #{(capability_refs - phase_ids).to_a.sort.join(', ')}" unless capability_refs.subset?(phase_ids)
  errors << "capability phase index has unknown IDs: #{(phase_ids - capability_refs).to_a.sort.join(', ')}" unless phase_ids.subset?(capability_refs)
end

required_documents = %w[
  blueprint/03-features.md
  blueprint/08-roadmap.md
  artifacts/operations/p0-artifact-pack.md
  artifacts/operations/build-readiness-matrix.md
]
required_documents.each { |path| errors << "missing closed-pilot governance document: #{path}" unless File.file?(File.join(root, path)) }
%w[business experience engineering operations].each do |lens|
  path = "artifacts/#{lens}/README.md"
  errors << "missing artifact lens entry point: #{path}" unless File.file?(File.join(root, path))
end
%w[design specs research legal evidence catalogs decisions].each do |legacy|
  path = "artifacts/#{legacy}"
  errors << "legacy artifact top-level folder remains: #{path}" if File.exist?(File.join(root, path))
end

required_runtime = %w[
  artifacts/engineering/contracts/runtime/async-job-worker-contract.md
  artifacts/engineering/contracts/runtime/cache-contract.md
  artifacts/engineering/contracts/runtime/api-governance-contract.md
  artifacts/engineering/contracts/runtime/outbox-reconciliation-contract.md
  artifacts/engineering/contracts/runtime/observability-slo-contract.md
  artifacts/engineering/contracts/runtime/provider-adapter-contract.md
  artifacts/engineering/contracts/runtime/llm-routing-context-contract.md
  artifacts/engineering/contracts/runtime/failure-taxonomy-contract.md
  artifacts/engineering/contracts/runtime/runtime-baseline-config.yaml
  artifacts/engineering/contracts/writing-task-2/writing_evaluation_v1.md
  artifacts/experience/specs/vertical-slices/identity-consent.md
  artifacts/experience/specs/vertical-slices/placement-and-plan.md
  artifacts/experience/specs/vertical-slices/daily-action.md
  artifacts/engineering/contracts/placement-diagnosis-contract.md
  artifacts/engineering/contracts/daily-action-contract.md
  artifacts/operations/placement-quality-gate.md
  artifacts/operations/catalogs/capability-index.md
]
required_runtime.each { |path| errors << "missing P0 runtime contract: #{path}" unless File.file?(File.join(root, path)) }

(1..6).each do |number|
  pack = format("P0-%02d", number)
  [required_documents[0], required_documents[2], required_documents[3]].each do |path|
    errors << "missing #{pack} coverage: #{path}" unless File.file?(File.join(root, path)) && File.read(File.join(root, path)).include?(pack)
  end
end

{
  "OpenAPI" => "tools/commands/validate/openapi.sh",
  "Framework" => "tools/commands/validate/framework.sh",
  "Semantic contract" => "tools/commands/validate/semantic-contracts.sh"
}.each do |label, command|
  errors << "#{label} validation failed" unless system(File.join(root, command))
end

if errors.empty?
  puts "document validation passed (ruby_parser=true, metadata=#{meta_paths.length})"
else
  warn errors.join("\n")
  warn "document validation failed: #{errors.length} issue(s)"
  exit 1
end
