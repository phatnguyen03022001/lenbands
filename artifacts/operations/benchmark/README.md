# Evaluation Benchmark Intake and Run Contract

Đây là workflow để biến một corpus Writing Task 2 được cấp quyền thành benchmark run bất biến. Nó không chứa essay hoặc audio; payload learner phải ở ngoài repository hoặc trong kho được cấp quyền, còn manifest chỉ giữ opaque reference, label và provenance cần audit.

## Trạng thái hiện tại

`gold-corpus-manifest.yaml` đang `status: missing` với `gold_case_count: 0`. `numeric-threshold-policy.yaml` có candidate numbers nhưng `approval_state: pending_founder` và `armed: false`. Vì vậy chưa có benchmark run hợp lệ và route evaluation vẫn bị block.

## Intake gate

Một corpus chỉ được chuyển `ready` khi mỗi case có:

- opaque `case_id` và `essay_ref`, không commit raw essay;
- Task 2 type/version và rubric version resolve về framework;
- reference labels cho TR/CC/LR/GRA + overall band;
- label method và qualified reference provenance;
- rights/permission evidence immutable;
- dataset version/hash và split không overlap với regression/test set.

## Run gate

`tools/run-writing-benchmark.sh` chỉ ghi run record khi corpus đã `ready`, result file có đủ case IDs, threshold policy đã `armed`, cost ceiling không rỗng và caller cung cấp `--reviewed-by`. Tool không overwrite output; run record mới luôn là snapshot mới.

Run pass không tự cấp quyền publish. Release vẫn cần `OPS.ReleaseGate`, acceptance runtime và review theo owner.

## Input/result shape

Corpus manifest giữ reference labels, không giữ raw learner content:

```yaml
cases:
  - case_id: G-WRITING-0001
    task_type: W_task2_opinion
    task_version: 0.1.0
    essay_ref: vault://approved-corpus/...
    reference:
      criteria: {task_response: 6.0, coherence_cohesion: 6.0, lexical_resource: 6.5, grammar: 6.0}
      overall_band: 6.0
```

Evaluator results use the same `case_id` and contain only structured output metrics. Raw essay, prompt, chain-of-thought and provider payload are forbidden.
