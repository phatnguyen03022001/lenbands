# 07 — Conventions

This file owns cross-cutting naming, interaction, accessibility, localization, privacy and runtime conventions. It does not redefine product capability semantics, API payloads, evaluation policy or runtime topology.

## 1. UI naming and technology disclosure

### Principle

Primary learner UI uses functional language rather than implementation branding. Learners should understand what a feature does, what a result means and what happens to their data without needing to understand model/provider architecture.

Rules:

- do not prefix normal labels, buttons, menus or tabs with `AI`;
- do not use sparkle/robot/brain imagery as a generic quality signal;
- use functional labels such as Writing Evaluation, Feedback, Tutor, Next Step and Review;
- privacy, consent and assessment disclosures must truthfully state when automated systems process learner work;
- provider/model identity is audit/governance metadata unless disclosure is required for trust, policy or support;
- no UI copy may imply that an automated estimate is an official IELTS score.

### Capability to learner-label examples

| Capability | Learner label |
|---|---|
| `EVAL.Writing` | Writing Evaluation |
| `EVAL.Speaking` | Speaking Evaluation |
| `EVAL.Pronunciation` | Pronunciation Evaluation |
| `EVAL.Examiner` | Examiner / Speaking Practice |
| `COACH.AnswerExplanation` | Answer Explanation |
| `COACH.DistractorExplanation` | Why this option is wrong |
| `COACH.Feedback` | Feedback |
| `COACH.ErrorAnalysis` | Error Analysis |
| `COACH.Tutor` | Tutor |
| `PERSONAL.NextBestAction` | Next Step |
| `PERSONAL.Insights` | Insights |
| `GOVERNANCE.*` | normally invisible to learner |

## 2. Navigation and interaction conventions

Navigation follows `04-experience.md`; the capability catalog never maps one-to-one to top-level navigation.

### Destination hierarchy

- **Today** is the default authenticated next-decision surface.
- **Progress / History** is secondary inspection, not a prerequisite for receiving the next action.
- **Account** is a utility destination.
- **Library / Explore** is phase-gated and appears only when meaningful direct browsing value exists.
- Placement, skill tasks, feedback, fixes, review, retest and mock/exam flows are contextual destinations unless evidence justifies permanent top-level entry.

### Interaction rules

- one primary CTA per primary state; at most one lighter alternative may compete with it;
- browser/system Back never mutates domain truth by itself;
- refresh after acknowledged mutation is a semantic no-op;
- a resumable active session remains resumable when the learner navigates away; navigation does not imply completion or abandonment;
- show leave confirmation only when unacknowledged work is actually at risk;
- deep links authorize ownership/entitlement and resolve current resource/version state before rendering;
- stale action links never execute a superseded plan; recompute/recover from canonical state;
- dialogs are for bounded confirmation, consent and destructive decisions, not nested primary workflows;
- phase-gated destinations are absent rather than disabled placeholders;
- mobile and desktop navigation may differ visually but preserve the same hierarchy and semantics.

## 3. Accessibility

Accessibility is part of component/state design, not a post-build feature.

### General

- every interactive control is keyboard operable;
- focus is visible and follows semantic order;
- semantic HTML is preferred over custom ARIA recreation;
- color is never the only information channel;
- critical touch targets are at least 44px where practical;
- reduced-motion preference disables nonessential motion;
- route/status/error changes provide appropriate non-visual semantics;
- critical P0 paths remain usable at 200% zoom/reflow;
- countdown pressure, red danger styling and sound are reserved for authentic exam contexts, not engagement pressure.

### Listening

- transcript availability follows content/assessment policy;
- audio controls are keyboard accessible;
- playback speed and seek controls are operable without pointer;
- timer/audio updates do not generate excessive screen-reader announcements.

### Reading

- passage navigation, highlight/annotation controls and answer selection are keyboard accessible;
- text supports readable reflow and user font/contrast preferences where platform support exists.

### Writing

- editor supports standard keyboard/assistive-technology text editing;
- autosave/recovery, word count, timer and validation status are available without hover or color-only cues;
- accidental keyboard submit is prevented by explicit submit confirmation when policy requires it.

### Speaking

- recording state has visual and non-visual indication;
- playback controls are accessible;
- transcript and pronunciation evidence are structured for reading where policy permits them.

The canonical P0 release acceptance boundary remains `artifacts/experience/critical-path-usability-contract.yaml`.

## 4. Localization

### Scope

- UI labels/messages are localized;
- coaching/explanations may be localized;
- IELTS source content remains in the language/form required by the assessment/content contract and is not silently translated when translation would alter task semantics.

### Initial languages

- default: Vietnamese;
- initial supported UI: Vietnamese + English;
- expansion follows learner demand and quality evidence.

### Locale and timezone

- locale controls date/number/presentation formatting;
- persisted IANA timezone controls learner-local calendar semantics;
- locale/timezone changes never rewrite historical UTC instants or date-scoped evidence truth;
- date-only values such as exam date remain date-only according to canonical runtime rules.

### Explanation language

- follows the learner's selected language where supported;
- never changes scoring/rubric/evidence semantics;
- preserves essential IELTS terminology with glossary support rather than mistranslation;
- falls back explicitly when localized content is unavailable.

## 5. Data privacy and trust

### Principles

- learner data has an explicit purpose and governing retention behavior;
- consent is recorded where required;
- optional processing is not enabled through dark patterns;
- export/delete requests expose truthful operation state;
- general telemetry never contains raw essays, recordings, private notes, credentials or unrestricted provider payloads;
- benchmark/research use requires its own provenance, rights and processing basis; production learner submissions do not silently become a research corpus.

### Evaluation disclosure

Before first applicable submission, explain:

- what learner input is processed;
- for what purpose;
- what result scope means;
- relevant retention/data-use behavior;
- how to recover/dispute when the system cannot produce an ordinary valid result.

A result should expose understandable `How this was assessed` information such as rubric/scope/evidence and limitation language. Raw provider confidence or hidden model reasoning is not required learner output.

## 6. Naming and state conventions

- **Capability ID:** `{DOMAIN}.{Capability}` such as `EVAL.Writing`.
- **Mutable canonical filename:** lower-kebab-case except approved special names/numbered Blueprint paths.
- **UI action label:** concise verb-first action where appropriate.
- **Persisted enum/status:** snake_case.
- **Event:** past-tense fact, snake_case.
- **Failure code:** uppercase namespace + reason, e.g. `EVAL_TIMEOUT`, `QUOTA_EXCEEDED`.
- **Versioned contract/event/failure semantics:** use explicit version and preserve migration/replay behavior where applicable.

### Evaluation axes

Operation lifecycle and result trustworthiness remain separate:

```text
operation_state:
  accepted | processing | succeeded | delayed | unavailable | failed | cancelled

result_validity:
  accepted | limited_evidence | insufficient_evidence | invalid | integrity_review
```

Rules:

- do not reintroduce `low_confidence` or `quality_status` as persisted workflow state;
- raw model/provider confidence is internal telemetry unless separately calibrated for a governed interpretation;
- an aggregate UI may have `none/not_started`, but that must not be injected into persisted entity enums merely for presentation convenience;
- each domain owns its own state axes; do not collapse target feasibility, operation lifecycle, result validity, content lifecycle and learner progress into one universal state enum.

### Target and recommendation vocabulary

- target is `TargetProfile`, not one universal scalar `target_band`;
- feasibility: `insufficient_evidence | on_track | at_risk | current_constraints_insufficient | target_met`;
- diagnosis cause: `english_foundation | ielts_technique | integrated_performance | mixed | evidence_needed`;
- missing evidence is never a synonym for weakness;
- `on_track` is not a success probability or guarantee;
- recommendations use minimum sufficient challenge and may return `content_gap` rather than harder/unrelated content.

## 7. Notification convention

Every notification has a governed reason, priority, channel, quiet-hours behavior, frequency cap, unsubscribe path and expected learner value.

- send only for a useful due/result/goal/comeback state;
- no guilt, streak-loss threat or false scarcity;
- notification open/click is not learner-outcome evidence;
- notifications do not override Today/planner semantics.

## 8. Performance and cost convention

For every inference-backed interaction, define:

- latency/deadline behavior;
- retry ownership and bound;
- safe fallback/degraded state;
- cost attribution;
- quality floor and escalation policy.

Rules:

- deterministic rules/library/SQL/precomputed content precede model inference when sufficient;
- stronger/more expensive routes are bounded escalation, not the default status symbol;
- reusable content/explanations may be cached/precomputed only when freshness/invalidation semantics are safe;
- cheaper is not better if the required quality floor fails;
- optimize cost per verified improvement where the capability claims learning outcome, not only cost/request.

## 9. Runtime convention

Canonical runtime topology is owned by `artifacts/engineering/runtime-contract.yaml` and sourcing decisions. This Blueprint does not require Redis, Kafka, a standalone worker service, Go, Python or any other topology by default.

Rules:

- durable mutations require idempotency unless the canonical API explicitly documents an exclusion;
- accepted learner work is preserved before optional downstream inference/retry;
- retry has one owning layer, bounded attempts/deadline and idempotent effect;
- queue/cache/background execution mechanisms are implementation choices only when a measured need and owned contract justify them;
- cache is never a source of semantic truth;
- client/browser state never becomes the only canonical copy after server acknowledgement;
- internal execution uses minimum function/object/data scope, never a generic model/service super-role;
- provider errors, trace IDs and implementation details do not replace learner-safe recovery behavior;
- request/response/telemetry boundaries follow canonical API/privacy contracts rather than ad-hoc provider schemas.

## 10. Blueprint change control

| Change | Record in | Minimum review | Required impact |
|---|---|---|---|
| Product invariant, scope or semantic owner | owning Blueprint + ADR when genuinely cross-domain | founder/product | review affected contracts/roadmap |
| Capability ID/meaning | `03-features.md` | founder/product | update profiles/dependencies/events as needed |
| Learner journey/navigation invariant | `04-experience.md` | product | update affected vertical slices/acceptance |
| Content eligibility/coverage semantics | `05-content.md` | product/content | update planner/publish/rights controls |
| Engine/evidence algorithm boundary | `06-engines.md` | product/engineering | update runtime/benchmark contracts |
| Shared UI/runtime convention | `07-conventions.md` | product/engineering | update affected implementation contracts |
| Delivery phase | `08-roadmap.md` | founder/product | update build/readiness projections |

Rules:

- do not edit Blueprint merely to mirror temporary provider/framework details;
- semantic replacement requires migration/deprecation rather than silently changing a published identifier;
- an affected approved artifact returns to review before reuse when its owned semantics materially change;
- privacy, quality, legal and release implications reference their canonical operational owners;
- repository verification is required before claiming exact-head convergence.

## Cross-references

- Product promise/outcomes: `01-product.md`
- Architecture boundaries: `02-architecture.md`
- Capability identities: `03-features.md`
- Learner shell/journeys: `04-experience.md`
- Content/coverage: `05-content.md`
- Learning engines: `06-engines.md`
- Delivery phases: `08-roadmap.md`
- Runtime: `artifacts/engineering/runtime-contract.yaml`
- P0 usability/recovery: `artifacts/experience/critical-path-usability-contract.yaml`
