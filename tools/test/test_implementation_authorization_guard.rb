#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "open3"
require "lenbands"
require "lenbands/reporter"

root = Lenbands::ROOT
reporter = Lenbands::Reporter.new("Implementation authorization guard tests")
guard = File.join(root, ".claude/hooks/guard-tool-use.rb")
head, head_status = Open3.capture2("git", "rev-parse", "HEAD", chdir: root)
reporter << "cannot resolve repository HEAD" unless head_status.success?
head = head.strip

run_guard = lambda do |tool_name, tool_input, env = {}|
  payload = JSON.generate(
    "session_id" => "implementation-authorization-regression",
    "hook_event_name" => "PreToolUse",
    "tool_name" => tool_name,
    "tool_input" => tool_input
  )
  Open3.capture3({"CLAUDE_PROJECT_DIR" => root}.merge(env), guard, stdin_data: payload, chdir: root)
end

denied = lambda do |stdout|
  stdout.include?(%q{"permissionDecision":"deny"}) || stdout.include?(%q{"decision":"block"})
end

# Registered pnpm commands are known to the command policy but unusable without bounded authorization.
stdout, stderr, status = run_guard.call("Bash", {"command" => "pnpm --dir apps/web run build"})
reporter << "implementation command escaped without authorization: #{stdout}#{stderr}" unless status.success? && denied.call(stdout)

# Opaque external references + exact HEAD are not enough: current family contracts are still review,
# so repository eligibility must fail closed rather than trusting environment variables alone.
external_context = {
  "LENBANDS_IMPLEMENTATION_FAMILY" => "P0-04",
  "LENBANDS_IMPLEMENTATION_BASE_SHA" => head,
  "LENBANDS_IMPLEMENTATION_SOURCE_SCOPES" => "apps/web",
  "LENBANDS_FOUNDER_AUTHORIZATION_REF" => "external-founder-approval:test",
  "LENBANDS_IMPLEMENTATION_AUTHORIZATION_REF" => "external-implementation-attestation:test"
}
stdout, stderr, status = run_guard.call("Bash", {"command" => "pnpm --dir apps/web run build"}, external_context)
reporter << "external env bypassed repository eligibility: #{stdout}#{stderr}" unless status.success? && denied.call(stdout)

stdout, stderr, status = run_guard.call("Write", {"file_path" => File.join(root, "apps/web/security-regression.tmp")}, external_context)
reporter << "source write escaped while family contracts remain unapproved: #{stdout}#{stderr}" unless status.success? && denied.call(stdout)

# A reviewed diagnostic command remains legitimate and does not need implementation authorization.
stdout, stderr, status = run_guard.call("Bash", {"command" => "git status --short"})
reporter << "read-only diagnostic command was denied: #{stdout}#{stderr}" unless status.success? && !denied.call(stdout)

reporter.pass!("PASS: implementation authorization guard tests")
