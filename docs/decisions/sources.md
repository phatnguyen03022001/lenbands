# Decision Sources and Crosswalk

STATUS: SUPPORTING
ROLE: FORENSIC SOURCE INDEX
AUTHORITY: NONE

This file records where LenBands decision semantics came from and prevents packet/meta/review artifacts from being mistaken for additional independent decisions.

Extraction snapshot:

```text
branch: main
commit: 78eb3a394e975c159e2572db9d6b4b96a6b46538
```

## Classification rule

A source is normalized as a semantic decision only when it actually selects or records a direction. Files that explicitly say `proposal`, `review required`, `no decision has been made`, `projection`, `diff annex`, `queue`, `readiness assessment`, `completion addendum`, or equivalent are provenance/workflow sources, not extra decisions.

Metadata YAML accompanies its owning document and is never counted as a separate semantic decision.

## Founder source

| Source | Classification | Normalized destination |
|---|---|---|
| `artifacts/operations/decisions/lenbands-decision-register-v1.0.0-founder-locked-2026-08-12.md` | PRIMARY FOUNDER DECISION SOURCE — 325 numbered rows + separate rights block | `founder/*.md` |
| `...decision-register...meta.yaml` | metadata/provenance | not separately normalized |
| `...decision-register...reconciliation.md` | adoption/reconciliation projection over the same founder rows | source only; no duplicate rows |
| `...decision-register...reconciliation.meta.yaml` | metadata/provenance | not separately normalized |

The later Decision-to-Authority Compiler Foundation reports `Founder rows / extraction mismatches = 325 / 0`, which independently confirms the source register's row inventory. That compiler artifact is itself proposal-only and not A0 authority.

## Operations decision sources

| Source | Classification | Normalized destination |
|---|---|---|
| `artifacts/operations/decisions/ADR-0002-sole-evaluator-and-governance.md` | explicit ADR, original status `review` | `repository/architecture-and-governance.md` |
| corresponding `.meta.yaml` | metadata | not separately normalized |

## Business decision sources

| Source | Classification | Normalized destination |
|---|---|---|
| `artifacts/business/decisions/README.md` | navigation/index | source only |
| `artifacts/business/decisions/build-buy-register.md` | historical decision, explicitly superseded | `repository/platform-sourcing.md` |
| `artifacts/business/decisions/managed-platform-baseline-decision.md` | historical provider baseline, explicitly superseded | `repository/platform-sourcing.md` |
| `artifacts/business/decisions/platform-sourcing.md` | current review/founder-directed sourcing candidate for new design work | `repository/platform-sourcing.md` |
| `artifacts/business/decisions/founder-decision-packet-identity-and-residency.md` | founder decision packet / provenance input | founder identity/platform files already preserve selected rows; packet not duplicated |
| corresponding `.meta.yaml` files | metadata | not separately normalized |

## Engineering decision sources normalized as decisions

| Source | Classification | Normalized destination |
|---|---|---|
| `artifacts/engineering/decisions/ADR-0001-repository-and-runtime-planes.md` | explicit ADR, `approved` | `repository/architecture-and-governance.md` |
| `artifacts/engineering/decisions/ADR-0003-platform-boundary-and-managed-infrastructure.md` | explicit ADR, `review`, partially superseded | `repository/architecture-and-governance.md` |
| `artifacts/engineering/decisions/ADR-0004-composition-first-application-platform.md` | explicit ADR, `review`, newer direction than ADR-0003 runtime assignments | `repository/architecture-and-governance.md` |
| `artifacts/engineering/decisions/speaking-speech-processing-routing-decision.md` | explicit future speech boundary decision | `repository/speech-processing.md` |
| corresponding `.meta.yaml` files where present | metadata | not separately normalized |

## Engineering decision-directory artifacts retained as provenance, not promoted

The following decision-directory files are useful evidence, review, or proposal artifacts but do not create additional normalized semantic decisions in this library unless a separate source proves adoption:

| Source | Reason not counted as an independent decision |
|---|---|
| `phase-4-a-c-decision-ledger.md` | explicitly `review`, `proposal`, no protected mutation; records proposed directions/blockers |
| `phase-4-a-c-completion-addendum.md` | completion/review addendum rather than new decision authority |
| `founder-review-packet-index.md` | decision-review coordination/provenance index; unresolved choices are not selected decisions |
| `founder-review-21-diff-annex.md` | diff/review annex |
| `openapi-unification-review-packet.md` | review packet |
| `convergence-batch-1-protected-diffs.md` | protected-diff working packet |
| `convergence-batch-2-protected-diffs.md` | protected-diff working packet |
| `convergence-batch-3-protected-diffs.md` | protected-diff working packet |
| `convergence-batch-4-protected-diffs.md` | protected-diff working packet |
| `learning-ontology-adoption-readiness.md` | explicitly non-authoritative; status `review`; says no decision has been made |
| `claude-code-asset-factory-foundation.md` | explicitly draft/proposal-only and not authorization |
| `semantic-capability-normalization-queue.md` | normalization queue / worklist |
| `decision-to-authority-compiler-foundation.md` | proposal-only projection/closure machinery; useful extraction evidence, not A0 authority |
| `proposal-transport-classification-validator.md` | proposal by filename/status role |
| `projection-consistency-reconciliation-queue.md` | reconciliation queue |

If one of these sources is later adopted through an authoritative change, the normalized library should add the resulting semantic decision at that time rather than retroactively treating proposal text as approved history.

## Supersession crosswalk

```text
ADR-0003
  managed polyglot stack + Redis Streams P0
      │
      ├── founder V7: Postgres outbox first; do not provision Redis initially
      │
      ├── ADR-0004: composition-first; no pre-authorized Go/Python/Redis worker topology
      │
      └── platform-sourcing: consolidate commodity planes around managed candidates
```

```text
build-buy-register
      ↓ SUPERSEDED
managed-platform-baseline
      ↓ SUPERSEDED
platform-sourcing
      = current review/founder-directed candidate for new design work
```

## Extraction completeness

Founder numbered rows represented in normalized files:

```text
V1   12
V2   10
V3   10
V4   16
V5   14
V6   12
V7   12 boundary rows
V8   16
V9   30
10A  15
10B  40
10C  54
10D  40
10E  24
10F  20
---------
TOTAL 325
```

The rights/content-sourcing block is preserved separately and does not alter the 325-row total.