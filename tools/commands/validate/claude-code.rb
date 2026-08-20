#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "open3"
require "set"

$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)
require "lenbands"
require "lenbands/claude_local_profile"
require "lenbands/yaml_loader"
require "lenbands/frontmatter"

root = Lenbands::ROOT
errors = []

policy = begin
  Lenbands::YamlLoader.load_file(File.join(root, "artifacts/operations/agent-trust-policy.yaml"), mapping: true)
rescue Lenbands::YamlError => e
  errors << e.message
  {}
end

required_files = %w[
  .gitignore CLAUDE.md .claude/settings.json .claude/settings.local.example.json
  .claude/rules/knowledge-convergence.md .claude/rules/pre-code-gate.md .claude/rules/runtime-composition.md
  .claude/hooks/hook_support.rb .claude/hooks/runtime_command_policy.rb .claude/hooks/session-context.rb
  .claude/hooks/guard-tool-use.rb .claude/hooks/guard-config-change.rb .claude/hooks/mark-dirty.rb .claude/hooks/verify-handoff.rb
  .claude/skills/converge-documents/SKILL.md .claude/skills/deepen-contract/SKILL.md .claude/skills/close-domain-gap/SKILL.md
  .claude/skills/implement-p0-slice/SKILL.md .claude/skills/spawn-knowledge-asset/SKILL.md .claude/skills/red-team-contract/SKILL.md
  .claude/skills/handoff/SKILL.md
  .claude/agents/repo-cartographer.md .claude/agents/ielts-semantics-auditor.md .claude/agents/contract-deepener.md
  .claude/agents/runtime-composer.md .claude/agents/nextjs-implementer.md .claude/agents/go-backend-implementer.md
  .claude/agents/python-evaluation-implementer.md .claude/agents/runtime-integration-verifier.md
  .claude/agents/red-team-reviewer.md .claude/agents/verification-auditor.md
]
required_files.each { |relative| errors << "Claude Code file missing: #{relative}" unless File.file?(File.join(root, relative)) }

claude_md = File.file?(File.join(root, "CLAUDE.md")) ? File.read(File.join(root, "CLAUDE.md")) : ""
errors << "CLAUDE.md must import AGENTS.md" unless claude_md.lines.any? { |line| line.strip == "@AGENTS.md" }
errors << "CLAUDE.md exceeds the 200-line adherence budget" if claude_md.lines.length > 200
[
  "Knowledge must converge", "auto-memory", "unknown_*", "family-scoped", "exact reviewed", "gate toolchain", "gate p0",
  "release readiness", "data-migration-contract.yaml", "critical-path-usability-contract.yaml"
].each { |marker| errors << "CLAUDE.md missing invariant: #{marker}" unless claude_md.include?(marker) }
errors << "CLAUDE.md must not require global all-180 completion for one family" if claude_md.match?(/all 180 capabilities.*before implement/i)

phase_gate = policy.dig("application_builder", "phase_gate")
unless phase_gate.is_a?(Hash)
  errors << "agent trust policy application phase gate must be a mapping"
  phase_gate = {}
end
errors << "Claude phase must use family_scoped_authorization" unless phase_gate["state"] == "family_scoped_authorization"
errors << "repository default source mutation must remain locked" unless phase_gate["source_mutation"] == "locked"
errors << "family-scoped policy must permit bounded family unlock" unless phase_gate["partial_pack_unlock_allowed"] == true
errors << "repository must contain no active implementation authorization" unless phase_gate["repository_authorization_state"] == "none"
errors << "repository tree must not self-authorize" unless phase_gate["repository_tree_may_self_authorize"] == false
errors << "locked source roots drifted" unless phase_gate["locked_source_roots"] == %w[apps services engines]
errors << "eligibility contract drifted" unless phase_gate["canonical_eligibility_contract"] == "artifacts/operations/implementation-eligibility.yaml"
errors << "change-governance contract drifted" unless phase_gate["canonical_change_governance"] == "artifacts/operations/change-governance.yaml"

auth_source = phase_gate["authorization_source"]
unless auth_source.is_a?(Hash)
  errors << "authorization_source must be a mapping"
  auth_source = {}
end
errors << "implementation authorization must be external runtime context" unless auth_source["mode"] == "external_runtime_context"
errors << "authorization must not persist in repository" unless auth_source["repository_persistence"] == "forbidden"
required_bindings = %w[family_id authorization_base_sha source_scopes founder_authorization_ref authorization_attestation_ref]
errors << "authorization binding set drifted" unless Array(auth_source["required_bindings"]) == required_bindings
expected_env = {
  "family_id" => "LENBANDS_IMPLEMENTATION_FAMILY",
  "authorization_base_sha" => "LENBANDS_IMPLEMENTATION_BASE_SHA",
  "source_scopes" => "LENBANDS_IMPLEMENTATION_SOURCE_SCOPES",
  "founder_authorization_ref" => "LENBANDS_FOUNDER_AUTHORIZATION_REF",
  "authorization_attestation_ref" => "LENBANDS_IMPLEMENTATION_AUTHORIZATION_REF"
}
errors << "external authorization environment contract drifted" unless auth_source["environment_contract"] == expected_env
required_family_unlocks = Set.new(%w[
  family_is_implementation_eligible exact_authorization_base_sha_matches_repository_head_at_session_start
  family_id_is_declared source_scopes_are_declared_and_within_allowed_workspace founder_authorization_ref_is_external_and_nonempty
  authorization_attestation_ref_is_external_and_nonempty no_implementation_blocking_risk_for_family protected_paths_remain_locked
])
errors << "family authorization requirements incomplete" unless Set.new(Array(phase_gate["unlock_requires_per_family"])) == required_family_unlocks
errors << "legacy global unlock_requires must be removed" if phase_gate.key?("unlock_requires")

settings = {}
begin
  settings = JSON.parse(File.read(File.join(root, ".claude/settings.json")))
rescue StandardError => e
  errors << "invalid .claude/settings.json: #{e.message}"
end
expected_setting_keys = %w[$schema autoMemoryEnabled disableWorkflows workflowSizeGuideline fileCheckpointingEnabled disableArtifact disableClaudeAiConnectors disableSkillShellExecution skillOverrides permissions sandbox hooks]
errors << "Claude settings root keys drifted" unless settings.keys.sort == expected_setting_keys.sort
errors << "Claude project auto-memory must be disabled" unless settings["autoMemoryEnabled"] == false
errors << "Claude settings must pin SchemaStore" unless settings["$schema"] == "https://json.schemastore.org/claude-code-settings.json"
errors << "Claude file checkpointing must remain enabled" unless settings["fileCheckpointingEnabled"] == true
errors << "Claude artifacts must remain disabled" unless settings["disableArtifact"] == true
errors << "Claude AI connectors must remain disabled" unless settings["disableClaudeAiConnectors"] == true
errors << "Claude skill shell execution must remain disabled" unless settings["disableSkillShellExecution"] == true
errors << "Claude skillOverrides must disable user claude-api shadow" unless settings["skillOverrides"] == {"claude-api" => "off"}

permissions = settings["permissions"]
unless permissions.is_a?(Hash)
  errors << "Claude permissions must be a mapping"
  permissions = {}
end
errors << "Claude permission keys drifted" unless permissions.keys.sort == %w[allow defaultMode deny disableAutoMode disableBypassPermissionsMode].sort
errors << "Claude default permission mode must remain default" unless permissions["defaultMode"] == "default"
errors << "Claude bypass-permissions mode must be disabled" unless permissions["disableBypassPermissionsMode"] == "disable"
errors << "Claude auto mode must be disabled" unless permissions["disableAutoMode"] == "disable"
expected_allows = [
  "Bash",
  "Bash(tools/bin/lenbands doctor)", "Bash(tools/bin/lenbands verify)",
  "Bash(tools/bin/lenbands gate toolchain)", "Bash(tools/bin/lenbands gate p0)", "Bash(tools/bin/lenbands gate repository)",
  "Bash(tools/bin/lenbands context)", "Bash(tools/bin/lenbands context --yaml)",
  "Bash(tools/bin/lenbands validate all)", "Bash(tools/bin/lenbands validate tooling)",
  "Bash(tools/bin/lenbands validate trust-boundary)", "Bash(tools/bin/lenbands validate phase-index)",
  "Bash(tools/bin/lenbands validate documents)", "Bash(tools/bin/lenbands validate framework)",
  "Bash(tools/bin/lenbands validate knowledge-assets)", "Bash(tools/bin/lenbands validate openapi)",
  "Bash(tools/bin/lenbands validate semantic-contracts)", "Bash(tools/bin/lenbands validate contract-ownership)",
  "Bash(tools/bin/lenbands validate domain-automation)", "Bash(tools/bin/lenbands validate evidence-lineage)",
  "Bash(tools/bin/lenbands validate platform-boundary)", "Bash(tools/bin/lenbands validate spawn-prompts)",
  "Bash(tools/bin/lenbands validate benchmark-contracts)", "Bash(tools/bin/lenbands validate implementation-catalog)",
  "Bash(tools/bin/lenbands validate claude-code)", "Bash(tools/bin/lenbands generate all --check)"
]
errors << "Claude permission allow list drifted" unless Array(permissions["allow"]) == expected_allows
expected_denies = [
  "Artifact", "Workflow", "EnterWorktree", "MultiEdit", "Monitor", "PowerShell", "mcp__*",
  "Skill(implement-p0-slice)", "Agent(runtime-composer)", "Agent(nextjs-implementer)",
  "Agent(go-backend-implementer)", "Agent(python-evaluation-implementer)", "Agent(runtime-integration-verifier)",
  "Read(**/.env)", "Read(**/.env.*)", "Read(**/secrets/**)", "Read(~/.ssh/**)", "Read(~/.aws/**)",
  "Read(~/.config/gcloud/**)", "Read(~/.kube/**)", "Bash(rm *)", "Bash(git push *)", "Bash(git reset *)",
  "Bash(git clean *)", "Bash(git checkout *)", "Bash(git restore *)"
]
errors << "Claude permission deny list drifted" unless Array(permissions["deny"]) == expected_denies
errors << "Claude permission deny list contains duplicates" unless Array(permissions["deny"]).uniq.length == Array(permissions["deny"]).length

sandbox = settings["sandbox"]
unless sandbox.is_a?(Hash)
  errors << "Claude sandbox must be a mapping"
  sandbox = {}
end
errors << "Claude sandbox keys drifted" unless sandbox.keys.sort == %w[allowUnsandboxedCommands autoAllowBashIfSandboxed credentials enabled failIfUnavailable filesystem network].sort
errors << "Claude sandbox must remain enabled/fail-closed" unless sandbox["enabled"] == true && sandbox["failIfUnavailable"] == true
errors << "Claude sandbox must not auto-allow Bash" unless sandbox["autoAllowBashIfSandboxed"] == false
errors << "Claude sandbox must forbid unsandboxed commands" unless sandbox["allowUnsandboxedCommands"] == false
filesystem = sandbox["filesystem"] || {}
errors << "Claude sandbox filesystem keys drifted" unless filesystem.keys.sort == %w[denyRead denyWrite].sort
errors << "Claude sandbox must not open allowWrite roots" if filesystem.key?("allowWrite")
expected_deny_writes = %w[./.claude ./.claude-plugin ./.git ./.github ./AGENTS.md ./CLAUDE.md ./blueprint ./tools]
errors << "Claude sandbox denyWrite drifted" unless Array(filesystem["denyWrite"]) == expected_deny_writes
expected_deny_reads = %w[./.env ./.env.* ./**/.env ./**/.env.* ./secrets ./**/secrets ~/.ssh ~/.aws ~/.config/gcloud ~/.kube]
errors << "Claude sandbox denyRead drifted" unless Array(filesystem["denyRead"]) == expected_deny_reads
network = sandbox["network"] || {}
errors << "Claude sandbox network keys drifted" unless network.keys == ["allowedDomains"]
expected_domains = %w[registry.npmjs.org proxy.golang.org sum.golang.org pypi.org files.pythonhosted.org github.com api.github.com raw.githubusercontent.com]
errors << "Claude sandbox build-domain allowlist drifted" unless network["allowedDomains"] == expected_domains
credentials = sandbox["credentials"] || {}
errors << "Claude sandbox credential keys drifted" unless credentials.keys.sort == %w[envVars files].sort
expected_credential_files = expected_deny_reads.first(6).map { |path| {"path" => path, "mode" => "deny"} }
errors << "Claude credential file policy drifted" unless credentials["files"] == expected_credential_files
expected_secret_env = %w[
  ANTHROPIC_AUTH_TOKEN ANTHROPIC_API_KEY DEEPSEEK_API_KEY OPENAI_API_KEY AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
  AWS_SESSION_TOKEN GOOGLE_APPLICATION_CREDENTIALS DATABASE_URL GH_TOKEN GITHUB_TOKEN CLOUDFLARE_API_TOKEN NEON_API_KEY
  SUPABASE_ACCESS_TOKEN VERCEL_TOKEN
].map { |name| {"name" => name, "mode" => "deny"} }
errors << "Claude secret environment policy drifted" unless credentials["envVars"] == expected_secret_env

stable_cli = File.join(root, "tools/bin/lenbands")
if File.file?(stable_cli)
  body = File.read(stable_cli)
  errors << "stable CLI must export workspace-local TMPDIR" unless body.include?('export TMPDIR="$lenbands_scratch"')
  errors << "stable CLI scratch root must be non-authoritative" unless body.include?('artifacts/operations/.tmp')
end

gitignore = File.readlines(File.join(root, ".gitignore"), chomp: true)
%w[.claude/settings.local.json .claude/worktrees/].each { |entry| errors << ".gitignore must contain #{entry}" unless gitignore.include?(entry) }

local_template = {}
begin
  local_template = JSON.parse(File.read(File.join(root, ".claude/settings.local.example.json")))
  errors.concat(Lenbands::ClaudeLocalProfile.validate(profile: local_template, policy: policy).map { |e| "local template: #{e}" })
rescue StandardError => e
  errors << "invalid local settings template: #{e.message}"
end
local_profile_state = "absent"
local_path = File.join(root, ".claude/settings.local.json")
if File.file?(local_path)
  local_profile_state = "founder-flash"
  begin
    local_profile = JSON.parse(File.read(local_path))
    errors.concat(Lenbands::ClaudeLocalProfile.validate(profile: local_profile, policy: policy).map { |e| "local profile: #{e}" })
    errors << "founder local profile must match reviewed template" unless local_profile == local_template
  rescue StandardError => e
    errors << "invalid founder local profile: #{e.message}"
  end
end

shadow_paths = [File.join(root, ".mcp.json")] + Dir.glob(File.join(root, "**/CLAUDE.local.md"), File::FNM_DOTMATCH)
shadow_paths.select { |path| File.file?(path) }.each { |path| errors << "bounded profile forbids local shadow surface: #{path.delete_prefix(root + '/')}" }

git_present = File.exist?(File.join(root, ".git"))
if git_present
  errors << "Claude workflow size guideline must remain small" unless settings["workflowSizeGuideline"] == "small"
else
  errors << "Claude workflows must remain disabled without Git/worktree isolation" unless settings["disableWorkflows"] == true
  errors << "saved workflows forbidden without Git/worktree isolation" unless Dir.glob(File.join(root, ".claude/workflows/*")).empty?
end

hooks = settings["hooks"]
unless hooks.is_a?(Hash)
  errors << "Claude hooks must be a mapping"
  hooks = {}
end
required_hooks = {
  "SessionStart" => [nil, "session-context.rb", 30],
  "PreToolUse" => ["Write|Edit|MultiEdit|NotebookEdit|Bash|PowerShell|Monitor", "guard-tool-use.rb", 10],
  "PostToolUse" => ["Write|Edit|MultiEdit|NotebookEdit", "mark-dirty.rb", 10],
  "Stop" => [nil, "verify-handoff.rb", 180],
  "ConfigChange" => ["project_settings|local_settings|skills", "guard-config-change.rb", 10]
}
errors << "Claude hook event set drifted" unless hooks.keys.sort == required_hooks.keys.sort
required_hooks.each do |event, (matcher, basename, timeout)|
  declarations = Array(hooks[event])
  errors << "Claude #{event} must have exactly one declaration" unless declarations.length == 1
  entry = declarations.first
  next unless entry.is_a?(Hash)
  expected_keys = matcher ? %w[hooks matcher] : %w[hooks]
  errors << "Claude #{event} declaration keys drifted" unless entry.keys.sort == expected_keys.sort
  errors << "Claude #{event} matcher drifted" unless entry["matcher"] == matcher
  command_hooks = Array(entry["hooks"])
  errors << "Claude #{event} must have exactly one command hook" unless command_hooks.length == 1
  hook = command_hooks.first
  next unless hook.is_a?(Hash)
  errors << "Claude #{event} hook keys drifted" unless hook.keys.sort == %w[args command timeout type]
  errors << "Claude #{event} command drifted" unless hook["command"] == "${CLAUDE_PROJECT_DIR}/.claude/hooks/#{basename}"
  errors << "Claude #{event} hook type drifted" unless hook["type"] == "command"
  errors << "Claude #{event} hook args must be empty" unless hook["args"] == []
  errors << "Claude #{event} timeout drifted" unless hook["timeout"] == timeout
end

hook_files = required_files.grep(%r{\A\.claude/hooks/}).reject { |p| %w[hook_support.rb runtime_command_policy.rb].include?(File.basename(p)) }
hook_files.each do |relative|
  path = File.join(root, relative)
  next unless File.file?(path)
  errors << "Claude hook is not executable: #{relative}" unless File.executable?(path)
  _out, err, status = Open3.capture3("ruby", "-c", path)
  errors << "Claude hook syntax invalid #{relative}: #{err}" unless status.success?
end

expected_skills = %w[close-domain-gap converge-documents deepen-contract handoff implement-p0-slice red-team-contract spawn-knowledge-asset]
skill_names = []
Dir.glob(File.join(root, ".claude/skills/*/SKILL.md")).sort.each do |path|
  data, error = Lenbands::Frontmatter.parse(path)
  relative = path.delete_prefix(root + "/")
  if error
    errors << "#{relative}: invalid frontmatter: #{error}"
    next
  end
  name = data["name"]
  skill_names << name
  errors << "#{relative}: skill name must match directory" unless name == File.basename(File.dirname(path))
  errors << "#{relative}: description missing" if data["description"].to_s.empty?
  errors << "#{relative}: allowed-tools missing" if data["allowed-tools"].to_s.empty? && !data["allowed-tools"].is_a?(Array)
end
errors << "Claude skill set mismatch" unless skill_names.sort == expected_skills

expected_agents = %w[
  contract-deepener go-backend-implementer ielts-semantics-auditor nextjs-implementer python-evaluation-implementer
  red-team-reviewer repo-cartographer runtime-composer runtime-integration-verifier verification-auditor
]
flash_workers = %w[go-backend-implementer nextjs-implementer python-evaluation-implementer runtime-integration-verifier]
read_only_agents = %w[ielts-semantics-auditor red-team-reviewer repo-cartographer]
agent_names = []
Dir.glob(File.join(root, ".claude/agents/*.md")).sort.each do |path|
  data, error = Lenbands::Frontmatter.parse(path)
  relative = path.delete_prefix(root + "/")
  if error
    errors << "#{relative}: invalid frontmatter: #{error}"
    next
  end
  name = data["name"]
  agent_names << name
  errors << "#{relative}: agent name must match filename" unless name == File.basename(path, ".md")
  errors << "#{relative}: description missing" if data["description"].to_s.empty?
  expected_model = flash_workers.include?(name) ? "haiku" : "inherit"
  errors << "#{relative}: model routing drifted" unless data["model"] == expected_model
  errors << "#{relative}: effort must be high" unless data["effort"] == "high"
  errors << "#{relative}: persistent agent memory forbidden" if data.key?("memory")
  tools = data["tools"].is_a?(Array) ? data["tools"] : data["tools"].to_s.split(/\s*,\s*/)
  forbidden = tools & %w[Edit Write MultiEdit NotebookEdit Bash PowerShell Monitor]
  errors << "#{relative}: read-only agent exposes #{forbidden.join(', ')}" if read_only_agents.include?(name) && !forbidden.empty?
end
errors << "Claude agent set mismatch" unless agent_names.sort == expected_agents

session_body = File.read(File.join(root, ".claude/hooks/session-context.rb"))
errors << "session context must announce family-scoped authorization" unless session_body.include?("family-scoped authorization")
errors << "session context must announce default locked state" unless session_body.include?("application source remains locked")
errors << "locked session must not provision runtime build caches" if session_body.match?(/GOMODCACHE|GOCACHE|UV_CACHE_DIR|npm_config_store_dir/)

protected = Array(policy["protected_paths"])
%w[
  **/CLAUDE.md **/CLAUDE.local.md **/AGENTS.md **/.mcp.json .git/** .claude/** .claude-plugin/** blueprint/** tools/** .github/**
  artifacts/operations/problem-risk-registry.yaml artifacts/operations/build-readiness-matrix.md artifacts/operations/acceptance/**
  artifacts/operations/benchmark/** artifacts/engineering/api/** artifacts/engineering/runtime-contract.yaml
  artifacts/engineering/data-migration-contract.yaml artifacts/experience/critical-path-usability-contract.yaml
].each { |pattern| errors << "agent trust policy must protect #{pattern}" unless protected.include?(pattern) }

framework_readme = File.read(File.join(root, "blueprint/framework/README.md"))
framework_version = framework_readme[/framework_version:\s*(\d+\.\d+\.\d+)/, 1]
agents_body = File.read(File.join(root, "AGENTS.md"))
declared_version = agents_body[/Framework IELTS v(\d+\.\d+\.\d+)/, 1]
errors << "AGENTS.md framework version drifted" unless declared_version == framework_version

codeowners = File.read(File.join(root, ".github/CODEOWNERS"))
errors << "CODEOWNERS must protect CLAUDE.md" unless codeowners.match?(%r{^/CLAUDE\.md\s}i)
errors << "CODEOWNERS must protect .claude" unless codeowners.match?(%r{^/\.claude/\s}i)

guard = File.join(root, ".claude/hooks/guard-tool-use.rb")
if File.executable?(guard)
  invoke = lambda do |tool_name, tool_input, extra_env = {}|
    payload = JSON.generate("session_id" => "validator-session", "hook_event_name" => "PreToolUse", "tool_name" => tool_name, "tool_input" => tool_input)
    Open3.capture3({"CLAUDE_PROJECT_DIR" => root}.merge(extra_env), guard, stdin_data: payload, chdir: root)
  end
  deny = lambda do |tool_name, tool_input, label, env = {}|
    stdout, stderr, status = invoke.call(tool_name, tool_input, env)
    errors << "Claude guard failed to deny #{label}: #{stdout}#{stderr}" unless status.success? && stdout.include?(%q{"permissionDecision":"deny"})
  end
  allow = lambda do |tool_name, tool_input, label, env = {}|
    stdout, stderr, status = invoke.call(tool_name, tool_input, env)
    errors << "Claude guard rejected #{label}: #{stdout}#{stderr}" unless status.success? && stdout.empty?
  end

  deny.call("Write", {"file_path" => File.join(root, "tools/README.md")}, "protected tooling write")
  %w[apps/web/CLAUDE.md apps/web/CLAUDE.local.md apps/web/AGENTS.md .mcp.json .git/config].each do |relative|
    deny.call("Write", {"file_path" => File.join(root, relative)}, "instruction/config injection #{relative}")
  end
  allow.call("Write", {"file_path" => File.join(root, "artifacts/engineering/contracts/agent-probe.md")}, "bounded artifact write")
  %w[apps/web/phase-probe.ts services/api/phase-probe.go engines/evaluation/phase_probe.py].each do |relative|
    deny.call("Write", {"file_path" => File.join(root, relative)}, "unauthorized source write #{relative}")
  end

  head, head_status = Open3.capture2("git", "rev-parse", "HEAD", chdir: root)
  if head_status.success?
    auth_env = {
      "LENBANDS_IMPLEMENTATION_FAMILY" => "P0-03",
      "LENBANDS_IMPLEMENTATION_BASE_SHA" => head.strip,
      "LENBANDS_IMPLEMENTATION_SOURCE_SCOPES" => "apps/web",
      "LENBANDS_FOUNDER_AUTHORIZATION_REF" => "external://validator/founder",
      "LENBANDS_IMPLEMENTATION_AUTHORIZATION_REF" => "external://validator/authorization"
    }
    # External-looking refs plus exact HEAD are necessary but not sufficient. Current P0
    # family contracts remain review, so the guard must fail closed on repository eligibility.
    deny.call("Write", {"file_path" => File.join(root, "apps/web/phase-probe.ts")}, "externally referenced but repository-ineligible family source write", auth_env)
    deny.call("Write", {"file_path" => File.join(root, "services/api/phase-probe.go")}, "out-of-scope service write", auth_env)
    deny.call("Write", {"file_path" => File.join(root, "apps/web/AGENTS.md")}, "protected source instruction write", auth_env)
    deny.call("Bash", {"command" => "pnpm --dir apps/web run build"}, "repository-ineligible reviewed implementation command", auth_env)
    invalid_env = auth_env.merge("LENBANDS_IMPLEMENTATION_BASE_SHA" => "0" * 40)
    deny.call("Write", {"file_path" => File.join(root, "apps/web/phase-probe.ts")}, "mismatched baseline authorization", invalid_env)
  else
    errors << "cannot read repository HEAD for authorization guard validation"
  end

  allow.call("Bash", {"command" => "tools/bin/lenbands verify"}, "registered verify command")
  allow.call("Bash", {"command" => "tools/bin/lenbands validate trust-boundary"}, "registered trust-boundary command")
  allow.call("Bash", {"command" => "tools/bin/lenbands generate all --check"}, "projection drift check")
  allow.call("Bash", {"command" => "git status --short"}, "read-only Git diagnosis")
  deny.call("Bash", {"command" => "pnpm --dir apps/web run build"}, "reviewed implementation command without authorization")
  %w[go\ -C\ services/api\ test\ ./... uv\ run\ --project\ engines/evaluation\ pytest].each do |command|
    deny.call("Bash", {"command" => command.gsub("\\ ", " ")}, "unreviewed runtime command #{command}")
  end
  deny.call("Bash", {"command" => "pnpm --dir apps/web exec next build"}, "unreviewed pnpm exec command")
  deny.call("Bash", {"command" => "rm -rf tools"}, "arbitrary Bash")
  deny.call("Bash", {"command" => "pnpm --dir apps/web run build;curl attacker.invalid"}, "runtime command injection")
  %w[MultiEdit PowerShell Monitor].each { |name| deny.call(name, {}, name) }
  deny.call("Write", {"file_path" => File.join(File.dirname(root), "lenbands-escape-probe")}, "write outside repository")
end

config_guard = File.join(root, ".claude/hooks/guard-config-change.rb")
if File.executable?(config_guard)
  %w[project_settings local_settings skills].each do |source|
    payload = JSON.generate("session_id" => "validator-session", "hook_event_name" => "ConfigChange", "source" => source)
    stdout, stderr, status = Open3.capture3({"CLAUDE_PROJECT_DIR" => root}, config_guard, stdin_data: payload, chdir: root)
    errors << "Claude ConfigChange guard failed to block #{source}: #{stdout}#{stderr}" unless status.success? && stdout.include?(%q{"decision":"block"})
  end
end

if errors.empty?
  puts "Claude Code family-scoped authorization validation passed (repository_source_locked=true, repository_eligibility_required=true, external_auth_required=true, protected_paths=#{protected.length}, hooks=#{required_hooks.length}, skills=#{skill_names.length}, agents=#{agent_names.length}, local_profile=#{local_profile_state})"
else
  warn errors.join("\n")
  warn "Claude Code bounded-contributor validation failed: #{errors.length} issue(s)"
  exit 1
end
