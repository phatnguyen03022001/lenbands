#!/usr/bin/env ruby
# frozen_string_literal: true

require "tempfile"
require "tmpdir"

$LOAD_PATH.unshift File.join(__dir__, "..", "lib")
require "lenbands"
require "lenbands/registries"
require "lenbands/reporter"

reporter = Lenbands::Reporter.new("registry fail-closed tests")
support = Lenbands::Registries::Support

begin
  support.load_mapping(File.join(Dir.tmpdir, "lenbands-definitely-missing-registry.yaml"))
  reporter << "missing registry was accepted"
rescue Lenbands::Registries::RegistryError => e
  reporter << "missing registry error omitted cause" unless e.message.include?("missing")
end

Tempfile.create(["lenbands-malformed-registry", ".yaml"]) do |file|
  file.write("key: [unterminated")
  file.flush
  begin
    support.load_mapping(file.path)
    reporter << "malformed registry was accepted"
  rescue Lenbands::Registries::RegistryError => e
    reporter << "malformed registry error omitted cause" unless e.message.include?("unreadable")
  end
end

Tempfile.create(["lenbands-sequence-registry", ".yaml"]) do |file|
  file.write("- not\n- a\n- mapping\n")
  file.flush
  begin
    support.load_mapping(file.path)
    reporter << "non-mapping registry root was accepted"
  rescue Lenbands::Registries::RegistryError => e
    reporter << "registry shape error omitted cause" unless e.message.include?("must be a mapping")
  end
end

reporter.pass!("PASS: registry fail-closed tests")
