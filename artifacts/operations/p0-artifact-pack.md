# P0 Artifact Pack — Closed Pilot

## Purpose

This contract portfolio answers two questions without mixing them:

1. what must be defined so an agent can implement without inventing behavior;
2. what real evidence must exist before the closed pilot can serve learners.

It does not replace the Capability Catalog, Problem/Risk Registry, Implementation Eligibility contract, or Build Readiness Matrix.

## Usage rules

1. Capability IDs in `blueprint/03-features.md` remain canonical identities.
2. One Artifact may cover multiple packs when semantics are shared; avoid one-file-per-row bureaucracy.
3. Before implementation planning, filter `artifacts/operations/problem-risk-registry.yaml` to the target family.
4. An unresolved risk with `implementation_blocking=true` blocks implementation. `release_evidence_required=true` belongs to release readiness when the design contract already exists. `public_scale_control_required=true` is a broader-access gate.
5. Do not invent benchmark, legal, rights, runtime, user-research, acceptance or incident evidence.
6. Every inference-using pack first proves why deterministic/library/SQL/precomputed mechanisms are insufficient for that judgment.
7. Model output is a candidate judgment; domain validation/evidence admission remains authoritative.
8. Cost is evaluated against required quality and verified learner outcome, not token/request count alone.

## Required artifact/input classes

| Class | Purpose | Stage |
|---|---|---|
| Problem/risk coverage | classify applicable problem, owner, control and staged gate | before implementation planning |
| Interaction / vertical slice | entry, states, recovery, cross-domain handoff | before learner-flow implementation |
| Critical-path usability | accessibility + browser/network preservation semantics | before P0 UI/state implementation |
| API / data / event / failure | typed runtime semantics, idempotency, privacy, recovery | before affected source implementation |
| Data migration | additive/expand-contract, backfill, compatibility, projection rebuild | before persistent schema/backfill implementation |
| Evidence/result policy | observation vs validity vs evidence admission/readiness | before diagnosis/evaluation/retest implementation |
| Evaluation contract | staged judgment, validation, scorer routing and uncertainty | before subjective scorer implementation |
| Deterministic/inference decision | rules/library/precompute vs model boundary | before inference-using implementation |
| Operations/release design | quota, cost, observability, incident, restore, rollback | design before implementation; evidence before release |
| Rights/content design | provenance/right/version/exposure semantics | design before content pipeline; approved assets before release |
| Benchmark design | corpus classes, slice plan, metrics, threshold lifecycle | design before scorer approval |
| Benchmark run | authorized corpus + exact candidate-bound results | before learner-visible scorer release |
| Acceptance evidence | functional/privacy/idempotency/usability/outcome tests | before release readiness unless explicitly pre-code |

Do not create a second LLM architecture layer when canonical evaluation/runtime contracts already own inference semantics. Do not create one risk document per problem: the registry owns classification; the referenced contract owns the control.

## P0 pack requirements

| Pack | Outcome proof | Minimum design/contract set before source implementation | Additional evidence before closed-pilot release |
|---|---|---|---|
| P0-01 Identity | learner authenticates/consents; ownership is safe | risk coverage + experience + auth/access/privacy/retention + provider adapter/sourcing boundaries + critical-path usability | provider DPA/activation + legal pilot eligibility + export/delete + negative access/usability acceptance |
| P0-02 Diagnosis | useful baseline without false precision | risk coverage + TargetProfile + placement coverage/termination/result validity + deterministic scoring + time semantics + content-rights model | calibration/construct coverage + approved task/config rights + legal eligibility + usability acceptance |
| P0-03 Daily action | one reasoned useful action with fallback | risk coverage + compact evidence state + deterministic candidate/ranking policy + time semantics + session/API/failure + critical-path usability | deterministic/timezone/network/accessibility/outcome acceptance |
| P0-04 Writing evaluation | task-scoped evidence-backed feedback + priority fix | risk coverage + Writing slice + staged runtime/API/data/evaluation/event/failure + benchmark slice design + scorer route + support dispute + reproducibility + usability | rights-approved tasks + authorized gold corpus + required benchmark slices + privacy/idempotency/evidence/dispute/usability + legal eligibility |
| P0-05 Error-to-review | confirmed error receives smallest useful intervention and independent retest | risk coverage + remediation/retest policy + FSRS suitability + exposure/novelty + canonical mutations + time/usability semantics | scheduling + no-card-for-complex-skill + novel-retest + verified-improvement + access/usability acceptance |
| P0-06 Quality & economics | quality/privacy/outcome floor survives cost pressure | risk coverage + benchmark design + cost/routing/release/observability + migration/retention/incident/recovery/vendor-exit design | real benchmark + armed thresholds + cost/outcome + restore + incident tabletop + retention + rollback + legal eligibility evidence |

## P0 Writing non-negotiables

```text
deterministic eligibility
  -> primary approved scorer
  -> evidence/schema validation
  -> governed hard-case escalation only
  -> result_validity admission
  -> one actionable finding
  -> smallest useful fix
  -> optional retrievable review
  -> independent/novel retest
```

Active implementation semantics must not:

- treat `low_confidence` as submission/workflow state;
- expose raw model confidence as learner correctness probability;
- use migration-only OpenAPI as build authority;
- perform unconditional second-pass scoring;
- let model output directly set mastery/readiness;
- use AI-generated-text detection as cheating proof;
- create FSRS cards for complex Writing criteria solely because a score was low.

## Documentation-cost rule

Before spawning a new Artifact:

1. Does a canonical owner already own the semantic field?
2. Is this a new semantic owner or an executable/evidence boundary rather than another explanation?
3. Can an existing canonical owner be updated instead?
4. Does the file reduce agent inference more than it increases context and maintenance cost?

If not, do not create it.

## References

- Authority: `DOCS.yaml`.
- Risk coverage: `artifacts/operations/problem-risk-registry.yaml`.
- Implementation/release lifecycle: `artifacts/operations/implementation-eligibility.yaml`.
- Runtime/time/reproducibility: `artifacts/engineering/runtime-contract.yaml`.
- Data migration: `artifacts/engineering/data-migration-contract.yaml`.
- P0 accessibility/network: `artifacts/experience/critical-path-usability-contract.yaml`.
- Canonical web API: `artifacts/engineering/api/`.
- Current status: `artifacts/operations/build-readiness-matrix.md`.
