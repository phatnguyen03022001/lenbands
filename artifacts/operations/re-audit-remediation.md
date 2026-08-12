# Re-audit Remediation Ledger

## Purpose

This ledger reconciles the 2026-08-07 re-audit report with the repository after remediation. `fixed` means the invariant was corrected and a validator/projection checks it; `confirmed-existing` means the repository already has the control and must not be changed backward; `evidence-pending` means it has not been replaced with prose or an assertion; `deferred-by-scope` means it is outside P0 closed-pilot build input.

No finding in this ledger promotes an artifact to `approved`, publishes a Knowledge Asset, or replaces real founder approval/evidence.

## Confirmed and fixed

| Finding | Disposition | Repository evidence |
|---|---|---|
| Writing failure codes do not resolve to the registry | `fixed` | `runtime/failure-taxonomy-contract.md`, Writing failure contract, semantic validator |
| `review_completed` lacks a producer; `retest_started` lacks an event pack | `fixed` | Error-to-Review event contract, event schema pack |
| Quota/paywall events are not synchronized with the Blueprint | `fixed` | Blueprint canonical event table + event schema pack |
| `evaluation_state: none` is ambiguous | `fixed` | `07-conventions.md`: aggregate state vs persisted Evaluation projection |
| Grammar prerequisite leaks into `error_refs`; summary count is duplicated | `fixed` | `grammar-band-framework.md`, `validate-framework.sh` |
| `band_range` is used for two different boundaries | `fixed` | `05-content.md`, content-publish contract, Knowledge Assets README, KA validator |
| Auth/identity lacks token subject/scope/ownership semantics | `fixed-as-contract` | `auth-identity-contract.md`, identity-consent slice; provider/permission evidence remains pending |
| Runtime baseline lacks quota windows | `fixed-as-config` | `runtime-baseline-config.yaml`; numbers are policy baseline, not production evidence |
| Cost boundary IDs lacked a registry | `fixed` | `cost-budget.md` canonical boundary table |
| Error Graph lacked ownership/data meaning | `fixed-as-projection` | Error-to-Review data contract defines the graph projection; it does not create a new SSOT |
| Practice was inconsistently hidden in early mode | `fixed` | IA/navigation model renders Practice consistently; Tests remain hidden |
| Band mode was interpreted as a continuous dead zone | `fixed-as-semantics` | IA/navigation records IELTS half-band labels |
| Typo in a historical annotation and ADR status body/meta mismatch | `fixed` | Experience docs/wireframe comments, ADR-0001 |
| Catalog generated metadata was inconsistent | `fixed` | Catalog payload + sibling meta both have generation state/source/time/schema |
| Validator caught static keys but omitted semantic invariants | `fixed-partially` | `validate-semantic-contracts.sh`, framework/KA/OpenAPI validators |
| Framework bump made historical spawn evidence stale | `fixed-with-new-evidence` | framework/asset refs `1.0.6`, immutable run-007; runs 001–006 remain as history |
| Same asset id/version had different payload checksums | `fixed-forward` | four affected payloads bumped `0.1.0 → 0.1.1`; run-007 records version + checksum without changing old evidence |

## Control already exists; do not change backward

| Finding in report | Disposition | Reason |
|---|---|---|
| OpenAPI lacks feedback/quota/error/retest paths | `confirmed-existing` | OpenAPI validator requires the P0 paths and currently passes |
| OpenAPI does not represent low confidence | `confirmed-existing` | `WritingEvaluation` has `low_confidence` in evaluation state and quality status |
| SPA emits events directly | `confirmed-existing` | Event contracts require a backend producer, not an SPA |
| Retry `max_attempts: 2` vs provider attempt `1` is a contradiction | `not-a-defect` | Worker contract allows at most one provider call per worker attempt; a job allows at most two attempts |
| 10 legacy vocabulary assets lack provenance | `evidence-pending` | `unknown/pending_review` metadata is neutral; PENDING-EVIDENCE blocks publishing |
| Templates create embedded metadata | `confirmed-existing` | Templates only reference the canonical sibling sidecar |
| Catalog stub lacks meta/generator state | `confirmed-existing` | Both catalogs have sidecars and `sample_not_generated`; the missing generator is explicit |
| Framework body retains historical versions 1.0.1/1.0.2 | `not-a-drift` | This is changelog content; frontmatter `1.0.4` is the active version |
| Evidence record must hash itself | `rejected-design` | Self-hashing creates a loop; payload hashes + immutable record + approval record are the correct boundary |

## Evidence blockers that remain

The items below must intentionally not be “fixed with text”:

- real gold-standard corpus and rights/provenance;
- numeric benchmark threshold and benchmark run record;
- provider/DPA, permission/export/delete, and provider-switch exit exercises;
- rights/content review for 10 legacy assets and 7 generated draft assets;
- founder review for promotion candidates, freeze gate, and validation re-run;
- user-interview findings and outcome/acceptance run for P0 experience.

These blockers are tracked in `PENDING-EVIDENCE.md`; related artifacts remain `review`/`draft` and the P0 matrix remains `not ready`.

## Boundaries still requiring founder decisions

- `asset-spawn-freeze-gate.md` remains `review`; run-005 is only a revalidation exception and does not unlock mass spawn.
- No asset is promoted `draft → published` in this remediation.
- No artifact is promoted `review → approved` by an agent.
- P0 build-readiness changes only when founder approval and the corresponding evidence record exist.

## Validator contract

Minimum validation after each semantic change:

```text
./tools/validate-framework.sh
./tools/validate-knowledge-assets.sh
./tools/validate-semantic-contracts.sh
./tools/validate-openapi.sh
./tools/validate-documents.sh
```

The validator is a static/semantic gate, not a benchmark, legal clearance, provider run, or user-research evidence.
