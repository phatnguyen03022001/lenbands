# 08 — Roadmap

This file owns delivery phasing, not capability semantics. The complete product Blueprint may describe future scope; only the phase below may receive build-ready work.

## P0 — Closed Pilot

P0 proves one complete learner-outcome loop, not a four-skill IELTS-completion claim.

P0 packs remain:

- `P0-01` identity/consent/profile/privacy;
- `P0-02` TargetProfile + placement/diagnosis;
- `P0-03` deterministic Daily Action / Next Best Action;
- `P0-04` Writing Task 2 evaluation;
- `P0-05` error → remediation → review when appropriate → independent retest;
- `P0-06` quality/cost/governance controls.

P0 principles:

- deterministic-first;
- missing evidence is not weakness;
- diagnosis distinguishes English foundation, IELTS technique, integrated performance, mixed causes and evidence-needed states when evidence supports it;
- target feasibility is a planning state, never a guaranteed-band probability;
- the learner sees one primary action + one reason + one verification rule + at most one lighter alternative;
- Today is the default authenticated next-decision surface; capability inventory does not become navigation inventory;
- recommendation cannot outrun governed curriculum + independent verification/retest coverage;
- minimum sufficient challenge; no automatic higher-band progression;
- Writing result is task-scoped diagnostic evidence, not an official IELTS Writing score;
- FSRS schedules only suitable retrievable units;
- success requires independent evidence, not familiar-item completion;
- cost is measured against verified learner improvement.

## P0 canonical outcome loop

```text
TargetProfile
  -> minimum placement evidence
  -> target feasibility
  -> supported cause / evidence gap
  -> ONE Today action + Why + Verification
  -> Writing Task 2
  -> governed task-scoped evaluation
  -> one evidence-backed error/cause
  -> smallest useful remediation
  -> optional FSRS review only when retrievable
  -> sufficiently novel independent retest
  -> evidence/readiness update
  -> Today recomputes the next decision
  -> measured cost per verified improvement
```

Explicitly deferred from P0 learner-completeness claims: Listening, Reading, Speaking, Pronunciation, full Mock Test, full Exam Readiness, full Content/Colab, subscriptions, broad search/notifications/offline/multi-device and advanced analytics.

## P0 launch gates

Closed pilot may launch only when all six P0 packs are eligible/ready under the canonical readiness system and the exact candidate proves:

1. TargetProfile supports module + overall/per-skill minima + date/capacity constraints without altering observed score truth.
2. Placement can return insufficient evidence instead of fabricated precision.
3. Supported diagnosis distinguishes foundation/technique/integrated/mixed causes or explicitly returns evidence-needed.
4. Target feasibility uses only `insufficient_evidence | on_track | at_risk | current_constraints_insufficient | target_met`; no success probability/hours-to-band/guaranteed attainment copy exists.
5. Home/Daily Action exposes one primary action, one controlled reason, one verification rule and at most one lighter alternative.
6. Today is the default authenticated next-decision surface; P0 does not expose top-level tabs merely for capability domains.
7. Back/refresh/deep-link/resume behavior preserves canonical state, accepted submissions and unacknowledged learner work without duplicate semantic effects.
8. `current_constraints_insufficient` yields an actionable constraint decision instead of an impossible normal plan.
9. Activated Writing diagnosis/remediation families have governed intervention + independent verification/retest coverage; missing coverage yields `content_gap`.
10. Planner excludes advanced/beyond-target content unless prerequisite, authentic-exam or transfer policy explicitly justifies it.
11. Writing submission/evaluation preserves scope, rubric/task/scorer-route/config provenance, result validity, evidence, cost and recovery.
12. No unbenchmarked scorer fallback exists; stronger scoring only runs under a governed escalation rule.
13. Error → fix → retest preserves novelty/exposure; revealed/repeated source content cannot prove transfer.
14. Activity/session/FSRS completion cannot directly promote complex-skill readiness.
15. Consent/export/delete/access/telemetry/privacy/recovery tests pass on the exact candidate.
16. Accessibility/browser/network/navigation critical-path evidence passes for activated P0 flows.
17. Cost/evaluation and cost/verified-improvement are observable without weakening the quality floor.
18. No learner-facing text promises that plan adherence guarantees an official IELTS band.

## Expanded MVP — four-skill learner solution

Expanded MVP may claim a complete IELTS-learning path only after P0 outcome evidence exists and the same semantic loop is proven across all announced skills.

Candidate scope includes:

- Listening/Reading objective practice/scoring;
- Writing;
- staged Speaking;
- target-relevant Pronunciation support where activated;
- governed Mock/Exam Simulation where scope is valid;
- cross-skill evidence/readiness;
- full minimum curriculum coverage needed by the announced path.

### Skill activation template

A new learner-facing skill/scope is not activated merely because capability IDs, content or an evaluator exist. Before build/release promotion it must define the same minimum flow depth as the Writing pilot.

```text
Entry / prerequisite
  -> task or evidence-collection surface
  -> durable learner attempt/work
  -> deterministic checks where applicable
  -> governed result/evidence state
  -> supported cause or evidence-needed
  -> ONE smallest useful intervention
  -> independent verification/retest
  -> transfer/maintenance when required
  -> evidence/readiness update
  -> Today recomputes the next decision
```

For each activated skill/scope the implementation-facing vertical slice must specify:

1. learner outcome and explicit out-of-scope behavior;
2. entry prerequisites, target/module/content eligibility and rights boundary;
3. primary surfaces and one-action navigation handoff;
4. persisted state axes versus UI-only loading/navigation states;
5. scoring/evidence scope and insufficient/invalid behavior;
6. foundation-vs-technique-vs-integrated cause behavior where meaningful;
7. minimum sufficient intervention and no-over-band constraints;
8. independent verification/retest and exposure/novelty rules;
9. back/refresh/deep-link/resume/network recovery behavior;
10. accessibility requirements for the skill-specific interaction;
11. privacy/telemetry/provider-context boundaries;
12. deterministic-first/cost/escalation behavior;
13. events/outcome measurement;
14. executable acceptance evidence and learner-meaningful exit states.

Do not create skill-specific navigation, state names or recommendation semantics that duplicate the canonical shell/domain owners. Skill slices extend the shared flow only where the modality genuinely requires it.

### Expanded-MVP launch gates

For every announced skill/scope:

1. `Diagnose → supported cause/evidence gap → intervention → independent retest → transfer/maintenance where applicable` has acceptance evidence.
2. Foundation vs IELTS-technique routing materially changes the intervention where supported.
3. Curriculum coverage exists from diagnosis to independent verification; no activated target/cause family dead-ends.
4. Objective Listening/Reading correctness stays deterministic where answer keys suffice.
5. Speaking/Pronunciation measurement uses appropriate staged/specialist evidence and passes quality/privacy/cost gates.
6. Placement/mock/readiness preserve module, score scope, exposure/novelty and insufficient-evidence behavior.
7. Planner does not over-band learners; harder content has explicit target/prerequisite/transfer justification.
8. Primary UX remains one-action-first despite expanded capability inventory.
9. Every activated skill passes the Skill Activation Template including Back/refresh/deep-link/resume and accessibility evidence.
10. Multi-skill cost, quality and verified-learning impact are measured again rather than inferred from Writing-only P0.
11. The product still makes no guaranteed official-band claim from adherence alone.

Only after these gates pass may product language describe LenBands as an end-to-end four-skill IELTS learning system.

## P1 / Version 1

Expansion is evidence-triggered, not feature-count-triggered.

Candidate additions:

- advanced `BAND.Readiness` / `BAND.ExamReadiness`;
- broader `PERSONAL.GapAnalysis`, Insights and adaptive practice;
- staged Speaking/Pronunciation/Examiner capabilities;
- full History/portfolio/compare;
- governed Exam Simulation;
- advanced content/search/notification/PKM operations;
- subscription/premium with identical semantic truth/quality floor;
- healthy motivation/reactivation;
- richer governance/drift/anti-gaming only where evidence requires it.

Rules:

- model-based recommendation requires measured benefit over deterministic policy;
- per-learner FSRS tuning requires sample sufficiency and measurable outcome benefit;
- advanced personalization may not add primary learner choices unless it improves verified outcome over the compressed path;
- generated insights/prose never become learner-state truth;
- a new permanent top-level destination requires repeated direct-entry value, not merely a new feature family.

## P2 / Version 2

Polish and scale only after the core target-to-verification system works:

- advanced analytics;
- advanced notification center/moderation;
- deeper personalization;
- additional locales;
- richer exam planning;
- operational scale controls triggered by measured volume/risk.

## Outcome-claim maturity

Product claims advance separately from feature phases.

```text
Design claim
  -> acceptance evidence
  -> closed-pilot outcome evidence
  -> multi-skill outcome evidence
  -> governed attainment/effectiveness study
  -> only then stronger effectiveness claims
```

### Always allowed when true

- describes what the system does;
- states score/evidence scope;
- states that recommendations are target/evidence-driven;
- states that improvement is verified by governed retest/transfer rules.

### Requires runtime evidence

- scoring accuracy/benchmark quality;
- learner improvement rate;
- usefulness of recommendation/cause classification;
- cost per verified improvement;
- accessibility/recovery/navigation reliability.

### Requires dedicated outcome study

- percentage of adherent learners reaching official targets;
- expected time/hours to gain a band;
- probability of official-band attainment;
- causal claim that LenBands makes learners achieve a target.

A dedicated outcome claim must specify cohort, baseline, target, adherence definition, observation window, attrition/missing-data handling, uncertainty and causal-vs-associational status.

## Release principles

- milestone/evidence-based, not calendar-based;
- capability additions never bypass the minimal learner-path invariant;
- skill activation requires an implementation-facing vertical slice following the shared template;
- breaking data semantics require migration/versioning;
- scorer/provider changes affecting evidence require benchmark/release governance even when HTTP is unchanged;
- content/taxonomy expands only when an active consumer and outcome/quality need justify the cost;
- roadmap changes may reduce scope without changing canonical capability identity.

## Phasing summary

```text
P0
  prove one Writing target→cause→action→retest loop + economics

Expanded MVP
  prove the same loop and skill-activation contract across announced IELTS skills

V1
  add mechanisms only when they improve measured learner value

V2
  scale/polish after core evidence + economics work
```
