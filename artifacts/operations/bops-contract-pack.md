# BOPS Contract Pack — Legacy Compatibility Pointer

Status: **superseded / migration-only**.

The former BOPS document mixed provider selection, dated provider properties, security policy, SLO targets and operational controls in one monolith. That made provider churn look like architecture change and created agent retrieval noise.

Current BOPS authority is deliberately split into only two documents:

- `artifacts/operations/bops/contract.yaml` — machine-readable Business/Operations/Platform/Security controls, data classes, provider boundaries and release blockers.
- `artifacts/operations/bops/threat-model.md` — red-team interference/abuse scenarios and acceptance criteria.

Provider selection/build-vs-buy is owned separately by:

- `artifacts/business/decisions/platform-sourcing.md`.

This path remains only because historical artifacts and validators may reference it. It must not receive new provider facts, SLO policy, IAM policy or architecture authority.
