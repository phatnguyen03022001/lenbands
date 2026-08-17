# Probabilistic Inference Routing & Context Contract — P0

The filename is retained for compatibility, but this contract governs the P0 **probabilistic inference route**, not a general LLM-first application architecture.

## Scope and authority

P0 uses a generative model only for the semantic-inference portion of `EVAL.Writing` in the outcome loop. Autosave, authentication/authorization, entitlement, idempotency, FSRS, retry eligibility, Daily Plan/NextBestAction, quota, route selection, feedback priority, score aggregation, quality-state decisions and learner-facing presentation are deterministic.

The canonical compute-mode projection is `artifacts/operations/execution-policy.yaml`. It cannot create semantics or decision units; this routing contract may only operationalize an already-declared compute boundary.

Provider/model names are not in the domain contract. `evaluation_primary` or `evaluation_fallback` points only to an adapter tuple that has passed the benchmark, privacy review, cost gate and release policy for the same scorer-route version.

## P0 route table

| Workload | Compute | Context / output budget | Cache | Fallback |
|---|---|---|---|---|
| Draft autosave | deterministic storage | n/a | n/a | local-first sync |
| Submission validation/quota | deterministic domain rules | n/a | n/a | action_required |
| Writing semantic inference | `evaluation_primary` governed generative route | target 4k in / 1.5k out; hard max 6k in / 2k out | cache only accepted normalized evaluation summary by version | delayed/unavailable; approved fallback route only |
| Evidence-reference/taxonomy/criterion validation | deterministic | no provider context | accepted candidate only | invalid/insufficient_evidence |
| Score aggregation + quality-state decision | deterministic | no provider context | canonical result | low_confidence/insufficient_evidence/invalid |
| Feedback priority/Error Graph | deterministic ranking over accepted evaluation facts | no second model call | accepted result | show structured evidence/result state |
| Learner-facing explanation wording | deterministic templates over accepted facts | no provider context and no second P0 model call | accepted result | structured facts remain usable |
| Daily action P0 | deterministic rules | n/a | deterministic cache only | at most 3 reason-coded alternatives |
| Benchmark/dual-run | isolated governed inference route | controlled corpus budget | no learner-result cache | benchmark failure blocks promotion |

`in` and `out` are token budgets after normalization. A submission over the hard input envelope is not silently truncated: it remains preserved and receives a user-safe recovery action.

## Context assembly

```text
published task version
  + rubric version
  + learner submission snapshot
  + minimal controlled taxonomy/rule version
  + prompt-template ID + hash
  + scorer-route version
  -> versioned inference request
```

- Include only content necessary for the current task; do not append full learner history, profile, other essays or unrelated Knowledge Assets.
- Context builder records references, versions and token counts; full raw prompts do not enter general telemetry.
- Prompt template and rubric are controlled artifacts/approved knowledge inputs. Prompt body is not copied into learner-visible state.
- Do not request, store, expose or log chain-of-thought.

## Typed candidate inference and evidence provenance

A provider response is never a canonical evaluation by itself.

```text
provider response
  -> typed candidate inference
  -> bind rubric/task/prompt/route/model/assessment provenance
  -> bind evidence_refs to the immutable submission snapshot
  -> deterministic schema + evidence + taxonomy validation
  -> deterministic score aggregation
  -> deterministic quality-state decision
  -> canonical evaluation result
```

The candidate must carry the provenance required by `evaluation-contract.md`, including rubric version, task version, prompt-template hash, scorer/model route version, assessment mode, evidence refs and confidence state. Missing or invalid provenance is `invalid`/`insufficient_evidence`; it is not repaired by best-effort scoring.

P0 learner-facing explanation text is rendered deterministically from accepted structured facts. Future generative wording is an optional presentation enhancement only and requires an explicit governed compute-mode change; it cannot change criterion findings, error IDs, scores, evidence, action priority or readiness state.

## Preflight and route-selection guard

1. Verify authenticated subject, authorization, entitlement, submission state and idempotency.
2. Measure normalized token estimate; enforce the hard input/output envelope before provider transfer.
3. Check per-subject concurrency, quota, cost bucket and circuit state deterministically.
4. Determine eligible routes from benchmark/release evidence.
5. Select the route using the deterministic `quality.model_route_selection` policy.
6. Start one durable managed workflow for the accepted inference request.
7. Record actual usage and validate the typed candidate before any canonical result mutation.

If a guard fails, preserve the submission and return `action_required`, `delayed` or `unavailable` according to the failure contract. Never silently substitute an unbenchmarked model or a different compute mode.

## Retry, fallback and cost

- One accepted P0 Writing evaluation has a bounded provider-attempt policy; durable workflow retry follows the canonical runtime contract and remains idempotent.
- An internal retry does not create another learner submission or learner charge.
- Provider fallback is allowed only among benchmark-approved combinations inside the same scorer-route version.
- A provider outage never opens a model route for deterministic workloads such as Daily Action, quota, FSRS, feedback ranking or presentation.
- Prompt/model/rubric/context changes require benchmark regression and release-gate review.
- Large-model escalation is prohibited unless the candidate route is benchmarked and satisfies the founder-approved cost policy.

## Acceptance conditions

- P0 Daily Action and NextBestAction perform zero model calls.
- One accepted Writing submission creates no unbounded inference retry.
- Every candidate inference is traceable to rubric/task/prompt/route/model/evidence provenance.
- No candidate inference can directly mutate canonical score, error, readiness, entitlement or quota state.
- Feedback priority and learner-facing presentation perform no second model inference.
- Presentation failure leaves canonical structured facts usable.
- Route disable/circuit open produces retained submission + useful delayed/unavailable UX, never a fake score.
