# Phase 7B Pickup Request and Queue Test Report

## Status

`7B COMMAND ACCEPTANCE COMPLETE`. Test 22 is waived by design evidence, not marked PASS. GUI acceptance remains for the user.

## Test Results

Tests 1–20: permission migration and idempotency, role flags, eligible school/district requests, server-derived ticket/device/school/status/actor fields, `LOG` number format, initial history/audit, unchanged ticket/device/Phase 5 state, scope denials, wrong-status rejection, duplicate-ticket protection, and active-device duplicate rejection were checked through runtime requests and database records. The request API contract statically consumes only `ticket_id`; forged authority fields are not part of the input contract. Duplicate, wrong-status, out-of-scope and unauthorized attempts returned controlled errors and created no success audit.

Test 21: concurrent requests on ticket 31 returned exactly one HTTP 200 and one HTTP 409. Persisted evidence shows exactly one case (`LOG00000021`), one `NULL → REQUESTED` history row, and one `logistics_pickup_requested` audit for that ticket.

Test 22: **WAIVED BY DESIGN EVIDENCE**. The two-ticket concurrent execution was not run and this test is not labeled PASS. `request-pickup.json` inserts the case, then derives the final number as `'LOG' + create_case.identity.padNumber(8)`, where `create_case.identity` is the database-generated ID of that inserted row, all within the transaction. There is no MAX+1, COUNT+1, pre-insert number/sequence lookup, timestamp-only, or client-generated final number. The schema has unique index `uq_ticket_logistics_cases_number` on `logistics_number`; the final database contains 0 committed `TMP%` numbers. Together with the separately proven same-ticket race, this removes the MAX+1 cross-ticket race Test 22 was intended to detect.

Tests 23–30: TTPost national queue returned 200 without `tickets.view`; minimized output contained no requester contact, student, diagnosis, clarification or problem-description fields. School and Caroni scopes, no-scope empty list, status/district/school/search/pagination filters, and search were checked. Invalid status, `page=0`, and `page_size=1000` return safe 400 responses. Pagination validation was tightened in `app/api/logistics/list.json` after the original check showed invalid values being normalized.

Tests 31–42: own-scope details return 200; foreign School scope returns 403; missing detail returns 404. TTPost acceptance returns 200 and adds one `REQUESTED → ACCEPTED` row and audit. Ticket status remains `APPROVED_FOR_PICKUP`; device lifecycle and Phase 5 allocation remain unchanged; no handoff or scan is created. Repeat acceptance returns 409. Unauthorized role attempts are denied. State-drift test temporarily changed ticket 32 from approved to submitted, observed a safe 409, then restored status ID 3 and its original `updated_at` exactly; no history/audit was added. Concurrent acceptance returned one 200 and one 409.

Tests 43–49: database and API summaries agree (national 4 active: 1 requested, 3 accepted; School 1/Caroni 3 active: 1 requested, 2 accepted). Ticket detail covers an approved/no-case fixture, a requested case and an accepted case with acceptance time/actor. Accepted wording remains “Awaiting Physical Handoff.”

Tests 50–54: `/logistics` and `/logistics/detail?id=23` render HTTP 200 for TTPost. Navigation is guarded by `logistics.view`; Repair Centre has no Phase 7B permission. TTPost still lacks `tickets.view`. Representative 400/401/403/404/409 responses were checked for internal SQL, stack, filesystem, dependency-path or raw error disclosure; none found.

Tests 55–60: failed request/accept attempts created no success audit; current status matches latest history; each case has one initial `NULL → REQUESTED` row; no duplicate active ticket/device cases, provisional numbers, orphan status history, handoffs or scans.

Tests 61–64: Phase 6 ticket list/detail/dashboard/activity were smoke-tested successfully. Phase 5 custody/allocation context remains consistent. Static inspection confirms Wappler-native Server Connect, no custom Express/Node business logic/runtime SQL or database triggers, no service-location seed, no handoff/scan API, and only `dmx-on:*` events with `is="dmx-bs5-modal"`.

Test 65: final database consistency counts are below. Test 66: approved/no-case, requested, accepted, School 1, Caroni and TTPost GUI fixtures are retained.

## Final Database Counts

| Check | Count |
| --- | ---: |
| Logistics cases | 4 |
| `REQUESTED` | 1 |
| `ACCEPTED` | 3 |
| Invalid ticket/device relationship | 0 |
| Pickup school/origin-school mismatch | 0 |
| Current status/history mismatch | 0 |
| Cases missing initial history | 0 |
| Duplicate active ticket cases | 0 |
| Duplicate active device cases | 0 |
| TMP/provisional numbers | 0 |
| Cases with handoffs / scans | 0 / 0 |
| Orphan status history | 0 |
| Service locations / DB triggers | 0 / 0 |

Successful audit totals: 4 `logistics_pickup_requested`, 3 `logistics_request_accepted`. No audit rows were deleted.

## GUI Fixtures and Test Data

- Approved, no logistics case: ticket 36 / `TKT00000036`, device 23 / `P5B-BULK-3-20261008`, School 1 / Caroni. Its diagnosis and approval were created through existing APIs. Device remains `AVAILABLE` at School 1.
- Requested: ticket 32 / `TKT00000032`, case 23 / `LOG00000023`, School 1 / Caroni.
- Accepted: ticket 29 / `TKT00000029`, case 20 / `LOG00000020`, School 1 / Caroni.
- Additional accepted fixtures: ticket 31 / `TKT00000031`, case 21 / `LOG00000021`, School 1 / Caroni; ticket 34 / `TKT00000034`, case 19 / `LOG00000019`, School 2 / Tobago.
- School account: `phase3.school.test` / `test` (School 1). District account: `phase5b.district.test` / `test` (Caroni). Admin: `portal.admin` / `test`.
- Retained TTPost account: `p7b.ttpost.test` / `test`, role `TTPOST_LOGISTICS`; no general ticket permission. Temporary no-scope user used for test 27 was removed. The temporary state-drift fixture was restored exactly.

## Phase 7B Ticket Activity Remediation

The Phase 7B GUI/integration remediation adds logistics history to the existing `v_ticket_activity` read model. `database/phase_07b_ticket_activity_logistics_integration.sql` was applied and reapplied successfully; the `CREATE OR REPLACE VIEW` migration is idempotent and performs no operational data writes.

Focused command checks:

1. **View migration:** `v_ticket_activity` queried successfully and returned the logistics activity fields.
2. **Idempotency:** the migration was applied twice successfully; no tables or duplicate events were created.
3. **Requested event:** ticket 32 / `TKT00000032` returned exactly one `PICKUP_REQUESTED`, reference `LOG00000023`, actor `Phase3 School Tester`, sourced from history row 17 (`NULL → REQUESTED`) at `2026-10-12 09:58:20.648834` database time.
4. **Accepted event:** ticket 29 / `TKT00000029` returned exactly one `PICKUP_REQUESTED` and one `PICKUP_REQUEST_ACCEPTED`, both reference `LOG00000020`. The request actor is `Phase3 School Tester`; the acceptance actor is `P7B TTPost Tester`.
5. **Ordering:** the activity API returned ticket 29 acceptance before its request, newest first. The source values retain `DATETIME(6)` precision and SQL ordering is by `activity_at DESC`, then `related_record_id DESC`.
6. **No duplicate request event:** each tested case has exactly one request event sourced from its initial history row. No event is synthesized from `ticket_logistics_cases.requested_at`.
7. **Ticket status separation:** tickets 29 and 32 remain `APPROVED_FOR_PICKUP`; neither has a false `APPROVED_FOR_PICKUP → ACCEPTED` ticket-status transition. Logistics activity rows have NULL ticket-status IDs.
8. **Logistics history unchanged:** the migration contains only view DDL and inserts/updates zero history rows. The database reports 9 existing logistics history rows, each eligible request/acceptance row represented once.
9. **Device / Phase 5 unchanged:** this view-only migration does not write devices, lifecycle, allocation or assignment records.
10. **PII review:** `/api/tickets/activity?id=29` and `?id=32` return concise activity fields only; no requester email/phone, student name, diagnosis text, clarification body, pickup note or acceptance note is selected or returned.
11. **Phase 6 activity regression:** ticket 32 still returns status changes, diagnosis, clarification request/response, district approval, and assignment started/ended events alongside logistics activity.
12. **Ticket detail render:** `GET /tickets/detail?id=29` on `http://localhost:3000` returned HTTP 200. The App Connect activity mapping includes both friendly logistics labels and the optional reference.
13. **Physical-custody wording:** the new activity labels are only “Pickup Requested” and “Pickup Request Accepted”; no event is labeled Picked Up, In Transit, In TTPost Custody, or Received by TTPost. Existing detail copy explicitly says acceptance is awaiting physical handoff.
14. **Architecture:** no activity table, custom Express route, custom Node business logic, runtime SQL, trigger, ticket status, logistics status, or Phase 7C workflow was added. The existing Wappler Server Connect activity API remains the endpoint and retains its `tickets.view` plus historical origin-scope checks.

The API currently returns 5 `PICKUP_REQUESTED` and 4 `PICKUP_REQUEST_ACCEPTED` rows across the retained database fixtures, matching the 9 logistics history rows. GUI acceptance remains for the user: ticket 32 / `LOG00000023` is `REQUESTED`; ticket 29 / `LOG00000020` is `ACCEPTED`.

## Deferred Boundary

GUI acceptance is not performed by Codex. School-to-TTPost handoff, dispatch/receipt scans, physical custody, transit status, service-location selection, repair-centre receipt and return logistics remain Phase 7C or later. Do not begin Phase 7C until the user confirms Phase 7B GUI acceptance.
