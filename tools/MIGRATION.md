# Toolchain Migration and Compatibility Policy

The stable command surface is `tools/bin/lenbands`. Its command contract is
versioned in `toolchain.yaml`.

Existing root scripts remain compatibility entry points. Do not rename, remove, or
change their arguments in a patch release. A future breaking change requires all of:

1. a toolchain major-version bump;
2. a migration note with replacement commands;
3. a fail-closed compatibility shim where silent behavior could mutate data;
4. contract tests for the new and old entry points; and
5. an explicit owner review.

New documentation and automation should use the stable CLI, for example:

```bash
tools/bin/lenbands generate all --check
tools/bin/lenbands validate all
tools/bin/lenbands capability compile EVAL.Writing
tools/bin/lenbands gate toolchain
```

As of toolchain 1.1.0, implementations are grouped under `tools/commands/` by
responsibility. This is an internal layout change only: the stable CLI and legacy
root shims preserve their command/argument contracts. Direct use of
`tools/commands/**` is reserved for tool composition and tests.

Toolchain 1.2.0 adds `validate domain-automation` and changes the measurement contract,
not the application runtime: coverage is evaluated against LenBands domain controls;
commodity platform capabilities remain framework/provider responsibilities.

Toolchain 1.3.0 adds `doctor`, declares executable runtime requirements, moves document
metadata validation to structured Ruby/YAML parsing, and makes the latest evidence
lineage snapshot machine-readable. Public command compatibility is unchanged.

Toolchain 1.4.0 adds read-only `context` onboarding and `validate trust-boundary`, plus
protected-path, append-only-evidence and CI attestation controls. These harden agent
changes without granting tools authority over hosting-platform branch protection.

Toolchain 1.4.1 is a fail-closed correctness and input-safety patch. Reporter-backed
tests now fail on accumulated assertions; registry data is deeply immutable; YAML is
safe-loaded throughout `tools/`; readiness evidence paths are canonicalized and
contained; malformed authority inputs produce bounded validation errors; and empty
benchmark samples cannot reach metric calculations. Public commands and arguments are
unchanged.

Toolchain 1.5.0 adds the stable `validate claude-code` contract and a committed Claude
Code bounded-contributor profile. It imports `AGENTS.md`, disables ungoverned project
auto-memory, injects current repository context at session start, blocks protected
writes and arbitrary Bash before execution, and verifies dirty sessions before handoff.
It also provides six domain workflows as project skills and six least-privilege role
agents, with independent discovery, writing, red-team and verification boundaries.
Dynamic workflows are fail-closed while Git/worktree isolation is unavailable. This is
repository enforcement for agent contributions, not an application runtime.

Toolchain 1.6.0 hardens that bounded-contributor profile against alternate execution
surfaces and configuration drift. It disables bypass/auto permission modes, legacy
`MultiEdit`, `PowerShell`, `Monitor`, unreviewed connectors and artifacts; enables
fail-closed Bash sandboxing and file checkpoints; protects project/local settings and
skills with `ConfigChange`; and validates the exact security-relevant subset pinned to
the SchemaStore Claude Code settings contract. Public commands and arguments remain
unchanged.

Toolchain 1.6.1 attempted bounded-session reproducibility by allow-writing standard
macOS/POSIX temporary roots. Independent Seatbelt reproduction showed that policy was
not reliable for shell `mktemp`; the external allow-write expansion is therefore
removed in 1.6.2. The accompanying skill-shell, MCP and `/claude-api` shadow controls
remain active.

Toolchain 1.10.3 corrects DeepSeek model routing to its two official API identifiers:
`deepseek-v4-flash` and `deepseek-v4-pro`. The former remains the default and pinned
subagent route; the latter is only an explicit founder main-session escalation. The
historical `[1m]` suffix was a client annotation, not an official API model ID, and is
removed from active settings and policy. DeepSeek's published one-million-token context
is a model capability, not part of the model identifier. Public commands are unchanged.

Toolchain 1.6.2 makes temporary-file behavior deterministic at the stable CLI boundary.
`tools/bin/lenbands` exports `artifacts/operations/.tmp` as its private, ignored
`TMPDIR`, so generators, Ruby `Tempfile`, tests, compatibility shims and Stop-hook
verification no longer depend on macOS per-user temp access. `doctor` probes both Ruby
`Tempfile` and shell `mktemp` against that path. No external filesystem `allowWrite`
root remains. Public commands and arguments are unchanged.

Toolchain 1.6.3 pre-approves only the exact bounded handoff/context Bash commands in
project permissions. Direct `doctor`, `verify`, `gate toolchain`, `gate p0`,
`gate repository`, `context`, and `context --yaml` calls no longer require a permission
prompt. Wildcard arguments remain forbidden, the PreToolUse hook still validates every
command, and deny rules continue to take precedence. Public commands are unchanged.

Toolchain 1.6.4 fixes BSD/macOS `mktemp` portability. The stable CLI already exported a
workspace-local `TMPDIR`, but bare `mktemp` and `mktemp -d` may ignore it on macOS.
Doctor and every generator now pass an explicit `${TMPDIR:-/tmp}/lenbands-*.XXXXXX`
template; tooling contract tests reject future bare calls. This closes bounded-session
verification without widening sandbox paths or using unsandboxed execution. Public
commands and arguments remain unchanged.

Toolchain 1.7.0 introduces a constrained founder-local Claude Code execution profile.
The committed `.claude/settings.local.example.json` is the reproducible contract while
the ignored `.claude/settings.local.json` is the machine-local instance. The profile
defaults to DeepSeek V4 Flash at medium effort, reserves V4 Pro for explicit session
escalation, and pre-approves only reviewed web, read-only agent and document skill
surfaces. It cannot add Bash/Edit/MCP permissions, credentials, hooks, sandbox changes
or alternate configuration keys. Bounded agents still cannot mutate either settings
scope. Public commands and arguments are unchanged.

Toolchain 1.8.0 aligns that profile with the current DeepSeek Anthropic compatibility
contract: Flash uses the provider-supported `high` effort label because DeepSeek maps
`medium` to `high`, model names/capabilities are declared explicitly, and the local
profile follows Claude Code's stable update channel. The historical Opus escalation
route used `deepseek-v4-pro[1m]` as a client annotation. It is superseded by Toolchain
1.10.3: active settings use the official API model ID `deepseek-v4-pro`; one-million-
token context remains a documented capability, not a suffix on the model identifier.
Subagent resolution is explicitly
pinned to Flash (the highest-priority Claude Code routing layer), including when the
founder escalates the main session to Pro. Shared hardening now denies
Artifact, Workflow and worktree-entry surfaces and protects environment files,
cloud/SSH credential stores and common secret environment variables through both
built-in Read permissions and the Bash sandbox. Hook structure, matchers, commands and
timeouts are now exact validator contracts. The founder-local profile duplicates only
the exact static read-only context, validation, projection-check and handoff commands,
allowing verification agents to run before workspace trust without accepting wildcard
Bash. Its `acceptEdits` mode removes repetitive
ordinary document-edit prompts while remaining subordinate to shared deny rules,
sandboxing and PreToolUse guards. Public commands and arguments remain unchanged.

Toolchain 1.9.0 promotes the Claude profile from document-only contribution to bounded
application building. A Pro main session can orchestrate Flash workers with disjoint
ownership of `apps/web`, `services/api` and `engines/evaluation`. The reviewed Bash
surface now admits only workspace-scoped pnpm, Go, uv, sqlc, build, test and codegen
commands. A fail-closed PreToolUse policy rejects shell chaining, arbitrary interpreters,
unscoped package commands and protected writes; sandbox network access is limited to the
package registries and source hosts required by those ecosystems. Agent Teams remain
disabled until Git/worktree isolation exists. Public LenBands commands are unchanged.

Toolchain 1.10.0 corrects the phase boundary without removing future build capability.
The active Claude profile is globally locked to `document_convergence`: ordinary agents
cannot write anywhere under `apps`, `services` or `engines`, and reviewed pnpm/Go/uv/sqlc
implementation commands are denied by the PreToolUse hook. There is no per-pack unlock.
Opening source mutation requires a protected, attested global founder authorization only
after the complete Blueprint and Artifact portfolio has zero unresolved semantic,
ownership, vocabulary, role/journey, UX, contract, NFR, governance or operational gaps.
Runtime agents and the implementation skill remain installed but dormant; the founder
local profile exposes only document-convergence agents and skills. Public commands and
arguments are unchanged. It also adds `/converge-documents`, a bounded global campaign
that inventories all document axes, fans out disjoint read-only audits, deepens one
canonical owner at a time, red-teams each batch and preserves real decision/evidence
blockers instead of self-declaring completion.

Toolchain 1.10.1 closes a false-green document-validation path exposed by the
convergence audit. YAML duplicate mapping keys are now rejected before safe loading;
previously a parser could silently retain only the final key value. The document validator
applies this check to every Blueprint, Artifact and Knowledge Asset YAML file, and a
regression test proves it fails closed. Public commands and arguments are unchanged.

Toolchain 1.10.2 adds drift enforcement for the hand-maintained Executor Dossier. It
must identify its non-authoritative, validated-index role and match canonical family-map
membership plus ACTIVE/PLANNED lifecycle counts. An orphan registry family is surfaced as
a blocker rather than counted as executor coverage. Public commands and arguments are
unchanged.

Tooling only composes repository checks and immutable-evidence runners. It must not
become an application runtime, job framework, scheduler, deployment system, or a
generic workflow engine.
