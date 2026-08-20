# Content Publish Contract (Colab → Published Asset)

Canonical metadata is in `data-contract.meta.yaml`.

P0 scope: Writing Task 2 prompt from Colab draft → reviewed → published → consumed by the Writing slice.

This contract owns authoring/publishing semantics for the P0 content boundary. Learner-facing HTTP payloads are owned by `artifacts/engineering/api/openapi.yaml` and `artifacts/engineering/api/schema-contract.yaml`.

## Boundary

Authoring metadata and learner-facing payloads intentionally differ.

- rights/provenance/reviewer fields stay on the authoring/governance side;
- learner API exposes only fields required to render/use the task safely;
- target-band routing is **not** a content-authoring truth;
- challenge/learning-stage metadata is optional until an active planner consumer and validation policy exist;
- a Writing Task 2 prompt is authentic task content, not a promise that it is "Band 5" or "Band 8" material.

## Lifecycle

```text
draft → in_review → published → deprecated → retired
```

- `draft`: authoring state.
- `in_review`: correctness/rights/task-type review.
- `published`: learner-eligible when all active gates pass.
- `deprecated`: historical/direct references remain valid; not selected for new work.
- `retired`: hidden from new learner selection while historical evidence keeps exact version refs.

## Entity: WritingTask (authoring side)

```yaml
task_id: string
version: integer
status: draft | in_review | published | deprecated | retired
exam_module: academic | general_training | shared
task_type: W_task2_opinion | W_task2_discussion | W_task2_advantages_disadvantages | W_task2_problem_solution | W_task2_two_part
prompt_text: string
minimum_words: 250
prompt_hash: string
rights:
  origin: first_party | licensed | generated | public_domain
  source_ref: string | null
  license_evidence_ref: string | null
  review_state: needs_review | approved | blocked
routing:
  learning_stage: foundation | developing | target | advanced | precision | null
  calibration_status: unknown | provisional | calibrated
  prerequisite_refs: []
  note: optional_routing_metadata_not_an_ielts_band_claim
tags:
  topic: []
  microskill_ref: []
colab_author_ref: string
reviewed_by_ref: string | null
reviewed_at: timestamp | null
published_at: timestamp | null
created_at: timestamp
updated_at: timestamp
```

### Routing metadata rule

`routing.learning_stage` may exist only when an active planning/content-selection consumer uses it. It is not equivalent to an IELTS band and cannot be converted into `target_band_range` by author/model judgment.

`calibration_status=calibrated` requires governed evidence. Without it, the planner uses prerequisites, TargetProfile, supported diagnosis cause, task authenticity, exposure policy and minimum-sufficient-challenge rules rather than fabricated numeric difficulty.

## Rights gate

A task cannot become `published` when:

- `rights.review_state != approved`;
- `rights.origin=licensed` and `license_evidence_ref` is missing;
- source/provenance is unclear;
- prompt reproduces protected third-party assessment material without permission;
- branding/source wording could misrepresent first-party/generated material as official IELTS/Cambridge/other third-party material.

Generated or first-party content is still reviewed for rights, correctness and misleading provenance. "Generated" does not mean automatically rights-safe or exam-authentic.

## Author → Review → Publish flow

```text
1. Author creates draft
   ↓
2. Deterministic validation
   - schema / task_type / module
   - prompt hash / duplicate check
   - required provenance fields
   ↓
3. Optional metadata suggestion
   - only fields with active consumers
   - no target-band guessing
   ↓
4. Review
   - task correctness/authenticity
   - rights/provenance
   - misleading source/trademark language
   - active routing metadata if present
   ↓
5. Publish audited immutable version
   ↓
6. Canonical Writing API serves learner projection
```

P0 does not need a complex Colab shell; one trusted operator may hold author/reviewer/publisher permissions, but each transition remains explicit and audited.

## Curriculum sufficiency integration

Publishing one prompt does not prove that a learner path is complete.

For any activated diagnosis/remediation family, the content system must separately prove governed coverage from intervention to independent verification/retest according to `blueprint/05-content.md`.

If coverage is missing, the planner returns `content_gap`; it must not:

- manufacture a task at runtime;
- reuse a revealed source prompt as independent transfer proof;
- route to harder/higher-band material merely because another suitable task is unavailable.

## Anti-patterns

- Hosting protected third-party assessment material without permission.
- Labeling a first-party/generated task as official or third-party-authored.
- Generating a random assessment task because no published task exists.
- Publishing without rights/correctness review.
- Editing `prompt_text` in place after publication.
- Inventing `target_band_range`, difficulty or time-to-band from author/model intuition.
- Treating harder vocabulary/grammar/prompt complexity as automatically better preparation.

## Versioning

- material prompt/task change → new immutable version;
- assessment-relevant routing/exposure/evaluation-policy change → impact review/version as required by the owning content/evidence contract;
- optional non-semantic metadata may be patched only when it cannot alter historical evidence interpretation;
- retire/deprecate preserves historical attempt references.

## Canonical references

- learner API: `artifacts/engineering/api/openapi.yaml`;
- learner payload semantics: `artifacts/engineering/api/schema-contract.yaml`;
- content/curriculum/challenge policy: `blueprint/05-content.md`;
- Writing consumer: `artifacts/experience/specs/vertical-slices/writing-task-2.md`;
- rights/legal evidence: current business/legal artifacts selected through `DOCS.yaml` and release governance.

## P0 vs later

- P0: Writing Task 2 prompts, explicit review, minimum required metadata, rights/provenance, enough intervention/retest coverage for activated Writing paths.
- Later: broader skill assets and richer routing metadata only after active consumers and outcome/quality evidence justify their authoring cost.
