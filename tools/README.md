# LenBands Tooling

`tools/` contains repository automation only. It never owns product semantics,
framework vocabulary, capability-to-family mapping, promotion facts, policy, or an
application runtime. Those remain in their declared canonical artifacts.

## Canonical structure

```text
tools/
├── bin/lenbands              # stable public CLI
├── commands/
│   ├── capability/           # bounded capability authoring/context commands
│   ├── gate/                 # release/freeze decisions; fail closed
│   ├── generate/             # deterministic projections only
│   ├── run/                  # immutable evidence runners
│   └── validate/             # syntax + cross-contract semantics
├── lib/lenbands/             # shared library code
├── test/                     # tool contract/unit tests
├── manifest.yaml             # tool dependency/input/output registry
└── toolchain.yaml            # versioned public command contract
```

Root-level scripts are intentionally tiny compatibility shims. Canonical
implementations live only under `commands/`; new scripts must not be added at the
root.

## Daily commands

```bash
tools/bin/lenbands doctor
tools/bin/lenbands context
tools/bin/lenbands validate claude-code
tools/bin/lenbands generate all
tools/bin/lenbands verify
tools/bin/lenbands gate toolchain
tools/bin/lenbands gate p0
```

`doctor` verifies the declared Bash/Ruby/ripgrep and POSIX utility prerequisites
and performs a real temporary-file write probe before any repository validation runs.
This makes a broken Claude sandbox temp policy fail early with an actionable path and
system error instead of aborting later inside a generator. Shell `mktemp` always receives
an explicit workspace template because bare BSD/macOS `mktemp` may ignore `$TMPDIR`.

`context` is the read-only onboarding entry point for every coding agent. It reports
authority boundaries, hard rules, protected paths, current P0 blockers and mandatory
handoff checks without turning the projection into a new source of truth.

`validate claude-code` verifies the committed Claude Code bounded-contributor profile:
`CLAUDE.md` imports the shared agent rules, project auto-memory is disabled, path-scoped
knowledge convergence rules are present, protected writes/arbitrary Bash are denied by
hooks, and the hook/config surface is itself protected by repository trust controls. It
also validates the exact project skill and role-agent inventory, least-privilege tool
assignments, inherited provider routing, and the fail-closed workflow policy. The
security-relevant settings subset is pinned to the SchemaStore Claude Code schema and a
stricter repository overlay: bypass/auto modes, `MultiEdit`, `PowerShell`, `Monitor`,
connectors, artifacts and unsandboxed Bash escapes are disabled; Bash sandbox startup
fails closed; file checkpoints remain enabled; and project/local settings or skill
changes are blocked during bounded sessions. Standard OS temporary roots remain closed;
instead the stable CLI exports the ignored, non-authoritative
`artifacts/operations/.tmp` scratch root so `mktemp`, Ruby `Tempfile`, generators and
Stop-hook checks are reproducible inside the sandbox. Protected repository paths remain
denied. Built-in reads and sandboxed subprocesses are also denied access to repository
environment files, common cloud/SSH credential stores and reviewed secret environment
variables. Artifact, workflow, worktree-entry, skill inline-shell expansion and MCP
surfaces are denied by default, and the provider-specific user `/claude-api` shadow is
disabled.

The shared `.claude/settings.json` remains the security-policy authority. A committed
`.claude/settings.local.example.json` defines the only accepted founder-local execution
profile, and the ignored `.claude/settings.local.json` must match it. This profile pins
DeepSeek V4 Flash as the cost-bounded default at provider-supported `high` effort, maps
Opus to `deepseek-v4-pro` for explicit long-context review sessions, declares the
provider's actual model capabilities, and follows Claude Code's stable update channel. DeepSeek maps `medium` to
`high`, so a `medium` label would be misleading rather than cheaper. The profile
pre-approves only reviewed WebSearch/WebFetch, read-only project agents and document
skills. It cannot store credentials or override hooks, sandboxing, protected paths,
Bash restrictions or permission modes. Bounded sessions still cannot mutate local
settings or silently promote themselves to Pro. `CLAUDE_CODE_SUBAGENT_MODEL` pins every
delegated agent to Flash even when the founder explicitly escalates the main session to
Pro; agent effort labels use DeepSeek's provider-native `high` value. The exact static
read-only context, validation, projection-check and handoff commands are duplicated in
the personal local profile so verification agents work before workspace trust is
accepted; wildcard Bash approval remains invalid and every command is checked again by
the hook when project customizations load.
The local `acceptEdits` mode lets a solo founder run document work without approving
every ordinary Edit/Write call. It does not authorize protected paths, arbitrary Bash,
configuration mutation, evidence writes or bypass mode; shared denies, sandboxing and
PreToolUse hooks remain authoritative.

Project permissions pre-approve only exact stable CLI handoff/context commands. They do
not use trailing wildcards: direct `doctor`, `verify`, named gates and `context` variants
run without prompts, while the PreToolUse hook still rejects extra arguments, compound
shell expressions and every unregistered command.

The reusable Claude Code entry points are:

- `/deepen-contract` and `/close-domain-gap` for deepening an existing canonical owner;
- `/implement-p0-slice` for adapter-first P0 implementation work;
- `/spawn-knowledge-asset` for registry-governed asset creation;
- `/red-team-contract` for adversarial read-only review; and
- `/handoff` for evidence-aware completion.

Six project agents separate repository mapping, IELTS semantics, contract writing,
runtime composition, adversarial review, and verification. Read-only roles have no
write or Bash tools. Dynamic workflows remain disabled when Git/worktree isolation is
absent; agent-team writers are not a substitute for that isolation. Nested instruction
files, local Claude memory, project MCP configuration, plugin manifests and Git metadata
are protected injection surfaces, not ordinary implementation files.

`generate all` updates read-only projections. `generate all --check` fails
when a committed projection is stale. `verify` runs that drift check, the complete
validator graph (without duplicate nested calls), and the Ruby unit tests.

`verify` proves repository contracts are internally valid. It deliberately does not
claim runtime readiness. `gate p0` and `gate repository` are separate, fail-closed
evidence gates and remain blocked until real corpus, approval, runtime and acceptance
evidence exist.

The test harness is fail-closed: accumulated assertions make a suite non-zero, and
`verify` fails if no test file is discovered. Tool YAML is safe-loaded, registry
snapshots are deeply immutable, and malformed authority inputs must never be converted
into an empty-success result.

Tooling quality is measured as **Business Automation Coverage**, not by the breadth of
a generic automation platform. The canonical domains are repository, knowledge,
learning, assessment, AI, release and adapter-only runtime integration. Inspect them
with `tools/bin/lenbands validate domain-automation`.

`tools/bin/lenbands` is the stable public interface. Root scripts remain compatible
for existing artifacts and automation; do not use them for new integration. Full
compatibility rules are in [MIGRATION.md](MIGRATION.md).

## Authority and safety

- `commands/generate/capability-index.sh` renders the Blueprint capability projection.
- `commands/generate/lifecycle-registry.sh` renders lifecycle only from the canonical
  capability-family map plus phase index. It never rewrites promotion facts or policy.
- `commands/generate/operational-coverage.sh` renders coverage projections from registries and
  filesystem evidence.
- `commands/generate/repository-baseline.sh` renders the frozen diagnostic baseline from the
  current catalog, phase projection, and registry inputs; it also supports `--check`.
- `commands/validate/toolchain.rb` validates the tool manifest, declared inputs/outputs, executable
  entry points, dependency graph, and the fail-closed legacy compatibility shim.
- `commands/validate/capability-phase-index.rb` makes the manually owned phase projection
  complete and drift-safe without turning roadmap policy into generator code.
- `generate-capability-registries.sh` is deprecated and intentionally exits without
  making changes. It is retained solely to prevent old invocations from silently
  rewriting canonical mapping or policy.

Evidence runners under `commands/run/` are immutable:
they require actual result inputs and refuse to overwrite a run record.

## Adding or changing a tool

1. Add the command and tests.
2. Register it in `tools/manifest.yaml` with real inputs, outputs, invalidation and dependencies.
3. Keep generators as projections: never embed or rewrite product/framework/policy truth.
4. Run `tools/bin/lenbands verify`.

Any readiness or freeze claim must additionally run the matching `gate` command.
New tools must automate a declared LenBands domain invariant or evidence boundary;
commodity infrastructure breadth is not an acceptance criterion.

Protected changes are governed by `agent-trust-policy.yaml`. Local validation detects
missing checks, modified immutable evidence and missing attestations; actual prevention
of a write-capable agent bypass requires the checked-in CODEOWNERS/workflow to be made
mandatory through hosting-platform branch protection.

The frozen-tooling rule is in `artifacts/operations/architecture-frozen.md`.
