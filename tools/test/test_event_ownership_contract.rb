#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.join(__dir__, "..", "lib")
require "lenbands"
require "lenbands/yaml_loader"
require "lenbands/event_ownership_contract"
require "lenbands/reporter"

root = Lenbands::ROOT
ownership_data = Lenbands::YamlLoader.load_file(
  File.join(root, "artifacts/engineering/contracts/events/event-ownership-registry.yaml"),
  mapping: true
)
family_data = Lenbands::YamlLoader.load_file(
  File.join(root, "artifacts/operations/capability-family-registry.yaml"),
  mapping: true
)
ownership = ownership_data.fetch("events")
families = family_data.fetch("families")
validate = ->(events, entries) { Lenbands::EventOwnershipContract.family_alignment_errors(ownership: events, families: entries) }
copy = ->(value) { Marshal.load(Marshal.dump(value)) }
reporter = Lenbands::Reporter.new("event ownership mutation tests")

reporter << "canonical event-family alignment rejected" unless validate.call(ownership, families).empty?

missing_shared_event = copy.call(families)
study = missing_shared_event.find { |family| family["family_id"] == "STUDY.DailyAction" }
study["shared_events"].delete("next_best_action_shown")
unless validate.call(ownership, missing_shared_event).any? { |item| item.include?("next_best_action_shown: absent") }
  reporter << "owned event missing from family shared_events was accepted"
end

unowned_shared_event = copy.call(families)
writing = unowned_shared_event.find { |family| family["family_id"] == "WRITING.Evaluation" }
writing["shared_events"] << "writing_unowned_event"
unless validate.call(ownership, unowned_shared_event).any? { |item| item.include?("contains unowned event writing_unowned_event") }
  reporter << "unowned active-family shared event was accepted"
end

wrong_owner = copy.call(ownership)
wrong_owner["writing_feedback_viewed"]["owner_family"] = "STUDY.DailyAction"
unless validate.call(wrong_owner, families).any? { |item| item.include?("owned by STUDY.DailyAction") }
  reporter << "shared event with a conflicting owner family was accepted"
end

reporter.pass!("PASS: event ownership mutation tests")
