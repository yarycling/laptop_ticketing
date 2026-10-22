# Phase 8C-B2 Repair Centre Stock Location Test Report

Date: 2026-10-13. Runtime: `http://localhost:3000`. Scope: stock-location
foundation only. Phase 8C-B existing-inventory integration, 8C-C, and 8D were
not started.

## Implementation and Static Checks

The repeatable migration `database/phase_08c_b2_device_stock_location.sql`
was applied. It creates `device_stock_locations`,
`v_device_current_stock_location`, `v_device_stock_intake_eligibility`, and
`v_device_stock_queue`, and seeds `device_stock.view`, `.intake`, and `.release`
permissions. `service_locations.location_type = REPAIR_CENTRE` identifies
valid locations. Server Connect actions are Wappler JSON; the queue/detail
are EJS/App Connect views. No custom Express, Node business logic, runtime raw
SQL, permanent triggers, or edits to Wappler runtime files were introduced.

## Command Acceptance

| Test | Actual result |
| --- | --- |
| Valid intake | Device 55 to location 8: HTTP 200; active row 1, `AVAILABLE` / `CENTRAL` retained. |
| Duplicate intake | Same device: HTTP 409; one active row. |
| Student-assigned | Device 58 (`ASSIGNED` / `STUDENT`): HTTP 409, no stock row. |
| In repair | Device 49: HTTP 409. |
| Manufacturer-return lifecycle | Device 52: HTTP 409. |
| Active Phase 7 logistics | Device 45, even though `AVAILABLE`: HTTP 409. |
| Active Phase 8B manufacturer case | Device 29: HTTP 409. |
| Out-of-scope Repair Centre | `p7d.repair.test` intake to location 9: HTTP 403. |
| TTPost | `p7b.ttpost.test` intake and list: HTTP 403 each. |
| Release | Device 56, stock row 2: HTTP 200; released history retained, active key null, lifecycle/Phase 5 unchanged. Repeated release: HTTP 409. |
| Intake concurrency | Two parallel requests for device 57: HTTP 200 and 409; one active row. |
| Release concurrency | Two parallel requests for device 57, row 3: HTTP 200 and 409. |

The controlled rollback test temporarily made audit insertion fail. Intake of
device 56 returned sanitized HTTP 500 and left no active stock row. Release of
row 8 returned sanitized HTTP 500 and left that row active. After the temporary
failure mechanism was removed, both operations retried with HTTP 200. No
temporary trigger remains.

Stock intake did not create tickets, logistics cases, educational allocation,
or student assignment for the stock fixture devices. Device 55's detail API
reports `AVAILABLE`, `CENTRAL`, location 8, and
`REPAIR_CENTRE_STOCK`; its attempted lifecycle change while stocked returned
HTTP 409.

## Read Isolation and GUI

- `p7d.repair.test` sees only location 8 in the stock queue and intake options.
  Detail for device 55 returns HTTP 200; detail for device 59 at location 9
  returns HTTP 403. Intake search finds device 54 by serial/asset tag.
- `portal.admin` sees active stock at both locations 8 and 9.
- Head Office (`p8b.ho.1`) and Oversight (`p8b.oversight`) were temporarily
  re-enabled for regression, each received HTTP 200 national list and HTTP 403
  on write. Both accounts were returned to their original disabled state.
- With `p7d.repair.test` temporarily lacking service-location scope, stock
  list/intake returned HTTP 403. The original scope was restored.
- The browser showed the Repair Centre Stock sidebar link, queue row 55, a
  readable placement date, stock detail/history, and the intake modal with a
  working search for preserved GUI STOCK A. No GUI stock fixture was consumed.
- District view was not granted. TTPost, school, and technical roles were not
  granted stock access.

## Database Consistency

Snapshot after command tests: 6 stock history rows, 2 active, 4 released.
Exact anomaly counts:

| Check | Count |
| --- | ---: |
| Devices with multiple active rows | 0 |
| Active stock with lifecycle other than `AVAILABLE` | 0 |
| Active stock with student allocation | 0 |
| Active stock with active Phase 7 logistics | 0 |
| Active stock with active Phase 8B manufacturer return | 0 |
| Active stock with active repair | 0 |
| Active stock at invalid/inactive Repair Centre location | 0 |
| Released row with non-null active key | 0 |
| Released row without `removed_at` | 0 |
| Active row with `removed_at` | 0 |
| Dangling device foreign key | 0 |
| Dangling service-location foreign key | 0 |
| Tickets for stock fixture devices 54/55/56/57/59 | 0 |
| Phase 5 district allocations for those devices | 0 |
| Phase 5 school allocations for those devices | 0 |
| Student assignments for those devices | 0 |
| Stock fixture devices whose lifecycle is not `AVAILABLE` | 0 |
| Temporary triggers remaining | 0 |

No Phase 8D temporary-loan table or cases exist, so a loan conflict count is
not applicable. Ticket work-owner mutation is not applicable to these ticketless
stock fixtures; the stock actions do not write ticket or work-owner tables.

## Preserved GUI Fixtures

| Fixture | Device | Serial / asset tag | Phase 5 | Stock | Reservation |
| --- | --- | --- | --- | --- | --- |
| GUI STOCK A | 54 | `P8CB2-STOCK-A-20261013` / `P8CB2-STOCK-A-TAG` | `CENTRAL` | None; eligible for intake at location 8 | Not reserved |
| GUI STOCK B | 55 | `P8CB2-STOCK-B-20261013` / no asset tag | `CENTRAL` | Row 1, `IN_STOCK`, location 8 `P7D Repair Centre Test Facility`, `REPAIR_CENTRE_STOCK` | Not reserved |
| GUI STOCK C | Deferred | No replacement reservation was fabricated | - | - | Requires 8C-B integration |

Additional isolation fixture: device 59 is `AVAILABLE` / `CENTRAL`, active
stock row 5 at location 9 (`P8C-B2 Other Repair Centre`).

GUI retest: log in as `p7d.repair.test` with the established test password;
open **Repair Centre Stock** from the sidebar. Search for GUI STOCK B's serial
to inspect its queue/detail and readable date. Open **Record Stock Intake** and
search GUI STOCK A's serial; select location 8 only if intentionally testing a
new intake, since that will consume the preserved eligible fixture.

## Gate and Remaining Work

Gate 0 physical-location foundation: **NOW SATISFIED**. The eligibility view,
current-stock view, and service-location scope can identify an `AVAILABLE`,
unassigned, non-conflicting device physically at the same Repair Centre.
`EXISTING_INVENTORY` selection remains blocked in the permanent-replacement
source-options/select actions until the next 8C-B integration pass. Phase
8C-C and 8D were not started. Overall: **READY FOR GUI ACCEPTANCE** of this
foundation, not acceptance of the existing-inventory branch.

Those unchanged 8C-B actions still return their earlier
`NO_AUTHORITATIVE_REPAIR_CENTRE_STOCK_LOCATION_MODEL` blocker text. That text
is now stale; the next integration pass must replace it while enabling the
same-Repair-Centre candidate and reservation rules.

## Phase 8C-B Integration Follow-Up (2026-10-14)

The later existing-inventory integration now uses the Phase 8C-B2 stock views
and location 8 for source selection. The stale blocker has been removed.
Selected device 60 remains `AVAILABLE`, active row 9 remains `IN_STOCK` at
location 8, and the stock queue/detail displays reservation `PR2`. Attempting
to release that reserved stock row returned HTTP 409. The original B2 intake
fixtures 54 and 55 remain unconsumed; device 55 is an eligible candidate for
the still-unselected PR1. Phase 8C-C and Phase 8D have not started.
