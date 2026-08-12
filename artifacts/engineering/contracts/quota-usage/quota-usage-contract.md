# Quota & Usage Limit Contract

Canonical metadata is in `quota-usage-contract.meta.yaml`.

P0 needs a clear quota boundary because the Writing slice + experience contract both reference `quota_exceeded`. This contract decides **when the learner hits a wall, what that wall looks like, and what alternatives exist**.

## P0 quota boundary (closed pilot)

| Action | Free (closed pilot) | Premium (post-P0) |
|---|---|---|
| Writing Task 2 evaluation | **3 / day**, **10 / week** | 50 / day, unlimited / week |
| Writing draft autosave | unlimited | unlimited |
| Review card rating (FSRS) | unlimited | unlimited |
| Placement test | 1 attempt / 30 days | 1 attempt / 30 days (both) |
| Mistake Notebook | unlimited (save only) | unlimited |
| Retest | 3 / day (linked to eval quota) | 50 / day |
| Band Map view | unlimited (read) | unlimited |
| Coaching (Answer Explanation) | 10 / day (post-P0) | unlimited |

Quota = **per-user**, calculated by rolling UTC day. P0 has no payment → "premium" = founder flag (for pilot testers).

## Quota computation rule

```yaml
quota_check (before a costly action, e.g. EVAL.Writing):
  1. Resolve user plan (free | premium)
  2. Atomically reserve one slot in every applicable window using `submission_id`/idempotency key
  3. If available slot < 1 → return quota_exceeded
  4. Else → allow and retain reservation throughout the job; finalize when the action is accepted, release on terminal failure that creates no result
```

- Reservation is created before the provider call to prevent concurrent submissions exceeding the cap. Retry of the same submission reuses the reservation and does not double-count.
- `accepted` here means the domain submission was durably enqueued; provider retry does not create a new reservation. Terminal failure before an evaluation result releases the reservation under policy.
- Entitlement quota and transport rate limit are separate layers: quota determines remaining learner slots by plan/window; `runtime-baseline-config.yaml.api.rate_limits` limits burst/abuse only. A request must pass both layers; do not infer entitlement from rate limit.

## User-facing behavior (`quota_exceeded`)

According to the `p0-experience-contract.md` "paywall/quota" rule + experience anti-pattern "unexpected paywall":

```text
Trigger: learner submits Writing when count >= limit
UI state: "You have used all 3 evaluations today"
Do not:
  - Lose the draft (the draft remains intact)
  - Hide existing work (old feedback remains viewable)
  - Push upgrade modal aggressive
Provide:
  - Clear alternative: "You can still review evaluated work, fix errors, and use FSRS review"
  - Reset timing: "New attempts after 7 hours" (time-to-reset)
  - (P1) A light upgrade CTA that does not block the alternative
```

## Quota state in API

```yaml
# GET /me/quota response
{
  "plan": "free",
  "windows": {
    "writing_evaluation": {
      "daily": {"used": 2, "limit": 3, "resets_at": "2024-..."},
      "weekly": {"used": 7, "limit": 10, "resets_at": "..."}
    },
    "retest": {...}
  }
}
```

Suggested header (optional): `X-Quota-Remaining: 1` on the costly-action response.

## Events

| Event | Producer | Required properties | Rule |
|---|---|---|---|
| `quota_warning_shown` | Quota/access service | `action_type`, `remaining`, `window` | emit at most once per user/action/window presentation key; do not emit raw content |
| `quota_exceeded` | Quota/access service | `action_type`, `plan`, `window` | emit only after atomic reservation rejection; retry with the same idempotency key creates no duplicate fact |

Events use the envelope in `blueprint/03-features.md`; quota counters contain no learner content.

## Failure contract

| Failure | State |
|---|---|
| Quota exceeded | `quota_exceeded` — retain draft, show clear alternative |
| Quota service unavailable | Do not start costly action; retain draft, allow review/FSRS, and show retry — avoid exceeding the hard cost ceiling |
| Counter drift | Reconciliation job daily; drift > 5% alert |

Quota fails closed for costly actions when the service is down; the learner can still use the draft, tasks with feedback, and free review. This protects the hard cost ceiling.

## Premium upgrade (P1)

P0: manual founder flag. P1: payment flow (SUB.Payment), gate After payment confirmation → flip `plan` → apply the new quota rule.

The P0 contract does not settle payment integration — it settles only **boundary + behavior + API** so adding payment in P1 does not break it.

## Privacy

- Quota counter contains no content (counts only).
- Usage analytics are aggregate, not individual PII.

## Cross-refs

- Runtime quota: `engineering/contracts/runtime/runtime-baseline-config.yaml` (api.rate_limits).
- Experience quota rule: `experience/design/p0-experience-contract.md` (paywall rule).
- Writing slice quota: `experience/specs/vertical-slices/writing-task-2.md` §10 (Cost guardrails).
- SUB capability: `03-features.md` SUB.*.
