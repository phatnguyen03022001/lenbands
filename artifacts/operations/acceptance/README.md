# P0 Acceptance Run Contract

This is the list of runtime acceptance checks required for the six P0 packs. The manifest defines test IDs and the evidence contract; it does not claim that the tests have run.

`tools/run-p0-acceptance.sh` currently supports only the preflight contract. It stops with `not_run` when no runtime command or evidence output is available. It must not write fabricated evidence.

## Evidence rule

Every real run must include:

- immutable `run_id`, commit/build, environment, and test command;
- pass/fail for each test ID;
- privacy/redaction and idempotency results;
- reviewer and timestamp;
- sibling metadata with hash; never overwrite an earlier run.
