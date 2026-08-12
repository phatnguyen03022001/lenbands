# OpenAPI Unification Review Packet — Batch B

## Status and scope

- **Status:** `review`; proposal only. No live OpenAPI file, Blueprint, registry, tool, gate, or evidence record was changed. The existing API ownership runtime contract received only the document-only Batch B reconciliation addendum recorded in this handoff; no duplicate owner or unresolved schema/path was promoted.
- **Source lock:** `source_locked=true` was reported by the toolchain validation. This packet does not authorize source mutation or runtime implementation.
- **Framework:** `v1.0.6`, verified by `tools/bin/lenbands verify`.
- **Canonicality:** The OpenAPI authority README explicitly says that one canonical API authority is **NOT YET** established and that the target unified root is planned but not created (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi/README.md:18-32`). The ownership contract already selects logical ownership for identity versus the P0 loop, but calls the transition incomplete (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/api-ownership-bff-contract.md:11-31`).
- **Readiness:** P0 remains `not_ready`. This packet makes no runtime-readiness claim.

### Evidence classification

- **Validator-proven:** output from the four required commands recorded in the handoff section below.
- **File-proven:** a claim directly supported by the cited repository file and line range.
- **Inference:** a bounded comparison or risk derived from cited file-proven facts; it is not a contract decision.
- **External-source-unverified:** no external provider, IELTS, corpus, calibration, or runtime claim is treated as verified in this packet. Numeric fields present in OpenAPI are reported as declared schema shape only.

### Controlled sources used

The two live specifications are:

- `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi.yaml` — OpenAPI `3.0.3`, `info.version 0.2.0`, five non-deprecated identity operations plus eight deprecated loop placeholders (`:1-19`, `:198-434`).
- `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml` — OpenAPI `3.1.0`, `info.version 0.5.0`, twenty-five P0 operations (`:1-11`, `:13-509`).

The README’s “5 live ops” wording is therefore treated as “five non-deprecated identity operations,” not as a count of all path definitions (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi/README.md:18-25`). The root file still contains eight live path definitions marked deprecated; this is a transition state, not an authority decision.

## 1. Inventory totals and ownership rule

The target rule is one logical HTTP API and one owning family per operation. Current ownership is a design projection, not runtime evidence: identity-only paths are assigned to the root surface, while placement, daily, writing, review, quota, quality-gate, and the loop profile are assigned to the Writing Task 2 surface (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/api-ownership-bff-contract.md:18-31`). The repository invariant requires exactly one owning family per API operation (`/Users/tienphat/Developer/lenbands/artifacts/operations/architecture-frozen.md:55-64`).

### Root specification: 13 path/method definitions

Disposition labels mean:

- `canonical candidate`: target logical owner is selected, but a single unified authority has not been created or approved.
- `legacy placeholder`: explicitly deprecated and not a build input; retained for traceability.
- `duplicate / transitional`: same path and method exists in the other file, with the root definition pointing to the P0 file.
- `conflicting / missing contract`: evidence shows a path, schema, lifecycle, privacy, or authorization decision is not yet reconciled.

| # | Method and path · operationId | Owner family / P0 capability | Request → response | Auth, idempotency, async | Lifecycle / events / failure / privacy boundary | Disposition; exact evidence |
|---:|---|---|---|---|---|---|
| 1 | `POST /v1/auth/session` · `createSession` | `IDENTITY.Core`; `IDENTITY.Auth` | `CreateSessionRequest` → `SessionResponse` | `security: []` guest; explicitly `x-idempotency-exempt`; synchronous `201` | Guest → authenticated/session states; safe `400/401/429/503`; provider token input is a transport gap against the BFF contract; no provider payload in errors | `canonical candidate`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi.yaml:45-75`, schemas `:482-508`; BFF/session alternatives `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi/README.md:134-150` |
| 2 | `GET /v1/me` · `getProfile` | `IDENTITY.Core`; `IDENTITY.Profile` | no body → `AccountProfile` | global bearer; no mutation idempotency; synchronous `200` | learner-owned profile, server-side opaque subject; `401/404`; conflicts with loop profile shape/path | `canonical candidate; conflicting profile surface`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi.yaml:77-98`, schema `:510-524`; ownership split `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/api-ownership-bff-contract.md:15-23` |
| 3 | `POST /v1/me/consents` · `recordConsent` | `IDENTITY.Core`; `IDENTITY.Privacy` | `RecordConsentRequest` → `ConsentRecord` | global bearer; `RequestId` + `Idempotency-Key`; synchronous `201` | consent must precede Writing submission; `400/401/403/409`; consent is learner-owned privacy state | `canonical candidate`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi.yaml:100-133`; identity minimum operations and consent boundary `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/auth-identity-contract.md:40-66` |
| 4 | `POST /v1/me/export` · `requestExport` | `IDENTITY.Core`; `IDENTITY.Privacy` | no body → `PrivacyRequest` | global bearer; `RequestId` + `Idempotency-Key`; asynchronous export job reference returned as `201` | export job/retry; `400/401/403/409`; cascade/export policy is defined outside OpenAPI | `canonical candidate`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi.yaml:135-161`; privacy contract `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/auth-identity-contract.md:54-66` |
| 5 | `POST /v1/me/deletion` · `requestDeletion` | `IDENTITY.Core`; `IDENTITY.Privacy` | `RequestDeletionRequest` → `PrivacyRequest` | global bearer; `RequestId` + `Idempotency-Key`; asynchronous deletion job reference returned as `201` | fresh-auth/re-auth required; deletion lifecycle and retry safety; `400/401/403/409`; learner-owned data cascade remains acceptance evidence | `canonical candidate`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi.yaml:163-197`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/auth-identity-contract.md:54-72` |
| 6 | `POST /v1/writing/submissions` · `createSubmission` | `WRITING.Evaluation`; `LEARN.Writing` | root `CreateSubmissionRequest` → root `WritingSubmission` | global bearer; `RequestId` + `Idempotency-Key`; `201` and no async contract in this placeholder | root accepts `essay_text`; root state is `[submitted, processing, scored, failed]`; P0 target is draft-reference based and async `202`; no event ownership is asserted here | `legacy placeholder; duplicate / transitional; conflicting schema/status/async`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi.yaml:198-235`, schemas `:627-655`; target `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:230-255`, schemas `:704-718` |
| 7 | `GET /v1/writing/submissions/{submissionId}/evaluation` · `getEvaluation` | `WRITING.Evaluation`; `EVAL.Writing` | no body → root `WritingEvaluation` | global bearer; read; synchronous `200` only in placeholder | no pending projection; P0 has `202 EvaluationPending`, `Retry-After`, bounded worker lifecycle; `401/404` | `legacy placeholder; duplicate / transitional; conflicting async/response contract`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi.yaml:236-261`; target `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:293-317`, runtime `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/api-ownership-bff-contract.md:49-51` |
| 8 | `GET /v1/writing/submissions/{submissionId}/feedback` · `getFeedback` | `WRITING.Evaluation`; `COACH.Feedback` | no body → root `WritingFeedback` | global bearer; read; synchronous `200` | explicitly has no canonical same-method successor; P0 only has `POST .../feedback` to record learner feedback; learner content must remain learner-scoped | `legacy placeholder; conflicting / missing same-method contract`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi.yaml:262-290`; P0 method `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:318-342`; ownership contract `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/api-ownership-bff-contract.md:25-31`, `:61-64` |
| 9 | `GET /v1/me/quota` · `getQuota` | `OPS.QualityEconomics`; `OPS.Quota` | no body → root `QuotaStatus` | global bearer; read; synchronous `200` | quota projection; P0 target has `QuotaState` and is owned by P0-06; `401` | `legacy placeholder; duplicate / transitional; schema projection differs`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi.yaml:291-313`, schema `:785-795`; target `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:343-356`, schema `:852-878` |
| 10 | `GET /v1/writing/errors` · `listWritingErrorsDeprecated` | `REVIEW.ErrorToReview`; `REVIEW.MistakeNotebook` | optional `submissionId` query → array `WritingError` | global bearer; read; synchronous `200` | deprecated root schema is not the P0 `LearningError` lifecycle; `401`; event ownership belongs to Review service, not this placeholder | `legacy placeholder; duplicate / transitional; schema/entity ownership differs`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi.yaml:314-343`; target `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:357-398`, schemas `:773-810`; lifecycle `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/lifecycle-contract.md:306-328` |
| 11 | `POST /v1/writing/errors/{errorId}/fixes` · `submitErrorFix` | `REVIEW.ErrorToReview`; `PRACTICE.Drill` | root `ErrorFixRequest` → root `ErrorFixResult` | global bearer; `RequestId` + `Idempotency-Key`; synchronous `201` | root response is not P0 `FixEvidence`; fix evidence must not directly mark `improved`; `400/401/404/409` | `legacy placeholder; duplicate / transitional; response/lifecycle contract differs`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi.yaml:344-379`, schemas `:747-764`; target `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:416-440`, runtime `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/runtime-spec.md:237-274` |
| 12 | `POST /v1/writing/errors/{errorId}/retest` · `retestError` | `REVIEW.ErrorToReview`; `PRACTICE.Drill` | no body → root `ErrorFixResult` | global bearer; `RequestId` + `Idempotency-Key`; root `201`, P0 target async `202` | retest is a separate async `RetestAttempt`; `400/401/404/409`; no source-task reuse | `legacy placeholder; duplicate / transitional; response/status/async contract differs`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi.yaml:380-409`; target `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:442-465`, lifecycle `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/lifecycle-contract.md:353-372` |
| 13 | `GET /v1/review/cards` · `getReviewCards` | `REVIEW.ErrorToReview`; `REVIEW.SmartQueue` | no body → array root `ReviewCard` | global bearer; read; synchronous `200` | root is a placeholder; P0 queue is learner-owned and FSRS-backed; `401` | `legacy placeholder; duplicate / transitional; schema projection differs`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi.yaml:410-434`, schema `:766-784`; target `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:466-484`, schema `:891-906` |

### Writing Task 2 specification: 25 path/method definitions

For this table, `B` means the global `bearerAuth` requirement at `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:5-11`; `I` means the shared required `Idempotency-Key` parameter at `:523-528`; `S` is synchronous; `A` is explicitly asynchronous or has an asynchronous pending projection. OpenAPI does not declare per-operation scopes, so the permission column reports the runtime contract’s server-side scope and marks missing OpenAPI expression as a contract gap. The API governance contract requires Bearer access, correlation, idempotency for mutations, safe error envelopes, and server-side ownership (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/api-governance-contract.md:7-31`).

| # | Method and path · operationId | Owner family / P0 capability | Request → response | Auth, idempotency, async | Lifecycle / events / failure / privacy boundary | Disposition; exact evidence |
|---:|---|---|---|---|---|---|
| 1 | `GET /v1/me/profile` · `getMyProfile` | `IDENTITY.Core`; `IDENTITY.Profile` | no body → `LearnerProfile` | `B`; read; `S`; learner ownership not encoded as an OpenAPI scope | profile projection; `401`; schema differs from root `AccountProfile` | `canonical candidate; conflicting profile surface`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:14-25`, schemas `:587-594`; root `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi.yaml:77-98`, `:510-524` |
| 2 | `PUT /v1/me/profile` · `updateMyProfile` | `IDENTITY.Core`; `IDENTITY.Profile` | `UpdateProfileRequest` → `LearnerProfile` | `B; I`; `S`; learner write scope required by auth contract but not declared in OpenAPI | profile update; `400/401`; target-band shape is file-declared only, not external IELTS evidence | `canonical candidate; conflicting profile surface`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:26-44`, schemas `:595-601`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/auth-identity-contract.md:25-38` |
| 3 | `POST /v1/placement` · `startPlacement` | `PLACEMENT.Diagnosis`; `PLACE.Test`, `GOAL.Target` | `StartPlacementRequest` → `PlacementAttempt` | `B; I`; `S` response, later diagnosis may be async by domain contract | placement status `[new, in_progress, paused, submitted, diagnosed, insufficient_data]`; `placement_started/completed`; insufficient-data safe failure; response text must remain reference/storage scoped | `canonical candidate; conflicting path with runtime contract`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:45-64`, schemas `:602-621`; runtime contract paths and privacy `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/placement-diagnosis-contract.md:22-49` |
| 4 | `POST /v1/placement/{attemptId}/responses` · `submitPlacementResponse` | `PLACEMENT.Diagnosis`; `PLACE.Test` | `PlacementResponseRequest` → `PlacementAttempt` | `B; I`; `S` persistence | response references `item_ref`; placement attempt state; `400/404`; raw response not in events | `canonical candidate; conflicting path with runtime contract`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:65-85`, schemas `:608-621`; runtime contract `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/placement-diagnosis-contract.md:22-49` |
| 5 | `GET /v1/placement/{attemptId}` · `getPlacementAttempt` | `PLACEMENT.Diagnosis`; `PLACE.Test`, `PLACE.BandEstimation` | no body → `PlacementAttempt` | `B`; read; `S` projection | returns state/result reference; `404`; calibration/provenance remains required in placement result contract | `canonical candidate; conflicting result path with runtime contract`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:86-99`, schema `:614-621`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/placement-diagnosis-contract.md:7-20`, `:22-49` |
| 6 | `GET /v1/today` · `getTodayPlan` | `STUDY.DailyAction`; `STUDY.DailyPlan`, `PERSONAL.NextBestAction` | no body → `DailyPlan` | `B`; read; `S`; fallback states are explicit | `[plan_ready, no_plan, plan_stale, plan_unavailable, fallback_offered]`; `daily_plan_generated`; no-plan/stale/unavailable fallback; no raw learner content in events | `canonical candidate; missing check-in companion contract`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:100-118`, schema `:622-641`; daily contract `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/daily-action-contract.md:7-29`, `:50-75` |
| 7 | `POST /v1/study/sessions` · `startStudySession` | `STUDY.DailyAction`; `STUDY.MicroSession` | `StartSessionRequest` → `StudySession` | `B; I`; `S` `201` | state begins `started`; `session_started`; action must be in current plan; duplicate-safe | `canonical candidate; path differs from runtime contract’s hyphenated endpoint`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:119-137`, schemas `:642-660`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/daily-action-contract.md:50-75` |
| 8 | `PATCH /v1/study/sessions/{sessionId}` · `updateStudySession` | `STUDY.DailyAction`; `STUDY.MicroSession` | `UpdateSessionRequest` → `StudySession` | `B; I`; `S` `200` | permits pause/resume/complete/abandon through state; `session_paused/completed/...`; completion must be idempotent | `canonical candidate; method/path differs from runtime contract’s explicit complete operation`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:138-157`, schemas `:647-660`; daily contract `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/daily-action-contract.md:50-75` |
| 9 | `GET /v1/ops/quality-gate` · `getQualityGate` | `OPS.QualityEconomics`; `OPS.ReleaseGate`, `GOVERNANCE.AuditTrail` | no body → `QualityGate` | `B`; read; `S`; `admin:governance` required by runtime contract but not expressed in OpenAPI | ReleaseGateDecision states exactly `[unarmed, collecting_evidence, blocked, approved_for_pilot, rolled_back]`; audit record; `403`; no readiness inference from response | `canonical candidate; permission annotation gap`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:158-169`, schema `:669-678`; lifecycle `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/lifecycle-contract.md:398-417`; admin binding `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi/README.md:103-119` |
| 10 | `POST /v1/ops/quality-gate` · `evaluateQualityGate` | `OPS.QualityEconomics`; `OPS.ReleaseGate` | `EvaluateQualityGateRequest` → `QualityGate` | `B; I`; `S` `200`; admin scope not expressed in OpenAPI | immutable evidence refs only; gate decision/audit; `403`; no direct corpus/threshold invention | `canonical candidate; permission annotation gap`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:170-187`, schemas `:661-678`; quality runtime `/Users/tienphat/Developer/lenbands/artifacts/engineering/runtime/quality-economics-runtime.md:13-23`, `:57-79` |
| 11 | `GET /v1/writing/tasks/{taskId}` · `getWritingTask` | `WRITING.Evaluation`; `LEARN.Writing` | no body → `WritingTask` | `B`; read; `S` `200` | only published task; `404`; task content is learner-facing knowledge/content, not event/log payload | `canonical candidate`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:188-204`, schema `:679-688`; runtime `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/runtime-spec.md:118-135` |
| 12 | `PUT /v1/writing/drafts/{draftId}` · `saveWritingDraft` | `WRITING.Evaluation`; `PKM.Drafts` | `SaveDraftRequest` → `WritingDraft` | `B; I`; `S` `200`; optimistic version in request | draft version/conflict; `409` version conflict; `writing_draft_saved` carries refs only; learner text is private | `canonical candidate`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:205-229`, schemas `:689-703`; data/privacy `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/data-contract.md:17-25`, `:27-39`; event `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/event-contract.md:5-17` |
| 13 | `POST /v1/writing/submissions` · `createWritingSubmission` | `WRITING.Evaluation`; `LEARN.Writing`, `EVAL.Writing` | `CreateSubmissionRequest` → `WritingSubmission` | `B; I`; `A` `202` | submission → processing; durable job/outbox; `400/401/403/409/422/429`; event `writing_submission_accepted`; draft text stays behind scoped storage | `canonical candidate; target of root duplicate`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:230-255`, schemas `:704-718`; runtime `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/runtime-spec.md:161-190` |
| 14 | `GET /v1/writing/submissions/{submissionId}` · `getWritingSubmission` | `WRITING.Evaluation`; `LEARN.Writing` | no body → `WritingSubmission` | `B`; read; `S` projection | learner-owned lifecycle `[submitted, processing, delayed, scored, low_confidence, unavailable]`; cross-user `404` | `canonical candidate`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:256-272`, schemas `:710-718`; runtime `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/runtime-spec.md:203-218` |
| 15 | `POST /v1/writing/submissions/{submissionId}/retry` · `retryWritingEvaluation` | `WRITING.Evaluation`; `EVAL.Writing` | no body → `WritingSubmission` | `B; I`; `A` `202` | bounded retry only for delayed/unavailable; no new submission; `409` for invalid state; job idempotency | `canonical candidate`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:273-292`, runtime `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/runtime-spec.md:203-218`, `:329-351` |
| 16 | `GET /v1/writing/submissions/{submissionId}/evaluation` · `getWritingEvaluation` | `WRITING.Evaluation`; `EVAL.Writing` | no body → `WritingEvaluation` (`200`) or `EvaluationPending` (`202`) | `B`; read; `A` pending projection with `Retry-After` | evaluation lifecycle `[submitted, processing, scored, low_confidence, invalid, anti_gaming_review, failed]`; evaluation events; safe delayed/unavailable states; no score promotion on low confidence | `canonical candidate; target of root duplicate`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:293-317`, schemas `:719-747`; runtime `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/runtime-spec.md:203-218`, event `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/event-contract.md:5-17` |
| 17 | `POST /v1/writing/submissions/{submissionId}/feedback` · `submitWritingFeedback` | `WRITING.Evaluation`; `COACH.Feedback` | `FeedbackRequest` → `FeedbackReceipt` | `B; I`; `S` `201` | records learner feedback without changing score; `400/404/409`; note is learner content and must not enter logs/events/errors | `canonical candidate; no root same-method duplicate`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:318-342`, schemas `:839-851`; runtime `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/api-governance-contract.md:21-31` |
| 18 | `GET /v1/me/quota` · `getMyQuota` | `OPS.QualityEconomics`; `OPS.Quota` | no body → `QuotaState` | `B`; read; `S` | quota preflight projection; `401`; root is deprecated duplicate | `canonical candidate; target of root duplicate`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:343-356`, schema `:852-878` |
| 19 | `GET /v1/writing/errors` · `listWritingErrors` | `REVIEW.ErrorToReview`; `REVIEW.MistakeNotebook` | optional status query → `LearningErrorList` | `B`; read; `S` | status enum includes `[open, in_review, improved, dismissed]` in filter; persisted model also has `resolved, recurring`; `401`; event ownership is Review service | `canonical candidate; target of root duplicate`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:357-375`, schemas `:787-810`; lifecycle `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/lifecycle-contract.md:308-328` |
| 20 | `POST /v1/writing/errors` · `saveWritingError` | `REVIEW.ErrorToReview`; `REVIEW.MistakeNotebook` | `SaveErrorRequest` → `LearningError` | `B; I`; `S` `201` | learner confirmation required; `learning_error_saved`; `400/401/404/409`; evidence ref only in event, no raw error text | `canonical candidate; target of root duplicate`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:376-398`, schemas `:773-810`; error contract `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/error-to-review/event-contract.md:5-18` |
| 21 | `GET /v1/writing/errors/{errorId}` · `getWritingError` | `REVIEW.ErrorToReview`; `REVIEW.MistakeNotebook` | no body → `LearningError` | `B`; read; `S` | learner-owned error lifecycle; `404` prevents cross-user oracle; private evidence ref | `canonical candidate`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:399-415`, schema `:787-803`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/error-to-review/data-contract.md:7-30` |
| 22 | `POST /v1/writing/errors/{errorId}/fixes` · `completeWritingErrorFix` | `REVIEW.ErrorToReview`; `PRACTICE.Drill` | `CompleteFixRequest` → `FixEvidence` | `B; I`; `S` `201` | fix evidence saved but does not mark improved; `400/401/404/409`; evidence is learner content and private | `canonical candidate; target of root duplicate`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:416-440`, schemas `:814-826`; runtime `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/runtime-spec.md:264-274` |
| 23 | `POST /v1/writing/errors/{errorId}/retest` · `startWritingErrorRetest` | `REVIEW.ErrorToReview`; `PRACTICE.Drill` | optional `RetestRequest` → `Retest` | `B; I`; `A` `202` | RetestAttempt `[created, submitted, processing, completed, unavailable]`; `retest_started/completed`; `404/409/429`; new content, same error pattern, no source reuse | `canonical candidate; target of root duplicate`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:442-465`, schema `:879-890`; lifecycle `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/lifecycle-contract.md:353-372` |
| 24 | `GET /v1/review/cards` · `listReviewCards` | `REVIEW.ErrorToReview`; `REVIEW.SmartQueue`, `REVIEW.FSRS` | optional state query → `ReviewCardList` | `B`; read; `S` | active queue states `[new, learning, review, relearning]`; `401`; source error required for error cards | `canonical candidate; target of root duplicate`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:466-484`, schema `:891-906`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/error-to-review/data-contract.md:32-55` |
| 25 | `POST /v1/review/cards/{cardId}/ratings` · `rateReviewCard` | `REVIEW.ErrorToReview`; `REVIEW.FSRS` | `RateReviewCardRequest` → `ReviewCardRating` | `B; I`; `S` `200` | FSRS rating exactly once; durable transition before `review_completed`; `400/401/404/409`; rating enum is `[again, hard, good, easy]` | `canonical candidate`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:485-509`, schemas `:827-838`; event/lifecycle `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/error-to-review/event-contract.md:20-42`, `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/lifecycle-contract.md:330-350` |

## 2. Confirmed conflicts and rejected false positives

### Confirmed conflicts or missing contract decisions

| Severity | Conflict type | Evidence and executor/learner impact | Status and minimum direction |
|---|---|---|---|
| High | Path/method + schema + ownership: profile | Root owns `GET /v1/me` → `AccountProfile`; P0 owns `GET/PUT /v1/me/profile` → `LearnerProfile`. The ownership contract says identity-only `/v1/me` but also says profile is in the loop surface (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/api-ownership-bff-contract.md:18-23`). A client or executor cannot know whether these are two intentional projections or competing profile authorities. | Engineering decision required; keep both only as explicitly additive projections during migration, with one canonical shared schema and a documented successor/retirement relation. No endpoint is deleted in this batch. |
| High | Auth/transport + schema: session | Root accepts `provider_token` and optional `provider` (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi.yaml:482-508`), while the A3 contract requires BFF-mediated input of validated `id_token` or `authorization_code`, opaque internal tokens, and BFF-only calling (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi/README.md:134-150`). A browser/client can be directed to the wrong credential boundary. | Existing founder D-02 identity-provider choice plus engineering/CODEOWNERS contract review required. Do not name a provider or choose an input shape in this packet. |
| High | Path/method: placement | P0 OpenAPI uses `POST /v1/placement`, `POST /v1/placement/{attemptId}/responses`, and `GET /v1/placement/{attemptId}` (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:45-99`); the placement contract specifies `/v1/placement/attempts`, `PUT /v1/placement/attempts/{attemptId}`, `POST .../submit`, and `/v1/placement/results/{attemptId}` (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/placement-diagnosis-contract.md:22-49`). The executor cannot implement both as one path authority without an explicit mapping. | Engineering/CODEOWNERS reconciliation required. The P0 OpenAPI is the current logical target by ownership contract, but that is not permission to silently rewrite the placement contract. |
| High | Path/method: daily action/check-in | P0 OpenAPI has `GET /v1/today`, `POST /v1/study/sessions`, and `PATCH /v1/study/sessions/{sessionId}` (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:100-157`); the daily contract specifies `POST /v1/today/check-in`, `POST /v1/study-sessions`, and `POST /v1/study-sessions/{sessionId}/complete` (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/daily-action-contract.md:50-75`). Check-in has no P0 operation and completion has a different method/path. The learner flow cannot be tested against one stable surface. | Engineering/CODEOWNERS reconciliation required. Do not invent a check-in schema or choose a rename as applied. |
| High | Transitional duplicate + method mismatch | Seven root loop path/methods duplicate P0 operations and are explicitly deprecated; root `GET /feedback` has no P0 same-method successor (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi.yaml:198-434`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/api-ownership-bff-contract.md:25-31`). A consumer using the wrong file can generate deprecated calls or an unimplemented feedback read. | The duplication is intentional transition state, not a current build instruction. It blocks completion of unification until deprecation metadata, migration window, release record, sunset, and retirement treatment are completed. For orphan GET feedback, remove only from the non-authoritative reference at the end of the approved migration or create a separately approved read contract; do not invent a successor now. |
| High | Schema/status/async: writing submission/evaluation/retest | Root placeholders use `essay_text`, `201`, root state `[submitted, processing, scored, failed]`, and no pending evaluation response; P0 uses draft references, `202`, delayed/unavailable, `EvaluationPending`, and bounded retry (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi.yaml:198-260`, `:627-675`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:230-317`, `:704-747`). An executor could charge, enqueue, or poll under incompatible semantics. | P0 contract is the candidate target because the ownership contract names it the selected logical candidate surface for the runtime loop. Treat the root definitions only as legacy placeholders; no live file is changed here. |
| Medium | Privacy/error contract under-specification | P0 and root schemas contain learner-scoped content fields, while the governance contract forbids raw learner content, provider payloads, and stack traces in error bodies (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/api-governance-contract.md:21-31`). P0 `UserSafeFailure.message` is unconstrained (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:907-920`), and the authority README says privacy markers are not consistently present (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi/README.md:154-160`). A false-safe error projection could leak content or provider detail. | Engineering/CODEOWNERS review must define one shared safe-error schema and validate privacy markers at the target root. Learner input remains private API data; it must never be copied into events, logs, queues, telemetry, or error payloads. |
| Medium | Authorization annotation | Both live specs use bearer authentication, but admin operations only expose `403`; `admin:governance` is required by the identity contract and README binding (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/auth-identity-contract.md:25-38`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi/README.md:103-119`). The OpenAPI documents do not express the scope per operation. | Engineering/CODEOWNERS review must choose one provider-neutral, server-enforced security representation. Do not add a new scope. |
| Medium | Lifecycle filter projection | `LearningError` persisted lifecycle includes `resolved` and `recurring`, while the list query filter only declares `[open, in_review, improved, dismissed]` (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/lifecycle-contract.md:308-328`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:357-375`, `:787-803`). A learner or executor cannot request all controlled states through the declared filter. | Engineering/CODEOWNERS decision required: either document the filter as active-queue-only or reconcile it to the full controlled lifecycle. Do not invent a replacement enum. |

### Rejected false positives and intentional scope

| Candidate concern | Why it is not a confirmed defect | Evidence |
|---|---|---|
| “The two files themselves prove two competing owners.” | The files are a deliberate transitional representation: identity logical ownership is root, loop logical ownership is P0, and root loop definitions are marked deprecated with `x-canonical-owner`. This is incomplete deprecation, not evidence that both are intended build authorities. | `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/api-ownership-bff-contract.md:11-31`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi.yaml:7-17`, `:198-207` |
| “ReviewCard is invalid because lifecycle has `graduated` but the queue schema does not.” | The lifecycle coverage matrix explicitly treats `new` versus `created` as a representation difference and `graduated` as an internal terminal state omitted from the active learner queue. It directs any future history endpoint to handle graduated separately. | `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/lifecycle-coverage-matrix.md:56-63`, `:90-98` |
| “Admin dashboard operations are missing P0 endpoints.” | The dashboard’s additional audit, metrics, and raw-preview surfaces are explicitly deferred; raw preview is break-glass and requires founder-approved policy. P0 quality-gate GET/POST are the defined P0 surface. | `/Users/tienphat/Developer/lenbands/artifacts/experience/specs/vertical-slices/governance-ops-dashboard.md:1-22`, `:75-106`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi/README.md:103-119` |
| “Anti-gaming should be added to the P0 OpenAPI.” | The governance dashboard explicitly marks `GOVERNANCE.AntiGaming` as P1-gated and requires an empty/placeholder queue until a real detector exists. No P1 endpoint is promoted here. | `/Users/tienphat/Developer/lenbands/artifacts/experience/specs/vertical-slices/governance-ops-dashboard.md:1-7`, `:53-72` |
| “Different operationIds alone prove a conflict.” | The root file documents that operationIds were renamed to avoid cross-file collisions while retaining deprecated traceability. The actual conflict is the duplicate path/method and incompatible schema/status, not the identifier spelling. | `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi.yaml:314-325`, `:344-353`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/api-ownership-bff-contract.md:18-31` |
| “The declared band ranges prove official IELTS semantics.” | The packet reports only the file-declared numeric shape. No official IELTS, calibration, corpus, or measurement evidence was used or fabricated. | `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:587-600`, `:719-757`; measurement and readiness remain outside this review. |

## 3. Target unification design (proposal only)

### Recommended structure

Use the already documented target location as a proposed unified root; do not create it in Batch B:

```text
/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi/p0-runtime.yaml
├── paths/identity.yaml
├── paths/placement.yaml
├── paths/daily-action.yaml
├── paths/writing.yaml
├── paths/review.yaml
├── paths/ops.yaml
└── common/
    ├── headers.yaml
    ├── parameters.yaml
    ├── responses.yaml
    └── schemas/
        ├── identity.yaml
        ├── placement.yaml
        ├── daily-action.yaml
        ├── writing.yaml
        ├── review.yaml
        └── ops.yaml
```

The root would own one `paths` entry per exact path/method and `$ref` each schema exactly once. The directory and schema grouping are aligned to the existing target structure in `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi/README.md:27-53`; the `paths/` split is a review-packet proposal, not an existing file claim.

### Canonical ownership rule

1. The unified root is the only client-generation and contract-test authority after adoption; the two current files become explicitly historical transition inputs.
2. Exact path/method ownership is unique. The current logical allocation is identity-only paths (`/v1/auth/session`, `/v1/me`, `/v1/me/consents`, `/v1/me/export`, `/v1/me/deletion`) to the identity side and all other P0 loop paths to the Writing Task 2 side (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/api-ownership-bff-contract.md:18-23`).
3. Schema ownership is also unique. `AccountProfile` versus `LearnerProfile`, `QuotaStatus` versus `QuotaState`, root writing schemas versus P0 writing schemas, and root error/review projections cannot both remain canonical. No merge mapping is applied by this packet.
4. Existing P0 capability ownership is preserved: P0-01 Identity, P0-02 Diagnosis, P0-03 Daily action, P0-04 Writing evaluation, P0-05 Error-to-review, and P0-06 Quality & economics are the controlled pack boundaries in `/Users/tienphat/Developer/lenbands/blueprint/03-features.md:311-316` and the P0 `x-owner-pack` declarations in `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:14-509`.
5. Event ownership remains outside OpenAPI. The unified spec may reference event/lifecycle contracts, but it must not assign an unknown event owner, schema, producer, or state.

### Exact migration/deprecation order

This sequence follows the existing deprecation contract; it is not applied here:

1. **Announce:** record `Deprecation: true`, `x-deprecated-at`, `x-sunset`, and a real `x-successor` for each deprecated operation, plus a release record. The current `deprecated: true` and `x-canonical-owner` markers do not complete this sequence (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi/README.md:121-132`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/api-ownership-bff-contract.md:33-38`).
2. **Additive target:** add the unified root and modular `$ref`s while the current representations remain readable for migration. Do not delete or rename a live endpoint in this batch.
3. **Consumer migration:** migrate server-side callers, BFF/SSR callers, generated clients, contract tests, and documentation to the unified root’s chosen path/schema. Verify authz, idempotency, async, failure, and privacy behavior with post-code evidence; this packet does not claim that evidence exists.
4. **Sunset:** after the stated migration window, return `410 Gone` from the retired operation with the successor reference. The orphan `GET /feedback` has no successor to invent; it requires explicit retirement or a separately approved read contract.
5. **Remove:** physically remove the old operation only after one additional API version and a release record. The breaking-change rule remains `/v2/` for breaking changes (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/api-governance-contract.md:33-48`).

### Alternatives and decision ownership

| Decision | Alternative A | Alternative B | Evidence-supported recommendation | Decision owner |
|---|---|---|---|---|
| Root authority | Create proposed unified `openapi/p0-runtime.yaml` with modular refs | Keep two live canonical surfaces indefinitely | A is the only option consistent with the README’s planned atomic unification and the one-owner invariant; it is not yet applied | Engineering; CODEOWNERS review for repository-protected enforcement |
| Profile path/schema | Keep both paths temporarily as additive projections, converge to one shared schema and explicit retirement path | Retire `/v1/me` or `/v1/me/profile` immediately | Do not delete now. Evidence does not select the public path or representation; reconcile first | Engineering/CODEOWNERS; founder only if product-facing profile semantics change |
| Session input | BFF-validated `id_token`/`authorization_code` or service-key exchange | Root `provider_token` request | Do not choose here. Existing A3 explicitly leaves provider/input choice to D-02 founder decision | Founder D-02 plus Engineering/CODEOWNERS |
| Placement and daily paths | Reconcile to the P0 OpenAPI path set because ownership contract names it the candidate P0 runtime surface | Reconcile to the separate runtime-contract paths | No silent choice. The P0 OpenAPI is the current candidate, but runtime contracts must be reconciled before adoption | Engineering/CODEOWNERS |
| Root `GET /feedback` | Retire from non-authoritative reference after migration | Invent a canonical GET feedback operation | Retire only if no consumer requires a read; otherwise produce a separate approved contract. Do not invent a path or schema | Engineering/CODEOWNERS; founder only if scope/product outcome changes |
| Admin and anti-gaming | Keep P0 quality-gate GET/POST; leave audit/metrics/raw-preview deferred and AntiGaming P1-gated | Promote deferred/P1 endpoints into P0 | A; this preserves current lifecycle and phase boundaries | Engineering/CODEOWNERS; founder approval required for any scope promotion |

## 4. Red-team verification of the proposal

### Exactly one owner per operation

- The P0 file declares one `x-owner-pack` on each of its 25 operations (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:14-509`).
- The root file declares five identity operations and explicitly routes its eight loop placeholders to the P0 file using `deprecated: true` and `x-canonical-owner` (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi.yaml:7-17`, `:198-434`).
- Therefore the current **logical** owner assignment is file-proven, but exact-one-owner **runtime behavior** is not proven. The seven duplicate path/method pairs and orphan GET feedback must be retired or otherwise reconciled before claiming a single canonical authority. Classification: file-proven plus bounded inference.

### Raw learner-content boundary

- Private learner content is declared in draft, placement response, submission/fix/feedback fields (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:608-613`, `:689-694`, `:814-844`). This is not by itself a violation: it is learner-scoped API data.
- The event contracts require opaque references and prohibit raw essay, prompt, provider payload, and error evidence text in events (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/event-contract.md:5-17`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/error-to-review/event-contract.md:5-18`, `:44-55`). The data contract also prohibits text in events/logs (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/data-contract.md:17-25`).
- The live OpenAPI files do not consistently carry privacy markers, and the safe-error message is unconstrained (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi/README.md:154-160`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:907-920`). The target must therefore be treated as privacy-unproven until semantic validation and redaction evidence exist. No learner raw content is included in this packet.

### No invented schema or state

- This packet uses only declared framework/capability IDs and contract states. Unknown event owners, schemas, producers, privacy classes, and any unresolved path mappings remain named gaps.
- Placement and daily path conflicts are not silently normalized. ReviewCard `graduated` is not promoted into the queue enum because the lifecycle coverage matrix explicitly calls it an internal terminal state and directs separate history treatment (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/lifecycle-coverage-matrix.md:90-98`).
- Numeric band shapes in the specs (`0..9`, `0.5` increments) are reported as file declarations only; they are not asserted as official IELTS facts or calibrated measurements (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:587-600`, `:719-757`).

### Auth/BFF boundary remains server-side and provider-neutral

- The identity contract maps provider claims to an opaque server-side subject and reserves `admin:governance` for governance actions (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/auth-identity-contract.md:9-38`).
- The BFF contract requires server-side token handling and says the browser must not hold a raw provider JWT; the exact session transport remains incomplete (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/api-ownership-bff-contract.md:40-51`).
- The root’s provider-token schema conflicts with the provider-neutral BFF design. No provider, DPA, or identity implementation is selected in this packet. Existing D-02 is the founder decision dependency.

### No P1/P2 promotion

- All 25 operations in the P0 specification are explicitly assigned to P0-01 through P0-06 (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/writing-task-2/openapi.yaml:14-509`).
- Governance’s anti-gaming surface is explicitly P1-gated and remains placeholder-only; deferred audit/metrics/raw-preview surfaces are not promoted (`/Users/tienphat/Developer/lenbands/artifacts/experience/specs/vertical-slices/governance-ops-dashboard.md:1-22`, `:53-72`).

## 5. Decision, review, and non-readiness statement

### Recommendation

This Batch B deliverable can proceed as a normal, non-protected engineering-document review packet. Applying the live-spec unification is **not yet cleared**: it is blocked on explicit engineering reconciliation of profile, session transport, placement, daily action, orphan feedback, privacy/error annotation, and authorization-expression decisions listed above. The existing founder D-02 decision is required for the final session transport shape. No new PD-08 is added because no new protected/founder decision is evidenced beyond D-02; adding one would duplicate the canonical founder index.

No endpoint was merged, renamed, deleted, or edited. No schema, event, state, provider, IELTS fact, calibration result, corpus result, or readiness claim was invented. `gate p0` remains truthful and blocked.

### Founder decisions required

- Existing **D-02 OIDC identity-provider selection** is required before finalizing the `/v1/auth/session` BFF input/output contract; it is already tracked in `/Users/tienphat/Developer/lenbands/artifacts/operations/founder-review-packet-index.md:21-27`.
- A founder decision is not evidenced as necessary for the path/schema reconciliation itself unless the choice changes the product-facing profile, identity, or P0 scope. If scope is promoted (for example, deferred admin or P1 anti-gaming), a founder scope decision is required.

### Engineering and CODEOWNERS review required

- Engineering must reconcile the path/schema/lifecycle differences before any live-spec edit.
- Repository trust policy requires external CODEOWNERS review and protected-change attestation when a protected path or validator/gate boundary is changed (`/Users/tienphat/Developer/lenbands/artifacts/operations/agent-trust-policy.yaml:253-279`). The current CODEOWNERS file maps the repository default and protected paths to `@tienphat` (`/Users/tienphat/Developer/lenbands/.github/CODEOWNERS:1-26`); this packet does not treat that mapping as evidence that an external review has occurred.
- The packet itself is not a protected-path change. No founder index update was made because no PD-08 was added.

### Explicit non-readiness

The two live specifications are not unified, the canonical API authority is not yet established, the design contracts are pre-code, and P0 is not ready. Passing `verify` and the toolchain gate validates repository contracts only; it does not prove runtime behavior, acceptance, benchmark, corpus, calibration, provider, or release readiness (`/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/runtime/api-ownership-bff-contract.md:3-7`; `/Users/tienphat/Developer/lenbands/artifacts/engineering/contracts/openapi/README.md:14-25`).

## 6. P0-02 / P0-03 Transport Reconciliation (Phase 2.1 — 2026-08-11)

This section records the evidence-backed endpoint/operation/state ownership map for P0-02 (PLACEMENT.Diagnosis) and P0-03 (STUDY.DailyAction), reconciling every API reference across both live OpenAPI surfaces, the runtime contracts, the transport-classification, the capability-manifest, and the lifecycle-contract. No endpoint, schema, state, event, or owner was invented. No single OpenAPI authority was declared by prose.

### 6.1 P0-02 — PLACEMENT.Diagnosis (7 capabilities, 3 HTTP operations)

#### 6.1.1 Capability-to-transport map

| Capability | Transport class | OpenAPI operationId | OpenAPI path | Contract path (conflicting) | Resolution status |
|---|---|---|---|---|---|
| GOAL.Target | `public-http` | `startPlacement` | `POST /v1/placement` (via `goal_ref`) | — | No conflict |
| PLACE.Test | `public-http` | `startPlacement`, `submitPlacementResponse` | `POST /v1/placement`, `POST /v1/placement/{attemptId}/responses` | `POST /v1/placement/attempts`, `PUT /v1/placement/attempts/{attemptId}`, `POST /v1/placement/attempts/{attemptId}/submit` (`placement-diagnosis-contract.md:60-62`) | **UNRESOLVED** — two different path designs; OpenAPI is the candidate per ownership contract; contract must be reconciled before implementation |
| PLACE.BandEstimation | `internal-command` | — | surfaced in `GET /v1/placement/{attemptId}` | — | No conflict |
| PLACE.GapDetection | `internal-command` | — | surfaced in `GET /v1/placement/{attemptId}` | — | No conflict |
| PLACE.InitialPath | `internal-command` | — | surfaced in `GET /v1/placement/{attemptId}` | — | No conflict |
| PLACE.SkillDiagnosis | `internal-command` | — | surfaced in `GET /v1/placement/{attemptId}` | — | No conflict |
| BAND.Current | `event-projection` | — | `GET /v1/placement/{attemptId}` | `GET /v1/placement/results/{attemptId}` (`placement-diagnosis-contract.md:63`) | **UNRESOLVED** — contract uses `/results/` prefix; OpenAPI returns results via `result_ref` in the attempt object |

#### 6.1.2 State reconciliation

| Entity | OpenAPI enum | Contract status | Lifecycle canonical_states | Agreement |
|---|---|---|---|---|
| `PlacementAttempt.state` | `[new, in_progress, paused, submitted, diagnosed, insufficient_data]` `openapi.yaml:619` | Identical `contract:30` | Identical `lifecycle-contract.md:153` | **ALL THREE MATCH** ✓ |
| P0-02 manifest states | — | — | — | **STALE**: manifest `:53` uses `[not_started, in_progress, scored, insufficient_evidence, retry_required]` — tracked as B2-P0-02 |

#### 6.1.3 Placement conflict: smallest safe resolution

The contract defines four operations; the OpenAPI defines three. The path structures differ at the resource-name level (`/v1/placement` vs `/v1/placement/attempts`; `/{attemptId}/responses` vs `/attempts/{attemptId}/submit`; `/{attemptId}` vs `/results/{attemptId}`).

**Resolution direction (implementation-blocked until engineering reconciliation):** Align the contract API table and `placement-diagnosis-runtime.md` to the OpenAPI paths. The OpenAPI is the candidate runtime surface per the ownership contract. Three operations cover the same lifecycle: `startPlacement` (create attempt + optional goal), `submitPlacementResponse` (submit individual item responses, equivalent to contract's PUT + submit), `getPlacementAttempt` (returns full state including band/gap/diagnosis/path — equivalent to contract's GET /results).

### 6.2 P0-03 — STUDY.DailyAction (4 capabilities, 3 HTTP operations)

#### 6.2.1 Capability-to-transport map

| Capability | Transport class | OpenAPI operationId | OpenAPI path | Contract path (conflicting) | Resolution status |
|---|---|---|---|---|---|
| STUDY.DailyPlan | `public-http` | `getTodayPlan` | `GET /v1/today` | `GET /v1/today` (`daily-action-contract.md:73`) | **MATCH** ✓ |
| STUDY.CheckIn | `public-http` | `startStudySession` (mapped at `transport-classification.yaml:104`) | `POST /v1/study/sessions` | `POST /v1/today/check-in` (`daily-action-contract.md:74`) | **UNRESOLVED** — CheckIn has no dedicated endpoint in any OpenAPI file; transport-classification mis-maps it to `startStudySession`, which starts a plan action and does not capture check-in data (`minutes_available`, `energy`). The check-in data contract entity (`check_in` at `daily-action-contract.md:27-30`) is absent from `capability-manifest.yaml:89` data_entities. |
| STUDY.MicroSession | `public-http` | `startStudySession`, `updateStudySession` | `POST /v1/study/sessions`, `PATCH /v1/study/sessions/{sessionId}` | `POST /v1/study-sessions`, `POST /v1/study-sessions/{sessionId}/complete` (`daily-action-contract.md:75-76`) | **UNRESOLVED** — path format mismatch (hyphen vs slash); completion method mismatch (dedicated POST vs PATCH state transition); resume transition (`paused → started`) inexpressible via OpenAPI `UpdateSessionRequest.state` which is `[paused, completed, abandoned]` |
| PERSONAL.NextBestAction | `internal-command` | — | surfaced in `GET /v1/today` | — | No conflict |

#### 6.2.2 State reconciliation

| Entity | OpenAPI enum | Contract status | Lifecycle canonical_states | Agreement |
|---|---|---|---|---|
| `StudySession` | `state` enum `[started, paused, completed, abandoned]` `openapi.yaml:658` | `status` field same enum values `contract:34` | Identical `lifecycle-contract.md:221` | **MATCH** ✓ |
| `DailyPlan.plan_state` | `[plan_ready, no_plan, plan_stale, plan_unavailable, fallback_offered]` `openapi.yaml:628` | no explicit enum; failure table and prose reference same set | `[no_plan, plan_ready, plan_stale, **plan_replaced**, plan_unavailable, fallback_offered]` `lifecycle-contract.md:197` | **DRIFT**: lifecycle has `plan_replaced` (terminal state); OpenAPI does not |
| `reason_code` | `[... fallback_micro_session, unknown_reason_code]` `openapi.yaml:638` | same 7 + `unknown_reason_code` `contract:40-48` | — | **MATCH** ✓ |
| `UpdateSessionRequest.state` | `[paused, completed, abandoned]` `openapi.yaml:651` | — | `paused → started` transition permitted `lifecycle-contract.md:226` | **GAP**: resume not representable on API |

#### 6.2.3 Daily-action conflict: smallest safe resolution

Three items must be resolved before implementation:

1. **CheckIn:** Either (a) add `POST /v1/today/check-in` with `CheckInRequest` schema to the OpenAPI, add `CheckIn` to `capability-manifest.yaml` data_entities, and update `transport-classification.yaml`; or (b) remove `STUDY.CheckIn` as a standalone capability and fold check-in data into `startStudySession`. Founder decision required — affects P0-03 scope.

2. **Session paths and completion:** Align to the OpenAPI paths (`/v1/study/sessions` with slash). Reconcile completion: either adopt `PATCH .../sessions/{sessionId}` with `state=completed` (OpenAPI's model) or add `POST /v1/study/sessions/{sessionId}/complete` to the OpenAPI (contract's model). The PATCH approach is the current candidate per the ownership contract.

3. **Resume gap:** Either add `started` to `UpdateSessionRequest.state` (OpenAPI) to represent `paused → started` resume, or remove the `paused → started` transition from the lifecycle contract and use a new session for resume. Engineering decision — affects how `session_resumed` event is produced.

### 6.3 Privileged-review diffs (not applied)

The following protected files would need changes to fully reconcile. These diffs are recorded for privileged review only; none is applied here.

#### Diff P0-02A — Align placement-diagnosis-contract API table to OpenAPI
- **Target:** `artifacts/engineering/contracts/placement-diagnosis-contract.md:58-63` (API table) — legacy paths at lines 60-63
- **Change:** Update the API table to reference OpenAPI paths `POST /v1/placement`, `POST /v1/placement/{attemptId}/responses`, `GET /v1/placement/{attemptId}`; remove legacy `/v1/placement/attempts`, `/v1/placement/results` paths
- **Affected projections:** `transport-classification.yaml` (already aligned), `openapi/README.md` (non-authoritative excerpt), `placement-diagnosis-runtime.md:61`
- **Migration:** no runtime migration (pre-code); contract-only change
- **Regression:** placement-contract validator must verify operationIds resolve to OpenAPI; document validator must verify P0-02 row signature unchanged
- **Attestation:** standard 9-field; `protected_changes_reviewed: true`, `validators_weakened: false`

#### Diff P0-03A — Align daily-action-contract API table to OpenAPI
- **Target:** `artifacts/engineering/contracts/daily-action-contract.md:69-76` (API table) — legacy paths at lines 74-76
- **Change:** Update the API table to reference OpenAPI paths; remove legacy `/v1/today/check-in`, `/v1/study-sessions` paths; the check-in concept remains in the data contract but its API surface is noted as unresolved (see CheckIn resolution below)
- **Affected projections:** `transport-classification.yaml` (STUDY.CheckIn row needs resolution), `daily-action-runtime.md:63`
- **Same migration/regression/attestation as P0-02A**

#### Diff P0-03B — Resolve STUDY.CheckIn: add endpoint or remove concept
- **Target:** `writing-task-2/openapi.yaml` (add path), `capability-manifest.yaml:89` (add data_entity), `transport-classification.yaml:101-106` (correct operation_id mapping)
- **Decision owner:** Founder (affects P0-03 scope — is check-in a real capability or vestigial?)
- **Option A:** Add `POST /v1/today/check-in` with `CheckInRequest { minutes_available, energy }` schema. Bump OpenAPI minor version. Update manifest and transport classification.
- **Option B:** Remove STUDY.CheckIn as a standalone capability; fold check-in data into `StartSessionRequest`. Demote or deprecate the capability ID.
- **Validator impact:** capability-manifest validator must verify `api_operations` resolution; transport-classification must map every ACTIVE capability to a real operationId

#### Diff P0-03C — Reconcile DailyPlan `plan_replaced` lifecycle state
- **Target:** `writing-task-2/openapi.yaml:628` (add `plan_replaced` to DailyPlan.plan_state enum) OR `lifecycle-contract.md:197` (remove `plan_replaced`)
- **Owner:** engineering — lifecycle SSOT, OpenAPI is projection; normally lifecycle wins
- **If lifecycle wins:** add `plan_replaced` to OpenAPI enum; no breaking change
- **If OpenAPI wins:** remove `plan_replaced` from lifecycle contract; requires lifecycle state-machine revision

#### Diff P0-03D — Reconcile resume gap
- **Target:** `writing-task-2/openapi.yaml:651` (add `started` to UpdateSessionRequest.state) OR `lifecycle-contract.md:226` (remove `paused → started` transition)
- **Owner:** engineering
- **Recommendation:** add `started` to `UpdateSessionRequest.state` — this is the lowest-friction path and preserves the lifecycle transition

## 7. Required command handoff

Commands were run from `/Users/tienphat/Developer/lenbands` after the evidence review. Classification: validator-proven for command results; no runtime-readiness inference is made.

| Command | Exit | Result |
|---|---:|---|
| `tools/bin/lenbands doctor` | `0` | `toolchain doctor passed (runtime requirements=9)` |
| `tools/bin/lenbands verify` | `0` | Repository contract verification passed; OpenAPI, framework `1.0.6`, 180 capabilities, 25 families, 39 events, and 25 operations validated. The command explicitly reports runtime/P0 readiness is a separate fail-closed gate. |
| `tools/bin/lenbands gate toolchain` | `0` | Toolchain contract freeze gate passed; it explicitly does not imply P0/runtime readiness. |
| `tools/bin/lenbands gate p0` | `3` | Expected truthful blocked state: 33 blockers, including all six P0 packs `readiness_state=not_ready`, missing provider/DPA or calibration/acceptance/benchmark/gold-corpus evidence as applicable, pending founder approvals, missing corpus, and unapproved numeric-threshold policy. |

The exit `3` from `gate p0` is expected and must remain unchanged.
