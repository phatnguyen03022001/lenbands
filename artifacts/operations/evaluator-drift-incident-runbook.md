# Evaluator Drift Incident Runbook

## Trigger

Activate when benchmark regression exceeds the approved threshold, evidence coverage decreases, a high-confidence result is no longer safe, or a prompt/model/provider change breaks contract mapping. When the threshold/corpus has not been approved by the founder, the status is `not_armed` and the route must not be deployed; do not describe it as a running detector.

## Response

1. Write an immutable incident snapshot with capability, model/prompt/rubric versions, and metric delta; do not write raw learner essays.
2. Freeze promotion and disable the affected route with a feature flag/kill switch.
3. Route to the baseline adapter/model or a safe low-confidence response according to the Evaluation Contract.
4. Triage failure cases into a regression set; retain the dataset/provenance separately.
5. Run benchmark comparison and a cost scenario before proposing reopen.
6. The founder/quality owner decides whether to rollback, hold, or promote; the decision references incident evidence.

## Exit criteria

- Root cause and affected versions are recorded.
- Baseline/fallback works without losing submission/history.
- Regression benchmark meets the approved threshold.
- Release record has an approver, rollout cohort, and rollback decision.

## References

- `artifacts/operations/release-gate.md`.
- `artifacts/operations/evaluation-benchmark-spec.md`.
- `artifacts/engineering/contracts/runtime/provider-adapter-contract.md`.
