# Founder Decision Packet — Data Residency & OIDC Identity Provider

- **Status:** `packet` — structured options for founder review; not a decision, not a selection, not evidence.
- **Date:** 2026-08-10
- **Owner:** Founder
- **Consumed by:** architecture, engineering, business/legal, operations
- **Derived from:** `IDENTITY.Auth`, `IDENTITY.Profile`, `IDENTITY.Privacy` (P0-01); `OPS.ReleaseGate` (P0-06)
- **References:** `auth-identity-contract.md`, `identity-core-runtime.md`, `managed-platform-baseline-decision.md`, `build-buy-register.md`

## Purpose

This packet presents structured options for two interdependent founder decisions that are blocking P0-01 (Identity) readiness:

1. **Data residency stance** — where may learner personal data and assessment data reside?
2. **OIDC-compatible managed identity provider** — who authenticates the learner?

Neither decision is selected here. The packet provides criteria, tradeoffs, and a readiness checklist
for each option so the founder can choose with eyes open. No DPA, legal opinion, or approval is claimed.

---

## Decision 1: Data residency stance

### Why this matters now

Every managed provider (Neon PostgreSQL, Cloud Run, Upstash, Resend, PostHog, DeepSeek) has a
default data region. Selecting "Vietnam only" or "SG and west" before provisioning determines
which providers are eligible and which must be replaced or deferred.

| Stance | Eligible for P0 today | Cost impact | Pilot feasibility | Long-term risk |
|---|---|---|---|---|
| **A: No hard region requirement** — accept wherever the provider operates by default; review at public pilot | All selected providers | None | Simplest for closed pilot | May require data migration later if Vietnam residency becomes mandatory |
| **B: Asia-Pacific preferred** — Singapore or closer; block providers that can't meet this | Neon (SG), Cloud Run (SG available), Upstash (SG available), Resend (US-only — needs review), DeepSeek (CN/US — needs review), PostHog (US/EU) | Some providers may need plan upgrade for region pinning | Feasible with vendor review | May still need migration for VN-local requirement |
| **C: Vietnam residency required** — data must stay in Vietnam | Very few managed providers have VN region; likely requires self-hosted DB + object storage + container host in VN | Significant infra cost and ops burden | Blocks closed pilot timeline | Future-proof for VN data law |

### Founder questions to answer

1. Is Vietnam data-residency a legal requirement now, a likely future requirement, or not on the horizon?
2. Is the pilot small enough (internal + <25 learners) that personal-data volume is negligible and any region is acceptable?
3. Would "SG is close enough" satisfy the foreseeable privacy policy?
4. Is the pilot timeline more important than locking in a region now?

### Recommendation-neutral observation

Stance A is the fastest to pilot. Stance B adds a few hours of vendor-region review before
provisioning but keeps options open. Stance C effectively requires a self-hosted or VN-colocated
stack and would block the free-first managed-platform baseline. The decision should be recorded
as a one-line resolution and reviewed at the public-pilot gate.

---

## Decision 2: OIDC-compatible managed identity provider

### Required contract (from `auth-identity-contract.md`)

Whatever provider is selected must support:

- OIDC / standards-based authentication
- `iss` → allowlist per environment
- `sub` → stable opaque `subject_id` mapping
- Token validation: `aud`, `exp`, `iat`, `jti`
- Scope-based permission: `learner:read`, `learner:write`, `privacy:export`, `privacy:delete`, `admin:governance`
- Account lifecycle without LenBands storing passwords
- Provider export of user/profile mapping (for exit)
- Provider deletion API (for learner deletion requests)
- DPA or equivalent data-processing terms

### Candidates

| Candidate | OIDC | Free tier (MAU) | Region options | Exit export | Developer ergonomics | Notes |
|---|---|---|---|---|---|---|
| **Clerk** | Yes | 10,000 MAU | US/EU default; region selection on Pro ($25/mo) | User export API | Excellent; Next.js SDK, React components, webhooks | Developer-friendly; free tier includes magic link, Google OAuth, session management |
| **Firebase Auth** (Google Identity Platform) | Yes (via Identity Platform) | 50,000 MAU (standard), unlimited anonymous | Global; region selection available | Export via Firebase Admin SDK, takeout | Good; Google ecosystem | Tight Google Cloud Run integration; OIDC requires Identity Platform upgrade (free tier includes it) |
| **Auth0 by Okta** | Yes (native) | 7,500 MAU (free) | US, EU, AU, JP | User export via Management API | Good; universal SDKs | Enterprise-focused; free tier limits branding, custom domains, MFA |
| **Supabase Auth** (re-evaluation) | Yes (via GoTrue, OIDC-compatible) | 50,000 MAU (same free project) | Provider region (SG available) | SQL-level user export | Good; bundled with DB if using Supabase | Previously deprecated in Instance A because full Supabase platform replaced Neon+Cloud Run; standalone Supabase Auth evaluation is a fresh decision |
| **Stack Auth** | Yes (OIDC provider built-in) | Unlimited (open-source) | Self-hosted or managed cloud | Direct DB access for export | Good; Next.js native | Newer project; managed cloud version pricing TBD; open-source core is AGPL |

### Selection criteria (weighted by pilot needs)

| Criterion | Priority | Notes |
|---|---|---|
| OIDC-compatible | Hard requirement | Non-negotiable from architecture |
| Free tier covers pilot MAU (100–500) | Pilot budget | Closed pilot is invite-only; MAU is small |
| Google OAuth + email magic-link | P0 scope | Per scope decision; guest deferred |
| DPA available | Legal/privacy | Required before provisioning |
| User export API | Exit strategy | Required per build/buy register |
| Deletion API / workflow | Privacy compliance | Required per auth-identity-contract |
| Next.js integration | Developer speed | P0 frontend is Next.js |
| Provider region in Asia-Pacific | Data residency | Depends on Decision 1 |
| Session/refresh token management | Security | Managed by provider |

### What the Instance A deprecation means

Instance A in `build-buy-register.md §9.1` deprecated the **full Supabase platform** (Auth +
Postgres + Storage) because LenBands selected Neon + Cloud Run + R2 as the managed baseline.
This does **not** automatically exclude Supabase Auth as a **standalone OIDC identity provider**
in a fresh evaluation. However, adopting Supabase Auth alone means another vendor relationship
and credential set; the tradeoff is consolidation vs. operational simplicity.

### Founder questions to answer

1. Is "one more vendor" acceptable if the provider is clearly the best fit for P0 identity?
2. Preference between Google OAuth, email magic-link, or both for pilot?
3. How important is the identity provider's data region relative to Decision 1?
4. Is it acceptable to provision a candidate, test exit, and switch before production — i.e., treat the pilot identity provider as provisional?

---

## Activation gate checklist

Before the identity provider is considered selected (not just desk-reviewed):

- [ ] Founder records data-residency stance (A / B / C with rationale).
- [ ] Founder selects identity candidate + fallback.
- [ ] Provider DPA or terms reviewed for data use, training prohibition, and deletion.
- [ ] Provider region confirmed against residency stance.
- [ ] Export test: create user → export profile → verify → delete.
- [ ] Deletion test: create user → request deletion → verify deletion → recovery window.
- [ ] Token-validation integration test against Go API middleware (OIDC discovery, `iss` allowlist, `sub` mapping, scope).
- [ ] Provider rate limits documented; OTP/magic-link abuse guard designed.
- [ ] Magic-link email template reviewed (no AI branding, no vendor watermark where avoidable).

## After the founder decision

1. Record the decision in this packet or a follow-up ADR with date, rationale, and selected provider.
2. Update `managed-platform-baseline-decision.md §1` to replace "does **not** select an identity provider."
3. Update `build-buy-register.md` to add Instance D (identity) with `candidate`, `decision`, and `review_date`.
4. Trigger the activation gate checklist above before provisioning.

---

**Node: this packet is a review artifact, not a decision. All options are desk research. No provider pricing, DPA, or availability has been verified for procurement purposes. Re-verify at decision time.**
