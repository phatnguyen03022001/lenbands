# Executor Dossier — Family Coverage Matrix (validated manual index)

Metadata canonical ở sibling `executor-dossier.meta.yaml`.

- `generated_from`: `artifacts/operations/capability-family-registry.yaml` + `capability-family-map.yaml` + `capability-lifecycle-registry.yaml` + `blueprint/08-roadmap.md`
- `generated_at`: `2026-08-10` (manual index; generator chưa có)
- `schema_version`: `1`
- `generation_state`: `manual_projection_pending_generator` (canonical per sibling `.meta.yaml`)
- `validation_state`: registry-map membership and lifecycle counts checked by document validation

Đây là **validated manual index**, không phải SSOT. Family identity và shared behavior canonical nằm ở
`capability-family-registry.yaml`; capability→family mapping canonical ở `capability-family-map.yaml`.
Dossier này cho executor biết family nào build được (ACTIVE), family nào deferred (PLANNED) với lý do
và activation prerequisite. **Không file nào ở đây nâng lifecycle/status/readiness.** Khi registry/map
đổi, document validation phải bắt drift membership/count trước khi index được dùng làm handoff.

Family lifecycle: ACTIVE = trong scope build candidate (vẫn evidence-gated); PLANNED = deferred, không
build cho tới khi roadmap mở scope bằng decision + evidence; DEPRECATED = alias, không implementation owner.

## ACTIVE families (6) — runtime spec có sẵn, evidence-gated

| Family | Owner | Runtime spec | Interaction spec | Phase | Readiness |
|---|---|---|---|---|---|
| `IDENTITY.Core` | product+engineering | `runtime/identity-core-runtime.md` | `interaction/identity-core.md` | P0-01 | not ready (evidence) |
| `PLACEMENT.Diagnosis` | product | `runtime/placement-diagnosis-runtime.md` | `interaction/placement-diagnosis.md` | P0-02 | not ready (evidence) |
| `STUDY.DailyAction` | product | `runtime/daily-action-runtime.md` | `interaction/daily-action.md` | P0-03 | not ready (evidence) |
| `WRITING.Evaluation` | product+engineering | `runtime/writing-evaluation-runtime.md` | `interaction/writing-task-2.md`* | P0-04 | not ready (evidence) |
| `REVIEW.ErrorToReview` | product | `runtime/error-to-review-runtime.md` | `interaction/error-to-review.md` | P0-05 | not ready (evidence) |
| `OPS.QualityEconomics` | operations | `runtime/quality-economics-runtime.md` | `interaction/quality-economics.md` | P0-06 | not ready (evidence) |

*`WRITING.Evaluation` registry vẫn trỏ `interaction/writing-evaluation.md` (deprecated) — xem protected diff B4-1.

## PLANNED reachable families (19) — deferred executor-reference rows

Mỗi row: scope, phase/deferred reason, activation prerequisite, canonical owner, dependency,
role/permission boundary, lifecycle ref, data/API/event/failure ref, privacy/cost/observability,
provider/framework boundary, non-goals. Deferred families giữ identity trong Blueprint nhưng KHÔNG build.

| Family | Scope (from registry) | Deferred reason / activation prerequisite | Canonical refs | Key gaps |
|---|---|---|---|---|
| `READING.Practice` | Passage-based reading practice, answer eval, review, retest | P1; activation: P0 evidence + published reading content + answer-key benchmark | registry row; `LEARN.Reading`→this family; deltas `READING.QuestionType` | no owner_spec/contracts/events; `reading_answer_key_benchmark` evidence pending |
| `LISTENING.Practice` | Audio listening practice, answer eval, review, retest | P1; activation: P0 evidence + licensed audio + answer-key benchmark | registry row; `LEARN.Listening`; deltas `LISTENING.QuestionType` | no owner_spec/contracts/events; audio rights/licensing unresolved (KA gap) |
| `SPEAKING.Evaluation` | Evidence-backed speaking evaluation + feedback | P1; activation: P0 evidence + gold corpus + evaluator benchmark | registry row; `LEARN.Speaking`, `EVAL.Speaking`, `EVAL.Examiner`; deltas `SPEAKING.Part` | no owner_spec/contracts/events; `speaking_evaluator_benchmark` pending; Speaking PR band 5 descriptor correction pending (convergence-batch-1 DIFF 3) |
| `PRONUNCIATION.Practice` | Pronunciation target, model, recording, feature feedback, retest | P1; activation: P0 evidence + phoneme framework depth + feature benchmark | registry row; `LEARN.Pronunciation`, `EVAL.Pronunciation`; deltas `PRONUNCIATION.Unit` | no owner_spec/contracts/events; P_* namespace overlap unresolved (framework) |
| `MOCK.ExamSimulation` | Composite exam simulation, timing, resume, scoring, routing | P1; activation: P0 evidence + exam-module conversion + composite benchmark | registry row; `PRACTICE.MockTest`, `PRACTICE.ExamSimulation`, `CONTENT.MockTest`; deltas `MOCK.Module` | no owner_spec/contracts/events; `mock_composite_benchmark` pending |
| `PRACTICE.Drill` | Reusable question/task drill attempt + result workflow | **collision**: family PLANNED owns PRACTICE.Adaptive/Set/Timed; capability `PRACTICE.Drill` maps to REVIEW.ErrorToReview (ACTIVE) | registry row; `PRACTICE.Adaptive/Set/Timed` | namespace collision (capability ID == family ID) — reconcile (protected) |
| `HISTORY.Assessment` | Assessment history, comparison, portfolio, timeline projections | P1; activation: P0 assessment facts + history consistency acceptance | registry row; `HISTORY.*` (8 caps) | no owner_spec/contracts/events; `history_consistency_acceptance` pending |
| `PROGRESS.Learning` | Progress, band, goal, learning analytics projections | P1/P2/deferred; activation: P0 outcome evidence + projection acceptance | registry row; `BAND.*`/`PROGRESS.*` (many caps) | no owner_spec/contracts/events; several caps `deferred`; `progress_projection_acceptance` pending |
| `PERSONAL.Recommendation` | Evidence-backed personalization, gaps, recommendations, NBA | P1; activation: P0 outcome evidence + recommendation outcome evidence | registry row; `PERSONAL.*` (AdaptivePlan/GapAnalysis/GoalRecommendation/Insights/Recommendation/WeaknessPractice) | no owner_spec/contracts/events; `recommendation_outcome_evidence` pending; NBA baseline P0 in STUDY.DailyAction |
| `NOTIFICATION.Delivery` | Preference-aware delivery of study/result/review/goal notifications | P1/P2; activation: P0 retention evidence + delivery acceptance | registry row; `NOTIF.*` (9 caps) | no owner_spec/contracts/events; `notification_delivery_acceptance` pending; quiet-hours/frequency-cap policy pending |
| `SUBSCRIPTION.Usage` | Plan, payment, premium entitlement, quota, usage boundary | P1; activation: pilot outcome + quota/entitlement acceptance + billing decision | registry row; `SUB.*` (4 caps) | no owner_spec/contracts/events; billing/payment legal + `quota_and_entitlement_acceptance` pending |
| `PKM.Content` | Learner-owned drafts, notes, recordings, collections, import/export, sync | P1; activation: P0 draft ownership + content ownership acceptance | registry row; `PKM.*` (9 caps: Collections/Export/Import/Notes/Offline/Recordings/SavedItems/Sync/WordBank; `PKM.Drafts` ACTIVE in WRITING.Evaluation) | no owner_spec/contracts/events; `content_ownership_acceptance` pending; cross-device sync infra pending |
| `LOCALIZATION.Preference` | Interface/response language, locale format, preference sync | P1/P2/deferred; activation: vi/en baseline + localization acceptance | registry row; `LOC.*` (5 caps) | no owner_spec/contracts/events; `localization_acceptance` pending; AI response language policy pending |
| `SEARCH.Knowledge` | Search across knowledge, questions, descriptors, samples | P1; activation: P0 content + search relevance acceptance | registry row; `SEARCH.*` (8 caps) | no owner_spec/contracts/events; `search_relevance_acceptance` pending; Postgres FTS at MVP only |
| `CONTENT.Management` | Content authoring, question bank, moderation, tagging, publishing | P1; activation: P0 content gate + content quality acceptance | registry row; `CONTENT.*` (AutoTag/Lesson/Knowledge/QuestionBank/Quiz/Tag/Publish/Moderation/Feedback/BlueprintUpdate/TagReview; `CONTENT.MockTest` maps to MOCK.ExamSimulation) | no owner_spec/contracts/events; `content_quality_acceptance` pending; KA rights/content review pending (founder) |
| `ADMIN.Governance` | Admin users, permissions, billing views, moderation logs, governance dashboard | P1/P2/deferred; activation: P0 ops evidence + admin permission acceptance | registry row; `ADMIN.*` (12 caps) | no owner_spec/contracts/events; `admin_permission_acceptance` pending; admin scopes now under `admin:governance` |
| `CONTENT.Knowledge` | Canonical grammar/vocab/collocation/strategy/lesson/exercise assets | P1; activation: content quality gate + KA rights review | registry row; `KA.*` (8 caps) | no owner_spec/contracts/events; `knowledge_quality_acceptance` pending; KA rights_status pending_review (17 assets) |
| `GOVERNANCE.Quality` | Anti-gaming, bias, drift, confidence, audit, gold-standard beyond P0 | P1; activation: P0 governance evidence + governance benchmark | registry row; `EVAL.AntiGaming` (DEPRECATED alias → GOVERNANCE.AntiGaming in OPS.QualityEconomics) | no owner_spec/contracts/events; `governance_benchmark` pending; GOV.* P1 (AntiGaming/Drift/Bias/Dashboard/GoldStandardBenchmark) |
| `COACH.Feedback` | Cross-skill explanatory feedback and tutoring after P0 | P1; activation: P0 feedback evidence + helpfulness evidence | registry row; `COACH.*` (AnswerExplanation/Vocabulary/Distractor/Listening/Reading/Recommendation/Tutor) | no owner_spec/contracts/events; `feedback_helpfulness_evidence` pending; distractor/paraphrase registries unresolved (framework gap) |

## Orphan registry family (not dossier coverage)

| Registry family | Why excluded from reachable coverage | Required resolution |
|---|---|---|
| `SPEAKING.Practice` | `capability-family-registry.yaml` contains the family, but `capability-family-map.yaml` maps no capability to it; speaking capabilities map to `SPEAKING.Evaluation`. It is not an executor-selectable family. | Protected founder decision B4-2: remove/deprecate it, or add/move Blueprint capabilities through a scope decision. |

## DEPRECATED member note

| Family | Member | Reason | Replacement |
|---|---|---|---|
| `GOVERNANCE.Quality` (PLANNED family) | `EVAL.AntiGaming` (DEPRECATED) | deprecated alias | `GOVERNANCE.AntiGaming` (OPS.QualityEconomics) |

Family `GOVERNANCE.Quality` is itself PLANNED in the registry; only its sole mapped member `EVAL.AntiGaming` is DEPRECATED. Lifecycle-smell reconciliation is tracked in `convergence-batch-4-protected-diffs.md` DIFF B4-4.

## Unresolved gaps (from this projection)

1. **SPEAKING.Practice orphan** — family in registry with zero mapped capabilities. Needs reconcile (protected: registry/map/lifecycle).
2. **PRACTICE.Drill namespace collision** — capability ID `PRACTICE.Drill` == family ID `PRACTICE.Drill`. Needs disambiguation (protected).
3. **WRITING.Evaluation interaction_spec** — registry points to deprecated `interaction/writing-evaluation.md`; canonical is `interaction/writing-task-2.md` (protected diff B4-1).
4. **Family count 25 vs 26** — semantic snapshot/map resolve 25 reachable families while registry has 26 because of `SPEAKING.Practice`. This is a canonical-registry correctness gap, not a harmless projection discrepancy; it blocks global unlock requirement 8.
5. **All 19 reachable PLANNED families** lack owner_spec/contracts/events — expected (deferred); activation requires roadmap decision + evidence, never inferred. The extra orphan registry family is tracked separately above.
6. **KA rights/content review** and **gold corpus / benchmark / thresholds** remain founder/external-owned across CONTENT.Knowledge, SPEAKING.Evaluation, MOCK.ExamSimulation, GOVERNANCE.Quality.
7. **COACH.Feedback** blocked by unresolved `distractor_type`/`paraphrase_pattern` registries (framework gap).
8. **PRONUNCIATION.Practice** blocked by P_* namespace overlap (framework gap).

## Rules

- PLANNED family ≠ build-ready. Chỉ nâng scope qua roadmap decision + Build Readiness Matrix + evidence gate.
- Projection này không thay `capability-family-registry.yaml` (SSOT family identity) hay `capability-family-map.yaml` (SSOT capability→family).
- Mọi executor muốn build một ACTIVE family phải đọc runtime spec + contracts của family đó, không tự suy luận.
- Gaps 1-3 cần privileged review (protected registry/map/lifecycle/blueprint).
- Gaps 1–4 above are tracked as PD-01–PD-04 in the canonical `artifacts/operations/founder-review-packet-index.md`.
