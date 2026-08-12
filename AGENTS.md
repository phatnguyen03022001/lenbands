# AGENTS.md — Hướng dẫn cho AI Agent

Đây là entry point cho mọi AI agent (Claude Code, ZCode, subagent, cheap spawn agent) làm việc trong repo LenBands.

## Reading order (đọc theo thứ tự)

1. `README.md` — layout repo + linking
2. `blueprint/README.md` — hub blueprint, nguyên tắc xuyên suốt, document map
3. `blueprint/01-product.md` → `08-roadmap.md` — spoke blueprint theo thứ tự
4. `blueprint/framework/README.md` — IELTS Knowledge Framework (bộ gen domain)
5. `artifacts/README.md` + `artifacts/CONVENTION.md` — artifact rule
6. `artifacts/operations/spawn-prompts/README.md` + `registry.yaml` — chỉ khi task tạo Knowledge Asset

Repository-wide freeze: đọc `artifacts/operations/architecture-frozen.md` trước khi thay đổi capability, family, runtime contract hoặc validator.

Trước mọi task code, chạy `tools/bin/lenbands context` để lấy authority map, P0 blockers,
protected paths và handoff commands hiện hành. Output của command là context projection;
file authority bên dưới vẫn là nguồn sự thật.

Không đọc toàn bộ repo cùng lúc. Đọc theo need.

## Prompt workflow artifacts

`artifacts/operations/spawn-prompts/` là thư viện workflow artifact cho agent spawn. Agent được phép đọc/index khi workflow cần; prompt không phải SSOT domain và không được dùng để thay thế `blueprint/framework/`.

Đọc `artifacts/operations/spawn-prompts/README.md` và `registry.yaml` trước khi dùng prompt. Mọi prompt phải qua `tools/validate-spawn-prompts.sh`; output đi `knowledge-assets/`, không đi vào thư mục prompt.

## Nguyên tắc cứng (cho mọi agent)

1. **Controlled vocabulary**: id ngoài framework enum → báo `unknown_*`, không tự đặt tên.
2. **Không tự suy luận**: framework thiếu → báo + flag, không bịa.
3. **SSOT**: mỗi năng lực 1 capability id, mỗi dữ liệu 1 owner. Catalog/index = projection, không phải nguồn.
4. **Sole evaluator**: AI chấm 100%, không human-in-the-loop.
5. **No-AI-label UI**: UI không dùng chữ "AI" hay icon AI.
6. **Privacy**: không emit learner content (essay/audio/error text) vào event/log.
7. **Evidence over prose**: `approved` cần evidence thật, không phải claim.
8. **Không bypass tooling**: không được xóa validator khỏi `verify`, đổi gate fail-closed
   thành warning/success, giảm evidence requirement, sửa/xóa immutable evidence, hoặc sửa
   test để hợp thức hóa validator yếu hơn.
9. **Protected change**: thay đổi validator, gate, framework, freeze/domain/trust policy,
   manifest/toolchain hoặc CI trust config phải kèm change attestation theo
   `artifacts/operations/agent-trust-policy.yaml` và cần external CODEOWNERS review.
10. **Stable command surface**: agent/human gọi `tools/bin/lenbands`; direct
    `tools/commands/**` chỉ dành cho internal composition và tests.

## Scope hiện tại

- P0 = closed pilot = Writing Task 2 loop. Listening/Reading/Speaking/Pronunciation/Mock Test/full Colab/Admin = deferred.
- Blueprint là design SSOT; P0 artifact chỉ build-ready khi Build Readiness Matrix và evidence gate xác nhận, không suy ra từ prose.
- Framework IELTS v1.0.6 — versioned controlled vocabulary; coverage gap phải được báo bằng `unknown_*`.
- Build readiness: `artifacts/operations/build-readiness-matrix.md` (P0-01..06).

## Khi sửa artifact/blueprint

- Bump version (minor: thêm, patch: sửa, deprecated: không xóa).
- Cập nhật `build-readiness-matrix.md` nếu động P0 pack.
- Traceability: `derived_from` phải ghi capability id thật.
- File dưới `artifacts/operations/evidence/` là append-only: chỉ thêm record mới, không
  sửa/xóa record cũ. Reconciliation phải tạo record versioned mới.

## Handoff bắt buộc

```bash
tools/bin/lenbands doctor
tools/bin/lenbands verify
tools/bin/lenbands gate toolchain
tools/bin/lenbands gate p0
```

`gate p0` exit `3` là blocked state hợp lệ khi evidence còn thiếu; không được đổi thành
success. Protected diff phải pass `tools/bin/lenbands validate trust-boundary --diff ...`.

## Khi spawn asset (cho cheap agent)

- Đọc `artifacts/operations/spawn-prompts/README.md` + `registry.yaml` → chọn prompt theo loại asset.
- Asset output đi `knowledge-assets/`, KHÔNG đi `artifacts/operations/spawn-prompts/`.
- Framework là SSOT cho mọi domain enum; Knowledge Asset sidecar là SSOT cho metadata của từng asset.
