# Decision-to-Authority Compiler Foundation

- Round: 2.2.3
- Status: review
- Authority: proposal-only projection; not A0 authority.
- Execution mode: artifact_normative_algorithm / lenbands-r223-artifact-normative-replay 2.2.3
- R2-F06: still_failed
- Closure candidate: not_ready

## Current execution truth

Round-2.2.2 execution and closure results are historical, not current proof. Clean-room execution uses the exact founder-register bytes and a new frozen source snapshot.

| Measure | Value |
|---|---:|
| Frozen source entries | 450 |
| Source inventory SHA-256 | 129c0d44c17e0b8abf419199b460ea9b5abf8726dea7a5c3d9fc1eb50caf887b |
| Consumed authority entries | 3 |
| Consumed authority manifest SHA-256 | 10628eaf3c448ebe9d16d19f2d096854c94d83ecde2a36ab50783931b240dac7 |
| Founder rows / extraction mismatches | 325 / 0 |
| Resolved seeds / generic fallback seeds | 325 / 0 |
| Executions complete / incomplete | 322 / 3 |
| Causal search hits / raw reference candidates | 1262 / 46 |
| Blocking / unresolved terminals | 5 / 0 |
| Writer replay mismatches | 0 |

## Classification

{'missing_in_universe_target': 5, 'out_of_universe': 8, 'resolved_in_universe_file': 33}

The five missing in-universe targets remain blocking addressable witnesses. They are not external references. External terminals are non-blocking only when the frozen rule and row-specific causal facts apply.

## Compact evidence

Normal observation payload embedded: 0. Historical bulk execution payload embedded: 0. Inventory observations used for row completion: 0. All causal row-counting observations have a founder row, seed, matched token, source location, and deterministic observation identity.

Unsatisfied predicates: CP223-021, CP223-026, CP223-042. Session E is not launched; no repository closure or readiness claim is made.
