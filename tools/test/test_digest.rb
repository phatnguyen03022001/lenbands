#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.join(__dir__, "..", "lib")
require "lenbands"
require "lenbands/digest_helper"
require "lenbands/reporter"

reporter = Lenbands::Reporter.new("digest tests")

# Test valid checksum format
reporter << "valid sha256 rejected" unless Lenbands::DigestHelper.valid_checksum?("sha256:#{"a" * 64}")
reporter << "invalid sha256 accepted (too short)" if Lenbands::DigestHelper.valid_checksum?("sha256:abc")
reporter << "non-string accepted" if Lenbands::DigestHelper.valid_checksum?(nil)
reporter << "missing prefix accepted" if Lenbands::DigestHelper.valid_checksum?("a" * 64)

# Test sha256_file on a known file
known_file = File.join(Lenbands::ROOT, "blueprint", "framework", "README.md")
if File.file?(known_file)
  hex = Lenbands::DigestHelper.sha256_file(known_file)
  reporter << "sha256_file returned non-hex" unless hex.match?(/\A[0-9a-f]{64}\z/)

  prefixed = Lenbands::DigestHelper.sha256_prefixed(known_file)
  reporter << "sha256_prefixed missing prefix" unless prefixed.start_with?("sha256:")
  reporter << "sha256_prefixed mismatch" unless prefixed == "sha256:#{hex}"
end

reporter.pass!("PASS: digest tests")
