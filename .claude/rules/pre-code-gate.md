# Pre-code / implementation authorization gate

Canonical state axes live in `artifacts/operations/implementation-eligibility.yaml`. Risk classification and staged gate fields live in `artifacts/operations/problem-risk-registry.yaml`. Agent authorization requirements live in `artifacts/operations/agent-trust-policy.yaml`.

Repository state is fail-closed by default. Therefore:

- application source mutation, dependency installation, code generation, runtime builds/tests and implementation-agent delegation require a valid external family-scoped authorization context when the relevant tool is supported;
- `ACTIVE` means product scope only and cannot unlock implementation;
- repository verification, tool availability, source directories, a P0 label, or prose claiming completeness cannot unlock source mutation;
- before implementation planning, every problem category applicable to the target family must have explicit risk coverage;
- an unresolved risk with `implementation_blocking=true` keeps that family ineligible; do not hide it with local code, a prompt, provider choice or fallback;
- `release_evidence_required=true` is not a circular pre-code requirement when the control design exists; real benchmark, legal, rights, restore, cost/outcome and usability evidence belongs to release readiness;
- `public_scale_control_required=true` is a broader exposure/monetization gate and cannot be silently treated as covered by a bounded pilot;
- `covered` means the control plus acceptance boundary is defined, not that runtime evidence has passed;
- authorization must bind one P0 family, exact reviewed baseline SHA, approved source scope, external founder authorization reference and external authorization attestation;
- repository files cannot self-authorize and protected authority/evidence/tooling paths remain locked under implementation authorization;
- schema/backfill changes follow `artifacts/engineering/data-migration-contract.yaml`;
- P0 UI/state implementation consumes `artifacts/experience/critical-path-usability-contract.yaml` rather than deferring accessibility/network semantics to post-build work;
- unresolved authority collision, required design decision, unknown controlled-vocabulary value, implementation-blocking risk, or other open HIGH/CRITICAL implementation finding keeps that family blocked.

If no valid external implementation authorization is present, stop read-only for application-source changes and return the blockers. Do not use a historical agent/skill filename as permission.
