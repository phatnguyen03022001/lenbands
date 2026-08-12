# Lifecycle Contract — Cross-Entity State Machine Authority

- **Type:** lifecycle-contract
- **Status:** `review` — Deliverable B
- **Owner:** engineering
- **Created:** 2026-08-10
- **Derived from:** all 6 ACTIVE family runtime specs, `capability-lifecycle-registry.yaml`, `architecture-frozen.md`
- **Consumed by:** Go API (state enforcement), Python evaluation worker (job lifecycle), validators

## Purpose

Define the canonical lifecycle framework for every runtime entity in LenBands. This contract establishes
uniform semantics for state machines, transitions, terminal states, cancellation, retry, replay,
idempotency, archival, deletion, export, and restore across all families.

Per-family state definitions in the 6 owner runtime specs remain authoritative for family-specific
states. This contract provides the cross-cutting rules those per-family definitions must conform to.

## 1. Lifecycle framework — mandatory properties

Every entity state machine MUST define:

| Property | Required | Description |
|---|---|---|
| `owner_family` | yes | Family that owns this entity's lifecycle |
| `canonical_states` | yes | Ordered list of persisted states |
| `initial_state` | yes | State at entity creation |
| `terminal_states` | yes | States from which no further transition is permitted |
| `transitions` | yes | Map of `{from_state: {to_state: [permitted_actors]}}` |
| `idempotency_key` | yes | Field(s) that make a transition idempotent |
| `retry_policy` | if retryable | Conditions under which a failed transition may be retried |
| `cancellation_policy` | if cancellable | Whether cancellation is permitted, by whom, and resulting state |
| `archival_policy` | yes | When data moves to read-only archival |
| `deletion_policy` | yes | How learner deletion requests affect this entity |
| `export_policy` | yes | Whether entity data is included in learner export |
| `audit_policy` | yes | Which transitions produce immutable audit records |
| `privacy_class` | yes | One of: account, learning, assessment, audio, billing, system, derived |

## 2. Cross-entity lifecycle invariants

### 2.1 Terminal state invariant

Once an entity reaches a terminal state, no actor may transition it to any other state. Terminal
states are: `deleted`, `graduated`, `resolved`, `archived`, `completed` (final), `rolled_back`.

### 2.2 Idempotency invariant

A transition with the same `idempotency_key` applied to the same entity in the same `from_state`
MUST produce the same result. Duplicate transition requests return the stored result, not an error,
unless the payload materially differs (→ `409 idempotency_key_reused`).

### 2.3 Immutability invariant

Fact entities (evaluation results, consent records, benchmark runs, audit records) are
**append-only**. Once written, their content is never modified. Corrections create new facts
with `supersedes` references to the original.

### 2.4 Deletion invariant

When a learner requests account deletion:
1. All learner-owned entities enter `deletion_pending` → `deleted` within the recovery window.
2. Immutable audit/evidence records referencing the learner are pseudonymized (subject_id replaced
   with a deletion token), not physically removed.
3. Events already emitted are not retracted; new events are no longer produced for the deleted subject.
4. The recovery window is 30 days from deletion request. During this window, the learner may cancel
   deletion and restore access. After the window, data is hard-deleted.

### 2.5 Export invariant

A learner export request produces a machine-readable bundle of all learner-owned entities within
a defined time window. Export is idempotent per request and versioned. It includes: Account,
ConsentRecord, LearnerProfile, Goal, PlacementAttempt, BandEstimate, GapProfile, DailyPlan,
StudySession, WritingDraft, WritingSubmission, WritingEvaluation, FeedbackFinding, LearningError,
ReviewCard, ReviewAttempt, RetestAttempt. It excludes: provider tokens, raw provider payloads,
system audit records, and other learners' data.

## 3. Entity lifecycle catalog

### 3.1 IDENTITY.Core entities

#### Account

```yaml
owner_family: IDENTITY.Core
canonical_states: [guest, authenticated, consent_pending, active, deletion_requested, deletion_processing, deleted]
initial_state: guest
terminal_states: [deleted]
transitions:
  guest: {authenticated: [identity_provider, runtime]}
  authenticated: {consent_pending: [learner], guest: [runtime]}
  consent_pending: {active: [learner], authenticated: [runtime]}
  active: {deletion_requested: [learner]}
  deletion_requested: {active: [learner], deletion_processing: [runtime]}
  deletion_processing: {deleted: [runtime]}
idempotency_key: provider_subject
retry_policy: AUTH_UNAVAILABLE → retry with backoff; return existing session if active
cancellation_policy: deletion_requested may be cancelled by learner within recovery window → active
archival_policy: deleted account data retained 30 days then hard-deleted
deletion_policy: owner of this entity; full cascade to all learner-owned entities
export_policy: included in full export
audit_policy: account_created, deletion_requested, deleted produce audit records
privacy_class: account
```

#### ConsentRecord

```yaml
owner_family: IDENTITY.Core
canonical_states: [recorded, active, superseded]
initial_state: recorded
terminal_states: [superseded]
transitions:
  recorded: {active: [runtime], superseded: [runtime]}
  active: {superseded: [runtime]}
idempotency_key: subject_id + consent_version
retry_policy: immutable — no retry; new consent creates new record
cancellation_policy: not cancellable
archival_policy: superseded records retained indefinitely for audit
deletion_policy: deleted with account
export_policy: included in full export
audit_policy: every consent record creation produces audit
privacy_class: account
note: Consent records are append-only immutable facts. A consent change creates a new record; the prior record becomes superseded. Never overwritten.
```

#### PrivacyRequest

```yaml
owner_family: IDENTITY.Core
canonical_states: [requested, processing, ready, completed, failed, cancelled]
initial_state: requested
terminal_states: [completed, cancelled]
transitions:
  requested: {processing: [runtime], cancelled: [learner]}
  processing: {ready: [runtime], completed: [runtime], failed: [runtime]}
  ready: {completed: [runtime]}
idempotency_key: subject_id + request_type (export|deletion) + request_version
retry_policy: failed → learner may retry (creates new request)
cancellation_policy: requested may be cancelled by learner
archival_policy: completed request records retained 90 days
deletion_policy: deleted with account; export-ready data included in deletion bundle
export_policy: export requests produce export-ready state; deletion requests are NOT exported
audit_policy: privacy_export_requested, privacy_deletion_requested events
privacy_class: account
```

### 3.2 PLACEMENT.Diagnosis entities

#### PlacementAttempt

```yaml
owner_family: PLACEMENT.Diagnosis
canonical_states: [new, in_progress, paused, submitted, diagnosed, insufficient_data]
initial_state: new
terminal_states: [diagnosed, insufficient_data]
transitions:
  new: {in_progress: [learner]}
  in_progress: {paused: [learner], submitted: [learner]}
  paused: {in_progress: [learner]}
  submitted: {diagnosed: [runtime], insufficient_data: [runtime]}
idempotency_key: subject_id + attempt_config_version
retry_policy: insufficient_data → learner creates new attempt; SCORING_UNAVAILABLE → preserve attempt, retry scoring later
cancellation_policy: not cancellable after submission; new/in_progress may be abandoned (→ new retry attempt)
archival_policy: immutable after submission; retained for history
deletion_policy: deleted with account
export_policy: included in full export (all versions)
audit_policy: placement_completed event
privacy_class: learning
note: An attempt is immutable after submission. Retry creates a new attempt linked to the prior via prior_attempt_ref.
```

#### Goal

```yaml
owner_family: PLACEMENT.Diagnosis
canonical_states: [active, superseded]
initial_state: active
terminal_states: [superseded]
transitions:
  active: {superseded: [learner]}
idempotency_key: subject_id + goal_version
retry_policy: goal change creates new version; prior goal superseded
cancellation_policy: not cancellable
archival_policy: superseded goals retained for timeline
deletion_policy: deleted with account
export_policy: included in full export
audit_policy: goal_set event
privacy_class: learning
```

### 3.3 STUDY.DailyAction entities

#### DailyPlan

```yaml
owner_family: STUDY.DailyAction
canonical_states: [no_plan, plan_ready, plan_stale, plan_replaced, plan_unavailable, fallback_offered]
initial_state: no_plan
terminal_states: [plan_replaced]
transitions:
  no_plan: {plan_ready: [runtime], fallback_offered: [runtime], plan_unavailable: [runtime]}
  plan_ready: {plan_stale: [runtime], plan_replaced: [runtime]}
  plan_stale: {plan_ready: [runtime]}
  fallback_offered: {plan_ready: [runtime]}
  plan_unavailable: {plan_ready: [runtime], fallback_offered: [runtime]}
idempotency_key: subject_id + plan_date
retry_policy: plan_unavailable → regenerate next cycle
cancellation_policy: not cancellable (transient daily projection)
archival_policy: retained 90 days for analytics
deletion_policy: deleted with account
export_policy: NOT included (derived projection, not source truth)
audit_policy: daily_plan_generated event
privacy_class: learning
note: DailyPlan is a projection, not a source of truth. Reproducible from source facts.
```

#### StudySession

```yaml
owner_family: STUDY.DailyAction
canonical_states: [started, paused, completed, abandoned]
initial_state: started
terminal_states: [completed, abandoned]
transitions:
  started: {paused: [learner], completed: [learner], abandoned: [learner]}
  paused: {started: [learner], abandoned: [learner]}
idempotency_key: subject_id + session_id + state_transition
retry_policy: SESSION_RESTORE_FAILED → preserve last checkpoint, retry resume
cancellation_policy: abandoned is terminal; no further transitions
archival_policy: retained for learning history; completed sessions retained indefinitely for analytics
deletion_policy: deleted with account
export_policy: included in full export (session metadata, not action content)
audit_policy: session_started, session_completed, session_abandoned events
privacy_class: learning
```

### 3.4 WRITING.Evaluation entities

#### WritingDraft

```yaml
owner_family: WRITING.Evaluation
canonical_states: [drafting, saved, submitted]
initial_state: drafting
terminal_states: [submitted]
transitions:
  drafting: {saved: [learner], submitted: [learner]}
  saved: {drafting: [learner], submitted: [learner]}
idempotency_key: draft_id + version (optimistic locking)
retry_policy: DRAFT_SYNC_UNAVAILABLE → retry save; conflict → reconcile client-side
cancellation_policy: drafting/saved may be discarded by learner (draft removed after 90 days inactivity)
archival_policy: submitted drafts retained with submission; unsubmitted drafts auto-purged after 90 days
deletion_policy: deleted with account
export_policy: included in full export (text content is learner-owned)
audit_policy: writing_draft_saved event (text never in event)
privacy_class: assessment
note: Draft contains raw essay text — privacy_class assessment, never logged, never in analytics events.
```

#### WritingSubmission

```yaml
owner_family: WRITING.Evaluation
canonical_states: [submitted, processing, scored, low_confidence, delayed, unavailable]
initial_state: submitted
terminal_states: [scored, unavailable]
transitions:
  submitted: {processing: [runtime], delayed: [runtime]}
  processing: {scored: [runtime], low_confidence: [runtime], delayed: [runtime], unavailable: [runtime]}
  delayed: {processing: [runtime], unavailable: [runtime]}
  low_confidence: {scored: [runtime]}  # only if policy approves override
idempotency_key: draft_id + draft_version (submission); submission_id (evaluation)
retry_policy: delayed → retry evaluation (POST retry); unavailable → may retry once; timeout → exponential backoff up to 3 attempts
cancellation_policy: not cancellable after submission acceptance
archival_policy: retained for assessment history; scored submissions retained indefinitely
deletion_policy: deleted with account
export_policy: included in full export (submission metadata; essay text via draft)
audit_policy: writing_submission_accepted, evaluation_submitted/scored/failed/delayed events
privacy_class: assessment
note: Submission is immutable after acceptance. Evaluation retry reuses the same submission.
```

#### WritingEvaluation

```yaml
owner_family: WRITING.Evaluation
canonical_states: [submitted, processing, scored, low_confidence, invalid, anti_gaming_review, failed]
initial_state: submitted
terminal_states: [scored, invalid, failed]
transitions:
  submitted: {processing: [runtime]}
  processing: {scored: [evaluator], low_confidence: [evaluator], invalid: [evaluator], anti_gaming_review: [evaluator], failed: [evaluator]}
  low_confidence: {scored: [runtime]}  # policy-gated override
  anti_gaming_review: {scored: [runtime], invalid: [runtime]}  # disposition decision
idempotency_key: submission_id + evaluator_version
retry_policy: failed → retry (new evaluator run); low_confidence → policy decision (show guarded or retry)
cancellation_policy: not cancellable
archival_policy: scored evaluations retained indefinitely as assessment facts; failed/low_confidence retained for quality analysis
deletion_policy: deleted with account
export_policy: included in full export
audit_policy: evaluation_scored/failed event; provider version + rubric version recorded
privacy_class: assessment
note: Evaluation is an append-only fact. A re-evaluation of the same submission creates a new evaluation record with supersedes_ref.
```

### 3.5 REVIEW.ErrorToReview entities

#### LearningError

```yaml
owner_family: REVIEW.ErrorToReview
canonical_states: [open, in_review, improved, dismissed, resolved, recurring]
initial_state: open
terminal_states: [resolved, dismissed]
transitions:
  open: {in_review: [learner], dismissed: [learner]}
  in_review: {improved: [learner], open: [runtime]}
  improved: {resolved: [runtime], recurring: [runtime], open: [runtime]}
  recurring: {in_review: [learner], open: [runtime]}
idempotency_key: source_finding_id + subject_id
retry_policy: NO_EVIDENCE_NO_CARD → cannot create; RETEST_INVALID → preserve error, do not mark resolved
cancellation_policy: dismissed by learner
archival_policy: resolved/dismissed errors retained for learning history
deletion_policy: deleted with account
export_policy: included in full export
audit_policy: learning_error_saved, learning_error_resolved events
privacy_class: learning
```

#### ReviewCard

```yaml
owner_family: REVIEW.ErrorToReview
canonical_states: [created, learning, review, relearning, graduated]
initial_state: created
terminal_states: [graduated]
transitions:
  created: {learning: [runtime]}
  learning: {review: [runtime], relearning: [runtime], graduated: [runtime]}
  review: {learning: [runtime], relearning: [runtime], graduated: [runtime]}
  relearning: {review: [runtime], graduated: [runtime]}
idempotency_key: source_error_id + card_version
retry_policy: REVIEW_QUEUE_EMPTY → offer alternative action; duplicate rating → idempotent, return same result
cancellation_policy: not manually cancellable; only graduates via FSRS algorithm
archival_policy: graduated cards retained for learning analytics
deletion_policy: deleted with account
export_policy: included in full export
audit_policy: review_card_created, review_card_rated, review_card_graduated events
privacy_class: learning
note: Card transitions are deterministic FSRS transitions. No manual state override permitted.
```

#### RetestAttempt

```yaml
owner_family: REVIEW.ErrorToReview
canonical_states: [created, submitted, processing, completed, unavailable]
initial_state: created
terminal_states: [completed, unavailable]
transitions:
  created: {submitted: [learner], unavailable: [runtime]}
  submitted: {processing: [runtime]}
  processing: {completed: [runtime], unavailable: [runtime]}
idempotency_key: error_id + retest_version
retry_policy: unavailable → may retry (creates new attempt); RETEST_INVALID → preserve, do not resolve error
cancellation_policy: not cancellable after submission
archival_policy: completed retests retained for outcome measurement
deletion_policy: deleted with account
export_policy: included in full export
audit_policy: retest_started, retest_completed events
privacy_class: learning
note: Each retest uses a new task/item — never replays the original WritingTask from the source error.
```

### 3.6 OPS.QualityEconomics entities

#### BenchmarkRun

```yaml
owner_family: OPS.QualityEconomics
canonical_states: [created, running, completed, failed]
initial_state: created
terminal_states: [completed, failed]
transitions:
  created: {running: [runtime]}
  running: {completed: [runtime], failed: [runtime]}
idempotency_key: benchmark_config_version + run_id
retry_policy: failed → new run with incremented run_id
cancellation_policy: not cancellable after start
archival_policy: retained indefinitely as immutable evidence
deletion_policy: NOT deletable — evidence is permanent
export_policy: admin-accessible via governance dashboard; not learner export
audit_policy: benchmark_run_completed event
privacy_class: derived
note: Benchmark runs are immutable evidence records. Never overwritten, never deleted.
```

#### ReleaseGateDecision

```yaml
owner_family: OPS.QualityEconomics
canonical_states: [unarmed, collecting_evidence, blocked, approved_for_pilot, rolled_back]
initial_state: unarmed
terminal_states: [approved_for_pilot, rolled_back]
transitions:
  unarmed: {collecting_evidence: [admin]}
  collecting_evidence: {blocked: [runtime], approved_for_pilot: [admin]}
  blocked: {collecting_evidence: [admin]}
  approved_for_pilot: {rolled_back: [admin]}
idempotency_key: gate_id + decision_version
retry_policy: blocked → remediate and re-evaluate
cancellation_policy: not cancellable
archival_policy: retained indefinitely as governance evidence
deletion_policy: NOT deletable
export_policy: admin-accessible only
audit_policy: release_gate_blocked, release_gate_approved events; every decision auditable
privacy_class: derived
```

#### AuditRecord

```yaml
owner_family: OPS.QualityEconomics
canonical_states: [recorded]  # single-state — immutable
initial_state: recorded
terminal_states: [recorded]
transitions: {}  # no transitions — append-only
idempotency_key: event_id + record_hash
retry_policy: not applicable
cancellation_policy: not cancellable
archival_policy: retained indefinitely
deletion_policy: NOT deletable; pseudonymized on account deletion
export_policy: NOT learner-accessible
audit_policy: self-auditing (record creation is audit event)
privacy_class: system
note: Audit records are immutable system facts. Never contain learner content.
```

## 4. Protected conflict lifecycle analysis

### 4.1 SPEAKING.Practice orphan

**Conflict:** Family defined, 0 capabilities assigned.

**Lifecycle implication:** If the family is intended as a practice-only entry point separate from
evaluation, the lifecycle states for `SpeakingPrompt`, `SpeakingRecording`, `SpeakingAttempt`
must eventually be defined. But with 0 assigned capabilities, no entity lifecycle exists yet.

**Privileged diff options:** See `artifacts/operations/founder-review-packet-index.md` PD-01.
This contract registers the conflict without resolving it.

### 4.2 PRACTICE.Drill capability/family collision

**Conflict:** Same name at capability layer (ACTIVE, in REVIEW.ErrorToReview) and family layer
(PLANNED, PRACTICE.Drill).

**Lifecycle implication:** The `RetestAttempt` lifecycle (above) is the P0 PRACTICE.Drill lifecycle.
The separate PRACTICE.Drill family will define its own lifecycles for `PracticeSet`, `PracticeAttempt`,
`PracticeResult` when promoted. The shared name creates no runtime collision because the family
layer is PLANNED with no owner_spec yet.

**Privileged diff options:** See `artifacts/operations/founder-review-packet-index.md` PD-02.

### 4.3 WRITING.Evaluation deprecated interaction reference

**Conflict:** Family registry's `interaction_spec` points to `interaction/writing-evaluation.md`;
the actual canonical interaction is `writing-task-2.md` vertical slice.

**Lifecycle implication:** The interaction spec defines learner-facing state rendering. If two files
claim authority, states like `low_confidence`, `delayed`, `anti_gaming_review` may have divergent
UX behavior across the two references. The lifecycle contract above is neutral — it defines
canonical states without prescribing UX rendering.

**Privileged diff options:** See `artifacts/operations/founder-review-packet-index.md` PD-03.

### 4.4 GOVERNANCE.Quality deprecated-only lifecycle smell

**Conflict:** Family with 1 PLANNED capability (`GOVERNANCE.AntiGaming`) and no owner_spec.

**Lifecycle implication:** The `EVAL.AntiGaming` (DEPRECATED) capability has no lifecycle —
it's a deprecated alias. Its successor `GOVERNANCE.AntiGaming` (PLANNED) has no lifecycle yet
because it has no owner_spec. The governance entity `GovernanceFinding` is deferred.

**Privileged diff options:** See `artifacts/operations/founder-review-packet-index.md` PD-04.

## 5. Job lifecycle (async evaluation + retest)

This contract defines the **logical cross-entity lifecycle**. The canonical operational job
envelope, physical queue states, retry ceiling, backoff, deadline, and replay procedure are owned
by `async-job-worker-contract.md`. A family or lifecycle document MUST NOT duplicate numeric retry
policy; it references that owner instead.

Every async job (evaluation, retest) follows this logical lifecycle:

```yaml
job_lifecycle:
  canonical_states: [queued, claimed, running, completed, failed, dead_lettered]
  initial_state: queued
  terminal_states: [completed, dead_lettered]
  transitions:
    queued: {claimed: [worker]}
    claimed: {running: [worker], dead_lettered: [runtime]}
    running: {completed: [worker], failed: [worker]}
    failed: {queued: [runtime], dead_lettered: [runtime]}
  idempotency_key: job_id (UUID, generated at enqueue)
  retry_policy: failed → queued until the job envelope's max_attempts/deadline policy is exhausted; then dead_lettered
  replay_policy: dead_lettered jobs may be replayed by an authorized operator only through the job-worker contract's new-job/replay_of procedure
  observability: job_id + trace_id + attempt_number on every state transition
  privacy: job payload must not duplicate raw essay text; essay accessed via learner-scoped draft service reference
```

**Operational-policy reference:** For P0 writing evaluation, the job envelope currently sets
`max_attempts: 2` and 30-second jittered backoff in
`async-job-worker-contract.md` § Retry, DLQ and concurrency. Retest and privacy jobs require their
own job-worker policy row before implementation. This lifecycle contract deliberately holds no
competing retry number or schedule.

## 6. Transition authority

| Actor | Permitted transitions |
|---|---|
| `learner` | Learner-initiated state changes on their own entities (submit, pause, rate, dismiss, request deletion/export, cancel request) |
| `runtime` | System-initiated transitions (plan generation, scoring, job lifecycle, timeout/expiry) |
| `evaluator` | Evaluation worker transitions (processing → scored/low_confidence/invalid/anti_gaming_review/failed) |
| `worker` | Job worker transitions (queued → claimed → running → completed/failed) |
| `identity_provider` | External auth provider (guest → authenticated) |
| `admin` | Governance transitions (unarmed → collecting_evidence, blocked → collecting_evidence, approved_for_pilot → rolled_back, dead_letter replay) |

All transitions produce audit records. Admin transitions require `admin:governance` scope.

## 7. Recovery and restore

### 7.1 Session recovery

When a learner's session is interrupted (network loss, browser close):
- `StudySession`: last `checkpoint_ref` is preserved; resume from checkpoint
- `PlacementAttempt`: `paused` state with in-progress responses preserved
- `WritingDraft`: autosaved version available; optimistic version check on reconnect

### 7.2 Data restore

- **Point-in-time restore:** Neon PostgreSQL PITR (6-hour window on free plan).
- **Entity restore:** Not a general feature. Specific restore paths:
  - `WritingDraft`: autosave history within session window
  - `PlacementAttempt`: retry creates new attempt, prior responses not restored
  - `LearningError`: dismissed errors cannot be undismissed (intentional — learner choice)
  - `ReviewCard`: FSRS algorithm owns all transitions; no manual restore

## References

- `artifacts/engineering/runtime/identity-core-runtime.md`
- `artifacts/engineering/runtime/placement-diagnosis-runtime.md`
- `artifacts/engineering/runtime/daily-action-runtime.md`
- `artifacts/engineering/runtime/writing-evaluation-runtime.md`
- `artifacts/engineering/runtime/error-to-review-runtime.md`
- `artifacts/engineering/runtime/quality-economics-runtime.md`
- `artifacts/engineering/contracts/writing-task-2/failure-contract.md`
- `artifacts/engineering/contracts/runtime/api-governance-contract.md`
