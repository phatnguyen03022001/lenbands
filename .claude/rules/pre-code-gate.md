# Pre-code phase gate

The active phase is read from
`artifacts/operations/agent-trust-policy.yaml` at
`application_builder.phase_gate.state`.

- `document_convergence` means all writes under `apps/**`, `services/**` and
  `engines/**`, implementation-agent delegation, dependency installation, code
  generation, build and runtime test commands are forbidden.
- Tool availability, an empty source directory, `verify` success, `gate toolchain`
  success, or prose claiming build readiness cannot unlock implementation.
- There is no pack-by-pack unlock. Unlocking requires a privileged, attested policy
  change after explicit founder authorization for the entire application and objective
  closure of the global document-completeness criteria: all 180 capabilities, roles,
  journeys, IELTS semantics, UX states, contracts, NFRs, security/privacy, accessibility,
  observability, AI governance, provider boundaries, operations and release strategy.
- Any `unknown_*`, missing mapping, duplicate/ambiguous owner, draft/review authority,
  unresolved decision or uncited external claim keeps all source workspaces locked.
- Runtime/benchmark evidence that requires code remains a post-code release gate. Never
  invent evidence to satisfy a pre-code gate.
- While locked, converge existing Blueprint and Artifact owners, preserve unresolved
  decisions explicitly, red-team them, and return protected changes as reviewable diffs.
