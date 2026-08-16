---
version: 1.0.6
scope: framework
---

# Grammar × Band Framework

Status: `framework` — versioned controlled vocabulary of grammar points by band. Feeds `KA.Grammar`, the `BAND.Map` grammar row, `BAND.Requirement` grammar checklist, and FSRS `recall_grammar_rule` card sources.

Conventions:
- `grammar_id` is snake_case and versioned.
- Each point has `band_introduce` (band where use begins to matter), `band_master` (band where accurate/flexible use should be mastered), and `error_refs` (related error-taxonomy IDs, not micro-skills).
- Band ranges follow standard EFL/IELTS difficulty guidance; they are not hard rules, but answer the question **"should a learner at band X be able to use this yet?"**
- This does not list all English grammar; it includes only points that have **band-discriminating value** in IELTS.

## Node schema (each grammar point)

Each grammar point is a **self-contained node** that owns its relationships, completion conditions, and learner-facing statement inline. Global graph/index views are generated projections, not SSOT; see `framework/README.md`.

The band tables below are inventory summaries. Only nodes with complete `can_statement`, `depends_on`, `done_when`, and `error_refs` are spawn-ready; summary-only nodes must be marked `needs_review` by assets and must not be published as if learning outcomes were fully defined.

```yaml
grammar_id: g_second_conditional
name: Second Conditional
band_introduce: 6.0
band_master: 7.0
error_refs: [W_gra_complex_with_error]
can_statement: "Learner can form and use second conditional to talk about hypothetical present/future situations accurately in writing and speaking."
depends_on:
  - id: g_zero_first_conditional
    strength: hard_prerequisite      # hard_prerequisite | recommended | soft
    source: cambridge_syllabus       # cambridge_syllabus | efl_research | colab_curated
  - id: g_past_simple
    strength: hard_prerequisite
    source: cambridge_syllabus
done_when:
  accuracy_pct: 90                   # in practice/drill linked to this grammar_id
  consecutive_sessions: 3            # 3 consecutive sessions at target accuracy
  no_review_regression_days: 30      # no relapse for 30 days after FSRS rating Good
  evidence_source: [practice, writing_eval, speaking_eval]
unlocks:                             # forward nodes unlocked by this node; projection use
  - g_mixed_conditionals
```

Field conventions:
- `depends_on`: edges **into** prerequisites required by this node. Empty means no prerequisite.
- `unlocks`: forward edges **out** from this node. This is a projection and does not have to be manually authored.
- `strength`: `hard_prerequisite` means learning is blocked without it; `recommended` means it should be learned first; `soft` means weakly related.
- `source`: edge provenance and must NOT be inferred. `cambridge_syllabus` = Cambridge syllabus; `efl_research` = EFL research; `colab_curated` = Colab curated.
- `done_when`: conditions for ✓ in `BAND.Map` mastery. `accuracy_pct` + `consecutive_sessions` + `no_review_regression_days` are AND conditions.
- `can_statement`: learner-facing "Learner can ..." statement rather than a technical label.

## Band 4.0–5.0 — Foundation (required to enter band 5)

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
| `g_modals_basic` | can/could/must/should (ability, advice, obligation) | 4.5 | 5.5 | — | |

Dependency edges for the two foundation rows below are not taxonomy links:

| grammar_id | depends_on | strength |
|---|---|---|
| `g_present_continuous` | `g_present_simple` | hard_prerequisite |
| `g_past_simple` | `g_present_simple` | hard_prerequisite |

## Band 5.0–6.0 — Developing (required to enter band 6)

| grammar_id | Grammar point | band_introduce | band_master | error_refs |
|---|---|---|---|---|
| `g_present_perfect_continuous` | Present perfect continuous | 5.5 | 6.5 | `W_gra_tense` |
| `g_past_perfect` | Past perfect | 5.5 | 6.5 | — |
| `g_zero_first_conditional` | Zero + first conditional | 5.5 | 6.5 | `W_gra_complex_with_error` |
| `g_second_conditional` | Second conditional (hypothetical) | 6.0 | 7.0 | — |
| `g_passive_voice` | Passive voice (present/past) | 5.5 | 6.5 | `W_gra_complex_with_error` |
| `g_relative_clauses_defining` | Defining relative clauses (who/which/that) | 5.5 | 6.5 | `W_gra_relative_clause` |
| `g_relative_clauses_non_defining` | Non-defining relative clauses (comma + who/which) | 6.0 | 7.0 | — |
| `g_gerund_infinitive` | Gerund vs infinitive after verbs | 5.5 | 6.5 | — |
| `g_comparatives_superlatives` | Comparative + superlative forms | 5.0 | 6.0 | — |
| `g_quantifiers` | some/any/much/many/few/a few | 5.0 | 6.0 | — |
| `g_countable_uncountable` | Countable vs uncountable | 5.0 | 6.0 | — |
| `g_used_to` | used to / be used to / get used to | 5.5 | 6.5 | — |
| `g_reported_speech` | Reported speech + backshift | 5.5 | 6.5 | — |
| `g_question_tags` | Question tags | 5.5 | 6.5 | — |
| `g_articles_advanced` | The with unique/geographical/generic reference | 6.0 | 7.0 | `W_gra_article` |

## Band 6.0–7.0 — Target (required to enter band 7; most important discriminating range)

| grammar_id | Grammar point | band_introduce | band_master | error_refs |
|---|---|---|---|---|
| `g_third_conditional` | Third conditional (past unreal) | 6.5 | 7.5 | `W_gra_complex_with_error` |
| `g_mixed_conditionals` | Mixed conditionals | 7.0 | 8.0 | — |
| `g_wish_if_only` | wish + past/past perfect; if only | 6.5 | 7.5 | — |
| `g_passive_advanced` | Passive with modals/reporting verbs | 6.5 | 7.5 | — |
| `g_relative_clause_reduced` | Reduced relative clauses (participle) | 7.0 | 8.0 | — |
| `g_participle_clauses` | Participle clauses (-ing/-ed reduced) | 7.0 | 8.0 | `W_gra_complex_with_error` |
| `g_inversion` | Inversion after negative/restrictive adverbs | 7.0 | 8.0 | `W_gra_complex_with_error` |
| `g_cleft_sentences` | Cleft sentences (It is... that...) | 7.0 | 8.0 | — |
| `g_modal_perfect` | Modal + perfect (must have done, should have done) | 6.5 | 7.5 | — |
| `g_subordinate_clauses` | Concession (although/despite), purpose (so that), result (such) | 6.5 | 7.5 | — |
| `g_emphatic_do_did` | Emphatic do/did | 6.5 | 7.5 | — |
| `g_noun_clauses` | Noun clauses (that/whether) | 6.5 | 7.5 | — |
| `g_indirect_questions` | Indirect-question word order | 6.5 | 7.5 | — |
| `g_punctuation_advanced` | Semicolon, colon, dash, parallel structure | 6.5 | 7.5 | `W_gra_punctuation` |

## Band 7.5–9.0 — Advanced/Precision (required for band 8+)

| grammar_id | Grammar point | band_introduce | band_master | error_refs |
|---|---|---|---|---|
| `g_inversion_conditional` | Inversion in conditionals (Had I known...) | 7.5 | 8.5 | — |
| `g_emphatic_inversion` | Emphatic inversion (Not only did he...) | 8.0 | 9.0 | — |
| `g_elliptical_clauses` | Ellipsis (omitting words) | 8.0 | 9.0 | — |
| `g_nominalization` | Nominalization (academic style) | 7.5 | 8.5 | — |
| `g_subjunctive` | Subjunctive (suggest/recommend that he be) | 8.0 | 9.0 | — |
| `g_complex_parallelism` | Parallelism in long sentences | 7.5 | 8.5 | — |
| `g_fronting` | Fronting for emphasis (On the table was...) | 8.0 | 9.0 | — |

## Cumulative grammar-point count by target band (`BAND.Map` checklist)

| Band target | Grammar points to master (cumulative) |
|---|---|
| 5.0 | 11 (Foundation) |
| 7.0 | 40 (including Target; discriminating 6→7 range) |
| 8.0 | 47 (including Advanced) |
| 9.0 | 47 (all Advanced) |

These counts are **band-completion guidance**, not hard rules. `BAND.Map` displays each point as ✓/⚠/✗ using `band_master` plus real learner evidence.

## Important dependency chains (examples; full edges live inline in nodes)

```text
Tense chain:
  g_present_simple ─hard─▶ g_past_simple ─hard─▶ g_present_perfect ─hard─▶ g_past_perfect
                                  │                              │
                                  └─hard─▶ g_present_continuous  └─recommended─▶ g_present_perfect_continuous

Conditional chain:
  g_zero_first_conditional ─hard─▶ g_second_conditional ─hard─▶ g_third_conditional ─hard─▶ g_mixed_conditionals
                                                                          │
                                                                          └─recommended─▶ g_inversion_conditional

Relative clause chain:
  g_relative_clauses_defining ─hard─▶ g_relative_clauses_non_defining ─recommended─▶ g_relative_clause_reduced ─recommended─▶ g_participle_clauses

Passive chain:
  g_passive_voice ─recommended─▶ g_passive_advanced ─recommended─▶ (g_inversion — advanced)

Inversion cluster:
  g_inversion ─recommended─▶ g_inversion_conditional ─recommended─▶ g_emphatic_inversion
```

A `hard` edge means the next node should not be learned before the prerequisite. A `recommended` edge means prior learning is preferred but can be skipped at a cost.

## Usage

- `KA.Grammar` asset: every grammar lesson has a `grammar_id` from this framework + `band_master`.
- `BAND.Map` grammar row: list grammar points with `band_master <= target_band`, then mark ✓/⚠/✗ from evidence such as recent `REVIEW.MistakeNotebook` and `EVAL.Writing/Speaking` results.
- `BAND.Requirement` checklist: use these points to represent grammar required for band X.
- FSRS `recall_grammar_rule` card: source = `grammar_id` + rule.
- `COACH.ErrorAnalysis`: map grammar errors to `grammar_id`.

## Versioning

- Current release: `1.0.6`; the frontmatter is authoritative for the file version.
- `version: 1.0.1` — corrected inventory count/identifier and marked incomplete summary rows; no new grammar point added.
- `version: 1.0.2` — corrected the inventory column label so `error_refs` is not confused with `depends_on`.
- `version: 1.0.4` — moved foundation prerequisites out of `error_refs` and removed the duplicate 6.0 summary row; no new grammar node added.
- `version: 1.0.5` — corrected `g_participle_clauses.error_refs` to a taxonomy error id after semantic validator hardening; no new grammar node added.
- `version: 1.0.6` — normalized the changelog order; grammar nodes and band mappings are unchanged.
- Addition: minor bump + `added_in`.
- Change to `band_master`: patch + note.
- Removal: `deprecated_in`, never deletion.

## Do not infer

A grammar point outside this framework must not be used as a `BAND.Map` item or FSRS card source. Adding a rare point requires Colab review.
