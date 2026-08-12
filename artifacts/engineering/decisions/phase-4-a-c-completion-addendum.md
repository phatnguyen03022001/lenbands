# Phase 4 A–C Completion Addendum

- Status: review — bounded proposal/decision package only
- Version: 0.1.2
- Owner: document-convergence orchestrator
- Authority: projection of the Phase 4 target learning architecture proposal and the canonical founder-review index
- Adoption status: proposal
- Protected mutation: none

## 0. Boundary and count rule

This addendum completes the A01–A16, B01–B08, and six-workstream C handoff at
proposal/decision level. It does not apply a protected change, select an external
source/provider/region, create evidence, unlock source, add a capability, or claim runtime,
P0 readiness, calibration, or certification.

A founder index, ledger, annex, catalog, generated projection, or historic packet is used only
to route to the current canonical owner. current canonical owner/evidence below names the
authority file and the cited proof of the current fact.

Resolution classes:

- mechanical — exact target is supported and semantics remain unchanged;
- semantic — controlled vocabulary, state, privacy, or ownership meaning must be reconciled;
- architecture_affecting — representation or boundary must be designed before application;
- external_source_dependent — named external source/evidence is a prerequisite;
- protected_validator — validator/gate behavior changes and needs attestation/external review.

### Package counts

| package | complete rows | unresolved application choice | external/protected blocker | runtime/readiness claim |
|---|---:|---:|---:|---|
| A01–A16 | 16/16 | 0 founder choices; design/owner review remains | protected targets; A16 is a protected validator | none |
| B01–B08 | 8/8 | founder/protected/engineering choices remain where stated | owner/protected workflow and D-01/D-02/D-06 choices | none |
| C workstream audit | 6/6 | target package adoption is not selected | C-source-01/02 and calibration remain blocked | none |

A resolution-class count: mechanical=9, semantic=4, architecture_affecting=2,
external_source_dependent=0, protected_validator=1. Official-source questions remain in the
existing C01–C02 source packet; they do not make A01–A06 external-source dependent.

## 0.1 Non-authoritative governance state model

The following is a proposed working model for decision-package governance only. It is **not**
adopted, is not a global schema or tooling contract, and does not replace any canonical decision,
authority registry, lifecycle registry, validator, gate, evidence record, or release policy.

```text
working_direction_recorded
  → direction_selected
  → authority_dimension_adopted
  → change_authorized
  → change_applied
  → verification_by_dimension
```

### State semantics

- `working_direction_recorded` means a proposal has captured a direction for review. It must
  include:

  ```yaml
  working_direction:
    source: <explicit input or proposal reference>
    proposed_by: founder_directed_input | architecture_proposal
    recorded_at: <timestamp>
    canonical_status: non_authoritative
  ```

- `direction_selected` is true only when an explicit record in the canonical owner exists. A
  selected record must include:

  ```yaml
  direction_selected:
    value: <selected value or option>
    selected_by: <canonical owner or explicitly authorized founder record>
    authority_ref: <canonical decision ID + exact section + version>
    selected_at: <timestamp>
    selection_scope: <decision dimension and bounded scope>
  ```

  A filename alone is not an `authority_ref`. A completion addendum may enrich or clarify a
  decision, but it may not supersede canonical decision status unless the canonical owner
  explicitly adopts the addendum's wording in the canonical authority.

  **direction_selected = true is invalid unless the referenced canonical record explicitly records the selection within selection_scope.**

  A canonical decision ID/section/version is insufficient if that record still says
  `unresolved`/`pending` or does not affirm the scoped selection.

- `authority_dimension_adopted` is dimension-scoped, not a global boolean. Relevant owner
  dimensions are:

  ```text
  product_scope_owner
  architecture_owner
  engineering_contract_owner
  validator_owner
  legal_external_owner
  protected_change_owner
  ```

  Adoption of one dimension does not select or adopt any unrelated dimension. The model must
  retain the dimension, owner, exact canonical authority reference, version, timestamp, and
  bounded scope for each adopted dimension.

- `change_authorized` means the applicable owner has authorized a specific protected or
  non-protected change after its preconditions are satisfied. It is not implied by a selected
  direction or by package completeness.

- `change_applied` means the authorized change is evidenced in the actual canonical target by
  its owner workflow. A proposal, projection, ledger, or generated catalog cannot self-report
  this state.

- `verification_by_dimension` is a set of separate results, not one aggregate readiness flag:

  ```yaml
  verification_by_dimension:
    structural: pass | fail | unknown | not_applicable
    contract: pass | fail | unknown | not_applicable
    protected_change: pass | fail | unknown | not_applicable
    runtime: pass | fail | unknown | not_applicable
    evidence: pass | fail | unknown | not_applicable
  ```

  These are the only permitted verification values. Use `not_applicable` when a dimension is
  structurally outside the change; for example, runtime verification is `not_applicable` for a
  validator-only PD-07 change. `unknown` means the dimension is relevant but has not been
  established; it is not a pass or readiness signal.

  Passing `doctor`, `verify`, or `gate toolchain` can support structural/contract checks only
  within their declared scope. It does not prove runtime behavior, evidence, calibration,
  readiness, certification, or source unlock. `gate p0` remains the separate fail-closed gate.

### Partial-selection semantics and current classification

Partial selection or adoption of one dimension must never imply that unrelated decision
dimensions are selected, adopted, authorized, applied, or verified. For example, B05 may
illustratively receive an engineering-contract direction for an event owner/schema matrix in a
future canonical record while its product-scope, validator, legal/external, and protected-change
  dimensions remain unresolved. This B05 example is non-binding and does not select any event owner,
schema, producer, privacy class, or version now.

The current Phase 4 A–C and B packages are `working_direction_recorded` only. They are not
`direction_selected`, `authority_dimension_adopted`, `change_authorized`, `change_applied`, or
`verification_by_dimension` results. Package completeness is not decision closure and is not
application approval.

### Canonical-adoption precondition and non-claims

Before any proposed direction can be treated as selected or adopted, the canonical owner must
record the selected value, exact decision ID/section/version, selector, timestamp, and scope in
the canonical authority. Protected application additionally requires the applicable attestation,
owner review, CODEOWNERS review, and regenerated projections. External-source-dependent items
additionally require named, versioned, dated external evidence in the proper evidence authority.

This model does not create a decision ID, select a founder option, authorize or apply a change,
verify runtime behavior, create or modify evidence, establish calibration, establish readiness or
certification, or unlock source.

### Adversarial self-check

- **Authority inflation:** the model explicitly keeps `working_direction` non-authoritative and
  requires canonical owner adoption before `direction_selected` or adoption can be true.
- **Projection-as-authority:** addenda, ledgers, annexes, catalogs, and generated projections
  cannot establish selected/applied/verified states or supersede the canonical owner.
- **Global-boolean leakage:** adoption is stored by owner dimension; one selected dimension cannot
  imply unrelated product, legal, validator, protected-change, runtime, or evidence decisions.
- **Verification leakage:** tooling passes are bounded to their declared structural/contract
  scope and cannot be promoted to runtime, evidence, readiness, or certification proof.

## 1. A01–A16 completion matrix

Every row records owner/evidence, class, bounded target, migration/projection/validator plan,
dependencies/conflicts, and non-claims. “Application-ready proposal” is used only for A07/A08,
where the current owner contains both the current token and the exact target token. A target
reference is used everywhere else when an external fact or new semantic choice remains.

### A01 — B1-4, LR band 3 text hygiene

- Current canonical owner/evidence: blueprint/framework/band-descriptor-map.md:62; the canonical founder index Track A row and annex B1-4 record the non-English text as still present.
- Resolution class: mechanical.
- Target reference: review the exact protected row and replace only the non-English characters with an English rewrite preserving current meaning. Exact replacement wording is not established by current authority.
- Migration/projection/validator/regression: no runtime migration; bump framework revision after owner review; regenerate dependent projections; run framework/frontmatter validation and a before/after row semantic diff.
- Dependencies/conflicts: framework owner and CODEOWNERS review; no external IELTS-source dependency established. Conflict: hygiene must not become a descriptor correction.
- Non-claims: no official-source confirmation, calibration, runtime, readiness, or P0 expansion.

### A02 — B1-6, Speaking PR band 9 text hygiene

- Current canonical owner/evidence: blueprint/framework/band-descriptor-map.md:138; founder index Track A and annex B1-6 record the characters as still present.
- Resolution class: mechanical.
- Target reference: clean only the cited row with reviewed English wording preserving semantics; no literal sentence is invented here.
- Migration/projection/validator/regression: no runtime migration; share the framework revision bump with related hygiene rows; regenerate projections; run framework validation and row-level semantic diff.
- Dependencies/conflicts: framework owner/CODEOWNERS review; no external-source dependency established. Conflict: cleanup cannot silently alter the band descriptor.
- Non-claims: no official descriptor, runtime, readiness, or P0 claim.

### A03 — B1-7, Speaking PR band 7 text hygiene

- Current canonical owner/evidence: blueprint/framework/band-descriptor-map.md:140; founder index Track A and annex B1-7 record the issue as still present.
- Resolution class: mechanical.
- Target reference: replace only the cited non-English characters with a semantics-preserving English rewrite; exact wording remains owner-review input.
- Migration/projection/validator/regression: no runtime migration; bump the affected file revision; regenerate projections; run framework validation and unchanged-node/row diff.
- Dependencies/conflicts: framework owner/CODEOWNERS review; no external-source dependency established. Conflict: do not infer an official correction.
- Non-claims: no official-source, calibration, runtime, readiness, or P0 claim.

### A04 — B1-8, error taxonomy text hygiene

- Current canonical owner/evidence: blueprint/framework/error-taxonomy.md:43; founder index Track A and annex B1-8 record the non-English text as still present.
- Resolution class: mechanical.
- Target reference: clean only the cited prose without changing the error ID, controlled vocabulary, criterion impact, or band signal; exact prose is not supplied.
- Migration/projection/validator/regression: no runtime migration; bump this framework file; regenerate taxonomy projections; validate IDs and relations are unchanged.
- Dependencies/conflicts: framework owner/CODEOWNERS review; no external-source dependency established. Conflict: no new error ID or reclassification.
- Non-claims: no new taxonomy node, runtime, readiness, or P0 claim.

### A05 — B1-9, speaking-parts text hygiene

- Current canonical owner/evidence: blueprint/framework/speaking-parts-framework.md:170; founder index Track A and annex B1-9 record the non-English text as still present.
- Resolution class: mechanical.
- Target reference: clean only the cited prose while preserving speaking-part behavior, pronunciation-depth meaning, examiner rules, and controlled IDs.
- Migration/projection/validator/regression: no runtime migration; bump the framework file; regenerate speaking projections; run framework validation and unchanged-node/edge diff.
- Dependencies/conflicts: framework owner/CODEOWNERS review; no external-source dependency established. Conflict: hygiene cannot alter construct semantics.
- Non-claims: no official descriptor correction, standalone pronunciation band, runtime, or readiness claim.

### A06 — B1-10, Speaking PR band 8 text hygiene

- Current canonical owner/evidence: blueprint/framework/band-descriptor-map.md:139; founder index Track A and annex B1-10 record the characters as still present.
- Resolution class: mechanical.
- Target reference: clean only the cited characters with a semantics-preserving English rewrite; no literal target sentence is asserted.
- Migration/projection/validator/regression: no runtime migration; share the band-descriptor revision bump; regenerate projections; run framework validation and row-level semantic diff.
- Dependencies/conflicts: framework owner/CODEOWNERS review; no external-source dependency established. Conflict: cleanup is not an official band correction.
- Non-claims: no official-source, calibration, runtime, readiness, or P0 claim.

### A07 — B1-1, Reading micro-skill vocabulary

- Current canonical owner/evidence: blueprint/framework/microskill-enum.md:42 contains R_matching_information; blueprint/framework/skill-questiontype-band.md:60 contains the exact target R_matching_information_paragraph. The founder index records the same target.
- Resolution class: mechanical, with protected controlled-vocabulary impact.
- Application-ready proposal target: replace R_matching_information with R_matching_information_paragraph. The current owner proves both current and target tokens; no new semantic choice or external fact is required.
- Migration/projection/validator/regression: bump microskill revision only after protected review; regenerate dependency/learning projections; run vocabulary validation and no-dangling-reference scan. Any stored old token needs a versioned alias/migration record, not silent rewriting.
- Dependencies/conflicts: framework owner, CODEOWNERS, and projection generator. Conflict: enum/question-type vocabulary drift must be reconciled in the owner, not in a projection.
- Non-claims: no new capability, task type, band claim, runtime, or readiness claim.

### A08 — B1-2, Listening flow-chart vocabulary

- Current canonical owner/evidence: blueprint/framework/microskill-enum.md:63 contains flow_chart_labelling; blueprint/framework/skill-questiontype-band.md:40 contains the exact target L_flow_chart_completion. The founder index records the same target.
- Resolution class: mechanical, with protected controlled-vocabulary impact.
- Application-ready proposal target: replace flow_chart_labelling with L_flow_chart_completion. Both values are established by the current canonical vocabulary owner; no new semantic choice or external fact is required.
- Migration/projection/validator/regression: bump microskill revision; regenerate dependent projections; scan consumers for the old token; preserve a versioned alias/migration record if downstream data contains it.
- Dependencies/conflicts: framework owner, CODEOWNERS, and generator. Conflict: enum/question-type alignment must remain single-source.
- Non-claims: no Listening capability activation, runtime, calibration, readiness, or P0 expansion.

### A09 — B2-M3, P0-01 identity states

- Current canonical owner/evidence: artifacts/engineering/contracts/runtime/auth-identity-contract.md:51-63 owns the state semantics; artifacts/operations/capability-manifest.yaml:21 carries the divergent projection seed. The founder index identifies the mismatch.
- Resolution class: semantic.
- Target reference: align the manifest to the exact auth-contract state vocabulary and transitions; the manifest remains a projection seed and must not become a competing authority.
- Migration/projection/validator/regression: no learner/runtime migration before code; regenerate capability/executor projections; validate state references and auth/manifest consistency; test guest, consent_pending, active, deletion_processing, and deleted paths as contract cases.
- Dependencies/conflicts: auth contract owner, manifest owner, generator, protected attestation/CODEOWNERS. Conflict: current manifest tokens differ from auth-contract tokens.
- Non-claims: no provider selection, endpoint change, runtime activation, or P0 readiness.

### A10 — B2-P0-02, placement states

- Current canonical owner/evidence: artifacts/engineering/contracts/runtime/lifecycle-contract.md:149-169 owns PlacementAttempt states [new, in_progress, paused, submitted, diagnosed, insufficient_data]; artifacts/operations/capability-manifest.yaml:53 carries a divergent list.
- Resolution class: semantic.
- Target reference: align the manifest to the lifecycle contract vocabulary and regenerate dependent projections.
- Migration/projection/validator/regression: no runtime migration asserted; validate owner-defined states, transitions, no deprecated token, and cases for new→submitted→diagnosed, insufficient_data, pause/resume, and retry.
- Dependencies/conflicts: lifecycle owner, manifest owner, OpenAPI reconciliation, protected review. Conflict: manifest scored is not lifecycle diagnosed.
- Non-claims: no placement evidence, runtime readiness, or P0 unlock.

### A11 — B2-P0-04, submission/evaluation axes

- Current canonical owner/evidence: artifacts/engineering/contracts/runtime/lifecycle-contract.md:239-303 separates WritingDraft, WritingSubmission, and WritingEvaluation; capability-manifest.yaml:119 mixes their states.
- Resolution class: architecture_affecting.
- Target reference: prepare a protected manifest design with distinct submission and evaluation axes referencing existing entity owners; do not choose field names or add a lifecycle here.
- Migration/projection/validator/regression: contract reconciliation before code; regenerate projections after approval; reject cross-axis states and cover submission acceptance, evaluation processing, low-confidence/unavailable, retry, and terminal behavior.
- Dependencies/conflicts: lifecycle, Writing Task 2 contracts, manifest owner, generator, CODEOWNERS. Conflict: one list conflates immutable submission with append-only evaluation.
- Non-claims: no new entity, endpoint, event, evaluator state, or P0 readiness.

### A12 — B3-1, P0-04 privacy class

- Current canonical owner/evidence: blueprint/03-features.md:314 currently says learning/assessment; lifecycle-contract.md:256-302 and P0 Writing data contracts use assessment. The founder index records the compound enum.
- Resolution class: semantic.
- Target reference: change the protected Blueprint cell to assessment and reconcile consumers through their owners.
- Migration/projection/validator/regression: no runtime migration asserted; regenerate privacy projections; validate one privacy value per capability and draft/submission/evaluation export/delete boundaries.
- Dependencies/conflicts: Blueprint, runtime data, manifest/projection owners, protected review. Conflict: compound class is not the controlled privacy vocabulary.
- Non-claims: no privacy compliance evidence or readiness claim.

### A13 — B3-2, P0-06 privacy class

- Current canonical owner/evidence: blueprint/03-features.md:316 currently says assessment; lifecycle-contract.md:375-417 records benchmark/release-gate records as derived. The founder index records the mismatch.
- Resolution class: semantic.
- Target reference: change the protected P0-06 cell to derived and reconcile manifest/operations consumers.
- Migration/projection/validator/regression: no runtime migration; regenerate capability/privacy projections; verify quality/economics records do not copy raw learner content and audit treatment remains separate.
- Dependencies/conflicts: Blueprint, lifecycle, operations governance, manifest, protected review. Conflict: P0-06 output is derived/operational governance data, not raw assessment content.
- Non-claims: no evidence approval, release approval, or P0 readiness.

### A14 — B4-1 / PD-03, Writing interaction reference

- Current canonical owner/evidence: capability-family-registry.yaml:114 points WRITING.Evaluation.interaction_spec to deprecated writing-evaluation.md; artifacts/experience/specs/interaction/writing-task-2.md is the canonical target named by the founder index.
- Resolution class: mechanical, with protected registry impact.
- Application-ready proposal target: replace only writing-evaluation.md with writing-task-2.md in the protected field; current target file and value are established and no semantic choice is required.
- Migration/projection/validator/regression: no runtime migration; regenerate web-surface/executor projections; validate target existence and non-deprecated status. Current validator existence-only behavior is a known limitation, not a claim of future hardening.
- Dependencies/conflicts: family registry owner, interaction owner, generator, CODEOWNERS. Conflict: current registry reference is deprecated.
- Non-claims: no implementation, web readiness, or capability expansion.

### A15 — B2-M6, FSRS card-kind composition

- Current canonical owner/evidence: blueprint/framework/review-mapping.md:59,60,66,83 contains compound fsrs_card_kind cells; the founder index records no composition rule.
- Resolution class: architecture_affecting.
- Target reference: a protected engineering packet must choose either an explicit typed composition rule or normalization to one controlled value per cell. This addendum does not choose or invent vocabulary.
- Migration/projection/validator/regression: version the mapping migration for every existing compound cell; regenerate review projections; validate base/modifier parsing, uniqueness, and card compatibility; cover all six compound cells and unknown tokens.
- Dependencies/conflicts: framework owner, FSRS/runtime contracts, generator, protected review. Conflict: representation and controlled vocabulary do not establish whether composition is legal.
- Non-claims: no FSRS runtime behavior, review outcome, calibration, or readiness.

### A16 — PD-07, fail-closed P0-row validator

- Current canonical owner/evidence: founder-review-packet-index.md:87-178 owns the exact protected proposal; tools/commands/validate/documents.rb:130-145 currently drops malformed rows and does not require all six rows. Source rows are blueprint/03-features.md:311-316 and build-readiness-matrix.md:27-32.
- Resolution class: protected_validator.
- Target reference: apply only the PD-07 protected patch: source/line diagnostics, required P0-01…P0-06 rows, malformed/duplicate rejection, and comparison of complete matching row signatures.
- Migration/projection/validator/regression: no runtime migration; six regression cases are missing-left, missing-right, malformed, mismatched signature, valid match, and duplicate. Preserve gate p0 exit 3 for current evidence blockers.
- Dependencies/conflicts: trust policy, validator owner, CODEOWNERS, tests, and gate semantics. Conflict: fail-closed hardening cannot be represented as readiness or gate weakening.
- Non-claims: validator behavior is unchanged; no evidence, readiness, or source unlock.

## 2. B01–B08 founder-direction packets

Package completeness is not decision closure and is not application approval. No row below is
founder_approved. Each row has one or more precise direction_status values.

### B01 — SPEAKING.Practice reservation

- direction_status: founder_directed_target; founder_choice_still_required; protected_application_required
- Current fact: capability-family-registry.yaml/map contains an orphan SPEAKING.Practice family with zero capabilities; PD-01 records the unresolved structure choice.
- Target direction: retain the namespace/family as planned/idle only for this proposal; add no Speaking capability, runtime, API, event, evidence, or readiness row.
- Already founder-directed vs still needing choice: no-invention/idle boundary is directed for this pass; eventual remove/assign/keep-idle disposition remains a founder/protected choice.
- Exact protected targets/preconditions: capability-family-registry.yaml, capability-family-map.yaml, capability-lifecycle-registry.yaml; reconcile family/lifecycle/map projections atomically with no capability addition.
- Migration/compatibility: no runtime migration; preserve IDs and regenerate projections. Rollback is restoring the prior registry projection before consumer adoption.
- Validation/rollback: family↔capability cardinality, lifecycle validity, orphan annotation, generated projection equality, and P0 scope checks.
- Adoption boundary/non-claims: planned reservation only; no Speaking activation, P1 promotion, runtime, or readiness.

### B02 — Directional rename to REVIEW.RetestDrill

- direction_status: founder_directed_target; founder_choice_still_required; engineering_design_required; protected_application_required
- Current fact: PRACTICE.Drill collides with a family/namespace and P0 maps the review loop through REVIEW.ErrorToReview; PD-02 records the collision.
- Target direction: prepare PRACTICE.Drill → REVIEW.RetestDrill; do not rename any Blueprint, registry, API, event, analytics, or projection in this pass.
- Already founder-directed vs still needing choice: target name is the requested direction; old/new identity approval and compatibility design still require founder/protected owner review.
- Exact protected targets/preconditions: blueprint/03-features.md, family/map/lifecycle registries, and every API/event/analytics/projection consumer. Before application require old/new ID, alias/deprecation, migration version, regenerated projections, analytics/event/API compatibility, and rollback semantics.
- Migration/compatibility: retain old ID as a deprecated alias for a declared migration window; version stored/configured references; preserve or explicitly version API/events; regenerate projections. Rollback reactivates the alias and reverses the versioned projection migration; never delete the old identity.
- Validation/rollback: no dangling IDs, one capability owner/family, analytics continuity, event/API consumer compatibility, deprecation expiry, and unchanged P0 matrix. This is a future test plan, not current evidence.
- Adoption boundary/non-claims: no rename is applied; no new capability, runtime, event, or P0 expansion.

### B03 — Separate quality/economics from release/audit governance

- direction_status: founder_directed_target; founder_choice_still_required; engineering_design_required; protected_application_required
- Current fact: OPS.QualityEconomics and related governance references cover operational quality/cost/quota/provider concerns; GOVERNANCE.Quality is a deprecated-only family candidate. lifecycle-contract.md:375-435 defines BenchmarkRun, ReleaseGateDecision, and AuditRecord.
- Target direction: OPS.QualityEconomics owns operational quality, cost, quota, provider, and model-routing concerns; release/audit governance remains separate audit-policy records.
- Already founder-directed vs still needing choice: separation direction is directed; exact family retirement/merge/annotation and owner reconciliation remain unresolved.
- Exact protected targets/preconditions: family/map/lifecycle registries, lifecycle references, transport classification, event/audit references, and projections. Require one owner per operational family/entity/event and explicit audit-record-first lifecycle mapping.
- Migration/compatibility: preserve audit identity/history; migrate operational references by version; never reinterpret release decisions as learner events. Rollback is versioned reference rollback with audit history retained.
- Validation/rollback: ownership, lifecycle consistency, audit immutability, privacy class, projection regeneration, and no P0 expansion.
- Adoption boundary/non-claims: direction only; no family merge, release approval, quality evidence, or readiness.

### B04 — P0-06 scope-boundary directions

- direction_status: founder_directed_target; founder_choice_still_required; protected_application_required
- Current fact: OPS.ContentQuality is ACTIVE with a deferred/no-runtime exception; anti_gaming_flagged has canonical ownership at event-ownership-registry.yaml:43 but P0-vs-P1 scope is unresolved. These are independent PD-05 subdecisions.
- Target direction: deferred content quality must not imply runtime readiness, and anti-gaming scope must be explicit rather than silently enlarging P0. This packet does not choose demote/retain or remove/retain options.
- Already founder-directed vs still needing choice: no-implicit-readiness boundary is directed; lifecycle and event-scope options remain founder/protected choices.
- Exact protected targets/preconditions: capability lifecycle/manifest, transport classification, event ownership/manifest references, governance projection, and P0-06 readiness references; require explicit P0/P1 decision and regenerated projections.
- Migration/compatibility: if demoted/removed, version projections and preserve historical refs; if retained as placeholder, mark P1-gated and produce no P0 evidence. Rollback restores prior scope projection without deleting history.
- Validation/rollback: P0 set equality, lifecycle/transport consistency, event owner/schema/privacy, and no deferred row treated as ready.
- Adoption boundary/non-claims: no P0-06 scope change, anti-gaming activation, content-runtime, or readiness claim.

### B05 — Learning/practice event authority and audit-first release gates

- direction_status: founder_directed_target; founder_choice_still_required; engineering_design_required; protected_application_required
- Current fact: event-schema-pack.md:50-64 defines learning_error_fix_started, learning_error_fix_completed, and practice_started; event-ownership-registry.yaml does not fully register them. lifecycle-contract.md:416 references release_gate_blocked and release_gate_approved without a fully reconciled event authority.
- Target direction: retain named learning/practice events for deliberate review; before adoption each needs one canonical owner, schema authority, allowed producers, privacy class, and version. Release gates are audit-record-first.
- Already founder-directed vs still needing choice: completeness requirements and audit-first boundary are directed; retention/rename/removal and owner selection remain founder/engineering choices.
- Exact protected targets/preconditions: event schema pack, ownership registry, lifecycle contract, Blueprint references, manifest/projections, and audit-policy records. Before application require the owner/schema/producer/privacy/version matrix, consumer inventory, and migration plan.
- Migration/compatibility: preserve names unless semantic equivalence proves a rename; version payloads and migrate producers/consumers atomically; retain release decisions as immutable audit records. Rollback is producer/consumer version rollback with audit history retained.
- Validation/rollback: one owner/schema, producer allowlists, raw-content privacy scan, schema compatibility, lifecycle/audit reconciliation, and regenerated projections. This is not application-ready because owner/schema/producers/privacy/version are not yet established.
- Adoption boundary/non-claims: no event owner/schema is invented; no raw learner content, release approval, runtime, or readiness claim.

### B06 — Data residency direction, no region selection

- direction_status: founder_directed_target; founder_choice_still_required; external_evidence_required; protected_application_required
- Current fact: the canonical D-01 packet §1 presents region options A/B/C and the founder index marks residency unresolved.
- Target direction: one primary canonical learner-data region, explicit data-location policy, no sensitive multi-region replication initially, and an explicit decision about classes allowed to leave region.
- Already founder-directed vs still needing choice: minimization/explicit-policy direction is prepared; founder must choose D-01 option and approve legal/provider implications. No option is selected.
- Exact protected targets/preconditions: residency/provider topology, privacy/data-location policy, auth/runtime storage contracts, and DPA/evidence packet. Require founder option selection, legal/rights review, data-class inventory, and deletion/export path.
- Migration/compatibility: classify data classes and migrate only by versioned reversible plan; preserve deletion/export; avoid silent replication. Rollback is storage/routing policy rollback with no destructive deletion.
- Validation/rollback: region placement, egress, access, deletion/export, backups/replicas, and provider-contract checks; not run/claimed here.
- Adoption boundary/non-claims: direction only; no region, provider, DPA, legal clearance, runtime, or readiness claim.

### B07 — Provider-neutral OIDC direction, no vendor selection

- direction_status: founder_directed_target; founder_choice_still_required; engineering_design_required; external_evidence_required; protected_application_required
- Current fact: auth-identity-contract.md:7-23,51-63 defines opaque subject_id mapping and state semantics; D-02 vendor selection remains unresolved.
- Target direction: external OIDC → ExternalIdentity → internal stable learner_id; learning ownership never relies directly on provider IDs.
- Already founder-directed vs still needing choice: provider-neutral boundary is directed; founder must choose D-02 vendor and approve provider/DPA/operational constraints. No vendor is selected.
- Exact protected targets/preconditions: auth contract, OpenAPI/auth transport, identity runtime, manifest, and provider policy; require vendor-neutral contract tests, claim mapping, account-link/recovery, and D-02 choice.
- Migration/compatibility: persist stable internal IDs and version external links; support provider rotation without changing learning ownership. Rollback is adapter rollback retaining internal IDs and audit history.
- Validation/rollback: token validation, cross-user isolation, link/unlink/recovery, consent/deletion/export, provider rotation, and no raw token logging.
- Adoption boundary/non-claims: no vendor, endpoint, DPA, provider activation, or P0 readiness claim.

### B08 — Standalone STUDY.CheckIn direction, no invented transport

- direction_status: founder_directed_target; founder_choice_still_required; engineering_design_required; protected_application_required
- Current fact: daily-action-contract.md:7-12,26-36,52-64 defines CheckIn; it lists a candidate POST /v1/today/check-in, while the logical OpenAPI candidate has no matching operation and transport classification maps the capability to startStudySession. D-06 is unresolved.
- Target direction: retain standalone STUDY.CheckIn as a target semantic step distinct from StudySession: CheckIn → Planning → NextAction → StartStudySession.
- Already founder-directed vs still needing choice: semantic distinction and no-invention rule are directed; founder must choose D-06 retain/remove and engineering must design transport if retained.
- Exact protected targets/preconditions: manifest/lifecycle, OpenAPI candidate, transport classification, daily-action contract/runtime, and vertical-slice refs; require D-06 choice, idempotency/status/privacy/event design, and regenerated projections.
- Migration/compatibility: version the retain/remove contract; if retained, add approved transport/data entity atomically; if removed, preserve or explicitly retire time/energy semantics and deprecate refs. Rollback is transport/manifest version rollback without data loss.
- Validation/rollback: capability↔operation mapping, schema/idempotency, state transitions, accessibility/skippability, privacy, event, and P0 equality checks.
- Adoption boundary/non-claims: no endpoint/schema/operation is added; no runtime or readiness claim.

## 3. C — Six-workstream target-architecture audit

The existing Phase 4 proposal covers the six workstreams conceptually. These entries make the
missing package boundaries explicit as target proposals. They are not adopted runtime entities,
capabilities, APIs, events, or validators.

| workstream | current canonical owner/evidence | target package entry and required boundary | adoption_status/current-state contrast | blockers/non-claims |
|---|---|---|---|---|
| Semantic | Blueprint/framework; ssot-registry.md; Phase 4 proposal §1 | Semantic traceability package: five authority layers plus independent rights/provenance; claim types official_fact, derived_interpretation, curriculum_policy, curriculum_hypothesis, empirical_observation, calibrated_threshold, operational_policy; explicit adoption_status/current_state_ref. Preserve Band → performance target → LearnerGap → curriculum assignment; Band is not a syllabus. | Target rows are proposal/planned; current authority remains distributed and no universal semantic ledger is adopted. | No authority reclassification, official claim, band probability, runtime ontology, or P0 expansion. |
| Learning & assessment | Writing Task 2 evaluation contracts; framework task/criterion vocabulary; measurement proposal | Assessment separation package: LearningActivity, PracticeDefinition, PracticeMode, AssessmentTask, ObjectiveItemResult, RubricAssessmentResult remain typed distinctions; IELTSBandEstimate only where an assessment/calibration contract authorizes it. | Current P0 is rubric-oriented Writing; cross-skill objective-result ownership is unresolved. Target is proposal/candidate_contract, not adopted schema. | No cross-skill readiness, objective scoring by rubric, or local-signal band claim. |
| Evidence & learner state | lifecycle-contract §§2.3–2.5; event schema pack; ontology/traceability proposals | Evidence lineage/deletion package: LearnerResponse → Observation/Scoring → EvidenceEligibility → EvidenceFact → Attribution(rule_ref) → MasteryEstimate(versioned) → LearnerGapSnapshot → planning. Raw content stays in learner owners; derived facts use scoped opaque refs; deletion/export state cascade, tombstone, audit, and immutable-evidence treatment. | Current facts are entity-specific and no unified EvidenceFact/Mastery/Gap owner exists. Target is proposal/planned; no runtime store or validator is adopted. | No raw essay/audio/error duplication, evidence creation, mastery truth, calibration, or deletion-compliance claim. |
| Curriculum & progression | Knowledge Asset README/manifests; Blueprint content/roadmap; framework README; daily-action and measurement proposals | Coverage package: distinguish ContentAsset, TaskInstance, CurriculumUnit, CurriculumAssignment, and typed Task↔Competency relation. CoverageContract means declared task/content/competency coverage only. Rights/provenance is required; source deletion/tombstoning invalidates or quarantines dependent projections without copying source content. | Current assets, task refs, and progression concepts are partial/separately owned. Target is proposal/candidate_contract; no curriculum runtime is adopted. | No fixed band syllabus, automatic asset promotion, rights evidence, or learner-outcome claim. |
| Goals & planning | daily-action-contract.md; lifecycle contract; founder D-06 packet | Planning-input package: preserve CheckIn → Planning → NextAction → StartStudySession; DailyPlan is derived, Goal is long-horizon intent, NextAction is short-horizon output, neither is mastery. | CheckIn transport is unresolved and DailyPlan is review; target is target/proposal, not endpoint/schema. | No invented CheckIn endpoint/schema, adaptive threshold, or plan readiness claim. |
| Governance | architecture freeze; trust policy; event schema/ownership; lifecycle §§2.11–2.12; PD-04/PD-05/PD-06/PD-07 | Claim/governance package: operational quality/economics stays separate from release/audit policy. CoverageContract=scope coverage; ReadinessContract=evidence-backed implementation/release preconditions; CertificationClaim=separately reviewable claim backed by immutable evidence and authority. Release-gate decisions are audit-record-first. | Current ownership/event/validator gaps remain protected. Target is proposal/architecture_affecting; no claim is certified because no evidence is created. | No release approval, readiness, certification, validator change, source unlock, or external evidence claim. |

### C invariants and adversarial disposition

- Rights/provenance is orthogonal to semantic authority: semantic relevance does not establish usability until rights, provenance, retention, and deletion/tombstoning are resolved.
- Raw learner content is never duplicated into events, logs, EvidenceFact, MasteryEstimate, GapSnapshot, planning, or governance records; use scoped opaque references and explicit deletion/export treatment.
- A local practice/grammar/pronunciation signal cannot become an IELTS criterion, section band, or overall band without an applicable assessment and calibration contract. Otherwise it remains a non-band metric or explicit unknown/blocked condition.
- CoverageContract, ReadinessContract, and CertificationClaim are separate target package boundaries; none is a capability, API, event, runtime entity, or evidence record in this pass.
- adoption_status describes the proposal-to-contract state of a target row; it does not replace protected capability lifecycle or release readiness. current_state_ref remains evidence of what exists now.
- Terminology collisions, duplicate owners, projection-as-authority, P0 expansion, and invalid migration claims remain fail-closed review findings.

## 4. Unresolved blockers and routing

| route | unresolved items | stop condition |
|---|---|---|
| Founder | B01 eventual family disposition; B02 rename application; B03 family/governance disposition; B04 P0-06 scope options; B05 event retention/owner choice; B06 D-01 region option; B07 D-02 vendor; B08 D-06 retain/remove choice | do not apply a protected change until required founder direction is recorded |
| Protected owner/CODEOWNERS | A01–A16 targets, especially A09–A16 and all registry/Blueprint/framework/tool changes; B01–B05; B08; C target adoption | require owner review, attestation where protected, and regenerated projections |
| External source/evidence | existing C01–C02 official IELTS descriptor questions; B06 legal/provider/residency evidence; C calibration/benchmark thresholds and certification claims | do not infer or create source/evidence; remain blocked |
| Runtime/readiness | all target runtime contracts, P0 evidence, lifecycle/event/API implementation, deletion/export runs | proposal review cannot unlock source or convert gate output into readiness |

## 5. Literal non-claims

This addendum is proposal-only. It records no protected mutation, no external evidence, no
founder choice beyond the stated directions, no runtime claim, no P0/readiness claim, and no
source-unlock claim. It does not create capabilities, families, endpoints, schemas, events,
validators, evidence, calibration, or certification.
