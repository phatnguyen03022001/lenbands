# P0 Acceptance Run Contract

Đây là danh sách acceptance runtime cần chạy cho sáu P0 pack. Manifest mô tả test IDs và evidence contract; nó không tự nhận đã chạy.

`tools/run-p0-acceptance.sh` hiện chỉ hỗ trợ preflight contract. Nó dừng với `not_run` nếu chưa có runtime command hoặc evidence output. Không ghi evidence giả.

## Evidence rule

Mỗi run thật phải có:

- immutable `run_id`, commit/build, environment và test command;
- pass/fail từng test ID;
- privacy/redaction và idempotency result;
- reviewer và timestamp;
- sibling metadata với hash; không overwrite run cũ.
