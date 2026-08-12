# Phase 4 Target Learning Architecture Proposal

- **Status:** `review` — non-authoritative proposal only
- **Version:** `0.1.1`
- **Owner:** document-convergence orchestrator
- **Scope:** Phase 4 target learning architecture and A–C decision-package preparation
- **Adoption status:** `proposal`

## 0. Boundary and non-claims

This document is a founder-directed target architecture proposal. It is not a canonical
ontology, capability registry, framework extension, runtime contract, API contract, event
ownership decision, evidence record, calibration result, readiness decision, or source unlock.
No protected file is changed by this proposal.

Each proposed component below records `authority_ref`, `current_state_ref`, and
`adoption_status`. The allowed proposal statuses are `current_contract`, `candidate_contract`,
`proposal`, `planned`, `target`, and `deprecated`; they do not replace capability lifecycle
states in protected registries.

### Authority layers

The target architecture uses five semantic authority layers:

1. `IELTS_CANONICAL` — official IELTS facts and normative scoring/descriptor material when a
   named, versioned, dated official source is recorded.
2. `IELTS_DERIVED` — versioned internal representations derived from official material;
   never official by default.
3. `LENBANDS_CURRICULUM` — product learning policy, progression, assignments, and
   learner-facing decomposition.
4. `LENBANDS_EMPIRICAL` — observations, calibration outputs, benchmark results, and
   uncertainty-bearing measurements.
5. `LENBANDS_OPERATIONAL_POLICY` — privacy, retention, deletion, release, cost, provider,
   and governance policy.

`CONTENT_RIGHTS_AND_PROVENANCE` is an independent dimension crossing all five layers. A
source may be semantically relevant but still unusable until rights and provenance are
resolved.

The target claim-type vocabulary is:

`official_fact`, `derived_interpretation`, `curriculum_policy`, `curriculum_hypothesis`,
`empirical_observation`, `calibrated_threshold`, and `operational_policy`.

Every estimate, probability, threshold, or confidence value must declare claim type,
authority, provenance, version, and confidence/uncertainty semantics. A completion
probability is not permitted before empirical calibration.

## 1. Target semantic model — P4-A

**Target/proposal:** The semantic model separates examination meaning, learning meaning,
operational behavior, and implementation identity. Semantic architecture maps to Product
Capabilities, which map to Runtime/API/Events. The capability registry is an implementation
registry, not an ontology.

**Synthesis control record**

- `dependencies:` existing Blueprint/framework authority, `ssot-registry.md`, and the sibling
  ontology/measurement proposals.
- `conflicts_detected:` semantic authority is distributed; the capability registry, framework,
  and external IELTS material must not be treated as interchangeable owners.
- `non_claims:` `does_not_establish_runtime`; `does_not_establish_mastery`;
  `does_not_expand_p0`; `does_not_select_between canonical authorities`.

| Component | Target/proposal | `authority_ref` | `current_state_ref` | `adoption_status` | `non_claims` |
|---|---|---|---|---|---|
| Authority layer | Use the five authority layers plus independent rights/provenance dimension defined above. | `blueprint/framework/README.md`; `artifacts/operations/ssot-registry.md` | Current authorities are distributed across Blueprint, framework, contracts, content, and policy registries. | `proposal` | Does not reclassify any current file or create a new SSOT. |
| Claim type | Tag each substantive claim with one target claim type and its source/version/confidence semantics. | `artifacts/engineering/contracts/learning-measurement-traceability-proposal.md §7` | Existing proposals distinguish design contracts from empirical validity but do not provide one adopted cross-workstream claim ledger. | `proposal` | Does not convert internal framework text into official IELTS fact. |
| Semantic-to-capability mapping | Model `semantic concept → capability → family/runtime/API/event` as traceability, with each layer retaining its own owner. | `artifacts/operations/architecture-frozen.md`; `artifacts/operations/ssot-registry.md` | Capability family registry/map resolve implementation families; they do not constitute an ontology. | `target` | Does not add capabilities, families, APIs, or events. |
| Band and gap | Treat Band as a performance target/projection; treat LearnerGap as a curriculum assignment. Band is never a fixed syllabus. | `blueprint/02-architecture.md`; `blueprint/03-features.md`; `learning-measurement-traceability-proposal.md §1–4` | Blueprint contains target-band, band-map, gap, and path concepts without one adopted distinction contract. | `proposal` | Does not assert that a band implies a fixed list, threshold, or completion probability. |
| Performance Model | Define a LenBands performance model informed by `IELTS_DERIVED`, curriculum policy, and empirical evidence. | `learning-measurement-traceability-proposal.md §7`; `learning-ontology-proposal.md §2` | No canonical Performance Model entity or runtime exists. | `planned` | The model is not official IELTS and has no calibrated weights or thresholds. |

### Semantic invariants

- A local signal cannot become an IELTS criterion, section band, or overall band without an
  assessment/calibration contract.
- `KnowledgeUnit`, `Competency`, `PerformanceContext`, and `CurriculumUnit` are distinct
  concepts; one cannot silently substitute for another.
- `TaskType`, `LearningActivity`, `PracticeDefinition`, and `AssessmentTask` are distinct.
  `PracticeMode` is orchestration context, not a new task type.
- A response is not evidence by default. Automatic attribution requires an explicit
  `rule_ref` and a versioned deterministic rule.

## 2. Learning and assessment — P4-B

**Target/proposal:** Learning records what the learner did and what was assigned; assessment
records a scoring judgment. They share references but do not share ownership.

**Synthesis control record**

- `dependencies:` P0 Writing contracts, framework task/criterion vocabulary, and the
  measurement proposal's MetricType boundary.
- `conflicts_detected:` objective-result ownership for future Listening/Reading and the
  cross-skill AssessmentTask taxonomy are not current canonical contracts.
- `non_claims:` `does_not_establish_runtime`; `does_not_establish_mastery`;
  `does_not_expand_p0`; `does_not_resolve deferred result-owner decisions`.

| Component | Target/proposal | `authority_ref` | `current_state_ref` | `adoption_status` | `non_claims` |
|---|---|---|---|---|---|
| Learning activity | `LearningActivity` is the learner-facing action; `PracticeDefinition` is its reusable design; `PracticeMode` is orchestration context. | `learning-ontology-proposal.md §1.3–1.4`; `artifacts/engineering/contracts/daily-action-contract.md` | Current contracts describe practice attempts and daily actions, but do not adopt these four type boundaries globally. | `proposal` | Does not introduce an endpoint or a new practice family. |
| Assessment task | `AssessmentTask` is an assessment-owned task instance with rubric/evaluator context; it is not equivalent to a generic content task. | `artifacts/engineering/contracts/writing-task-2/evaluation-contract.md`; `runtime/lifecycle-contract.md` | P0 Writing contracts define WritingTask, Submission, and Evaluation; cross-skill assessment-task taxonomy is not adopted. | `candidate_contract` | Does not claim cross-skill assessment readiness. |
| Result separation | Use `ObjectiveItemResult` for answer-key/objective outcomes and `RubricAssessmentResult` for criterion/rubric judgments. | `blueprint/framework/exam-module-differences.md`; `writing-task-2/evaluation-contract.md`; `learning-measurement-traceability-proposal.md §4` | Current P0 Writing is rubric-oriented; objective result ownership for future Listening/Reading is deferred. | `proposal` | Does not create result schemas or claim that a rubric can score objective items. |
| Construct discipline | Separate `pronunciation` practice/evaluation competency from IELTS Speaking PR band. | `blueprint/framework/skill-questiontype-band.md`; `blueprint/framework/speaking-parts-framework.md`; `learning-ontology-proposal.md §1.1` | Current framework already states pronunciation is a Speaking criterion with a separate depth domain. | `current_contract` | Does not create a standalone IELTS pronunciation band. |
| Assessment claim | Assessment output may be an `IELTSBandEstimate` only where the applicable assessment and calibration contract authorizes it; other metrics use non-band metric types. | `learning-measurement-traceability-proposal.md §4` | MetricType is proposed; no calibration evidence exists. | `proposal` | No band, confidence, or completion probability is calibrated by this document. |

## 3. Evidence and learner state — P4-C

**Target/proposal:** Use a typed evidence flow without copying learner content into derived
facts or telemetry.

**Synthesis control record**

- `dependencies:` lifecycle immutability/export/deletion rules, event privacy rules, and the
  sibling ontology/traceability proposals.
- `conflicts_detected:` no unified EvidenceFact owner exists; current facts are entity-specific;
  unified deletion/tombstone semantics are not yet an adopted contract.
- `non_claims:` `does_not_establish_runtime`; `does_not_establish_mastery`;
  `does_not_expand_p0`; `does_not_create evidence`; `does_not_claim calibration`.

```text
LearnerResponse
  → Observation/Scoring
  → EvidenceEligibility
  → EvidenceFact
  → Attribution
  → MasteryEstimate
  → GapEvaluation
  → LearnerGapSnapshot
  → PlanningPolicy
  → DailyPlan
```

| Component | Target/proposal | `authority_ref` | `current_state_ref` | `adoption_status` | `non_claims` |
|---|---|---|---|---|---|
| LearnerResponse | Keep raw response in its learner-scoped owner; expose only an opaque reference across boundaries. | `runtime/lifecycle-contract.md §§2.3–2.5`; `event-schema-pack.md §§1, 3` | WritingDraft/Submission hold or reference raw content; events prohibit raw essay/audio/error text. | `current_contract` | Does not redesign storage or add a response API. |
| EvidenceEligibility | Gate whether a response/result is eligible to produce an evidence fact; eligibility is not automatic. | `learning-ontology-proposal.md §3`; `learning-measurement-traceability-proposal.md §3` | Current contracts have per-entity events and evaluation quality states; no unified eligibility owner exists. | `proposal` | Does not claim every response produces evidence. |
| EvidenceFact | Use immutable typed facts (`AttemptFact`, `EvaluationFact`, `RetestFact`, `ReviewRatingFact`, `ErrorResolutionFact`, `PlacementFact`) with references and typed attribution. | `learning-ontology-proposal.md §§2–3`; `runtime/lifecycle-contract.md §2.3` | No unified EvidenceFact interface or cross-skill evidence owner exists; current facts are entity-specific. | `candidate_contract` | Does not create `EVIDENCE.LearningRecord` or a runtime store. |
| Attribution | Require `rule_ref` for automatic fact→competency attribution; ambiguous mappings become an explicit unknown/blocked condition. | `learning-measurement-traceability-proposal.md §3` | The traceability proposal defines a rule but it is not an adopted runtime validator. | `proposal` | No heuristic or prose-based attribution is accepted. |
| MasteryEstimate | Treat mastery as a computed projection, not a stored truth; use `MetricType`, not a universal band field. | `learning-ontology-proposal.md §2`; `learning-measurement-traceability-proposal.md §4` | Mastery has no capability, family, entity, API, or calibration evidence. | `planned` | No model, numeric threshold, staleness duration, or completion probability is selected. |
| LearnerGapSnapshot | Store a versioned derived snapshot of gaps and evidence references, separated from curriculum assignment. | `blueprint/02-architecture.md`; `learning-ontology-proposal.md §2` | Current GapProfile/GapDetection concepts are placement-oriented and not a unified ongoing state contract. | `planned` | Does not replace `PLACE.GapDetection` or claim adaptive learning. |
| Privacy/deletion | Evidence references are opaque, scoped, tombstonable, and deletion-aware. Derived facts contain no raw learner content. Deletion semantics must state cascade, tombstone, export, and audit treatment. | `runtime/lifecycle-contract.md §§2.3–2.5`; `event-schema-pack.md §3` | Existing entity contracts define account deletion/export individually; no unified evidence deletion contract exists. | `proposal` | Does not assert deletion compliance or add immutable evidence. |

## 4. Curriculum and progression — P4-D

**Target/proposal:** Curriculum assigns learning work to a learner gap; the band target informs
the assignment but does not define a fixed syllabus.

**Synthesis control record**

- `dependencies:` Knowledge Asset ownership/provenance, framework controlled vocabulary, and
  current placement/daily-action contracts.
- `conflicts_detected:` ContentAsset, TaskInstance, CurriculumUnit, and ongoing gap assignment
  have partial owners or proposal-only boundaries; no duplicate owner is selected here.
- `non_claims:` `does_not_establish_runtime`; `does_not_establish_mastery`;
  `does_not_expand_p0`; `does_not_turn Band into a syllabus`.

| Component | Target/proposal | `authority_ref` | `current_state_ref` | `adoption_status` | `non_claims` |
|---|---|---|---|---|---|
| CurriculumUnit | A curriculum unit is a sequenced learning assignment with prerequisites, practice definition, and completion evidence. | `blueprint/05-content.md`; `blueprint/08-roadmap.md`; `learning-ontology-proposal.md §1.2–1.5` | Content/Knowledge assets and learning paths exist as separate concepts; no adopted CurriculumUnit contract exists. | `proposal` | Does not promote content assets to curriculum units automatically. |
| Gap-to-assignment | `LearnerGapSnapshot → CurriculumAssignment` is a policy decision with an auditable rule/version. | `artifacts/engineering/contracts/daily-action-contract.md`; `learning-measurement-traceability-proposal.md §3` | Daily action currently consumes placement, goals, review, and error signals; ongoing gap assignment is not unified. | `planned` | Does not define a recommendation algorithm or threshold. |
| Progression | Progression is a curriculum policy over competencies and evidence, not a band-descriptor copy or a completion probability. | `blueprint/08-roadmap.md`; `blueprint/framework/grammar-band-framework.md` | Framework band rows and grammar bands are internal reference material with explicit non-calibration caveats. | `proposal` | Does not claim that a learner has completed a band or syllabus. |
| Content/task distinction | `ContentAsset` is reusable authored/provenance-bearing content; `TaskInstance` is a learner-scoped instantiation. ContentAsset != TaskInstance. | `knowledge-assets/README.md`; `knowledge-assets/manifests/README.md`; `blueprint/05-content.md` | Current asset and task references are present but a cross-skill typed relation is not adopted. | `candidate_contract` | Does not create assets, task instances, or rights evidence. |
| Task relation | `Task ↔ Competency` is N:M with a typed relation and attribution rule. | `learning-measurement-traceability-proposal.md §3`; `blueprint/framework/README.md` | Existing framework tags and proposal references provide partial mappings; no adopted relation registry exists. | `proposal` | Does not infer competency from a tag without a rule_ref. |

## 5. Goals and planning — P4-E

**Target/proposal:** Preserve the existing P0 orchestration boundary while making its input
semantics explicit: CheckIn → Planning → NextAction → StartStudySession.

**Synthesis control record**

- `dependencies:` `daily-action-contract.md`, runtime lifecycle states, and canonical founder
  decision D-06.
- `conflicts_detected:` CheckIn is defined conceptually but its standalone transport/schema is
  unresolved; current OpenAPI candidates disagree with the daily-action contract.
- `non_claims:` `does_not_establish_runtime`; `does_not_establish_mastery`;
  `does_not_expand_p0`; `does_not_invent an endpoint or schema`.

| Component | Target/proposal | `authority_ref` | `current_state_ref` | `adoption_status` | `non_claims` |
|---|---|---|---|---|---|
| CheckIn | Retain standalone `STUDY.CheckIn` in the target plan: `CheckIn(minutes_available, energy) → Planning → NextAction → StartStudySession`. | `artifacts/engineering/contracts/daily-action-contract.md`; canonical founder index §D-06 | Daily-action contract defines CheckIn, but the standalone endpoint/schema remains unresolved in D-06. | `target` | Does not invent an endpoint, schema, operationId, or transport mapping. |
| DailyPlan | DailyPlan is a derived plan snapshot, not the source of truth for goals, evidence, review cards, or drafts. | `daily-action-contract.md`; `runtime/lifecycle-contract.md §§2.5–2.6` | Current contract states this boundary and marks P0-03 not ready. | `current_contract` | Does not claim plan acceptance or runtime readiness. |
| Planning policy | Planning consumes goal, gap, evidence, review, CheckIn, and operational constraints through versioned rules. | `daily-action-contract.md`; `blueprint/02-architecture.md` | P0 plan is deterministic/rules-first and currently has unresolved API conflicts. | `proposal` | Does not define a new endpoint or adaptive threshold. |
| Goal vs action | Goal is a longer-horizon target; NextAction is a short-horizon plan output; neither is a mastery estimate. | `blueprint/02-architecture.md`; `daily-action-contract.md` | Existing domain map contains both Goal and Study orchestration, with boundaries in separate contracts. | `proposal` | Does not conflate goal completion with IELTS band attainment. |

## 6. Governance — P4-F

**Target/proposal:** Governance is a policy and evidence boundary. Release/audit decisions are
not learner learning events, and operational quality/cost/provider concerns belong together
without absorbing release/audit governance.

**Synthesis control record**

- `dependencies:` architecture freeze, trust policy, event schema/ownership contracts, and
  canonical founder PD/D packets.
- `conflicts_detected:` event ownership is incomplete for the named lifecycle events; P0-06
  scope and family ownership questions remain protected decisions.
- `non_claims:` `does_not_establish_runtime`; `does_not_establish_mastery`;
  `does_not_expand_p0`; `does_not_apply protected changes`; `does_not_claim readiness`.

| Component | Target/proposal | `authority_ref` | `current_state_ref` | `adoption_status` | `non_claims` |
|---|---|---|---|---|---|
| Quality/economics ownership | Target `OPS.QualityEconomics` for operational quality, cost, quota, provider, and model-routing concerns; retain release/audit governance as separate audit-policy records. | `blueprint/02-architecture.md`; founder index PD-04; `runtime/lifecycle-contract.md §§2.11–2.12` | `GOVERNANCE.Quality` remains a deprecated-only family candidate and `OPS.ContentQuality` is a P0-06 phase exception. | `target` | Does not merge protected families or promote `OPS.ContentQuality`. |
| Event authority | Keep `learning_error_fix_started`, `learning_error_fix_completed`, and `practice_started` as canonical events; define one owner, schema authority, producers, privacy class, and version. Treat `release_gate_blocked` and `release_gate_approved` as audit-record-first and reconcile all references deliberately. | `event-schema-pack.md`; `event-ownership-registry.yaml`; founder index PD-06 | The first three are in the event pack but not fully resolved in the ownership registry; release-gate references exist in lifecycle policy but are not fully registered in the event pack. | `engineering_design_required` | Does not invent event owners, producers, or payload fields. |
| P0 privacy | P0-04 privacy direction is `assessment`; P0-06 privacy direction is `derived`. | founder index Track A A12–A13; P0 contracts | Current protected Blueprint/manifest references remain queued for protected alignment. | `target` | Does not apply the privacy changes or claim validator passage. |
| Anti-gaming scope | Remove `anti_gaming_flagged` from P0 and retain it for P1, subject to the protected scope packet. | founder index PD-05/B3-3; `event-ownership-registry.yaml` | Event has an owner but is currently listed in P0-06 while governance scope is P1-gated. | `architectural_direction_proposed` | Does not remove the event or alter P0 manifests here. |
| A/B change governance | Protected changes require exact target evidence, attestation, CODEOWNERS review, and regenerated projections. | `architecture-frozen.md`; `agent-trust-policy.yaml`; founder index Track A–C | Protected queues remain unresolved/unapplied. | `current_contract` | This document is not an attestation and does not unlock source or runtime work. |

## 7. Founder-directed A decision package

The A directions are recorded as pending protected application. “Mechanical” describes the
shape of a future edit; it does not mean the edit was applied. Each item remains separately
reviewable and must not be bundled with C01/C02 official-source work.

| A item | Classification | Current target evidence | Application condition | Status |
|---|---|---|---|---|
| A01 | mechanical | `blueprint/framework/band-descriptor-map.md:62` hygiene row | Exact English cleanup; confirm no semantic descriptor change; framework owner review/version bump | pending protected application |
| A02 | mechanical | `band-descriptor-map.md:138` hygiene row | Same exact-target and no-semantic-change check | pending protected application |
| A03 | mechanical | `band-descriptor-map.md:140` hygiene row | Same exact-target and no-semantic-change check | pending protected application |
| A04 | mechanical | `blueprint/framework/error-taxonomy.md:43` hygiene row | Exact English cleanup; no taxonomy meaning change | pending protected application |
| A05 | mechanical | `blueprint/framework/speaking-parts-framework.md:170` hygiene row | Exact English cleanup; no pronunciation semantics change | pending protected application |
| A06 | mechanical | `band-descriptor-map.md:139` hygiene row | Exact English cleanup; no descriptor meaning change | pending protected application |
| A07 | semantic | `microskill-enum.md:42`; replacement `R_matching_information_paragraph` resolves at `skill-questiontype-band.md:60` | Verify target vocabulary, update exact `applies_to`, bump framework version, regenerate projections | pending protected application |
| A08 | semantic | `microskill-enum.md:63`; replacement `L_flow_chart_completion` resolves at `skill-questiontype-band.md:40` | Verify target vocabulary, update exact `applies_to`, bump framework version, regenerate projections | pending protected application |
| A09 | semantic | `capability-manifest.yaml:21`; auth owner states at `runtime/lifecycle-contract.md:85–94` | Align projection seed to canonical auth vocabulary and regenerate projections | pending protected application |
| A10 | semantic | `capability-manifest.yaml:53`; placement owner states at `lifecycle-contract.md:153–155` | Align projection seed to canonical placement vocabulary and regenerate projections | pending protected application |
| A11 | architecture-affecting | `capability-manifest.yaml:119` mixes drafting/submission/evaluation states; lifecycle separates WritingDraft, WritingSubmission, WritingEvaluation | Design two named axes and consumer semantics before exact patch; never combine in one field | pending engineering design |
| A12 | semantic | `blueprint/03-features.md:314`; current packet records `learning/assessment` | Exact privacy enum target `assessment`; protected alignment and validator review | pending protected application |
| A13 | semantic | `blueprint/03-features.md:316`; current packet records `assessment` for P0-06 | Exact privacy enum target `derived`; protected alignment and validator review | pending protected application |
| A14 | mechanical | `capability-family-registry.yaml:114`; old interaction spec is deprecated and names `writing-task-2.md` as successor | Exact reference replacement plus projection regeneration | pending protected application |
| A15 | architecture-affecting | `review-mapping.md` contains compound `fsrs_card_kind` cells | Choose atomic `fsrs_card_kind`; typed fields/list for multi-attribute cards; then update exact cells and projections | pending engineering design |
| A16 | protected validator | `founder-review-packet-index.md §PD-07`; `tools/commands/validate/documents.rb` and `tools/test/` | Apply fail-closed hardening and all proposed regression cases only through attestation/CODEOWNERS review | pending protected validator review |

### A exact protected target references and proposal diffs

The following are application-ready *proposal references/diff shapes*, not implementation-ready
protected diffs and not applied patches. They are bounded inputs for a future decision packet.

```diff
// A07 — blueprint/framework/microskill-enum.md:42
- applies_to: R_matching_information
+ applies_to: R_matching_information_paragraph

// A08 — blueprint/framework/microskill-enum.md:63
- applies_to: flow_chart_labelling
+ applies_to: L_flow_chart_completion

// A14 — artifacts/operations/capability-family-registry.yaml:114
- interaction_spec: artifacts/experience/specs/interaction/writing-evaluation.md
+ interaction_spec: artifacts/experience/specs/interaction/writing-task-2.md
```

A09/A10 have verified canonical target vocabularies but require projection regeneration and
protected manifest review. A12/A13 have exact target values from the founder packet but touch
protected Blueprint authority. A11, A15, and A16 are intentionally not reduced to a one-line
proposal diff because their design/validator behavior must be reviewed first. A01–A06 are
mechanical hygiene candidates with no external IELTS-source dependency established by the
track evidence; they still require exact-target/no-semantic-change review. They are not bundled
with C01/C02, which do require official IELTS sources.

## 8. Founder-directed B decision package

The B directions are target architecture directions pending protected application. No row is
marked `founder_approved` because the repository does not contain a separate explicit founder
authority record for this run.

| B item | Direction to prepare | Current canonical evidence | Protected packet / migration requirements | Status |
|---|---|---|---|---|
| B01 | Keep `SPEAKING.Practice` as a planned family/namespace reservation. No capability, runtime, API, evidence, or readiness is implied. | `capability-family-registry.yaml` family row; `semantic-capability-normalization-queue.md:38`; founder index PD-01 | Keep-idle/PLANNED annotation must be reconciled in family/lifecycle projections; do not invent capabilities. | architectural_direction_proposed |
| B02 | Directionally rename review-loop capability to `REVIEW.RetestDrill`. | Current `PRACTICE.Drill` collision and P0 mapping to `REVIEW.ErrorToReview` in family/lifecycle maps; founder index PD-02 | Require old/new IDs, alias/deprecation, migration version, regenerated projections, analytics/event/API compatibility, and protected owner review. | architectural_direction_proposed |
| B03 | Merge operational quality/cost/provider concerns into `OPS.QualityEconomics`; keep release/audit governance as separate audit-policy records. | `capability-family-registry.yaml` OPS/GOVERNANCE rows; `runtime/lifecycle-contract.md:380–435`; founder index PD-04 | Reconcile family registry/map/lifecycle and audit-policy references; preserve audit record ownership and migration history. | architectural_direction_proposed |
| B04a | Set `OPS.ContentQuality` to `PLANNED`. | `capability-lifecycle-registry.yaml:747`; founder index PD-05 | Protected lifecycle/transport reconciliation; no P0-06 readiness implication. | architectural_direction_proposed |
| B04b | Remove `anti_gaming_flagged` from P0; retain it for P1. | `capability-manifest.yaml:202`; `event-ownership-registry.yaml:43`; founder index PD-05/B3-3 | Reconcile manifest/event projections and P1 scope; event ownership itself is not missing. | architectural_direction_proposed |
| B05 | Keep the three learning/practice events canonical; resolve one owner/schema/producers/privacy/version. Treat release-gate events as audit-record-first. | `event-schema-pack.md:61–63`; `lifecycle-contract.md:416`; founder index PD-06 | Do not invent missing event ownership. Reconcile canonical event pack, ownership registry, lifecycle references, consumers, and migrations. | engineering_design_required |
| B06 | Direction only: one primary canonical learner-data region, explicit data-location policy, no sensitive multi-region replication initially, and an explicit decision about data classes allowed to leave region. | `founder-decision-packet-identity-and-residency.md §1`; canonical founder index D-01 | Read D-01 options before selection; do not choose packet A/B/C or a provider in this proposal. | external_evidence_required |
| B07 | Direction only: external OIDC → `ExternalIdentity` → internal stable `learner_id`; learning domain never relies directly on provider IDs. | `runtime/auth-identity-contract.md`; canonical founder index D-02 | Require provider-neutral contract design and D-02 review; do not select a vendor here. | engineering_design_required |
| B08 | Retain standalone P0 `STUDY.CheckIn`, distinct from StudySession, in the target flow. | `daily-action-contract.md` Data contract and API conflict section; canonical founder index D-06 | Do not invent endpoint/schema. Resolve exact transport/OpenAPI design in a later protected packet. | engineering_design_required |

## 9. A–C decision ledger

Status values are deliberately limited to the requested decision states. No row is a claim that
the underlying change is applied or ready.

| `decision_id` | `status` | `authority refs` | `blocks_adoption_of` | `does_not_block` | `protected targets` |
|---|---|---|---|---|---|
| A01–A06 | `engineering_design_required` | founder index Track A; 21-diff annex categories (a) | framework cleanup application | Phase 4 proposal review | `blueprint/framework/**` |
| A07–A08 | `engineering_design_required` | `skill-questiontype-band.md:40,60`; founder index Track A | controlled-vocabulary correction and projection regeneration | target semantic model | `blueprint/framework/microskill-enum.md`, projections |
| A09–A10 | `engineering_design_required` | `auth-identity-contract.md`; `lifecycle-contract.md:153–155`; founder index Track A | manifest alignment and generated projections | target state-axis design | `artifacts/operations/capability-manifest.yaml` |
| A11 | `engineering_design_required` | founder index Track A; `lifecycle-contract.md:243–303` | adoption of a single submission/evaluation manifest contract | Phase 4 conceptual separation | `capability-manifest.yaml`, related projections |
| A12–A13 | `engineering_design_required` | founder index Track A; P0 contracts | privacy-class reconciliation | proposal privacy principles | `blueprint/03-features.md` |
| A14 | `engineering_design_required` | `writing-evaluation.meta.yaml`; `writing-task-2.md`; founder index Track A | canonical interaction reference adoption | P0 target architecture | `capability-family-registry.yaml`, projections |
| A15 | `engineering_design_required` | `review-mapping.md`; founder index Track A | atomic FSRS card-kind contract | other learning ontology sections | `blueprint/framework/review-mapping.md`, projections |
| A16 / PD-07 | `engineering_design_required` | founder index PD-07; `agent-trust-policy.yaml` | fail-closed readiness validator adoption | proposal-only review and expected P0 blocked state | `tools/commands/validate/documents.rb`, `tools/test/` |
| B01 | `architectural_direction_proposed` | founder index PD-01; family registry/map | family reconciliation decision | multi-skill target architecture | family/lifecycle/map registries |
| B02 | `architectural_direction_proposed` | founder index PD-02; semantic normalization queue | review-loop rename/migration | P0 unchanged | Blueprint capability identity, registry/map/lifecycle, events/API projections |
| B03 | `architectural_direction_proposed` | founder index PD-04; lifecycle contract | family ownership reconciliation | audit-policy proposal | family/map/lifecycle registries |
| B04a | `architectural_direction_proposed` | founder index PD-05; lifecycle/transport rows | P0-06 scope reconciliation | target governance boundary | lifecycle and transport classification |
| B04b | `architectural_direction_proposed` | founder index PD-05/B3-3; event ownership | P0-06 event scope reconciliation | governance event ownership design | P0 manifest/event registry |
| B05 | `engineering_design_required` | founder index PD-06; event schema/ownership/lifecycle contracts | canonical event authority adoption | typed evidence proposal | event pack, ownership registry, lifecycle refs |
| B06 / D-01 | `external_evidence_required` | D-01 packet §1; canonical founder index | residency/provider eligibility design | semantic architecture and P0 unchanged | provider topology/policy contracts |
| B07 / D-02 | `engineering_design_required` | D-02 packet §2; auth identity contract | identity provider activation design | provider-neutral learner model | auth/API/runtime contracts |
| B08 / D-06 | `engineering_design_required` | D-06 packet; daily-action contract | CheckIn transport/schema adoption | CheckIn semantic direction | OpenAPI/manifest/transport projections |
| C01–C02 | `external_evidence_required` | founder index Track C; 21-diff annex Batch 1 | any official-source-dependent framework correction | all internal target architecture work | `blueprint/framework/band-descriptor-map.md` |
| C03 | `architectural_direction_proposed` | `ssot-registry.md`; architecture frozen contract | authority-layer adoption | P0 runtime scope | none at proposal stage |
| C04 | `architectural_direction_proposed` | traceability proposal §7; ontology proposal §2 | Performance Model design adoption | P0 unchanged | future Mastery contracts |
| C05 | `engineering_design_required` | architecture frozen contract; ssot registry | semantic→capability→runtime traceability contract | conceptual ontology definitions | registries/contracts if later adopted |
| C06 | `engineering_design_required` | ontology proposal §§2–3; event schema pack | unified evidence flow adoption | current P0 contracts | evidence/runtime/event contracts |
| C07 | `engineering_design_required` | lifecycle contract §§2.3–2.5; event schema pack | evidence reference/deletion contract | proposal review | privacy/runtime contracts |
| C08 | `architectural_direction_proposed` | ontology/traceability proposals; framework README | type-boundary adoption | P0 writing loop | future schema contracts |
| C09 | `architectural_direction_proposed` | framework speaking/pronunciation files | construct separation adoption | P0 writing | future speaking/pronunciation contracts |
| C10 | `external_evidence_required` | traceability proposal §§4,7; benchmark manifest | calibrated thresholds/probabilities | design-only target architecture | benchmark/evidence/policy artifacts |

## 10. Application-ready protected target references

This is the handoff index for a future privileged workflow. It intentionally contains no
implementation-ready protected diff, no attestation, no generated projection, and no protected
mutation.

### Exact-supported packets

- **A07/A08:** use the literal proposal replacements in §7. The replacement IDs are present in the
  current controlled vocabulary; run the framework validator and regenerate projections.
- **A09/A10:** use the canonical state arrays from `auth-identity-contract.md` and
  `runtime/lifecycle-contract.md`; the manifest is a projection seed, so regenerate dependent
  projections after the protected edit.
- **A12/A13:** use the exact single privacy values in the founder Track A packet; reconcile
  Blueprint and manifest consumers through protected review.
- **A14:** use the literal proposal `writing-evaluation.md → writing-task-2.md` replacement in §7 and
  regenerate the web-surface projection.
- **B01:** preserve the family reservation as planned/idle; do not add a capability. The
  protected packet must reconcile lifecycle/map projection state only.

### Design-gated packets

- **A11:** define named submission and evaluation axes and their owner contracts before a
  manifest patch.
- **A15:** choose atomic `fsrs_card_kind` values and typed multi-attribute representation
  before editing the framework.
- **A16/PD-07:** apply only the exact fail-closed patch and regression set in the canonical
  PD-07 packet; validator hardening is protected.
- **B02:** prepare old/new ID, alias/deprecation, migration version, generated projections,
  event/API/analytics compatibility, and rollback semantics before any identity rename.
- **B03/B04/B05:** reconcile family, lifecycle, transport, manifest, event ownership, and
  audit-policy owners as a multi-file protected change.
- **B06/B07/B08:** do not create packet A/B/C selection, vendor selection, endpoint, or schema
  until D-01/D-02/D-06 and the required engineering/legal evidence are resolved.

## 11. Adoption plan

1. **P0 remains unchanged.** The closed pilot remains the Writing Task 2 loop. This proposal
   does not add a capability, family, endpoint, event, data entity, readiness row, or evidence
   claim. `gate p0` is expected to remain blocked while evidence is missing.
2. **Phase 4 design convergence:** review this proposal, reconcile the existing ontology and
   measurement proposals, and publish bounded contract packets with the authority/current-state
   fields above. No source unlock.
3. **P1 writing learning-state slice:** after real P0 evidence exists, design the reference-only
   EvidenceFact projection and a Writing-scoped MasteryEstimate. Require gold corpus,
   benchmark, privacy/deletion acceptance, and calibration before thresholds are armed.
4. **Multi-skill expansion:** promote Reading and Listening only after their task, objective
   result, ContentAsset/TaskInstance, attribution, and evidence contracts exist. Extend
   Speaking and Pronunciation later with explicit separation of pronunciation competency from
   Speaking PR; do not use the planned namespace as an active capability.
5. **Cross-skill progression:** add CurriculumAssignment, LearnerGapSnapshot consumers, and
   planning integration only after evidence lineage and policy versions are reviewable. Mock
   Test and full Colab/Admin remain deferred per repository scope.
6. **No source unlock:** nothing here satisfies the global document-convergence unlock, creates
   an attestation, or permits runtime workers/source mutation.

## 12. Adversarial verification

| Attack | Verification question | Required disposition |
|---|---|---|
| Authority inflation | Does any proposal row claim a proposal is canonical, official, approved, or ready? | Reject; require authority_ref and claim type. |
| Projection-as-authority | Does a catalog, queue, ledger, annex, generated output, or proposal become a canonical owner merely because it is newer or more detailed? | Reject; resolve ownership only through the current canonical owner and record the projection as a projection. |
| Terminology collision | Are TaskType, LearningActivity, PracticeDefinition, AssessmentTask, PracticeMode, ContentAsset, TaskInstance, Competency, and CurriculumUnit kept distinct? | Reject ambiguous aliases; add typed relation or `unknown_*`. |
| Privacy/deletion | Can a unified fact or event contain essay, audio, transcript, error text, provider payload, or model reasoning? Are opaque refs scoped and tombstonable? | Reject raw-content duplication; require deletion/export semantics before adoption. |
| Construct leakage | Can a local pronunciation signal, grammar score, or practice count become an IELTS criterion/section/overall band without an assessment/calibration contract? | Reject; keep non-band MetricType or blocked state. |
| P0 expansion | Do B/C directions add Speaking, Reading, Listening, Mock Test, Admin, or new P0 events/capabilities? | Reject; retain planned/deferred status and P0 unchanged. |
| Duplicate objects | Does a proposed EvidenceFact, Mastery, CheckIn, event, or family duplicate a current owner? | Resolve against `ssot-registry.md`, current contracts, and founder index before proposing adoption. |
| Non-claim discipline | Are estimates, thresholds, probabilities, and confidence values labeled with authority, provenance, version, and uncertainty? | Reject unlabeled values; no completion probability before empirical calibration. |
| Controlled vocabulary | Does any new ID resolve to the framework or use an `unknown_*` diagnostic instead of invention? | Fail closed; never create a local substitute. |
| Rename safety | Does B02 preserve old/new compatibility, aliases, deprecation, versioning, projections, analytics, API, and event consumers? | Block protected rename until all are packeted. |
| Validator safety | Does A16 keep fail-closed behavior and add negative regression cases without weakening gates? | Require attestation and independent CODEOWNERS review. |

## 13. References

- `artifacts/operations/architecture-frozen.md`
- `artifacts/operations/agent-trust-policy.yaml`
- `artifacts/operations/founder-review-packet-index.md`
- `artifacts/engineering/decisions/founder-review-21-diff-annex.md`
- `artifacts/engineering/contracts/learning-ontology-proposal.md`
- `artifacts/engineering/contracts/learning-measurement-traceability-proposal.md`
- `artifacts/engineering/contracts/runtime/lifecycle-contract.md`
- `artifacts/engineering/contracts/runtime/auth-identity-contract.md`
- `artifacts/engineering/contracts/daily-action-contract.md`
- `artifacts/engineering/contracts/events/event-schema-pack.md`
- `artifacts/engineering/contracts/events/event-ownership-registry.yaml`
- `blueprint/framework/README.md`
- `blueprint/framework/skill-questiontype-band.md`
- `blueprint/framework/microskill-enum.md`
- `blueprint/framework/review-mapping.md`
