---
name: red-team-contract
description: Adversarially review LenBands contracts or implementation for semantic drift, ownership conflict, privacy leakage, provider coupling and unverifiable claims. Read-only.
argument-hint: "[path, P0 pack, or capability]"
context: fork
agent: red-team-reviewer
background: false
disable-model-invocation: true
allowed-tools: Read, Grep, Glob
---

# Red-team review

Review `$ARGUMENTS` against its canonical owners. Return only evidence-backed findings:

- severity and exact path;
- violated invariant/owner;
- concrete failure scenario;
- smallest correct remediation;
- whether the finding is contract, implementation or evidence work.

Check SSOT duplication, state/event classification, privacy payloads, framework IDs,
provider neutrality, approval/readiness claims and fail-open behavior. Do not edit files.
