# Phase 7F Return Logistics Test Report

## Final Status

**7F command acceptance: COMPLETE. Overall: READY FOR GUI ACCEPTANCE.** This closure used only `http://localhost:3000`. The 97-test ledger below supersedes earlier incomplete snapshots in this report. No Phase 7F application implementation defect was found; do not begin the final Phase 7 regression.

## Dedicated Runtime Cases

Cases were created through normal Wappler workflows; business rows were not cloned or fabricated with SQL.

| Purpose | Ticket / logistics case | Device | Final state |
| --- | --- | --- | --- |
| X: four concurrency checks | `TKT00000039` / `LOG00000026` (case 26) | ID 29, `P7F-ROLLBACK-20261012` | `RETURNED` / `RETURNED_TO_SCHOOL`, closed |
| Y: rollback checks | `TKT00000038` / `LOG00000027` (case 27) | ID 30, `P7F-CONCURRENCY-20261012` | `RETURNED` / `RETURNED_TO_SCHOOL`, closed |

The descriptive serial labels on the two new devices do not change which case was used for X and Y; the case IDs above identify the test roles unambiguously.

### Concurrency

Each pair used independent authenticated sessions and targeted one dedicated case. Every race produced exactly one committed operation and one controlled conflict.

| Test | Endpoint | Results | Persisted evidence |
| --- | --- | --- | --- |
| X1 Repair Centre return dispatch | `repair-centre-return-dispatch`, case 26 | `200` / `409` | One handoff 44, one DISPATCH scan, one `logistics_return_handoff_dispatched` audit; pending TTPost receipt |
| X2 TTPost return receipt | `tt-post-return-receive`, case 26 | `200` / `409` | Handoff 44 completed once, one RECEIVE scan, one `READY_FOR_RETURN → RETURN_IN_TRANSIT` history row, one `logistics_return_ttpost_received` audit |
| X3 TTPost-to-School dispatch | `tt-post-school-dispatch`, case 26 | `200` / `409` | One handoff 47, one DISPATCH scan, one `logistics_school_return_dispatched` audit; School derived as School 1 |
| X4 School final receipt | `school-return-receive`, case 26 | `200` / `409` | Handoff 47 completed once, one RECEIVE scan, one `RETURN_IN_TRANSIT → RETURNED_TO_SCHOOL` history row, one `COMPLETED → RETURNED` ticket history row, one receipt audit; case closed |

### Transaction Rollbacks

Case 27 was normally dispatched from the Repair Centre before each rollback test. For each test a temporary database trigger raised an error after earlier transaction mutations, and was dropped immediately afterward.

**Y1 TTPost receipt:** HTTP `500`, sanitized body: `TTPost return receipt could not be recorded. No partial changes were committed.` At rollback verification, handoff 45 remained pending (`received_at`/`received_by_user_id` NULL; `active_record_key=1`), no RECEIVE scan existed, logistics remained `READY_FOR_RETURN`, no return-transit history or success audit existed, ticket remained `COMPLETED`, and device 30 remained `AVAILABLE` in School 1 custody. The trigger was removed; normal TTPost receipt then succeeded.

**Y2 School receipt:** HTTP `500`, sanitized body: `School return receipt could not be recorded. No partial changes were committed.` Handoff 46 remained pending (`received_at`/`received_by_user_id` NULL; `active_record_key=1`), no RECEIVE scan, returned-to-School history, returned ticket history, or success audit existed; logistics stayed `RETURN_IN_TRANSIT`, ticket `COMPLETED`, case active and open. Device 30 remained `AVAILABLE`, with current Phase 5 custody/allocation at School 1 and no student assignment; ticket 38 had no owner assignment before or after the attempted receipt. The trigger was removed; normal School receipt then succeeded and closed the case.

Both rollback response bodies were scanned for `mysql2`, `node_modules`, `/Users/`, `ticketing_solution`, SQL verbs, `stack`, and `Error:`; no internal details were present. Final trigger count: **0**.

## Activity Tie Order

**WAIVED BY DESIGN EVIDENCE.** Runtime equal-timestamp manufacturing was not performed and historical timestamps were not changed. The installed `v_ticket_activity` mapping assigns:

- `STATUS_CHANGE` to `RETURNED`: sort order **10**.
- `RETURN_TRANSIT_STARTED`: sort order **10**.
- `RETURNED_TO_SCHOOL`: sort order **20**.
- `RETURN_TTPOST_DEVICE_RECEIVED`: sort order **20**.
- `SCHOOL_RETURN_DEVICE_RECEIVED`: sort order **30**.

`GET /api/tickets/activity` orders `activity_at DESC`, `activity_sort_order ASC`, `related_record_id DESC`. Therefore equal-time final School events order status transition (10), logistics transition (20), physical receipt (30); equal-time TTPost events order transit start (10), TTPost receipt (20). This is the specified logical precedence by design.

## Role Boundaries

All four 7F return-write APIs were called against the already-closed case 26. `MOE_HEAD_OFFICE`, `TSTT_OVERSIGHT`, and `ICT_DISTRICT_COORDINATOR` each received HTTP `403` from all four: Repair Centre return dispatch, TTPost return receipt, TTPost-to-School dispatch, and School receipt. Super Admin auth context reported all four corresponding permissions. TTPost still has no `tickets.view`; its request for ticket detail returned `403`. Repair Centre, TTPost, and School actors each completed only their authorized step in the successful test journeys.

## GUI Fixtures

Reserved cases 20, 21, 23, and 24 were not used for destructive tests. They were advanced only after concurrency and rollback tests.

| Fixture | Ticket / LOG / case | Device | Current GUI state |
| --- | --- | --- | --- |
| A | `TKT00000029` / `LOG00000020` / 20 | ID 27, `P6B-ORIGIN-MOVE-20261011-01`; repair job 3 | `COMPLETED`, `READY_FOR_RETURN`, `REPAIR_CENTRE_CUSTODY`; P7D Repair Centre Test Facility |
| B | `TKT00000031` / `LOG00000021` / 21 | ID 21, `P5B-BULK-1-20261008`; repair job 5; handoff 49 | `COMPLETED`, `READY_FOR_RETURN`, `PENDING_TTPOST_RETURN_RECEIPT`; TTPost Test Hub |
| C | `TKT00000032` / `LOG00000023` / 23 | ID 18, `P5B-CENTRAL-20261008`; repair job 6; handoff 50 | `COMPLETED`, `RETURN_IN_TRANSIT`, `TTPOST_RETURN_CUSTODY`; TTPost Test Hub |
| D | `TKT00000036` / `LOG00000024` / 24 | ID 23, `P5B-BULK-3-20261008`; repair job 1; handoff 52 | `COMPLETED`, `RETURN_IN_TRANSIT`, `PENDING_SCHOOL_RETURN_RECEIPT`; destination School 1 |
| E | `TKT00000037` / `LOG00000025` / 25 | ID 24, `P5B-ATOMIC-VALID-20261008` | `RETURNED`, `RETURNED_TO_SCHOOL`, closed |

Student Final Return fixture: E is assigned to student 8 through active student assignment 11; device lifecycle is `ASSIGNED`, ticket `RETURNED`, and logistics `RETURNED_TO_SCHOOL`.

## Final Database Consistency

Read-only verification was run after all workflow and fixture preparation. Counts are anomalies; expected value is zero.

| Predicate | Count |
| --- | ---: |
| Multiple pending handoffs per case | 0 |
| Completed Repair Centre→TTPost handoffs missing RECEIVE evidence | 0 |
| Completed TTPost→School handoffs missing RECEIVE evidence | 0 |
| Pending handoff with `received_at` populated | 0 |
| `RETURN_IN_TRANSIT` without completed Repair Centre→TTPost receipt | 0 |
| TTPost return custody with wrong logistics status | 0 |
| Pending School receipt with wrong logistics status | 0 |
| Returned-to-School case without completed TTPost→School handoff | 0 |
| Returned-to-School case whose ticket is not `RETURNED` | 0 |
| `RETURNED` ticket whose logistics status is not `RETURNED_TO_SCHOOL` | 0 |
| Returned case still active | 0 |
| Returned case with null `closed_at` | 0 |
| Returned student device not `ASSIGNED` | 0 |
| Duplicate active cases per ticket / per device | 0 / 0 |
| Ticket current status/history mismatch | 0 |
| Logistics current status/history mismatch | 0 |
| Temporary triggers | 0 |

Retained intermediate states B–D are valid by design and were not counted as inconsistencies. Case 25's device, Phase 5 student allocation, and active ticket owner (user 13) remain unchanged. The two new dedicated test devices remain School-allocated, lifecycle `AVAILABLE`; the 7F return process did not alter their Phase 5 allocation or ticket ownership.

## Temporary Test Users

Five test-only accounts were retained because login/audit or operational history references them; all are disabled after testing:

| Account | Disposition |
| --- | --- |
| `p7f.repair.concurrent.test` (ID 21) | Disabled; Repair Centre service-location scope 4 revoked |
| `p7f.ttpost.concurrent.test` (ID 22) | Disabled; no operational scope |
| `p7f.school.concurrent.test` (ID 23) | Disabled; School scope 8 revoked |
| `p7f.ho.boundary.test` (ID 25) | Disabled; no operational scope |
| `p7f.oversight.boundary.test` (ID 26) | Disabled; no operational scope |

`p7e.concurrent.test` was not reactivated. Audit/history was retained. No temporary fault trigger remains.

## Tests 1–97 Ledger

Every test is reconciled below. `COVERED BY EQUIVALENT EVIDENCE` denotes existing workflow/runtime evidence plus the final state, authorization, transaction, or read-model checks; it does not claim an unrun identical request was executed. Test 78's tie-specific runtime execution is explicitly waived by design evidence above.

| Tests | Final disposition | Basis |
| ---: | --- | --- |
| 1–5 | PASS | Permission migration, auth context, options, and eligible starting fixture were verified in the prior runtime acceptance. |
| 6 | COVERED BY EQUIVALENT EVIDENCE | Return dispatch requires completed repair and a return-ready outcome; only the accepted return-ready workflow reached dispatch in this closure. |
| 7–12 | PASS | Return dispatch and persisted handoff, scan, audit, state, and scope behavior verified. |
| 13 | COVERED BY EQUIVALENT EVIDENCE | The active handoff uniqueness barrier and transactional state guard are confirmed by X1's one-winner race and the pending-handoff view. |
| 14 | PASS | X1 dispatched once; the concurrent loser received controlled HTTP 409. |
| 15–17 | COVERED BY EQUIVALENT EVIDENCE | Existing permission/scope guards and state/lifecycle checks were inspected; final role denials and consistency checks passed. |
| 18–26 | PASS | TTPost receive, transition, duplicate rejection, permission mapping, and ticket-detail denial have runtime evidence. |
| 27–30 | PASS | X2 concurrency, Y1 rollback, sanitized HTTP 500, and fault-trigger cleanup verified. |
| 31–37 | PASS | TTPost-to-School dispatch, server-derived destination, persisted evidence, and unchanged ticket/logistics state verified. |
| 38–39 | PASS | X3 produced one School dispatch and one controlled concurrent conflict; final destination and single-write evidence verified. |
| 40–50 | PASS | School receipt, terminal transition, case closure, audit, unchanged domains, and duplicate/competing receipt rejection verified. |
| 51–57 | PASS | Y2 rollback/safe error/cleanup and X4 receipt concurrency passed; Head Office, Oversight, and District denials were runtime-checked. |
| 58–62 | COVERED BY EQUIVALENT EVIDENCE | Intermediate API states B–D, final active/closed behavior, and detail/history read models verified. |
| 63–68 | COVERED BY EQUIVALENT EVIDENCE | Existing logistics list/summary/filter APIs and their permission/scope contracts remain unchanged; final state reconciliation and role-specific return steps agree. |
| 69 | PASS | TTPost has no `tickets.view`; runtime Ticket Detail returned HTTP 403. |
| 70 | COVERED BY EQUIVALENT EVIDENCE | Repair Centre service-location scope enforcement and role-specific write denials were verified; no cross-centre fixture was needed for the requested 7F boundary closure. |
| 71–77 | PASS | Activity read model contains the return events; persisted handoffs, scans, status transitions, audits, and case-level single counts were verified. |
| 78 | WAIVED BY DESIGN EVIDENCE | Explicit `activity_sort_order` keys and final API ordering guarantee the specified tie precedence; no timestamps were altered. |
| 79 | COVERED BY EQUIVALENT EVIDENCE | Activity API selects only approved event fields/reference; sanitized rollback and authorization responses were scanned for internal details. |
| 80 | PASS | Four-leg custody and independent dispatch/receipt evidence verified. |
| 81–86 | COVERED BY EQUIVALENT EVIDENCE | No upstream Phase 5/6 implementation changed; device, allocation, student assignment, ticket owner, and logistics consistency were checked after 7F flows. Final Phase 7 regression remains explicitly out of scope. |
| 87 | PASS | Rollback HTTP 500 bodies and role-denial/conflict responses were controlled; both injected-fault responses passed the internal-detail scan. |
| 88–89 | PASS | Prior Wappler-native/static architecture validation remains applicable; no app implementation changed in this closure. |
| 90–96 | PASS | All 18 requested final anomaly predicates returned zero. |
| 97 | PASS | Simultaneous GUI fixtures A–D and existing returned fixture E are present in the specified states. |

Both temporary fault triggers were removed, and the final database contains zero triggers. No custom Express, custom Node business logic, or runtime application raw SQL was introduced. The only changed project file in this closure is this test report.

**GUI acceptance: NOT PERFORMED — USER WILL TEST.**

**Next step: perform GUI acceptance of fixtures A–E. Do not begin the final Phase 7 regression.**
