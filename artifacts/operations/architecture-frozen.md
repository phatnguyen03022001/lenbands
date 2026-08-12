# Architecture Frozen Contract

## Purpose

This document freezes the repository architecture so implementation work can move to operational capability coverage. It does not introduce a compiler, scheduler, engine, graph database, or generic pipeline framework.

## Authority boundaries

1. `blueprint/` is product and domain design authority.
2. `blueprint/framework/` is IELTS domain and controlled-vocabulary authority.
3. `artifacts/` contains operational definitions, contracts, decisions, evidence requirements, and projections. It is authoritative only within an explicitly scoped registry or contract.
4. `knowledge-assets/` contains canonical learner content and manifests.
5. `03-features.md` remains authoritative for capability identity and product meaning.
6. Family Registry is authoritative only for implementation-family identity and shared behavior.
7. Owner Runtime Spec is authoritative only for family runtime behavior.

## Frozen principles

1. Runtime quality and evidence have priority over repository ergonomics.
2. A capability is implementable only when its operational path is defined:

   `User Action -> Interaction -> Runtime -> Web Surface -> Evidence`

3. Validators are coverage gates, not proof that missing capabilities do not exist.
4. Generators render canonical definitions; they do not contain product or IELTS business rules.
5. A gap is derived from evidence; it is not a new source of truth.
6. No compiler, scheduler, graph database, generic engine, IR framework, or build framework is introduced without a runtime blocker or evidence-backed requirement.
7. Business Automation Coverage—not infrastructure feature breadth—is the tooling success metric. Tooling investment prioritizes IELTS semantics, learning, assessment, Knowledge Assets, benchmark integrity, and release evidence.
8. All business-value logic belongs to a domain contract. Frameworks, runtimes, and providers are replaceable adapters and may not redefine system semantics.

## Capability lifecycle

Every capability has exactly one lifecycle state:

| State | Meaning | Minimum definition |
|---|---|---|
| `ACTIVE` | Approved current build scope | Complete Operational Definition and required contracts |
| `PLANNED` | Future or explicitly deferred scope | Identity, rationale, owner, dependencies, and promotion gate |
| `DEPRECATED` | No longer an implementation owner | Replacement, migration/reference path, and removal policy |

P0 maps to `ACTIVE`; P1, P2, and unassigned/deferred scope map to `PLANNED`; deprecated aliases map to `DEPRECATED`.

Lifecycle is not release readiness. Acceptance, evidence, approval, and release gates remain separate.

## Family-first operationalization

The canonical navigation path is:

`Capability ID -> Family -> Delta -> Owner Runtime Spec`

Every capability resolves to exactly one family. A family owns shared behavior: runtime boundary, actors, permissions, commands, entities, lifecycle, API shape, events, failure/recovery, acceptance pattern, and evidence requirements.

A delta owns variation only: question/task shape, answer normalization, scoring nuance, stimulus schema, required signals, or knowledge references. A delta may not override API, lifecycle, entity ownership, event envelope, failure semantics, privacy, permission, or ownership. If it needs to do so, it is a new family.

## Implementation invariants

- Every `ACTIVE` capability maps to exactly one family.
- Every family has exactly one Owner Runtime Spec.
- Every Owner Runtime Spec belongs to exactly one family.
- Every runtime entity has exactly one owner.
- Every API operation has exactly one owning family.
- Every event has exactly one canonical owner/schema; its allowed producers are explicitly declared and may be one or more.
- Every delta belongs to exactly one family.
- Every generated projection is reproducible and not manually edited.
- No capability-to-family mapping forms a cycle.

## Promotion policy boundary

Family dependencies are facts stored in the family/dependency registries. Promotion rules are policy stored separately. A validator evaluates both:

`Family Facts + Promotion Policy -> Promotion Decision`

Changing the required status from `candidate` to `ready` must change policy, not dependency facts.

## Change gate

Architecture changes require one of:

1. a runtime implementation blocker;
2. benchmark/evidence showing the design is insufficient;
3. a product scope decision.

## Tool Refactoring Governance

Every refactor of the `tools/` directory must demonstrate at least one of:

1. **Knowledge deduplication** — removes duplicated business logic or mapping.
2. **Drift detection** — increases the ability to detect errors, inconsistencies, or stale artifacts.
3. **Maintenance cost reduction** — reduces maintenance burden without altering authority boundaries.

If a proposed refactor satisfies none of these, it should not be merged.

## Long-lived Toolchain Contract

`tools/bin/lenbands` is the stable human and automation entry point. Its public
commands, compatibility guarantees and semantic version live in `tools/toolchain.yaml`.
Root scripts remain compatibility entry points until a versioned migration replaces
them; they are not the default for new automation.

Tooling is repository automation, not application infrastructure. It may validate,
render projections and write immutable evidence records. It may not introduce a
generic job framework, scheduler, deployment runtime, workflow engine or provider
control plane. Application runtime concerns follow the composition-first boundary in
`ADR-0004`.

The canonical measurement model is
`artifacts/operations/domain-automation-contract.yaml`. A missing infrastructure
feature is not a tooling gap when a maintained framework/provider owns it. A missing
IELTS invariant, semantic validator, evidence gate, or provider-independent adapter
contract is a tooling gap.
