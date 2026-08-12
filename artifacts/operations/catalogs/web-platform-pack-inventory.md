# Web Platform Contract Pack — Inventory & Convergence Map (projection)

Metadata canonical ở sibling `web-platform-pack-inventory.meta.yaml`.

- `generated_from`: `artifacts/engineering/contracts/**`, `blueprint/02-architecture.md`, `blueprint/07-conventions.md`, `artifacts/operations/capability-family-map.yaml`
- `generated_at`: `2026-08-10` (manual projection; generator chưa có)
- `schema_version`: `2`
- `generation_state`: `manual_projection_pending_generator`

Đây là **projection/index**, không phải SSOT. Mỗi row dùng schema:
`canonical owner | status | pre-code document gap | post-code evidence gate`.

- **Pre-code document gap**: nội dung design còn thiếu, thuộc document-convergence (giải quyết bằng contract này/batch).
- **Post-code evidence gate**: điều kiện cần runtime/build thật (benchmark, acceptance, SLO observation, restore drill, release) — không phải việc viết doc.

---

## A. OpenAPI / API-Governance / BFF ownership

| Canonical owner | Status | Pre-code document gap | Post-code evidence gate |
|---|---|---|---|
| `artifacts/engineering/contracts/runtime/api-ownership-bff-contract.md` (new) | draft | ownership model selected; deprecation transition and frontend session transport remain open (A2/A3) | endpoint gen + contract test trên source |
| `artifacts/engineering/contracts/writing-task-2/openapi.yaml` (P0 loop surface, 3.1.0) | review | single consolidated P0 OpenAPI; admin `/admin/governance/*` chưa vào OpenAPI (A1) | OpenAPI lint/parse, client gen, auth/idempotency/error test |
| `artifacts/engineering/contracts/openapi.yaml` (identity surface, v0.2.0) | draft | re-scoped identity-only; legacy loop operations retain traceability but remain live path definitions until A2 specifies deprecation/successor treatment; `admin:governance` canonical ở auth contract | gen + auth test |
| `artifacts/engineering/contracts/runtime/api-governance-contract.md` | review | shared HTTP lifecycle (auth, error envelope, idempotency, compatibility) | real HTTP tests |
| `artifacts/experience/specs/vertical-slices/governance-ops-dashboard.md` (§Contracts) | review | admin endpoints unbound to scope (A1) | admin auth/scope test |

**Gap A1 (pre-code):** admin governance endpoints (`/admin/governance/*`, `POST /admin/routes/{id}/block`) chưa canonical trong OpenAPI + chưa bind `admin:governance`. OpenAPI binding là design work, không phải post-code.

**Gap A2 (pre-code):** legacy loop operations trong identity OpenAPI mới có `deprecated: true` + pointer. Chưa có per-operation successor treatment cho orphan GET feedback, response-header contract, migration window hoặc release-record schema theo API Governance. Runtime emission/verification của header và release record là post-code evidence sau khi A2 được định nghĩa.

**Gap A3 (pre-code):** BFF contract chọn server-side token handling nhưng identity contract chỉ định bearer validation; chưa có session-transport contract cho HttpOnly cookie attributes, CSRF boundary, session lifetime/rotation và logout/invalidation behavior.

## B. Entity + async workflow lifecycle

| Entity family | Canonical owner | Pre-code gap | Post-code evidence gate |
|---|---|---|---|
| Account, ConsentRecord, LearnerProfile, PrivacyRequest | `runtime/auth-identity-contract.md` + `runtime/identity-core-runtime.md` + `contracts/openapi.yaml` | none (B3 aligned PrivacyRequest.state) | export/delete cascade + consent test |
| Goal, PlacementAttempt, BandEstimate, GapProfile, InitialPath | `placement-diagnosis-contract.md` + `placement-diagnosis-runtime.md` | none (B1/B3 aligned states) | placement calibration + acceptance |
| DailyPlanSnapshot, CheckIn, StudySession | `daily-action-contract.md` + `daily-action-runtime.md` | none (B1 aligned) | daily-action acceptance run |
| WritingTask, WritingDraft, WritingSubmission, WritingEvaluation, FeedbackFinding | `writing-task-2/{runtime-spec,data,event,failure,evaluation}-contract.md` + `writing-evaluation-runtime.md` | none (B1/B3 aligned) | writing idempotency/redaction/recovery + benchmark |
| LearningError, ReviewCard, ReviewAttempt, RetestAttempt | `error-to-review/{data,event,failure}-contract.md` + `error-to-review-runtime.md` | none | review scheduling + retest outcome acceptance |
| BenchmarkRun, CostMeasurement, ReleaseGateDecision, AuditRecord | `quality-economics-runtime.md` + `evaluation-benchmark-spec.md` + `release-gate.md` | drift/anti-gaming P1-gated (M10) | gold corpus + benchmark run + numeric thresholds |
| Job/DLQ/replay | `async-job-worker-contract.md` + `outbox-reconciliation-contract.md` | none | worker crash/reclaim/duplicate-drill test |

**Không gọi lifecycle "complete" khi còn protected conflict:** `SPEAKING.Practice` orphan (B4-2), `PRACTICE.Drill` collision (B4-3), `WRITING.Evaluation` interaction_spec deprecated ref (B4-1) vẫn chờ founder decision — không row nào ở trên claim lifecycle đã đóng hoàn toàn cho tới khi các diff đó được apply.

## C. Web route / server-client / session / cache / UX

| Canonical owner | Status | Pre-code gap | Post-code evidence gate |
|---|---|---|---|
| `runtime/api-ownership-bff-contract.md` (BFF/server-client/session) | draft | BFF boundary canonical (Batch 5) | FE↔API integration test |
| `runtime/cache-contract.md` | review | cache-aside, invalidation, negative-read | cache miss/eviction/stampede test |
| `runtime/auth-identity-contract.md` (session) | review | bearer token model; frontend session-transport/cookie/CSRF/lifetime contract absent (A3) | auth/session E2E |
| `blueprint/04-experience.md` + `07-conventions.md` (a11y, empty/error/resume) | invariant/review | UX-state conventions | per-screen a11y acceptance |
| `blueprint/04-experience.md` + `07-conventions.md` (feature flag) | invariant | flag naming/cohort/rollback | flag E2E |

**Gap C1 (pre-code):** không consolidated web-route/feature-flag contract; route map scattered. Batch 5 `api-ownership-bff-contract` + `sre-delivery-security-contract` (§8 config/flag) mô tả; route map chi tiết theo slice.

## D. Managed cloud / platform topology

| Canonical owner | Status | Pre-code gap | Post-code evidence gate |
|---|---|---|---|
| `runtime/cloud-platform-topology-contract.md` (new) | draft | env topology, trust zones, IAM, network, DNS/WAF, secrets/KMS, backup/restore, RPO/RTO, DR (Batch 5 — **resolves D1/D2**) | restore drill, backup verify, DR runbook drill |
| `blueprint/02-architecture.md` (§ Cross-cutting infra) | invariant | infra choice fixed (Postgres/Redis/S3) | infra provision + integration |
| `business/decisions/build-buy-register.md` §4 | draft | ownership/boundary cho managed services | DPA/procurement evidence |

**D1/D2 now pre-code resolved:** `cloud-platform-topology-contract.md` định nghĩa provider-neutral topology + backup/restore design + RPO/RTO targets. Phần còn lại (restore drill, provider setup, IaC) là **post-code evidence gate**, không phải gap document.

## E. SRE

| Canonical owner | Status | Pre-code gap | Post-code evidence gate |
|---|---|---|---|
| `runtime/observability-slo-contract.md` | review | redacted telemetry, SLI/SLO, alert, incident minimum | SLO observation, alert sim, runbook drill |
| `runtime/sre-delivery-security-contract.md` (new) | draft | incident/runbook taxonomy, alert ownership/escalation (**resolves E1**) | runbook drill, incident record |
| `operations/evaluator-drift-incident-runbook.md` | review | evaluator-drift class runbook | regression benchmark trigger drill |

**E1 now pre-code resolved:** general incident/runbook taxonomy trong `sre-delivery-security-contract.md`; runbook riêng cho từng class được tạo khi có evidence. Drill/thực thi = post-code evidence.

## F. Delivery / security

| Canonical owner | Status | Pre-code gap | Post-code evidence gate |
|---|---|---|---|
| `runtime/sre-delivery-security-contract.md` (new) | draft | CI/CD gates, artifact provenance, SCA policy, migration, config promotion, flag/kill-switch/rollback (**resolves F1**) | CI run, SBOM/provenance verify, migration dry-run |
| `technology-stack-recommendations.md` (§ 272-277, 332) | review | tooling selected: Dependabot/Renovate, Grype, Gitleaks, Trivy, SBOM/Syft | scanner run + vuln report |
| `runtime/provider-adapter-contract.md` (threat sections) | review | rollback/kill-switch via flag; threat model provider boundary | dual-run, rollback test |
| `runtime/api-governance-contract.md` + `auth-identity-contract.md` (threat sections) | review | transport/auth threat model | TLS config, auth test |
| `blueprint/07-conventions.md` + `08-roadmap.md` (migration/version) | invariant | version/migration policy | migration dry-run on staging |

**F1 now pre-code resolved:** SCA *policy* trong `sre-delivery-security-contract.md`; tooling đã chọn ở technology-stack. Scan run thật = post-code evidence.
**F2 (by design):** security/threat model host-boundary (3 runtime contracts + auth), không tạo consolidated security owner (M12). Đây là decision, không phải gap.

---

## Summary

| Dimension | Pre-code resolved in Batch 5 | Remaining post-code evidence gate |
|---|---|---|
| A. OpenAPI/BFF | ownership model selected; A1/A2/A3 remain pre-code gaps | endpoint gen + contract test |
| B. Lifecycle | states aligned (B1/B3); conflicts flagged (B4) | acceptance/benchmark runs |
| C. Web/route/cache | BFF/cache/flag baseline; session-transport and consolidated route contract remain open | FE integration, a11y acceptance |
| D. Cloud topology | cloud-platform-topology-contract (env/IAM/network/secrets/backup/DR/RPO/RTO) | restore drill, provider setup, IaC |
| E. SRE | sre-delivery-security-contract (incident/runbook taxonomy) | SLO observation, runbook drill |
| F. Delivery/security | sre-delivery-security-contract (CI gates/SCA/migration/flag/kill-switch) | CI run, SBOM, migration dry-run |

## Rules

- Projection này không thay runtime contracts (SSOT cho từng concern).
- Row nào có owner rồi thì deepen owner; contract mới chỉ tạo khi gap pre-code cần canonical owner (Batch 5 đã tạo 3: api-ownership-bff, cloud-platform-topology, sre-delivery-security).
- Pre-code document gap = việc viết/sửa doc; post-code evidence gate = cần runtime/build thật, không phải viết doc.
- Không gọi lifecycle/security/SLO/SCA "complete" khi chưa có evidence gate thật.
