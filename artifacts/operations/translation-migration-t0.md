# LenBands English-Only Documentation Migration — T2 MD/YAML Ledger and Protected Packets

Status: `blocked`  
Version: `0.3.0`  
Checkpoint: T2 MD/YAML reconciliation; safe mutable prose is zero; protected and generator work remains blocked  
Updated: 2026-08-11

This artifact prepares a later migration toward:

> All current authoritative human-authored documentation is English-only;
> immutable historical evidence and explicitly registered source-language
> exceptions remain unchanged.

T0.1 does not translate repository files. It does not change Blueprint,
Framework, registry, manifest, lifecycle, OpenAPI, tool, validator, gate,
`.claude` policy, source-code, or immutable-evidence content.

## 1. Boundary contract

### In scope for later checkpoints

Mutable human-authored documentation and guidance, including the root
`README.md`, Blueprint prose, IELTS Framework prose, artifact decisions,
contracts, research, runbooks, experience specifications, HTML design and
wireframe/mockup prose, operational documentation, agent and skill
instructions, prompt templates, tool documentation, and human-readable prose
fields in YAML/JSON-like metadata where the relevant owner and
protected-change process permit the edit.

The migration changes language only. It must not change meaning, authority,
obligation strength, lifecycle, ownership, controlled vocabulary, readiness,
scope, evidence status, calibration status, or runtime semantics.

### Never translate or mutate

- Capability IDs, canonical IDs, enum values, keys, schema properties,
  operationIds, API paths, event names, state/lifecycle values, commands,
  regexes, URLs, filenames, hashes, checksums, versions, or source IDs.
- Inline code, fenced code, HTML `<style>`/`<script>` syntax, YAML/JSON/OpenAPI
  structures, machine-contract fields, or generated projections. Translate
  their canonical input and regenerate the projection.
- Immutable evidence, append-only historical records, attestations, or any
  historical line-reference content.
- External-source titles and quotations when the original language is needed
  for provenance or faithful evidence.
- Learner-serving Knowledge Assets. Their content language and sidecar
  semantics remain governed by the Knowledge Asset contract; they are not
  documentation in this T0.1 universe.

### Semantic non-regression invariant

No translation may turn:

`recommendation → requirement`, `candidate → approved`, `proposed → adopted`,
`partial → complete`, `unknown → known`, `deferred → available`,
`review → accepted`, `evidence-needed → evidenced`, or `not_ready → ready`.

It must not turn a learner-facing approximation into an official IELTS rule.
Official IELTS terms remain source-backed English terminology and are kept
distinct from LenBands internal terms.

## 2. Deterministic inventory universe

The T0.1 universe is the filesystem snapshot produced by the following
command, sorted by repository-relative path. It intentionally inventories
both rendered documentation surfaces and structured files that may contain
human-readable free prose. The extension scan is only a candidate enumerator;
profile and field classification determine what is translatable.

```sh
rg --files --hidden \
  -g '!/.git/**' -g '!.cache/**' -g '!.pnpm-store/**' \
  -g '*.md' -g '*.mdx' -g '*.txt' -g '*.rst' -g '*.adoc' \
  -g '*.html' -g '*.htm' \
  -g '*.yaml' -g '*.yml' -g '*.json' -g '*.toml' \
  | rg -v '^(apps|services|engines)/' \
  | rg -v '^knowledge-assets/(collocations|grammar|vocabulary|writing-prompts)/' \
  | rg -v '^artifacts/operations/translation-migration-t0(\.md|\.meta\.yaml)$' \
  | sort
```

The command covers every current repository-relative path in these surface
classes: root guidance; `blueprint/**`; `artifacts/**`; `.claude/**`;
`.github/**`; `tools/**`; `knowledge-assets/README.md` and
`knowledge-assets/manifests/README.md`; and any future matching path not under
an explicit exclusion. Current HTML surfaces are nine files under
`artifacts/experience/design/**`; they contain visible headings, labels,
paragraphs, annotations, and state copy, so they are in scope as mutable
documentation. Their CSS, JavaScript, HTML IDs/classes, attributes with
machine meaning, and code comments are preserved syntax/token spans.

Explicit exclusions are: `.git/**`, `.cache/**`, `.pnpm-store/**`, source
roots `apps/**`, `services/**`, and `engines/**`; learner-serving Knowledge
Asset paths under `knowledge-assets/{collocations,grammar,vocabulary,
writing-prompts}/**`; and this T0 artifact plus its sidecar. Source code,
executable scripts, and comments embedded in source code remain out of scope;
they are not silently classified as documentation.

The corrected universe contains **467 files**: 213 Markdown files, 9 HTML
files, 241 YAML files, 3 JSON files, and 1 YML file. Root counts are:
`.claude` 23, `.github` 1, `AGENTS.md` 1, `CLAUDE.md` 1, root `README.md` 1,
`artifacts` 414, `blueprint` 20, `knowledge-assets` 2, and `tools` 4. The
excluded learner-asset set contains **34 files** (17 content files and 17
sidecars). It is registered below as a governed content exception, not
silently dropped.

Inventory manifest hash for the snapshot above:

```text
1b96ebe015b13204de4e6c85b8feb599620112390ec7cb6399a0a638a07019bb
```

The hash is SHA-256 over the newline-delimited sorted path manifest. Re-run
the command and hash the exact output before each later batch. A changed
count or hash requires a new inventory snapshot and readiness review.

### Per-file classification record

Every path in the 467-file manifest has exactly one profile below. Profiles
are mutually exclusive, cover the complete manifest, and classify structured
files at file level plus their fields through the field contract in §3. A
selector failure is not an exclusion: it produces `unknown_classification`
and blocks later migration readiness.

| Profile / exact selector | Count | authority_role | mutation_class | language_policy | authority_owner | protected | immutable | translation_required | translation_permitted | exception_reason | machine_tokens_present | citation_risk | sidecar_or_metadata | notes |
|---|---:|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `P1`: `AGENTS.md`, `CLAUDE.md`, `.claude/**` | 25 | canonical | protected | translate_later | repository governance owner | yes | no | yes | no in T0.1 | protected policy; packet required | yes | high | role metadata; sidecar not required | Includes agent, skill, rule, and local JSON policy surfaces. |
| `P2`: `.github/**` | 1 | canonical | protected machine_contract | translate_later by free-prose field | CI/trust owner | yes | no | yes by field | no in T0.1 | protected CI configuration | yes | high | policy-owned | Workflow syntax and tokens are preserved. |
| `P3`: `blueprint/**` | 20 | canonical | protected | translate_later | Blueprint product owner; Framework domain owner | yes | no | yes | no in T0.1 | protected product/domain authority | yes | high | no sibling sidecar | Framework controlled vocabulary is immutable in meaning. |
| `P4`: `tools/**` | 4 | canonical | protected machine_contract | translate_later by free-prose field | toolchain owner | yes | no | yes by field | no in T0.1 | protected toolchain documentation/configuration | yes | high | sibling metadata where present | Do not modify tools or validators in T0.1. |
| `P5`: `artifacts/operations/spawn-prompts/**` | 21 | non_authoritative | protected | translate_later by prose span/field | spawn-prompt registry owner | yes | no | yes | no in T0.1 | protected workflow template; registry controls use | yes | high | sibling metadata/registry | Examples remain examples; output schemas and stop rules stay exact. |
| `P6`: `artifacts/operations/evidence/**` and `artifacts/operations/attestations/**` | 59 | canonical | immutable_evidence | preserve_immutable | evidence/trust owner | yes by path | yes | no | no | immutable or append-only historical record | yes | high | evidence/attestation authority | Never repair or reflow historical line references. |
| `P7`: protected policy paths from `agent-trust-policy.yaml`, excluding P1–P6 | 40 | canonical | protected | translate_later by approved field | owner recorded by protected authority | yes | no | yes by field | no in T0.1 | protected registry, contract, acceptance, benchmark, or ADR | yes | high | sibling metadata/path authority | Requires protected-change packet and external review. |
| `P8`: generated/derived selectors `catalogs/**`, `generated/**`, `baseline/**`, and declared top-level projections | 41 | projection | generated_or_derived | regenerate_from_canonical | declared source owner/generator | no unless policy overlap | no | yes only through generator | no hand translation | derived output; generator/source must be proven | yes | high | sibling metadata required | Manual-projection-pending files remain unresolved, never hand-translated. |
| `P9`: repository-root `README.md` | 1 | canonical | mutable | translate_later | repository/documentation owner | no | no | yes | yes after owner review | explicit root guidance profile | yes/possible | high | no sibling sidecar | This is the corrected explicit root README record. |
| `P10`: `artifacts/business/research/**`, `artifacts/experience/research/**` | 8 | non_authoritative | mutable | translate_later by prose field/span | research owner | no | no | yes | yes after source/citation review | research prose is not product or IELTS authority | possible | high | sibling metadata when present | Preserve source quotes, provenance, and uncertainty. |
| `P11`: `artifacts/templates/**` | 5 | non_authoritative | mutable | translate_later by prose span | artifact-template owner | no | no | yes | yes | reusable template prose; field names and tokens frozen | yes/possible | medium/high | no sibling sidecar | Do not create a second governance SSOT. |
| `P12`: all remaining selected files, including the 9 HTML design/wireframe files and remaining artifact/Knowledge Asset governance docs | 242 | canonical | mutable | translate_later by prose field/span | sibling `.meta.yaml` owner or owning artifact lens | no unless policy overlap | no | yes by prose | yes after owner check | no implicit exception; unknown fields block | yes/possible | medium/high | sidecar when present; role rule otherwise | HTML visible prose is mutable; CSS/JS/IDs remain protected spans. |

Coverage check: `25 + 1 + 20 + 4 + 21 + 59 + 40 + 41 + 1 + 8 + 5 + 242 = 467`.

`current_language_state` is a separate field, not a selector: Markdown and
HTML use visible prose spans; structured files use only fields classified as
free prose. A file is `english_only`, `vietnamese_only`, `mixed`,
`nonlinguistic_or_machine_only`, or `unknown` based on those spans/fields.
Unicode detection may flag candidates, but cannot decide scope or authority.
Any unrecognized human-readable span/field is `unknown` and blocks readiness.

`sidecar_or_metadata` is recorded per file: sibling `.meta.yaml` when present,
protected policy/registry authority when the path governs itself, and an
explicit owner-lens rule otherwise. Missing metadata is not permission to
infer ownership; an unowned file becomes `unknown_classification`.

Citation risk is resolved per file as `high` when it contains external source
references, quoted source text, line references, or immutable evidence;
`medium` when it contains local stable IDs, cross-file links, or machine
tokens; and `low` only when neither condition is present. A file with more
than one condition takes the highest risk.

Structured files are not excluded from the universe. Their free-prose fields
and machine/controlled values are separated by the field contract in §3.
Keys, schemas, registries, operationIds, paths, events, states, commands,
URLs, hashes, versions, and source IDs are preservation-only; description,
rationale, notes, purpose, and registered explanatory fields are later
translation targets when the owner permits.

## 3. Structured prose-field contract

Structured files are classified at field/span level. A field is not
translatable merely because its value is a string, and it is not protected
merely because its file is YAML or JSON. Every scalar string must resolve to
one of the following classes before a later batch can start.

| field/span class | examples | later handling | status |
|---|---|---|---|
| mutable free prose | `description`, `rationale`, `notes`, `note`, `purpose`, `summary`, `meaning`, `reason`, `exception_reason`, `generation_note`, `change_log[].changes[]`, `non_goals`, `constraints`, `assumptions`, `context`, `consequences`, `motivation`, `scope`, `out_of_scope`, `owner_note`, and registered human-readable `title`, `label`, `help`, `message`, `fallback` | Translate bounded value only, preserving surrounding key/path and meaning. | translate_later |
| machine/controlled value | all YAML/JSON keys; IDs; enum values; `status`; `phase`; `lifecycle`; `state`; `capability_id`; `family_id`; `owner_spec`; `operationId`; `event`; `derived_from`; `consumed_by`; `framework_refs`; `version`; dates; `schema_version`; `generated_at`; `source_files`; commands; regex; API paths; URLs; hashes; checksums; filenames; source IDs | Preserve byte-for-byte where the value is a token or controlled value. Re-parse after any adjacent prose edit. | preserve_machine_contract |
| provenance-preserving source span | `source_title`, external title, direct quote, citation target, source identifier, or source-language excerpt whose original language is required | Preserve the original span; translate surrounding LenBands explanation only. | preserve_source_language |
| unknown human-readable field | any string field not in the registered free-prose or controlled-value classes | Record path and field in the exception/queue; migration readiness fails closed until classified. | unknown_classification |

`status: review`, `phase: P1`, `capability_id: BAND.Current`, and
`event: evaluation_failed` are preserved controlled values. A value such as
`description: "Vietnamese explanatory prose"` is a later translation target.
Field classification is independent of file extension, directory, or
Unicode detection.

For HTML, visible text nodes and human-readable `aria-label`/title copy are
mutable prose spans when they are documentation or mockup copy. `<style>`,
`<script>`, HTML IDs/classes, data attributes with runtime meaning, inline
code, URLs, and control-flow/executable syntax are preserved token spans.

## 4. Proposed English terminology glossary

These are proposed English renderings for later batches. Existing authority
already uses most of them; this glossary does not rename IDs or enums.

| term | canonical_english | meaning_in_lenbands | allowed_variants | disallowed_or_risky_variants | authority_ref | status | notes |
|---|---|---|---|---|---|---|---|
| capability | capability | A product/system ability with one canonical identity and owner. | capability | feature when identity is intended; competency | `blueprint/README.md` § Blueprint capability readiness | defined | Use the stable capability ID. |
| owner | owner | Role responsible for semantic authority or change review. | owning role | maintainer when authority is meant | `artifacts/CONVENTION.md` § 2–3 | defined | Folder/lens is not the owner. |
| canonical authority | canonical authority | The one source allowed to define a semantic object. | canonical source | source of truth when the object is only a projection | `artifacts/operations/ssot-registry.md` | defined | Keep distinct from projection. |
| SSOT | single source of truth (SSOT) | One canonical owner for a meaning, capability, or data object. | SSOT | master copy, primary-ish source | `blueprint/README.md` | defined | Expand on first use in prose. |
| projection | projection | A derived view or index that is not the source of truth. | derived view, index | canonical, authoritative copy | `artifacts/operations/catalogs/README.md` | defined | Must be reproducible. |
| proposal | proposal | A not-yet-adopted option or change under review. | proposed change | decision, adopted rule | `artifacts/CONVENTION.md` § 4 | defined | Never translate to requirement. |
| evidence | evidence | Traceable proof supporting a claim or gate. | supporting evidence | proof when provenance is absent | `artifacts/operations/PENDING-EVIDENCE.md` | defined | Claims need real evidence. |
| immutable evidence | immutable evidence | Append-only historical proof that cannot be edited or deleted. | historical evidence | archived draft, editable record | `artifacts/operations/evidence/README.md` | defined | New correction means new version. |
| provenance | provenance | Origin, rights, and source context of a document or asset. | source provenance | citation alone | `artifacts/CONVENTION.md` § 3 | defined | Preserve source language where needed. |
| lineage | lineage | Traceable derivation chain from canonical input to output. | derivation lineage | ancestry when unclear | `artifacts/operations/founder-agent-governance-workflow.md` | defined | Required for generated outputs. |
| review | review | Evaluation state before approval or adoption. | under review | accepted, approved | `artifacts/CONVENTION.md` § 4 | defined | Review is not acceptance. |
| approval | approval | Explicit owner decision permitting a reviewed artifact to advance. | approved decision | evidence, published result | `artifacts/CONVENTION.md` § 6 | defined | Approval is not external proof. |
| readiness | readiness | Gate state indicating required definitions and evidence are satisfied. | ready state | completeness, production-ready | `artifacts/operations/build-readiness-matrix.md` | defined | Never infer from prose. |
| blocker | blocker | An unmet condition that prevents a gate or promotion. | blocking condition | warning, minor issue | `tools/bin/lenbands context` | defined | Preserve severity and status. |
| protected decision | protected decision | A decision whose authority path requires protected review and attestation. | protected change | ordinary edit | `artifacts/operations/agent-trust-policy.yaml` | defined | Packet before application. |
| lifecycle | lifecycle | Controlled states through which a capability or artifact moves. | lifecycle state model | release status when not equivalent | `artifacts/operations/architecture-frozen.md` | defined | Keep state values unchanged. |
| phase | phase | Roadmap placement such as P0, P1, or P2. | roadmap phase | priority, release | `blueprint/08-roadmap.md` | defined | Phase is not readiness. |
| family | family | Shared implementation/runtime boundary grouping capabilities. | implementation family | category, topic | `artifacts/operations/architecture-frozen.md` | defined | Family identity is protected. |
| transport | transport | API or interaction delivery mode for a capability. | transport mode | channel when semantics differ | `artifacts/engineering/contracts/openapi/README.md` | defined | Preserve API paths and operationIds. |
| assessment | assessment | Evaluation activity or result within an IELTS/task context. | assessment activity | exam result, official score | `blueprint/05-content.md`; `blueprint/framework/README.md` | defined | LenBands output is not official IELTS. |
| practice | practice | Learner activity intended for rehearsal or improvement. | practice activity | assessment when no judgment contract exists | `blueprint/01-product.md` | defined | Keep practice separate from assessment. |
| task | task | A bounded learner or system work unit. | task | assignment when runtime meaning differs | `blueprint/framework/writing-task-framework.md` | defined | Task is not always a task type. |
| task type | task type | Controlled IELTS/task classification used to shape content or evaluation. | task-type | task category, mode | `blueprint/framework/writing-task-framework.md` | defined | Preserve enum values. |
| skill | skill | IELTS skill domain such as Writing or Speaking. | IELTS skill | ability when it is a domain enum | `blueprint/framework/README.md` | defined | Use framework vocabulary. |
| knowledge | knowledge | Structured domain information used by the Knowledge OS. | domain knowledge | content when learner asset is intended | `blueprint/05-content.md` | defined | Distinguish from Knowledge Asset. |
| content | content | Material presented, practiced, or transformed by the system. | learning content | knowledge when the layer is not known | `blueprint/05-content.md` | defined | Layer and owner must be explicit. |
| mastery | mastery | Learner state inferred from evidence over a defined scope. | mastery state | proficiency guarantee | `blueprint/06-engines.md` | defined | Do not overclaim from one attempt. |
| learning evidence | learning evidence | Traceable learner signal supporting a learning-state claim. | evidence of learning | completion, score alone | `artifacts/operations/learning-coverage-and-measurement-gate.md` | defined | Raw learner content is not emitted to logs. |
| learner coverage | learner coverage | Whether a learner-facing capability or outcome is supported, partial, or deferred. | coverage status | availability, completeness | `artifacts/operations/catalogs/learning-outcome-index.yaml` | defined | Preserve `supported`, `partial`, `deferred`, `unknown`. |
| calibration | calibration | Agreement of evaluation behavior with an approved benchmark and threshold policy. | calibration state | accuracy without a run | `artifacts/operations/evaluation-benchmark-spec.md` | defined | Requires dataset/run evidence. |
| benchmark | benchmark | Versioned dataset, rubric, model, prompt, and run used for comparison. | benchmark run | test, proof | `artifacts/operations/evaluation-benchmark-spec.md` | defined | Preserve version tuple. |
| threshold | threshold | A boundary used by a gate or evaluation policy. | policy threshold | target, recommendation | `artifacts/operations/build-readiness-matrix.md` | defined | Numeric approval is separate. |
| candidate threshold | candidate threshold | A proposed, not-yet-approved boundary. | proposed threshold | approved threshold, hard limit | `artifacts/operations/cost-budget.md` | defined | Must retain candidate status. |
| runtime acceptance | runtime acceptance | Evidence-backed acceptance of a runtime path against its contract. | acceptance run | review, readiness | `artifacts/operations/acceptance/README.md` | defined | Requires an actual run record. |
| source unlock | source unlock | Explicit authorization to remove a protected source-mutation lock. | unlock authorization | implementation-ready, approval | `artifacts/operations/agent-trust-policy.yaml` | defined | Requires attestation and external review. |
| document input readiness | document input readiness | Convergence state in which authoritative docs satisfy the required pre-code conditions. | documentation readiness | complete, ready-to-build | `artifacts/operations/agent-trust-policy.yaml` | unresolved | Confirm canonical owner and exact gate wording before T1. |
| deferred | deferred | Explicitly postponed from the current phase or release scope. | deferred scope | unavailable, cancelled | `blueprint/08-roadmap.md` | defined | Do not translate to available. |
| unsupported | unsupported | Not supported by the current contract or capability boundary. | unsupported case | deferred when no deferral exists | `artifacts/operations/architecture-frozen.md` | defined | Keep distinct from unknown. |
| unknown | unknown | A value or mapping not established by authoritative vocabulary or evidence. | `unknown_*` diagnostic | guessed, inferred, unmapped without flag | `AGENTS.md` hard rules | defined | Never invent a framework ID. |
| not applicable | not applicable | A field or status that does not apply to the object under evaluation. | `not_applicable` | unsupported, unknown | `artifacts/engineering/decisions/learning-ontology-capability-mapping-inventory.yaml` | defined | Preserve exact enum spelling. |

Projection-local enums are not translated, renamed, normalized, or bridged:

```text
capability_mapping_status:
  mapped | partial | unknown_ontology_mapping | not_applicable
learner_coverage_status:
  supported | partial | deferred | unknown
```

## 5. Exception registry and protected handling

The following registry is span/field-level. A path pattern is an explicit
registration, not an implicit omission. `immutable` applies to the registered
span/file, not to unrelated mutable prose in the same file.

| path | anchor/field | exception_type | reason | authority | immutable |
|---|---|---|---|---|---|
| `artifacts/operations/evidence/**` (19 files) | entire file and historical line references | immutable_evidence | Append-only evidence must remain byte-stable; repairs use new records. | `artifacts/operations/evidence/README.md`; trust policy | yes |
| `artifacts/operations/attestations/**` (40 files) | entire record, including attestation fields and historical values | immutable_attestation | Protected-change attestations are historical governance records. | `artifacts/operations/agent-trust-policy.yaml` | yes |
| `knowledge-assets/{collocations,grammar,vocabulary,writing-prompts}/**` (34 files) | entire content file and sidecar | learner_content_source_language | Learner-serving Knowledge Assets are excluded unless a separate content-localization decision opts in. | `knowledge-assets/README.md` | no; preserve by policy |
| Any in-scope Markdown/HTML/YAML/JSON-like file | inline code, fenced code, `<style>`, `<script>`, executable syntax | machine_contract_token | Translation cannot change code or executable behavior. | `AGENTS.md`; architecture freeze | yes for span |
| Any in-scope file | IDs, enum values, keys, schema/property names, paths, operationIds, events, states, lifecycle values, commands, regex, hashes, checksums, URLs, versions, filenames, source IDs | controlled_token | Runtime and controlled vocabulary identity must remain exact. | Blueprint, Framework, contracts, registries | yes for span |
| Any in-scope structured file | `source_title`, external title, direct quote, citation target, source-language evidence span | provenance_source_language | Original language is required for provenance or faithful evidence. | source owner/citation authority | no; preserve span |
| Any in-scope structured file | any unknown human-readable scalar field | unknown_classification | No field may bypass classification; unknown blocks readiness. | owning `.meta.yaml` or canonical owner, otherwise queue | no |
| P8 generated/derived files | entire generated output | regenerate_from_canonical | Derived output must be regenerated, never hand-translated. | declared source/generator in §6 | no |
| Protected profiles P1–P5/P7 | entire file for T0.1 edit boundary | protected_change_required | Later translation requires packet, attestation, external CODEOWNERS review, approved application, and verification. | `agent-trust-policy.yaml` | no; protected |
| Blueprint localization sections | prose describing product UI/response language | product_localization_semantics | Documentation English-only must not silently change learner-facing localization policy. | `blueprint/07-conventions.md` | no; protected |

Exception counts: 59 immutable evidence/attestation files, 34 learner-asset
source-language files, 9 HTML files with protected syntax spans, and an
unbounded-but-closed set of machine-token spans. Any new source quote or
unknown field must add a new row or a versioned update before translation.

## 6. Generated and derived ownership

| generated selector | count | canonical source | registered generator/owner | handling |
|---|---:|---|---|---|
| `artifacts/operations/catalogs/**` | 15 | Each sibling sidecar `generated_from`/`source_files` declaration; primarily Blueprint/registries/framework | `tools/generate-capability-index.sh` where declared; otherwise sidecar state `manual_projection_pending_generator` | No hand translation; register missing generator before T1. |
| `artifacts/operations/generated/**` | 6 | Canonical operations registries and contracts declared by sidecars | `tools/generate-operational-coverage.sh` | Translate canonical inputs, then regenerate and validate. |
| `artifacts/operations/baseline/**` | 12 | Baseline source files declared in sidecars | `tools/generate-repository-baseline.sh` | Regenerate after source translation; preserve generated status. |
| Top-level projections `global-certification-ledger.*`, `executor-dossier.*`, `web-surface-inventory.*`, and `knowledge/active-capability-asset-alignment.*` | 8 | Sidecar `source_files`/`derived_from` or declared owner | Owner is recorded, but some sidecars are `manual_projection_pending_generator` or omit a generator | Generator registration is unresolved; no hand translation. |

Generated ownership is therefore complete at source/owner level for all 41
P8 files, but generator registration is unresolved for manual projections.
That unresolved state is a blocker, not an exception.

## 7. Token preservation and citation revalidation

Every future batch follows this bounded protocol:

1. Capture pre-edit references for the exact file set: incoming links,
   outgoing links, anchors, citation targets, source IDs, and line references.
2. Extract and hash protected token classes before editing: capability IDs;
   enum values; YAML/JSON keys; operationIds; API paths; event names;
   lifecycle/state values; commands; inline and fenced code; URLs; hashes;
   checksums; version strings; citation targets; and source identifiers.
3. Translate only bounded mutable prose spans. Code spans, fenced blocks,
   tables containing machine values, identifiers, and source quotations are
   immutable spans unless a protected owner explicitly approves otherwise.
4. Re-parse affected Markdown references and every affected YAML/JSON/OpenAPI
   companion. Compare token multisets and exact protected-span hashes. Any
   added, removed, renamed, or reordered semantic token fails the batch unless
   the change is separately authorized.
5. Recompute incoming/outgoing references and line references against the
   post-edit documents. Repair only a reference whose target is proven. Never
   modify immutable evidence to repair historical line numbers.
6. Run the repository validators and gates. A language-only diff is not
   sufficient evidence if ownership, citations, readiness, or runtime
   semantics drift.

Machine-checkable invariants for later tooling proposals (without modifying
 tooling in T0.1):

```text
protected_tokens(post) == protected_tokens(pre)
protected_span_hashes(post) == protected_span_hashes(pre)
yaml_json_openapi_parse(post) == success
resolved_citations(post) >= resolved_citations(pre)
immutable_evidence_bytes(post) == immutable_evidence_bytes(pre)
semantic_status(post) == semantic_status(pre)
```

The last invariant is semantic review, not a claim that a textual diff alone
can prove meaning preservation.

## 8. Unresolved terminology and classification queue

1. Confirm the canonical owner and exact gate wording for `source unlock` and
   `document input readiness`; both are currently defined as proposed terms,
   not new gate states.
2. Decide whether the English-only documentation target includes
   `AGENTS.md`, `CLAUDE.md`, `.claude/**`, and `tools/**` in the next protected
   packet, while keeping runtime localization policy unchanged.
3. Resolve any `unknown_classification` produced by the 467-file selector or
   field scanner. No selector failure may become an implicit exception.
4. Assign owners or sidecars where the owning role is not already explicit.
   Do not infer owner from filename alone.
5. Resolve the status of generated artifacts whose sidecars say
   `manual_projection_pending_generator`; no hand translation is allowed.
6. Establish a citation owner for Framework rows and external IELTS excerpts,
   including a rule for retaining source-language titles and quotes.
7. Confirm that all 34 excluded learner-asset content/sidecar files remain
   outside this documentation migration unless a separate content decision
   explicitly opts them in.
8. Decide whether a future translation-safety validator is needed. If so,
   prepare a protected tooling proposal; do not edit validators or gates in
   T0.1.

## 9. Deterministic T1–T4 sequence and readiness

| checkpoint | scope | entry criteria | exit criteria |
|---|---|---|---|
| T0.1 | Boundary correction, 467-file inventory, field classifications, exceptions, generator ownership, token/citation rules | Repository context, freeze/trust policy, existing T0 artifact, and current HTML/structured surfaces read | 467-file manifest and hash recorded; every file has one profile; root README explicit; HTML and structured prose included; exceptions and unresolved queue recorded; no protected or immutable mutation; required handoff commands reported. |
| T1 | Non-protected mutable documentation | T0.1 complete; owners resolved for selected batch; pre-edit references captured | Bounded prose translated; versions and required sidecar changelogs bumped; token/reference checks pass; no semantic status drift. |
| T2 | Blueprint and IELTS Framework protected translation | T1 stable; protected diff packet; attestation; external CODEOWNERS review and approval | Approved protected diff applied; controlled vocabulary and official IELTS meaning preserved; post-edit verification passes. |
| T3 | Agent, skill, prompt, and operational protected documentation | T2 stable; separate policy/operational packet where required | Instructions, stop rules, commands, and output contracts preserve behavior; prompt registry and trust checks pass. |
| T4 | Repository-wide verification and English-only gate | T1–T3 complete; regenerated projections current; all exceptions registered | Deterministic inventory re-run; residual non-exception source-language prose is zero or queued with an owner; citations, token invariants, validators, and gates pass. |

Protected translation workflow is always:

`decision/proposed diff → protected-change attestation → external CODEOWNERS review → approved application → verification`.

Every mutable artifact translation must bump its version and update the
sibling changelog where its convention requires it. Translation does not
authorize lifecycle, readiness, ownership, evidence, or metadata-status
changes.

At T0.1, no bulk translation was performed. In T1.2, only bounded mutable
documentation prose was translated. No immutable evidence, machine-contract
token, source code, API/runtime contract, readiness state, calibration status,
or IELTS semantic claim was changed.

## 10. T1.2 execution ledger

The scan below is a Vietnamese-aware, span-oriented inventory captured after
the T1.2 safe batch. The detector uses Vietnamese-specific Latin letters rather
than a broad Unicode range, so mathematical symbols such as `×` are not
classified as Vietnamese. A ledger unit is a bounded prose/comment/text-node
anchor; when a line mixes machine syntax and human copy, only the human span
is classified. Line ranges are exact anchors for review and re-scan.

### Applied safe batch

| file | exact mutable span anchors | applied change | version/review evidence |
|---|---|---|---|
| `artifacts/engineering/contracts/content-publish/data-contract.md` | YAML comments at lines 30–31, 34–35, 37, 40–41, 44–45 | Translated 8 explanatory comments to English; keys, IDs, enums, paths, and YAML syntax are unchanged. | `data-contract.meta.yaml` `0.2.5 → 0.2.6`; YAML parse and token inspection required. |
| `artifacts/engineering/contracts/error-to-review/data-contract.md` | YAML comments at lines 13–14, 17, 19–21, 37, 39, 49, 75–76, 80–81 | Translated 13 explanatory comments to English; keys, IDs, enums, and YAML syntax are unchanged. | `data-contract.meta.yaml` `0.2.2 → 0.2.3`; YAML parse and token inspection required. |
| `artifacts/experience/design/navigation/learner-shell.html` | CSS/HTML author comments at lines 33, 41, 53, 65, 83, 94, 124, 159 | Translated 8 design annotations; learner-facing text and UX copy remain Vietnamese-first. | HTML parse and protected syntax inspection required; no sidecar version exists. |
| `artifacts/experience/design/wireframes/full-system-wireframe.html` | CSS author comment at line 118 | Translated 1 design annotation; visible mockup copy remains unchanged. | HTML parse and protected syntax inspection required; no sidecar version exists. |
| **Applied total** | **30 prose spans** | **Safe non-protected mutable prose remaining: 0** | **No protected or immutable path was edited.** |

### Remaining-span ledger by governed disposition

#### Protected pending external review — 2,018 span anchors

These spans are eligible documentation prose but cannot be applied by this
agent. Each packet needs a protected-change attestation, external review via
`.github/CODEOWNERS`, approved application, and post-edit token/citation/gate
verification. The exact line anchors are:

| file | line anchors |
|---|---|
| `artifacts/engineering/decisions/ADR-0004-composition-first-application-platform.md` | 9–13, 17–19, 22–34, 36, 38, 41–42, 44–46, 50–56, 60–65 |
| `artifacts/engineering/decisions/convergence-batch-1-protected-diffs.md` | 19–20, 34–35, 44, 61–62, 73, 121–122 |
| `artifacts/engineering/decisions/convergence-batch-2-protected-diffs.md` | 23, 27–31, 40–41, 46–47, 52–53, 58–59, 64–65, 70–71 |
| `artifacts/engineering/decisions/convergence-batch-3-protected-diffs.md` | 17–18 |
| `artifacts/operations/PENDING-EVIDENCE.md` | 3, 5, 7–9, 11–18, 20, 22–24 |
| `artifacts/operations/acceptance/README.md` | 3, 5, 9, 11–15 |
| `artifacts/operations/benchmark/README.md` | 3, 5, 7, 11, 13–14, 16, 18, 22, 24, 28 |
| `artifacts/operations/build-readiness-matrix.md` | 3, 5, 7, 9, 11, 13, 15, 17–21, 23, 36, 38–45, 47, 49, 53–56, 60–63 |
| `artifacts/operations/spawn-prompts/README.md` | 3, 7–11, 13, 15–20, 34, 36 |
| `artifacts/operations/spawn-prompts/examples/grammar-lesson-example.md` | 20, 26–27, 29, 34–36, 39–41, 43, 45, 47, 52, 54, 58, 66, 70, 72, 75, 78, 81, 85–86 |
| `artifacts/operations/spawn-prompts/examples/vocab-card-example.md` | 9 |
| `artifacts/operations/spawn-prompts/spawn-collocation.md` | 3, 5, 7, 9, 16, 23, 43, 65, 72, 74 |
| `artifacts/operations/spawn-prompts/spawn-error-example.md` | 3, 5, 7, 9, 15, 22, 62, 69, 71 |
| `artifacts/operations/spawn-prompts/spawn-grammar-lesson.md` | 3, 5, 7, 9–11, 13, 15, 17–18, 20, 22–23, 25, 33–34, 47, 50, 53, 56, 58–59, 61–62, 64–65, 68, 71–79, 81–84, 107, 111, 114, 116, 118 |
| `artifacts/operations/spawn-prompts/spawn-question-item.md` | 3, 5, 7, 9–13, 15, 17–18, 21, 23, 25–27, 29–32, 34, 37, 41–43, 49, 61, 65–66, 74–84, 86–89, 112, 116, 119, 121, 123 |
| `artifacts/operations/spawn-prompts/spawn-speaking-cue-card.md` | 3, 5, 7, 9–10, 13, 20–21, 32, 34, 51, 62–69, 71–73, 96, 99, 103, 105, 107 |
| `artifacts/operations/spawn-prompts/spawn-vocab.md` | 3–4, 6, 8, 10–11, 13–14, 16–17, 19–21, 23, 25–26, 28, 30, 33–35, 38, 40–46, 50–63, 66, 70, 92, 102, 112, 132–135, 138–139, 141, 143 |
| `artifacts/operations/spawn-prompts/spawn-writing-prompt.md` | 3, 5, 7, 9–11, 14, 16, 18, 21, 23–28, 30, 40, 52–59, 61–63, 86, 89, 93, 95, 97 |
| `artifacts/operations/ssot-registry.md` | 3, 5, 7, 10–11, 13, 26, 28–29, 31, 33–36 |
| `blueprint/README.md` | 3, 5, 9, 13–16, 18, 22, 24, 37, 52, 56–59, 61, 63–69, 73, 75, 78, 81–82, 89, 102, 106, 109, 112, 115, 119, 147, 151, 153, 155–158, 160, 164–176, 180–188 |
| `blueprint/01-product.md` | 3, 7, 9–11, 13, 15–17, 19, 21–26, 28, 30, 32, 34–41, 43, 80–84, 90–92, 97, 99–100, 103, 105–106, 110, 112–115, 119–135, 141, 145, 147–151, 155–158, 162–164, 168–170, 174, 176–178, 180 |
| `blueprint/02-architecture.md` | 3, 20, 32, 50, 65, 68, 71, 74, 78, 80, 84–85, 87, 89, 105, 119–124, 128, 130, 132, 134, 138–140, 142, 146–147, 153–158, 162, 187–190, 194, 198–201, 204, 208, 221, 223–231, 235–239, 243, 247, 249, 251–254, 256, 259, 261–264, 270–273, 276, 299, 302–305, 309, 330–334, 336, 338–341 |
| `blueprint/03-features.md` | 3, 5, 7–9, 19–20, 23, 29, 31–33, 35, 50–54, 58, 62–63, 74, 76, 82–84, 86–87, 106, 108, 116, 122–124, 128–130, 142, 148–149, 151, 157, 170, 191–194, 206, 211, 215–217, 223, 226–227, 233, 243, 245–249, 251, 263, 270, 275–277, 279–281, 285, 289, 297–298, 303, 307, 311–316, 318, 324, 348, 350–363, 365–376, 380, 392–397, 403, 413, 417–423 |
| `blueprint/04-experience.md` | 3, 5, 7, 9–17, 19, 21, 37, 43, 49, 52, 54, 56, 58, 60, 62, 66, 68, 71, 75, 78, 80, 84, 87, 89, 91, 94, 98, 101, 103, 105, 107, 109, 113, 115, 118, 122, 125, 127, 129, 131, 135, 137, 142, 146, 149, 151, 156, 158, 163, 167, 170, 175, 177, 184, 188, 191, 199, 202, 206, 209, 211, 213, 215, 217, 222, 226, 230–235, 239, 241, 243–248, 250, 254, 256, 258–262, 266, 268, 270, 272, 274, 278, 280, 282–284, 286, 288, 290, 293, 295, 297, 299, 301, 303, 306, 308–312, 314, 316, 318–321, 323, 327–330, 334, 336–340, 344 |
| `blueprint/05-content.md` | 3, 5, 9, 11, 13–15, 17–20, 22, 26, 30, 34–38, 40, 42–43, 45, 47–50, 52, 54, 56, 58, 60–61, 65, 67, 69, 71–73, 75, 78, 85, 87, 100–104, 108, 115, 117, 124, 126, 128–129, 131–132, 134–136, 140–143, 147–149, 153, 155, 157–162, 166, 168–171, 173, 175, 177, 179, 181–184, 188, 197, 199, 201–205, 209, 213, 236, 238–243, 247, 249–254, 258–261, 265–267 |
| `blueprint/06-engines.md` | 3, 18, 20, 22–25, 29, 32, 34–40, 60–63, 67, 69–70, 75, 78–81, 88, 92, 94, 99, 102, 109–113, 117–119, 123–127, 133, 148, 156, 159–160, 165–167, 171, 173, 175–176, 179–180, 184, 188, 209, 213–218, 222, 224, 226, 232, 241, 247–251, 258, 262, 265, 267, 269–271, 277, 288, 292, 299, 302–309, 311–312, 314, 318–321, 323, 325, 327–331, 337, 341, 343–348, 353, 355, 357, 359, 361, 363, 365, 368, 370–372, 376, 378–382 |
| `blueprint/07-conventions.md` | 3, 7, 9, 11, 13, 15–18, 22, 40–41, 43, 47, 49–52, 56, 60–62, 64, 68, 71, 75, 81, 83, 87, 89, 92–93, 97, 99–101, 103, 105–107, 111–113, 117–121, 125, 127–129, 133, 136–137, 141–143, 147–150, 154–158, 163–164, 167–168, 170, 173–174, 178–180, 184–187, 191–196, 200, 202–206, 208, 210–213, 217–218 |
| `blueprint/08-roadmap.md` | 3, 5, 11, 19, 21, 23, 25–26, 60, 67, 80, 82, 84, 86, 88, 109, 113, 122, 143, 148–150, 154–156, 160–162, 166, 168–175, 179, 181–184, 188, 192–193, 197 |
| `blueprint/framework/README.md` | 3, 5, 7, 11, 13, 17, 24, 26–35, 37, 39, 42–44, 49 |
| `blueprint/framework/band-descriptor-map.md` | 8, 10, 12, 16–18, 22, 26–30, 34, 38, 41–45, 50, 54, 56, 58–64, 66, 70, 72, 74–80, 82, 86, 89–91, 93–95, 98, 102, 104, 110, 116, 120, 125, 128, 132, 136, 141, 148, 150, 152–156, 158, 160, 167 |
| `blueprint/framework/error-taxonomy.md` | 8, 10–15, 17, 19, 29–31, 34–37, 41, 43–54, 58, 60–65, 67–70, 74, 76–85, 88–92, 97–100, 104, 106–114, 116–117, 120–124, 126, 128, 130–131, 133, 142, 144, 146 |
| `blueprint/framework/exam-module-differences.md` | 8, 10, 12, 16–19, 21, 29, 31, 33, 37, 39, 55, 71, 73, 89, 93, 95, 99–100, 102–103, 108, 110, 112–114, 116, 118–119, 121, 131, 133–134, 152, 160, 164, 166, 171, 182, 184, 186, 188–190, 198–199, 201, 203–205 |
| `blueprint/framework/grammar-band-framework.md` | 8, 10, 12–14, 16, 18, 20, 37–39, 41, 45–51, 53, 55, 64, 76, 78, 94, 96, 98, 103, 115, 117, 127, 129, 132–134, 136, 138, 161, 163, 165–167, 180–182, 184, 186 |
| `blueprint/framework/microskill-enum.md` | 8, 10–14, 16, 18, 23, 37, 42, 45–49, 55–65, 71–79, 81–82, 88–101, 107–118, 120, 124–128, 130, 138–140, 142, 144–147, 149, 151 |
| `blueprint/framework/review-mapping.md` | 8, 10–13, 15, 17, 19–26, 32–37, 43–50, 56–70, 74, 78–85, 91–93, 97–102, 104, 108–110, 118, 120, 122 |
| `blueprint/framework/skill-questiontype-band.md` | 8, 10, 12, 19–20, 27, 30, 34, 36–45, 47, 49, 53, 55–70, 72, 78, 80–84, 93, 96–98, 102, 104–106, 108, 110, 112, 114, 116–119, 124, 126, 128–131, 133, 142, 144 |
| `blueprint/framework/speaking-parts-framework.md` | 8, 12, 14–16, 21–25, 27, 31–33, 38–41, 43, 47–48, 54, 56–58, 74, 78–79, 86–88, 90, 94–95, 100, 102–104, 106, 110–112, 117, 122–123, 125, 129–130, 135, 137, 139, 141, 143–148, 150, 154, 158, 160–162, 166, 175, 177–178, 180, 183, 185, 187, 189–191, 194, 196, 198–202, 204, 212–213, 215, 217–219 |
| `blueprint/framework/vocab-collocation-topic.md` | 8, 10–13, 17, 19, 32, 36, 38, 46–49, 51, 53, 55, 66, 75, 79, 83, 95, 115, 119, 121, 137, 141, 143, 149, 151, 153–157, 166–167, 169, 171–173 |
| `blueprint/framework/writing-task-framework.md` | 8, 14, 16–20, 22, 24–27, 33–34, 36, 38–39, 42, 44, 48, 50, 52, 71, 81–83, 85, 91, 101–102, 108, 110–111, 134, 138–139, 149, 168, 171, 175, 180, 184, 186, 188, 211–215, 217, 219–220, 230–231, 233, 235–237 |

#### Generated / derived output — 83 span anchors; generator-gap blocker

No generated output was hand-edited. The registered projection selector covers
all of `artifacts/operations/catalogs/**`; the following exact residual spans
remain blocked until the canonical source and a registered generator are
available:

| file | line anchors |
|---|---|
| `artifacts/operations/catalogs/README.md` | 3, 5, 7 |
| `artifacts/operations/catalogs/capability-index.md` | 3 |
| `artifacts/operations/catalogs/capability-phase-index.md` | 3, 6, 9, 196–199 |
| `artifacts/operations/catalogs/dependency-graph.yaml` | 1, 3–4, 10, 12, 14–16, 27, 73–74 |
| `artifacts/operations/catalogs/executor-dossier.md` | 3, 6, 11–15, 17–18, 20, 31, 35, 37, 88–91 |
| `artifacts/operations/catalogs/global-certification-ledger.md` | 3, 6, 10–12, 15–19, 53–56 |
| `artifacts/operations/catalogs/learning-outcome-index.yaml` | 1, 3–4, 11, 13, 15–17, 29 |
| `artifacts/operations/catalogs/web-platform-pack-inventory.md` | 3, 6, 10, 13–14, 22–24, 28, 30, 32, 46, 58, 68, 78, 90–91, 108–111 |

Required generator gaps are the missing registration for manual projections
such as `dependency-graph.yaml`, `learning-outcome-index.yaml`,
`capability-index.md`, and `capability-phase-index.md`. Existing canonical
generators may be used only where the sibling sidecar explicitly names them.

#### Immutable evidence / attestation — 27 span anchors

These records were not edited and remain byte-stable. The residual language is
registered as immutable historical evidence, not as eligible documentation:

| file | line anchors |
|---|---|
| `artifacts/operations/evidence/README.md` | 1, 3, 5, 7 |
| `artifacts/operations/evidence/spawn-validation-run-001.md` | 5, 19 |
| `artifacts/operations/evidence/spawn-validation-run-002.md` | 3, 5, 36–37, 39–40, 46 |
| `artifacts/operations/evidence/spawn-validation-run-003.md` | 3, 5, 37–38, 40–41, 48 |
| `artifacts/operations/evidence/spawn-validation-run-004.md` | 3, 5, 37–38, 40–41, 49 |

#### Provenance quote — 1 span anchor

`artifacts/engineering/decisions/learning-ontology-adoption-readiness.md:195`
contains the exact quoted source text `"Thư mục rỗng nghĩa là chưa có evidence
thật để lưu"`, retained because it faithfully quotes
`artifacts/operations/evidence/README.md:7`, an immutable source. The
surrounding decision prose remains English.

#### Learner-facing Vietnamese UX — 168 span anchors

The following HTML/mockup text nodes, labels, titles, `aria-label` copy, state
copy, and quoted learner examples remain Vietnamese-first by product
localization policy. Their HTML/CSS structure, IDs, classes, attributes with
machine meaning, and executable syntax remain unchanged:

| file | line anchors |
|---|---|
| `artifacts/experience/design/navigation/learner-shell.html` | 145, 150–151, 154, 160–161, 177, 179, 185, 188–190, 197, 205, 213, 223, 230, 240, 243–245, 251, 253, 255, 257, 259, 261, 263, 270, 272, 274, 278, 282–285, 346–351 |
| `artifacts/experience/design/wireframes/full-app.html` | 61, 63, 66, 68, 70, 72, 74, 76, 78, 80, 82 |
| `artifacts/experience/design/wireframes/full-system-wireframe.html` | 234–238, 250–252, 266–267, 277, 279–281, 294–295, 305, 307–309, 323–324, 335, 337–340, 342, 352, 354–357 |
| `artifacts/experience/design/wireframes/journeys/band-map.html` | 8–9, 11, 85–87, 92–93, 109–110, 112–113, 116–117, 121–124, 134, 136, 140, 142–143, 146–148, 158, 160–161 |
| `artifacts/experience/design/wireframes/journeys/daily-learning.html` | 85–87, 95–96, 102–105, 111–113 |
| `artifacts/experience/design/wireframes/journeys/deep-practice.html` | 74, 80–82, 88–90, 97–98 |
| `artifacts/experience/design/wireframes/journeys/exam-readiness.html` | 60–63, 73–75, 82–83, 89, 91, 97–99 |
| `artifacts/experience/design/wireframes/journeys/first-day.html` | 120–123, 130–131, 140, 146–148 |
| `artifacts/experience/design/wireframes/journeys/review-loop.html` | 76–77, 83–84, 86–89 |

#### Machine/executable token — 0 Vietnamese spans

No Vietnamese-bearing machine token or executable syntax span remains after
the safe batch. Controlled IDs, keys, enums, paths, operationIds, states,
commands, regexes, URLs, hashes, versions, and HTML/CSS syntax were treated as
preservation-only throughout.

### Protected packet requirements

The following non-overlapping packets are prepared as review scopes. The
literal translations below are exact packet anchors, not applied changes; each
packet must expand the same before/after mapping to every listed span before
approval.

| packet | exact scope | literal before → proposed after anchor | token evidence | required path |
|---|---|---|---|---|
| `T2-BP-FRAMEWORK` | All `blueprint/**` spans listed above, including `blueprint/framework/**` | `Bộ khung kiến thức IELTS (invariant) — **không chứa asset**, chỉ chứa framework.` → `The IELTS knowledge framework (invariant) — **contains no assets**; it contains only the framework.` | Pre/post protected-token multiset and span hashes must match; no IDs/enums/framework semantics may change. | `artifacts/operations/attestations/*.yaml` + `.github/CODEOWNERS` review |
| `T3-OPS-POLICY` | `PENDING-EVIDENCE.md`, acceptance/benchmark READMEs, build-readiness matrix, and `ssot-registry.md` spans listed above | `Đây là ledger mutable để founder theo dõi evidence còn nợ.` → `This is a mutable ledger for the founder to track outstanding evidence.` | Preserve gate states, evidence status, paths, hashes, and lifecycle values exactly. | `artifacts/operations/attestations/*.yaml` + `.github/CODEOWNERS` review |
| `T3-SPAWN-WORKFLOWS` | `artifacts/operations/spawn-prompts/**` spans listed above | `Đây là thư viện workflow artifact cho agent tạo Knowledge Asset.` → `This is the workflow artifact library for agents that create Knowledge Assets.` | Preserve prompt delimiters, schemas, stop rules, controlled vocabulary, commands, and registry IDs exactly. | `artifacts/operations/attestations/*.yaml` + `.github/CODEOWNERS` review |
| `T3-DECISION-PACKETS` | ADR-0004 and convergence batches 1–3 spans listed above | `LenBands là product IELTS, không phải một platform/runtime product.` → `LenBands is an IELTS product, not a platform/runtime product.` | Preserve decision status, diff markers, IDs, provider names, and architecture boundaries exactly. | `artifacts/operations/attestations/*.yaml` + `.github/CODEOWNERS` review |

Protected packet application is blocked pending the required external review;
these packets do not authorize a unilateral protected edit.

### Historical T1.2 completion state (superseded by T2 reconciliation)

Eligible mutable Vietnamese prose in the non-protected batch is **0**. The
repository-wide English-only documentation objective is **blocked/incomplete**:
2,018 protected span anchors await review, 83 generated-output anchors await
generator registration/regeneration, 27 immutable evidence anchors remain by
governance, 1 provenance quote remains by source fidelity, and 168
learner-facing UX anchors remain Vietnamese-first by product policy.

## 11. T2 MD/YAML reconciliation (2026-08-11)

This section supersedes the earlier 467-surface HTML-inclusive snapshot for
the current goal. The current universe is every repository-relative `.md`,
`.yaml`, and `.yml` file, including root guidance, `.claude/**`, `.github/**`,
`tools/**`, `blueprint/**`, `artifacts/**`, and `knowledge-assets/**`. Only
`.git/**`, `.cache/**`, and `.pnpm-store/**` are excluded as repository
internals/cache data; no documentation selector failure is an exclusion.

Deterministic manifest command:

```sh
rg --files --hidden -g '!/.git/**' -g '!.cache/**' -g '!.pnpm-store/**' \
  -g '*.md' -g '*.yaml' -g '*.yml' | sort
```

Current manifest: **491 files** (`231 .md`, `259 .yaml`, `1 .yml`), SHA-256
`9988bf935e4aaf74be3b775784978deb1a5ab02d7579b5273dc526fbcf970758`.

The detector uses Vietnamese-specific letters and a supplementary
non-ASCII-letter check. A bounded line is one inventory span unless a line
contains distinct prose fragments separated by machine syntax; math symbols,
IPA phonetic notation, URLs, identifiers, and executable tokens are not prose.
The scan found **2,162 Vietnamese-bearing spans** plus **20 supplementary
non-English-letter spans**, for **2,182 total non-English-letter spans**.

### Complete span disposition ledger

| disposition | pre-translation spans | post-translation spans | handling | current state |
|---|---:|---:|---|---|
| `safe_mutable_apply` | 34 | 0 | Translate in bounded batches; bump governed sidecars. | Complete for this scan. |
| `protected_translation_review` | 2,037 | 2,037 | Review packet, attestation, external CODEOWNERS approval, then approved application. Includes 2,033 Vietnamese spans and 4 Chinese-bearing framework spans. | Pending; no protected target file was edited. |
| `generated_via_canonical_generator` | 83 | 83 | Translate canonical source, register/execute the named generator, then regenerate and validate. | Blocked on generator registration for manual projections. |
| `immutable` | 27 | 27 | Preserve byte-for-byte; append a new record for any correction. | Preserved. |
| `provenance_exception` | 19 | 19 | Preserve and register exact reason. Includes 12 bilingual learner-content files, the source quotation, and six exact original-language review/source literals in this ledger. | Registered; not eligible for translation in this goal. |
| `machine_token` | 16 | 16 | Preserve exact phonetic notation or other non-prose data. | Preserved. |

The disposition is span-level, so file counts may overlap when one file has,
for example, both a phonetic machine token and a bilingual content field.
The 12 Knowledge Asset files under `knowledge-assets/vocabulary/*.md` are an
explicit boundary: their `definition_vi` values are bilingual learner-content
data, not author documentation. They remain unchanged under the
Knowledge Asset contract; this is a registered provenance/content exception,
not a silent path exclusion. The phonetic values in those files are separate
`machine_token` spans.

The six exact non-English review/source literals retained in this governance
ledger are registered here so the ledger itself does not create a false
`safe_mutable_apply` remainder:

| file:anchor | reason |
|---|---|
| `artifacts/operations/translation-migration-t0.md:481-482` | Exact quotation of immutable evidence source text; retained for provenance. |
| `artifacts/operations/translation-migration-t0.md:521` | Literal original for the T2 Blueprint/Framework review packet. |
| `artifacts/operations/translation-migration-t0.md:522` | Literal original for the T3 operations-policy review packet. |
| `artifacts/operations/translation-migration-t0.md:523` | Literal original for the T3 spawn-workflow review packet. |
| `artifacts/operations/translation-migration-t0.md:524` | Literal original for the T3 decision-packet review scope. |

The 16 `machine_token` spans are exact IPA/data anchors at
`artifacts/operations/spawn-prompts/spawn-vocab.md:96`,
`artifacts/operations/spawn-prompts/examples/vocab-card-example.md:3`,
`artifacts/engineering/contracts/learning-measurement-traceability-proposal.md:71`,
`blueprint/framework/vocab-collocation-topic.md:60`, and line `3` of each
of these 12 Knowledge Asset files:
`knowledge-assets/vocabulary/v_env_001.md`,
`v_env_002.md`, `v_env_003.md`, `v_env_004.md`, `v_env_005.md`,
`v_env_006.md`, `v_env_007.md`, `v_env_008.md`, `v_env_009.md`,
`v_env_010.md`, `v_education_001.md`, and `v_technology_001.md`.

### Protected packets

The following packets are disjoint by protected scope. The exact line-anchor
inventory for every Vietnamese-bearing protected span is the current table in
§10, plus the `AGENTS.md` anchors listed below and the four supplementary
Chinese-bearing framework anchors. A packet entry must be expanded before
approval into one record per exact file/anchor with these fields:

```yaml
exact_file_anchor: path/to/file.md:line-or-field
literal_original: exact source span copied byte-for-byte
english_replacement: proposed English replacement
token_preservation_assertion: protected token multiset and protected-span hash unchanged
semantic_no_change_review: lifecycle, authority, controlled vocabulary, readiness, and runtime meaning unchanged
change_id: <attestation change id>
change_scope: <exact disjoint packet scope>
protected_changes_reviewed: true
authority_boundaries_changed: false
validators_weakened: false
evidence_modified: false
readiness_claimed: false
commands_run: [tools/bin/lenbands verify, tools/bin/lenbands gate toolchain, tools/bin/lenbands gate p0]
external_review_required: true
required_review: .github/CODEOWNERS owner approval in a pull request
```

| packet | exact scope and current anchors | required application path |
|---|---|---|
| `T2-BP-FRAMEWORK` | `blueprint/**` (1,599 protected prose spans), including framework anchors in §10; supplementary non-English anchors: `blueprint/framework/band-descriptor-map.md:138-140` and `blueprint/framework/speaking-parts-framework.md:170`. | Protected-change attestation under `artifacts/operations/attestations/*.yaml`, pull request, external `.github/CODEOWNERS` review, approved application, token/citation/gate verification. |
| `T3-AGENT-GOV` | `AGENTS.md` (45 spans): `1, 3, 5, 8-10, 12, 14, 16-18, 20, 24, 26, 28, 30-44, 46, 49-50, 53, 55-59, 61, 70-71, 75-77`. | Same protected-change attestation and external CODEOWNERS review; no unilateral edit. |
| `T3-OPS-POLICY` | `ADR-0004-composition-first-application-platform.md` (41); `PENDING-EVIDENCE.md` (17); `acceptance/README.md` (8); `benchmark/README.md` (11); `build-readiness-matrix.md` (32); `ssot-registry.md` (14). Exact anchors remain in §10. | Same protected-change attestation and external CODEOWNERS review; readiness and evidence fields must remain unchanged. |
| `T3-SPAWN-WORKFLOWS` | `artifacts/operations/spawn-prompts/**` (270 protected prose spans across 10 files; phonetic tokens are separate machine-token spans). Exact anchors remain in §10. | Same protected-change attestation and external CODEOWNERS review; prompt delimiters, schemas, stop rules, commands, and registry IDs must remain exact. |

The packet table is an application-ready review scope and invariant contract;
the one-record-per-span literal mapping is still pending protected-owner
translation review. It is therefore not evidence that any protected prose is
translated or complete.

### Generator-gap blockers

No generated projection was hand-edited. The 83 generated spans are in the
eight catalog/projection files listed in §10. The unresolved gaps include
`artifacts/operations/catalogs/dependency-graph.yaml`,
`artifacts/operations/catalogs/learning-outcome-index.yaml`,
`artifacts/operations/catalogs/capability-index.md`, and
`artifacts/operations/catalogs/capability-phase-index.md`: the declared
generators `tools/gen_dependency_graph.py` and
`tools/gen_learning_outcome_index.py` are missing, and the relevant sidecars
remain `manual_projection_pending_generator`. Existing generators may be used
only where the sibling sidecar explicitly names them. These spans remain
blocked until registration and regeneration are available.

### T2 status

The safe mutable MD/YAML prose remainder is **0**. The full English-only
objective is **blocked/incomplete** because protected translation review and
generator registration/regeneration remain outstanding. Immutable,
provenance/content, and machine-token spans are preserved under their
registered dispositions.

## References

- `AGENTS.md`
- `artifacts/CONVENTION.md`
- `artifacts/operations/architecture-frozen.md`
- `artifacts/operations/agent-trust-policy.yaml`
- `blueprint/README.md`
- `blueprint/framework/README.md`
- `knowledge-assets/README.md`
