#!/usr/bin/env ruby
# frozen_string_literal: true

require "open3"

root = File.expand_path("../..", __dir__)
load_path = File.join(root, "tools/lib")
errors = []

failure_program = <<~'RUBY'
  require "lenbands"
  require "lenbands/reporter"
  reporter = Lenbands::Reporter.new("reporter regression")
  reporter << "sentinel assertion failure"
  reporter.pass!("must not print a pass result")
RUBY
stdout, stderr, status = Open3.capture3("ruby", "-I#{load_path}", "-e", failure_program, chdir: root)
errors << "Reporter#pass! accepted accumulated errors" if status.success?
errors << "Reporter failure omitted accumulated error" unless stderr.include?("sentinel assertion failure")
errors << "Reporter printed a false pass result" if stdout.include?("must not print")

success_program = <<~'RUBY'
  require "lenbands"
  require "lenbands/reporter"
  Lenbands::Reporter.new("reporter regression").pass!("sentinel pass")
RUBY
stdout, stderr, status = Open3.capture3("ruby", "-I#{load_path}", "-e", success_program, chdir: root)
errors << "clean Reporter failed: #{stderr}" unless status.success?
errors << "clean Reporter omitted pass result" unless stdout.include?("sentinel pass")

abort(errors.join("\n")) unless errors.empty?
puts "PASS: reporter fail-closed regression tests"
