# IELTS Knowledge Framework

The IELTS knowledge framework — **contains no learner assets**, only domain definitions, controlled vocabularies, instructional models, and official-derived test facts. This is a governed knowledge layer; every asset, lesson, evaluation, and review card must trace to an appropriate framework node or external normative source.

## Purpose

Before this framework existed, the Blueprint had capabilities and a coverage contract but lacked enough IELTS-domain structure for deterministic authoring and diagnosis. The framework supplies stable IDs for grammar points, error types, micro-skills, topics, question types, review mappings, and test-format facts so agents do not silently invent identifiers or scoring rules.

The framework is **not itself an IELTS publication**. Only facts explicitly sourced from public IELTS material are official-derived. LenBands taxonomies, curriculum sequencing, diagnostic thresholds, topic grouping, and practice heuristics remain internal product constructs.

## Authority classes

Every framework claim must be interpreted through one of these authority classes:

| Authority | Meaning | May drive official score/format claims? |
|---|---|---|
| `external-normative` | Current public IELTS.org material. Wins on conflict. | Yes; this is the normative source. |
| `official-derived` | LenBands restructuring/paraphrase of an external-normative fact with a traceable source. | Yes, provided source/version is current and meaning is preserved. |
| `lenbands-controlled` | Internal IDs, enums, taxonomy, curriculum organization, product policy, and workflow contracts. | No. May organize learning/product behavior only. |
| `experimental-heuristic` | Uncalibrated difficulty signals, target counts, mastery thresholds, band associations, or diagnostic shortcuts. | No. Must not be presented as an IELTS requirement or used as the sole source of a band/readiness claim. |

Rules:
1. A numeric band threshold, score conversion, CEFR mapping, test timing/format rule, or examiner-scoring rule requires `external-normative`/`official-derived` support.
2. A LenBands curriculum item may carry a target band or difficulty estimate only as `experimental-heuristic` unless calibration evidence promotes it.
3. `BAND.Map` may display internal curriculum progress, but the UI must distinguish **curriculum coverage** from **IELTS band evidence**.
4. A heuristic can influence recommendations, not override public band descriptors or objective answer-key evidence.
5. If provenance is absent or conflicting, fail closed with `needs_review`, `insufficient_evidence`, or the domain-specific `unknown_*` value.

## Files (10)

| File | Authority / content | Feeds |
|---|---|---|
| `band-descriptor-map.md` | official-derived operational summaries of Writing/Speaking descriptors; official source remains normative | `EVAL.Writing/Speaking`, `BAND.Requirement`, `BAND.Map` |
| `skill-questiontype-band.md` | official-derived question-type inventory + LenBands difficulty/requirement heuristics | `05-content.md`, `BAND.Map`, `LEARN.QuestionTypes` |
| `microskill-enum.md` | LenBands-controlled micro-skill taxonomy; `band_signal` is heuristic unless calibrated | `learning_design_profile.target_micro_skills`, `BAND.Map`, `COACH.ErrorAnalysis` |
| `error-taxonomy.md` | LenBands-controlled learner-error taxonomy; band signals are diagnostic heuristics | `COACH.ErrorAnalysis`, `REVIEW.MistakeNotebook`, `BAND.Map` |
| `review-mapping.md` | LenBands-controlled error → review policy and FSRS card mapping | `REVIEW.SmartQueue`, `REVIEW.MistakeNotebook`, `REVIEW.FSRS` |
| `grammar-band-framework.md` | LenBands-controlled grammar curriculum; grammar-to-band fields are instructional heuristics, not IELTS requirements | `KA.Grammar`, curriculum coverage, FSRS |
| `vocab-collocation-topic.md` | LenBands-controlled topic/collocation taxonomy and curriculum guidance; no official vocabulary-count requirement | `KA.Vocabulary/Collocation`, curriculum coverage |
| `speaking-parts-framework.md` | official-derived Speaking format + LenBands practice/simulator policies | `EVAL.Speaking`, `EVAL.Examiner`, `EVAL.Pronunciation`, `LEARN.Speaking` |
| `writing-task-framework.md` | official-derived Writing format/criteria + LenBands instructional scaffolds | `LEARN.Writing`, `EVAL.Writing`, `BAND.Map` |
| `exam-module-differences.md` | official-derived module/score anchors + versioned runtime conversion boundary | `PRACTICE.MockTest`, `BAND.ExamReadiness`, `GOAL.Target` |

## Usage principles

1. **Controlled vocabulary**: framework IDs are the only valid internal IDs. Values outside an enum → `unknown_*`; never invent a name.
2. **Versioned**: every domain file has a `version`. Addition = minor, correction = patch, removal = deprecate rather than silently delete.
3. **Do not infer**: if required framework knowledge is missing, flag it. Do not invent band requirements, score conversions, grammar requirements, or error IDs.
4. **Official source wins**: public IELTS material is external normative authority for IELTS descriptors, format, scoring, and score interpretation.
5. **No asset duplication**: concrete words, collocations, lessons, passages, questions, and prompts live as governed Knowledge Assets rather than being duplicated as framework SSOT.
6. **No calibration by prose**: writing a band number beside an internal taxonomy item does not make it calibrated. Promotion requires evidence and an explicit reviewed calibration record.
7. **Inline ownership**: a node owns its relationships and completion conditions. Global graphs/indexes are projections and must not become competing SSOTs.

## Graph / outcome ownership

- Each complete node declares fields such as `depends_on`, `done_when`, and `can_statement` inline where applicable.
- There is no hand-maintained global dependency or learning-outcome SSOT.
- Generated graph/index views live under `artifacts/operations/catalogs/` when a registered deterministic generator exists.
- Changing an edge/threshold means changing its canonical node and regenerating the projection. Never hand-edit a generated projection to conceal drift.

## How agents use it

- Listening/Reading authoring: `skill-questiontype-band.md` + `microskill-enum.md` + `error-taxonomy.md` + `review-mapping.md`.
- Writing authoring/evaluation: add `writing-task-framework.md` + current official-derived descriptor contract.
- Speaking authoring/evaluation: add `speaking-parts-framework.md` + pronunciation contract + current official-derived descriptor contract.
- Curriculum map: internal grammar/vocabulary/micro-skill coverage may be shown, but it must be labeled separately from predicted IELTS band.
- Mock Test: use `exam-module-differences.md`; objective scoring requires an approved versioned conversion table rather than inferred cut-offs.
- Any learner-visible band claim requires the evidence path defined by the evaluation/assessment contracts, not a curriculum-count shortcut.

## Version

- `framework_version: 1.0.6` — metadata-governance hardening release; this aggregate version changes only when the framework file set/schema boundary changes. Individual domain files may advance independently.
- Bump the specific file version whenever that file changes semantically or factually.
- 2026-08-07: standardized per-file frontmatter, reconciled controlled vocabulary/event references, and released `1.0.1`; this was a semantic patch before spawn freeze, not calibration evidence.
- 2026-08-07: clarified grammar `error_refs` versus prerequisite `depends_on` in `1.0.2`.
- 2026-08-07: corrected Listening/Reading question-type inventory counts in `1.0.3`.
- 2026-08-07: separated grammar prerequisites from `error_refs` and removed a duplicate band summary row in `1.0.4`.
- 2026-08-07: corrected taxonomy typing and controlled criterion values in `1.0.5`.
- 2026-08-07: completed per-file version records and changelog ordering in `1.0.6`; this did not establish IELTS calibration.
- 2026-08-17 audit: formalized authority classes after identifying baseline documents that mixed official IELTS facts with unvalidated LenBands heuristics. `exam-module-differences.md` advanced to `1.0.7`; other domain files advance independently as remediated.

## Non-negotiable interpretation

- The words "band", "Band Map", or a numeric target inside a LenBands curriculum file do not by themselves make the value an official IELTS threshold.
- Internal target counts, grammar sequencing, error frequencies, mastery percentages, and micro-skill band signals require calibration before they can gate an IELTS band claim.
- If an official source changes, update the official-derived framework and downstream references before serving the affected scoring/format claim.
