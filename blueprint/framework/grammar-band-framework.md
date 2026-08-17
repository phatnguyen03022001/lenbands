---
version: 1.0.7
scope: framework
---

# Grammar × Band Framework

Status: `framework` — LenBands-controlled grammar curriculum. It provides stable `grammar_id` values, instructional sequencing, and heuristic band labels for content routing. It feeds `KA.Grammar`, curriculum views in `BAND.Map`, and FSRS grammar-card sources.

Authority:
- Grammar IDs, dependency edges, completion rules, and curriculum ordering are `lenbands-controlled`.
- `band_introduce` and `band_master` are `experimental-heuristic` curriculum labels. IELTS does **not** publish a checklist saying a particular named grammar structure is required at a particular band.
- These band fields must not be presented as official IELTS requirements or used as the sole basis for a predicted/awarded band.
- Writing/Speaking grammar scores come from the official-derived Grammatical Range & Accuracy descriptors and observed performance, not completion of this inventory.

Conventions:
- `grammar_id` is snake_case and versioned.
- `band_introduce` is the LenBands curriculum point where instruction may begin emphasizing the structure.
- `band_master` is the LenBands curriculum target where stronger independent control is expected.
- `error_refs` contains related error-taxonomy IDs, not prerequisites.
- This is a selective teaching inventory, not a claim to enumerate all English grammar or all grammatical evidence relevant to IELTS.

## Node schema

A complete grammar node owns its relationships, completion conditions, and learner-facing statement inline. Global graph/index views are generated projections, not SSOT.

```yaml
grammar_id: g_second_conditional
name: Second Conditional
band_introduce: 6.0       # LenBands curriculum heuristic, not official IELTS threshold
band_master: 7.0          # LenBands curriculum heuristic, not official IELTS threshold
error_refs: [W_gra_complex_with_error]
can_statement: "Learner can form and use second conditional to talk about hypothetical present/future situations accurately in writing and speaking."
depends_on:
  - id: g_zero_first_conditional
    strength: hard_prerequisite
    source: colab_curated
  - id: g_past_simple
    strength: hard_prerequisite
    source: colab_curated
done_when:
  accuracy_pct: 90
  consecutive_sessions: 3
  no_review_regression_days: 30
  evidence_source: [practice, writing_eval, speaking_eval]
unlocks:
  - g_mixed_conditionals
```

Field rules:
- `depends_on`: teaching prerequisite asserted by an approved provenance source. Missing provenance → `needs_review`.
- `unlocks`: forward projection; may be generated from prerequisites.
- `strength`: `hard_prerequisite | recommended | soft` is a LenBands instructional relation, not an IELTS scoring relation.
- `source`: provenance for the edge. Do not label an edge `cambridge_syllabus` or `efl_research` without a concrete source reference in the governed asset/metadata layer.
- `done_when`: internal mastery condition for curriculum review. It does not prove an IELTS band.
- `can_statement`: learner-facing skill statement.

## Curriculum bucket 4.0–5.0 — Foundation heuristic

| grammar_id | Grammar point | band_introduce | band_master | error_refs | done_when (summary) |
|---|---|---|---|---|---|
| `g_present_simple` | Present simple | 4.0 | 5.0 | — | acc≥90%, 3 sessions, 30d no relapse |
| `g_present_continuous` | Present continuous | 4.0 | 5.0 | — | acc≥90%, 3 sessions |
| `g_past_simple` | Past simple | 4.0 | 5.0 | — | acc≥90%, 3 sessions |
| `g_past_continuous` | Past continuous | 4.5 | 5.5 | — | |
| `g_present_perfect` | Present perfect vs past simple | 5.0 | 6.0 | `W_gra_tense` | |
| `g_future_will_going` | Will vs going to | 4.5 | 5.5 | — | |
| `g_subject_verb_agreement` | Subject-verb agreement | 4.5 | 5.5 | `W_gra_subject_verb` | |
| `g_articles_basic` | Basic a/an/the | 4.5 | 6.0 | `W_gra_article` | |
| `g_plural_nouns` | Plural nouns + irregular forms | 4.0 | 5.0 | — | |
| `g_basic_conjunctions` | and/but/because/so | 4.0 | 5.0 | — | |
| `g_modals_basic` | can/could/must/should | 4.5 | 5.5 | — | |

Example instructional prerequisites:

| grammar_id | depends_on | strength |
|---|---|---|
| `g_present_continuous` | `g_present_simple` | hard_prerequisite |
| `g_past_simple` | `g_present_simple` | hard_prerequisite |

## Curriculum bucket 5.0–6.0 — Developing heuristic

| grammar_id | Grammar point | band_introduce | band_master | error_refs |
|---|---|---|---|---|
| `g_present_perfect_continuous` | Present perfect continuous | 5.5 | 6.5 | `W_gra_tense` |
| `g_past_perfect` | Past perfect | 5.5 | 6.5 | — |
| `g_zero_first_conditional` | Zero + first conditional | 5.5 | 6.5 | `W_gra_complex_with_error` |
| `g_second_conditional` | Second conditional | 6.0 | 7.0 | — |
| `g_passive_voice` | Passive voice (present/past) | 5.5 | 6.5 | `W_gra_complex_with_error` |
| `g_relative_clauses_defining` | Defining relative clauses | 5.5 | 6.5 | `W_gra_relative_clause` |
| `g_relative_clauses_non_defining` | Non-defining relative clauses | 6.0 | 7.0 | — |
| `g_gerund_infinitive` | Gerund vs infinitive after verbs | 5.5 | 6.5 | — |
| `g_comparatives_superlatives` | Comparative + superlative forms | 5.0 | 6.0 | — |
| `g_quantifiers` | some/any/much/many/few/a few | 5.0 | 6.0 | — |
| `g_countable_uncountable` | Countable vs uncountable | 5.0 | 6.0 | — |
| `g_used_to` | used to / be used to / get used to | 5.5 | 6.5 | — |
| `g_reported_speech` | Reported speech + backshift | 5.5 | 6.5 | — |
| `g_question_tags` | Question tags | 5.5 | 6.5 | — |
| `g_articles_advanced` | Advanced article reference | 6.0 | 7.0 | `W_gra_article` |

## Curriculum bucket 6.0–7.0 — Upper-intermediate heuristic

| grammar_id | Grammar point | band_introduce | band_master | error_refs |
|---|---|---|---|---|
| `g_third_conditional` | Third conditional | 6.5 | 7.5 | `W_gra_complex_with_error` |
| `g_mixed_conditionals` | Mixed conditionals | 7.0 | 8.0 | — |
| `g_wish_if_only` | wish + past/past perfect; if only | 6.5 | 7.5 | — |
| `g_passive_advanced` | Passive with modals/reporting verbs | 6.5 | 7.5 | — |
| `g_relative_clause_reduced` | Reduced relative clauses | 7.0 | 8.0 | — |
| `g_participle_clauses` | Participle clauses | 7.0 | 8.0 | `W_gra_complex_with_error` |
| `g_inversion` | Inversion after negative/restrictive adverbs | 7.0 | 8.0 | `W_gra_complex_with_error` |
| `g_cleft_sentences` | Cleft sentences | 7.0 | 8.0 | — |
| `g_modal_perfect` | Modal + perfect | 6.5 | 7.5 | — |
| `g_subordinate_clauses` | Concession/purpose/result clauses | 6.5 | 7.5 | — |
| `g_emphatic_do_did` | Emphatic do/did | 6.5 | 7.5 | — |
| `g_noun_clauses` | Noun clauses | 6.5 | 7.5 | — |
| `g_indirect_questions` | Indirect-question word order | 6.5 | 7.5 | — |
| `g_punctuation_advanced` | Semicolon, colon, dash, parallel structure | 6.5 | 7.5 | `W_gra_punctuation` |

## Curriculum bucket 7.5–9.0 — Advanced heuristic

| grammar_id | Grammar point | band_introduce | band_master | error_refs |
|---|---|---|---|---|
| `g_inversion_conditional` | Inversion in conditionals | 7.5 | 8.5 | — |
| `g_emphatic_inversion` | Emphatic inversion | 8.0 | 9.0 | — |
| `g_elliptical_clauses` | Ellipsis | 8.0 | 9.0 | — |
| `g_nominalization` | Nominalization | 7.5 | 8.5 | — |
| `g_subjunctive` | Subjunctive | 8.0 | 9.0 | — |
| `g_complex_parallelism` | Parallelism in long sentences | 7.5 | 8.5 | — |
| `g_fronting` | Fronting for emphasis | 8.0 | 9.0 | — |

## Inventory count

The controlled inventory currently contains 47 grammar IDs. Counts by curriculum bucket are useful for authoring coverage only. They are **not** minimum grammar counts required by IELTS and must not appear learner-facing as "master N structures to reach Band X".

## Example dependency chains

```text
Tense chain:
  g_present_simple ─hard─▶ g_past_simple ─hard─▶ g_present_perfect ─hard─▶ g_past_perfect

Conditional chain:
  g_zero_first_conditional ─hard─▶ g_second_conditional ─hard─▶ g_third_conditional ─hard─▶ g_mixed_conditionals

Relative clause chain:
  g_relative_clauses_defining ─hard─▶ g_relative_clauses_non_defining ─recommended─▶ g_relative_clause_reduced ─recommended─▶ g_participle_clauses

Inversion cluster:
  g_inversion ─recommended─▶ g_inversion_conditional ─recommended─▶ g_emphatic_inversion
```

These are instructional paths. They do not mean IELTS examiners require a named structure before awarding a band.

## Usage

- `KA.Grammar`: lessons reference a controlled `grammar_id`.
- `BAND.Map`: may show **Grammar curriculum coverage** separately from IELTS band evidence. It must not convert inventory completion into an IELTS band.
- `BAND.Requirement`: must derive official band requirements from the Grammatical Range & Accuracy descriptors, not from a list of named grammar structures. This file may supply examples/drills only.
- `REVIEW.FSRS`: grammar cards may use `grammar_id` as source identity.
- `COACH.ErrorAnalysis`: observed grammar errors may map to `grammar_id` for remediation, while band impact remains holistic and evidence-based.

## Versioning

- Current release: `1.0.7`; the frontmatter is authoritative for the file version.
- `version: 1.0.1` — corrected inventory count/identifier and marked incomplete summary rows.
- `version: 1.0.2` — clarified `error_refs` versus prerequisite `depends_on`.
- `version: 1.0.4` — moved foundation prerequisites out of `error_refs` and removed a duplicate summary row.
- `version: 1.0.5` — corrected `g_participle_clauses.error_refs` to a taxonomy error ID.
- `version: 1.0.6` — normalized changelog order; grammar nodes were unchanged.
- `version: 1.0.7` — corrected authority: grammar-to-band mappings are explicitly LenBands curriculum heuristics, not official IELTS structure requirements, and inventory completion may not produce a band claim.
- Adding a grammar ID: minor bump + `added_in`.
- Changing a heuristic band label: patch + note and calibration review.
- Removal: deprecate rather than delete.

## Do not infer

- Do not claim IELTS requires a particular named grammar construction at a particular band unless the claim is directly supported by the official descriptor/evidence contract.
- Do not use completion of the 47-item inventory as a scoring formula.
- A grammar item outside this controlled inventory requires review before becoming a LenBands curriculum ID; its absence does not mean the structure is irrelevant to IELTS performance.
