# Error-to-Review Failure Contract

Canonical metadata is in `failure-contract.meta.yaml`.

This file maps P0-05 domain failures to learner-safe recovery. Technical failure codes remain governed by the canonical runtime failure taxonomy; this file does not invent a competing registry.

| Condition | Learner-facing behavior | Recovery / invariant |
|---|---|---|
| Save confirmed error network failure | `Saving locally` / retry state | preserve learner action; idempotent sync |
| Source finding/evidence no longer admissible | explain that the item cannot be saved as a learning error | no fake error/card; retain original evaluation |
| Error taxonomy mapping unresolved | show finding as informational or request another action | keep `unknown_error`; do not invent ID |
| Remediation asset unavailable | `Practice unavailable right now` | keep error open; offer another valid action |
| Error is not FSRS-reviewable | no failure copy required | skip card and continue appropriate fix/retest path |
| Review rating save failure | `Unable to save review` | retry idempotently; preserve prior canonical card state |
| FSRS calculation/library failure | `Review schedule unavailable` | preserve card/rating intent; bounded deterministic recovery; do not silently fabricate mastery |
| No eligible novel retest content | explain that a fresh verification task is unavailable | keep error active; do not reuse exposed source as proof |
| Retest submit network failure | `Unable to submit retest` | preserve text; same idempotency key |
| Retest quota unavailable | explain evaluation allowance | preserve fix/review state; no provider call before quota reservation |
| Retest evaluation delayed | `Evaluation is taking longer` | preserve submission; leave/revisit safely |
| No approved scorer route | `Evaluation unavailable right now` | retain retest; no unbenchmarked fallback |
| Retest result limited/insufficient evidence | explain that more/fresh evidence is needed | remain active; do not resolve error |
| Retest integrity review | neutral action-required/resubmission guidance | detector output alone cannot accuse learner or resolve state |
| Source task retired | historical error remains viewable by reference policy | choose eligible new retest/remediation content or keep active |

## Retry / idempotency

- Save error: stable mutation idempotency key; duplicate creates at most one `LearningError`.
- Review rating: canonical review item/version + idempotency contract; duplicate does not create two histories.
- Fix evidence: stable mutation key; preserve learner-authored content on retry.
- Retest submission: same durable/idempotent Writing submission semantics as P0-04.
- Retry belongs to one runtime layer; nested provider/domain retries must not multiply cost.

## Result semantics

Do not model these as transport failures:

- `limited_evidence`;
- `insufficient_evidence`;
- `integrity_review`.

They are result-validity/evidence states and use learner-safe explanation + next action. Queue/provider lifecycle remains separate.

## FSRS boundary

No-card is a valid domain outcome, not a failure. Broad Writing criteria are not forced into FSRS merely to keep the loop uniform.

If the FSRS implementation fails, preserve the remediation/error state. Do not replace the schedule with an arbitrary interval unless a separately governed deterministic fallback explicitly permits it.

## Novelty/exposure boundary

A familiar/revealed retest is not a technical failure; it is **ineligible independent evidence**. The system may allow it as practice but must not resolve the error as transfer/improvement through that attempt alone.

## Privacy

User-facing errors and telemetry must not expose:

- raw essay/fix/retest text;
- provider names/payloads;
- hidden reasoning;
- security/internal IDs beyond safe request/reference IDs.

## Cross-references

- canonical runtime failure registry/taxonomy;
- `blueprint/06-engines.md`;
- sibling `data-contract.md` / `event-contract.md`;
- Writing P0 runtime/evaluation contracts for retest scoring semantics.