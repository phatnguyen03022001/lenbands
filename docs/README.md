# LenBands Documentation

STATUS: SUPPORTING
ROLE: HUMAN-READABLE DOCUMENTATION ENTRYPOINT
AUTHORITY: NONE

The repository's canonical authority continues to be defined by `DOCS.yaml` and the owner documents it registers. This `docs/` tree is for durable human-readable navigation and extracted decision history; it must not become a parallel SSOT.

## Decision history

Start at [`decisions/README.md`](decisions/README.md).

The decision library contains:

- every numbered founder decision from the locked 325-row register;
- the separate founder content-rights/provenance block;
- explicit repository ADRs and later sourcing/speech-routing decisions;
- a forensic source crosswalk showing which legacy artifacts are decisions, superseded decisions, metadata, proposals, review packets, or reconciliation material.

## Naming

Mutable human-readable docs use lowercase kebab-case. Names describe durable concerns, not chronology or workflow state.

Prefer:

```text
platform-and-reliability.md
identity-privacy-and-access.md
evidence-and-readiness.md
```

Avoid:

```text
final.md
latest.md
v2.md
new-decision.md
phase-4-final-review.md
```

Legacy IDs and dates remain inside documents for traceability rather than controlling the primary information architecture.

## Authority

```text
DOCS.yaml / canonical owner
          ↓
canonical contract / policy / blueprint
          ↓
implementation

          ─────────────

docs/
= navigation + supporting history
```

If `docs/` conflicts with a canonical owner, fix `docs/`; do not reconcile by creating another authority layer.