# Lenbands

This repository is organized by lifecycle and responsibility, not by file type.

| Layer | Purpose | Changes when |
|---|---|---|
| `blueprint/` | Defines — SSOT, invariants, product/runtime contracts | Foundational decisions change |
| `artifacts/` | Decides, documents, proves, indexes | Research, operations, legal, or measurement changes |
| `knowledge-assets/` | Canonical learning content used to create learner experiences | Content is created, reviewed, published, or retired |

## Start here

- Product/system source of truth: [`blueprint/README.md`](blueprint/README.md)
- Operational decisions and evidence: [`artifacts/README.md`](artifacts/README.md)
- Frozen architecture and implementation invariants: [`artifacts/operations/architecture-frozen.md`](artifacts/operations/architecture-frozen.md)
- Agent workflow artifacts: [`artifacts/operations/spawn-prompts/README.md`](artifacts/operations/spawn-prompts/README.md)
- Knowledge Asset contract: [`knowledge-assets/README.md`](knowledge-assets/README.md)

## Working rule

Do not create a folder or abstraction merely to anticipate the future. Add structure when the first asset or workflow genuinely needs it.
