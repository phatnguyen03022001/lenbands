# Pre-code / implementation authorization gate

Canonical state axes live in `artifacts/operations/implementation-eligibility.yaml`.

The current shared trust policy still has source mutation globally locked while the repository migrates from the historical all-application gate to family-scoped exact-SHA authorization. Therefore:

- writes under application source roots, dependency installation, code generation, runtime builds/tests, and implementation-agent delegation remain forbidden now;
- `ACTIVE` means product scope only and cannot unlock implementation;
- repository verification, tool availability, source directories, a P0 label, or prose claiming completeness cannot unlock source mutation;
- runtime evidence is a release/readiness concern and must not be fabricated as a pre-code prerequisite;
- future authorization must be bound to one exact candidate SHA and declared implementation-family scope after eligibility is machine-evaluated;
- one family may eventually become eligible without forcing all 180 capabilities or every future family to be implementation-complete;
- any unresolved authority collision, required decision, unknown controlled-vocabulary value, or open HIGH/CRITICAL finding for the target family keeps that family blocked.

Until `agent-trust-policy.yaml` itself is reviewed and migrated to the family-scoped authorization model, stop read-only and return the blockers. Do not use a historical agent/skill filename as permission.
