---
version: 1.0.7
scope: framework
---

# Speaking Parts Framework (Part 1/2/3 + Pronunciation depth)

Status: `framework` — combines official-derived IELTS Speaking format with LenBands-controlled practice/simulator behavior. Feeds `EVAL.Speaking`, `EVAL.Examiner`, `EVAL.Pronunciation`, `LEARN.Speaking`, and curriculum views.

Authority:
- Part timing, interaction pattern, preparation time, and the broad purpose of Parts 1–3 are `official-derived` from IELTS.org.
- Topic pools, anti-repeat rules, practice question counts, coaching follow-ups, and pronunciation drill mechanics are `lenbands-controlled`.
- Simplified band examples in learning UX are diagnostic heuristics only. Actual scoring uses the current reviewed Speaking band descriptors.

Official reference: `https://ielts.org/take-a-test/test-types/ielts-academic-test/ielts-academic-format-speaking`

## Runtime modes

`EVAL.Examiner` must declare a mode:

```yaml
examiner_mode: strict_mock | guided_practice
```

- `strict_mock`: preserve the public IELTS interaction pattern and timing; do not insert coaching, corrections, extra teaching turns, or artificial challenge rounds.
- `guided_practice`: may use LenBands coaching/repetition policies, but the UI must not present the interaction as an exact exam simulation.

## Part 1 — Introduction and interview (4–5 minutes)

### Official-derived contract

- The examiner introduces themself and checks identity.
- The examiner asks general questions about familiar topics such as home, family, work, studies, or interests.
- Part 1 lasts about 4–5 minutes.
- Public IELTS format material does **not** define a fixed number of topics or a fixed number of questions that LenBands may treat as universal.

### LenBands practice policy

A practice session may use a configurable topic pool such as:

`home, family, food, hobbies, weather, music, reading, sport, internet, daily routine, travel, animals, colours, flowers, noise, patience, concentration, memory, time management, punctuality`

Practice presets may, for example, choose several topics and avoid recent repeats. These are product policies, not official IELTS counts.

`guided_practice` may:
- avoid topics used recently by the learner;
- prompt a learner to extend an unusually short answer;
- offer a retry after the answer is complete.

`strict_mock` must not turn those coaching rules into extra examiner assistance.

### Common diagnostic errors

| error_id | Mapping |
|---|---|
| `S_fc_short_answer` | practice extending relevant answers (`S_extend_answer`) |
| `S_fc_long_pause` | practice sustained speech |
| `S_lr_repetitive` | paraphrase / lexical flexibility practice |
| `S_gra_tense` | tense-control drill |

## Part 2 — Individual long turn (3–4 minutes including preparation)

### Official-derived contract

- The examiner gives the learner a task card on a particular topic.
- The card states points to include and asks the learner to explain one aspect of the topic.
- The learner has **1 minute to prepare** and may make notes.
- The learner then speaks for **up to 2 minutes**; the examiner stops the turn when time is up.
- The examiner may ask one or two questions on the same topic after the long turn.

Do not encode a universal IELTS rule that every task card has exactly 3–4 bullets or that the final bullet must literally use the words "and explain why". LenBands assets may use a normalized authoring template, but that template is an internal content convention.

### LenBands authoring template

```text
Describe [topic].

You should say:
- [point]
- [point]
- [point]
- and explain [an aspect of the topic].
```

Allowed internal genres may include person, place, object, experience, event, and activity. Genre taxonomy is LenBands-controlled.

### Strict mock behavior

- Give one minute of preparation time.
- Start the long turn after preparation.
- Allow the learner to continue until the response ends or the time limit is reached.
- Stop at the time limit and optionally ask the normal brief same-topic follow-up.
- Do not correct, teach, or reveal a score during the interaction.

### Guided practice behavior

After a completed attempt, the app may invite the learner to retry, compare structure, or practice sustaining speech. Such coaching occurs outside the strict examiner turn.

### Common diagnostic errors

| error_id | Mapping |
|---|---|
| `S_fc_long_pause` | sustained-turn practice (`S_long_turn_sustain`) |
| `S_fc_part2_under_time` | long-turn planning/sustaining practice; not an automatic IELTS penalty rule |
| `S_fc_repetition` | paraphrase + discourse-organisation practice |

## Part 3 — Discussion (4–5 minutes)

### Official-derived contract

- Examiner and learner discuss issues connected to the Part 2 topic in a more general and abstract way and, where appropriate, in greater depth.
- Part 3 lasts about 4–5 minutes.
- It tests the ability to explain opinions and to analyse, discuss, and speculate.
- Public format guidance does not define a universal fixed question count that the simulator may treat as an IELTS rule.

### LenBands practice policy

Practice questions may involve causes, consequences, comparison, evaluation, speculation, and future change. `guided_practice` may add deeper prompts after an attempt. `strict_mock` should use a time-bounded examiner interaction without adding an artificial debate/challenge mechanic merely to make the session harder.

### Common diagnostic errors

| error_id | Mapping |
|---|---|
| `S_fc_part3_no_develop` | practice explaining/justifying abstract ideas (`S_abstract_reasoning`) |
| `S_gra_only_simple` | broaden spoken structural range while preserving accuracy |
| `S_lr_no_idiom` | legacy diagnostic label; do not treat absence of an idiom as an automatic IELTS error |

`S_lr_no_idiom` requires taxonomy review/deprecation because IELTS Lexical Resource is holistic; a fixed idiom count is not a scoring rule.

## Pronunciation feedback depth

Pronunciation is one of the four Speaking criteria. LenBands may expose a deeper diagnostic subsystem, but the subsystem must not manufacture a Pronunciation band by mechanically averaging internal layers.

### LenBands diagnostic layers

| Layer | Unit | Example diagnostic output |
|---|---|---|
| Phoneme | individual sound | confidence/error evidence |
| Word stress | word | stress-location evidence |
| Sentence stress | utterance | prominence pattern |
| Rhythm | utterance | timing/prominence pattern |
| Intonation | utterance | contour/prominence evidence |
| Connected speech | phrase | linking/reduction evidence |

These layers support feedback and drills. The official Pronunciation band remains criterion-based and holistic.

### Feedback priority

Prioritize communicative impact rather than dumping every detected deviation:

| Priority | Issue | Action |
|---|---|---|
| High | Sound contrast causes a meaning/intelligibility problem | targeted perception/production drill |
| High | Word stress substantially harms intelligibility | targeted stress drill |
| Medium | Prominence/rhythm makes intended meaning difficult to follow | pattern drill |
| Medium | Intonation/prominence weakens meaning or discourse signalling | guided shadowing |
| Low | Optional connected-speech feature is absent but intelligibility is unaffected | enrichment, not penalty |

Do not penalize a learner for having a non-native accent. Feedback targets intelligibility and controlled use of relevant phonological features.

### Drill kinds

| kind | Description | Source |
|---|---|---|
| `phoneme_minimal_pair` | perception/production contrast | model audio + learner recording |
| `word_stress_rule` | practice lexical stress | word list |
| `sentence_stress_pattern` | practice prominence | sentence + recording |
| `intonation_shadowing` | imitate a model contour | model audio + recording |
| `linking_drill` | optional connected-speech practice | phrase + recording |

## Scoring boundary

- `EVAL.Speaking` scores FC, LR, GRA, and PR with equal weighting using the reviewed descriptor version.
- Part-specific diagnostics can explain where evidence came from, but IELTS does not award a separate band for Part 1, Part 2, and Part 3.
- A micro-skill, error count, pause threshold, idiom count, or pronunciation-layer score must not directly determine an IELTS band.
- Insufficient evidence → `insufficient_evidence`.

## Usage

- `LEARN.Speaking`: choose `strict_mock` or `guided_practice` explicitly.
- `EVAL.Examiner`: preserve mode boundaries and part timing.
- `EVAL.Speaking`: use all relevant performance evidence and the current reviewed descriptor contract.
- `EVAL.Pronunciation`: provide diagnostic evidence without substituting for the holistic PR criterion.
- `REVIEW.SmartQueue`: create drills from observed errors/evidence, not from accent stereotypes.

## Versioning

- Current release: `1.0.7`; the frontmatter is authoritative for the file version.
- `version: 1.0.1` — reconciled speaking error references.
- `version: 1.0.6` — normalized per-file version records without changing speaking semantics.
- `version: 1.0.7` — separated official Speaking format from LenBands simulator/practice presets, removed fixed question/bullet counts as IELTS rules, separated strict mock from coaching behavior, and clarified holistic scoring boundaries.
- A correction to official-derived format facts requires a patch bump plus source review.
- A product-practice policy change requires a patch/minor bump according to schema impact.

## Do not infer

- Do not invent fixed IELTS question counts or cue-card bullet counts when public IELTS guidance does not define them.
- Do not make guided-practice assistance available inside `strict_mock` examiner turns.
- Do not derive a Speaking or Pronunciation band from internal diagnostic thresholds alone.
- Do not treat a missing idiom, a particular accent, or one isolated pronunciation feature as an automatic band cap.
