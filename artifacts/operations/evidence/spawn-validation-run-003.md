# Spawn Validation Recheck 003 — Framework 1.0.2

Metadata canonical ở sibling `spawn-validation-run-003.meta.yaml`.

**Immutable run record:** tạo ngày `2026-08-07` sau framework clarification patch `1.0.2`. Đây là revalidation của 7 asset draft đã spawn ở run-001, không phải spawn mới và không phải approval/publish. Không sửa file này sau khi ghi nhận.

## Run parameters

```yaml
workflow_run_id: spawn-validation-run-003
source_spawn_run: spawn-validation-run-001
prior_revalidation: spawn-validation-run-002
mode: revalidate_existing_draft_assets
framework_version: 1.0.2
model: n/a_revalidation
parameters: {}
validator: ./tools/validate-knowledge-assets.sh
validator_result: passed
unknown_count: 0
needs_review_count: 2
```

## Asset checksum record

| Asset | Payload SHA-256 | Current framework refs | Status |
|---|---|---|---|
| `knowledge-assets/vocabulary/v_technology_001.md` | `sha256:f1a9983d841064b53787b1d63e44569baecca538d2db5d2efa93523b21d6d69d` | `vocab-collocation-topic@1.0.2:t_technology` | draft |
| `knowledge-assets/vocabulary/v_education_001.md` | `sha256:261df888c56b6e83c0d2d4470e3c9139c75f37512a1d3c51fd5678e443038f0b` | `vocab-collocation-topic@1.0.2:t_education` | draft |
| `knowledge-assets/grammar/gl_present_perfect_01.md` | `sha256:489790642d4c7a309371c73ab9988a522ad6af884315a58ff191e7d4997d7435` | `grammar-band-framework@1.0.2:g_present_perfect` | draft |
| `knowledge-assets/grammar/gl_articles_basic_01.md` | `sha256:3f1d99103eabc00837e23382d4449d31af408530d4221923ff7dfc28ddf84f05` | `grammar-band-framework@1.0.2:g_articles_basic` | draft |
| `knowledge-assets/writing-prompts/W_t_001.md` | `sha256:c23985cf6118ff32566d3e04172de51f9b57df11eae9fa2672c2a81ee3f81a00` | `writing-task-framework@1.0.2:W_task2_opinion`; `vocab-collocation-topic@1.0.2:t_education` | draft |
| `knowledge-assets/writing-prompts/W_t_002.md` | `sha256:0bd2951cecd3fe88ac6882f541f2322a8c1a2bcfee79d3ff2aed3c3b3680bdc6` | `writing-task-framework@1.0.2:W_task2_discussion`; `vocab-collocation-topic@1.0.2:t_technology,t_work_business` | draft |
| `knowledge-assets/collocations/c_verb_noun_technology_001.md` | `sha256:ec1665be9b76e1e7c9dbddbed9f023dbd6d86c4d20984620f48cf713ebfeaa11` | `vocab-collocation-topic@1.0.2:c_verb_noun,t_technology` | draft |

## Findings

- Checksum payload: `7/7` khớp sidecar tại thời điểm revalidation.
- `framework_refs`: `7/7` resolve đúng file/version/node type.
- `unknown_*`: `0`.
- `needs_review`: `2` grammar asset vẫn giữ cờ vì framework node summary chưa đủ `can_statement`/edge provenance; revalidation không tự bịa các field này.
- Rights/governance: vẫn `pending_review`/`draft`; record này không cấp quyền publish.

## References

- `spawn-validation-run-001.md` — historical spawn record, immutable.
- `spawn-validation-run-002.md` — prior revalidation record, immutable.
- `tools/validate-knowledge-assets.sh` — validator run.
- `artifacts/operations/asset-spawn-freeze-gate.md` — mass-spawn gate vẫn chưa approved.
