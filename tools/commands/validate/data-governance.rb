#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "set"
require "date"

root = File.expand_path("../../..", __dir__)
errors = []
load_yaml = lambda do |relative|
  begin
    data = YAML.safe_load(File.read(File.join(root, relative)), permitted_classes: [Date], aliases: false)
    data.is_a?(Hash) ? data : {}
  rescue StandardError => e
    errors << "#{relative}: #{e.message}"
    {}
  end
end

registry = load_yaml.call("artifacts/operations/data-retention-registry.yaml")
bops = load_yaml.call("artifacts/operations/bops/contract.yaml")
type_system = load_yaml.call("artifacts/engineering/api/type-system.yaml")
entities = registry["entities"]
unless entities.is_a?(Hash) && !entities.empty?
  errors << "data retention registry entities must be a non-empty mapping"
  entities = {}
end
allowed_classes = Set.new(%w[C1_account C2_learning C3_assessment C4_security C5_derived])
entities.each do |name, entity|
  unless entity.is_a?(Hash)
    errors << "#{name}: retention entry must be a mapping"
    next
  end
  %w[data_class owner purpose retention export deletion].each do |field|
    errors << "#{name}: missing #{field}" if entity[field].to_s.empty?
  end
  errors << "#{name}: unknown data class #{entity['data_class'].inspect}" unless allowed_classes.include?(entity["data_class"])
  errors << "#{name}: numeric retention must not be activated before review" if entity["retention"].is_a?(Numeric)
end

forbidden = Array(registry["forbidden_general_telemetry_fields"]).to_set
%w[essay audio transcript raw_answer prompt provider_payload access_token authorization_header email display_name].each do |field|
  errors << "telemetry deny set missing #{field}" unless forbidden.include?(field)
end

privacy = bops["privacy_retention"] || bops.dig("controls", "privacy_retention") || {}
if privacy.is_a?(Hash) && privacy.key?("registry_required")
  errors << "BOPS requires retention registry but registry is not source_of_truth" unless registry["source_of_truth"] == true
end

config_alias = type_system.dig("aliases", "governed_config_map")
errors << "governed_config_map type missing" unless config_alias.is_a?(Hash)
pattern = config_alias&.dig("propertyNames", "not", "pattern").to_s
%w[secret token password credential key].each do |word|
  errors << "admin config secret-key deny pattern misses #{word}" unless pattern.downcase.include?(word)
end
errors << "admin config map must not allow arbitrary object values" if config_alias&.dig("additionalProperties") == true

if errors.empty?
  puts "data governance validation passed (entities=#{entities.length}, telemetry_deny=#{forbidden.length}, admin_config_secret_keys=blocked)"
else
  warn errors.join("\n")
  warn "data governance validation failed: #{errors.length} issue(s)"
  exit 1
end
