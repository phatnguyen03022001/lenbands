# Design

This branch contains artifacts for the product experience and presentation. It belongs to `Artifact`, not `Blueprint` or `Knowledge Asset`.

Conventions:

- Wireframes, design specs, prototypes, and UX reviews are all artifacts.
- Every design artifact must trace to at least one Capability ID.
- `type` describes the representation; `version` is metadata; `path` organizes files.
- `artifact_id` is not needed until an artifact is an independent reference target.

## Design order

```text
Information Architecture
        ↓
Navigation Model
        ↓
P0 Experience Contract
        ↓
Navigation Shell
        ↓
Journey Wireframes
```

Navigation is locked in one shared place so journeys do not redraw the header/sidebar independently.

`p0-experience-contract.md` is the primary behavior handoff for the closed pilot. A wireframe must not independently decide states, copy, recovery, or retention rules that conflict with this contract.
