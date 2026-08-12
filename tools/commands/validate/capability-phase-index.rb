#!/usr/bin/env ruby
# frozen_string_literal: true

require "set"

root = File.expand_path("../../..", __dir__)
features_path = File.join(root, "blueprint/03-features.md")
index_path = File.join(root, "artifacts/operations/catalogs/capability-phase-index.md")
errors = []

features = File.read(features_path)
canonical_ids = features.scan(/`([A-Z][A-Z0-9_]*\.[A-Za-z][A-Za-z0-9_]*)`/).flatten.to_set
rows = File.readlines(index_path).map do |line|
  match = line.match(/^\| `([A-Z][A-Z0-9_]*\.[A-Za-z][A-Za-z0-9_]*)` \| ([^|]+) \| ([^|]+) \|$/)
  match && { "id" => match[1], "phase" => match[2].strip, "interpretation" => match[3].strip }
end.compact

errors << "phase index has no capability rows" if rows.empty?
ids = rows.map { |row| row["id"] }
errors << "phase index has duplicate capability IDs" unless ids.uniq.length == ids.length
errors << "phase index IDs differ from blueprint capability IDs" unless ids.to_set == canonical_ids

allowed_phases = %w[P0 P1 P2 deferred]
rows.each do |row|
  errors << "#{row["id"]}: invalid phase #{row["phase"]}" unless allowed_phases.include?(row["phase"])
  errors << "#{row["id"]}: empty interpretation" if row["interpretation"].empty?
end

anti_gaming = rows.find { |row| row["id"] == "EVAL.AntiGaming" }
unless anti_gaming && anti_gaming["phase"] == "deferred" && anti_gaming["interpretation"].include?("deprecated alias")
  errors << "EVAL.AntiGaming must remain the deferred deprecated alias"
end

# P0 is an explicit closed-pilot decision, not an inference from a capability name.
p0_profile_ids = features.each_line.map do |line|
  next unless line.start_with?("| `P0-0") || line.start_with?("| P0-0")
  line.scan(/`([A-Z][A-Z0-9_]*\.[A-Za-z][A-Za-z0-9_]*)`/).flatten
end.compact.flatten.to_set
indexed_p0_ids = rows.select { |row| row["phase"] == "P0" }.map { |row| row["id"] }.to_set
errors << "P0 phase IDs differ from Blueprint P0 profile matrix" unless indexed_p0_ids == p0_profile_ids

if errors.empty?
  puts "capability phase index validation passed (#{rows.length} capabilities, P0=#{indexed_p0_ids.length})"
else
  warn errors.join("\n")
  warn "capability phase index validation failed: #{errors.length} issue(s)"
  exit 1
end
