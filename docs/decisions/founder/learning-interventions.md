# Learning Intervention Decisions

STATUS: SUPPORTING
ROLE: FOUNDER DECISION HISTORY
AUTHORITY: NONE

This file preserves all 40 founder decisions from 10B. It records gap-to-action and learning-mechanism direction without turning specific UI/activity implementations into canonical learning truth.

## 10B — Gap → action intent → intervention

| ID | Decision | Rationale |
|---|---|---|
| 10B.1 | Ability gap → diagnose failure pattern; prerequisite only if implicated. | Wrong does not automatically mean missing prerequisite. |
| 10B.2 | Worked example → controlled → guided → fade → independent → transfer, with stages skippable when evidence supports. | Provide an acquisition path without forcing already-demonstrated steps. |
| 10B.3 | Retention/recall gap → retrieval + spaced practice candidate. | Use mechanisms aligned to retrieval failure rather than reteaching by default. |
| 10B.4 | Spacing applies only to suitable reviewable learning units, not every mistake. | FSRS-like scheduling requires discrete repeatable retrieval semantics. |
| 10B.5 | Discrimination gap → contrastive examples → explanation → varied context → independent application. | Near-alternative errors require discrimination, not merely more same-format items. |
| 10B.6 | Production gap → recognition → controlled → guided → independent → unseen production. | Recognizing quality is not equivalent to producing it. |
| 10B.7 | Scaffolding dependence → identify carrying support → selectively fade → re-evidence. | Remove the support actually responsible for performance, not all help at once. |
| 10B.8 | Transfer gap → variation → interleaving → unseen transfer. | More same-pattern practice does not test generalisation. |
| 10B.9 | Insufficient evidence → low-friction uncertainty-reducing diagnostic. | Unknown is an evidence problem, not a remediation command. |
| 10B.10 | Conflicting evidence → discriminating task/hypothesis test. | Resolve the reason for inconsistency instead of averaging it away. |
| 10B.11 | Stale evidence → targeted reassessment before remediation. | Old evidence does not prove deterioration. |
| 10B.12 | Intervention failure → classify failure mode → change action space. | Do not repeat the same intervention indefinitely. |
| 10B.13 | Learner preference is a suitability signal only. | Preference may improve adherence but cannot override prerequisites/quality/contraindications. |
| 10B.14 | Mechanism diversity only when justified by diminishing returns/transfer/repetition. | Do not randomize learning merely to look varied. |
| 10B.15 | Adaptive acceleration skips/compresses unnecessary stages when evidence supports it. | Strong learners should not replay the whole curriculum. |
| 10B.16 | When learner struggles, retain target; decompose/scaffold and use nearer-term subgoal. | Adapt the path, not the target, unless the learner explicitly changes the goal. |
| 10B.17 | Active retrieval for appropriate learned/reviewable knowledge; application follows when target requires production. | Retrieval supports recall, but complex performance still needs contextual production/transfer. |
| 10B.18 | FSRS-like scheduling only for reviewable learning units with repeated retrieval events and updateable recall state. | Use scheduler semantics where there is a meaningful discrete review object. |
| 10B.19 | Worked examples include attention guidance/comparison then fade. | Model answers should teach relevant features, not invite memorization. |
| 10B.20 | Contrastive practice for near alternatives/discrimination gaps. | Make the discriminating cue observable. |
| 10B.21 | Dictation only when failure implicates decoding/segmentation/detail perception. | Dictation is not a universal Listening curriculum. |
| 10B.22 | Shadowing only for relevant pronunciation/prosody/fluency targets. | Shadowing success does not prove independent Speaking readiness. |
| 10B.23 | Controlled production bridges recognition → production. | Constrain output enough to practice the intended form before free performance. |
| 10B.24 | Guided production uses failure-relevant support and fades selectively. | Scaffolding should target the actual production bottleneck. |
| 10B.25 | Rewrite/re-record only when corrected production has learning value for the gap. | Do not force productive correction on every wrong answer type. |
| 10B.26 | Feedback depth adapts to failure type. | Avoid rigid “always reveal” or “always self-correct first” rules. |
| 10B.27 | Extensive input is a learning candidate for breadth/exposure; weak direct readiness evidence alone. | Exposure can improve learning without directly proving a target claim. |
| 10B.28 | Interleaving is purposeful and follows sufficient initial stability. | Random mixing can increase difficulty without improving discrimination. |
| 10B.29 | Difficulty progression follows learner evidence + target/context demands. | Band labels are not direct item-difficulty rules. |
| 10B.30 | Feedback timing follows activity intent. | Immediate feedback supports acquisition; delayed feedback protects independent evidence. |
| 10B.31 | Hint availability/use belongs to ScaffoldingProfile/evidence context. | A correct response after hint has different inference scope. |
| 10B.32 | Self-explanation only when it reveals useful reasoning/discrimination. | Use cognitive friction when it produces information/learning value. |
| 10B.33 | Reflection/metacognition is lightweight and event-triggered. | Avoid turning every question into a survey. |
| 10B.34 | Learner-generated output is a productive retrieval/elaboration candidate when feedback is feasible. | Generation can expose production gaps that recognition hides. |
| 10B.35 | Timing is relevant only when the target performance requirement makes it material. | Timed practice is context, not a universal learning mechanism. |
| 10B.36 | Full mock = assessment/re-evidence mechanism with learning side-effects. | Mocks are broad evidence tools, not substitutes for targeted intervention. |
| 10B.37 | Detect diminishing returns; no fixed diversity quota. | Mechanism change should follow plateau/transfer/friction signals, not arbitrary counts. |
| 10B.38 | Multi-mechanism sequences require declared candidate rationale; plausibility ≠ validated efficacy. | A coherent story is not causal evidence. |
| 10B.39 | AI tutor is delivery/runtime capability, not a learning-mechanism ontology root. | AI can instantiate worked examples, guided practice, role-play, explanation, etc. |
| 10B.40 | Gamification belongs to experience support, not mastery/readiness semantics. | XP/streak/badges must not become ability evidence. |

## Navigation summary

```text
GapEvaluation
    ↓
ActionIntent
    ↓
Intervention
    ↓
LearningMechanism
    ↓
ActivityPattern
    ↓
learner attempt / evidence as appropriate
```

The distinctions above summarize the locked set; they do not replace current canonical contracts.

Original source: `artifacts/operations/decisions/lenbands-decision-register-v1.0.0-founder-locked-2026-08-12.md`.