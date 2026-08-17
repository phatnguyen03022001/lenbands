---
version: 1.0.7
scope: framework
---

# Writing Task Framework (Academic/General Training)

Status: `framework` — combines official-derived Writing format/assessment boundaries with LenBands-controlled task taxonomy and instructional scaffolds. Feeds `LEARN.Writing`, `EVAL.Writing`, curriculum views, and the `W_*` error taxonomy.

Authority:
- Minimum word counts, two-task structure, approximate recommended timing, assessment criteria, and Task 2 weighting are official-derived from IELTS.org.
- Paragraph templates, vocabulary checklists, task-subtype IDs, content grouping advice, and coaching workflows are LenBands instructional conventions.
- Public descriptors and the reviewed evaluation contract determine scoring. Internal templates or error tags do not create automatic band caps unless an official-derived scoring rule explicitly supports them.

Official references:
- Academic Writing: `https://ielts.org/take-a-test/test-types/ielts-academic-test/ielts-academic-format-writing`
- General Training Writing: `https://ielts.org/take-a-test/test-types/ielts-general-training-test/ielts-general-training-format-writing`
- Scoring: `https://ielts.org/take-a-test/your-results/ielts-scoring-in-detail`

## Academic Task 1

### LenBands task taxonomy

| id | Type | Description | Minimum words |
|---|---|---|---:|
| `W_ac_task1_chart` | Chart/graph (`chart_variant`: `line`, `bar`, `pie`, `mixed`) | describe/compare visual data | 150 |
| `W_ac_task1_table` | Table | describe/compare tabular data | 150 |
| `W_ac_task1_process` | Process | describe stages of a process/procedure | 150 |
| `W_ac_task1_map` | Map/plan | describe relevant spatial/change features | 150 |
| `W_ac_task1_diagram` | Diagram/object | describe an object, event, sequence, or how something works | 150 |

`W_ac_task1_chart` remains the canonical chart question type where downstream contracts require a single chart ID; chart variants are metadata rather than new controlled IDs.

### Official-derived requirements

- Write at least 150 words.
- Present the important information/features accurately and appropriately.
- Use an academic or semi-formal/neutral style.
- Assessment uses Task Achievement, Coherence & Cohesion, Lexical Resource, and Grammatical Range & Accuracy.
- A well-organised overview of the visual information is part of what the task tests.

### LenBands instructional scaffold

A common teaching structure is:

```text
Introduction / task paraphrase
Overview of the most important features
Body grouping with relevant detail/comparison
```

This is a scaffold, not a mandatory paragraph count. The app must not penalize a response merely for using a different organisation when the official criteria are satisfied.

### Diagnostic rules

| Diagnostic | Meaning | Error id |
|---|---|---|
| Missing/unclear overview | important Task Achievement limitation to evaluate against the current descriptor | `W_t1_no_overview` |
| Personal opinion displaces description | likely task-relevance problem; evaluate actual effect rather than applying a synthetic fixed cap | `W_t1_opinion_injected` |
| Unselective detail dump | key-feature selection/organisation may be weak | `W_t1_detail_dump` |
| Under 150 words | official guidance says an answer that is too short is penalised; public guidance does not define a universal fixed numeric band deduction for LenBands to invent | `W_tr_under_wordcount` |

## General Training Task 1

### LenBands task taxonomy

| id | Register class | Typical use |
|---|---|---|
| `W_gt_task1_formal_letter` | Formal | authority/service/professional context |
| `W_gt_task1_semi_formal_letter` | Semi-formal | known person in a non-intimate context |
| `W_gt_task1_informal_letter` | Informal | friend/family/personal context |

Official task prompts specify a situation and points that the response should cover. LenBands must score whether the response achieves the task purpose and uses appropriate register/style; it must not assume every live task has a fixed bullet count unless the actual prompt contains that count.

Common teaching structure:

```text
Greeting
Purpose/opening
Body covering every prompt point
Appropriate close/sign-off
```

Register examples are instructional guidance, not a fixed phrase checklist. A contraction or idiom is not automatically an IELTS error; appropriateness depends on context and effect.

## Task 2 — Academic + General Training

### LenBands task taxonomy

| id | Type | Typical prompt function |
|---|---|---|
| `W_task2_opinion` | Opinion | state/justify degree of agreement or disagreement |
| `W_task2_discussion` | Discussion | discuss views and give a position where requested |
| `W_task2_advantages_disadvantages` | Advantages/Disadvantages | analyse advantages/disadvantages, sometimes weigh them |
| `W_task2_problem_solution` | Problem/Solution | analyse a problem/cause and propose responses |
| `W_task2_two_part` | Two-part | answer two explicit questions |

These IDs are LenBands authoring categories, not an official exhaustive taxonomy of every possible wording.

### Official-derived requirements

- Write at least 250 words.
- Address the actual question fully and relevantly.
- Organise ideas clearly and support them with relevant examples/evidence where appropriate.
- Use an academic or semi-formal/neutral style for Academic Task 2; General Training Task 2 is also a discursive essay.
- Task 2 contributes **twice as much as Task 1** to the Writing section score.

### LenBands instructional scaffold

A common four-paragraph teaching pattern may be offered:

```text
Introduction
Body / developed main idea
Body / developed main idea
Conclusion
```

It is not an IELTS rule that a response must contain exactly four paragraphs. Score organisation through the official criteria.

### Diagnostic rules

| Diagnostic | Meaning | Error id |
|---|---|---|
| Required position is unclear/inconsistent | Task Response limitation | `W_tr_position_unclear` |
| A required part of the prompt is missing | Task Response limitation | `W_tr_task_missed_part` |
| Main ideas lack development/support | limits higher Task Response performance | `W_tr_idea_undeveloped` |
| Under 250 words | official guidance says too-short responses are penalised; do not invent a fixed automatic band deduction | `W_tr_under_wordcount` |
| Organisation/paragraphing is ineffective | Coherence & Cohesion limitation | `W_cc_no_paragraphing` |

## Time management

IELTS recommends about 20 minutes for Task 1 and about 40 minutes for Task 2 within the 60-minute Writing section. `STUDY.Session` may use those values as guidance. A strict mock should preserve the 60-minute section boundary rather than pretending the internal 20/40 split is separately enforced by the exam.

## Scoring contract

### Per-task analytic result

Each task is assessed using four equally weighted criteria. For diagnostics, LenBands may calculate the average of those four criterion bands, but that value must be named as a **task-level diagnostic**, not the full Writing section band.

```yaml
evaluation:
  task_ref: ...
  task_type: W_task2_opinion
  word_count: 287
  rubric_version: <reviewed-rubric-version>
  criteria:
    task_response:
      band: 6.5
      confidence: 0.82
      evidence_refs: [sent_3_position, para_2_idea]
      issues:
        - error_id: W_tr_idea_undeveloped
          evidence_ref: para_2
    coherence_cohesion: ...
    lexical_resource: ...
    grammar: ...
  task_band_diagnostic: 6.0
  overall_confidence: 0.85
  quality_status: accepted
```

### Writing section result

A complete Writing section result must preserve both tasks and apply the reviewed aggregation rule in which Task 2 carries twice the weight of Task 1:

```yaml
writing_section:
  task1_ref: <evaluation-ref>
  task2_ref: <evaluation-ref>
  aggregation: task2_weighted_twice
  aggregation_version: <version>
  section_band: <result>
```

If only one task is present, do not label its diagnostic average as the official-equivalent Writing section band. Return an incomplete diagnostic state instead.

## Curriculum vocabulary guidance

Trend/comparison vocabulary, paragraph templates, thesis patterns, and register examples can be taught as resources. They are not scoring checklists. High bands require effective, appropriate language in context rather than presence of specific memorized words or structures.

## Usage

- `LEARN.Writing`: learner selects a governed task type and receives an appropriate workspace.
- `EVAL.Writing`: retains criterion evidence, rubric version, and task identity.
- `BAND.Map`: uses criterion-based assessment evidence for band claims; curriculum completion is shown separately.
- `REVIEW.MistakeNotebook`: observed errors map to review rules without mechanically capping a band.

## Versioning

- Current release: `1.0.7`; the frontmatter is authoritative for the file version.
- `version: 1.0.1` — reconciled Academic Task 1 IDs and enumerated Task 2 authoring types.
- `version: 1.0.6` — normalized per-file release records without establishing calibration evidence.
- `version: 1.0.7` — separated official Writing requirements from teaching templates, removed synthetic fixed caps/paragraph rules, and separated per-task diagnostic averages from the Task-2-weighted Writing section score.
- Task-taxonomy schema changes require a minor bump; factual/scoring corrections require a patch bump plus source review.

## Do not infer

- Do not invent a fixed band cap or numeric penalty where public IELTS guidance gives no such fixed rule.
- Do not equate one task's four-criterion average with the complete Writing section score.
- Do not require a memorized paragraph count, phrase, vocabulary item, or grammar structure as a condition for a band.
- Do not create task IDs outside the controlled taxonomy without review.
