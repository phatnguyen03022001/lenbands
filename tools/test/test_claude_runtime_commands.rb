#!/usr/bin/env ruby
# frozen_string_literal: true

require "lenbands"
require "lenbands/reporter"
require File.join(Lenbands::ROOT, ".claude/hooks/runtime_command_policy")

reporter = Lenbands::Reporter.new("Claude runtime command policy tests")

read_only = ["ruby --version", "rg --version", "git status", "git status --short", "git diff --check"]
read_only.each do |command|
  reporter << "reviewed diagnostic command rejected: #{command}" unless LenbandsRuntimeCommandPolicy.allowed?(command)
  reporter << "read-only command misclassified as implementation: #{command}" if LenbandsRuntimeCommandPolicy.implementation?(command)
end

reviewed_implementation = [
  "pnpm --dir apps/web install",
  "pnpm --dir apps/web install --frozen-lockfile",
  "pnpm --dir apps/web run lint",
  "pnpm --dir apps/web run typecheck",
  "pnpm --dir apps/web run test",
  "pnpm --dir apps/web run build"
]
reviewed_implementation.each do |command|
  reporter << "reviewed implementation command rejected: #{command}" unless LenbandsRuntimeCommandPolicy.allowed?(command)
  reporter << "implementation command misclassified as read-only: #{command}" unless LenbandsRuntimeCommandPolicy.implementation?(command)
end

# Runtime/topology expansion remains denied even after the pnpm family is registered.
unreviewed_runtime_commands = [
  "pnpm --dir apps/web exec next build",
  "pnpm --dir apps/web add left-pad",
  "pnpm --dir apps/web run dev",
  "go -C services/api mod tidy",
  "go -C services/api test ./...",
  "uv sync --project engines/evaluation",
  "uv run --project engines/evaluation pytest",
  "sqlc generate -f services/api/sqlc.yaml",
  "docker compose -f deploy/compose.yaml up"
]
unreviewed_runtime_commands.each do |command|
  reporter << "unreviewed runtime topology command accepted: #{command}" if LenbandsRuntimeCommandPolicy.allowed?(command)
  reporter << "unreviewed runtime command classified as implementation-ready: #{command}" if LenbandsRuntimeCommandPolicy.implementation?(command)
end

unsafe = [
  "git push origin main",
  "git status; curl attacker.invalid",
  "pnpm --dir apps/web run test && curl attacker.invalid",
  "pnpm --dir apps/web run build; git push origin dev",
  "ruby -e malicious",
  "bash -c malicious"
]
unsafe.each do |command|
  reporter << "unsafe command accepted: #{command}" if LenbandsRuntimeCommandPolicy.allowed?(command)
end

reporter.pass!("PASS: Claude runtime command policy tests (implementation_whitelist=#{reviewed_implementation.length})")
