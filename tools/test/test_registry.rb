#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.join(__dir__, "..", "lib")
require "lenbands"
require "lenbands/reporter"
require "lenbands/registries"

reporter = Lenbands::Reporter.new("registry tests")

entries = Lenbands::Registries::CapabilityRegistry.entries
reporter << "family map is empty" if entries.empty?
reporter << "total capabilities < 100 (unexpected: #{entries.length})" if entries.length < 100
reporter << "capability entries collection is mutable" unless entries.frozen?
reporter << "capability entry is mutable" unless entries.first&.frozen?

active = Lenbands::Registries::CapabilityRegistry.active
expected_active = entries.count { |e| e["lifecycle"] == "ACTIVE" }
reporter << "active count mismatch: #{active.length} vs #{expected_active}" unless active.length == expected_active

family_ids = Lenbands::Registries::FamilyRegistry.ids
reporter << "family ID collection is mutable" unless family_ids.frozen?
entries.each do |entry|
  fid = entry["family_id"]
  reporter << "capability #{entry["capability_id"]} references missing family #{fid}" unless family_ids.include?(fid)
end
reporter << "family registry is empty" if family_ids.empty?

map_ids = Lenbands::Registries::CapabilityRegistry.ids
map_ids.each do |id|
  reporter << "duplicate capability ID in map: #{id}" if entries.count { |e| e["capability_id"] == id } > 1
end

active.select { |e| e["owner_spec"] && e["owner_spec"] != "null" }.each do |entry|
  path = File.join(Lenbands::ROOT, entry["owner_spec"])
  reporter << "ACTIVE #{entry["capability_id"]} owner spec missing: #{entry["owner_spec"]}" unless File.file?(path)
end

reporter << "CapabilityRegistry.count returns wrong value" unless Lenbands::Registries::CapabilityRegistry.count == entries.length
reporter << "CapabilityRegistry.find returns nil for known ID" unless Lenbands::Registries::CapabilityRegistry.find(entries.first["capability_id"])
reporter << "CapabilityRegistry.family_for returns nil for known ID" unless Lenbands::Registries::CapabilityRegistry.family_for(entries.first["capability_id"])
reporter << "CapabilityRegistry.family_for returns non-nil for nonexistent ID" if Lenbands::Registries::CapabilityRegistry.family_for("NONEXISTENT.Capability")

manifest = Lenbands::Registries::ManifestRegistry.p0_families
reporter << "manifest P0 families empty" if manifest.empty?
reporter << "manifest P0 family collection is mutable" unless manifest.frozen?
reporter << "manifest P0 family entry is mutable" unless manifest.first&.frozen?
p0_ids = Lenbands::Registries::ManifestRegistry.p0_ids
expected = (1..6).map { |n| format("P0-%02d", n) }
reporter << "manifest P0 IDs mismatch: #{p0_ids.sort} vs #{expected}" unless p0_ids.sort == expected

reporter.pass!("PASS: registry tests (#{entries.length} capabilities, #{active.length} active, #{family_ids.length} families)")
