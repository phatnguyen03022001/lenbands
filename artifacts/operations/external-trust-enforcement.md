# External Trust Enforcement

Repository validators reduce accidental bypass, but a write-capable agent shares their
trust boundary. The repository is protected only after the hosting platform enforces
the controls below on the default branch.

## Required GitHub settings

1. Require pull requests; prohibit direct pushes.
2. Require status check `LenBands Toolchain Trust / verify-trust-boundary`.
3. Require CODEOWNERS review and dismiss stale approvals after new commits.
4. Require conversation resolution.
5. Block force pushes and branch deletion.
6. Restrict bypass permission to the founder's recovery account; do not grant it to
   runtime agents, automation tokens, or ordinary maintainers.
7. Confirm the account in `.github/CODEOWNERS` is the actual repository-host account.

## Trust statement

`tools/bin/lenbands validate trust-boundary` validates repository structure, protected
change attestations and append-only evidence. It cannot activate GitHub branch settings
or prove the identity of a reviewer. Those controls are external and remain pending
until configured on the hosting platform.
