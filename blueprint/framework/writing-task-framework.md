---
version: 1.0.6
scope: framework
---

# Writing Task Framework (Task 1 Academic/General + Task 2)

Status: `framework` — defines structure, requirements, and scoring depth for each Writing task. Feeds `LEARN.Writing`, `EVAL.Writing`, the `BAND.Map` writing row, and the `W_*` error taxonomy.

## Task 1 Academic

### Task types

| id | Type | Description | Word target | Key challenge |
|---|---|---|---|---|
| `W_ac_task1_chart` | Chart/graph (`chart_variant`: `line`, `bar`, `pie`, `mixed`) | Describe trends, groups, or proportions according to chart type | 150+ | choose trend/comparison vocabulary appropriate to the variant |
| `W_ac_task1_table` | Table (static or time-series) | Compare tabular data | 150+ | comparison, grouping |
| `W_ac_task1_process` | Process | Describe a natural/man-made process | 150+ | passive voice, sequencing |
| `W_ac_task1_map` | Map | Compare maps across past/present/future | 150+ | spatial language, tense |
| `W_ac_task1_diagram` | Diagram/Object | Describe the structure of an object | 150+ | labels, spatial language |

`W_ac_task1_chart` is the canonical question type in `skill-questiontype-band.md`; `line`, `bar`, `pie`, and `mixed` are only `chart_variant` values, not independent task IDs. Older granular names must not be used for new assets.

**Static vs time-series distinction (important for vocabulary selection):**
- **Time-series (dynamic)**: data includes a time axis → use **trend vocabulary** such as rise, fall, fluctuate, peak and use past tense for past data.
- **Static**: data represents one point in time with no time axis → use **comparison vocabulary** such as whereas, while, in contrast, the most significant; do NOT use trend vocabulary because no change over time is shown.
- **Mixed**: contains both → prioritize trend language for time-series data and comparison language for static data. `W_t1_detail_dump` risk is higher in mixed tasks.

### Required structure

```text
1. Introduction (1-2 sentences)
   - paraphrase the task
2. Overview (2-3 sentences) — REQUIRED; missing overview caps TR around band 5 in this framework
   - main trend / main feature / key comparison
   - NO specific figures
3. Body paragraphs (2 paragraphs)
   - group data logically, e.g. by trend/category
   - specific figures + comparisons
```

### Critical requirements

| Requirement | Consequence if missing | Error id |
|---|---|---|
| Overview present | framework cap around band 5 for TR | `W_t1_no_overview` |
| No personal opinion | framework cap around band 5 for TR | `W_t1_opinion_injected` |
| Do not list all data | framework cap around band 5 for TR; key features must be selected | `W_t1_detail_dump` |
| Word count ≥ 150 | apply under-length handling according to evaluation policy | `W_tr_under_wordcount` |
| No conclusion required for Task 1 | informational | — |

### Task 1 Academic criterion focus

- TR: data accuracy + overview + selection
- CC: paragraph logic + cohesive presentation of data
- LR: trend/comparison vocabulary such as rise, fall, fluctuate, peak, account for
- GRA: tense appropriate to data, comparison structures, passive voice for processes

### Trend/comparison vocabulary checklist (band 6-7)

**Trend vocabulary for time-series / dynamic data:**

| Category | Vocabulary |
|---|---|
| Increase | rise, climb, grow, surge, soar, upward trend |
| Decrease | fall, decline, drop, plunge, downward trend |
| Stable | remain stable, plateau, level off |
| Fluctuation | fluctuate, vary, oscillate |
| Peak/trough | peak at, reach a low of, hit a high of |

**Comparison vocabulary for static data and comparisons within time-series:**

| Category | Vocabulary |
|---|---|
| Contrast | whereas, while, in contrast, by contrast, conversely |
| Similarity | similarly, likewise, the same pattern, comparable |
| Superlative | by far the most, the highest/lowest, the most significant |
| Proportion | account for, make up, comprise, constitute, represent, a mere, a mere fraction |
| Approximation | approximately, roughly, just over/under, nearly, almost |

**Vocabulary selection by chart type:**
- Line chart → mainly trend vocabulary.
- Static pie/bar/table → mainly comparison + proportion.
- Time-series bar/table → trend + comparison.
- Mixed → combine both, prioritizing trend vocabulary for data with a time axis.

## Task 1 General Training (Letter)

### Task types

| id | Type | Tone | Description |
|---|---|---|---|
| `W_gt_task1_formal_letter` | Formal | Formal | complaint, job application, request to an authority |
| `W_gt_task1_semi_formal_letter` | Semi-formal | Semi-formal | neighbor, colleague |
| `W_gt_task1_informal_letter` | Informal | Informal | friend, family |

### Required structure

```text
1. Greeting (Dear Sir/Madam, Dear Mr. X, Dear John)
2. Opening (reason for writing — paraphrase the task)
3. Body (cover all 3 bullet points in the task)
4. Closing (sign-off: Yours faithfully/formal, Yours sincerely/semi, Best regards/informal)
```

### Critical requirements

| Requirement | Consequence | Error id |
|---|---|---|
| Tone appropriate to letter type | framework cap around band 5 for TR/LR | `W_letter_wrong_tone` |
| Cover all 3 bullets | framework cap around band 5 for TR | `W_tr_task_missed_part` |
| Word count ≥ 150 | apply under-length handling according to evaluation policy | `W_tr_under_wordcount` |

### Tone/register rules

| Tone | Open | Close | Style |
|---|---|---|---|
| Formal | Dear Sir/Madam, Dear [Title+Name] | Yours faithfully, Yours sincerely | no contractions, no idioms |
| Semi-formal | Dear [First name] | Yours sincerely, Kind regards | some contractions acceptable |
| Informal | Dear [First name] | Best wishes, Lots of love, Cheers | contractions, idioms, casual language |

## Task 2 (Academic + General Training shared)

### Task types

| id | Type | Prompt pattern | Key challenge |
|---|---|---|---|
| `W_task2_opinion` | Opinion | "To what extent do you agree/disagree?" | clear position throughout |
| `W_task2_discussion` | Discussion | "Discuss both views and give your opinion." | balance + own position |
| `W_task2_advantages_disadvantages` | Advantages/Disadvantages | "Do advantages outweigh disadvantages?" | evaluate both + position |
| `W_task2_problem_solution` | Problem/Solution | "Causes and solutions?" | identify + propose |
| `W_task2_two_part` | Two-part | 2 sub-questions | answer both fully |

### Common instructional structure (4 paragraphs)

```text
1. Introduction (2-3 sentences)
   - paraphrase the task
   - thesis statement / clear position when required
2. Body 1 (main idea 1 + development + example)
3. Body 2 (main idea 2 + development + example)
4. Conclusion (1-2 sentences)
   - restate position
   - optional final thought
```

This is a learning scaffold rather than an IELTS-mandated paragraph count; quality is scored through the public criteria.

### Critical requirements

| Requirement | Consequence | Error id |
|---|---|---|
| Position clear throughout when task requires one | major TR limitation | `W_tr_position_unclear` |
| Answer all parts | major TR limitation | `W_tr_task_missed_part` |
| Main ideas developed + supported | limits higher TR performance | `W_tr_idea_undeveloped` |
| Word count ≥ 250 | apply under-length handling according to evaluation policy | `W_tr_under_wordcount` |
| Logical paragraphing | CC is affected when organization is weak | `W_cc_no_paragraphing` |

### Task 2 criterion focus

- TR: position, idea development, addressing all parts
- CC: paragraph logic, cohesive range, progression
- LR: precision, collocation, paraphrase, less common vocabulary
- GRA: range and accuracy of complex structures

## Cross-cutting: word count rule

| Task | Minimum |
|---|---|
| Task 1 (Academic + GT) | 150 |
| Task 2 | 250 |

App behavior: flag `W_tr_under_wordcount` when a submission is under length. Product behavior may require confirmation or allow submission with a clear warning, but must not silently alter the learner's text.

## Cross-cutting: time management

| Task | Suggested time |
|---|---|
| Task 1 | 20 min |
| Task 2 | 40 min |

The learner controls allocation. `STUDY.Session` may default to these hints; Mock Test mode uses a total 60-minute timer rather than enforcing an internal split.

## Band descriptor reference

Criterion bands (TR/CC/LR/GRA) are defined in `band-descriptor-map.md`. This file defines task structure and requirements rather than duplicating descriptors.

## Examiner (`EVAL.Writing`) scoring depth

`EVAL.Writing` must output:

```yaml
evaluation:
  task_ref: ...
  task_type: W_task2_opinion
  word_count: 287
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
  overall_band: 6.0  # average of 4, rounded to nearest 0.5 (.25→.5, .75→up) per IELTS
  overall_confidence: 0.85
  quality_status: accepted
```

Requirements:
- Band per criterion + evidence from specific sentences/paragraphs.
- Overall = average of the four criteria, **rounded to the nearest IELTS half/whole band (.25→.5, .75→up)**. See `exam-module-differences.md` for the complete conversion rule.
- Issue list uses `error_id` from `error-taxonomy.md` + `evidence_ref`.
- Do not guess; insufficient evidence → `insufficient_evidence`.

## Usage

- `LEARN.Writing` practice: learner selects a task type → workspace.
- `EVAL.Writing` scores according to the schema above.
- `BAND.Map` writing row: readiness by task type (✓/⚠/✗) + criterion.
- `REVIEW.MistakeNotebook`: error → review card via `review-mapping.md`.

## Versioning

- Current release: `1.0.6`; the frontmatter is authoritative for the file version.
- `version: 1.0.1` — reconciled Academic Task 1 IDs and enumerated Task 2 types.
- `version: 1.0.6` — normalized the per-file release record; task types and evaluation rules are unchanged.
- Adding a task subtype: minor.
- Changing a structure requirement: patch + note.

## Do not infer

- Task type must belong to the enum listed above (`W_ac_task1_chart`, `W_gt_task1_formal_letter`, `W_gt_task1_semi_formal_letter`, `W_gt_task1_informal_letter`, or one of the five Task 2 IDs); grouped notation is not a valid enum value.
- Critical task requirements such as a Task 1 overview and answering all Task 2 parts must not be relaxed by an agent.
- Scoring behavior comes from the official/public descriptor framework and configured evaluation contract; agents must not invent new band caps.
