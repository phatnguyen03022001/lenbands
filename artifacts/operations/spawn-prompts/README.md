# Spawn Prompt Artifacts

This is the workflow-artifact library for agents that create Knowledge Assets. Agents are allowed and encouraged to read this directory when spawning assets; there is no rule prohibiting reading or indexing it.

## Authority boundary

- IELTS domain, controlled vocabulary, and band semantics: `blueprint/framework/` is the source of truth.
- Prompt template: `spawn-*.md` files in this directory are workflow contracts and must not create enums or band semantics outside the framework.
- Prompt registry: `registry.yaml` is an operational manifest/index, not a new source of truth.
- Learner content: `knowledge-assets/` plus sidecars are the canonical outputs; prompts must not become a second copy of learner content.
- Evidence/run history: `artifacts/operations/evidence/` is immutable; do not modify earlier run records when prompts change.

## Usage

1. Read [registry.yaml](registry.yaml) to obtain `prompt_template_id`, owner, framework refs, output contract, and validator.
2. Read the corresponding prompt artifact.
3. Use only input IDs that exist in the framework; if an ID is missing, return `unknown_*` and stop.
4. If evidence is insufficient or uncertain, return `needs_review`; do not invent facts.
5. Output only to `knowledge-assets/` as a `.md` payload plus `.meta.yaml` sidecar, with initial status `draft`.
6. Run `./tools/validate-spawn-prompts.sh` and `./tools/validate-knowledge-assets.sh`.

## Prompt catalog

| Prompt ID | Output | Framework boundary |
|---|---|---|
| `spawn-vocab` | vocabulary card | topic, band, microskill |
| `spawn-collocation` | collocation card | category, topic, microskill |
| `spawn-grammar-lesson` | grammar lesson | grammar node, errors, microskill |
| `spawn-question-item` | Reading/Listening item | question type, microskill, error, module rules |
| `spawn-error-example` | error example | error taxonomy, review mapping |
| `spawn-speaking-cue-card` | Speaking Part 2 cue card | part, genre, topic, speaking microskill |
| `spawn-writing-prompt` | Writing task prompt | task type, topic, writing microskill |

## Claims not permitted

A prompt passing its validator proves only workflow structure, reference resolution, and integrity. It does not prove IELTS quality, rights, calibration, benchmark validity, or learner outcome. Those claims require separate evidence, and a prompt must never promote an asset to `published` on its own.
