#!/usr/bin/env ruby
# frozen_string_literal: true

require "tempfile"

$LOAD_PATH.unshift File.join(__dir__, "..", "lib")
require "lenbands"
require "lenbands/reporter"
require "lenbands/yaml_loader"

reporter = Lenbands::Reporter.new("YAML duplicate-key fail-closed tests")

Tempfile.create(["lenbands-duplicate-key", ".yaml"]) do |file|
  file.write("status: draft\nchange_log: []\nchange_log: []\n")
  file.flush
  begin
    Lenbands::YamlLoader.load_file(file.path, mapping: true)
    reporter << "duplicate YAML mapping key was accepted"
  rescue Lenbands::YamlError => e
    reporter << "duplicate-key error omitted key name" unless e.message.include?("change_log")
  end
end

reporter.pass!("PASS: YAML duplicate-key fail-closed tests")
