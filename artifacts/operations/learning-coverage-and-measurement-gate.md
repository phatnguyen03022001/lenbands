# Learning Coverage and Measurement Gate

## 0. Purpose, authority, and non-claim

This operational quality gate answers a different question from the learner-practice coverage contract:

- [`skill-practice-coverage.md`](../experience/specs/skill-practice-coverage.md) defines **what a learner may practise** by IELTS skill, module, task type and mode.
- This gate defines **what LenBands may measure, show, and claim** for a learner, and the evidence required before a learner-facing estimate can become more precise.

It is a review-stage decision aid, not a capability registry, scoring algorithm, IELTS conversion table, or source of learner content. It neither creates a capability nor changes the P0 readiness gate. A green document/tooling check does not prove learning efficacy, fairness, or scoring precision.

**Hard product rule:** LenBands must never guarantee a score for every learner, or represent a product estimate as an official IELTS result. Any future score-like output must state its skill, module, task scope, evidence state, and confidence/range in learner-safe language.

## 1. Terms and claim ladder

| Term | Meaning | May be learner-facing now? |
|---|---|---|
| Learning coverage | A learner can access an appropriate task/practice/review path. | Only within the scope and state declared by the practice coverage contract. |
| Measurement coverage | A result can be traced to a versioned task, scoring rule, and evidence boundary. | No current skill has runtime evidence proving this end-to-end. |
| Provisional estimate | A scoped result whose configuration is published but not calibrated. | Only when the placement quality gate admits the configuration and the UI explicitly discloses the limitation. |
| Calibrated half-band estimate | A scoped estimate that has passed the evidence gate in §5 for the specified slice. | Not available today. |
| Official IELTS score | Score issued by the official examination process. | Never claim; out of product scope. |

`0.5 band` is an output-resolution claim, not proof of accuracy. The official IELTS scale reports whole and half bands, but Writing and Speaking are multi-criterion assessments and Listening/Reading conversions depend on the test form/module. Product precision must therefore be separately measured; it cannot be inherited from the public band scale.

## 2. Learner coverage axes

No artifact may use “all learners” without naming the covered slice across every applicable axis below.

| Axis | Required slice label | Current truth |
|---|---|---|
| Exam module | `academic`, `general_training`, or `shared` | Writing Task 2 is shared; all other module-specific runtime paths are deferred/candidate. |
| Skill | Listening, Reading, Writing, Speaking | Only Writing Task 2 has a P0 contract pack; it is not runtime-verified. |
| Task/practice unit | Framework-controlled task type or practice unit ID | Defined in framework/practice coverage; implementation coverage varies. |
| Learner starting point | Evidence-backed baseline/range; never inferred demographic label | Placement configuration/calibration is missing. |
| Target outcome | Practice outcome, skill estimate, or exam-readiness outcome | Overall/exam-readiness claim is unavailable without all four scoped skills. |
| Modality and accommodation | Keyboard, screen-reader, captions/transcript, audio-recording permission, connectivity/retry | Must be specified by the future interaction/runtime slice; no coverage may be assumed. |
| Language/device context | UI locale, input method, browser/device capability | Deferred unless an approved surface provides it. |
| Evidence state | `not_available`, `provisional`, or `calibrated` | Current P0 evaluation/placement evidence is `not_available`. |

## 3. Skill and measurement coverage matrix

The rows below are a claim-control matrix. They do not create scoring rules or override `skill-practice-coverage.md`.

| Skill / module / task group | Practice coverage authority | Measurement needed before any band-like estimate | Current product allowance | Current state |
|---|---|---|---|---|
| Listening / Academic or GT / ten controlled question types | `skill-practice-coverage.md` §2–3 | Authorized audio/items, accepted-answer rules, test-form/module conversion, timing/retry acceptance, labeled calibration slices | No score/band claim | `spec_candidate` |
| Reading / Academic / sixteen controlled question types | `skill-practice-coverage.md` §2–3 | Authorized passages/items, answer normalization, Academic form conversion, timing/retry acceptance, labeled calibration slices | No score/band claim | `spec_candidate` |
| Reading / GT / same type IDs, distinct passage profile | `skill-practice-coverage.md` §2–3 | GT-specific form conversion and corpus; it must not inherit Academic calibration | No score/band claim | `spec_candidate` |
| Writing / Academic Task 1 | `skill-practice-coverage.md` §2–3 | Task-1-specific rubric/content, authorized labels, benchmark and calibration | No score/band claim | `domain_defined` |
| Writing / GT Task 1 | `skill-practice-coverage.md` §2–3 | Register/letter-purpose rubric, authorized labels, benchmark and calibration | No score/band claim | `domain_defined` |
| Writing / shared Task 2 | P0-04 contracts and `skill-practice-coverage.md` | Rights-cleared prompt/response corpus, examiner labels, criterion/overall agreement, confidence calibration, privacy and acceptance runs | Feedback and safe fallback only once runtime exists; no calibrated band claim today | `contract_defined`, `evidence_blocked` |
| Speaking / Parts 1–3 | `skill-practice-coverage.md` §2–4 | Authorized recordings/labels, part-aware rubric, audio permission/recovery, transcript/feature quality, calibration by part and learner-visible modality | No score/band or pronunciation claim | `spec_candidate` |
| Pronunciation / support units | `skill-practice-coverage.md` §2–4 | Labeled feature evidence and a validated relationship to learner feedback; it is not a standalone IELTS section score | Practice feedback only after its own acceptance evidence; never a standalone IELTS band | `spec_candidate` |
| Mock / Academic or GT composite | `skill-practice-coverage.md` §1–4 | All constituent skill slices calibrated, valid aggregation, section timing/resume, complete provenance | No overall/readiness claim | `deferred` |

## 4. Learner-experience guardrails

Every learner-facing assessment surface must optimize usefulness without false precision.

| UX moment | Required behavior | Prohibited behavior |
|---|---|---|
| Before a task | State skill/module/task scope, expected time, data/recording requirement, and save/retry behavior. | Imply an unavailable skill, module, or official exam simulation. |
| After deterministic practice | Show answer/explanation and a concrete next action tied to the observed task/error. | Invent a band score from one item or one short attempt. |
| After Writing/Speaking evaluation | Show scoped feedback, evidence-backed findings, uncertainty/safe fallback, and a next practice/retest action. | Show a precise band when calibration/status is unavailable; leak raw learner text/audio into logs or events. |
| Low evidence, failed provider, unavailable configuration | Preserve draft/attempt safely, explain retry/resume or an alternative action, and withhold the unsupported result. | Silently fabricate feedback, random-route a learner, or degrade into an unlabelled score. |
| Progress display | State the scope and version of any estimate; distinguish placement-derived results from future mastery. | Present `BAND.Current` as a continuously calibrated mastery estimate before ONT-03 and its evidence gate. |
| Accessibility/modality | Provide the documented accessible path or declare the task unavailable for that modality. | Treat a missing microphone, unsupported browser, or assistive-technology path as learner failure. |

Learner copy must obey the no-AI-label UI invariant and must not expose internal provider/model names. “Not enough evidence yet” must be phrased as a learner-safe next step, not as a system error.

## 5. Half-band measurement admission gate

A future learner-facing half-band estimate is allowed only for one named slice:

```text
exam module × skill × task group × scoring-rule version × corpus version
× learner-visible modality × model/prompt/provider route version
```

All of the following must hold for that slice:

1. **Scope:** controlled task/practice identifiers and the relevant rubric/conversion rule are versioned and published for the slice.
2. **Rights and labels:** benchmark corpus has verified rights, provenance, qualified label method, and versioned examiner/reference labels. No learner data is repurposed as a gold label without the required authority.
3. **Measurement:** a reproducible benchmark run records criterion/overall agreement, adjacent-band behaviour, error distribution, calibration/confidence behaviour, safety withholding, latency, and cost.
4. **Equity and robustness:** the run documents applicable task/module/modality slices and known exclusions. It must not extrapolate one task type, module, or input modality to every learner.
5. **Acceptance:** runtime acceptance confirms the displayed scope/version, privacy/redaction, retry/recovery, and no-result fallback.
6. **Policy:** numeric thresholds are approved and armed in the canonical policy; thresholds are not created by this document.
7. **Promotion:** an immutable evidence record identifies dataset/rubric/model/prompt/provider versions and a promote/hold/rollback decision.

Until all seven hold, the required state is `not_available` or, where admitted by the placement quality gate, `provisional`; it is never `calibrated`.

## 6. Overall-band and personalization guardrails

- An overall/exam-readiness estimate requires valid, current, module-correct coverage for all four assessed skills. A Writing-only result must remain Writing-scoped.
- A learner with uneven evidence across skills receives scoped next actions, not an invented overall band.
- Daily Plan, Next Best Action, coaching, and future Mastery are orchestration consumers. They may not manufacture a score; they must preserve the evidence scope that produced a recommendation.
- `BAND.Current` is placement-derived today. It must not be relabeled as Mastery or used as a Mastery input without the separately proposed, protected ontology adoption path and its post-code evidence.

## 7. Current readiness and next evidence work

| Outcome | Current evidence | State | Required next proof |
|---|---|---|---|
| Complete practice taxonomy | Framework + `skill-practice-coverage.md` | `domain_defined` / partial by slice | Promotion-specific contracts and authorized content. |
| P0 Writing Task 2 feedback loop | Review-stage contract pack | `not_ready` | Runtime acceptance, gold corpus, benchmark, armed thresholds, founder approval. |
| Calibrated Writing half-band estimate | No gold corpus/run/armed policy | `not_available` | §5 admission gate for each Task 2 slice. |
| Placement provisional result | Gate contract exists; no calibrated configuration evidence | `not_available` | Published rights-verified configuration plus its admission/acceptance evidence. |
| Listening/Reading/Speaking/Pronunciation measurement | Deferred/candidate specifications | `not_available` | Per-row requirements in §3; no inheritance from Writing evidence. |
| Overall IELTS/exam readiness | No valid all-skill runtime coverage | `not_available` | Four skill/module slices plus composite aggregation evidence. |

## 8. Evidence-intake coverage record

The canonical corpus manifest and benchmark run remain their existing owners. Before a corpus or run is presented for promotion, its accompanying intake/review record must show which measurement slices are covered and which remain uncovered. This record contains no raw learner content, audio, transcript, prompt body, or provider payload.

```yaml
measurement_coverage_record:
  record_version:
  dataset_ref:
  rubric_version:
  route_version:
  slices:
    - slice_ref:
      exam_module: academic | general_training | shared
      skill:
      task_group_or_practice_unit:
      scoring_rule_ref:
      label_method_ref:
      band_or_boundary_coverage: []
      criterion_coverage: []
      modality_coverage: []
      rights_evidence_ref:
      dataset_state: missing | intake | ready | benchmarked
      measurement_state: not_available | provisional | calibrated
      exclusions: []
      run_evidence_ref:
  aggregation_notes: []
  owner_review:
```

Rules:

- A blank, unknown, or unlabelled dimension remains an exclusion; aggregate scores must not silently fill it.
- Coverage for one Writing task type, one Reading/Listening form, one module, one input modality, or one provider route never transfers to another slice without its own benchmark evidence.
- `band_or_boundary_coverage` records what the authorized labels actually cover. This gate sets no sample-size, fairness, MAE, or agreement number; those are separate founder-approved policies after baseline evidence exists.
- Any demographic/fairness analysis needs an explicit lawful/consented purpose and privacy review. It must use the smallest lawful aggregate slice and never place sensitive learner data in repository artifacts.
- Modality coverage records interface/acceptance support (for example keyboard, screen-reader, captions/transcript, recording permission and recovery); it is not a substitute for score calibration.
- A `calibrated` state is valid only when the named slice meets every admission condition in §5 and has an immutable run evidence reference.

This is an intake/review shape, not a new YAML source of truth or a replacement for `gold-corpus-manifest.yaml`.

## 9. References

- `artifacts/experience/specs/skill-practice-coverage.md` — learner-practice scope and task inventory.
- `artifacts/operations/placement-quality-gate.md` — placement configuration admission and provisional/calibrated distinction.
- `artifacts/operations/evaluation-benchmark-spec.md` — Writing benchmark run and promotion boundary.
- `artifacts/operations/benchmark/gold-corpus-manifest.yaml` and `numeric-threshold-policy.yaml` — canonical evidence/policy status.
- `artifacts/engineering/contracts/learning-ontology-proposal.md` and `learning-measurement-traceability-proposal.md` — proposed Evidence/Mastery design; neither is adopted runtime authority.
- [IELTS scoring in detail](https://ielts.org/take-a-test/your-results/ielts-scoring-in-detail?authuser=0), accessed 2026-08-11 — external orientation only; this artifact does not reproduce or replace official scoring material.
