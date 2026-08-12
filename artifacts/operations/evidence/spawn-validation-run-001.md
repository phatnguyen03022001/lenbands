# Spawn Validation Run 001

## Record status

Đây là immutable run record của validation exception được phép trong `asset-spawn-freeze-gate.md`. Record này không phải founder approval và không cấp quyền publish.

```yaml
evidence_id: spawn-validation-run-001
run_at: "2026-08-07T05:54:58Z"
workflow_run_id: spawn-validation-run-001
freeze_gate_status: review
exception: validation-only
max_assets: 7
asset_status_after_run: draft
unknown_count: 0
needs_review_count: 2
```

## Inputs và lineage

| Asset | Asset ID | Framework refs | Prompt template | Prompt hash |
|---|---|---|---|---|
| `knowledge-assets/vocabulary/v_technology_001.md` | `KA-000011` | `vocab-collocation-topic@1.0.0#t_technology` | `spawn-vocab` | `sha256:abc485c9a5168f0544b7703aae2b914b8a61a7e6dc79210988508911bb7fbc09` |
| `knowledge-assets/vocabulary/v_education_001.md` | `KA-000012` | `vocab-collocation-topic@1.0.0#t_education` | `spawn-vocab` | `sha256:abc485c9a5168f0544b7703aae2b914b8a61a7e6dc79210988508911bb7fbc09` |
| `knowledge-assets/grammar/gl_articles_basic_01.md` | `KA-000013` | `grammar-band-framework@1.0.0#g_articles_basic` | `spawn-grammar-lesson` | `sha256:fd8ab5a9dcdd6d1139c466b7a4304b15c7c273f46fb74663453628a0285cc501` |
| `knowledge-assets/grammar/gl_present_perfect_01.md` | `KA-000014` | `grammar-band-framework@1.0.0#g_present_perfect` | `spawn-grammar-lesson` | `sha256:fd8ab5a9dcdd6d1139c466b7a4304b15c7c273f46fb74663453628a0285cc501` |
| `knowledge-assets/writing-prompts/W_t_001.md` | `KA-000015` | `writing-task-framework@1.0.0#W_task2_opinion`; `vocab-collocation-topic@1.0.0#t_education` | `spawn-writing-prompt` | `sha256:013eb5ad8aafb167edcb0006100b27972e1ea204b51c3db0708d9ba57dccd6a3` |
| `knowledge-assets/writing-prompts/W_t_002.md` | `KA-000016` | `writing-task-framework@1.0.0#W_task2_discussion`; `vocab-collocation-topic@1.0.0#t_technology,t_work_business` | `spawn-writing-prompt` | `sha256:013eb5ad8aafb167edcb0006100b27972e1ea204b51c3db0708d9ba57dccd6a3` |
| `knowledge-assets/collocations/c_verb_noun_technology_001.md` | `KA-000017` | `vocab-collocation-topic@1.0.0#c_verb_noun,t_technology` | `spawn-collocation` | `sha256:11aa97ddb0e96b7f644680aaa43eb56325aeb5ffc0db26bea13dbf472d9d68f3` |

Model recorded for this local validation run: `codex`. No external provider call was made.

## Payload integrity

| Payload | SHA-256 |
|---|---|
| `v_technology_001.md` | `sha256:f1a9983d841064b53787b1d63e44569baecca538d2db5d2efa93523b21d6d69d` |
| `v_education_001.md` | `sha256:261df888c56b6e83c0d2d4470e3c9139c75f37512a1d3c51fd5678e443038f0b` |
| `gl_articles_basic_01.md` | `sha256:3f48e96a2c2c839d4bed78da7ab552e9bf2ab8916c47120ca181ae7f3fd937dd` |
| `gl_present_perfect_01.md` | `sha256:daf91fb270a3ecef41ce9e60b4e1c84c1f3d99521867f2ce2ce6b9b284e73e91` |
| `W_t_001.md` | `sha256:c23985cf6118ff32566d3e04172de51f9b57df11eae9fa2672c2a81ee3f81a00` |
| `W_t_002.md` | `sha256:0bd2951cecd3fe88ac6882f541f2322a8c1a2bcfee79d3ff2aed3c3b3680bdc6` |
| `c_verb_noun_technology_001.md` | `sha256:ec1665be9b76e1e7c9dbddbed9f023dbd6d86c4d20984620f48cf713ebfeaa11` |

## Validation result

Commands executed:

```text
./tools/validate-knowledge-assets.sh → knowledge asset validation passed
./tools/validate-documents.sh → document validation passed
./tools/validate-openapi.sh → openapi validation passed
```

`unknown_*`: 0. `needs_review`: 2 grammar metadata fields are not defined in the current framework summary. Checksum mismatches: 0. Duplicate `asset_id`: 0. Published assets: 0.

## Approval boundary

Founder endorsement is pending and must be recorded separately. This run validates the pipeline only; it does not verify third-party rights, benchmark quality, calibration, learner outcome or publication eligibility.
