#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$repo_root"

ruby -Itools/lib -rlenbands -rlenbands/yaml_loader -rdigest -rset <<'RUBY'
root = Dir.pwd
errors = []
spawn_root = File.join(root, "artifacts/operations/spawn-prompts")
legacy_root = File.join(root, "spawn-prompts")

errors << "legacy top-level spawn-prompts directory must not exist" if File.exist?(legacy_root)

registry_path = File.join(spawn_root, "registry.yaml")
registry_meta_path = File.join(spawn_root, "registry.meta.yaml")
errors << "missing prompt registry: #{registry_path}" unless File.file?(registry_path)
errors << "missing prompt registry metadata: #{registry_meta_path}" unless File.file?(registry_meta_path)
exit(errors.length) unless errors.empty?

registry = Lenbands::YamlLoader.load_file(registry_path, mapping: true)
umbrella_body = File.read(File.join(root, "blueprint/framework/README.md"))
current_framework = umbrella_body[/framework_version:\s*([0-9]+\.[0-9]+\.[0-9]+)/, 1]
errors << "cannot resolve framework umbrella version" unless current_framework
errors << "prompt registry must declare source_of_truth: false" unless registry["source_of_truth"] == false
errors << "prompt registry must declare authority: workflow_contract" unless registry["authority"] == "workflow_contract"
errors << "prompt registry framework_version is stale" unless registry["framework_version"].to_s == current_framework.to_s

framework_version_for = lambda do |file|
  path = File.join(root, "blueprint/framework", "#{file}.md")
  return nil unless File.file?(path)
  body = File.read(path)
  match = body.match(/\A---\s*\n(.*?)\n---\s*(?:\n|\z)/m)
  return nil unless match
  begin
    frontmatter = YAML.safe_load(match[1], aliases: false) || {}
    frontmatter["version"].to_s
  rescue StandardError
    nil
  end
end

expected_ids = %w[
  spawn-vocab
  spawn-collocation
  spawn-grammar-lesson
  spawn-question-item
  spawn-error-example
  spawn-speaking-cue-card
  spawn-writing-prompt
]
templates = registry.fetch("prompt_templates", [])
ids = templates.map { |entry| entry["prompt_template_id"] }
errors << "prompt template IDs mismatch: #{ids.sort.inspect}" unless ids.sort == expected_ids.sort
errors << "prompt template IDs are duplicated" unless ids.uniq.length == ids.length

templates.each do |entry|
  id = entry["prompt_template_id"]
  path = entry["path"].to_s
  meta_path = entry["metadata_path"].to_s
  errors << "#{id}: path must stay inside artifacts/operations/spawn-prompts" unless path.start_with?("artifacts/operations/spawn-prompts/")
  errors << "#{id}: output_root must stay inside knowledge-assets" unless entry["output_root"].to_s.start_with?("knowledge-assets/")
  abs_path = File.join(root, path)
  abs_meta_path = File.join(root, meta_path)
  errors << "#{id}: missing prompt file #{path}" unless File.file?(abs_path)
  errors << "#{id}: missing prompt metadata #{meta_path}" unless File.file?(abs_meta_path)
  next unless File.file?(abs_path) && File.file?(abs_meta_path)

  actual_hash = "sha256:#{Digest::SHA256.file(abs_path).hexdigest}"
  errors << "#{id}: registry source_sha256 mismatch" unless entry["source_sha256"] == actual_hash
  metadata = Lenbands::YamlLoader.load_file(abs_meta_path, mapping: true)
  %w[type prompt_template_id status version owner representation derived_from purpose created_at updated_at framework_refs output_contract source_sha256].each do |field|
    errors << "#{id}: metadata missing #{field}" unless metadata.key?(field)
  end
  errors << "#{id}: metadata prompt_template_id mismatch" unless metadata["prompt_template_id"] == id
  errors << "#{id}: prompt template must remain review/draft, not approved" if metadata["status"] == "approved"
  errors << "#{id}: metadata source_sha256 mismatch" unless metadata["source_sha256"] == actual_hash
  refs = Array(metadata["framework_refs"])
  errors << "#{id}: framework_refs cannot be empty" if refs.empty?
  errors << "#{id}: registry/framework metadata file sets differ" unless Array(entry["framework_files"]).sort == refs.map { |ref| ref["file"] }.sort
  output_contract = metadata["output_contract"] || {}
  errors << "#{id}: registry/output metadata kind differs" unless entry["output_kind"] == output_contract["asset_kind"]
  errors << "#{id}: registry/output metadata root differs" unless entry["output_root"] == output_contract["output_root"]

  refs.each do |ref|
    file = ref["file"].to_s
    framework_path = File.join(root, "blueprint/framework", "#{file}.md")
    errors << "#{id}: framework file missing #{file}" unless File.file?(framework_path)
    next unless File.file?(framework_path)

    file_version = framework_version_for.call(file)
    errors << "#{id}: cannot resolve framework version for #{file}" if file_version.nil? || file_version.empty?
    if file_version && !file_version.empty? && ref["version"].to_s != file_version
      errors << "#{id}: stale framework ref #{file}@#{ref["version"]}; current is #{file_version}"
    end

    framework_body = File.read(framework_path)
    Array(ref["nodes"]).each do |node|
      errors << "#{id}: unresolved framework node #{file}##{node}" unless framework_body.include?(node.to_s)
    end
    Array(ref["sections"]).each do |section|
      errors << "#{id}: unresolved framework section #{file}##{section}" unless framework_body.include?(section.to_s)
    end
  end

  body = File.read(abs_path)
  errors << "#{id}: missing start marker" unless body.include?("---BẮT ĐẦU---")
  errors << "#{id}: missing output contract section" unless body.include?("## OUTPUT")
  errors << "#{id}: missing unknown_* stop rule" unless body.include?("unknown_")
  errors << "#{id}: missing needs_review honesty rule" unless body.include?("needs_review")
  errors << "#{id}: prompt must not prohibit agent reading" if body.match?(/KHÔNG ĐỌC (?:FOLDER|THƯ MỤC)|DO NOT (?:READ|INDEX) (?:THIS )?(?:FOLDER|DIRECTORY)/i)
end

example_paths = %w[
  artifacts/operations/spawn-prompts/examples/vocab-card-example.md
  artifacts/operations/spawn-prompts/examples/grammar-lesson-example.md
]
example_paths.each do |path|
  errors << "missing golden example #{path}" unless File.file?(File.join(root, path))
  meta_path = path.sub(/\.md\z/, ".meta.yaml")
  errors << "missing golden example metadata #{meta_path}" unless File.file?(File.join(root, meta_path))
  next unless File.file?(File.join(root, meta_path))
  meta = Lenbands::YamlLoader.load_file(File.join(root, meta_path), mapping: true)
  errors << "#{meta_path}: example_only must be true" unless meta["example_only"] == true
  Array(meta["framework_refs"]).each do |ref|
    file = ref["file"].to_s
    file_version = framework_version_for.call(file)
    errors << "#{meta_path}: stale framework ref #{file}@#{ref["version"]}; current is #{file_version}" if file_version && ref["version"].to_s != file_version
  end
end

Dir.glob(File.join(spawn_root, "spawn-*.md")).each do |path|
  meta = path.sub(/\.md\z/, ".meta.yaml")
  errors << "prompt missing sibling metadata: #{path.delete_prefix("#{root}/")}" unless File.file?(meta)
end

if errors.empty?
  puts "spawn prompt validation passed (#{templates.length} templates, umbrella framework #{current_framework})"
else
  errors.each { |error| warn error }
  warn "spawn prompt validation failed: #{errors.length} issue(s)"
  exit 1
end
RUBY
