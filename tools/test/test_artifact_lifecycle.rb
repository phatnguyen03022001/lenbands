#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.join(__dir__, "..", "lib")
require "lenbands"
require "lenbands/artifact_lifecycle"
require "lenbands/reporter"

reporter = Lenbands::Reporter.new("artifact lifecycle detector tests")
detect = ->(text) { Lenbands::ArtifactLifecycle.embedded_metadata?(text.lines(chomp: true)) }

reporter << "partial lifecycle status was not detected" unless detect.call("# Contract\n```yaml\nstatus: draft\n```\n")
reporter << "partial lifecycle version was not detected" unless detect.call("```yaml\nversion: 1.2.3\n```\n")
reporter << "sidecar-only key was not detected" unless detect.call("```yaml\nderived_from: [EVAL.Writing]\n```\n")
reporter << "runtime status enum was mistaken for lifecycle metadata" if detect.call("```yaml\nstatus: open | in_review | closed\n```\n")
reporter << "runtime integer version was mistaken for lifecycle metadata" if detect.call("```yaml\nversion: integer\n```\n")
reporter << "prose outside a YAML fence was mistaken for metadata" if detect.call("status: draft\n")

reporter.pass!("PASS: artifact lifecycle detector tests")
