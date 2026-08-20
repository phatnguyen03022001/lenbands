# LenBands Web API

The web API uses **non-overlapping semantic owners that compile into one build contract**:

- `openapi.yaml` — HTTP paths/methods, operation IDs, persona/role/entitlement/data-class annotations and HTTP error surface.
- `schema-contract.yaml` — request and success-response field semantics for every canonical `operationId`.
- `type-system.yaml` — closed type aliases plus transport, request-limit, browser-session, rendering and public-failure policies.
- `operation-ownership.yaml` — exactly one implementation-family owner for every canonical operation.
- `access-control.md` — web personas, authenticated roles, entitlements, browser-session/recent-auth requirements, function-scoped internal principals and separation of duties.

`DOCS.yaml` registers these owners. None may redefine another concern.

## Deterministic build projection

`tools/commands/generate/canonical-web-api.rb` compiles the semantic inputs above into a resolved OpenAPI 3.1.2 projection. `tools/commands/generate/all.sh --check` proves the projection can be regenerated without unknown type tokens or generic build payloads.

Rules:

- source `openapi.yaml` may retain generic authoring placeholders while operation/access metadata is edited;
- **generated/resolved OpenAPI is the only codegen/build input**;
- resolved operations bind request/response bodies to the exact schemas registered by `operationId`;
- `JsonObject`, `ObjectOK`, `ListOK`, `ObjectCreated` and `ObjectAccepted` are forbidden in the resolved build surface;
- unknown schema/type tokens fail CI;
- generated output is a projection and never becomes an additional SSOT;
- retired split specs under `artifacts/engineering/contracts/**/openapi.yaml` must not exist or re-enter `DOCS.yaml`; Git history is the migration archive.

## Identity model

Web personas: `guest`, `learner`, `premium_learner`, `colab`, `admin`.

Authenticated product roles: `learner`, `colab`, `admin`.

`premium_learner = learner + premium entitlement`; it is not a separate security role. `guest` has no authenticated role.

Internal signed/workflow identities are function-scoped principals such as evaluation worker, billing webhook, content job, notification job or research benchmark job. One generic credential does not imply blanket domain access. Model/provider credentials are never LenBands authorization credentials.

## Contract rules

- Resolved OpenAPI target: **3.1.2** with JSON Schema 2020-12 semantics.
- Error bodies use RFC 9457 `application/problem+json`; public `Problem.code` values are compiled from the controlled failure projection.
- Every operation declares persona, role, entitlement, data class and idempotency policy.
- Every operation has exactly one typed request/success-response registry entry and exactly one implementation-family owner.
- `none` request means no JSON request body.
- Managed identity verifies authentication; LenBands server/data policy owns object/role/entitlement/function authorization.
- Client claims and opaque IDs are never sufficient authorization.
- Durable mutations require the controlled `Idempotency-Key` contract.
- Request parsing and semantic fields follow the body/depth/collection/text ceilings in `type-system.yaml`; oversized input is rejected before storage, inference, logging or domain side effects.
- Browser credential transport, CSRF/origin controls, session rotation/revocation and recent-auth/step-up follow `access-control.md` + `type-system.yaml`; the client cannot self-assert recent-auth.
- Learner, Colab, provider and generated text are untrusted renderable data. Raw HTML is not trusted by storage/API provenance; browser rendering follows the sanitizer/URL/CSP policy in `type-system.yaml`.
- Raw C1–C4 assessment/security content never enters general analytics, logs, error details or billing webhooks.
- Signed billing webhooks verify the raw request body before parsing/normalization, deduplicate by provider event ID, then update only the provider-neutral billing/entitlement ledger.
- Provider/model responses are validated and normalized at adapter/domain boundaries before entering canonical domain state.

## TargetProfile contract

A learner target is not one universal `target_band` scalar.

Canonical Goal payloads use `TargetProfile` with exam module plus optional overall target, per-skill minimums, exam date and purpose.

```text
TargetProfile
  -> planner/content eligibility
  -> evidence collection
  -> readiness interpretation
```

The target may prioritize learning. It must not bias a scorer into awarding the desired band.

### `TargetFeasibility.target_met` scope rule

`target_met` means **all target requirements that the TargetProfile actually declares are satisfied by the owning readiness policy with admitted evidence for every required scope**. It never means “this sampled skill looks good.”

Required invariants:

- an overall IELTS target requires the owning readiness policy to have sufficient admitted evidence for every skill/scope required to support that overall claim;
- a per-skill minimum may be satisfied only for that explicitly targeted skill; it cannot be serialized or rendered as overall IELTS attainment;
- missing required target scope forces `insufficient_evidence`, `at_risk` or another truthful non-met state according to policy;
- P0 Writing-only evidence cannot produce overall/four-skill `target_met` because full four-skill readiness is not activated in the closed pilot;
- UI copy must name a narrower satisfied scope when only a narrower target requirement is proven;
- `target_met` remains a readiness/planning state, not an official IELTS score or guarantee of future exam performance.

This rule applies wherever `TargetFeasibility` appears, including Goal, Placement and Daily Plan projections. A client may not infer broader attainment from the enum alone.

## Operation state vs result validity

Transport/workflow lifecycle and result trustworthiness are separate fields.

Canonical high-risk derived results follow:

```text
operation_state:
  accepted | processing | succeeded | delayed | unavailable | failed | cancelled

result_validity:
  accepted | limited_evidence | insufficient_evidence | invalid | integrity_review
```

A submission/practice operation may be completed while its linked result is `limited_evidence` or `insufficient_evidence`. Do not overload one `state` enum with queue status, model confidence and evidence validity.

Only the owning evidence policy decides which result validity states may update learner mastery/readiness.

## Score identity and scorer isolation

These identities remain distinct:

- `official_ielts_score`;
- `exam_simulation_estimate`;
- `diagnostic_estimate`;
- `learning_mastery`.

One Writing Task 2 result is task-scoped diagnostic evidence, not a complete official-equivalent Writing section score.

Learner-facing score payloads preserve `score_label`, `score_scope`, rubric/scorer-route provenance and `result_validity`. They do not require model/provider identity or raw model confidence in the learner response.

General generation/coaching may use policy-approved provider fallback. Learner-visible scoring may route only among benchmark-approved combinations inside the compatible scorer-route policy. If no approved route is available, return delayed/unavailable semantics; never silently substitute an unbenchmarked scorer.

## Deterministic / inference boundary

HTTP endpoints expose product semantics, not "AI endpoints".

Before inference, the implementation must use deterministic/library/SQL/precomputed mechanisms when they meet quality for:

- authorization/entitlement;
- objective answer normalization/scoring;
- word counts/format/schema checks;
- exposure/evidence admission;
- FSRS scheduling;
- P0 recommendation candidate/ranking rules;
- content lifecycle/rights checks;
- quota/idempotency/cost accounting.

Inference is allowed for irreducibly semantic/generative/speech judgment under the runtime/evaluation contracts. Model output remains a candidate until domain validation accepts it.

No LLM/model response may directly set role, entitlement, content publication, readiness or mastery.

## Content metadata API boundary

Content schemas require universal publishing/provenance/rights metadata. Taxonomy enrichment is optional unless an active capability declares the field as a decision dependency.

`CONTENT.AutoTag`/tag-suggestion operations may reduce authoring cost, but cannot publish content or create framework authority. Optional semantic suggestions should normally be batch/small-model work after deterministic metadata reuse/rules.

Content authoring data is not trusted presentation markup. A published/rights-approved content object still requires safe rendering; publication authority and XSS/DOM safety are separate controls.

## Versioning and deprecation

- URI major version: `/v1`.
- Compatible payload additions follow the schema/API version policy.
- Breaking semantics require an explicit compatibility migration or new major API version.
- Retired split OpenAPI paths must remain absent from the working tree and control plane.
- Removal requires successor/retirement, usage/reference evidence and zero unresolved canonical consumers; completed migration trace belongs in Git history, not live aliases.

TargetProfile/result-validity/feasibility semantics require generated-contract/runtime consumer validation before implementation eligibility is claimed.

## Application boundary

The browser talks to the reviewed same-origin managed application boundary selected by the sourcing decision. The API contract does not require Next.js, Go, Python, a standalone BFF or a dedicated service topology.

Direct browser-to-managed-data access is allowed only for explicitly reviewed public/subject-owned surfaces with server/data-layer authorization such as RLS. Sensitive assessment, Admin and Colab mutations default to the governed application API so authorization, recent-auth, idempotency, audit, request-limit and evidence rules remain centralized.
