# Writing Task 2 — Evaluation Contract

## Purpose

Define the P0 boundary between deterministic validation, model-assisted rubric judgment, evidence validation, bounded escalation and learner-facing Writing feedback.

This contract intentionally separates **scorer output** from **domain result validity**. A model response is a candidate judgment; it cannot directly become readiness/mastery or an official-equivalent IELTS score.

## Score identity

Every P0 Writing Task 2 result uses:

```yaml
score_label: diagnostic_estimate
score_scope: writing_task_2
```

It is not the complete IELTS Writing section score and never becomes `official_ielts_score`.

## Evaluation input

Runtime resolves raw learner content from protected references and sends only the minimum scorer context.

```yaml
evaluation_request:
  submission_ref: string
  task_ref: string
  task_version: string
  rubric_version: string
  assessment_mode: practice | retest
  essay_text: <protected runtime payload>
  task_prompt: string
  scorer_route_version: string
  bounded_context:
    language_preference: string | null
    relevant_prior_error_refs: []   # optional, capped, only when needed
```

Do not send full learner history, entitlements, unrelated scores or private notes to the scorer.

Target band/minima may inform later feedback/planning, but are not required to decide what evidence exists in the submitted essay.

## Deterministic precheck

Before scorer invocation the runtime validates:

- task status/version and module eligibility;
- ownership/idempotency/quota;
- non-empty/eligible essay input;
- deterministic word count/basic integrity;
- supported rubric/scorer-route version.

A failed precheck produces no paid scorer call.

## Primary scorer output

The scorer returns structured rubric judgments and evidence candidates only:

```yaml
scorer_output:
  scorer_route_version: string
  model_id: string
  provider_id: string
  criteria:
    - criterion: task_response | coherence_cohesion | lexical_resource | grammar
      band_estimate: half_band_0_9 | null
      raw_confidence: number | null
      evidence_candidates:
        - evidence_ref: string
          claim: string
      finding_candidate: string | null
  overall_band_candidate: half_band_0_9 | null
  integrity_signals: []
```

`raw_confidence` is internal routing/governance data. It is not a learner-facing probability that the band is correct.

The scorer output is not persisted as the learner result until domain validation succeeds.

## Domain validation

The normalizer/evidence validator must check:

1. output/schema version;
2. closed criterion enum;
3. band value/range/rounding policy;
4. each evidence reference resolves to actual learner-owned submission evidence;
5. finding text is supported by the cited evidence;
6. task/rubric/scorer route provenance is complete;
7. no result attempts to change score scope/label;
8. integrity signals are treated according to policy rather than as proof.

Unsupported/hallucinated evidence cannot be silently dropped while retaining the same confident score claim. The result must be degraded/re-evaluated according to the versioned policy.

## Escalation contract

A second/stronger/specialist scorer is optional and executes only when the governed escalation policy declares a hard case.

Eligible reasons may include:

- material criterion disagreement/uncertainty according to calibrated policy;
- evidence validation failure that a separately approved route may resolve;
- benchmark-defined high-risk region/task;
- integrity recheck requiring an independent approved route.

Rules:

- no unconditional second pass;
- hard maximum number of scorer passes;
- every escalation has its own cost/provenance record;
- fallback is only to benchmark-approved routes inside the compatible scorer-route policy;
- no approved route → delayed/unavailable, never silent lower-quality substitution.

## Normalized WritingEvaluation

After validation/reconciliation, the domain stores:

```yaml
writing_evaluation:
  evaluation_id: string
  submission_id: string
  score_label: diagnostic_estimate
  score_scope: writing_task_2
  assessment_mode: practice | retest
  rubric_version: string
  scorer_route_version: string
  result_validity: accepted | limited_evidence | insufficient_evidence | invalid | integrity_review
  criteria:
    - criterion: task_response | coherence_cohesion | lexical_resource | grammar
      band_estimate: half_band_0_9 | null
      evidence_refs: []
      finding_ref: string | null
  overall_band_estimate: half_band_0_9 | null
  learner_uncertainty_copy: string | null
  provenance:
    primary_model_id: string
    primary_provider_id: string
    escalation_route_ref: string | null
    prompt_template_id: string
    prompt_hash: string
  cost_ref: string
  created_at: timestamp
```

`operation_state` belongs to the durable operation/submission projection and is not duplicated as result trustworthiness.

## Result-validity policy

- `accepted` — evidence/rubric/route requirements pass for the task-scoped estimate.
- `limited_evidence` — a useful scoped result exists but must not be treated as ordinary strong evidence by downstream learner-state policy.
- `insufficient_evidence` — evidence is not sufficient for the requested numeric/judgment claim; prefer null numeric fields over fabricated precision.
- `invalid` — malformed/unsupported input or output makes the result unusable.
- `integrity_review` — unresolved integrity risk; neutral recovery/resubmission policy applies.

Only the downstream evidence policy determines which validity states can update which learner claims.

## FeedbackFinding contract

Learner-facing feedback is normalized once into immutable findings:

```yaml
feedback_finding:
  finding_id: string
  evaluation_id: string
  criterion: task_response | coherence_cohesion | lexical_resource | grammar
  evidence_refs: [string]
  error_pattern: <framework ID | unknown_error>
  explanation: string
  priority: integer
  remediation_unit_ref: string | null
  retest_family_ref: string | null
  actionability: actionable | informational | insufficient_evidence
```

A finding must not invent a framework error ID. An unknown mapping may remain informational; it cannot create an invalid review card merely to satisfy taxonomy completeness.

## Feedback policy

Default order:

```text
evidence
  -> meaning / rubric criterion
  -> one highest-leverage action
  -> verification / retest
  -> optional deeper explanation
```

Do not generate a long essay rewrite by default. Reusable remediation content should be precomputed/versioned; personalized generation is on-demand where it materially improves learner outcome.

## Integrity policy

Integrity signals are risk signals, not automatic adjudication.

Prefer deterministic/provenance signals such as known-sample similarity, copied prompt overlap and exposure history. AI-generated-text detectors, if used, are weak supporting signals and cannot alone declare cheating.

## Quality gate

A scorer route cannot be promoted on aggregate MAE alone. Benchmark evidence should cover the governed suite including criterion agreement, within-band agreement, stability, evidence validity, task/proficiency slices and confidence usefulness where applicable.

No numeric release threshold is active without an approved corpus/protocol/run.

## Cost policy

- deterministic eligibility before inference;
- primary approved route first;
- stronger route only for governed hard cases;
- bounded retries/escalations;
- concise feedback by default;
- deeper personalized explanation on demand/quota;
- record primary, escalation and feedback-generation cost separately;
- optimize `cost_per_accepted_evaluation` and `cost_per_verified_improvement`, not tokens alone.

## Privacy / reasoning boundary

Store prompt/template/version hashes and structured result provenance required for audit. Do not store or expose hidden chain-of-thought. General telemetry never contains raw essay/provider payload.

## Derived contract

This is the Writing Task 2 specialization of the canonical evaluation/runtime semantics. Any shared schema enum/type change must be reconciled with the canonical API/runtime contracts before this slice becomes implementation-eligible.