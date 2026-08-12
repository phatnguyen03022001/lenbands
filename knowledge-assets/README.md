# Knowledge Assets

A Knowledge Asset is a versioned canonical knowledge unit used to create learning experiences: a lesson, question, audio item, rubric, template, glossary, strategy, or equivalent content.

Assets are not classified as AI/human in folders. Provenance, rights, and workflow are recorded in the Knowledge Asset sidecar; learner-facing content has one canonical source. `origin.source/license` in the sidecar is asset-level metadata and differs from `rights.origin` in the authoring contract.

Schema boundary for a Writing prompt: authoring-side `WritingTask` retains `target_band_range`, rights, rubric, and moderation fields; the learner-facing Knowledge Asset payload only retains the `band_range` target range as an `N.N-N.N` string together with the prompt/task fields needed for rendering. Authoring fields are not considered missing from the learner payload and must not be exposed automatically through OpenAPI.

## Current layout

| Folder | Used for |
|---|---|
| `manifests/` | Canonical manifest by `asset_id` |
| `proprietary/` | The first asset owned by the product or authorized for distribution |

Add an appropriate folder only when the first licensed or generated asset exists. Do not create it in advance.

## Lifecycle

`draft → in_review → published → deprecated → retired`

Only `published` assets are served to learners. A pipeline/agent is the actor that creates or transforms an asset; an asset does not transform itself.
