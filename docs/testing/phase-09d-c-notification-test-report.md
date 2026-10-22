# Phase 9D-C Notification Test Report

**Status:** Command and browser-functional acceptance passed; one coherent success fixture and one exception fixture retained for user visual acceptance.  
**Test date:** 2026-10-16  
**Runtime:** `http://localhost:3000`

## Repair Completion Atomicity

The defect was a transaction-boundary error in `app/api/repairs/complete.json`: nested SLA workflow calls were executed from within the authoritative repair-completion transaction. This allowed a logistics transition to persist while the repair-job and ticket completion did not. TKT00000086 reproduced the bad partial state; retry returned 409.

The repair-job completion, ticket `COMPLETED` history/state, logistics `READY_FOR_RETURN` history/state, lifecycle update, and domain audit now remain in one Wappler Database Transaction. SLA derivation is invoked only after that transaction commits. The post-commit helper catches and audits its own failure, so derived SLA/notification work cannot undo domain completion and cannot swallow a core transaction failure. Workflow notifications remain after the transaction using the existing contained notification helper.

Fresh live proof: TKT00000088 / repair job 42 returned HTTP 200; job 42 is `REPAIRED_SUCCESSFULLY` with `completed_at`, ticket moved to `COMPLETED`, logistics moved to `READY_FOR_RETURN`, and each corresponding history transition exists exactly once. The `RETURN_LOGISTICS` SLA started at the same local completion timestamp. The complete school-return workflow then ended with ticket `RETURNED`, logistics `RETURNED_TO_SCHOOL`, and school custody. Repeating completion returned HTTP 409 and made no duplicate history/event rows.

TKT00000086/device 69 was not used as proof and was not changed. Device 69 (`P8B-REPLACEMENT-ROLLBACK-006`) predates 9D-C and is protected Phase 8 replacement test data. Since exact physical/custody restoration is not established, its known failed diagnostic workflow and events 18–26 remain visible and separately classified.

## Event Matrix

All events below were produced by normal workflow APIs. Each listed logical event occurred once for the fresh success fixture unless stated otherwise; source links, severity, and expected role/scope recipients passed the read-only matrix.

| Event | Recipient(s) | Runtime result |
| --- | --- | --- |
| `TICKET_SUBMITTED` | School operational users, origin school | PASS, TKT00000088 event 38 |
| `DISTRICT_APPROVAL_REQUIRED` | Caroni District Coordinator | PASS, event 39 |
| `TICKET_APPROVED_FOR_PICKUP` | School operational users, origin school | PASS, event 40 |
| `LOGISTICS_PICKUP_REQUESTED` | TTPost Logistics | PASS, event 41 |
| `LOGISTICS_SCHOOL_RELEASED` | TTPost Logistics | PASS, event 42 |
| `LOGISTICS_RECEIVED_BY_TTPOST` | School operational users, origin school | PASS, event 43 |
| `LOGISTICS_SENT_TO_REPAIR_CENTRE` | Users scoped to target repair centre | PASS, event 44 |
| `LOGISTICS_RECEIVED_BY_REPAIR_CENTRE` | School operational users, origin school | PASS, event 45 |
| `REPAIR_STARTED` | School and District operational users, matching scope | PASS, event 46 |
| `REPAIR_COMPLETED` | School and District operational users, matching scope | PASS, event 47 |
| `LOGISTICS_READY_FOR_RETURN_PICKUP` | TTPost Logistics | PASS, event 48 |
| `LOGISTICS_RETURN_RECEIVED_BY_TTPOST` | School operational users, origin school | PASS, event 49 |
| `LOGISTICS_RETURN_IN_TRANSIT_TO_SCHOOL` | School operational users, origin school | PASS, event 50 |
| `LOGISTICS_RETURNED_TO_SCHOOL` | School and matching District users | PASS, event 51 |
| `TICKET_CLARIFICATION_REQUESTED` | School operational users, origin school | PASS, TKT00000091 event 74 |
| `DISTRICT_REPAIR_DECISION_REQUIRED` | Caroni District Coordinator | PASS, TKT00000090 event 71 |
| `HEAD_OFFICE_REPLACEMENT_APPROVAL_REQUIRED` | Active national MOE Head Office user | PASS, TKT00000090 event 72; direct route also produced event 61 for TKT00000089 |

The completion retry for job 42 returned 409. Event uniqueness and recipient uniqueness constraints plus the acceptance SQL checks show no duplicates. No production failure-injection hook was added; failure isolation is established by static transaction ordering and the shared helper's local catch/audit pattern.

## Exception and Clarification

Clarification is **IMPLEMENTED**. The real Phase 6C workflow was called as the in-scope District user on submitted TKT00000091. It moved the ticket to `NEEDS_CLARIFICATION` and created one WARNING notification for the three active operational users at the origin school; the event points to ticket 91.

The District-routed exception fixture is TKT00000090 / exception 31 / LOG00000068 / repair job 44. The Repair Centre completed the real repair workflow with `UNABLE_TO_REPAIR`; submit produced `PENDING_DISTRICT_DECISION` and event 71 for the Caroni Coordinator. The Coordinator selected `SELECT_PERMANENT_REPLACEMENT`, which advanced the case to `PENDING_HEAD_OFFICE_APPROVAL`; event 72 was delivered only to active `p9db.ho.test`. No workflow state was manually fabricated.

## Security and Browser Functional Acceptance

Browser notification list/detail were exercised using each representative account: `phase3.school.test`, `phase5b.district.test`, `p7b.ttpost.test`, `p7d.repair.test`, and `p9db.ho.test`. Each inbox showed its relevant events and readable received times. The Head Office detail modal showed ticket, school, district, device, logistics, repair centre, exception source, and a valid `/exceptions/detail?id=31` action link. School detail context for TKT00000088 was also verified in the earlier browser pass.

Live API checks: District own notification returned 200 and Repair Centre-only detail returned 404; TTPost own notification returned 200 and forged mark-read of another user's recipient returned 404; Repair Centre own dispatch returned 200 and School-only detail returned 404; Head Office own exception notification returned 200. The Head Office role is intentionally able to inspect national-scope notification rows, including the District event. School account browser checks showed its own school events; broad cross-district isolation could not be independently exercised because no second-district recipient fixture exists in this database. The global recipient-scope check passed with zero anomalies. Disabled accounts are excluded; zero inactive users appear in recipient rows.

No subjective visual acceptance was performed; the user remains responsible for visual review.

## Database Acceptance

Ran `docs/testing/phase-09d-c-notification-acceptance.sql` read-only against the MAMP MySQL socket. Checks 01–12 all returned zero anomalies: required event types, idempotency keys, event/user recipients, inactive recipients, ticket/logistics/handoff/repair/exception source links, recipient scope, safe actions, and triggers. Protected 9D-A notification events 7/8 and Phase 9D-B TKT00000076 events were present. Targeted successful-repair consistency checks returned zero anomalies.

## Fixture and Preservation Register

**Final success GUI fixture:** TKT00000088; device 88 / `P9D-C-FINAL-SUCCESS-20261016-A2`; school `PHASE3 TEST SCHOOL A UPDATED` (id 1); district Caroni (id 4); LOG00000066; repair job 42. Events 38–51 cover the full outbound, repair, return, and school-receipt path. Representative accounts: School `phase3.school.test`, District `phase5b.district.test`, TTPost `p7b.ttpost.test`, Repair Centre `p7d.repair.test` (password `test`).

**Final exception GUI fixture:** TKT00000090; device 90 / `P9D-C-FINAL-EXCEPTION-20261016-B1`; exception 31; LOG00000068; repair job 44; District event 71 and Head Office event 72. Head Office account `p9db.ho.test` remains active (password `test`). The case is pending Head Office approval.

Other diagnostic data: TKT00000087 is an earlier completion-timestamp probe (job 41, LOG00000065), not the final GUI fixture. TKT00000089 is a separate direct-to-Head-Office route probe (exception 30, LOG00000067, job 43). TKT00000091 is the clarification probe. These records were not erased because they have append-oriented domain/audit/notification history and there is no supported Wappler cleanup endpoint. They remain labelled test data in this report.

Tickets 79–83 belong to the earlier Phase 8C-B inventory-selection/concurrency/rollback test set (devices 58–62; tickets 79–83 were created in a five-minute test window on 2026-10-16). TKT00000079 is the earlier clarification-path probe. TKT00000084/device 65 is a protected Phase 8 permanent-replacement staged device, and TKT00000085/device 67 is a protected Phase 8 manufacturer/replacement fixture. These are not 9D-C cleanup candidates. No records in 79–85 or underlying devices were changed.

Protected fixture checks passed: 9D-A events 7/8; 9D-B TKT00000076, device 84, SLA 9, ESC00000004, LOG00000063; 9D-C's pre-existing TKT86/device69 remains unchanged; 9C TKT00000075/SLA8/ESC00000003/LOG00000061; and Phase 8 TL11, TL18, TL20, TL24, and PR9 remain present in their recorded states.

**Phase 9D-C command acceptance:** PASS. **Browser functional acceptance:** PASS. **Status:** Ready for user visual acceptance. **Phase 9D-D/email:** NOT STARTED.
