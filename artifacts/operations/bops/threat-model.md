# BOPS Threat & Interference Model

Status: **review**. This is a pre-code red-team contract, not evidence that the controls have been implemented.

The model treats **interference** broadly: anything that causes one authority, role, provider, retry, learning mode, data source, browser boundary, authorization signal, or document to contaminate another.

## Priority findings

| ID | Interference / threat | Failure mode | Required control | Gate |
|---|---|---|---|---|
| `RT-01` | split API authority | agents implement different paths/schemas | one canonical API owner set; retired split specs absent; zero live aliases | P0 |
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
| `RT-19` | documentation authority collision | agent selects newer/longer/stale doc | `DOCS.yaml`, one owner, zero live aliases, retired-path regression checks | P0 |
| `RT-20` | alert/provider noise | many vendor signals obscure learner-impacting incidents | symptom/SLO-oriented alerts; dedupe dependency incidents | ops |
| `RT-21` | browser credential/CSRF interference | stolen persistent bearer or forged cookie mutation changes private state | governed session storage, CSRF/origin defense, rotation/revocation, re-auth | P0 |
| `RT-22` | stored rendering injection | learner/Colab/generated content executes script or unsafe URL in browser | untrusted-data rendering, sanitization, URL allow-list, CSP | P0 |
| `RT-23` | payload/parser exhaustion | oversized/deep valid-looking request burns parser/storage/model/cost budget | transport body/depth/collection/semantic field ceilings before side effects | P0 |
| `RT-24` | readiness-scope overclaim | Writing/narrow evidence serializes as full `target_met` | require every declared TargetProfile requirement and owning readiness scope | P0 |
| `RT-25` | implementation authorization spoof | external env fields bypass family eligibility or blocking-risk gate | exact HEAD/scope + repository eligibility + blocking-risk check + external refs | P0 |

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

High-impact Admin/Colab mutations additionally require the recent-auth/step-up policy owned by `artifacts/engineering/api/access-control.md`; a role alone is not sufficient proof for a destructive/governance mutation.

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

Legacy/history search results may contain provider names, paths or version claims that look authoritative.

Controls:

1. Agent starts at `DOCS.yaml`.
2. Working tree keeps zero live legacy aliases.
3. Search result snippets are discovery only and may point at historical commits.
4. An index/README/generated catalog is never product authority.
5. Retired shadow paths are rejected by validators when split-authority risk exists.
6. Git history, not live compatibility files, is the archive for completed migrations/review packets.

### I. Browser credential theft / CSRF

Authentication transport is assumed attacker-relevant.

- application code does not persist raw bearer/refresh credentials in its own localStorage/sessionStorage/IndexedDB/URL state;
- cookie-authenticated mutations use the selected same-origin/CSRF defense and are not defended by CORS alone;
- session rotation/revocation and re-auth re-run authorization against current state;
- expired auth preserves acknowledged learner work but does not replay mutations automatically;
- recent-auth is server/provider verified, never a client boolean.

### J. Stored browser rendering injection

Writing text, fixes, feedback notes, Colab-authored content, provider-normalized strings and generated explanations are untrusted renderable data even after rights/publication/domain validation.

Controls:

- raw HTML is prohibited by default;
- Markdown/rich text uses an allowlisted maintained renderer plus sanitization;
- script-capable URL schemes and dangerous DOM sinks are rejected;
- release configuration includes a CSP with `unsafe-eval` prohibited and inline script disabled by default;
- sanitization never grants content rights, authorization or evidence validity.

### K. Payload/parser exhaustion

An authenticated request can be syntactically valid but intentionally huge/deep.

Controls execute before expensive side effects:

```text
transport byte ceiling
  -> bounded parser depth/collections
  -> schema validation
  -> semantic text/content ceiling
  -> quota/cost reservation
  -> storage/domain/inference
```

The server rejects rather than silently truncates, because truncation can change assessment/content semantics.

### L. Target-attainment scope confusion

`TargetFeasibility.target_met` is never inferred from one sampled skill or one Writing result.

- every requirement declared by TargetProfile must have enough admitted evidence under the owning readiness policy;
- a narrower per-skill requirement may be shown only as that narrower scope;
- full/overall target attainment is impossible when required skills are missing;
- closed-pilot Writing evidence cannot create four-skill/overall `target_met`.

### M. External authorization environment spoof

Environment variables are inputs, not proof by themselves.

The Claude write guard requires:

- exact repository HEAD equals authorized baseline SHA;
- P0 family and source scope are valid;
- every current pre-code family contract projection is approved/canonical;
- no unresolved `implementation_blocking` risk affects the family;
- external founder + implementation attestation refs are present;
- protected paths remain denied.

A repo file still cannot self-authorize.

## OWASP API alignment

The generated API/security test suite must explicitly cover:

- object-level authorization;
- authentication/token misuse and session fixation/revocation;
- property-level over-posting/over-sharing;
- resource/cost exhaustion including oversized/deep payloads;
- function-level authorization;
- sensitive flow abuse and recent-auth/step-up;
- stored/rendered injection at browser boundaries;
- CSRF/origin behavior for cookie-authenticated mutations where applicable;
- SSRF at provider/import boundaries;
- security misconfiguration including CSP/session policy;
- API inventory/deprecation drift;
- unsafe consumption of provider APIs.

## Red-team acceptance

Before the canonical API/BOPS boundary can be considered clean:

- one and only one canonical OpenAPI owner set resolves from `DOCS.yaml`; retired split specs are absent;
- every operation has role/persona/entitlement/data-class annotations;
- negative BOLA/BFLA matrix exists for protected operation families;
- session credential storage/rotation/revocation and cookie-CSRF/origin behavior pass the selected auth mechanism acceptance;
- recent-auth rejects stale/missing proof for destructive/governance operations;
- untrusted text/rich-content rendering passes stored-XSS/unsafe-URL/CSP checks;
- oversized/deep payloads fail before storage/inference/domain side effects while legitimate IELTS-sized input passes;
- `target_met` cannot be produced for a target whose required evidence scope is incomplete;
- evaluator fallback cannot escape an approved scorer route;
- no analytics contract accepts raw C1–C4 or credential material;
- no service/bypass credential is usable by browser code;
- all durable mutations have replay/idempotency treatment;
- published assessment/content versions are immutable references;
- active family registries contain no retired contract paths or legacy low-confidence failure semantics;
- source mutation/build commands remain locked when external authorization exists but repository family eligibility does not;
- same-head repository verification and trust-boundary checks pass.
