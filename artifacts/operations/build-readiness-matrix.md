# Build Readiness Matrix

## Purpose

This operational projection tells founders/agents which P0 capability packs have enough input to move into Source Code. It does not replace the Capability Catalog or P0 Capability Profile Matrix in the Blueprint.

**Scope:** only the six closed-pilot packs `P0-01` → `P0-06` in `blueprint/03-features.md`. Listening, Reading, Speaking, Mock Test, and Exam Readiness must not be added to this matrix until the roadmap expands scope through an evidence-backed decision.

**Re-audit update 2026-08-07:** semantic-contract remediation ran across framework/KA/event/failure/OpenAPI validators; no pack changed state. P0 remains `not ready` because founder approval and real evidence are still missing.

**Knowledge OS hardening update 2026-08-07:** P0 capability families now have typed seeds in `artifacts/operations/capability-manifest.yaml`, and the semantic validator checks manifest coverage/reference resolution. This is graph/compiler preparation and does not promote any pack to `ready`.

**Benchmark/acceptance hardening update 2026-08-07:** benchmark intake, candidate numeric policy, P0 acceptance manifest, and executable runners exist. The corpus remains `missing`, policy remains `unarmed`, and no runtime result/evidence exists; therefore P0-04/P0-05/P0-06 remain `not ready`.

## Status conventions

- `missing`: required artifact/contract does not exist.
- `draft`: exists but has not been reviewed.
- `review`: content is sufficient for founder review, but founder approval or real evidence is still pending.
- `approved`: eligible as input to the next step.
- `n/a`: not applicable to the slice.

## Current matrix — closed pilot

| P0 pack | Capability backbone | Behavior/design | Product spec | Engineering contracts | Quality / ops | Acceptance run | Build state |
|---|---|---|---|---|---|---|---|
| P0-01 Identity | `IDENTITY.Auth`, `IDENTITY.Profile`, `IDENTITY.Privacy` | interaction + P0 experience contract: draft | Identity & Consent: draft | auth-identity-contract + privacy/data boundary: review; founder approval pending | privacy/data boundary: draft | not run | not ready — provider/DPA and end-to-end acceptance evidence missing |
| P0-02 Diagnosis | `GOAL.Target`, `PLACE.Test`, `PLACE.BandEstimation`, `PLACE.GapDetection`, `PLACE.InitialPath`, `PLACE.SkillDiagnosis`, `BAND.Current` | interaction + P0 experience contract + first-day wireframe: draft | Placement & Plan: draft | **placement-diagnosis-contract: review; founder approval pending** | placement quality gate: review; founder approval pending | not run | not ready — calibration and acceptance evidence missing |
| P0-03 Daily action | `STUDY.DailyPlan`, `STUDY.CheckIn`, `STUDY.MicroSession`, `PERSONAL.NextBestAction` | interaction + P0 experience contract + daily wireframe: draft | Today & Daily Action: draft | **daily-action-contract: review; founder approval pending** | deterministic fallback: draft | not run | not ready — acceptance run and founder approval pending |
| P0-04 Writing evaluation | `LEARN.Writing`, `EVAL.Writing`, `COACH.ErrorAnalysis`, `COACH.Feedback`, `PKM.Drafts` | interaction + P0 experience contract + full-app wireframe: draft | Writing Task 2: draft | **interaction/writing-task-2.md** + **runtime-spec.md** + OpenAPI/data/event/failure + **evaluation-contract.md (new)** + LLM/runtime pack + semantic validator: review; founder approval pending | benchmark, cost, release gate: review; benchmark evidence pending | run-006 is pipeline revalidation only | not ready — interaction/runtime contracts are candidates, evidence still pending |
| P0-05 Error-to-review | `REVIEW.MistakeNotebook`, `REVIEW.FSRS`, `REVIEW.SmartQueue`, `PRACTICE.Drill` | interaction + P0 experience contract + **error-to-review vertical slice (new)**: review | **error-to-review/data+event+failure contracts (new)**: review; founder approval pending | error-to-review contract pack + shared writing + Error Graph projection: review candidate | FSRS + retest acceptance (data contract): draft | run-006 is pipeline revalidation only | not ready — founder approval and acceptance run pending |
| P0-06 Quality & economics | `OPS.CostBudget`, `OPS.ModelRouting`, `OPS.Quota`, `OPS.Observability`, `OPS.ReleaseGate`, `OPS.EvaluationQuality`, `OPS.ContentQuality`, `OPS.OutcomeMeasurement`, `GOVERNANCE.ConfidenceScore`, `GOVERNANCE.AuditTrail` | **governance-ops-dashboard spec (new)**: review; founder approval pending | operational policy: review candidate | event-schema-pack + evaluation-contract + **quota-usage-contract (new)** + observability/runtime pack: review candidate | cost, content, benchmark, release, exit exercise: review; external evidence pending | not run | not ready — founder approval and gold-standard corpus pending |

## Gate

A P0 row becomes `ready` only when:

- The Blueprint Capability Profile is complete.
- The Capability Manifest row resolves the correct capability IDs, events, artifacts, cost boundary, privacy class, and blockers.
- Interaction + Screen behavior is `approved`.
- Vertical Slice Spec is `approved`.
- Required API/data/event/failure/prompt contracts are `approved`.
- Acceptance tests have an owner and can run.
- Privacy, quality, and cost gates are no longer `missing`.
- If the row includes learner-visible evaluation or a rights claim, real evidence/run is referenced according to `CONVENTION.md` §6 rather than merely described in prose.

Write `ready` only when required artifacts are `approved` and every mandatory piece of evidence exists and is referenced by an immutable record.

A closed pilot becomes `ready` only when **all P0-01 → P0-06** are `ready`; a missing pack cannot be offset by polished UI or working code elsewhere.

## Cross-pack dependencies (silent)

- **P0-04 (Writing)** uses a `WritingTask` seeded through the content-publish contract; this is a shared input/content-quality gate, not full `CONTENT.Publish` product scope.
- **P0-04/P0-05** depend on the **quota-usage-contract** — free/premium boundaries determine what happens when a learner hits a usage wall.
- **P0-06** depends on the **governance-ops-dashboard** — the founder needs an operational calibration surface during the pilot.
- These dependencies already have contracts in `review`; readiness still depends on founder approval and real evidence such as a gold-standard corpus and a published task batch.

## Update rule

- Update this matrix whenever an artifact changes status.
- A Blueprint semantic change returns the affected row to `review`.
- Do not use this matrix to redefine capability identity, scope, or product decisions.
- `not run` is not a failure; it is the truthful state before Source Code, benchmark, or pilot execution exists.
