#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$repo_root"

ruby -ryaml -rset <<'RUBY'
root = Dir.pwd
framework_root = File.join(root, "blueprint", "framework")
files = %w[
  band-descriptor-map
  error-taxonomy
  exam-module-differences
  grammar-band-framework
  microskill-enum
  review-mapping
  skill-questiontype-band
  speaking-parts-framework
  vocab-collocation-topic
  writing-task-framework
]
errors = []
versions = {}

files.each do |name|
  path = File.join(framework_root, "#{name}.md")
  unless File.file?(path)
    errors << "missing framework file #{name}.md"
    next
  end
  text = File.read(path)
  match = text.match(/\A---\s*\n(.*?)\n---\s*(?:\n|\z)/m)
  errors << "#{name}: missing frontmatter" unless match
  next unless match
  begin
    data = YAML.safe_load(match[1], aliases: false) || {}
    version = data["version"]
    errors << "#{name}: invalid version" unless version.is_a?(String) && version.match?(/\A\d+\.\d+\.\d+\z/)
    versions[name] = version
    errors << "#{name}: scope must be framework" unless data["scope"] == "framework"
    errors << "#{name}: missing Versioning section" unless text.include?("## Versioning")
    errors << "#{name}: current release marker does not match frontmatter" unless text.include?("Current release: `#{version}`")
    release_versions = text.scan(/^- `version: (\d+\.\d+\.\d+)`/).flatten
    errors << "#{name}: changelog does not include current release #{version}" unless release_versions.include?(version)
    ordered = release_versions.map { |item| item.split(".").map(&:to_i) }
    errors << "#{name}: changelog versions are not ascending" unless ordered == ordered.sort
    errors << "#{name}: changelog contains duplicate versions" unless release_versions.uniq.length == release_versions.length
  rescue StandardError => e
    errors << "#{name}: invalid frontmatter (#{e.message})"
  end
end

if versions.values.compact.uniq.length != 1
  errors << "framework files do not share one version: #{versions.inspect}"
end
umbrella = File.read(File.join(framework_root, "README.md"))
if versions.values.compact.uniq.length == 1 && !umbrella.include?("framework_version: #{versions.values.compact.uniq.first}")
  errors << "framework README umbrella version diverges from domain files"
end

grammar = File.read(File.join(framework_root, "grammar-band-framework.md"))
grammar_inventory = grammar
grammar_ids = grammar_inventory.scan(/^\| `(g_[a-z0-9_]+)` \| [^|]+ \| \d+\.\d \| \d+\.\d \|/).flatten
errors << "grammar inventory count is #{grammar_ids.uniq.length}, expected 47" unless grammar_ids.uniq.length == 47
errors << "grammar inventory contains duplicate row IDs" unless grammar_ids.length == grammar_ids.uniq.length
errors << "grammar inventory contains invalid identifier" unless grammar_ids.all? { |id| id.match?(/\Ag_[a-z0-9_]+\z/) }
errors << "obsolete spaced grammar identifier remains" if grammar.include?("g_plural nouns")
errors << "grammar inventory must label taxonomy links as error_refs" unless grammar_inventory.include?("| error_refs |")
errors << "grammar inventory still labels error refs as depends_on" if grammar_inventory.match?(/^\| grammar_id .* \| depends_on \|/)
grammar.each_line do |line|
  next unless line.match?(/^\| `g_[a-z0-9_]+` \| [^|]+ \| \d+\.\d \| \d+\.\d \|/)
  columns = line.split("|").map(&:strip)
  error_refs = columns[5].to_s
  errors << "grammar error_refs contains grammar prerequisite: #{line.strip}" if error_refs.match?(/`g_[a-z0-9_]+`/)
end
errors << "grammar summary contains duplicate 6.0 row" if grammar_inventory.scan(/^\| 6\.0 \|/).length > 1

error_taxonomy = File.read(File.join(framework_root, "error-taxonomy.md"))
error_ids = error_taxonomy.scan(/^\| `([LRSW]_[a-z0-9_]+)` \|/).flatten.to_set
microskills = File.read(File.join(framework_root, "microskill-enum.md"))
  .scan(/`([LRWSP]_[a-z0-9_]+)`/).flatten.to_set
criterion_values = %w[TR CC LR GRA FC PR answer-key strategy TR_TASK1 TR_LR].to_set
grammar.each_line do |line|
  next unless line.match?(/^\| `g_[a-z0-9_]+` \| [^|]+ \| \d+\.\d \| \d+\.\d \|/)
  refs = line.scan(/`([LRWSP]_[a-z0-9_]+)`/).flatten
  refs.each do |ref|
    errors << "grammar error_ref is not in error taxonomy: #{ref}" unless error_ids.include?(ref)
  end
end
error_taxonomy.each_line do |line|
  next unless line.match?(/^\| `([LRSW]_[a-z0-9_]+)` \|/)
  columns = line.split("|").map(&:strip)
  criterion = columns[4].to_s
  band_signal = columns[5].to_s
  refs = line.scan(/`([LRWSP]_[a-z0-9_]+)`/).flatten.drop(1)
  errors << "error taxonomy criterion_impact is not controlled: #{criterion}" unless criterion_values.include?(criterion)
  unless band_signal == "all_bands" || band_signal.match?(/\A\d+\.\d\z/)
    errors << "error taxonomy band_signal is not controlled: #{band_signal}"
  end
  refs.each do |ref|
    errors << "error taxonomy microskill_ref is not in microskill enum: #{ref}" unless microskills.include?(ref)
  end
end

writing = File.read(File.join(framework_root, "writing-task-framework.md"))
writing_ids = writing.scan(/^\| `(W_[a-z0-9_]+)` \|/).flatten.to_set
expected_writing = %w[
  W_ac_task1_chart W_ac_task1_table W_ac_task1_process W_ac_task1_map W_ac_task1_diagram
  W_gt_task1_formal_letter W_gt_task1_semi_formal_letter W_gt_task1_informal_letter
  W_task2_opinion W_task2_discussion W_task2_advantages_disadvantages W_task2_problem_solution W_task2_two_part
].to_set
errors << "writing task enum mismatch: #{writing_ids.to_a.sort.inspect}" unless writing_ids == expected_writing
errors << "writing framework contains wildcard task ID" if writing.match?(/`W_(?:ac_task1|gt_task1|task2)_\*`/)

question_types = File.read(File.join(framework_root, "skill-questiontype-band.md"))
errors << "Listening question-type count label is stale" unless question_types.include?("## Listening — 10 question types")
errors << "Reading question-type count label is stale" unless question_types.include?("## Reading — 16 question types")

features = File.read(File.join(root, "blueprint", "03-features.md"))
event_pack = File.read(File.join(root, "artifacts", "engineering", "contracts", "events", "event-schema-pack.md"))
old_events = %w[writing_evaluation_started writing_evaluation_completed evaluation_completed writing_retest_completed study_session_started study_session_completed]
old_events.each do |event|
  errors << "obsolete event name remains: #{event}" if features.include?(event) || event_pack.include?(event)
end
%w[account_created consent_recorded placement_started placement_completed goal_set daily_plan_generated session_started session_completed evaluation_submitted evaluation_scored evaluation_failed evaluation_delayed learning_error_saved review_completed retest_completed quota_warning_shown quota_exceeded].each do |event|
  errors << "canonical event missing from event schema pack: #{event}" unless event_pack.include?("`#{event}`")
end
%w[retest_started upgrade_cta_shown upgrade_completed].each do |event|
  errors << "registered extension missing from event schema pack: #{event}" unless event_pack.include?("`#{event}`")
end
errors << "review_completed producer missing from error-to-review event contract" unless File.read(File.join(root, "artifacts", "engineering", "contracts", "error-to-review", "event-contract.md")).include?("### `review_completed`")
%w[event_type event_version event_id trace_id occurred_at user_id_hash session_id schema_version source entity_refs properties privacy_class schema_hash].each do |field|
  errors << "event envelope field missing from event schema pack: #{field}" unless event_pack.include?("#{field}:")
end

conventions = File.read(File.join(root, "blueprint", "07-conventions.md"))
errors << "evaluation state contains obsolete normal value" if conventions.match?(/Evaluation state.*`normal`/)
errors << "evaluation state scope does not explain aggregate-only none" unless conventions.include?("aggregate may be `none`")
unless conventions.include?("**Quality status**: `accepted`, `low_confidence`, `insufficient_evidence`, `invalid`")
  errors << "canonical quality_status enum missing from conventions"
end

if errors.empty?
  puts "framework validation passed (version #{versions.values.compact.uniq.first})"
else
  errors.each { |error| warn error }
  warn "framework validation failed: #{errors.length} issue(s)"
  exit 1
end
RUBY
