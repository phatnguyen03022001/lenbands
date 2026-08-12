# Web Surface Inventory

## 0. Purpose

This is an operational inventory answering which capabilities have a path from **User Action → Interaction → Runtime → Web Surface → Evidence**. It does not replace the capability catalog, Blueprint, or OpenAPI.

`ready` is valid only when every required path exists and the evidence gate passes. `review`/`candidate` is not build approval.

## 1. Current inventory

| Capability / pack | Interaction Spec | Runtime Boundary | Web Surface | Evidence | Status |
|---|---|---|---|---|---|
| IDENTITY.Core | `experience/specs/interaction/identity-core.md` | `engineering/runtime/identity-core-runtime.md` | P0 Runtime OpenAPI profile: profile/consent operations pending dedicated path review | DPA/export-delete acceptance not_run | `contract_candidate` |
| PLACEMENT.Diagnosis | `experience/specs/interaction/placement-diagnosis.md` | `engineering/runtime/placement-diagnosis-runtime.md` | P0 Runtime OpenAPI profile: placement operations | calibration/acceptance not_run | `contract_candidate` |
| STUDY.DailyAction | `experience/specs/interaction/daily-action.md` | `engineering/runtime/daily-action-runtime.md` | P0 Runtime OpenAPI profile: daily/session operations | acceptance not_run | `contract_candidate` |
| WRITING.Evaluation | `experience/specs/interaction/writing-evaluation.md` | `engineering/runtime/writing-evaluation-runtime.md` | `engineering/contracts/writing-task-2/openapi.yaml` | corpus/benchmark/acceptance missing | `contract_candidate` |
| REVIEW.ErrorToReview | `experience/specs/interaction/error-to-review.md` | `engineering/runtime/error-to-review-runtime.md` | P0 Runtime OpenAPI profile: review operations | acceptance not_run | `contract_candidate` |
| OPS.QualityEconomics | `experience/specs/interaction/quality-economics.md` | `engineering/runtime/quality-economics-runtime.md` | P0 Runtime OpenAPI profile: quality-gate operations | evidence pending | `supporting_candidate` |
| Listening | missing | multi-skill runtime candidate | no canonical OpenAPI | corpus/acceptance missing | `missing` |
| Reading | missing | multi-skill runtime candidate | no canonical OpenAPI | corpus/acceptance missing | `missing` |
| Speaking | missing | multi-skill runtime candidate | no canonical OpenAPI | recordings/labels/acceptance missing | `missing` |
| Pronunciation | missing | multi-skill runtime candidate | no canonical OpenAPI | audio/features/acceptance missing | `missing` |
| Mock Test | missing | multi-skill runtime candidate | no canonical OpenAPI | composite corpus/acceptance missing | `deferred` |

## 2. Core versus supporting definition

### Core runtime capabilities

Writing, Listening, Reading, Speaking, Pronunciation, Placement and Mock Test change learner state or create learning evidence. They require:

- Interaction Spec.
- Runtime boundary.
- State/entity/API/event/failure definitions.
- Review/retest rule where applicable.
- Acceptance evidence.
- Benchmark/corpus when the capability makes a quality claim.

### Supporting capabilities

Notification, Search, Settings, Progress projections and similar surfaces use a smaller contract:

- user action/read model;
- permission/data boundary;
- API or projection contract;
- lifecycle/failure;
- basic acceptance.

They do not require an independent scorer benchmark unless they make a quality claim.

### Foundation capabilities

Auth, privacy, quota, cost, observability and release gate are prerequisites for core capabilities. They require safety/acceptance evidence, not IELTS scorer calibration.

## 3. Readiness rule

```text
User Action
  → Interaction Spec
  → Runtime Boundary
  → Web Surface
  → Evidence
```

Any broken link means `not_ready`. Green validators only mean existing definitions are internally consistent; they do not close a missing link.
