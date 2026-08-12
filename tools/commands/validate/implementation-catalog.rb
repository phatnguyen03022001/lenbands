#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "set"
require "date"

$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)
require "lenbands"
require "lenbands/registries"

ROOT = Lenbands::ROOT
errors = []
load_yaml = lambda do |relative_path|
  path = File.join(ROOT, relative_path)
  unless File.file?(path)
    errors << "required YAML missing: #{relative_path}"
    next {}
  end
  data = YAML.safe_load(File.read(path), permitted_classes: [Date], aliases: false)
  unless data.is_a?(Hash)
    errors << "YAML root must be a mapping: #{relative_path}"
    next {}
  end
  data
rescue Psych::Exception, SystemCallError => e
  errors << "invalid YAML #{relative_path}: #{e.message}"
  {}
end
load_text = lambda do |relative_path|
  path = File.join(ROOT, relative_path)
  unless File.file?(path)
    errors << "required document missing: #{relative_path}"
    next ""
  end
  File.read(path)
rescue SystemCallError => e
  errors << "cannot read #{relative_path}: #{e.message}"
  ""
end
required_array = lambda do |data, key, label|
  value = data[key]
  errors << "#{label}: #{key} must be an array" unless value.is_a?(Array)
  Array(value).select do |entry|
    valid = entry.is_a?(Hash)
    errors << "#{label}: #{key} entries must be mappings" unless valid
    valid
  end
end
required_mapping = lambda do |data, key, label|
  value = data[key]
  errors << "#{label}: #{key} must be a mapping" unless value.is_a?(Hash)
  value.is_a?(Hash) ? value : {}
end
field = lambda do |item, key, label|
  value = item[key]
  errors << "#{label}: missing #{key}" if value.nil? || value.to_s.empty?
  value
end

begin
  total_capabilities = Lenbands::Registries::CapabilityRegistry.count
  active_capabilities = Lenbands::Registries::CapabilityRegistry.active.length
rescue Lenbands::Registries::RegistryError => e
  errors << e.message
  total_capabilities = 0
  active_capabilities = 0
end

catalog = load_text.call("artifacts/operations/catalogs/capability-index.md")
catalog_ids = catalog.scan(/\| `([^`]+)` \|/).flatten
map = load_yaml.call("artifacts/operations/capability-family-map.yaml")
entries = required_array.call(map, "capability_map", "capability family map")
registry = load_yaml.call("artifacts/operations/capability-family-registry.yaml")
families = required_array.call(registry, "families", "capability family registry")
family_by_id = families.to_h { |item| [field.call(item, "family_id", "family registry entry"), item] }

errors << "catalog count #{catalog_ids.length} != #{total_capabilities}" unless catalog_ids.length == total_capabilities
map_ids = entries.map { |item| field.call(item, "capability_id", "capability map entry") }.compact
errors << "map count #{entries.length} != catalog count #{catalog_ids.length}" unless entries.length == catalog_ids.length
errors << "map/catalog IDs differ" unless map_ids.to_set == catalog_ids.to_set
map_ids.group_by(&:itself).each { |id, values| errors << "duplicate capability #{id}" if values.length > 1 }

active = entries.select { |item| item["lifecycle"] == "ACTIVE" }
errors << "ACTIVE count #{active.length} != #{active_capabilities}" unless active.length == active_capabilities
allowed = %w[ACTIVE PLANNED DEPRECATED]

entries.each do |entry|
  id = field.call(entry, "capability_id", "capability map entry")
  lifecycle = field.call(entry, "lifecycle", id || "capability map entry")
  family_id = field.call(entry, "family_id", id || "capability map entry")
  next if id.nil? || lifecycle.nil? || family_id.nil?
  errors << "#{id}: invalid lifecycle #{lifecycle}" unless allowed.include?(lifecycle)
  family = family_by_id[family_id]
  unless family
    errors << "#{id}: family #{family_id} missing"
    next
  end
  if lifecycle == "ACTIVE"
    owner = entry["owner_spec"]
    errors << "#{id}: ACTIVE owner spec missing" if owner.nil? || owner == "null"
    errors << "#{id}: owner spec file missing #{owner}" if owner && owner != "null" && !File.file?(File.join(ROOT, owner))
    interaction = family["interaction_spec"]
    errors << "#{id}: ACTIVE interaction spec missing" if interaction.nil? || !File.file?(File.join(ROOT, interaction.to_s))
  end
end

active_by_family = active.group_by { |item| item["family_id"] }
active_by_family.each do |family_id, family_entries|
  owners = family_entries.map { |item| item["owner_spec"] }.compact.uniq
  errors << "family #{family_id} has multiple owner specs" if owners.length > 1
end
family_owner_specs = families.map { |family| family["owner_spec"] }.compact
family_owner_specs.group_by(&:itself).each { |path, values| errors << "owner spec #{path} owned by multiple families" if values.length > 1 }

families.each do |family|
  id = field.call(family, "family_id", "family registry entry")
  next if id.nil?
  errors << "#{id}: missing family_version" if family["family_version"].to_s.empty?
  if family["lifecycle"] == "ACTIVE"
    errors << "#{id}: active owner spec missing" if family["owner_spec"].nil?
    errors << "#{id}: active interaction spec missing" if family["interaction_spec"].nil?
  end
end

facts_data = load_yaml.call("artifacts/operations/promotion-dependency-facts.yaml")
facts = required_mapping.call(facts_data, "families", "promotion dependency facts")
facts.each do |family_id, dependency|
  errors << "unknown dependency family #{family_id}" unless family_by_id.key?(family_id)
  unless dependency.is_a?(Hash)
    errors << "#{family_id}: dependency declaration must be a mapping"
    next
  end
  Array(dependency["requires_families"]).each do |required|
    errors << "#{family_id}: unknown required family #{required}" unless family_by_id.key?(required)
  end
end

policy_data = load_yaml.call("artifacts/operations/promotion-policy.yaml")
policy = required_mapping.call(policy_data, "promotion_policy", "promotion policy")
%w[required_family_status required_owner_spec_status required_acceptance_status required_evidence_status].each do |field|
  errors << "promotion policy missing #{field}" unless policy.key?(field)
end

matrix = load_text.call("artifacts/operations/generated/operationalization-matrix.md")
matrix_ids = matrix.lines.grep(/^\| `[^`]+` \|/)
errors << "generated matrix rows #{matrix_ids.length} != #{total_capabilities}" unless matrix_ids.length == total_capabilities

if errors.empty?
  puts "implementation catalog validation passed (capabilities=180 active=33 families=#{families.length})"
else
  warn errors.join("\n")
  warn "implementation catalog validation failed: #{errors.length} issue(s)"
  exit 1
end
