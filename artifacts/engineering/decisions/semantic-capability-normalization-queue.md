# Semantic Capability Normalization Queue

## Purpose and boundary

This is a non-authoritative review queue for ambiguities in the 180-capability model. It does not modify the lifecycle registry, family registry/map, Blueprint, framework, transport classification, or any runtime contract.

The queue distinguishes six different conditions which must not be “fixed” by adding or renaming capabilities without evidence:

| Finding type | Question to resolve |
|---|---|
| `identity_collision` | Are two capability IDs genuinely the same product promise? |
| `ownership_overlap` | Do two capabilities claim the same responsibility or merely expose different surfaces? |
| `boundary_ambiguity` | Where does one responsibility stop and the other start? |
| `granularity_mismatch` | Are domain/service/use-case/operation scopes mixed without an explicit rule? |
| `family_anomaly` | Is a family mapping intentional, temporary, or semantically wrong? |
| `missing_semantic_contract` | Does a valid capability identity lack enough contract evidence to distinguish its responsibility? |

The Lifecycle Registry remains scoped to lifecycle, phase, family assignment and owner-spec reference. Semantic meaning belongs in Blueprint and approved implementation/runtime contracts; this queue only prepares decisions against those owners.

`Capability / family refs` is intentionally mixed: each reference must be resolved against the canonical capability registry or the canonical family registry as applicable. This queue does not infer a capability from a family name, or a family from a capability name.

## Admission rule

A queue item requires file-proven evidence from at least two relevant canonical/implementation owners. It must state alternatives and consequences, but cannot:

- create a new capability ID;
- rename/remap an existing capability;
- decide that a family is wrong merely because its name is surprising;
- treat a PLANNED capability with no owner spec as an implementation defect;
- claim learner/runtime readiness.

If a resolution changes a protected file, it needs the normal external CODEOWNERS review and attestation. Existing founder/engineering packets remain canonical for their decisions; this document is only a triage projection.

## Current queue

| ID | Type | Capability / family refs | File-proven evidence | Open interpretation; no resolution yet | Existing decision pointer |
|---|---|---|---|---|---|
| `SC-01` | `family_anomaly` | `SPEAKING.Practice`, `LEARN.Speaking`, `EVAL.Speaking`, `EVAL.Examiner` | Lifecycle/family projections show 26 defined families but the semantic snapshot reaches 25; `SPEAKING.Practice` has no mapped capability while the three speaking IDs map to `SPEAKING.Evaluation`. | Keep the unused family as a future boundary; remap the speaking capabilities; or retire/rename the unused family through a protected migration. | PD-01 / B4-2 require current-state review. |
| `SC-02` | `family_anomaly` | `PRACTICE.Drill`, `PRACTICE.Set`, `PRACTICE.Timed`, `PRACTICE.Adaptive` | P0 `PRACTICE.Drill` is in `REVIEW.ErrorToReview`; planned practice capabilities belong to a family also named `PRACTICE.Drill`. | P0 drill may be an Error-to-Review retest boundary while the planned family is broad practice; the same label may still be an unresolved collision. | PD-02 / B4-3. |
| `SC-03` | `boundary_ambiguity` | `ADMIN.AuditLog`, `GOVERNANCE.AuditTrail` | Blueprint lists AuditLog under system management and AuditTrail under calibration/model-version governance; neither current lifecycle row contains an explicit `does_not_own` boundary. | Separate admin-facing query/read surface from immutable governance audit records; or document a single ownership boundary and the other as a projection. | New semantic decision only if existing audit/event owners do not resolve it. |
| `SC-04` | `ownership_overlap` | `COACH.Recommendation`, `PERSONAL.Recommendation`, `PERSONAL.NextBestAction`, `BAND.RecommendedNext` | Blueprint describes coaching recommendation, recommendation engine, next action and recommended band/access as separately named capability surfaces. | They may differ by explanation, personalization, immediate action and progress projection; exact input/output/ownership boundaries are not yet documented. | Needs semantic-contract evidence before any protected change. |
| `SC-05` | `boundary_ambiguity` | `CONTENT.MockTest`, `PRACTICE.MockTest`, `PRACTICE.ExamSimulation` | Family map places all three in `MOCK.ExamSimulation`; Blueprint separately groups content management and practice/mock behavior. | Content/test-form ownership, learner execution, and exam-mode state may be valid separate responsibilities; boundary is not yet explicit. | No decision packet assigned. |
| `SC-06` | `boundary_ambiguity` | `CONTENT.Knowledge`, `KA.Grammar`, `KA.Vocabulary`, `KA.Strategy`, `CONTENT.Lesson` | The framework/asset model distinguishes Knowledge Assets from content-management capabilities, but planned owner specs are absent. | Knowledge asset payload/provenance, content lifecycle, and learner lesson delivery likely differ; no duplication/merge should be inferred before P1 owner specs exist. | Deferred; not a P0 defect. |
| `SC-07` | `family_anomaly` | `LEARN.Speaking`, `EVAL.Pronunciation`, `LEARN.Pronunciation` | Lifecycle registry maps `LEARN.Speaking` to `SPEAKING.Evaluation`, and pronunciation learning/evaluation to `PRONUNCIATION.Practice`; speaking/transcription interaction spec is P1 only. | Family naming may reflect shared runtime rather than capability prefix. Resolve only with a promoted P1 runtime boundary and the speaking protected-family decision. | PD-01 / B4-2; no autonomous remap. |
| `SC-08` | `granularity_mismatch` | `EVAL.Writing`, `COACH.Tutor`, `CONTENT.Knowledge`, `KA.Collocation`, `NOTIF.QuietHours`, `SEARCH.Formula` | The catalog contains service-scale and narrow use-case-scale capabilities side-by-side. | An explicit capability-level taxonomy may improve future auditability, but introducing it now would be a schema/semantic migration, not a clerical cleanup. | Founder/architecture decision required before registry field addition. |
| `SC-09` | `missing_semantic_contract` | All PLANNED families without owner spec | The family registry has 20 PLANNED families, all with `owner_spec: null`. The lifecycle registry has 146 PLANNED capabilities; 25 point to existing ACTIVE-family owner specs and 121 have no capability-level `owner_spec`. Those pointers do not promote a PLANNED family or prove runtime readiness. | This is expected deferral, not evidence of missing capability identity. Promotion must define intent/input/output/ownership in the family runtime spec, not backfill speculative prose now. | Deferred promotion policy. |

## Resolution protocol

For an admitted item, the responsible owner must produce a small, evidence-backed decision record:

```text
capability_refs
finding_type
canonical-owner evidence
implementation/runtime evidence
alternative boundaries
chosen boundary and does_not_own rule
affected protected paths
migration and compatibility impact
validator/regression proposal
attestation requirement
```

Only after that record is approved may a protected migration alter capability/family authority. A semantic finding with no chosen boundary remains a queue item, not a defect “resolved” by prose.

## Recommended order

1. `SC-01` and `SC-02`: repair family reachability/collision facts before any broad semantic taxonomy work.
2. `SC-03` through `SC-05`: define high-value ownership boundaries that affect audit, governance, recommendations and mock experience.
3. `SC-07`: defer until the P1 speaking family decision and audio runtime promotion evidence exist.
4. `SC-06`, `SC-08`, `SC-09`: treat as P1/P2 design/promotion work, not current P0 blockers.

## References

- `artifacts/operations/architecture-frozen.md` — lifecycle/family authority and protected-change principles.
- `artifacts/operations/ssot-registry.md` — scoped registry authority.
- `artifacts/operations/capability-lifecycle-registry.yaml` — current lifecycle/family/owner-spec facts.
- `artifacts/operations/capability-family-map.yaml` and `capability-family-registry.yaml` — implementation-family resolution.
- `artifacts/operations/founder-review-packet-index.md` and `artifacts/engineering/decisions/founder-review-21-diff-annex.md` — canonical pending protected decisions/diffs.
