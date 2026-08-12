# Spawn Validation Revalidation Run 005

## Run identity

- Run timestamp: `2026-08-07T08:13:54Z`
- Run type: immutable revalidation of the seven existing validation assets after framework `1.0.4`
- New asset generation: `0`
- External provider call: `0`
- Model/provider generation: not invoked; this run only recomputed hashes and ran validators
- `unknown_*` findings: `0`

## Asset snapshot

| Payload | Asset ID | Framework refs | Existing spawn lineage | Payload SHA-256 |
|---|---|---|---|---|
| `knowledge-assets/vocabulary/v_technology_001.md` | `KA-000011` | `vocab-collocation-topic@1.0.4#t_technology` | `spawn-validation-run-001` | `sha256:f1a9983d841064b53787b1d63e44569baecca538d2db5d2efa93523b21d6d69d` |
| `knowledge-assets/vocabulary/v_education_001.md` | `KA-000012` | `vocab-collocation-topic@1.0.4#t_education` | `spawn-validation-run-001` | `sha256:261df888c56b6e83c0d2d4470e3c9139c75f37512a1d3c51fd5678e443038f0b` |
| `knowledge-assets/grammar/gl_articles_basic_01.md` | `KA-000013` | `grammar-band-framework@1.0.4#g_articles_basic` | `spawn-validation-run-001` | `sha256:3f1d99103eabc00837e23382d4449d31af408530d4221923ff7dfc28ddf84f05` |
| `knowledge-assets/grammar/gl_present_perfect_01.md` | `KA-000014` | `grammar-band-framework@1.0.4#g_present_perfect` | `spawn-validation-run-001` | `sha256:489790642d4c7a309371c73ab9988a522ad6af884315a58ff191e7d4997d7435` |
| `knowledge-assets/writing-prompts/W_t_001.md` | `KA-000015` | `writing-task-framework@1.0.4#W_task2_opinion`; `vocab-collocation-topic@1.0.4#t_education` | `spawn-validation-run-001` | `sha256:29f07306255c2a96854f87b4ea65fe2b0a85d45c694bebfe6a6d981f9fb479f1` |
| `knowledge-assets/writing-prompts/W_t_002.md` | `KA-000016` | `writing-task-framework@1.0.4#W_task2_discussion`; `vocab-collocation-topic@1.0.4#t_technology,t_work_business` | `spawn-validation-run-001` | `sha256:822ab37a7ec765266dde3ce07162dee533634f87b892a8555f116a7958ce2535` |
| `knowledge-assets/collocations/c_verb_noun_technology_001.md` | `KA-000017` | `vocab-collocation-topic@1.0.4#c_verb_noun,t_technology` | `spawn-validation-run-001` | `sha256:ec1665be9b76e1e7c9dbddbed9f023dbd6d86c4d20984620f48cf713ebfeaa11` |

## Lineage and prompt snapshot

Current sidecars preserve the original spawn lineage and now pin the revalidated framework version. Prompt hashes were not recomputed because no prompt template or generation call ran in this revalidation:

| Asset family | Prompt template | Prompt hash |
|---|---|---|
| Vocabulary | `spawn-vocab` | `sha256:abc485c9a5168f0544b7703aae2b914b8a61a7e6dc79210988508911bb7fbc09` |
| Grammar | `spawn-grammar-lesson` | `sha256:fd8ab5a9dcdd6d1139c466b7a4304b15c7c273f46fb74663453628a0285cc501` |
| Writing prompt | `spawn-writing-prompt` | `sha256:013eb5ad8aafb167edcb0006100b27972e1ea204b51c3db0708d9ba57dccd6a3` |
| Collocation | `spawn-collocation` | `sha256:11aa97ddb0e96b7f644680aaa43eb56325aeb5ffc0db26bea13dbf472d9d68f3` |

## Validator result

The following commands completed successfully at run time:

```text
./tools/validate-framework.sh       → framework validation passed (version 1.0.4)
./tools/validate-knowledge-assets.sh → knowledge asset validation passed
./tools/validate-semantic-contracts.sh → semantic contract validation passed
./tools/validate-openapi.sh         → openapi validation passed
./tools/validate-documents.sh       → document validation passed
```

This record proves pipeline revalidation only. It does not prove rights, calibration, benchmark quality, founder approval, or publish eligibility.
