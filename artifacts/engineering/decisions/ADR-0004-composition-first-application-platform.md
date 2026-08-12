# ADR-0004 — Composition-first Application Platform

## Status

Review

## Context

LenBands là product IELTS, không phải một platform/runtime product. Tự viết lại
foundation runtime làm tăng attack surface, maintenance cost và thời gian tới learner
outcome mà không tạo lợi thế domain. Stack chính thức vẫn là Go (request/orchestration),
Python (async evaluation/data) và Next.js (web surface), nhưng mỗi layer phải compose
framework hoặc managed service phù hợp thay vì dựng framework riêng.

## Decision

1. Chỉ code domain-specific IELTS: knowledge model, learning loop, evaluation evidence,
   learner UX, policy và adapter mỏng tại provider boundary.
2. Bắt buộc build/buy cho auth, authorization primitive, managed database, object storage,
   queue/workflow execution, scheduler, retries/DLQ, observability, deployment, payment,
   email, migration/query tooling, API client/server generation, validation, feature flags
   và FSRS implementation.
3. Không viết custom generic runtime, job framework, workflow engine, scheduler, ORM/query
   builder, auth system, OpenAPI generator/client, telemetry pipeline, model gateway hoặc
   FSRS mathematics. Một adapter domain-specific không được trở thành abstraction platform.
4. Redis Streams trong P0 là transport boundary, không là authorization để dựng queue
   runtime. Nếu worker/retry/DLQ/scheduling vượt khả năng managed library/service đã chọn,
   phải mở Build/Buy decision thay vì mở rộng custom worker framework.
5. Mỗi dependency/provider mới cần owner, pinned version/contract, data boundary, cost
   boundary, security/privacy review, observability integration và exit/migration path.
   Provider selection tuân theo `artifacts/business/decisions/build-buy-register.md`.
6. Mọi logic mang giá trị kinh doanh phải nằm trong domain contract. Framework, runtime
   và provider chỉ được xuất hiện sau adapter boundary và phải thay thế được mà không đổi
   capability identity, IELTS semantics, event meaning, rubric, evidence hoặc learner state.

## Commodity boundary — không tự viết

Ngoài runtime/workflow concern ở trên, LenBands không tự tạo cache framework, event bus,
dependency-injection container, validation library, CLI framework, config loader, logger,
retry framework, plugin loader, template engine, Markdown parser, AST parser, diff engine,
scheduler, message broker, search engine hoặc vector database. Dùng implementation trưởng
thành và pin dependency; custom code chỉ được phép là adapter mỏng mang domain contract.

Một exception phải chỉ ra domain invariant không thể biểu diễn qua giải pháp hiện có,
benchmark/runtime blocker, tổng chi phí ownership, security impact và exit plan. “Muốn
kiểm soát nhiều hơn” hoặc “có thể viết” không phải evidence.

## Consequences

- Chưa chọn provider hay framework cụ thể khi chưa có procurement/evidence; ADR này không
  biến candidate thành approved platform vendor.
- Khi source code được scaffold, dependency manifests của Go, Python và Next.js phải là
  inventory canonical cho version đã chọn. Tooling chỉ validate inventory và boundary,
  không tự tạo runtime abstraction.
- Một proposal muốn tự build bất kỳ concern bị cấm nào phải có evidence-backed exception
  ADR nêu rõ runtime blocker, ownership cost và exit plan.

## Acceptance

- Không merge source runtime nếu thiếu dependency manifest tương ứng.
- Không merge generic package thuộc danh sách bị cấm khi chưa có exception ADR approved.
- Runtime implementation chứng minh dùng framework/managed component qua lockfile,
  configuration, integration test và observability evidence; prose không đủ.
- Provider replacement test không được yêu cầu migration IELTS domain semantics; chỉ
  adapter/configuration/provider-specific state được phép thay đổi.
