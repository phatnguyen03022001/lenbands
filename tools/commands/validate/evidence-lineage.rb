#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "digest"
require "set"

root = File.expand_path("../../..", __dir__)
snapshots = Dir.glob(File.join(root, "artifacts/operations/evidence/spawn-validation-snapshot-*.yaml")).sort
errors = []

if snapshots.empty?
  errors << "no machine-readable spawn validation snapshot exists"
else
  latest_path = snapshots.last
  snapshot = YAML.safe_load(File.read(latest_path), aliases: false)
  current_framework = File.read(File.join(root, "blueprint/framework/README.md"))[/framework_version:\s*(\d+\.\d+\.\d+)/, 1]
  errors << "latest snapshot schema_version must be 1.0.0" unless snapshot["schema_version"] == "1.0.0"
  errors << "latest snapshot must be static_validation_snapshot" unless snapshot["record_type"] == "static_validation_snapshot"
  errors << "latest snapshot framework version differs from #{current_framework}" unless snapshot["framework_version"].to_s == current_framework.to_s
  source_record = snapshot["source_record"].to_s
  errors << "latest snapshot source_record missing" unless File.file?(File.join(root, source_record))
  required_non_claims = %w[rights content_approval calibration benchmark_quality runtime_acceptance founder_approval publish_eligibility].to_set
  errors << "latest snapshot overstates evidence boundary" unless required_non_claims.subset?(Array(snapshot["does_not_prove"]).to_set)

  snapshot_assets = Array(snapshot["assets"])
  snapshot_by_id = snapshot_assets.to_h { |asset| [asset["asset_id"], asset] }
  errors << "latest snapshot has duplicate asset IDs" unless snapshot_by_id.length == snapshot_assets.length

  generated_meta = Dir.glob(File.join(root, "knowledge-assets/**/*.meta.yaml")).sort.map do |meta_path|
    data = YAML.safe_load(File.read(meta_path), aliases: false)
    next unless data.dig("origin", "source") == "generated"
    [data["asset_id"], meta_path, data]
  end.compact
  generated_ids = generated_meta.map(&:first).to_set
  errors << "latest snapshot asset set differs from generated assets" unless snapshot_by_id.keys.to_set == generated_ids

  generated_meta.each do |asset_id, meta_path, data|
    label = meta_path.delete_prefix(root + "/")
    record = snapshot_by_id[asset_id]
    next unless record
    payload = File.join(File.dirname(meta_path), data.dig("integrity", "payload_file").to_s)
    relative = payload.delete_prefix(root + "/")
    actual_checksum = File.file?(payload) ? "sha256:#{Digest::SHA256.file(payload).hexdigest}" : nil
    errors << "#{asset_id}: snapshot payload mismatch" unless record["payload"] == relative
    errors << "#{asset_id}: snapshot version mismatch" unless record["version"].to_s == data["version"].to_s
    errors << "#{asset_id}: snapshot checksum differs from sidecar" unless record["checksum"] == data.dig("integrity", "checksum")
    errors << "#{asset_id}: payload checksum differs from snapshot" unless record["checksum"] == actual_checksum
    normalized = ->(refs) do
      Array(refs).map do |ref|
        [ref["file"], ref["version"].to_s, Array(ref["nodes"]).map(&:to_s).sort]
      end.sort
    end
    errors << "#{asset_id}: snapshot framework refs mismatch" unless normalized.call(record["framework_refs"]) == normalized.call(data["framework_refs"])
    errors << "#{label}: current framework ref is stale" unless Array(data["framework_refs"]).all? { |ref| ref["version"].to_s == current_framework.to_s }
  end

  reconciliation = snapshot["reconciliation"] || {}
  errors << "latest snapshot must preserve historical records" unless reconciliation["preserves_historical_records"] == true
  revised = Array(reconciliation["revised_assets"])
  revised_ids = revised.map { |item| item["asset_id"] }.to_set
  expected_revised = %w[KA-000013 KA-000014 KA-000015 KA-000016].to_set
  errors << "historical revision reconciliation set mismatch" unless revised_ids == expected_revised
  revised.each do |item|
    errors << "#{item["asset_id"]}: reconciliation must bump 0.1.0 to 0.1.1" unless item["from_version"] == "0.1.0" && item["to_version"] == "0.1.1"
  end
end

if errors.empty?
  puts "evidence lineage validation passed (latest=#{File.basename(snapshots.last)}, structured=true)"
else
  warn errors.join("\n")
  warn "evidence lineage validation failed: #{errors.length} issue(s)"
  exit 1
end
