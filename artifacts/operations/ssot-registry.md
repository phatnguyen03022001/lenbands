# SSOT Registry — Authority Boundaries

## Audit conclusion

The repository does not have “3 SSOTs” in the sense that everything within three top-level folders is equally authoritative. It has three top-level lifecycle layers, while multiple registries inside those layers have different scoped authority. Therefore, counting `~11 sources` is only an inventory heuristic and must not be treated as an invariant. Authority must be interpreted by the scope below.

| Registry / entity | Authority | Source of truth for | Not source of truth for | Evidence in repo |
|---|---|---|---|---|
| Blueprint hub + `01`–`08` | `canonical` | product invariant, capability identity, product scope | OpenAPI, runtime data, learner content | `blueprint/README.md`; `blueprint/01-product.md` § SSOT |
| IELTS Knowledge Framework — 10 domain files | `canonical-domain` | IELTS enum, node IDs, band/task/error/microskill semantics | asset payload, benchmark result | `blueprint/framework/README.md` § Files/Usage principles |
| Public IELTS official material | `external-normative` | official descriptor/band/conversion when the repository conflicts | product behavior and internal policy | `blueprint/framework/README.md` § Usage principles |
| Event Contract in Blueprint | `canonical-product-fact` | event identity, envelope, outcome semantics | transport/schema implementation details | `blueprint/03-features.md` § Event Contract; `blueprint/07-conventions.md` |
| Event schema pack + slice event contracts | `implementation-contract` | producer/consumer payload and privacy enforcement | renaming or redefining outcome events | `artifacts/engineering/contracts/events/event-schema-pack.md` |
| Runtime State Model | `canonical-product-state` | state axes used by Home/recommendation/recovery | persisted database schema by itself | `blueprint/02-architecture.md` § Runtime State Model |
| Roadmap | `canonical-phasing` | phase and release sequencing | capability identity/invariants | `blueprint/08-roadmap.md` |
| Runtime failure taxonomy contract | `implementation-registry` | internal failure codes and public projection | IELTS learner error taxonomy | `artifacts/engineering/contracts/runtime/failure-taxonomy-contract.md` |
| Framework error taxonomy | `canonical-domain` | IELTS learner error IDs and criterion impact | runtime retry/provider failures | `blueprint/framework/error-taxonomy.md` |
| Evaluation contract | `implementation-contract` | evaluation request/result/audit/quality-state boundary | benchmark result or calibration claim | `artifacts/engineering/contracts/evaluation/evaluation-contract.md` |
| Capability manifest | `typed-projection-seed` | P0 family compilation context and readiness blockers | capability identity/product semantics | `artifacts/operations/capability-manifest.yaml` (`source_of_truth: false`) |
| Capability family registry | `implementation-registry` | family identity, schema, invariants, runtime boundary, shared contracts/entities/events/failures/acceptance/evidence | capability identity (belongs to Blueprint) | `artifacts/operations/capability-family-registry.yaml` (`source_of_truth: true`) |
| Capability family map | `implementation-registry` | capability-to-family resolution, delta scoping, owner spec assignment | capability identity or product semantics | `artifacts/operations/capability-family-map.yaml` (`source_of_truth: true`) |
| Knowledge Asset payload + sidecar | `canonical-content-and-metadata` | learner content + asset identity/provenance/lifecycle | framework enum or runtime assessment history | `knowledge-assets/README.md`; `knowledge-assets/manifests/README.md` |
| Assessment History runtime entity | `runtime-canonical` | all learner assessment results and timeline | repository design docs/evidence snapshots | `blueprint/01-product.md` § Assessment History |
| Catalogs, caches, code, Error Graph, DailyPlanSnapshot, templates | `projection/derived/tooling` | derived views or workflow support only | any upstream SSOT | `artifacts/CONVENTION.md`; `artifacts/operations/catalogs/README.md` |

## Two corrections already made

1. `capability-manifest.yaml` previously declared `source_of_truth: true` while also having `status: draft` and stating that it did not replace `blueprint/03-features.md`. That was an authority collision. It has been downgraded to `source_of_truth: false`, `typed-projection-seed`; the validator blocks that flag from returning.
2. The former top-level `spawn-prompts/` directory prohibited agents from reading workflow artifacts and pinned framework `1.0.4` even after the framework moved to `1.0.5`. The directory was moved to `artifacts/operations/spawn-prompts/` with a registry, sidecar metadata, and hash validator. Agents may read it; prompts are workflow contracts and must not override framework authority.

## Honest counting rule

- Counting layers (`blueprint`, `artifacts`, `knowledge-assets`) describes repository taxonomy.
- Counting registries describes scoped authority inventory, not a number of independent SSOTs.
- If two files claim the same semantic field, one must be explicitly `canonical` and the other `implementation-contract` or `projection`; a validator must verify resolution.
- `status: approved`, a passing validator, or a correct prompt hash does not prove IELTS quality, rights, calibration, benchmark validity, or learner outcome.
