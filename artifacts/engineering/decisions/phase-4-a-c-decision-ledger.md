# Phase 4 A–C Decision Ledger

- **Status:** `review` — coordination projection of the Phase 4 proposal
- **Authority:** `artifacts/engineering/contracts/phase-4-target-learning-architecture-proposal.md`
- **Adoption status:** `proposal`
- **Protected mutation:** none

This ledger records founder-directed directions and engineering/source blockers. It does not
mark a direction `founder_approved` because no separate in-repository founder authority record
supports that status. Protected application still requires the authority-owner workflow,
attestation, CODEOWNERS review, and regenerated projections.

Every ledger group carries the following synthesis controls:

- `dependencies:` current canonical owner, founder packet, and any required external source or
  evidence packet named in the row.
- `conflicts_detected:` unresolved owner, vocabulary, scope, transport, source, or validator
  conflict is recorded as packeted—not resolved by this ledger.
- `non_claims:` every row `does_not_establish_runtime`, `does_not_establish_mastery`, and
  `does_not_expand_p0` unless a future protected packet explicitly changes scope; no row is an
  implementation-ready diff or readiness claim.

| item group | `dependencies` | `conflicts_detected` | `non_claims` |
|---|---|---|---|
| A01–A06 | exact target rows and framework owner review | no external IELTS-source dependency established by Track A; exact wording must not alter semantics | `does_not_establish_runtime`; `does_not_establish_mastery`; `does_not_expand_p0` |
| A07–A10 | current framework/auth/placement vocabularies and projection regeneration | controlled-vocabulary/state projection alignment remains protected | `does_not_establish_runtime`; `does_not_establish_mastery`; `does_not_expand_p0` |
| A11–A16 | current lifecycle, review mapping, and PD-07 packet | axis design, FSRS representation, and validator behavior remain unresolved/protected | `does_not_establish_runtime`; `does_not_establish_mastery`; `does_not_expand_p0`; `does_not_claim readiness` |
| B01–B05 | current family/lifecycle/event owners and PD packets | family, event, P0-scope, and rename conflicts are packeted, not resolved | `does_not_establish_runtime`; `does_not_establish_mastery`; `does_not_expand_p0` |
| B06–B08 | D-01/D-02/D-06 packets and current identity/planning contracts | residency/provider/transport choices remain unresolved; no vendor or endpoint is selected | `does_not_establish_runtime`; `does_not_establish_mastery`; `does_not_expand_p0` |
| C01–C02 | named official IELTS source required by Track C | exact external descriptor/source conflict remains open | `does_not_establish_runtime`; `does_not_establish_mastery`; `does_not_expand_p0` |
| C03–C10 | Phase 4 proposal, traceability proposal, and future empirical evidence | authority-layer, calibration, and construct mappings remain proposal-level | `does_not_establish_runtime`; `does_not_establish_mastery`; `does_not_expand_p0`; `does_not_claim calibration` |

| `decision_id` | `status` | `authority refs` | `blocks_adoption_of` | `does_not_block` | `protected targets` |
|---|---|---|---|---|---|
| A01–A06 | `engineering_design_required` | canonical founder index Track A; 21-diff annex categories (a) | exact framework hygiene application | Phase 4 target design | `blueprint/framework/**` |
| A07–A08 | `engineering_design_required` | `skill-questiontype-band.md:40,60`; founder index Track A | controlled-vocabulary correction and projection regeneration | target semantic model | `blueprint/framework/microskill-enum.md`, projections |
| A09–A10 | `engineering_design_required` | `auth-identity-contract.md`; `lifecycle-contract.md:153–155`; founder index Track A | manifest state alignment | target state-axis design | `artifacts/operations/capability-manifest.yaml` |
| A11 | `engineering_design_required` | founder index Track A; `lifecycle-contract.md:243–303` | separate submission/evaluation state contract | P4 conceptual boundary | capability manifest and projections |
| A12–A13 | `engineering_design_required` | founder index Track A; P0 data/lifecycle contracts | privacy class reconciliation | privacy principles in proposal | `blueprint/03-features.md` |
| A14 | `engineering_design_required` | `writing-evaluation.meta.yaml`; `interaction/writing-task-2.md`; founder index Track A | canonical interaction reference | P0 target design | family registry and generated web projection |
| A15 | `engineering_design_required` | `review-mapping.md`; founder index Track A | atomic FSRS card-kind contract | other P4 workstreams | framework review mapping and projections |
| A16 / PD-07 | `engineering_design_required` | founder index PD-07; trust policy | fail-closed validator hardening | proposal review and expected blocked P0 gate | `tools/commands/validate/documents.rb`, tests |
| B01 | `architectural_direction_proposed` | founder index PD-01; semantic normalization queue | family reservation reconciliation | phased multi-skill plan | family/lifecycle/map registries |
| B02 | `architectural_direction_proposed` | founder index PD-02; current PRACTICE.Drill/REVIEW.ErrorToReview mapping | review-loop ID migration | P0 unchanged | Blueprint capability identity, registries, APIs/events/projections |
| B03 | `architectural_direction_proposed` | founder index PD-04; lifecycle contract | family ownership reconciliation | audit-policy design | family/map/lifecycle registries |
| B04a | `architectural_direction_proposed` | founder index PD-05; lifecycle/transport rows | OPS.ContentQuality P0 scope reconciliation | target governance boundary | lifecycle and transport classification |
| B04b | `architectural_direction_proposed` | founder index PD-05/B3-3; event ownership | P0-06 anti-gaming scope reconciliation | event-owner design | manifest and event registry |
| B05 | `engineering_design_required` | founder index PD-06; event schema/ownership/lifecycle contracts | canonical event authority | typed evidence design | event pack, ownership registry, lifecycle refs |
| B06 / D-01 | `external_evidence_required` | D-01 packet §1; canonical founder index | residency and data-location policy | P4 semantics and P0 scope | provider topology/policy contracts |
| B07 / D-02 | `engineering_design_required` | D-02 packet §2; auth identity contract | provider activation | provider-neutral identity boundary | auth/API/runtime contracts |
| B08 / D-06 | `engineering_design_required` | D-06 packet; daily-action contract | CheckIn transport/schema | CheckIn target flow | OpenAPI/manifest/transport projections |
| C01–C02 | `external_evidence_required` | founder index Track C; 21-diff annex Batch 1 | official-source-dependent framework correction | all proposal-only architecture | `blueprint/framework/band-descriptor-map.md` |
| C03–C09 | `architectural_direction_proposed` | Phase 4 proposal §§1–6; ontology/traceability proposals | adoption of target semantic boundaries | P0 unchanged | none at proposal stage |
| C10 | `external_evidence_required` | traceability proposal §§4,7; benchmark manifest | calibrated thresholds/probabilities | design-only proposal | benchmark/evidence/policy artifacts |

## Packet handoff

- Exact-supported A proposal references: A07/A08 replacement IDs resolve; A14 canonical interaction
  reference exists; A09/A10 canonical state owners are identified; A12/A13 exact privacy
  targets are recorded in the founder packet.
- A01–A06 have no external IELTS-source dependency established by the track evidence; their
  dependency is exact-target/no-semantic-change review only. C01/C02 remain the official-source
  blockers.
- Design-gated A references: A01–A06 exact hygiene review, A11 axis split, A15 atomic FSRS
  representation, and A16/PD-07 protected validator patch.
- B02 requires old/new ID, alias/deprecation, migration version, regenerated projections,
  analytics/event/API compatibility, and rollback semantics before protected application.
- B06 must not select D-01 packet A/B/C or any provider. B07 must not select an OIDC vendor.
- B08 must not invent an endpoint or schema. P0 stays unchanged until the D-06 engineering
  packet resolves the transport boundary.

## Literal run boundary

The package is **proposal-only / no protected mutation / no runtime or readiness claim**. It is
not an implementation-ready protected diff set.
