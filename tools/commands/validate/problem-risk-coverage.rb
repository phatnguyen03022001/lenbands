#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "set"
require "date"

ROOT = File.expand_path("../../..", __dir__)

load_yaml = lambda do |relative|
  YAML.safe_load(File.read(File.join(ROOT, relative)), permitted_classes: [Date], aliases: false)
rescue StandardError => e
  warn "#{relative}: #{e.message}"
  exit 1
end

registry_path = "artifacts/operations/problem-risk-registry.yaml"
docs = load_yaml.call("DOCS.yaml")
registry = load_yaml.call(registry_path)
eligibility = load_yaml.call("artifacts/operations/implementation-eligibility.yaml")

errors = []

unless docs.dig("authority", "problem_risk_coverage", "path") == registry_path
  errors << "DOCS.yaml must register problem_risk_coverage authority at #{registry_path}"
end

errors << "problem-risk registry root must be a mapping" unless registry.is_a?(Hash)
policy = registry["coverage_policy"] || {}
categories = registry["categories"] || {}
risks = registry["risks"] || []

statuses = Set.new(Array(policy["statuses"]))
severities = Set.new(Array(policy["severities"]))
phases = Set.new(Array(policy["phases"]))
p0_families = Set.new(Array(policy["p0_families"]))
expected_families = Set.new(%w[P0-01 P0-02 P0-03 P0-04 P0-05 P0-06])

errors << "coverage_policy statuses missing" if statuses.empty?
errors << "coverage_policy severities missing" if severities.empty?
errors << "coverage_policy phases missing" if phases.empty?
errors << "P0 family set drift" unless p0_families == expected_families
errors << "categories must be a non-empty mapping" unless categories.is_a?(Hash) && !categories.empty?
errors << "risks must be a non-empty array" unless risks.is_a?(Array) && !risks.empty?

risk_ids = Set.new
coverage = Hash.new { |h, k| h[k] = Set.new }

Array(risks).each_with_index do |risk, index|
  unless risk.is_a?(Hash)
    errors << "risk[#{index}] must be a mapping"
    next
  end

  id = risk["risk_id"].to_s
  category = risk["category"].to_s
  phase = risk["phase"].to_s
  severity = risk["severity"].to_s
  status = risk["status"].to_s
  families = Set.new(Array(risk["affected_families"]))
  contracts = Array(risk["canonical_contracts"])

  errors << "risk[#{index}] risk_id missing" if id.empty?
  errors << "duplicate risk_id #{id}" if !id.empty? && risk_ids.include?(id)
  risk_ids << id unless id.empty?
  errors << "#{id}: unknown category #{category}" unless categories.key?(category)
  errors << "#{id}: unknown phase #{phase}" unless phases.include?(phase)
  errors << "#{id}: unknown severity #{severity}" unless severities.include?(severity)
  errors << "#{id}: unknown status #{status}" unless statuses.include?(status)
  errors << "#{id}: owner missing" if risk["owner"].to_s.empty?
  errors << "#{id}: title missing" if risk["title"].to_s.empty?
  errors << "#{id}: required_control missing" if risk["required_control"].to_s.empty?
  errors << "#{id}: acceptance_test missing" if risk["acceptance_test"].to_s.empty?
  errors << "#{id}: affected_families contains unknown P0 family" unless families.subset?(p0_families)

  families.each { |family| coverage[category] << family }

  contracts.each do |path|
    next if path.to_s.empty?
    errors << "#{id}: canonical contract does not exist: #{path}" unless File.exist?(File.join(ROOT, path))
  end

  if status == "covered" && contracts.empty?
    errors << "#{id}: covered risk requires canonical_contracts"
  end

  p0_high = phase == "P0" && %w[critical high].include?(severity) && !families.empty?
  should_block = p0_high && %w[open partial].include?(status)
  actual_block = risk["implementation_blocking"] == true
  errors << "#{id}: open/partial P0 #{severity} risk must be implementation_blocking" if should_block && !actual_block
  errors << "#{id}: covered risk must not remain implementation_blocking" if status == "covered" && actual_block
  errors << "#{id}: deferred P0 risk is not allowed" if status == "deferred" && phase == "P0" && !families.empty?
end

categories.each do |category, definition|
  applies = Set.new(Array(definition.is_a?(Hash) ? definition["p0_applies_to"] : []))
  errors << "#{category}: p0_applies_to contains unknown family" unless applies.subset?(p0_families)
  missing = applies - coverage[category]
  errors << "#{category}: missing explicit risk coverage for #{missing.to_a.sort.join(', ')}" unless missing.empty?
end

eligibility_requires = Set.new(Array(eligibility.dig("axes", "implementation_eligibility", "requires")))
%w[problem_risk_coverage_assessed no_blocking_problem_risk].each do |requirement|
  errors << "implementation-eligibility must require #{requirement}" unless eligibility_requires.include?(requirement)
end

if errors.empty?
  blocking = Array(risks).count { |risk| risk.is_a?(Hash) && risk["implementation_blocking"] == true }
  puts "problem/risk coverage validation passed (categories=#{categories.length}, risks=#{risks.length}, blocking=#{blocking})"
else
  warn errors.join("\n")
  warn "problem/risk coverage validation failed: #{errors.length} issue(s)"
  exit 1
end
