# Resource and Usage Rights Strategy

- **Status:** artifact policy in force
- **Owner:** Founder
- **Related decision:** `ADR-0001-repository-and-runtime-planes`
- **Related Blueprint:** `blueprint/01-product.md`, `blueprint/05-content.md`, `blueprint/08-roadmap.md`
- **Legal note:** this document is operating policy and does not replace legal advice for a jurisdiction, territory, or individual license.

## Product thesis

LenBands does not make money by copying or locking access to available third-party resources. The paid value is the system that turns knowledge into personal progress:

```text
Context → Gap analysis → Personal plan → Practice → Review → Retest → Progress evidence
```

## Resource groups

| Group | Example | Default handling | Monetization |
|---|---|---|---|
| `external_reference` | URL, DOI, RSS, API reference | Catalog/link + attribution; no default ingestion | Do not charge for a copy or link |
| `licensed_content` | Content with a written commercial license | Store license/evidence, serve within scope | May be premium if the license permits |
| `first_party` | Lesson/question owned by LenBands | Review, version, publish through asset workflow | May be used in suitable plans |
| `generated_content` | Content created and approved by a workflow | Store provenance/workflow reference, quality gate | May be used if rights/policy permit |
| `user_content` | Learner essay, recording, note | Runtime Data, private; not a Knowledge Asset | Process only under consent/plan and privacy policy |

## Non-negotiable rules

1. Unknown rights = `link_only`; do not copy, cache, transform, train, or serve.
2. “Free to access” must not be understood as “free to commercialize”. Only explicit permission/license opens commercial use, derivative use, or AI processing rights.
3. Do not use a brand, logo, or copy that makes users believe LenBands is endorsed by IELTS, Cambridge, TED, or another provider without written permission.
4. External/third-party content may become a Knowledge Asset only after rights review, evidence reference, and a manifest with `rights_status=verified`.
5. Do not train a model, create a benchmark, or use retrieval on third-party content when the license/evidence does not grant the necessary rights.
6. A takedown or license expiry must be traceable to the asset ID, version, learner exposure, and affected derived output.

## Monetization policy

### Free

- Discovery, links to lawful sources, attribution, and basic orientation.
- Some first-party practice needed for the learner to receive time-to-first-value.

### Paid

- Personal plan, adaptive routing, FSRS/review workflow, outcome analytics, and exam readiness.
- Writing, Speaking, and Pronunciation evaluation/feedback; pricing by plan or clearly defined usage quota.
- Premium Knowledge Assets only when LenBands owns them or has a commercial distribution license.

### Not charged directly

- Copies, transcripts, answer keys, audio, or derivatives of third-party content without commercial/derivative permission.
- “Official IELTS score”, official affiliation, or benefits that LenBands cannot lawfully provide.

## Intake and rights gate

```text
Research potential source
  → record external reference
  → check license/terms/rights holder
  → attach immutable evidence
  → founder approves intended use
  → create Knowledge Asset manifest
  → content quality + rights gate
  → publish or retain link-only
```

The Licensing Matrix supports baseline decisions; the asset manifest and evidence record are release authority for each individual asset.

## Required asset rights fields

`rights.origin` in this policy is a classification of the rights/authoring boundary and may be `external_reference`. It is not the Knowledge Asset sidecar's `origin.source`: the sidecar uses the narrower provenance enum `unknown | generated | first_party | licensed | public_domain`. When creating a sidecar, map the rights decision and evidence through `governance.rights_status`/evidence reference; do not copy this enum unchanged into `origin.source`.

```yaml
rights:
  origin: first_party | licensed | external_reference | generated
  provider: optional
  url: optional
  license: identifier_or_reference
  attribution: required_text_or_reference

governance:
  rights_status: unknown | link_only | pending_review | verified | expired | revoked
  evidence_refs: []
  commercial_use: prohibited | permitted | conditional
  derivative_use: prohibited | permitted | conditional
  ai_processing: prohibited | permitted | conditional
```

## Re-review conditions

Review before a license expires, a provider changes terms, a new territory/plan launches, content is used for training/evaluation, or a takedown/complaint is received.
