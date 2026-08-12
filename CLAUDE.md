@AGENTS.md

# Claude Code — LenBands document-convergence workspace

These instructions apply to every model routed through Claude Code, including fast
or inexpensive models. They supplement, never replace, `AGENTS.md`.

## Start every turn

1. Run `tools/bin/lenbands context`.
2. Identify the canonical owner of the requested knowledge before editing.
3. Read only the relevant owner, its sidecar, and directly referenced contracts.
4. If no owner or controlled-vocabulary node exists, report `unknown_*`; do not invent it.

## Knowledge must converge

- Deepen an existing canonical owner instead of creating a parallel document.
- Do not create a new Markdown/YAML authority file unless the user explicitly asks and
  no current owner exists.
- Catalogs, indexes, matrices, generated files and reports are projections, not truth.
- Durable learning belongs in a versioned repository owner. Project auto-memory is
  disabled because private model notes must not become shadow architecture.
- Every assertion must be classified as one of: existing contract, cited source,
  runtime evidence, explicit proposal, or unresolved gap.
- Never convert missing evidence into prose, fabricated records, approval, calibration,
  rights, provenance, benchmark results or readiness.
- Keep status at `draft` or `review` unless real approval evidence already exists.
- Reuse mature Go, Python and Next.js frameworks through adapters. Do not build a
  framework, runtime, queue, cache, scheduler, validator library or provider clone.

## Phase gate: documents before source code

- The repository is currently in `document_convergence`. Blueprint and Artifact
  ambiguity is the work; application implementation is not yet authorized.
- The presence of source directories, build commands, `/implement-p0-slice`, or runtime
  agents is capability preparation only. It never grants permission to start coding.
- Do not edit `apps/**`, `services/**` or `engines/**`, install application dependencies,
  run code generation, or spawn implementation agents while the phase gate is locked.
- `verify` and `gate toolchain` prove repository/tooling integrity only. They do not open
  the implementation gate. `gate p0` exit `3` must remain visibly blocked.
- There is no partial or per-pack unlock. Implementation may begin only after a
  privileged, attested policy change records the founder's explicit global authorization
  and confirms the whole IELTS Blueprint and Artifact portfolio is complete, consistent,
  traceable and approved across all 180 capabilities, roles, journeys and cross-cutting
  concerns. Any `unknown_*`, draft/review owner, ownership conflict, vocabulary/coverage
  gap, undecided product/technology choice or unsupported readiness claim keeps every
  source workspace locked.
- Runtime acceptance and benchmark evidence that intrinsically require an implementation
  are post-code gates; they must not be fabricated as a shortcut to unlock coding.
- When the gate is closed, use document workers only: `repo-cartographer`,
  `ielts-semantics-auditor`, `contract-deepener`, `red-team-reviewer` and
  `verification-auditor`. Protected-owner changes remain proposals for privileged review.
- Once explicitly unlocked, runtime workspace ownership is fixed: `apps/web` = Next.js,
  `services/api` = Go and `engines/evaluation` = Python. Do not create parallel roots.
- Agent Teams remain disabled until Git and worktree isolation exist. Project subagents
  are sufficient for bounded document convergence and cost less than independent teams.
- Sandboxed package install, build, lint, code generation and tests are available only
  after the phase gate is unlocked and only through the reviewed workspace-native
  command allowlist. Shell chaining and arbitrary interpreter execution remain forbidden.

## Write boundary

- Protected authority and tooling paths are read-only in normal Claude Code sessions.
- If a request requires a protected change, explain the required change and stop for a
  privileged, independently reviewed workflow. Never weaken or bypass the hook.
- Direct evidence writes are forbidden. Evidence may only be created by its registered
  fail-closed runner from real inputs.
- Use native `Read`, `Glob`, `Grep`, `Edit` and `Write` tools. Bash is restricted to
  registered LenBands checks plus exact workspace-native pnpm, Go, uv, sqlc and
  read-only Docker/Git commands enforced by the project hook. Wildcard shell expansion,
  command chaining and unscoped interpreters are forbidden.
- `MultiEdit`, `PowerShell`, `Monitor`, bypass/auto permission modes and unsandboxed
  command escapes are disabled. Do not attempt to reach the same operation through an
  alternate tool or child process.
- Built-in reads and sandboxed subprocesses cannot access repository environment files,
  common cloud/SSH credential stores, or secret environment variables.
- The founder-local execution profile may be pre-provisioned from the reviewed project
  template. Bounded sessions cannot modify project/local settings or project skills;
  configuration changes require the protected review + attestation path.
- Founder-local `acceptEdits` removes prompts for ordinary editable files only. Shared
  deny rules, sandbox boundaries and PreToolUse guards still take precedence.
- Founder sessions default to DeepSeek V4 Flash at provider-supported `high` effort.
  V4 Pro is an explicit session escalation; every subagent remains pinned to Flash and
  agents must not silently promote themselves.

## Completion

- Run `tools/bin/lenbands verify` and `tools/bin/lenbands gate toolchain`.
- Run `tools/bin/lenbands gate p0`; exit `3` is an expected blocked state while real
  evidence is missing and must never be changed to success.
- Report exactly which canonical owners were deepened and which gaps remain.
- Do not claim the application/runtime is ready merely because repository checks pass.

Detailed path-scoped rules live in `.claude/rules/` and enforcement lives in
`.claude/hooks/`. Do not modify either from a normal agent session.

Use `/converge-documents all` as the default campaign. It may fan out disjoint read-only
audits and one-owner-at-a-time document deepening, but it cannot unlock source code.
Do not invoke `/implement-p0-slice` in the current phase. After a privileged global
unlock, use it for the selected implementation sequence and delegate each source boundary to the
least-privileged project agent. Dynamic workflows and agent-team writers remain disabled
until Git worktree isolation exists.
