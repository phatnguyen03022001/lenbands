# Knowledge OS Score Rubric

## Purpose

This rubric defines what `10/10` means for Blueprint and Artifact quality. It prevents score inflation from clean prose, folder hygiene or unverified claims.

The target is not "more documentation". The target is a repository where an agent can compile a capability into build inputs, detect semantic drift and distinguish verified evidence from planned controls.

## Scoring ceilings

These ceilings apply before the detailed score is calculated.

| Condition | Maximum score |
|---|---:|
| No typed semantic validator for the layer | 8.0 |
| Generated projection has no real generator or source hash | 8.2 |
| Evaluation quality has no gold corpus and benchmark run | 8.0 |
| Cost/quality gate has policy text but no approved numeric threshold | 8.3 |
| Capability is spread across documents without a manifest or graph node | 8.4 |
| Approved/published claim has no immutable evidence record | 7.5 |
| Validator passes while a known semantic drift remains | 7.2 |

The ceiling is applied to the affected layer, not automatically to the whole repo. If a P0 capability depends on the affected layer, its readiness remains blocked.

## Blueprint rubric

| Criterion | Weight | 10/10 requirement |
|---|---:|---|
| Capability canon | 15 | Every active/build-candidate capability has a typed manifest with inputs, outputs, states, APIs, events, knowledge, metrics, cost, privacy and evidence gates. |
| Semantic graph | 15 | Capability, framework, event, data, API, artifact, metric and evidence nodes are connected by typed edges that can be queried without opening arbitrary prose files. |
| Executability | 15 | A compiler can produce the required artifact family and readiness gaps from Blueprint/manifests without model inference. |
| Domain depth | 15 | IELTS criteria, errors, microskills, grammar, task types, assets and assessment outcomes resolve through controlled vocabulary and typed references. |
| Event/data invariants | 10 | Event producers/consumers, data entities, state transitions and privacy classes resolve across Blueprint and contracts. |
| Quality measurability | 10 | Quality bars have numeric thresholds, evidence requirements and explicit unarmed states when data is missing. |
| Roadmap honesty | 10 | Phase, scope and readiness are generated or mechanically checked from capability state. |
| Controlled evolution | 10 | Versioning, deprecation, migration and stale projection detection are enforced by tooling. |

## Artifact rubric

| Criterion | Weight | 10/10 requirement |
|---|---:|---|
| Artifact family completeness | 15 | Each P0 capability family declares required UX/API/data/event/failure/prompt/evaluation/ops/evidence artifacts and actual coverage. |
| Traceability semantics | 15 | `derived_from` and graph edges resolve by type, not just by string existence. |
| Build contract depth | 15 | State machines, data entities, OpenAPI, event payloads, failure recovery, privacy and idempotency are mutually consistent. |
| Evidence immutability | 10 | Benchmark, legal, user research, release and validation claims reference immutable run/evidence records. |
| Lifecycle discipline | 10 | `draft`, `review`, `approved`, `published` and blockers cannot be promoted by prose or generated text alone. |
| Generated catalog integrity | 10 | Projections are generated from declared sources, include source hashes and fail validation when stale. |
| Agent navigation | 10 | An agent can request a capability and receive the exact build context, missing inputs and blockers. |
| Operational readiness | 10 | Cost, quota, observability, benchmark, rollout, rollback and incident contracts have numeric gates or explicit unarmed blockers. |
| No duplication/drift | 5 | Duplicate semantic claims are either projections or fail validation. |

## Required evidence for a true 10

- P0 capability manifest source for all six closed-pilot packs.
- Typed semantic graph or graph-ready manifest with validator coverage.
- Semantic validator that catches wrong node types, enum drift, event drift, data-state drift and stale projections.
- Gold-standard Writing benchmark corpus and at least one immutable benchmark run.
- Approved numeric quality/cost thresholds.
- Acceptance run records for P0-01 through P0-06.
- No generated catalog with `sample_not_generated` used as build input.

Until those exist, the repo may improve but cannot honestly claim 10/10.
