# Spawn Validation Reconciliation Run 007

## Run identity

- Run timestamp: `2026-08-07T21:00:00+07:00`
- Run type: immutable validation and revision reconciliation against framework `1.0.6`
- New asset generation: `0`
- External provider call: `0`
- Scope: validator evidence only; no rights decision, content approval, publish, benchmark, runtime acceptance, or mass-spawn unlock

Run 007 preserves runs 001–006 as historical records. Four payloads whose bytes had
changed while still labelled `0.1.0` are now versioned `0.1.1`; their current hashes
are recorded below. This repairs forward lineage without rewriting prior evidence.

## Asset snapshot

| Payload | Asset ID | Asset version | Framework refs | Payload SHA-256 |
|---|---|---:|---|---|
| `knowledge-assets/vocabulary/v_technology_001.md` | `KA-000011` | `0.1.0` | `vocab-collocation-topic@1.0.6#t_technology` | `sha256:f1a9983d841064b53787b1d63e44569baecca538d2db5d2efa93523b21d6d69d` |
| `knowledge-assets/vocabulary/v_education_001.md` | `KA-000012` | `0.1.0` | `vocab-collocation-topic@1.0.6#t_education` | `sha256:261df888c56b6e83c0d2d4470e3c9139c75f37512a1d3c51fd5678e443038f0b` |
| `knowledge-assets/grammar/gl_articles_basic_01.md` | `KA-000013` | `0.1.1` | `grammar-band-framework@1.0.6#g_articles_basic` | `sha256:051331bb841e2f17c5e7199403399057f1044c9a15965a18eb8a9e9cf8ec9852` |
| `knowledge-assets/grammar/gl_present_perfect_01.md` | `KA-000014` | `0.1.1` | `grammar-band-framework@1.0.6#g_present_perfect` | `sha256:d8d8dcf7112e8ee5d47104c8fff4e3d0f091f32e40f286d27b209ba09f159d05` |
| `knowledge-assets/writing-prompts/W_t_001.md` | `KA-000015` | `0.1.1` | `writing-task-framework@1.0.6#W_task2_opinion`; `vocab-collocation-topic@1.0.6#t_education` | `sha256:f271f8ca18965e3bc45d2d4cd1cddb2823dd2f0e6e4f72d4979875a425d33264` |
| `knowledge-assets/writing-prompts/W_t_002.md` | `KA-000016` | `0.1.1` | `writing-task-framework@1.0.6#W_task2_discussion`; `vocab-collocation-topic@1.0.6#t_technology,t_work_business` | `sha256:7d639c21596f0c0d04970e7a5181b7e34bec88ce35b3d9698c451286c24b25b3` |
| `knowledge-assets/collocations/c_verb_noun_technology_001.md` | `KA-000017` | `0.1.0` | `vocab-collocation-topic@1.0.6#c_verb_noun,t_technology` | `sha256:ec1665be9b76e1e7c9dbddbed9f023dbd6d86c4d20984620f48cf713ebfeaa11` |

## Validator result

```text
tools/bin/lenbands validate framework             → passed (1.0.6)
tools/bin/lenbands validate spawn-prompts         → passed (7 templates, 1.0.6)
tools/bin/lenbands validate knowledge-assets      → passed
tools/bin/lenbands validate contract-ownership    → passed (6 packs, 35 events, 25 operations)
```

This is the latest static validation snapshot. It does not supersede or manufacture
rights, calibration, benchmark, provider, founder-approval, runtime, or publish evidence.
