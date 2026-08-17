---
version: 1.0.7
scope: framework
---

# Exam Module Differences (Academic vs General Training) + Score Conversion

Status: `framework` — defines Academic vs General Training differences, answer normalization, and the authority boundary for Listening/Reading raw-score conversion. Feeds `PRACTICE.MockTest`, `BAND.ExamReadiness`, and `LEARN.Path` module routing.

Authority:
- Test format and published score anchors are **official-derived** from IELTS.org.
- Exact per-form raw-score boundaries are **not** invented by this framework. They must come from a versioned, reviewed score-conversion source.
- If a configured conversion conflicts with current official IELTS guidance, the official source wins and the configuration must be reviewed.

## Academic vs General Training — differences

IELTS has two modules: **Academic** and **General Training**. Reading and Writing differ; Listening and Speaking use the same test format for both modules.

| Skill | Academic | General Training |
|---|---|---|
| Listening | **Same format**: four parts, 40 questions | Same as Academic |
| Reading | Three sections using texts drawn from books, journals, magazines, newspapers, and online resources for a non-specialist audience | Three sections progressing from everyday material to workplace material and a longer general-interest text |
| Writing | Task 1 describes visual information; Task 2 responds to a point of view, argument, or problem | Task 1 is a letter; Task 2 responds to a point of view, argument, or problem |
| Speaking | **Same** three-part interview | Same as Academic |

The learner selects a module during setup. `GOAL.Target` must contain `exam_module: academic | general_training`. Learning paths and content routing depend on this field.

## Module routing rule

| Capability | Academic | General Training |
|---|---|---|
| `LEARN.Reading` | Academic Reading source style and task mix | General Training Reading source style and task mix |
| `LEARN.Writing` Task 1 | visual-information response | letter |
| `LEARN.Writing` Task 2 | Academic Task 2 | General Training Task 2 |
| `PRACTICE.MockTest` | full Academic | full General Training |
| `KA.Vocabulary` | curriculum may emphasize academic-register vocabulary | curriculum may emphasize everyday/workplace vocabulary where appropriate |

A learner does not mix modules within one mock-test attempt. Product policy may require re-placement or a new diagnostic when a learner changes module; that policy is LenBands-specific, not an IELTS rule.

## Listening/Reading — raw score → band authority

Listening and Reading each contain 40 questions and award one mark for each correct answer. IELTS converts raw marks to whole/half band scores. IELTS explicitly states that the precise number of marks needed can vary slightly from one test version to another.

### Official published average anchors

These are the **average marks published by IELTS.org**, not complete half-band conversion tables:

| Skill/module | Band | Average marks out of 40 |
|---|---:|---:|
| Listening | 5 | 16 |
| Listening | 6 | 23 |
| Listening | 7 | 30 |
| Listening | 8 | 35 |
| Academic Reading | 5 | 15 |
| Academic Reading | 6 | 23 |
| Academic Reading | 7 | 30 |
| Academic Reading | 8 | 35 |
| General Training Reading | 4 | 15 |
| General Training Reading | 5 | 23 |
| General Training Reading | 6 | 30 |
| General Training Reading | 7 | 35 |

The framework **must not interpolate or invent** missing half-band cut-offs from these anchors.

### Runtime conversion contract

A scored mock must reference an explicit, reviewed conversion version:

```yaml
score_conversion:
  source: ielts_public_or_calibrated_table
  source_ref: <immutable-source-or-reviewed-config-ref>
  version: <version>
  module: listening | academic_reading | general_training_reading
  status: approved
```

Rules:
- `PRACTICE.MockTest` may calculate a Listening/Reading band only when an approved conversion version covering the raw score is available.
- The result stores `raw_score`, `conversion_version`, and `conversion_source_ref` for auditability.
- If no approved conversion covers the score, return `conversion_unavailable`; do **not** guess or interpolate a band.
- The official average anchors above are suitable for sanity checks, not sufficient by themselves to define every half-band boundary.

## Answer normalization rules (Listening/Reading)

Answer-key matching may normalize mechanically equivalent representations before comparison, but normalization must never turn a semantically different answer into a correct one.

| Rule | Description |
|---|---|
| Case normalization | compare case-insensitively when case is not part of the answer construct |
| Trim whitespace | remove accidental leading/trailing whitespace |
| Alternative accepted answer | accept only alternatives explicitly registered in the question key |
| Spelling variant | accept British/American variants only when the reviewed key permits them |
| Number/date formatting | normalize mechanically equivalent formats only when the reviewed key permits them |
| Word limit | enforce the wording of the question instruction; an answer exceeding the stated limit is wrong |
| Hyphenation | treat variants as equivalent only when the reviewed key explicitly permits it |

Do not apply global rules such as "articles are always optional" or "plural is always lenient". Those decisions belong to the reviewed answer key for the specific item.

### Number/date/phone/currency normalization

Listening items may register controlled normalization for mechanically equivalent forms:

| Type | Example of configurable equivalence |
|---|---|
| Date | `15 March` / `March 15` when both are accepted by the reviewed key |
| Phone | spaces or hyphens may be ignored when they do not change the digits |
| Currency | symbol/word form may be normalized only when the reviewed key permits it |
| Decimal | numeric and spoken-number forms may be mapped when explicitly configured |
| Time | equivalent clock formats may be mapped when explicitly configured |
| Quantity + unit | unit omission is accepted only when the item asks for the number alone |

Example key configuration:

```yaml
correct_answer:
  values: ["15 March", "March 15"]
  normalize: [lowercase, trim, date_flexible]
word_limit: 2
```

Listening-specific errors:

| error_id | Description |
|---|---|
| `L_ans_number_format` | Format does not match an accepted normalized representation |
| `L_ans_unit_missing` | A required unit is missing |

## Overall band calculation

IELTS overall band is the average of the four section band scores. If the average ends in `.25`, it is rounded up to the next half band; if it ends in `.75`, it is rounded up to the next whole band. Other averages are reported to the nearest whole or half band according to IELTS rules.

Examples:
- L6.5 R6.0 W6.0 S6.5 → average 6.25 → overall **6.5**.
- L6.5 R6.5 W6.5 S6.5 → average 6.5 → overall **6.5**.
- L7.0 R7.0 W6.5 S6.5 → average 6.75 → overall **7.0**.

## Mock test scoring (`PRACTICE.MockTest`)

- Listening/Reading: raw score from the answer key, then an **approved versioned conversion table**.
- Writing: criterion scoring for both tasks, with Task 2 carrying twice the weight of Task 1 in the Writing section score.
- Speaking: four equally weighted criteria.
- Overall IELTS band: calculated from the four section bands using the official rounding rule.
- Audit output: per-skill band, overall band, L/R raw score + conversion version, and W/S criterion evidence.

## IELTS ↔ CEFR guardrails

IELTS and CEFR do **not** align at exact transition points. Do not assign a precise CEFR level to every IELTS half band as if the scales were interchangeable.

Current public IELTS guidance states, in particular:
- the minimum C1 threshold falls **between IELTS 6.5 and 7.0**;
- IELTS **8.5 and above** is recognized as C2, while band 8 is borderline.

Any finer CEFR crosswalk used by LenBands must carry its own research/provenance and must be presented as an approximation, not an official one-to-one conversion.

## Official references

- IELTS scoring in detail: `https://ielts.org/take-a-test/your-results/ielts-scoring-in-detail`
- IELTS and the CEFR: `https://ielts.org/organisations/ielts-for-organisations/compare-ielts/ielts-and-the-cefr`
- Academic test format: `https://ielts.org/organisations/ielts-for-organisations/test-types/ielts-academic-test/academic-test-format-in-detail`
- General Training test format: `https://ielts.org/organisations/ielts-for-organisations/test-types/ielts-general-training-test/general-training-test-format-in-detail`

## Usage

- `GOAL.Target` contains `exam_module` and determines path direction.
- `LEARN.Path` routes content by module.
- `PRACTICE.MockTest` selects the module and records the approved score-conversion version.
- `BAND.ExamReadiness` consumes scored evidence; it must not manufacture missing conversions.
- `EVAL.Writing` reads Academic vs General Training task type and applies the appropriate task contract.

## Versioning

- Current release: `1.0.7`; the frontmatter is authoritative for the file version.
- `version: 1.0.1` — reconciled answer-normalization error references.
- `version: 1.0.6` — normalized the per-file release record; module and score rules were unchanged.
- `version: 1.0.7` — replaced incorrect inferred raw-score ranges with current IELTS.org average anchors, made exact half-band conversion fail-closed and versioned, tightened answer-normalization authority, and corrected CEFR claims.
- A correction to an official-derived fact requires a patch bump plus source review.
- Adding a new product-supported IELTS test type requires an explicit scope decision rather than agent inference.

## Do not infer

- Do not infer a half-band conversion from neighboring official anchor points.
- Do not present a LenBands score table as an official IELTS per-form curve.
- Do not convert IELTS to CEFR one-to-one without an explicitly sourced crosswalk.
- Module values supported by this contract are `academic` and `general_training`; additional IELTS products require an explicit product decision.
- Unknown answer-normalization behavior must return `unknown_normalization` rather than silently accepting an answer.