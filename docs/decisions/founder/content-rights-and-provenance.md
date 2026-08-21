# Content Rights and Provenance Decisions

STATUS: SUPPORTING
ROLE: FOUNDER DECISION HISTORY
AUTHORITY: NONE

This file normalizes the separate content-rights and commercial-curriculum decision block from the founder register. These decisions were outside the 325 numbered V1–10F rows.

## Spotify

**Decision:** Remove Spotify from the LenBands core/integrated content strategy.

**Rationale:** Commercial/platform/minor/AI-ingestion restrictions add product risk without unique enough learning value to justify the dependency.

## Rights-first content factory

The selected flow is:

```text
rights-cleared factual/reference source
        ↓
FactBundle / source provenance
        ↓
original LenBands asset generation
        ↓
similarity + factuality + rights QA
        ↓
versioned commercial asset
```

Two negative rules are explicit:

- “free to access” does not mean commercially reusable;
- AI paraphrasing is not a rights-clearing mechanism.

## Rights classes

| Class | Default handling |
|---|---|
| `GREEN` | LenBands-owned, CC0, verified public domain, CC BY, or explicit commercial licence; still enforce attribution/other terms. |
| `AMBER` | CC BY-SA, mixed/uncertain rights, publicity/trademark/person issues, jurisdiction uncertainty; require review. |
| `RED` | Non-commercial licences, restricted IELTS practice, TED/restricted content without permission, random YouTube transcripts, copyrighted/paywalled works without rights; do not use as paid generation seed. |

## Authority separation

```text
Official IELTS
→ construct/task/criteria reference

Open / licensed sources
→ factual/media substrate

AI
→ generation/adaptation tool

LenBands evidence + rights review
→ product admission / validation
```

External popularity does not become rights authority or curriculum truth.

## Provenance implications

The rights-first direction requires content to remain traceable to source/rights evidence. Later content/runtime contracts may refine the machine-readable provenance shape; this supporting history does not invent a second canonical provenance schema.

## Traceability

Original source: `artifacts/operations/decisions/lenbands-decision-register-v1.0.0-founder-locked-2026-08-12.md`, section `V6.7 Content Rights / Commercial Curriculum`.

Current rights, privacy, licensing, and publication policies remain the operational authority.