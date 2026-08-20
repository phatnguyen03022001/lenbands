#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$repo_root"

ruby -Itools/lib -rlenbands -rlenbands/yaml_loader -rlenbands/event_schema_privacy_contract -rset <<'RUBY'
root = Dir.pwd
errors = []

read = ->(path) { File.read(File.join(root, path)) }

# Failure codes used by slice contracts must come from the runtime registry.
registry = read.call("artifacts/engineering/contracts/runtime/failure-taxonomy-contract.md")
  .scan(/^\| `([A-Z][A-Z0-9_]*)` \|/).flatten.to_set
writing_failure = read.call("artifacts/engineering/contracts/writing-task-2/failure-contract.md")
  .lines.select { |line| line.match?(/^\| `([A-Z][A-Z0-9_]*)` \|/) }
  .map { |line| line.match(/^\| `([A-Z][A-Z0-9_]*)` \|/)[1] }
writing_failure.each do |code|
  errors << "writing failure code is not in runtime registry: #{code}" unless registry.include?(code)
end

# Canonical outcome events and extensions must be present in the event schema pack.
event_pack = read.call("artifacts/engineering/contracts/events/event-schema-pack.md")
errors.concat(Lenbands::EventSchemaPrivacyContract.validate(event_pack))
blueprint_events = read.call("blueprint/03-features.md")
canonical_events = %w[
  account_created consent_recorded placement_started placement_completed goal_set
  daily_plan_generated session_started session_completed first_meaningful_session_completed
  writing_task_opened writing_draft_saved writing_submission_accepted evaluation_submitted
  evaluation_scored evaluation_failed evaluation_delayed writing_feedback_viewed
  learning_error_saved practice_started retest_completed review_completed quota_warning_shown
  quota_exceeded
]
canonical_events.each do |event|
  errors << "canonical event missing from Blueprint: #{event}" unless blueprint_events.include?("`#{event}`")
  errors << "canonical event missing from event schema pack: #{event}" unless event_pack.include?("`#{event}`")
end
%w[retest_started review_completed upgrade_cta_shown upgrade_completed].each do |event|
  errors << "event extension missing from event schema pack: #{event}" unless event_pack.include?("`#{event}`")
end
errors << "review_completed producer contract missing" unless read.call("artifacts/engineering/contracts/error-to-review/event-contract.md").include?("### `review_completed`")
quota_contract = read.call("artifacts/engineering/contracts/quota-usage/quota-usage-contract.md")
%w[quota_warning_shown quota_exceeded].each do |event|
  errors << "quota event producer contract missing: #{event}" unless quota_contract.include?("`#{event}`")
end

# The aggregate can have no evaluation; an Evaluation resource cannot.
conventions = read.call("blueprint/07-conventions.md")
unless conventions.include?("aggregate may be `none`") && conventions.include?("persisted `Evaluation` entity")
  errors << "evaluation_state lifecycle/entity scope is not explicit"
end

# Cost boundary identifiers used by P0 profiles must be declared in operations policy.
cost_budget = read.call("artifacts/operations/cost-budget.md")
%w[managed_auth_pilot placement_pilot rules_first writing_eval_pilot deterministic_fsrs quality_release_gate].each do |bucket|
  errors << "unknown cost boundary ID: #{bucket}" unless cost_budget.include?("`#{bucket}`")
end

# Knowledge Asset payloads retain their existing payload boundary until the asset reset is executed.
# This validates syntax only; a payload band_range is not TargetProfile/attainment truth.
Dir.glob(File.join(root, "knowledge-assets", "**", "*.md")).each do |path|
  text = File.read(path)
  match = text.match(/\A---\s*\n(.*?)\n---\s*(?:\n|\z)/m)
  next unless match
  begin
    data = YAML.safe_load(match[1], aliases: false) || {}
    next unless data.key?("band_range")
    value = data["band_range"]
    unless value.is_a?(String) && value.match?(/\A\d+\.\d-\d+\.\d\z/)
      errors << "#{path.delete_prefix("#{root}/")}: band_range must be N.N-N.N string"
    end
  rescue Psych::Exception => e
    errors << "#{path.delete_prefix("#{root}/")}: invalid YAML (#{e.message})"
  end
end

# Content authoring may not invent an IELTS target-band range as routing truth.
authoring_contract = read.call("artifacts/engineering/contracts/content-publish/data-contract.md")
errors << "content authoring contract must not restore target_band_range heuristic" if authoring_contract.include?("target_band_range:")
errors << "content authoring contract must expose learning-stage routing boundary" unless authoring_contract.include?("learning_stage:")
errors << "content authoring contract must expose calibration status" unless authoring_contract.include?("calibration_status:")
errors << "content authoring contract must reference canonical API" unless authoring_contract.include?("artifacts/engineering/api/openapi.yaml") && authoring_contract.include?("artifacts/engineering/api/schema-contract.yaml")

# Generated YAML projections must declare generation state in both payload and sidecar.
%w[dependency-graph learning-outcome-index].each do |name|
  payload = Lenbands::YamlLoader.load_file(File.join(root, "artifacts/operations/catalogs", "#{name}.yaml"), mapping: true)
  meta = Lenbands::YamlLoader.load_file(File.join(root, "artifacts/operations/catalogs", "#{name}.meta.yaml"), mapping: true)
  %w[generated_from generated_at schema_version generation_state].each do |field|
    errors << "#{name}.yaml missing #{field}" unless payload.key?(field)
    errors << "#{name}.meta.yaml missing #{field}" unless meta.key?(field)
  end
  errors << "#{name} sample projection must not claim generated" unless payload["generation_state"] == "sample_not_generated"
end

# P0 capability manifest is the typed seed for compiler/build context.
manifest_path = File.join(root, "artifacts/operations/capability-manifest.yaml")
if File.file?(manifest_path)
  manifest = Lenbands::YamlLoader.load_file(manifest_path, mapping: true)
  errors << "capability manifest must be a projection seed, not source_of_truth" unless manifest["source_of_truth"] == false
  acceptance_manifest_path = File.join(root, "artifacts/operations/acceptance/p0-acceptance-manifest.yaml")
  acceptance_manifest = Lenbands::YamlLoader.load_file(acceptance_manifest_path, mapping: true) if File.file?(acceptance_manifest_path)
  acceptance_by_pack = Array(acceptance_manifest && acceptance_manifest["packs"]).to_h { |pack| [pack["pack_id"], pack] }
  corpus = Lenbands::YamlLoader.load_file(File.join(root, "artifacts/operations/benchmark/gold-corpus-manifest.yaml"), mapping: true)
  threshold_policy = Lenbands::YamlLoader.load_file(File.join(root, "artifacts/operations/benchmark/numeric-threshold-policy.yaml"), mapping: true)
  families = manifest.fetch("capability_families", [])
  expected_families = (1..6).map { |n| format("P0-%02d", n) }
  family_ids = families.map { |family| family["family_id"] }
  errors << "capability manifest P0 families mismatch: #{family_ids.sort.inspect}" unless family_ids.sort == expected_families

  features = read.call("blueprint/03-features.md")
  capability_ids = features.scan(/`([A-Z][A-Z0-9_]*\.[A-Za-z][A-Za-z0-9_]*)`/).flatten.to_set
  registered_events = features.scan(/`([a-z][a-z0-9_]*[a-z0-9])`/).flatten.to_set
  event_pack_text = read.call("artifacts/engineering/contracts/events/event-schema-pack.md")
  event_pack_events = event_pack_text.scan(/`([a-z][a-z0-9_]*[a-z0-9])`/).flatten.to_set
  cost_budget_text = read.call("artifacts/operations/cost-budget.md")
  readiness_values = %w[not_ready ready blocked]
  privacy_values = %w[account learning assessment audio billing system derived]

  families.each do |family|
    id = family["family_id"]
    %w[family_id capability_ids owner phase user_outcome inputs outputs events_published data_entities metrics cost_boundary privacy_class artifacts_required artifacts_current evidence_required readiness_state readiness_blockers].each do |field|
      errors << "#{id}: missing manifest field #{field}" unless family.key?(field)
    end
    unless family.key?("states") || family.key?("state_axes")
      errors << "#{id}: manifest must declare states or state_axes"
    end
    Array(family["capability_ids"]).each do |capability|
      errors << "#{id}: unknown capability #{capability}" unless capability_ids.include?(capability)
    end
    Array(family["events_published"]).each do |event|
      unless registered_events.include?(event) || event_pack_events.include?(event)
        errors << "#{id}: event is not registered in Blueprint or event schema pack: #{event}"
      end
    end
    Array(family["events_consumed"]).each do |event|
      unless registered_events.include?(event) || event_pack_events.include?(event)
        errors << "#{id}: consumed event is not registered in Blueprint or event schema pack: #{event}"
      end
    end
    Array(family["artifacts_current"]).each do |artifact|
      path = artifact["path"]
      errors << "#{id}: artifact path missing in manifest entry" if path.to_s.empty?
      errors << "#{id}: artifact path does not exist: #{path}" unless path.to_s.empty? || File.file?(File.join(root, path))
      errors << "#{id}: artifact status missing for #{path}" unless artifact["status"].is_a?(String)
    end
    boundary = family["cost_boundary"]
    errors << "#{id}: cost boundary missing from cost-budget.md: #{boundary}" unless boundary && cost_budget_text.include?("`#{boundary}`")
    errors << "#{id}: invalid privacy_class #{family["privacy_class"]}" unless privacy_values.include?(family["privacy_class"])
    errors << "#{id}: invalid readiness_state #{family["readiness_state"]}" unless readiness_values.include?(family["readiness_state"])
    if family["readiness_state"] == "ready" && !Array(family["readiness_blockers"]).empty?
      errors << "#{id}: ready family still has readiness_blockers"
    end
    if family["readiness_state"] == "ready"
      acceptance_pack = acceptance_by_pack[id]
      errors << "#{id}: ready family has no acceptance manifest pack" unless acceptance_pack
      if acceptance_pack
        errors << "#{id}: ready family acceptance status is not passed" unless acceptance_pack["status"] == "passed"
        errors << "#{id}: ready family acceptance evidence_ref is missing" if acceptance_pack["evidence_ref"].to_s.empty?
        if acceptance_pack["evidence_ref"] && !File.file?(File.join(root, acceptance_pack["evidence_ref"].to_s))
          errors << "#{id}: ready family acceptance evidence does not exist: #{acceptance_pack["evidence_ref"]}"
        end
      end
      if %w[P0-04 P0-06].include?(id)
        errors << "#{id}: ready evaluation family has no ready gold corpus" unless corpus["status"] == "ready" && corpus["rights_status"] == "verified" && corpus["label_status"] == "verified"
        errors << "#{id}: ready evaluation family has unarmed threshold policy" unless threshold_policy["armed"] == true && threshold_policy["approval_state"] == "approved"
      end
    end
  end

  p002 = families.find { |family| family["family_id"] == "P0-02" } || {}
  errors << "P0-02 target feasibility vocabulary drift" unless Array(p002["planning_states"]) == %w[insufficient_evidence on_track at_risk current_constraints_insufficient target_met]
  errors << "P0-02 diagnosis cause vocabulary drift" unless Array(p002["diagnosis_causes"]) == %w[english_foundation ielts_technique integrated_performance mixed evidence_needed]
  errors << "P0-02 must include curriculum coverage dependency" unless Array(p002["dependencies"]).include?("curriculum_coverage_projection")

  p003 = families.find { |family| family["family_id"] == "P0-03" } || {}
  policy = p003["deterministic_policy"] || {}
  errors << "P0-03 must expose exactly one primary action" unless policy["primary_action_count"] == 1
  errors << "P0-03 may expose at most one lighter alternative" unless policy["max_lighter_alternatives"] == 1
  errors << "P0-03 must prohibit LLM direct action selection" unless policy["llm_direct_action_selection"] == "prohibited"
  errors << "P0-03 must prohibit unjustified over-band routing" unless policy["unjustified_over_band_routing"] == "prohibited"
  errors << "P0-03 must prohibit automatic target-met progression" unless policy["target_met_auto_progression"] == "prohibited"
  errors << "P0-03 fallback still encodes multi-choice overload" if p003["fallback"].to_s.include?("three")
  errors << "P0-03 must model content gap" unless Array(p003["states"]).include?("content_gap")

  p005 = families.find { |family| family["family_id"] == "P0-05" } || {}
  review_policy = p005["review_policy"] || {}
  errors << "P0-05 must require cause-appropriate intervention" unless review_policy["cause_appropriate_intervention_required"] == true
  errors << "P0-05 must prohibit unjustified over-band routing" unless review_policy["unjustified_over_band_routing"] == "prohibited"

  p006 = families.find { |family| family["family_id"] == "P0-06" } || {}
  %w[curriculum_coverage_acceptance one_action_usability_acceptance no_over_band_acceptance feasibility_claim_review].each do |evidence|
    errors << "P0-06 missing learner-path release evidence #{evidence}" unless Array(p006["evidence_required"]).include?(evidence)
  end
else
  errors << "missing typed P0 capability manifest: artifacts/operations/capability-manifest.yaml"
end

%w[artifacts/operations/ssot-registry.md artifacts/operations/ssot-registry.meta.yaml].each do |path|
  errors << "missing authority-boundary registry: #{path}" unless File.file?(File.join(root, path))
end

compiler_path = File.join(root, "tools/commands/capability/compile.sh")
if File.file?(compiler_path)
  errors << "canonical capability compiler is not executable" unless File.executable?(compiler_path)
  compile_output = `#{compiler_path} EVAL.Writing 2>&1`
  unless $?.success? && compile_output.include?("pack_id: P0-04") && compile_output.include?("family_id: WRITING.Evaluation") && compile_output.include?("benchmark_not_run")
    errors << "compile-capability cannot resolve EVAL.Writing to WRITING.Evaluation with blockers"
  end
else
  errors << "missing canonical compiler context helper"
end

unless system("tools/commands/validate/spawn-prompts.sh")
  errors << "spawn prompt workflow validation failed"
end

unless system("tools/commands/validate/benchmark-contracts.sh")
  errors << "benchmark/acceptance contract validation failed"
end

if errors.empty?
  puts "semantic contract validation passed"
else
  errors.each { |error| warn error }
  warn "semantic contract validation failed: #{errors.length} issue(s)"
  exit 1
end
RUBY
