# Platform Contract Restructure Audit

Status: **review**. This is a documentation/contract audit, not runtime evidence and not a production-readiness claim.

Date: 2026-08-17
Layered PR: #2 (`docs/platform-contract-v2` → `docs/english-blueprint-artifacts`)

## Audit method

The orchestrator separated the review into eight independent lenses so one design concern could not self-approve another:

1. document information architecture and naming;
2. five-persona web identity/access model;
3. BOPS completeness;
4. API/OpenAPI completeness;
5. build-versus-buy/provider consolidation;
6. cross-boundary interference/noise analysis;
7. red-team/security review;
8. verification/governance.

The lanes share findings only through explicit canonical contracts. A research note or PR description is not allowed to become runtime authority.

## Findings and dispositions

| ID | Lane | Severity before | Finding | Disposition |
|---|---|---:|---|---|
| `AUD-01` | documentation | critical | agents could encounter multiple documents that looked authoritative for architecture/API/provider choice | added root `DOCS.yaml`; stable document IDs; legacy aliases; one semantic owner rule |
| `AUD-02` | documentation | high | Blueprint hub duplicated and contradicted architecture through a fixed Go/Python/Next.js stack statement | removed implementation stack authority from Blueprint hub; `02-architecture.md` owns provider-neutral architecture |
| `AUD-03` | access | high | Premium could be modeled as a fourth authenticated role and drift from billing state | five personas but three authenticated product roles; Premium = learner + entitlement |
| `AUD-04` | API | critical | two OpenAPI candidates existed and the repository explicitly lacked one unified authority | added one canonical full-web OpenAPI; legacy specs are migration-only |
| `AUD-05` | API | high | an endpoint inventory could look complete while request/response payloads remained generic | added typed schema contract mapped 1:1 to all 60 canonical operation IDs; CI checks exact coverage |
| `AUD-06` | BOPS | high | prior BOPS monolith mixed dated provider facts with operations/security policy | split BOPS into machine contract + red-team threat model; sourcing moved to business decision authority |
| `AUD-07` | BOPS | high | Business Operations ownership for privacy, billing, content, incidents, procurement and release was under-specified | BOPS 1.1 adds operating domains, owners, runbook requirements, retention, incident/support, procurement, recovery and release gates |
| `AUD-08` | sourcing | high | managed provider sprawl still left a solo founder with many IAM/network/queue/config failure surfaces | buy-first consolidated candidate baseline; custom Go/Python/Redis/Kafka/workflow/auth/payment/search infrastructure removed from default P0 design |
| `AUD-09` | evaluation | critical | general model-gateway fallback could silently change learner scoring semantics | scorer route allow-list permits fallback only among benchmark-approved model/provider combinations for the same route version; otherwise delayed/unavailable |
| `AUD-10` | assessment | high | Learn/Practice context or repeated items could contaminate Retest/Mock evidence | assessment-mode provenance, exposure/independent-evidence controls and cross-mode leakage threat added |
| `AUD-11` | security | critical | BOLA/BFLA and elevated managed-database credential misuse needed explicit tests | access contract + canonical API annotations + BOPS threat cases require object/function negative tests and server-side authorization |
| `AUD-12` | privacy | critical | analytics/session replay/provider payloads could receive learner assessment/PII through convenience instrumentation | C0–C5 data classes; only C0/C5 in general analytics; assessment/auth/privacy/billing/admin replay prohibited |
| `AUD-13` | durability | high | workflow/webhook retries can duplicate evaluation, billing, review or publish side effects | at-least-once assumption + idempotency contract + provider event dedupe/order/reconciliation |
| `AUD-14` | tooling | high | a "green" migration could ignore a new canonical API because old validators only knew legacy specs | added `canonical-web-api.rb` to repository verify; legacy validation remains active during migration rather than being disabled |

## Five web personas

The public product exposes:

1. `guest`
2. `learner`
3. `premium_learner`
4. `colab`
5. `admin`

Security identities are deliberately smaller:

- unauthenticated guest;
- role `learner`;
- role `colab`;
- role `admin`;
- internal `service` principal for signed callbacks/workflows.

`premium_learner` is the learner role with an active `premium` entitlement.

## Canonical API result

Current canonical HTTP authority: `artifacts/engineering/api/openapi.yaml`.

The contract contains 60 operations spanning Public/Guest, learner/Premium study and assessment, Colab content operations, Admin operations, and signed billing webhook handling.

Every operation carries:

- `x-web-personas`
- `x-required-roles`
- `x-required-entitlements`
- `x-data-classes`
- `x-idempotency`

Payload semantics are owned by `artifacts/engineering/api/schema-contract.yaml`; every canonical `operationId` must have exactly one request and success-response schema mapping.

## BOPS result

Canonical BOPS is now:

- `artifacts/operations/bops/contract.yaml` — machine controls;
- `artifacts/operations/bops/threat-model.md` — adversarial/interference analysis.

It covers identity/access, privacy/retention, billing/entitlements, content operations, evaluation quality, release/change, procurement, incidents/support, data classification, provider boundaries, durability, backup/recovery, observability, cost and release blockers.

## Build/buy result

Custom product code is reserved for LenBands differentiation: IELTS semantics, learner evidence/model/policy, content/publishing semantics, evaluation/benchmark semantics, thin application orchestration and product experience.

Commodity infrastructure is sourced as managed capability by default. Current provider names are **design candidates**, not procurement or deployment evidence.

## Red-team interference set

The explicit red-team contract covers at least:

- split API/document authority;
- persona/role collision;
- provider sprawl;
- scorer fallback interference;
- cross-mode answer/context leakage;
- repeated-item contamination;
- prompt injection through learner content;
- retry duplication;
- out-of-order/duplicate billing webhooks;
- elevated DB/RLS bypass;
- BOLA/BFLA;
- analytics/PII contamination;
- mutable assessment content after evidence exists;
- stale entitlement cache;
- unsafe provider consumption;
- adaptive tunnel vision;
- feedback overload;
- documentation retrieval poisoning;
- alert/provider noise.

## Verification record so far

Bootstrap CI run `31988340443` on head `2968e92c8a517b375f96524433e4fb7a6de385ce` proved:

- Doctor: pass
- Repository Verify: pass
- Toolchain freeze: pass
- Change-set build: pass
- Protected attestation step: intentionally failed because the restructure attestation had not yet been created

The resulting append-only attestation is `platform-contract-restructure-20260817-v1.yaml`.

Subsequent CI is required on the final head after all protected cleanup. This document must be updated or superseded if final verification finds a new high/critical issue.

## Residual risks / intentionally incomplete migration

These are **not hidden**:

1. Legacy OpenAPI files still physically exist because legacy validators/capability packs reference them. `DOCS.yaml` marks them migration-only. They may be deleted only after inbound-reference/validator migration.
2. The canonical OpenAPI still uses a generic transport object in some request/response components. The typed schema registry is authoritative for payload meaning; build readiness is blocked until OpenAPI/codegen binds directly to those schemas or a deterministic projection is introduced.
3. `agent-trust-policy.yaml` still contains locked legacy Go/Python implementation-workspace/worker names. Source mutation remains globally locked, and `DOCS.yaml`/`02-architecture.md` own product architecture. These dormant names should be removed only with the corresponding Claude/tooling validator migration; they are not a reason to reintroduce Go/Python services.
4. Provider candidates are not provisioned/procured and no DPA/cost/exit exercise is claimed.
5. P0 learning/scoring calibration and real learner evidence remain blocked separately.
6. Independent external CODEOWNER review is still required by repository governance.

## Exit criteria for this restructure

The restructure is clean enough to fold into the parent documentation branch only when:

- same-head Doctor/Verify/Toolchain/Trust passes;
- canonical API typed-operation coverage passes for all operation IDs;
- no unresolved critical/high red-team finding remains inside the changed authority scope;
- no legacy file can override the canonical owner through `DOCS.yaml`;
- protected-change attestation chain is valid;
- external review remains required rather than bypassed;
- no claim of production, P0, calibration or provider readiness is introduced without evidence.
