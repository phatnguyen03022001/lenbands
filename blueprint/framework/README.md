# IELTS Knowledge Framework

The invariant IELTS knowledge framework — **contains no assets**, only framework definitions. This is the product's "genome"; every asset, lesson, evaluation, and review card must trace back to this framework.

## Purpose

Before this framework existed, the Blueprint had capabilities and a coverage contract but lacked **IELTS domain depth**. An agent spawning a Listening/Reading/Speaking slice would have to infer grammar points, error types, micro-skills, and review rules, creating hallucination risk. This framework prevents that: every IELTS entity (grammar point, error, micro-skill, topic, question type, band requirement) must have an ID in the framework.

## Files (10)

| File | Content | Feeds |
|---|---|---|
| `band-descriptor-map.md` | 4 criteria × 9 bands × official Writing/Speaking descriptors | `EVAL.Writing/Speaking`, `BAND.Requirement`, `BAND.Map` |
| `skill-questiontype-band.md` | Matrix of skill × question/task type × band difficulty | `05-content.md`, `BAND.Map`, `LEARN.QuestionTypes` |
| `microskill-enum.md` | Versioned micro-skill enum by question type | `learning_design_profile.target_micro_skills`, `BAND.Map` micro-skill row, `COACH.ErrorAnalysis` |
| `error-taxonomy.md` | Error IDs by skill + criterion impact + band signal | `COACH.ErrorAnalysis`, `REVIEW.MistakeNotebook` tag, `BAND.Map` ⚠/✗ |
| `review-mapping.md` | Error → review rule (review type + frequency + FSRS card kind) | `REVIEW.SmartQueue`, `REVIEW.MistakeNotebook`, `REVIEW.FSRS` |
| `grammar-band-framework.md` | 47 grammar points × introduce/master band | `KA.Grammar`, `BAND.Map` grammar row, FSRS card source |
| `vocab-collocation-topic.md` | 10 topics + collocation framework + target count by band | `KA.Vocabulary/Collocation`, `BAND.Map` vocab/collocation row |
| `speaking-parts-framework.md` | Part 1/2/3 behavior + pronunciation depth + examiner rules | `EVAL.Speaking`, `EVAL.Examiner`, `EVAL.Pronunciation`, `LEARN.Speaking` |
| `writing-task-framework.md` | Academic/General Task 1 + Task 2 structure + requirements | `LEARN.Writing`, `EVAL.Writing`, `BAND.Map` writing row |
| `exam-module-differences.md` | Academic vs General + raw-score → band conversion + normalization | `PRACTICE.MockTest`, `BAND.ExamReadiness`, `GOAL.Target` module routing |

## Usage principles

1. **Controlled vocabulary**: framework IDs are the only valid IDs. Values outside the enum → `unknown_*`; never invent a name.
2. **Versioned**: every file has a `version`. Addition = minor, correction = patch, removal = deprecated rather than deleted.
3. **Do not infer**: if the framework is missing something, report it and flag it for Colab to add. Do not invent band requirements, grammar points, or error IDs.
4. **Source of truth**: descriptors, bands, and score conversion follow public official IELTS sources. If there is a conflict, the official source wins.
5. **Contains no assets**: these files define the framework; concrete words/collocations/lessons are `KA.*` assets authored by Colab.
6. **Inline ownership — graph/outcome belongs to the node, not to a central file**:
   - Each node has its own schema; `depends_on`, `done_when`, and `can_statement` may be claimed only when the node declares them completely. A summary table is not a complete node.
   - There is NO `dependency-graph.md` or `learning-outcome.md` as an SSOT. Such a God file would violate separation of concerns.
   - Global graph/index views are generated projections at `artifacts/operations/catalogs/dependency-graph.yaml` and `learning-outcome-index.yaml` once their generators are implemented. Current files are sample `draft` projections, not build inputs; **write** authority remains with the nodes.
   - Rule: changing an edge/threshold means changing the node in the framework and then regenerating the projection. Never edit a projection directly.

## How agents use it

- Spawn a Listening/Reading slice: use `skill-questiontype-band.md` + `microskill-enum.md` + `error-taxonomy.md` + `review-mapping.md`.
- Spawn a Writing slice: add `writing-task-framework.md` + `band-descriptor-map.md`.
- Spawn a Speaking slice: add `speaking-parts-framework.md` + pronunciation depth.
- Spawn Band Map data: use `grammar-band-framework.md` (grammar row) + `vocab-collocation-topic.md` (vocab/collocation row) + `skill-questiontype-band.md` (question-type row) + `microskill-enum.md` (micro-skill row).
- Spawn Evaluation: use `band-descriptor-map.md` (criteria) + `writing-task-framework.md` (Task 1/2 requirements) + `speaking-parts-framework.md` (Part behavior).
- Spawn Mock Test: use `exam-module-differences.md` (conversion + normalization).

## Version

- `framework_version: 1.0.6` — metadata-governance hardening release; all 10 domain files expose an ordered, validator-enforced version record without changing controlled vocabulary.
- Bump the specific file version when that file changes; bump `framework_version` when adding a file.
- 2026-08-07: standardized per-file frontmatter, reconciled controlled vocabulary/event references, and released `1.0.1`; this is a semantic patch before spawn freeze, not evidence of calibration.
- 2026-08-07: clarified grammar `error_refs` versus prerequisite `depends_on` in the inventory projection and released `1.0.2`; this remains a framework correction, not calibration evidence.
- 2026-08-07: corrected Listening/Reading question-type inventory counts and released `1.0.3`; this remains a vocabulary correction, not calibration evidence.
- 2026-08-07: separated grammar prerequisites from `error_refs`, removed a duplicate band summary row, and released `1.0.4`; this remains a framework semantics correction, not calibration evidence.
- 2026-08-07: corrected `g_participle_clauses` taxonomy reference, converted Writing Task 1/combined criterion cells and `all_bands` into controlled values, and released `1.0.5`; this remains a validator/typing correction, not calibration evidence.
- 2026-08-07: completed per-file version records and made changelog ordering machine-verifiable in `1.0.6`; no IELTS node, threshold, calibration claim, or runtime evidence changed.
