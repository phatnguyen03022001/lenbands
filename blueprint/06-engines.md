# 06 — Engines (Learning Engine Layer)

This file describes the **implementation contracts** of engines that provide algorithms to the Capability Layer (`03-features.md`). They all belong to one "Learning Engine" layer. FSRS is not a separate architectural layer; it is one engine implementation.

```text
Learning Engine
  ├── FSRS Engine          → implement REVIEW.FSRS
  ├── Evaluation Engine    → implement EVAL.Writing/Speaking/Pronunciation/Examiner
  ├── Recommendation Engine→ implement PERSONAL.Recommendation/NextBestAction/Insights
  ├── Quality & Cost Plane → implement OPS.*
  └── Governance Engine    → implement GOVERNANCE.*
```

---

## 1. FSRS Engine (implement `REVIEW.FSRS`)

FSRS (Free Spaced Repetition Scheduler) is the primary spaced-repetition algorithm for every review card: vocabulary, grammar, collocation, sentence patterns, and incorrect questions.

### Why FSRS

- Optimizes intervals from each learner's review history with less repeated self-assessment than SM-2
- More accurate review forecasting
- Personalization through optimization (tuning 19 parameters per learner)
- Open source with established benchmarking (FSRS-5.x spec: https://github.com/open-spaced-repetition/fsrs4anki)

### Card model

| Field | Description |
|---|---|
| `card_id`, `user_id` | id |
| `content_ref` | link to vocab/grammar/collocation/question |
| `content_type` | vocab/grammar/collocation/template/question |
| `due` | next review timestamp |
| `stability` | number of days remembered with high probability |
| `difficulty` | perceived difficulty (1-10) |
| `elapsed_days` | days since last review |
| `scheduled_days` | scheduled interval |
| `reps` | number of reviews |
| `lapses` | number of forgetting events |
| `state` | New / Learning / Review / Relearning |
| `last_review` | timestamp |

### Card state machine

```text
New
  ↓ (first review)
Learning
  ↓ (graduated)
Review
  ↓ (forgot)
Relearning
  ↓ (regraduated)
Review
```

### Rating

- **Again (1)** — completely forgotten → Relearning
- **Hard (2)** — remembered with difficulty → increase difficulty
- **Good (3)** — normal recall → interval calculated by FSRS
- **Easy (4)** — very easy recall → increase interval substantially and reduce difficulty

### Core parameters

19 parameters are optimized per learner:
- `w0-w17` — weights for initial stability/difficulty
- `request_retention` — desired retention rate (default 0.9, configurable per user)
- `maximum_interval` — maximum interval (default 36500 days)

### Stability formula (concept)

```text
New stability = f(previous stability, difficulty, rating, retrievability)
```

- Again → stability decreases substantially / resets
- Hard → small increase
- Good → increases by factor
- Easy → large increase

### Review flow

```text
Card due
  ↓
Learner sees front → recalls → sees back
  ↓
Rating (Again/Hard/Good/Easy)
  ↓
FSRS calculates new stability, difficulty, and due
  ↓
Update card → remove from queue until next due
```

### Card sources

- Vocabulary from Knowledge Assets (`KA.Vocabulary`)
- Collocation (`KA.Collocation`)
- Grammar rule (`KA.Grammar`)
- Wrong question from Mistake Notebook (`REVIEW.MistakeNotebook`)
- Speaking template phrase
- Writing template phrase
- Pronunciation drill item

### FSRS Optimization

- MVP: use a validated global/cohort parameter set; do not optimize per learner while data is insufficient.
- After at least `1000` valid reviews with sufficiently diverse ratings, run optimization offline.
- V1: tune by cohort or skill; apply only when the validation set does not reduce retention/recall.
- V2: per-learner optimization with minimum sample, rollback, and model/version audit.
- Re-optimize periodically, but promote new parameters only through `OPS.ReleaseGate`.

### Review Forecast

- Forecast cards due over the next 7/30 days
- Warn about retention overload when forecast volume is too high
- Suggest adjustments to `request_retention`

### Integration points

- Completed vocabulary lesson → automatically create a card
- Wrong question → option to add to SRS
- Vocabulary Explanation (`COACH.VocabularyExplanation`) → add-to-SRS action
- Daily notification for due reviews (`NOTIF.SRS`)
- Weekly goals may include an SRS review target

---

## 2. Evaluation Engine (implement `EVAL.*`)

AI is the sole scorer and performs 100% of scoring without a human in the loop. The Governance Engine is a control design (section 5 below), not evidence that quality controls are already active.

### Sub-engines

| Engine | Implement | Input | Output |
|---|---|---|---|
| Writing Scorer | `EVAL.Writing` | essay text (+ task prompt) | band 4 criteria (TR, CC, LR, GRA), overall band, sentence-level feedback |
| Speaking Scorer | `EVAL.Speaking` | audio → transcript + features | band 4 criteria (FC, LR, GRA, PR), overall band |
| Pronunciation Scorer | `EVAL.Pronunciation` | audio | phoneme score, word/sentence stress, intonation, mispronunciation list |
| Examiner | `EVAL.Examiner` | user answer (Part 1/2/3) | follow-up question generated in context |
| Band Predictor | `EVAL.BandPrediction` | history of attempts | predicted band + confidence |
| Rewrite Suggester | `EVAL.RewriteSuggestion` | essay draft | sentence-level rewrite suggestions |

### Context injection

`COACH.Tutor` and other Coaches receive the **user's current context**:

```text
context = {
  current_skill,
  current_passage_id,
  current_question_id,
  current_question_type,
  user_history (how often this type was answered incorrectly),
  user_band
}
→ inject into prompt
→ respond in context
```

### Scoring rubric

- Follow public IELTS band descriptors (TR/CC/LR/GRA for Writing; FC/LR/GRA/PR for Speaking).
- Output a **Confidence Score** (`GOVERNANCE.ConfidenceScore`) for every evaluation.
- Low confidence → backend flag, invisible to the user.

### Evaluation result contract

Every evaluation result is stored with:

| Field | Purpose |
|---|---|
| `rubric_version` | identify the rubric that produced the score |
| `model_version` | reproduce and audit the result |
| `quality_status` | `accepted`, `low_confidence`, `insufficient_evidence`, `invalid` |
| `evaluation_state` | `none`, `submitted`, `processing`, `scored`, `low_confidence`, `invalid`, `anti_gaming_review`, `failed` |
| `evidence` | sentence/audio segment/feature supporting the result |
| `feedback_actions` | proposed lesson/drill/rewrite |
| `quality_flags` | anti-gaming, audio quality, off-topic, missing input |
| `cost_metadata` | model tier, token/audio usage, cache hit, latency |

A score feeds readiness, history, and recommendations only when its state is valid. Low-confidence results require a recovery or resubmission path and must never silently become ordinary band results.

### Failure Contract

Failure is part of product behavior, not merely a technical log. Every service/engine returns the same failure envelope:

```json
{
  "failure_code": "EVAL_TIMEOUT",
  "failure_version": "1.0.0",
  "source": "transcription|scoring|recommendation|sync|quota",
  "severity": "recoverable|degraded|terminal",
  "retryable": true,
  "retry_after_seconds": 30,
  "user_state": "processing|delayed|unavailable|action_required",
  "data_action": "preserve|discard_invalid|await_sync",
  "fallback": "queue_retry|basic_result|save_draft|none",
  "quota_effect": "charged|not_charged|reserved_released",
  "telemetry_event": "evaluation_failed",
  "trace_id": "id"
}
```

### Failure taxonomy

Concrete P0 failure codes and their mapping to user-safe HTTP errors live in `artifacts/engineering/contracts/runtime/failure-taxonomy-contract.md`. That Artifact is the sole registry; services must not invent new codes during implementation.

### Failure rules

- `retryable=true` always includes a retry limit, backoff, idempotency key, and `retry_after`.
- Never retry indefinitely or charge a learner multiple times for one internal failure.
- Preserve user-created data before fallback processing; discard only data explicitly marked invalid.
- UI uses understandable user states; error codes, trace IDs, and provider details belong only in support/admin views.
- Every failure emits the corresponding event; exception text is not an analytics contract.
- Failure policies must be tested for timeout, duplicate submit, network loss, quota exhaustion, model rollback, and app restart.

### Anti-gaming

- `GOVERNANCE.AntiGaming` detects pre-existing sample essays, plagiarism, and generated-submission signals.
- Implementation: similarity search against a corpus + AI-generated detector.
- When flagged: show a restrained user message and do not write the band into normal history, or write it only with an explicit flag according to policy.

Anti-gaming is a risk signal, not absolute proof. The system requires false-positive monitoring, neutral explanation, a right to resubmit, and explicit policy for whether flagged results enter history.

---

## 3. Recommendation Engine (implement `PERSONAL.*`)

Turns learning results into next best actions, insights, and adaptive plans.

### Inputs

- Assessment History (`HISTORY.*`)
- Review state (`REVIEW.FSRS`, `REVIEW.MistakeNotebook`)
- Goal (`GOAL.*`)
- Band Framework (`BAND.*`)
- Content taxonomy (`05-content.md`)
- Current energy/time, modality, and notification preferences (`STUDY.CheckIn`, `PROGRESS.Wellbeing`)

### Outputs

| Capability | Logic |
|---|---|
| `PERSONAL.NextBestAction` | "do X today" — based on due queue + weakness + goal |
| `PERSONAL.Insights` | "Matching Headings errors stem from weak paraphrase recognition" — aggregate by `question_type` + `micro_skill` + `paraphrase_pattern` |
| `PERSONAL.AdaptivePlan` | adjust Learning Path according to progress |
| `PERSONAL.WeaknessPractice` | select questions by weakness tags |
| `PERSONAL.GapAnalysis` | gap between current band and target band according to descriptors |

### Insights generation

```text
Aggregate wrong answers by (question_type, micro_skill, paraphrase_pattern)
   ↓
Find weakest pattern (frequency + recency)
   ↓
Map to natural-language insight
   ↓
Recommend action (which lesson to study, which type to practice)
```

This depends on taxonomy depth (`05-content.md`); missing tags mean no reliable insight can be generated.

### Cold start and safety

- Cold start uses self-report + placement + curated baseline; do not pretend personalization exists before evidence exists.
- Every recommendation includes a reason, confidence, and a lighter alternative.
- Do not recommend additional workload when overload signals exist or backlog exceeds capacity.

---

## 4. Quality & Cost Control Plane (implement `OPS.*`)

This layer operates across FSRS, Evaluation, Recommendation, Content, and Experience.

### Model routing ladder

```text
Request
  ↓
Rule / deterministic lookup
  ↓ miss
Cache / precomputed result
  ↓ miss
Small model or batch model
  ↓ low confidence / high-risk task
Large model / specialist scorer
  ↓ failure
Safe fallback + retry queue + clear user state
```

### Quality gates

- **Content**: correctness, taxonomy completeness, calibration, accessibility, rights.
- **Evaluation**: rubric agreement, calibration error, confidence coverage, drift/bias, reproducibility.
- **Recommendation**: actionability, completion, retest lift, error recurrence, and overload rate.
- **Experience**: first meaningful action, recovery success, notification fatigue, accessibility.

Do not promote a model/content item merely because offline accuracy is strong; require outcome and cost impact on a holdout cohort.

### Cost controls

| Control | Policy |
|---|---|
| Cache | cache by normalized input + version; invalidate when content/rubric/model changes |
| Batch | auto-tag, embeddings, weekly recap, and analytics run in batch |
| Routing | rules/small model for classification; large model for high-value/high-risk tasks |
| Quota | token, audio minutes, retries, and concurrent jobs by plan/capability |
| Budget | hard/soft budget by learner, feature, and cohort; alert before exceeding |
| Fallback | degraded but useful: save draft, basic explanation, delayed result, retry queue |
| Observability | measure cost together with quality to detect “cheaper but worse learning” |

### Cost-quality SLOs

- Do not increase cost/active learner without a meaningful outcome increase.
- Do not lower the model tier for high-risk evaluation merely to meet budget.
- Over-budget requests fail gracefully and do not retry indefinitely.
- Every routing change uses canary, rollback, and is recorded in `GOVERNANCE.AuditTrail`.

### Cache, worker, and API reliability

These are product/runtime invariants, not library choices:

- Cache only accelerates access; canonical state remains in the runtime store. Cache miss/outage must not change entitlement, scores, review schedules, or lose drafts.
- Learner-data cache keys must contain subject scope + contract/version; raw essay/audio must never be stored under a shared key.
- Evaluation, sync, and batch processing are at-least-once. Idempotency key + durable state determine exactly-once side effects at the domain layer; the queue itself does not guarantee them.
- Every job has deadline, max attempts, backoff, DLQ/replay path, trace/correlation ID, quota/cost attribution, and owner.
- API mutations must be idempotent, return semantic user-safe failures, and support backward-compatible migration. OpenAPI is a representation of the HTTP contract; it does not replace data/event/failure contracts.

---

## 5. Governance Engine (implement `GOVERNANCE.*`)

Invisible backend controls designed to govern the quality of the sole evaluator without opening a human-in-the-loop runtime path; they are not a quality guarantee while real corpus, threshold, and benchmark-run evidence is missing.

### Sub-engines

| Engine | Implement | Description |
|---|---|---|
| Confidence Scorer | `GOVERNANCE.ConfidenceScore` | every evaluation has confidence; low confidence → flag |
| Gold-Standard Benchmark | `GOVERNANCE.GoldStandardBenchmark` | proposal: re-score an examiner-graded corpus at a cadence/size approved by the founder and measure variance/bias |
| Drift Detector | `GOVERNANCE.DriftDetection` | detect scoring-model drift over time |
| Bias Monitor | `GOVERNANCE.BiasMonitoring` | scoring differences by user group/task type/band |
| Anti-Gaming | `GOVERNANCE.AntiGaming` | canonical owner; `EVAL.AntiGaming` is only a deprecated alias |
| Audit Trail | `GOVERNANCE.AuditTrail` | log calibration, model version, and every change |

### Workflow

```text
Every evaluation (EVAL.*), after routing passes the release gate
   ↓
Attach Confidence Score
   ↓
[Low confidence] → Flag → run through recalibration pipeline (invisible)
   ↓
Benchmark according to founder-approved corpus/threshold cadence
   ↓
Measure drift/bias → if threshold exceeded → re-tune model
   ↓
Record in Audit Trail
   ↓
Governance Dashboard displays metrics to Admin (ADMIN.GovernanceDashboard)
```

### Why this is not human review

- Sole-evaluator philosophy (`01-product.md`): the user sees a 100% AI evaluation flow.
- The quality-control goal is **data-driven governance**, not runtime human review; this mechanism becomes effective only after real corpus, thresholds, and runs exist.
- Calibration may use a gold-standard dataset only when the founder has rights/provenance and a real run exists — this is "human in the dataset", not "human in the loop".

### Key metrics

| Metric | Meaning | Suggested threshold |
|---|---|---|
| Mean Absolute Error vs gold | average deviation | candidate `< 0.5 band`; not approved |
| Low-confidence rate | % evaluations flagged | candidate `< 5%`; not approved |
| Drift (month over month) | change over time | candidate alert threshold; inactive until founder approves benchmark baseline |
| Bias (group diff) | difference across groups | candidate alert; not approved |
| Anti-gaming catch rate | % sample/AI-detected | track; no fixed threshold |

## Cross-references

- Capability IDs: `03-features.md`
- Taxonomy feed: `05-content.md`
- UX recovery when AI fails: `04-experience.md` § Error Recovery
- Conventions (no AI label): `07-conventions.md`
