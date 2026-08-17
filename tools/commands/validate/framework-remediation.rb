#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "set"

root = File.expand_path("../../..", __dir__)
framework = File.join(root, "blueprint/framework")
errors = []

taxonomy = File.read(File.join(framework, "error-taxonomy.md"))
review = File.read(File.join(framework, "review-mapping.md"))
registry = YAML.safe_load(File.read(File.join(root, "artifacts/operations/review-remediation-dispositions.yaml")), aliases: false) || {}

error_ids = taxonomy.scan(/^\| `([LRSWX]_[a-z0-9_]+)` \|/).flatten.to_set
mapped_ids = review.scan(/^\| `([LRSWX]_[a-z0-9_]+)` \|/).flatten.to_set
explicit = (registry["unmapped_dispositions"] || {}).keys.to_set
unknown_registry = explicit - error_ids
errors << "review disposition registry contains unknown error IDs: #{unknown_registry.to_a.sort.join(', ')}" unless unknown_registry.empty?
overlap = explicit & mapped_ids
errors << "review disposition registry duplicates mapped IDs: #{overlap.to_a.sort.join(', ')}" unless overlap.empty?
missing = error_ids - mapped_ids - explicit
errors << "controlled error IDs lack remediation disposition: #{missing.to_a.sort.join(', ')}" unless missing.empty?

registry.fetch("unmapped_dispositions", {}).each do |id, disposition|
  unless disposition.is_a?(Hash)
    errors << "#{id}: remediation disposition must be a mapping"
    next
  end
  errors << "#{id}: action missing" if disposition["action"].to_s.empty?
  if disposition["action"] == "none"
    errors << "#{id}: no-action disposition must disable new generation" unless disposition["new_generation"] == false
    errors << "#{id}: no-action disposition must explain reason" if disposition["reason"].to_s.empty?
  else
    errors << "#{id}: active remediation must declare card_kind" if disposition["card_kind"].to_s.empty?
  end
end

if taxonomy.include?("unknown_microskill")
  resolutions = registry["microskill_resolution"] || {}
  taxonomy.scan(/^\| `([LRSWX]_[a-z0-9_]+)` .*`unknown_microskill`/).flatten.each do |id|
    resolution = resolutions[id]
    errors << "#{id}: unknown_microskill lacks explicit reviewed resolution" unless resolution.is_a?(Hash) && resolution["state"] == "reviewed_no_specific_microskill_required"
  end
end

if errors.empty?
  puts "framework remediation validation passed (errors=#{error_ids.length}, mapped=#{mapped_ids.length}, explicit=#{explicit.length})"
else
  warn errors.join("\n")
  warn "framework remediation validation failed: #{errors.length} issue(s)"
  exit 1
end
