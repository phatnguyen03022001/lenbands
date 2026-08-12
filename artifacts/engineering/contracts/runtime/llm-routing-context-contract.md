# LLM Routing & Context Contract — P0

## Scope and non-goals

P0 uses an LLM only for `EVAL.Writing` in the outcome loop. Autosave, entitlement, FSRS, retry decisions, the Daily Plan baseline, and quota checks are deterministic; do not call a model merely to create an “AI-first” impression.

Provider/model names are not in the contract. `evaluation_primary` or `evaluation_fallback` points only to an adapter that has passed the benchmark, privacy review, and cost gate.

## Route table

| Workload | Route | Context / output budget | Cache | Fallback |
|---|---|---|---|---|
| Draft autosave | deterministic storage | n/a | n/a | local-first sync |
| Submission validation/quota | deterministic Go domain rule | n/a | n/a | action_required |
| Writing evaluation | `evaluation_primary` | target 4k in / 1.5k out; hard max 6k in / 2k out | cache only accepted normalized evaluation summary by version | delayed queue; approved fallback route only |
| Feedback priority/Error Graph | same accepted evaluation output + deterministic ranking | no second LLM call | cache accepted result | show evidence/result state |
| Daily action P0 | deterministic rules | n/a | 5m deterministic cache | max 3 explained alternatives |
| Benchmark/dual-run | isolated async route | controlled corpus budget | no learner-result cache | benchmark failure blocks route |

`in` and `out` are token budgets after normalization. A submission over hard input envelope is not silently truncated: it remains a draft and receives an action to shorten or split according to a future approved UX rule.

## Context assembly

```text
published task version
  + rubric version
  + learner submission text
  + minimal error-taxonomy/rule version
  + prompt-template ID + hash
  → versioned evaluation request
```

- Include only content necessary for the current task; do not append full learner history, profile, other essays or unrelated Knowledge Assets.
- Context builder records reference/version/token count, not full raw prompt in general telemetry.
- Prompt template and rubric are controlled artifacts/approved knowledge inputs. Prompt body is not copied into runtime data or learner response.
- Model output must validate against Evaluation Contract schema. Schema failure is `EVALUATION_UNAVAILABLE`/retryable according to Failure Contract, never a best-effort learner score.
- Do not request, store, show or log chain-of-thought. Learner receives concise evidence, rubric-linked explanation and next action only.

## Preflight and routing guard

1. Verify authenticated subject, entitlement, submission state and idempotency.
2. Measure normalized token estimate; enforce hard context/output envelope before provider call.
3. Check per-subject concurrency, quota, cost bucket and circuit state.
4. Select route only if its adapter/model/rubric/prompt tuple has an active benchmark approval for this contract version.
5. Enqueue one durable job. Worker records actual usage and validates structured output before accepting result.

If any guard fails, preserve the submission and return `action_required`, `delayed` or `unavailable` according to Failure Contract. It does not silently downgrade to an unbenchmarked cheap model.

## Cost and quality constraints

- One accepted P0 Writing evaluation permits one bounded provider attempt; job retry is controlled by Worker Contract and counts toward cost attribution.
- A retry caused by internal failure must not create an additional learner submission or charge. Actual provider bill may be absorbed by reserve; this is measured separately.
- Prompt/model/rubric/context change requires benchmark regression, scenario recalculation and release gate review.
- Large-model escalation is prohibited for P0 unless the candidate route is benchmarked and stays under the founder-approved hard ceiling. Until `cost-budget.md` has a non-empty approved ceiling, the route is blocked rather than treated as protected by a live guardrail.

## Acceptance conditions

- One accepted submission produces no more than one active evaluation job and no unbounded model retry.
- Normal Writing Task 2 evaluation stays within token envelope without hidden truncation.
- Every accepted result can be traced to contract/rubric/prompt-hash/model-version/usage, while learner-facing output contains no provider internals.
- Route disable/circuit open produces retained submission + useful delayed/unavailable UX, not a fake score.
