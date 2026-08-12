---
paths:
  - "apps/**/*"
  - "services/**/*"
  - "engines/**/*"
---

# Runtime composition rules

- These rules describe a dormant implementation capability. They do not authorize source
  edits. The repository-wide pre-code gate must be `implementation_authorized` first.
- Application code implements LenBands contracts; it does not redefine them.
- Go and Python backend code and Next.js frontend code must compose declared mature
  dependencies. Add an adapter around provider-specific APIs.
- Domain semantics cannot depend on an LLM provider, object store, cache, database host,
  browser automation vendor or deployment platform.
- Do not implement commodity cache, retry, queue, scheduler, DI, config, logging,
  validation, parser, auth, storage, search or workflow frameworks.
- Add provider contract tests and versioned configuration instead of provider branches
  inside IELTS domain logic.
- Learner essay/audio/error text must not enter analytics events or ordinary logs.
