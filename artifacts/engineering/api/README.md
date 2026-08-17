# LenBands Web API

`openapi.yaml` is the **single canonical HTTP contract** for the LenBands web product.

## Identity model

There are five web personas:

`guest`, `learner`, `premium_learner`, `colab`, `admin`.

There are only three authenticated product roles:

`learner`, `colab`, `admin`.

`premium_learner` is `learner + premium entitlement`. It is deliberately **not** a separate authorization role. `guest` has no authenticated role. Internal workflow/webhook principals are service identities and are not web personas.

See `access-control.md`.

## Contract rules

- Target OpenAPI semantics: **3.1.2**. The document uses `openapi: 3.1.0`, as required by the 3.1 document format.
- Error bodies use RFC 9457 `application/problem+json`.
- Every operation declares `x-web-personas`, `x-required-roles`, `x-required-entitlements`, `x-data-classes`, and `x-idempotency`.
- Authentication is provider-owned. LenBands does not create a second password/session API. The current sourcing decision selects managed auth; the LenBands server verifies the identity token and enforces its own object/role/entitlement policy.
- Client claims are inputs, not authorization decisions. Server policy and database controls remain authoritative.
- Mutations that can create a durable side effect require an idempotency key.
- Object ownership is checked server-side on every learner-owned resource; knowing an ID is never authorization.
- Raw assessment content never appears in analytics, general logs, error details, or billing webhooks.
- Provider response bodies are validated and normalized at adapter boundaries before entering domain state.

## Score identity

These are different objects and may not share an ambiguous UI/API field:

- `official_ielts_score`
- `exam_simulation_estimate`
- `diagnostic_estimate`
- `learning_mastery`

A single Writing Task result is task-scoped diagnostic evidence, not the official Writing section score.

## Evaluation route isolation

General coaching/generation may use provider fallback according to BOPS policy. Scoring may **not** fall back to a model/provider combination that has not passed the same benchmark/rubric release gate. A provider outage yields a delayed/unavailable evaluation state rather than silent scorer substitution.

## Versioning and deprecation

- URI major version: `/v1`.
- Additive compatible changes bump `info.version`.
- Breaking semantics require a new major API version or an explicit compatibility migration.
- Old split specs under `artifacts/engineering/contracts/**/openapi.yaml` are migration inputs only. They do not own new operations.
- An operation is removable only after successor/retirement, migration window, usage evidence, and validator/reference migration are recorded.

## Application boundary

The browser talks to the same-origin Next.js application boundary. Server-side route handlers/actions call managed data/provider services. Sensitive provider credentials and elevated database credentials never enter client JavaScript.

Direct browser-to-managed-data access is allowed only for an explicitly reviewed public/learner-owned surface with RLS; sensitive assessment/Admin/Colab mutations default to the application API so authorization, idempotency, audit and evidence rules stay centralized.
