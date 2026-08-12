# Product Specifications

This branch contains build-ready specifications for each vertical slice. A slice is eligible to move to Source Code only after it describes:

- User goal, entry/exit, and state machine.
- Interaction Specification: actor, command, sync/async, runtime effect, expected UX, failure, and evidence.
- Screen inventory, action, validation, and transition.
- Runtime data read/write.
- API/event boundary.
- Failure/recovery.
- Quality, cost, and acceptance tests.

Reference order:

```text
Blueprint Capability
        ↓
Vertical Slice Spec
        ↓
Interaction Specification + Screen Wireframe
        ↓
Engineering Contracts
        ↓
Source Code
```

`skill-practice-coverage.md` is the coverage contract for all skills/modes; `writing-task-2.md` is the first runtime slice and does not represent all of IELTS.
