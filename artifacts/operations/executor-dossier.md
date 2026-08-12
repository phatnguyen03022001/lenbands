# Executor Dossier — Deprecated Historical Convergence Snapshot

- **Type:** convergence projection — derived from canonical owners.
- **Status:** `deprecated` — preserved historical snapshot; not a current convergence authority
- **Owner:** document-convergence orchestrator
- **Created:** 2026-08-10
- **Phase gate:** `document_convergence` (source code globally locked)

> **Do not use this file for current family coverage, current protected decisions, or readiness.**
> The current validated family index is
> `artifacts/operations/catalogs/executor-dossier.md`; the canonical founder-decision
> index is `artifacts/operations/founder-review-packet-index.md`.

## Historical purpose

This file preserves the 2026-08-10 convergence snapshot. It is not a single pane of glass and must
not be used as an authority for current capability, lifecycle, OpenAPI, BOPS, protected-diff, or
readiness state.

## Historical convergence state at a glance (2026-08-10)

| Axis | Truthful state (2026-08-10) |
|---|---|
| Capability count | 180 (33 ACTIVE, 146 PLANNED, 1 DEPRECATED) — verified |
| Family count | 26 defined, 25 referenced |
| Capability-to-family mapping | 180/180 resolve — verified |
| Runtime specs deepened | 6/6 ACTIVE have executor dossier sections — verified |
| PLANNED deferred reference | `deferred-families-reference.md` exists (promo gates defined) — draft |
| **Canonical OpenAPI authority** | **MISSING** — no unified API contract exists; writing-task-2 OpenAPI is partial |
| **Lifecycle state machine contract** | **PARTIAL** — per-family states exist in runtime specs but no cross-entity lifecycle system, no terminal/recovery/replay semantics |
| **BOPS contracts** | **PARTIAL** — build-buy + managed-platform-baseline exist; per-provider data/IAM/SLO/exit contracts are shallow or missing |
| Protected conflicts | **4 unresolved** (see §Protected changes queue) |
| verify / gate toolchain | ✅ PASS |
| gate p0 | exit 3 (33 blockers — correct blocked state) |


## Batch progress

| Batch | Scope | Status | What was done | What is STILL MISSING |
|---|---|---|---|---|
| **0** | Audit fixes + founder packets | done | 6 metadata/reference/risk fixes, founder-decision-packet created | Founder has not made identity/residency decisions |
| **A** | Runtime spec deepening | partial | 6/6 ACTIVE runtime specs read; REVIEW.ErrorToReview deepened with executor dossier; cross-family event ownership verified clean | 4 protected conflicts NOT resolved (see queue); no canonical OpenAPI for any P0 family; lifecycle state machines are per-family prose, not unified contract |
| **B** | Learning/practice families | partial | PLACEMENT/STUDY runtime specs verified deep; READING/LISTENING/PRACTICE deferred ref created | No deferred API classifications; no lifecycle for PLANNED entities |
| **C** | Assessment families | partial | WRITING/REVIEW runtime specs verified deep; SPEAKING/PRONUNCIATION/MOCK deferred ref created | SPEAKING.Practice orphan not resolved; PRACTICE.Drill collision not resolved; WRITING.Evaluation deprecated interaction ref not traced |
| **D** | Content/knowledge/search/PKM/localization | shallow | Deferred ref entries exist for 5 families | No transport classification; no lifecycle; no API contract |
| **E** | Progress/personal/notification/subscription/admin/governance | shallow | Deferred ref entries exist for 7 families | Same as D; GOVERNANCE.Quality deprecated-only lifecycle smell not resolved |
| **DELIVERABLE A** | Canonical OpenAPI authority | NOT STARTED | — | One OpenAPI authority, transport classify all 180 caps, resolve A1/A2/A3 |
| **DELIVERABLE B** | Full lifecycle system | NOT STARTED | — | Unified state machines, terminal states, retry/replay/idempotency, resolve 4 conflicts |
| **DELIVERABLE C** | Full BOPS contract pack | NOT STARTED | — | Per-provider data/IAM/SLO/exit contracts, founder packets for pending decisions |

## Convergence criteria (Definition of Done)

For each ACTIVE (P0) capability:

- [ ] Capability ID resolves to family → delta → owner spec
- [ ] User outcome stated
- [ ] Actors and permissions defined
- [ ] State transitions defined (canonical states, not prose)
- [ ] API operations owned and traced to OpenAPI
- [ ] Events classified: producer, consumer, schema, privacy filter
- [ ] Failure modes classified: code, recovery, learner-facing projection
- [ ] Privacy class assigned and retention/export/delete path confirmed
- [ ] Cost boundary assigned with fallback behavior
- [ ] Acceptance tests referenced (even if not yet runnable)
- [ ] Evidence requirements listed with current blocker
- [ ] Non-goals explicit

For each PLANNED family:

- [ ] Executor-grade deferred contract created (family README or equivalent)
- [ ] Capability-to-family mapping verified
- [ ] Promotion gate stated (what evidence/policy unlocks this family)
- [ ] Known dependencies on ACTIVE families documented
- [ ] Phase and rationale recorded

## Protected changes queue — 4 unresolved conflicts

These conflicts touch protected SSOT (blueprint/*, capability-family-registry.yaml, capability-lifecycle-registry.yaml). They require privileged review + options + migration impact + validator impact + attestation. They are NOT resolved.

### CONFLICT 1: SPEAKING.Practice family orphan
- **What:** `SPEAKING.Practice` family defined in `capability-family-registry.yaml` (line 211–228) with `lifecycle: PLANNED`, `status: planned`, `owner_spec: null`, `shared_entities: [SpeakingPrompt, SpeakingRecording, SpeakingAttempt]`. But 0 capabilities assigned in `capability-lifecycle-registry.yaml`.
- **Why it matters:** All speaking capabilities (EVAL.Speaking, EVAL.Examiner, LEARN.Speaking) map to `SPEAKING.Evaluation`. SPEAKING.Practice has no reason to exist unless practice-only speaking is a deliberate separate entry point.
- **Options:**
  - A: Remove SPEAKING.Practice family (merge entities into SPEAKING.Evaluation). Requires family registry + lifecycle registry update.
  - B: Assign capabilities to SPEAKING.Practice (LEARN.Speaking) and keep SPEAKING.Evaluation for evaluation only. Requires product decision.
  - C: Keep as `idle` with explicit rationale — practice recording workflow is architecturally separate from evaluation.
- **Protected files touched:** `capability-family-registry.yaml`, `capability-lifecycle-registry.yaml`
- **Current state:** unresolved — deferred to founder

### CONFLICT 2: PRACTICE.Drill capability/family collision
- **What:** `PRACTICE.Drill` *capability* (P0 ACTIVE) lives in `REVIEW.ErrorToReview` family. `PRACTICE.Drill` *family* (PLANNED) hosts PRACTICE.Set/Timed/Adaptive — different scope. Same name, different layer.
- **Why it matters:** The de-facto architecture is that retest-drill belongs to error-to-review, while general-drill belongs to a separate practice family. This is intentional but confusing — the name collision creates ambiguity.
- **Options:**
  - A: Rename capability to `REVIEW.RetestDrill` (clear semantic boundary). Requires blueprint/03-features.md change.
  - B: Rename family to `PRACTICE.GeneralDrill` (reserves PRACTICE.Drill for capabilities). Requires family registry change.
  - C: Document as intentional and add explicit cross-family note in both specs (already done in error-to-review-runtime.md). No registry change.
- **Protected files touched:** `blueprint/03-features.md` (option A), `capability-family-registry.yaml` (option B)
- **Current state:** documented in error-to-review-runtime.md but not formally resolved — deferred to founder

### CONFLICT 3: WRITING.Evaluation deprecated interaction reference
- **What:** `WRITING.Evaluation` family references `interaction_spec: artifacts/experience/specs/interaction/writing-evaluation.md` in family registry. The referenced interaction spec is at `review` status but the runtime spec references `writing-task-2.md` vertical slice instead.
- **Why it matters:** Two competing interaction owners — the family-level interaction_spec vs the vertical-slice-level spec. Only one can be canonical.
- **Options:**
  - A: Align family interaction_spec to point to vertical slice `writing-task-2.md` (the actual canonical owner). Requires family registry update.
  - B: Deprecate the family interaction_spec field for WRITING.Evaluation and use delta-level interaction references. Requires architecture change.
- **Protected files touched:** `capability-family-registry.yaml`
- **Current state:** unresolved — deferred to founder

### CONFLICT 4: GOVERNANCE.Quality deprecated-only lifecycle smell
- **What:** `GOVERNANCE.Quality` family has exactly 1 capability assigned: `GOVERNANCE.AntiGaming` (PLANNED). This supersedes the deprecated `EVAL.AntiGaming`. But 1 capability does not justify a full family — especially when P0 governance lives in OPS.QualityEconomics.
- **Why it matters:** A family with 1 PLANNED capability and no owner_spec is a placeholder, not an implementation unit. It may never need to exist as a separate family at runtime.
- **Options:**
  - A: Merge GOVERNANCE.Quality capabilities into OPS.QualityEconomics (one governance family). Requires family + lifecycle registry update.
  - B: Keep as planned with explicit promotion gate: family activates when ≥ 3 governance capabilities beyond P0 are promoted.
  - C: Demote to `DEFERRED_FAMILY` marker — not listed in active family registry but tracked in roadmap.
- **Protected files touched:** `capability-family-registry.yaml`, `capability-lifecycle-registry.yaml`
- **Current state:** unresolved — deferred to founder

## Pending founder decisions

| Decision | Packet | Urgency | Blocks |
|---|---|---|---|
| Data residency stance | `founder-decision-packet-identity-and-residency.md §Decision 1` | Before provisioning | Neon/GCP/DeepSeek region eligibility, DPA scope |
| OIDC identity provider | `founder-decision-packet-identity-and-residency.md §Decision 2` | Before closed pilot | P0-01 (IDENTITY.Core) provisioning, auth middleware |
| Gold corpus procurement | `build-buy-register.md §9.1 Instance C` | Before benchmark | P0-04, P0-06 activation |
| Numeric cost thresholds | `cost-budget.md` + `benchmark/numeric-threshold-policy.yaml` | After benchmark | Cost guardrails armed |

## Verified invariants (post-audit)

1. ✅ 180 capabilities all resolve to family and lifecycle state with no orphans.
2. ✅ All 33 ACTIVE capabilities have non-null `owner_spec` matching family registry.
3. ✅ All 25 family references in lifecycle registry exist in family registry.
4. ✅ Blueprint `03-features.md` capability catalog matches lifecycle registry exactly.
5. ✅ `build-buy-register.md` + `managed-platform-baseline-decision.md` are consistent — no contradictory provider selection.
6. ✅ `managed-platform-baseline-decision.md` properly gates activation behind DPA, benchmark, and release evidence.
7. ✅ No `deepseek-chat`/`deepseek-reasoner` legacy alias in any non-deprecated contract.
8. ✅ DeepSeek thinking-mode sensitivity and peak-pricing risk documented as unverified external risks.
9. ✅ PostHog designated as default observability surface (analytics + flags + error tracking); Sentry on-trigger.
10. ✅ Numeric cost ceilings remain `unarmed`.

## Open gaps (truthful — not deferred, real)

1. **No canonical OpenAPI authority.** Two competing files exist: `writing-task-2/openapi.yaml` (v0.5.0, review, 25 ops covering all 6 P0 packs) and `contracts/openapi.yaml` (v0.2.1, draft, 5 live identity ops + 8 deprecated placeholders). The two files are bound by `api-ownership-bff-contract.md` which states the transition is incomplete. Issues: version drift (0.2.0 vs 0.2.1), `/v1/me` prefix overlap, schema duplication, no admin endpoints, deprecation mechanics unresolved. A1/A2/A3 resolved as design contracts in `openapi/README.md` but the files themselves are not yet unified.
2. **No unified lifecycle state machine contract.** Per-family states exist in 6 runtime specs as prose. No cross-entity lifecycle definitions: terminal states, cancellation, retry, replay, idempotency, archival, deletion, export, restore are not consistently defined.
3. **BOPS contracts partial.** `build-buy-register.md` + `managed-platform-baseline-decision.md` cover provider selection. Per-provider contracts (data classes allowed, IAM, quota bands, SLO, backup/restore, RPO/RTO, exit exercise, scale-up path) are shallow or nonexistent.
4. **SPEAKING.Practice orphan** — 0 capabilities assigned to a defined family. See protected conflict 1.
5. **PRACTICE.Drill collision** — same name at capability vs family layer. See protected conflict 2.
6. **WRITING.Evaluation interaction ref** — competing references. See protected conflict 3.
7. **GOVERNANCE.Quality 1-capability family** — smells like placeholder. See protected conflict 4.
8. **`founder-review-packet-index.md` does not exist.** User expected it. The 21 protected diffs referenced by the user were never catalogued or queued.
9. **`cost-budget.md` still references bare `numeric-threshold-policy.yaml`** — the fix was only applied to `managed-platform-baseline-decision.md`.

## Current work — Deliverable A (in progress)

Establishing ONE canonical OpenAPI authority at `artifacts/engineering/contracts/openapi/`.
Transport-classifying all 180 capabilities. Resolving A1/A2/A3.

## Next after Deliverable A

Deliverable B (lifecycle system), then Deliverable C (BOPS contracts).
Founder-review-packet-index.md created during this phase.

## References

- `artifacts/operations/global-certification-ledger.md` (companion projection)
- `artifacts/operations/build-readiness-matrix.md`
- `artifacts/operations/capability-lifecycle-registry.yaml`
- `artifacts/operations/capability-family-registry.yaml`
- `artifacts/business/decisions/build-buy-register.md`
- `artifacts/business/decisions/managed-platform-baseline-decision.md`
- `artifacts/business/decisions/founder-decision-packet-identity-and-residency.md`
