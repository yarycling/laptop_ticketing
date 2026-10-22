# Phase 6D Ticket Assignment Test Report

## Scope and result

Implementation and command/API acceptance for work assignment, technician claim, reassignment, release, assignment history, queue filters, permission/scope boundaries, and requested focused regressions were exercised against `http://localhost:3000`. Result: **PASS**. Full prior Phase 6B/6C/5 suites were not rerun; the specifically requested focused checks passed. GUI acceptance remains **NOT PERFORMED — USER WILL TEST**.

No Phase 6E work was started. The existing `ticket_assignments` table and active-row uniqueness barrier were reused; no routing table, status, or application schema was added. The only schema-related change is the idempotent permission seed.

## Implementation

- Permission seed: `database/phase_06d_ticket_assignment_permissions.sql`.
- New endpoints: `GET /api/tickets/assignment-options`; `POST /api/tickets/assignment/assign`; `POST /api/tickets/assignment/claim`; `POST /api/tickets/assignment/reassign`; `POST /api/tickets/assignment/release`.
- Updated endpoints: `GET /api/tickets/list`, `GET /api/tickets/detail`, `GET /api/tickets/summary`, and `GET /api/auth/context`.
- UI: `views/tickets.ejs`, `views/tickets-detail.ejs`.
- Model documentation: `docs/phase-06-ticketing-model.md`.

Only active, in-scope `ICT_TECHNICAL_OFFICER` users are assignable. School/district managers can assign, reassign, and release only within their active origin scope; eligible technicians can claim an unassigned ticket for themselves. The queue derives from ticket origin, status, and active assignment. Reassignment preserves prior assignment rows; release closes the active row. Claim concurrency is protected by the unique active assignment key and transaction handling.

Assignment actions leave ticket status/history, device lifecycle/custody, diagnosis, and approval unchanged. There is no automatic routing, technician self-release, or TTPost/repair ownership.

## Command acceptance

**Passed:**

- Tests 1–2: applied and reapplied the permission migration; verified idempotence and exact grants: `tickets.assign` to SUPER_ADMIN, SCHOOL_ADMINISTRATOR, ICT_DISTRICT_COORDINATOR; `tickets.claim` to ICT_TECHNICAL_OFFICER. No other requested roles received either grant.
- Test 3: verified admin/school/district manager assignment context and technical officer claim-only context.
- Tests 4–6: school and Caroni district option lists contained only active, in-scope technical officers; non-technical roles and Tobago-only candidates were excluded from Caroni.
- Tests 7–14: manager assignment succeeded; cross-school/cross-district operations were forbidden; wrong-role, wrong-scope, inactive, and already-assigned targets were controlled rejections. Inactive user was restored immediately.
- Test 15: direct duplicate active-row insert was rejected by the database unique key and rolled back.
- Tests 16–20: eligible claim succeeded with actor as both assignee and assigning user; out-of-scope, already-assigned, and non-technical claims were rejected. Concurrent claims returned exactly one HTTP 200 and one HTTP 409, leaving one active owner.
- Tests 21–24: reassignment succeeded and retained old actor/assignee/time history; same-user and ineligible target attempts were rejected without displacing the active owner.
- Tests 26–29: release succeeded without a replacement row; repeated and out-of-scope release attempts were rejected; blank and overlength reasons were rejected.
- Tests 30–33 and 36–39: status remained independent of assignment; SUBMITTED, NEEDS_CLARIFICATION, and APPROVED_FOR_PICKUP were eligible; a temporarily unsupported status was rejected and restored exactly.
- Tests 40–41: detail returned current assignment and newest-first assignment history with actors, reasons, and interval state.
- Tests 42–45: final filters returned 7 unassigned, 13 assigned, and 9 tickets for `p6c.tech.test` under `MINE`; invalid filter returned HTTP 400. Rows matched their owner state.
- Test 46: school and district scope checks passed; SUPER_ADMIN returned the authorized global list. Focused closure also verified an active no-scope District Coordinator receives an empty list and a school user gets 403 on an out-of-scope ticket detail.
- Test 47: summary matched database counts: global open 20 = 7 unassigned + 13 assigned; Caroni technical user `my_open` = 9. Portal Admin `my_open` = 0.
- Tests 48–51: audit rows exist for assignment, claim, reassignment, and release; descriptions identify the ticket/action and do not include the supplied release/reassignment reason.
- Test 52: representative failed assign, claim, reassign, and release requests returned controlled 409 responses. Before/after audit counts for the affected fixture tickets were unchanged (ticket_assigned 3, ticket_claimed 0, ticket_reassigned 4, ticket_assignment_released 1); the rollback-injected reassignment likewise created no success audit.
- Test 53: forged actor/time/end/active-key/status/origin fields were ignored; persisted actor, timestamps, origin, and ticket status remained server-controlled.
- Test 54: representative controlled 400/403/409 responses were scanned for SQL, stack, filesystem, dependency, and raw error details; no prohibited internals were exposed. The deferred generic unexpected-500 runtime test was not run.
- Test 57: authenticated `/tickets` and `/tickets/detail?id=31` both rendered HTTP 200.
- Test 58: touched JSON files parse; Bootstrap modals use `dmx-bs5-modal`, dynamic events use `dmx-on:*`, and no static event handlers or custom browser workflow code were introduced.
- Test 60: final database integrity checks: duplicate active ticket groups 0; active rows with end time 0; open intervals with wrong active key 0; ended intervals with active key 1: 0; historical rows missing end time 0; missing assignee users 0; inactive active owners 0; non-technical active owners 0; active owners outside technician origin scope 0; temporary trigger artifacts 0.
- Test 61: the temporary Tobago-only account used for exclusion testing was removed after confirming it had no history. Retained accounts: existing `p6c.tech.test` (user 12), `p6d.caroni.tech.test` (user 13), and `p6d.tobago.tech.test` (user 15); retained accounts 13 and 15 have assignment/audit history referencing them.
- Test 62: GUI fixtures are listed below. No device/custody fixture was changed.

**Focused gap closure:**

### Reassignment transaction rollback

- Fixture: ticket 25 / `TKT00000025`; old active assignment 10 to `p6d.caroni.tech.test` (user 13); attempted target `p6c.tech.test` (user 12).
- A temporary MySQL `BEFORE INSERT` trigger on `ticket_assignments` raised an error during the new-assignment insert, after the old row had been closed inside the Wappler transaction.
- Reassign response: **HTTP 500**, `{"success":false,"error":"Ticket reassignment could not be completed."}`. The response contained none of the prohibited SQL, stack, filesystem, dependency, or raw error markers.
- Immediate rollback proof: assignment 10 still had `ended_at=NULL`, `ended_by_user_id=NULL`, `end_reason=NULL`, `active_record_key=1`; active assignment count remained 1; attempted new-assignee rows remained 0; `ticket_reassigned` success audit count for ticket 25 remained 0.
- The trigger was dropped before retrying. Normal reassignment succeeded with HTTP 200 (assignment 24); the owner was restored to the GUI fixture technician (assignment 25). A second custody-independence check also reassigned successfully (assignment 26) and restored the fixture owner (assignment 27). Final ticket-25 owner is user 13.
- Final temporary-trigger count: 0.

### Dynamic no-auto-assignment and focused Phase 6B/6C checks

- Fresh ticket: ID 32 / `TKT00000032`, created through `/api/tickets/create` from device 18. API returned HTTP 200; ticket number was server-generated; origin was School 1 / Caroni; status was SUBMITTED; exactly one `NULL → SUBMITTED` history row existed; assignment history count was 0.
- School diagnosis returned HTTP 200 and left status SUBMITTED. Clarification request returned HTTP 200 and moved status to NEEDS_CLARIFICATION. Clarification response returned HTTP 200 and returned status to SUBMITTED. The earlier diagnosis became stale (`has_current_diagnosis=false`). A new diagnosis returned HTTP 200 and restored current-diagnosis eligibility.
- District approval returned HTTP 200 and moved ticket 32 to APPROVED_FOR_PICKUP. Final assignment history count remained 0; no assignment audit existed for the ticket. Final detail showed two diagnoses, one clarification request, one response, one approval, and the expected status history.
- Focused Phase 6B checks passed: generated ticket number, initial status/history, correct origin capture, empty list for a no-scope ticket-view user, and 403 for out-of-scope detail. No full Phase 6B suite was rerun.
- Focused Phase 6C checks passed: diagnosis leaves SUBMITTED unchanged; clarification request/response transitions are correct; diagnosis freshness is invalidated and restored; district approval succeeds; ticket assignment count remains 0 throughout the workflow. No full Phase 6C suite was rerun.
- Tests 25, 52, 55, and 59 are closed by these focused checks. Tests 55/56 were intentionally limited to the requested adjacent regression rather than rerunning their complete historical suites.

### Focused Phase 5 and owner/status independence

- Current-custody view resolved representative fixtures: device 23 `P5B-BULK-3-20261008` CENTRAL; device 22 `P5B-BULK-2-20261008` DISTRICT (Tobago); device 21 `P5B-BULK-1-20261008` SCHOOL (Caroni / School 1); device 18 `P5B-CENTRAL-20261008` STUDENT (Caroni / School 1 / student 4).
- Before and after successful ticket-25 reassignments, device 21 remained lifecycle ID 2 / AVAILABLE, custody SCHOOL, district 4, school 1, no current student. Its district allocation row, school allocation history/current row, and student assignment history were unchanged.
- The create/diagnose/clarification/approval flow on device 18 left lifecycle ID 3 / ASSIGNED and custody STUDENT, district 4, school 1, student 4. No allocation or student-assignment change occurred.
- Work owner and status coexist independently: ticket 23 is NEEDS_CLARIFICATION with active owner `p6c.tech.test`; ticket 31 is APPROVED_FOR_PICKUP with active owner `p6c.tech.test`. Assignment did not perform either status transition.

## Security and implementation constraints

- Representative controlled responses contained no `mysql2`, `node_modules`, `/Users/`, `ticketing_solution`, SQL statements, stack, or raw `Error:` details.
- No custom Express, custom Node business logic, or runtime raw SQL was added.
- No ticket status, device lifecycle/custody, allocation, diagnosis, or approval mutation is part of assignment actions.
- No temporary database trigger remains. No implementation file was changed for gap closure.

## GUI fixtures

- Unassigned SUBMITTED: ticket 11 / `TKT00000011` (Tobago); ticket 13 / `TKT00000013` (Caroni, with released history).
- Assigned to `p6c.tech.test`: ticket 31 / `TKT00000031`, assignment 1; ticket 17 / `TKT00000017` (SUBMITTED); and ticket 23 / `TKT00000023` (`NEEDS_CLARIFICATION`).
- Assigned to another technician: ticket 25 / `TKT00000025`, current assignment 27, `p6d.caroni.tech.test` (retains reassignment history including the rollback acceptance).
- Reassignment history: ticket 26 / `TKT00000026`, current assignment 21 to `p6c.tech.test`; prior intervals are retained, including assignment 20 to `p6d.caroni.tech.test`.
- Released/unassigned history: ticket 13 / `TKT00000013`, ended assignment 3.
- NEEDS_CLARIFICATION assigned: ticket 23 / `TKT00000023`, assignment 9 to `p6c.tech.test`.
- APPROVED_FOR_PICKUP assigned: ticket 31 / `TKT00000031`, assignment 1 to `p6c.tech.test`.
- Approved and unassigned focused workflow: ticket 32 / `TKT00000032`; preserves the create/diagnosis/clarification/response/approval test trail.

GUI acceptance is **NOT PERFORMED — USER WILL TEST**. Do not begin Phase 6E until Phase 6D GUI acceptance passes.
