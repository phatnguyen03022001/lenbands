# Interaction Contract — IDENTITY.Core

| Step | User intent | Command/API | Expected UX | Runtime completion | Failure UX |
|---|---|---|---|---|---|
| 1 | Sign in | Authenticate | Provider/loading state | Account/session established | Retry; remain anonymous |
| 2 | Give consent | RecordConsent | Consent confirmation | Immutable consent recorded | Block learner runtime; explain |
| 3 | Set profile | UpdateProfile | Saved profile state | Profile version persisted | Inline validation/retry |
| 4 | Export data | RequestExport | Request accepted/status | Export job created | Retry without duplicate |
| 5 | Delete data | RequestDeletion | Confirmation + pending state | Deletion request persisted | Preserve request and retry |

Completion evidence: account/session, consent version, profile version, and privacy request status. Learner content never appears in UX telemetry.
