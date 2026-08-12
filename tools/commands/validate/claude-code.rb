#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "open3"
require "tmpdir"

$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)
require "lenbands"
require "lenbands/claude_local_profile"
require "lenbands/yaml_loader"
require "lenbands/frontmatter"

root = Lenbands::ROOT
errors = []
policy = {}
begin
  policy = Lenbands::YamlLoader.load_file(File.join(root, "artifacts/operations/agent-trust-policy.yaml"), mapping: true)
rescue Lenbands::YamlError => e
  errors << e.message
end
required_files = %w[
  .gitignore
  CLAUDE.md
  .claude/settings.json
  .claude/settings.local.example.json
  .claude/rules/knowledge-convergence.md
  .claude/rules/pre-code-gate.md
  .claude/rules/runtime-composition.md
  .claude/hooks/hook_support.rb
  .claude/hooks/runtime_command_policy.rb
  .claude/hooks/session-context.rb
  .claude/hooks/guard-tool-use.rb
  .claude/hooks/guard-config-change.rb
  .claude/hooks/mark-dirty.rb
  .claude/hooks/verify-handoff.rb
  .claude/skills/converge-documents/SKILL.md
  .claude/skills/deepen-contract/SKILL.md
  .claude/skills/close-domain-gap/SKILL.md
  .claude/skills/implement-p0-slice/SKILL.md
  .claude/skills/spawn-knowledge-asset/SKILL.md
  .claude/skills/red-team-contract/SKILL.md
  .claude/skills/handoff/SKILL.md
  .claude/agents/repo-cartographer.md
  .claude/agents/ielts-semantics-auditor.md
  .claude/agents/contract-deepener.md
  .claude/agents/runtime-composer.md
  .claude/agents/nextjs-implementer.md
  .claude/agents/go-backend-implementer.md
  .claude/agents/python-evaluation-implementer.md
  .claude/agents/runtime-integration-verifier.md
  .claude/agents/red-team-reviewer.md
  .claude/agents/verification-auditor.md
]
required_files.each do |relative|
  errors << "Claude Code file missing: #{relative}" unless File.file?(File.join(root, relative))
end

claude_md_path = File.join(root, "CLAUDE.md")
if File.file?(claude_md_path)
  claude_md = File.read(claude_md_path)
  errors << "CLAUDE.md must import AGENTS.md" unless claude_md.lines.any? { |line| line.strip == "@AGENTS.md" }
  errors << "CLAUDE.md exceeds the 200-line adherence budget" if claude_md.lines.length > 200
  %w[Knowledge\ must\ converge auto-memory unknown_* document_convergence no\ partial gate\ toolchain gate\ p0].each do |marker|
    marker = marker.gsub("\\ ", " ")
    errors << "CLAUDE.md missing invariant: #{marker}" unless claude_md.include?(marker)
  end
end

phase_gate = policy.dig("application_builder", "phase_gate")
unless phase_gate.is_a?(Hash)
  errors << "agent trust policy application phase gate must be a mapping"
  phase_gate = {}
end
errors << "Claude application phase must remain document_convergence" unless phase_gate["state"] == "document_convergence"
errors << "Claude source mutation must remain globally locked" unless phase_gate["source_mutation"] == "locked"
errors << "Claude pre-code gate cannot allow partial pack unlock" unless phase_gate["partial_pack_unlock_allowed"] == false
errors << "Claude pre-code gate must have zero unresolved-gap budget" unless phase_gate["unresolved_gap_budget"] == 0
errors << "Claude pre-code locked roots drifted" unless phase_gate["locked_source_roots"] == %w[apps services engines]
errors << "Claude locked phase cannot carry founder authorization" unless phase_gate["founder_authorization_ref"].nil?
errors << "Claude locked phase cannot carry completion attestation" unless phase_gate["completion_attestation_ref"].nil?
required_global_unlocks = %w[
  all_180_capabilities_semantically_complete_and_traceable
  all_roles_permissions_and_user_journeys_complete
  all_ielts_controlled_vocabularies_mapped_without_unknown_placeholders
  all_product_ux_state_and_accessibility_decisions_approved
  all_data_api_event_failure_privacy_and_security_contracts_approved
  all_learning_assessment_ai_governance_and_provider_boundaries_approved
  all_nfr_observability_operations_recovery_and_release_contracts_approved
  no_duplicate_or_ambiguous_canonical_owner
  no_draft_or_review_authority_required_by_the_application
  external_claims_have_citations_and_rights_or_provenance_state
  independent_semantic_and_red_team_audits_have_no_open_critical_or_high_findings
  explicit_global_founder_authorization
]
missing_global_unlocks = required_global_unlocks - Array(phase_gate["unlock_requires"])
errors << "Claude global document gate omits: #{missing_global_unlocks.join(', ')}" unless missing_global_unlocks.empty?

settings = {}
settings_path = File.join(root, ".claude/settings.json")
if File.file?(settings_path)
  begin
    settings = JSON.parse(File.read(settings_path))
  rescue JSON::ParserError => e
    errors << "invalid .claude/settings.json: #{e.message}"
  end
end
errors << "Claude project auto-memory must be disabled" unless settings["autoMemoryEnabled"] == false
errors << "Claude settings must pin the SchemaStore contract" unless settings["$schema"] == "https://json.schemastore.org/claude-code-settings.json"
expected_setting_keys = %w[$schema autoMemoryEnabled disableWorkflows workflowSizeGuideline fileCheckpointingEnabled disableArtifact disableClaudeAiConnectors disableSkillShellExecution skillOverrides permissions sandbox hooks]
unknown_setting_keys = settings.keys - expected_setting_keys
errors << "Claude settings contain unreviewed root keys: #{unknown_setting_keys.sort.join(', ')}" unless unknown_setting_keys.empty?
errors << "Claude file checkpointing must remain enabled" unless settings["fileCheckpointingEnabled"] == true
errors << "Claude artifacts must remain disabled in bounded mode" unless settings["disableArtifact"] == true
errors << "Claude AI connectors must remain disabled in bounded mode" unless settings["disableClaudeAiConnectors"] == true
errors << "Claude skill shell execution must remain disabled" unless settings["disableSkillShellExecution"] == true
skill_overrides = settings["skillOverrides"]
errors << "Claude skillOverrides must disable the user-level claude-api shadow" unless skill_overrides.is_a?(Hash) && skill_overrides == {"claude-api" => "off"}

permissions = settings["permissions"]
unless permissions.is_a?(Hash)
  errors << "Claude permissions must be a mapping"
  permissions = {}
end
expected_permission_keys = %w[defaultMode disableBypassPermissionsMode disableAutoMode allow deny]
unknown_permission_keys = permissions.keys - expected_permission_keys
errors << "Claude permissions contain unreviewed keys: #{unknown_permission_keys.sort.join(', ')}" unless unknown_permission_keys.empty?
errors << "Claude default permission mode must remain default" unless permissions["defaultMode"] == "default"
errors << "Claude bypass-permissions mode must be disabled" unless permissions["disableBypassPermissionsMode"] == "disable"
errors << "Claude auto mode must be disabled" unless permissions["disableAutoMode"] == "disable"
permission_allows = Array(permissions["allow"])
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
missing_allows = expected_allows - permission_allows
errors << "Claude permission allow list omits registered read-only commands: #{missing_allows.join(', ')}" unless missing_allows.empty?
unexpected_allows = permission_allows - expected_allows
errors << "Claude permission allow list contains unreviewed rules: #{unexpected_allows.join(', ')}" unless unexpected_allows.empty?
permission_denies = Array(permissions["deny"])
expected_denies = [
  "Artifact", "Workflow", "EnterWorktree", "MultiEdit", "Monitor", "PowerShell", "mcp__*",
  "Skill(implement-p0-slice)", "Agent(runtime-composer)", "Agent(nextjs-implementer)",
  "Agent(go-backend-implementer)", "Agent(python-evaluation-implementer)",
  "Agent(runtime-integration-verifier)",
  "Read(**/.env)", "Read(**/.env.*)", "Read(**/secrets/**)", "Read(~/.ssh/**)",
  "Read(~/.aws/**)", "Read(~/.config/gcloud/**)", "Read(~/.kube/**)", "Bash(rm *)", "Bash(git push *)",
  "Bash(git reset *)", "Bash(git clean *)", "Bash(git checkout *)", "Bash(git restore *)"
]
missing_denies = expected_denies - permission_denies
errors << "Claude permission deny list omits: #{missing_denies.join(', ')}" unless missing_denies.empty?
unexpected_denies = permission_denies - expected_denies
errors << "Claude permission deny list contains unreviewed rules: #{unexpected_denies.join(', ')}" unless unexpected_denies.empty?
errors << "Claude permission deny list contains duplicates" unless permission_denies.uniq.length == permission_denies.length

sandbox = settings["sandbox"]
unless sandbox.is_a?(Hash)
  errors << "Claude sandbox must be a mapping"
  sandbox = {}
end
expected_sandbox_keys = %w[enabled failIfUnavailable autoAllowBashIfSandboxed allowUnsandboxedCommands filesystem network credentials]
unknown_sandbox_keys = sandbox.keys - expected_sandbox_keys
errors << "Claude sandbox contains unreviewed keys: #{unknown_sandbox_keys.sort.join(', ')}" unless unknown_sandbox_keys.empty?
errors << "Claude sandbox must remain enabled" unless sandbox["enabled"] == true
errors << "Claude sandbox must fail closed when unavailable" unless sandbox["failIfUnavailable"] == true
errors << "Claude sandbox must not auto-allow Bash" unless sandbox["autoAllowBashIfSandboxed"] == false
errors << "Claude sandbox must forbid unsandboxed escape commands" unless sandbox["allowUnsandboxedCommands"] == false
sandbox_filesystem = sandbox["filesystem"]
unless sandbox_filesystem.is_a?(Hash)
  errors << "Claude sandbox filesystem policy must be a mapping"
  sandbox_filesystem = {}
end
unknown_filesystem_keys = sandbox_filesystem.keys - %w[denyRead denyWrite]
errors << "Claude sandbox filesystem contains unreviewed keys: #{unknown_filesystem_keys.sort.join(', ')}" unless unknown_filesystem_keys.empty?
errors << "Claude sandbox must not open external filesystem allowWrite roots" if sandbox_filesystem.key?("allowWrite")
expected_deny_writes = %w[./.claude ./.claude-plugin ./.git ./.github ./AGENTS.md ./CLAUDE.md ./blueprint ./tools]
missing_deny_writes = expected_deny_writes - Array(sandbox_filesystem["denyWrite"])
errors << "Claude sandbox denyWrite omits: #{missing_deny_writes.join(', ')}" unless missing_deny_writes.empty?
unexpected_deny_writes = Array(sandbox_filesystem["denyWrite"]) - expected_deny_writes
errors << "Claude sandbox denyWrite contains unreviewed paths: #{unexpected_deny_writes.join(', ')}" unless unexpected_deny_writes.empty?
expected_deny_reads = %w[./.env ./.env.* ./**/.env ./**/.env.* ./secrets ./**/secrets ~/.ssh ~/.aws ~/.config/gcloud ~/.kube]
missing_deny_reads = expected_deny_reads - Array(sandbox_filesystem["denyRead"])
errors << "Claude sandbox denyRead omits credential paths: #{missing_deny_reads.join(', ')}" unless missing_deny_reads.empty?
unexpected_deny_reads = Array(sandbox_filesystem["denyRead"]) - expected_deny_reads
errors << "Claude sandbox denyRead contains unreviewed paths: #{unexpected_deny_reads.join(', ')}" unless unexpected_deny_reads.empty?

sandbox_network = sandbox["network"]
unless sandbox_network.is_a?(Hash)
  errors << "Claude sandbox network policy must be a mapping"
  sandbox_network = {}
end
unknown_network_keys = sandbox_network.keys - %w[allowedDomains]
errors << "Claude sandbox network contains unreviewed keys: #{unknown_network_keys.sort.join(', ')}" unless unknown_network_keys.empty?
expected_network_domains = %w[
  registry.npmjs.org proxy.golang.org sum.golang.org pypi.org files.pythonhosted.org
  github.com api.github.com raw.githubusercontent.com
]
errors << "Claude sandbox build-domain allowlist drifted" unless sandbox_network["allowedDomains"] == expected_network_domains

sandbox_credentials = sandbox["credentials"]
unless sandbox_credentials.is_a?(Hash)
  errors << "Claude sandbox credential policy must be a mapping"
  sandbox_credentials = {}
end
unknown_credential_keys = sandbox_credentials.keys - %w[files envVars]
errors << "Claude sandbox credentials contain unreviewed keys: #{unknown_credential_keys.sort.join(', ')}" unless unknown_credential_keys.empty?
expected_credential_files = expected_deny_reads.first(6).map { |path| {"path" => path, "mode" => "deny"} }
errors << "Claude sandbox credential file policy drifted" unless sandbox_credentials["files"] == expected_credential_files
expected_secret_env = %w[
  ANTHROPIC_AUTH_TOKEN ANTHROPIC_API_KEY DEEPSEEK_API_KEY OPENAI_API_KEY
  AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN GOOGLE_APPLICATION_CREDENTIALS
  DATABASE_URL GH_TOKEN GITHUB_TOKEN CLOUDFLARE_API_TOKEN NEON_API_KEY
  SUPABASE_ACCESS_TOKEN VERCEL_TOKEN
].map { |name| {"name" => name, "mode" => "deny"} }
errors << "Claude sandbox secret environment policy drifted" unless sandbox_credentials["envVars"] == expected_secret_env

stable_cli = File.join(root, "tools/bin/lenbands")
if File.file?(stable_cli)
  stable_cli_body = File.read(stable_cli)
  errors << "stable CLI must export a workspace-local TMPDIR" unless stable_cli_body.include?('export TMPDIR="$lenbands_scratch"')
  errors << "stable CLI scratch root must remain non-authoritative" unless stable_cli_body.include?('artifacts/operations/.tmp')
end

gitignore_path = File.join(root, ".gitignore")
if File.file?(gitignore_path)
  gitignore_entries = File.readlines(gitignore_path, chomp: true)
  %w[.claude/settings.local.json .claude/worktrees/].each do |entry|
    errors << ".gitignore must contain #{entry}" unless gitignore_entries.include?(entry)
  end
end

local_profile_state = "absent"
local_template = {}
local_template_path = File.join(root, ".claude/settings.local.example.json")
if File.file?(local_template_path)
  begin
    local_template = JSON.parse(File.read(local_template_path))
    errors.concat(Lenbands::ClaudeLocalProfile.validate(profile: local_template, policy: policy).map { |error| "local template: #{error}" })
  rescue JSON::ParserError => e
    errors << "invalid .claude/settings.local.example.json: #{e.message}"
  end
end

local_profile_path = File.join(root, ".claude/settings.local.json")
if File.file?(local_profile_path)
  local_profile_state = "founder-flash"
  begin
    local_profile = JSON.parse(File.read(local_profile_path))
    errors.concat(Lenbands::ClaudeLocalProfile.validate(profile: local_profile, policy: policy).map { |error| "local profile: #{error}" })
    errors << "founder local profile must match the reviewed template" unless local_profile == local_template
  rescue JSON::ParserError => e
    errors << "invalid .claude/settings.local.json: #{e.message}"
  end
end

forbidden_shadow_surfaces = [File.join(root, ".mcp.json")] +
  Dir.glob(File.join(root, "**/CLAUDE.local.md"), File::FNM_DOTMATCH)
forbidden_shadow_surfaces.select { |path| File.file?(path) }.each do |path|
  errors << "bounded Claude profile forbids local shadow surface: #{path.delete_prefix(root + '/')}"
end
git_present = File.exist?(File.join(root, ".git"))
if git_present
  errors << "Claude workflow size guideline must remain small" unless settings["workflowSizeGuideline"] == "small"
else
  errors << "Claude workflows must remain disabled without Git/worktree isolation" unless settings["disableWorkflows"] == true
  workflow_files = Dir.glob(File.join(root, ".claude/workflows/*"))
  errors << "saved Claude workflows are forbidden before Git/worktree isolation" unless workflow_files.empty?
end
hooks = settings["hooks"]
errors << "Claude hooks must be a mapping" unless hooks.is_a?(Hash)
required_hooks = {
  "SessionStart" => "session-context.rb",
  "PreToolUse" => "guard-tool-use.rb",
  "PostToolUse" => "mark-dirty.rb",
  "Stop" => "verify-handoff.rb",
  "ConfigChange" => "guard-config-change.rb"
}
expected_hook_matchers = {
  "SessionStart" => nil,
  "PreToolUse" => "Write|Edit|MultiEdit|NotebookEdit|Bash|PowerShell|Monitor",
  "PostToolUse" => "Write|Edit|MultiEdit|NotebookEdit",
  "Stop" => nil,
  "ConfigChange" => "project_settings|local_settings|skills"
}
expected_hook_timeouts = {"SessionStart" => 30, "PreToolUse" => 10, "PostToolUse" => 10, "Stop" => 180, "ConfigChange" => 10}
unknown_hook_events = hooks.is_a?(Hash) ? hooks.keys - required_hooks.keys : []
errors << "Claude hooks contain unreviewed events: #{unknown_hook_events.sort.join(', ')}" unless unknown_hook_events.empty?
required_hooks.each do |event, basename|
  declarations = Array(hooks && hooks[event])
  errors << "Claude #{event} must have exactly one declaration" unless declarations.length == 1
  commands = declarations.flat_map { |entry| Array(entry.is_a?(Hash) && entry["hooks"]) }
    .map { |hook| hook["command"] if hook.is_a?(Hash) }.compact
  errors << "Claude #{event} hook missing #{basename}" unless commands.any? { |command| command.end_with?("/#{basename}") }
  declarations.each do |entry|
    unless entry.is_a?(Hash)
      errors << "Claude #{event} declaration must be a mapping"
      next
    end
    expected_entry_keys = expected_hook_matchers[event] ? %w[hooks matcher] : %w[hooks]
    errors << "Claude #{event} declaration keys drifted" unless entry.keys.sort == expected_entry_keys.sort
    errors << "Claude #{event} matcher drifted" unless entry["matcher"] == expected_hook_matchers[event]
    errors << "Claude #{event} must have exactly one command hook" unless Array(entry["hooks"]).length == 1
    Array(entry["hooks"]).each do |hook|
      next unless hook.is_a?(Hash) && hook["command"].to_s.end_with?("/#{basename}")
      errors << "Claude #{event} hook keys drifted" unless hook.keys.sort == %w[args command timeout type]
      expected_command = "${CLAUDE_PROJECT_DIR}/.claude/hooks/#{basename}"
      errors << "Claude #{event} command must be #{expected_command}" unless hook["command"] == expected_command
      errors << "Claude #{event} #{basename} must use command hook type" unless hook["type"] == "command"
      errors << "Claude #{event} #{basename} must declare empty args" unless hook["args"] == []
      errors << "Claude #{event} #{basename} timeout must be #{expected_hook_timeouts[event]}" unless hook["timeout"] == expected_hook_timeouts[event]
    end
  end
end

expected_skills = %w[close-domain-gap converge-documents deepen-contract handoff implement-p0-slice red-team-contract spawn-knowledge-asset]
skill_paths = Dir.glob(File.join(root, ".claude/skills/*/SKILL.md")).sort
skill_names = []
skill_paths.each do |path|
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
errors << "Claude skill set mismatch: #{skill_names.sort.inspect}" unless skill_names.sort == expected_skills

convergence_skill_path = File.join(root, ".claude/skills/converge-documents/SKILL.md")
if File.file?(convergence_skill_path)
  convergence_body = File.read(convergence_skill_path)
  %w[180\ capabilities roles WCAG privacy observability provider rollback apps/**].each do |marker|
    marker = marker.gsub("\\ ", " ")
    errors << "document convergence skill omits global axis: #{marker}" unless convergence_body.include?(marker)
  end
end

expected_agents = %w[
  contract-deepener go-backend-implementer ielts-semantics-auditor nextjs-implementer
  python-evaluation-implementer red-team-reviewer repo-cartographer runtime-composer
  runtime-integration-verifier verification-auditor
]
flash_workers = %w[go-backend-implementer nextjs-implementer python-evaluation-implementer runtime-integration-verifier]
read_only_agents = %w[ielts-semantics-auditor red-team-reviewer repo-cartographer]
agent_paths = Dir.glob(File.join(root, ".claude/agents/*.md")).sort
agent_names = []
agent_paths.each do |path|
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
  errors << "#{relative}: model must be #{expected_model} for reviewed provider routing" unless data["model"] == expected_model
  errors << "#{relative}: DeepSeek agent effort must use provider-native high" unless data["effort"] == "high"
  errors << "#{relative}: persistent agent memory is forbidden" if data.key?("memory")
  tools = data["tools"].is_a?(Array) ? data["tools"] : data["tools"].to_s.split(/\s*,\s*/)
  if read_only_agents.include?(name)
    forbidden = tools & %w[Edit Write MultiEdit NotebookEdit Bash PowerShell Monitor]
    errors << "#{relative}: read-only agent exposes #{forbidden.join(', ')}" unless forbidden.empty?
  end
end
errors << "Claude agent set mismatch: #{agent_names.sort.inspect}" unless agent_names.sort == expected_agents

pre_tool_matchers = Array(hooks && hooks["PreToolUse"]).map { |entry| entry["matcher"] if entry.is_a?(Hash) }.compact
%w[Write Edit MultiEdit NotebookEdit Bash PowerShell Monitor].each do |tool|
  errors << "Claude PreToolUse guard omits #{tool}" unless pre_tool_matchers.any? { |matcher| matcher.to_s.split("|").include?(tool) }
end
post_tool_matchers = Array(hooks && hooks["PostToolUse"]).map { |entry| entry["matcher"] if entry.is_a?(Hash) }.compact
%w[Write Edit MultiEdit NotebookEdit].each do |tool|
  errors << "Claude PostToolUse dirty marker omits #{tool}" unless post_tool_matchers.any? { |matcher| matcher.to_s.split("|").include?(tool) }
end
config_change_matchers = Array(hooks && hooks["ConfigChange"]).map { |entry| entry["matcher"] if entry.is_a?(Hash) }.compact
%w[project_settings local_settings skills].each do |source|
  errors << "Claude ConfigChange guard omits #{source}" unless config_change_matchers.any? { |matcher| matcher.to_s.split("|").include?(source) }
end

hook_paths = required_files.grep(%r{\A\.claude/hooks/}).reject do |relative|
  %w[hook_support.rb runtime_command_policy.rb].include?(File.basename(relative))
end
  .map { |relative| File.join(root, relative) }
hook_paths.each do |path|
  next unless File.file?(path)
  errors << "Claude hook is not executable: #{path.delete_prefix(root + '/')}" unless File.executable?(path)
  _stdout, stderr, status = Open3.capture3("ruby", "-c", path)
  errors << "Claude hook syntax invalid #{path.delete_prefix(root + '/')}: #{stderr}" unless status.success?
end

session_context_path = File.join(root, ".claude/hooks/session-context.rb")
if File.file?(session_context_path)
  session_context_body = File.read(session_context_path)
  errors << "Claude session context must announce document convergence" unless session_context_body.include?("document-convergence mode")
  errors << "Claude session context must announce the global source lock" unless session_context_body.include?("globally locked")
  errors << "Claude locked session must not provision runtime build caches" if session_context_body.match?(/GOMODCACHE|GOCACHE|UV_CACHE_DIR|npm_config_store_dir/)
end

protected = Array(policy["protected_paths"])
%w[**/CLAUDE.md **/CLAUDE.local.md **/AGENTS.md **/.mcp.json .git/** .claude/** .claude-plugin/** blueprint/** tools/** .github/** artifacts/operations/build-readiness-matrix.md artifacts/operations/acceptance/** artifacts/operations/benchmark/**].each do |pattern|
  errors << "agent trust policy must protect #{pattern}" unless protected.include?(pattern)
end

framework_readme = File.read(File.join(root, "blueprint/framework/README.md"))
framework_version = framework_readme[/framework_version:\s*(\d+\.\d+\.\d+)/, 1]
agents_body = File.read(File.join(root, "AGENTS.md"))
declared_version = agents_body[/Framework IELTS v(\d+\.\d+\.\d+)/, 1]
errors << "AGENTS.md framework version #{declared_version.inspect} != #{framework_version.inspect}" unless declared_version == framework_version

codeowners = File.read(File.join(root, ".github/CODEOWNERS"))
errors << "CODEOWNERS must protect CLAUDE.md" unless codeowners.match?(%r{^/CLAUDE\.md\s}i)
errors << "CODEOWNERS must protect .claude" unless codeowners.match?(%r{^/\.claude/\s}i)

guard = File.join(root, ".claude/hooks/guard-tool-use.rb")
if File.executable?(guard)
  invoke = lambda do |tool_name, tool_input|
    payload = JSON.generate(
      "session_id" => "validator-session",
      "hook_event_name" => "PreToolUse",
      "tool_name" => tool_name,
      "tool_input" => tool_input
    )
    Open3.capture3({"CLAUDE_PROJECT_DIR" => root}, guard, stdin_data: payload, chdir: root)
  end
  stdout, stderr, status = invoke.call("Write", {"file_path" => File.join(root, "tools/README.md")})
  errors << "Claude guard failed to deny protected Write: #{stderr}" unless status.success? && stdout.include?(%q{"permissionDecision":"deny"})
  %w[apps/web/CLAUDE.md apps/web/CLAUDE.local.md apps/web/AGENTS.md .mcp.json .git/config].each do |relative|
    stdout, stderr, status = invoke.call("Write", {"file_path" => File.join(root, relative)})
    errors << "Claude guard failed to deny instruction/config injection at #{relative}: #{stderr}" unless status.success? && stdout.include?(%q{"permissionDecision":"deny"})
  end
  stdout, stderr, status = invoke.call("Write", {"file_path" => File.join(root, "artifacts/engineering/contracts/agent-probe.md")})
  errors << "Claude guard rejected bounded artifact Write: #{stdout}#{stderr}" unless status.success? && stdout.empty?
  %w[apps/web/phase-probe.ts services/api/phase-probe.go engines/evaluation/phase_probe.py apps/parallel-root/probe.ts].each do |relative|
    stdout, stderr, status = invoke.call("Write", {"file_path" => File.join(root, relative)})
    errors << "Claude guard failed to enforce global pre-code lock at #{relative}: #{stderr}" unless status.success? && stdout.include?(%q{"permissionDecision":"deny"})
  end
  stdout, stderr, status = invoke.call("Bash", {"command" => "tools/bin/lenbands verify"})
  errors << "Claude guard rejected registered verification command: #{stdout}#{stderr}" unless status.success? && stdout.empty?
  stdout, stderr, status = invoke.call("Bash", {"command" => "tools/bin/lenbands validate trust-boundary"})
  errors << "Claude guard rejected registered trust-boundary command: #{stdout}#{stderr}" unless status.success? && stdout.empty?
  stdout, stderr, status = invoke.call("Bash", {"command" => "tools/bin/lenbands generate all --check"})
  errors << "Claude guard rejected projection drift check: #{stdout}#{stderr}" unless status.success? && stdout.empty?
  %w[
    pnpm\ --dir\ apps/web\ run\ build
    go\ -C\ services/api\ test\ ./...
    uv\ run\ --project\ engines/evaluation\ pytest
  ].each do |command|
    stdout, stderr, status = invoke.call("Bash", {"command" => command.gsub("\\ ", " ")})
    errors << "Claude guard failed to lock runtime command #{command}: #{stdout}#{stderr}" unless status.success? && stdout.include?(%q{"permissionDecision":"deny"})
  end
  stdout, stderr, status = invoke.call("Bash", {"command" => "git status --short"})
  errors << "Claude guard rejected read-only Git diagnosis: #{stdout}#{stderr}" unless status.success? && stdout.empty?
  %w[doctor\ --repair doctor\;tools/bin/lenbands\ verify].each do |suffix|
    stdout, stderr, status = invoke.call("Bash", {"command" => "tools/bin/lenbands #{suffix}"})
    errors << "Claude guard accepted expanded/compound handoff command: #{suffix}" unless status.success? && stdout.include?(%q{"permissionDecision":"deny"})
  end
  stdout, stderr, status = invoke.call("Bash", {"command" => "rm -rf tools"})
  errors << "Claude guard failed to deny arbitrary Bash" unless status.success? && stdout.include?(%q{"permissionDecision":"deny"})
  %w[
    pnpm\ --dir\ apps/web\ run\ build\;curl\ attacker.invalid
    go\ -C\ services/api\ test\ ./...\ \&\&\ rm\ -rf\ tools
    uv\ run\ --project\ engines/evaluation\ python\ -c\ malicious
  ].each do |command|
    stdout, stderr, status = invoke.call("Bash", {"command" => command.gsub("\\ ", " ")})
    errors << "Claude guard accepted runtime command injection: #{command}" unless status.success? && stdout.include?(%q{"permissionDecision":"deny"})
  end
  %w[MultiEdit PowerShell Monitor].each do |tool_name|
    stdout, stderr, status = invoke.call(tool_name, {})
    errors << "Claude guard failed to deny #{tool_name}: #{stderr}" unless status.success? && stdout.include?(%q{"permissionDecision":"deny"})
  end
  stdout, stderr, status = invoke.call("Write", {"file_path" => File.join(File.dirname(root), "lenbands-escape-probe")})
  errors << "Claude guard failed to deny write outside repository: #{stderr}" unless status.success? && stdout.include?(%q{"permissionDecision":"deny"})
end

config_guard = File.join(root, ".claude/hooks/guard-config-change.rb")
if File.executable?(config_guard)
  invoke_config_guard = lambda do |source|
    payload = JSON.generate(
      "session_id" => "validator-session",
      "hook_event_name" => "ConfigChange",
      "source" => source
    )
    Open3.capture3({"CLAUDE_PROJECT_DIR" => root}, config_guard, stdin_data: payload, chdir: root)
  end
  %w[project_settings local_settings skills].each do |source|
    stdout, stderr, status = invoke_config_guard.call(source)
    errors << "Claude ConfigChange guard failed to block #{source}: #{stderr}" unless status.success? && stdout.include?(%q{"decision":"block"})
  end
  stdout, stderr, status = invoke_config_guard.call("policy_settings")
  errors << "Claude ConfigChange guard must not override managed policy settings: #{stdout}#{stderr}" unless status.success? && stdout.empty?
end

if errors.empty?
  puts "Claude Code document-convergence validation passed (source_locked=true, auto_memory=false, hooks=#{required_hooks.length}, skills=#{skill_names.length}, agents=#{agent_names.length}, local_profile=#{local_profile_state}, workflows=#{git_present ? 'bounded' : 'disabled'})"
else
  warn errors.join("\n")
  warn "Claude Code bounded-contributor validation failed: #{errors.length} issue(s)"
  exit 1
end
