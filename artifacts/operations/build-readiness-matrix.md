# Build Readiness Matrix

## Purpose

This projection answers two different questions for closed-pilot P0:

1. **Implementation eligibility** — can an agent implement source without inventing unresolved behavior?
2. **Release readiness** — does the exact candidate have the runtime/legal/rights/quality evidence required for real learners?

It does not redefine product/API/risk/release authority.

## Rebaseline — 2026-08-21

Canonical design now includes:

- evidence/outcome-first semantics;
- deterministic-first execution;
- TargetProfile + planning `TargetFeasibility` with scoped `target_met` semantics;
- evidence-bound diagnosis causes: English foundation / IELTS technique / integrated performance / mixed / evidence-needed;
- one-action-first learner path;
- Today-first app shell with explicit Back/refresh/deep-link/resume/re-auth semantics;
- curriculum sufficiency + `content_gap`;
- minimum-sufficient-challenge / no-over-band routing;
- staged Writing evaluation and separate operation/result validity;
- independent retest/transfer boundary;
- browser session/credential, CSRF/origin, recent-auth/step-up and safe-rendering boundaries;
- bounded request body/depth/collections/text before storage/inference side effects;
- cost per verified improvement;
- explicit risk/data-migration/accessibility/navigation/network/recovery controls;
- honest outcome-claim policy: process guarantee, no guaranteed official band from adherence alone.

`problem-risk-registry.yaml` owns risk classification. `implementation-eligibility.yaml` owns lifecycle/authorization distinction.

## Current matrix

| Pack | Contract/design state | Implementation state | Release evidence still missing | Release state |
|---|---|---|---|---|
| `P0-01 Identity` | auth/access/privacy/retention/browser-session/re-auth/step-up + shell handoff boundaries defined | **blocked pending contract approval + verification/authorization** | provider DPA/activation, legal pilot eligibility, export/delete, access, session-security and accessibility/navigation/network acceptance | **not ready** |
| `P0-02 Diagnosis` | TargetProfile + deterministic placement + evidence coverage + diagnosis cause + scoped target feasibility + one-priority initial path defined | **blocked pending contract approval + verification/authorization** | calibration/coverage run, cause-classification usefulness/false-positive review, target-scope acceptance, rights evidence, legal pilot eligibility, accessibility/navigation/network acceptance | **not ready** |
| `P0-03 Daily action` | deterministic ranking + feasibility/cause/content coverage + one primary action + verification + no-over-band + Today-first shell + zero-LLM defined | **blocked pending contract approval + verification/authorization** | deterministic acceptance, content-gap behavior, choice-compression/navigation usability, target-scope behavior, timezone-boundary and accessibility/network runs | **not ready** |
| `P0-04 Writing evaluation` | staged scorer/runtime/API/data/failure/benchmark/support/reproducibility + contextual navigation/re-auth/request-limit/safe-rendering semantics defined | **blocked pending contract approval + verification/authorization** | rights-approved tasks, authorized corpus, benchmark slices, privacy/idempotency/evidence/dispute/browser-security/accessibility/navigation/network runs, legal pilot eligibility | **not ready** |
| `P0-05 Error-to-review` | reviewability/FSRS + cause-aware remediation + independent retest + canonical mutations + contextual handoff defined | **blocked pending contract approval + verification/authorization** | governed remediation + independent-retest coverage for activated families, API/access/idempotency/browser-rendering checks, verified-improvement and accessibility/navigation/network runs | **not ready** |
| `P0-06 Quality & economics` | release/risk/benchmark/migration/recovery/cost + learner-path/navigation/browser-security integrity controls defined | **blocked pending contract approval + verification/authorization** | real benchmark, armed cost thresholds, cost/outcome measurement, curriculum coverage, browser-security acceptance, restore drill, incident tabletop, legal pilot eligibility, rollback evidence | **not ready** |

No row becomes implementation-eligible merely because prose is coherent. Canonical contracts remain in review, exact-head verification is a separate fact, and implementation authorization is exact-SHA/family scoped.

## Implementation eligibility gate

A family becomes implementation-eligible only when:

1. canonical Blueprint/API/runtime/Artifact semantics agree;
2. applicable problem categories have explicit risk coverage;
3. no unresolved family risk has `implementation_blocking: true`;
4. owner/current pre-code contracts have required lifecycle state;
5. generated API/schema/ownership checks pass when applicable;
6. stored sensitive entities have retention mapping;
7. schema changes follow `data-migration-contract.yaml`;
8. no unresolved critical/high finding exists outside governed tracking;
9. the learner path does not require undefined cause/feasibility/content/challenge/navigation/browser-security behavior;
10. source unlock is denied unless the external exact-baseline authorization also passes the repository family-eligibility and blocking-risk guard.

Post-code benchmark/calibration/cost/outcome/restore/accessibility/legal evidence is not a circular implementation prerequisite.

## Learner-path design invariants

### P0 app shell

```text
authenticated learner
  -> Today
  -> one contextual action/session
  -> outcome / resume / evidence-needed / content-gap
  -> Today recomputes the next decision
```

Block implementation that:

- maps the capability catalog into top-level navigation;
- requires the learner to visit Progress/History/Library before receiving a next action;
- treats Back navigation as complete/abandon;
- allows refresh/deep-link/retry/re-auth to duplicate semantic effects;
- returns an accepted immutable submission to an editable pre-submit state;
- executes stale Daily Action links without revalidating current state;
- discards acknowledged work when authentication expires.

### P0-02 diagnosis

```text
TargetProfile
  + admitted evidence
  -> gap | evidence_needed
  -> supported cause
  -> TargetFeasibility
  -> one initial priority
```

Block implementation that:

- equates missing evidence with weakness;
- treats feasibility as exam-success probability;
- uses universal hours/weeks-to-band;
- assigns foundation/technique cause without evidence;
- creates a normal plan when current constraints are explicitly insufficient;
- emits overall/four-skill `target_met` from Writing-only or otherwise incomplete required target scope.

### P0-03 Daily Action

```text
target status
  -> ONE primary action
  -> Why this?
  -> Verification
  -> optional ONE lighter alternative
```

Block implementation that:

- makes the learner browse multiple competing recommendation surfaces to know what to do;
- exposes several equivalent alternatives by default;
- routes to advanced/beyond-target content without prerequisite/exam-authenticity/transfer justification;
- substitutes harder/unrelated material when curriculum/retest coverage is missing;
- auto-progresses to a higher target when `target_met`;
- treats a narrower satisfied target scope as overall IELTS attainment.

### P0-04 Writing

```text
submission lifecycle != result_validity
model candidate judgment != runtime provenance != admitted domain result
```

Block `low_confidence` workflow state, learner raw-confidence probability, unbenchmarked fallback, model-owned readiness or detector-as-cheating-proof.

Writing/browser implementation additionally blocks:

- raw persistent browser bearer storage controlled by application code;
- silent truncation of learner essay/fix input;
- unbounded request/parser payload before inference/storage;
- raw HTML or unsafe rich-text/URL rendering from learner/provider/generated content;
- auth expiry that replays submit/evaluation or loses acknowledged draft/submission state.

### P0-05 verified improvement

```text
confirmed evidence-backed error
  -> appropriate cause/remediation
  -> smallest useful intervention
  -> FSRS only when retrievable
  -> sufficiently novel retest
  -> evidence admission
  -> improved or remains active
```

Operation/activity existence is not improvement evidence.

## Release gates

Closed-pilot release additionally requires candidate-bound evidence for applicable controls:

- negative role/entitlement/function/object access;
- selected browser-session credential storage/rotation/revocation behavior;
- cookie CSRF/origin negative cases when cookie-authenticated mutation is used;
- recent-auth/step-up negative + legitimate controls for deletion/sensitive export and activated governance operations;
- authentication expiry/re-auth during resumable flow without acknowledged-work loss or mutation replay;
- idempotency/replay/network recovery;
- authenticated Today-first shell and one-action-first navigation;
- Back/refresh/deep-link/resume/accepted-submission/unsaved-work navigation integrity;
- mobile/desktop destination hierarchy consistency;
- transport byte/depth/collection/semantic-field limits reject pathological payloads while accepting legitimate IELTS-sized input;
- stored-XSS/unsafe-URL/sanitized-rich-text tests and release CSP smoke check;
- retention/export/delete and telemetry privacy;
- authorized rights/provenance for released content/benchmark assets;
- benchmark-approved scoring route and critical slices;
- result-validity/evidence admission;
- cause-classification usefulness/error review for activated diagnosis;
- target-feasibility copy/behavior review with zero guaranteed-attainment semantics;
- `target_met` scope tests proving incomplete required skill coverage cannot become overall target attainment;
- one-action-first usability / choice-overload acceptance;
- activated curriculum coverage from diagnosis to independent verification;
- no-over-band/challenge-fit test cases;
- accessibility critical path;
- timezone/day-boundary where applicable;
- restore/export-import drill and incident tabletop;
- migration rehearsal for material schema change;
- armed cost/quality thresholds and disable/rollback;
- closed-pilot jurisdiction/age/processing/provider decisions before real learner data.

A `covered` risk means the design/control boundary exists. It does not mean the release evidence passed.

## Complete IELTS-solution claim gate

The product must **not** claim complete end-to-end IELTS learner coverage based on Writing P0 alone.

A complete four-skill learner-solution claim requires, for every announced skill/scope:

1. diagnosis/evidence coverage;
2. foundation-vs-technique/integrated cause handling where meaningful;
3. governed intervention content;
4. independent retest/verification path;
5. transfer/maintenance policy where applicable;
6. score/readiness scope integrity, including target-met scope coverage;
7. usable one-action learner path and Today handoff;
8. skill-specific state/recovery plus Back/refresh/deep-link/resume/re-auth behavior;
9. accessibility for the modality-specific interaction;
10. browser/session/rendering/request-limit security appropriate to the modality;
11. quality/privacy/cost evidence;
12. an implementation-facing vertical slice satisfying the Roadmap Skill Activation Template.

## Outcome-claim gate

Always prohibited without dedicated outcome evidence:

- guaranteed official band from plan adherence;
- unvalidated success probability;
- universal time/hours-to-band;
- causal attainment claim from engagement data alone.

A stronger attainment/effectiveness claim requires cohort, baseline, target, adherence definition, observation window, attrition/missing-data handling, uncertainty and causal/associational status.

## Cost invariant

Observe cost per accepted evaluation, primary/escalation cost, retry waste, optional feedback/content-operation cost and cost per verified improvement. A cheaper route fails when the required quality/learner-path/security floor fails.

## Update rule

- Semantic/security-boundary change can return a family to implementation review.
- Runtime/legal/rights evidence changes release readiness without redefining product semantics.
- `not run` remains truthful; intended tests do not count as evidence.
- Public-scale controls are separate from bounded closed-pilot release where policy permits.
- Host branch protection/status enforcement is external evidence; repository policy/CI configuration cannot self-claim it.
- This matrix reports status only; canonical owners remain in `DOCS.yaml`.
