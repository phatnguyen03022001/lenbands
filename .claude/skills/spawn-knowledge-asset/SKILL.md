---
name: spawn-knowledge-asset
description: Create one bounded IELTS Knowledge Asset using the registered spawn prompt, controlled vocabulary, sidecar, lineage and integrity contract.
argument-hint: "[asset kind and requested scope]"
allowed-tools: Read, Grep, Glob, Edit, Write, Bash
paths:
  - "knowledge-assets/**/*"
---

# Spawn one governed Knowledge Asset

1. Read the spawn-prompt README and registry, then select exactly one registered prompt
   matching `$ARGUMENTS`.
2. Read only its declared framework references and nodes.
3. Generate one payload and sibling sidecar under the declared `knowledge-assets/` root.
4. Use only controlled IDs. Missing vocabulary becomes `unknown_*` and blocks publish.
5. Record prompt/model/parameter lineage and calculate the payload checksum.
6. Keep status `draft`, rights `pending_review`, and content review incomplete.
7. Run knowledge-asset, spawn-prompt and full repository validation.

Generated content is not licensed, calibrated, approved or learner-servable evidence.
