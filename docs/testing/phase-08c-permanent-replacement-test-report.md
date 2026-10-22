# Phase 8C Permanent Replacement Test Report

Date: 2026-10-13

Scope: Phase 8C-A foundation only. Phase 8C-B and Phase 8D were not started.

## Implementation

Result: PASS

Added permanent replacement schema, statuses, permissions, read model, start API,
list/detail/summary APIs, queue page, detail shell, ticket/exception links, and
privacy-safe ticket activity for `PERMANENT_REPLACEMENT_STARTED`.

## Migrations

Result: PASS

Applied twice without error:

- `database/phase_08c_permanent_replacement_foundation.sql`
- `database/phase_08c_ticket_activity.sql`

## Command Acceptance

Valid start: PASS

- Request: `POST /api/permanent-replacements/start`
- User: `p7d.repair.test`
- Exception: 14
- Result: HTTP 200
- Created: PR1 / replacement case 1
- Status: `SELECTION_REQUIRED`

Duplicate start: PASS

- Request: repeat start for exception 14
- Result: HTTP 409

Invalid status: PASS

- Request: start for exception 26 (`PENDING_HEAD_OFFICE_APPROVAL`)
- Result: HTTP 409

Unauthorized mutation: PASS

- User: `p7b.ttpost.test`
- Request: start for exception 16
- Result: HTTP 403

Concurrency: PASS

- Exception: 9
- Parallel start calls produced one HTTP 200 and one HTTP 409
- Created: PR2 / replacement case 2

Read isolation: PASS

- `p7d.repair.test` can list visible replacement cases for service location 8.
- `p7b.ttpost.test` receives HTTP 403 from the replacement list endpoint.

Activity: PASS

- Ticket `TKT00000053` has ticket activity:
  `PERMANENT_REPLACEMENT_STARTED`, related record 1, reference `PR1`.

Outer state preservation: PASS

For PR1 and PR2 after start:

- Exception status remains `REPLACEMENT_APPROVED`
- Ticket status remains `UNDER_REPAIR`
- Logistics status remains `AT_REPAIR_CENTRE`
- Original device lifecycle remains `IN_REPAIR`
- Phase 5 custody remains `SCHOOL`
- Replacement status is `SELECTION_REQUIRED`

Database consistency:

- Permanent replacement cases: 2
- Permanent replacement status history rows: 2
- Device replacement relationship rows: 0

## GUI Fixtures

GUI A: `REPLACEMENT_APPROVED`, no replacement case

- Ticket: `TKT00000055`
- Exception ID: 16
- Replacement case ID: none
- Repair job: 25
- Original device: 46 / `P8A-HROLL-20261013`
- Repair Centre: 8 / P7D Repair Centre Test Facility
- District: 4

GUI B: `SELECTION_REQUIRED`, replacement case created

- Ticket: `TKT00000053`
- Exception ID: 14
- Replacement case ID: 1
- Replacement number: `PR1`
- Repair job: 23
- Original device: 44 / `P8A-HCON-20261013`
- Repair Centre: 8 / P7D Repair Centre Test Facility
- District: 4 / Caroni

## Static Check

Result: PASS

Changed JSON and EJS files parsed/compiled. No custom Express route, custom
Node business logic, runtime raw SQL, permanent trigger, or Wappler runtime-file
modification was introduced.

Phase 8C-A overall: READY FOR GUI ACCEPTANCE.

---

# Phase 8C-B Replacement Source Selection

Date: 2026-10-13

Scope: Phase 8C-B source selection. Phase 8C-C and Phase 8D were not started.

## Gate 0 Existing Inventory Inspection

Result: BLOCKED

Existing inventory selection was not enabled. No authoritative Repair Centre
physical stock-location model exists for free `AVAILABLE` inventory.

Evidence:

- Phase 5 current custody is educational allocation/assignment custody, not a
  Repair Centre stock location model.
- Phase 7 physical custody is active logistics/repair obligation custody, not a
  general inventory store-room model.
- `service_locations` identifies workflow locations but does not prove that an
  otherwise available device is physically held by the replacement Repair
  Centre.

Implemented behavior:

- `/api/permanent-replacements/source-options` returns
  `existing_inventory_blocked: true`.
- `/api/permanent-replacements/select` returns HTTP 409 for
  `EXISTING_INVENTORY`.

## Manufacturer-Supplied Source Selection

Result: PASS

Implemented Wappler Server Connect actions:

- `GET /api/permanent-replacements/source-options`
- `POST /api/permanent-replacements/select`

The selectable manufacturer-supplied unit must belong to a completed
manufacturer return for the same exception and same Repair Centre, have outcome
`REPLACEMENT_SUPPLIED`, have a received staged unit, not already be selected by
another active permanent replacement case, and not already exist as a device.

Runtime verification:

- PR6 / ticket `TKT00000041` source options returned staged unit 1 from `MFR6`.
- Selecting staged unit 1 returned HTTP 200.
- PR6 moved to `REPLACEMENT_SELECTED`.
- PR6 source is `MANUFACTURER_SUPPLIED`.
- PR6 selected-at display is readable: `Oct 13, 2026, 5:43 PM`.
- Duplicate selection for PR6 returned HTTP 409.
- Cross-exception staged-unit selection from PR7 using PR6 staged unit 1
  returned HTTP 409.
- Concurrent selection against PR5 produced one HTTP 200 and one HTTP 409.

## GUI Fixtures

GUI A: source selection required with eligible manufacturer-supplied unit

- Username: `p7d.repair.test`
- Password: `test`
- Menu: Permanent Replacements
- Detail URL: `/permanent-replacements/detail?id=7`
- Ticket: `TKT00000070`
- Replacement case: `PR7`
- Manufacturer return: `MFR20`
- Expected status: `SELECTION_REQUIRED`
- Expected candidate source: Manufacturer Supplied
- Expected staged unit: 3
- Expected staged serial: `P8B-V3-REPLACEMENT-J-20261013`
- Expected existing inventory state: blocked with Repair Centre stock-location
  model warning
- Expected physical/logistics state: `AT_REPAIR_CENTRE`
- Expected original lifecycle: `MANUFACTURER_RETURN`

GUI B: manufacturer-supplied source already selected

- Username: `p7d.repair.test`
- Password: `test`
- Menu: Permanent Replacements
- Detail URL: `/permanent-replacements/detail?id=6`
- Ticket: `TKT00000041`
- Replacement case: `PR6`
- Manufacturer return: `MFR6`
- Expected status: `REPLACEMENT_SELECTED`
- Expected source: `MANUFACTURER_SUPPLIED`
- Expected staged unit: 1
- Expected staged serial: `P8B-REPLACEMENT-ROLLBACK-006`
- Expected selected-at display: `Oct 13, 2026, 5:43 PM`
- Expected selected-by display: `P7D Repair Centre Tester`
- Expected physical/logistics state: `AT_REPAIR_CENTRE`
- Expected original lifecycle: `MANUFACTURER_RETURN`

## Database Consistency

Result: PASS

Consistency checks returned zero for:

- `REPLACEMENT_SELECTED` cases without a source type
- manufacturer-supplied selections without a staged unit
- manufacturer-supplied selections with a replacement device assigned early
- existing-inventory selections without a replacement device
- existing-inventory selections with a staged unit
- duplicate active selection keys
- staged units selected from the wrong exception
- staged selected serials already existing as devices
- replacement status/latest-history mismatch
- selected-source outer state mutation

Additional checks:

- `device_replacements` rows remain `0`.
- Permanent triggers: none.

## Static Check

Result: PASS

Changed JSON parsed and changed EJS compiled with async EJS support.

No custom Express route, custom Node business logic, runtime raw SQL, permanent
trigger, or Wappler runtime-file modification was introduced.

Phase 8C-B overall: OPEN - awaiting user GUI retest.

---

# Phase 8C-B Existing Inventory Integration

Date: 2026-10-14

Scope: Complete `EXISTING_INVENTORY` source selection using the Phase 8C-B2
Repair Centre stock model. Gate 0 is satisfied. Phase 8C-C and Phase 8D were
not started. The earlier Gate 0 blocker and GUI A stock warning above describe
the prior pass, not the current behavior.

## Implementation

Result: PASS

- Repeatable `v_permanent_replacement_inventory_candidates` view enforces
  active same-Repair-Centre stock, `AVAILABLE` lifecycle, unassigned and
  unreserved state, Phase 5 hierarchy compatibility, and absence of active
  logistics/manufacturer-return/repair or consumed-device conflicts.
- `source-options` returns only server-filtered eligible inventory. Selection
  serializes case, candidate device, and active stock row in a Wappler
  transaction, sets `DEVICE:<device_id>`, and appends history/audit.
- `device_stock.view` and Repair Centre scope are required in addition to
  `replacements.select`; frontend visibility remains advisory.
- Stock release now locks its row before checking reservation, preventing a
  concurrent selection from racing past release validation.
- Replacement and stock read models show the selected device, stock location,
  reservation, business identifier, and readable dates.

## Command Acceptance

| Check | Actual result |
| --- | --- |
| Eligible options, PR1 at location 8 | HTTP 200; device 55 included, unreserved `AVAILABLE` / `IN_STOCK` / `CENTRAL`. |
| Valid selection, PR2 / device 60 | HTTP 200; `REPLACEMENT_SELECTED`, `EXISTING_INVENTORY`, `DEVICE:60`; staged ID null. |
| Duplicate select, PR2 | HTTP 409. |
| Same device, different cases | PR2 and PR4 raced for device 60: HTTP 200 and 409; exactly one active reservation for device 60. |
| Same case, different simultaneous requests | PR4 / device 61: HTTP 200 and 409. |
| Other Repair Centre | Device 59 at location 9 absent from PR1 options; direct select HTTP 409. |
| No active stock | Device 54 absent; direct select HTTP 409. |
| Student assignment | Device 58 absent; direct select HTTP 409. |
| Non-available lifecycle | Device 49 (`IN_REPAIR`) and device 52 (`MANUFACTURER_RETURN`) absent; direct selects HTTP 409. |
| Incompatible Phase 5 | Device 63 (`DISTRICT` Tobago) and device 64 (different `SCHOOL`) absent; direct selects HTTP 409. |
| Active logistics | Device 45 absent; direct select HTTP 409. |
| Reserved stock release | Release of active row 9 for device 60: HTTP 409. |
| Unauthorized selection | Active TTPost and district test accounts: HTTP 403 each. |

Devices 60-64 and their stock were prepared through the normal device,
allocation, lifecycle, and stock-intake APIs. No business state was fabricated
with SQL. `v_device_stock_intake_eligibility` remains the intake gate; source
selection queries the current stock queue because an eligible candidate must
already have an active stock row.

## Transaction Rollback

Result: PASS

PR8 was started normally from approved exception 6. A temporary audit insert
failure made selection of device 62 return sanitized HTTP 500. The transaction
left PR8 `SELECTION_REQUIRED` with source, device, and reservation key null;
the success history/audit/activity counts stayed zero; device 62 stayed
`AVAILABLE`, `IN_STOCK`, and unreserved. The temporary trigger was dropped,
and retry returned HTTP 200. No temporary trigger remains.

## Manufacturer Regression

Result: PASS (bounded, non-mutating)

PR7 still returns staged manufacturer unit 3 from MFR20 with readable receipt
date. PR6 detail still returns `MANUFACTURER_SUPPLIED`, staged unit 1,
`REPLACEMENT_SELECTED`, and no replacement device. Cross-exception selection
of PR7 using PR6's staged unit remains HTTP 409. The already accepted PR7
candidate was deliberately not consumed for another positive selection.

## Outer State, Stock, and Activity

Result: PASS

PR2, PR4, and PR8 each have original lifecycle `IN_REPAIR`, ticket
`UNDER_REPAIR`, logistics `AT_REPAIR_CENTRE`, exception
`REPLACEMENT_APPROVED`, and original physical state
`REPAIR_CENTRE_CUSTODY`. Their candidates 60, 61, and 62 remain `AVAILABLE`,
`CENTRAL`, and actively `IN_STOCK` at Repair Centre 8, with one active
reservation each. `device_replacements` rows: 0. Each selected case has
exactly one `PERMANENT_REPLACEMENT_SELECTED` ticket activity row.

## Database Consistency

Snapshot: 3 selected existing-inventory cases and 3 matching active stock
rows. Exact anomaly counts:

| Check | Count |
| --- | ---: |
| `REPLACEMENT_SELECTED` without source | 0 |
| Existing inventory without replacement device | 0 |
| Existing inventory with staged unit ID | 0 |
| Existing inventory candidate lifecycle not `AVAILABLE` | 0 |
| Existing inventory candidate without active stock | 0 |
| Existing inventory candidate at wrong Repair Centre | 0 |
| Existing inventory candidate with incompatible Phase 5 | 0 |
| Multiple active reservations for one stock device | 0 |
| Selected stock released prematurely | 0 |
| Selected device with Phase 5 allocation/assignment rows | 0 |
| Selected device lifecycle mutated | 0 |
| Original lifecycle mutated from `IN_REPAIR` | 0 |
| Ticket or logistics status mutated | 0 |
| Status/latest-history mismatch | 0 |
| Dangling replacement device ID | 0 |
| Temporary triggers remaining | 0 |

No temporary-loan conflict can exist before Phase 8D establishes that model.

## Preserved GUI Fixtures

Log in as `p7d.repair.test` / `test` at `http://localhost:3000`. Open
**Permanent Replacements** from the sidebar.

| Fixture | Exact case and ticket | Expected GUI state |
| --- | --- | --- |
| GUI A | PR7, ticket `TKT00000070`, `/permanent-replacements/detail?id=7` | `SELECTION_REQUIRED`; click **Select Replacement Source**. Manufacturer Supplied offers staged unit 3 from MFR20, received Oct 13, 2026, 12:11 PM. Do not submit if preserving the fixture. |
| GUI B | PR6, ticket `TKT00000041`, `/permanent-replacements/detail?id=6` | `REPLACEMENT_SELECTED`; source Manufacturer Supplied, staged unit 1; no replacement device has been created. |
| GUI C | PR1, ticket `TKT00000053`, `/permanent-replacements/detail?id=1` | `SELECTION_REQUIRED`; click **Select Replacement Source**, switch to Existing Inventory. Candidate device 55 (`P8CB2-STOCK-B-20261013`) is available at Repair Centre 8. Do not submit if preserving the fixture. |
| GUI D | PR2, ticket `TKT00000048`, `/permanent-replacements/detail?id=2` | `REPLACEMENT_SELECTED`; source Existing Inventory; selected device 60, serial `P8CB-INV-SELECT-20261014`, asset `P8CB-INV-SELECT-TAG`; lifecycle `AVAILABLE`, Phase 5 `CENTRAL`, stock `IN_STOCK` at `P7D Repair Centre Test Facility`, reserved for PR2. |

For GUI D, also open **Repair Centre Stock** and search the device serial or
asset tag; its row and detail must show `Reserved`, `PR2`, `AVAILABLE`, and
`IN_STOCK`. The Permanent Replacements queue must show Existing Inventory,
the asset tag, Replacement Selected, and a readable Updated date.

## Static Check

Result: PASS. Changed Server Connect JSON parsed and EJS templates compiled;
the candidate migration was reapplied successfully. No custom Express route,
custom Node business logic, runtime raw SQL, permanent trigger, or generated
Wappler runtime file was introduced.

Phase 8C-B existing-inventory integration: READY FOR GUI ACCEPTANCE.

## Phase 8C-C Final Acceptance

Date: 2026-10-14. This section supersedes earlier fixture snapshots where
PR4, PR7, or PR8 were still selected. Authoritative runtime:
`http://localhost:3000`.

### Implementation and Static Checks

- `database/phase_08c_c_acceptance.sql` adds unique manufacturer-stage
  consumption, a unique Phase 5 transfer snapshot, and
  `v_logistics_return_device`. It was reapplied successfully.
- `accept.json` uses one Wappler Database Transaction for source validation,
  device creation or stock release, Phase 5 transfer, lifecycle changes,
  relationship, case/exception/ticket/logistics status, history, and audit.
- Manufacturer stages without a catalogue model require an explicit active
  model choice for the same manufacturer at acceptance.
- Detail and Logistics pages show the physical return device and original
  physical disposition. The old Phase 7F return-dispatch action rejects a
  completed replacement case (HTTP 409); full replacement handoffs belong to
  8C-D.
- The Ticket Activity view derives one privacy-safe
  `PERMANENT_REPLACEMENT_COMPLETED` event per completed case. Changed JSON
  parses and changed EJS compiles. No custom Express, Node business logic,
  runtime raw SQL, or permanent trigger was added.

### Command Acceptance

| Test | Result | Evidence |
| --- | --- | --- |
| A: manufacturer/student | PASS, HTTP 200 | PR11, exception 29, ticket `TKT00000011`, original device 20, staged unit 4, new device 68. Original student assignment 3 closed; new assignment 21 active for student 5, school 2, district 8. Original `REPLACED`; replacement `ASSIGNED`. |
| B: inventory/student | PASS, HTTP 200 | PR9, exception 27, ticket `TKT00000033`, original device 19, existing device 55. Old assignment 7 closed; new assignment 20 active for student 11, school 1, district 4. No device was created; stock row 1 released. |
| C: non-student | PASS, HTTP 200 | PR4, original 46, existing device 61, school 1/district 4 transferred; replacement `AVAILABLE`, original `REPLACED`, stock row 10 released. PR5 also accepted a manufacturer-supplied school-level device 65. |
| D: duplicate | PASS, HTTP 409 | Second accept on PR4; no second relationship, transfer, history, or activity. |
| E: stale serial | PASS, HTTP 409 | Device 69 was created via the normal device API using PR6 staged unit 1's serial. PR6 acceptance returned 409 without mutation. The disposable device was deleted through controlled test cleanup; PR6 remains selected and ready. |
| F: lost reservation | PASS, HTTP 409 | PR2's active selection key was briefly cleared for fault injection, then restored to `DEVICE:60`. No acceptance mutation. |
| G: missing stock | PASS, HTTP 409 | PR2 stock row 9 was briefly marked released for fault injection, then restored to active `IN_STOCK`. No acceptance mutation. |
| H: permission | PASS, HTTP 403 | TTPost, District, Head Office, and Oversight all denied by the acceptance endpoint. The three previously disabled read-only test users were restored to `disabled` immediately after testing. |
| Concurrency | PASS, 200 + 409 | Two simultaneous PR7 manufacturer accept calls created exactly one device 67, one relationship, one transfer, one stage acceptance, and one completed activity. |
| Manufacturer rollback | PASS, sanitized HTTP 500 | A temporary failure at `device_replacements` insert, after device creation, rolled PR7 back: staged model unresolved, no device with staged serial, no stage consumption, relationship, transfer, or activity; case still selected. Trigger removed; concurrent retry succeeded. |
| Inventory rollback | PASS, sanitized HTTP 500 | A temporary failure at transfer insert, after stock release and allocation work, rolled PR8 back: stock row 11 active `IN_STOCK`, reservation intact, candidate `AVAILABLE`, original `IN_REPAIR`, no relationship/transfer/activity. Trigger removed; retry HTTP 200. |
| Phase 7F original-device guard | PASS, HTTP 409 | Return dispatch on completed PR9/logistics 54 was rejected, with no handoff. Logistics Detail reports return device 55, not original 19. |

All completed cases have exception `PERMANENT_REPLACEMENT_COMPLETED`, ticket
`COMPLETED`, logistics `READY_FOR_RETURN`, original lifecycle `REPLACED`, a
unique device relationship and Phase 5 transfer, and a replacement physical
return identity. The original is not set to `AVAILABLE`. Manufacturer-retained
originals show `MANUFACTURER_RETAINED_REPLACED`; local originals show
`REPAIR_CENTRE_REPLACED_PENDING_DISPOSITION`.

### Database Consistency

Six completed cases and six `PERMANENT_REPLACEMENT_COMPLETED` activity rows.
The exact count for each anomaly below was **0**:

| Check | Count |
| --- | ---: |
| Completed case without replacement device | 0 |
| Completed case with original lifecycle other than `REPLACED` | 0 |
| Completed manufacturer source without matching consumed staged unit | 0 |
| Completed manufacturer source without replacement device row | 0 |
| Completed inventory source with active stock | 0 |
| Completed inventory source with lifecycle inconsistent with allocation | 0 |
| Completed student transfer without active replacement assignment | 0 |
| Completed student transfer with original student assignment still active | 0 |
| Duplicate `device_replacements` per case | 0 |
| Relationship using the same original and replacement device | 0 |
| Completed case with exception not completed | 0 |
| Completed case with ticket not `COMPLETED` | 0 |
| Completed case with logistics not `READY_FOR_RETURN` | 0 |
| Completed case with active source reservation key | 0 |
| Consumed staged unit without completed case | 0 |
| `REPLACED` original without device relationship | 0 |
| Completed case without relationship | 0 |
| Completed case without transfer snapshot | 0 |
| Replacement Phase 5 hierarchy mismatch with transfer snapshot | 0 |
| Completed case with wrong physical return device identity | 0 |
| Temporary Phase 8C-C triggers remaining | 0 |

Acceptance does not insert/update `ticket_assignments`; ticket work ownership
is unchanged by this action. Original parent Phase 5 allocation rows remain
active where the Phase 5 reverse model preserves them.

### Preserved GUI Fixtures

Log in at `http://localhost:3000` as `p7d.repair.test` / `test`, then open
**Permanent Replacements**. Do not accept GUI A or C if they must remain
available for another tester.

| Fixture | Exact case | Expected detail |
| --- | --- | --- |
| GUI A, ready manufacturer | Ticket `TKT00000041`, exception 2, PR6, original device 32, staged unit 1, source `MANUFACTURER_SUPPLIED` | `REPLACEMENT_SELECTED`; original `MANUFACTURER_RETURN`; no replacement device yet. **Accept Permanent Replacement** opens a confirmation modal with model selection. |
| GUI B, completed manufacturer/student | Ticket `TKT00000011`, exception 29, PR11, original device 20, staged unit 4, replacement device 68 | `COMPLETED`; original `REPLACED`, replacement `ASSIGNED`; student 5, school 2, district 8; ticket `COMPLETED`, logistics `READY_FOR_RETURN`; return device 68, original manufacturer-retained. |
| GUI C, ready inventory | Ticket `TKT00000048`, exception 9, PR2, original device 39, existing device 60, stock row 9 | `REPLACEMENT_SELECTED`; candidate `AVAILABLE`, active `IN_STOCK` and reserved for PR2, Phase 5 `CENTRAL`; no original lifecycle/outer-state change. |
| GUI D, completed inventory/student | Ticket `TKT00000033`, exception 27, PR9, original device 19, replacement device 55 | `COMPLETED`; original `REPLACED`, replacement `ASSIGNED`; student 11, school 1, district 4; stock row 1 released; ticket `COMPLETED`, logistics `READY_FOR_RETURN`; return device 55 at Repair Centre. |
| GUI E, completed non-student | Ticket `TKT00000055`, exception 16, PR4, original device 46, replacement device 61 | `COMPLETED`; school 1/district 4 transferred, original `REPLACED`, replacement `AVAILABLE`; stock row 10 released; ticket `COMPLETED`, logistics `READY_FOR_RETURN`; return device 61 at Repair Centre. |

Direct detail URLs: `/permanent-replacements/detail?id=6`, `?id=11`,
`?id=2`, `?id=9`, and `?id=4`, respectively. The source number, actual device,
Phase 5 transfer, and physical return identity should be visible without
opening another module. GUI acceptance by the user remains pending.

At the end of this Phase 8C-C pass, Phase 8C-D and Phase 8D were not started.
The Phase 8C-D results follow below; Phase 8D remains not started.

Phase 8C-C overall: READY FOR GUI ACCEPTANCE.

---

# PHASE 8C-D - PHASE 7F / READ MODEL / UI INTEGRATION

Date: 2026-10-15. Runtime: `http://localhost:3000`. Phase 8C-E and Phase 8D
were not started. The earlier Phase 8C-C GUI fixture states above are historical;
the preserved Phase 8C-D fixtures below are the current GUI acceptance targets.

## Implementation

Result: PASS. Before this phase, Phase 7F handoff actions and physical custody
used `ticket_logistics_cases.device_id` (the original service device); Phase
8C-C rejected return dispatch for completed replacements. The new
`v_ticket_effective_device` selects a completed replacement's device, ordered
by latest completion time and case ID, while keeping ticket and logistics
original-device links intact. `v_logistics_return_device`,
`v_logistics_current_context`, and Phase 7F custody views now use this identity.
New handoffs persist the server-derived `device_id`; a client-supplied mismatch
returns 409. Detail/queue/action UI labels original and replacement separately.

The existing four Phase 7F actions handle both source branches. A completed
replacement without an active Phase 5 School destination cannot enter School
return dispatch; no School is inferred from the original pickup address.
No completed `CENTRAL`/`DISTRICT` fixture without a School was available for a
positive runtime command test. The server guard and safe UI reason were
inspected. No new district/central logistics path was introduced.

## Command Acceptance

| Check | Result | Evidence |
| --- | --- | --- |
| Existing inventory full return | PASS | PR9, ticket `TKT00000033`, LOG00000054: Repair Centre dispatch, TTPost receipt, School dispatch, School receipt each HTTP 200. Handoffs 118/119 identify replacement device 55. Ticket `RETURNED`, logistics `RETURNED_TO_SCHOOL`; original 19 remains `REPLACED`, replacement 55 remains `ASSIGNED`, Phase 5 School/student allocation unchanged. |
| Manufacturer supplied full return | PASS | PR7, ticket `TKT00000070`, LOG00000053: same four actions each HTTP 200; handoffs 120/121 identify replacement 67, never original 53. Final ticket `RETURNED`, logistics `RETURNED_TO_SCHOOL`, replacement `AVAILABLE`, original `REPLACED`. |
| Original device at dispatch | PASS | PR8/LOG00000033 request with original device 36 returned HTTP 409 before any handoff. |
| Original device downstream | PASS | TTPost School dispatch on PR8 with device 36 and School receipt on PR11 with original 20 each returned HTTP 409; fixture states unchanged. |
| Unrelated device | PASS | PR8 dispatch with device 1 returned HTTP 409. |
| No School destination | NOT APPLICABLE for runtime command | No usable completed `CENTRAL`/`DISTRICT` case without School. Allocation-derived School guard and ineligible UI state are present; no state was fabricated. |
| Dispatch concurrency | PASS | Parallel PR11/LOG00000056 dispatch: HTTP 200 + 409, exactly one handoff 122. |
| Final receipt concurrency | PASS | Parallel PR7/LOG00000053 School receipt: HTTP 200 + 409, exactly one final handoff 121. |
| Final receipt rollback | PASS | Temporary failure before logistics status update on PR9 returned sanitized HTTP 500. Handoff 119 had no `received_at`; ticket remained `COMPLETED`, logistics `RETURN_IN_TRANSIT`, replacement 55 `ASSIGNED`, original 19 `REPLACED`, allocation unchanged. Temporary trigger dropped; retry HTTP 200; triggers remaining 0. |

## Read Scope and Activity

Repair Centre `p7d.repair.test` could read PR8, LOG00000033, ticket detail,
and activity (HTTP 200). TTPost's normal return queue and detail showed the
replacement asset. School 1 `phase3.school.test` could read LOG00000033 (200)
but not School 2 LOG00000056 (403). District 1 `p8b.district.1` likewise
received 200/403. National `p8b.ho.1` and read-only `p8b.oversight` could
read LOG00000056 (200). No-scope `p7f.ho.boundary.test` received 403.
Previously disabled read-only test accounts temporarily enabled for these
checks were restored to disabled; no permission grants were made.

Ticket `TKT00000070` activity shows replacement started, selected, and
completed, followed in order by Repair Centre dispatch, TTPost receipt,
School dispatch, and School receipt. The existing Phase 7F event rows were
reused, with no duplicate activity source. The Activity API supplies readable
server-formatted dates; desktop and narrow Ticket Detail display them.

## Database Consistency

The administrative-only `database/phase_08c_d_consistency.sql` check returned
these exact anomaly counts after both completed journeys and preserved
fixtures:

| Check | Count |
| --- | ---: |
| Completed effective device differs from replacement | 0 |
| Active return handoff uses original | 0 |
| Active return handoff uses unrelated device | 0 |
| Returned ticket original not `REPLACED` | 0 |
| Returned replacement allocation missing | 0 |
| Returned replacement lifecycle/allocation mismatch | 0 |
| Ready return effective device NULL | 0 |
| TTPost return custody on original | 0 |
| School receipt completed for original | 0 |
| Replacement relationship mismatch after return | 0 |
| Phase 5 allocation transfer mismatch after return | 0 |
| Replacement lifecycle incorrect after return | 0 |
| Duplicate active return handoff | 0 |
| Ticket/logistics status mismatch | 0 |
| Effective read model mismatch | 0 |
| Dangling replacement/logistics relationship | 0 |
| Temporary triggers | 0 |

## Preserved GUI Fixtures

Log in at `http://localhost:3000`. The Repair Centre account is
`p7d.repair.test` / `test`; TTPost is `p7b.ttpost.test` / `test`.
Open **Permanent Replacements**, the linked Ticket and Logistics details, and
the **Logistics** return queue. Do not submit any further handoff on A-D if
the inspection states must remain available.

| Fixture | Exact IDs / source / School | Expected current state |
| --- | --- | --- |
| GUI A | PR4, `TKT00000055`, LOG00000043 (id 43); original device 46 `P8A-HROLL-20261013`, replacement 61 `P8CB-INV-CONCUR-20261014`, `EXISTING_INVENTORY`, School 1 `PHASE3 TEST SCHOOL A UPDATED`; no return handoffs | Ticket `COMPLETED`, logistics `READY_FOR_RETURN`, replacement physical `REPAIR_CENTRE_CUSTODY`, replacement `AVAILABLE`, original `REPLACED`. Repair Centre dispatch is available. |
| GUI B | PR5, `TKT00000042`, LOG00000030 (id 30); original device 33 `P8A-C-20261013-01`, replacement 65 `P8B-STAGED-DUP-001`, `MANUFACTURER_SUPPLIED`, School 1; no return handoffs | Ticket `COMPLETED`, logistics `READY_FOR_RETURN`, replacement physical `REPAIR_CENTRE_CUSTODY`, replacement `AVAILABLE`, original `REPLACED`. Original physical disposition is manufacturer-retained. |
| GUI C | PR8, `TKT00000045`, LOG00000033 (id 33); original device 36 `P8A-F-20261013-01`, replacement 62 `P8CB-INV-ROLLBACK-20261014`, `EXISTING_INVENTORY`, School 1; handoff 117 received | Ticket `COMPLETED`, logistics `RETURN_IN_TRANSIT`, physical `TTPOST_RETURN_CUSTODY`, replacement `AVAILABLE`, original `REPLACED`. TTPost can prepare School dispatch. |
| GUI D | PR11, `TKT00000011`, LOG00000056 (id 56); original device 20 `P5B-DISTRICT-B-20261008`, replacement 68 `P8CC-STUDENT-MFR-20261014`, `MANUFACTURER_SUPPLIED`, School 2 `PHASE3 TEST SCHOOL B`; handoff 122 received, 124 pending | Ticket `COMPLETED`, logistics `RETURN_IN_TRANSIT`, physical `PENDING_SCHOOL_RETURN_RECEIPT`, replacement `ASSIGNED`, original `REPLACED`. School 2 can receive the replacement. |
| GUI E | PR9, `TKT00000033`, LOG00000054 (id 54); original device 19 `P5B-DISTRICT-A-20261008`, replacement 55 `P8CB2-STOCK-B-20261013`, `EXISTING_INVENTORY`, School 1; handoffs 118 and 119 received | Ticket `RETURNED`, logistics `RETURNED_TO_SCHOOL`, physical `RETURNED_TO_SCHOOL`, replacement `ASSIGNED`, original `REPLACED`. Phase 5 student allocation stays active. |

School-receipt GUI user: `p6d.tobago.tech.test` / `test`,
`ICT_TECHNICAL_OFFICER`, District 8 / School 2 scoped, with existing
`logistics.return_school_receive` permission. Open **Logistics**, filter
`TKT00000011`, open LOG00000056, then open School receipt without submitting;
the modal shows replacement `P8CC-STUDENT-MFR-20261014` and School B.

At desktop 1280x800 and narrow 390x844, Ticket, Logistics, Permanent
Replacement, and Exception details, TTPost return queue, and School receipt
were visually checked. Original vs replacement identity was readable; no
document horizontal overflow. Narrow tables scroll within their own wrappers.

## Static and Scope Check

Result: PASS. Changed Server Connect JSON parsed; changed EJS compiled with
async EJS. The Phase 8C-D migration and Phase 7F views were applied, and the
consistency query returned zero anomalies. No custom Express route, custom
Node business logic, runtime raw SQL, permanent trigger, or Wappler runtime
file was introduced. Phase 8C-E and Phase 8D: NOT STARTED.

Phase 8C-D overall: READY FOR GUI ACCEPTANCE.

---

# PHASE 8C-E - FINAL REGRESSION / CLOSURE

Date: 2026-10-15. Runtime: `http://localhost:3000`. Phase 8D was not started.
No runtime business logic was changed in this pass. PR6 and PR2 were existing,
clean `REPLACEMENT_APPROVED` cases with start and selection already recorded;
this pass verified those historical gates and executed acceptance through
School receipt. It did not claim to rerun start or selection as new mutations.
The prior Phase 8C-D GUI A-E fixtures were not advanced.

## Golden Paths

| Gate | Manufacturer supplied | Existing inventory |
| --- | --- | --- |
| Case / ticket / logistics | PR6 / `TKT00000041` / LOG00000029; exception 2; original device 32 | PR2 / `TKT00000048` / LOG00000036; exception 9; original device 39 |
| Pre-acceptance history | `SELECTION_REQUIRED` then `REPLACEMENT_SELECTED`; staged unit 1 from completed MFR6, serial `P8B-REPLACEMENT-ROLLBACK-006` | Same status sequence; selected device 60, serial `P8CB-INV-SELECT-20261014`; stock row 9 active `IN_STOCK` and reserved |
| Acceptance | HTTP 200; new device 69, unique staged acceptance 5; original 32 `REPLACED`, replacement 69 `AVAILABLE` | HTTP 200; existing device 60 reused, no device created; stock row 9 `RELEASED`, history retained; original 39 `REPLACED`, replacement 60 `AVAILABLE` |
| Immediate outer state | Ticket `COMPLETED`, logistics `READY_FOR_RETURN`, exception `PERMANENT_REPLACEMENT_COMPLETED`; effective device 69 | Same states; effective device 60 |
| Repair Centre dispatch | HTTP 200, handoff 125, device 69 | HTTP 200, handoff 126, device 60 |
| TTPost receipt | HTTP 200; `RETURN_IN_TRANSIT`, ticket still `COMPLETED` | HTTP 200; same states |
| TTPost School dispatch | HTTP 200, handoff 127, device 69, School 1 | HTTP 200, handoff 128, device 60, School 1 |
| School receipt | HTTP 200; ticket `RETURNED`, logistics `RETURNED_TO_SCHOOL`, handoff 127 received | HTTP 200; same states, handoff 128 received |
| Final identity | Original 32 `REPLACED`; replacement 69 `AVAILABLE`, Phase 5 `SCHOOL` / district 4 / School 1 | Original 39 `REPLACED`; replacement 60 `AVAILABLE`, same Phase 5 destination |

No client-supplied device override was used for the successful handoffs.
Historical ticket/logistics original-device references remained 32 and 39;
the operational effective IDs were 69 and 60. The manufacturer staged unit
and MFR6 status/history remain present; `manufacturer_supplied_unit_acceptances`
links staged unit 1 to PR6/device 69 without overwriting the original asset.

## Cross-Phase Regression

- **Phase 5: PASS.** The School-level transfer snapshots are PR6 transfer 7
  and PR2 transfer 8. Original School allocation rows 25/32 are closed but
  retained, replacement School rows 57/58 are active, district 4/School 1
  hierarchy matches, and the original parent district history remains as
  designed. Duplicate active district, School, and student allocations: 0 each.
  Phase 7F did not change the transferred Phase 5 rows or device lifecycles.
- **Phase 7F: PASS.** Both journeys returned the replacement, not the original;
  the ticket changed from `COMPLETED` to `RETURNED` only at final School receipt.
  On preserved ready PR4, supplied original device 46 and unrelated device 1
  each returned HTTP 409; return handoffs for PR4 remained 0. Phase 8C-D's
  separately executed dispatch and final-receipt concurrency tests produced
  200 + 409 with one handoff/receipt; its final School-receipt rollback returned
  sanitized 500 without partial state, and retry returned 200. Those fault
  injections were not repeated in Phase 8C-E; no relevant runtime code changed.
- **Phase 8A: PASS.** Exception 25, not `REPLACEMENT_APPROVED`, received HTTP
  409 on start with no case created. PR6/PR2 retain separate district
  disposition and Head Office replacement-approval decisions, followed by
  `REPLACEMENT_APPROVED` and then `PERMANENT_REPLACEMENT_COMPLETED` history;
  acceptance did not rewrite either approval decision.
- **Phase 8B: PASS.** MFR6 remains `COMPLETED` with 7 status-history rows;
  staged unit 1 and original device 32 remain identifiable. Acceptance added
  its own consumption row, not a replacement of 8B records.
- **Stock model: PASS.** Device 60 stayed `IN_STOCK` and reserved until
  acceptance, then row 9 became `RELEASED` with placed/removed timestamps.
  Device 60's stock detail says `Not in stock` but retains the placement
  history. Unselected devices 59, 63, and 64 remain `IN_STOCK`; pending PR1
  and PR10 remain `SELECTION_REQUIRED`.
- **Role/scope: PASS.** Repair Centre accepted both in-scope cases. TTPost and
  School calls to replacement acceptance returned 403; their allowed Phase 7F
  actions succeeded. HO, Oversight, and District could read PR6 (200) but
  acceptance returned 403 for each. No-scope PR6 replacement and logistics
  detail returned 403. School receipt used School 1's scoped
  `phase3.school.test`; a Tobago Technical Officer could inspect the pending
  School 2 modal without submitting it.
- **Activity: PASS.** `TKT00000041` has one each, in order: replacement
  started, selected, completed, Repair Centre return dispatch, TTPost receipt,
  School dispatch, School receipt. No duplicate completion event. The activity
  API exposes event reference, actor, and readable date, but no staged serial,
  tracking reference, student name, financial value, or manufacturer note.

## Read Model and GUI

Result: PASS. The actual browser showed `TKT00000041` with original device 32
and replacement 69, `RETURNED` ticket, returned physical custody, and readable
activity dates. Exception 2 showed Permanent Replacement Completed, original
`REPLACED`, current replacement serial, and PR6/logistics links. PR6 detail
showed manufacturer source, transferred allocation, LOG00000029, and returned
custody. LOG00000029 showed return device 69, historical original 32, PR6,
School 1 allocation, and `RETURNED_TO_SCHOOL`. Repair Centre Stock detail for
device 60 showed the released row and its history. TTPost's queue filtered by
`TKT00000045` showed PR8 replacement asset `P8CB-INV-ROLLBACK-TAG`, not the
original, in `TTPOST_RETURN_CUSTODY`. The scoped School 2 modal for
LOG00000056 showed replacement `P8CC-STUDENT-MFR-20261014` and School B;
it was cancelled, leaving the pending fixture intact.

## Final Database Consistency

`database/phase_08c_e_consistency.sql` is read-only administration SQL, not a
runtime query. Exact final anomaly counts:

| Check | Count |
| --- | ---: |
| Completed without replacement device | 0 |
| Completed with original not `REPLACED` | 0 |
| Duplicate `device_replacements` | 0 |
| Manufacturer source without consumed staged unit | 0 |
| Inventory source with active stock row | 0 |
| Replacement allocation missing/mismatched | 0 |
| Original still active at replaced allocation level | 0 |
| Replacement lifecycle/allocation mismatch | 0 |
| Ticket/logistics state mismatch | 0 |
| Effective-device mismatch | 0 |
| Active return handoff using original | 0 |
| Stock reservation after completion | 0 |
| Staged reservation after completion | 0 |
| Status/latest-history mismatch | 0 |
| Dangling replacement/source reference | 0 |
| Duplicate completion activity | 0 |
| Temporary triggers | 0 |

The independent Phase 8C-D 17-check query was rerun after both journeys;
every count also remained 0. No Phase 8C-only user account exists. The four
read-only scope test accounts temporarily enabled for regression (IDs 25, 31,
32, 33) were restored to `disabled`. Standing shared users
`p7d.repair.test`, `p7b.ttpost.test`, and `p6d.tobago.tech.test` remain active.
All audit and history records were preserved. There are 0 triggers in the
local database.

No custom Express route, custom Node business logic, runtime raw SQL, or
permanent trigger was added. Phase 8D: NOT STARTED.

Phase 8C overall: CLOSED / PASS.
