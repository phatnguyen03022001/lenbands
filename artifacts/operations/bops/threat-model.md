# BOPS Threat & Interference Model

Status: **review**. This is a pre-code red-team contract, not evidence that the controls have been implemented.

The model treats **interference** broadly: anything that causes one authority, role, provider, retry, learning mode, data source, or document to contaminate another.

## Priority findings

| ID | Interference / threat | Failure mode | Required control | Gate |
|---|---|---|---|---|
| `RT-01` | split API authority | agents implement different paths/schemas | one canonical OpenAPI + migration-only aliases | P0 |
| `RT-02` | persona/role collision | Premium becomes a parallel role and drifts from billing | 5 personas, 3 authenticated product roles; Premium entitlement overlay | P0 |
| `RT-03` | provider sprawl | solo-founder ops burden creates configuration/security drift | consolidate commodity planes; add provider only for distinct obligation | P0 |
| `RT-04` | scorer fallback interference | outage silently changes model and learner band | scorer route allow-list; only benchmark-approved fallback | P0 |
| `RT-05` | learning/exam context leakage | hints/answers contaminate retest or mock evidence | assessment-mode provenance; clean context boundary; item-exposure tracking | P0 |
| `RT-06` | repeated-item contamination | familiarity is mistaken for skill transfer | independent-evidence and novel-transfer rules | P0 |
| `RT-07` | prompt injection in learner content | essay/text tries to alter scorer/system/tool policy | treat learner content as untrusted data; no tools/secrets from evaluator prompt | P0 |
| `RT-08` | retry duplication | duplicate evaluation, charge, review card, publication | idempotency keys + unique domain constraints + durable step state | P0 |
| `RT-09` | webhook disorder | duplicated/out-of-order billing event corrupts entitlement | verify signature; dedupe event ID; use occurred_at; reconcile | monetization |
| `RT-10` | elevated DB credential leakage | browser bypasses RLS and exposes all learner data | service/bypass keys server-only; application auth before elevated query | P0 |
| `RT-11` | BOLA | learner guesses another learner's resource ID | server ownership check + RLS + negative generated tests | P0 |
| `RT-12` | BFLA | learner/Colab calls Admin function | operation role policy + server enforcement + negative tests | P0 |
| `RT-13` | analytics contamination | raw essay/audio/PII enters analytics/session replay | C5-only analytics, property allow-list, assessment replay disabled | P0 |
| `RT-14` | mutable-content race | a published task changes after evaluation and destroys reproducibility | immutable/versioned published task references | P0 |
| `RT-15` | stale entitlement cache | canceled user retains Premium or paid user loses it | provider-neutral ledger, short-lived derived cache, webhook + reconciliation | monetization |
| `RT-16` | unsafe provider consumption | compromised/malformed external API response enters domain | schema validation, timeout, allow-list, SSRF-safe URLs, normalization | P0 |
| `RT-17` | adaptive tunnel vision | one observed weakness monopolizes learner plan | coverage/exploration guard + uncertainty tracking | P0 |
| `RT-18` | feedback overload | long feedback reduces action/transfer | mode-specific progressive feedback; measure retest/transfer not text length | P0 |
| `RT-19` | documentation authority collision | agent selects newer/longer/stale doc | `DOCS.yaml`, one owner, stable document IDs, alias expiry | P0 |
| `RT-20` | alert/provider noise | many vendor signals obscure learner-impacting incidents | symptom/SLO-oriented alerts; dedupe dependency incidents | ops |

## Detailed red-team scenarios

### A. Evaluation route poisoning

**Attack/failure:** a gateway fallback selects a cheaper or newly available model after the benchmarked scorer provider fails.

**Impact:** the API still returns a plausible band, but score meaning changed without rubric/release evidence.

**Control:**

```text
scorer_route_version
  -> allowed model/provider pair(s)
  -> same rubric/prompt contract
  -> benchmark gate
  -> production allow-list
```

No allowed route available → `delayed`/`unavailable`; never an unbenchmarked score.

### B. Prompt injection through assessed work

Learner essays, speaking transcripts, imported text, and content-source text are **data**, even when they contain instructions such as “ignore the rubric” or “call this URL”.

Evaluator execution:

- no arbitrary tools;
- no secret or environment access;
- no provider selection controlled by learner text;
- structured schema output;
- evidence references point only to the assessed artifact;
- system/rubric instructions are separated from untrusted content;
- generated external URLs are never fetched by the scoring path.

### C. Cross-mode leakage

Learn mode may reveal hints/solutions. Retest/exam mode may not inherit:

- prior answer text;
- prior explanation;
- rubric coaching generated specifically for that item;
- hidden correctness labels.

Only policy-approved learner-history features that do not reveal the answer may enter the retest/exam context. Prior item exposure remains attached as provenance so repeated success is not counted as independent transfer evidence.

### D. Colab-to-learner boundary

A content author can publish a task but cannot query “who failed my task” at raw learner level. Learner reports shown to Colab are minimal content-quality reports with unnecessary account/assessment fields removed.

### E. Admin boundary

Ordinary Admin can observe aggregate evaluation governance and operate account state but cannot type a replacement band into a learner result. Corrections occur through versioned evaluator/policy reruns and immutable audit, not manual mutation.

### F. Billing entitlement disorder

Provider webhooks are assumed at-least-once and potentially out of order.

- signature verified over raw request;
- event ID has a unique deduplication record;
- provider event timestamp drives ordering;
- local subscription data is a cache/ledger, not independent billing truth;
- reconciliation repairs missed events;
- an old event cannot overwrite a newer known state without conflict handling.

### G. Service-role/RLS bypass

Managed DB elevated keys may bypass row policies. Every elevated request therefore carries:

`principal -> operationId -> role/entitlement -> object scope -> SQL/storage action`.

A generic “server is trusted” assumption is prohibited.

### H. Documentation retrieval poisoning

Legacy docs may contain provider names, paths or version claims that look authoritative.

Controls:

1. Agent starts at `DOCS.yaml`.
2. Legacy alias cannot override canonical owner.
3. Search result snippets are discovery only.
4. An index/README/generated catalog is never product authority.
5. Physical rename/delete occurs only after inbound-reference validation.

## OWASP API alignment

The generated API test suite must explicitly cover:

- object-level authorization;
- authentication/token misuse;
- property-level over-posting/over-sharing;
- resource/cost exhaustion;
- function-level authorization;
- sensitive flow abuse;
- SSRF at provider/import boundaries;
- security misconfiguration;
- API inventory/deprecation drift;
- unsafe consumption of provider APIs.

## Red-team acceptance

Before the canonical API/BOPS migration can be considered clean:

- one and only one canonical OpenAPI resolves from `DOCS.yaml`;
- every operation has role/persona/entitlement/data-class annotations;
- negative BOLA/BFLA matrix exists for protected operation families;
- evaluator fallback cannot escape an approved scorer route;
- no analytics contract accepts raw C1–C4;
- no service/bypass credential is usable by browser code;
- all durable mutations have replay/idempotency treatment;
- published assessment/content versions are immutable references;
- all legacy authority docs are explicitly migration-only or superseded;
- same-head repository verification and trust-boundary checks pass.
