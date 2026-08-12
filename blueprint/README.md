# IELTS AI-first Knowledge OS — Blueprint

Đây là Single Source of Truth (SSOT) cho sản phẩm, tổ chức theo kiến trúc **hub-and-spoke 9 file**, mỗi file giữ đúng một concern, dependency gần như một chiều.

Blueprint là tầng **định nghĩa bất biến**. Nó trả lời: sản phẩm tồn tại để làm gì, có capability nào, behavior nào không được phá vỡ, quality/cost/legal guardrail nào phải giữ. Blueprint không phải backlog, wireframe, OpenAPI hoặc implementation plan.

## Purpose

Mô hình hóa một app học IELTS theo hướng **Knowledge OS AI-first**: không phải LMS chứa lesson, không phải app làm quiz, mà là hệ thống giúp learner hiểu toàn bộ IELTS blueprint, biết mình đang ở đâu, thiếu gì, và cần học gì tiếp theo.

## Repository Constitution

1. **Blueprint defines invariants.** Blueprint là SSOT cho các nguyên tắc và contract bền vững của sản phẩm.
2. **Artifact records decisions, evidence and indexes.** Artifact không trở thành nguồn content mutable để phục vụ learner.
3. **Knowledge Asset is the canonical, versioned knowledge object.** Mỗi asset có một `asset_id`, manifest, provenance và lifecycle rõ ràng.
4. **Only pipelines/agents create or transform Knowledge Assets. Evidence is immutable.** Pipeline/agent phải ghi transformation record; evidence không overwrite, chỉ tạo version/snapshot mới.

Chi tiết cấu trúc repository ở `../README.md`. Dependency dùng stable ID và chỉ đi xuống; không layer nào đọc hoặc mutate source của layer cao hơn.

## Blueprint contract

Mọi nội dung mới phải thuộc đúng một concern trong 8 spoke dưới đây; README là hub và governance, tạo thành bộ 9 file:

| File | Phải định nghĩa | Không định nghĩa |
|---|---|---|
| `01-product.md` | Vision, user, value, scope, success, product guardrails | Screen/API/data schema |
| `02-architecture.md` | Domain, boundary, planes, runtime state, technology boundary | Capability detail/backlog |
| `03-features.md` | Capability catalog, stable IDs, event contract | UI layout, implementation code |
| `04-experience.md` | Experience principles, journeys, UX behavior invariants | CSS/component code |
| `05-content.md` | Knowledge model, taxonomy, content quality/publish rules | Learner runtime content files |
| `06-engines.md` | Engine contracts, failure, evaluation/governance/cost invariants | Provider-specific code |
| `07-conventions.md` | Naming, privacy, accessibility, localization, cross-cutting rules | One-off feature decisions |
| `08-roadmap.md` | Phase, priority, release/deprecation policy | Detailed build specification |

### Blueprint capability readiness

Một capability chỉ được xem là `build candidate` khi đã có:

```yaml
capability_id: DOMAIN.Capability
user_outcome:
owner:
phase:
dependencies: []
primary_events: []
quality_gate:
cost_budget:
fallback:
privacy_class: account | learning | assessment | audio | billing | system | derived
```

Các trường này là contract tối thiểu; chi tiết screen/API/data/failure chuyển sang Artifact build-ready spec.

### Blueprint change rule

- Blueprint thay đổi khi invariant, scope, capability hoặc guardrail thay đổi.
- Quyết định triển khai cụ thể đi vào Artifact, không sửa Blueprint để chứa implementation detail.
- Roadmap có thể thay đổi mà không làm thay đổi capability identity.
- Mỗi capability chỉ có một mô tả canonical trong `03-features.md`; spoke khác chỉ reference bằng ID.

## Nguyên tắc xuyên suốt

1. **Blueprint structured, không phải danh sách lesson** — IELTS được mô hình hóa thành domain có cấu trúc, band là khuyến nghị mềm không khóa cứng.
2. **Sole evaluator + governance** — toàn bộ tầng evaluation do AI xử lý 100%, không human-in-the-loop; AI Governance là control target backend invisible, chưa phải quality guarantee nếu thiếu corpus/threshold/run thật.
3. **No-AI-label UI** — trong docs dùng chữ "AI" ở capability để dev hiểu nguồn gốc; trong UI người dùng không hiển thị chữ "AI" hay icon AI, chỉ tên chức năng thuần túy.
4. **Progress over pressure** — retention đến từ tiến bộ có thể nhìn thấy, phiên học vừa sức và đường quay lại tử tế; không dùng guilt, streak loss hay notification spam để giữ người.
5. **Trustworthy outcomes** — mọi feedback phải giải thích được, dẫn tới một hành động cụ thể và có bước kiểm chứng lại; hệ thống luôn hiển thị trạng thái, giới hạn và độ tin cậy phù hợp.
6. **Cost-aware by design** — mọi capability AI có model tier, ngân sách, quota, cache và fallback; chất lượng tối thiểu được bảo vệ trước khi tối ưu chi phí.
7. **Fixed tech stack** — Backend: **Go**, Engine/AI/Data: **Python**, Frontend: **Next.js**. Chi tiết và ranh giới ở `02-architecture.md` § Technology Stack. Mọi artifact sinh ra phải dùng stack này.

## Document Map

| File | Concern | Loại artifact AI sẽ sinh |
|---|---|---|
| `README.md` (file này) | HUB: mục lục, glossary, nguyên tắc | — (entry point) |
| `01-product.md` | WHY / WHO / WHAT: vision, role, scope, boundaries | Product brief |
| `02-architecture.md` | Domain Map, Capability Layer, System Boundary, Skill Modeling, Runtime State Model | System architecture |
| `03-features.md` | Capability Catalog, Event Contract (Learner / Content / Admin) với capability id | Entity, API, data model, analytics schema |
| `04-experience.md` | 8 User Journeys, Home, UX Principles, Delight, Empty State | UI screen, component, workflow |
| `05-content.md` | Knowledge System: Assets, Taxonomy, Tagging, Question Bank, Colab Workflow | Content schema, tagging model |
| `framework/` (spoke con của 05) | IELTS Knowledge Framework: band descriptor, question type, micro-skill, error taxonomy, grammar/vocab band, speaking parts, writing task, exam module differences | IELTS domain gen (chặn hallucinate) |
| `06-engines.md` | Learning Engine: FSRS, Evaluation, Recommendation, Failure Contract, Governance, Quality & Cost | Thuật toán, runtime errors, routing, calibration pipeline |
| `07-conventions.md` | UI Naming, Icon, Accessibility, Localization, Data Privacy | Design system, convention |
| `08-roadmap.md` | P0/P1/P2, MVP, Version, Release, Deprecation | Sprint backlog, phasing |

## Reading Order

```
README (file này)
   │
   ▼
01 Product  ──WHY/WHO/WHAT──
   │
   ▼
02 Architecture  ──domain/capability layer──
   │
   ▼
03 Features  ──capability catalog + capability id──
   │
   ┌────┴────┐
   ▼         ▼
04 UX     05 Content   ← dùng capability id làm neo, không lặp mô tả
   │         │
   └────┬────┘
        ▼
06 Engines  ──cung cấp thuật toán cho Features (FSRS, Evaluation, Recommendation, Governance)
   │
   ▼
07 Conventions  ──áp đặt luật lên mọi file trên
   │
   ▼
08 Roadmap  ──đọc tất cả để lên phasing
```

Dependency gần như một chiều. Không spoke phụ thuộc ngược về spoke trước nó (trivial back-ref OK).

## Capability ID schema

Mọi capability có id duy nhất theo dạng `{DOMAIN}.{Capability}`, dùng làm neo tham chiếu xuyên suốt các spoke (đặc biệt `04-experience.md` và `06-engines.md`):

- `EVAL.Writing` — Writing Evaluation
- `EVAL.Speaking` — Speaking Evaluation
- `EVAL.Pronunciation` — Pronunciation Evaluation
- `EVAL.Examiner` — Examiner (interactive dialogue)
- `EVAL.BandPrediction`
- `EVAL.RewriteSuggestion`
- `EVAL.AntiGaming`
- `COACH.AnswerExplanation`
- `COACH.VocabularyExplanation`
- `COACH.DistractorExplanation`
- `COACH.ListeningCoach`
- `COACH.ReadingCoach`
- `COACH.ErrorAnalysis`
- `COACH.Recommendation`
- `COACH.Tutor` — IELTS Q&A, context-aware
- `LEARN.Listening`, `LEARN.Reading`, `LEARN.Writing`, `LEARN.Speaking`, `LEARN.Pronunciation`
- `PRACTICE.Drill`, `PRACTICE.Adaptive`, `PRACTICE.MockTest`, `PRACTICE.ExamSimulation`
- `REVIEW.SmartQueue`, `REVIEW.MistakeNotebook`, `REVIEW.FSRS`
- `PERSONAL.Insights`, `PERSONAL.NextBestAction`, `PERSONAL.GapAnalysis`
- `BAND.Map`, `BAND.Readiness`, `BAND.ExamReadiness`, `BAND.Checklist`, `BAND.Requirement`
- `STUDY.Session`, `STUDY.DailyPlan`, `STUDY.TodayQueue`
- `PKM.Notes`, `PKM.WordBank`, `PKM.Collections`, `PKM.Import`, `PKM.Export`, `PKM.Offline`
- `GOVERNANCE.ConfidenceScore`, `GOVERNANCE.GoldStandardBenchmark`, `GOVERNANCE.DriftDetection`, `GOVERNANCE.AntiGaming`
- `OPS.ContentQuality`, `OPS.EvaluationQuality`, `OPS.ReleaseGate`, `OPS.OutcomeMeasurement`, `OPS.ModelRouting`, `OPS.CostBudget`, `OPS.Quota`, `OPS.Observability`
- `CONTENT.Publish`, `CONTENT.Moderation`, `CONTENT.Feedback`

Danh sách đầy đủ ở `03-features.md`.

## Quality bar (Definition of 10/10)

Blueprint chỉ được xem là đạt chuẩn khi có đủ bốn lớp sau:

| Lớp | Kết quả cần đạt | Chỉ số chính |
|---|---|---|
| Value | Learner nhận được chẩn đoán và một hành động hữu ích trong phiên đầu | time-to-first-value, activation rate |
| Retention | Learner quay lại vì thấy tiến bộ và có phiên phù hợp năng lượng/thời gian | D7/W4 retention, meaningful study days, comeback rate |
| Learning quality | Feedback đúng, dễ hiểu, có thể hành động và được kiểm chứng | outcome lift, error recurrence, calibration error, content report rate |
| Economics | Chi phí trên mỗi kết quả hữu ích nằm trong ngân sách | cost/active learner, cost/evaluation, cache hit rate, fallback rate |

Các capability mới phải chỉ rõ owner, phase, dependency, quality gate, cost budget và event đo lường. Nếu chưa có, capability đó chỉ là ý tưởng, chưa phải contract để build.

## Glossary

- **Knowledge OS** — hệ điều hành tri thức: mô hình hóa một lĩnh vực (IELTS) thành domain có cấu trúc, giúp người dùng biết mình ở đâu, thiếu gì, học gì tiếp.
- **Sole evaluator** — AI là nguồn chấm điểm duy nhất, không human-in-the-loop; governance backend là cơ chế kiểm soát phải được chứng minh bằng corpus, threshold và run thật.
- **AI Governance** — tầng backend invisible (confidence scoring, gold-standard benchmark, drift/bias monitoring, anti-gaming), không phải human review.
- **Capability id** — định danh duy nhất cho một năng lực hệ thống, dạng `{DOMAIN}.{Capability}`, dùng làm neo tham chiếu xuyên suốt.
- **Colab** — vai trò content operator (thêm, kiểm duyệt, publish nội dung), không bao giờ chấm bài.
- **FSRS** — Free Spaced Repetition Scheduler, thuật toán spaced repetition chính của hệ thống (chi tiết `06-engines.md`).
- **Band Readiness** — mức độ sẵn sàng ở một band (khuyến nghị mềm, không khóa cứng).
- **Exam Readiness** — mức độ sẵn sàng cho kỳ thi thi thật (overall + per-skill + confidence + risk).
- **Smart Review Queue** — các view của FSRS queue (Today's, Priority, Weak Skill, Exam Queue).
- **Personal Knowledge (PKM)** — kho tri thức cá nhân learner tự xây (notes, word bank, collections, drafts, recordings), phân biệt với Knowledge Assets (tri thức hệ thống do Colab publish).
- **Runtime State Model** — state vector đa trục của learner: lifecycle, learning, session, evaluation và goal; là SSOT cho Home, recommendation, notification và recovery.
- **Event Contract** — schema bất biến có version cho các fact product/learning; là SSOT cho analytics, recommendation, dashboard và experimentation.
- **Failure Contract** — taxonomy và response chuẩn cho failure runtime: retry, fallback, data safety, quota, UI state và telemetry.

## Cross-references

- Vai trò và ranh giới → `01-product.md` § Role Model
- Domain và capability layer → `02-architecture.md`
- Capability chi tiết → `03-features.md`
- Cảm xúc và hành trình → `04-experience.md`
- Content workflow và taxonomy → `05-content.md`
- Thuật toán engine → `06-engines.md`
- Quy ước đặt tên / a11y / localization → `07-conventions.md`
- Phasing và roadmap → `08-roadmap.md`
- Quality, retention và cost guardrails → `01-product.md`, `04-experience.md`, `06-engines.md`, `08-roadmap.md`
- Runtime contracts → `02-architecture.md` § Runtime State Model, `03-features.md` § Event Contract, `06-engines.md` § Failure Contract
