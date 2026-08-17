#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "set"

root = File.expand_path("../../..", __dir__)
errors = []
failure_path = File.join(root, "artifacts/engineering/contracts/runtime/failure-taxonomy-contract.md")
type_path = File.join(root, "artifacts/engineering/api/type-system.yaml")
failure = File.read(failure_path)
types = YAML.safe_load(File.read(type_path), aliases: false) || {}

public_codes = failure.scan(/^\| `([A-Z][A-Z0-9_]+)` \| `(?:[A-Z][A-Z0-9_]+`(?:, `?[A-Z][A-Z0-9_]+`?)*) \|/).flatten.to_set
# The table parser above is intentionally conservative. Fall back to the public
# projection section only so internal failure codes cannot accidentally enter API enums.
projection = failure.split("## Public projection", 2)[1].to_s.split("## Evidence gap", 2)[0].to_s
public_codes = projection.scan(/^\| `([A-Z][A-Z0-9_]+)` \|/).flatten.to_set
api_codes = Array(types.dig("transport_policy", "public_failure_codes")).to_set

errors << "public failure taxonomy is empty" if public_codes.empty?
missing = public_codes - api_codes
extra = api_codes - public_codes
errors << "API public failure codes missing taxonomy values: #{missing.to_a.sort.join(', ')}" unless missing.empty?
errors << "API public failure codes contain values absent from taxonomy: #{extra.to_a.sort.join(', ')}" unless extra.empty?

if errors.empty?
  puts "failure registry validation passed (public_codes=#{public_codes.length}, api_projection=exact)"
else
  warn errors.join("\n")
  warn "failure registry validation failed: #{errors.length} issue(s)"
  exit 1
end
