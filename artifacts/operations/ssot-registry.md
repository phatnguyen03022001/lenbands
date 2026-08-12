# SSOT Registry — Authority Boundaries

## Kết luận kiểm tra

Repo không có “3 SSOT” theo nghĩa mọi thứ đều là nguồn sự thật. Có 3 lớp lifecycle ở top level, nhưng nhiều registry có authority khác nhau bên trong. Vì vậy đếm `~11 nguồn` chỉ là một inventory heuristic; nó không được dùng như một invariant. Authority phải được đọc theo phạm vi dưới đây.

| Registry / entity | Authority | Nguồn sự thật cho | Không phải nguồn sự thật cho | Bằng chứng trong repo |
|---|---|---|---|---|
| Blueprint hub + `01`–`08` | `canonical` | product invariant, capability identity, product scope | OpenAPI, runtime data, learner content | `blueprint/README.md`; `blueprint/01-product.md` § SSOT |
| IELTS Knowledge Framework — 10 domain files | `canonical-domain` | IELTS enum, node IDs, band/task/error/microskill semantics | asset payload, benchmark result | `blueprint/framework/README.md` § Files/Nguyên tắc dùng |
| Public IELTS official material | `external-normative` | official descriptor/band/conversion khi repo mâu thuẫn | product behavior và internal policy | `blueprint/framework/README.md` § Nguyên tắc dùng |
| Event Contract in Blueprint | `canonical-product-fact` | event identity, envelope, outcome semantics | transport/schema implementation details | `blueprint/03-features.md` § Event Contract; `blueprint/07-conventions.md` |
| Event schema pack + slice event contracts | `implementation-contract` | producer/consumer payload and privacy enforcement | đổi tên hoặc định nghĩa outcome event | `artifacts/engineering/contracts/events/event-schema-pack.md` |
| Runtime State Model | `canonical-product-state` | state axes used by Home/recommendation/recovery | persisted database schema by itself | `blueprint/02-architecture.md` § Runtime State Model |
| Roadmap | `canonical-phasing` | phase and release sequencing | capability identity/invariants | `blueprint/08-roadmap.md` |
| Runtime failure taxonomy contract | `implementation-registry` | internal failure codes and public projection | IELTS learner error taxonomy | `artifacts/engineering/contracts/runtime/failure-taxonomy-contract.md` |
| Framework error taxonomy | `canonical-domain` | IELTS learner error IDs and criterion impact | runtime retry/provider failures | `blueprint/framework/error-taxonomy.md` |
| Evaluation contract | `implementation-contract` | evaluation request/result/audit/quality-state boundary | benchmark result or calibration claim | `artifacts/engineering/contracts/evaluation/evaluation-contract.md` |
| Capability manifest | `typed-projection-seed` | P0 family compilation context and readiness blockers | capability identity/product semantics | `artifacts/operations/capability-manifest.yaml` (`source_of_truth: false`) |
| Capability family registry | `implementation-registry` | family identity, schema, invariants, runtime boundary, shared contracts/entities/events/failures/acceptance/evidence | capability identity (belongs to blueprint) | `artifacts/operations/capability-family-registry.yaml` (`source_of_truth: true`) |
| Capability family map | `implementation-registry` | capability-to-family resolution, delta scoping, owner spec assignment | capability identity or product semantics | `artifacts/operations/capability-family-map.yaml` (`source_of_truth: true`) |
| Knowledge Asset payload + sidecar | `canonical-content-and-metadata` | learner content + asset identity/provenance/lifecycle | framework enum or runtime assessment history | `knowledge-assets/README.md`; `knowledge-assets/manifests/README.md` |
| Assessment History runtime entity | `runtime-canonical` | all learner assessment results and timeline | repository design docs/evidence snapshots | `blueprint/01-product.md` § Assessment History |
| Catalogs, caches, code, Error Graph, DailyPlanSnapshot, templates | `projection/derived/tooling` | derived views or workflow support only | any upstream SSOT | `artifacts/CONVENTION.md`; `artifacts/operations/catalogs/README.md` |

## Hai điểm đã sửa

1. `capability-manifest.yaml` từng khai `source_of_truth: true` nhưng đồng thời `status: draft` và nói không thay `blueprint/03-features.md`. Đó là authority collision. Nó đã được hạ thành `source_of_truth: false`, `typed-projection-seed`; validator sẽ chặn nếu cờ này quay lại.
2. `spawn-prompts/` top-level từng tự cấm mọi agent đọc workflow artifact và pin framework `1.0.4` dù framework đã là `1.0.5`. Thư mục đã được chuyển vào `artifacts/operations/spawn-prompts/`, có registry, sidecar metadata và hash validator. Agent đọc được; prompt chỉ là workflow contract, không được lấn quyền framework.

## Quy tắc đếm trung thực

- Đếm lớp (`blueprint`, `artifacts`, `knowledge-assets`) là taxonomy repository.
- Đếm registry là inventory authority theo phạm vi, không phải số lượng SSOT độc lập.
- Nếu hai file cùng claim cùng một semantic field, phải ghi rõ một file là `canonical`, file kia là `implementation-contract` hoặc `projection`, rồi validator phải kiểm tra resolution.
- `status: approved`, validator pass hoặc prompt hash đúng không chứng minh IELTS quality, rights, calibration, benchmark hay learner outcome.
