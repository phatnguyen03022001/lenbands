#!/usr/bin/env ruby
# frozen_string_literal: true

require "tmpdir"
require_relative "hook_support"

File.write(LenbandsClaudeHook.session_marker, "dirty\n")
