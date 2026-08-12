# Spawn Validation Final Revalidation Run 006

## Run identity

- Run timestamp: `2026-08-07T08:22:50Z`
- Run type: final immutable revalidation of the seven existing draft assets against framework `1.0.4`
- New asset generation: `0`
- External provider call: `0`
- `unknown_*` findings: `0`
- Scope: validation only; no rights decision, publish, founder approval or mass-spawn unlock

## Asset snapshot

| Payload | Asset ID | Framework refs | Payload SHA-256 |
|---|---|---|---|
| `knowledge-assets/vocabulary/v_technology_001.md` | `KA-000011` | `vocab-collocation-topic@1.0.4#t_technology` | `sha256:f1a9983d841064b53787b1d63e44569baecca538d2db5d2efa93523b21d6d69d` |
| `knowledge-assets/vocabulary/v_education_001.md` | `KA-000012` | `vocab-collocation-topic@1.0.4#t_education` | `sha256:261df888c56b6e83c0d2d4470e3c9139c75f37512a1d3c51fd5678e443038f0b` |
| `knowledge-assets/grammar/gl_articles_basic_01.md` | `KA-000013` | `grammar-band-framework@1.0.4#g_articles_basic` | `sha256:3f1d99103eabc00837e23382d4449d31af408530d4221923ff7dfc28ddf84f05` |
| `knowledge-assets/grammar/gl_present_perfect_01.md` | `KA-000014` | `grammar-band-framework@1.0.4#g_present_perfect` | `sha256:489790642d4c7a309371c73ab9988a522ad6af884315a58ff191e7d4997d7435` |
| `knowledge-assets/writing-prompts/W_t_001.md` | `KA-000015` | `writing-task-framework@1.0.4#W_task2_opinion`; `vocab-collocation-topic@1.0.4#t_education` | `sha256:29f07306255c2a96854f87b4ea65fe2b0a85d45c694bebfe6a6d981f9fb479f1` |
| `knowledge-assets/writing-prompts/W_t_002.md` | `KA-000016` | `writing-task-framework@1.0.4#W_task2_discussion`; `vocab-collocation-topic@1.0.4#t_technology,t_work_business` | `sha256:822ab37a7ec765266dde3ce07162dee533634f87b892a8555f116a7958ce2535` |
| `knowledge-assets/collocations/c_verb_noun_technology_001.md` | `KA-000017` | `vocab-collocation-topic@1.0.4#c_verb_noun,t_technology` | `sha256:ec1665be9b76e1e7c9dbddbed9f023dbd6d86c4d20984620f48cf713ebfeaa11` |

## Validator result

```text
./tools/validate-framework.sh         → framework validation passed (version 1.0.4)
./tools/validate-knowledge-assets.sh  → knowledge asset validation passed
./tools/validate-semantic-contracts.sh → semantic contract validation passed
./tools/validate-openapi.sh           → openapi validation passed
./tools/validate-documents.sh         → document validation passed
```

This immutable record supersedes run-005 as the latest validation snapshot. It does not prove rights, calibration, benchmark quality, provider readiness, founder approval or publish eligibility.
