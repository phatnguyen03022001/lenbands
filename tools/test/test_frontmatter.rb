#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.join(__dir__, "..", "lib")
require "lenbands"
require "lenbands/frontmatter"
require "lenbands/reporter"

reporter = Lenbands::Reporter.new("frontmatter tests")

fw_root = File.join(Lenbands::ROOT, "blueprint", "framework")
framework_files = Dir.glob(File.join(fw_root, "*.md"))
                     .map { |f| File.basename(f, ".md") }
                     .reject { |n| n == "README" }

reporter << "no framework files found" if framework_files.empty?

framework_files.each do |name|
  path = File.join(fw_root, "#{name}.md")
  data, err = Lenbands::Frontmatter.parse(path)
  if err
    reporter << "frontmatter parse error in #{name}: #{err}"
    next
  end
  ver = data["version"]
  reporter << "#{name}: missing version in frontmatter" unless ver.is_a?(String)
  reporter << "#{name}: invalid semver #{ver}" if ver.is_a?(String) && !ver.match?(/\A\d+\.\d+\.\d+\z/)
end

# Test version helper against a file that is governed by YAML frontmatter.
versioned_framework = File.join(fw_root, "#{framework_files.first}.md")
fw_version = Lenbands::Frontmatter.version(versioned_framework)
reporter << "framework file version is nil" if fw_version.nil?

# Test parse on non-existent file
data, err = Lenbands::Frontmatter.parse("/nonexistent/path.md")
reporter << "parse non-existent file should return error" unless err
reporter << "parse non-existent file should return nil data" unless data.nil?

reporter.pass!("PASS: frontmatter tests (#{framework_files.length} framework files)")
