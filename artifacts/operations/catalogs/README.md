# Catalog

Catalog là projection/index, không phải SSOT độc lập. Catalog thật phải ghi `generated_from`, `generated_at` và `schema_version`. Các YAML có `generation_state: sample_not_generated` chỉ là design sample, không được dùng làm build input hay evidence. `capability-phase-index.md` là projection phasing explicit; capability `deferred` không thuộc active scope.

`artifacts/operations/capability-manifest.yaml` là source seed có type cho P0 capability family. Nó chưa phải generated catalog; nó là input để generator/compiler sau này sinh capability graph, artifact family projection và readiness view.

Không sửa catalog bằng tay nếu nó có thể được sinh lại từ Knowledge Asset manifest hoặc system data.
