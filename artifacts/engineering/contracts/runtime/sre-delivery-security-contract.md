# SRE / Delivery / Security Contract — P0

## Purpose and classification

Design contract (pre-code document). Defines the common incident/runbook taxonomy, alert ownership/escalation,
redaction/audit boundary, CI/CD gates, artifact provenance, dependency/SCA, database migration, config
promotion, feature flag, kill switch, and rollback for the closed pilot. **Distinguish the design contract
(pre-code) from runtime validation evidence (post-code).** Do not claim that incident/SLO/SCA operations are live;
that is an evidence gate.

## 1. Incident / runbook taxonomy

### 1.1 Incident classes

| Class | Example | Severity | Response |
|---|---|---|---|
| `raw_content_leak` | essay/audio in telemetry/log | critical | halt route, redact, incident |
| `duplicate_effect` | duplicate evaluation/charge/review card | critical | idempotency reconcile, halt |
| `evaluation_degradation` | drift/benchmark regression | high | freeze promotion, runbook drift |
| `cost_ceiling_breach` | exceeds the hard budget ceiling | high | circuit/review, block release |
| `queue_dlq_growth` | DLQ exceeds capacity | high (page) | replay/repair, alert owner — page per observability-slo |
| `slo_breach` | latency/error exceeds the SLO for a sustained 15m | high (page) | triage per observability-slo — page per observability-slo |
| `provider_outage` | inference provider fail | medium (page for critical) | fallback route, delayed state; critical vs non-critical split per observability-slo |
| `cache_collapse` | cache hit collapse | low | recompute, ticket |
| `reconciliation_repair` | outbox repair needs action | low | repair, follow-up |

### 1.2 Runbook inventory

| Runbook | Owner | Status |
|---|---|---|
| Evaluator drift incident | quality owner | `artifacts/operations/evaluator-drift-incident-runbook.md` (exists) |
| **General incident runbook (this taxonomy)** | ops | **this contract** (pre-code design; no separate runbook exists for every class) |
| Cost-ceiling breach runbook | ops | pending (design here; drill = post-code evidence) |
| DLQ/replay runbook | ops | references async-job-worker + outbox-reconciliation |
| Restore/drill runbook | ops | designed in cloud-platform-topology §7; drill = post-code evidence |

## 2. Alert ownership / escalation

| Alert | Owner | Escalation |
|---|---|---|
| Raw-content leak, duplicate effect | ops/engineering | page (urgent) |
| Cost ceiling breach | ops/founder | page |
| Evaluation degradation (drift) | quality owner | page |
| DLQ growth beyond P0 capacity | ops | page (urgent) — per observability-slo |
| SLO breach sustained 15 min | ops | page (urgent) — per observability-slo |
| Cache collapse, non-critical provider fallback | ops | ticket / next-business-day — per observability-slo |
| Provider outage | ops | page (route fallback); critical vs non-critical split per observability-slo |

- Each alert has an owner, channel, quiet hours, runbook ref, and escalation path.
- Alerts do not contain raw learner content; use opaque refs/metrics.

## 3. Redaction / audit boundary

- Telemetry/log/alert/incident records: **must not** contain essay/audio/transcript, bearer tokens, provider payloads, prompt bodies, or hidden reasoning (`observability-slo-contract.md` § Signals, `07-conventions.md` § Runtime contract convention).
- Audit records contain model/rubric/prompt-hash/contract version, state transition, and actor type — chain-of-thought and raw provider payloads do not enter the audit.
- Immutable incident snapshots record versions + metric delta, not raw content.

## 4. CI/CD gates

| Gate | Pre-code design | Post-code evidence |
|---|---|---|
| `verify` | repository/validator checks | passes on real repo |
| `gate toolchain` | toolchain freeze | passes |
| `gate p0` | exit 3 blocked until evidence | evidence present → re-evaluate (founder decision) |
| Build/lint/test | registered workspace-native commands | real run |
| Contract-test / OpenAPI lint | design: version diff + auth/idempotency/error examples | real client gen/test |
| Migration dry-run | design: migration versioned, backward-compatible | dry-run on staging copy |

- CI does not bypass trust-boundary/attestation (agent-trust-policy).
- Promotion `dev→staging→prod` goes through a reviewed gate; do not deploy laterally.

## 5. Artifact provenance

- Build artifact records: commit SHA, tool version, dependency lockfile hash, SBOM (Syft, per technology-stack), provenance attestation.
- Artifact provenance is pre-code design; an actual run in Source Code/CI is post-code evidence.

## 6. Dependency security / SCA

- Selected tooling: Dependabot/Renovate (deps), Grype (vulnerability), Gitleaks (secrets), Trivy (container), SBOM/Syft (release) — `technology-stack-recommendations.md` § 272-277, 332.
- Contract (pre-code): every dependency manifest has a lockfile; a PR adding a dependency requires review + scanner; critical/high vulnerabilities block promotion.
- Do not claim that scans have run; that is post-code evidence.

## 7. Database migration

- Migration versioned, idempotent, backward-compatible (07-conventions § Runtime contract; 08-roadmap breaking change → migration).
- Migration runs through the `migrator` role; dry-run on staging before prod; do not mutate prod before passing the gate.
- Data migration must preserve idempotency/outbox semantics (outbox-reconciliation).

## 8. Config promotion / feature flag / kill switch

| Concern | P0 design |
|---|---|
| Config promotion | dev→staging→prod through reviewed promotion; config is versioned (runtime-baseline-config.yaml) |
| Feature flag | snake_case, owner, start/end, cohort, rollback condition (07-conventions § Experiment/feature flag); the flag does not bypass the quality/privacy gate (build-buy-register) |
| Kill switch | per-route/per-feature; disable route → submission goes to fallback/delayed/unavailable (provider-adapter § Rollback); drafts/history are not lost |
| Rollback | adapter route via flag/config, no API/event/domain semantic change; rollback decision auditable (release-gate) |

## 9. Non-goals

- Do not deploy cloud resources, use Terraform/IaC, or claim that SLO/SCA/incidents have run (post-code evidence).
- Do not create a runbook for every class immediately (pre-code design taxonomy; create a separate runbook when evidence requires it).

## Acceptance (design)

- [ ] Each incident class has severity + response + runbook ref.
- [ ] Alerts have owner/escalation; no raw content.
- [ ] Redaction/audit boundary is consistent with observability + conventions.
- [ ] CI/CD gate + provenance + SCA + migration + flag/kill-switch/rollback are described.
- [ ] Design contract vs post-code evidence is clearly distinguished.

## References

- `artifacts/operations/evaluator-drift-incident-runbook.md`
- `artifacts/engineering/contracts/runtime/observability-slo-contract.md`
- `artifacts/engineering/contracts/runtime/provider-adapter-contract.md`
- `artifacts/engineering/contracts/runtime/async-job-worker-contract.md`
- `artifacts/engineering/contracts/runtime/outbox-reconciliation-contract.md`
- `artifacts/engineering/contracts/runtime/cloud-platform-topology-contract.md`
- `artifacts/operations/release-gate.md`
- `artifacts/engineering/technology-stack-recommendations.md`
- `blueprint/07-conventions.md` § Runtime contract / Experiment/feature flag
