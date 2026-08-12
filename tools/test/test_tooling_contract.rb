#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

tools_root = File.expand_path("..", __dir__)
repo_root = File.expand_path("..", tools_root)
manifest = YAML.safe_load(File.read(File.join(tools_root, "manifest.yaml")), aliases: false)
toolchain = YAML.safe_load(File.read(File.join(tools_root, "toolchain.yaml")), aliases: false)
abort "tools manifest is missing tools" unless manifest["tools"].is_a?(Hash)

tool_sources = Dir.glob(File.join(tools_root, "**", "*"), File::FNM_DOTMATCH).select do |path|
  File.file?(path) && %w[.rb .sh].include?(File.extname(path))
end
tool_sources << File.join(tools_root, "bin/lenbands")
tool_sources << File.join(tools_root, "commands/capability/add")
unsafe_yaml_call = ["YAML", "load_file"].join(".")
tool_sources.uniq.each do |path|
  body = File.read(path)
  abort "unsafe YAML file loading remains in #{path.delete_prefix(repo_root + '/')}" if body.include?(unsafe_yaml_call)
end

%w[commands/generate/lifecycle-registry.sh commands/generate/repository-baseline.sh].each do |relative|
  body = File.read(File.join(tools_root, relative))
  abort "#{relative} uses substring capability matching" if body.match?(/include\?\(id\)/)
end

%w[
  commands/generate/capability-index.sh
  commands/generate/operational-coverage.sh
  commands/generate/repository-baseline.sh
].each do |relative|
  body = File.read(File.join(tools_root, relative))
  abort "#{relative} uses non-portable bare mktemp" if body.match?(/\$\(mktemp(?: -d)?\)/)
  abort "#{relative} must place temporary output under configured TMPDIR" unless body.include?('${TMPDIR:-/tmp}')
end

%w[generate-all verify validate-tools validate-capability-phase-index].each do |name|
  path = File.join(tools_root, "#{name}.sh")
  path = File.join(tools_root, "#{name}.rb") unless File.file?(path)
  abort "missing tool entry point: #{name}" unless File.file?(path) && File.executable?(path)
  abort "missing tool manifest entry: #{name}" unless manifest["tools"].key?(name)
end

Dir.chdir(repo_root) do
  cli = "tools/bin/lenbands"
  abort "stable CLI is not executable" unless File.executable?(cli)
  abort "stable CLI version mismatch" unless `#{cli} version`.strip == "LenBands toolchain #{toolchain.fetch("toolchain_version")}"
  abort "stable CLI generate check failed" unless system(cli, "generate", "all", "--check", out: File::NULL)
  abort "generated projections are stale" unless system("tools/generate-all.sh", "--check", out: File::NULL)
  abort "tool validator failed" unless system("tools/validate-tools.sh", out: File::NULL)
  abort "capability phase index validator failed" unless system("tools/validate-capability-phase-index.sh", out: File::NULL)
  unknown_capability_ok = system("tools/add-capability", "--id", "EVAL.NotInBlueprint", "--family", "WRITING.Evaluation", out: File::NULL, err: File::NULL)
  abort "add-capability must reject unknown controlled-vocabulary IDs" if unknown_capability_ok
  legacy_generator_ok = system("tools/generate-capability-registries.sh", out: File::NULL, err: File::NULL)
  abort "legacy capability registry generator must remain fail-closed" if legacy_generator_ok

  probe = "artifacts/operations/evidence/tooling-contract-probe.yaml"
  abort "reserved tooling probe path already exists" if File.exist?(probe) || File.exist?("#{probe}.meta.yaml")
  acceptance_ok = system("tools/run-p0-acceptance.sh", "--results", "missing.yaml", "--output", probe, "--reviewed-by", "tooling", out: File::NULL, err: File::NULL)
  abort "acceptance runner must fail closed without runtime results" if acceptance_ok || File.exist?(probe)
  benchmark_ok = system("tools/run-writing-benchmark.sh", "--results", "missing.yaml", "--output", probe, "--reviewed-by", "tooling", out: File::NULL, err: File::NULL)
  abort "benchmark runner must fail closed without runtime results" if benchmark_ok || File.exist?(probe)
end

puts "PASS: tooling contract tests (#{manifest["tools"].length} registered tools)"
