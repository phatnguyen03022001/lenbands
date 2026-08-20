# Pre-code / implementation authorization gate

Canonical state axes live in `artifacts/operations/implementation-eligibility.yaml`. Risk classification and staged gate fields live in `artifacts/operations/problem-risk-registry.yaml`.

The current shared trust policy still has application-source mutation globally locked while the repository migrates from the historical all-application gate to family-scoped exact-SHA authorization. Therefore:

- writes under application source roots, dependency installation, code generation, runtime builds/tests, and implementation-agent delegation remain forbidden until the trust policy authorizes the exact candidate/family;
- `ACTIVE` means product scope only and cannot unlock implementation;
- repository verification, tool availability, source directories, a P0 label, or prose claiming completeness cannot unlock source mutation;
- before implementation planning, every problem category applicable to the target family must have explicit risk coverage;
- an unresolved risk with `implementation_blocking=true` keeps the family ineligible; do not hide it with local code, a prompt, a provider choice, or a fallback;
- `release_evidence_required=true` is not a circular pre-code requirement when its design contract already exists; real benchmark, legal, rights, restore, cost/outcome and usability evidence belongs to release readiness;
- `public_scale_control_required=true` is a later exposure/monetization gate and cannot be silently treated as covered by a closed pilot;
- `covered` means the control plus acceptance boundary is defined, not that runtime evidence has passed;
- future implementation authorization must be bound to one exact candidate SHA and declared implementation-family scope after eligibility is machine-evaluated;
- schema/backfill changes must follow `artifacts/engineering/data-migration-contract.yaml`;
- P0 UI/state implementation must consume `artifacts/experience/critical-path-usability-contract.yaml` rather than deferring accessibility/network semantics to post-build work;
- unresolved authority collision, required design decision, unknown controlled-vocabulary value, implementation-blocking risk, or other open HIGH/CRITICAL implementation finding keeps that family blocked.

Until `agent-trust-policy.yaml` itself is reviewed and migrated to the family-scoped authorization model, stop read-only for application-source changes and return the blockers. Do not use a historical agent/skill filename as permission.
