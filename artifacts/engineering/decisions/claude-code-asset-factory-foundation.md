# Claude Code / Asset Factory Foundation

## Packet boundary

**Status:** `draft` — proposal-only, non-authoritative, not an approval or authorization.

This bounded packet records current facts, revalidated findings, target design, future
unlock predicates, and protected-change packets. It does not supersede the Founder Review
Packet Index, Blueprint/framework, lifecycle authorities, freeze gate, or trust policy.
No protected file, source file, evidence file, Knowledge Asset, workflow, or runtime
contract was changed. A local Git repository baseline was created separately under the
founder-authorized CC-1 setup; no remote was created or changed.

Canonical owners consulted: `AGENTS.md`, `CLAUDE.md`, `artifacts/CONVENTION.md`,
`artifacts/operations/architecture-frozen.md`, `artifacts/operations/agent-trust-policy.yaml`,
`artifacts/operations/asset-spawn-freeze-gate.md`,
`artifacts/operations/founder-agent-governance-workflow.md`, and
`artifacts/operations/founder-review-packet-index.md`.

## 1. Revalidated current-state map

| Boundary | Classification | Current fact and authority | Non-claim / gap |
|---|---|---|---|
| Source mutation | `observed_current_state` | Trust policy phase gate is `document_convergence`, `source_mutation: locked`, with null founder authorization and completion attestation refs. | No source unlock or implementation authorization. |
| Protected paths | `observed_current_state` | Trust policy protects `.claude/**`, Blueprint/framework-adjacent authorities, tools, `.github/**`, and append-only evidence. | This packet cannot apply protected diffs. |
| Claude settings | `observed_current_state` | Settings disable workflows/connectors/skill shell execution and bypass/auto modes; runtime agents and implementation skill are denied. | Permission declarations do not prove account quota or external enforcement. |
| Local routing | `observed_current_state` | Local settings configure DeepSeek V4 Flash at high effort, explicit V4 Pro escalation, and Flash subagents. | Actual provider availability, quota, latency, model version, and account enforcement are `external_unverified`. |
| Workflows/worktrees/teams | `observed_current_state` | Workflows remain disabled; local Git now exists, but CC-7 worktree/team predicates are not proven and no enablement occurred. | Platform state, isolation, and parallel-writer proof remain unverified. |
| Git | `observed_current_state` | Local repository exists at the LenBands root on branch `main`; baseline commit `25496375043518c92e8cfdcef2842cdb49eacf6c` contains 610 files and the post-commit worktree is clean; no remote is configured. | No canonical remote, history/provenance beyond this local snapshot, GitHub protection, or repository-owner proof is inferred. |
| CODEOWNERS | `observed_current_state` | `.github/CODEOWNERS` exists and names `@tienphat` for protected paths. | Effective GitHub branch protection and account ownership are `external_unverified`. |
| Asset freeze | `observed_current_state` | Freeze policy is `review`; review does not unlock mass spawn. | No founder approval, rights clearance, publication, calibration, or mass-spawn authority. |
| Validation exception | `observed_current_state` | Policy permits one future run of at most seven draft assets only if a workflow/run record exists. | No validation run was executed or recorded. |
| Founder decisions | `observed_current_state` | Founder Review Packet Index is canonical, status `review`, with unresolved D/PD records. | This packet does not adopt or alter a founder decision. |

Current `.claude` inventory: settings files; hooks `session-context.rb`, `guard-tool-use.rb`,
`guard-config-change.rb`, `mark-dirty.rb`, `runtime_command_policy.rb`, `hook_support.rb`,
`verify-handoff.rb`; skills `close-domain-gap`, `converge-documents`, `deepen-contract`,
`handoff`, `implement-p0-slice`, `red-team-contract`, `spawn-knowledge-asset`; document
auditors/deepener/reviewer agents and dormant runtime agents; rules for convergence, pre-code
gating, and runtime composition.

## 2. Historical finding re-verification

### F-001 — Stop/handoff hook

```yaml
finding_id: F-001
reproduction_status: reproduced
current_target: .claude/hooks/verify-handoff.rb
canonical_authority_ref: [CLAUDE.md: Completion, .claude/skills/handoff/SKILL.md, .claude/hooks/verify-handoff.rb:11-15]
current_fact: Stop runs verify, gate toolchain, and gate p0; it does not run doctor.
exact_proposed_change: Add tools/bin/lenbands doctor first, preserving exits 0 for doctor/verify/toolchain and 0 or 3 for p0.
tests_or_regressions: [order and exit handling, doctor failure blocks Stop, p0 exit 3 remains accepted]
migration_impact: read-only handoff check only; no runtime migration
attestation_required: true
codeowners_required: true
rollback_plan: revert only through reviewed protected change; never disable handoff
dependencies: [protected Claude review, external CODEOWNERS/GitHub proof]
conflicts_detected: canonical completion/handoff instructions require doctor but current Stop hook omits it
non_claims: not applied, approved, live-verified, or readiness evidence
packet_status: unresolved_protected_change_packet
```

### F-002 — implementation skill gate surface

```yaml
finding_id: F-002
reproduction_status: reproduced
current_target: .claude/skills/implement-p0-slice/SKILL.md
canonical_authority_ref: [CLAUDE.md: Phase gate and Completion, .claude/skills/implement-p0-slice/SKILL.md:12,43]
current_fact: capability compile is a legitimate precondition, native tests are legitimate preconditions, and verify is a legitimate integrity check; the defect is only that the final handoff text uses bare `gate toolchain` and `gate p0` instead of the stable `tools/bin/lenbands` command surface.
exact_proposed_change: Change only the final handoff text from `gate toolchain` to `tools/bin/lenbands gate toolchain` and from `gate p0` to `tools/bin/lenbands gate p0`; preserve capability compile, native tests, verify, ordering, and all other valid preconditions.
tests_or_regressions: [exact command-surface comparison, compile/native-test/verify preconditions remain present, stable commands remain ordered, p0 exit 3 remains expected]
migration_impact: dormant workflow contract only; no source/runtime migration
attestation_required: true
codeowners_required: true
rollback_plan: restore only through reviewed protected change; never bypass phase gate
dependencies: [protected review, attestation, external CODEOWNERS/GitHub proof]
conflicts_detected: none; current evidence distinguishes valid preconditions from the bare final command defect
non_claims: not applied, approved, or implementation authorization
packet_status: application_ready_protected_proposal
founder_decision_required: false
```

### F-003 — Knowledge Asset governance fields

```yaml
finding_id: F-003
reproduction_status: reproduced
current_target: .claude/skills/spawn-knowledge-asset/SKILL.md
canonical_authority_ref: [artifacts/operations/asset-spawn-freeze-gate.md, artifacts/operations/founder-agent-governance-workflow.md]
current_fact: Skill requires checksum, prompt/model/parameter lineage, unknown_* handling, draft status, pending rights, and incomplete review; it does not explicitly require reading/recording freeze-gate state or the validation-exception/run record.
exact_proposed_change: Unresolved. Option A adds a canonical freeze preflight and blocks mass spawn while permitting only the separately recorded at-most-seven exception. Option B keeps the skill generic and adds the preflight/run-record contract to the canonical workflow owner.
tests_or_regressions: [review blocks mass spawn, only one recorded exception, required run fields, rights pending_review, status draft]
migration_impact: future workflow/skill contract only; no assets or records created
attestation_required: true
codeowners_required: true
rollback_plan: restore only through protected review without weakening freeze gate
dependencies: [canonical owner selection, founder freeze-gate approval]
conflicts_detected: skill and workflow divide responsibilities; unilateral consolidation is unsafe
non_claims: no exception used; no generation, publication, rights, calibration, or learner eligibility claim
packet_status: unresolved_options_protected_change_packet
```

## 3. PHASE B authorization matrix

The Foundation packet is a proposal and is not authorization. The current canonical
Founder Review Packet Index does not list F-001, F-002, or F-003 as an adopted protected
change. Existing attestations cover other historical permission/profile/model changes and
do not name these exact targets and diffs. Local `.github/CODEOWNERS` is not proof of
effective GitHub review enforcement because the workspace has no verified canonical Git
repository or remote.

| Finding | Reproduction | Exact current target | Protected packet | Exact authorized diff | Codeowners/review | Attestation | Authorization evidence | Apply now | Reason |
|---|---|---|---|---|---|---|---|---|---|
| F-001 | reproduced | `.claude/hooks/verify-handoff.rb` | F-001 section above | Add `tools/bin/lenbands doctor` before existing verify/toolchain/p0 sequence | Required | Required | None naming this target/diff | false | Proposal and historical attestations are not exact authorization; GitHub enforcement is unverified. |
| F-002 | reproduced | `.claude/skills/implement-p0-slice/SKILL.md` | F-002 section above | Change only bare `gate toolchain` and `gate p0` to stable `tools/bin/lenbands ...` forms | Required | Required | None naming this target/diff | false | `founder_decision_required: false` means no product choice is needed, not that protected application is authorized. |
| F-003 | reproduced | `.claude/skills/spawn-knowledge-asset/SKILL.md` | F-003 section above | Explicit freeze state, exception/run record, checksum, lineage, unknown count, rights review | Required | Required | None naming this target/diff | false | Canonical freeze/workflow policy requires review; no exact skill-owner authorization exists. |

No protected `.claude` mutation is authorized in this run. No application-ready proposal is
silently promoted to an applied change.

## 4. Claude Code control-plane audit

Official platform facts used for this audit: Claude Code permission rules are evaluated
deny → ask → allow, and a blocking `PreToolUse` hook can deny a call even when an allow rule
matches; project settings can be checked into version control; project subagents and hooks
are distinct execution surfaces; and worktree isolation assumes a Git repository. DeepSeek's
official Anthropic-compatible API documents `https://api.deepseek.com/anthropic` and the
`deepseek-v4-pro` / `deepseek-v4-flash` model identifiers. These platform facts do not prove
LenBands authorization, account quota, GitHub enforcement, provider billing, or runtime
quality.

Official references used: [Claude Code permissions](https://code.claude.com/docs/en/permissions),
[Claude Code configuration](https://code.claude.com/docs/en/configuration),
[Claude Code subagents](https://code.claude.com/docs/en/sub-agents),
[Claude Code worktrees](https://code.claude.com/docs/en/worktrees), and
[DeepSeek's Anthropic-compatible API](https://api-docs.deepseek.com/guides/anthropic_api).

| Surface | Current | Target | Authorized now | Applied | Packet-only / blocked reason |
|---|---|---|---|---|---|
| Shared settings | 26 allow and 26 deny rules; workflows, connectors, skill shell execution, bypass/auto modes, and auto-memory are disabled; protected paths and credentials are denied. | Preserve deny-first, protected-path, secret-deny, source-lock behavior; only narrow through exact protected review. | No additional change | No | Current policy is canonical and validator-approved; no improvement authorization. |
| Local settings | 71 allows, no local denies; `acceptEdits`, Flash default/high effort, explicit Pro mapping, Flash subagents; project policy still dominates. | Keep local profile bounded and credential-free; never use it to override shared denies. | No additional change | No | Current local profile is covered by historical attestation, but this run does not alter it. |
| Bash allowlist | Shared settings allow a broad `Bash` entry, but `guard-tool-use.rb` enforces exact registered LenBands/read-only/runtime patterns and rejects chaining/arbitrary commands. | Keep deterministic hook enforcement and stable `tools/bin/lenbands` surface. | No change | No | Broad convenience allow is guarded; any tightening is a protected policy change. |
| Protected paths | `guard-tool-use.rb` resolves canonical paths, blocks policy-protected paths, locks source roots, and fails closed on malformed trust policy. | Preserve; require attestation/CODEOWNERS for protected exceptions. | No | No | Protected mutation not authorized. |
| Hooks | Five registered hooks: session context, PreToolUse guard, dirty marker, Stop handoff, ConfigChange guard. Stop omits doctor (F-001). | Deterministic fail-closed hooks; Stop sequence includes doctor after authorized remediation. | F-001 no | No | F-001 packet only; no exact authorization. |
| Skills | Seven project skills; document convergence and bounded handoff are active; runtime implementation and asset spawn remain policy-gated. | Keep small composable skills with exact commands, stop conditions, verification, and non-claims. | F-002/F-003 no | No | F-002 exact protected proposal; F-003 unresolved owner/options packet. |
| Agents | Ten agents; document auditors/read-only reviewers are usable; runtime implementers are denied or phase-gated. | Narrow read/write scope, Flash workers, Pro orchestration only when globally authorized; no self-approval. | No additions/changes | No | Existing architecture is sufficient; no new agent/team writer authorized. |
| Rules | Three rules cover convergence, pre-code gate, and runtime composition; source unlock and provider neutrality are explicit. | Keep canonical rules dominant over execution optimization. | No change | No | No duplicate or conflicting rule requiring immediate mutation was proven. |
| Routing | Local config uses DeepSeek V4 Flash default and explicit V4 Pro escalation; subagents pinned to Flash. | Task-scoped eligibility → calibrated quality/reliability/privacy → cost optimization, with full lineage fields. | No routing change | No | Benchmark, quota, residency, and provider enforcement are unverified. |
| Cost controls | Repository records no proven hard provider quota, per-run guard, worst-case admission, or actual-cost reconciliation for Claude Code. | Fail closed when remaining budget is below worst-case next call; opaque telemetry only. | No | No | Proposal-only; hard enforcement unavailable/unverified. |
| Workflow/worktree/team | Workflows disabled; `EnterWorktree`, runtime agents, and implementation skill denied; no Git repository proof. | Enable only after complete CC-7 proof; otherwise all remain blocked. | No | No | Canonical Git/GitHub/worktree proof absent. |

### Skill and agent classification

| Component | Classification | Current evidence / boundary |
|---|---|---|
| `close-domain-gap` | keep | Bounded gap investigation; cannot change readiness or protected authority. |
| `converge-documents` | keep | Global document workflow; explicitly forbids source implementation and delegates only read-only audits. |
| `deepen-contract` | keep | One editable owner at a time; preserves status and requires verification. |
| `handoff` | keep | Already uses the four stable commands; Stop hook mismatch is separate F-001. |
| `implement-p0-slice` | remediate_if_authorized | F-002 exact command normalization only; source remains globally locked. |
| `red-team-contract` | keep | Read-only adversarial review. |
| `spawn-knowledge-asset` | remediate_if_authorized | F-003 explicit freeze/run-record requirements; no generation authority. |
| Document/audit agents | keep | Read-only or bounded non-protected writing scopes. |
| Runtime implementer agents | proposal_only / blocked | Dormant capability; shared deny and phase gate prevent use. |
| New Asset Factory or parallel-writer agents | proposal_only | Not created; no generation or team enablement authority. |

## 5. Full-control-plane gap report

`apply_now` is false unless exact authorization is proven. The following are gaps or
blockers, not new status values and not approvals.

| Gap ID | Severity | Current target | Current fact | Canonical authority | Impact | Exact remediation | Application authority | Apply now | Tests / rollback / non-claims |
|---|---|---|---|---|---|---|---|---|---|
| P0-CC-001 | P0 governance/safety | `.claude/hooks/verify-handoff.rb` | Stop sequence lacks doctor. | `CLAUDE.md`, handoff skill, trust policy | Handoff omits a required integrity precheck. | F-001 exact diff: add doctor first; preserve fail-closed exits. | Protected review + attestation + CODEOWNERS | false | Order/exit regression; rollback reviewed hook diff; no readiness claim. |
| P0-CC-002 | P0 governance/safety | `.claude/skills/spawn-knowledge-asset/SKILL.md` | Skill does not explicitly require freeze state and validation run record. | Freeze gate and founder workflow | Future operator could mistake generic lineage/checksum steps for freeze authorization. | F-003 option selection and exact protected application. | Canonical owner decision + protected review + attestation | false | Freeze-review blocks mass spawn; one exception only; no asset generated. |
| P0-CC-003 | P0 governance/safety | F-001/F-002/F-003 protected targets | No exact current authorization names these diffs; proposal packet is not authority. | Founder Review Packet Index and trust policy | Applying would be unauthorized protected mutation. | Obtain exact owner/CODEOWNERS evidence and attestation, or keep packet-only. | Founder/CODEOWNERS/external repository owner | false | Authorization matrix is the control; no protected mutation applied. |
| P0-CC-004 | P0 governance/safety | Git/workflow/team boundary | No verified canonical Git repository/remote/history; workflow/team proof absent. | Trust policy CC-7 predicates and Claude worktree boundary | Cannot safely enable worktrees, teams, or parallel writers. | External owner supplies canonical Git/GitHub proof and conflict/isolation tests. | External repository owner + CODEOWNERS | false | No Git commands that initialize/clone/bind; no enablement. |
| P1-CC-001 | P1 cost/reliability | Claude Code provider/account boundary | Hard quota, per-run hard guard, billing and actual usage reconciliation are unverified. | Cost/routing proposals and external provider/account authority | Estimated tokens could be mistaken for spend enforcement. | Add future gateway/account hard quota and fail-closed run admission with opaque usage refs. | Provider/account owner + operations | false | Budget monitoring remains non-enforcement; no cost claim. |
| P1-CC-002 | P1 cost/reliability | Local model routing | Flash/Pro roles are configured, but task-scoped quality/reliability benchmarks are absent. | Model-routing proposal; DeepSeek official model docs only for API facts | Cannot claim Flash suitability or a quality floor. | Run scoped benchmark before moving any quality-sensitive task class to Flash. | Operations/assessment/provider | false | No self-confidence or model name is evidence. |
| P1-CC-003 | P1 cost/reliability | Control-plane telemetry | No implemented bounded run telemetry or actual-cost reference exists. | Observability/cost target design | Cost and routing reproduction would be incomplete if future automation runs. | Future opaque fields and reconciliation path; never learner content. | Operations/provider | false | No telemetry schema or evidence created in this run. |
| P2-CC-001 | P2 ergonomics | F-002 skill text | Final two commands use bare forms despite stable command surface. | AGENTS.md and current skill | Operator copy/paste can fail or bypass intended command surface. | F-002 exact two-line normalization. | Protected review; no founder product choice | false | Compile/tests/verify remain; no broad rewrite. |
| P2-CC-002 | P2 ergonomics | Skills/agents namespace | No additional `/context`, `/audit`, `/foundation-check`, or Asset Factory skills exist. | Current skill namespace and no-create-unless-needed rules | Potential future convenience only; not a current safety defect. | Do not create until a canonical workflow requires one. | None currently | false | Packet-only; no namespace expansion. |

## 6. Adversarial review result

The review found no authorization to apply protected changes. The current packet does not
inflate proposal authority, use historical findings as current without reproduction, invent
status vocabulary, conflate Git with GitHub protection, enable workflows/worktrees/teams,
write secrets, claim Flash quality, share runtime credentials, emit learner content, call
monitoring enforcement, represent generation as publication/evidence, or treat gate success
as source unlock. F-002 was narrowed to the exact stable-command defect; F-001 and F-003
remain packet-only protected proposals.

## 7. CC roadmap and predicates

| Stage | Design/package | Execution/adoption | Owner dimension | Required proof | Blocks | Does not block |
|---|---|---|---|---|---|---|
| CC-1 Git recovery | proposal_only checklist; local baseline applied | local baseline complete; external repository owner still required for canonical proof | founder + external repository owner | local root/identity/commit verified; remote/history/provenance/ownership still require external proof | CC-7 | design/read-only audits |
| CC-2 `.claude` remediation | proposal_only F packets | protected_application_required | founder + CODEOWNERS | selected remediation, attestation, effective review | governed workflow adoption | target design |
| CC-3 routing/cost | proposal_only | blocked for claims | engineering/operations/provider | scoped benchmark, privacy, reliability, cost | pilot routing | read-only design |
| CC-4 queue/schema | proposal_only | blocked for execution | engineering/operations/founder | approved queue/source/policy contracts | CC-5, CC-6, CC-8 | schema proposal |
| CC-5 freeze approval | proposal_only packet | protected_application_required; founder required | founder + CODEOWNERS | approved gate and founder record | CC-6, CC-8 | CC-1..CC-4 design |
| CC-6 validation pilot | proposal_only | blocked: asset_freeze_gate_authority | operations/founder | exception, run record, budget enforcement, validators | CC-8 | pilot design |
| CC-7 workflow/worktree proof | proposal_only | blocked: canonical_git_and_github_proof | repo owner/CODEOWNERS | remote, protection, CODEOWNERS, isolation/conflict tests | CC-8/team enablement | packet work |
| CC-8 mass generation | proposal_only | blocked | founder/ops/provider/repo owner | CC-5/6/7 plus frozen queue, rights/source/policy/QA | CC-9 | foundation package |
| CC-9 QA/rights promotion | proposal_only | blocked | independent QA + founder/legal | scoped quality and rights evidence | publication/promotion | draft queue design |
| CC-10 calibration intake | proposal_only | blocked | assessment/ops/provider/legal | scoped dataset, thresholds, sample/review evidence | learning claims | queue coverage only |

CC-1 local baseline is applied under founder authorization: `git init -b main`, local
identity copied from existing read-only Git config, one baseline commit, and no remote
operation. It must not run `git clone`, `git remote add`, bind a remote, infer history/
provenance, or infer GitHub protection. The initial commit staged 610 existing workspace
files; `.cache/`, `.pnpm-store/`, local Claude settings, and scratch payloads were ignored.
The staged review found no private-key or credential pattern. Existing trailing-whitespace
warnings were preserved and not rewritten.

CC-1 does not satisfy CC-7. Canonical remote, external branch protection, effective
CODEOWNERS, required checks, worktree isolation, and parallel-writer conflict proof remain
external or future predicates.
CC-7 requires canonical remote/history/provenance, external branch protection, effective
CODEOWNERS and checks, tested worktree isolation, a passed parallel-writer conflict test,
and explicit protected-policy permission. CC-8 additionally requires approved freeze,
rights/content, generation/source, and budget policies; frozen queue hash; budget enforcement;
approved pilot admission/exit criteria; and independent QA.

## 8. Asset Factory target design

Target only; no assets or global lifecycle are created.

```text
queue admission → generation → deterministic/schema validation → dedupe
→ provenance verification → rights review → quality review → canonical publication handoff
```

Use only `draft | review | approved | deprecated | archived`. Supplemental fields:

```yaml
queue_version: <version>
queue_snapshot_hash: <hash>
curriculum_version: <version>
source_policy_version: <version>
generation_policy_version: <version>
workflow_id: <id>
workflow_version: <version>
asset_id: <id>
asset_class: <controlled-or-unknown_asset_class>
current_status: draft | review | approved | deprecated | archived
rights_state: <supplemental-state>
quality_review_state: <supplemental-state>
validation_run_ref: <opaque-ref>
provenance_ref: <opaque-ref>
```

Future generation records queue version/snapshot hash, curriculum version, source/generation/
workflow policy versions, and model/prompt lineage. A generated asset may improve queue
coverage only; it cannot establish curriculum coverage, rights, learner eligibility,
calibration, publication, or learning effectiveness. Failed pilot assets create no new
status: delete only where no immutable/audit-retention requirement exists; otherwise retain
under the existing lifecycle and record invalidity/supersession/disposal in run metadata.

## 9. Governed pilot proposal — not executed

```yaml
max_assets: 7 maximum under the existing exception
allowed_asset_classes: controlled classes only; otherwise unknown_asset_class and blocked
allowed_sources: founder-approved and rights-supported sources only
allowed_model: explicitly recorded provider/model/version
max_cost: founder/operations-approved numeric ceiling; unresolved
required_validators: schema, vocabulary, checksum, dedupe, provenance, rights, quality, privacy
allowed_rights_states: pending_review for draft; no publish without approval/evidence
human_escalation_rule: benchmark gaps, band boundaries, disagreement, drift, rights/legal review
governed_disposal_rule: existing lifecycle retention or governed candidate deletion
pilot_exit_criteria: validator results, scoped QA, reconciled cost, no blocking unknown_*
pilot_stop_criteria: insufficient worst-case budget, unavailable enforcement, rights/quality/privacy failure
allowed_queue_snapshot: frozen hash-recorded snapshot only
allowed_generation_policy_version: approved recorded version only
allowed_source_policy_version: approved recorded version only
```

`budget_state: within_budget | exceeded | unknown` is run metadata, not asset status.
Target enforcement is provider/account hard quota → per-run hard guard → worst-case pre-call
admission → post-call usage capture → actual-cost reconciliation. If hard enforcement is
unavailable, pilot execution is blocked. Budget monitoring is not budget enforcement.

## 10. Routing, cost, privacy, calibration

Control-plane routing and learner-runtime routing remain separate; they must not implicitly
share credentials, raw logs, learner-data authority, runtime permissions, or budget authority.
Flash is proposed for inventory/extraction/tagging/candidate generation/bounded critique and
low-risk transformations after benchmark suitability. Pro is proposed for canonical conflicts,
architecture synthesis, protected-diff design, difficult IELTS cases, and high-impact review.
No quality floor is claimed without scoped benchmark evidence.

Each route records policy version/hash, task class, eligibility result, selected mechanism,
reason, fallback chain, provider/model/version, prompt/rule version, and input-feature version.
Eligibility precedes cost: privacy/residency, rights/processing, quality, reliability, and
latency must pass first. Total cost includes tokens/cache/thinking, retries/fallbacks, ASR/TTS,
storage/egress, gateway/observability, benchmarking, labels/review, content QA, rights,
failed requests, and provider switching. Telemetry uses opaque/scoped references only and
never duplicates learner essay/audio/transcript. Quality floors declare metric, threshold,
confidence interval, minimum sample, coverage, calibration dataset, construct, population,
validity period, review date, and claim scope.

## 11. Blockers and final handoff

Founder: freeze approval, queue/source/generation policy, pilot cost ceiling, and unresolved
D/PD decisions. Protected/CODEOWNERS: F-001/F-002/F-003 selection/application, trust-policy/
config changes, and validator/gate changes. External repository owner: canonical remote,
history/provenance beyond the local snapshot, effective GitHub protection, CODEOWNERS and
required checks. Legal/provider: rights, processing/residency, quota/hard enforcement, and
usage reconciliation. Future runtime/calibration:
benchmarks, quality floors, independent QA, runtime gateway separation, and pilot evidence.

Literal handoff commands:

```text
tools/bin/lenbands doctor
tools/bin/lenbands verify
tools/bin/lenbands gate toolchain
tools/bin/lenbands gate p0
```

Doctor/verify/toolchain pass proves repository/tooling integrity only. Gate p0 exit 3 is the
expected evidence-blocked state, not proposal failure, source unlock, runtime success, P0
readiness, or product readiness. If doctor/verify/toolchain regresses, stop and report.

No downstream governance state may be inferred from this package. Generation success is not
publication success, and publication success is not learning-effectiveness evidence.

proposal-only
non-authoritative
no canonical status changed
no protected mutation
no founder decision adopted
no Git initialization, clone, or remote binding
no workflow/worktree/team enablement
no asset generation or publication
no lifecycle/status vocabulary added
no budget enforcement claimed without enforcement proof
no source unlock
no runtime/evidence/calibration/readiness claim
