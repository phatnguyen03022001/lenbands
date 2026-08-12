# Business Decisions

Index for first-class business decisions. Each entry has one canonical owner. Decisions reference capability IDs from `blueprint/03-features.md` for traceability.

## Index

| Decision | Status | Version | Purpose | Owner | Authority boundary | References |
|---|---|---|---|---|---|---|
| `build-buy-register.md` | draft | 0.1.2 | mvp-build-buy-operating-policy | founder | Build/buy/hybrid ownership and procurement boundary for every P0 runtime boundary | managed-platform-baseline-decision.md, framework capability IDs (OPS.*, EVAL.Writing, IDENTITY.Auth, SUB.Premium, PERSONAL.NextBestAction) |
| `managed-platform-baseline-decision.md` | review (pre-code, founder-selected) | 0.1.0 | Free-first managed-platform baseline with portability and activation gates | founder | Every provider boundary; activation blocked by procurement/DPA/benchmark/release evidence | build-buy-register.md, provider-adapter-contract.md, cloud-platform-topology-contract.md, cost-budget.md, benchmark/numeric-threshold-policy.yaml |
| `founder-decision-packet-identity-and-residency.md` | packet (options, awaiting founder) | — | Structured options for data-residency stance and OIDC identity provider selection | founder | Prepares P0-01 (IDENTITY.Core) provisioning decision; does NOT make a selection | auth-identity-contract.md, identity-core-runtime.md, build-buy-register.md §9.1 Instance A |

## Dependency graph

```text
build-buy-register.md (ownership + boundary rubric)
    │
    ├── §9.1 Instance C
    │       └── managed-platform-baseline-decision.md (provider selections)
    │               ├── cost-budget.md
    │               ├── benchmark/numeric-threshold-policy.yaml
    │               ├── provider-adapter-contract.md
    │               └── cloud-platform-topology-contract.md
    │
    └── §9.1 Instance A/B
            └── deprecated_not_selected (Supabase Auth, Anthropic Sonnet 4)
```

## Procurement instances in build-buy register

| Instance | Boundary | Status |
|---|---|---|
| Instance A | identity_and_platform (Supabase Auth + managed Postgres/Storage) | `deprecated_not_selected_for_current_baseline` |
| Instance B | writing_evaluation_inference (Anthropic Sonnet 4 API) | `deprecated_not_selected_for_current_baseline` |
| Instance C | closed_pilot_managed_platform (Cloudflare + Cloud Run + Neon + Upstash + Resend/Brevo + PostHog/Sentry + DeepSeek V4) | `founder_selected_pre_code_baseline`; activation blocked by all gates |

## Decision lifecycle

- `draft`: open for review; not binding.
- `review`: content complete enough for founder audit; missing approval/evidence.
- `founder_selected_pre_code_baseline`: selected for procurement planning; no runtime activation or P0-readiness claim.
- `approved`: reviewed and cleared for downstream use (requires approval record/evidence per CONVENTION.md §6).

## Update triggers

Review each decision when:
- A provider price, DPA, or data-use policy changes materially.
- A 30-day free-tier re-check window expires.
- A procurement, DPA, benchmark, or release gate is met.
- A cost boundary exceeds its budget for two consecutive periods.
- A vendor outage repeats or provider lock-in becomes clear.

## Node: this is a projection index, not a source of truth

The canonical owners are the decision files themselves. This index may become stale; always verify against the `.meta.yaml` of each decision file.

Created from: `build-buy-register.md` and `managed-platform-baseline-decision.md` @ 2026-08-10.
