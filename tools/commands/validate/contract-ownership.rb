#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "set"
require "date"

root = File.expand_path("../../..", __dir__)
$LOAD_PATH.unshift File.join(root, "tools/lib")
require "lenbands"
require "lenbands/criterion_mapping_contract"
require "lenbands/event_ownership_contract"

errors = []
load_yaml = lambda do |relative_path|
  path = File.join(root, relative_path)
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

manifest = load_yaml.call("artifacts/operations/capability-manifest.yaml")
packs = required_array.call(manifest, "capability_families", "capability manifest")
pack_by_id = packs.to_h { |pack| [pack["family_id"], pack] }
family_map_data = load_yaml.call("artifacts/operations/capability-family-map.yaml")
family_map = required_array.call(family_map_data, "capability_map", "capability family map")
family_for = family_map.to_h { |entry| [entry["capability_id"], entry["family_id"]] }
family_registry = load_yaml.call("artifacts/operations/capability-family-registry.yaml")
family_entries = required_array.call(family_registry, "families", "capability family registry")
families = family_entries.to_h { |family| [family["family_id"], family] }

packs.each do |pack|
  pack_id = pack["family_id"]
  implementation_family = pack["implementation_family_id"]
  errors << "#{pack_id}: missing implementation_family_id bridge" if implementation_family.to_s.empty?
  errors << "#{pack_id}: unknown implementation family #{implementation_family}" unless families.key?(implementation_family)
  mapped = Array(pack["capability_ids"]).map { |capability| family_for[capability] }.uniq
  errors << "#{pack_id}: capabilities map to #{mapped.inspect}, expected only #{implementation_family}" unless mapped == [implementation_family]
end

ownership_data = load_yaml.call("artifacts/engineering/contracts/events/event-ownership-registry.yaml")
ownership = required_mapping.call(ownership_data, "events", "event ownership registry")
errors.concat(Lenbands::EventOwnershipContract.family_alignment_errors(ownership: ownership, families: family_entries))
published = Hash.new { |hash, key| hash[key] = [] }
packs.each { |pack| Array(pack["events_published"]).each { |event| published[event] << pack["family_id"] } }
published.each { |event, owners| errors << "#{event}: multiple publishing packs #{owners.inspect}" unless owners.length == 1 }
ownership.each do |event, contract|
  unless contract.is_a?(Hash)
    errors << "#{event}: ownership declaration must be a mapping"
    next
  end
  owner_pack = contract["owner_pack"]
  owner_family = contract["owner_family"]
  errors << "#{event}: unknown owner pack #{owner_pack}" unless pack_by_id.key?(owner_pack)
  errors << "#{event}: owner family mismatch" unless pack_by_id.dig(owner_pack, "implementation_family_id") == owner_family
  errors << "#{event}: manifest publisher mismatch #{published[event].inspect}" unless published[event] == [owner_pack]
  errors << "#{event}: allowed_producers empty" if Array(contract["allowed_producers"]).empty?
end
errors << "manifest publishes events absent from ownership registry: #{(published.keys.to_set - ownership.keys.to_set).to_a.sort.join(', ')}" unless published.keys.to_set.subset?(ownership.keys.to_set)
packs.each do |pack|
  Array(pack["events_consumed"]).each { |event| errors << "#{pack["family_id"]}: consumes unowned event #{event}" unless ownership.key?(event) }
  overlap = Array(pack["states"]).to_set & (Array(pack["events_published"]) + Array(pack["events_consumed"])).to_set
  errors << "#{pack["family_id"]}: values classified as both state and event: #{overlap.to_a.sort.join(', ')}" unless overlap.empty?
end

openapi = load_yaml.call("artifacts/engineering/contracts/writing-task-2/openapi.yaml")
canonical_evaluation_contract = File.join(root, "artifacts/engineering/contracts/evaluation/evaluation-contract.md")
error_taxonomy = File.join(root, "blueprint/framework/error-taxonomy.md")
if File.file?(canonical_evaluation_contract) && File.file?(error_taxonomy)
  errors.concat(
    Lenbands::CriterionMappingContract.validate(
      canonical_contract: File.read(canonical_evaluation_contract),
      error_taxonomy: File.read(error_taxonomy),
      openapi: openapi
    )
  )
else
  errors << "criterion mapping authority input missing"
end
operations = []
paths = openapi["paths"]
errors << "OpenAPI paths must be a mapping" unless paths.is_a?(Hash)
paths.to_h.each do |path, methods|
  unless methods.is_a?(Hash)
    errors << "OpenAPI path #{path}: methods must be a mapping"
    next
  end
  methods.each do |method, operation|
    next unless %w[get post put patch delete].include?(method)
    unless operation.is_a?(Hash)
      errors << "#{method.upcase} #{path}: operation must be a mapping"
      next
    end
    operations << [operation["operationId"], operation["x-owner-pack"], method.upcase, path]
  end
end
operation_ids = operations.map(&:first)
errors << "OpenAPI operationId missing or duplicated" unless operation_ids.none?(&:nil?) && operation_ids.uniq.length == operation_ids.length
operations.each do |operation_id, owner_pack, method, path|
  errors << "#{method} #{path}: missing/unknown x-owner-pack" unless pack_by_id.key?(owner_pack)
  errors << "#{operation_id}: absent from #{owner_pack}.api_operations" unless Array(pack_by_id.dig(owner_pack, "api_operations")).include?(operation_id)
end
packs.each do |pack|
  expected = operations.select { |operation| operation[1] == pack["family_id"] }.map(&:first).sort
  actual = Array(pack["api_operations"]).sort
  errors << "#{pack["family_id"]}: api_operations drift expected=#{expected.inspect} actual=#{actual.inspect}" unless actual == expected
end

if errors.empty?
  puts "contract ownership validation passed (packs=#{packs.length}, events=#{ownership.length}, operations=#{operations.length})"
else
  warn errors.join("\n")
  warn "contract ownership validation failed: #{errors.length} issue(s)"
  exit 1
end
