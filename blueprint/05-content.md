# 05 — Content & Knowledge System

This file owns LenBands content semantics: Knowledge Assets, controlled metadata application, content lifecycle, publishing, provenance, rights and the boundary between curriculum content and assessment evidence.

It does **not** require every possible taxonomy field on every asset. Content metadata exists to support a governed product decision; metadata with no active consumer is optional/deferred rather than mandatory authoring work.

> IELTS domain vocabulary and authority classes live in `framework/`. Official IELTS facts remain externally normative. LenBands curriculum, taxonomy and routing metadata never become official band requirements merely because they are stored beside IELTS content.

## 1. Content principles

1. **Decision-value metadata.** A field is required only when an active capability uses it to make a decision that cannot be made safely from cheaper existing data.
2. **Minimum sufficient schema.** Require the smallest metadata set that preserves correctness, learning outcome, rights, auditability and the current phase.
3. **Deterministic-first.** Validate IDs, answer keys, lifecycle, rights and schema with rules/controlled vocabulary before inference.
4. **AI suggests; domain owners decide.** Model output may suggest tags/explanations, but never creates framework truth or publishes content directly.
5. **Version everything that can invalidate evidence.** Published tasks, stimuli, answer keys, prompts, rubrics and assessment-critical metadata are immutable by version.
6. **Learning content and assessment evidence are different pools.** Familiar/revealed items may teach; they do not automatically provide fresh diagnostic/transfer evidence.
7. **No calibration by prose.** `band`, `difficulty`, `estimated_time`, mastery/readiness or score-related metadata is provisional until governed evidence promotes it.
8. **Rights before usefulness.** An excellent item with unknown rights/provenance is not publishable.
9. **Curriculum sufficiency before recommendation.** A planner may recommend a learning gap only when an eligible intervention exists and the intended improvement can be verified by an eligible independent/retest path; otherwise the system reports a content gap.
10. **Minimum sufficient challenge.** Content should meet the learner at the lowest challenge level that can produce the target-relevant learning/evidence outcome. Harder or higher-band content is not inherently better.

## 2. Knowledge Assets

System Knowledge Assets are learner-serving, versioned content published through the content workflow.

| Asset | Purpose |
|---|---|
| Lesson | Explain and teach one bounded outcome |
| Grammar | Grammar concept/rule and examples |
| Vocabulary | Word/phrase with learner-serving meaning/context |
| Collocation | Governed word combination/pattern |
| Template | Writing/Speaking scaffold; never a guaranteed band formula |
| Strategy | Question/task-specific strategy |
| Example | Worked example/sample with provenance |
| Exercise | Practice linked to a learning/evidence objective |
| Question | Objective item or prompt used under a declared assessment mode |
| Passage/Audio | Versioned stimulus with rights/accessibility metadata |

Concrete learner assets live here/runtime stores; framework files contain definitions and controlled vocabulary, not duplicate asset inventories.

## 3. Metadata economics

### 3.1 Metadata must have an active consumer

A metadata dimension may be mandatory only when its contract declares at least one active consumer and observable decision:

```yaml
metadata_dimension:
  id: micro_skill
  authority: framework/microskill-enum.md
  consumers: [COACH.ErrorAnalysis, REVIEW.SmartQueue]
  decision: map evidence-backed error to remediation/retest family
  phase: P0 | P1 | P2
  validation: controlled_enum
  fallback: unknown_microskill
```

If `consumers` or `decision` is empty, the field is not a release-blocking requirement.

### 3.2 Metadata tiers

**Tier A — universal publishing metadata**

Required for every publishable asset where applicable:

- stable asset/content ID;
- version and lifecycle status;
- asset/content type;
- owner/author/reviewer identity reference;
- source/provenance;
- rights/license state;
- created/updated timestamps;
- skill/module only when the asset is skill/module scoped.

**Tier B — active learning/evaluation metadata**

Required only when an active capability consumes it:

- `question_type`;
- `micro_skill`;
- `criterion`;
- `error_pattern`;
- `grammar_point`;
- `practice_unit`;
- answer-normalization rules;
- exposure/novelty policy;
- remediation/retest mapping;
- prerequisite/learning-stage eligibility when it changes routing.

**Tier C — calibrated routing metadata**

Never blocks authoring merely because it is unknown:

- `difficulty`;
- `band_range` / routing band;
- predicted `estimated_time`;
- item information/calibration parameters;
- cohort-specific performance priors.

Until calibrated, use `unknown_*`/`provisional`, not fabricated precision.

**Tier D — deferred enrichment**

Examples such as detailed distractor, paraphrase-pattern, topic, CEFR or search-enrichment metadata are introduced only when the owning P1/P2 capability proves the decision value.

## 4. P0 Writing Task 2 minimum content contract

Closed-pilot Writing must not pay the metadata cost of future Listening/Reading/Speaking features.

A publishable P0 Writing Task 2 needs only:

```yaml
writing_task:
  task_id: string
  task_version: string
  exam_module: academic | general_training | shared
  task_type: <framework-controlled Writing Task 2 type>
  prompt: string
  rubric_version: string
  lifecycle_state: draft | in_review | published | deprecated | retired
  provenance:
    source_ref: string
    rights_state: approved | restricted | blocked | needs_review
  evaluation_policy_ref: string
  exposure_policy_ref: string
```

For learner feedback/remediation, normalized findings use:

```yaml
finding_mapping:
  criterion: task_response | coherence_cohesion | lexical_resource | grammar
  evidence_ref: string
  error_pattern: <framework-controlled error ID or unknown_error>
  remediation_unit_ref: string | null
  retest_family_ref: string | null
```

P0 does **not** require distractor taxonomy, paraphrase taxonomy, CEFR, IELTS topic taxonomy, calibrated item difficulty or global band-routing metadata for Writing Task 2 unless a concrete P0 decision explicitly consumes it.

## 5. Question and stimulus model

### Objective Listening/Reading question

Minimum semantic fields when that skill activates:

- versioned question ID;
- skill/module/question type;
- stimulus reference + version;
- prompt/options where applicable;
- answer-normalization rule + accepted answers;
- explanation/rationale;
- assessment-mode/exposure policy;
- active micro-skill/error metadata only when consumed;
- lifecycle/provenance/rights.

Objective answer correctness is deterministic. AI/LLM is not used to decide whether a known normalized answer key matches.

### Writing/Speaking prompt

A prompt owns task/format constraints and provenance. It does not own a learner band. Scoring belongs to the evaluation contract and current rubric version.

### Passage/Audio

Stimulus metadata includes the minimum fields required for rendering, accessibility, synchronization, versioning, rights and the activated skill. Transcript/segment/speaker metadata is added only when a consumer needs it.

## 6. Learning design profile

A learning design profile is a contract for one active teaching/practice slice, not a demand to pre-model the entire IELTS universe.

```yaml
learning_design_profile:
  skill: listening | reading | writing | speaking | pronunciation
  exam_module: academic | general_training | shared
  learning_stage: foundation | developing | target | advanced | precision
  cause_fit: english_foundation | ielts_technique | integrated_performance | mixed | any
  learner_outcome: <observable outcome>
  evaluation_rule: <answer/rubric/evidence policy ref>
  review_mapping: <review/remediation policy ref or n/a>
  calibration_status: provisional | calibrated | retired

  # Conditional only when the active slice needs them
  question_type: <controlled ID | n/a>
  practice_unit: <controlled ID | n/a>
  target_micro_skills: []
  prerequisite_refs: []
  feedback_priority: []
  exposure_policy_ref: <ref | n/a>
  acceptance_evidence: <novel/retest/transfer rule>
```

`learning_stage` describes teaching/scaffolding behavior. It is not an IELTS band and is not required to map one-to-one to a numeric target band.

## 7. Exam module and TargetProfile boundary

`exam_module` is first-class whenever the exam variant changes content/format semantics.

The learner's `TargetProfile` belongs to Goal Management, not content metadata. Content may declare module/format eligibility; it must not copy a learner's target band/minima into asset identity.

```text
TargetProfile
  -> diagnosis identifies evidence/cause
  -> planner chooses eligible content
  -> content declares what it can teach/measure
  -> evidence policy decides what the result supports
```

Do not encode learner-specific goals into shared Knowledge Assets.

## 8. Curriculum sufficiency contract

A content library is not sufficient because it contains many lessons. It is sufficient for an **active target path** only when the required chain exists.

For each activated target-relevant gap/cause family, maintain a machine-checkable coverage state equivalent to:

```yaml
curriculum_coverage:
  target_or_construct_ref: string
  cause_class: english_foundation | ielts_technique | integrated_performance | mixed
  teach_or_explain_refs: [string]
  guided_practice_refs: [string]
  independent_practice_refs: [string]
  retest_or_verification_refs: [string]
  rights_ready: boolean
  module_eligible: boolean
  coverage_state: complete | partial | missing
```

Rules:

- `complete` requires at least one governed path from diagnosis to an independent verification action appropriate to the construct;
- FSRS is optional and only required when the remediation unit is meaningfully retrievable;
- a large quantity of learning assets cannot compensate for missing independent verification/retest content;
- a retest pool must preserve exposure/novelty policy and cannot simply reuse the revealed source item;
- if `coverage_state=missing`, the planner returns `content_gap` instead of recommending unrelated material;
- P0 checks only activated Writing/placement/remediation families; it does not require complete four-skill coverage before the closed pilot;
- expanded four-skill claims require corresponding coverage to become complete before launch.

## 9. No-over-band / challenge-fit policy

“Band” is an assessment scale, not a content difficulty ladder that should always increase.

The planner/content selector chooses the **minimum sufficient challenge** consistent with:

- supported diagnosis cause;
- prerequisites;
- learner evidence state;
- TargetProfile;
- required exam authenticity;
- transfer/maintenance need;
- time/energy when pedagogically acceptable.

Content above the learner's demonstrated prerequisite level or beyond the target is excluded by default.

It becomes eligible only when:

1. it is a required bridge to the target;
2. authentic IELTS stimulus/task complexity cannot be simplified without changing the construct;
3. a governed transfer/robustness check intentionally uses a harder/new context;
4. the learner has already demonstrated the lower requirement and the next level is target-relevant.

Do not use advanced vocabulary, complex grammar, harder prompts or denser analytics as a proxy for quality. A learner targeting Band 6.5 should not be routed through Band-8-style enrichment unless one of the rules above justifies it.

## 10. Exposure and evidence pools

Every assessment-capable item/prompt declares an exposure policy appropriate to its activated phase.

Recommended semantic classes:

- `learning_pool` — may be revealed/repeated freely for teaching;
- `practice_pool` — may create diagnostic evidence when unscaffolded and exposure policy allows;
- `retest_pool` — selected to test the same construct/error on sufficiently novel content;
- `protected_assessment_pool` — reserved for higher-integrity diagnostic/mock use.

Rules:

- Seeing an answer/explanation invalidates fresh independent evidence for the configured window/policy.
- A repeated item may still be useful learning/review evidence but is not automatically transfer evidence.
- Exposure history is deterministic runtime state; do not ask an LLM whether an item is "novel enough" when the system already has exposure facts.

## 11. Content workflow and separation of duties

```text
Create
  -> deterministic schema/ID/rights checks
  -> optional tag suggestion
  -> author/reviewer resolves suggestions
  -> review
  -> publish permission + audit
  -> monitor feedback/outcomes
  -> version / deprecate / retire
```

Permissions are functional:

- author creates/edits draft content;
- reviewer checks correctness, taxonomy and rights;
- publisher performs the audited publish transition;
- the same person may hold multiple permissions in P0, but actions remain separate/audited;
- evaluation workers and learner scoring are outside the Colab authority boundary.

## 12. Auto-tagging policy

`CONTENT.AutoTag` is a cost-reduction assistant, not a publishing authority.

Routing order:

1. deterministic inference from asset type/module/question type when exact;
2. reuse/copy governed metadata from a canonical parent/template when valid;
3. bounded offline/small-model suggestion for semantic tags;
4. human review only for tags whose active consumer makes them material;
5. unresolved value remains `unknown_*` or blocks only the capability that truly requires it.

Do not run a large model synchronously merely to populate optional metadata. Batch suggestions when learner-visible latency is irrelevant.

## 13. Versioning and immutability

Lifecycle:

```text
draft -> in_review -> published -> deprecated -> retired
```

Publishing creates an immutable assessment-relevant version. A material correction creates a new version rather than changing historical evidence in place.

At minimum, changes to these fields require impact review/versioning when referenced by learner evidence:

- task/question/prompt text;
- stimulus;
- answer key/normalization;
- rubric/evaluation policy reference;
- assessment mode/exposure policy;
- framework IDs used for evidence/remediation;
- rights/provenance state.

Historical attempts keep the exact content/task/rubric versions they used.

## 14. Provenance, rights and quality gate

Every published learner-serving asset has:

- source/provenance reference;
- rights/license state;
- author/owner;
- reviewer/publisher audit where applicable;
- lifecycle/version;
- correctness/evaluation rule appropriate to the asset.

`rights_state=blocked|needs_review` prevents publication into learner-visible assessment content.

Generated content is not automatically rights-safe, authentic IELTS material or calibrated merely because a model produced it.

## 15. Calibration boundary

The following claims require evidence rather than author judgment/model output:

- calibrated difficulty;
- calibrated estimated time;
- band-routing accuracy;
- diagnostic information value;
- score/readiness implications;
- claim that a tag improves recommendation/learning outcome;
- claim that a target can be achieved in a stated duration/hours.

A field may remain provisional indefinitely if it is useful for lightweight routing but must be labeled/protected accordingly.

## 16. Content economics

Content operations must measure the cost of metadata, not only model tokens.

Track where practical:

- author minutes per publishable asset;
- reviewer/publisher minutes;
- model/batch cost for suggestions;
- percentage of suggested tags changed/rejected;
- percentage of metadata fields actually queried by active decisions;
- content defect/report rate;
- curriculum-coverage gaps by activated target/cause family;
- downstream retest/transfer lift by remediation/content family.

A metadata dimension should be removed, deferred or made optional when its maintenance cost is material and it does not improve correctness, diagnosis, recommendation, retrieval, governance or verified learner outcome.

## 17. P0 closed-pilot scope

P0 content work is limited to what supports:

```text
TargetProfile / placement
  -> supported diagnosis cause or evidence gap
  -> Today action
  -> published Writing Task 2
  -> staged evaluation
  -> evidence-backed priority finding
  -> smallest useful remediation
  -> retrievable review unit when appropriate
  -> independent/novel retest
```

P0 content readiness requires the activated Writing remediation families to have enough governed intervention + retest coverage that the planner does not dead-end after identifying a real gap.

Do not build full cross-skill taxonomy tooling, bulk auto-tagging, advanced search metadata or calibrated difficulty infrastructure merely because the full Blueprint contains those future capabilities.

## 18. Framework integration

Framework IDs remain controlled vocabulary. Missing IDs fail closed only when the active capability truly requires the ID; otherwise retain an explicit unknown/deferred value.

Primary references:

- `framework/README.md` — authority classes and controlled-vocabulary rules;
- `framework/writing-task-framework.md` — Writing format/instructional semantics;
- `framework/band-descriptor-map.md` — official-derived rubric summaries;
- `framework/error-taxonomy.md` — normalized learner error IDs;
- `framework/review-mapping.md` — error → remediation/review semantics;
- `framework/exam-module-differences.md` — module/format/scoring boundary.

Content can organize learning. It cannot manufacture IELTS scoring truth, learner mastery, target feasibility probability or readiness.
