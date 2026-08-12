#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "open3"
require "tempfile"
require "yaml"
require "lenbands"
require "lenbands/claude_local_profile"
require "lenbands/yaml_loader"

root = File.expand_path("../..", __dir__)
errors = []
settings = JSON.parse(File.read(File.join(root, ".claude/settings.json")))
local_template = JSON.parse(File.read(File.join(root, ".claude/settings.local.example.json")))
local_profile_path = File.join(root, ".claude/settings.local.json")
local_profile = File.file?(local_profile_path) ? JSON.parse(File.read(local_profile_path)) : nil
policy = Lenbands::YamlLoader.load_file(File.join(root, "artifacts/operations/agent-trust-policy.yaml"), mapping: true)
validate_local = ->(candidate) { Lenbands::ClaudeLocalProfile.validate(profile: candidate, policy: policy) }
copy = ->(value) { Marshal.load(Marshal.dump(value)) }

errors << "Claude SchemaStore contract is not pinned" unless settings["$schema"] == "https://json.schemastore.org/claude-code-settings.json"
errors.concat(validate_local.call(local_template).map { |error| "founder local template rejected: #{error}" })
if local_profile
  errors << "founder local profile drifted from reviewed template" unless local_profile == local_template
  errors.concat(validate_local.call(local_profile).map { |error| "founder local profile rejected: #{error}" })
end
errors << "founder local profile is not ignored" unless File.readlines(File.join(root, ".gitignore"), chomp: true).include?(".claude/settings.local.json")

unsafe_root = copy.call(local_template)
unsafe_root["sandbox"] = {"enabled" => false}
errors << "local sandbox override was accepted" unless validate_local.call(unsafe_root).any? { |error| error.include?("unreviewed root keys") }

secret_profile = copy.call(local_template)
secret_profile["env"]["ANTHROPIC_AUTH_TOKEN"] = "must-not-live-here"
errors << "local credential was accepted" unless validate_local.call(secret_profile).any? { |error| error.include?("must not store secrets") }

max_effort_profile = copy.call(local_template)
max_effort_profile["env"]["CLAUDE_CODE_EFFORT_LEVEL"] = "max"
errors << "global max-effort override was accepted" unless validate_local.call(max_effort_profile).any? { |error| error.include?("unreviewed env keys") }

misleading_effort_profile = copy.call(local_template)
misleading_effort_profile["effortLevel"] = "medium"
errors << "DeepSeek medium-effort alias was accepted" unless validate_local.call(misleading_effort_profile).any? { |error| error.include?("effort must be high") }

latest_update_profile = copy.call(local_template)
latest_update_profile["autoUpdatesChannel"] = "latest"
errors << "unreviewed latest update channel was accepted" unless validate_local.call(latest_update_profile).any? { |error| error.include?("update channel must be stable") }

adaptive_claim_profile = copy.call(local_template)
adaptive_claim_profile["env"]["ANTHROPIC_DEFAULT_HAIKU_MODEL_SUPPORTED_CAPABILITIES"] = "effort,adaptive_thinking"
errors << "unsupported adaptive-thinking claim was accepted" unless validate_local.call(adaptive_claim_profile).any? { |error| error.include?("ANTHROPIC_DEFAULT_HAIKU_MODEL_SUPPORTED_CAPABILITIES") }

inherited_subagent_profile = copy.call(local_template)
inherited_subagent_profile["env"].delete("CLAUDE_CODE_SUBAGENT_MODEL")
errors << "unpinned subagent routing was accepted" unless validate_local.call(inherited_subagent_profile).any? { |error| error.include?("omits env keys") }

bypass_mode_profile = copy.call(local_template)
bypass_mode_profile["permissions"]["defaultMode"] = "bypassPermissions"
errors << "local bypass permission mode was accepted" unless validate_local.call(bypass_mode_profile).any? { |error| error.include?("permission mode must be acceptEdits") }

privileged_profile = copy.call(local_template)
privileged_profile["permissions"]["allow"] << "Bash(*)"
errors << "local arbitrary Bash permission was accepted" unless validate_local.call(privileged_profile).any? { |error| error.include?("may not pre-approve unreviewed privileged tools") }

unreviewed_web_profile = copy.call(local_template)
unreviewed_web_profile["permissions"]["allow"] << "WebFetch(domain:example.com)"
errors << "unreviewed WebFetch domain was accepted" unless validate_local.call(unreviewed_web_profile).any? { |error| error.include?("unreviewed allow rules") }
permissions = settings.fetch("permissions", {})
errors << "bypass permission mode is not disabled" unless permissions["disableBypassPermissionsMode"] == "disable"
errors << "auto permission mode is not disabled" unless permissions["disableAutoMode"] == "disable"
expected_allows = [
  "Bash",
  "Bash(tools/bin/lenbands doctor)",
  "Bash(tools/bin/lenbands verify)",
  "Bash(tools/bin/lenbands gate toolchain)",
  "Bash(tools/bin/lenbands gate p0)",
  "Bash(tools/bin/lenbands gate repository)",
  "Bash(tools/bin/lenbands context)",
  "Bash(tools/bin/lenbands context --yaml)",
  "Bash(tools/bin/lenbands validate all)",
  "Bash(tools/bin/lenbands validate tooling)",
  "Bash(tools/bin/lenbands validate trust-boundary)",
  "Bash(tools/bin/lenbands validate phase-index)",
  "Bash(tools/bin/lenbands validate documents)",
  "Bash(tools/bin/lenbands validate framework)",
  "Bash(tools/bin/lenbands validate knowledge-assets)",
  "Bash(tools/bin/lenbands validate openapi)",
  "Bash(tools/bin/lenbands validate semantic-contracts)",
  "Bash(tools/bin/lenbands validate contract-ownership)",
  "Bash(tools/bin/lenbands validate domain-automation)",
  "Bash(tools/bin/lenbands validate evidence-lineage)",
  "Bash(tools/bin/lenbands validate platform-boundary)",
  "Bash(tools/bin/lenbands validate spawn-prompts)",
  "Bash(tools/bin/lenbands validate benchmark-contracts)",
  "Bash(tools/bin/lenbands validate implementation-catalog)",
  "Bash(tools/bin/lenbands validate claude-code)",
  "Bash(tools/bin/lenbands generate all --check)"
]
errors << "bounded handoff allow rules drifted" unless Array(permissions["allow"]) == expected_allows
%w[Artifact Workflow EnterWorktree MultiEdit Monitor PowerShell].each do |tool|
  errors << "permission deny list omits #{tool}" unless Array(permissions["deny"]).include?(tool)
end
errors << "MCP tools are not denied by default" unless Array(permissions["deny"]).include?("mcp__*")
%w[Read(**/.env) Read(**/.env.*) Read(**/secrets/**) Read(~/.ssh/**) Read(~/.aws/**) Read(~/.config/gcloud/**) Read(~/.kube/**)].each do |rule|
  errors << "credential read deny list omits #{rule}" unless Array(permissions["deny"]).include?(rule)
end
errors << "skill shell execution remains enabled" unless settings["disableSkillShellExecution"] == true
errors << "user-level claude-api shadow is not disabled" unless settings["skillOverrides"] == {"claude-api" => "off"}

sandbox = settings.fetch("sandbox", {})
errors << "sandbox is not fail-closed" unless sandbox["enabled"] == true && sandbox["failIfUnavailable"] == true
errors << "unsandboxed command escape remains available" unless sandbox["allowUnsandboxedCommands"] == false
errors << "sandboxed Bash is incorrectly auto-allowed" unless sandbox["autoAllowBashIfSandboxed"] == false
errors << "sandbox opens external filesystem allowWrite roots" if sandbox.fetch("filesystem", {}).key?("allowWrite")
expected_deny_reads = %w[./.env ./.env.* ./**/.env ./**/.env.* ./secrets ./**/secrets ~/.ssh ~/.aws ~/.config/gcloud ~/.kube]
errors << "sandbox credential denyRead policy drifted" unless sandbox.fetch("filesystem", {})["denyRead"] == expected_deny_reads
expected_build_domains = %w[
  registry.npmjs.org proxy.golang.org sum.golang.org pypi.org files.pythonhosted.org
  github.com api.github.com raw.githubusercontent.com
]
errors << "sandbox build-domain allowlist drifted" unless sandbox.fetch("network", {})["allowedDomains"] == expected_build_domains
expected_secret_env_names = %w[
  ANTHROPIC_AUTH_TOKEN ANTHROPIC_API_KEY DEEPSEEK_API_KEY OPENAI_API_KEY
  AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN GOOGLE_APPLICATION_CREDENTIALS
  DATABASE_URL GH_TOKEN GITHUB_TOKEN CLOUDFLARE_API_TOKEN NEON_API_KEY
  SUPABASE_ACCESS_TOKEN VERCEL_TOKEN
]
credential_env_names = Array(sandbox.fetch("credentials", {})["envVars"]).map { |entry| entry["name"] }
errors << "sandbox secret environment policy drifted" unless credential_env_names == expected_secret_env_names
expected_tmpdir = File.join(root, "artifacts/operations/.tmp")
errors << "stable CLI did not provide workspace-local TMPDIR" unless File.expand_path(Dir.tmpdir) == expected_tmpdir
begin
  Tempfile.create("lenbands-claude-hardening") do |file|
    file.write("sandbox-temp-regression\n")
    file.flush
    errors << "temporary-file regression probe did not persist" unless File.size(file.path).positive?
  end
rescue SystemCallError => e
  errors << "workspace temporary-file regression probe failed at #{Dir.tmpdir}: #{e.class}: #{e.message}"
end

run = ->(*command, stdin_data: "") do
  Open3.capture3({"CLAUDE_PROJECT_DIR" => root}, *command, stdin_data: stdin_data, chdir: root)
end

stdout, stderr, status = run.call("tools/bin/lenbands", "validate", "claude-code")
errors << "Claude Code contract validator failed: #{stdout}#{stderr}" unless status.success?

tool_guard = File.join(root, ".claude/hooks/guard-tool-use.rb")
%w[MultiEdit PowerShell Monitor].each do |tool_name|
  payload = JSON.generate(
    "session_id" => "hardening-regression",
    "hook_event_name" => "PreToolUse",
    "tool_name" => tool_name,
    "tool_input" => {}
  )
  stdout, stderr, status = run.call(tool_guard, stdin_data: payload)
  errors << "#{tool_name} bypass was not denied: #{stderr}" unless status.success? && stdout.include?(%q{"permissionDecision":"deny"})
end

config_guard = File.join(root, ".claude/hooks/guard-config-change.rb")
payload = JSON.generate(
  "session_id" => "hardening-regression",
  "hook_event_name" => "ConfigChange",
  "source" => "local_settings"
)
stdout, stderr, status = run.call(config_guard, stdin_data: payload)
errors << "local settings change was not blocked: #{stderr}" unless status.success? && stdout.include?(%q{"decision":"block"})

abort(errors.join("\n")) unless errors.empty?
puts "PASS: Claude Code hardening regression tests"
