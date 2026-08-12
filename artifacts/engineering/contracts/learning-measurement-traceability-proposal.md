# Learning Measurement Traceability — Proposal

- **Type:** measurement-proposal — non-protected document. Does not edit Blueprint or registries.
- **Status:** `review` — founder review required before adoption.
- **Created:** 2026-08-11
- **Version:** 0.1.9 (patch: displayed lifecycle status and current sibling-reference reconciliation; see changelog)
- **Owner:** document-convergence orchestrator (proposal author)
- **Derived from:** `learning-ontology-proposal.md` v0.3.9, `blueprint/framework/` v1.0.6, `openapi.yaml` v0.5.0, `lifecycle-contract.md`
- **Consumed by:** product, engineering, validators
- **Changelog:**
  - v0.1.9 — document-convergence correction: synchronized displayed lifecycle status with canonical sibling metadata and live ontology/self references; no measurement semantics, controlled vocabulary, readiness state, or evidence state changed
  - v0.1.8 — document-convergence reconciliation: synchronized current sibling references to ontology v0.3.8 and the current traceability example to v0.1.8; no measurement semantics or evidence state changed
  - v0.1.0 — initial proposal: ExamConstruct / LearningCompetency / ObservableIndicator; traceability chain; evidence-to-competency invariant; MetricType union; closed-loop coverage matrix; graph projection schema; design-vs-empirical boundary
  - v0.1.1 — red-team: P0 implicit/proposed edges downgraded to `proposed`; produces cardinality split; `spec_candidate` replaced with `proposed`; EC_*/LC_*/IELTS.Writing.* reclassified as illustrative proposed labels; unverified source-version claims replaced with provenance-required; TraceabilityEdge projection schema added
  - v0.1.2 — red-team: §1.1 ExamConstruct IDs reclassified as illustrative proposed labels with external-IELTS authority; `provenance-blocked` added to coverage-status legend; generic `derives` replaced with typed causal relations; LearningTarget→attempted_as→AttemptFact (0:N); all JSON nodes proposed, source nodes added, endpoint-resolution invariant; TraceabilityEdge identity extended with scope_ref; stale ontology v0.3.1→v0.3.2
  - v0.1.3 — red-team: relation direction reconciled across §2.1/§2.2/§5.2/DOT/JSON to fact-reference convention (EvaluationFact→evaluates_attempt→AttemptFact, RetestFact→retests_error→LearningError, ErrorResolutionFact→resolves_error→LearningError, ReviewRatingFact→rates_card→ReviewCard, LearnerModel→evidenced_by→EvidenceFact); TraceabilityEdge.status enum aligned to coverage legend (proposed-blocked→provenance-blocked); edge_id normalized with owner_ref+contract_version and normalization rule defined; Pronunciation source→construct corrected to provenance-blocked with framework P_* as independent internal_representation_of relation; present-tense generator claims replaced with future/conditional wording
  - v0.1.4 — red-team: §2.2 evidenced_by cardinality corrected to 1:N per (learner_ref, competency_ref, model_version) projection with global N:M; §5.3 Fact→Model heading renamed to Model→EvidenceFact; ENT_ERROR/ENT_CARD clarified as canonical lifecycle entity types owned by lifecycle-contract.md with proposed status applying only to graph projection mapping; §7.2 external IELTS provenance reclassified from P0 prerequisite to proposal-adoption/quality-governance prerequisite
  - v0.1.5 — document-convergence reconciliation: synchronized current references to the sibling ontology proposal v0.3.5 and the current traceability example version; no measurement semantics, controlled vocabulary, readiness state, or evidence claim changed
  - v0.1.6 — document-convergence red-team: changed unqualified “IELTS officially measures” wording to a proposed/internal representation with explicitly provenance-blocked external authority; no measurement semantics, controlled vocabulary, readiness state, or evidence claim changed
  - v0.1.7 — document-convergence reconciliation: synchronized all live sibling references to ontology v0.3.7 and the current traceability example to v0.1.7; historical changelog references retained; no measurement semantics or evidence state changed

## Purpose

Define the **measurement traceability model** that connects proposed IELTS-related constructs to observable learner indicators, through to evidence facts, learner model updates, and interventions. This proposal is a sibling to the Learning Ontology Foundation (`learning-ontology-proposal.md` v0.3.9) and depends on its 8 ontological concepts and CompetencyRef union.

**Explicit non-claim:** This proposal defines design contracts for measurement traceability. It does NOT assert empirical validity, calibration evidence, benchmark results, or runtime readiness. Every `band` or `performance` field in this document is a design placeholder until real calibration evidence exists.

## 1. Three-tier measurement model

### 1.1 ExamConstruct

**Definition:** A proposed LenBands representation of an examination dimension that may correspond to an IELTS construct and band score. It is not an official IELTS definition until the required external source provenance is recorded.

**Authority:**
- **External normative source (required; currently provenance-blocked):** A named, versioned, dated official IELTS source would define what each construct measures and how it is scored. The external source is the authority; LenBands does not reinterpret it. The current proposal does not treat a generic public URL as a completed source record.
- **Internal governed representation:** `blueprint/framework/` v1.0.6 is the LenBands internal governed reference that records which IELTS constructs the system recognizes. It is a representation, not the source of truth.
- **No LenBands-invented constructs:** LenBands does not invent, extend, or reinterpret IELTS constructs. Every recognized construct must trace to a named, versioned external IELTS source.

**Illustrative proposed constructs (all labels are proposed, not canonical IDs):**

All identifiers below (`IELTS.Writing.*`, `IELTS.Speaking.*`, `IELTS.Listening`, `IELTS.Reading`) are illustrative proposed labels. They are not registered in any LenBands capability registry, framework enum, or OpenAPI schema. Canonical construct identifiers would be assigned only after proposal adoption, external-source provenance is recorded, and per-family contract alignment.

| Proposed label | External IELTS source | Band scale | LenBands P0 scope |
|---|---|---|---|
| `IELTS.Writing.TaskResponse` | Writing Task 2 band descriptors (public, provenance-required) | 0–9 (0.5) | P0 (EVAL.Writing) |
| `IELTS.Writing.CoherenceCohesion` | Writing Task 2 band descriptors (public, provenance-required) | 0–9 (0.5) | P0 (EVAL.Writing) |
| `IELTS.Writing.LexicalResource` | Writing Task 2 band descriptors (public, provenance-required) | 0–9 (0.5) | P0 (EVAL.Writing) |
| `IELTS.Writing.Grammar` | Writing Task 2 band descriptors (public, provenance-required) | 0–9 (0.5) | P0 (EVAL.Writing) |
| `IELTS.Speaking.FluencyCoherence` | Speaking band descriptors (public, provenance-required) | 0–9 (0.5) | Deferred |
| `IELTS.Speaking.LexicalResource` | Speaking band descriptors (public, provenance-required) | 0–9 (0.5) | Deferred |
| `IELTS.Speaking.Grammar` | Speaking band descriptors (public, provenance-required) | 0–9 (0.5) | Deferred |
| `IELTS.Speaking.Pronunciation` | Speaking band descriptors (public, provenance-required) | 0–9 (0.5) | Deferred |
| `IELTS.Listening` | Listening raw→band conversion table (public, provenance-required) | 0–9 (0.5) | Deferred |
| `IELTS.Reading` | Reading raw→band conversion table (public, provenance-required) | 0–9 (0.5) | Deferred |

**Ownership boundary:** The external IELTS source owns the construct definition. The LenBands framework is an internal governed representation/reference. LenBands evaluators MUST trace their scoring rubrics to the external source, not only to the internal framework copy.

**Relation:** external IELTS `source` → `supports` → ExamConstruct (internal representation)

### 1.2 LearningCompetency

**Definition:** A LenBands-internal, observable, practice-oriented decomposition of an ExamConstruct into learnable units. LearningCompetencies are what the system tracks and attempts to improve — they are narrower and more actionable than ExamConstructs.

**Owner:** This proposal (design contract). Operational ownership: `blueprint/03-features.md` (PRACTICE.*, LEARN.*, REVIEW.*)

**Canonical subtypes (mirroring CompetencyRef from learning-ontology-proposal.md v0.3.9):**

| Competency type | CompetencyRef variant | Example | Calibration requirement |
|---|---|---|---|
| Task-type competency | `TaskTypeRef` | Can write an Opinion essay (W_task2_opinion) with clear position | Task-type-specific rubric alignment |
| Practice-unit competency | `PracticeUnitRef` | Can produce the /θ/ phoneme accurately in isolation | Feature-threshold calibration |
| Grammar-point competency | `GrammarPointRef` | Can form and use second conditional (g_second_conditional) | Accuracy threshold per grammar point |
| Criterion competency | `CriterionRef` | Task Response at band 6.0+ | Rubric-aligned band estimation |
| Skill-level competency | `SkillLevelRef` | Overall Writing capability | Aggregate of criterion + task-type evidence |

**Ownership boundary:** LearningCompetencies are LenBands design constructs, NOT IELTS exam constructs. They decompose IELTS constructs into actionable learning targets but do not claim IELTS equivalence unless validated against a calibrated rubric. A `LearningCompetency` is `operationalized_as` a measurable target; it is not itself a score.

**Invariant:** Every `LearningCompetency` MUST trace to at least one `ExamConstruct` via `operationalized_as`. A competency with no construct trace is a design gap, not a valid measurement target.

**Relation:** `ExamConstruct` → `operationalized_as` → LearningCompetency

### 1.3 ObservableIndicator

**Definition:** A concrete, measurable signal produced by a learner action that provides evidence about a LearningCompetency. ObservableIndicators are what the system actually measures — they are the bridge between learner behavior and competency estimates.

**Owner:** This proposal (design contract). Operational ownership: per-evaluator canonical owner (Writing: `openapi.yaml` v0.5.0; Speaking/Pronunciation: deferred).

**Canonical subtypes:**

| Indicator type | Produced by | Example | Evidence fact type |
|---|---|---|---|
| Criterion score | EVAL.* evaluator | `CriterionResult.band_estimate` for Task Response = 6.0 | `EvaluationFact` |
| Feature measurement | EVAL.Pronunciation | Phoneme accuracy = 0.87 | `EvaluationFact` (pronunciation) |
| Answer correctness | L/R answer key | `R_multiple_choice` item correct | `AttemptFact` + answer key |
| Error resolution | Learner fix action | `LearningError` status → resolved | `ErrorResolutionFact` |
| FSRS retrieval | Review card rating | Rating = "good" on grammar card | `ReviewRatingFact` |
| Retest outcome | Retest evaluation | Retest improved on same error pattern | `RetestFact` |

**Ownership boundary:** ObservableIndicators are produced by evaluators, practice engines, and review systems. The indicator definition belongs to the producer's canonical owner contract. This proposal defines the indicator *type* and its traceability path; the producer defines the indicator *schema* and *threshold*.

Every `ObservableIndicator` MUST declare:
- `produced_by`: capability ID or evaluator family
- `indicates`: LearningCompetency reference(s)
- `metric_type`: MetricType (see §4)
- `calibration_status`: `provisional` | `calibrated` | `evidence_blocked`

**Relation:** `LearningCompetency` → `observed_by` → ObservableIndicator

## 2. Traceability chain

### 2.1 Full chain

**Convention: fact-reference direction.** Edges point FROM the fact that records an event TO the entity that was acted upon. The fact is the subject; the referenced entity is the object. For example, `EvaluationFact → evaluates_attempt → AttemptFact` means "the EvaluationFact evaluates the AttemptFact." No generic `derives` edge is retained.

```
external IELTS source (band descriptors, exam specification)
  └─ supports → ExamConstruct (internal governed representation)
       └─ operationalized_as → LearningCompetency
            └─ observed_by → ObservableIndicator
                 └─ elicited_by → LearningTarget (LearningTargetRef)
                      └─ attempted_as → AttemptFact (0:N over time per target)

// Downstream facts point to the entities they reference:
EvaluationFact ──evaluates_attempt──→ AttemptFact
RetestFact ──retests_error──→ LearningError (illustrative proposed entity)
ErrorResolutionFact ──resolves_error──→ LearningError
ReviewRatingFact ──rates_card──→ ReviewCard (illustrative proposed entity)

// LearnerModel is evidenced by all fact types:
LearnerModel projection ──evidenced_by──→ EvidenceFact (any type)

// Intervention loop:
LearnerModel ──triggers──→ Intervention (COACH.* | REVIEW.* | PRACTICE.*)
Intervention outcome ──reassessed_by──→ LearningTarget (next cycle)
```

**Instance/event rule (not a graph edge):** A single learner action produces exactly one `AttemptFact` (1:1). This is a runtime invariant, not a static graph relation. The graph relation `attempted_as` is 0:N — one LearningTarget may be attempted zero or more times over the learner's history.

### 2.2 Relation contracts

Each relation in the chain is typed and versioned. Direction follows the fact-reference convention: edges point FROM the recording fact TO the referenced entity.

| Relation | From | To | Cardinality | Versioned by |
|---|---|---|---|---|
| `supports` | external IELTS source | ExamConstruct (internal representation) | 1:N | Source retrieval metadata (URL, date, version) |
| `internal_representation_of` | LenBands framework | ExamConstruct | 1:N | Framework version |
| `operationalized_as` | ExamConstruct | LearningCompetency | 1:N | Competency design version |
| `observed_by` | LearningCompetency | ObservableIndicator | 1:N | Indicator contract version |
| `elicited_by` | ObservableIndicator | LearningTarget | N:M | Task/asset version |
| `attempted_as` | LearningTarget | AttemptFact | 0:N (over time; 1:1 per learner-action instance) | Fact schema version |
| `evaluates_attempt` | EvaluationFact | AttemptFact | 0:N per attempt | Evaluator contract version |
| `retests_error` | RetestFact | LearningError | 0:N per error | Retest config version |
| `resolves_error` | ErrorResolutionFact | LearningError | 0:N per error | Error lifecycle version |
| `rates_card` | ReviewRatingFact | ReviewCard | 0:N per card | FSRS algorithm version |
| `evidenced_by` | LearnerModel projection | EvidenceFact (any type) | 1:N per (learner_ref, competency_ref, model_version) projection; global N:M (one immutable fact can contribute to multiple scoped projections) | Model version |
| `triggers` | LearnerModel state | Intervention | 1:N | Intervention rule version |
| `reassessed_by` | Intervention outcome | LearningTarget | 1:N | Retest/practice config version |

**Note:** `LearningError` and `ReviewCard` are defined in `lifecycle-contract.md` (REVIEW.ErrorToReview family). They appear as referenced entities in the graph, not as EvidenceFacts. Nodes for them in §6 are illustrative proposed labels.

### 2.3 Source-to-construct traceability (mandatory)

Every `ExamConstruct` MUST trace to a **named, versioned, provenance-recorded external source**:

| Construct | External source | Provenance | Public? |
|---|---|---|---|
| IELTS Writing criteria (4) | IELTS Writing Task 2 band descriptors | external-source-reference-pending (provenance-required: URL, retrieval date, version identifier not yet recorded) | Yes |
| IELTS Speaking criteria (4) | IELTS Speaking band descriptors | external-source-reference-pending (provenance-required) | Yes |
| IELTS Listening raw→band | IELTS Listening raw score conversion table | external-source-reference-pending (provenance-required) | Yes |
| IELTS Reading raw→band | IELTS Reading raw score conversion table | external-source-reference-pending (provenance-required) | Yes |
| Pronunciation features (5) | IELTS Speaking Pronunciation band descriptors (public, provenance-required) | external-source-reference-pending (provenance-required) | Yes |

**Pronunciation note:** The LenBands framework `skill-questiontype-band.md` v1.0.6 defines P_* practice units as an internal governed representation. This is an `internal_representation_of` relation, independent of external source provenance. Framework P_* being versioned does not make the external IELTS Speaking Pronunciation source `defined` — the external source remains `provenance-blocked` until its own provenance record exists.

No construct may be defined without a source reference. "General IELTS knowledge" is not a valid source.

## 3. Evidence-to-competency invariant

### 3.1 Invariant statement

**Every EvidenceFact that affects a LearnerModel mastery estimate MUST carry at least one explicit `CompetencyRef` OR have exactly one deterministic canonical derivation path from its `learning_target` and `skill` fields.**

No mastery-affecting computation may rely on prose inference, heuristic tag matching, or undocumented mapping. The path from fact to competency must be mechanically verifiable.

### 3.2 Derivation paths (canonical)

| EvidenceFact type | Explicit CompetencyRef? | Derivation path if not explicit |
|---|---|---|
| `AttemptFact` | No (attempts don't score) | N/A — attempts alone do not affect mastery |
| `EvaluationFact` | Criterion → `CriterionRef`; overall → `SkillLevelRef` | `skill` + `learning_target.TaskTypeRef` → `TaskTypeRef` |
| `RetestFact` | Source error's `error_pattern` → grammar/micro_skill | `source_error_ref` → `LearningError` → `error_pattern` → framework taxonomy |
| `ReviewRatingFact` | Source error's competency | `source_error_ref` → `LearningError` → `microskill_ref[]` |
| `ErrorResolutionFact` | Source error's competency | Same as ReviewRatingFact |
| `PlacementFact` (band_estimation) | `SkillLevelRef` for estimated skill | N/A — explicit |

### 3.3 Ambiguity rejection

If an EvidenceFact could map to more than one CompetencyRef and no deterministic rule selects one:
- The fact is flagged `ambiguous_competency` in the LearnerModel update
- It contributes to **no** CompetencyRef estimate until the ambiguity is resolved by a contract update
- The ambiguity is reported as a design gap

This is a fail-closed rule. Silent disambiguation is forbidden.

### 3.4 No-evidence sentinel

A `CompetencyRef` with zero associated EvidenceFacts has the state `no_evidence`, not band 0.0. This is distinct from:
- `low_confidence`: has evidence but below confidence threshold
- `insufficient_evidence`: has evidence but not enough to estimate
- `stale`: had evidence but recency expired

## 4. MetricType union

### 4.1 Definition

Not every CompetencyRef produces an IELTS band score. The `MetricType` union prevents the category error of representing all measurements as band 0–9:

```
MetricType = IELTSBandEstimate | PerformanceEstimate | KnowledgeMasteryEstimate | FeaturePerformanceEstimate
```

### 4.2 MetricType contracts

#### IELTSBandEstimate

```
IELTSBandEstimate {
  metric_type: "ielts_band_estimate"
  band: 0.0 – 9.0 (0.5 steps)
  confidence: 0.0 – 1.0
  // REQUIRES: the construct is an IELTS band-aligned ExamConstruct
  //   with a validated rubric traceable to public band descriptors.
  // VALID FOR: CriterionRef (Writing criteria), SkillLevelRef (overall Writing band)
  // INVALID FOR: PracticeUnitRef (pronunciation is not an IELTS band),
  //   GrammarPointRef (grammar points don't have band scores),
  //   TaskTypeRef (task types don't have band scores — they elicit band-scored criteria)
  // CALIBRATION GATE: must have gold-corpus benchmark evidence before
  //   any IELTSBandEstimate is presented to a learner as a band claim.
}
```

#### PerformanceEstimate

```
PerformanceEstimate {
  metric_type: "performance_estimate"
  value: 0.0 – 1.0 (normalized)
  confidence: 0.0 – 1.0
  // VALID FOR: TaskTypeRef, PracticeUnitRef, SkillLevelRef (non-band aggregate)
  // NOT a band score. Never convert to band without a validated conversion table.
}
```

#### KnowledgeMasteryEstimate

```
KnowledgeMasteryEstimate {
  metric_type: "knowledge_mastery_estimate"
  recall_accuracy: 0.0 – 1.0
  usage_accuracy: 0.0 – 1.0 (in context, via writing/speaking evaluation)
  transfer_accuracy: 0.0 – 1.0 | null (in new contexts, deferred)
  fsrs_stability: 0.0 – 1.0 | null (from FSRS algorithm)
  confidence: 0.0 – 1.0
  // VALID FOR: GrammarPointRef
  // FUTURE: VocabularyRef, CollocationRef (when controlled IDs exist — P1 gap)
}
```

#### FeaturePerformanceEstimate

```
FeaturePerformanceEstimate {
  metric_type: "feature_performance_estimate"
  feature_scores: map of feature_id → 0.0–1.0
  // Feature IDs are the 5 P_* pronunciation units from skill-questiontype-band.md v1.0.6
  confidence: 0.0 – 1.0
  // VALID FOR: PracticeUnitRef (individual P_* unit accuracy)
}
```

### 4.3 MetricType ↔ CompetencyRef mapping (mandatory)

| CompetencyRef variant | Default MetricType | Alternative MetricType | Band 0–9 valid? |
|---|---|---|---|
| `CriterionRef` (Writing) | `IELTSBandEstimate` | — | Yes (rubric-aligned) |
| `CriterionRef` (Speaking, deferred) | `IELTSBandEstimate` | — | Yes (after Speaking calibration) |
| `SkillLevelRef` (Writing) | `IELTSBandEstimate` | `PerformanceEstimate` (aggregate) | Yes (overall band) |
| `SkillLevelRef` (other skills) | `PerformanceEstimate` | — | Only after per-skill calibration |
| `TaskTypeRef` | `PerformanceEstimate` | — | **No** |
| `PracticeUnitRef` | `FeaturePerformanceEstimate` | `PerformanceEstimate` | **No** |
| `GrammarPointRef` | `KnowledgeMasteryEstimate` | — | **No** |

### 4.4 The generic `Mastery.band` field is invalid

The Mastery entity in `learning-ontology-proposal.md` v0.3.9 §2.1 defines `band: 0.0 – 9.0 (0.5 steps)` as a universal field. This is a design defect: not every CompetencyRef maps to an IELTS band. The `band` field must be replaced with `metric: MetricType`, which discriminates the correct value type per CompetencyRef variant.

Until MetricType is adopted, every use of `Mastery.band` for a non-band-aligned CompetencyRef MUST be treated as a design error. The ontology proposal's Mastery entity is marked as needing this correction (see §9 Minimal ontology patch).

## 5. Closed-loop coverage matrix

### 5.1 Status legend

| Status | Meaning |
|---|---|
| `defined` | Contract exists for this cell (spec, schema, or owner contract) with provenance recorded |
| `proposed` | Defined in this proposal or learning-ontology-proposal.md; not yet adopted |
| `provenance-blocked` | External source is known to exist but source record lacks URL, retrieval date, version identifier, and rights/provenance; cannot be treated as `defined` |
| `missing` | No contract exists; design gap |
| `evidence-blocked` | Contract defined but post-code evidence required (gold corpus, benchmark, calibration) |

### 5.2 P0 Writing — closed loop

| Traceability link | Status | Owner contract | Gaps |
|---|---|---|---|
| external source → ExamConstruct (Writing 4 criteria) | `provenance-blocked` | IELTS public band descriptors | Public descriptor version not pinned; external-source-reference-pending. |
| ExamConstruct → LearningCompetency (4 criteria) | `proposed` | This proposal §1.2 | Criterion-to-competency decomposition is implicit in rubric alignment; no explicit mapping contract exists. |
| LearningCompetency → ObservableIndicator | `proposed` | This proposal §1.3 | `openapi.yaml` defines CriterionResult; it does not declare itself as an ObservableIndicator for a LearningCompetency. |
| ObservableIndicator → LearningTarget | `proposed` | This proposal §2.1 chain | No contract explicitly links a CriterionResult to the LearningTarget that produced the submission. |
| LearningTarget → AttemptFact (`attempted_as`) | `proposed` | `learning-ontology-proposal.md` v0.3.9 §3 (AttemptFact) | 0:N over time per target. Instance rule: 1 learner action = 1 AttemptFact. |
| EvaluationFact → AttemptFact (`evaluates_attempt`) | `proposed` | This proposal §2.2 | EvaluationFact records the evaluation of an attempt. |
| RetestFact → LearningError (`retests_error`) | `proposed` | This proposal §2.2 | RetestFact records the retest of a learning error. |
| ErrorResolutionFact → LearningError (`resolves_error`) | `proposed` | This proposal §2.2 | ErrorResolutionFact records resolution of a learning error. |
| ReviewRatingFact → ReviewCard (`rates_card`) | `proposed` | This proposal §2.2 | ReviewRatingFact records a rating on a review card. |
| LearnerModel → EvidenceFact (`evidenced_by`) | `proposed` | `learning-ontology-proposal.md` v0.3.9 §2 (Mastery) | Mastery domain not defined in capability registry. |
| LearnerModel → Intervention (`triggers`) | `missing` | — | No contract defines intervention triggers from Mastery state. |
| Intervention → reassessment (`reassessed_by`) | `proposed` | `lifecycle-contract.md` (RetestAttempt, ReviewCard) | Retest loop exists but does not reference Mastery state. |

### 5.3 Deferred skills — coverage status

| Skill | source→Construct | Construct→Competency | Competency→Indicator | Indicator→Target | Target→AttemptFact | Model→EvidenceFact | Model→Intervention | reassessment |
|---|---|---|---|---|---|---|---|---|
| Listening | `provenance-blocked` (IELTS public) | `missing` | `missing` | `proposed` | `proposed` | `proposed` | `missing` | `missing` |
| Reading | `provenance-blocked` (IELTS public) | `missing` | `missing` | `proposed` | `proposed` | `proposed` | `missing` | `missing` |
| Speaking | `provenance-blocked` (IELTS public) | `missing` | `missing` | `proposed` | `proposed` | `proposed` | `missing` | `missing` |
| Pronunciation | `provenance-blocked` (IELTS public; framework P_* v1.0.6 is internal_representation_of, independent relation) | `proposed` | `proposed` | `proposed` | `proposed` | `proposed` | `missing` | `missing` |

All deferred skills share the same gap pattern: external IELTS sources exist but lack provenance records; LearningCompetency decomposition, ObservableIndicator contracts, LearnerModel→Intervention triggers, and reassessment rules are all missing or proposed only. Framework P_* units being versioned does not make the external IELTS Speaking Pronunciation source `defined` — `internal_representation_of` is an independent relation. These gaps are expected at the current document-convergence phase and do not block P0.

### 5.4 Evidence-blocked cells (post-code)

Every cell marked `evidence-blocked` requires runtime evidence that cannot exist while source is locked:

| Cell | What's blocked | Required evidence |
|---|---|---|
| P0: LearnerModel → EvidenceFact | Mastery computation algorithm | Gold corpus + benchmark run + numeric threshold policy |
| P0: LearnerModel → Intervention | Intervention trigger rules | Mastery estimate stability + false-positive rate measurement |
| All deferred: any cell | Complete contracts for non-Writing skills | Per-skill evaluator contracts + calibration evidence |

## 6. Graph projection schema

### 6.1 Principle

**Git contracts are the SSOT.** This section defines a JSON/DOT-ready projection schema for visualization and traceability verification. No graph database (Neo4j, etc.) is created, required, or proposed. No generator exists yet; this document defines only a proposed projection schema.

If and when a generator is built, the projection would be regenerated by a deterministic script that reads the canonical Git contracts. The projection would never be hand-edited. If a generated projection were to disagree with a Git contract, the Git contract would win.

### 6.2 Node types (DOT-ready)

**All node identifiers below are illustrative proposed labels, not canonical IDs.** They are not registered in any LenBands capability registry, framework enum, or OpenAPI schema. Canonical IDs would be assigned only after proposal adoption and per-family contract alignment.

Edges follow the fact-reference convention (§2.1): fact nodes point TO the entities they reference.

```
digraph MeasurementTraceability {
  // Source nodes
  SOURCE_IELTS [label="External IELTS Source\n(band descriptors, provenance-required)", shape=box, style=filled, fillcolor=lightgray];
  FRAMEWORK [label="LenBands Framework\n(internal governed representation, v1.0.6)", shape=box, style=filled, fillcolor=lightgray];

  // ExamConstruct nodes (illustrative proposed labels)
  EC_W_TR [label="ExamConstruct\nIELTS.Writing.TaskResponse (proposed)", shape=ellipse];
  EC_W_CC [label="ExamConstruct\nIELTS.Writing.CoherenceCohesion (proposed)", shape=ellipse];
  EC_W_LR [label="ExamConstruct\nIELTS.Writing.LexicalResource (proposed)", shape=ellipse];
  EC_W_GR [label="ExamConstruct\nIELTS.Writing.Grammar (proposed)", shape=ellipse];

  // LearningCompetency nodes (illustrative proposed labels)
  LC_W_TR [label="LearningCompetency\nTask Response at band 6.0+ (proposed)", shape=component];
  LC_W_CC [label="LearningCompetency\nCoherence & Cohesion at band 6.0+ (proposed)", shape=component];
  LC_W_OPINION [label="LearningCompetency\nOpinion essay (proposed)", shape=component];
  LC_G_COND [label="LearningCompetency\nSecond conditional (proposed)", shape=component];

  // ObservableIndicator nodes (illustrative proposed labels)
  OI_CRITERION [label="ObservableIndicator\nCriterionResult.band_estimate (proposed)", shape=hexagon];
  OI_FINDING [label="ObservableIndicator\nFeedbackFinding.error_pattern (proposed)", shape=hexagon];

  // LearningTarget nodes (illustrative proposed labels)
  LT_OPINION [label="LearningTarget\nTaskTypeRef(W_task2_opinion) (proposed)", shape=cds];

  // EvidenceFact nodes (illustrative proposed labels)
  EF_ATTEMPT [label="EvidenceFact\nAttemptFact (proposed)", shape=record];
  EF_EVAL [label="EvidenceFact\nEvaluationFact (proposed)", shape=record];
  EF_RETEST [label="EvidenceFact\nRetestFact (proposed)", shape=record];
  EF_ERROR [label="EvidenceFact\nErrorResolutionFact (proposed)", shape=record];
  EF_RATING [label="EvidenceFact\nReviewRatingFact (proposed)", shape=record];

  // Referenced entities — NOT EvidenceFacts. LearningError and ReviewCard are canonical
  // lifecycle entity types owned by lifecycle-contract.md (REVIEW.ErrorToReview family).
  // "proposed" applies only to this graph projection mapping, never to the entities themselves.
  ENT_ERROR [label="Referenced Entity\nLearningError\n(owner: lifecycle-contract.md)", shape=box, style=dashed];
  ENT_CARD [label="Referenced Entity\nReviewCard\n(owner: lifecycle-contract.md)", shape=box, style=dashed];

  // LearnerModel node (illustrative proposed label)
  LM_WRITING [label="LearnerModel\nMastery(SkillLevelRef, writing) (proposed)", shape=folder];

  // Intervention nodes (illustrative proposed labels)
  INT_COACH [label="Intervention\nCOACH.ErrorAnalysis (proposed)", shape=invhouse];
  INT_REVIEW [label="Intervention\nREVIEW.FSRS (proposed)", shape=invhouse];

  // Edges — fact-reference convention: facts point TO referenced entities
  SOURCE_IELTS -> EC_W_TR [label="supports"];
  FRAMEWORK -> EC_W_TR [label="internal_representation_of"];
  EC_W_TR -> LC_W_TR [label="operationalized_as"];
  EC_W_TR -> LC_W_OPINION [label="operationalized_as"];
  LC_W_TR -> OI_CRITERION [label="observed_by"];
  LC_W_OPINION -> OI_FINDING [label="observed_by"];
  OI_CRITERION -> LT_OPINION [label="elicited_by"];
  LT_OPINION -> EF_ATTEMPT [label="attempted_as (0:N)"];

  // Fact-reference edges: facts → entities
  EF_EVAL -> EF_ATTEMPT [label="evaluates_attempt"];
  EF_RETEST -> ENT_ERROR [label="retests_error"];
  EF_ERROR -> ENT_ERROR [label="resolves_error"];
  EF_RATING -> ENT_CARD [label="rates_card"];

  // LearnerModel is evidenced by all fact types
  LM_WRITING -> EF_ATTEMPT [label="evidenced_by"];
  LM_WRITING -> EF_EVAL [label="evidenced_by"];
  LM_WRITING -> EF_RETEST [label="evidenced_by"];
  LM_WRITING -> EF_ERROR [label="evidenced_by"];
  LM_WRITING -> EF_RATING [label="evidenced_by"];

  // Intervention loop
  LM_WRITING -> INT_COACH [label="triggers"];
  LM_WRITING -> INT_REVIEW [label="triggers"];
  INT_REVIEW -> LT_OPINION [label="reassessed_by"];
}
```

### 6.3 JSON projection schema

```yaml
# Proposed illustrative traceability graph schema.
# All node ids and labels are illustrative proposed labels (§6.2 caveat).
# No generator exists yet; this is a projection schema declaration only.
# If a generator were built, it would produce instances of this schema.
measurement_traceability_graph:
  version: "0.1.5"
  proposed_schema_from:
    - learning-ontology-proposal.md (v0.3.9)
    - learning-measurement-traceability-proposal.md (v0.1.9)
    - openapi.yaml (v0.5.0)
    - lifecycle-contract.md
    - blueprint/framework/ (v1.0.6)
  nodes:
    # Source nodes
    - id: SOURCE_IELTS
      type: ExternalSource
      label: "IELTS Writing Task 2 Band Descriptors (public)"
      provenance: provenance-blocked
      status: proposed
    - id: FRAMEWORK
      type: InternalRepresentation
      label: "LenBands Framework v1.0.6"
      status: proposed
    # ExamConstruct nodes
    - id: EC_W_TR
      type: ExamConstruct
      label: "IELTS.Writing.TaskResponse"
      external_source_ref: SOURCE_IELTS
      internal_representation_ref: FRAMEWORK
      status: proposed
    - id: EC_W_CC
      type: ExamConstruct
      label: "IELTS.Writing.CoherenceCohesion"
      external_source_ref: SOURCE_IELTS
      internal_representation_ref: FRAMEWORK
      status: proposed
    # LearningCompetency nodes
    - id: LC_W_TR
      type: LearningCompetency
      label: "Task Response at band 6.0+"
      competency_ref: {ref_type: criterion, criterion: task_response, skill: writing}
      status: proposed
    - id: LC_W_OPINION
      type: LearningCompetency
      label: "Opinion essay (W_task2_opinion)"
      competency_ref: {ref_type: task_type, task_type_id: W_task2_opinion, skill: writing}
      status: proposed
    # ObservableIndicator nodes
    - id: OI_CRITERION
      type: ObservableIndicator
      label: "CriterionResult.band_estimate"
      produced_by: EVAL.Writing
      metric_type: IELTSBandEstimate
      calibration_status: evidence_blocked
      status: proposed
    - id: OI_FINDING
      type: ObservableIndicator
      label: "FeedbackFinding.error_pattern"
      produced_by: EVAL.Writing
      metric_type: null
      calibration_status: provisional
      status: proposed
    # LearningTarget nodes
    - id: LT_OPINION
      type: LearningTarget
      label: "W_task2_opinion"
      learning_target_ref: {ref_type: task_type, task_type_id: W_task2_opinion, skill: writing}
      status: proposed
    # EvidenceFact nodes
    - id: EF_ATTEMPT
      type: EvidenceFact
      label: "AttemptFact"
      fact_type: attempt
      status: proposed
    - id: EF_EVAL
      type: EvidenceFact
      label: "EvaluationFact"
      fact_type: evaluation
      status: proposed
    - id: EF_RETEST
      type: EvidenceFact
      label: "RetestFact"
      fact_type: retest
      status: proposed
    - id: EF_ERROR
      type: EvidenceFact
      label: "ErrorResolutionFact"
      fact_type: error_resolution
      status: proposed
    - id: EF_RATING
      type: EvidenceFact
      label: "ReviewRatingFact"
      fact_type: review_rating
      status: proposed
    # Referenced entity nodes — NOT EvidenceFacts.
    # LearningError and ReviewCard are canonical lifecycle entity types owned by
    # lifecycle-contract.md (REVIEW.ErrorToReview family). "proposed" applies only
    # to this graph projection mapping, never to the entities themselves.
    - id: ENT_ERROR
      type: ReferencedEntity
      label: "LearningError"
      canonical_owner: "artifacts/engineering/contracts/runtime/lifecycle-contract.md"
      canonical_family: REVIEW.ErrorToReview
      status: proposed
    - id: ENT_CARD
      type: ReferencedEntity
      label: "ReviewCard"
      canonical_owner: "artifacts/engineering/contracts/runtime/lifecycle-contract.md"
      canonical_family: REVIEW.ErrorToReview
      status: proposed
    # LearnerModel node
    - id: LM_WRITING
      type: LearnerModel
      label: "Mastery(SkillLevelRef, writing)"
      metric_type: IELTSBandEstimate
      status: proposed
    # Intervention nodes
    - id: INT_COACH
      type: Intervention
      label: "COACH.ErrorAnalysis"
      status: proposed
    - id: INT_REVIEW
      type: Intervention
      label: "REVIEW.FSRS"
      status: proposed
  edges:
    - {from: SOURCE_IELTS, to: EC_W_TR, relation: supports, status: provenance-blocked}
    - {from: FRAMEWORK, to: EC_W_TR, relation: internal_representation_of, status: proposed}
    - {from: EC_W_TR, to: LC_W_TR, relation: operationalized_as, status: proposed}
    - {from: EC_W_TR, to: LC_W_OPINION, relation: operationalized_as, status: proposed}
    - {from: LC_W_TR, to: OI_CRITERION, relation: observed_by, status: proposed}
    - {from: LC_W_OPINION, to: OI_FINDING, relation: observed_by, status: proposed}
    - {from: OI_CRITERION, to: LT_OPINION, relation: elicited_by, status: proposed}
    - {from: LT_OPINION, to: EF_ATTEMPT, relation: attempted_as, status: proposed}
    # Fact-reference edges: facts → entities
    - {from: EF_EVAL, to: EF_ATTEMPT, relation: evaluates_attempt, status: proposed}
    - {from: EF_RETEST, to: ENT_ERROR, relation: retests_error, status: proposed}
    - {from: EF_ERROR, to: ENT_ERROR, relation: resolves_error, status: proposed}
    - {from: EF_RATING, to: ENT_CARD, relation: rates_card, status: proposed}
    # LearnerModel is evidenced by all fact types
    - {from: LM_WRITING, to: EF_ATTEMPT, relation: evidenced_by, status: proposed}
    - {from: LM_WRITING, to: EF_EVAL, relation: evidenced_by, status: proposed}
    - {from: LM_WRITING, to: EF_RETEST, relation: evidenced_by, status: proposed}
    - {from: LM_WRITING, to: EF_ERROR, relation: evidenced_by, status: proposed}
    - {from: LM_WRITING, to: EF_RATING, relation: evidenced_by, status: proposed}
    # Intervention loop
    - {from: LM_WRITING, to: INT_COACH, relation: triggers, status: missing}
    - {from: LM_WRITING, to: INT_REVIEW, relation: triggers, status: missing}
    - {from: INT_REVIEW, to: LT_OPINION, relation: reassessed_by, status: proposed}

# Endpoint resolution invariant: every edge's `from` and `to` MUST resolve to a node `id`
# in the nodes list. Edges with unresolvable endpoints are invalid projections.
```

### 6.4 TraceabilityEdge projection schema (proposed)

Every edge in the traceability graph would project to a `TraceabilityEdge` record if a generator were built. This schema is proposed only — no generator or graph database implements it.

```yaml
TraceabilityEdge:
  edge_id: string            # deterministic: sha256(scope_ref + ":" + owner_ref + ":" + contract_version + ":" + from_ref + ":" + relation + ":" + to_ref)
  scope_ref: string          # scope within which this edge is defined (e.g., "P0/Writing", "Deferred/Speaking")
  owner_ref: string          # canonical contract that defines this edge (repo-relative path, no version suffix, normalized)
  contract_version: string   # semver version of the owner contract at time of projection
  from_ref: string           # node identifier (illustrative proposed label; see §6.2 caveat)
  to_ref: string             # node identifier (illustrative proposed label; see §6.2 caveat)
  relation: enum             # supports | internal_representation_of | operationalized_as | observed_by | elicited_by | attempted_as | evaluates_attempt | retests_error | resolves_error | rates_card | evidenced_by | triggers | reassessed_by
  status: enum               # defined | proposed | provenance-blocked | missing | evidence-blocked
  evidence_ref: string | null  # immutable evidence record supporting this edge; null unless status=defined and evidenced
  regenerated_at: timestamp | null  # would be set at projection generation time; null while no generator exists
```

**`scope_ref` definition:** `scope_ref` identifies the product scope within which this edge is meaningful. Valid values are derived from the capability lifecycle registry's pack/phase structure (e.g., `P0/Writing`, `P1/Reading`, `P1/Listening`, `P2/Speaking`, `P2/Pronunciation`).

**`owner_ref` normalization (deterministic identity):** `owner_ref` is the repository-relative file path with no version suffix, using forward slashes, with no trailing slash. Examples:
- `artifacts/engineering/contracts/learning-measurement-traceability-proposal.md`
- `artifacts/engineering/contracts/writing-task-2/openapi.yaml`
- `artifacts/engineering/contracts/runtime/lifecycle-contract.md`

`contract_version` is the semver string from the owner contract at the time the edge was last reviewed (e.g., `0.1.3`, `0.5.0`, `1.0.6`). Normalization: strip leading `v` if present; use exactly `MAJOR.MINOR.PATCH` format.

**TraceabilityEdge invariants:**
- `edge_id` is deterministic: `sha256(scope_ref + ":" + owner_ref + ":" + contract_version + ":" + from_ref + ":" + relation + ":" + to_ref)` — same inputs always produce the same ID. Changing the owner contract version produces a new edge_id (the edge is re-versioned).
- `owner_ref` MUST resolve to a file path in the repository. Edges with unresolvable `owner_ref` are flagged `orphaned_owner`.
- `evidence_ref` is non-null only when `status = defined` AND the edge is backed by an immutable evidence record. All other states have `evidence_ref: null`.
- `regenerated_at` is null while no generator exists. It would be set at projection generation time.
- Every `from_ref` and `to_ref` MUST resolve to a node in the projection's nodes list. Unresolvable endpoints are invalid.

**Example (P0 Writing, proposed edge):**

```yaml
- edge_id: "a1b2c3..."  # sha256("P0/Writing:artifacts/engineering/contracts/learning-measurement-traceability-proposal.md:0.1.5:EC_W_TR:operationalized_as:LC_W_TR")
  scope_ref: "P0/Writing"
  owner_ref: "artifacts/engineering/contracts/learning-measurement-traceability-proposal.md"
  contract_version: "0.1.5"
  from_ref: "EC_W_TR"
  to_ref: "LC_W_TR"
  relation: operationalized_as
  status: proposed
  evidence_ref: null
  regenerated_at: null
```

**No runtime dependency:** The TraceabilityEdge schema is a design contract for how projections would be structured if a generator were built. It does not require a running system, a graph database, or a code generator. It is a schema declaration only.

## 7. Design contracts vs empirical validity

### 7.1 Boundary

| Layer | What it defines | What it does NOT define | Evidence required to advance |
|---|---|---|---|
| **Design contract** (this proposal, ontology proposal) | Entity types, relations, schemas, invariants, MetricType definitions | Band thresholds, confidence thresholds, calibration constants, algorithm weights | Founder review + adoption |
| **Empirical validity** | Whether an indicator actually measures the construct it claims to measure | — | Construct validity study (post-code) |
| **Calibration** | Numeric mapping from raw indicator values to MetricType values | — | Gold corpus + benchmark run (post-code) |
| **Runtime evidence** | Actual learner outcomes, effect sizes, intervention efficacy | — | Production data (post-launch) |

### 7.2 Explicit gaps (honest inventory)

| Gap | Classification | Resolution path |
|---|---|---|
| External IELTS source provenance records | Provenance gap | Record URL, retrieval date, version identifier, and rights confirmation for each external IELTS source. Classified as a proposal-adoption / quality-governance prerequisite, not a current P0 gate blocker. Would become a P0 requirement only if a protected founder decision explicitly adds it to `gate p0`. |
| Writing rubric-to-competency decomposition | Design gap | Explicit mapping from each criterion band level to observable competency statements (P1 design task) |
| CriterionRef → IELTSBandEstimate calibration | Evidence gap | Gold corpus of pre-scored essays + benchmark run (post-code) |
| TaskTypeRef → PerformanceEstimate threshold | Design + evidence gap | Define "successful completion" per task type; calibrate threshold from learner data (post-code) |
| GrammarPointRef → KnowledgeMasteryEstimate thresholds | Design gap | Define recall/usage/transfer accuracy thresholds per grammar point (P1 design task) |
| LearnerModel → Intervention trigger rules | Design gap | Define which Mastery state transitions trigger which interventions (P1 design task) |
| Pronunciation FeaturePerformanceEstimate → Speaking PR criterion mapping | Design + evidence gap | Map feature scores to IELTS Speaking Pronunciation criterion band levels (deferred; requires Speaking evaluator) |
| Vocabulary/Collocation identifier model | Framework gap | P1 framework change request (noted in learning-ontology-proposal.md v0.3.9 §2.1) |

All gaps are honestly reported. None are hidden behind prose claims of completeness.

## 8. Relationship to Learning Ontology proposal

This proposal is a sibling to `learning-ontology-proposal.md` v0.3.9:

- The ontology proposal defines **what entities exist** (Skill, TaskType, Evidence, Mastery, CompetencyRef).
- This proposal defines **how those entities are measured, traced, and validated** (ExamConstruct → LearningCompetency → ObservableIndicator → MetricType → LearnerModel → Intervention).

The ontology proposal's `Mastery.band` field is invalid pending adoption of the `MetricType` union defined here (§4). See §9 Minimal ontology patch for the required correction.

## 9. Minimal ontology patch

When this proposal is adopted, the following minimal changes to `learning-ontology-proposal.md` v0.3.9 are required:

1. **§2.1 Mastery entity:** Replace `band: 0.0 – 9.0 (0.5 steps)` with `metric: MetricType` (see `learning-measurement-traceability-proposal.md` §4).
2. **§2.3 Confidence:** Update to reference MetricType-specific confidence semantics.
3. **§6 References:** Add `learning-measurement-traceability-proposal.md` to the references list.

These changes are proposed only — the ontology proposal is `review` status and must not be edited without founder review.

## References

- `learning-ontology-proposal.md` v0.3.9 — sibling proposal (8 ontology concepts, CompetencyRef, LearningEvidence facts)
- `blueprint/framework/` v1.0.6 — IELTS Knowledge Framework (band descriptors, skill-questiontype-band, grammar-band-framework)
- `artifacts/engineering/contracts/writing-task-2/openapi.yaml` v0.5.0 — P0 writing evaluation contract
- `artifacts/engineering/contracts/runtime/lifecycle-contract.md` — entity state machines (LearningError, ReviewCard defined in REVIEW.ErrorToReview family)
- `artifacts/operations/capability-lifecycle-registry.yaml` — 180 capability lifecycle
- `artifacts/engineering/contracts/learning-ontology-proposal.meta.yaml` — ontology sidecar
- IELTS Writing Task 2 band descriptors (public, ielts.org) — external SSOT for Writing ExamConstructs (provenance-required)
- IELTS Speaking band descriptors (public, ielts.org) — external SSOT for Speaking ExamConstructs (provenance-required)
