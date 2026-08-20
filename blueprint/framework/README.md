# IELTS Knowledge Framework

The IELTS Knowledge Framework contains **domain definitions, controlled vocabularies, instructional models and official-derived test facts**. It contains no learner-owned runtime state and no concrete learner asset inventory.

Every lesson, content item, evaluation and review mapping must resolve only the framework concepts that its active contract actually needs. The framework exists to prevent invented scoring rules and unstable identifiers, not to force every content item to carry every taxonomy dimension.

## Purpose

The framework supplies stable definitions for concepts such as question/task types, rubric criteria, micro-skills, error patterns, grammar concepts, review mappings and exam-module facts so product/runtime contracts can remain deterministic and auditable.

The framework is **not an IELTS publication**. Only facts supported by current public IELTS sources are external-normative/official-derived. LenBands taxonomies, curriculum sequencing, learning stages, diagnostic heuristics and practice policies remain internal product constructs.

## Authority classes

| Authority | Meaning | May drive official score/format claims? |
|---|---|---|
| `external-normative` | Current authoritative public IELTS material | Yes |
| `official-derived` | Traceable LenBands restructuring/paraphrase of normative material | Yes, while source/version remains current and meaning is preserved |
| `lenbands-controlled` | Internal IDs, taxonomy, curriculum organization and product policy | No; learning/product behavior only |
| `experimental-heuristic` | Uncalibrated routing/difficulty/threshold/count association | No; never sole source of band/readiness claim |

Rules:

1. Numeric score conversion, official timing/format, examiner criteria or other official claims require external-normative/official-derived support.
2. A LenBands taxonomy node may carry provisional difficulty/band signals only as an internal heuristic until calibrated.
3. Curriculum coverage and IELTS evidence are separate concepts in storage and UI.
4. Missing/conflicting provenance fails closed for the affected claim; do not invent a replacement value.
5. A model/provider/prompt cannot create or promote framework truth by output alone.

## Framework files

| File | Authority / content | Primary consumers |
|---|---|---|
| `band-descriptor-map.md` | official-derived Writing/Speaking descriptor summaries | `EVAL.Writing`, `EVAL.Speaking` |
| `skill-questiontype-band.md` | official-derived question/task inventory plus explicitly marked LenBands heuristics | `LEARN.QuestionTypes`, activated skill content |
| `microskill-enum.md` | LenBands-controlled micro-skill IDs | diagnosis/remediation where activated |
| `error-taxonomy.md` | LenBands-controlled learner-error IDs | feedback, mistake/review mapping |
| `review-mapping.md` | LenBands-controlled error → remediation/review policy | `REVIEW.*` |
| `grammar-band-framework.md` | LenBands-controlled grammar curriculum; band associations are heuristic unless calibrated | grammar learning/review |
| `vocab-collocation-topic.md` | LenBands-controlled vocabulary/collocation/topic organization | activated vocabulary/search features |
| `speaking-parts-framework.md` | official-derived Speaking format + LenBands practice policy | Speaking/Examiner/Pronunciation |
| `writing-task-framework.md` | official-derived Writing format/criteria + LenBands instructional scaffolds | Writing learning/evaluation |
| `exam-module-differences.md` | official-derived module/scoring/format boundary | Goal, Mock, Readiness |

The file count and path names are documentation details; stable framework node IDs and authority/provenance are the durable identities.

## Controlled-vocabulary rules

1. **Do not invent IDs.** Unknown required values use the domain `unknown_*`/`needs_review` state.
2. **Resolve only what the active capability needs.** A future taxonomy dimension does not become mandatory metadata for current P0 content.
3. **Version semantic changes.** Addition/correction/removal follows the owning file's version policy; removal is deprecated before deletion where historical evidence references it.
4. **Official source wins.** Current external normative material wins when an internal summary conflicts.
5. **No asset duplication.** Concrete passages, prompts, questions, examples and vocabulary assets remain Knowledge Assets/content, not framework SSOT.
6. **No calibration by naming.** A `band` field/name beside a node does not make the relationship calibrated.

## Taxonomy decision-value rule

A framework taxonomy can exist before product activation, but requiring authors/runtime to populate a field has a higher bar.

A metadata dimension becomes release-blocking only when an active contract identifies:

```yaml
consumer: <capability/engine>
decision: <observable product/domain decision>
authority: <framework file/node family>
validation: <rule>
fallback: <unknown/degraded behavior>
phase: P0 | P1 | P2
```

If the consumer/decision is not active, the value may remain absent/unknown without blocking unrelated content.

This prevents taxonomy breadth from becoming an unbounded content-operations cost.

## TargetProfile boundary

The learner's target is runtime Goal state, not framework truth.

A TargetProfile may contain:

```yaml
exam_module: academic | general_training
target_overall_band: number | null
skill_minimums:
  listening: number | null
  reading: number | null
  writing: number | null
  speaking: number | null
exam_date: date | null
purpose: string | null
```

Framework/content declares what a task teaches/measures and which exam module it is valid for. It does **not** copy a learner-specific target into a shared framework node.

```text
TargetProfile
  -> planner/selectors
  -> eligible content/evidence opportunities
  -> domain evidence admission
  -> readiness interpretation
```

No framework node may shortcut this chain by declaring a learner "Band X ready" from curriculum completion alone.

## Learning-stage boundary

Internal learning stages may be used to change scaffolding/feedback depth:

`foundation | developing | target | advanced | precision`

They are **not official IELTS bands** and do not require a fixed one-to-one mapping to numeric bands. A learner can be at different stages for different constructs/skills.

This avoids treating a single overall band as a universal teaching mode.

## Evidence and exposure boundary

Framework concepts may define what construct/error a task can elicit, but runtime evidence policy decides whether an observation is admissible.

Important distinctions:

```text
item/task identity != construct
correctness != independent evidence
repeated success != transfer
FSRS maturity != complex-skill mastery
curriculum coverage != IELTS readiness
```

Exposure/familiarity is runtime state. When the learner has seen an answer/explanation, the configured evidence policy decides whether that attempt remains usable for learning, retest or diagnostic purposes.

## Deterministic-first usage

Use controlled framework facts/rules before inference for:

- task/question-type validation;
- rubric criterion identity;
- answer normalization when an answer key exists;
- error/remediation mapping when exact IDs exist;
- exam-module eligibility;
- exposure/evidence policy lookup.

Inference may propose a semantic classification only where deterministic evidence is insufficient. The result remains a candidate until schema/framework validation accepts it.

## Graph / outcome ownership

- Complete nodes may declare `depends_on`, `done_when`, `can_statement` or equivalent relationships where useful.
- Generated indexes/graphs are projections, not competing SSOTs.
- Changing an authoritative relationship means changing its canonical node and regenerating projections.
- Do not maintain a global graph solely because a visualization exists.

## Agent reading rules

P0 Writing normally needs only:

- `writing-task-framework.md`;
- current `band-descriptor-map.md`;
- the activated subset of `error-taxonomy.md`;
- the activated subset of `review-mapping.md`;
- `exam-module-differences.md` when module semantics matter.

Do **not** load Listening/Reading/Speaking vocabulary simply because those files exist.

Listening/Reading/Speaking expansion reads only the framework slices required by that implementation phase.

## Version

`framework_version: 1.1.0`

This version records the authority/economics clarification that:

- taxonomy presence does not imply mandatory metadata population;
- TargetProfile is learner runtime state, not framework identity;
- learning stages are internal scaffolding states rather than fixed band equivalents;
- model output cannot create framework authority;
- exposure/evidence admission remains a runtime/domain decision.

Individual domain files retain their own versions and must advance independently when their facts/semantics change.

## Non-negotiable interpretation

- The words `band`, `Band Map` or a numeric value in an internal curriculum file do not create an official IELTS threshold.
- Grammar/vocabulary counts, micro-skill completion, error frequency, content completion and FSRS state do not alone prove an IELTS band.
- Generated/model-proposed taxonomy is never automatically framework truth.
- If an official source changes, update the affected official-derived framework and downstream contracts before continuing to serve the affected claim.