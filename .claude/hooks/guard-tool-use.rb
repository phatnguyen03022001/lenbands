#!/usr/bin/env ruby
# frozen_string_literal: true

require "tmpdir"
require "open3"
require_relative "hook_support"
require_relative "runtime_command_policy"

root = LenbandsClaudeHook.root
$LOAD_PATH.unshift File.join(root, "tools/lib")
require "lenbands"
require "lenbands/yaml_loader"

input = LenbandsClaudeHook.input
tool_name = input["tool_name"].to_s
tool_input = input["tool_input"]
LenbandsClaudeHook.deny!("tool_input must be a mapping") unless tool_input.is_a?(Hash)

policy_path = File.join(root, "artifacts/operations/agent-trust-policy.yaml")
begin
  policy = Lenbands::YamlLoader.load_file(policy_path, mapping: true)
rescue Lenbands::YamlError => e
  LenbandsClaudeHook.deny!("cannot enforce agent trust policy: #{e.message}")
end
phase_gate = policy.dig("application_builder", "phase_gate")
LenbandsClaudeHook.deny!("application phase gate is missing or malformed") unless phase_gate.is_a?(Hash)

# A repository-side authorization is impossible by policy. A privileged launcher may inject
# exact-baseline/family/scope references, but the hook still independently checks conservative
# repository eligibility and blocking-risk state before it permits source mutation or build tools.
def repository_family_implementation_eligible?(root, family)
  manifest_path = File.join(root, "artifacts/operations/capability-manifest.yaml")
  risk_path = File.join(root, "artifacts/operations/problem-risk-registry.yaml")
  manifest = Lenbands::YamlLoader.load_file(manifest_path, mapping: true)
  risks = Lenbands::YamlLoader.load_file(risk_path, mapping: true)

  family_row = Array(manifest["capability_families"]).find { |row| row.is_a?(Hash) && row["family_id"] == family }
  return false unless family_row

  # This is intentionally conservative: implementation can start only after every current
  # pre-code contract projection for the family has been promoted to approved/canonical.
  artifacts = Array(family_row["artifacts_current"])
  return false if artifacts.empty?
  return false unless artifacts.all? do |entry|
    entry.is_a?(Hash) && %w[approved canonical].include?(entry["status"].to_s)
  end

  unresolved_blocker = Array(risks["risks"]).any? do |risk|
    next false unless risk.is_a?(Hash)
    next false unless Array(risk["affected_families"]).include?(family)
    next false unless risk["implementation_blocking"] == true
    %w[open partial deferred].include?(risk["status"].to_s)
  end
  !unresolved_blocker
rescue Lenbands::YamlError, SystemCallError, StandardError
  false
end

# Repository policy defines the requirements but never contains an active authorization.
# A privileged launcher may inject a bounded external authorization context. The hook
# validates it against exact HEAD, the single canonical P0 source workspace, repository
# implementation eligibility, and unresolved implementation-blocking risks.
def implementation_authorization(root, policy, phase_gate)
  return nil unless phase_gate["state"] == "family_scoped_authorization"
  return nil unless phase_gate["source_mutation"] == "locked"
  return nil unless phase_gate["repository_authorization_state"] == "none"
  return nil unless phase_gate["repository_tree_may_self_authorize"] == false

  family = ENV["LENBANDS_IMPLEMENTATION_FAMILY"].to_s
  base_sha = ENV["LENBANDS_IMPLEMENTATION_BASE_SHA"].to_s
  raw_scopes = ENV["LENBANDS_IMPLEMENTATION_SOURCE_SCOPES"].to_s
  founder_ref = ENV["LENBANDS_FOUNDER_AUTHORIZATION_REF"].to_s
  auth_ref = ENV["LENBANDS_IMPLEMENTATION_AUTHORIZATION_REF"].to_s
  return nil if [family, base_sha, raw_scopes, founder_ref, auth_ref].any?(&:empty?)
  return nil unless family.match?(/\AP0-0[1-6]\z/)
  return nil unless base_sha.match?(/\A[0-9a-f]{40}\z/)

  head, status = Open3.capture2("git", "rev-parse", "HEAD", chdir: root)
  return nil unless status.success? && head.strip == base_sha
  return nil unless repository_family_implementation_eligible?(root, family)

  canonical_workspace = policy.dig("application_builder", "source_workspaces", "application_candidate").to_s
  return nil if canonical_workspace.empty?
  scopes = raw_scopes.split(",").map(&:strip).reject(&:empty?).uniq
  return nil if scopes.empty?
  return nil unless scopes.all? do |scope|
    !scope.start_with?("/") && !scope.split("/").include?("..") &&
      (scope == canonical_workspace || scope.start_with?(canonical_workspace + "/"))
  end

  {
    "family_id" => family,
    "base_sha" => base_sha,
    "source_scopes" => scopes,
    "founder_ref" => founder_ref,
    "authorization_ref" => auth_ref
  }
rescue StandardError
  nil
end

authorization = implementation_authorization(root, policy, phase_gate)
source_authorized = lambda do |relative|
  authorization && authorization["source_scopes"].any? { |scope| relative == scope || relative.start_with?(scope + "/") }
end

case tool_name
when "Write", "Edit", "NotebookEdit"
  raw_path = tool_input["file_path"] || tool_input["notebook_path"] || tool_input["path"]
  LenbandsClaudeHook.deny!("#{tool_name} omitted its target path") if raw_path.to_s.empty?
  relative = LenbandsClaudeHook.relative_write_path(raw_path.to_s)

  source_roots = Array(phase_gate["locked_source_roots"])
  source_root = source_roots.find { |path| relative == path.to_s || relative.start_with?(path.to_s + "/") }
  if source_root && !source_authorized.call(relative)
    LenbandsClaudeHook.deny!("source mutation requires externally authorized, repository-eligible family scope for the exact reviewed baseline: #{relative}")
  end

  patterns = Array(policy["protected_paths"]) + Array(policy["immutable_append_only_paths"])
  flags = File::FNM_PATHNAME | File::FNM_EXTGLOB
  matched = patterns.find { |pattern| File.fnmatch(pattern.to_s, relative, flags) }
  LenbandsClaudeHook.deny!("normal Claude sessions cannot modify protected path #{relative} (policy #{matched})") if matched
when "Bash"
  command = tool_input["command"].to_s.strip
  LenbandsClaudeHook.deny!("empty Bash command") if command.empty?
  public_read_only = [
    /\A(?:\.\/)?tools\/bin\/lenbands context(?: --yaml)?\z/,
    /\A(?:\.\/)?tools\/bin\/lenbands doctor\z/,
    /\A(?:\.\/)?tools\/bin\/lenbands verify\z/,
    /\A(?:\.\/)?tools\/bin\/lenbands version\z/,
    /\A(?:\.\/)?tools\/bin\/lenbands gate (?:toolchain|p0|repository)\z/,
    /\A(?:\.\/)?tools\/bin\/lenbands validate (?:all|tooling|trust-boundary|phase-index|documents|framework|knowledge-assets|openapi|semantic-contracts|contract-ownership|domain-automation|evidence-lineage|platform-boundary|spawn-prompts|benchmark-contracts|implementation-catalog|claude-code)\z/,
    /\A(?:\.\/)?tools\/bin\/lenbands generate all --check\z/,
    /\A(?:\.\/)?tools\/bin\/lenbands capability compile [A-Z][A-Za-z0-9_.-]*\z/,
    /\Aruby tools\/commands\/validate\/problem-risk-coverage\.rb\z/
  ]
  runtime_allowed = LenbandsRuntimeCommandPolicy.allowed?(command)
  if runtime_allowed && LenbandsRuntimeCommandPolicy.implementation?(command) && authorization.nil?
    LenbandsClaudeHook.deny!("runtime implementation command requires externally authorized, repository-eligible family scope for the exact reviewed baseline")
  end
  unless public_read_only.any? { |pattern| command.match?(pattern) } || runtime_allowed
    LenbandsClaudeHook.deny!("Bash is restricted to registered LenBands checks and reviewed workspace-native commands; shell chaining, arbitrary interpreters and unscoped commands are denied.")
  end
when "MultiEdit", "PowerShell", "Monitor"
  LenbandsClaudeHook.deny!("#{tool_name} is disabled in bounded mode; use guarded Edit/Write or a registered LenBands command.")
else
  LenbandsClaudeHook.deny!("unexpected tool routed to write guard: #{tool_name}")
end
