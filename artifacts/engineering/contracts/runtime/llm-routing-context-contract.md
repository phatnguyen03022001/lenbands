# LLM Routing & Context Contract — P0

## Scope and non-goals

P0 uses an LLM only where open-ended rubric judgment materially requires inference, primarily `EVAL.Writing` in the first outcome slice. Autosave, authorization, entitlement, FSRS, retry ownership, Daily Action routing, quota and evidence admission remain deterministic/domain-owned.

Provider/model names are not product contract identities. A scorer route is eligible only when its adapter/model/rubric/prompt combination is benchmark-approved for the relevant use.

## Mechanism table

| Workload | Default mechanism | Inference boundary | Safe failure |
|---|---|---|---|
| Draft autosave | deterministic managed storage | none | preserve local/durable draft and reconcile |
| Submission validation/quota | deterministic domain rules | none | action-required / reject before provider cost |
| Writing evaluation | deterministic precheck + approved primary scorer | bounded task/rubric/essay context only | durable delayed/unavailable; approved compatible escalation only |
| Feedback priority/error mapping | admitted evaluation + deterministic mapping/ranking | optional wording/detail only | show structured evidence/action |
| Daily Action P0 | deterministic candidate/ranking policy | none | deterministic fallback/no-plan |
| Benchmark/dual-run | isolated approved evaluation workflow | controlled corpus only | benchmark failure blocks route promotion |

Token/context budgets may be configured as candidate values, but they are not product semantics. Oversized content is handled by an explicit input/UX policy; it is never silently truncated in a way that changes assessment meaning.

## Context assembly

```text
published task/version
  + rubric/version
  + immutable learner submission snapshot
  + scorer prompt template/version/hash
  + minimum operation-required context
  -> bounded provider request
```

Rules:

- include only content necessary for the current operation;
- do not append full learner history, arbitrary profile data, other essays or unrelated Knowledge Assets;
- TargetProfile may affect downstream planning/feedback relevance but does not bias rubric evidence judgment unless a separately governed operation explicitly requires it;
- context builder records opaque refs, versions and usage counts in general telemetry, not raw prompt/essay content;
- prompt/template and rubric are controlled inputs; learner content is delimited untrusted data;
- provider/model output is candidate data and must pass adapter + domain validation;
- do not request, store, display or log hidden chain-of-thought.

## Preflight and routing guard

Before a paid scorer call:

1. verify authenticated subject/internal function scope, ownership, task/submission state and idempotency;
2. verify rights/status/rubric/route eligibility;
3. enforce configured bounded input/output envelope without hidden truncation;
4. check quota/cost reservation and operation deadline;
5. select only a benchmark-approved route for learner-visible scoring;
6. create/use the canonical durable operation if work must outlive the HTTP request;
7. invoke the provider-neutral adapter with the minimum bounded payload.

No queue, worker fleet, Go/Python service, Redis or cache is implied by this contract. The managed execution mechanism is replaceable as long as canonical durable-operation semantics hold.

If a guard fails, preserve learner-created state and return the canonical safe action/delayed/unavailable behavior. Do not silently downgrade to an unbenchmarked cheaper model.

## Candidate output and admission

The LLM returns only the structured candidate fields defined by the scorer specialization. It does not author provider/model provenance, `result_validity`, readiness/mastery or authorization.

Runtime independently binds:

- scorer route version;
- provider/model identity;
- prompt template/revision/hash;
- rubric/task/submission versions;
- execution/usage/cost references.

The domain then validates evidence/schema/uncertainty/integrity and creates the immutable admitted result.

## Cost and quality constraints

- deterministic precheck always precedes inference;
- primary route is the cheapest approved route that meets the required quality floor;
- stronger route is bounded escalation for governed hard cases, not the default second pass;
- retries/escalations have one owner and hard ceilings;
- provider costs from internal failures are measured separately from learner logical charges;
- prompt/model/rubric/context changes that can affect scoring require benchmark regression before promotion;
- optional personalized prose must not mutate the already-admitted score/evidence truth;
- optimize downstream verified improvement and accepted evaluation economics rather than raw token minimization.

## Caching / reuse

No runtime cache is assumed. Reuse immutable governed results or precomputed remediation content when semantically valid. Introduce an actual cache only under the canonical runtime cache enablement rule: measured benefit + reviewed invalidation model + semantics unchanged on cache outage.

## Acceptance conditions

- deterministic precheck can reject ineligible input with zero scorer calls;
- ordinary Writing evaluation uses the approved primary route without unconditional second pass;
- every admitted result is traceable to task/rubric/prompt/route/provider/model/usage identity outside generated content;
- route disable/provider outage preserves learner submission and yields useful delayed/unavailable UX;
- full learner history is absent from scorer context unless a future operation explicitly proves it necessary;
- no hidden truncation changes assessed content;
- provider/model output cannot directly set `result_validity`, readiness or entitlement.
