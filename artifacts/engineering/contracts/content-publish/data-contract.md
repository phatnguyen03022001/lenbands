# Content Publish Contract (Colab → Published Asset)

Canonical metadata is in `data-contract.meta.yaml`.

P0 scope: **Writing Task 2 prompt** from Colab draft → published → consumed by the Writing slice. This is P0's largest reverse dependency (P0-04 consumes a published task but no generation spec exists yet).

### Authoring-side and learner-side schema boundary

The `target_band_range` and `rights` fields belong to the authoring side, used for the Colab rights/content gate and not as learner-facing API output. `openapi.yaml` is the learner-side projection, so it exposes only the required prompt, controlled `task_type`, and minimal metadata. The two schemas intentionally have different boundaries; do not copy internal rights/provenance into the API.

`origin.source/license` is KA sidecar schema metadata; `rights.origin` in this authoring entity is a separate rights-classification enum. The two boundaries do not share a representation.

## Lifecycle

```text
draft → in_review → published → deprecated → retired
```

- `draft`: Colab authoring, AI-assisted auto-tag proposal.
- `in_review`: Colab submit, moderation queue (founder review P0).
- `published`: live and consumable by learners.
- `deprecated`: still accessible by direct link (already used by learners), not used in recommendations.
- `retired`: fully hidden.

P0 moderation: **manual founder review** (no complex tool required). P1: full Colab tool.

## Entity: WritingTask (authoring side)

```yaml
task_id: string               # uuid, stable across versions
version: integer              # bump on edit
status: draft | in_review | published | deprecated | retired
exam_module: academic | general_training
task_type: W_task2_opinion | W_task2_discussion | W_task2_advantages_disadvantages | W_task2_problem_solution | W_task2_two_part (from writing-task-framework.md)
prompt_text: string           # full prompt
prompt_word_count_target: integer   # 250 (Task 2)
prompt_hash: string           # hash prompt_text to detect duplicates
rights:
  origin: first_party | licensed | cambridge_pattern | generated | public_domain
  origin_ref: string          # source URL/ref if not first_party
  license_evidence_ref: string  # path/hash evidence if licensed (immutable in operations/evidence)
target_band_range: [5.0, 9.0]
tags:
  topic: [t_education, t_technology, ...]   # from vocab-collocation-topic.md
  microskill_ref: [W_position_clarity, ...] # suggested, not required
colab_author_id: string
reviewed_by: string           # founder id (P0)
reviewed_at: timestamp | null
published_at: timestamp | null
created_at: timestamp
updated_at: timestamp
```

## Rights gate (hard rule)

Task is not `published` when:
- `rights.origin` is outside the enum → reject.
- `rights.origin = licensed` lacks `license_evidence_ref` → reject.
- `rights.origin = cambridge_pattern` (written in a Cambridge pattern, not original Cambridge material) → OK but must be stated clearly.
- If provenance is unclear, Colab keeps the entity in `draft` and does not emit `rights.origin`; do not assign `link_only` or a license automatically.

P0: founder decides rights during authoring. Immutable evidence is in `operations/evidence/` (hash + provenance).

## Author → Review → Publish flow (P0)

```text
1. Colab/Founder authors the draft (WritingTask entity)
   ↓
2. Auto-tag (CONTENT.AutoTag) proposes: task_type, topic, target_band_range
   - P0: deterministic rules + prompt pattern match, no LLM required
   ↓
3. Founder review (in_review → moderation queue)
   - Check: prompt is not duplicated (prompt_hash), rights are valid, band range is reasonable
   - P0: minimal UI (admin tool, no full Colab shell required)
   ↓
4. Approved → published (status flip, published_at set)
   ↓
5. Writing slice consume GET /writing/tasks/{task_id}
```

## Anti-pattern

- Hosting original Cambridge material without a license → rights violation, reject.
- Generate a random prompt for the learner when no task is published → violation ("do not create a random task" — Writing slice rule).
- Publish without review → moderation-gate violation.
- Change `prompt_text` after publishing without bumping version → learner-facing immutability violation.

## Versioning

- Edit `prompt_text`: bump version and retain the old version (learners who used it still reference it correctly).
- Edit metadata without semantic change (tag): patch, no version bump.
- Retire: status flip + reason note.

## Cross-refs

- Writing slice (consumer): `experience/specs/vertical-slices/writing-task-2.md` §4 (entry condition: a published task is required).
- Licensing matrix: `business/legal/licensing-matrix.md`.
- OpenAPI WritingTask schema: `engineering/contracts/writing-task-2/openapi.yaml` (WritingTask).
- Knowledge Asset lifecycle: `blueprint/05-content.md` § Versioning.

## P0 vs later

- P0: Writing Task 2 prompt only, founder manual review, minimal admin UI.
- P1: full Colab tool, LLM-assisted AutoTag, multiple content types (Reading passage, Listening audio, Speaking cue card).
- P2: Advanced moderation workflow, blueprint update batch.
