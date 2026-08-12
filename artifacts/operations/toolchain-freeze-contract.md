# Toolchain Freeze Contract

The LenBands toolchain has two deliberately separate gates.

## 1. Toolchain contract freeze

`tools/bin/lenbands gate toolchain` proves that:

- the stable CLI, manifest, command registry and compatibility shims agree;
- generated projections have no drift;
- cross-contract ownership, event and OpenAPI mappings are internally consistent;
- document, framework and implementation-catalog validators pass.

Passing this gate freezes the automation contract surface. It does **not** approve
application contracts, content rights, model quality, cost policy, or P0 launch.

The freeze gate also validates the Business Automation Coverage contract. It does not
reward adding generic infrastructure capabilities. Repository automation is complete
only when domain ownership, IELTS semantics and evidence boundaries are machine-checked;
runtime integration is complete only at the replaceable adapter boundary.

The gate validates the agent trust policy and CI/CODEOWNERS configuration. This proves
the enforcement configuration is present and internally consistent; it does not prove
that branch protection has been activated on the hosting platform.

The Claude application-builder profile may run only reviewed, workspace-scoped native
build/test/code-generation commands. Its broader Bash permission remains subordinate to
the fail-closed PreToolUse command policy, sandbox network/filesystem boundaries and
protected-path rules. This is an implementation execution surface, not a new runtime or
domain authority.

## 2. Runtime and P0 readiness

`tools/bin/lenbands gate p0` is fail-closed. It requires all P0 packs to be ready,
acceptance packs to have passed evidence, the gold corpus to have verified rights and
labels, and the numeric threshold policy to be armed and approved.

`tools/bin/lenbands gate repository` additionally requires the declared application
dependency manifests. Missing implementation or evidence is a blocker, never a
successful validation message.

## Change control

Toolchain contract changes require a semantic toolchain version bump, manifest and
CLI updates, compatibility coverage, and a passing toolchain gate. Runtime readiness
can change only from immutable evidence and explicit approval records; validators do
not promote it.
