# 07 — Conventions

This file contains **cross-cutting conventions** that apply to all preceding files: naming, icons, accessibility, localization, and privacy. These are shared rules, not features.

## 1. UI Naming & Icon Convention (No-AI-label)

### Principle

Documentation uses the term "AI" on capabilities so developers understand their technical origin (calibration, model, engine). The **end-user UI** does not use the word "AI" and does not use AI-themed icons. Users see plain functional names and do not need to care about the underlying technology as long as outcomes are clear.

This rule applies only to primary product labels. Privacy, Help, consent, evaluation details, and error states must transparently explain that results are produced by an automated system, what confidence limitations exist, and how data is handled.

### Rules

- Do not prefix labels, buttons, menus, or tab names with "AI"
- Do not use AI-symbol icons such as sparkle ✨, robot 🤖, or brain 🧠
- Use functional icons such as pen, microphone, score sheet, tutor, or light bulb
- Documentation retains "AI Writing Evaluation (sole scorer)" at the capability-definition level; UI displays "Writing Evaluation"

### Mapping docs capability → UI label

| Capability id | UI display |
|---|---|
| `EVAL.Writing` | Writing Evaluation |
| `EVAL.Speaking` | Speaking Evaluation |
| `EVAL.Pronunciation` | Pronunciation Evaluation |
| `EVAL.Examiner` | Examiner |
| `COACH.AnswerExplanation` | Answer Explanation |
| `COACH.VocabularyExplanation` | Vocabulary Explanation |
| `COACH.DistractorExplanation` | Distractor Explanation |
| `COACH.ListeningCoach` | Listening Coach |
| `COACH.ReadingCoach` | Reading Coach |
| `COACH.Feedback` | Feedback |
| `COACH.ErrorAnalysis` | Error Analysis |
| `COACH.Recommendation` | Recommendation |
| `COACH.Tutor` | Tutor |
| `EVAL.BandPrediction` | Band Prediction |
| `EVAL.RewriteSuggestion` | Rewrite Suggestion |
| `PERSONAL.Insights` | Insights |
| `PERSONAL.NextBestAction` | Next Step (localized equivalent may be used) |
| `GOVERNANCE.*` | invisible — not shown to the user |

### Icon examples

| Capability | Icon |
|---|---|
| Writing Evaluation | pencil / graded paper |
| Speaking Evaluation | microphone |
| Examiner | interviewer / headset |
| Tutor | tutor / light bulb |
| Band Prediction | chart / target |
| FSRS review | flashcard / loop |

## 2. Accessibility (a11y)

Accessibility is cross-cutting and is not a separate feature.

### Listening

- Transcript is always available
- Subtitles synchronized with audio
- Complete keyboard navigation
- Playback speed (0.75x–1.5x)
- Keyboard shortcuts for play/pause/seek

### Reading

- Keyboard-accessible highlight and underline
- Dark mode
- Adjustable font size
- Sufficient contrast (WCAG AA)

### Writing

- Autosave so drafts are not lost
- Real-time word count
- Keyboard-friendly editor

### Speaking

- Recording has a visual indicator
- Transcript after recording
- Adjustable playback speed

### General

- Every action has a keyboard equivalent
- Screen-reader friendly through semantic HTML / ARIA
- Color is never the only information channel
- Visible focus
- Touch target ≥ 44px
- Reduced motion and pause/stop controls for animation, audio, and notifications
- Do not use countdowns, red color, or sound to create pressure outside exam mode

## 3. Localization

### Scope

- **UI** is multilingual: labels, menus, buttons, messages
- **AI responses** are multilingual: answer explanations, Writing/Speaking feedback, knowledge explanations
- **IELTS content** always remains in its original English and is NOT translated: audio, passage, question, writing task, speaking prompt

### Languages

- Default: Vietnamese
- Initial: Vietnamese + English
- Later: expand according to demand

### Locale formatting

- Date formatting follows locale
- Decimal formatting follows locale
- 12h/24h time follows locale

### AI response language

- Follows `user.preferred_language`
- Does not affect scoring; band score remains aligned to the IELTS rubric
- Helps learners understand feedback in a familiar language
- Preserves necessary IELTS terminology; use a glossary rather than mistranslating band/rubric terms
- Provides an explicit language fallback when a response is not localized

## 4. Data Privacy

### Principles

- Users own their data and can export and delete it
- AI data usage is transparent
- Consent is explicit

### Capability

| id | Description |
|---|---|
| `IDENTITY.Privacy` | Export Data, Delete Data, Consent, AI Data Usage |
| `IDENTITY.DeleteAccount` | Delete account |
| `PKM.Export` | Export learning data (notes, word bank, history) |

### AI Data Usage disclosure

- Users are informed that submission data may be used to improve models when consent exists
- Users can opt out
- Gold-standard benchmark data is de-identified

### Data retention

- Drafts/Recordings: retained according to user policy until account deletion
- Assessment History: retained for portfolio/timeline according to the governing retention policy
- Review logs (FSRS): retained according to the policy required for optimization
- Account deletion: delete PII; aggregated anonymous benchmark data may remain only when consent and policy allow it

### Trust and evaluation disclosure

- Before the first submission, users are told which inputs are processed, for what purpose, and for what retention period.
- Every result provides a "How this was assessed" path showing rubric, evidence, confidence state, and model/rubric version in understandable terms.
- Do not use "official score" for anything other than a real official test result; use "estimated band" or "practice result".
- An anti-gaming flag is a state requiring handling, not a default conclusion of misconduct.
- Users can export/delete data according to policy; the UI must display processing state rather than merely making a button disappear.

## 5. Naming convention (cross-cutting)

- **Capability id**: `{DOMAIN}.{Capability}` (PascalCase) — e.g. `EVAL.Writing`, `REVIEW.SmartQueue`
- **Docs file**: `NN-name.md` (snake or kebab according to team convention)
- **UI label**: clear; verb-first for actions ("Evaluate Writing"), noun-first for entities ("Writing Portfolio")
- **Status value**: snake_case — `published`, `in_review`, `deprecated`
- **Evaluation state**: the learner aggregate may be `none`, `submitted`, `processing`, `scored`, `low_confidence`, `invalid`, `anti_gaming_review`, or `failed`. The persisted `Evaluation` entity and its HTTP projection start at `submitted` and therefore intentionally omit aggregate-only `none`.
- **Quality status**: `accepted`, `low_confidence`, `insufficient_evidence`, `invalid`; this is a quality axis and must not be merged into lifecycle state.
- **Runtime state**: snake_case within each axis — `active`, `inactive`, `paused`, `at_risk`, `achieved`; do not collapse the axes into a single enum
- **Event name**: past-tense fact, snake_case — `placement_completed`, `retest_completed`, `session_abandoned`
- **Event envelope SSOT**: `blueprint/03-features.md` § Event Contract; projections must use `event_type`, semver `event_version`, `trace_id`, `user_id_hash`, `schema_version`, and `privacy_class`.
- **Event `privacy_class`**: `account | learning | assessment | audio | billing | system | derived`.
- **Failure code**: uppercase namespace + reason — `EVAL_TIMEOUT`, `QUOTA_EXCEEDED`, `SYNC_CONFLICT`
- **Contract version**: increment `event_version`/`failure_version` when schema or semantics change; preserve backward compatibility during migration
- **Experiment/feature flag**: snake_case with owner, start/end date, cohort, and rollback condition

## Notification convention

- Every notification has `reason`, `priority`, `channel`, `quiet_hours`, `frequency_cap`, `unsubscribe_action`, and `expected_value`.
- Do not send notifications merely to create opens/clicks; each must relate to a due item, result, goal, or comeback action.
- Do not use guilt ("you're falling behind", "you'll lose your streak") or false scarcity.

## Performance and cost convention

- Every AI-backed interaction defines a latency target, timeout, retry limit, fallback, and cost budget.
- Prefer cache, batch, precompute, and smaller models; use larger models only when risk/value justifies them.
- Display waiting and delayed-result states honestly; do not block an entire journey because of one AI call.
- Quality regression and cost regression are both release blockers when committed thresholds are exceeded.

## Runtime contract convention

- P0 backend jobs use Redis Streams consumer groups; changing queue technology requires a Decision Artifact plus migration/exit exercise and must not be a silent refactor.
- An HTTP mutation requires `Idempotency-Key` unless it is read-only or the contract explicitly documents an exclusion.
- APIs return correlation IDs, versioned error envelopes, and `Retry-After` when the client can retry.
- Cache key/TTL/invalidation/revalidation behavior is defined in a Cache Contract; semantics must not exist only as hard-coded implementation behavior.
- Worker/job contracts define producer, consumer, payload classification, retry/DLQ/replay, concurrency, cancellation, and idempotent effect.
- Request/response and telemetry must not contain raw essays, recordings, provider payloads, or hidden reasoning outside the approved data scope.

## Blueprint change control

| Change | Record in | Minimum approval | Required impact |
|---|---|---|---|
| Change invariant, scope, or role boundary | Blueprint + ADR when multiple domains are affected | Founder | Review affected Artifacts/roadmap |
| Add/change Capability ID | `03-features.md` | Founder | Update dependency, event, quality/cost profile |
| Change runtime state/event/failure semantics | Blueprint + engineering contract | Founder + engineering review | Version/migration/rollback |
| Change UI wording or design representation | Artifact Design | Product review | Capability identity remains unchanged |
| Change implementation/provider | Artifact Decision/Contract | Engineering review | Quality/cost regression gate |

Rules:

- Do not edit the Blueprint merely to reflect temporary implementation details.
- A published Capability ID must not change meaning; semantic replacement requires a new capability or a deprecated capability with migration.
- An `approved` Artifact affected by a Blueprint change returns to `review` before further use.
- Every change with privacy, quality, or legal impact references the appropriate decision/evidence.

## Cross-references

- Sole-evaluator principle: `01-product.md`
- Complete capability IDs: `03-features.md`
- Engine (calibration, model): `06-engines.md`
