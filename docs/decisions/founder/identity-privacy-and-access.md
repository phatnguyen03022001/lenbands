# Identity, Privacy, and Access Decisions

STATUS: SUPPORTING
ROLE: FOUNDER DECISION HISTORY
AUTHORITY: NONE

Source authority at lock time: `A1_FOUNDER_SELECTED_UNRECORDED`.

This file preserves founder decision IDs V3 and V4. Current implementation must still follow current canonical identity/privacy/auth contracts and activation gates.

## V3 — Identity and privacy principles

| ID | Decision | Rationale |
|---|---|---|
| V3.1 | Email/password is the main learner login; Google/Facebook optional. | Own a universal login path and avoid social-provider dependence. |
| V3.2 | Credential custody resolved later through Auth0 selection. | Managed credential handling reduces password-security burden while preserving an identity adapter boundary. |
| V3.3 | Guest trial allowed; retention/merge behavior must be subtle and research-driven. | Reduce acquisition friction without silently merging identities or manipulating retention. |
| V3.4 | User-request deletion, subject to lawful/security retention categories. | Respect deletion rights without pretending immutable/security records can always be instantly rewritten. |
| V3.5 | Full machine-readable export required. | Identity/data portability is a hard product boundary. |
| V3.6 | Derived progress/results may be retained; raw/intermediate learner content is adaptively cleaned. | Keep longitudinal learning value while minimizing unnecessary sensitive content. |
| V3.7 | Audio ephemeral-by-default; local replay/download where possible; temporary server processing/recovery; auto-delete unless separately approved. | Privacy, cost and trust improve when recording retention is not the default. |
| V3.8 | AI processor training/reuse prohibited or highly restricted by default (`training_by_processor_allowed=false`). | Learner content must not become provider training data through a default setting. |
| V3.9 | Minimal pilot analytics; no raw learner content. | Product analytics should not become a secondary content repository. |
| V3.10 | Minors are supported, triggering additional consent/privacy/legal review. | Minors change legal and product-safety constraints and cannot be treated as an adult-only afterthought. |

## V4 — Authentication and session model

| ID | Decision | Rationale |
|---|---|---|
| V4.1 | Email/password mandatory/main. | Consistent with V3 and usable without social identity. |
| V4.2 | Managed credentials via Auth0 selection. | Reduces password storage/security burden while preserving internal learner identity. |
| V4.3 | Existing valid sessions should survive temporary IdP outage where safely possible. | Avoid coupling every authenticated request to live IdP availability. |
| V4.4 | Learner session horizon ~30 days. | Balance learner convenience with revocable server-side sessions. |
| V4.5 | Logout-all-devices required. | User must be able to invalidate active refresh sessions. |
| V4.6 | Password change/compromise revokes all refresh sessions. | Credential compromise must invalidate long-lived session material. |
| V4.7 | Guest → account merge requires explicit user confirmation. | Avoid accidental identity/data merges. |
| V4.8 | Same-email identities are not auto-linked; any later linking requires explicit secure re-authentication. | Email equality is not sufficient proof of account ownership. |
| V4.9 | Unverified users may learn; sensitive features remain restricted. | Reduce onboarding friction while reserving higher-risk actions for verified accounts. |
| V4.10 | Password reset via email OTP. | Simple recovery path consistent with email/password primary auth. |
| V4.11 | Admin identity is a separate security boundary. | Privileged access should not inherit learner-account assumptions. |
| V4.12 | Learners have no mandatory MFA by default. | Avoid disproportionate friction for general learners. |
| V4.13 | Access token target ~1 hour. | Bound bearer-token lifetime without excessive refresh churn. |
| V4.14 | Opaque rotating/revocable refresh sessions, stored server-side; persist token hash, not raw refresh token. | Support device revocation and reduce secret-at-rest risk. |
| V4.15 | Learning domain references stable internal `learner_id`, not provider IDs. | Identity provider changes must not rewrite the learning domain. |
| V4.16 | Admin new/untrusted device requires email OTP confirmation. | Founder-selected low-friction step-up for new devices; does not claim email OTP is a strong independent MFA factor. |

## Traceability

Original source: `artifacts/operations/decisions/lenbands-decision-register-v1.0.0-founder-locked-2026-08-12.md`.

Later provider/sourcing artifacts may change the implementation/provider direction without changing these stable founder IDs. In particular, any legacy Auth0-specific direction must be interpreted against the current identity/provider contracts rather than treated as automatic activation authority.