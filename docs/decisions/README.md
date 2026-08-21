# LenBands Decision Library

STATUS: SUPPORTING
ROLE: DECISION HISTORY AND NAVIGATION
AUTHORITY: NONE

This library extracts and normalizes LenBands decision history into a stable, human-readable structure. It does **not** replace `DOCS.yaml`, Blueprint owners, contracts, policies, or other canonical repository authorities.

## Read this first

Use this library to answer:

- What did the founder choose?
- Why was it chosen?
- Which historical choice was later superseded?
- Which repository-level engineering or sourcing decision changed implementation direction?
- Where is the original source?

Do **not** use this library to infer that a provider is activated, a runtime is production-ready, a policy is calibrated, or a historical A1 decision is automatically current A0 authority.

## Structure

```text
docs/decisions/
├── README.md
├── founder/
│   ├── platform-and-reliability.md
│   ├── identity-privacy-and-access.md
│   ├── ai-evaluation-and-cost.md
│   ├── product-and-requirements.md
│   ├── learning-interventions.md
│   ├── evidence-and-readiness.md
│   ├── learner-experience.md
│   ├── economics-and-entitlements.md
│   ├── coverage-and-support.md
│   └── content-rights-and-provenance.md
├── repository/
│   ├── architecture-and-governance.md
│   ├── platform-sourcing.md
│   └── speech-processing.md
└── sources.md
```

## Founder decisions

The founder register contains exactly **325 locked decision rows**. This library preserves every stable founder decision ID exactly once and reorganizes them by durable concern rather than by historical interview/phase order.

| Normalized owner | Legacy decision ranges | Rows |
|---|---|---:|
| `founder/platform-and-reliability.md` | V1, V2, V5, V7, V8 | 64 |
| `founder/identity-privacy-and-access.md` | V3, V4 | 26 |
| `founder/ai-evaluation-and-cost.md` | V6 | 12 |
| `founder/product-and-requirements.md` | V9, 10A | 45 |
| `founder/learning-interventions.md` | 10B | 40 |
| `founder/evidence-and-readiness.md` | 10C | 54 |
| `founder/learner-experience.md` | 10D | 40 |
| `founder/economics-and-entitlements.md` | 10E | 24 |
| `founder/coverage-and-support.md` | 10F | 20 |
| **Total** |  | **325** |

The separate rights/content-sourcing decision block is normalized in `founder/content-rights-and-provenance.md`; it was not part of the 325 numbered rows.

## Repository decisions

Repository decisions are implementation/governance decisions outside the 325-row founder register. Only artifacts that actually choose a direction are normalized as decisions. Proposal queues, review packets, diff annexes, completion addenda, metadata YAML, and reconciliation working papers remain provenance and are cross-walked in `sources.md` rather than promoted into duplicate decisions.

## Status vocabulary

Use these labels in this library:

- `CURRENT_DIRECTION` — current repository direction at the extraction snapshot, while still subject to its canonical activation/governance gates.
- `FOUNDER_LOCKED` — founder-selected row preserved from the locked register; this label does not upgrade A1 to A0.
- `SUPERSEDED` — later decision explicitly replaced the earlier direction for new work.
- `HISTORICAL` — retained only for provenance.
- `PROPOSAL_ONLY` — source explicitly says it is not adopted/authorized.
- `DEFERRED` — direction intentionally postponed pending evidence/gates.

## Naming rule

Normalized filenames are lowercase kebab-case and describe durable concerns. Historical phase numbers, versions, dates, `final`, `latest`, and vendor/tool names are kept inside provenance when necessary, not encoded into the primary navigation unless the decision itself is specifically about that vendor/tool.

## Authority rule

```text
canonical repository owner
        ↓
current contract / policy / blueprint
        ↓
implementation

this decision library
= supporting history + rationale only
```

If a normalized decision conflicts with a current canonical owner, the canonical owner wins and this library must be corrected.