#!/usr/bin/env ruby
# frozen_string_literal: true
exec File.expand_path("bin/lenbands", __dir__), "validate", "implementation-catalog", *ARGV
