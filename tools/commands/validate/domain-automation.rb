#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "date"

root = File.expand_path("../../..", __dir__)
$LOAD_PATH.unshift File.join(root, "tools/lib")
require "lenbands"
require "lenbands/domain_automation_contract"

contract = YAML.safe_load(File.read(File.join(root, "artifacts/operations/domain-automation-contract.yaml")), aliases: false)
toolchain = YAML.safe_load(File.read(File.join(root, "tools/toolchain.yaml")), aliases: false)
adr_meta = YAML.safe_load(File.read(File.join(root, "artifacts/engineering/decisions/ADR-0004-composition-first-application-platform.meta.yaml")), permitted_classes: [Date], aliases: false)
commands = Array(toolchain["public_commands"]).map { |item| item["command"] }
errors = Lenbands::DomainAutomationContract.validate(contract: contract, adr_meta: adr_meta, public_commands: commands, root: root)

if errors.empty?
  summary = contract.fetch("domains").map { |name, definition| "#{name}=#{definition["coverage_state"]}" }.join(" ")
  puts "domain automation validation passed (#{summary})"
else
  warn errors.join("\n")
  warn "domain automation validation failed: #{errors.length} issue(s)"
  exit 1
end
