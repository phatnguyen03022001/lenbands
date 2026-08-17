# 02 — System Architecture

This document owns LenBands system boundaries, domain map, architecture invariants and runtime-state model. Provider selection belongs to `artifacts/business/decisions/platform-sourcing.md`; HTTP operations belong to the canonical OpenAPI contract.

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
   +--> governed model-provider gateway/adapter
   +--> managed email/billing/analytics adapters
```

The provider-neutral design rule is:

> Build LenBands semantics; buy commodity infrastructure.

LenBands builds the parts that form differentiated product IP:

- IELTS taxonomy/rubric/evidence semantics;
- content and assessment versioning;
- learner evidence/transfer/retention model;
- adaptive/recommendation policy;
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

### Identity and access

Five web personas exist: Guest, Learner, Premium Learner, Colab and Admin.

Security identity is intentionally smaller:

- unauthenticated guest;
- `learner`;
- `colab`;
- `admin`;
- internal service principal for provider/workflow callbacks.

Premium Learner is a learner with a `premium` entitlement, not a separate role.

Colab and Admin are separate duties. Neither is an implicit super-role over learner assessment content. Admin does not manually override learner scores; Colab does not score learner work.

Canonical details live in `artifacts/engineering/api/access-control.md`.

## API boundary

There is exactly one canonical web API:

`artifacts/engineering/api/openapi.yaml`.

Legacy split OpenAPI files are migration-only and cannot receive new authority. Auth provider endpoints are external to the LenBands API; LenBands verifies identity and enforces product authorization server-side.

Every API operation declares persona, role, entitlement, data class and idempotency policy.

## Evaluation boundary

Evaluation is a high-risk product domain.

```text
submission snapshot
  -> durable workflow
  -> scorer route version
  -> model/provider adapter
  -> structured output normalization
  -> rubric/evidence validation
  -> quality state
  -> immutable evaluation result
```

A model-provider outage cannot silently change score semantics. Learner-visible scoring may fall back only to a model/provider combination benchmark-approved for the same scorer route version. Otherwise the evaluation remains delayed/unavailable.

The following identities never collapse:

- official IELTS score;
- LenBands exam-simulation estimate;
- partial/task diagnostic estimate;
- learner-model mastery.

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

## Runtime state model

Learner runtime state is multi-axis, not one giant status enum:

```text
Lifecycle:  new -> diagnosed -> active <-> inactive -> reactivated
Session:    none -> active <-> paused -> completed | abandoned
Evaluation: none -> submitted -> processing -> scored | low_confidence |
            insufficient_evidence | invalid | failed
Goal:       no_goal -> goal_set -> on_track | at_risk -> achieved | expired
```

Skill/evidence state is tracked separately per construct and includes uncertainty, evidence independence, transfer and maintenance where applicable.

## Reliability invariants

- canonical writes are durable before a learner is told they succeeded;
- mutations with durable side effects are idempotent;
- external callbacks and workflows are treated as replayable;
- task/content versions referenced by assessment evidence are immutable;
- cache/analytics/workflow state never authorizes access or replaces canonical state;
- raw learner assessment content never enters general logs or analytics;
- every provider boundary has timeout, schema validation, minimum-data transfer, cost attribution and user-safe degradation;
- provider names never enter capability IDs, domain event names or score meaning.

## Build-versus-buy change gate

A new custom runtime/service/platform component requires evidence for at least one:

1. the managed capability cannot meet an explicit correctness/security/SLO contract;
2. measured cost exceeds the governed threshold after realistic volume;
3. compliance/data-residency requires another boundary;
4. the capability has become demonstrably differentiating IP;
5. provider lock-in cannot be contained by the existing adapter/export contract.

“More control”, anticipated scale, or developer preference alone is not sufficient.

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
