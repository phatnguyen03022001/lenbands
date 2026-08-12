# Build Readiness Matrix

## Mục đích

Đây là operational projection cho founder/agent biết P0 capability pack nào đã có đủ input để bước sang Source Code. Nó không thay thế Capability Catalog hay P0 Capability Profile Matrix trong Blueprint.

**Scope:** chỉ sáu pack closed pilot `P0-01` → `P0-06` trong `blueprint/03-features.md`. Listening, Reading, Speaking, Mock Test và Exam Readiness không được thêm vào matrix này cho đến khi roadmap nâng scope bằng decision có evidence.

**Re-audit update 2026-08-07:** semantic contract remediation đã chạy qua framework/KA/event/failure/OpenAPI validators; không pack nào được nâng trạng thái. P0 vẫn `not ready` vì founder approval và evidence thật còn thiếu.

**Knowledge OS hardening update 2026-08-07:** P0 capability families đã có typed seed ở `artifacts/operations/capability-manifest.yaml`, và semantic validator kiểm tra manifest coverage/ref resolution. Đây là bước chuẩn bị graph/compiler, không nâng bất kỳ pack nào lên `ready`.

**Benchmark/acceptance hardening update 2026-08-07:** benchmark intake, candidate numeric policy, P0 acceptance manifest và executable runners đã tồn tại. Corpus vẫn `missing`, policy vẫn `unarmed`, không có runtime result/evidence; vì vậy P0-04/P0-05/P0-06 vẫn `not ready`.

## Quy ước trạng thái

- `missing`: chưa có artifact/contract.
- `draft`: đã có nhưng chưa review.
- `review`: nội dung đã đủ để founder kiểm tra, nhưng chưa được founder approve hoặc còn chờ evidence thật.
- `approved`: đủ điều kiện làm input cho bước tiếp theo.
- `n/a`: không áp dụng cho slice.

## Matrix hiện tại — closed pilot

| P0 pack | Capability backbone | Behavior/design | Product spec | Engineering contracts | Quality / ops | Acceptance run | Build state |
|---|---|---|---|---|---|---|---|
| P0-01 Identity | `IDENTITY.Auth`, `IDENTITY.Profile`, `IDENTITY.Privacy` | interaction + P0 experience contract: draft | Identity & Consent: draft | auth-identity-contract + privacy/data boundary: review; founder approval pending | privacy/data boundary: draft | not run | not ready — provider/DPA and end-to-end acceptance evidence missing |
| P0-02 Diagnosis | `GOAL.Target`, `PLACE.Test`, `PLACE.BandEstimation`, `PLACE.GapDetection`, `PLACE.InitialPath`, `PLACE.SkillDiagnosis`, `BAND.Current` | interaction + P0 experience contract + first-day wireframe: draft | Placement & Plan: draft | **placement-diagnosis-contract: review; founder approval pending** | placement quality gate: review; founder approval pending | not run | not ready — calibration and acceptance evidence missing |
| P0-03 Daily action | `STUDY.DailyPlan`, `STUDY.CheckIn`, `STUDY.MicroSession`, `PERSONAL.NextBestAction` | interaction + P0 experience contract + daily wireframe: draft | Today & Daily Action: draft | **daily-action-contract: review; founder approval pending** | deterministic fallback: draft | not run | not ready — acceptance run and founder approval pending |
| P0-04 Writing evaluation | `LEARN.Writing`, `EVAL.Writing`, `COACH.ErrorAnalysis`, `COACH.Feedback`, `PKM.Drafts` | interaction + P0 experience contract + full-app wireframe: draft | Writing Task 2: draft | **interaction/writing-task-2.md** + **runtime-spec.md** + OpenAPI/data/event/failure + **evaluation-contract.md (new)** + LLM/runtime pack + semantic validator: review; founder approval pending | benchmark, cost, release gate: review; benchmark evidence pending | run-006 is pipeline revalidation only | not ready — interaction/runtime contracts are candidates, evidence still pending |
| P0-05 Error-to-review | `REVIEW.MistakeNotebook`, `REVIEW.FSRS`, `REVIEW.SmartQueue`, `PRACTICE.Drill` | interaction + P0 experience contract + **error-to-review vertical slice (new)**: review | **error-to-review/data+event+failure contracts (new)**: review; founder approval pending | error-to-review contract pack + shared writing + Error Graph projection: review candidate | FSRS + retest acceptance (data contract): draft | run-006 is pipeline revalidation only | not ready — founder approval and acceptance run pending |
| P0-06 Quality & economics | `OPS.CostBudget`, `OPS.ModelRouting`, `OPS.Quota`, `OPS.Observability`, `OPS.ReleaseGate`, `OPS.EvaluationQuality`, `OPS.ContentQuality`, `OPS.OutcomeMeasurement`, `GOVERNANCE.ConfidenceScore`, `GOVERNANCE.AuditTrail` | **governance-ops-dashboard spec (new)**: review; founder approval pending | operational policy: review candidate | event-schema-pack + evaluation-contract + **quota-usage-contract (new)** + observability/runtime pack: review candidate | cost, content, benchmark, release, exit exercise: review; external evidence pending | not run | not ready — founder approval and gold-standard corpus pending |

## Gate

Một P0 row chỉ thành `ready` khi:

- Capability Profile trong Blueprint hoàn chỉnh.
- Capability Manifest row resolve đúng capability IDs, events, artifacts, cost boundary, privacy class và blockers.
- Interaction + Screen behavior đã `approved`.
- Vertical Slice Spec đã `approved`.
- API/data/event/failure/prompt contracts cần thiết đã `approved`.
- Acceptance tests có owner và có thể chạy.
- Privacy, quality và cost gate không còn `missing`.
- Nếu row có learner-visible evaluation hoặc rights claim: evidence/run thật đã được reference theo `CONVENTION.md` §6, không chỉ có prose.

`ready` chỉ được ghi khi các artifact cần thiết đã `approved` và mọi evidence bắt buộc đã tồn tại, được reference bằng immutable record.

Một closed pilot chỉ thành `ready` khi **toàn bộ P0-01 → P0-06** là `ready`; không bù một pack thiếu bằng UI đẹp hoặc code đã chạy.

## Cross-pack dependencies (silent)

- **P0-04 (Writing)** dùng một `WritingTask` đã được seed qua content-publish contract; đây là shared input/content-quality gate, không phải full `CONTENT.Publish` product scope.
- **P0-04/P0-05** phụ thuộc **quota-usage-contract** — ranh giới free/premium quyết định khi learner hit wall.
- **P0-06** phụ thuộc **governance-ops-dashboard** — founder cần surface vận hành calibration trong pilot.
- Các dependency này đã có contract ở `review`; readiness vẫn phụ thuộc founder approval và evidence thật (gold-standard corpus, published task batch).

## Update rule

- Cập nhật matrix cùng lúc khi artifact đổi status.
- Blueprint đổi semantics → row liên quan quay về `review`.
- Không dùng matrix để thay capability identity, scope hoặc product decision.
- `not run` không phải failure; nó là trạng thái trung thực trước khi có Source Code, benchmark hoặc pilot.
