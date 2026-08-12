# Interaction Specification — Speaking Transcript & Audio Feedback

## 0. Purpose and boundary

This P1 interaction specification turns the future learner journey into an
observable behavior contract.  It covers a speaking prompt, local recording,
optional transcript assistance, learner correction, trial/premium audio review
and recovery.  It does not create a canonical runtime/API/event/lifecycle
owner, activate a provider, promise a speaking score, or resolve the protected
`SPEAKING.Practice` family decision.

The system decision is
`artifacts/engineering/decisions/speaking-speech-processing-routing-decision.md`.
The existing multi-skill runtime document remains the P1 conceptual runtime
reference until a promoted owner runtime spec is approved.

## 1. Learner promise

The learner can always practise speaking, hear their own recording and work
with editable text.  Server-audio analysis is optional depth, never the only
way to continue learning.  The screen must distinguish:

- **Transcript draft:** optional text produced by the browser; it may be wrong.
- **Confirmed text:** the learner's editable revision used for text-oriented
  feedback.
- **Audio review:** a separate, consented server route; availability and
  entitlement are shown before submission.

The learner never sees an “official score”.  Until the quality release ladder
authorizes it, the screen does not display a numeric pronunciation result,
fluency result or estimated IELTS Speaking band.

## 2. Interaction path contract

| Step | Actor | Learner action/system behavior | Data and runtime boundary | Expected UX | Failure/recovery | Evidence required for promotion |
|---|---|---|---|---|---|---|
| `SP-I01` | Learner | Opens a published Part 1/2/3 prompt and receives a microphone readiness check. | Prompt content stays English; capability detection is local. | Clear prompt, timer only where the selected part requires it, and a visible “Start recording” action. | No mic/support → manual response route and help; no dead end. | Cross-browser/accessibility acceptance. |
| `SP-I02` | Learner | Reviews recording/transcription/evaluation processing disclosure before first relevant use. | Consent purpose is checked server-side only when a server route is requested. | Plain-language explanation of what is retained and why; separate choices for local practice versus Audio Review. | Decline → local practice remains available. | Consent, retention and export/delete acceptance. |
| `SP-I03` | Learner | Starts, pauses/stops, replays or re-records. | Local recording is not telemetry. A future upload uses a learner-scoped recording reference only. | Visible recording indicator, elapsed time, keyboard controls, replay and re-record; no pressure colors/audio outside exam mode. | Permission denied/interruption → preserve any local draft where browser allows; offer retry/manual route. | Recording/recovery acceptance. |
| `SP-I04` | System / learner | Offers browser transcript only if the session capability probe succeeds; learner edits it. | Browser result remains provisional and is not persisted as speech evidence by default. | “Transcript draft — please check before feedback.” Editable field and a “Use this text” confirmation. | Unsupported/no match/recognition failure → empty editable field, never a blocked session. | Browser fallback acceptance; disclosure review. |
| `SP-I05` | Learner | Requests text feedback after confirming text. | Text feedback reads the learner-confirmed private revision; it does not treat it as an audio measurement. | Feedback identifies language actions and a next practice step; it does not infer pronunciation from text. | Text route unavailable → keep confirmed text and show retry state. | Text-feedback contract and privacy acceptance. |
| `SP-I06` | Learner | Elects Audio Review trial or premium feedback. | Server admission checks required consent, ownership, entitlement, cost/quota reservation, file safety and idempotency before accepting. | Upfront notice of what the review covers, any trial availability, and a truthful pending state after acceptance. | Ineligible/quota unavailable → return to complete local practice without losing recording/text. | Entitlement/admission and quota idempotency acceptance. |
| `SP-I07` | System | Processes a durable recording through transcription/evaluation route. | Async work receives opaque references; raw audio/transcript/provider payload stay learner-scoped. | Learner may leave; result status is recoverable on return. | Timeout/outage → retained recording plus delayed/unavailable/retry-safe state; no silent browser fallback. | Provider outage, retry and redaction acceptance. |
| `SP-I08` | Learner | Views a final transcript and any permitted evidence-linked observation; chooses a next practice or retest. | Provider transcript and learner-confirmed revision stay distinct private records. | Clear source/limitation copy: text feedback uses confirmed text; audio observations use the recording. | Insufficient audio evidence → explain limitation and offer re-record/targeted practice, not a fabricated result. | Evidence-link, calibration and learner-comprehension acceptance. |

## 3. Progressive experience rules

### Standard practice

- Browser speech recognition is an optional convenience, not a prerequisite.
- Manual text entry and local playback work regardless of browser support.
- The learner can receive feedback on confirmed text, but the result is described
  as text feedback—not as pronunciation, fluency or a Speaking score.

### Audio Review trial

- The trial exists so a standard learner can experience the value of audio-aware
  feedback before deciding to upgrade.
- Its exact count, duration and eligibility belong to the future subscription
  policy; UI and backend use a named entitlement/configuration, never a hidden
  client-side counter.
- It is not a promise of numeric scoring.  If the eligible audio quality level
  is not released, the trial may provide final transcription and an explicit
  “audio feedback is not available yet” result rather than inventing analysis.

### Premium speaking feedback

- Premium expands admitted server-audio usage subject to quota, privacy and
  quality gates.  It must not receive a lower-quality route merely to save cost.
- A released audio observation must cite a segment/evidence reference or say
  that evidence was insufficient.  It does not expose provider identities,
  prompts, hidden reasoning or internal confidence values.

## 4. Learner copy and disclosure rules

Required functional copy, localized through the product language setting:

| Situation | Required meaning (Vietnamese reference copy) |
|---|---|
| Browser transcript | “This transcript was created by the browser and may be inaccurate. Edit it before receiving content feedback.” |
| Browser processing | “Transcription depends on the browser; some browsers may process audio through their own service.” |
| Audio Review | “Audio Review analyzes the recording you choose to submit. You can continue practicing without this feature.” |
| Pronunciation limitation | “Pronunciation feedback appears only when the recording contains enough data. This is not an official IELTS score.” |
| Pending/recovery | “Your recording has been saved. You can leave the screen; we will show the result or guide you to try again.” |

These are transparency/help/consent statements, not marketing labels.  Primary
actions remain functional: “Record”, “Review recording”, “Edit transcript”,
“Get text feedback”, and “Try Audio Review”.

## 5. Quality and integrity invariants

1. A learner correction must never alter the original audio, provider
   transcript, timing evidence or any resulting score.
2. Text feedback never claims to assess pronunciation or fluency.
3. STT accuracy, word timestamps and speech-recognition confidence are not
   pronunciation scores.
4. Numeric pronunciation indicators require the `L3_pronunciation_indicator`
   gate; estimated Speaking practice results require `L4_speaking_result`.
5. All results retain their source/rubric/model/quality context privately for
   audit; learner UI receives an understandable limitation, evidence and next
   action rather than internal payloads.
6. Analytics can measure aggregate funnel/latency/correction-rate buckets only.
   It cannot receive raw audio, transcript text, prompt body or provider
   response.

## 6. Acceptance cases for future promotion

| ID | Scenario | Pass condition |
|---|---|---|
| `SP-UX-01` | Unsupported browser or mic denied | Learner can still practise through prompt, local/manual text route and receives no false transcript. |
| `SP-UX-02` | Browser transcript is materially wrong | Learner edits/uses confirmed text; feedback reflects confirmed text and makes no speech-quality claim. |
| `SP-UX-03` | Learner edits transcript after server transcription | Original recording/provider transcript remain immutable; correction is linked as a separate private revision. |
| `SP-UX-04` | Trial entitlement/quota rejects admission | No upload/evaluation charge is created; local recording/text path remains usable and honest. |
| `SP-UX-05` | Server route times out after acceptance | Recording and accepted request remain recoverable; no duplicate work/charge; learner sees truthful recovery state. |
| `SP-UX-06` | Audio lacks evidence for a requested observation | UI says evidence is insufficient and offers re-record/practice; it shows no fabricated numeric result. |
| `SP-UX-07` | Screen-reader, keyboard and reduced-motion use | Recording state, timer, playback, transcript edit, cancel and recovery are available without color-only or audio-only signals. |
| `SP-UX-08` | Telemetry review | Event/log/analytics/replay contains no raw recording, transcript, provider payload or prompt body. |

## 7. Non-goals

- Real-time examiner avatar, live conversation or interruption handling.
- Accent classification/coaching, video analysis, emotion inference or identity
  inference from voice.
- A standalone pronunciation IELTS section/band.
- A provider-specific UI, hard-coded provider quota or client-side entitlement
  enforcement.
- Claiming an official IELTS score or P1 runtime readiness.

## References

- `blueprint/04-experience.md`, `blueprint/07-conventions.md`
- `artifacts/experience/specs/skill-practice-coverage.md`
- `artifacts/engineering/decisions/speaking-speech-processing-routing-decision.md`
- `artifacts/engineering/contracts/multi-skill-practice/runtime-spec.md`
- `artifacts/engineering/contracts/runtime/provider-adapter-contract.md`
- `artifacts/operations/deferred-families-reference.md`
