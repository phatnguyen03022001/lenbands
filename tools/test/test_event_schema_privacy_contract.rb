#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.join(__dir__, "..", "lib")
require "lenbands"
require "lenbands/event_schema_privacy_contract"
require "lenbands/reporter"

path = File.join(Lenbands::ROOT, "artifacts/engineering/contracts/events/event-schema-pack.md")
canonical = File.read(path)
validate = ->(text) { Lenbands::EventSchemaPrivacyContract.validate(text) }
reporter = Lenbands::Reporter.new("event schema privacy mutation tests")

reporter << "canonical event schema privacy contract rejected" unless validate.call(canonical).empty?

FORBIDDEN_MUTATIONS = {
  "essay_text" => "writing_submission_accepted",
  "essay" => "writing_draft_saved",
  "audio_data" => "session_completed",
  "transcript" => "retest_started",
  "raw_answer" => "retest_started",
  "error_text" => "learning_error_saved",
  "prompt" => "evaluation_submitted",
  "prompt_body" => "evaluation_submitted",
  "provider_payload" => "evaluation_scored",
  "email" => "account_created",
  "learner_content" => "writing_draft_saved"
}.freeze

FORBIDDEN_MUTATIONS.each do |field, event|
  mutated = canonical.sub(/^- `#{event}` .*$/) { |line| "#{line} — {#{field}}" }
  unless validate.call(mutated).any? { |item| item.include?("#{event}: forbidden") && item.include?(field) }
    reporter << "forbidden event payload field #{field} was accepted"
  end
end

%w[prompt_ref task_ref evidence_refs provider_ref].each do |field|
  mutated = canonical.sub(/^- `evaluation_submitted` .*$/) { |line| "#{line} — {#{field}}" }
  reporter << "opaque event reference #{field} was incorrectly rejected" unless validate.call(mutated).empty?
end

reporter.pass!("PASS: event schema privacy mutation tests")
