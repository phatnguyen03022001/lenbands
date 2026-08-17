# AGENTS.md — LenBands agent entry point

This file is the smallest safe entry point for any repository agent.

## Read order

1. `DOCS.yaml` — machine-readable authority and alias registry.
2. The one canonical document that owns the requested concern.
3. Only the contracts explicitly referenced by that document.
4. `artifacts/operations/agent-trust-policy.yaml` before a protected change.

Do **not** scan the repository before reading `DOCS.yaml`. Do **not** resolve authority by filename recency, folder depth, or prose confidence.

## Core rules

1. **One owner per semantic field.** If two canonical documents appear to own the same fact, report `authority_collision`.
2. **Stable IDs over paths.** Capability IDs, framework node IDs, document IDs, operationIds, event IDs, and evidence IDs are durable. File paths are replaceable.
3. **IELTS authority classes stay explicit.** Official/public IELTS rules, LenBands-controlled policy, and experimental heuristics must not be blended.
4. **No invention.** Missing enum/node/contract → `unknown_*` or a documented gap; never create a plausible value silently.
5. **Evidence over claims.** `approved`, `calibrated`, `ready`, or quality claims require the evidence specified by their gate.
6. **Premium is not a security role.** The five web personas are `guest`, `learner`, `premium_learner`, `colab`, `admin`; authorization roles are `learner`, `colab`, `admin`, with Premium represented by entitlement.
7. **Provider-neutral domain.** Vendor names may appear only in sourcing/BOPS/adapter boundaries, never in capability identity, learner score semantics, canonical events, or learner-facing product terminology.
8. **Buy commodity infrastructure.** Build only LenBands differentiation: IELTS semantics, learning evidence, learner model/adaptive policy, content/publishing semantics, evaluation/rubric governance, thin orchestration, and product experience.
9. **Privacy.** Raw learner essays, audio, transcripts, answers, private notes, secrets, and provider payloads never enter analytics events or general logs.
10. **Scoring isolation.** A learner-visible evaluator may use only a benchmark-approved route/model/provider combination. General AI fallback must never silently change scoring semantics.
11. **No tooling bypass.** Never weaken validators, evidence requirements, protected-path checks, mutation tests, or immutable-history rules to make a change pass.
12. **No speculative infrastructure.** Do not introduce a service, queue, cache, custom auth layer, model server, search cluster, or new language runtime without an evidence-backed blocker.

## Canonical web/API sources

- API contract: `artifacts/engineering/api/openapi.yaml`
- Access model: `artifacts/engineering/api/access-control.md`
- BOPS controls: `artifacts/operations/bops/contract.yaml`
- Threat model: `artifacts/operations/bops/threat-model.md`
- Sourcing/build-vs-buy: `artifacts/business/decisions/platform-sourcing.md`

Legacy OpenAPI/BOPS/build-buy documents exist only for migration and traceability. Their status is declared in `DOCS.yaml`; they must not become a second authority.

## Framework compatibility projection

Current compatibility projection: **Framework IELTS v1.0.6**.

This line exists only because the bounded-contributor validator still checks the agent entrypoint during migration. The authoritative Framework version remains `blueprint/framework/README.md`; agents must not use this projection to resolve a conflict. The projection is removed when that validator is migrated to `DOCS.yaml`/Framework metadata.

## Protected change workflow

For a protected change:

```bash
tools/bin/lenbands context
tools/bin/lenbands doctor
tools/bin/lenbands verify
tools/bin/lenbands gate toolchain
tools/bin/lenbands gate p0
```

`gate p0` may correctly remain blocked while real P0 evidence is missing. A protected diff also needs the repository trust-boundary attestation and the required independent review.

## Knowledge Asset workflow

Only when creating learner-serving content, read:

- `artifacts/operations/spawn-prompts/README.md`
- its registry
- the exact Framework nodes named by the workflow

Prompts are workflow artifacts, never IELTS/domain authority.
