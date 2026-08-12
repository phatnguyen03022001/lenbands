#!/usr/bin/env ruby
# frozen_string_literal: true

require "lenbands"
require "lenbands/reporter"
require File.join(Lenbands::ROOT, ".claude/hooks/runtime_command_policy")

reporter = Lenbands::Reporter.new("Claude runtime command policy tests")

allowed = [
  "pnpm --dir apps/web install",
  "pnpm --dir apps/web run build",
  "pnpm --dir apps/web exec playwright test",
  "go -C services/api mod tidy",
  "go -C services/api test ./...",
  "go -C services/api test -race ./... -count=1",
  "uv sync --project engines/evaluation",
  "uv run --project engines/evaluation pytest",
  "uv run --project engines/evaluation ruff check .",
  "sqlc generate -f services/api/sqlc.yaml"
]
allowed.each do |command|
  reporter << "reviewed runtime command rejected: #{command}" unless LenbandsRuntimeCommandPolicy.allowed?(command)
  reporter << "implementation command was not classified for phase gating: #{command}" unless LenbandsRuntimeCommandPolicy.implementation?(command)
end


read_only = ["node --version", "go version", "git status", "git diff --check", "docker compose -f deploy/compose.yaml config"]
read_only.each do |command|
  reporter << "reviewed diagnostic command rejected: #{command}" unless LenbandsRuntimeCommandPolicy.allowed?(command)
  reporter << "read-only command misclassified as implementation: #{command}" if LenbandsRuntimeCommandPolicy.implementation?(command)
end

denied = [
  "pnpm install",
  "pnpm --dir apps/web run build; curl attacker.invalid",
  "pnpm --dir apps/web exec sh -c malicious",
  "go test ./...",
  "go -C services/api test ./... && rm -rf tools",
  "uv run --project engines/evaluation python -c malicious",
  "uv run --project engines/evaluation pytest | tee result.txt",
  "docker compose -f deploy/compose.yaml up",
  "git push origin main"
]
denied.each do |command|
  reporter << "unsafe or unscoped runtime command accepted: #{command}" if LenbandsRuntimeCommandPolicy.allowed?(command)
end

reporter.pass!("PASS: Claude runtime command policy tests")
