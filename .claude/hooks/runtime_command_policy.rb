# frozen_string_literal: true

# Shared Bash policy while application source mutation is locked by default.
# The command family below is reviewed but remains unusable until guard-tool-use.rb
# verifies external exact-baseline authorization plus repository family eligibility.
module LenbandsRuntimeCommandPolicy
  READ_ONLY_COMMANDS = [
    /\Aruby --version\z/,
    /\Arg --version\z/,
    /\Agit status(?: --short)?\z/,
    /\Agit diff(?: --check| --stat| --name-only)?\z/
  ].freeze

  IMPLEMENTATION_COMMANDS = [
    /\Apnpm --dir apps\/web install\z/,
    /\Apnpm --dir apps\/web install --frozen-lockfile\z/,
    /\Apnpm --dir apps\/web run lint\z/,
    /\Apnpm --dir apps\/web run typecheck\z/,
    /\Apnpm --dir apps\/web run test\z/,
    /\Apnpm --dir apps\/web run build\z/
  ].freeze

  COMMANDS = (READ_ONLY_COMMANDS + IMPLEMENTATION_COMMANDS).freeze

  module_function

  def allowed?(command)
    COMMANDS.any? { |pattern| command.match?(pattern) }
  end

  def implementation?(command)
    IMPLEMENTATION_COMMANDS.any? { |pattern| command.match?(pattern) }
  end
end
