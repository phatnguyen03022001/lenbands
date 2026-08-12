---
name: implement-p0-slice
description: Implement a bounded P0 LenBands vertical slice from its compiled capability context using mature Go, Python and Next.js dependencies through adapters.
argument-hint: "[P0-01..P0-06 or capability ID]"
allowed-tools: Read, Grep, Glob, Edit, Write, Bash
paths:
  - "apps/**/*"
  - "services/**/*"
  - "engines/**/*"
---

# Implement a P0 slice

1. Read `application_builder.phase_gate` in the agent trust policy. If its state is not
   `implementation_authorized`, stop read-only and return the document/decision blockers.
   Do not edit source, install dependencies, generate code, or delegate a runtime worker.
2. Confirm the privileged authorization globally unlocks application implementation
   after all Blueprint and Artifact completion criteria passed. There is no per-pack
   exception. Tool availability and repository verification are not authorization.
3. Run `tools/bin/lenbands capability compile $ARGUMENTS`. Stop if the global document
   gate has any unresolved capability, role, journey, IELTS semantic, interaction, API,
   data, event, failure, privacy, security, accessibility, observability, AI-governance,
   provider, operations or release-strategy criterion. Runtime evidence that can only
   exist after code is a later release gate.
4. Read only the referenced owner contracts, interaction specification and failure/event
   registries required by that slice.
5. Use the fixed workspace boundaries: `apps/web` for Next.js, `services/api` for Go,
   and `engines/evaluation` for Python. Do not create competing application roots.
6. For a cross-stack slice, the Pro main session owns decomposition and integration.
   Delegate disjoint path ownership to `nextjs-implementer`, `go-backend-implementer`
   and `python-evaluation-implementer`; use `runtime-integration-verifier` after merge.
7. Select mature dependencies already approved by the composition ADR and technology
   recommendation. Implement provider-neutral domain interfaces and thin adapters;
   never rebuild commodity infrastructure.
8. Generate contract-bound types from canonical OpenAPI where supported. Generated code
   is a projection and must not redefine product semantics.
9. Preserve privacy, idempotency, failure taxonomy and event ownership boundaries.
10. Add unit, contract and integration tests proportional to the change. Use only the
   reviewed workspace-native Bash commands exposed by the project guard; never chain
   shell commands or invoke an arbitrary interpreter to bypass it.
11. Do not mark acceptance passed or create evidence. Runtime results must later enter
   through registered evidence runners.
12. Run native tests, `tools/bin/lenbands verify`, `gate toolchain`, then `gate p0`.
    Exit 3 remains expected until genuine P0 evidence exists.
