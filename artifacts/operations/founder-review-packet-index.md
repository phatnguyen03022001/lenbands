# Founder Review Packet Index

- **Type:** review-packet-index — **CANONICAL index** of pending founder decisions and protected diffs.
- **Status:** `review` — incomplete; full audit pending.
- **Created:** 2026-08-10
- **Owner:** founder
- **Canonical status:** This is the single canonical founder-review index for the LenBands repository. All other review/tracking artifacts that list founder decisions or protected diffs are projections pointing here.

## Relationship to other artifacts

- `artifacts/business/decisions/founder-decision-packet-identity-and-residency.md` — DETAILED BODY for decisions D-01 (data residency) and D-02 (identity provider). This index references it; it does not compete with it.
- `artifacts/operations/catalogs/executor-dossier.md` — current validated family-coverage index; references this index for pending decisions/diffs.
- `artifacts/operations/executor-dossier.md` — deprecated historical snapshot; retained only for traceability.
- `artifacts/operations/global-certification-ledger.md` — capability status projection; references blocker status from this index.

## Purpose

Single canonical index of every pending founder decision, protected diff, and unresolved conflict that blocks
document-convergence or the transition to application implementation.

## Pending founder decisions

| # | Decision | Packet | Urgency | Blocks |
|---|---|---|---|---|
| D-01 | Data residency stance (A/B/C) | `artifacts/business/decisions/founder-decision-packet-identity-and-residency.md §1` | Before provisioning | Neon/GCP/DeepSeek region, DPA scope |
| D-02 | OIDC identity provider selection | `artifacts/business/decisions/founder-decision-packet-identity-and-residency.md §2` | Before closed pilot | P0-01 activation |
| D-03 | Gold corpus procurement | `build-buy-register.md §9.1 Instance C` | Before benchmark | P0-04, P0-06 |
| D-04 | Numeric cost thresholds | `cost-budget.md` + `benchmark/numeric-threshold-policy.yaml` | After benchmark | Cost guardrails armed |
| D-05 | Value/pricing for premium | `build-buy-register.md` (deferred) | Before public pilot | SUBSCRIPTION.Usage family promotion |
| D-06 | STUDY.CheckIn P0 capability scope: retain standalone or remove | see § D-06 detailed section below | Before P0-03 API alignment (Phase 2.1) | P0-03 transport reconciliation, daily-action contract API table, transport-classification STUDY.CheckIn row, capability-manifest data_entities |

## Protected diffs queue

Protected diffs touch files under `blueprint/**`, `artifacts/operations/capability-*`, `tools/**`,
or other protected paths. Each requires: options analysis, migration impact, validator impact, and
attestation before application.

| # | Conflict | Files affected | Options | Status |
|---|---|---|---|---|
| PD-01 | SPEAKING.Practice family orphan (0 caps) | capability-family-registry.yaml, capability-lifecycle-registry.yaml | Remove / Assign / Keep-idle | Unresolved |
| PD-02 | PRACTICE.Drill name collision (cap vs family) | blueprint/03-features.md or capability-family-registry.yaml | Rename cap / Rename family / Document | Partial (documented in runtime spec) |
| PD-03 | WRITING.Evaluation interaction reference ambiguity | capability-family-registry.yaml | Align to vertical slice / Deprecate family field | Unresolved |
| PD-04 | GOVERNANCE.Quality 1-cap family | capability-family-registry.yaml, capability-lifecycle-registry.yaml | Merge into OPS / keep with gate / demote | Unresolved |
| PD-05 | P0-06 scope exceptions: (a) OPS.ContentQuality ACTIVE + deferred-no-runtime (phase exception); (b) anti_gaming_flagged event P0-vs-P1 scope (B3-3) | (a) capability-lifecycle-registry.yaml (lifecycle=ACTIVE), transport-classification.yaml (class=deferred-no-runtime); (b) capability-manifest.yaml:202, event-ownership-registry.yaml:43 | (a) Accept exception: keep ACTIVE, document deferred_reason, require founder-approved phase decision OR Demote lifecycle to PLANNED; (b) Keep anti_gaming_flagged in P0-06 as P1-gated placeholder OR Remove from P0-06 events/manifest | Unresolved — deferred_reason in transport-classification.yaml is documentation, not approval. B3-3 (formerly unassigned) is canonically routed here: anti_gaming_flagged already has canonical ownership (OPS.QualityEconomics, producer governance_worker); the open question is P0-vs-P1 scope. These are two independent P0-06 scope-boundary questions documented under one decision entry because both constrain what belongs in the P0-06 pack. |
| PD-06 | Event authority completeness for learning/error-fix, practice, and release-gate events | event-schema-pack.md, event-ownership-registry.yaml, lifecycle-contract.md, blueprint/03-features.md | Add canonical ownership / rename to an existing canonical event / remove only from a non-authoritative reference | Unresolved — founder/engineering decision required; no owner, schema, privacy class, or producer is invented here. |
| PD-07 | P0 readiness matrix row comparison false-green hardening | tools/commands/validate/documents.rb, proposed regression coverage under tools/test/ | Fail closed on missing/malformed rows and compare only complete matching row signatures | Unresolved — exact protected implementation proposal recorded below; no validator or test change applied. |

## Imported founder decision register — scoped A1 relationship and reconciliation

`artifacts/operations/decisions/lenbands-decision-register-v1.0.0-founder-locked-2026-08-12.md`
is the immutable repository record of the Founder’s 2026-08-12 decision-phase selections.
Its row authority is `A1_FOUNDER_SELECTED_UNRECORDED`, not `A0_CANONICAL`; the import records
founder selection and does not itself adopt a decision into canonical repository governance.
The companion reconciliation ledger is a row-level projection of the immutable source, not an
SSOT. The sequence remains:

```text
working direction / founder selection
→ per-dimension adoption
→ change authorization
→ protected application
→ structural/contract/runtime/evidence verification
```

The current pending/unresolved records above remain the owner-facing records. The table below
records only exact or explicitly partial scope proven by the imported source; nonmatches retain
their existing status. No row below is called applied, authorized, verified, ready, or approved
merely because an A1 selection was recorded.

| ID | Previous index status | Reconciliation status | Exact source anchor | Selected dimension / scope | Remaining owner, protected, or external prerequisites; reason |
|---|---|---|---|---|---|
| D-01 | Pending founder decision | `founder_direction_recorded` | Register §6.1 `V1.1`, line 296 | No hard early data-residency requirement; Vietnam is the initial market. This records the residency-stance dimension only; the Singapore topology rows are separate provider direction. | Canonical A0 adoption; legal/DPA and provider-region review; provisioning/activation gates. No legal approval or provider activation is claimed. |
| D-02 | Pending founder decision | `founder_direction_recorded` | Register §6.3 `V3.2`, line 339; §6.4 `V4.2`, line 359; §6.8 V7 `Identity`, line 487 | Auth0 is the selected managed identity direction. | Canonical A0 adoption; DPA/data-use/region review; export/delete/token/rate-limit tests; activation gates. No provider procurement or activation is claimed. |
| D-03 | Pending founder decision | `not_reconciled_from_register` | Related register §6.13 V10C, lines 653–719 | No exact gold-corpus procurement, rights, or label-selection row is present; evidence/retest rows do not select a corpus. | Gold-corpus owner must choose/procure/rights-verify/label-verify a corpus before benchmark. Existing status unchanged. |
| D-04 | Pending founder decision | `partial_scope_recorded` | Register §6.15 `10E.13`, line 793 | Multiple operational budgets are selected instead of only a monthly company bill. Numeric warning/hard threshold values are not selected. | Founder must approve numeric thresholds, measurement source, provider-price version, owner, and review frequency; current policy remains unarmed. |
| D-05 | Pending founder decision | `partial_scope_recorded` | Register §6.10 `V9.29`, line 569; §6.15 `10E.22`, line 802 | Premium value direction is depth/personalization/assessment/analytics with fair-use entitlement, not token packages. Numeric pricing is not selected. | Founder/product/operations must set price, entitlement/quota, fair-use and measured economics; canonical adoption remains pending. |
| D-06 | Pending founder decision | `not_reconciled_from_register` | Related register §6.10 `V9.23`, line 563 | Daily Plan inputs are selected, but no exact standalone-retain/remove `STUDY.CheckIn` scope decision is present. | Founder must choose retain/remove; protected manifest/Blueprint/lifecycle and contract reconciliation then require owner review and, where applicable, CODEOWNERS/attestation. Existing status unchanged. |
| PD-01 | Unresolved | `not_reconciled_from_register` | Related register §6.10 `V9.13`, line 553 | Speaking progression is selected, but no exact orphan-family remove/assign/keep-idle decision is present. | Founder scope choice plus protected family/lifecycle reconciliation and review. Existing status unchanged. |
| PD-02 | Partial (documented in runtime spec) | `not_reconciled_from_register` | Related register §6.10 `V9.2`, line 542 | Skill presentation is selected, but no exact `PRACTICE.Drill` capability/family rename-or-document decision is present. | Founder/engineering namespace decision, migration/projection review, and protected application prerequisites. Existing status unchanged. |
| PD-03 | Unresolved | `not_reconciled_from_register` | Related register §6.10 `V9.10–V9.12`, lines 550–552 | Writing progression and rewrite loop are selected, but no exact `interaction_spec` reference alignment/deprecation decision is present. | Engineering owner and protected registry review; no reference change applied. Existing status unchanged. |
| PD-04 | Unresolved | `not_reconciled_from_register` | Related register §6.9 V8, lines 513–532 | Operational quality/recovery directions are selected, but no exact `GOVERNANCE.Quality` family merge/keep/demote decision is present. | Founder/engineering family decision and protected registry/lifecycle review. Existing status unchanged. |
| PD-05 | Unresolved | `not_reconciled_from_register` | Related register §7 V10F.13–V10F.19, lines 830–836 | Coverage/support/calibration gate semantics are selected, but no exact P0-06 `OPS.ContentQuality` or `anti_gaming_flagged` scope decision is present. | Founder P0 scope choice plus protected lifecycle/manifest/transport/event review. Existing status unchanged. |
| PD-06 | Unresolved | `not_reconciled_from_register` | Related register §6.13 V10C.1, lines 655–659 | Evidence provenance semantics are selected, but no exact canonical owner/schema/producer decision for the five event questions is present. | Founder/engineering event-authority choice, protected contract/registry review, attestation and external CODEOWNERS review. Existing status unchanged. |
| PD-07 | Unresolved | `not_reconciled_from_register` | Related register §10 W0-C, lines 935–935 | Canonical reconciliation is a pending gate, but no exact fail-closed parser/comparator implementation decision is present. | Protected validator-owner review, attestation, regression tests, and external CODEOWNERS review. Existing status unchanged. |

For the 13 current D/PD records, reconciliation counts are exactly:
`founder_direction_recorded=2`, `partial_scope_recorded=2`,
`not_reconciled_from_register=9`, `out_of_repository_decision=0`.
The full 325-row projection and its separate row-level counts are in the companion ledger.

### Cross-reference: V7 provider topology and 10F implementation rows

The enhanced reconciliation ledger (v1.1.1) reclassifies an additional 31 rows that have proven
canonical targets beyond the 13 D/PD dimensions above. Owner references are dimension-scoped:

- **19 rows `canonical_reconciliation_required`**: 6 D-dimension rows (D-01, D-02 ×3, D-05 ×2)
  plus 11 V7 non-Auth0 boundary rows (Cloud Run, Cloudflare/OpenNext, Region, Neon, Backup,
  R2, Redis, Admin auth, Staging, IaC, Provider rule) plus 2 audio-ephemeral rows (V3.7,
  V9.14). The managed-platform baseline is retained only for its exact provider/baseline
  dimensions: Cloud Run, Cloudflare/OpenNext, Neon, R2, Redis, and the provider rule. D-02
  owns the Admin auth identity boundary; the provider-neutral topology contract is cited for
  Region, independent backup/restore, and Staging; IaC has no current canonical owner because
  that contract expressly excludes it. V3.7 and V9.14 target the speaking/speech-processing
  decision owner. All remain blocked by engineering specification and A0 adoption, not founder
  choice.
- **22 rows `implementation_specification_required`**: 20 10F rows (IMPL-1 schemas) plus
  2 V9.21–V9.22 Mastery rows (missing Mastery entity/contract).
- **2 rows `external_evidence_or_legal_required`**: V3.8 (AI training DPA) and 10E.13
  (numeric cost thresholds).
- **1 row `calibration_or_validation_required`**: V6.10 (calibrated quality floor).
- **281 rows `no_current_owner_target`**: Legitimate founder decisions without current
  repository canonical owner files.

No A0 adoption, protected mutation, or readiness claim is made for any row. The immutable A1
register remains the sole authority for all 325 rows pending the W0-C canonicalization gate.

## PD-06 — Event authority completeness

**Status:** Unresolved. This packet records a protected-change proposal only. No event schema, ownership registry, lifecycle contract, Blueprint, projection, or evidence file was changed.

**Severity:** High — an executor cannot establish one canonical owner/schema boundary for events that are already referenced by canonical event material or lifecycle policy.

**Verified evidence:**

- The canonical Event Schema Pack defines `learning_error_fix_started`, `learning_error_fix_completed`, and `practice_started` with typed payload shapes at `artifacts/engineering/contracts/events/event-schema-pack.md:50-64`.
- The same events are absent from the source-of-truth ownership registry, whose complete current event map is `artifacts/engineering/contracts/events/event-ownership-registry.yaml:6-45`.
- Blueprint event references include `practice_started` and both learning-error fix events at `blueprint/03-features.md:366` and `blueprint/03-features.md:385`.
- Lifecycle policy references `release_gate_blocked` and `release_gate_approved` at `artifacts/engineering/contracts/runtime/lifecycle-contract.md:410-417`, but neither event is defined in the Event Schema Pack or ownership registry.
- The prior protected attestation explicitly records that `practice_started` and the paired learning-error fix events remain unassigned pending an explicit founder decision at `artifacts/operations/attestations/g-02-clear-event-ownership-20260808.yaml:18-20`.
- The frozen invariant requires every event to have exactly one canonical owner/schema, with allowed producers explicitly declared, at `artifacts/operations/architecture-frozen.md:60-62`.

**Affected protected files if a decision is adopted:**

- `artifacts/engineering/contracts/events/event-ownership-registry.yaml` and its sidecar.
- `artifacts/engineering/contracts/events/event-schema-pack.md` and its sidecar if event names or payload semantics change.
- `artifacts/engineering/contracts/runtime/lifecycle-contract.md` if release-gate references are classified as audit-only or renamed.
- `blueprint/03-features.md` if canonical product event references change.
- Any generated publisher/consumer or family projections required by the selected owner; no projection is to be edited manually.

**Options:**

1. **Add canonical ownership.** Add each retained event to the protected ownership registry only after selecting one existing owner family, one schema authority, one allowed producer boundary, and a permitted envelope privacy class. Until selected, these fields remain `unknown_event_owner`, `unknown_event_schema`, `unknown_event_producer`, and `unknown_event_privacy_class` as review gaps, not contract values.
2. **Rename to an existing canonical event.** Permitted only if semantic equivalence is evidenced and producer/consumer migration, event-version treatment, and projection reconciliation are specified. No equivalent existing event is established by the current files.
3. **Remove from a non-authoritative reference.** Permitted only where the reference is demonstrably non-authoritative. Removing the events from the canonical Event Schema Pack, Blueprint, or lifecycle authority requires a protected scope/contract decision and cannot be treated as cleanup.

**Recommended direction:** Preserve the existing names for review because they are present in the canonical schema/Blueprint, but do not assign an owner or producer by inference. Founder and Engineering must decide whether each event is canonical, renamed, or removed from a non-authoritative reference. For the release-gate events, first decide whether they are canonical events or immutable audit-only records; the current evidence does not support unilateral registration.

**Migration impact:** A canonical-registration decision affects event ownership validation, publisher allowlists, consumer subscriptions, schema/version projections, analytics/governance consumers, and release/audit records. A rename or removal requires consumer migration and a protected reconciliation record. Payloads must remain opaque-reference-only and must not contain learner essay, audio, or error text; the Event Schema Pack privacy rules remain binding at `artifacts/engineering/contracts/events/event-schema-pack.md:21-26` and `:88-99`.

**Validator impact:** The future implementation must update the protected ownership/schema inputs atomically and pass the registered ownership, semantic-contract, projection, and full verification checks. This proposal does not weaken or change any validator, gate, event schema, or ownership file.

**Attestation and review required before application:** The change must provide `change_id`, `change_scope`, `protected_changes_reviewed`, `authority_boundaries_changed`, `validators_weakened`, `evidence_modified`, `readiness_claimed`, `commands_run`, and `external_review_required`, with `protected_changes_reviewed: true`, `validators_weakened: false`, `evidence_modified: false`, and `readiness_claimed: false`, per `artifacts/operations/agent-trust-policy.yaml:253-269`. External CODEOWNERS review and the required GitHub protections remain mandatory under `artifacts/operations/agent-trust-policy.yaml:271-279`.

**Decision requirement:** Founder/Engineering choice required. External CODEOWNERS review is additionally required for any protected application. PD-06 is not approved, not applied, and does not establish readiness.

## PD-07 — P0 readiness matrix row comparison false-green hardening

**Status:** Unresolved. This packet records the exact protected implementation and regression-test proposal only. `tools/commands/validate/documents.rb` and `tools/test/**` were not changed.

**Severity:** High — the current comparison can silently omit a row from both parsed maps, allowing `nil == nil` or equal empty signatures to avoid a row-level mismatch. A one-sided missing row already mismatches, but the parser does not fail closed for missing rows in both sources, malformed rows, duplicates, or source/line diagnostics.

**Verified evidence:**

- `tools/commands/validate/documents.rb:130-135` parses only rows matching a permissive regular expression and converts them with `compact.to_h`, so unmatched/malformed rows disappear and duplicate IDs use last-value semantics.
- `tools/commands/validate/documents.rb:137-145` compares only keys present in both hashes and does not explicitly require all six P0 rows in each source before comparing.
- A read-only Ruby probe against the current extraction logic returned `both_missing: true`, `both_malformed: true`, `one_missing: false`, and `mismatched: false`; this is verification of current parser behavior, not a repository evidence record.
- The compared source rows are the six Blueprint P0 rows at `blueprint/03-features.md:311-316` and the six readiness-matrix rows at `artifacts/operations/build-readiness-matrix.md:27-32`.
- The architecture contract requires validators to be coverage gates and generated projections to be reproducible at `artifacts/operations/architecture-frozen.md:24-26` and `:64`.

**Affected protected files if adopted:**

- `tools/commands/validate/documents.rb` — proposed fail-closed parser/comparator change.
- A proposed regression test file under `tools/test/` — exact path and cases below; no test file was created.
- Any protected manifest or trust-boundary attestation required by the actual implementation workflow.

**Exact proposed implementation patch — not applied:**

```diff
diff --git a/tools/commands/validate/documents.rb b/tools/commands/validate/documents.rb
@@
-extract_p0 = lambda do |text|
-  text.each_line.map do |line|
-    match = line.match(/^\| `?(P0-0[1-6])`?[^|]*\| ([^|]+) \|/)
-    next unless match
-    [match[1], match[2].scan(/`([A-Z][A-Z0-9_]*\.[A-Za-z][A-Za-z0-9_]*)`/).flatten.sort]
-  end.compact.to_h
-end
+p0_ids = (1..6).map { |number| format("P0-%02d", number) }
+extract_p0 = lambda do |text, source_label|
+  rows = {}
+  text.each_line.with_index(1) do |line, line_number|
+    next unless line.include?("|") && line.match?(/\bP0-0[1-6]\b/)
+    match = line.match(/\A\s*\|\s*`?(P0-0[1-6])[^|]*\|\s*([^|]+?)\s*\|/)
+    unless match
+      errors << "#{source_label}: malformed P0 row at line #{line_number}"
+      next
+    end
+    id, capability_cell = match.captures
+    capability_ids = capability_cell.scan(/`([A-Z][A-Z0-9_]*\.[A-Za-z][A-Za-z0-9_]*)`/).flatten.sort
+    if capability_ids.empty?
+      errors << "#{source_label}: malformed P0 row #{id} at line #{line_number}: no capability IDs"
+      next
+    end
+    if rows.key?(id)
+      errors << "#{source_label}: duplicate P0 row #{id} at line #{line_number}"
+      next
+    end
+    rows[id] = capability_ids
+  end
+  p0_ids.each do |id|
+    errors << "#{source_label}: missing P0 row #{id}" unless rows.key?(id)
+  end
+  rows
+end
@@
-  feature_rows = extract_p0.call(features)
-  matrix_rows = extract_p0.call(File.read(matrix_path))
-  (1..6).each do |number|
-    id = format("P0-%02d", number)
-    errors << "P0 capability mismatch for #{id}" unless feature_rows[id] == matrix_rows[id]
-  end
+  feature_rows = extract_p0.call(features, "blueprint/03-features.md")
+  matrix_rows = extract_p0.call(File.read(matrix_path), "artifacts/operations/build-readiness-matrix.md")
+  p0_ids.each do |id|
+    next unless feature_rows.key?(id) && matrix_rows.key?(id)
+    errors << "P0 capability mismatch for #{id}" unless feature_rows[id] == matrix_rows[id]
+  end
```

The proposed comparator deliberately compares the current row signature — the controlled capability-ID set — and does not invent a new readiness-state vocabulary. The required “mismatched state” regression case therefore means an equal P0 row ID with a different extracted row signature. If a future authority adds a separate `readiness_state` comparison, that must be separately schema-owned and protected.

**Exact proposed regression cases — not applied:**

1. **Missing left row:** Blueprint fixture omits `P0-03`, matrix fixture contains a valid `P0-03`; expect `blueprint/03-features.md: missing P0 row P0-03` and failure.
2. **Missing right row:** Matrix fixture omits `P0-03`, Blueprint fixture contains a valid `P0-03`; expect `artifacts/operations/build-readiness-matrix.md: missing P0 row P0-03` and failure.
3. **Malformed row:** A table row contains `P0-03` but its capability cell has no controlled capability IDs; expect a source/line-specific malformed-row error and failure.
4. **Mismatched state/row signature:** Both sources contain `P0-03`, but their sorted capability-ID sets differ; expect `P0 capability mismatch for P0-03` and failure.
5. **Valid matching row:** Both fixtures contain exactly one valid row for each `P0-01` through `P0-06` with matching sorted capability-ID sets; expect no P0-row errors.
6. **Additional duplicate-row hardening:** Either source contains two rows for the same P0 ID; expect a duplicate-row error and failure.

**Migration impact:** No runtime migration. The future validator change changes only document-validation failure behavior. Existing valid P0 rows must continue to pass; malformed, missing, duplicate, and mismatched rows must fail before any readiness conclusion. `verify` and `gate toolchain` must remain green only when their full required inputs are valid.

**Validator impact:** This is a protected validator change and must receive negative regression coverage. It must remain fail-closed, preserve `gate p0` exit `3` for current evidence blockers, and not convert missing evidence into readiness.

**Attestation and review required before application:** The actual implementation must provide all fields and invariants listed in `artifacts/operations/agent-trust-policy.yaml:253-269`, including `readiness_claimed: false`, `validators_weakened: false`, `evidence_modified: false`, and `external_review_required: true`. External CODEOWNERS review and required GitHub protections remain mandatory at `artifacts/operations/agent-trust-policy.yaml:271-279`.

**Decision requirement:** No founder product choice is evidenced as necessary for the exact fail-closed hardening proposal; external CODEOWNERS review, protected-change attestation, and validator-owner review are required before application. PD-07 is not approved, not applied, and does not establish readiness.

## D-06 — STUDY.CheckIn P0 capability scope decision

**Status:** Unresolved. This packet records a founder product decision proposal only. No OpenAPI, Blueprint, framework, registry, manifest, lifecycle, transport-classification, event schema, or evidence file was changed.

**Severity:** High — STUDY.CheckIn is an ACTIVE P0 capability with no dedicated HTTP endpoint in either live OpenAPI file. The transport-classification maps it to `startStudySession` (`POST /v1/study/sessions`), but that operation starts a session from a plan action and does not capture check-in data (`minutes_available`, `energy`). The check-in data entity (`daily-action-contract.md:26-29`) is absent from `capability-manifest.yaml:89` data_entities. The daily-action contract API table (`daily-action-contract.md:74`) defines `POST /v1/today/check-in` as a contract path with no corresponding OpenAPI operation. This gap blocks P0-03 API alignment (Phase 2.1) and must be resolved before the daily-action contract can be reconciled to the OpenAPI candidate surface.

**Verified evidence:**

- `blueprint/03-features.md:313` — P0-03 profile includes `STUDY.CheckIn` as a capability ID.
- `artifacts/operations/capability-lifecycle-registry.yaml` — `STUDY.CheckIn` lifecycle `ACTIVE`, phase `P0`, family `STUDY.DailyAction`, status `candidate`.
- `artifacts/operations/capability-manifest.yaml:80,88-89` — P0-03 `api_operations: [getTodayPlan, startStudySession, updateStudySession]` does not include any check-in operation; `data_entities: [DailyPlan, NextAction, StudySession]` does not include `CheckIn`.
- `artifacts/engineering/contracts/openapi/transport-classification.yaml:101-106` — `STUDY.CheckIn` class `public-http`, mapped to `operation_id: startStudySession`, path `POST /v1/study/sessions` — a transport operation that starts a session, not check-in.
- `artifacts/engineering/contracts/writing-task-2/openapi.yaml` — contains `startStudySession` (`:119-137`) and `updateStudySession` (`:138-157`); no `/v1/today/check-in` path exists.
- `artifacts/engineering/contracts/daily-action-contract.md:10,26-29,74` — defines `CheckIn` entity owned by authenticated learner, with fields `check_in_id`, `minutes_available`, `energy: low|normal|high|skipped`; API table lists `POST /v1/today/check-in`.
- `artifacts/engineering/runtime/daily-action-runtime.md:62-63` — lists `CheckIn` as a written entity; API paths include `POST /v1/today/check-in`.
- `artifacts/experience/specs/vertical-slices/daily-action.md:5,43-50` — defines CheckIn screen with UI states `default, skipped, low_energy, saved`; entity table `:64` binds CheckIn to event `session_started`.
- `artifacts/experience/specs/interaction/daily-action.md:5-9` — interaction steps do not include a dedicated CheckIn command.

**Existing file-proven CheckIn facts (retained regardless of decision):**
- Data contract fields: `check_in_id`, `minutes_available` (integer|null), `energy` (low|normal|high|skipped) — `daily-action-contract.md:26-29`.
- UI states: `default, skipped, low_energy, saved` — `vertical-slices/daily-action.md:43-50`.
- Learner purpose: declare time availability and energy level so the plan adjusts action length without changing outcome or rubric — `daily-action-contract.md:10`.
- CheckIn is always skippable; skipped uses default budget; low-energy reduces scope — `vertical-slices/daily-action.md:47-49`.
- Event binding: `session_started` — `vertical-slices/daily-action.md:64`.
- API path reference in contract: `POST /v1/today/check-in` — `daily-action-contract.md:74`.

Future API/schema/status/event/privacy/idempotency/observability details remain unresolved until the founder selects an option and the relevant authority owners (engineering for OpenAPI/contract, product for vertical-slice scope) review the implementing diff.

**Option A — Retain STUDY.CheckIn as a standalone P0 capability**

Facts (file-proven, not recommendation):
- The daily-action vertical slice defines four CheckIn UI states with explicit copy and decision rules.
- The daily-action runtime spec records `CheckIn` as a written entity owned by the plan service.
- The interaction spec does not include a CheckIn command, meaning the interaction surface is currently defined only in the vertical slice, not in the interaction contract.

If CheckIn is retained as a standalone capability, the following files require review (protected vs non-protected classified per `agent-trust-policy.yaml protected_paths`):

Protected files (require CODEOWNERS review + attestation):
1. `artifacts/operations/capability-manifest.yaml:89` — add `CheckIn` to P0-03 `data_entities`; add a corresponding operation to `api_operations`.

Non-protected authority-impacting contracts (no CODEOWNERS requirement; owner review):
2. `artifacts/engineering/contracts/writing-task-2/openapi.yaml` — add a check-in endpoint and schema. Exact path, operationId, request/response shape, status codes, and idempotency behavior are post-decision engineering design, not determined by this packet.
3. `artifacts/engineering/contracts/openapi/transport-classification.yaml:101-106` — update operation_id and path to the new endpoint.
4. `artifacts/engineering/contracts/daily-action-contract.md:71-76` — align API table to the new OpenAPI operation.
5. `artifacts/engineering/runtime/daily-action-runtime.md:63` — align API paths.

Migration impact: no runtime migration (pre-code). Manifest data_entities and api_operations updated; transport-classification row updated; contract and runtime spec aligned. Proposed regression/invariant for the implementing diff (not asserted as current validator capability): transport-classification should map every ACTIVE capability to a real operationId. Whether the current validator set enforces this must be confirmed against the actual validator code at implementation time.

**Option B — Remove STUDY.CheckIn as a standalone capability**

Facts (file-proven, not recommendation):
- The interaction spec does not include a dedicated CheckIn command; the flow is OpenToday → SelectNextAction → StartAction.
- The runtime spec entity list (`daily-action-runtime.md:29`) lists `DailyPlan, NextAction, StudySession, SessionCheckpoint` — `CheckIn` is recorded as written at `:62` but is not in the primary entity list.
- Preserving or retiring the existing time/energy semantics (`minutes_available`, `energy`) is a post-decision contract-design question. Whether the concept survives as fields on another entity, as a UI-only affordance, or is retired entirely is not determined by this packet.

If CheckIn is removed as a standalone capability, the following files require review:

Protected files (require CODEOWNERS review + attestation):
1. `artifacts/operations/capability-lifecycle-registry.yaml` — change `STUDY.CheckIn` lifecycle from `ACTIVE` to `DEPRECATED` with a replacement reference.
2. `artifacts/operations/capability-manifest.yaml:80,88-89` — remove `STUDY.CheckIn` from P0-03 `capability_ids`; update `data_entities` if the check-in concept survives in the data model.
3. `blueprint/03-features.md:313` — remove `STUDY.CheckIn` from P0-03 profile capability IDs.

Non-protected authority-impacting contracts (no CODEOWNERS requirement; owner review):
4. `artifacts/engineering/contracts/openapi/transport-classification.yaml:101-106` — deprecate or remove the `STUDY.CheckIn` row.
5. `artifacts/engineering/contracts/daily-action-contract.md` — remove `CheckIn` entity from boundary/ownership, data contract, and API table; update conflict documentation. Whether time/energy semantics are preserved elsewhere is a post-decision design question.
6. `artifacts/engineering/runtime/daily-action-runtime.md` — remove `CheckIn` from written entities and API paths.
7. `artifacts/experience/specs/vertical-slices/daily-action.md` — remove CheckIn screen from scope and entity table. The founder must decide whether to preserve, redesign, or retire the time/energy learner outcome (adjust action length without penalty); the implementing contract must define and validate it later. Whether the outcome survives through a fold, a redesign, or is retired is not determined by this packet.

Projection updates (non-authoritative):
- `artifacts/engineering/decisions/openapi-unification-review-packet.md` — update §6.2.1.
- `artifacts/engineering/decisions/founder-review-21-diff-annex.md` — if any B-diff references CheckIn.
- `artifacts/operations/catalogs/executor-dossier.md` — if CheckIn is referenced in gap list.
- `artifacts/operations/global-certification-ledger.md` — if CheckIn is listed in P0-03 capability row.

Migration impact: one capability ID deprecated; `capability-manifest.yaml` P0-03 capability_ids reduced; `transport-classification.yaml` row deprecated; `blueprint/03-features.md` P0-03 profile reduced; daily-action-contract, runtime spec, and vertical slice updated. Event `session_started` is already the binding event per the vertical slice. Proposed regression/invariant for the implementing diff (not asserted as current validator capability): `implementation-catalog.rb` should verify ACTIVE capability count consistency after the deprecation, and transport-classification must not map a deprecated capability to a live operationId. Whether the current validator set enforces these must be confirmed against the actual validator code at implementation time.

**Decision ownership and review requirements**

- **Decision owner:** Founder — P0 product scope decision affecting P0-03 pack content.
- **CODEOWNERS review:** Required only for protected-file changes (manifest, lifecycle registry, Blueprint). Non-protected contracts (OpenAPI, transport-classification, daily-action-contract, runtime spec, vertical slice, projection files) require owner review but not CODEOWNERS.
- **Attestation:** Required for protected-file changes per `agent-trust-policy.yaml:253-269`: `change_id`, `change_scope`, `protected_changes_reviewed: true`, `authority_boundaries_changed`, `validators_weakened: false`, `evidence_modified: false`, `readiness_claimed: false`, `commands_run`, `external_review_required`.
- **Pre-requisite:** None — independent of D-01..D-05 and PD-01..PD-07.
- **Post-decision:** Founder selection enables the implementing protected diff (analogous to P0-02A/P0-03A-D in the openapi-unification-review-packet). Exact API/schema/status/event/idempotency/observability design is deferred to the implementing diff and its authority-owner review.

**Impact on non-CheckIn P0-03 concerns (Option A vs Option B)**

| Concern | Option A (retain) | Option B (remove) |
|---|---|---|
| DailyPlan | Check-in adjusts action length, not plan identity | Action-length adjustment semantics are a post-decision contract-design question |
| StudySession | Session start follows optional check-in | Post-decision contract-design question |
| Accessibility | Check-in optional/skippable; no penalty | Same |
| No-plan / fallback | `no_plan` and `fallback_offered` states unchanged | `no_plan` → route to P0-02 unchanged |
| Event ownership | Existing `session_started` binding per vertical slice | Existing `session_started` unchanged |
| Observability | Post-decision | Post-decision |
| Acceptance | Post-decision | Post-decision |

**Facts vs recommendations:** The facts above are file-proven from cited canonical owners. Option A and Option B are presented as equal alternatives. No recommendation is made. No decision has been made. D-06 is not approved, not applied, and does not establish readiness.

**Count ledger (non-overlapping; no artificial total):**
- 21 historical B-IDs across 4 convergence batches.
- B4-1..B4-4 are represented by current PD-IDs: B4-1→PD-03, B4-2→PD-01, B4-3→PD-02, B4-4→PD-04.
- B3-3 is routed as a subdecision under PD-05.
- 16 remaining historical B-IDs are tracked in the 21-diff annex (B1-1..B1-10, B2-M3, B2-M6, B2-P0-02, B2-P0-04, B3-1, B3-2).
- 7 current PD records: PD-01..PD-07.
- 6 current D records: D-01..D-06.
- Summing PD + D + B-ID counts creates overlapping categories and is not a meaningful total.

Detailed annex: `engineering/decisions/founder-review-21-diff-annex.md` (bidirectional link).

## Phase 2 Execution Plan — ordered remediation sequence

This section groups unresolved items into five execution tracks. Current records per the D-06 non-overlapping ledger: 7 PD-IDs (PD-01..PD-07), 6 D-IDs (D-01..D-06), and 16 historical B-IDs tracked separately in the 21-diff annex (B4-1..B4-4 are represented by PD-01..PD-04; B3-3 is routed as a subdecision under PD-05). These categories overlap, so they are not summed into a single total. No item in track A–C claims runtime readiness; track D and E remain evidence-blocked. All unprotected items reference their detailed evidence in the 21-diff annex.

### Track A — Apply after technical CODEOWNERS review + attestation

These 16 items can proceed without founder product decisions. Each requires protected-change attestation per `agent-trust-policy.yaml:253-269` and external CODEOWNERS review where the target file is protected.

| # | Item | Target file(s) | Semantic change | Migration impact | Regression / validator checks | Attestation fields required |
|---|---|---|---|---|---|---|
| A01 | B1-4 | `blueprint/framework/band-descriptor-map.md:62` | Replace Chinese chars with English rewrite (LR band 3) | None; framework version bump to 1.0.7 | Framework frontmatter validator; no semantic change | standard 9-field attestation; `validators_weakened: false` |
| A02 | B1-6 | `blueprint/framework/band-descriptor-map.md:138` | Replace Chinese chars with English rewrite (PR band 9) | None; same file bump as A01 | Same as A01 | Same as A01 |
| A03 | B1-7 | `blueprint/framework/band-descriptor-map.md:140` | Replace Chinese chars with English rewrite (PR band 7) | None; same file bump as A01 | Same as A01 | Same as A01 |
| A04 | B1-8 | `blueprint/framework/error-taxonomy.md:43` | Replace Chinese chars with English rewrite | Framework file bump | Framework frontmatter validator | Same as A01 |
| A05 | B1-9 | `blueprint/framework/speaking-parts-framework.md:170` | Replace Chinese chars with English rewrite | Framework file bump | Framework frontmatter validator | Same as A01 |
| A06 | B1-10 | `blueprint/framework/band-descriptor-map.md:139` | Replace Chinese chars with English rewrite (PR band 8) | Same file bump as A01 | Same as A01 | Same as A01 |
| A07 | B1-1 | `blueprint/framework/microskill-enum.md:42` | Fix `R_matching_information` → `R_matching_information_paragraph` | Verify `R_matching_information_paragraph` exists in `skill-questiontype-band.md` first; bump file version; regenerate projections | Framework vocabulary validator; projection regeneration gate | `controlled_vocabulary_verified: true` required |
| A08 | B1-2 | `blueprint/framework/microskill-enum.md:63` | Fix `flow_chart_labelling` → `L_flow_chart_completion` | Verify `L_flow_chart_completion` exists in `skill-questiontype-band.md` first; bump file version; regenerate projections | Same as A07 | Same as A07 |
| A09 | B2-M3 | `artifacts/operations/capability-manifest.yaml:21` | Align P0-01 states to auth-identity-contract vocabulary | Manifest is compiler seed; regenerate capability projections | Manifest state validator; semantic-contract validator | `manifest_state_alignment: true` |
| A10 | B2-P0-02 | `artifacts/operations/capability-manifest.yaml:53` | Align P0-02 states to OpenAPI/lifecycle vocabulary | Same as A09 | Same as A09 | Same as A09 |
| A11 | B2-P0-04 | `artifacts/operations/capability-manifest.yaml:119` | Split P0-04 states into submission axis vs evaluation axis | Separate submission lifecycle from evaluation lifecycle; may require adding a second axis field | Manifest structure validator; projection regeneration | `manifest_axis_split: true` |
| A12 | B3-1 | `blueprint/03-features.md:314` | Change privacy from compound `learning/assessment` → single `assessment` | Aligns P0-04 privacy class across Blueprint, data contract, lifecycle contract | Privacy classification validator; document validator | `privacy_class_alignment: true` |
| A13 | B3-2 | `blueprint/03-features.md:316` | Change P0-06 privacy from `assessment` → `derived` | Governance/quality data is derived, not raw assessment; aligns with data classification model | Same as A12 | Same as A12 |
| A14 | B4-1 / PD-03 | `artifacts/operations/capability-family-registry.yaml:114` | Point `interaction_spec` from deprecated `writing-evaluation.md` → canonical `writing-task-2.md` | Single-field ref update; regenerate web-surface inventory projection | `implementation-catalog.rb` should reject deprecated refs (future hardening); currently checks only file existence | `interaction_spec_alignment: true`; standard 9-field attestation |
| A15 | B2-M6 | `blueprint/framework/review-mapping.md` | Either add composition rule for compound `fsrs_card_kind` cells OR normalize to single values | Framework file bump; regenerate review-mapping projections | Framework frontmatter validator; no new vocabulary unless composition tokens are added | engineering design choice documented in attestation |
| A16 | PD-07 | `tools/commands/validate/documents.rb` + `tools/test/` | Apply exact fail-closed patch recorded in PD-07 section below; add 6 regression test cases | No runtime migration; changes document-validation failure behavior only; existing valid rows continue to pass | Negative regression coverage: missing-row, malformed-row, duplicate-row, mismatched-row, valid-row; `gate p0` must remain exit 3 | `readiness_claimed: false`; `validators_weakened: false`; `evidence_modified: false`; `external_review_required: true` |

### Track B — Founder decisions required

These 8 items require explicit founder product/scoping/identity choices before any protected change is applied.

| # | Item | Decision | Options | Canonical packet |
|---|---|---|---|---|
| B01 | PD-01 / B4-2 | SPEAKING.Practice orphan family | (a) Remove from registry (b) Assign speaking practice capabilities via scope decision (c) Keep idle with annotation | `founder-review-packet-index.md` PD-01 |
| B02 | PD-02 / B4-3 | PRACTICE.Drill name collision | (a) Rename capability `PRACTICE.Drill` → `REVIEW.RetestDrill` (b) Rename family `PRACTICE.Drill` → new name (c) Document collision and keep both | `founder-review-packet-index.md` PD-02 |
| B03 | PD-04 / B4-4 | GOVERNANCE.Quality 1-cap family | (a) Merge into OPS.QualityEconomics (b) Keep with promotion gate (c) Demote/deprecate | `founder-review-packet-index.md` PD-04 |
| B04 | PD-05 (+ B3-3) | P0-06 scope exceptions: OPS.ContentQuality phase exception + anti_gaming_flagged event scope | OPS.ContentQuality: (a) Accept ACTIVE+deferred exception (b) Demote to PLANNED. anti_gaming_flagged: (a) Keep in P0-06 as P1-gated placeholder (b) Remove from P0-06 events/manifest | `founder-review-packet-index.md` PD-05 |
| B05 | PD-06 | Event authority for 5 events (learning_error_fix_started, learning_error_fix_completed, practice_started, release_gate_blocked, release_gate_approved) | (a) Add canonical ownership to event-ownership-registry.yaml (b) Rename to existing canonical events (c) Remove non-authoritative references | `founder-review-packet-index.md` PD-06 |
| B06 | D-01 | Data residency stance | Options A/B/C in `founder-decision-packet-identity-and-residency.md §1` | `founder-review-packet-index.md` D-01 |
| B07 | D-02 | OIDC identity provider selection | Options in `founder-decision-packet-identity-and-residency.md §2` | `founder-review-packet-index.md` D-02 |
| B08 | D-06 | STUDY.CheckIn P0 capability scope | (a) Retain standalone: add endpoint, schema, manifest/transport updates (b) Remove: deprecate capability, fold check-in data into startStudySession. Detailed evidence and impact assessment in § D-06 below. | `founder-review-packet-index.md` D-06 |

### Track C — Official IELTS source required

These 2 items cannot proceed until verified against a named, versioned, dated official IELTS source.

| # | Item | Question | Required evidence |
|---|---|---|---|
| C01 | B1-3 | Does `band-descriptor-map.md:142` Speaking PR band 5 text match the official IELTS Band 4 descriptor? | Named official IELTS publication (URL + retrieval date) showing the official PR band 4 and band 5 descriptors |
| C02 | B1-5 | What is the correct official wording for FC band 8 at `band-descriptor-map.md:89` (currently garbled "fluency chia")? | Named official IELTS publication (URL + retrieval date) showing the official FC band 8 descriptor |

### Track D — External evidence / procurement

These 3 items require external procurement, pricing, or legal decisions before application.

| # | Item | Decision | Blocks |
|---|---|---|---|
| D01 | D-03 | Gold corpus procurement (≥30 cases, rights-verified, label-verified) | P0-04 benchmark, P0-06 quality gate |
| D02 | D-04 | Numeric cost thresholds (per-evaluation ceiling, alert threshold, review frequency) | Cost guardrails armed; requires real provider pricing |
| D03 | D-05 | Value/pricing for premium | SUBSCRIPTION.Usage family promotion (P1) |

### Track E — Post-code evidence (correctly blocked by `gate p0` exit 3)

These items require a running application and must not be fabricated pre-code.

- Gold corpus labeling and rights verification
- Benchmark runs (MAE <0.5 band, calibration thresholds, per-criterion accuracy)
- P0-01..P0-06 acceptance runs
- Backup/restore drills, exit exercises
- Provider DPA agreements
- Founder approval attestation

## Pre-code gate checklist

- [ ] All 7 current PD-IDs resolved or queued with founder-approved or CODEOWNERS-approved path (PD-01..PD-07).
- [ ] All 16 separately-tracked historical B-IDs revalidated against current protected-path state (B4-1..B4-4 are represented by PD-01..PD-04; B3-3 is routed as a subdecision under PD-05).
- [ ] All 6 founder decisions recorded (D-01..D-06).
- [ ] Phase 2 Execution Plan tracks A–C executed or queued; tracks D–E remain evidence-blocked.
- [ ] OpenAPI: two-file state resolved; transport-classification.yaml machine-verified; A1/A2/A3 implemented.
- [ ] Lifecycle: all entity state machines reconciled; 3 discrepancies resolved; coverage matrix zero-uncovered.
- [ ] BOPS: per-provider data axes verified against DPA/region; all values labelled dated design targets.
- [ ] `verify` + `gate toolchain` pass; `gate p0` exit 3.

## References

- `artifacts/operations/catalogs/executor-dossier.md` — current family-coverage index
- `artifacts/operations/global-certification-ledger.md` — 180-cap projection
- `artifacts/business/decisions/founder-decision-packet-identity-and-residency.md` — identity + residency
- `artifacts/business/decisions/managed-platform-baseline-decision.md` — provider baseline
- `artifacts/business/decisions/build-buy-register.md` — build/buy boundary
