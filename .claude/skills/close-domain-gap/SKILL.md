---
name: close-domain-gap
description: Investigate a declared LenBands domain automation gap, deepen its canonical owners, and produce a reviewable closure assessment without changing protected readiness or gap authority.
argument-hint: "[domain and gap ID]"
allowed-tools: Read, Grep, Glob, Edit, Write, Bash
---

# Close a domain gap without falsifying closure

1. Find `$ARGUMENTS` in `domain-automation-contract.yaml` or the current context output.
2. Classify it as knowledge, contract, implementation, rights, calibration, benchmark,
   runtime acceptance or founder-decision work.
3. Identify the existing editable owner. If only a protected authority can change, stop
   with a precise privileged-change proposal.
4. Deepen editable owners and tests; use `unknown_*` for missing controlled vocabulary.
5. Never remove the declared gap or change readiness. Report whether closure is:
   `not_addressed`, `contract_candidate`, `implementation_needed`, or `evidence_needed`.
6. Run repository verification.
