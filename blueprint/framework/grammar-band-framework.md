---
version: 1.0.6
scope: framework
---

# Grammar × Band Framework

Status: `framework` — versioned controlled vocabulary của grammar points theo band. Feed `KA.Grammar`, `BAND.Map` grammar row, `BAND.Requirement` grammar checklist, FSRS card nguồn `recall_grammar_rule`.

Quy ước:
- `grammar_id` snake_case, versioned.
- Mỗi điểm có: `band_introduce` (band bắt đầu cần dùng), `band_master` (band cần dùng chính xác flexible), `error_refs` (error taxonomy liên quan; không phải micro-skill).
- Band range theo difficulty tiêu chuẩn EFL/IELTS; không phải rule cứng mà **câu hỏi "learner band X có dùng chưa"**.
- Không list toàn bộ ngữ pháp tiếng Anh — chỉ list những điểm có **ý nghĩa phân biệt band** trong IELTS.

## Node schema (mỗi grammar point)

Mỗi grammar point là một **node khép kín** — sở hữu quan hệ + điều kiện hoàn thành + phát biểu của chính nó (inline ownership). Graph/index toàn cục là projection sinh tự động, không phải SSOT (xem `framework/README.md`).

Các bảng band bên dưới hiện là inventory summary. Chỉ node có đủ `can_statement`, `depends_on`, `done_when` và `error_refs` mới là spawn-ready; summary-only node phải được asset đánh dấu `needs_review`, không được publish như đã đủ learning outcome.

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
  accuracy_pct: 90                   # trong practice/drill gắn grammar_id này
  consecutive_sessions: 3            # 3 lần liên tiếp đạt accuracy
  no_review_regression_days: 30      # không relapse trong 30 ngày sau FSRS rating Good
  evidence_source: [practice, writing_eval, speaking_eval]
unlocks:                             # thuận: node này mở khóa node nào (projection dùng)
  - g_mixed_conditionals
```

Quy ước field:
- `depends_on`: edge **đến** node này cần (prerequisite). Rỗng = không có prerequisite (node gốc).
- `unlocks`: edge **đi** từ node này (forward). Bằng projection, không bắt buộc viết tay.
- `strength`: `hard_prerequisite` (không biết thì không học được), `recommended` (nên biết trước), `soft` (liên quan nhẹ).
- `source`: nguồn edge, KHÔNG tự suy luận. `cambridge_syllabus` = chuẩn Cambridge; `efl_research` = nghiên cứu EFL; `colab_curated` = Colab curated.
- `done_when`: điều kiện để đánh dấu ✓ ở `BAND.Map` (mastery). `accuracy_pct` + `consecutive_sessions` + `no_review_regression_days` là 3 điều kiện hội (AND).
- `can_statement`: phát biểu learner-facing ("learner can ..."), không phải tên kỹ thuật.

## Band 4.0–5.0 — Foundation (cần có để vào band 5)

| grammar_id | Điểm ngữ pháp | band_introduce | band_master | error_refs | done_when (summary) |
|---|---|---|---|---|---|
| `g_present_simple` | Present simple | 4.0 | 5.0 | — | acc≥90%, 3 session, 30d no relapse |
| `g_present_continuous` | Present continuous | 4.0 | 5.0 | — | acc≥90%, 3 session |
| `g_past_simple` | Past simple | 4.0 | 5.0 | — | acc≥90%, 3 session |
| `g_past_continuous` | Past continuous | 4.5 | 5.5 | — |
| `g_present_perfect` | Present perfect vs past simple | 5.0 | 6.0 | `W_gra_tense` |
| `g_future_will_going` | Will vs going to | 4.5 | 5.5 | — |
| `g_subject_verb_agreement` | Subject-verb agreement | 4.5 | 5.5 | `W_gra_subject_verb` |
| `g_articles_basic` | a/an/the cơ bản | 4.5 | 6.0 | `W_gra_article` |
| `g_plural_nouns` | Plural nouns + irregular | 4.0 | 5.0 | — |
| `g_basic_conjunctions` | and/but/because/so | 4.0 | 5.0 | — |
| `g_modals_basic` | can/could/must/should (ability, advice, obligation) | 4.5 | 5.5 | — |

Dependency edges for the two foundation rows above are not taxonomy links:

| grammar_id | depends_on | strength |
|---|---|---|
| `g_present_continuous` | `g_present_simple` | hard_prerequisite |
| `g_past_simple` | `g_present_simple` | hard_prerequisite |

## Band 5.0–6.0 — Developing (cần có để vào band 6)

| grammar_id | Điểm ngữ pháp | band_introduce | band_master | error_refs |
|---|---|---|---|---|
| `g_present_perfect_continuous` | Present perfect continuous | 5.5 | 6.5 | `W_gra_tense` |
| `g_past_perfect` | Past perfect | 5.5 | 6.5 | — |
| `g_zero_first_conditional` | Zero + first conditional | 5.5 | 6.5 | `W_gra_complex_with_error` |
| `g_second_conditional` | Second conditional (hypothetical) | 6.0 | 7.0 | — |
| `g_passive_voice` | Passive voice (present/past) | 5.5 | 6.5 | `W_gra_complex_with_error` |
| `g_relative_clauses_defining` | Defining relative clauses (who/which/that) | 5.5 | 6.5 | `W_gra_relative_clause` |
| `g_relative_clauses_non_defining` | Non-defining (comma + who/which) | 6.0 | 7.0 | — |
| `g_gerund_infinitive` | Gerund vs infinitive after verbs | 5.5 | 6.5 | — |
| `g_comparatives_superlatives` | Comparative + superlative forms | 5.0 | 6.0 | — |
| `g_quantifiers` | some/any/much/many/few/a few | 5.0 | 6.0 | — |
| `g_countable_uncountable` | Countable vs uncountable | 5.0 | 6.0 | — |
| `g_used_to` | used to / be used to / get used to | 5.5 | 6.5 | — |
| `g_reported_speech` | Reported speech + backshift | 5.5 | 6.5 | — |
| `g_question_tags` | Question tags | 5.5 | 6.5 | — |
| `g_articles_advanced` | The với unique, geographical, generic | 6.0 | 7.0 | `W_gra_article` |

## Band 6.0–7.0 — Target (cần có để vào band 7 — vùng phân biệt quan trọng nhất)

| grammar_id | Điểm ngữ pháp | band_introduce | band_master | error_refs |
|---|---|---|---|---|
| `g_third_conditional` | Third conditional (past unreal) | 6.5 | 7.5 | `W_gra_complex_with_error` |
| `g_mixed_conditionals` | Mixed conditionals | 7.0 | 8.0 | — |
| `g_wish_if_only` | wish + past/past perfect; if only | 6.5 | 7.5 | — |
| `g_passive_advanced` | Passive với modals, reporting verbs | 6.5 | 7.5 | — |
| `g_relative_clause_reduced` | Reduced relative clauses (participle) | 7.0 | 8.0 | — |
| `g_participle_clauses` | Participle clauses (-ing/-ed reduced) | 7.0 | 8.0 | `W_gra_complex_with_error` |
| `g_inversion` | Inversion sau negative/restrictive adverb | 7.0 | 8.0 | `W_gra_complex_with_error` |
| `g_cleft_sentences` | Cleft sentences (It is... that...) | 7.0 | 8.0 | — |
| `g_modal_perfect` | Modal + perfect (must have done, should have done) | 6.5 | 7.5 | — |
| `g_subordinate_clauses` | Concession (although/despite), purpose (so that), result (such) | 6.5 | 7.5 | — |
| `g_emphatic_do_did` | Emphatic do/did | 6.5 | 7.5 | — |
| `g_noun_clauses` | Noun clauses (that/whether) | 6.5 | 7.5 | — |
| `g_indirect_questions` | Indirect question word order | 6.5 | 7.5 | — |
| `g_punctuation_advanced` | Semicolon, colon, dash, parallel structure | 6.5 | 7.5 | `W_gra_punctuation` |

## Band 7.5–9.0 — Advanced/Precision (cần có để vào band 8+)

| grammar_id | Điểm ngữ pháp | band_introduce | band_master | error_refs |
|---|---|---|---|---|
| `g_inversion_conditional` | Inversion trong conditional (Had I known...) | 7.5 | 8.5 | — |
| `g_emphatic_inversion` | Emphatic inversion (Not only did he...) | 8.0 | 9.0 | — |
| `g_elliptical_clauses` | Ellipsis (omitting words) | 8.0 | 9.0 | — |
| `g_nominalization` | Nominalization (academic style) | 7.5 | 8.5 | — |
| `g_subjunctive` | Subjunctive (suggest/recommend that he be) | 8.0 | 9.0 | — |
| `g_complex_parallelism` | Parallelism trong long sentences | 7.5 | 8.5 | — |
| `g_fronting` | Fronting for emphasis (On the table was...) | 8.0 | 9.0 | — |

## Tổng số grammar point theo band target (cho `BAND.Map` checklist)

| Band target | Số điểm ngữ pháp cần master (cumulative) |
|---|---|
| 5.0 | 11 (Foundation) |
| 7.0 | 40 (cộng Target — vùng phân biệt 6→7) |
| 8.0 | 47 (cộng Advanced) |
| 9.0 | 47 (cả Advanced) |

Con số này là **gợi ý band completion**, không phải rule cứng — `BAND.Map` hiển thị từng điểm ✓/⚠/✗ theo `band_master` và evidence thực tế của learner.

## Dependency chains quan trọng (mẫu — full edge inline trong node)

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

Edge `hard` = không học qua thì không học được node sau. Edge `recommended` = nên học trước nhưng có thể nhảy (chậm hơn).

## Cách dùng

- `KA.Grammar` asset: mỗi grammar lesson có `grammar_id` (từ framework này) + `band_master`.
- `BAND.Map` grammar row: liệt kê grammar points với `band_master <= target_band`, check ✓/⚠/✗ dựa trên evidence (`REVIEW.MistakeNotebook`, `EVAL.Writing/Speaking` recent).
- `BAND.Requirement` checklist: dùng grammar này làm "cần đạt band X".
- FSRS card `recall_grammar_rule`: source = `grammar_id` + rule.
- `COACH.ErrorAnalysis`: map grammar error → `grammar_id`.

## Versioning

- Current release: `1.0.6`; the frontmatter is authoritative for the file version.

- `version: 1.0.1` — corrected inventory count/identifier and marked incomplete summary rows; no new grammar point added.
- `version: 1.0.2` — corrected the inventory column label so `error_refs` is not confused with `depends_on`.
- `version: 1.0.4` — moved foundation prerequisites out of `error_refs` and removed the duplicate 6.0 summary row; no new grammar node added.
- `version: 1.0.5` — corrected `g_participle_clauses.error_refs` to a taxonomy error id after semantic validator hardening; no new grammar node added.
- `version: 1.0.6` — normalized the changelog order; grammar nodes and band mappings are unchanged.
- Thêm: minor bump + `added_in`.
- Sửa band_master: patch + note.
- Bỏ: deprecated_in (không xóa).

## Không tự suy luận

Grammar point không trong framework không được dùng làm `BAND.Map` item hay FSRS card source. Thêm điểm mới (rare) phải qua Colab review.
