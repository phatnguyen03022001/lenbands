---
paths:
  - "blueprint/**/*"
  - "artifacts/**/*"
  - "knowledge-assets/**/*"
---

# Knowledge convergence protocol

For every requested addition:

1. Classify it as product, IELTS framework, business/runtime contract, Knowledge Asset,
   projection, or evidence.
2. Locate the current canonical owner through README/index links and `derived_from`.
3. Modify the owner in place. Merge duplicates; never create “enhanced”, “v2”, “final”,
   “complete” or agent-specific parallel documents.
4. Preserve controlled IDs. Missing vocabulary becomes `unknown_*` plus an explicit gap.
5. Bump the owner version according to repository conventions and update its sidecar.
6. Regenerate projections only through registered generators.
7. Run repository verification before handoff.

## Depth quality

A deeper section must add testable value: invariant, precondition, ownership, state
transition, failure behavior, privacy boundary, acceptance criterion, dependency or
traceability. More prose without one of these is not increased depth.

Do not duplicate the same fact across layers. A consumer references its owner. When two
owners appear to conflict, stop and report the conflict rather than choosing silently.

Knowledge Assets must use the registered spawn workflow, controlled vocabulary,
lineage, integrity checksum and rights-review state. Generated text is never evidence.
