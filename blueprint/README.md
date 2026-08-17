# LenBands Blueprint

The Blueprint is the **product and domain invariant layer**. It defines what LenBands means and what must remain true across implementations. It is not the repository-wide authority registry, implementation backlog, OpenAPI contract, provider catalog, or deployment guide.

Repository authority is resolved first through `../DOCS.yaml`.

## Constitution

1. **One semantic owner.** Each durable product/domain concern has one owner declared in `DOCS.yaml`.
2. **Stable identities.** Capability IDs and IELTS Framework node IDs survive file/path/provider changes.
3. **Blueprint owns invariants, not infrastructure vendors.** Provider/build-buy choices live in Artifacts and may change without redefining product semantics.
4. **Artifacts decide and operationalize.** API, sourcing, BOPS, implementation, research and evidence belong under `artifacts/` according to their owner.
5. **Knowledge Assets are versioned learner-serving content.** Provenance and lifecycle are explicit; evidence is never overwritten.
6. **No readiness by prose.** `approved`, `calibrated`, `ready`, scorer-quality or learning-effectiveness claims require their governed evidence.

## Eight spokes

This README is the hub for eight Blueprint spokes. It indexes them; it does not duplicate their contracts.

| File | Owns | Does not own |
|---|---|---|
| `01-product.md` | vision, users/personas, scope, product principles, success contract | API or deployment topology |
| `02-architecture.md` | semantic domains, system boundaries, architecture invariants, runtime state model | capability catalog or vendor procurement |
| `03-features.md` | capability identities and meanings | screen layout or implementation |
| `04-experience.md` | learner journeys and experience invariants | component/CSS implementation |
| `05-content.md` | content system and taxonomy application | runtime learner content files |
| `06-engines.md` | learning/evaluation/recommendation/governance engine semantics | provider-specific SDK topology |
| `07-conventions.md` | product naming, accessibility, localization and cross-cutting conventions | one-off feature decisions |
| `08-roadmap.md` | phase scope and promotion horizon | detailed build specification |

The IELTS controlled-vocabulary framework is the child domain under `framework/` and remains the authority for its registered nodes/versions.

## Agent reading rule

Do **not** read all spokes by default.

```text
DOCS.yaml
  -> resolve semantic owner
  -> read one owning Blueprint/Artifact
  -> follow only explicit cross-references required by the task
```

A README, generated catalog, prompt, research synthesis or historical decision cannot override a registered owner.

## Core product invariants

- IELTS is modeled as a structured knowledge/assessment domain, not a lesson list.
- Five web personas exist: Guest, Learner, Premium Learner, Colab and Admin.
- Premium Learner is a learner with a premium entitlement, not a separate authorization hierarchy.
- Colab operates content and never scores learner work.
- Admin operates the platform/governance and does not manually overwrite learner evaluation scores.
- The evaluator is automated; quality controls require benchmark/governance evidence and are never assumed from model confidence alone.
- Learning progress is evidence-driven: activity completion alone is not mastery or exam readiness.
- Learner retention must come from useful progress, not guilt, streak pressure or notification spam.
- Provider identity must not change capability IDs, canonical events, learner score meaning or IELTS semantics.
- Commodity infrastructure is bought/managed by default; custom infrastructure requires an evidence-backed blocker under `02-architecture.md` and the sourcing authority.

## Score identity boundary

These concepts must remain distinct throughout the product:

- `official_ielts_score` — an actual official result supplied by the learner/authorized source;
- `exam_simulation_estimate` — LenBands estimate from a complete governed mock/simulation;
- `diagnostic_estimate` — partial/task/placement estimate;
- `learning_mastery` — LenBands learner-model state.

A task-level estimate must never be presented as an official section/overall IELTS score.

## Learning evidence boundary

The target learning progression is:

```text
Diagnose
  -> Understand
  -> Guided Practice
  -> Independent Practice
  -> Retest
  -> Transfer
  -> Maintain
```

Repeated/revealed-item success can support learning but does not by itself prove independent transfer. FSRS schedules suitable review units; it is not a universal mastery model for complex IELTS skills.

## Capability readiness

A capability is only a build candidate when its governed profile identifies at least:

```yaml
capability_id: DOMAIN.Capability
user_outcome: observable outcome
owner: product | engineering | operations | legal
phase: P0 | P1 | P2 | deferred
dependencies: []
primary_events: []
quality_gate: explicit gate
cost_budget: explicit policy
fallback: explicit degraded state
privacy_class: account | learning | assessment | audio | billing | system | derived
```

Detailed API/data/event/failure/provider contracts belong in the owning Artifact rather than being copied into the Blueprint.

## Important current cross-references

- Repository/document authority: `../DOCS.yaml`
- System architecture: `02-architecture.md`
- Capability catalog: `03-features.md`
- Learner experience: `04-experience.md`
- Content system: `05-content.md`
- Learning/evaluation engines: `06-engines.md`
- Canonical web API: `../artifacts/engineering/api/openapi.yaml`
- Five-persona access model: `../artifacts/engineering/api/access-control.md`
- Buy-first sourcing: `../artifacts/business/decisions/platform-sourcing.md`
- BOPS controls: `../artifacts/operations/bops/contract.yaml`
- Trust/change policy: `../artifacts/operations/agent-trust-policy.yaml`
