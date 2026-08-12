# Interaction Specification — Writing Task 2

## 0. Purpose and boundary

This behavior contract connects learner action, runtime orchestration, UX expectations, failure, and evidence for `P0-04`. It does not replace the state machine, OpenAPI, or data/event/failure contracts; it defines **the order in which those contracts work together**.

References:

- Experience: `artifacts/experience/specs/vertical-slices/writing-task-2.md`
- Runtime: `artifacts/engineering/contracts/writing-task-2/runtime-spec.md`
- HTTP: `artifacts/engineering/contracts/writing-task-2/openapi.yaml`
- Data: `artifacts/engineering/contracts/writing-task-2/data-contract.md`
- Events: `artifacts/engineering/contracts/writing-task-2/event-contract.md`
- Failure: `artifacts/engineering/contracts/writing-task-2/failure-contract.md`
- Acceptance: `WR-01` → `WR-07` in the runtime spec and P0 acceptance manifest

## 1. Interaction path contract

| Step | Actor | Command/action | Sync/async | Runtime write/effect | Expected UX | Failure/recovery | Evidence |
|---|---|---|---|---|---|---|---|
| `WR-I01` | Learner | Open published Task 2 | sync | read task/version/constraints | prompt + word target | task unavailable → alternative task state; do not randomize the task | task response + published fixture |
| `WR-I02` | Learner | Type and autosave draft | sync request, local-first | write draft version, ownership, and save outcome | `Saved` / `Saving` / local-only | network → retain local text; conflict → reconcile, do not overwrite | read-back + version trace |
| `WR-I03` | Learner | Click `Submit` | sync validation + async dispatch | validate word count/task/version/quota; atomically write submission + outbox | confirm → `Processing` | validation/quota/idempotency error; draft remains | request pair + submission/effect count |
| `WR-I04` | Runtime | Claim evaluation job | async | set processing; check idempotency/deadline | learner may leave the screen; status remains | worker crash → reclaim; no duplicate charge/result | job/state trace |
| `WR-I05` | Runtime | Call provider adapter and normalize result | async | bounded provider call; parse Evaluation Contract; create evaluation/findings | processing indicator | timeout → delayed; schema/provider failure → unavailable; retain low-confidence flag | provider-neutral result + failure trace |
| `WR-I06` | Runtime | Persist evaluation and publish outcome | sync transaction after async call | immutable evaluation + findings + current pointer; ack after commit | result available or safe state | DB/outbox failure → durable result, reconcile event | evaluation/event/outbox evidence |
| `WR-I07` | Learner | Open feedback and select finding | sync read + mutation | read evidence-linked finding; confirmation creates LearningError | 4 criteria, evidence, one priority error | missing evidence → do not allow error save; low confidence → review state | response + finding/error mapping |
| `WR-I08` | Learner | Complete fix drill | sync | write fix evidence, do not mark improved automatically | one specific corrective action | save failure → retain attempt, retry idempotently | fix evidence |
| `WR-I09` | Learner | Rate ReviewCard | sync mutation | FSRS transition durable write | next due/state | duplicate rating → idempotent result; FSRS failure → safe retry | card transition + event |
| `WR-I10` | Learner | Start and submit retest | async if evaluation is needed | new prompt with the same error pattern; evaluate + resolve rule | `Checking improvement` | timeout/unavailable keeps error in review | retest result + resolve decision |

## 2. Authoritative sequencing rules

### Submit path

```text
Learner submit
  → API auth/ownership/input/quota validation
  → transaction: submission + idempotency record + outbox job
  → 202 submitted
  → worker claim
  → evaluation adapter
  → normalize/validate
  → transaction: evaluation + findings + current pointer
  → ack job
  → outcome event
```

Do not queue before transaction commit, return a score before durable write, or create `LearningError` automatically before learner confirmation.

### Safe result path

```text
valid evidence      → scored + learner feedback
low confidence      → flagged feedback, no promotion
insufficient evidence → safe unavailable/insufficient state
anti-gaming action  → recheck once, then unavailable if not clear
provider/worker fail → delayed/unavailable, submission retained
```

### Review path

```text
FeedbackFinding
  → learner confirm
  → LearningError(open)
  → ReviewCard
  → FSRS rating
  → new-content retest
  → resolve_when check
  → improved or in_review
```

## 3. UX/runtime contract

- Every async step has a visible state; the learner does not have to keep a screen open.
- Leaving the screen does not cancel a durable submission, evaluation, or recording.
- Every mutation has `Idempotency-Key`; every response has `X-Request-Id`.
- The learner sees only user-safe state; not the provider, stack trace, hidden reasoning, or raw failure payload.
- There is no partial score. Evaluation parse/schema failure is a complete failure state.
- There is no readiness/progress promotion from `invalid`, `low_confidence`, or `anti_gaming_review`.
- Every learner-visible finding has an evidence ref, or clearly displays `insufficient_evidence` and does not allow an error card to be created.

## 4. Interaction acceptance gate

The interaction spec may move to `approved` only when the reviewer can trace each row from:

```text
User Action
  → Command/API
  → Runtime transition/effect
  → UX state
  → Event/evidence
  → Failure/recovery
```

If a row lacks a clear runtime effect, evidence, or recovery, the capability is not `ready`, even if its OpenAPI/schema is individually valid.
