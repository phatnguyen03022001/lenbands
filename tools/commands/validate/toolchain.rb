#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "set"

ROOT = File.expand_path("../../..", __dir__)
manifest_path = File.join(ROOT, "tools/manifest.yaml")
manifest = YAML.safe_load(File.read(manifest_path), aliases: false)
toolchain_path = File.join(ROOT, "tools/toolchain.yaml")
toolchain = YAML.safe_load(File.read(toolchain_path), aliases: false)
errors = []

errors << "tools manifest schema_version must be 1" unless manifest["schema_version"] == 1
tools = manifest["tools"]
errors << "tools manifest tools must be a mapping" unless tools.is_a?(Hash)

allowed_types = %w[generator validator utility runner]
seen_outputs = {}

tools.to_h.each do |name, entry|
  errors << "#{name}: invalid tool declaration" unless entry.is_a?(Hash)
  next unless entry.is_a?(Hash)
  errors << "#{name}: invalid type #{entry["type"].inspect}" unless allowed_types.include?(entry["type"])
  %w[consumes produces invalidates depends_on].each do |field|
    errors << "#{name}: #{field} must be an array" unless entry[field].is_a?(Array)
  end

  declared_entrypoint = entry["entrypoint"]
  executable = if declared_entrypoint
    File.join(ROOT, declared_entrypoint)
  else
    [File.join(ROOT, "tools/#{name}"), File.join(ROOT, "tools/#{name}.sh"), File.join(ROOT, "tools/#{name}.rb")].find { |path| File.file?(path) }
  end
  script_exists = executable && File.file?(executable)
  errors << "#{name}: no matching executable script" unless script_exists
  errors << "#{name}: declared entrypoint must live under tools/commands" if declared_entrypoint && !declared_entrypoint.start_with?("tools/commands/")
  errors << "#{name}: script is not executable" if script_exists && !File.executable?(executable)

  Array(entry["consumes"]).each do |path|
    next if path.include?("*")
    errors << "#{name}: declared input missing: #{path}" unless File.exist?(File.join(ROOT, path))
  end
  Array(entry["produces"]).each do |path|
    previous = seen_outputs[path]
    errors << "#{name}: output #{path} is also owned by #{previous}" if previous
    seen_outputs[path] = name
  end
  Array(entry["depends_on"]).each do |dependency|
    errors << "#{name}: unknown dependency #{dependency}" unless tools.key?(dependency)
  end
end

errors << "toolchain schema_version must be 1" unless toolchain["schema_version"] == 1
errors << "toolchain_version must be semantic version" unless toolchain["toolchain_version"].to_s.match?(/\A\d+\.\d+\.\d+\z/)
requirements = Array(toolchain["runtime_requirements"])
errors << "toolchain runtime_requirements must not be empty" if requirements.empty?
requirement_names = requirements.map { |item| item["command"] }
errors << "toolchain has duplicate runtime requirements" unless requirement_names.uniq.length == requirement_names.length
requirements.each do |requirement|
  errors << "runtime requirement missing command" if requirement["command"].to_s.empty?
  errors << "#{requirement["command"]}: runtime requirement missing purpose" if requirement["purpose"].to_s.empty?
  minimum = requirement["minimum_version"]
  errors << "#{requirement["command"]}: invalid minimum_version" if minimum && !minimum.to_s.match?(/\A\d+\.\d+\.\d+\z/)
  errors << "#{requirement["command"]}: version_args must be an array" unless requirement["version_args"].is_a?(Array)
end
entrypoint = toolchain["stable_entrypoint"].to_s
errors << "toolchain stable_entrypoint is missing or not executable" unless File.executable?(File.join(ROOT, entrypoint))
commands = Array(toolchain["public_commands"])
errors << "toolchain public_commands must not be empty" if commands.empty?
command_names = commands.map { |command| command["command"] }
errors << "toolchain has duplicate public command names" unless command_names.uniq.length == command_names.length
commands.each do |command|
  name = command["command"].to_s
  target = command["target"].to_s
  errors << "toolchain command missing name" if name.empty?
  errors << "#{name}: invalid stability" unless command["stability"] == "stable"
  errors << "#{name}: target is missing or not executable" unless File.executable?(File.join(ROOT, target))
  errors << "#{name}: public target must live under tools/commands" unless target.start_with?("tools/commands/")
end

Dir.glob(File.join(ROOT, "tools/*.{sh,rb}")).each do |legacy|
  next if File.basename(legacy) == "generate-capability-registries.sh"
  text = File.read(legacy)
  errors << "#{legacy.delete_prefix(ROOT + '/')}: compatibility shim must route through tools/bin/lenbands" unless text.include?("bin/lenbands")
  errors << "#{legacy.delete_prefix(ROOT + '/')}: compatibility shim is unexpectedly large" if text.lines.length > 12
end

tools.to_h.each do |name, entry|
  visited = Set.new
  stack = Array(entry["depends_on"])
  until stack.empty?
    dependency = stack.pop
    next if visited.include?(dependency)
    visited << dependency
    errors << "#{name}: dependency cycle via #{dependency}" if dependency == name
    stack.concat(Array(tools.dig(dependency, "depends_on")))
  end
end

deprecated = File.join(ROOT, "tools/generate-capability-registries.sh")
if File.file?(deprecated) && !File.read(deprecated).include?("deprecated and intentionally disabled")
  errors << "legacy capability registry generator must remain fail-closed"
end

if errors.empty?
  puts "tooling contract validation passed (#{tools.length} registered tools, #{commands.length} public commands)"
else
  warn errors.join("\n")
  warn "tooling contract validation failed: #{errors.length} issue(s)"
  exit 1
end
