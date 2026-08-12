# Learning Ontology Foundation — Proposal

- **Type:** ontology-proposal — non-protected document. Does not edit Blueprint or registries.
- **Status:** `review` — third red-team remediation applied; founder review required before adoption.
- **Created:** 2026-08-11
- **Updated:** 2026-08-11 (document-convergence reconciliation)
- **Version:** 0.3.9 (patch: displayed lifecycle status and current sibling-reference reconciliation; see changelog)
- **Owner:** document-convergence orchestrator (proposal author)
- **Changelog:**
  - v0.3.9 — document-convergence correction: synchronized displayed lifecycle status with the canonical sibling metadata and the live sibling traceability reference; no ontology semantics, controlled vocabulary, readiness state, or evidence state changed
  - v0.1.0 — initial proposal (8 ontology concepts, Mastery, LearningEvidence aggregate, P0 vertical slice)
  - v0.2.0 — red-team v2: BAND.Current cycle removed, P_* vocabulary fixed, LearningEvidence → immutable typed facts, CompetencyRef union, Grammar/Vocabulary as formative domains, "Implemented" → contract-defined, 180-capability map method only
  - v0.3.0 — red-team v3: §5.3 pronunciation framework addition removed; unknown_skill sentinel removed (fail-closed); CompetencyRef → TaskTypeRef + PracticeUnitRef + explicit vocabulary/collocation P1 gap; LearningTargetRef in AttemptFact/EvaluationFact; EvaluationFact state enums → canonical WritingEvaluation reference; Vocabulary/Grammar paragraph rewritten
  - v0.3.1 — red-team v3.1: GrammarPointRef added to CompetencyRef (grammar_point_id from grammar-band-framework.md; no framework change needed); P_* removed from TaskType list (pronunciation has no question type, uses PracticeUnitRef only); 5 LenBands controlled skills explicit with pronunciation included, unknown_skill diagnostic/fail-closed only; PronunciationAttemptFact target_unit removed (derived from LearningTargetRef.PracticeUnitRef); EvaluationFact quality_status scoped to Writing canonical owner as proposed vocabulary; Purpose non-claim added (no 180 map exists); sidecar synchronized
  - v0.3.2 — measurement traceability alignment: §1.4 Practice definition updated to use LearningTargetRef (not universally TaskType); §2.1 Mastery.band marked as invalid for non-band-aligned CompetencyRef variants pending MetricType adoption; §6 References linked to sibling measurement traceability proposal
  - v0.3.3 — red-team: synchronized the sibling measurement traceability reference to v0.1.4; no ontology semantics, protected authority, readiness state, or evidence claim changed
  - v0.3.4 — document-convergence reconciliation: clarified that a non-authoritative review inventory exists, while no adopted/canonical 180-capability ontology map exists; no ontology semantics, protected authority, readiness state, or evidence claim changed
  - v0.3.5 — document-convergence reconciliation: synchronized the sibling measurement traceability reference to v0.1.5; no ontology semantics, protected authority, readiness state, or evidence claim changed
  - v0.3.6 — document-convergence red-team: distinguished framework-declared task types and band axes from external IELTS authority; no ontology semantics, controlled vocabulary, readiness state, or evidence claim changed
  - v0.3.7 — document-convergence reconciliation: synchronized the live sibling measurement traceability reference to v0.1.7; historical changelog references retained; no ontology semantics or evidence state changed
  - v0.3.8 — document-convergence reconciliation: synchronized the live sibling measurement traceability reference to v0.1.8; no ontology semantics or evidence state changed
- **Derived from:** `blueprint/03-features.md` (capability catalog), `blueprint/framework/` (IELTS vocabulary), `blueprint/05-content.md` (knowledge taxonomy)
- **Consumed by:** product, engineering, validators

## Purpose

Define 8 foundational ontological concepts (Skill, Knowledge, TaskType, Practice, Content, Assessment, Evidence, Mastery) that capabilities reference by type, not by enumerated mapping.

**Explicit non-claim:** No adopted/canonical 180-capability-to-ontology map exists. A separate non-authoritative review inventory exists, but it is not canonical, not adopted, and not a generated projection. The capability lifecycle registry does not map capabilities to these 8 concepts. The P0 Writing loop vertical slice (§4) demonstrates the mapping method for 6 ACTIVE families. The full map completion method is proposed in §5.4 — it is a distinct deliverable, not content of this proposal.

This ontology enables:
- Unified data model across skills (Writing, Reading, Listening, Speaking, Pronunciation)
- Canonical LearningEvidence contract for every attempt/assessment
- Mastery as a computable domain entity
- Practice Library taxonomy separate from internal Skill Ontology
- Clean assessment-vs-practice boundary

## 1. Concept definitions

### 1.1 Skill

**Definition:** A testable IELTS competency dimension. Skills are the primary axis of the learning domain.

**Owner:** `blueprint/framework/` (IELTS Knowledge Framework v1.0.6)

**LenBands controlled skill values (5 values, exhaustive):**

| Skill | Framework canonical | IELTS exam score | LenBands use |
|---|---|---|---|
| `listening` | yes (`skill-questiontype-band.md`) | yes (Listening band) | Practice + assessment |
| `reading` | yes (`skill-questiontype-band.md`) | yes (Reading band) | Practice + assessment |
| `writing` | yes (`skill-questiontype-band.md`) | yes (Writing band) | Practice + assessment (P0) |
| `speaking` | yes (`skill-questiontype-band.md`) | yes (Speaking band) | Practice + assessment (deferred) |
| `pronunciation` | yes (`05-content.md` skill tag; `skill-questiontype-band.md` P_* units) | no (criterion of Speaking, not standalone band) | Practice + evaluation (deferred); uses PracticeUnitRef, not TaskType |

These 5 values are the exhaustive LenBands skill enum. Any skill reference outside this set is fail-closed:

- **`unknown_skill` is a diagnostic signal, not a valid skill value.** If a capability, artifact, or runtime contract references a skill outside the 5 controlled values, the reference is rejected at validation. The `unknown_skill` diagnostic is reported as a framework gap/change request — it must never be persisted, published, or accepted as a runtime value.
- **No new skills may be added without a framework change.** Pronunciation is already controlled; no additional extension is needed.

**Ownership boundary:** The IELTS framework defines the 4 macro skills. LenBands adds `pronunciation` as a fifth controlled skill for internal practice/evaluation, backed by the framework's own `P_*` practice units. Pronunciation does not claim IELTS band-score equivalence.

**Typed relationships:**
- Skill `has_many` MicroSkill (via `blueprint/framework/microskill-enum.md`)
- Skill `has_many` QuestionType (via `blueprint/framework/skill-questiontype-band.md`)
- Skill `has_many` BandDescriptor (via `blueprint/framework/band-descriptor-map.md`)
- Skill `measured_by` Assessment (via EVAL.* capabilities)
- Skill `practiced_by` TaskType (via PRACTICE.* capabilities)

### 1.2 Knowledge

**Definition:** Structured, versioned, rights-reviewed content that a learner consumes or references. Knowledge is what the system teaches; it is not what the learner produces.

**Owner:** `blueprint/05-content.md`, `blueprint/framework/`, Knowledge Assets (`knowledge-assets/`)

**Canonical subtypes:**
- `KA.Lesson` — structured lesson
- `KA.Grammar` — grammar point (traces to `framework/grammar-band-framework.md`)
- `KA.Vocabulary` — vocabulary item with band/cefr/collocation
- `KA.Collocation` — collocation pair
- `KA.Template` — writing/speaking template
- `KA.Strategy` — exam strategy
- `KA.Example` — sample essay/transcript
- `KA.Exercise` — exercise linked to lesson/knowledge
- `framework/*` — IELTS domain enums, band descriptors, error taxonomy (meta-knowledge)

**Ownership boundary:** Knowledge assets are Colab-published, not learner-generated. Learner-generated content (drafts, notes, wordbank) belongs to PKM, not Knowledge. The framework is SSOT for IELTS vocabulary — no Knowledge asset may reference a non-framework ID without `unknown_*` declaration.

**Typed relationships:**
- Knowledge `tagged_by` Taxonomy dimension (skill, band, question_type, micro_skill, grammar_point, topic, difficulty, cefr)
- Knowledge `consumed_by` Practice (as stimulus/prompt/reference material)
- Knowledge `explains` Assessment finding (via COACH.*)
- Knowledge `versioned_by` ContentRevision
- Knowledge `published_by` Colab (role)

### 1.3 TaskType

**Definition:** A specific question format or task shape that a learner responds to. TaskTypes are the atomic unit of practice and assessment. They are NOT skills — they are the vehicle through which a skill is exercised.

**Owner:** `blueprint/framework/skill-questiontype-band.md` (IELTS question types), `blueprint/03-features.md` (PRACTICE.* drill types)

**Framework-declared TaskTypes (official equivalence requires external provenance):**
- Writing: `W_task2_opinion`, `W_task2_discussion`, `W_task2_advantages_disadvantages`, `W_task2_problem_solution`, `W_task2_two_part`
- Reading: `R_matching_headings`, `R_matching_information_paragraph`, `R_true_false_not_given`, `R_multiple_choice`, etc.
- Listening: `L_form_completion`, `L_flow_chart_completion`, `L_multiple_choice`, etc.
- Speaking: Part 1/2/3 prompt types

**Pronunciation has no question type.** Pronunciation uses `PracticeUnitRef` (see §2.1), not TaskType. The framework defines 5 canonical practice units (`P_phoneme`, `P_word_stress`, `P_sentence_stress`, `P_intonation`, `P_linking`) in `skill-questiontype-band.md` v1.0.6, explicitly stating "Pronunciation — no separate 'question type'." The `P_*` IDs are practice-unit identifiers, not TaskType identifiers. Pronunciation is NOT a separate IELTS exam score.

**Practice modes (NOT TaskTypes — these are orchestration inputs):**
- `timed` — time constraint applied to any TaskType
- `adaptive` — difficulty selection applied to any TaskType
- `drill` — repetition focus on a specific TaskType or micro_skill
- `retest` — evidence-backed re-evaluation of a previously missed item
- `exam_simulation` — composite timed attempt across multiple TaskTypes

**Ownership boundary:** TaskTypes are defined by the internal framework controlled vocabulary; any claim that a type is officially equivalent to an IELTS task type requires a named, versioned external source. Unknown values are declared as `unknown_task_type`. Practice modes are orchestration parameters applied to TaskTypes — they do not create new TaskTypes.

**Typed relationships:**
- TaskType `belongs_to` Skill
- TaskType `has_many` PracticeAttempt (via PRACTICE.*)
- TaskType `assessed_by` Assessment (via EVAL.*)
- TaskType `tagged_by` difficulty, band, micro_skill
- TaskType `references` Knowledge (prompt, passage, audio stimulus)

### 1.4 Practice

**Definition:** A learner attempt at a LearningTarget (see §3.1 LearningTargetRef), producing a response that may be scored or reviewed. Practice is the action layer — it records what the learner did, when, and with what outcome.

**Owner:** `blueprint/03-features.md` (PRACTICE.*, STUDY.*, LEARN.*)

**Canonical subtypes:**
- `PRACTICE.Drill` — focused repetition on a LearningTarget or error pattern
- `PRACTICE.Set` — structured exercise set
- `PRACTICE.Timed` — time-constrained practice
- `PRACTICE.Adaptive` — difficulty-adaptive selection
- `PRACTICE.MockTest` — full or section test
- `STUDY.MicroSession` — short (5–10 min) bounded session
- `STUDY.Session` — full study session
- `LEARN.Writing` — writing workspace interaction
- `LEARN.Listening`, `LEARN.Reading`, `LEARN.Speaking`, `LEARN.Pronunciation` — skill-specific practice surfaces

**Ownership boundary:** Practice is what the learner does. It is distinct from Assessment (which judges the outcome) and Knowledge (which provides the stimulus). A Practice attempt may feed into Assessment, but Practice is not Assessment.

**Typed relationships:**
- Practice `uses` LearningTarget (TaskTypeRef for L/R/W/S; PracticeUnitRef for Pronunciation)
- Practice `produces` LearningEvidence
- Practice `consumes` Knowledge (as prompt/stimulus/reference)
- Practice `triggers` Assessment (optional — practice may be unscored)
- Practice `scheduled_by` FSRS (via REVIEW.*)
- Practice `part_of` StudySession

**Learner-facing Practice Library taxonomy:**
```
Practice Library (learner-visible)
├── By Skill: Writing / Speaking / Reading / Listening / Pronunciation
├── By TaskType: [per-skill TaskType list from framework]
├── By Band: 3.0 – 9.0
├── By Focus: Grammar / Vocabulary / Task Response / Coherence / Fluency / Pronunciation
└── By Mode: Timed / Untimed / Adaptive / Retest
```

This taxonomy is a projection for the learner UI. It is NOT the internal Skill Ontology. The internal ontology uses framework IDs; the Practice Library uses learner-friendly labels per `07-conventions.md`.

### 1.5 Content

**Definition:** The operational lifecycle of Knowledge assets — authoring, tagging, moderation, versioning, publishing, and deprecation. Content is Knowledge plus its workflow state.

**Owner:** `blueprint/03-features.md` (CONTENT.*), `blueprint/05-content.md`

**Canonical subtypes:**
- `CONTENT.Publish` — publication workflow
- `CONTENT.Moderation` — review and approval
- `CONTENT.Feedback` — learner feedback on content
- `CONTENT.QuestionBank` — question/item bank management
- `CONTENT.Tag`, `CONTENT.TagReview`, `CONTENT.AutoTag` — tagging pipeline
- `CONTENT.BlueprintUpdate` — blueprint-driven content refresh
- `CONTENT.Quiz`, `CONTENT.Lesson` — content packaging

**Ownership boundary:** Content is Colab-owned workflow. It is NOT learner-facing content display (that's Knowledge consumption via LEARN.*). Content quality gates are deferred to P1.

**Typed relationships:**
- Content `manages` Knowledge lifecycle
- Content `produces` ContentRevision
- Content `tagged_by` Taxonomy dimensions
- Content `published_to` Knowledge (available for learner consumption)

### 1.6 Assessment

**Definition:** A scored, evidence-linked evaluation of a learner response. Assessment produces a band estimate, criterion-level scores, and actionable findings. Assessment is the judgment layer.

**Owner:** `blueprint/03-features.md` (EVAL.*, PLACE.*, BAND.*, GOVERNANCE.*)

**Canonical subtypes:**
- `EVAL.Writing` — sole-scorer writing evaluation
- `EVAL.Speaking` — sole-scorer speaking evaluation (deferred)
- `EVAL.Pronunciation` — phoneme/stress/intonation evaluation (deferred)
- `EVAL.Examiner` — interactive dialogue evaluation (deferred)
- `PLACE.Test` — placement assessment
- `PLACE.BandEstimation` — band estimation from placement
- `BAND.Current` — current band projection
- `BAND.Readiness`, `BAND.ExamReadiness` — readiness assessment

**Sole evaluator principle:** AI scores 100%, no human-in-the-loop. Quality is controlled by GOVERNANCE.* backend (confidence scoring, benchmark, drift detection). No AI label in learner UI.

**Ownership boundary:** Assessment owns the scoring judgment. It does NOT own the learner response (that's Practice/LearningEvidence) or the corrective action (that's Review/FSRS or COACH).

**Typed relationships:**
- Assessment `evaluates` LearningEvidence (the response)
- Assessment `produces` CriterionResult (per-criterion band + confidence)
- Assessment `produces` FeedbackFinding (actionable error/improvement)
- Assessment `references` Rubric (framework band descriptor)
- Assessment `references` ModelVersion (evaluator identity)
- Assessment `governed_by` GOVERNANCE.ConfidenceScore, GOVERNANCE.Benchmark

### 1.7 Evidence

**Definition:** An immutable, append-only, privacy-filtered record of a single learner action or outcome at a single point in time. Evidence is the atomic unit of the learning graph — every fact the system knows about a learner comes from Evidence. Evidence is a **discriminated union of typed facts** (see §3), not a mutable aggregate.

**Owner:** This proposal defines Evidence as a new cross-cutting contract (see §3). Current partial owners: `OPS.QualityEconomics` (benchmark evidence), `GOVERNANCE.AuditTrail` (audit evidence), individual entity contracts (per-family event schemas).

**Canonical fact types (see §3.1 for full schemas):**
- `AttemptFact` — learner engaged with a task
- `EvaluationFact` — an attempt was evaluated (append-only; re-evaluation creates new fact with `supersedes`)
- `RetestFact` — a retest was completed
- `ReviewRatingFact` — an FSRS card was rated
- `ErrorResolutionFact` — a learning error changed state
- `PlacementFact` — a placement response or band estimation
- `BenchmarkEvidence` — gold-corpus run result (OPS-owned)
- `AuditEvidence` — governance decision record (OPS-owned)
- `ConsentEvidence` — consent record (IDENTITY-owned, immutable fact)

**Ownership boundary:** Evidence facts are produced by Practice (AttemptFact), Assessment (EvaluationFact), and Governance (BenchmarkEvidence). Evidence facts are consumed by Mastery (computation), PERSONAL.Insights (explanation), PROGRESS (visualization), and REVIEW.FSRS (scheduling). Evidence facts are append-only and immutable per lifecycle-contract.md §2.3.

**Typed relationships:**
- Evidence fact `produced_by` Practice | Assessment | Governance
- Evidence fact `consumed_by` Mastery | PERSONAL.* | PROGRESS.* | REVIEW.FSRS
- Evidence fact `references` Knowledge (the task/prompt used, via `task_ref`)
- Evidence fact `tagged_by` Skill, TaskType, micro_skill, grammar_point
- Evidence fact `versioned_by` source_version (rubric, model, task)
- Evidence fact `has` privacy_class (learning | assessment | audio | derived)

**No-raw-content policy (unchanged):** Evidence facts contain references, scores, metadata, and hashes. They NEVER contain raw essay text, audio bytes, transcript text, provider prompt payload, or model reasoning tokens. Raw content lives in learner-scoped storage (WritingDraft, R2 audio) and is accessed by reference only.

### 1.8 Mastery

**Definition:** The system's current estimate of a learner's capability on a specific Skill × CompetencyRef intersection, derived from all available Evidence facts. Mastery is a computed projection, NOT a stored truth.

**Owner:** This proposal defines Mastery as a **canonical missing domain** — see §2.

**Current gap:** No capability ID, family, entity, contract, or OpenAPI schema exists for Mastery. The concept is implicit in `BAND.Current`, `BAND.Readiness`, `PLACE.BandEstimation`, and `PERSONAL.GapAnalysis` but has no canonical owner.

## 2. Mastery — canonical missing domain

### 2.1 Entity definition

**CompetencyRef — controlled reference union**

Before defining Mastery, the dimension it tracks must be a named, controlled union. `CompetencyRef` is the canonical reference type for what Mastery estimates. Only references backed by existing controlled vocabulary are included:

```
CompetencyRef = TaskTypeRef | PracticeUnitRef | GrammarPointRef | CriterionRef | SkillLevelRef

TaskTypeRef {
  ref_type: "task_type"
  task_type_id: framework TaskType ID
  // Must resolve to a W_* (Writing), R_* (Reading), L_* (Listening),
  // or S_* (Speaking) ID from skill-questiontype-band.md v1.0.6.
  // Rejected if: id not in framework enum → unknown_task_type (fail-closed).
  skill: Skill enum (the parent skill; enforced: W_* → writing, R_* → reading, etc.)
}

PracticeUnitRef {
  ref_type: "practice_unit"
  practice_unit_id: framework pronunciation unit ID
  // Must resolve to one of: P_phoneme, P_word_stress, P_sentence_stress,
  // P_intonation, P_linking (from skill-questiontype-band.md v1.0.6).
  // Only valid when skill = pronunciation.
  // Rejected if: id not in framework enum → unknown_practice_unit (fail-closed).
  skill: "pronunciation" (fixed)
}

GrammarPointRef {
  ref_type: "grammar_point"
  grammar_point_id: framework grammar_point ID
  // Must resolve to a g_* ID from grammar-band-framework.md v1.0.6
  // (e.g., g_present_simple, g_second_conditional, g_relative_clause).
  // These IDs already exist in the framework — no framework change is required
  // to add this CompetencyRef variant.
  // Rejected if: id not in framework enum → unknown_grammar_point (fail-closed).
  // GrammarPointRef is skill-independent: the same grammar point may be
  // practiced or assessed across writing and speaking.
}

CriterionRef {
  ref_type: "criterion"
  criterion: enum {task_response, coherence_cohesion, lexical_resource, grammar}
  // Writing criteria per openapi.yaml v0.5.0 CriterionResult schema.
  // Speaking criteria (fluency, lexical, grammar, pronunciation) are deferred
  // and must be defined by the Speaking evaluation canonical owner.
  skill: Skill enum (writing or speaking — the skills that have rubric criteria)
}

SkillLevelRef {
  ref_type: "skill_level"
  skill: Skill enum
  // Skill-level aggregate — no sub-dimension. Used for overall skill band.
}
```

**Explicit P1 framework gap — vocabulary and collocation identifiers:**

Grammar points have controlled IDs in `grammar-band-framework.md` v1.0.6 (e.g., `g_present_simple`, `g_second_conditional`). `GrammarPointRef` is therefore a valid, immediately usable CompetencyRef variant — no framework change is needed.

Vocabulary items and collocation pairs lack a controlled identifier model. The `KA.Vocabulary` and `KA.Collocation` Knowledge Asset types exist, but they carry band/cefr/collocation tags as metadata fields, not as a resolvable controlled enum of IDs. This means:
- `CompetencyRef` does NOT include a `VocabularyRef` or `CollocationRef` variant — there is no framework enum to validate against.
- A P1 framework change request is required to define a controlled vocabulary/collocation identifier model if those dimensions need independent Mastery tracking. Until then, vocabulary and collocation are tracked indirectly through `CriterionRef(lexical_resource)` at the Writing/Speaking criterion level and through `GrammarPointRef` for grammar-adjacent lexical patterns.

**What "exhaustive" means and what it does not mean:**

The `CompetencyRef` union is exhaustive over the dimensions that CAN be tracked given current framework vocabulary. It does NOT claim to cover every conceivable learning dimension. New ref variants require a framework change that adds the corresponding controlled vocabulary — they cannot be added by the ontology alone. This is a fail-closed design, not an exhaustive one.

**Mastery entity:**

```
Mastery {
  subject_id: opaque learner identifier
  competency: CompetencyRef  // WHAT is being estimated
  metric: MetricType  // HOW it is measured (see learning-measurement-traceability-proposal.md §4)
  // DESIGN DEFECT (v0.3.1): the generic 'band: 0.0-9.0' field below is invalid
  // for non-band-aligned CompetencyRef variants. Not every competency maps to an
  // IELTS band. TaskTypeRef, PracticeUnitRef, and GrammarPointRef MUST use
  // PerformanceEstimate, FeaturePerformanceEstimate, or KnowledgeMasteryEstimate
  // respectively — never a band score. The 'band' field is retained here only as
  // a placeholder pending adoption of the MetricType union. See
  // learning-measurement-traceability-proposal.md §4.3 for the mandatory
  // CompetencyRef → MetricType mapping.
  band: 0.0 – 9.0 (0.5 steps)  // VALID ONLY for CriterionRef + SkillLevelRef (Writing)
  confidence: 0.0 – 1.0
  recency: timestamp of most recent evidence contributing to this estimate
  evidence_count: number of distinct evidence facts contributing
  version: monotonically increasing integer (incremented on recalculation)
  computed_at: timestamp of last computation
  stale_after: timestamp after which this estimate is considered stale
  explainability_refs: [fact_id, ...] — top N evidence facts most influential
}
```

**Pending correction:** When `learning-measurement-traceability-proposal.md` MetricType is adopted, `band` must be replaced with `metric: MetricType`. No numeric band thresholds are defined here — all thresholds require post-code calibration evidence.

### 2.2 Evidence inputs

Mastery is computed from the following evidence types (all exist or are proposed):

| Evidence type | Contribution | Weight factor |
|---|---|---|
| `EvaluationFact` (EVAL.Writing criterion score, per criterion) | Band estimate for that criterion + micro_skills | Assessment confidence |
| `PlacementFact` (PLACE.BandEstimation subtype) | Initial band seed per skill | Placement confidence |
| `RetestFact` outcome | improvement/regression signal | Recency |
| `ReviewRatingFact` (FSRS card rating: again/hard/good/easy) | Retrieval strength proxy | FSRS stability |
| `ErrorResolutionFact` (transition to resolved/recurring) | Gap-closure signal | Error severity + recency |
| — | — | — |

**Explicit non-inputs (to prevent circular dependency):**
- `BAND.Current` projection — MUST NOT feed Mastery. BAND.Current is a downstream consumer of Mastery, not an input. Including it would create a self-referential cycle where band estimates calibrate themselves.

**Explicit non-inputs:** StudySession duration (effort ≠ mastery). Practice attempt count without outcome (volume ≠ quality). Content consumption without assessment (reading ≠ understanding).

### 2.3 State, confidence, recency, version

- **State:** Mastery is a computed projection. It has no persisted lifecycle states — only `current` (latest computation) and `stale` (past stale_after). Previous versions are retained as `MasterySnapshot` for timeline queries.
- **Confidence:** Derived from: number of distinct evidence facts contributing, their individual confidence scores (from EvaluationFact), recency distribution, and consistency (do multiple EvaluationFacts agree on the same CompetencyRef?). No hard threshold defined — this is an algorithm choice requiring post-code calibration evidence.
- **Recency:** The `recorded_at` timestamp of the most recent contributing evidence fact. If recency exceeds `stale_after`, the estimate is flagged stale. No default `stale_after` value is proposed — this requires founder input.
- **Version:** Monotonically increasing. Every recalculation produces a new Mastery version. Prior versions are retained for audit and drift analysis.

### 2.4 Recalculation trigger

Mastery is recalculated when:
1. A new `EvaluationFact` is persisted (direct assessment → immediate recalculation for the evaluated skill + competency).
2. A `RetestFact` with `outcome` is persisted (retest outcome → recalculation for the error's competency).
3. An `ErrorResolutionFact` with `new_status: resolved` or `new_status: recurring` is persisted (gap-closure signal).
4. A configurable time window elapses without new evidence facts (scheduled refresh for staleness management).

Recalculation is a deterministic internal command, NOT an LLM call. At P0, it is a rule-based aggregation of available evidence. No ML model, no Bayesian network, no numeric threshold is proposed without evidence.

### 2.5 Explainability

Every Mastery estimate MUST expose:
- `top_fact_refs`: the N most influential evidence facts (sorted by weight contribution)
- `confidence_breakdown`: per-fact-type contribution to overall confidence
- `gap_facts`: which CompetencyRef values have zero or low evidence facts (→ explains `unknown_*` state)

Learner-facing explainability: "Your estimated Writing band is 5.5–6.0 based on 3 evaluations. Coherence & Cohesion is your strongest criterion (6.0). Grammar needs more evidence (only 1 evaluation, low confidence)."

### 2.6 Privacy, export, deletion

- **Privacy class:** `derived` — Mastery is a computed projection from evidence facts, not raw learner content.
- **Export:** All Mastery snapshots for the requesting subject are included in privacy export as structured JSON (per lifecycle-contract.md §2.5 export invariant).
- **Deletion:** Mastery snapshots are deleted with the account. Recalculation on anonymized aggregate data is deferred.
- **No-raw-content:** Mastery records contain band estimates, confidence, fact references, and metadata only. No essay text, audio, or transcript.

### 2.7 Stale-data behavior

- A Mastery estimate with `now > stale_after` is flagged `stale: true`.
- Stale estimates are still displayed (best available information) with a staleness indicator: "Last updated [date]. New evaluation needed for current estimate."
- Stale estimates are NOT used for: adaptive difficulty selection, band readiness claims, or exam readiness scoring.
- The `stale_after` duration is NOT defined here — it requires founder decision based on expected learner evaluation frequency.

## 3. LearningEvidence — immutable typed facts

### 3.0 Design principle: append-only facts, not mutable aggregates

Per `artifacts/engineering/contracts/runtime/lifecycle-contract.md` §2.3: fact entities are append-only. Once written, their content is never modified. Corrections create new facts with `supersedes` references.

LearningEvidence is therefore NOT a single mutable entity that accumulates attempt + evaluation + retest into one record. It is a **discriminated union of immutable typed facts**, each recording exactly one event at one point in time. Queries compose facts by `subject_id`, `skill`, and dimension references — no fact is ever updated in place.

### 3.1 Fact type union

```
LearningEvidence = AttemptFact | EvaluationFact | RetestFact | ReviewRatingFact | ErrorResolutionFact | PlacementFact
```

Each fact type is sealed — its fields are fixed at creation and never modified.

**LearningTargetRef — what the learner engaged with**

Before defining the fact schemas, the target of every attempt and evaluation must be a controlled union. `LearningTargetRef` discriminates between task-type-based practice (Listening, Reading, Writing, Speaking) and practice-unit-based practice (Pronunciation):

```
LearningTargetRef = TaskTypeRef | PracticeUnitRef
// TaskTypeRef and PracticeUnitRef are defined in §2.1 CompetencyRef.
// Enforcement:
//   - skill ∈ {listening, reading, writing, speaking} → LearningTargetRef MUST be TaskTypeRef
//   - skill = pronunciation → LearningTargetRef MUST be PracticeUnitRef
//   - Any other combination → fail-closed; reject at validation.
```

#### AttemptFact — a learner engaged with a task

```
AttemptFact {
  // Identity
  fact_id: opaque string
  fact_type: "attempt"
  subject_id: opaque learner identifier
  
  // Source
  source_capability_id: capability ID (e.g., PRACTICE.Drill, LEARN.Writing)
  source_version: string (task version, config version)
  
  // What was attempted
  skill: Skill enum
  learning_target: LearningTargetRef  // TaskTypeRef for L/R/W/S; PracticeUnitRef for Pronunciation
  task_ref: opaque reference to Knowledge asset
  micro_skill_refs: [framework micro_skill ID, ...]
  grammar_point_refs: [framework grammar_point ID, ...]
  
  // Temporal
  started_at: timestamp
  completed_at: timestamp
  duration_seconds: integer
  
  // Metadata
  recorded_at: timestamp (immutable — set once at creation)
  privacy_class: enum {learning, assessment, audio, derived}
}
```

An AttemptFact records that a learner attempted a task. It does NOT contain a score, outcome, or evaluation — those are separate EvaluationFact records. This separation ensures that a re-evaluation of the same attempt creates a new EvaluationFact (with `supersedes` reference to any prior evaluation) rather than mutating the attempt.

#### EvaluationFact — an attempt was evaluated

```
EvaluationFact {
  // Identity
  fact_id: opaque string
  fact_type: "evaluation"
  subject_id: opaque learner identifier
  
  // Source
  source_capability_id: capability ID (e.g., EVAL.Writing, PLACE.BandEstimation)
  source_version: string (rubric version, model version)
  
  // What was evaluated
  attempt_fact_ref: fact_id of the AttemptFact this evaluates
  skill: Skill enum
  learning_target: LearningTargetRef  // inherited from AttemptFact; same enforcement rules
  
  // Result
  overall_band_estimate: 0.0–9.0 | null
  overall_confidence: 0.0–1.0 | null
  criterion_results: [{criterion, band_estimate, confidence, evidence_refs}] | null
  quality_status: enum {accepted, low_confidence, insufficient_evidence, invalid} | null
  
  // References to findings
  finding_refs: [opaque finding IDs] | null
  
  // Governance
  evaluation_state: string
  // Canonical owner per evaluator:
  //   Writing: openapi.yaml v0.5.0, WritingEvaluation.evaluation_state:
  //     {submitted, processing, scored, low_confidence, invalid, anti_gaming_review, failed}
  //   Speaking: not yet defined (deferred; MUST be declared by Speaking evaluation canonical owner)
  //   Pronunciation: not yet defined (deferred; MUST be declared by Pronunciation evaluation canonical owner)
  //   Placement: lifecycle-contract.md, PlacementAttempt states (different state model)
  // This generic schema only stores the string; validation MUST delegate to the
  // canonical owner for the source_capability_id's evaluator family.
  supersedes: fact_id | null (prior evaluation this one replaces)
  
  // Metadata
  recorded_at: timestamp (immutable)
  privacy_class: "assessment"
}
```

**Quality status vocabulary (proposed, Writing owner only):**

The `quality_status` values below are defined by and scoped to the Writing evaluation canonical owner (`openapi.yaml` v0.5.0, `WritingEvaluation.quality_status`). They are NOT yet a cross-evaluator controlled vocabulary — they are proposed here as a shared pattern, but each evaluator family must adopt or extend them in its own canonical owner contract:

| quality_status | Meaning | Current scope |
|---|---|---|
| `accepted` | Evaluation meets confidence thresholds | Writing (openapi.yaml) |
| `low_confidence` | Below threshold; may still be shown with caveat | Writing (openapi.yaml) |
| `insufficient_evidence` | Not enough signal to produce a result | Writing (openapi.yaml) |
| `invalid` | Evaluation could not be completed or result is unusable | Writing (openapi.yaml) |

Future evaluators (Speaking, Pronunciation) MAY adopt these values or define their own — the generic fact schema does not enforce them. `anti_gaming_review` is a Writing-specific `evaluation_state`, not a `quality_status`, and belongs in the Writing canonical owner contract.

An EvaluationFact is immutable. If the same submission is re-evaluated (retry, model upgrade), a new EvaluationFact is created with `supersedes` pointing to the prior evaluation. The prior fact is never modified.

#### RetestFact — a retest was completed

```
RetestFact {
  fact_id: opaque string
  fact_type: "retest"
  subject_id: opaque learner identifier
  
  source_error_ref: error_id (the LearningError that triggered this retest)
  attempt_fact_ref: fact_id of the AttemptFact for this retest
  evaluation_fact_ref: fact_id of the EvaluationFact for this retest outcome
  
  outcome: enum {improved, unchanged, regressed, insufficient_evidence}
  
  recorded_at: timestamp (immutable)
  privacy_class: "learning"
}
```

#### ReviewRatingFact — an FSRS card was rated

```
ReviewRatingFact {
  fact_id: opaque string
  fact_type: "review_rating"
  subject_id: opaque learner identifier
  
  card_ref: card_id
  source_error_ref: error_id
  rating: enum {again, hard, good, easy}
  prior_state: enum {new, learning, review, relearning}
  new_state: enum {learning, review, relearning, graduated}
  next_due_at: timestamp
  
  recorded_at: timestamp (immutable)
  privacy_class: "learning"
}
```

#### ErrorResolutionFact — a learning error changed state

```
ErrorResolutionFact {
  fact_id: opaque string
  fact_type: "error_resolution"
  subject_id: opaque learner identifier
  
  error_ref: error_id
  prior_status: enum {open, in_review, improved, recurring}
  new_status: enum {in_review, improved, resolved, dismissed, recurring}
  transition_source: enum {learner_action, retest_outcome, fsrs_graduation, manual_dismiss}
  
  recorded_at: timestamp (immutable)
  privacy_class: "learning"
}
```

#### PlacementFact — a placement response or result

```
PlacementFact {
  fact_id: opaque string
  fact_type: "placement"
  subject_id: opaque learner identifier
  
  placement_attempt_ref: attempt_id
  placement_subtype: enum {response, band_estimation}
  
  // For response subtype
  item_ref: string | null
  response_hash: string | null  (never raw response text)
  
  // For band_estimation subtype
  estimated_band: 0.0–9.0 | null
  confidence: 0.0–1.0 | null
  
  recorded_at: timestamp (immutable)
  privacy_class: "learning"
}
```

### 3.2 Per-skill extensions

Per-skill extensions add skill-specific fields to the base fact types. These are additive — they do not change the immutability contract.

**Writing extension (applies to AttemptFact and EvaluationFact):**

WritingAttemptFact extends AttemptFact:
- `word_count`: integer
- `draft_version`: integer (the draft version submitted)

WritingEvaluationFact extends EvaluationFact:
- `criterion_results` required fields: TaskResponse, CoherenceCohesion, LexicalResource, Grammar (4 criteria, per `openapi.yaml` v0.5.0 CriterionResult schema)

**Speaking extension (deferred):**

SpeakingAttemptFact extends AttemptFact:
- `recording_ref`: opaque R2 reference (never in event/log)
- `duration_seconds`: integer
- `part`: enum {part1, part2, part3}

SpeakingEvaluationFact extends EvaluationFact:
- `transcript_ref`: opaque reference (never in event/log)
- `feature_scores`: {fluency, lexical, grammar, pronunciation} | null

**Reading extension (deferred):**

ReadingAttemptFact extends AttemptFact:
- `passage_ref`: opaque reference
- `paragraph_refs`: [opaque references]
- `question_order`: integer

**Listening extension (deferred):**

ListeningAttemptFact extends AttemptFact:
- `audio_ref`: opaque reference
- `playback_position_seconds`: integer
- `replay_count`: integer
- `question_order`: integer

**Pronunciation extension (deferred):**

PronunciationAttemptFact extends AttemptFact:
- `recording_ref`: opaque R2 reference
- `target_unit` is NOT a separate field. The pronunciation unit is derived from `learning_target: LearningTargetRef.PracticeUnitRef.practice_unit_id`. Duplicating it as a standalone field would create a consistency risk (target_unit could diverge from learning_target). The canonical source is `LearningTargetRef`.

PronunciationEvaluationFact extends EvaluationFact:
- `feature_scores`: {phoneme_accuracy, word_stress_accuracy, sentence_stress_accuracy, intonation_accuracy, linking_accuracy} | null
- Feature score keys correspond 1:1 to the 5 canonical `P_*` practice units from `skill-questiontype-band.md` v1.0.6.

### 3.3 No-raw-content policy (unchanged)

Evidence records and their events MUST NOT contain:
- Raw essay text
- Audio bytes or recording data
- Transcript text
- Provider prompt payload
- Model reasoning tokens
- Learner PII beyond opaque subject_id

Raw content is accessed via learner-scoped storage references (WritingDraft.draft_id, R2 object key). Evidence carries the reference, never the content.

## 4. P0 Writing loop — reference vertical slice

This section traces the closed-pilot Writing Task 2 loop through all 8 ontological layers. Each layer's current P0 implementation status is noted.

### Layer 1: Skill

- **Classification:** `writing` (framework-canonical)
- **P0 status:** Contract-defined. `EVAL.Writing` and `LEARN.Writing` capabilities are ACTIVE in the capability lifecycle registry. `openapi.yaml` v0.5.0 defines the writing evaluation contract. Runtime not built — all application source workspaces remain globally locked.
- **Gaps:** No runtime acceptance evidence. Writing is the sole P0 skill by capability scope, not by implementation status.

### Layer 2: Knowledge

- **Classification:** Task 2 prompt (published Knowledge asset), rubric (framework), error taxonomy (framework)
- **P0 status:** Partially contract-defined. `WritingTask` entity exists in OpenAPI with `task_type` enum. Rubric referenced via `rubric_version`. Error taxonomy referenced via `error_pattern` (must resolve to framework error_id).
- **Gaps:** P0 requires at least 1 published `WritingTask` per task_type. Task publication workflow (CONTENT.Publish) is deferred to P1 — P0 tasks would be seeded manually in the initial data migration. No `KA.Example` assets exist yet for model answers. None of these gaps block the contract definition but all block runtime acceptance.

### Layer 3: TaskType

- **Classification:** `W_task2_opinion`, `W_task2_discussion`, `W_task2_advantages_disadvantages`, `W_task2_problem_solution`, `W_task2_two_part`
- **P0 status:** Contract-defined. `WritingTask.task_type` enum in OpenAPI covers all 5 framework Task 2 types. `getWritingTask` operation returns a task by ID with its type.
- **Gaps:** No task-type-specific evaluation behavior (all Task 2 types share the same rubric contract). No task-type difficulty calibration evidence.

### Layer 4: Practice

- **Classification:** `LEARN.Writing` (workspace + draft), `PRACTICE.Drill` (error retest), `STUDY.MicroSession` (session container)
- **P0 status:** Contract-defined. OpenAPI operations: `saveWritingDraft` (draft), `createWritingSubmission` (submit), `completeWritingErrorFix` (fix drill), `startWritingErrorRetest` (retest). Lifecycle states defined in lifecycle-contract.md for WritingDraft, WritingSubmission, StudySession, RetestAttempt.
- **Gaps:** No timed/untimed mode toggle in contract (all P0 writing is untimed by default). No adaptive difficulty. No mock test composite.

### Layer 5: Content

- **Classification:** `WritingTask` publication (deferred), `WritingDraft` (learner-owned PKM)
- **P0 status:** Partially contract-defined. `WritingTask` entity exists in OpenAPI. `WritingDraft` entity and lifecycle are defined (WRITING.Evaluation family, lifecycle-contract.md). Task publication workflow (CONTENT.Publish) is deferred to P1.
- **Gaps:** No content lifecycle for tasks (author → review → publish → deprecate) at P0. No question bank management.

### Layer 6: Assessment

- **Classification:** `EVAL.Writing` (sole-scorer evaluation), `COACH.ErrorAnalysis` (finding extraction), `COACH.Feedback` (learner feedback on evaluation)
- **P0 status:** Contract-defined (contract at `review`). `createWritingSubmission` → async evaluation job lifecycle → `WritingEvaluation` result with 4 criteria, overall band, confidence, anti_gaming_status, and findings per `openapi.yaml` v0.5.0. Job lifecycle defined in lifecycle-contract.md §5. `submitWritingFeedback` for learner quality feedback. Runtime not built — source workspaces globally locked.
- **Gaps:** Gold corpus missing. Benchmark not run. Numeric thresholds unarmed. Confidence scoring is provider-reported (not independently verified). Anti-gaming is `unchecked` placeholder. All of these are post-code gates that require a running implementation to resolve.

### Layer 7: Evidence

- **Classification:** `WritingSubmission` (fact of submission), `WritingEvaluation` (fact of evaluation), `LearningError` (confirmed error), `RetestAttempt` (retest outcome)
- **P0 status:** Partially contract-defined. `WritingSubmission` and `WritingEvaluation` entities are defined as append-only in lifecycle-contract.md (immutability invariant §2.3). `LearningError` entity is defined with canonical states. No unified `LearningEvidence` fact-union contract exists — entity-specific schemas carry evidence fields independently. This proposal defines the unified contract in §3.
- **Gaps:** No unified evidence fact schema adopted. No cross-skill evidence query defined. No evidence-to-mastery pipeline defined.

### Layer 8: Mastery

- **Classification:** Not defined — canonical missing domain
- **P0 status:** NOT DEFINED. No entity, capability ID, contract, or OpenAPI schema exists for Mastery. `BAND.Current` exists as a projection from placement in the capability registry, but there is no per-skill, per-CompetencyRef mastery estimate updated from writing evaluations. This proposal defines the domain in §2.
- **Gaps:** Entire domain gap. P0 contract-defined writing evaluations produce criterion scores and findings that could feed a Mastery computation, but no entity or contract exists to ingest them. This proposal defines the domain without claiming it is implemented.

### Deferred skills — gap map

| Skill | Skill layer | Knowledge | TaskType | Practice | Content | Assessment | Evidence | Mastery |
|---|---|---|---|---|---|---|---|---|---|
| Reading | LEARN.Reading (P1) | KA.* + framework | Framework R_* types | PRACTICE.* (P1) | CONTENT.* (P1) | COACH.ReadingCoach (P1) | Not defined | Not defined |
| Listening | LEARN.Listening (P1) | KA.* + framework | Framework L_* types | PRACTICE.* (P1) | CONTENT.* (P1) | COACH.ListeningCoach (P1) | Not defined | Not defined |
| Speaking | LEARN.Speaking (P1) | KA.* + framework | Part 1/2/3 types | PRACTICE.* (P1) | CONTENT.* (P1) | EVAL.Speaking (P1) | Not defined | Not defined |
| Pronunciation | LEARN.Pronunciation (P1) | framework P_* units | P_* unit types | PRACTICE.* (P1) | CONTENT.* (P1) | EVAL.Pronunciation (P1) | Not defined | Not defined |

Vocabulary and Grammar are explicitly excluded from this gap map because they are **formative-practice knowledge domains**, not IELTS macro skills. They have:
- No independent IELTS band score (IELTS does not issue a "Grammar 6.0" or "Vocabulary 7.5" certificate)
- No standalone TaskTypes (a learner does not take a "Grammar Task 2")
- No separate evaluation pipeline distinct from the macro-skill evaluators

However, they are valid formative-practice domains in their own right:
- `KA.Grammar` and `KA.Vocabulary` Knowledge Assets exist as first-class content types
- Grammar points have controlled framework IDs (`grammar-band-framework.md`)
- Both are tagged on macro-skill TaskTypes (`grammar_point_refs` on a Writing task)
- Both appear in the learner-facing Practice Library taxonomy as "Focus" dimensions
- Grammar point mastery can be tracked through `CompetencyRef.GrammarPointRef` using existing `grammar_point_id` values from `grammar-band-framework.md` v1.0.6 (no framework change required — the IDs already exist)

**Missing P1 contract — vocabulary/collocation fact and identifier model:**

Vocabulary and collocation lack a controlled identifier model. There is no framework enum of vocabulary IDs or collocation pair IDs equivalent to the grammar point IDs in `grammar-band-framework.md`. This means:
- A `VocabularyFact` or `CollocationFact` cannot yet be defined as a sealed Evidence fact type — there is no controlled `vocabulary_id` or `collocation_id` to reference.
- Vocabulary/collocation practice is recorded indirectly: an `AttemptFact` with `skill: writing` and `grammar_point_refs` capturing lexical-adjacent grammar points, plus `CriterionRef(lexical_resource)` in the EvaluationFact.
- A P1 framework change request is required to define a controlled vocabulary/collocation identifier model. Until adopted, vocabulary and collocation have no independent Evidence fact type and no direct CompetencyRef variant.

This design prevents the category error of treating grammar/vocabulary as peer IELTS skills alongside Listening, Reading, Writing, and Speaking, while honestly stating what contracts are missing to give them first-class evidentiary status.

## 5. Protected Blueprint diff proposal

The following changes to `blueprint/03-features.md` are proposed if the ontology is adopted. These are proposals only — `blueprint/**` is a protected path and must not be edited without privileged workflow.

### 5.1 Proposed capability additions

| Proposed ID | Capability | Domain | Phase | Rationale |
|---|---|---|---|---|
| `MASTERY.SkillEstimate` | Per-skill, per-dimension mastery computation from evidence | New domain: MASTERY | P1 | Currently no mastery entity exists. Writing evaluations produce criterion scores but nothing aggregates them per micro_skill over time. |
| `MASTERY.BandProjection` | Band projection from mastery estimates | MASTERY | P1 | Extends BAND.Current with per-skill, evidence-backed estimates. |
| `MASTERY.GapAnalysis` | Evidence-count and confidence analysis per micro_skill | MASTERY | P1 | Feeds PERSONAL.GapAnalysis with evidence-backed gap data. Currently PERSONAL.GapAnalysis has no canonical input entity. |
| `EVIDENCE.LearningRecord` | Unified LearningEvidence fact-union contract as cross-cutting entity (see §3) | New domain: EVIDENCE | P1 | Currently evidence is per-family events with no unified schema. This proposal defines the immutable typed-fact union. Adoption enables cross-skill evidence queries. |

### 5.2 Proposed existing capability reclassification

| Capability | Current domain | Proposed change | Rationale |
|---|---|---|---|
| `BAND.Current` | BAND (progression) | Add `derived_from: MASTERY.SkillEstimate` | BAND.Current should derive from mastery, not exist as an independent projection |
| `PERSONAL.GapAnalysis` | PERSONAL | Add `input: MASTERY.GapAnalysis` | Gap analysis needs an evidence-count input entity |
| `PERSONAL.Insights` | PERSONAL | Add `input: EVIDENCE.LearningRecord` | Insights need cross-skill evidence to generate explanations |

### 5.3 Proposed framework additions

These are NOT capability IDs — they are additions to `blueprint/framework/` vocabulary.

*No framework additions are proposed in this version.*

- **Pronunciation:** Already a controlled skill value in `blueprint/05-content.md` (tag dimension `skill`, controlled coverage matrix, `learning_design_profile.skill` enum). Framework `skill-questiontype-band.md` v1.0.6 defines the canonical `P_*` practice units. No framework change is needed.
- **Unknown/new skills:** Unknown skills are **fail-closed framework gaps**, not publishable controlled values. If a capability, artifact, or runtime contract references a skill not in the framework enum (`listening|reading|writing|speaking|pronunciation`), it MUST be reported as `unknown_skill` and blocked as a framework change request — it must never be accepted as a valid runtime value. There is no `unknown_skill` sentinel that makes an unrecognized skill valid; the sentinel is a diagnostic signal, not a controlled vocabulary entry.

### 5.4 Capability-to-ontology map — not yet created

**Truth state:** No adopted/canonical mapping exists from all 180 capabilities to the 8 ontological concepts defined in §1. A separate review-only inventory records provisional status labels, but it is not an adopted ontology map. The capability lifecycle registry (`artifacts/operations/capability-lifecycle-registry.yaml`) assigns each capability a family, phase, and pack, but it does not map capabilities to ontology concepts (Skill, Knowledge, TaskType, Practice, Content, Assessment, Evidence, Mastery).

**What this proposal contributes:** The P0 Writing loop vertical slice (§4) maps 6 ACTIVE capability families (IDENTITY.Core, PLACEMENT.Diagnosis, STUDY.DailyAction, WRITING.Evaluation, REVIEW.ErrorToReview, OPS.QualityEconomics) across all 8 ontology layers. This demonstrates the mapping method: trace a vertical slice through every ontology layer, identify which capabilities produce or consume each layer's entities, and record gaps.

**Proposed method for completing the map (post-code, P1+):**
1. For each of the 180 capabilities, determine which ontology concept it primarily operates on.
2. Record whether the capability `produces`, `consumes`, or `references` each of the 8 concept entities.
3. For each capability-ontology intersection, verify that controlled vocabulary exists (framework) and that entity contracts exist (artifacts).
4. Flag intersections where the capability references an ontology entity but no contract defines it → `unknown_*` gap.
5. Publish the completed map as a projection artifact derived from the capability registry + this proposal's ontology.

**Explicit non-claim:** This proposal does NOT contain an adopted/canonical completed 180-capability map. A separate draft inventory exists but remains review-only. This proposal defines the 8 ontological concepts and demonstrates the mapping method for the P0 Writing loop. The full map is a distinct deliverable that depends on this proposal's adoption and requires per-family contract review. The method is proposed; adoption and canonical semantic mapping are not done.

## 6. Implementation phasing

| Phase | What | Depends on |
|---|---|---|
| P0 (current) | Skill, Knowledge, TaskType, Practice, Content (partial), Assessment layers for Writing only. Evidence as per-entity events in entity-specific schemas. No Mastery. No unified evidence contract. | Nothing new — current contract-defined scope. |
| P0+ (proposed, no runtime code) | Adopt this ontology as a non-protected design contract. Reference ontology concepts from existing runtime specs. | Founder review + approval of this proposal. |
| P1 | Adopt `EVIDENCE.LearningRecord` fact-union contract. Implement `MASTERY.SkillEstimate` for Writing skill only (rule-based aggregation of EvaluationFact, RetestFact, ReviewRatingFact, ErrorResolutionFact). | P0 writing evaluation producing real EvaluationFacts (requires gold corpus, benchmark — post-code gates). |
| P1+ | Extend Evidence and Mastery to Reading, Listening as those skill families activate. | Reading/Listening practice families promoted from PLANNED. |
| P2 | Extend to Speaking, Pronunciation. Full cross-skill Mastery. PERSONAL.Insights consuming unified Evidence facts. | Speaking/Pronunciation families promoted. |

## References

- `blueprint/03-features.md` — canonical capability catalog
- `blueprint/05-content.md` — knowledge taxonomy
- `blueprint/framework/` — IELTS Knowledge Framework v1.0.6
- `artifacts/engineering/contracts/writing-task-2/openapi.yaml` — P0 writing evaluation contract
- `artifacts/engineering/contracts/runtime/lifecycle-contract.md` — entity state machines
- `artifacts/engineering/contracts/learning-measurement-traceability-proposal.md` v0.1.9 — sibling proposal (ExamConstruct/LearningCompetency/ObservableIndicator, MetricType union, traceability chain, coverage matrix)
- `artifacts/operations/capability-lifecycle-registry.yaml` — 180 capability lifecycle
