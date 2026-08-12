---
name: deepen-contract
description: Deepen an existing LenBands artifact contract with testable invariants, ownership, states, failures, privacy and acceptance criteria. Use when a contract or specification is shallow or incomplete.
argument-hint: "[artifact path or capability ID]"
allowed-tools: Read, Grep, Glob, Edit, Write, Bash
paths:
  - "artifacts/**/*"
---

# Deepen an existing contract

1. Run `tools/bin/lenbands context` and resolve `$ARGUMENTS` to one canonical owner.
2. Read its sidecar, capability/family references and directly adjacent contracts.
3. Report duplicate/conflicting owners before editing.
4. Add only testable depth: invariants, preconditions, ownership, state transitions,
   failure behavior, privacy, observability, acceptance and traceability.
5. Reference existing domain/runtime framework decisions; do not reimplement them.
6. Preserve status unless approval evidence exists. Bump the artifact patch version and
   sidecar timestamps according to repository convention.
7. Run `tools/bin/lenbands verify` and report unresolved gaps separately.

Do not create a parallel contract, new capability, approval, benchmark or evidence.
