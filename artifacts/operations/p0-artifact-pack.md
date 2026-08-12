# P0 Artifact Pack — Closed Pilot

## Purpose

This is the contract portfolio for the closed pilot. It answers: **which Artifacts does a P0 capability pack need so an agent can code without inferring product behavior, privacy, quality, or cost rules?**

It does not create a Knowledge Asset, assign a default Artifact ID, or replace the Build Readiness Matrix. The matrix records actual status; this file defines only the required evidence/specification set.

Typed P0 capability objects are now seeded in `artifacts/operations/capability-manifest.yaml`. `tools/compile-capability.sh <CAPABILITY_ID|P0-XX>` reads that projection seed and prints the build context, evidence gaps and blockers for one family. Blueprint capability identity and product semantics remain authoritative; this pack and manifest are operational build context, not replacement SSOT.

## Usage rules

1. The Capability ID in `blueprint/03-features.md` is the canonical identity.
2. One Artifact may cover multiple P0 packs when behavior is shared; do not copy it to create one file per row.
3. Do not mark a pack `ready` because it has a wireframe. Behavior, data, failure, privacy, cost, and acceptance are all required.
4. Provider-specific contracts appear only after a build/buy decision selects a provider; the Blueprint does not know the vendor.
5. Do not invent benchmarks, legal clearance, user-interview findings, or acceptance runs. Anything not performed must be `not run`, `missing`, `draft`, or `review`.

## Required artifact classes

| Class | Purpose | When required |
|---|---|---|
| Interaction / design | Entry condition, intent, decision, state, recovery, and screen behavior | Every learner-facing pack; P0 must use `p0-experience-contract.md` |
| Vertical slice spec | Scope, role/permission, entry/exit, runtime boundary, acceptance | Every pack with new code |
| Data / API / event / failure contract | Cross-service semantics, idempotency, telemetry redaction, recovery | When a pack reads/writes runtime data or calls a service |
| Evaluation contract | Evidence, confidence, version, benchmark, and learner-safe messaging | Every learner-visible judgment/scoring |
| Decision record | Build/buy, irreversible boundary, or exception | When there is a hard-to-reverse choice |
| Operations gate | Cost, quota, observability, rollout, rollback | Every P0 pack; a shared gate may be used |
| Shared runtime foundation | HTTP/API lifecycle, cache, job/worker, outbox/reconciliation, observability, provider adapter | Every P0 pack with code; P0-04/P0-05 must use the full pack |
| Semantic contract validation | Cross-file SSOT resolution for failure codes, events, framework node types, lifecycle projections, and boundary enums | Every P0 pack with an event/failure/framework/runtime contract; static validators do not replace evidence |
| Capability manifest | Typed capability family object with inputs, outputs, states, events, data, metrics, cost/privacy, artifacts, and evidence blockers | Every closed-pilot P0 pack; future compiler input |
| Evidence record | Immutable external proof or immutable run record | When claiming rights, benchmark, procurement, or release results |
| Benchmark intake/run | Authorized corpus manifest, numeric policy, result schema and immutable run boundary | P0-04/P0-06 evaluation quality |
| Acceptance manifest/run | P0 test IDs, privacy/idempotency checks, and immutable runtime result | Every P0 pack before `ready` |

Asset spawn must also pass `operations/asset-spawn-freeze-gate.md`. The gate unlocks mass spawn only at `approved`; the maximum-7-asset validation exception is recorded separately in the gate and workflow.

## P0 pack definition of done

| Pack | Outcome proof | Minimum Artifact set before code | Additional gate before pilot |
|---|---|---|---|
| P0-01 Identity | Learner logs in, consent is clear, export/delete stays within permission | P0 experience contract; identity/privacy slice; permission + retention contract; auth build/buy decision; failure/acceptance spec | destructive-operation test record; provider/DPA evidence if a provider is selected |
| P0-02 Diagnosis | Baseline/goal creates a reasoned plan | P0 experience contract; diagnosis slice; **placement-diagnosis-contract**; score-confidence rule; no-data recovery | calibration/provisional label verified; placement acceptance run |
| P0-03 Daily action | One reasoned next action is easy to start and has a fallback | P0 experience contract; daily-action slice; **daily-action-contract**; deterministic recommendation decision rule; session/event/failure contract; state behavior | no-plan, stale-plan, resume, and retry acceptance run |
| P0-04 Writing evaluation | Writing receives feedback with evidence and one priority fix | P0 experience contract; Writing Task 2 slice; **interaction/writing-task-2.md**; **writing-task-2/runtime-spec.md**; OpenAPI, data, event, failure, evaluation, controlled prompt, LLM routing/context contracts; full runtime foundation; quota/cost/ops gate | benchmark run, redaction check, retry/idempotency, and low-confidence acceptance run |
| P0-05 Error-to-review | One error is fixed, reviewed, and retested with a recorded result | P0 experience contract; `vertical-slices/error-to-review.md`; error/review-card data rule; FSRS/retest acceptance rule; shared runtime foundation | review scheduling and retest outcome run; no-evidence/no-card guard verified |
| P0-06 Quality & economics | Features do not break trust, privacy, or the hard cost ceiling | benchmark spec; cost budget; release gate; observability/event/failure contracts; exit exercise spec | actual benchmark, cost projection, rollout/rollback record, and any required evidence |

## Shared artifact rule

Writing evaluation and error-to-review are one outcome loop, so the P0 pack may share a Vertical Slice Spec and engineering contracts. If Review later expands independently to Listening/Reading/Grammar, create a separate scope spec; do not silently expand the Writing contract.

## References

- Capability scope: `blueprint/03-features.md` § P0 Capability Profile Matrix.
- Typed capability seed: `artifacts/operations/capability-manifest.yaml`.
- Release scope: `blueprint/08-roadmap.md` § MVP rebaseline — Closed Pilot.
- Artifact lifecycle / approval: `artifacts/CONVENTION.md`.
- Current status: `artifacts/operations/build-readiness-matrix.md`.
