# Wireframes

A wireframe is an artifact describing screen structure, hierarchy, and interaction flow at low to medium fidelity. The behavior source is `../interaction-model.md`; a wireframe must not invent states or transitions.

Conventions:

- Main file: `.html`
- Metadata: `.meta.yaml`
- Traceability: always include `derived_from` pointing to a Capability ID in the Blueprint
- Do not use a manifest for an artifact; use metadata/descriptor

The `journeys/` branch contains wireframes for major learner journeys instead of one overly long aggregate file.

`full-app.html` is the aggregate screen-level wireframe for the learner MVP. `full-system-wireframe.html` is now only a legacy overview artifact for reference.
