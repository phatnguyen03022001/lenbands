# Cost Budget — MVP Baseline

## Purpose

Set cost guardrails before enabling AI evaluation for users. This is a cost policy; the final numeric cap may be `approved` only after provider benchmarking and a pricing decision, and must not be invented before procurement.

**Current state: `unarmed/review`.** Empty numeric fields are blocking conditions, not zero, a default, or an active hard ceiling. No paid/public learner route may be inferred to be cost-protected from this file. The provider baseline and quota-protecting UX policy are in `artifacts/business/decisions/managed-platform-baseline-decision.md`; this does not replace numeric approval.

## Unit economics model

```text
Contribution per active learner
  = realized subscription revenue
  - payment/tax cost
  - inference + speech + storage + delivery cost
  - managed infrastructure allocation
```

Every capability must measure `cost_per_meaningful_outcome`, not only `cost_per_request`.

## P0 cost buckets

| Capability/boundary | Unit | Budget type | Required measurement | Fallback |
|---|---|---|---|---|
| `EVAL.Writing` | accepted submission | hard ceiling + warning threshold | inference, retry, evaluation success | delayed/retry; never lose submission |
| `LEARN.Writing` draft sync | active writer/day | soft ceiling | storage/write volume | debounce/local-first |
| `REVIEW.FSRS` | rating | near-zero ceiling | compute/storage | deterministic local/service rule |
| `PERSONAL.NextBestAction` | active learner/day | soft ceiling | model/rule invocation | deterministic rules |
| Auth/email | active account/month | hard ceiling | managed service spend | provider adapter |
| Observability/analytics | event volume | hard ceiling | ingestion/storage | sample/redact non-critical telemetry |

## Canonical cost-boundary IDs

The IDs below are boundary identifiers used in the P0 Capability Profile Matrix and runtime contracts. They are not evidence that the budget has founder approval; numeric approval remains in the gate table below.

| Boundary ID | Capability scope | State |
|---|---|---|
| `managed_auth_pilot` | `IDENTITY.Auth`, `IDENTITY.Profile`, `IDENTITY.Privacy` | policy name; numeric approval pending |
| `placement_pilot` | `PLACE.*`, `GOAL.*` in P0-02 | policy name; numeric approval pending |
| `rules_first` | `PERSONAL.NextBestAction` P0 deterministic path | policy name; numeric approval pending |
| `writing_eval_pilot` | `EVAL.Writing` provider/evaluation job | policy name; numeric approval pending |
| `deterministic_fsrs` | `REVIEW.FSRS` P0 scheduling | policy name; numeric approval pending |
| `quality_release_gate` | `OPS.*`/`GOVERNANCE.*` control plane | policy name; numeric approval pending |

## Numeric approval gate

Before public pilot, the founder must fill in each P0 bucket:

```yaml
warning_threshold:
hard_ceiling:
measurement_source:
provider_price_version:
owner:
review_frequency:
```

No evaluation capability may launch paid access without an approved hard ceiling and alert threshold.

## Routing rules

1. Validate, cache and deduplicate before model call.
2. Use deterministic/rule path before low-cost model; use high-cost path only when quality gate requires it.
3. Retry must keep idempotency key and charge attribution.
4. On budget breach, degrade non-critical detail before degrading data safety or core result integrity.
5. Cost regression is a release blocker when it exceeds hard ceiling without explicit founder approval.
6. Free-tier quota is an operations input, never a learner-facing failure mode: alert at verified consumption bands, protect admitted core work first, and use only truthful delayed/unavailable states when capacity is unavailable.
7. Provider pricing/limit facts are dated snapshots. Re-verify an active provider's official source at provisioning, at least every 30 days while free-tier-dependent, and on any price/limit incident.

## Spawn batch cost ceiling

The spawn batch is a hard-limited workflow, independent of learner quota:

```yaml
max_assets_per_validation_run: 7
max_llm_calls_per_asset: 1
max_llm_calls_per_run: 7
max_retries_per_asset: 0
on_ceiling: stop_batch_and_write_run_record
on_validation_failure: stop_batch; do_not_publish
```

The agent must validate the framework, dedup key, and input before calling the model. Retry must not automatically create a new asset/version. When any ceiling is reached, the batch stops, keeps created output at `draft`, and records an immutable run record; the founder decides whether to run the next batch/version.
