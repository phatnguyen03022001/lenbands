# Release Gate — Product, Quality and Cost

## Purpose

Defines the minimum conditions for releasing a feature, content, model/prompt, or provider change. Do not release merely because the UI works.

## Gate levels

| Level | Applies to | Required approval |
|---|---|---|
| R0 | docs/internal prototype | owner self-review |
| R1 | closed pilot, no billing | product + engineering review |
| R2 | public learner feature | founder approval + quality/cost evidence |
| R3 | model/provider/privacy change | founder + engineering + privacy/legal review as needed |

## Universal checklist

- [ ] Capability Profile complete.
- [ ] Vertical Slice Spec and applicable contracts reviewed.
- [ ] Critical-path and recovery acceptance tests pass.
- [ ] Accessibility: keyboard, labels, state feedback, no color-only meaning.
- [ ] Privacy scope, retention and deletion behavior verified.
- [ ] Event/failure telemetry emits semantic, redacted records.
- [ ] Rollback/kill switch exists.

## Evaluation release checklist

- [ ] Benchmark result meets approved threshold.
- [ ] Evidence coverage and low-confidence behavior verified.
- [ ] Rubric/model/prompt versions captured in audit trace.
- [ ] No raw provider payload or hidden reasoning reaches learner/UI analytics.
- [ ] Cost budget and quota behavior pass under retry/delay.
- [ ] Drift/regression comparison completed against current release.

## Evidence ownership and rollback

| Gate item | Evidence owner | Required record |
|---|---|---|
| Benchmark threshold/result | Founder + quality | immutable benchmark run with corpus/rubric/model/prompt versions |
| Cost ceiling/quota | Founder + operations | provider pricing snapshot, reservation/retry scenario and approved ceiling |
| Privacy/redaction | Engineering + privacy | redaction/ownership/export-delete exercise |
| Rollout decision | Founder + engineering | cohort, kill-switch state and rollback record |

Rollback for an evaluation route means disable route/feature flag, retain submission, serve only `delayed`/`unavailable` safe state, and preserve prior accepted history with its original version. It does not silently substitute an unbenchmarked provider.

## Blocking conditions

- Missing evidence for a learner-visible finding.
- High-confidence score with failed benchmark or unknown calibration.
- Data loss/duplicate submission under retry.
- Privacy breach, raw content in telemetry, or unreviewed provider policy change.
- Cost above hard ceiling without approved exception.

## Release record

Each release creates an immutable record with capability refs, versions, benchmark result, cost projection, approver, rollout cohort and rollback decision. A blank cost ceiling or benchmark threshold is a blocking `review` condition, not a passing value.
