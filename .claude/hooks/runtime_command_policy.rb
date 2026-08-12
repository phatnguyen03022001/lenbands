# frozen_string_literal: true

module LenbandsRuntimeCommandPolicy
  SAFE_ARGUMENT = "[A-Za-z0-9_./:=@,+-]+"

  READ_ONLY_COMMANDS = [
    /\A(?:node --version|pnpm --version|go version|uv --version)\z/,
    /\Adocker compose -f deploy\/compose\.yaml config\z/,
    /\Agit status(?: --short)?\z/,
    /\Agit diff(?: --check| --stat| --name-only)?\z/
  ].freeze

  IMPLEMENTATION_COMMANDS = [
    /\Apnpm --dir apps\/web install(?: --frozen-lockfile)?\z/,
    /\Apnpm --dir apps\/web run (?:dev|build|lint|typecheck|test|test:e2e|format|format:check|generate)(?: -- #{SAFE_ARGUMENT}(?: #{SAFE_ARGUMENT})*)?\z/,
    /\Apnpm --dir apps\/web exec (?:next|tsc|eslint|vitest|playwright|prettier|shadcn)(?: #{SAFE_ARGUMENT})*\z/,
    /\Ago -C services\/api mod (?:tidy|download|verify)\z/,
    /\Ago -C services\/api (?:fmt|vet|generate|build) \.\/\.\.\.\z/,
    /\Ago -C services\/api test(?: -race)? \.\/\.\.\.(?: -count=1)?\z/,
    /\Auv (?:sync|lock) --project engines\/evaluation(?: --frozen)?\z/,
    /\Auv run --project engines\/evaluation pytest(?: #{SAFE_ARGUMENT})*\z/,
    /\Auv run --project engines\/evaluation ruff (?:check \.|format --check \.)\z/,
    /\Auv run --project engines\/evaluation mypy \.\z/,
    /\Asqlc generate -f services\/api\/sqlc\.yaml\z/
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
