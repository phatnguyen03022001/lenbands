# Pending Evidence Ledger

Đây là ledger mutable để founder theo dõi evidence còn nợ. Immutable evidence chỉ được lưu ở `artifacts/operations/evidence/` và không overwrite.

| Evidence cần có | Owner | Blocker |
|---|---|---|
| Gold-standard corpus có rights/provenance thật | Founder | Writing evaluation contract, benchmark spec, P0-04/P0-06 |
| Benchmark intake manifest đã có nhưng đang `missing`; cần case refs + examiner labels | Founder/quality | `operations/benchmark/gold-corpus-manifest.yaml` |
| Numeric benchmark thresholds sau gold-standard baseline | Founder | Evaluation prompt/model route và release gate |
| Candidate numeric threshold policy approval + provider price version/cost ceiling | Founder | `operations/benchmark/numeric-threshold-policy.yaml`, `cost-budget.md` |
| Founder review của spawn reconciliation run-007 | Founder | Xác nhận framework 1.0.6 refs + asset revisions; chỉ là static validation, không publish asset |
| Benchmark run record có dataset/rubric/model/prompt versions | Founder/quality | Learner-facing evaluation promotion |
| P0-01..P0-06 runtime acceptance results | Engineering/operations | `operations/acceptance/p0-acceptance-manifest.yaml`; chưa có runtime results |
| Exit Exercise A: export, restore, authorization, deletion | Founder + provider/privacy | Exit decision và closed-pilot identity gate |
| Exit Exercise B: provider adapter switch và history preservation | Founder + engineering/provider | Provider/model promotion |
| Spawn validation approval record | Founder | Chỉ xác nhận pipeline validation; không thay rights/content publish |
| Provenance/license evidence cho 10 legacy vocabulary assets | Founder/content | Không được promote các sidecar `unknown` sang published |
| Rights/content review cho 7 generated draft assets | Founder/content | Không được serve learner hoặc publish asset |

## Quy tắc cập nhật

- Chưa có evidence thì giữ artifact ở `review` hoặc `draft`.
- Không tạo run record giả để lấp ledger.
- Khi evidence thật xuất hiện, lưu immutable snapshot và thêm reference/hash vào artifact liên quan.
