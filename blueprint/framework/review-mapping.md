---
version: 1.0.6
scope: framework
---

# Review Mapping (error type → review rule × skill)

Status: `framework` — maps errors from `error-taxonomy.md` to **review rules**: what to review, initial frequency, and FSRS mapping. Feeds `REVIEW.SmartQueue`, `REVIEW.MistakeNotebook`, and `REVIEW.FSRS` card sources.

Conventions:
- Every error has a `review_type` (what kind of content to review), `fsrs_card_kind` (card kind), and `frequency_hint` (initial frequency suggestion).
- `frequency_hint` is only a starting suggestion; FSRS adjusts scheduling after ratings.
- Every review card has an `evidence_ref` pointing to its source error; orphan cards are prohibited.

## Review card kinds (`fsrs_card_kind`)

| kind | Description | Example |
|---|---|---|
| `recall_meaning` | Recall the meaning of a word/collocation | "ephemeral = ?" |
| `recall_form` | Recall word form/spelling | "success → adj = ?" |
| `recall_grammar_rule` | Recall a grammar rule | "inversion after a negative adverb: ?" |
| `apply_distractor` | Apply distractor rejection | "[passage + stem + 2 options] identify the trap" |
| `apply_paraphrase` | Apply paraphrase recognition | "[passage + question] what paraphrases X?" |
| `apply_grammar_correct` | Correct a grammar error in a sentence | "[incorrect sentence] correct it" |
| `apply_structure` | Apply a Writing/Speaking structure | "[topic] write a topic sentence + cohesion" |
| `retest_question_type` | Retest the same question type/micro-skill | one new Reading Matching Headings item |

## Listening — error → review mapping

| error_id | review_type | fsrs_card_kind | frequency_hint | note |
|---|---|---|---|---|
| `L_ans_distractor_lexical` | practice distractor rejection | `apply_distractor` | 2 days → 7 → 21 | same question_type |
| `L_ans_distractor_number` | practice numerical traps | `apply_distractor` | 2 → 7 | numbers |
| `L_ans_paraphrase_missed` | practice paraphrase recognition | `apply_paraphrase` | 2 → 7 → 21 | linked to `L_paraphrase_recognition` |
| `L_spelling_error` | review spelling of the word | `recall_form` | 1 → 3 → 7 → 21 | word_id |
| `L_word_boundary` | listen again to minimal pair/boundary | `recall_meaning` | 3 → 7 | audio ref |
| `L_abstract_inference_missed` | practice inference | `retest_question_type` | 7 → 21 | new item |

## Reading — error → review mapping

| error_id | review_type | fsrs_card_kind | frequency_hint | note |
|---|---|---|---|---|
| `R_ans_paraphrase_missed` | practice paraphrase | `apply_paraphrase` | 2 → 7 → 21 | `R_paraphrase_recognition` |
| `R_ans_distractor_lexical` | practice trap rejection | `apply_distractor` | 2 → 7 | same question_type |
| `R_tfng_false_vs_notgiven` | practice F vs NG distinction | `retest_question_type` | 2 → 7 → 21 | new item, important boundary |
| `R_tfng_writer_vs_fact` | practice yes/no vs T/F distinction | `retest_question_type` | 3 → 7 | — |
| `R_heading_wrong_main_idea` | practice main-idea identification | `retest_question_type` | 3 → 7 → 21 | same matching_headings type |
| `R_completion_word_form` | practice word form | `recall_form` | 2 → 7 | word_id |
| `R_reference_misread` | practice reference resolution | `apply_paraphrase` | 3 → 7 | — |
| `R_ans_wrong_passage_loc` | practice local vs global location | `retest_question_type` | 7 → 21 | — |

## Writing — error → review mapping

| error_id | review_type | fsrs_card_kind | frequency_hint | note |
|---|---|---|---|---|
| `W_tr_task_missed_part` | practice task analysis | `apply_structure` | 3 → 7 → 21 | rewrite outline |
| `W_tr_position_unclear` | practice position statement | `apply_structure` | 3 → 7 | thesis writing |
| `W_tr_idea_undeveloped` | practice idea + support | `apply_structure` | 3 → 7 → 21 | extend-idea drill |
| `W_cc_mechanical_cohesive` | practice cohesive range | `recall_grammar_rule` + rewrite | 3 → 7 | connector list |
| `W_cc_topic_sentence_unclear` | practice topic sentence | `apply_structure` | 2 → 7 | — |
| `W_lr_wrong_collocation` | recall collocation | `recall_meaning` | 1 → 3 → 7 → 21 | collocation_id |
| `W_lr_repetitive` | practice synonym replacement | `recall_meaning` | 2 → 7 | word family |
| `W_gra_complex_with_error` | correct grammar error | `apply_grammar_correct` | 1 → 3 → 7 | source sentence |
| `W_gra_tense` | recall tense rule | `recall_grammar_rule` | 1 → 3 → 7 | — |
| `W_gra_article` | practice articles | `apply_grammar_correct` | 2 → 7 | — |
| `W_gra_relative_clause` | practice relative clauses | `apply_grammar_correct` + rule | 2 → 7 → 21 | — |
| `W_gra_punctuation` | correct punctuation | `apply_grammar_correct` | 3 → 7 | comma splice |
| `W_t1_no_overview` | practice overview | `apply_structure` | 3 → 7 | new dataset |
| `W_t1_detail_dump` | practice data selection | `apply_structure` | 3 → 7 | new chart |
| `W_letter_wrong_tone` | practice tone/register | `apply_structure` | 7 → 21 | new letter |

## Speaking — error → review mapping

Speaking is special: review cards often include **audio self-recording** so the learner can listen back to their own speech.

| error_id | review_type | fsrs_card_kind | frequency_hint | note |
|---|---|---|---|---|
| `S_fc_short_answer` | practice answer extension | `apply_structure` | 2 → 7 | new prompt, record |
| `S_fc_long_pause` | practice sustained speech | `retest_question_type` | 3 → 7 | new cue card |
| `S_fc_part3_no_develop` | practice defending/developing ideas | `apply_structure` | 7 → 21 | abstract topic |
| `S_lr_limited_paraphrase` | practice spontaneous paraphrase | `apply_paraphrase` | 3 → 7 | word prompt |
| `S_gra_only_simple` | practice complex spoken grammar | `apply_grammar_correct` (oral) | 7 → 21 | record |
| `S_pr_phoneme` | practice phoneme | `recall_meaning` + drill | 1 → 3 → 7 → 21 | model audio + record |
| `S_pr_word_stress` | practice word stress | `recall_form` + drill | 1 → 3 → 7 | word list |
| `S_pr_intonation_flat` | practice intonation | `retest_question_type` (shadowing) | 7 → 21 | model audio shadowing |

## Strategy errors — review mapping

| error_id | review_type | fsrs_card_kind | frequency_hint |
|---|---|---|---|
| `X_time_management` | practice pacing with timer | `retest_question_type` | 7 → 21 |
| `X_instruction_misread` | practice reading instructions | `recall_grammar_rule` | 7 |
| `X_answer_transfer_wrong` | practice answer-sheet transfer | `retest_question_type` | 21 |

## FSRS card source rules

Every review card must contain:
- `source_error_id` from error-taxonomy
- `evidence_ref` pointing to the original question/passage/audio
- `micro_skill_ref` from microskill-enum when available
- `fsrs_card_kind` from the table above
- `frequency_hint` as the initial suggestion; FSRS overrides it after the first rating

Orphan cards without a source must not be created; this supports anti-gaming and preserves review quality.

## Cross-link

- A `BAND.Map` ⚠/✗ item → click → opens a review card for the same micro-skill when an error exists, or opens a drill when no error exists and the learner only needs learning/practice.
- `COACH.ErrorAnalysis` outputs a list of error IDs → the system can generate review cards from this mapping, subject to learner confirmation/rejection where required.
- `REVIEW.SmartQueue` groups cards by `micro_skill_ref` to create a weak-skill queue.

## Versioning

- Current release: `1.0.6`; the frontmatter is authoritative for the file version.
- `version: 1.0.1` — reconciled error-to-microskill references.
- `version: 1.0.6` — normalized the per-file release record; review mappings are unchanged.
- Adding a mapping: minor; changing frequency: patch; removing a mapping: `deprecated_in`.

## Do not infer

If an error has no mapping, do not invent an `fsrs_card_kind`. Report `unknown_review_mapping` and flag Colab. Creating an orphan review card violates the contract.
