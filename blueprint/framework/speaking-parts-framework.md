---
version: 1.0.6
scope: framework
---

# Speaking Parts Framework (Part 1/2/3 + Pronunciation depth)

Status: `framework` — defines behavior for each Speaking part, pronunciation-feedback depth, and examiner interaction rules. Feeds `EVAL.Speaking`, `EVAL.Examiner`, `EVAL.Pronunciation`, `LEARN.Speaking`, and the `BAND.Map` speaking row.

## Part 1 — Interview (4-5 min)

### Structure

- Examiner asks **introductory questions** such as identity check, hometown, work/study.
- Then covers **3 familiar topics**, each with roughly four sub-questions, for about 12 Part 1 questions total.
- Topic pool is rotated; the AI examiner should avoid recently repeated topics for the learner:
  `home, family, food, hobbies, weather, music, reading, sport, internet, daily routine, travel, animals, colours, flowers, noise, patience, concentration, memory, time management, punctuality`

### Examiner topic rotation rule (`EVAL.Examiner`)

The AI examiner must:
- Select **3 topics** from the pool for each Part 1 session and **not repeat** topics used in the learner's previous 3 sessions.
- Always begin with identity check + work/study questions; these are fixed and not rotated.
- Avoid two strongly overlapping topics in the same session.
- Allow the pool to expand through Colab review; do not silently shrink it.

### Expected behavior

| Band | Behavior |
|---|---|
| 5.0 | Short answers with limited extension |
| 6.0 | Extends answers with Why?/How? and some discourse markers |
| 7.0 | Extends naturally, paraphrases, uses less common vocabulary and complex grammar |
| 8.0+ | Spontaneous, idiomatic, fully coherent |

### Examiner (`EVAL.Examiner`) rules

- Do not ask deeply complex follow-ups; Part 1 remains social/familiar.
- If the learner answers for <5 seconds, use a light follow-up such as "Can you tell me more about...?"
- If the learner goes off-topic, gently clarify with "I mean...".
- Examiner **does not correct** the learner; it only evaluates.

### Common errors

| error_id | Mapping |
|---|---|
| `S_fc_short_answer` | practice extension (`S_extend_answer`) |
| `S_fc_long_pause` | practice sustained speech |
| `S_lr_repetitive` | spontaneous paraphrase |
| `S_gra_tense` | tense drill |

## Part 2 — Long Turn / Cue Card (3-4 min)

### Structure

- Cue card contains a topic + 3–4 guiding bullet points + "and explain why...".
- 1 minute preparation with note-taking allowed, followed by 1–2 minutes of continuous speech.
- Examiner does not interrupt unless the learner stops early and needs a brief follow-up.

### Cue card anatomy

```text
Describe [a person/place/object/experience/event].

You should say:
- who/what/where it is
- how you know/learned about it
- what you do/did there
- and explain why [opinion/feeling].
```

Sub-prompts vary by genre: person / place / object / experience / event / activity.

### Expected behavior

| Band | Behavior |
|---|---|
| 5.0 | Covers 1–2 bullets, may stop early, repetition common |
| 6.0 | Covers most bullets, sustains 1+ minute, some structure |
| 7.0 | Covers all points, coherent narrative, range of vocabulary + grammar, **sustained monologue** |
| 8.0+ | Engaging narrative, idiomatic, sophisticated control |

### Examiner rules

- 1 minute prep → prompt "You have one minute... you can make notes."
- If the learner stops before 1 minute → ask "Is there anything else you'd like to add?" or one brief follow-up.
- If the learner exceeds 2 minutes → close gently with "Thank you."
- Do not conduct a long follow-up in Part 2; it is a monologue task.

### Common errors

| error_id | Mapping |
|---|---|
| `S_fc_long_pause` | practice sustained speech (`S_long_turn_sustain`) |
| `S_fc_part2_under_time` | practice cue-card structure |
| `S_fc_repetition` | paraphrase + structure |

## Part 3 — Discussion (4-5 min)

### Structure

- Abstract discussion related to the Part 2 topic.
- Examiner asks **abstract questions** involving why/how, future prediction, comparison, and evaluation.
- Roughly 4–6 questions with deeper follow-ups.

### Expected behavior

| Band | Behavior |
|---|---|
| 5.0 | Short answers; abstract discussion is difficult |
| 6.0 | Attempts to defend views with some reasoning |
| 7.0 | Abstract reasoning, defends views with evidence, uses hypotheticals |
| 8.0+ | Sophisticated argument, speculation, nuance |

### Examiner rules (interaction depth)

- This is the **deepest interaction section**. Follow-ups may include:
  - "Why do you think that is?"
  - "Can you give an example?"
  - "Do you think this will change in the future?"
  - "How does this compare to...?"
- Examiner may **challenge** lightly, e.g. "Some people would argue X...", to require the learner to defend a view.
- Examiner does not reveal its own opinion.

### Common errors

| error_id | Mapping |
|---|---|
| `S_fc_part3_no_develop` | practice abstract reasoning (`S_abstract_reasoning`) |
| `S_gra_only_simple` | practice complex spoken grammar |
| `S_lr_no_idiom` | idiomatic use |

## Pronunciation feedback depth

Pronunciation is the Speaking PR criterion but is separated into `EVAL.Pronunciation` because the feedback depth and mechanics differ.

### Evaluation units (per utterance)

`EVAL.Pronunciation` output has these layers:

| Layer | Unit | Output |
|---|---|---|
| Phoneme | individual phoneme | per-phoneme score (0-1) + error list |
| Word stress | each content word | correct/incorrect + violated rule |
| Sentence stress | each sentence | pattern analysis (content vs function words) |
| Rhythm | each utterance | stress-timed pattern: variation between stressed/unstressed syllables; rhythm is flow, stress is location |
| Intonation | each utterance | rising/falling/flat + appropriateness |
| Connected speech | each phrase | linking/elision/assimilation identified |

**Rhythm vs Sentence Stress:** sentence stress identifies *which words* receive stress; rhythm evaluates the *flow* between stressed syllables and whether timing sounds natural. Vietnamese learners may transfer a more syllable-timed rhythm and distribute stress too evenly. Rhythm becomes a stronger distinguishing signal around higher PR performance.

### Feedback priority (`COACH.ErrorAnalysis`)

Do not dump every detected issue. Prioritize by communicative impact:

| Priority | Issue | Action |
|---|---|---|
| High | Phoneme error changes meaning (ship/sheep) | targeted drill |
| High | Incorrect word stress harms intelligibility | targeted drill |
| Medium | Flat sentence stress with no content emphasis | pattern drill |
| Medium | Flat intonation obscures attitude/meaning | shadowing drill |
| Low | Missing connected-speech linking | reference; not mandatory below higher bands |

### Band correlation (PR criterion)

| Band PR | Pronunciation characteristics |
|---|---|
| 5.0 | Limited features, frequent mispronunciation, listener effort required |
| 6.0 | Range of features with mixed control, occasional mispronunciation, generally clear |
| 7.0 | Easy to understand throughout, more sustained features, rare errors that do not affect meaning |
| 8.0+ | Variety of features, natural, effortless to understand |

### Drill kinds (`REVIEW.FSRS` pronunciation cards)

| kind | Description | Source |
|---|---|---|
| `phoneme_minimal_pair` | Distinguish ship/sheep | model audio + recording |
| `word_stress_rule` | Apply stress rule (phoTOgrapher) | word list |
| `sentence_stress_pattern` | Content vs function-word stress | sentence + recording |
| `intonation_shadowing` | Shadow intonation | model audio + recording |
| `linking_drill` | Practice phrase linking | phrase + recording |

Every drill has model audio + learner recording for comparison/scoring.

## Examiner (`EVAL.Examiner`) — overall interaction rules

| Rule | Description |
|---|---|
| Adaptive follow-up | Follow-up depends on the learner's answer rather than a rigid script |
| Skill-appropriate | Part 1 social, Part 3 abstract; depth changes by Part |
| No correction | Examiner does not correct the learner |
| No opinion reveal | Examiner remains neutral |
| Time-bounded | Part 1 4-5min, Part 2 3-4min, Part 3 4-5min |
| Recovery | If the learner gets stuck, examiner offers light support such as "Take your time" or "Could you rephrase?" |

Examiner is the `EVAL.Examiner` capability, implemented by an LLM with context = current Part + question/answer history.

## Usage

- `LEARN.Speaking` practice: learner selects a Part and enters Examiner interaction.
- `EVAL.Speaking` scores four criteria (FC/LR/GRA/PR).
- `EVAL.Pronunciation` scores pronunciation layers separately for deeper feedback.
- `BAND.Map` speaking row: per-Part readiness plus pronunciation sub-items.
- `REVIEW.SmartQueue` pronunciation queue: cards from the drill kinds above.

## Versioning

- Current release: `1.0.6`; the frontmatter is authoritative for the file version.
- `version: 1.0.1` — reconciled speaking error references.
- `version: 1.0.6` — normalized the per-file release record; speaking semantics are unchanged.
- Adding Part-behavior detail: minor.
- Changing pronunciation depth: patch + research note.

## Do not infer

- Examiner must not ask outside the expected Part pattern, e.g. an abstract Part-3-style question in Part 1 is a bug.
- Pronunciation drills must not be generated from sources outside pronunciation `error_id` mappings.
- PR band correlation comes from `band-descriptor-map.md`; do not invent it.
