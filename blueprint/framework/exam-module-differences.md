---
version: 1.0.6
scope: framework
---

# Exam Module Differences (Academic vs General Training) + Score Conversion

Status: `framework` — defines Academic vs General Training differences and raw-score-to-band conversion for Listening/Reading. Feeds `PRACTICE.MockTest`, `BAND.ExamReadiness`, and `LEARN.Path` module routing.

## Academic vs General Training — differences

IELTS has two modules: **Academic** for higher education/professional registration and **General Training** for migration/work contexts. They differ in Reading and Writing; Listening and Speaking are shared:

| Skill | Academic | General Training |
|---|---|---|
| Listening | **Same**: four sections and shared format | Same as Academic |
| Reading | Three longer, more scholarly passages from magazines, books, journals, etc. | Three sections: Section 1 has short everyday texts, Section 2 workplace texts, Section 3 one longer general-interest text |
| Writing | Task 1: describe chart/table/process/map/diagram. Task 2: essay | Task 1: letter (formal/semi-formal/informal). Task 2: essay with generally more everyday context |
| Speaking | **Same** | Same as Academic |

The learner selects a module during setup. `GOAL.Target` must contain `exam_module: academic | general_training`. Learning paths and content routing depend on this field.

## Module routing rule

| Capability | Academic | General Training |
|---|---|---|
| `LEARN.Reading` | scholarly passages, academic vocabulary | everyday/workplace passages |
| `LEARN.Writing` Task 1 | chart/table/process/map/diagram | letter (3 registers) |
| `LEARN.Writing` Task 2 | more academic/general-public topics such as education, technology, science | more everyday topics such as family, work, community |
| `PRACTICE.MockTest` | full Academic | full GT |
| `KA.Vocabulary` | academic emphasis across all 10 topics | all 10 topics with stronger everyday emphasis |

A learner does not mix modules within one path. A rare module switch triggers re-placement according to policy.

## Listening/Reading — raw score → band conversion

Listening and Reading use objective answer keys. Band is derived from raw score through a **conversion table**. Exact boundaries can vary slightly between test forms, so the table below is a default benchmark rather than an immutable official per-form curve.

### Listening (40 questions) → band

| Band | Raw score range (approx) |
|---|---|
| 4.0 | 6-9 |
| 4.5 | 10-11 |
| 5.0 | 12-15 |
| 5.5 | 16-18 |
| 6.0 | 19-22 |
| 6.5 | 23-25 |
| 7.0 | 26-29 |
| 7.5 | 30-31 |
| 8.0 | 32-34 |
| 8.5 | 35-36 |
| 9.0 | 37-40 |

### Reading Academic (40 questions) → band

| Band | Raw score range (approx) |
|---|---|
| 4.0 | 4-5 |
| 4.5 | 6-7 |
| 5.0 | 8-11 |
| 5.5 | 12-13 |
| 6.0 | 14-18 |
| 6.5 | 19-22 |
| 7.0 | 23-25 |
| 7.5 | 26-28 |
| 8.0 | 29-31 |
| 8.5 | 32-33 |
| 9.0 | 34-40 |

### Reading General Training (40 questions) → band

GT Reading generally requires more correct answers for the same band because the source texts are less academically demanding.

| Band | Raw score range (approx) |
|---|---|
| 4.0 | 6-8 |
| 4.5 | 9-11 |
| 5.0 | 12-14 |
| 5.5 | 15-18 |
| 6.0 | 19-22 |
| 6.5 | 23-25 |
| 7.0 | 26-29 |
| 7.5 | 30-31 |
| 8.0 | 32-33 |
| 8.5 | 34-35 |
| 9.0 | 36-40 |

Note: these are benchmark approximations based on common published patterns. A real test-form conversion may differ slightly.

## Answer normalization rules (Listening/Reading)

Answer-key matching normalizes input before comparison:

| Rule | Description |
|---|---|
| Case-insensitive | "Paris" = "paris" = "PARIS" |
| Trim whitespace | " Paris " = "Paris" |
| Article optional (if allowed) | "a book" = "book" when configured for that question |
| Plural sensitivity | strict (book ≠ books) or lenient according to key/instruction |
| Alternative spelling | British vs American spelling such as colour/color according to key config |
| Number format | "1,000" = "1000" = "one thousand" when the key permits it |
| Word limit | instruction "NO MORE THAN TWO WORDS" → an answer over two words is wrong |
| Hyphenation | "well-known" = "well known" when the key permits it; default yes |

### Number/date/phone/currency normalization (Listening depth)

Listening contains many number formats that need dedicated normalization because learners hear the value and then write it:

| Type | Rule | Example |
|---|---|---|
| Date | accept multiple configured formats: DD/MM/YYYY, DD Month YYYY, Month DD | "5 March 2024" = "05/03/2024" = "March 5, 2024" |
| Phone | accept spaces/dashes; leading 0 optional according to key | "020 7946 0958" = "0207-946-0958" |
| Currency | symbol (£/$/€) optional if key does not require it; word forms may be accepted according to key config | "£15.50" = "15.50" when key is lenient |
| Decimal | "0.5" = "point five" = "nought point five" | — |
| Time | "9.30" = "9:30" = "half past nine" according to key | — |
| Age | "18-year-old" = "18 years old" = "18" according to key | — |
| Quantity + unit | "2 kilograms" = "2 kilos" = "2 kg" = "2" when key requires only the number | — |
| Ordinal | "3rd" = "third" = "3" according to key | — |

Key configuration determines strict/lenient behavior:
```yaml
correct_answer:
  - value: "15 March"
  - value: "March 15"
  - value: "15th March"
  normalize: [lowercase, trim, date_flexible]
```

Listening-specific errors:
| error_id | Description |
|---|---|
| `L_ans_number_format` | Wrong number/date/phone/currency format despite hearing the value correctly |
| `L_ans_unit_missing` | Required unit such as kg/pounds is missing |

Key structure inside a `question_id` asset:

```yaml
question_id: R_q_482
correct_answer:
  - value: "environment"
  - value: "the environment"
  - value: "environments"
  - rule: lenient_plural
  - normalize: [lowercase, trim]
word_limit: 2
explanation_ref: ...
```

## Overall band calculation (IELTS rule)

Overall band = **average of the four skill bands**, rounded to the nearest half/whole band according to IELTS rounding rules: .25 → .5 and .75 → next whole.

| Average | Overall band |
|---|---|
| x.00-x.24 | x.0 |
| x.25-x.74 | x.5 |
| x.75-x.99 | (x+1).0 |

Example: L6.5 R6.0 W6.0 S6.5 → average 6.25 → overall **6.5**.

## Mock test scoring (`PRACTICE.MockTest`)

- Listening/Reading: auto-score through answer key + conversion table.
- Writing/Speaking: score through `EVAL.Writing`/`EVAL.Speaking` + descriptors.
- Overall: calculate using the rule above.
- Output: per-skill band + overall + L/R raw score + W/S criterion bands.

## Band vs CEFR cross-reference

IELTS band does not map 1:1 to CEFR, but an approximate cross-reference is useful:

| IELTS Band | CEFR approx |
|---|---|
| 4.0 | A2+ |
| 4.5-5.0 | B1 |
| 5.5-6.0 | B1+ / B2 |
| 6.5-7.0 | B2 / B2+ |
| 7.5-8.0 | C1 |
| 8.5-9.0 | C1+ / C2 |

Use this only as a cross-reference for the vocabulary `cefr` field, not as a replacement for IELTS band.

## Usage

- `GOAL.Target` contains `exam_module` and determines path direction.
- `LEARN.Path` routes content by module.
- `PRACTICE.MockTest` selects the module and scores through conversion + descriptors.
- `BAND.ExamReadiness` calculates overall using IELTS rules.
- `EVAL.Writing` reads Academic vs GT task type and applies the appropriate task structure.

## Versioning

- Current release: `1.0.6`; the frontmatter is authoritative for the file version.
- `version: 1.0.1` — reconciled answer-normalization error references.
- `version: 1.0.6` — normalized the per-file release record; module and score rules are unchanged.
- Update conversion tables when authoritative/public benchmark patterns change: patch + note.
- Adding a new module such as Life Skills, currently out of scope: minor.

## Do not infer

- Conversion must follow this registered framework/default source; do not invent a mapping such as "L 30 = band 7.5" outside the configured table.
- Module must be `academic` or `general_training`; do not invent another module.
- Answer normalization follows the rules above; an unknown key rule must report `unknown_normalization`.
