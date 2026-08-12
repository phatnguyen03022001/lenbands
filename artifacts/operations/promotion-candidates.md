# Promotion Candidates — Founder Review

## Purpose

This is a promotion proposal patch after the artifact content has been reviewed. The agent may move metadata to `review`; only the founder may move it to `approved` and record the approval.

## Bucket A — proposed `approved` after founder review

The artifacts below do not themselves claim benchmark results, rights clearance, or learner outcomes. Before moving `review → approved`, the founder must check purpose, owner, traceability, failure/privacy boundaries, and the approval record:

- Writing Task 2: `openapi.yaml`, `data-contract.md`, `event-contract.md`, `failure-contract.md`.
- Error-to-Review: `data-contract.md`, `event-contract.md`, `failure-contract.md`.
- `quota-usage-contract.md`.
- Operations: `release-gate.md`, `placement-quality-gate.md`.
- Runtime: API governance, async job worker, cache, LLM routing/context, observability SLO, outbox reconciliation, provider adapter, failure taxonomy.
- P0-02/P0-03: `placement-diagnosis-contract.md`, `daily-action-contract.md`.

## Bucket B — retain `review` pending real evidence

| Artifact | Missing evidence | Blocker |
|---|---|---|
| `writing_evaluation_v1.md` | Benchmark regression, cost scenario, acceptance boxes | Do not deploy the prompt/model/rubric route |
| Writing `evaluation-contract.md` | Approved threshold and benchmark run | Do not claim calibrated evaluation |
| `evaluation-benchmark-spec.md` | Gold-standard corpus, numeric threshold, run record | Do not promote the quality result |
| `exit-exercise-spec.md` | Real Exercise A/B run, restore/provider switch evidence | Do not approve the Build/Buy exit decision |
| `auth-identity-contract.md` | Provider/DPA boundary, permission and export/delete exercise | P0-01 remains not ready |
| `governance-ops-dashboard.md` | Gold-standard corpus and governance metric run | Do not treat the dashboard stub as a live control |

## Rule

No artifact in this file is considered `approved` merely because the agent added it to the list. Founder approval must appear in each artifact's metadata/approval record.

## References

- `artifacts/CONVENTION.md` §6 — approval and evidence boundary.
- `artifacts/operations/founder-agent-governance-workflow.md` — founder/agent authority.
