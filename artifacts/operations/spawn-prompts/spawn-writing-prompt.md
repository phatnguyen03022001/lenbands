# PROMPT: Spawn Writing Task Prompt (DeepSeek V4 Flash)

> Copy từ `---BẮT ĐẦU---` đến cuối. Thay 3 tham số.

---BẮT ĐẦU---

Bạn là content spawner cho app IELTS LenBands. Nhiệm vụ: sinh Writing Task prompt từ framework. KHÔNG dùng kiến thức training — chỉ dùng framework trong repo.

## THAM SỐ
- task_type: `W_task2_opinion`  (phải có trong writing-task-framework.md; options: W_task2_opinion, W_task2_discussion, W_task2_advantages_disadvantages, W_task2_problem_solution, W_task2_two_part, W_ac_task1_chart, W_gt_task1_formal_letter, W_gt_task1_semi_formal_letter, W_gt_task1_informal_letter)
- exam_module: `academic`  (hoặc `general_training`)
- count: 5 prompt

## BƯỚC 1 — ĐỌC FRAMEWORK
- `blueprint/framework/writing-task-framework.md`  ← task type enum + structure + critical requirements
- `blueprint/framework/band-descriptor-map.md`  ← band 6→7 phân biệt cho Writing
- `blueprint/framework/vocab-collocation-topic.md`  ← topic enum (10 topic) cho prompt topic
- `blueprint/framework/grammar-band-framework.md`  ← grammar point gợi ý cho prompt
- `blueprint/framework/README.md`

Nếu `task_type` không có trong framework → báo `unknown_task_type`, DỪNG.

## BƯỚC 2 — SINH 5 PROMPT
Mỗi prompt phải:
- Thuộc đúng `task_type` (opinion = "To what extent do you agree/disagree", discussion = "Discuss both views", v.v.).
- Topic thuộc 10 topic enum.
- Band-appropriate (Task 2 academic cần abstract reasoning, không quá cụ thể).
- KHÔNG copy Cambridge bản gốc — viết mới (origin: `cambridge_pattern`).

## BƯỚC 3 — SCHEMA WRITING TASK

```yaml
task_id: W_t_001
exam_module: academic
task_type: W_task2_opinion
prompt_text: |
  Some people believe that governments should invest more money in public transportation systems.
  To what extent do you agree or disagree?
prompt_word_count_target: 250
prompt_hash: <hash của prompt_text — compute sau>
band_range: 5.0-9.0
rights:
  origin: cambridge_pattern
  origin_ref: "original prompt, pattern follows IELTS Task 2 opinion"
tags:
  topic: [t_transport_travel, t_society_culture]
  microskill_ref: [W_position_clarity, W_idea_development]
status: draft
version: 0.1.0
```

## LUẬT CỨNG
1. `task_type` PHẢI có trong `writing-task-framework.md`. Ngoài → `unknown_task_type`, DỪNG.
2. `topic` PHẢI thuộc 10 topic enum.
3. `microskill_ref` PHẢI có trong `microskill-enum.md`.
4. `prompt_text` phải đúng pattern `task_type` (vd opinion = "agree/disagree", không nhầm sang "discuss both views").
5. `rights.origin` phải hợp lệ enum.
6. KHÔNG copy Cambridge prompt thật — viết mới.
7. 5 prompt phải **đa dạng topic** — không lặp 1 topic.

## ĐIỀU KIỆN DỪNG
- task_type không có → `unknown_task_type`, DỪNG.
- Không chắc pattern → ghi `needs_review`.

## SIDECAR META.YAML SCHEMA (canonical)
```yaml
type: knowledge-asset
asset_kind: writing_prompt
asset_id: KA-NNNNNN
status: draft
version: 0.1.0
owner: colab
derived_from: [KA.Exercise]
framework_refs:
  - file: writing-task-framework
    version: 1.0.6
    nodes: [W_task2_opinion]
origin: {source: generated, license: unknown}
integrity: {checksum: sha256:<64-hex-payload-hash>, payload_file: W_t_001.md}
governance: {rights_status: pending_review, review_status: draft}
spawn_lineage: {workflow_run_id: <actual-run-id>, prompt_template_id: spawn-writing-prompt, prompt_hash: <hash>, model: <model-id>, parameters: {task_type: W_task2_opinion, exam_module: academic}}
created_at: "2026-08-07T00:00:00Z"
updated_at: "2026-08-07T00:00:00Z"
```

Sidecar là metadata canonical; `rights.origin` trong payload là authoring-side classification, không thay thế sidecar `origin`.

## OUTPUT
2 file mỗi prompt:
- `knowledge-assets/writing-prompts/W_t_001.md`
- `knowledge-assets/writing-prompts/W_t_001.meta.yaml`

Output sidecar phải theo schema canonical ở trên và checksum đúng payload `.md`.

Bắt đầu: đọc framework, xác nhận task_type, sinh 5 prompt.

---KẾT THÚC---
