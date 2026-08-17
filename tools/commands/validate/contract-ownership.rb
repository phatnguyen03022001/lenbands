#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "set"
require "date"

root = File.expand_path("../../..", __dir__)
$LOAD_PATH.unshift File.join(root, "tools/lib")
require "lenbands"
require "lenbands/event_ownership_contract"

errors = []
load_yaml = lambda do |relative_path|
  path = File.join(root, relative_path)
  begin
    data = YAML.safe_load(File.read(path), permitted_classes: [Date], aliases: false)
    unless data.is_a?(Hash)
      errors << "#{relative_path}: YAML root must be a mapping"
      next {}
    end
    data
  rescue StandardError => e
    errors << "#{relative_path}: #{e.message}"
    {}
  end
end

# Event ownership remains family-aligned and independent of HTTP ownership.
manifest = load_yaml.call("artifacts/operations/capability-manifest.yaml")
packs = Array(manifest["capability_families"])
pack_by_id = packs.to_h { |pack| [pack["family_id"], pack] }
family_registry = load_yaml.call("artifacts/operations/capability-family-registry.yaml")
family_entries = Array(family_registry["families"])
family_ids = family_entries.map { |family| family["family_id"] }.to_set
family_map = Array(load_yaml.call("artifacts/operations/capability-family-map.yaml")["capability_map"])
family_for = family_map.to_h { |entry| [entry["capability_id"], entry["family_id"]] }

packs.each do |pack|
  implementation_family = pack["implementation_family_id"]
  errors << "#{pack['family_id']}: unknown implementation family #{implementation_family}" unless family_ids.include?(implementation_family)
  mapped = Array(pack["capability_ids"]).map { |capability| family_for[capability] }.uniq
  errors << "#{pack['family_id']}: capability-to-family projection drift #{mapped.inspect}" unless mapped == [implementation_family]
end

event_data = load_yaml.call("artifacts/engineering/contracts/events/event-ownership-registry.yaml")
events = event_data["events"]
unless events.is_a?(Hash)
  errors << "event ownership registry events must be a mapping"
  events = {}
end
errors.concat(Lenbands::EventOwnershipContract.family_alignment_errors(ownership: events, families: family_entries))
published = Hash.new { |hash, key| hash[key] = [] }
packs.each { |pack| Array(pack["events_published"]).each { |event| published[event] << pack["family_id"] } }
published.each { |event, owners| errors << "#{event}: multiple publishing packs #{owners.inspect}" unless owners.length == 1 }
events.each do |event, contract|
  next unless contract.is_a?(Hash)
  owner_pack = contract["owner_pack"]
  owner_family = contract["owner_family"]
  errors << "#{event}: unknown owner pack #{owner_pack}" unless pack_by_id.key?(owner_pack)
  errors << "#{event}: owner family mismatch" unless pack_by_id.dig(owner_pack, "implementation_family_id") == owner_family
  errors << "#{event}: manifest publisher mismatch #{published[event].inspect}" unless published[event] == [owner_pack]
  errors << "#{event}: allowed_producers empty" if Array(contract["allowed_producers"]).empty?
end
unowned_published = published.keys.to_set - events.keys.to_set
errors << "manifest publishes events absent from ownership registry: #{unowned_published.to_a.sort.join(', ')}" unless unowned_published.empty?

# HTTP operation ownership is canonical across the full web API. P0 manifest operation
# lists are projections only and cannot shrink or redefine this universe.
openapi = load_yaml.call("artifacts/engineering/api/openapi.yaml")
ownership = load_yaml.call("artifacts/engineering/api/operation-ownership.yaml")
operation_owners = ownership["operations"]
unless operation_owners.is_a?(Hash)
  errors << "operation ownership operations must be a mapping"
  operation_owners = {}
end
operations = []
Array(openapi["paths"]&.to_a).each do |path, path_item|
  next unless path_item.is_a?(Hash)
  path_item.each do |method, operation|
    next unless %w[get post put patch delete].include?(method) && operation.is_a?(Hash)
    operations << [operation["operationId"], method.upcase, path]
  end
end
ids = operations.map(&:first)
errors << "canonical OpenAPI operationId missing or duplicated" unless ids.none? { |id| id.to_s.empty? } && ids.uniq.length == ids.length
openapi_ids = ids.to_set
owner_ids = operation_owners.keys.to_set
missing = openapi_ids - owner_ids
extra = owner_ids - openapi_ids
errors << "operation ownership missing canonical IDs: #{missing.to_a.sort.join(', ')}" unless missing.empty?
errors << "operation ownership contains unknown IDs: #{extra.to_a.sort.join(', ')}" unless extra.empty?
operation_owners.each do |operation_id, family_id|
  errors << "#{operation_id}: owner family #{family_id.inspect} missing from family registry" unless family_ids.include?(family_id)
end

operations.each do |operation_id, _method, path|
  owner = operation_owners[operation_id]
  if path.start_with?("/v1/colab/")
    errors << "#{operation_id}: Colab operations must be owned by CONTENT.Management" unless owner == "CONTENT.Management"
  end
  if path.start_with?("/v1/webhooks/billing/")
    errors << "#{operation_id}: billing webhook must be owned by SUBSCRIPTION.Usage" unless owner == "SUBSCRIPTION.Usage"
  end
end

if errors.empty?
  puts "contract ownership validation passed (events=#{events.length}, operations=#{operations.length}, operation_universe=canonical)"
else
  warn errors.join("\n")
  warn "contract ownership validation failed: #{errors.length} issue(s)"
  exit 1
end
