---
name: implement-p0-slice
description: Deprecated compatibility skill name retained while implementation governance migrates from pack/global unlocks to family-scoped exact-SHA authorization.
argument-hint: "[implementation family ID]"
allowed-tools: Read, Grep, Glob
---

# Deprecated implementation route

This skill must not edit source, install dependencies, run code generation, or delegate a runtime implementation worker.

1. Read `DOCS.yaml` and `artifacts/operations/implementation-eligibility.yaml`.
2. Resolve the requested capability to exactly one implementation family.
3. Report the family eligibility blockers and current source-mutation state.
4. If source mutation is locked, return `implementation_authorization_missing`.
5. Do not infer authorization from P0/ACTIVE status, tool availability, a passing repository check, or the existence of this skill.
6. Once the trust-policy migration supports family-scoped exact-SHA authorization, the canonical implementation route is `runtime-composer`, not this compatibility skill.

The historical name remains only because current Claude hardening explicitly denies/recognizes it. It is not an implementation entry point.
