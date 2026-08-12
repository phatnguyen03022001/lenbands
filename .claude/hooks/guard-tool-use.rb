#!/usr/bin/env ruby
# frozen_string_literal: true

require "tmpdir"
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
unless phase_gate.is_a?(Hash)
  LenbandsClaudeHook.deny!("application phase gate is missing or malformed")
end
implementation_authorized =
  phase_gate["state"] == "implementation_authorized" &&
  phase_gate["source_mutation"] == "enabled" &&
  phase_gate["partial_pack_unlock_allowed"] == false &&
  !phase_gate["founder_authorization_ref"].to_s.empty? &&
  !phase_gate["completion_attestation_ref"].to_s.empty?

case tool_name
when "Write", "Edit", "NotebookEdit"
  raw_path = tool_input["file_path"] || tool_input["notebook_path"] || tool_input["path"]
  LenbandsClaudeHook.deny!("#{tool_name} omitted its target path") if raw_path.to_s.empty?
  relative = LenbandsClaudeHook.relative_write_path(raw_path.to_s)

  source_roots = Array(phase_gate["locked_source_roots"])
  source_root = source_roots.find { |path| relative == path.to_s || relative.start_with?(path.to_s + "/") }
  if source_root && !implementation_authorized
    LenbandsClaudeHook.deny!("source mutation is globally locked during document_convergence: #{relative}")
  end

  patterns = Array(policy["protected_paths"]) + Array(policy["immutable_append_only_paths"])
  flags = File::FNM_PATHNAME | File::FNM_EXTGLOB
  matched = patterns.find { |pattern| File.fnmatch(pattern.to_s, relative, flags) }
  if matched
    LenbandsClaudeHook.deny!("normal Claude sessions cannot modify protected path #{relative} (policy #{matched})")
  end
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
    /\A(?:\.\/)?tools\/bin\/lenbands capability compile [A-Z][A-Za-z0-9_.-]*\z/
  ]
  runtime_allowed = LenbandsRuntimeCommandPolicy.allowed?(command)
  if runtime_allowed && LenbandsRuntimeCommandPolicy.implementation?(command) && !implementation_authorized
    LenbandsClaudeHook.deny!("runtime implementation commands are globally locked during document_convergence")
  end
  unless public_read_only.any? { |pattern| command.match?(pattern) } || runtime_allowed
    LenbandsClaudeHook.deny!("Bash is restricted to registered LenBands checks and reviewed workspace-native build commands; shell chaining, arbitrary interpreters and unscoped commands are denied.")
  end
when "MultiEdit", "PowerShell", "Monitor"
  LenbandsClaudeHook.deny!("#{tool_name} is disabled in bounded mode; use guarded Edit/Write or a registered LenBands command.")
else
  LenbandsClaudeHook.deny!("unexpected tool routed to write guard: #{tool_name}")
end
