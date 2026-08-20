@AGENTS.md

# Claude Code — LenBands bounded workspace

These instructions apply to every model routed through Claude Code. They supplement, never replace, `AGENTS.md`.

## Start every turn

1. Run `tools/bin/lenbands context`.
2. Identify the canonical owner from `DOCS.yaml` before editing.
3. Read the target family's problem/risk entries before implementation planning.
4. Read only the relevant owner, sidecar and directly referenced contracts.
5. Missing enum/node/contract → `unknown_*`; do not invent it.

## Knowledge must converge

- Deepen an existing canonical owner instead of creating a parallel authority.
- Catalogs, indexes, matrices, generated files and reports are projections, not truth.
- Project auto-memory is disabled; private model notes must not become shadow architecture.
- Every assertion is existing contract, cited source, runtime evidence, explicit proposal or unresolved gap.
- Never fabricate approval, calibration, rights, provenance, benchmark, legal decision, incident evidence or readiness.
- Keep lifecycle `draft`/`review` unless real approval evidence exists.
- Buy commodity infrastructure; do not build a custom framework, queue, cache, auth system, workflow engine or model-serving layer without an evidence-backed exception.

## Implementation authorization

The repository supports **family-scoped implementation authorization**. This is different from release readiness.

- Repository state is fail-closed: application source mutation is locked when no external authorization context exists.
- There is no global requirement to complete all 180 capabilities before implementing one eligible P0 family.
- A privileged launcher may authorize one `P0-01`…`P0-06` family from an exact reviewed repository baseline and one bounded source scope.
- Authorization is external to the candidate tree. Repository files cannot authorize themselves or claim founder approval.
- The guard requires family ID, exact baseline SHA, source scope, founder authorization reference and authorization attestation reference. Missing/mismatched context keeps source locked.
- Protected governance, evidence, `.claude`, Blueprint, API authority and tooling paths remain locked even when application source is authorized.
- Implementation eligibility requires resolved design/contract semantics and no implementation-blocking risk. Runtime/legal/rights evidence that intrinsically requires code belongs to release readiness, not a circular pre-code gate.
- Synthetic/fixture implementation does not authorize collection or processing of real learner data.
- `gate p0` may remain blocked after source implementation is allowed; never reinterpret that blocked release gate as a reason to fabricate evidence.

## Source/runtime boundary

- Canonical P0 application workspace is `apps/web` under the current composition-first architecture.
- `services/**` and `engines/**` are not alternative default topologies. Do not create a Go/Python service because a legacy implementation agent exists.
- Schema/backfill work follows `artifacts/engineering/data-migration-contract.yaml`.
- P0 UI/state work follows `artifacts/experience/critical-path-usability-contract.yaml` from component design, not as post-build polish.
- Runtime/time/reproducibility semantics live in `artifacts/engineering/runtime-contract.yaml`.
- The runtime command allowlist remains fail-closed until a native dependency/build command is explicitly reviewed for the authorized workspace. Source authorization alone does not authorize arbitrary shell or package-manager commands.
- Agent Teams remain disabled until Git/worktree isolation exists.

## Write boundary

- Protected authority/tooling paths are read-only in normal Claude sessions.
- Direct evidence writes are forbidden; evidence comes from registered fail-closed runners using real inputs.
- Use native Read/Glob/Grep/Edit/Write. Bash is restricted to registered LenBands checks and reviewed runtime commands.
- Shell chaining, arbitrary interpreter execution, unsandboxed escape, `MultiEdit`, `PowerShell`, `Monitor`, bypass/auto permission modes and secret access remain forbidden.
- Founder-local `acceptEdits` affects ordinary editable files only; shared denies, sandbox and hooks take precedence.
- Founder sessions default to DeepSeek V4 Flash at high effort. V4 Pro is explicit escalation; subagents stay pinned to Flash unless policy changes.

## Agent usage

Without external implementation authorization, use document/review agents only: `repo-cartographer`, `ielts-semantics-auditor`, `contract-deepener`, `red-team-reviewer`, `verification-auditor`.

With valid family-scoped authorization, implementation-agent delegation may be enabled only for the authorized family/source scope and must still obey protected paths, architecture, risk coverage and runtime command policy. Historical Go/Python/Next.js-specific agent names are compatibility surfaces, not topology authority.

## Completion

- Run `ruby tools/commands/validate/problem-risk-coverage.rb`.
- Run `tools/bin/lenbands verify` and `tools/bin/lenbands gate toolchain`.
- Run `tools/bin/lenbands gate p0`; a blocked result is truthful while release evidence is missing.
- Report which canonical owners/source family changed and which implementation/release blockers remain.
- Never claim application or runtime readiness because repository checks pass.

Detailed path rules live in `.claude/rules/`; enforcement lives in `.claude/hooks/`. Knowledge must converge, `unknown_*` remains explicit, gate toolchain and gate p0 remain distinct, and no partial evidence may be promoted to release truth.
