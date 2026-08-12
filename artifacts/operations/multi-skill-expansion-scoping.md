# Multi-skill Expansion Scoping Proposal

## Purpose

Proposes conditions for expanding the closed pilot from Writing Task 2 to Listening, Reading, and Speaking. This is a `review` proposal; it does not change P0 scope or promote capabilities outside the matrix.

## Scope unlock conditions

- Closed pilot P0-01 → P0-06 has readiness/evidence under the release gate.
- The Writing loop has enough retest gain, error recurrence, and helpfulness evidence to avoid inferring from completion.
- Each new skill has controlled coverage `skill × question_type × learning_band_bucket`; the Knowledge Asset target range uses its own `band_range`, rights gate, calibration status, and failure/recovery contract.
- A multi-skill cost/quality benchmark runs separately; do not reuse a Writing-only threshold.
- The founder decides through an Artifact decision with evidence and updates the Build Readiness Matrix.

## Deferred scope

Listening, Reading, Speaking, Pronunciation, Mock Test, and Exam Readiness remain deferred under `blueprint/08-roadmap.md`. This proposal does not create assets or build-ready contracts for those scopes.

## Required evidence before a decision

- A skill-specific gold/regression corpus with rights/provenance.
- An acceptance run for the outcome loop `Understand → Practice → Retest → Confirm`.
- Cost, latency, fallback, and quality comparison with the P0 baseline.
- Privacy/redaction and content-availability checks.

## References

- `blueprint/08-roadmap.md` — roadmap and expanded-MVP gates.
- `artifacts/operations/build-readiness-matrix.md` — P0 readiness projection.
- `artifacts/operations/release-gate.md` — release conditions.
