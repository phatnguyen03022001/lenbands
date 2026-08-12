#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "open3"
require "rubygems/version"
require "tempfile"
require "tmpdir"

root = File.expand_path("../..", __dir__)
toolchain = YAML.safe_load(File.read(File.join(root, "tools/toolchain.yaml")), aliases: false)
errors = []

def executable_on_path?(name)
  ENV.fetch("PATH", "").split(File::PATH_SEPARATOR).any? do |directory|
    path = File.join(directory, name)
    File.file?(path) && File.executable?(path)
  end
end

Array(toolchain["runtime_requirements"]).each do |requirement|
  command = requirement["command"].to_s
  unless executable_on_path?(command)
    errors << "missing required executable: #{command} (#{requirement["purpose"]})"
    next
  end
  args = Array(requirement["version_args"])
  next if args.empty?
  output, status = Open3.capture2e(command, *args)
  unless status.success?
    errors << "cannot inspect #{command} version"
    next
  end
  minimum = requirement["minimum_version"]
  next if minimum.to_s.empty?
  actual = output[/\d+(?:\.\d+){1,2}/]
  if actual.nil? || Gem::Version.new(actual) < Gem::Version.new(minimum.to_s)
    errors << "#{command} #{actual || 'unknown'} is below required #{minimum}"
  end
end

entrypoint = File.join(root, toolchain["stable_entrypoint"].to_s)
errors << "stable CLI is missing or not executable" unless File.file?(entrypoint) && File.executable?(entrypoint)
%w[tools/manifest.yaml artifacts/operations/domain-automation-contract.yaml].each do |path|
  errors << "required toolchain contract missing: #{path}" unless File.file?(File.join(root, path))
end

begin
  Tempfile.create("lenbands-toolchain-doctor") do |file|
    file.write("temp-write-probe\n")
    file.flush
    errors << "temporary-file write probe was not persisted" unless File.size(file.path).positive?
  end
rescue SystemCallError => e
  errors << "temporary directory is not writable (#{Dir.tmpdir}): #{e.class}: #{e.message}"
end

mktemp_template = File.join(Dir.tmpdir, "lenbands-doctor.XXXXXX")
mktemp_output, mktemp_status = Open3.capture2e("mktemp", mktemp_template)
if mktemp_status.success?
  mktemp_path = mktemp_output.strip
  expected_prefix = File.expand_path(Dir.tmpdir) + File::SEPARATOR
  errors << "mktemp escaped configured temporary directory: #{mktemp_path}" unless File.expand_path(mktemp_path).start_with?(expected_prefix)
  File.delete(mktemp_path) if File.file?(mktemp_path)
else
  errors << "shell mktemp cannot write configured temporary directory (#{Dir.tmpdir}): #{mktemp_output.strip}"
end

if errors.empty?
  puts "toolchain doctor passed (runtime requirements=#{Array(toolchain["runtime_requirements"]).length})"
else
  warn errors.join("\n")
  warn "toolchain doctor failed: #{errors.length} issue(s)"
  exit 2
end
