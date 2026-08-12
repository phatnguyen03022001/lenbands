# Workflow governance Founder–Agent

- **Status:** active
- **Owner:** Founder
- **Purpose:** allow agents to accelerate work without creating unreviewed canonical content, legal claims, or a hidden source of truth.

## Authority boundary

| Action | Agent | Founder |
|---|---|---|
| Draft research, artifact, schema, or content candidate | May do | Review when it affects a decision |
| Create Knowledge Asset `draft` + manifest | May do | May review before promotion |
| Mark rights `verified`, approve a license, publish an asset | Proposal only | Approval required |
| Change a Blueprint invariant or accepted ADR | Proposal only | Approval required |
| Create an evidence snapshot/hash | May do | Review relevance to use/approval |
| Generate a catalog projection | May do | No review needed if source and schema are unchanged |

## Required records

### For decisions

- decision ID, owner, date, status, context, alternatives, consequences, and review trigger.

### For evidence

- evidence ID, origin URL/source, retrieval timestamp, hash, storage path, and the decision/asset it supports.

### For Knowledge Assets

- `asset_id`, version, type, status, rights/provenance fields, quality review state, and transformation/workflow reference.

## Agent workflow

```text
Agent drafts research or a proposal
  → creates/references an Artifact
  → attaches evidence when needed
  → founder approves the decision or rights use
  → agent creates/updates a draft asset through the workflow
  → validation spawn exception (at most 7 assets, gate `review`, no publish/mass spawn)
  → review gate promotes to published
  → catalog projection is regenerated
```

The validation spawn exception applies only to a run recorded in the freeze gate and workflow run record. Mass spawn requires `asset-spawn-freeze-gate` to be `approved`.

## Guardrail

- An agent must never represent external rights as `verified` without immutable evidence and founder approval.
- An agent must not manually overwrite evidence, an accepted ADR, a published asset, or generated catalog output.
- Every generated output must state the source ID, workflow ID/version, and generated timestamp.
- If a task conflicts with the Blueprint, an Artifact decision, and runtime behavior, stop and create a decision proposal rather than choosing silently.
