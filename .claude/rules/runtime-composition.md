---
paths:
  - "apps/**/*"
  - "services/**/*"
  - "engines/**/*"
  - "packages/**/*"
---

# Runtime composition rules

- These rules never authorize source edits. Authorization is governed separately by `artifacts/operations/implementation-eligibility.yaml` and the trust policy.
- Application code implements canonical LenBands contracts; it does not redefine product, IELTS, API, privacy, evidence, or failure semantics.
- Read `DOCS.yaml` first. Runtime invariants come from `artifacts/engineering/runtime-contract.yaml`; provider/build-buy choices come from `platform-sourcing.md`.
- Prefer the smallest managed composition. A programming language, framework, service, queue, cache, worker, database host, search/vector engine, or deployment platform is an adapter choice, not a domain invariant.
- Do not implement commodity auth, workflow, queue, scheduler, retry, cache, logging, analytics, feature-flag, billing, email, search, storage, or observability frameworks when a reviewed managed capability satisfies the contract.
- Add provider contract tests and versioned configuration rather than provider branches inside IELTS or learning logic.
- Generate/consume the resolved typed API projection when implementing HTTP boundaries; do not code against generic `JsonObject` authoring placeholders.
- Raw essay/audio/transcript/error/prompt/provider content must not enter general analytics, logs, events, or alerts.
- Runtime outputs never create acceptance/benchmark/readiness evidence by assertion.
