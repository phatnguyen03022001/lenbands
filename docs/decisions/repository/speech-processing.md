# Speech Processing Decisions

STATUS: SUPPORTING
ROLE: REPOSITORY DECISION HISTORY
AUTHORITY: NONE

This file normalizes the explicit Speaking speech-processing and feedback-routing decision. It is a future P1 boundary decision, not provider procurement, runtime activation, or evidence that a speaking score is accurate.

## Evidence classes

| Class | Purpose | May be used for | Must never be used for |
|---|---|---|---|
| Browser transcript draft | Optional best-effort learner-device convenience | Editable text practice after learner confirmation | Canonical transcript, speech score, pronunciation score, band estimate, learner telemetry payload |
| Service transcription | Learner-authorized transcription of a retained recording | Timestamped speech evidence and future audio-feedback pipeline | Replacing original recording, raw event/log payload, score without its own benchmark |
| Pronunciation evidence | Dedicated benchmarked analysis of recording features against a defined target | Future feature feedback after its promotion gate | Inferring IELTS Pronunciation criterion, overall Speaking band, or score solely from STT confidence/timestamps |

Learner-corrected text is a private revision linked to—not a mutation of—the provider transcript. It may improve text feedback but cannot rewrite audio evidence or increase a speech/pronunciation result.

## Entitlement direction

| Experience tier | Learner value | Boundary |
|---|---|---|
| Standard practice | local recording, optional browser transcript, text confirmation, text-oriented feedback | no server audio route required; no pronunciation/fluency numeric result or Speaking estimate |
| Audio Review trial | one bounded, disclosed server-audio experience before purchase | consent + entitlement + budget admission; qualitative evidence-linked observations only after promotion gates |
| Premium speaking feedback | durable recording plus server transcription/evaluation under quota/quality policy | numeric pronunciation indicators and estimated Speaking results remain unavailable until separate benchmark gates pass |

Paid audio depth must not block the core ability to practise.

## Provider-neutral boundaries

| Boundary | Decision |
|---|---|
| `BrowserTranscriptProvider` | optional enhancement; capability-detected per session; fall back to manual entry when unavailable/denied/interrupted/unsupported |
| `SpeechToTextProvider` | completed-utterance cost-first candidate route; Groq Whisper Large v3 Turbo was identified as a candidate, not activated selection |
| `PronunciationAssessmentProvider` | deferred; STT is explicitly not this provider; requires labeled corpus, feature benchmark, calibration, accessibility review and release approval |

Deepgram was retained only as a future candidate for live-conversation/interim-subtitle routing when measured learner outcome justifies streaming cost/complexity.

Provider model IDs, prices, SDKs and routing names stay outside learner copy, domain entities, capability IDs, events and OpenAPI until approved implementation contracts exist.

## Admission and recovery

Before server audio is accepted, the future route checks:

1. authenticated ownership and purpose-specific consent;
2. microphone/recording availability plus local fallback;
3. entitlement and atomic quota/cost reservation;
4. file type/duration/size/corruption guardrails without payload logging;
5. durable recording reference before async work;
6. idempotency key preventing duplicate work/charge.

After acceptance, failure preserves the recording and truthful pending/recovery state. It must not fabricate feedback, silently substitute browser recognition, discard the learner attempt, or charge twice.

## Quality release ladder

| Level | Learner-visible promise | Minimum boundary |
|---|---|---|
| `L0_text_practice` | learner edits text and receives text feedback | no speech-quality claim |
| `L1_final_transcript` | final transcript of server-authorized recording | legal/data review + representative transcription benchmark + retry/redaction/retention acceptance |
| `L2_audio_observation` | limited qualitative observation tied to audio evidence | L1 + evidence-link completeness + feature validity benchmark + learner-understanding test |
| `L3_pronunciation_indicator` | bounded target-specific pronunciation indicator, not IELTS band by implication | L2 + labeled target corpus + calibration + subgroup/error analysis + threshold approval |
| `L4_speaking_result` | clearly non-official estimated Speaking practice result with rubric/evidence/confidence/recovery disclosure | gold recordings/examiner labels + benchmark + anti-gaming + calibration/drift/cost gates + release approval |

`L3` does not imply `L4`.

## Privacy and accessibility

- recording retention, server transcription and server evaluation use distinguishable purpose-specific consent;
- browser recognition is never described as “on-device” unless runtime capability proves it for that session;
- raw audio/transcripts do not enter general telemetry, screen replay, logs or events;
- unsupported/denied/noisy/interrupted/provider-unavailable paths retain a useful manual path;
- keyboard controls, visible recording state, pause/stop/re-record and transcript editing are required;
- learner-facing wording stays functional and transparent rather than using an AI marketing label.

## Status

This decision does **not**:

- activate P1 Speaking;
- resolve orphan-family ownership;
- create canonical lifecycle/API/event definitions;
- procure Groq/Deepgram;
- prove pronunciation or Speaking scoring quality;
- alter P0 readiness.

Original source: `artifacts/engineering/decisions/speaking-speech-processing-routing-decision.md`.