# Pre-code / implementation authorization gate

Canonical state axes live in `artifacts/operations/implementation-eligibility.yaml`. Problem/failure coverage and implementation-blocking risk state live in `artifacts/operations/problem-risk-registry.yaml`.

The current shared trust policy still has source mutation globally locked while the repository migrates from the historical all-application gate to family-scoped exact-SHA authorization. Therefore:

- writes under application source roots, dependency installation, code generation, runtime builds/tests, and implementation-agent delegation remain forbidden now;
- `ACTIVE` means product scope only and cannot unlock implementation;
- repository verification, tool availability, source directories, a P0 label, or prose claiming completeness cannot unlock source mutation;
- before implementation planning, every problem category applicable to the target family must have explicit risk coverage;
- any P0 `critical`/`high` risk marked `open` or `partial` with `implementation_blocking=true` keeps the family ineligible; do not hide the blocker with local code, a prompt, or a fallback;
- `covered` means the control/acceptance boundary is defined, not that runtime evidence already exists;
- runtime evidence that requires code is a later release/readiness concern and must not be fabricated as a pre-code prerequisite;
- future authorization must be bound to one exact candidate SHA and declared implementation-family scope after eligibility is machine-evaluated;
- one family may eventually become eligible without forcing every future capability/family to be implementation-complete;
- unresolved authority collision, required decision, unknown controlled-vocabulary value, blocking problem risk, or other open HIGH/CRITICAL finding for the target family keeps that family blocked.

Until `agent-trust-policy.yaml` itself is reviewed and migrated to the family-scoped authorization model, stop read-only and return the blockers. Do not use a historical agent/skill filename as permission.
