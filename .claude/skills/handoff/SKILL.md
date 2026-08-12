---
name: handoff
description: Run the mandatory LenBands validation and gate sequence and return a truthful bounded handoff. Invoke explicitly before ending a substantial task.
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash
---

# Verified handoff

Run, in order:

1. `tools/bin/lenbands doctor`
2. `tools/bin/lenbands verify`
3. `tools/bin/lenbands gate toolchain`
4. `tools/bin/lenbands gate p0`

Exit `3` from the P0 gate is expected while evidence is missing. Report changed canonical
owners, tests run, remaining gaps and any privileged review needed. Never translate a
green repository contract into a runtime-readiness claim.
