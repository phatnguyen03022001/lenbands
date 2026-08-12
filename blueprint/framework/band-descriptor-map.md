---
version: 1.0.6
scope: framework
---

# Band Descriptor Map

Status: `framework` — invariant IELTS knowledge. Đây là ánh xạ chính thức từ public IELTS band descriptors, được tái cấu trúc để máy đọc được. **Không thêm diễn dịch; nếu mâu thuẫn với nguồn chính thức, nguồn chính thức thắng.**

Nguồn: IELTS public band descriptors (Writing Task 1, Writing Task 2, Speaking), được dùng làm rubric cho `EVAL.Writing`, `EVAL.Speaking`, `BAND.Requirement`. Listening và Reading không có descriptor theo tiêu chí — chấm bằng answer key, band = số điểm đúng theo bảng quy đổi.

## Quy ước

- 4 criterion Writing: **TR** (Task Response), **CC** (Coherence & Cohesion), **LR** (Lexical Resource), **GRA** (Grammatical Range & Accuracy).
- 4 criterion Speaking: **FC** (Fluency & Coherence), **LR** (Lexical Resource), **GRA** (Grammatical Range & Accuracy), **PR** (Pronunciation).
- Mỗi ô là **đặc trưng phân biệt** ở band đó (không phải toàn bộ descriptor — để tránh trùng lặp giữa các band, mỗi band chỉ ghi thêm gì so với band dưới).
- Band 1-3 gộp chung vì Learner App target band 3.0+; dưới 3.0 không mô hình hóa sâu.
- Listening/Reading: bảng quy đổi (raw score → band) ở `exam-module-differences.md`, không lặp ở đây.

## Writing — Task Response (TR)

| Band | Đặc trưng phân biệt (thêm so với band dưới) |
|---|---|
| 9 | Fully developed, fully addresses all parts, well-supported, no irrelevance |
| 8 | Sufficiently addresses all parts, well-developed, relevant |
| 7 | Addresses all parts, presents clear position throughout, main ideas extended+supported (một số thể hiện chưa hoàn toàn nhất quán) |
| 6 | Addresses all parts (một số phần đầy đủ hơn khác), presents relevant main ideas (một số không được phát triển đầy đủ hoặc không rõ ràng) |
| 5 | Addresses task chỉ chung chung, expresses position nhưng không rõ ràng, main ideas hạn chế — **đường ranh 5/6: có phát triển thật hay không** |
| 4 | Responses đúng dạng nhưng không đủ, khó xác định position, ideas limited |
| 3 | Không hiểu task, ideas limited/không liên quan, có thể off-topic |
| 2 | Barely responds, no position, barely relevant |
| 1 | No position, totally irrelevant |

**Phân biệt mấu chốt 6.0 vs 7.0:** 7.0 có position xuyên suốt + main ideas được extended có support; 6.0 position có nhưng main ideas phát triển không đều.

## Writing — Coherence & Cohesion (CC)

| Band | Đặc trưng phân biệt |
|---|---|
| 9 | Skilful paragraphing, cohesive devices used with complete flexibility, fully logical progression |
| 8 | Logical, all cohesive devices appropriate, clear central topic trong mỗi paragraph |
| 7 | Logically organized, clear progression, range of cohesive devices (một số bị over-/under-use), presents clear central topic |
| 6 | Arranges coherently, overall progression, uses cohesive devices nhưng **mechanical** (this, however, firstly lặp), refers/thêm rõ nhưng không luôn successful |
| 5 | Presents organization nhưng **không rõ ràng**, cohesive devices inadequate/repeated, lacks overall progression, paragraphing có nhưng không logic |
| 4 | Presents information có nhưng khó theo dõi, few cohesive devices, repetitive, không có hoặc sai paragraphing |
| 3 | No logical organization, no cohesive devices (or wrong), no progression |
| 2 | Little organization, very little cohesive language |
| 1 | Incoherent |

**Mấu chốt 6.0 vs 7.0:** 7.0 dùng cohesive devices tự nhiên, có range; 6.0 mechanical (máy móc, lặp), tham chiếu đôi khi không rõ.

## Writing — Lexical Resource (LR)

| Band | Đặc trưng phân biệt |
|---|---|
| 9 | Wide range tự nhiên, full flexibility, accurate, rare errors chỉ là slip |
| 8 | Wide vocabulary, fluently + flexibly, rare errors, sophisticated |
| 7 | Sufficient range cho clarity + style, less common items, awareness of style/collocation (một số sai chọn), occasional errors |
| 6 | Adequate range cho task, attempts less common (có lỗi), errors trong spelling/word formation nhưng không cản trở communication |
| 5 | Limited range, adequate for task cơ bản, repetitive, errors spelling/word form rõ, **khó hiểu đôi chỗ** |
| 4 | Limited, basic vocabulary, repetitive, errors cản trở meaning |
| 3 | Rất limited, có thể lặp很多 |
| 2 | Cực kỳ limited, chỉ từ đơn giản |
| 1 | Chỉ vài từ rời rạc |

**Mấu chốt 6.0 vs 7.0:** 7.0 dùng less common items + collocation với awareness; 6.0 chỉ adequate, attempts less common còn lỗi.

## Writing — Grammatical Range & Accuracy (GRA)

| Band | Đặc trưng phân biệt |
|---|---|
| 9 | Full flexible range, accurate, chỉ slip |
| 8 | Wide range of structures, majority error-free, occasional non-systematic errors |
| 7 | Various complex structures, frequent error-free sentences, good control of grammar/punctuation (một vài errors) |
| 6 | Mix of simple + complex forms, flex nhưng có lỗi trong grammar/punctuation, errors hiếm khi cản trở communication |
| 5 | Limited range, attempts complex nhưng **limited accuracy**, errors frequent, punctuation lỗi |
| 4 | Chỉ basic forms, một vài complex có lỗi, errors frequent → cản trở |
| 3 | Cố basic nhưng error-heavy |
| 2 | Chỉ structures đơn giản, hầu hết lỗi |
| 1 | Không có cấu trúc có thể hiểu |

**Mấu chốt 6.0 vs 7.0:** 7.0 various complex structures + frequent error-free; 6.0 mix simple/complex, có lỗi nhưng không cản trở.

## Speaking — Fluency & Coherence (FC)

| Band | Đặc trưng phân biệt |
|---|---|
| 9 | Speaks fluently, only occasional repetition/self-correction, develops topics fully+coherently, appropriate length |
| 8 | Develops topics coherently+appropriately, fluency chia relates to language content (không accent) |
| 7 | Speaks at length without noticeable effort/loss of coherence, may exhibit **language-related hesitation** (vì tìm từ/grammar), some repetition, uses range of connectives+discourse markers (some over-/under-use) |
| 6 | Willing to speak at length nhưng **có mất fluency**, uses connectives+discourse markers but limited/repeated, repetition, self-correction, hesitation để tìm từ |
| 5 | Usually maintains flow but uses **repetition, self-correction, slow speech, hesitation**, links ideas simple, overuse certain connectives/discourse markers |
| 4 | Cannot respond without hesitation, speech slow, frequent repetition/self-correction, links simple but không logic |
| 3 | Hesitation rất dài, no clear message, simple speech |
| 2 | Pause dài, barely linked |
| 1 | No communication possible |

**Mấu chốt 6.0 vs 7.0:** 7.0 at length without noticeable effort, hesitation chỉ là language-related; 6.0 mất fluency, hesitation để tìm từ, connectives limited.

## Speaking — Lexical Resource (LR)

(So với Writing LR: thêm idiom, paraphrase sống)

| Band | Đặc trưng phân biệt |
|---|---|
| 9 | Full flexibility, precise meaning, idiomatic, wide range including rare items |
| 8 | Wide vocabulary, idiomatic, flexible+fluent |
| 7 | Flexible use including less common+idiomatic, some awareness of style/collocation, paraphrase effectively, occasional inaccuracies |
| 6 | Wide enough vocabulary to discuss at length, generally paraphrase successfully, uses less common (some inaccuracies) |
| 5 | Manages to talk với limited flexibility, general meaning clear dù **limited attempt paraphrase**, errors rõ |
| 4 | Limited, family topic OK, paraphrase rarely successful |
| 3 | Simple vocabulary to express personal info, insufficient for complex topics |
| 2 | Isolated words/memorized phrases |
| 1 | Nothing |

**Mấu chốt 6.0 vs 7.0:** 7.0 paraphrase effectively + idiomatic; 6.0 paraphrase generally OK, less common có inaccuracy.

## Speaking — Grammatical Range & Accuracy (GRA)

| Band | Đặc trưng phân biệt |
|---|---|
| 9 | Full flexible accurate, complex forms freely+accurately |
| 8 | Wide range of structures flexibly, frequent error-free, some basic errors |
| 7 | Various complex structures flexibly, frequent error-free, some persistent grammatical errors (non-systematic) |
| 6 | Various simple+complex forms, flex nhưng limited, mistakes nhưng không cản trở |
| 5 | Limited range, attempts complex limited accuracy, errors frequent |
| 4 | Basic forms used, limited accuracy, complex forms error-heavy |
| 3 | Cố simple form, errors heavy |
| 2 | Simple isolated words, errors-heavy |
| 1 | Nothing |

**Mấu chốt 6.0 vs 7.0:** tương tự Writing GRA — 7.0 various complex flexibly; 6.0 mix có lỗi nhưng không cản trở.

## Speaking — Pronunciation (PR)

| Band | Đặc trưng phân biệt |
|---|---|
| 9 | Effortless to understand, full灵活 features (rhythm, intonation, individual sounds) |
| 8 | Easy to understand throughout, variety of features, occasional individual sound mispronunciation不影响 meaning |
| 7 | Shows all positive features (6) **and** some use of features band 8 — easy to understand throughout, occasional individual sound errors不影响 meaning |
| 6 | Uses **range of pronunciation features** với mixed control, **some effective use of features** nhưng không sustained, generally clear throughout despite occasional mispronunciation |
| 5 | Shows all 4 positive features band 6 **but with some problems** OR shows some band 6 features but not sustained, can be understood generally but effort required by listener |
| 4 | Limited use of features, frequent mispronunciation, **listener effort needed** |
| 3 | Limited features, many mispronunciations, hard to follow |
| 2 | Very hard to understand, almost no features |
| 1 | Unintelligible |

**Mấu chốt 6.0 vs 7.0:** 7.0 easy throughout + sustained positive features; 6.0 range có nhưng mixed control, không sustained, occasional mispronunciation.

## Cách dùng (cho engine + agent)

- `EVAL.Writing`/`EVAL.Speaking` phải chấm theo 4 criterion, output band per criterion. Overall skill band = average của 4 criterion, **làm tròn về 0.5 gần nhất theo quy tắc IELTS: .25→.5, .75→next whole** (vd avg 6.25 → 6.5, avg 6.75 → 7.0). Chi tiết bảng quy đổi ở `exam-module-differences.md`.
- `BAND.Requirement`/`BAND.Map` dùng descriptor để sinh checklist "cần gì để đạt band X" (vd band 7.0 GRA: "various complex structures, frequent error-free").
- `COACH.ErrorAnalysis` phải map error → criterion bị ảnh hưởng + band tương ứng.
- Đường ranh quan trọng cho calibration: **5.0 vs 6.0** (có phát triển thật không; có mix complex không) và **6.0 vs 7.0** (range/flexibility vs adequate).
- Listening/Reading: band được tính từ raw score qua quy đổi, không qua descriptor — bảng quy đổi ở `exam-module-differences.md`.

## Không tự suy luận

Nếu descriptor ở đây không đủ để chấm một edge case, engine phải trả `insufficient_evidence` chứ không đoán band. Bổ sung descriptor (rare) phải qua Colab review và cập nhật version.

## Versioning

- Current release: `1.0.6`; the frontmatter is authoritative for the file version.
- `version: 1.0.1` — standardized criterion and band descriptor boundaries.
- `version: 1.0.6` — added the missing per-file version record; descriptor semantics and calibration claims are unchanged.
- Thêm descriptor hoặc đổi semantics: minor; sửa metadata/prose không đổi nghĩa: patch; bỏ: `deprecated_in` (không xóa).
