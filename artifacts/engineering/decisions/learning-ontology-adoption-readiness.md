# Learning Ontology Adoption Readiness — Decision Artifact

- **Type:** adoption-readiness-decision — non-authoritative, non-protected decision/projection only. Not a second ontology owner.
- **Status:** `review` — founder review required; no decision has been made.
- **Created:** 2026-08-11
- **Owner:** document-convergence orchestrator
- **Derived from:** `learning-ontology-proposal.md` v0.3.9, `learning-measurement-traceability-proposal.md` v0.1.9
- **Consumed by:** founder, engineering, product

## Purpose

Assess the adoption readiness of the 8-object Learning Ontology and the sibling Measurement Traceability proposal against current canonical owner state. This artifact records what exists, what is proposed, what is missing, and what decisions/evidence are required before any protected change. It does not adopt, approve, or implement the ontology.

## 1. Boundary — ontology vs orchestration

**Ontology (what the system tracks as learning truth):**

| # | Object | Definition | Scope |
|---|---|---|---|
| 1 | Skill | Testable IELTS competency dimension | P0: Writing; P1: Reading, Listening, Speaking, Pronunciation |
| 2 | Knowledge | Structured, versioned, rights-reviewed content | P0: framework + KA assets (draft); P1: content publication workflow |
| 3 | TaskType | Question format or task shape | P0: 5 W_task2_* types; P1: Reading, Listening, Speaking task types |
| 4 | Practice | Learner attempt producing a response | P0: LEARN.Writing, PRACTICE.Drill (retest only); P1: PRACTICE.Set/Timed/Adaptive |
| 5 | Content | Operational lifecycle of Knowledge assets | P1: CONTENT.Publish/Moderation/QuestionBank (deferred) |
| 6 | Assessment | Scored, evidence-linked evaluation | P0: EVAL.Writing, PLACE.*; P1: EVAL.Speaking/Pronunciation/Examiner |
| 7 | Evidence | Immutable, append-only record of learner action/outcome | P0: per-entity events (no unified schema); P1: proposed unified fact union |
| 8 | Mastery | Computed estimate of capability at Skill × CompetencyRef | Missing — no entity, capability, contract, or schema exists |

**Orchestration consumers (use ontology objects, not part of ontology):**

Learning Path, DailyPlan (STUDY.DailyPlan), NextBestAction (PERSONAL.NextBestAction), Recommendation (PERSONAL.Recommendation), AdaptivePlan, Coach (COACH.*), FSRS (REVIEW.FSRS), Progress (PROGRESS.*).

Note: BAND.* is classified as an Assessment subtype per the ontology proposal §1.6 (`BAND.Current`, `BAND.Readiness`, `BAND.ExamReadiness`), not as an orchestration consumer. BAND.Current is a downstream projection from placement data today; the ontology proposal reclassifies it as `derived_from: MASTERY.SkillEstimate` (see Diff ONT-03). BAND.* capabilities appear in both the Assessment object row below (§2.6) and in orchestration paths — this is a known ambiguity in the current capability catalog (Assessment-owned projections consumed by Progress), not an invention of this artifact. Until the ontology is adopted and BAND.Current is reclassified, it retains its current lifecycle registry classification in PLACEMENT.Diagnosis.

These consumers read from ontology objects (evidence facts, mastery estimates) but do not define them. Treating orchestration as ontology would create duplicate owners and circular dependencies.

## 2. Per-object current-state assessment

### 2.1 Skill

- **Canonical owner:** `blueprint/framework/` (IELTS Knowledge Framework v1.0.6) — 4 macro skills (listening, reading, writing, speaking). `blueprint/05-content.md` — pronunciation as controlled skill tag.
- **Status:** `canonical` — 5 controlled values, exhaustive. No new skills without framework change. Unknown skills → `unknown_skill` diagnostic, fail-closed.
- **Capability IDs:** LEARN.*, EVAL.*, PRACTICE.*, BAND.* operate per-skill.
- **P0 scope:** Writing only. Other four skills are P1/deferred.
- **P0 gaps:** No runtime acceptance evidence for any skill evaluation.
- **Protected adoption targets:** None — Skill vocabulary is already canonical. No framework change needed.
- **Required evidence:** Post-code acceptance runs per skill evaluator.

### 2.2 Knowledge

- **Canonical owner:** `blueprint/05-content.md`, `blueprint/framework/`, `knowledge-assets/`
- **Status:** `partial` — framework vocabulary is controlled (grammar points, error taxonomy, band descriptors, question types). 17 Knowledge Assets exist (all draft/pending_review; 10 lack provenance; all 17 have `license: unknown`). Content publication workflow (CONTENT.Publish) is P1.
- **Capability IDs:** KA.* (8 capabilities), CONTENT.* (12 capabilities, all P1)
- **P0 scope:** Framework as vocabulary SSOT. Writing tasks as published Knowledge assets (P0 requires ≥1 per task_type; publication workflow deferred).
- **P0 gaps:** No published, rights-reviewed Knowledge Assets. KA provenance incomplete. No content lifecycle for task publishing at P0.
- **Protected adoption targets:** None for the ontology — Knowledge is already defined in Blueprint and KA contracts.
- **Required evidence:** KA rights review, content quality acceptance (P1).

### 2.3 TaskType

- **Canonical owner:** `blueprint/framework/skill-questiontype-band.md` (IELTS question types), `blueprint/03-features.md` (PRACTICE.* drill types)
- **Status:** `canonical` for Writing Task 2 types (5 W_task2_*). Framework-canonical for Reading/Listening question types. Pronunciation has no question type — uses PracticeUnitRef (P_* IDs) per framework.
- **Capability IDs:** PRACTICE.*, EVAL.* operate per TaskType.
- **P0 scope:** 5 Writing Task 2 types. All other skill TaskTypes deferred.
- **P0 gaps:** No task-type-specific evaluation behavior (all Task 2 types share the same rubric). No task-type difficulty calibration.
- **Protected adoption targets:** None — vocabulary is framework-canonical.
- **Required evidence:** Task-type calibration evidence (post-code).

### 2.4 Practice

- **Canonical owner:** `blueprint/03-features.md` (PRACTICE.*, STUDY.*, LEARN.*)
- **Status:** `partial` — P0 Writing practice is contract-defined (saveWritingDraft, createWritingSubmission, startWritingErrorRetest). PRACTICE.Drill (retest) is ACTIVE in REVIEW.ErrorToReview family. PRACTICE.Set/Timed/Adaptive are PLANNED in PRACTICE.Drill family (P1).
- **Capability IDs:** LEARN.* (7), PRACTICE.* (6), STUDY.* (8)
- **P0 scope:** Writing workspace + draft + error retest. No timed/adaptive/mock-test practice.
- **P0 gaps:** No timed mode toggle. No adaptive difficulty. No PRACTICE.* families activated beyond retest.
- **Protected adoption targets:** PRACTICE.* family activation (P1, requires roadmap decision). Manifest must reflect practice capability family scope.
- **Required evidence:** Practice workflow acceptance (P1).

### 2.5 Content

- **Canonical owner:** `blueprint/03-features.md` (CONTENT.*), `blueprint/05-content.md`
- **Status:** `proposal` — CONTENT.* capabilities are all PLANNED (P1). Content publication workflow (author → review → publish → deprecate) is P1. Content quality gates are P1.
- **Capability IDs:** CONTENT.* (12, all PLANNED/P1)
- **P0 scope:** WritingTask has an existing P0 content-publish contract: `openapi.yaml` v0.5.0 defines `getWritingTask` (GET /v1/writing/tasks/{taskId}) with `task_type` enum, `task_version`, `prompt`, and `min_word_count`. This implies a publish lifecycle (author → review → published + rights gate) at P0 — a task that is not published and rights-reviewed cannot be returned by `getWritingTask`. However, the owning capability `CONTENT.Publish` is PLANNED/P1 (deferred). This is an unresolved ownership/scope tension: a P0 contract requires a content publish path that the owning capability does not yet cover. The author→review→published→rights-gate contract is P0-defined; CONTENT.Publish P1 deferral does not remove that P0 requirement. No bypass of publish/rights gates is proposed. WritingDraft is learner-owned PKM in WRITING.Evaluation family — distinct from published content.
- **P0 gaps:** No content lifecycle at P0. No question bank. No moderation/feedback pipeline.
- **Protected adoption targets:** CONTENT.Management family activation (P1, requires roadmap decision).
- **Required evidence:** Content quality acceptance (P1).

### 2.6 Assessment

- **Canonical owner:** `blueprint/03-features.md` (EVAL.*, PLACE.*, BAND.*, GOVERNANCE.*)
- **Status:** `partial` — EVAL.Writing is contract-defined (openapi.yaml v0.5.0, evaluation-contract at review, job lifecycle in lifecycle-contract.md). PLACE.* is contract-defined (placement-diagnosis-contract at review). GOVERNANCE.ConfidenceScore and GOVERNANCE.AuditTrail are P0 (ACTIVE in lifecycle registry, P0-06 pack) but benchmark/corpus/threshold evidence is missing. Remaining GOVERNANCE capabilities (GOVERNANCE.AntiGaming, GOVERNANCE.BiasMonitoring, GOVERNANCE.DriftDetection, GOVERNANCE.GoldStandardBenchmark, GOVERNANCE.Dashboard) are PLANNED/P1 in GOVERNANCE.Quality family. All other evaluators (Speaking, Pronunciation, Examiner) are P1/deferred.
- **Capability IDs:** EVAL.* (7), PLACE.* (5), BAND.* (11), GOVERNANCE.* (7: 2 P0 ACTIVE, 5 PLANNED/P1)
- **P0 scope:** Writing evaluation + placement diagnosis + confidence scoring + audit trail. Sole-evaluator principle (AI 100%, no HITL). Anti-gaming, bias, drift, dashboard, and gold-standard benchmark are P1.
- **P0 gaps:** Gold corpus missing. Benchmark not run. Numeric thresholds unarmed. Anti-gaming is `unchecked` placeholder. Confidence scoring is provider-reported, not independently verified. All post-code.
- **Protected adoption targets:** None for the ontology — EVAL.Writing is already ACTIVE with contracts defined.
- **Required evidence:** Gold corpus + benchmark run + numeric threshold approval + acceptance run (post-code).

### 2.7 Evidence

- **Canonical owner:** Partial — `OPS.QualityEconomics` (benchmark evidence), `GOVERNANCE.AuditTrail` (audit evidence), individual entity contracts (per-family event schemas). No unified owner.
- **Status:** `proposal` — P0 Writing loop entities have per-entity lifecycle records: WritingSubmission and WritingEvaluation are append-only, while LearningError and RetestAttempt are mutable lifecycle entities (lifecycle-contract.md §2.3). No unified LearningEvidence fact-union contract exists. No EVIDENCE.* capability ID exists in any registry. The ontology proposal §3 defines a proposed fact-type union (AttemptFact, EvaluationFact, RetestFact, ReviewRatingFact, ErrorResolutionFact, PlacementFact) — none of these are adopted.
- **P0 Writing loop entities and their evidence-bearing status (file-proven, not proposed):**

  **Immutable existing records** (append-only per lifecycle-contract.md; content is never modified after creation):
  - `WritingSubmission` — immutable after submission (lifecycle-contract.md:280). Carries draft ref, not essay text. These are the closest existing entities to ontology EvidenceFacts.
  - `WritingEvaluation` — append-only; re-evaluation creates a new fact with supersedes reference (lifecycle-contract.md:287). Carries criterion scores and confidence. These are the closest existing entities to ontology EvaluationFacts.

  **Mutable lifecycle entities** (state transitions change the entity; the entity is not itself an immutable fact):
  - `LearningError` — has lifecycle states (open, in_review, improved, dismissed, resolved, recurring; lifecycle-contract.md:308-312). The state transitions are facts, but the entity itself is mutable and has a current status.
  - `ReviewCard` — has FSRS states (new, learning, review, relearning, graduated; lifecycle-contract.md:334). Rating is a mutation on the card; the card is not an immutable fact. Future immutable `ReviewRatingFact` and `ErrorResolutionFact` records would capture the transition events, not the current entity state.
  - `RetestAttempt` — mutable lifecycle entity (`created → submitted → processing → completed|unavailable`; lifecycle-contract.md:353) that contains `submitted_text` (essay content, error-to-review/data-contract.md:77). RetestAttempt is NOT an EvidenceFact and must not be treated as one. Any unified LearningEvidence adoption must project reference-only (no copy, no raw content) from this entity.

  - `PlacementAttempt` — immutable after submission (lifecycle-contract.md:169); placement result.
- **What creates evidence now:** The entity-specific schemas in OpenAPI, data contracts, and event contracts produce per-entity facts. No cross-entity query, union type, or evidence-to-model pipeline exists.
- **P0 gaps:** No unified evidence fact schema adopted. No cross-skill evidence query. No `EVIDENCE.*` capability. Per-entity events carry evidence fields independently — a consumer must know which entity schema to query for each fact type.
- **Protected adoption targets:**
  - `EVIDENCE.LearningRecord` capability (proposed, P1) — would require capability registry addition, manifest update, transport classification, and a canonical owner contract.
  - Unified fact-type union adoption — would require lifecycle-contract amendment, event-schema-pack update, and OpenAPI schema additions.
- **Required evidence:** Adopted unified evidence contract + acceptance run (post-code).

### 2.8 Mastery

- **Canonical owner:** None. Canonical missing domain.
- **Status:** `missing` — no MASTERY.* capability ID, family, entity, contract, or OpenAPI schema exists in any registry. The concept is implicit in `BAND.Current`, `BAND.Readiness`, `PLACE.BandEstimation`, `PERSONAL.GapAnalysis` but has no canonical owner. The ontology proposal §2 defines the entity shape (CompetencyRef, MetricType, confidence, recency, version, explainability) but does not create a capability.
- **Why BAND.Current cannot feed Mastery:** BAND.Current is a downstream projection from placement data (capability-lifecycle-registry.yaml, owner_spec: placement-diagnosis-runtime.md). The ontology proposal §2.2 explicitly excludes BAND.Current as a Mastery input to prevent circularity: "BAND.Current is a downstream consumer of Mastery, not an input. Including it would create a self-referential cycle where band estimates calibrate themselves."
- **Why no Mastery entity exists:** The P0 Writing loop produces criterion scores and error findings (via EVAL.Writing), but no entity, contract, or capability exists to aggregate them into a per-competency, per-skill estimate. The evidence → model → orchestration spine is a documented gap: the ontology proposal §4 Layer 7-8 confirms no unified evidence contract and no Mastery entity exist (`learning-ontology-proposal.md:709-717`); the measurement traceability proposal records `evidenced_by` as `proposed` and orchestration triggers as `missing` (`learning-measurement-traceability-proposal.md:319-321`). Mastery is proposed as an initial P1 Writing implementation over P0-produced evidence — it is not a P0 deliverable. Confidence inputs are unresolved calibration factors, not a formula. No numeric threshold (MAE, confidence floor, evidence-count minimum) is decided; the `MAE <0.5` figure in `evaluation-benchmark-spec.md` is an unarmed candidate policy (status `review`, `approval_state: pending_founder`, `armed: false` per `numeric-threshold-policy.yaml:3-5`), never a decided threshold.
- **P0 gaps:** Entire domain gap. Mastery computation has no entity to store its output, no contract defining its inputs, and no capability ID to own its lifecycle.
- **Protected adoption targets:**
  - `MASTERY.SkillEstimate`, `MASTERY.BandProjection`, `MASTERY.GapAnalysis` capabilities (all proposed, P1) — require capability registry additions, manifest updates, family assignment, and canonical owner runtime specs.
  - CompetencyRef union adoption — requires controlled-vocabulary validation in framework tooling.
  - MetricType adoption from measurement traceability proposal.
- **Required evidence:** Mastery computation algorithm design + calibration run against gold corpus (post-code).

## 3. 180-capability mapping inventory

**Current truth:** A draft, non-authoritative mapping inventory exists at `learning-ontology-capability-mapping-inventory.yaml`. It is review-only — not canonical, not adopted, and not a generated projection. On 2026-08-11, a read-only comparison verified exact equality of all 180 capability IDs and lifecycle/phase values against the lifecycle registry. This verifies only the registry projection axes; it does not adopt the ontology map or prove ontology relationship semantics. The inventory uses locally-defined mapping status vocabulary (`mapped` | `partial` | `unknown_ontology_mapping` | `not_applicable`) that is projection-local and never flows into runtime. The ontology proposal §5.4 defines a completion method for a future canonical map; this inventory is an intermediate draft toward that method.

**Mapping method (proposed by the ontology proposal and represented in a review inventory; not adopted as canonical):**
1. For each of the 180 capabilities, determine the primary ontology concept it operates on.
2. Classify each capability-ontology intersection as `produces`, `consumes`, `references`, or `not_applicable`.
3. Where the capability has a defined entity contract (owner_spec, data contract, OpenAPI schema), record the contract reference. Where no contract exists, record `unknown_ontology_mapping`.
4. Publish the result as a projection derived from the capability registry + the adopted ontology.

**Sample application (P0 Writing, 6 ACTIVE families):**

| Ontology concept | Producing capability | Consuming capability | Status |
|---|---|---|---|
| Skill | EVAL.Writing, LEARN.Writing | — | `canonical` (framework) |
| Knowledge | CONTENT.* (P1, deferred) | LEARN.Writing (task prompt via getWritingTask) | `partial` (P0 WritingTask content-publish contract exists; CONTENT.Publish capability is P1 — owner/scope tension per §2.5) |
| TaskType | — (framework-canonical) | LEARN.Writing, EVAL.Writing | `canonical` (5 W_task2_*) |
| Practice | LEARN.Writing, PRACTICE.Drill | STUDY.DailyAction | `partial` (writing workspace + retest only) |
| Content | CONTENT.* (all P1, deferred) | — | `proposal` (P0 WritingTask content lifecycle implied by getWritingTask; owning capability CONTENT.Publish is P1 — documented owner/scope tension) |
| Assessment | EVAL.Writing, PLACE.* | COACH.ErrorAnalysis, REVIEW.ErrorToReview | `partial` (contract-defined, not runtime-verified) |
| Evidence | WritingSubmission, WritingEvaluation, LearningError, RetestAttempt (per-entity) | — (no unified consumer) | `proposal` (unified fact union proposed, not adopted) |
| Mastery | — (no entity exists) | — (no consumer exists) | `missing` |

**Deferred skills gap map:**

| Skill | Skill | Knowledge | TaskType | Practice | Content | Assessment | Evidence | Mastery |
|---|---|---|---|---|---|---|---|---|
| Reading | LEARN.Reading (P1) | Framework R_* + KA.* (partial) | Framework R_* types | PRACTICE.* (P1) | CONTENT.* (P1) | COACH.ReadingCoach (P1) | Not defined | Not defined |
| Listening | LEARN.Listening (P1) | Framework L_* + KA.* (partial) | Framework L_* types | PRACTICE.* (P1) | CONTENT.* (P1) | COACH.ListeningCoach (P1) | Not defined | Not defined |
| Speaking | LEARN.Speaking (P1) | Framework + KA.* (partial) | Part 1/2/3 types | PRACTICE.* (P1) | CONTENT.* (P1) | EVAL.Speaking (P1) | Not defined | Not defined |
| Pronunciation | LEARN.Pronunciation (P1) | Framework P_* units | P_* unit types | PRACTICE.* (P1) | CONTENT.* (P1) | EVAL.Pronunciation (P1) | Not defined | Not defined |

## 4. P0 Writing loop truth

**What creates evidence facts today (file-proven, not proposed):**

| Entity | Contract location | Append-only? | Contains raw content? | Downstream consumers |
|---|---|---|---|---|
| `WritingSubmission` | `openapi.yaml:710-718`, `lifecycle-contract.md:264` | Yes (immutable after submission) | No (draft ref only) | `WritingEvaluation` via async job |
| `WritingEvaluation` | `openapi.yaml:719-747`, `lifecycle-contract.md:287` | Yes (append-only; re-eval creates new fact) | No (criterion scores, refs only) | `COACH.ErrorAnalysis`, `COACH.Feedback` |
| `LearningError` | `error-to-review/data-contract.md:7-30`, `lifecycle-contract.md:308` | State transitions are facts | No (error ref, evidence ref) | `REVIEW.ErrorToReview` (MistakeNotebook, FSRS) |
| `RetestAttempt` | `lifecycle-contract.md:353`, `error-to-review/data-contract.md:72-83` | No (mutable lifecycle entity) | `submitted_text` field in data contract (line 77) — learner essay content stored in entity, not in events/logs | `REVIEW.ErrorToReview` (error resolution) |
| `ReviewCard` | `error-to-review/data-contract.md:32-55`, `lifecycle-contract.md:334` | Rating is a mutation with a fact record | No | REVIEW.FSRS scheduling |

**What does not exist (file-proven gap):**
- No unified `EvidenceFact` interface, union type, or common schema. Each entity carries its own fields independently.
- No `Mastery` entity, capability, or contract. Writing evaluations produce criterion scores (4 criteria × 0.5-band estimate with confidence), but nothing aggregates them per competency over time.
- No cross-skill evidence query. A consumer wanting "all evidence facts for learner X across all skills" must query each entity-specific API separately.
- No evidence-to-model pipeline. The `evidenced_by` edge in the measurement traceability proposal is `proposed` (measurement-traceability:319).

**Retest privacy — explicit prerequisite before any unified LearningEvidence adoption:**
Any unified fact projection spanning raw-content entities (RetestAttempt.submitted_text) and reference-only entities (WritingSubmission, WritingEvaluation) MUST be reference-only: no raw-content copy from RetestAttempt into a unified fact record. The projection must carry `retest_ref`, `submission_ref`, and `evaluation_ref` only — never `submitted_text`, essay body, or audio data. This is an acceptance invariant: redaction/redaction-check validation must pass before the unified contract is adopted.

**Why BAND.Current cannot feed Mastery (exact evidence):**
- `learning-ontology-proposal.md:358-359`: "BAND.Current projection — MUST NOT feed Mastery. BAND.Current is a downstream consumer of Mastery, not an input. Including it would create a self-referential cycle where band estimates calibrate themselves."
- BAND.Current derives from placement data (`capability-lifecycle-registry.yaml`, owner_spec: `placement-diagnosis-runtime.md`), not from ongoing evaluation facts. It is a one-time placement projection, not a continuously updated competency estimate.

**Why no calibration evidence exists:**
- `artifacts/operations/benchmark/gold-corpus-manifest.yaml:3,8,9`: `status: missing`, `gold_case_count: 0`, `rights_status: missing`, `label_status: missing`
- `artifacts/operations/benchmark/numeric-threshold-policy.yaml:3-5`: `status: review`, `approval_state: pending_founder`, `armed: false`
- `artifacts/operations/evidence/README.md:7`: "Thư mục rỗng nghĩa là chưa có evidence thật để lưu"
- All evaluation outputs are provisional until calibration evidence exists.

## 5. Adoption sequence

The following sequence is proposed for phased adoption. Each step is blocked on the preceding step. No step is applied here; all are proposals.

### Step 1 — EvidenceFact boundary (post-code acceptance)

- **What:** Adopt the unified immutable typed-fact contract (LearningEvidence = discriminated union of AttemptFact, EvaluationFact, RetestFact, ReviewRatingFact, ErrorResolutionFact, PlacementFact).
- **Prerequisite:** Founder approval of the ontology as a design contract.
- **Protected changes:** None required at proposal stage. If EVIDENCE.LearningRecord capability is created (P1), that would require capability registry, manifest, and transport classification updates.
- **Non-protected changes:** Evidence fact schemas can be adopted as design contracts referencing existing entity schemas (WritingSubmission, WritingEvaluation, etc.) without creating new capabilities. The ontology proposal §3 already defines the schema shapes.
- **Evidence gate:** Post-code — requires a running implementation to validate fact immutability, append-only behavior, and privacy invariants.

### Step 2 — MetricType and CompetencyRef (design contract)

- **What:** Adopt the MetricType union (IELTSBandEstimate, PerformanceEstimate, KnowledgeMasteryEstimate, FeaturePerformanceEstimate) and the CompetencyRef union (TaskTypeRef, PracticeUnitRef, GrammarPointRef, CriterionRef, SkillLevelRef).
- **Prerequisite:** Step 1 (facts must be typed before they can be measured).
- **Protected changes:** CompetencyRef requires controlled-vocabulary validation in framework tooling (validator addition). GrammarPointRef uses existing `grammar-band-framework.md` IDs — no framework change needed. Vocabulary/CollocationRef require P1 framework change (controlled identifier model) — explicitly deferred.
- **Evidence gate:** Design contract only. No calibration evidence required at this step.

### Step 3 — Mastery computation (post-code)

- **What:** Implement the Mastery entity as a computed projection from evidence facts — proposed initial P1 Writing implementation over P0-produced evidence. Rule-based aggregation (no ML model). Per-skill, per-CompetencyRef estimates with confidence, recency, versioning.
- **Prerequisite:** Steps 1 + 2. Requires a running evidence fact store.
- **Protected changes:** MASTERY.SkillEstimate, MASTERY.BandProjection, MASTERY.GapAnalysis capabilities (P1) — registry, manifest, family assignment. Blueprint §03-features.md capability catalog additions.
- **Evidence gate:** Post-code — Mastery computation correctness acceptance. Calibration run against gold corpus.

### Step 4 — Confidence, staleness, versioning (post-code)

- **What:** Define confidence computation from unresolved calibration factors (no formula asserted — evidence count, recency distribution, evaluation-fact consistency, and provider-reported confidence are candidate inputs only), `stale_after` thresholds (founder decision), and version retention policy.
- **Prerequisite:** Step 3. Requires real evidence data to calibrate confidence weights.
- **Protected changes:** None at design stage. `stale_after` threshold is a founder configuration decision. Version retention policy is an operational decision.
- **Evidence gate:** Post-code — confidence calibration against benchmark data.

### Step 5 — Orchestration triggers (post-code)

- **What:** Wire Mastery changes to orchestration consumers: DailyPlan reads Mastery to adjust action priority, NextBestAction selects actions based on weakest competency, Progress visualizes Mastery timeline. Current FSRS remains independent of Mastery (uses its own stability model); any future FSRS-Mastery integration is out of scope and requires a separate approved design.
- **Prerequisite:** Step 3. Requires running Mastery computation.
- **Protected changes:** BAND.Current reclassification (`derived_from: MASTERY.SkillEstimate` — Blueprint change). PERSONAL.GapAnalysis/Insights input reclassification — Blueprint changes.
- **Evidence gate:** Post-code — recommendation outcome acceptance, progress projection acceptance.

### Step 6 — Calibration (post-code)

- **What:** Run gold-corpus benchmark against writing evaluations, calibrate MAE <0.5 band threshold, arm numeric thresholds, run acceptance tests.
- **Prerequisite:** Steps 3 + gold corpus procurement (D-03). Running evaluation pipeline.
- **Protected changes:** Numeric threshold policy approval (founder). Benchmark run evidence (immutable record).
- **Evidence gate:** Post-code — this step IS the evidence gate.

## 6. Protected-diff proposals (not applied)

The following diffs would be required if the ontology is adopted and MASTERY/EVIDENCE capabilities are created. None is applied here; all require privileged review.

### Diff ONT-01 — Add EVIDENCE.LearningRecord capability (P1)

- **Targets required (all protected):**
  - `artifacts/operations/capability-lifecycle-registry.yaml` — new capability entry (ACTIVE or PLANNED per scope decision)
  - `artifacts/operations/capability-family-registry.yaml` — new EVIDENCE family or assignment to an existing family (candidate: OPS.QualityEconomics)
  - `artifacts/operations/capability-family-map.yaml` — capability→family mapping
  - `artifacts/operations/capability-manifest.yaml` — manifest entry (P1 scope; the current manifest is `closed_pilot_p0`; P1 entries require a scope/architecture decision, not a mechanical edit)
  - `artifacts/engineering/contracts/openapi/transport-classification.yaml` — transport class (event-projection)
  - `blueprint/03-features.md` — EVIDENCE.LearningRecord capability addition
  - Owner runtime spec — unresolved (no owner_spec path selected; must be created at P1 promotion)
- **Evidence contract:** Adopt ontology proposal §3 fact-type union schemas as canonical design contracts.
- **Attestation:** Standard 9-field; no readiness claim; no evidence claim.
- **Decision:** P1 scope; requires founder/engineering decision on EVIDENCE domain ownership.

### Diff ONT-02 — Add MASTERY.SkillEstimate, MASTERY.BandProjection, MASTERY.GapAnalysis capabilities (P1)

- **Targets required (all protected):**
  - `artifacts/operations/capability-lifecycle-registry.yaml` — three new capability entries (ACTIVE or PLANNED per scope decision)
  - `artifacts/operations/capability-family-registry.yaml` — new MASTERY family (to be created)
  - `artifacts/operations/capability-family-map.yaml` — capability→family mappings
  - `artifacts/operations/capability-manifest.yaml` — manifest entry (P1 scope; same scope/architecture decision requirement as ONT-01)
  - `artifacts/engineering/contracts/openapi/transport-classification.yaml` — transport class (internal-command or event-projection)
  - `blueprint/03-features.md` — three MASTERY.* capability additions
  - Owner runtime spec for each MASTERY capability — unresolved (must be created at P1 promotion)
- **Dependencies:** Step 1–3 adoption sequence. Requires EVIDENCE.LearningRecord to exist before Mastery can ingest unified facts.
- **Attestation:** Standard 9-field.
- **Decision:** P1 scope; requires founder decision on MASTERY domain scope and family assignment.

### Diff ONT-03 — Reclassify BAND.Current and PERSONAL.* inputs (P1)

- **Target:** `blueprint/03-features.md` — update capability descriptions.
- **Change:** BAND.Current `derived_from: MASTERY.SkillEstimate`. PERSONAL.GapAnalysis `input: MASTERY.GapAnalysis`. PERSONAL.Insights `input: EVIDENCE.LearningRecord`.
- **Blueprint change — requires privileged review + attestation + CODEOWNERS.**

### Diff ONT-04 — Adopt CompetencyRef controlled-vocabulary validator

- **Target:** `tools/commands/validate/framework.sh` or new semantic validator.
- **Change:** Add validation that any CompetencyRef (TaskTypeRef, PracticeUnitRef, GrammarPointRef, CriterionRef, SkillLevelRef) resolves to a controlled framework ID. Fail-closed on unknown IDs.
- **Tools change — protected; requires attestation + CODEOWNERS.**

### Diff ONT-05 — P1 vocabulary/collocation identifier model (framework change, deferred)

- **Target:** `blueprint/framework/` — new or extended vocabulary/collocation framework file.
- **Change:** Define controlled vocabulary/collocation IDs equivalent to grammar_point IDs in `grammar-band-framework.md`.
- **Prerequisite:** Colab content review + KA rights review.
- **Framework change — protected; requires attestation + CODEOWNERS.**

## 7. Red-team verification

### 7.1 Circularity check

- **BAND.Current → Mastery → BAND.Current:** Blocked. The ontology proposal §2.2 explicitly excludes BAND.Current as a Mastery input. Current BAND.Current is placement-derived (PLACEMENT.Diagnosis family, `placement-diagnosis-runtime.md` owner_spec) and forbidden as Mastery input. "Mastery downstream consumer" is a future-only reclassification pending ONT-03 approval. ✓
- **Mastery → AdaptivePlan → Mastery:** Not a cycle. AdaptivePlan reads Mastery to select difficulty but does not feed back into Mastery computation. Mastery reads evidence facts, not orchestration outputs. ✓
- **FSRS → Mastery → FSRS:** Not a cycle. Current FSRS scheduling is independent of Mastery (uses its own stability model via `capability-lifecycle-registry.yaml`, REVIEW.ErrorToReview family). A future ReviewRatingFact (proposed, not adopted) would be a Mastery input; Mastery would not feed back into FSRS scheduling. This is a future-only design, not current state. ✓

### 7.2 Fake IELTS-band metrics check

- The ontology proposal does not invent IELTS band descriptors, conversion tables, or scoring rubrics. Internal band references trace to `blueprint/framework/band-descriptor-map.md` as an internal representation or to the Writing evaluation OpenAPI schema; official equivalence still requires the named, versioned, dated external source in §7.2. ✓
- The measurement traceability proposal's ExamConstruct table (§1.1) labels all construct IDs as "illustrative proposed labels" with `provenance-required` for external IELTS source. No invented construct is asserted as canonical. ✓
- The ontology's `Mastery.band` field is explicitly marked as a DESIGN DEFECT pending MetricType adoption. The proposal does not assert that non-band-aligned competencies map to IELTS bands. ✓

### 7.3 Raw learner-content leakage check

- All proposed evidence fact schemas carry references (`task_ref`, `attempt_fact_ref`, `evidence_ref`), not raw content. The no-raw-content policy is repeated in §3.3 of the ontology proposal. ✓
- No proposed fact type contains `essay_text`, `audio_bytes`, `transcript`, `provider_payload`, or `model_tokens`. ✓

### 7.4 Duplicate owner check

- The ontology proposal does not claim to be an owner. It is a non-protected proposal. ✓
- No EVIDENCE.* or MASTERY.* capability exists in any registry — the proposal does not compete with an existing canonical owner. ✓
- Skill, Knowledge, TaskType all defer to framework as canonical owner. Practice, Content, Assessment defer to Blueprint/contracts. Evidence defines a cross-cutting contract where only partial per-family owners exist. Mastery has no owner. ✓

### 7.5 Orchestration-as-ontology check

- The proposal cleanly separates ontology (8 concepts) from orchestration (Learning Path, DailyPlan, etc.). Orchestration consumers read ontology objects but do not define them. ✓
- No orchestration capability (STUDY.DailyPlan, PERSONAL.NextBestAction, REVIEW.FSRS) is classified as an ontology object. ✓

## 8. Decision requirements

### Founder decisions

- **Adopt the 8-object ontology as a non-protected design contract** (no protected file changes). The ontology proposal is at `review` status in `learning-ontology-proposal.md` and `learning-measurement-traceability-proposal.md`. Adoption means: capabilities MAY reference ontology concepts by type; existing contracts are NOT retrofitted; protected diffs (ONT-01..ONT-05) remain separate proposals requiring their own reviews.
- **Decide P1 scope for MASTERY/EVIDENCE capability creation.** The ontology defines what Mastery and Evidence are; creating capabilities to own them is a separate scope decision (P1 per the proposal). This can be deferred without blocking ontology adoption.

### External evidence/procurement

- **IELTS official source provenance** — the measurement traceability proposal's ExamConstruct table requires named, versioned, dated external IELTS sources for every construct. This is a proposal-adoption prerequisite, not a P0 blocker.
- **Vocabulary/collocation identifier model (P1)** — requires Colab content review + KA rights review prior to framework change.

### Post-code evidence (correctly blocked by `gate p0` exit 3)

- All calibration, benchmark, and acceptance evidence.
- Mastery computation correctness acceptance.
- All EVIDENCE.* and MASTERY.* runtime validation.

## 9. References

- `artifacts/engineering/contracts/learning-ontology-proposal.md` v0.3.9
- `artifacts/engineering/contracts/learning-measurement-traceability-proposal.md` v0.1.9
- `blueprint/01-product.md`, `blueprint/03-features.md`, `blueprint/05-content.md`, `blueprint/06-engines.md`, `blueprint/08-roadmap.md`
- `blueprint/framework/README.md` v1.0.6
- `artifacts/operations/capability-lifecycle-registry.yaml`
- `artifacts/operations/capability-family-registry.yaml`
- `artifacts/operations/capability-manifest.yaml`
- `artifacts/engineering/contracts/openapi/transport-classification.yaml`
- `artifacts/engineering/contracts/writing-task-2/openapi.yaml` v0.5.0
- `artifacts/engineering/contracts/writing-task-2/data-contract.md`
- `artifacts/engineering/contracts/writing-task-2/event-contract.md`
- `artifacts/engineering/contracts/writing-task-2/runtime-spec.md`
- `artifacts/engineering/contracts/placement-diagnosis-contract.md`
- `artifacts/engineering/contracts/daily-action-contract.md`
- `artifacts/engineering/contracts/error-to-review/data-contract.md`
- `artifacts/engineering/contracts/runtime/lifecycle-contract.md`
- `artifacts/operations/deferred-families-reference.md`
- `artifacts/operations/architecture-frozen.md`
- `artifacts/operations/agent-trust-policy.yaml`
