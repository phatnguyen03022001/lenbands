# Artifact Constitution

## 1. Role

An artifact supports product building, decision-making, verification, operation, or governance. An artifact is not:

- Blueprint invariant.
- Source Code.
- Runtime Data.
- a Knowledge Asset serving learners.

An artifact may be Markdown, YAML, JSON, HTML, OpenAPI, a test specification, or an evidence file. **File format does not determine the layer; role and lifecycle do.**

## 2. Four owner lenses

An artifact is placed according to **who is responsible for changing its purpose**, not its file format or every group that reads it. Each artifact has exactly one canonical home; others consume it through a stable ID/reference and do not copy it.

| Lens / folder | Question answered | Contains |
|---|---|---|
| `business/` | Is it worth building, monetizable, and legally resourced? | market/pricing research, monetization, resource rights, business decision |
| `experience/` | What outcome and behavior does the learner experience? | user research, interaction/design, IA, wireframe, vertical slice spec |
| `engineering/` | How does the system implement the contract? | technical ADR, OpenAPI, data/event/failure/runtime/LLM contract |
| `operations/` | How does it run safely, with quality, measurement, and rollback? | quality/cost/release, benchmark, observability, operational ADR, evidence, catalog |
| `templates/` | How do agents/founders create artifacts consistently? | slice, screen, contract, ADR template |

`research`, `decision`, `legal`, `design`, and `spec` are **sub-roles**, not top-level taxonomy. For example, pricing research is in `business/research/`; user interviews are in `experience/research/`; technical ADRs are in `engineering/decisions/`; governance ADRs are in `operations/decisions/`.

### Canonical placement rule

1. Choose the lens by the question: **why/pay/rights → business; learner outcome/behavior → experience; implementation boundary → engineering; reliability/quality/cost/release/evidence → operations**.
2. If an artifact serves multiple lenses, place it in the lens that owns semantic changes and add `consumed_by` in metadata when needed; do not duplicate the file.
3. `owner` is the role/person responsible for review. The folder/lens does not replace the owner.
4. Immutable evidence always belongs in `operations/evidence/`; legal/buy decisions only reference evidence and do not contain mutable proof.

## 3. Metadata contract

Each artifact needs a `.meta.yaml` file when it has a lifecycle, is referenced by agents, or needs audit. A short note artifact may need only a path and heading.

```yaml
type: <artifact-role>
status: draft | review | approved | deprecated | archived
version: <semver>
owner: <role-or-owner>
representation: markdown | yaml | json | html | openapi | pdf | other
derived_from:
  - <capability-id-or-blueprint-reference>
purpose: <one-line-purpose>
consumed_by: [business | experience | engineering | operations]
created_at: YYYY-MM-DD
updated_at: YYYY-MM-DD
reviewed_by: <owner-or-role>
reviewed_at: YYYY-MM-DD
framework_refs:
  - file: <framework-file-without-.md>
    version: <framework-semver>
    nodes: [<framework-node-id>]
```

Rules:

- Do not create `artifact_id` by default.
- Add `artifact_id` only when the artifact is a first-class reference target in multiple contexts.
- `type` is role/representation, not a durable identity.
- Version does not belong in a filename or ID.
- Prefer Capability IDs in `derived_from`; do not use paths as dependency identity.
- `consumed_by` is optional; add it only when another lens regularly uses the artifact or a clear handoff is needed.
- `framework_refs` is optional for Artifact metadata. For Knowledge Asset sidecars at `knowledge-assets/**/*.meta.yaml`, it is required and must point to specific nodes and a framework version.
- A version string in a filename is retained only when it is a stable domain/template identity (for example, `writing_evaluation_v1`); do not use it instead of the artifact revision. The canonical revision is always in the sibling `.meta.yaml`.
- `origin.source/license` in a KA sidecar is only for asset-level provenance with source enum `unknown | generated | first_party | licensed | public_domain`. Authoring-side rights belong under `rights.origin`; `external_reference` and `cambridge_pattern` must not enter KA `origin.source`.
- Immutable evidence: do not overwrite it; create a new snapshot/version.
- An `approved` artifact must have `reviewed_by` and `reviewed_at`, or a clearly referenced approval record.
- When an artifact has a sibling `.meta.yaml`, the sibling is the sole canonical metadata. Do not keep a duplicate metadata block in the body; prose references remain allowed.

`derived_from` records only stable Capability IDs (and an Artifact ID in the rare case where one has been issued). Further-reading links may appear in the artifact's `References` section, but are **not** dependency identity.

## 4. Lifecycle

```text
draft → review → approved → deprecated → archived
```

- `draft`: being written; not an official build contract.
- `review`: content is sufficient; traceability/quality checks are in progress.
- `approved`: permitted as input to the next artifact or Source Code.
- `deprecated`: not for new work; retained for traceability.
- `archived`: read-only; no longer operationally effective.

## 5. Dependency rules

```text
Blueprint Capability
        ↓
Artifact Decision / Spec / Contract
        ↓
Source Code
        ↓
Runtime Data / Runtime Services
```

- An artifact may reference the Blueprint and other artifacts.
- An artifact must not mutate Blueprint source.
- An artifact must not become a second learner-serving content source.
- Source Code implements the artifact; do not make code the SSOT for product rules.
- Runtime Data must not be committed to an artifact.
- A catalog is only a projection, not a new source of truth.

## 6. Artifact Definition of Done

An artifact may be `approved` only when it has:

- purpose and owner.
- valid `derived_from` when it affects the product.
- scope and out-of-scope.
- clear status/lifecycle.
- no duplicate or second mutable source.
- when it describes capability behavior, an Interaction Specification or a reference to a specific path: actor, command, sync/async, runtime effect, expected UX, failure, and evidence.
- an acceptance/quality gate when used for building or operation.
- failure/edge cases when describing behavior.
- a version and update date.
- a review/approval record when `approved`.

### Approval and evidence boundary

`approved` does not mean "proven in the real world." This status only confirms that the artifact was reviewed according to its purpose:

| Claim type | Minimum condition for `approved` | Must not be inferred |
|---|---|---|
| Internal policy / convention | Real founder/owner review | Provider, legal, or learner outcome has been validated |
| Build contract / spec | Behavior, privacy, failure, and acceptance-test review | Code has run in production |
| Research finding | Traceable source or original transcript/record | Causal conclusion or willingness-to-pay without sufficient research |
| Legal / rights decision | Immutable evidence with hash, provenance, and appropriate review | Usage rights from only a URL/summary |
| Quality / benchmark result | Dataset, run record, version, and actual threshold | "The model meets the standard" without a run |

Every artifact requiring external proof must remain `draft` or `review` until real evidence exists in `operations/evidence/`. Do not use metadata, prose, or an agent assertion as a substitute for evidence.

## 7. Build-ready specification gate

An `experience/specs/` artifact may move to Source Code only when it has:

- User goal, role, and permission.
- Entry/exit conditions.
- State machine and transitions.
- Interaction path from user action → runtime effect → expected UX → failure/evidence.
- Screen/action/validation when there is UI.
- Runtime data read/write boundary.
- API/event/failure contract or a clear reference.
- Privacy and cost guardrail.
- Acceptance tests.

## 8. Non-goals and prohibitions

- Do not create an artifact merely to fill a folder.
- Do not issue IDs for every file.
- Do not copy the Blueprint's full contents into an artifact.
- Do not use a wireframe to replace the interaction model.
- Do not use research or an ADR directly as a runtime rule.
- Do not put a Knowledge Asset into the framework repository before it is needed.
- Do not use `approved` to conceal procurement, legal clearance, benchmark, user research, or a release that has not occurred.
