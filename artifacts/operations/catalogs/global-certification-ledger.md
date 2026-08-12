# Global Document Certification Ledger (projection)

Metadata canonical ở sibling `global-certification-ledger.meta.yaml`.

- `generated_from`: `artifacts/operations/agent-trust-policy.yaml` (§ unlock_requires), canonical owners, convergence audits
- `generated_at`: `2026-08-10` (manual projection; generator chưa có)
- `schema_version`: `1`
- `generation_state`: `manual_projection_pending_generator`

Đây là **projection duy nhất** cho trạng thái global-unlock. Nó liệt kê mọi `unlock_requires` trong
`agent-trust-policy.yaml`, ghi canonical evidence/owner/status hiện tại, và phân loại blocker type.
**Không có claim `complete`/`approved`/`ready` trừ khi canonical owner chứng minh bằng evidence immutable.**

Blocker types:
- **non-protected fix**: việc sửa/sâu doc không chạm protected path — có thể làm trong session này.
- **protected review**: cần privileged diff + CODEOWNERS/attestation.
- **founder decision**: cần quyết định product/evidence bởi founder.
- **external evidence**: cần provider/corpus/legal evidence bên ngoài.
- **post-code evidence**: cần runtime/build thật (benchmark, acceptance, SLO, release).

---

## Ledger

| # | Unlock requirement | Canonical evidence/owner | Status | Blocker type |
|---|---|---|---|---|
| 1 | all_180_capabilities_semantically_complete_and_traceable | `capability-family-map.yaml` (180 caps), `capability-phase-index.md`, `catalogs/executor-dossier.md` | **open** — 21 protected diffs pending (framework IDs, manifest states, family registry); framework gaps (distractor/paraphrase registries) | protected review + founder decision |
| 2 | all_roles_permissions_and_user_journeys_complete | `01-product.md` § Role Model, `04-experience.md` (8 journeys), `auth-identity-contract.md` (permissions), `identity-consent.md` | **open** — P0-01..06 experience specs at draft/review; no `approved` owner | protected review + founder decision |
| 3 | all_ielts_controlled_vocabularies_mapped_without_unknown_placeholders | `blueprint/framework/**` (10 files), `05-content.md` (tag dimensions), `error-taxonomy.md` | **open** — `unknown_distractor_type`, `unknown_paraphrase_pattern`, `unknown_difficulty`; invented IDs `R_matching_information`/`flow_chart_labelling` (B1 diff); `L_word_boundary` unknown_microskill | protected review + founder decision |
| 4 | all_product_ux_state_and_accessibility_decisions_approved | `04-experience.md`, `07-conventions.md` (§ a11y), vertical slices (WR-01..07, identity-consent, etc.) | **open** — no `approved` UX decision; all draft/review | founder decision |
| 5 | all_data_api_event_failure_privacy_and_security_contracts_approved | `api-ownership-bff-contract.md`, `api-governance-contract.md`, `writing-task-2/*`, `runtime/*`, threat-model sections | **open** — all `review`/`draft`; no `approved`; A1 admin OpenAPI binding, A2 legacy-deprecation transition and A3 frontend session transport are unresolved pre-code design gaps | non-protected fix + protected review + post-code evidence |
| 6 | all_learning_assessment_ai_governance_and_provider_boundaries_approved | `06-engines.md`, `evaluation-contract.md`, `llm-routing-context-contract.md`, `provider-adapter-contract.md`, `domain-automation-contract.yaml` | **open** — `assessment` evidence_blocked (gold corpus missing); `ai` partial; governance P1-gated | external evidence + post-code evidence |
| 7 | all_nfr_observability_operations_recovery_and_release_contracts_approved | `observability-slo-contract.md`, `sre-delivery-security-contract.md`, `cloud-platform-topology-contract.md`, `release-gate.md`, `outbox-reconciliation-contract.md` | **open** — design contracts authored (B5); no `approved`; SLO/drill/CI post-code | founder decision + post-code evidence |
| 8 | no_duplicate_or_ambiguous_canonical_owner | `ssot-registry.md`, `api-ownership-bff-contract.md`, `catalogs/executor-dossier.md` | **open** — 2 OpenAPI resolved (B6); SPEAKING.Practice orphan, PRACTICE.Drill collision, GOVERNANCE.Quality lifecycle (B4 diffs) | protected review + founder decision |
| 9 | no_draft_or_review_authority_required_by_the_application | all artifact metas | **open** — **zero `approved` owners**; all draft/review | founder decision |
| 10 | external_claims_have_citations_and_rights_or_provenance_state | `PENDING-EVIDENCE.md`, `build-buy-register.md`, KA sidecars (rights_status) | **open** — 17 KA assets rights_status pending_review; gold corpus rights/provenance missing; IELTS official descriptors need citation | external evidence |
| 11 | independent_semantic_and_red_team_audits_have_no_open_critical_or_high_findings | convergence audits (4 auditors, Batches 1-6) | **open** — Batch 1-5 HIGH/medium findings fixed; framework gaps (distractor/paraphrase registries, descriptor corrections) pending; need re-audit after protected diffs applied | protected review |
| 12 | explicit_global_founder_authorization | `agent-trust-policy.yaml` `founder_authorization_ref` | **open** — `null` | founder decision |

---

## Blocked state summary

- **Zero of 12** unlock requirements are met.
- **Zero `approved` canonical owners** exist (req 9 is globally unsatisfied).
- **founder_authorization_ref: null** (req 12) — the sole authority gate is founder-owned.
- Evidence blockers (req 6/10): gold corpus, benchmark runs, numeric thresholds, provider DPA, KA rights, IELTS citation — **external evidence**.
- Protected diffs (req 1/3/8): 21 diffs across Batches 1-4 — **protected review**.
- Post-code gates (req 5/6/7): benchmark/acceptance/SLO/CI/drill — **post-code evidence** (not unlockable by doc work).

## Rules

- Projection này không tạo evidence; chỉ phản ánh trạng thái canonical owner.
- Không sửa ledger thủ công nếu nó có thể regenerate từ agent-trust-policy + metas; đây là manual pending generator.
- Khi một req chuyển đủ điều kiện, canonical owner phải có evidence immutable trước khi ledger ghi `met`.
- `verify`/`gate toolchain` pass không phải unlock signal (agent-trust-policy `non_unlocking_signals`).
