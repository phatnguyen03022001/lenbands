#!/usr/bin/env ruby
# frozen_string_literal: true

# Semantic snapshot test. Captures structural properties of generator outputs
# (counts, IDs, relationships) — NOT byte-level. Safe against timestamp/ordering changes.

$LOAD_PATH.unshift File.join(__dir__, "..", "lib")
require "lenbands"
require "lenbands/reporter"
require "lenbands/registries"

reporter = Lenbands::Reporter.new("semantic snapshot")

# ── Capability Family Map ──────────────────────────────────────────
map_entries = Lenbands::Registries::CapabilityRegistry.entries
reporter << "family map is empty" if map_entries.empty?

total = map_entries.length
active = map_entries.count { |e| e["lifecycle"] == "ACTIVE" }
planned = map_entries.count { |e| e["lifecycle"] == "PLANNED" }
deprecated = map_entries.count { |e| e["lifecycle"] == "DEPRECATED" }

fams = map_entries.map { |e| e["family_id"] }.uniq.sort
active_fams = map_entries.select { |e| e["lifecycle"] == "ACTIVE" }.map { |e| e["family_id"] }.uniq.sort

puts "snapshot: total_capabilities=#{total}"
puts "snapshot: active=#{active} planned=#{planned} deprecated=#{deprecated}"
puts "snapshot: families=#{fams.length} (#{fams.join(', ')})"
puts "snapshot: active_families=#{active_fams.join(', ')}"

# ── Per-family capability count ────────────────────────────────────
by_family = map_entries.group_by { |e| e["family_id"] }.transform_values(&:length)
by_family.sort.each { |fid, count| puts "snapshot: family_count[#{fid}]=#{count}" }

# ── Cross-reference: catalog index vs family map ───────────────────
catalog_path = File.join(Lenbands::ROOT, "artifacts/operations/catalogs/capability-index.md")
catalog_ids = File.read(catalog_path).scan(/\| `([^`]+)` \|/).flatten.to_set
map_ids = map_entries.map { |e| e["capability_id"] }.to_set

only_in_catalog = catalog_ids - map_ids
only_in_map = map_ids - catalog_ids
reporter << "in catalog but not map: #{only_in_catalog.to_a.sort.join(', ')}" unless only_in_catalog.empty?
reporter << "in map but not catalog: #{only_in_map.to_a.sort.join(', ')}" unless only_in_map.empty?

# ── Matrix row count vs capability count ───────────────────────────
matrix_path = File.join(Lenbands::ROOT, "artifacts/operations/generated/operationalization-matrix.md")
matrix_rows = File.read(matrix_path).lines.grep(/^\| `[^`]+` \|/)
reporter << "matrix rows (#{matrix_rows.length}) != capabilities (#{total})" unless matrix_rows.length == total

# ── Family registry integrity ──────────────────────────────────────
registry_fams = Lenbands::Registries::FamilyRegistry.ids.to_set
fams.each do |fid|
  reporter << "family #{fid} in map but not in registry" unless registry_fams.include?(fid)
end

# ── ACTIVE families have required specs ────────────────────────────
active_fams.each do |fid|
  family = Lenbands::Registries::FamilyRegistry.find(fid)
  next unless family
  owner = family["owner_spec"]
  interaction = family["interaction_spec"]
  reporter << "ACTIVE family #{fid}: missing owner_spec" if owner.nil? || owner.to_s.empty?
  reporter << "ACTIVE family #{fid}: missing interaction_spec" if interaction.nil? || interaction.to_s.empty?
  if owner && !owner.to_s.empty?
    owner_path = File.join(Lenbands::ROOT, owner)
    reporter << "ACTIVE family #{fid}: owner_spec file missing: #{owner}" unless File.file?(owner_path)
  end
end

# ── No duplicate capability IDs ────────────────────────────────────
dup_ids = map_entries.group_by { |e| e["capability_id"] }.select { |_, v| v.length > 1 }
dup_ids.each { |id, entries| reporter << "duplicate capability_id #{id} (#{entries.length} entries)" }

reporter.pass!("PASS: semantic snapshot (#{total} capabilities, #{active} active, #{fams.length} families)")
