---
paths:
  - "blueprint/**/*"
  - "artifacts/**/*"
  - "knowledge-assets/**/*"
---

# Knowledge convergence protocol

For every requested addition or correction:

1. Read `DOCS.yaml` first and resolve the semantic owner from its `document_id`/authority entry.
2. Classify every encountered source as canonical, transitional, historical, deprecated, projection or evidence. A non-canonical source may inform traceability but may not override its canonical owner.
3. Modify the existing owner in place. Merge duplicates; never create `enhanced`, `v2`, `final`, `complete`, `latest` or agent-specific parallel authority.
4. Preserve controlled IDs. Missing vocabulary requires an explicit reviewed disposition; do not hide unresolved semantics behind a placeholder that validators ignore.
5. Bump semantic versions/sidecars only when their governed meaning changes.
6. Regenerate projections only through registered deterministic generators.
7. Check default-context visibility and executable inbound references before demoting/deleting an old authority.
8. Run repository verification before handoff.

A deeper contract must add a machine-checkable or acceptance-relevant invariant: ownership, state transition, failure behavior, privacy boundary, precondition, acceptance criterion, dependency or traceability. More prose alone is not depth.

Knowledge Assets must retain registered provenance, rights state and integrity. Generated text, a passing validator, or a citation is not runtime/calibration evidence.
