# Artifacts

Artifacts record decisions, research, design, specifications, contracts, evidence, operations, and projections/indexes. They may reference the Blueprint by capability ID, but they are not learner-serving content.

The full rules are in [CONVENTION.md](CONVENTION.md). This file is the entry point for agents to find the right artifact type.

| Lens / folder | Used for |
|---|---|
| `business/` | Market/pricing research, monetization, build/buy business decision, legal/rights strategy |
| `experience/` | Learner research, interaction/design, IA, wireframe, build-ready behavior spec |
| `engineering/` | Technical ADRs and OpenAPI/data/event/failure/runtime/LLM contracts |
| `operations/` | Release/cost/quality/benchmark/observability, operational decision, evidence, generated catalog |
| `templates/` | Copy-forward templates for artifacts with recurring lifecycle/boundary patterns |

The workflow library for agents that create Knowledge Assets is at [`operations/spawn-prompts/`](operations/spawn-prompts/). It is an artifact contract with a registry and validator; it is not the source of truth for the IELTS domain. Agents read this directory when needed.

## Dependency

```text
Blueprint
   ↓
Artifact
   ↓
Source Code
   ↓
Runtime
```

The Knowledge Asset layer is active. Artifacts only reference or summarize Knowledge Assets; they do not keep a second mutable learner-serving copy. The asset's canonical metadata is in its sidecar as defined by `knowledge-assets/README.md`.

## Rules

- Evidence in `operations/evidence/` is never overwritten. A new license or permission creates a new version with a timestamp and hash.
- When the Knowledge Asset layer exists, artifacts may only reference or summarize the asset; they must not keep a second mutable learner-serving copy.
- A catalog must include its generation source, generation time, and schema version.
- If an artifact defines a decision that affects the product, it must reference a capability ID or decision ID.
- A build-ready artifact must pass the checklist in `CONVENTION.md` §7 before an agent starts coding.
- The closed-pilot scope and minimum Artifact pack for each P0 capability are in `operations/p0-artifact-pack.md`; the actual status is in `operations/build-readiness-matrix.md`.
