#!/usr/bin/env ruby
# frozen_string_literal: true

require "open3"
require "tempfile"
require "yaml"

root = File.expand_path("../..", __dir__)
errors = []
run = ->(*command) { Open3.capture3(*command, chdir: root) }

stdout, stderr, status = run.call("tools/bin/lenbands", "doctor")
errors << "doctor failed: #{stdout}#{stderr}" unless status.success?

stdout, stderr, status = run.call("tools/bin/lenbands", "context", "--yaml")
errors << "agent context command failed" unless status.success?
begin
  context = YAML.safe_load(stdout, aliases: false)
  errors << "agent context omitted protected paths" unless Array(context["protected_paths"]).any?
rescue StandardError => e
  errors << "agent context is not valid YAML: #{e.message}"
end

stdout, stderr, status = run.call("tools/bin/lenbands", "gate", "p0")
errors << "P0 readiness gate must use blocked exit code 3" unless status.exitstatus == 3
errors << "P0 readiness gate omitted corpus blocker" unless (stdout + stderr).include?("gold corpus")

stdout, stderr, status = run.call("tools/bin/lenbands", "validate", "benchmark-contracts")
errors << "benchmark contract shape validator failed" unless status.success?
errors << "benchmark message must disclose blocked readiness" unless (stdout + stderr).include?("contract shape valid (readiness=blocked")

errors << "canonical document validator must be Ruby" unless File.executable?(File.join(root, "tools/commands/validate/documents.rb"))
errors << "legacy canonical documents.sh must not remain" if File.exist?(File.join(root, "tools/commands/validate/documents.sh"))

Tempfile.create("lenbands-protected-diff") do |file|
  file.write("M\ttools/toolchain.yaml\n")
  file.flush
  _stdout, _stderr, status = run.call("tools/bin/lenbands", "validate", "trust-boundary", "--diff", file.path)
  errors << "protected change accepted without attestation" if status.success?
end

Tempfile.create("lenbands-immutable-diff") do |file|
  file.write("M\tartifacts/operations/evidence/spawn-validation-run-007.md\n")
  file.flush
  _stdout, stderr, status = run.call("tools/bin/lenbands", "validate", "trust-boundary", "--diff", file.path)
  errors << "immutable evidence modification accepted" if status.success?
  errors << "immutable evidence failure reason missing" unless stderr.include?("may only be added")
end

Tempfile.create("lenbands-attested-diff") do |file|
  file.write("M\ttools/toolchain.yaml\n")
  file.write("A\tartifacts/operations/attestations/toolchain-trust-hardening-20260807.yaml\n")
  file.flush
  stdout, stderr, status = run.call("tools/bin/lenbands", "validate", "trust-boundary", "--diff", file.path)
  errors << "valid protected-change attestation rejected: #{stdout}#{stderr}" unless status.success?
end

abort(errors.join("\n")) unless errors.empty?
puts "PASS: fail-closed gate tests"
