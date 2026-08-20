# 02 — System Architecture

This document owns LenBands system boundaries, domain map, architecture invariants, runtime-state model, and the deterministic-versus-intelligence boundary. Provider selection belongs to `artifacts/business/decisions/platform-sourcing.md`; HTTP operations belong to the canonical OpenAPI contract.

## Domain map

The product retains 23 semantic domains. These are product boundaries, **not microservices**.

1. Identity
2. Localization
3. Goal Management
4. Placement
5. Learning
6. Knowledge Assets
7. Personal Knowledge
8. Practice
9. Evaluation
10. Coaching
11. Personalization
12. Band Framework & Progression
13. Review & Revision
14. Assessment History
15. Progress & Analytics
16. Search & Resource Center
17. Subscription
18. Content / Colab
19. Administration
20. Study Orchestration
21. Notification
22. Evaluation Governance
23. Quality & Economics Operations

Capability identity and exact meanings remain in `03-features.md`.

## Architecture principle: buy the platform, build the learning system

LenBands is a **modular application**, not a collection of services by default.

```text
Web browser
   |
   v
Next.js web + same-origin application API
   |
   +--> managed identity
   +--> managed Postgres / object storage
   +--> durable managed workflow for long-running jobs
   +--> governed model/speech provider adapters
   +--> managed email/billing/analytics adapters
```

The provider-neutral design rule is:

> Build LenBands semantics; buy commodity infrastructure.

LenBands builds the parts that form differentiated product IP:

- IELTS taxonomy/rubric/evidence semantics;
- target-profile semantics;
- content and assessment versioning;
- learner evidence/uncertainty/transfer/retention model;
- remediation and recommendation policy;
- evaluation normalization, score scope and benchmark policy;
- thin application orchestration;
- product authorization/RLS policy;
- learner, Colab and Admin experience.

LenBands does **not** build a password system, payment processor, database cluster, Redis/Kafka platform, workflow engine, generic analytics/flag system, model-serving fleet, search cluster or custom observability platform without measured evidence that a managed capability is insufficient.

## Runtime composition

### Request path

The default synchronous path is one TypeScript/Next.js application boundary. Adding a network service is an architectural change, not the default answer to a new domain.

### Long-running work

Evaluation and other multi-step work execute through a durable managed workflow. Canonical domain state remains in Postgres. Workflow state may coordinate execution but does not become the score, submission, entitlement or content source of truth.

Every durable side effect is idempotent because workflows, provider callbacks and webhooks can retry.

### Data

- Managed Postgres is the primary relational source of truth.
- Object storage holds large private/public assets through versioned opaque references.
- Row-level/database policies provide defense in depth; application authorization remains required for sensitive operations.
- No Redis, Kafka, vector database or secondary search system exists until measured requirements justify one.
- Search begins with Postgres-native search.
- A model provider response, embedding index, cache entry or workflow payload is never canonical learner state.

### Identity and access

Five web personas exist: Guest, Learner, Premium Learner, Colab and Admin.

Security identity is intentionally smaller:

- unauthenticated guest;
- `learner`;
- `colab`;
- `admin`;
- function-scoped internal service principals for callbacks/workflows/jobs.

Premium Learner is a learner with a `premium` entitlement, not a separate role.

Colab and Admin are separate duties. Neither is an implicit super-role over learner assessment content. Admin does not manually override learner scores; Colab does not score learner work.

A production implementation must not treat one generic `service` credential as blanket authorization. Evaluation workers, billing/webhook handlers, content jobs and workflow callbacks receive the minimum function/data scope required for their contract even when the underlying identity mechanism is shared.

Canonical details live in `artifacts/engineering/api/access-control.md`.

## API boundary

There is exactly one canonical web API:

`artifacts/engineering/api/openapi.yaml`.

Legacy split OpenAPI files are migration-only and cannot receive new authority. Auth provider endpoints are external to the LenBands API; LenBands verifies identity and enforces product authorization server-side.

Every API operation declares persona, role, entitlement, data class and idempotency policy.

## Deterministic domain core and intelligence boundary

LenBands is **deterministic-first**, not model-first.

A capability must use the cheapest and most testable mechanism that satisfies its correctness/quality contract. Model/speech inference is permitted only for the portion that requires semantic judgment, open-ended language generation, transcription, or acoustic analysis that deterministic mechanisms cannot adequately provide.

Default decision ladder:

```text
Typed rule / formula / state machine / answer key / SQL
  ↓ insufficient for required outcome
Precomputed or governed reusable knowledge
  ↓ insufficient
Bounded small/specialist model
  ↓ insufficient confidence or high-risk judgment
Benchmark-approved stronger/specialist model
  ↓ unavailable / invalid
Safe degraded state or durable retry
```

Deterministic/domain-owned by default:

- authorization, RLS policy, entitlement and billing reconciliation;
- IELTS score arithmetic and score-scope rules;
- Listening/Reading answer-key scoring and answer normalization where an objective key exists;
- word count, timers, autosave, idempotency and runtime state;
- FSRS scheduling;
- item exposure tracking and evidence-admission rules;
- readiness policy and the conditions under which evidence may update readiness;
- P0 Next Best Action candidate generation/ranking when explicit rules satisfy the contract;
- notification quiet hours/frequency caps;
- content schema validation, controlled vocabulary, lifecycle and publish gates;
- analytics aggregation, cost accounting and quota enforcement.

Model/speech-assisted only where justified:

- Writing rubric judgment that cannot be derived deterministically;
- Speaking discourse/rubric judgment;
- speech-to-text and specialist pronunciation/acoustic analysis;
- contextual tutor/open-ended explanations when reusable content is insufficient;
- bounded rewrite/generation;
- offline auto-tag suggestions subject to content review;
- natural-language rendering of already-derived facts when templating is insufficient.

### Authority rule

A model/speech adapter may produce a typed **observation**, **feature**, **candidate judgment**, or **generated explanation**. The owning domain contract decides whether that output is valid, admissible evidence, and allowed to change learner state.

```text
provider output
  -> schema validation
  -> provenance/version binding
  -> domain evidence/quality validation
  -> accepted observation/result OR rejected/limited state
  -> governed learner-state transition
```

A prompt, agent, provider, or raw confidence value may never directly authorize access, publish content, grant entitlement, define curriculum truth, or declare readiness/mastery.

## Evaluation boundary

Evaluation is a high-risk product domain.

```text
submission snapshot
  -> durable workflow
  -> deterministic pre-check/features
  -> scorer route version
  -> model/speech provider adapter(s)
  -> structured output normalization
  -> rubric/evidence validation
  -> quality/evidence state
  -> immutable evaluation result
```

A model-provider outage cannot silently change score semantics. Learner-visible scoring may fall back only to a model/provider combination benchmark-approved for the same scorer route version. Otherwise the evaluation remains delayed/unavailable.

Writing/Speaking/Pronunciation should be **staged pipelines** where the construct benefits from separable evidence. One opaque model call must not collapse distinguishable evidence such as transcript, timing/fluency features, acoustic pronunciation evidence, rubric judgment and result validation when those distinctions materially affect auditability or quality.

The following identities never collapse:

- official IELTS score;
- LenBands exam-simulation estimate;
- partial/task diagnostic estimate;
- criterion/micro-skill evidence;
- learner-model mastery/readiness state.

## Learning evidence boundary

A completed activity is not mastery.

```text
Diagnose
  -> Understand
  -> Guided Practice
  -> Independent Practice
  -> Retest
  -> Transfer
  -> Maintain
```

Repeated/revealed items may support learning but do not create independent transfer evidence. FSRS schedules review; it is not a universal mastery model.

A recommendation engine cannot convert model-generated narrative into mastery. Mastery/readiness updates require admissible evidence under the learner-evidence policy.

## Runtime state model

Learner runtime state is multi-axis, not one giant status enum:

```text
Lifecycle:  new -> diagnosed -> active <-> inactive -> reactivated
Session:    none -> active <-> paused -> completed | abandoned
Operation:  none -> accepted -> processing -> succeeded | delayed |
            unavailable | failed | cancelled
Goal:       no_goal -> goal_set -> on_track | at_risk -> achieved | expired
```

Evaluation result validity is separate from operation state:

```text
Result validity:
  accepted | limited_evidence | insufficient_evidence | invalid | integrity_review
```

This separation prevents transport/processing state from being confused with whether a result is trustworthy enough for readiness/history.

Skill/evidence state is tracked separately per construct and includes uncertainty, evidence independence, exposure, transfer and maintenance where applicable.

## Reliability invariants

- canonical writes are durable before a learner is told they succeeded;
- mutations with durable side effects are idempotent;
- external callbacks and workflows are treated as replayable;
- task/content versions referenced by assessment evidence are immutable;
- cache/analytics/workflow/provider state never authorizes access or replaces canonical state;
- raw learner assessment content never enters general logs or analytics;
- every provider boundary has timeout, schema validation, minimum-data transfer, cost attribution and user-safe degradation;
- provider names never enter capability IDs, domain event names or score meaning;
- model context is minimized to the task plus the smallest relevant learner-state snapshot required for the operation;
- retry happens in one owning layer only and cannot duplicate learner-visible effects or charges.

## Build-versus-buy change gate

A new custom runtime/service/platform component requires evidence for at least one:

1. the managed capability cannot meet an explicit correctness/security/SLO contract;
2. measured cost exceeds the governed threshold after realistic volume;
3. compliance/data-residency requires another boundary;
4. the capability has become demonstrably differentiating IP;
5. provider lock-in cannot be contained by the existing adapter/export contract.

“More control”, anticipated scale, developer preference, or “AI needs its own service” alone is not sufficient.

## Cost architecture invariants

Cost is optimized against learner outcome and required quality, not raw request count.

- compute deterministic facts once and reuse them;
- precompute reusable curriculum/explanation/mapping outputs when versionable;
- batch noninteractive model work;
- escalate models only when uncertainty/risk justifies the marginal cost;
- degrade optional feedback depth before evaluation integrity;
- keep context bounded and privacy-minimized;
- measure `cost_per_evaluation`, `cost_per_active_learner`, and `cost_per_verified_improvement` together with quality/learning outcomes;
- a cheaper route that reduces verified learning value or scoring quality is not an optimization.

## Canonical cross-references

- Product: `01-product.md`
- Capabilities: `03-features.md`
- Experience: `04-experience.md`
- Content: `05-content.md`
- Engines/learning policy: `06-engines.md`
- API: `artifacts/engineering/api/openapi.yaml`
- Access: `artifacts/engineering/api/access-control.md`
- Sourcing: `artifacts/business/decisions/platform-sourcing.md`
- BOPS: `artifacts/operations/bops/contract.yaml`
- Document authority: `DOCS.yaml`
