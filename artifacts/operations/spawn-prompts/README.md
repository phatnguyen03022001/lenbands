# Spawn Prompt Artifacts

Đây là thư viện workflow artifact cho agent tạo Knowledge Asset. Agent được phép và nên đọc thư mục này khi cần spawn; không có quy tắc cấm đọc hoặc cấm index.

## Authority boundary

- IELTS domain, controlled vocabulary và band semantics: `blueprint/framework/` là nguồn sự thật.
- Prompt template: file `spawn-*.md` trong thư mục này là workflow contract, không được tạo enum hoặc band ngoài framework.
- Prompt registry: `registry.yaml` là manifest/index vận hành, không phải nguồn sự thật mới.
- Learner content: `knowledge-assets/` cùng sidecar là canonical output; prompt không được trở thành bản content thứ hai.
- Evidence/run history: `artifacts/operations/evidence/` bất biến; không sửa run record cũ khi prompt đổi.

## Cách dùng

1. Đọc [registry.yaml](registry.yaml) để lấy `prompt_template_id`, owner, framework refs, output contract và validator.
2. Đọc prompt artifact tương ứng.
3. Chỉ dùng input có id tồn tại trong framework; thiếu id thì trả `unknown_*` và dừng.
4. Nếu không đủ bằng chứng hoặc không chắc, trả `needs_review`; không bịa.
5. Output chỉ đi vào `knowledge-assets/` với payload `.md` và sidecar `.meta.yaml`, status ban đầu là `draft`.
6. Chạy `./tools/validate-spawn-prompts.sh` và `./tools/validate-knowledge-assets.sh`.

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

## Không được claim

Prompt pass validator chỉ chứng minh cấu trúc, reference và integrity của workflow. Nó không chứng minh chất lượng IELTS, rights, calibration, benchmark hoặc learner outcome. Những claim đó cần evidence riêng và không được tự chuyển asset sang `published`.
