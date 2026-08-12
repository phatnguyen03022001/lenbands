#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.join(__dir__, "..", "lib")
require "yaml"
require "lenbands"
require "lenbands/yaml_loader"
require "lenbands/domain_automation_contract"
require "lenbands/reporter"

root = Lenbands::ROOT
contract = Lenbands::YamlLoader.load_file(File.join(root, "artifacts/operations/domain-automation-contract.yaml"), mapping: true)
adr_meta = Lenbands::YamlLoader.load_file(File.join(root, "artifacts/engineering/decisions/ADR-0004-composition-first-application-platform.meta.yaml"), mapping: true)
toolchain = Lenbands::YamlLoader.load_file(File.join(root, "tools/toolchain.yaml"), mapping: true)
commands = Array(toolchain["public_commands"]).map { |item| item["command"] }
validate = ->(candidate, meta = adr_meta) { Lenbands::DomainAutomationContract.validate(contract: candidate, adr_meta: meta, public_commands: commands, root: root) }
copy = ->(value) { Marshal.load(Marshal.dump(value)) }
reporter = Lenbands::Reporter.new("domain automation mutation tests")

reporter << "canonical domain automation contract rejected" unless validate.call(contract).empty?

missing_gap = copy.call(contract)
missing_gap["domains"]["knowledge"]["gaps"] = []
reporter << "partial domain accepted without disclosed gaps" unless validate.call(missing_gap).any? { |item| item.include?("must disclose gaps") }

unknown_command = copy.call(contract)
unknown_command["domains"]["repository"]["controls"][0]["command"] = "build universal-runtime"
reporter << "unknown control command accepted" unless validate.call(unknown_command).any? { |item| item.include?("unknown public command") }

enforced_gap = copy.call(contract)
enforced_gap["domains"]["repository"]["gaps"] = ["hidden_gap"]
reporter << "enforced domain accepted with a gap" unless validate.call(enforced_gap).any? { |item| item.include?("cannot retain gaps") }

mutated_meta = copy.call(adr_meta)
mutated_meta["policy_invariants"].delete("provider_semantics_neutral")
reporter << "ADR policy drift accepted" unless validate.call(contract, mutated_meta).any? { |item| item.include?("policy_invariants mismatch") }

reporter.pass!("PASS: domain automation mutation tests")
