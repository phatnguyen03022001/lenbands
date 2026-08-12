# Speaking Speech Processing & Feedback Routing Decision

## Context

Speaking and Pronunciation are P1, `PLANNED` families.  They have no activated
owner runtime spec, canonical API/event schema, audio benchmark, provider DPA,
or production acceptance evidence.  This record therefore decides the product
and adapter boundaries needed for a future promotion; it is **not** a provider
procurement decision, a runtime contract, or evidence that a speaking score is
accurate.

The product must make low-cost practice useful without representing a browser
transcript as a reliable assessment.  Browser speech recognition is not
portable enough to be a required foundation: MDN classifies `SpeechRecognition`
as limited availability and notes that some browsers send audio to a server-side
recognition service.  A browser result can help the learner compose or review
text, but it is neither guaranteed to be local nor canonical speech evidence.

## Decision

### 1. Separate three evidence classes

| Class | Purpose | May be used for | Must never be used for |
|---|---|---|---|
| Browser transcript draft | Optional, best-effort convenience on the learner device | Editable text practice after learner confirmation | Canonical transcript, speech score, pronunciation score, band estimate, learner telemetry payload |
| Service transcription | Learner-authorized transcription of a retained recording | Timestamped speech evidence and future audio-feedback pipeline | Replacing the original recording, raw event/log payload, score without its own benchmark |
| Pronunciation evidence | Dedicated, benchmarked analysis of recording features against a defined target | Future feature feedback only after its own promotion gate | Inferring an IELTS Pronunciation criterion, an overall Speaking band, or a score solely from STT confidence/timestamps |

The learner-confirmed text is a separate private revision linked to, not a
mutation of, the provider transcript.  It may improve text-oriented feedback.
It cannot revise the audio evidence, overwrite the provider transcript, or
increase a speech/pronunciation result.

### 2. Entitlement is progressive, not punitive

| Experience tier | Learner value | Audio boundary | Quality boundary |
|---|---|---|---|
| Standard practice | Record locally; optionally use browser transcript; edit/confirm text; receive text-oriented feedback | No server audio route is required. Browser recognition may use a browser-vendor service and therefore requires its own disclosure. | No pronunciation/fluency numeric result, no Speaking band estimate, no claim that transcript equals what was said. |
| Audio Review trial | One bounded, explicitly disclosed server-audio experience before purchase | Admission requires recording/transcription/evaluation consent, entitlement and budget reservation. Exact allowance belongs to the future subscription/quota policy, not this decision. | Show final transcript and qualitative, evidence-linked observations only if the relevant route has passed its promotion gate. Never promise or show an official score. |
| Premium speaking feedback | Durable recording plus server transcription/evaluation, subject to plan quota and quality policy | Same consent/admission/privacy path as the trial; provider use is an adapter route. | Numeric pronunciation indicators and estimated Speaking results stay unavailable until their separate benchmark gates are met. |

No learner is prevented from practising because a paid audio route is unavailable.
The graceful fallback is local recording playback plus manual or browser-assisted
text confirmation; it is not a silent downgrade of an accepted server analysis.

### 3. Provider routing is an adapter concern

The future runtime must expose three provider-neutral boundaries.  These labels
are engineering interfaces, not learner-facing names, domain entity names, or
new capability IDs.

| Boundary | Input/output constraint | Current route decision | Promotion/rollback rule |
|---|---|---|---|
| `BrowserTranscriptProvider` | Browser capability probe and provisional text only; no server persistence by default | Optional enhancement; capability-detected per session, never required | Fall back to manual entry when unavailable, denied, interrupted or not supported. |
| `SpeechToTextProvider` | Reads learner-scoped `recording_ref`; returns private transcript/evidence references and allowed timing metadata | Final, completed-utterance transcription is a cost-first candidate route. Groq Whisper Large v3 Turbo is a candidate because its current documentation supports file transcription and word/segment timestamps; it is not selected for activation here. | A route needs DPA/data review, benchmark, cost policy, failure/recovery test and release approval. Route swap is config/flag after equivalent-contract benchmark; no domain/API/event migration. |
| `PronunciationAssessmentProvider` | Reads a learner-scoped recording and target reference; returns only a validated, private result/ref | Deferred. STT is not this provider. | Requires labeled audio/target corpus, feature-level benchmark, calibration, accessibility review and release approval. |

Deepgram is a candidate only for a future live-conversation or interim-subtitle
route where native streaming/turn behavior demonstrably improves learner
outcome.  It must not be activated merely because it is available.  Its higher
cost and any live route must be justified by measured UX value, a DPA and an
operating quota.  Groq's current minimum billed audio length is ten seconds, so
a future completed-utterance route must use voice activity/end-of-turn handling
and must not issue a request for every tiny microphone chunk.

Provider-specific model IDs, prices, SDKs and routing names stay outside
learner copy, domain entities, capability IDs, events and OpenAPI until an
approved implementation contract exists.

### 4. Admission and recovery rules

Before a server-audio request is accepted, the future route must check:

1. authenticated learner ownership and the required purpose-specific consent;
2. microphone/recording availability and a clear local fallback;
3. entitlement and an atomic quota/cost reservation;
4. file type, duration, size and corruption guardrails without logging payload;
5. a durable recording reference before async transcription/evaluation;
6. an idempotency key so retries cannot create duplicate work or charge.

Once accepted, the learner sees a durable, truthful pending/recovery state and
may leave the screen.  A provider timeout, route outage or quota race retains
the recording and offers retry when safe; it does not fabricate feedback,
silently fall back to browser recognition, discard the learner's attempt, or
charge twice.  Any future job payload, event and general telemetry uses opaque
references and a controlled privacy class only—never audio bytes, transcript
text, prompt body, provider payload or hidden reasoning.

### 5. Quality release ladder

| Level | Learner-visible promise | Minimum evidence before activation |
|---|---|---|
| `L0_text_practice` | Learner edits text and receives text feedback. | Browser/manual flow acceptance, accessibility review, transparent copy. No speech-quality claim. |
| `L1_final_transcript` | A final transcript of a server-authorized recording. | Provider legal/data review, representative transcription benchmark, retry/redaction/retention acceptance. |
| `L2_audio_observation` | Limited qualitative observation tied to an audio segment or an explicit insufficient-evidence result. | L1 plus evidence-link completeness, feature validity benchmark and learner-understanding test. |
| `L3_pronunciation_indicator` | A bounded pronunciation indicator for a named practice target, never an IELTS band by implication. | L2 plus labeled target corpus, calibration, subgroup/error analysis and threshold approval. |
| `L4_speaking_result` | A clearly non-official estimated Speaking practice result with rubric/evidence/confidence/recovery disclosure. | Speaking gold recordings with examiner labels, rubric/model benchmark, anti-gaming policy, calibration/drift/cost gates and release approval. |

The levels are promotion gates, not a delivery schedule.  `L3` does not imply
`L4`; pronunciation practice remains a supporting domain rather than a separate
IELTS exam section or independent band.

### 6. Privacy, trust and accessibility rules

- Consent is purpose-specific: keeping a recording, server transcription and
  server evaluation are distinguishable.  Withdrawing optional reuse consent
  cannot silently delete a learner's requested practice record; deletion/export
  follows the canonical privacy policy.
- Before browser recognition begins, the UI states that browser support and
  processing location vary; it never calls the feature “on-device” unless the
  runtime capability check has proven that mode for that session.
- Audio, provider transcripts and learner-corrected transcripts are private,
  learner-scoped data.  Product analytics receives only privacy-filtered
  aggregate outcome/duration buckets; screen replay, logs and events never
  receive their raw content.
- Mic permission denial, unsupported browser, noisy audio, interrupted upload,
  inaccessible playback, or unavailable provider must leave a useful manual
  path.  Keyboard controls, visible recording state, pause/stop/re-record and
  transcript editing are required; color/audio alone never conveys state.
- Learner-facing labels use neutral functional wording such as “Transcript”,
  “Review recording” and “Audio feedback”.  Privacy/help copy remains explicit
  about automated processing and limitations without using an AI marketing
  label.

## Consequences

- **Product/UX:** free practice remains real practice, while paid audio analysis
  adds depth rather than withholding the learning loop.  Learners can correct a
  transcript before text feedback, preventing STT errors from being graded as
  language errors.
- **Quality:** no STT WER, timestamp or confidence number is treated as
  pronunciation evidence.  No numeric speech score is released ahead of an
  audio-specific benchmark.
- **Cost:** browser capability is optional; server usage has admission,
  quota, idempotency and completed-utterance guardrails.  Real-time streaming is
  an evidence-gated UX investment rather than the default path.
- **Portability:** changing Groq, Deepgram or a future provider changes an
  adapter route only after equivalent-contract validation; it cannot redefine
  IELTS semantics.
- **Scope:** this record does not resolve the protected `SPEAKING.Practice`
  orphan-family decision, activate P1, add canonical lifecycle/API/event
  definitions, provision a vendor, or alter P0 readiness.

## Review triggers

Re-review this decision before any P1 activation and whenever browser support,
provider data terms, costs, speech benchmark results, consent/retention policy,
or measured correction/abandonment rates materially change.

## Evidence and references

- [MDN SpeechRecognition](https://developer.mozilla.org/en-US/docs/Web/API/SpeechRecognition) (accessed 2026-08-11): limited browser availability; some browsers use server-based recognition; local processing is capability-dependent.
- [Groq Speech-to-Text](https://console.groq.com/docs/speech-to-text) (accessed 2026-08-11): completed-file transcription, word/segment timestamps, 10-second minimum billed length; values are provider facts, not a cost contract.
- [Deepgram pricing](https://deepgram.com/pricing) (accessed 2026-08-11): streaming/voice route candidate information; re-verify before procurement.
- `blueprint/01-product.md`, `blueprint/03-features.md`, `blueprint/07-conventions.md`, `blueprint/08-roadmap.md`
- `artifacts/operations/deferred-families-reference.md`
- `artifacts/engineering/contracts/multi-skill-practice/runtime-spec.md`
- `artifacts/engineering/contracts/runtime/provider-adapter-contract.md`
- `artifacts/business/decisions/managed-platform-baseline-decision.md`
