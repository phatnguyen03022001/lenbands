# frozen_string_literal: true

require "digest"
require "json"
require "open3"
require "tmpdir"

module LenbandsClaudeHook
  module_function

  def input
    @input ||= JSON.parse($stdin.read)
  rescue JSON::ParserError => e
    warn "Claude hook received invalid JSON: #{e.message}"
    exit 2
  end

  def root
    value = ENV["CLAUDE_PROJECT_DIR"].to_s
    deny!("CLAUDE_PROJECT_DIR is missing") if value.empty?
    File.realpath(value)
  rescue SystemCallError => e
    deny!("Claude project root is invalid: #{e.message}")
  end

  def session_marker
    session_id = input["session_id"].to_s
    deny!("Claude hook session_id is missing") if session_id.empty?
    File.join(Dir.tmpdir, "lenbands-claude-#{Digest::SHA256.hexdigest(session_id)}.dirty")
  end

  def deny!(reason)
    unless @input && @input["hook_event_name"] == "PreToolUse"
      warn reason
      exit 2
    end
    puts JSON.generate(
      "hookSpecificOutput" => {
        "hookEventName" => "PreToolUse",
        "permissionDecision" => "deny",
        "permissionDecisionReason" => reason
      }
    )
    exit 0
  end

  def canonical_candidate(path)
    expanded = File.expand_path(path, root)
    cursor = expanded
    suffix = []
    until File.exist?(cursor)
      parent = File.dirname(cursor)
      deny!("write target has no existing ancestor: #{path}") if parent == cursor
      suffix << File.basename(cursor)
      cursor = parent
    end
    File.join(File.realpath(cursor), *suffix.reverse)
  rescue SystemCallError => e
    deny!("cannot resolve write target #{path}: #{e.message}")
  end

  def relative_write_path(path)
    candidate = canonical_candidate(path)
    prefix = root + File::SEPARATOR
    deny!("writes outside the LenBands repository are forbidden: #{path}") unless candidate.start_with?(prefix)
    candidate.delete_prefix(prefix)
  end

  def run(*command)
    Open3.capture3(*command, chdir: root)
  end
end
