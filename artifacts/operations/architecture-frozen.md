# Architecture Governance Contract

## Purpose

This document freezes repository authority boundaries and implementation-governance invariants. It does **not** freeze a provider, programming language, queue, cache, service count, or deploy topology.

## Authority boundaries

1. `DOCS.yaml` is the machine resolver for document authority and migration aliases.
2. `blueprint/` owns product/domain meaning; `blueprint/framework/` owns IELTS controlled vocabulary and official-derived interpretation.
3. `artifacts/` owns explicitly registered operational contracts, decisions, evidence requirements and projections.
4. `knowledge-assets/` owns governed learner/content assets and manifests.
5. Generated catalogs and resolved API files are deterministic projections; they never override their canonical inputs.

If two registered authorities claim the same semantic field, fail with `authority_collision`; do not choose by filename, date, directory depth, or prose confidence.

## Four independent state axes

The canonical state model is `artifacts/operations/implementation-eligibility.yaml`.

| Axis | Meaning | Must not be interpreted as |
|---|---|---|
| `scope_lifecycle` | product scope: ACTIVE / PLANNED / DEPRECATED | permission to write code |
| `implementation_eligibility` | one capability family has enough approved semantic inputs to be implemented | source-mutation authorization or release readiness |
| `implementation_authorization` | founder-approved permission bound to exact candidate SHA + family scope | acceptance evidence |
| `release_readiness` | release scope has required runtime, quality, privacy, security and cost evidence | architecture/document completeness |

`ACTIVE` therefore means **current product scope only**. It does not mean “approved current build scope”. One family may become implementation-eligible while other families remain blocked. A closed-pilot release may still require all required P0 families to be release-ready.

## Family-first operationalization

Canonical implementation navigation is:

`Capability ID -> Implementation Family -> Owner Contract -> Canonical API/Event/Failure/Data Contracts -> Evidence Requirements`

Every capability resolves to exactly one implementation family. A family owns shared behavior and runtime semantics; deltas own bounded content/task variation only. A delta may not override authorization, API identity, event identity, failure semantics, privacy, ownership or evidence policy.

## Implementation invariants

- Every scoped capability maps to exactly one family.
- Every family has exactly one semantic owner contract when implementation-eligible.
- Every HTTP operation has exactly one owner in `artifacts/engineering/api/operation-ownership.yaml`.
- Every canonical event has exactly one ownership declaration.
- Provider/runtime mechanisms are replaceable adapters and cannot redefine domain meaning.
- Commodity runtime is managed/bought by default; custom infrastructure requires an evidence-backed sourcing exception.
- Cache, queue, worker fleet, vector store and custom workflow infrastructure are not implied by repository structure or historical compatibility files.
- Source implementation cannot create acceptance, benchmark or readiness evidence by assertion.

## Promotion and eligibility

Dependency facts remain facts. Policy remains policy.

`Family facts + promotion policy -> scope promotion decision`

`Approved semantic inputs + resolved decisions + no family HIGH/CRITICAL -> implementation eligibility`

`Eligibility + exact candidate SHA + founder attestation -> implementation authorization`

`Runtime evidence + release gates -> release readiness`

No one expression may collapse these stages into a single `ready` boolean.

## Tooling governance

`tools/bin/lenbands` is the stable automation entry point. Tooling may validate canonical sources, compile deterministic projections, detect drift, execute registered evidence runners and write immutable evidence records. It may not become an application runtime, workflow platform, deployment control plane or alternate product SSOT.

A tooling change must demonstrate at least one of:

1. knowledge/authority deduplication;
2. stronger drift or mutation detection;
3. lower maintenance/operational complexity without weakening a gate.

Validator success proves only what that validator actually executes. A new authority or security invariant is not considered enforced until a negative/mutation test demonstrates that violating it fails.

## Runtime composition

Runtime composition follows `artifacts/engineering/runtime-contract.yaml` and the reviewed sourcing decision. Managed capabilities are preferred. Provider candidates may change without updating product semantics when adapters, data portability and evidence gates remain valid.

No historical ADR, compatibility pointer, agent filename, dependency domain allowlist or dormant workspace name may be interpreted as authorization to create Go, Python, Redis, Kafka, a worker service, or any other fixed topology.

## Change gate

An architecture/governance change requires one of:

1. a product-scope decision;
2. a demonstrated implementation/runtime blocker;
3. benchmark/security/privacy/operational evidence showing the current contract is insufficient;
4. removal of a verified authority collision, false-green validator, or maintenance hazard.

Protected changes require the repository attestation policy and external hosting controls. Repository validation does not substitute for GitHub branch protection/code-owner enforcement.
