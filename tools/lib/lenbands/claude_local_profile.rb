# frozen_string_literal: true

module Lenbands
  module ClaudeLocalProfile
    SCHEMA_URL = "https://json.schemastore.org/claude-code-settings.json"
    SECRET_KEY = /(TOKEN|API_KEY|AUTH|SECRET|PASSWORD|CREDENTIAL)/i
    PRIVILEGED_PERMISSION = /\A(?:Bash|Edit|Write|NotebookEdit|MultiEdit|PowerShell|Monitor|mcp__)/

    module_function

    def validate(profile:, policy:)
      errors = []
      contract = policy["founder_local_profile"]
      return ["agent trust policy founder_local_profile contract must be a mapping"] unless contract.is_a?(Hash)
      return ["founder local profile must be a mapping"] unless profile.is_a?(Hash)

      expected_keys = Array(contract["required_root_keys"])
      unknown_keys = profile.keys - expected_keys
      missing_keys = expected_keys - profile.keys
      errors << "founder local profile contains unreviewed root keys: #{unknown_keys.sort.join(', ')}" unless unknown_keys.empty?
      errors << "founder local profile omits required root keys: #{missing_keys.sort.join(', ')}" unless missing_keys.empty?
      errors << "founder local profile must pin the SchemaStore contract" unless profile["$schema"] == SCHEMA_URL
      errors << "founder local profile update channel must be #{contract['auto_updates_channel']}" unless profile["autoUpdatesChannel"] == contract["auto_updates_channel"]
      errors << "founder local profile default model must be #{contract['default_model']}" unless profile["model"] == contract["default_model"]
      errors << "founder local profile effort must be #{contract['default_effort']}" unless profile["effortLevel"] == contract["default_effort"]

      env = profile["env"]
      unless env.is_a?(Hash)
        errors << "founder local profile env must be a mapping"
        env = {}
      end
      secret_keys = env.keys.grep(SECRET_KEY)
      errors << "founder local profile must not store secrets: #{secret_keys.sort.join(', ')}" unless secret_keys.empty?
      expected_env = contract["required_env"]
      unless expected_env.is_a?(Hash)
        errors << "agent trust policy founder_local_profile.required_env must be a mapping"
        expected_env = {}
      end
      unknown_env = env.keys - expected_env.keys
      missing_env = expected_env.keys - env.keys
      errors << "founder local profile contains unreviewed env keys: #{unknown_env.sort.join(', ')}" unless unknown_env.empty?
      errors << "founder local profile omits env keys: #{missing_env.sort.join(', ')}" unless missing_env.empty?
      expected_env.each do |key, value|
        errors << "founder local profile #{key} must be #{value.inspect}" unless env[key] == value
      end

      permissions = profile["permissions"]
      unless permissions.is_a?(Hash)
        errors << "founder local profile permissions must be a mapping"
        permissions = {}
      end
      unknown_permission_keys = permissions.keys - %w[defaultMode allow]
      errors << "founder local profile permissions contain unreviewed keys: #{unknown_permission_keys.sort.join(', ')}" unless unknown_permission_keys.empty?
      expected_mode = contract["default_permission_mode"]
      errors << "founder local profile permission mode must be #{expected_mode}" unless permissions["defaultMode"] == expected_mode
      allows = permissions["allow"]
      unless allows.is_a?(Array) && allows.all? { |rule| rule.is_a?(String) }
        errors << "founder local profile permissions.allow must be a string array"
        allows = []
      end
      errors << "founder local profile permissions.allow contains duplicates" unless allows.uniq.length == allows.length
      expected_allows = Array(contract["allowed_permissions"])
      privileged = allows.grep(PRIVILEGED_PERMISSION) - expected_allows
      errors << "founder local profile may not pre-approve unreviewed privileged tools: #{privileged.join(', ')}" unless privileged.empty?
      unexpected_allows = allows - expected_allows
      missing_allows = expected_allows - allows
      errors << "founder local profile contains unreviewed allow rules: #{unexpected_allows.join(', ')}" unless unexpected_allows.empty?
      errors << "founder local profile omits approved allow rules: #{missing_allows.join(', ')}" unless missing_allows.empty?

      errors
    end
  end
end
