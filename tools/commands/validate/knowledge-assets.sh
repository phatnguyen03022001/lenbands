#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$repo_root"

ruby -rdigest -Itools/lib -rlenbands -rlenbands/yaml_loader -rlenbands/frontmatter -rlenbands/digest_helper -rlenbands/reporter <<'RUBY'
root = Dir.pwd
errors = []
capabilities = File.read(File.join(root, "blueprint", "03-features.md"))
  .scan(/`([A-Z][A-Z0-9_]*\.[A-Za-z][A-Za-z0-9_]*)`/).flatten.to_h { |id| [id, true] }

def valid_checksum_format?(value)
  Lenbands::DigestHelper.valid_checksum?(value)
end

def payload_data(path)
  data, _err = Lenbands::Frontmatter.parse(path)
  return data unless data.nil? || data.empty?
  # Fallback: file may be pure YAML without frontmatter delimiters
  YAML.safe_load(File.read(path), permitted_classes: [Date], aliases: false) || {}
rescue StandardError
  {}
end

def ids_in(path, prefix)
  File.read(path).scan(/`(#{prefix}_[a-z0-9_]+)`/).flatten.to_h { |id| [id, true] }
end

framework_root = File.join(root, "blueprint", "framework")
topic_ids = File.read(File.join(framework_root, "vocab-collocation-topic.md")).scan(/`([tc]_[a-z0-9_]+)`/).flatten.to_h { |id| [id, true] }
grammar_ids = ids_in(File.join(framework_root, "grammar-band-framework.md"), "g")
writing_ids = ids_in(File.join(framework_root, "writing-task-framework.md"), "W")
microskill_ids = %w[microskill-enum].each_with_object({}) do |name, result|
  ids = File.read(File.join(framework_root, "#{name}.md")).scan(/`([LRWSP]_[a-z0-9_]+)`/).flatten
  ids.each { |id| result[id] = true }
end
error_ids = File.read(File.join(framework_root, "error-taxonomy.md")).scan(/^\| `([LRSW]_[a-z0-9_]+)` \|/).flatten.to_h { |id| [id, true] }

metas = Dir.glob(File.join(root, "knowledge-assets", "**", "*.meta.yaml")).sort
ids = {}

metas.each do |meta_path|
  data = Lenbands::YamlLoader.load_file(meta_path, mapping: true)
  label = meta_path.delete_prefix("#{root}/")
  required = %w[asset_id type status version owner derived_from origin integrity governance spawn_lineage framework_refs]
  required.each do |field|
    errors << "#{label}: missing #{field}" unless data.key?(field)
  end

  asset_id = data["asset_id"]
  unless asset_id.is_a?(String) && asset_id.match?(/\AKA-\d{6}\z/)
    errors << "#{label}: invalid asset_id"
  end
  if asset_id && ids.key?(asset_id)
    errors << "duplicate asset_id #{asset_id}: #{label} and #{ids[asset_id]}"
  elsif asset_id
    ids[asset_id] = label
  end

  status = data["status"]
  unless %w[draft in_review published deprecated retired].include?(status)
    errors << "#{label}: invalid Knowledge Asset status #{status.inspect}"
  end
  errors << "#{label}: version must be semver" unless data["version"].is_a?(String) && data["version"].match?(/\A\d+\.\d+\.\d+\z/)

  Array(data["derived_from"]).each do |ref|
    errors << "#{label}: unknown derived_from #{ref}" unless capabilities[ref]
  end
  errors << "#{label}: derived_from must be non-empty" if !data["derived_from"].is_a?(Array) || data["derived_from"].empty?

  origin = data["origin"] || {}
  unless %w[unknown generated first_party licensed public_domain].include?(origin["source"])
    errors << "#{label}: invalid origin.source"
  end
  errors << "#{label}: origin.license missing" unless origin.key?("license")

  governance = data["governance"] || {}
  %w[rights_status review_status].each do |field|
    errors << "#{label}: governance.#{field} missing" unless governance.key?(field)
  end
  unless %w[pending_review verified link_only expired revoked].include?(governance["rights_status"])
    errors << "#{label}: invalid governance.rights_status"
  end
  unless %w[draft reviewed].include?(governance["review_status"])
    errors << "#{label}: invalid governance.review_status"
  end

  lineage = data["spawn_lineage"] || {}
  %w[workflow_run_id prompt_template_id prompt_hash model parameters].each do |field|
    errors << "#{label}: spawn_lineage.#{field} missing" unless lineage.key?(field)
  end
  errors << "#{label}: spawn_lineage.parameters must be a map" unless lineage["parameters"].is_a?(Hash)
  if origin["source"] == "generated"
    %w[workflow_run_id prompt_template_id prompt_hash model].each do |field|
      value = lineage[field]
      errors << "#{label}: generated asset requires non-null spawn_lineage.#{field}" if value.nil? || value.to_s.empty?
    end
    errors << "#{label}: generated asset prompt_hash must be sha256" unless lineage["prompt_hash"].to_s.match?(/\Asha256:[0-9a-f]{64}\z/)
  end
  if status == "published"
    errors << "#{label}: published asset requires verified rights" unless governance["rights_status"] == "verified"
    errors << "#{label}: published asset requires reviewed governance" unless governance["review_status"] == "reviewed"
    errors << "#{label}: published asset requires governance.approval_ref" unless governance["approval_ref"].is_a?(String) && !governance["approval_ref"].empty?
  end

  integrity = data["integrity"] || {}
  payload_file = integrity["payload_file"]
  checksum = integrity["checksum"]
  unless payload_file.is_a?(String) && payload_file == File.basename(payload_file)
    errors << "#{label}: integrity.payload_file must be a sibling basename"
    next
  end
  payload_path = File.join(File.dirname(meta_path), payload_file)
  errors << "#{label}: missing payload #{payload_file}" unless File.file?(payload_path)
  errors << "#{label}: metadata/payload filename mismatch" if payload_file.is_a?(String) && File.basename(meta_path, ".meta.yaml") != File.basename(payload_file, ".md")
  unless checksum.is_a?(String) && checksum.match?(/\Asha256:[0-9a-f]{64}\z/)
    errors << "#{label}: invalid integrity.checksum"
  end
  if File.file?(payload_path) && checksum.is_a?(String)
    actual = "sha256:#{Digest::SHA256.file(payload_path).hexdigest}"
    errors << "#{label}: checksum mismatch" unless actual == checksum
  end

  refs = data["framework_refs"]
  errors << "#{label}: framework_refs must be non-empty" unless refs.is_a?(Array) && !refs.empty?
  Array(refs).each do |ref|
    unless ref.is_a?(Hash) && ref.key?("file") && ref.key?("version") && ref.key?("nodes")
      errors << "#{label}: each framework_ref requires file, version and nodes"
      next
    end
    file = ref["file"]
    version = ref["version"]
    nodes = ref["nodes"]
    framework_path = File.join(root, "blueprint", "framework", "#{file}.md")
    errors << "#{label}: missing framework file #{file}" unless file.is_a?(String) && File.file?(framework_path)
    errors << "#{label}: invalid framework version" unless version.is_a?(String) && version.match?(/\A\d+\.\d+\.\d+\z/)
    errors << "#{label}: framework nodes missing" unless nodes.is_a?(Array) && !nodes.empty?
    next unless File.file?(framework_path)
    expected_version = Lenbands::Frontmatter.version(framework_path)
    errors << "#{label}: framework version mismatch for #{file}" unless expected_version.to_s == version.to_s
    prefix = case file
             when "vocab-collocation-topic" then "[tc]"
             when "grammar-band-framework" then "g"
             when "writing-task-framework" then "W"
             when "microskill-enum" then "[LRWSP]"
             else nil
             end
    typed_nodes = prefix ? File.read(framework_path).scan(/`(#{prefix}_[a-z0-9_]+)`/).flatten.to_h { |id| [id, true] } : {}
    Array(nodes).each do |node|
      errors << "#{label}: unknown or wrong-type framework node #{node} in #{file}" unless typed_nodes[node]
    end
  end

  payload_path = File.join(File.dirname(meta_path), (data.dig("integrity", "payload_file") || ""))
  if File.file?(payload_path)
    payload = payload_data(payload_path)
    if payload.key?("status") && payload["status"] != status
      errors << "#{label}: payload status diverges from canonical sidecar"
    end
    if payload.key?("version") && payload["version"].to_s != data["version"].to_s
      errors << "#{label}: payload version diverges from canonical sidecar"
    end
    family = File.basename(File.dirname(meta_path))
    case family
    when "vocabulary"
      %w[word_id headword band_range topic_ref definition_en example microskill_ref].each do |field|
        errors << "#{label}: vocabulary payload missing #{field}" unless payload.key?(field)
      end
      errors << "#{label}: band_range must be N.N-N.N string" unless payload["band_range"].is_a?(String) && payload["band_range"].match?(/\A\d+\.\d-\d+\.\d\z/)
      Array(payload["topic_ref"]).each { |id| errors << "#{label}: unknown vocabulary topic #{id}" unless topic_ids[id] }
      Array(payload["microskill_ref"]).each { |id| errors << "#{label}: unknown vocabulary microskill #{id}" unless microskill_ids[id] }
    when "grammar"
      %w[grammar_id band_master band_introduce depends_on].each do |field|
        errors << "#{label}: grammar payload missing #{field}" unless payload.key?(field)
      end
      errors << "#{label}: grammar_id is not in grammar framework" unless grammar_ids[payload["grammar_id"]]
      Array(payload["depends_on"]).each { |id| errors << "#{label}: grammar depends_on must reference grammar node #{id}" unless grammar_ids[id] }
      Array(payload["error_refs"]).each { |id| errors << "#{label}: unknown grammar error_ref #{id}" unless error_ids[id] }
      if payload["can_statement"].nil? && !Array(payload["needs_review"]).include?("can_statement_not_defined_in_framework_node")
        errors << "#{label}: null can_statement requires explicit needs_review flag"
      end
    when "writing-prompts"
      %w[task_id exam_module task_type prompt_text].each do |field|
        errors << "#{label}: writing prompt payload missing #{field}" unless payload.key?(field)
      end
      errors << "#{label}: band_range must be N.N-N.N string" unless payload["band_range"].is_a?(String) && payload["band_range"].match?(/\A\d+\.\d-\d+\.\d\z/)
      errors << "#{label}: unknown writing task_type #{payload["task_type"]}" unless writing_ids[payload["task_type"]]
      Array(payload.dig("tags", "microskill_ref")).each { |id| errors << "#{label}: unknown writing microskill #{id}" unless microskill_ids[id] }
    when "collocations"
      %w[collocation_id collocation band_range topic_ref example microskill_ref].each do |field|
        errors << "#{label}: collocation payload missing #{field}" unless payload.key?(field)
      end
      errors << "#{label}: band_range must be N.N-N.N string" unless payload["band_range"].is_a?(String) && payload["band_range"].match?(/\A\d+\.\d-\d+\.\d\z/)
      Array(payload["topic_ref"]).each { |id| errors << "#{label}: unknown collocation topic #{id}" unless topic_ids[id] }
      Array(payload["microskill_ref"]).each { |id| errors << "#{label}: unknown collocation microskill #{id}" unless microskill_ids[id] }
    end
  end
end

if errors.empty?
  puts "knowledge asset validation passed"
else
  errors.each { |error| warn error }
  warn "knowledge asset validation failed: #{errors.length} issue(s)"
  exit 1
end
RUBY
