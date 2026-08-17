# frozen_string_literal: true

# Shared Bash policy while application source mutation is locked.
# Runtime implementation commands are intentionally empty: selecting pnpm, Go, Python,
# sqlc, a worker runtime, or any other build tool before sourcing + family authorization
# would silently freeze implementation topology.
module LenbandsRuntimeCommandPolicy
  READ_ONLY_COMMANDS = [
    /\Aruby --version\z/,
    /\Arg --version\z/,
    /\Agit status(?: --short)?\z/,
    /\Agit diff(?: --check| --stat| --name-only)?\z/
  ].freeze

  IMPLEMENTATION_COMMANDS = [].freeze
  COMMANDS = READ_ONLY_COMMANDS.freeze

  module_function

  def allowed?(command)
    COMMANDS.any? { |pattern| command.match?(pattern) }
  end

  def implementation?(_command)
    false
  end
end
