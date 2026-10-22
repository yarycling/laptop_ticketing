# Phase 8B Manufacturer Return / RMA Test Report

**Status: 8B FAIL / INCOMPLETE. Do not begin Phase 8C.**

Date: 2026-10-13  
Application: local Wappler instance, port 3000  
Database: `laptop_tickets_db`

## Implemented Scope

- Carrier directory schema and idempotent TTPost active-default seed.
- Manufacturer-return status catalogue and case, status-history, shipment,
  outcome, and staged manufacturer-supplied-unit tables.
- Explicit Phase 8B permission grants.
- Wappler Server Connect actions for start, outbound preparation, TTPost and
  external outbound pickup, manufacturer acknowledgment, outcome capture,
  return preparation, TTPost and external return pickup, final receipt, and
  carrier options.
- Internal `MFR` number derives from the inserted case ID. A unique active
  cycle key prevents concurrent active cycles. There is no `MAX+1` lookup.
- Replacement serials are staged outside `devices`; outcome entry does not
  transition the exception, ticket, logistics, or original-device lifecycle.
- Actions use Wappler Database Transactions and return controlled catches.

## Verification Performed

| Check | Result | Evidence |
| --- | --- | --- |
| Root/nested AGENTS instructions read | PASS | Root `AGENTS.md` read; no nested `AGENTS.md` found under application, database, views, or docs. |
| Migration syntax and application | PASS | Carrier, foundation, and permission migrations applied to local database. |
| Migration rerun | PASS | Each migration reran without error. |
| TTPost default | PASS | One active carrier default: `TTPOST`, type `TTPOST`, status `active`. |
| Initial 8B cases | PASS | Zero cases existed before acceptance; dedicated acceptance cases were subsequently created through normal APIs. |
| Permanent 8B triggers | PASS | Zero permanent triggers on Phase 8B tables. A temporary rollback-test trigger was created, then dropped and verified absent. |
| Wappler API JSON parsing | PASS | All current `app/api/manufacturer-returns/**/*.json` files pass `jq` parsing. |
| Unauthenticated start request | PASS | `POST /api/manufacturer-returns/start` returned HTTP 401 `Unauthorized`; no mutation was performed. |

## Acceptance Not Performed

The following required acceptance is **not performed**, so Phase 8B command
acceptance remains incomplete:

- Carrier create/edit/activate/deactivate, duplicate-code rejection, and
  inactive-carrier behavior.
- Start double-start race and remaining generated-number/manufacturer
  derivation assertions.
- Remaining pickup role-isolation and queue/read-scope checks.
- Replacement-to-staged-serial duplicate rejection.
- Post-fix Phase 7F warranty-rejected/BER and active-cycle rejection; an
  unintended warranty-rejected dispatch is documented below.
- Phase 8A rejection/BER District decision regression beyond the completed
  warranty-rejected second-cycle path.
- Full role/scope read/write matrix for Repair Centre, TTPost, District, Head
  Office, Oversight, School, Technical Officer, and no-scope identities.
- Carrier history/deactivation, complete safe-error scans, unified activity
  privacy, full database anomaly counts, and GUI fixtures A–K.
- Carrier administration and manufacturer-return queue/detail GUI acceptance.

Seven manufacturer-return cases were created through normal APIs for the
bounded acceptance run (MFR1-MFR7). GUI acceptance has not started, and the
complete A-K fixture set is not preserved simultaneously. Temporary
`p8b.*` test actors and external carrier `P8B-EXT-COURIER` remain active until
full command acceptance and cleanup. No permanent or temporary triggers
remain.

## Known Implementation Gaps

The outbound pickup lookup defect described in **Outbound Pickup Defect
Recovery** was found and fixed. Further outcome, final-receipt, Head Office,
and Phase 7F eligibility defects found during resume are recorded below and
were corrected in Wappler Server Connect. The full remaining matrix and GUI
acceptance are still open.

## Implementation Completion Pass

**Implementation status: COMPLETE. Command and GUI acceptance: NOT RUN.**

Implemented components:

- Scoped list, summary, detail, history, outcome-options, carrier-options, and
  ticket-summary Server Connect reads. Explicit no-scope guards run before
  scoped list/summary/detail/history reads; TTPost projections are restricted
  to TTPost participation and omit manufacturer financial/operational secrets.
- `v_manufacturer_return_physical_custody` and the Phase 7-aware
  `v_manufacturer_return_queue` read models.
- Manufacturer-return queue/detail pages, all required queue filters, and
  navigation/auth-context visibility.
- Carrier list/create/edit/status APIs and `/admin/carriers` UI. Backend
  `carriers.manage` permission remains authoritative.
- Safe manufacturer-return events integrated into `v_ticket_activity` and
  Ticket Activity; scoped high-level context on Ticket, Exception, Repair, and
  Logistics detail screens.
- Phase 7F return dispatch accepts only the completed `REPAIRED_ORIGINAL`
  manufacturer outcome in addition to the existing Phase 7E path; the other
  manufacturer outcomes and active cycles remain ineligible.
- Replacement-supplied units remain staged outside `devices`; no Phase 8C
  activation or assignment behavior was added.

Static validation:

- 25 unique changed/new Server Connect/config JSON files parse successfully.
- Seven changed/new EJS templates compile successfully.
- Routes are registered for `/manufacturer-returns`, its detail page, and
  `/admin/carriers`.
- No permanent Phase 8B triggers exist. No custom Express route, custom Node
  business logic, or runtime raw SQL was added.

Bounded smoke validation on port 3000:

| Check | Result | Evidence |
| --- | --- | --- |
| Authenticated `/manufacturer-returns` | PASS | HTTP 200 |
| Authenticated `/admin/carriers` | PASS | HTTP 200 |
| Unauthenticated carrier list API | PASS | HTTP 401 `Unauthorized` |
| Authenticated manufacturer-return list | PASS | Earlier bounded smoke returned HTTP 200 with an empty list before acceptance fixtures were created. |
| Authenticated manufacturer-return summary | PASS | HTTP 200, `{"success":true,"counts":[]}` |
| Authenticated outcome options | PASS | HTTP 200 with the four configured outcome codes |
| Authenticated carrier list | PASS | HTTP 200; seeded TTPost carrier returned |
| Authenticated nonexistent detail/history ID | PASS | HTTP 404 with safe `Manufacturer return was not found.` response |
| Manufacturer custody/queue view migration | PASS | Applied forward migration; queue view exposes Phase 7 logistics/custody columns |
| Manufacturer return-specific activity rows | PASS | Earlier bounded smoke returned 0 rows before acceptance fixtures were created. |
| Permanent Phase 8B triggers | PASS | Read-only `information_schema.TRIGGERS` count returned 0 |

The initial detail smoke exposed a stale local queue view (the endpoint asked
for Phase 7 fields not yet in the applied view). The forward migration was
applied, and the detail/history not-found paths were guarded so optional
lookups do not execute without a resolved case. This was an implementation
defect and is now corrected.

## Disposition

**Phase 8B command acceptance: INCOMPLETE.**  
**Phase 8B overall: REMAINS OPEN.**  
**GUI acceptance: NOT PERFORMED.**  
**Phase 8C: NOT STARTED.**

## Outbound Pickup Defect Recovery

Date: 2026-10-13  
Runtime: `http://localhost:3000`  
Result: outbound pickup success paths recovered; full command acceptance remains incomplete.

### Root Cause

Both outbound pickup `current` queries expressed the shipment direction
(`OUTBOUND`) as a literal inside a Wappler join clause. The generated SQL
incorrectly compiled that literal as `s.direction = undefined.undefined`, so
the first query failed before any mutation. This was confirmed in local MySQL
statement history (error 1054). The prior failed requests left their fixtures
unchanged; the failure was before the write sequence, not a partially applied
mutation.

The same invalid literal-in-join pattern was present in the two return-pickup
queries and manufacturer acknowledgement query. Their direction predicates
were moved to each query's normal `wheres` rules as the same scoped correction.

### Files Changed

- `app/api/manufacturer-returns/outbound/tt-post-pickup.json`
- `app/api/manufacturer-returns/outbound/external-pickup.json`
- `app/api/manufacturer-returns/return/tt-post-pickup.json`
- `app/api/manufacturer-returns/return/external-pickup.json`
- `app/api/manufacturer-returns/manufacturer/acknowledge.json`

All five files parse as JSON. Runtime statement history confirms the corrected
outbound lookup joins on the case ID and filters `s.direction = 'OUTBOUND'`
in `WHERE`.

### Outbound Results

| Fixture | Case / number | Actor | Result | Persisted result |
| --- | --- | --- | --- | --- |
| TTPost | 1 / MFR1, ticket `TKT00000044`, exception 5, device 35 (`P8A-E-20261013-01`) | TTPost user 16 | HTTP 200 | `OUTBOUND_IN_TRANSIT`; pickup recorded by user 16; device `MANUFACTURER_RETURN`; one pickup history and one success audit. |
| External | 2 / MFR2, ticket `TKT00000054`, exception 15, device 45 (`P8A-DROLL-20261013`) | Repair Centre user 18 | HTTP 200 | `OUTBOUND_IN_TRANSIT`; pickup recorded by user 18; device `MANUFACTURER_RETURN`; one pickup history and one success audit. |

Both cases retain ticket `UNDER_REPAIR` and Phase 7 logistics `AT_REPAIR_CENTRE`.
The custody read model reports `TTPOST_MANUFACTURER_OUTBOUND_CUSTODY` for case
1 and `EXTERNAL_COURIER_OUTBOUND_CUSTODY` for case 2, ahead of the stale
Phase 7 display of Repair Centre custody.

Repeated pickup returned HTTP 409 for both paths without duplicate history or
audit. An unauthenticated pickup returned HTTP 401. A Repair Centre actor
calling the TTPost-only endpoint returned HTTP 403. TTPost's list contained
the TTPost case and excluded the external-only case; an attempted TTPost
pickup of the external case returned HTTP 409.

### Concurrency and Rollback

- **Pickup concurrency:** dedicated case 3 / MFR3 (exception 12), two
  simultaneous TTPost requests returned HTTP 200 and HTTP 409. Read-only
  verification found one pickup timestamp, one transition history, one
  success audit, and one `MANUFACTURER_RETURN` lifecycle transition.
- **Pickup rollback:** dedicated case 4 / MFR4 (exception 2) was prepared
  through normal District, start, and outbound-preparation APIs. A temporary
  `BEFORE INSERT` history trigger induced a failure after the shipment, case,
  and device updates. The API returned sanitized HTTP 500. Verification showed
  status remained `AWAITING_OUTBOUND_CARRIER_PICKUP`, pickup timestamp NULL,
  device `IN_REPAIR`, and no pickup history/audit. The trigger was immediately
  dropped; the retry returned HTTP 200.
- Temporary test trigger count after removal: **0**. Permanent triggers on the
  manufacturer-return tables: **0**.
- Security scan of the 500, 409, 401, and 403 responses found none of the
  prohibited SQL, stack, filesystem, or runtime markers.

### Remaining Acceptance

The following resume tests were performed on 2026-10-13 at `localhost:3000`.

### Acknowledgement and Return Pickup

- MFR1 acknowledgement by Repair Centre user 18: HTTP 200; case advanced to
  `AT_MANUFACTURER`; shipment receipt actor/time recorded; one history and one
  audit. Device remained `MANUFACTURER_RETURN`, ticket `UNDER_REPAIR`, and
  Phase 7 logistics `AT_REPAIR_CENTRE`. Duplicate acknowledgement: HTTP 409.
- TTPost return: MFR1 prepared with carrier 1 and picked up by TTPost user 16;
  both actions HTTP 200, duplicate preparation and pickup HTTP 409. One return
  shipment, timestamp, transition, and audit; custody
  `TTPOST_MANUFACTURER_RETURN_CUSTODY`.
- External return: MFR2 prepared with external carrier 2 and picked up by
  Repair Centre user 18; HTTP 200. Duplicate pickup: HTTP 409. TTPost could
  not action the external-only leg: HTTP 409.
- Return pickup concurrency: MFR3 simultaneous TTPost requests returned one
  HTTP 200 and one HTTP 409; exactly one shipment, pickup timestamp, transition
  history, and audit.
- Return pickup rollback: MFR4 temporary history trigger induced sanitized
  HTTP 500. Case stayed `AWAITING_RETURN_CARRIER_PICKUP`; pickup timestamp,
  history, and audit remained absent; device remained `MANUFACTURER_RETURN`.
  Trigger removed (zero remain); normal retry returned HTTP 200.

### Outcomes and Final Receipt

- MFR1 / MFR3: `REPAIRED_ORIGINAL` completed. Cases closed with
  `active_record_key=NULL`; exception `MANUFACTURER_RETURN_COMPLETED`; ticket
  `COMPLETED`; logistics `READY_FOR_RETURN`; device `AVAILABLE` because neither
  had an active student assignment.
- MFR2 / MFR4: `WARRANTY_REJECTED` completed without replacing or retiring the
  original device. MFR7: `BEYOND_ECONOMICAL_REPAIR` completed; exception
  `PENDING_DISTRICT_DECISION`, ticket `UNDER_REPAIR`, logistics
  `AT_REPAIR_CENTRE`, device `IN_REPAIR`.
- MFR6: existing-device serial rejected with HTTP 409. Unique
  `REPLACEMENT_SUPPLIED` outcome recorded and staged; no `devices` row or Phase
  5 assignment was created. Receipt completed with exception
  `PENDING_HEAD_OFFICE_APPROVAL`, disposition `PERMANENT_REPLACEMENT`, ticket
  `UNDER_REPAIR`, logistics `AT_REPAIR_CENTRE`, original device
  `MANUFACTURER_RETURN`, and staged unit received.
- Final-receipt concurrency: MFR3 simultaneous requests returned one HTTP 200
  and one HTTP 409; one completion/history/audit only.
- Repaired-original rollback: MFR5 induced sanitized HTTP 500. Case remained
  `RETURN_IN_TRANSIT`, open, and active; destination receipt, routing, history,
  and audit were absent. Trigger removed; retry returned HTTP 200.
- Replacement-supplied rollback: MFR6 induced sanitized HTTP 500. Case remained
  open and in transit; staged unit remained unreceived; original device,
  exception, history, and audit were unchanged. Trigger removed; retry
  returned HTTP 200. Trigger count on Phase 8B tables: **0**.
- Phase 8A integrations: District reauthorized completed exception 15 and a
  second cycle started as MFR5, leaving MFR2 closed. Head Office approved
  exception 2 after MFR6 receipt; response `REPLACEMENT_APPROVED`.
- Phase 7F integration: repaired-original dispatch allowed for logistics 32
  (handoff 90) and logistics 39 (handoff 92). Replacement-supplied MFR6
  dispatch rejected HTTP 409 after the guard correction.

### Defect Discovered During Resume

The first Phase 7F negative test unexpectedly dispatched warranty-rejected
MFR2 (logistics 42), creating handoff 91 and an audit. The legacy repair
outcome's return-ready flag bypassed the manufacturer outcome restriction.
The Wappler guard was corrected to block any manufacturer-return case unless
it is eligible `REPAIRED_ORIGINAL`. The handoff/history was not deleted. This
unexpected dispatch is a known development-data exception requiring review;
post-fix warranty-rejected and BER dispatch rejection still need dedicated
unconsumed fixtures.

Outcome recording also had an unnecessary device serial query for every
outcome, using unsupported `.toUpperCase()` Server Connect expression syntax.
The query is now replacement-only and uses Wappler `.uppercase()`. Non-replacement
outcomes and replacement duplicate/unique serial paths were runtime verified.

Final receipt had the same literal-in-JOIN defect as pickup. The `RETURN`
direction predicate was moved into WHERE rules; repaired, rejected, BER, and
replacement receipts then passed their tested routes.

### Remaining Open

- Replacement-to-staged-serial duplicate rejection is not separately proven.
- Warranty-rejected Phase 7F rejection after the guard fix and BER Phase 7F
  rejection need isolated eligible fixtures. MFR2's unintended handoff must
  remain in history pending an approved correction process.
- Phase 7F rejection of active/incomplete manufacturer cycles is not verified.
- Full role/scope read/write matrix, carrier deactivation/history, activity
  privacy/data minimization, complete database anomaly counts, and all GUI
  fixtures A-K remain incomplete. GUI acceptance was not performed.
- Temporary `p8b.*` actors and `P8B-EXT-COURIER` remain active pending complete
  acceptance and cleanup. No temporary or permanent Phase 8B triggers remain.

### Files Changed During Resume

- `app/api/manufacturer-returns/outcome/create.json`
- `app/api/manufacturer-returns/return/repair-centre-receive.json`
- `app/api/exceptions/head-office/decide.json`
- `app/api/logistics/handoff/repair-centre-return-dispatch.json`
- This report.

All changed Server Connect files parse as JSON. No custom Express, custom Node
business logic, or runtime raw SQL was added.

**Phase 8B command acceptance: INCOMPLETE.**  
**Phase 8B overall: REMAINS OPEN.**  
**Phase 8C: NOT STARTED.**  
**Phase 8D: NOT STARTED.**

## Final Closure Pass V2

### Port and Static Validation

- `GET http://127.0.0.1:3000/login` returned HTTP 200. The Wappler app is
  reachable on port 3000.
- `jq` parsed the activity endpoint and all six timestamp-write endpoints
  changed during this pass, plus the existing manufacturer-return start action.

### Fresh Activity Ordering Cycle

Exception 1 / ticket `TKT00000034` was used to create one additional cycle
through the normal Server Connect APIs. A neutral assessment was created and
submitted, the manufacturer return was approved, and the cycle completed as
`REPAIRED_ORIGINAL` using the TTPost path. Each action returned HTTP 200:

1. Start manufacturer return (MFR12).
2. Prepare outbound shipment.
3. TTPost outbound pickup.
4. Record manufacturer receipt.
5. Record `REPAIRED_ORIGINAL` outcome.
6. Prepare return shipment.
7. TTPost return pickup.
8. Repair Centre return receipt.
9. Complete manufacturer repair.

The activity response returned this semantic sequence:

`MANUFACTURER_RETURN_STARTED` < `MANUFACTURER_OUTBOUND_PREPARED` <
`MANUFACTURER_CARRIER_PICKUP` < `MANUFACTURER_RECEIVED` <
`MANUFACTURER_OUTCOME_RECORDED` < `MANUFACTURER_RETURN_PREPARED` <
`MANUFACTURER_RETURN_CARRIER_PICKUP` < `MANUFACTURER_RETURN_RECEIVED` <
`MANUFACTURER_REPAIR_COMPLETED`.

Some later events shared a database timestamp to whole-second precision. The
read model now orders by `activity_at`, `activity_sort_order`, and
`related_record_id`; return receipt sorts before repair completion for the
same timestamp. The fresh response confirmed this deterministic order. Six
write actions now use the formatter's millisecond token (`v`) rather than
`SSS`; this correction was made after the runtime cycle, so runtime acceptance
of the final timestamp precision remains OPEN.

The read-model ordering changes are in `app/api/tickets/activity.json` and
`database/phase_08b_ticket_activity.sql`. The timestamp-token changes are in
the six manufacturer-return write actions listed below. The SQL view migration
was applied to the local database; this is a controlled read-model migration,
not runtime raw SQL.

### Permission and Scope Evidence

- Repair Centre positive writes: PASS for start, outbound preparation,
  manufacturer acknowledgement, outcome recording, return preparation, and
  final receipt in the MFR12 journey (HTTP 200). External outbound pickup and
  external return pickup were previously proven HTTP 200 in the MFR2 workflow.
- TTPost positive writes: PASS; outbound and return pickup both returned HTTP
  200 in MFR12.
- Super Admin carrier administration: PASS in the previously recorded
  carrier create/save/status workflow.
- Negative writes: prior role probes returned HTTP 403 for District, Head
  Office, Oversight, School, Technical Officer, TTPost on Repair Centre-only
  outcome actions, and Repair Centre on carrier management. The recorded
  endpoint-by-endpoint role matrix is not complete; retain this as bounded
  evidence, not a complete matrix pass.
- Read/scope: bounded prior probes returned 200 for Repair Centre (service
  location 8), TTPost, District 4, Head Office, and Oversight; School and
  Technical Officer were denied. No-scope list/summary/detail leakage probes
  were denied. Complete entity-by-entity custody-precedence verification
  remains OPEN.

### Custody and GUI Fixture Ledger

MFR12 exercised the TTPost outbound, manufacturer, and TTPost return legs,
ending at Repair Centre receipt. Prior evidence also covers external courier
legs and completed replacement, warranty-rejected, and BER cases. The full
requested state-to-custody matrix, including all active and terminal states
across Ticket Detail, Exception Detail, and Manufacturer Return Detail, was
not completed; CUSTODY MATRIX remains PARTIAL.

Existing fixtures were preserved and rechecked against the available
snapshot:

| Fixture | Current state |
| --- | --- |
| A | Ticket `TKT00000047`, exception 8; manufacturer return approved, no 8B cycle; device 38 `P8A-U2M-20261013`; Caroni / service location 8. |
| B | Not created; no suitable unconsumed approved exception fixture remained. |
| C | Not created; no suitable unconsumed approved exception fixture remained. |
| D | Not created; no suitable unconsumed approved exception fixture remained. |
| E | Ticket `TKT00000050`, exception 11, MFR11; `AT_MANUFACTURER`, external outbound, manufacturer custody. |
| F | Not created; no suitable unconsumed approved exception fixture remained. |
| G | Not created; no suitable unconsumed approved exception fixture remained. |
| H | Not created; no suitable unconsumed approved exception fixture remained. |
| I | Ticket `TKT00000046`, exception 7, MFR8; repaired original completed, ticket completed, logistics ready for return, undispatched, Phase 7F eligible. |
| J | Ticket `TKT00000042`, exception 3, MFR10; replacement supplied, exception has advanced to Head Office approval state; staged replacement remains staged only. This is not the requested unchanged GUI target state. |
| K | Ticket `TKT00000049`, exception 10, MFR7; BER completed, exception pending District decision, ticket under repair, logistics at Repair Centre, device in repair. |

The only suitable unused approved candidate was exception 1; it was consumed
to create the required fresh ordering cycle. Exception 8 remains reserved for
A. Other candidates are terminal/progression cases or the preserved J/K/E/I
fixtures. Building B/C/D/F/G/H now would require additional normal-API
business setup beyond the remaining eligible candidates. No SQL-fabricated
business state was created. GUI acceptance remains NOT PERFORMED.

### Database Consistency and Privacy

The measured SQL anomaly checks for items 1-19 and 22-30 returned zero, except
item 25: two active Phase 7F handoffs were present and both were valid later
progression for repaired-original cases, so the uncontrolled count is zero.
Handoff 91 remains the corrected historical defect. Temporary Phase 8B
triggers: 0. Items 20 and 21 were checked by static inspection of the
manufacturer-return endpoints, which found no Phase 5 allocation or ticket
work-owner mutation references; these are not represented as independent
database attribution counts. The report therefore does not claim a complete
raw database anomaly suite.

The earlier activity and queue payload privacy scans remain bounded to the
tested samples. The MFR12 activity response contained only the established
safe event projection. A fresh full scan across the MFR12 cycle and all
representative outcome classes, and a final queue privacy scan, were not
completed in this pass; final privacy acceptance remains OPEN.

### Accounts, Carrier, and Final Ledger

The five GUI-role accounts remain active and are retained for user GUI
acceptance: `p7d.repair.test` (Repair Centre, service location 8),
`p7b.ttpost.test` (TTPost), `p8b.district.1` (District 4), `p8b.ho.1`
(national Head Office), and `p8b.oversight` (national read-only). No temporary
account was disabled. `P8B-EXT-COURIER` remains ACTIVE for GUI fixture F.

| Requirement | V2 result |
| --- | --- |
| Port 3000 | PASS |
| Final timestamp precision runtime test | OPEN; final `v` formatter token was statically validated after the fresh cycle |
| Deterministic activity ordering | PASS; stable secondary ordering inspected and tied-event response verified |
| Fresh activity cycle | PASS for semantic event sequence; all nine workflow calls HTTP 200 |
| Positive Repair Centre / TTPost writes | PASS for the listed capabilities with direct workflow evidence |
| Complete negative write matrix | OPEN; bounded role denials only |
| Read/scope matrix | PARTIAL |
| Custody matrix | PARTIAL |
| Database anomaly suite | PARTIAL; measured uncontrolled count 0, items 20/21 static-only |
| Final activity and queue privacy | OPEN; prior scans were bounded |
| GUI fixtures A/E/I/J/K | Preserved; see exact states above |
| GUI fixtures B/C/D/F/G/H | NOT CREATED; no eligible candidate remained |
| GUI acceptance | NOT PERFORMED — USER WILL TEST |

**Test ledger: INCOMPLETE. Phase 8B command acceptance: INCOMPLETE. Phase 8B
overall: REMAINS OPEN; not ready to declare GUI acceptance readiness.**
**Phase 8C: NOT STARTED. Phase 8D: NOT STARTED.**

## Final Remaining Command Gap Closure

Date: 2026-10-13. This section supersedes earlier snapshots above where the
same current-state facts differ. Port `3000` was reachable (`GET /login` HTTP
200). Handoff 91 remains a corrected historical defect; it was not changed in
this closure.

### Defect Corrections and Validation

- `app/api/manufacturer-returns/start.json`: the start gate previously
  rejected the valid `UNABLE_TO_REPAIR` repair outcome after District approval
  selected `MANUFACTURER_RETURN`. The gate now requires that approved
  disposition and accepts either `MANUFACTURER_RETURN_REQUIRED` or
  `UNABLE_TO_REPAIR`. A normal-API runtime start on exception 3 succeeded as
  MFR9; the resulting second cycle and later exception progression are
  preserved.
- The six pickup/acknowledgement/receipt timestamps used `{{NOW}}`, which
  produced whole-second values in `DATETIME(6)` columns. Those event writes now
  use the established Wappler date formatter with millisecond precision.
  All changed API files parse as JSON. Existing historical events remain
  unchanged; their activity feed still contains ordering inversions, so the
  activity-ordering acceptance item is **not yet proven PASS** after this
  forward fix.
- No database data was changed for these two implementation corrections.

### Phase 7F Guard Results

- **Warranty rejected:** MFR9 (ticket `TKT00000042`, exception 3, logistics
  30) was completed with `WARRANTY_REJECTED`; the Phase 7F dispatch attempt
  returned HTTP 409 with a controlled response and created no handoff. At the
  time of the test, ticket/logistics/device state remained `UNDER_REPAIR`,
  `AT_REPAIR_CENTRE`, and `MANUFACTURER_RETURN`. The exception was later
  legitimately advanced through a second manufacturer cycle (MFR10); do not
  treat its current Head Office approval state as a test-time rollback.
- **Active cycle:** an active outbound-in-transit cycle was rejected by the
  Phase 7F dispatch endpoint with HTTP 409; no handoff was created and the
  manufacturer cycle remained active. MFR11 is separately retained as the
  current `AT_MANUFACTURER` GUI fixture.
- **Repaired original:** MFR8 is a fresh, completed repaired-original cycle.
  Authenticated logistics detail for case 34 reports
  `manufacturer_return_eligible: true`, `READY_FOR_RETURN`, completed ticket,
  restored `AVAILABLE` lifecycle, and `REPAIR_CENTRE_RETURN_RECEIVED` custody.
  It has no Phase 7F dispatch and is preserved as GUI Fixture I.

### Staged Serial and Role / Carrier Results

- Staged serial versus an existing device: PASS from prior runtime evidence;
  duplicate attempt returned HTTP 409.
- Staged serial versus staged serial: MFR11 attempted normalized duplicate
  `P8B-STAGED-DUP-001`; HTTP 409, no second staged unit. Final exact count is
  one normalized staged unit and zero matching device-register rows.
- Read probes: manufacturer-return list returned HTTP 200 for Repair Centre,
  TTPost, District, Head Office, and Oversight; School and Technical Officer
  returned 403. School, Technical Officer, and no-scope non-Super Admin
  detail probes returned 403. No-scope list and summary returned 403. TTPost
  queue excluded the external-only MFR11; general Ticket Detail returned 403.
- Write isolation: all tested workflow write endpoints returned 403 for
  District, Head Office, Oversight, School, Technical Officer, and no-scope
  actors. Repair Centre and TTPost permitted-endpoint probes used empty
  payloads, so expected validation/state responses did not complete a
  full positive authorization matrix. Role/scope acceptance remains PARTIAL.
- Carrier administration: Super Admin list/options/status calls and create,
  edit, and deactivate calls succeeded. Repair Centre, District, Head Office,
  and Oversight can view as configured but cannot manage; TTPost cannot manage
  or access the carrier administration list. The test carrier
  `P8B-CMD-CARRIER-20261013` (id 4) is inactive. `P8B-EXT-COURIER` (id 2) is
  active and retained for GUI acceptance.
- GUI actors remain active with password `test`: `p7d.repair.test`
  (REPAIR_CENTRE, service location 8), `p7b.ttpost.test`
  (TTPOST_LOGISTICS), `p8b.district.1` (ICT_DISTRICT_COORDINATOR, district 4),
  `p8b.ho.1` (MOE_HEAD_OFFICE, national), and `p8b.oversight`
  (TSTT_OVERSIGHT, national/read-only). They are marked temporary and retained
  for user GUI acceptance. No `p8b.*` actor was identified as concurrency-only
  in the final account list; no account was disabled. The complete duplicate-
  actor audit was not performed.

### Activity and Data Minimization

- Representative Ticket Activity reads contained the required event families
  across repaired-original, replacement-supplied, warranty-rejected, and BER
  cases. Retry/409 tests did not create duplicate pickup/receipt history or
  success audit entries. Completeness is PASS for the event families observed.
- Ordering is FAIL for existing data: ticket 42/MFR9 and ticket 46/MFR8 show
  return receipt timestamps before outcome/return-preparation timestamps, and
  ticket 42/MFR10 shows receipt/pickup timestamps tied with earlier events.
  The precision correction above is not yet runtime-proven with a fresh
  post-fix cycle; do not mark activity ordering PASS.
- Activity and queue projections were scanned. No RMA, tracking/shipment
  reference, staged replacement serial, manufacturer internal notes,
  manufacturer resolution reference, financial fields, student/guardian
  details, requester email, or requester phone was present in tested
  responses. Data-minimization scan: PASS for the tested projections.

### Final Database Consistency Snapshot

Read-only counts on `laptop_tickets_db`:

| Check | Raw anomaly count |
| --- | ---: |
| Multiple active manufacturer cycles per exception | 0 |
| Closed case with active key | 0 |
| Closed case missing `closed_at` | 0 |
| Invalid/dangling case, device, manufacturer, exception, ticket, logistics, or repair-job relationship | 0 |
| OUTBOUND_IN_TRANSIT without outbound pickup | 0 |
| AT_MANUFACTURER without acknowledgement | 0 |
| RETURN_IN_TRANSIT without return pickup | 0 |
| Completed non-replacement case without Repair Centre return custody | 0 |
| REPAIRED_ORIGINAL ticket not completed | 0 |
| REPAIRED_ORIGINAL logistics not READY_FOR_RETURN | 0 |
| REPAIRED_ORIGINAL device not restored to expected lifecycle | 0 |
| Replacement staged serial present in `devices` | 0 |
| Replacement original prematurely marked REPLACED | 0 |
| Duplicate normalized staged serial | 0 |
| Staged serial matching a device serial | 0 |
| Current status different from latest status-history row | 0 |
| Dangling shipment FK / dangling outcome FK | 0 / 0 |
| Active Phase 7F handoff for incomplete manufacturer cycle | 0 |
| Active Phase 7F handoff for non-repaired completed outcome | 0 |
| Phase 8B-table triggers / temporary named triggers | 0 / 0 |

The two active Phase 7F handoffs found (90 and 92) are valid
REPAIRED_ORIGINAL returns. Legitimate later progression exclusions include
ticket 54/MFR2, which subsequently completed the valid Phase 7F return, and
exception 3, which was reauthorized for its second cycle MFR10. The zeroes
above are the measured subset, not the complete requested anomaly suite:
multiple shipments per direction, ticket work-owner / Phase 5 mutation
attribution, and every invalid-handoff subcategory were not independently
queried. Therefore a complete raw/uncontrolled anomaly total is **not
certified**.

### Current GUI Fixture Inventory

Only A, E, I, J, and K are currently prepared. B, C, D, F, G, and H are not
available simultaneously; no GUI acceptance was performed.

| Fixture | Exact current identifiers and state |
| --- | --- |
| A | Ticket `TKT00000047`; exception 8; no manufacturer-return case/number; repair job 17; device 38, serial `P8A-U2M-20261013`, asset tag `P8A-U2M-20261013-TAG`; Phase 4B Manufacturer A 20261007201534; P7D Repair Centre Test Facility; Caroni; no outbound/return carrier or outcome; exception `MANUFACTURER_RETURN_APPROVED`; ticket `UNDER_REPAIR`; logistics 35 `AT_REPAIR_CENTRE`; device `IN_REPAIR`; physical `REPAIR_CENTRE_CUSTODY`. |
| E | Ticket `TKT00000050`; exception 11; MFR case 11 / `MFR11`; repair job 20; device 41, serial `P8A-HOR-20261013`, asset tag `P8A-HOR-20261013-TAG`; Phase 4B Manufacturer A 20261007201534; P7D Repair Centre Test Facility; Caroni; outbound carrier `P8B-EXT-COURIER`, no return carrier; no outcome; MFR `AT_MANUFACTURER`; exception `MANUFACTURER_RETURN_IN_PROGRESS`; ticket `UNDER_REPAIR`; logistics 38 `AT_REPAIR_CENTRE`; device `MANUFACTURER_RETURN`; physical `MANUFACTURER_CUSTODY`. |
| I | Ticket `TKT00000046`; exception 7; MFR case 8 / `MFR8`; repair job 16; device 37, serial `P8A-G-20261013-01`, asset tag `P8A-G-20261013-01-TAG`; Phase 4B Manufacturer A 20261007201534; P7D Repair Centre Test Facility; Caroni; outbound TTPost, return `P8B-EXT-COURIER`; `REPAIRED_ORIGINAL`; MFR `COMPLETED`; exception `MANUFACTURER_RETURN_COMPLETED`; ticket `COMPLETED`; logistics 34 `READY_FOR_RETURN`; device `AVAILABLE`; physical `REPAIR_CENTRE_RETURN_RECEIVED`; Phase 7F eligible and not dispatched. |
| J | Ticket `TKT00000042`; exception 3; MFR case 10 / `MFR10`; repair job 12; device 33, serial `P8A-C-20261013-01`, asset tag `P8A-C-TAG-20261013-01`; Phase 4B Manufacturer A 20261007201534; P7D Repair Centre Test Facility; Caroni; outbound `P8B-EXT-COURIER`, return TTPost; `REPLACEMENT_SUPPLIED`; MFR `COMPLETED`; exception `PENDING_HEAD_OFFICE_APPROVAL`; ticket `UNDER_REPAIR`; logistics 30 `AT_REPAIR_CENTRE`; original device `MANUFACTURER_RETURN`; staged serial `P8B-STAGED-DUP-001` exists only in staged-unit table; physical `MANUFACTURER_RETAINED_PENDING_REPLACEMENT`. Do not approve. |
| K | Ticket `TKT00000049`; exception 10; MFR case 7 / `MFR7`; repair job 19; device 40, serial `P8A-DRR-20261013`, asset tag `P8A-DRR-20261013-TAG`; Phase 4B Manufacturer A 20261007201534; P7D Repair Centre Test Facility; Caroni; outbound and return TTPost; `BEYOND_ECONOMICAL_REPAIR`; MFR `COMPLETED`; exception `PENDING_DISTRICT_DECISION`; ticket `UNDER_REPAIR`; logistics 37 `AT_REPAIR_CENTRE`; device `IN_REPAIR`; physical `REPAIR_CENTRE_RETURN_RECEIVED`. |

### Final Ledger

| Requirement | Final classification |
| --- | --- |
| Port 3000 | PASS |
| Handoff 91 | Corrected historical defect; preserved |
| Phase 7F warranty-rejected rejection | PASS, HTTP 409; no handoff |
| Phase 7F active-cycle rejection | PASS, HTTP 409; no handoff |
| Phase 7F repaired-original | PASS; logistics detail says eligible; no dispatch |
| Staged serial vs device | PASS |
| Staged serial vs staged | PASS, HTTP 409; exactly one staged row |
| Role/scope matrix | FAIL / PARTIAL; full positive endpoint matrix not run |
| Carrier admin authorization | PASS for tested roles/actions |
| Activity completeness | PASS for observed event families |
| Activity ordering | FAIL for existing events; precision fix requires fresh runtime verification |
| Data minimization | PASS for scanned activity/queue projections |
| Custody precedence | PASS for the sampled current state, but full status-by-status matrix remains partial |
| Full database consistency | INCOMPLETE; measured subset is all zero, remaining requested checks unverified |
| GUI fixtures A-K | INCOMPLETE; only A/E/I/J/K available |
| GUI acceptance | NOT PERFORMED — USER WILL TEST |

**Implementation changes this closure:**

- `app/api/manufacturer-returns/start.json`
- `app/api/manufacturer-returns/outbound/tt-post-pickup.json`
- `app/api/manufacturer-returns/outbound/external-pickup.json`
- `app/api/manufacturer-returns/manufacturer/acknowledge.json`
- `app/api/manufacturer-returns/return/tt-post-pickup.json`
- `app/api/manufacturer-returns/return/external-pickup.json`
- `app/api/manufacturer-returns/return/repair-centre-receive.json`
- This test report.

All changed Server Connect files pass JSON parsing. No custom Express, custom
Node business logic, runtime raw SQL, or permanent triggers were added.

**Phase 8B command acceptance: INCOMPLETE.**
**Phase 8B overall: REMAINS OPEN.**
**Phase 8C: NOT STARTED.**
**Phase 8D: NOT STARTED.**

## Final Command Acceptance Closure

Date: 2026-10-13  
Result: **INCOMPLETE — GUI acceptance and multiple command-acceptance items remain open.**

### Handoff 91 Data Correction

Before correction, read-only inspection found:

- Handoff 91 was `REPAIR_CENTRE_TO_TTPOST`, logistics case 42
  (`LOG00000042`), dispatched from service location 8 to TTPost location 5,
  not received, and had `active_record_key=1`.
- One historical `DISPATCH` scan (scan 141) existed. No receipt/downstream
  TTPost scan was recorded.
- The active handoff incorrectly made the logistics custody view report
  `PENDING_TTPOST_RETURN_RECEIPT` and `pending_handoff_id=91`.
- Importantly, the linked exception 15/logistics 42 had subsequently completed
  a distinct, valid second manufacturer cycle (MFR5, `REPAIRED_ORIGINAL`). At
  correction time the authoritative later state was exception
  `MANUFACTURER_RETURN_COMPLETED`, ticket `COMPLETED`, logistics
  `READY_FOR_RETURN`, device `AVAILABLE`, with the device allocated to School
  1. Rewinding those later records to the earlier warranty-rejected state
  would have undone valid later workflow and custody history.

Correction applied through `database/phase_08b_correct_invalid_handoff_91.sql`:

- Cleared only handoff 91's `active_record_key` to remove it as the current
  handoff. The handoff row and dispatch scan were preserved.
- Added one generic audit row with action
  `phase8b_invalid_return_dispatch_corrected`; no student, tracking, warranty,
  or financial details were recorded.
- Left exception, ticket, logistics status, device lifecycle, Phase 5
  allocations, and ticket work ownership unchanged to preserve MFR5's valid
  later progression. This is a deliberate deviation from the brief's earlier
  warranty-rejected snapshot postcondition, required by the verified record
  chronology.
- Reran the correction script: it was idempotent. Final counts: handoff row 1,
  dispatch scan 1, matching correction audit 1, active handoff for logistics
  42 0. The logistics custody view now reports Repair Centre custody with no
  pending handoff. The manufacturer custody projection reports
  `REPAIR_CENTRE_RETURN_RECEIVED` for the latest completed repaired-original
  case.

### Post-Fix Phase 7F Guard

Using authenticated `p7d.repair.test` against port 3000:

- Completed replacement-supplied case, logistics 29: HTTP 409, controlled
  ineligible response; no changes committed.
- Completed BER case, logistics 37: HTTP 409, controlled ineligible response;
  no changes committed.
- Repaired-original dispatch was previously accepted for logistics 32 and 39
  (handoffs 90 and 92). Those are not fresh, unconsumed fixtures.
- A clean post-fix warranty-rejected fixture and a clean active/incomplete
  cycle fixture were not available. The earlier MFR2 warranty-rejected attempt
  is the known invalid handoff being corrected, so it is not counted as a
  post-fix rejection test.

### Role / Scope Probe

Port 3000 authenticated list probes returned HTTP 200 for:

- `p7d.repair.test` — `REPAIR_CENTRE`, active service-location scope 8.
- `p7b.ttpost.test` — `TTPOST_LOGISTICS`.
- `p8b.district.1` — `ICT_DISTRICT_COORDINATOR`, active district scope 4.
- `p8b.ho.1` — `MOE_HEAD_OFFICE`, active national scope.
- `p8b.oversight` — `TSTT_OVERSIGHT`, active national scope.

`phase3.school.test` and `p6c.tech.test` authenticated, then received HTTP
403 from manufacturer-return list. The outcome-write endpoint returned HTTP
403 for TTPost, District, Head Office, Oversight, School, and Technical
Officer actors. This is a bounded role probe, not the full endpoint-by-endpoint
matrix; full matrix remains open.

### Data / Trigger Snapshot

- Active manufacturer-return cycles: **0**.
- Temporary triggers on Phase 8B tables: **0**.
- Handoff 91 retained, corrected, and no longer pending/current.
- Handoff 91 does not establish all requested anomaly counts. Full database
  consistency, activity/privacy, custody precedence, staged-serial-vs-staged,
  and remaining endpoint matrix checks are not complete.

### Ticket Activity and Privacy Probe

The national-scoped Ticket Activity endpoint was exercised for tickets 41,
44, 49, and 54. Across those responses, the expected event categories were
present: started, outbound prepared, outbound carrier pickup, manufacturer
received, outcome recorded, return prepared, return carrier pickup, return
received, repair completed, replacement received, warranty rejected, and BER
recorded. Repeated events were associated with test tickets that had multiple
manufacturer cycles; a complete per-cycle duplicate/order audit remains open.

The response projection is limited to ticket/event IDs, timestamps, event and
status codes/names, safe actor/subject display names, and reference code. The
tested payloads contained no RMA/tracking/test shipment references, staged
replacement serials, financial fields, student name, guardian name, requester
email, or requester phone. This is a bounded payload scan, not the full
role-by-role privacy acceptance.

### Available GUI Fixture Snapshot

The simultaneous A-K GUI fixture set was not rebuilt. Only these relevant
records currently match requested fixture states:

| Fixture | Current record | State / limitation |
| --- | --- | --- |
| A | Ticket `TKT00000047`, exception 8, logistics 35 (`LOG00000035`), repair job 17, device 38, serial `P8A-U2M-20261013`, asset tag `P8A-U2M-20261013-TAG` | `MANUFACTURER_RETURN_APPROVED`, no manufacturer-return cycle; Caroni, P7D Repair Centre Test Facility, outcome `UNABLE_TO_REPAIR`, ticket `UNDER_REPAIR`, logistics `AT_REPAIR_CENTRE`, device `IN_REPAIR`. Manufacturer/carrier not yet selected. |
| K | Ticket `TKT00000049`, exception 10, MFR7, logistics 37 (`LOG00000037`), repair job 19, device 40, serial `P8A-DRR-20261013`, asset tag `P8A-DRR-20261013-TAG` | `BEYOND_ECONOMICAL_REPAIR`, exception `PENDING_DISTRICT_DECISION`, ticket `UNDER_REPAIR`, logistics `AT_REPAIR_CENTRE`, device `IN_REPAIR`; outbound and return carriers TTPost; Caroni, P7D Repair Centre Test Facility. |

B-H were not staged. I is not a clean un-dispatched fixture. J's exception has
already advanced to `REPLACEMENT_APPROVED`, so it is not suitable. GUI
acceptance was not performed.

### GUI Accounts and Temporary Resources

Available account credentials for user acceptance (password `test`):

| Username | Role | Active scope | Intended GUI use |
| --- | --- | --- | --- |
| `p7d.repair.test` | `REPAIR_CENTRE` | Service location 8 | Repair-centre manufacturer-return workflow |
| `p7b.ttpost.test` | `TTPOST_LOGISTICS` | TTPost operational role | TTPost pickup/queue participation |
| `p8b.district.1` | `ICT_DISTRICT_COORDINATOR` | District 4 | District exception review |
| `p8b.ho.1` | `MOE_HEAD_OFFICE` | National | Head Office review (do not use for fixture J until rebuilt) |
| `p8b.oversight` | `TSTT_OVERSIGHT` | National | Oversight read view |

All five accounts remain active pending GUI acceptance. Concurrency-only
duplicate actors were not separately audited/disabled in this closure.
External carrier `P8B-EXT-COURIER` remains active as a GUI dependency; do not
delete it before GUI acceptance. Temporary trigger count is zero.

### Closure Ledger

| Item | Result |
| --- | --- |
| Port 3000 | PASS at time of bounded probes |
| Handoff 91 correction | Corrected by data migration; row and scan retained |
| Phase 7F replacement rejection | PASS, HTTP 409 |
| Phase 7F BER rejection | PASS, HTTP 409 |
| Phase 7F repaired-original allow | Previously passed, but no clean fixture remains |
| Phase 7F warranty-rejected rejection | OPEN |
| Active/incomplete cycle rejection | OPEN |
| Staged serial vs existing device | PASS (prior runtime evidence) |
| Staged serial vs another staged unit | OPEN |
| Role/scope matrix | PARTIAL; bounded read and outcome-write probes only |
| Activity completeness/privacy | OPEN |
| Custody precedence matrix | PARTIAL; handoff 91 corrected and latest case projection checked |
| Full anomaly suite | OPEN; only active cycles 0 and Phase 8B triggers 0 verified here |
| GUI fixtures A-K | OPEN; A and K remain, full set absent |
| GUI acceptance | NOT PERFORMED |

**Phase 8B command acceptance: INCOMPLETE.**  
**Phase 8B overall: REMAINS OPEN FOR REMAINING COMMAND ACCEPTANCE AND GUI ACCEPTANCE.**  
**Phase 8C: NOT STARTED.**  
**Phase 8D: NOT STARTED.**

## V2 Final Superseding Status

This note is the final status for the 2026-10-13 Final Closure Pass V2 and
supersedes earlier closure snapshots above. Port and deterministic activity
ordering passed; the fresh MFR12 journey passed the event sequence. The final
millisecond timestamp formatter was only statically validated after that
journey. The full role/scope and custody matrices, complete database anomaly
attribution, final privacy scans, and GUI fixtures B/C/D/F/G/H remain open.
Existing fixtures A/E/I/J/K and the five GUI-role accounts remain preserved;
`P8B-EXT-COURIER` remains active. No fixture state was fabricated with SQL.

**V2 test ledger: INCOMPLETE. Phase 8B command acceptance: INCOMPLETE. GUI
acceptance: NOT PERFORMED — USER WILL TEST. Phase 8B remains open. Phase 8C
and Phase 8D were not started.**

## Final Command Closure V3

Date: 2026-10-13  
Result: **COMMAND ACCEPTANCE COMPLETE; GUI ACCEPTANCE REMAINS FOR USER.**

### Runtime and Timestamp Verification

Port 3000 returned HTTP 200 for `/login` and authenticated application pages
during this pass. The local server briefly refused a connection while its
files were reloading, then returned HTTP 200 on retry; no implementation
runtime fault was observed.

All six timestamp-writing action categories were exercised after the final
`yyyy-MM-dd HH:mm:ss.v` formatter change. Detail APIs returned valid ISO date
times with millisecond precision and no malformed value or SQL/date error:

| Action | Runtime evidence |
| --- | --- |
| TTPost outbound pickup | MFR13, `2026-10-13T16:05:51.448Z` |
| External outbound pickup | MFR14, `2026-10-13T16:07:18.015Z` |
| Manufacturer acknowledgement | MFR13 history, `2026-10-13T16:06:09.162Z` |
| TTPost return pickup | MFR13, `2026-10-13T16:06:36.332Z` |
| External return pickup | MFR15, `2026-10-13T16:07:32.799Z` |
| Repair Centre final receipt | MFR13 return receipt, `2026-10-13T16:06:36.376Z`; final status history `2026-10-13T16:06:36.380Z` |

Ticket 61 activity returned the ordered manufacturer sequence:
`MANUFACTURER_RETURN_STARTED`, `MANUFACTURER_OUTBOUND_PREPARED`,
`MANUFACTURER_CARRIER_PICKUP`, `MANUFACTURER_RECEIVED`,
`MANUFACTURER_OUTCOME_RECORDED`, `MANUFACTURER_RETURN_PREPARED`,
`MANUFACTURER_RETURN_CARRIER_PICKUP`, `MANUFACTURER_RETURN_RECEIVED`,
`MANUFACTURER_REPAIR_COMPLETED`. No duplicate manufacturer event was present
in that fresh cycle.

### Fixture Pool and GUI States

Nine fresh, normal-API-created approved exceptions were reserved before these
remaining tests: B, C, D, F, G, H, J, TIMESTAMP, and X. No business state was
fabricated or corrected through SQL. All are Caroni / District 4, School 1,
Repair Centre location 8, and manufacturer Phase 4B Manufacturer A.

| Fixture | Ticket / exception / MFR | Repair job; device / serial | Carriers; outcome | Final state and custody |
| --- | --- | --- | --- | --- |
| A | TKT00000047 / exception 8 / none | Job 17; device 38 / `P8A-U2M-20261013` | No carrier; `UNABLE_TO_REPAIR` | Approved, no 8B cycle; ticket UNDER_REPAIR, logistics AT_REPAIR_CENTRE, device IN_REPAIR, REPAIR_CENTRE_CUSTODY |
| B | TKT00000065 / exception 21 / MFR16 | Job 30; device 48 / `P8B-V3-POOL-B-20261013` | None; no manufacturer outcome | PREPARATION_REQUIRED; exception in progress, ticket UNDER_REPAIR, logistics AT_REPAIR_CENTRE, device MANUFACTURER_RETURN, REPAIR_CENTRE_MANUFACTURER_PREPARATION |
| C | TKT00000066 / exception 22 / MFR17 | Job 31; device 49 / `P8B-V3-POOL-C-20261013` | TTPost outbound; no outcome | AWAITING_OUTBOUND_CARRIER_PICKUP; PENDING_OUTBOUND_CARRIER_PICKUP |
| D | TKT00000067 / exception 23 / MFR18 | Job 32; device 50 / `P8B-V3-POOL-D-20261013` | TTPost outbound; no outcome | OUTBOUND_IN_TRANSIT; TTPOST_MANUFACTURER_OUTBOUND_CUSTODY |
| E | TKT00000050 / exception 11 / MFR11 | Job 20; device 41 / `P8A-HOR-20261013` | P8B-EXT-COURIER outbound; no outcome | AT_MANUFACTURER; exception in progress, ticket UNDER_REPAIR, logistics AT_REPAIR_CENTRE, device MANUFACTURER_RETURN, MANUFACTURER_CUSTODY |
| F | TKT00000068 / exception 24 / MFR14 | Job 33; device 51 / `P8B-V3-POOL-F-20261013` | P8B-EXT-COURIER outbound; no outcome | OUTBOUND_IN_TRANSIT; EXTERNAL_COURIER_OUTBOUND_CUSTODY |
| G | TKT00000069 / exception 25 / MFR19 | Job 34; device 52 / `P8B-V3-POOL-G-20261013` | TTPost outbound and return; REPAIRED_ORIGINAL | AWAITING_RETURN_CARRIER_PICKUP; PENDING_RETURN_CARRIER_PICKUP |
| H | TKT00000060 / exception 18 / MFR21 | Job 27; device 29 / `P7F-ROLLBACK-20261012` | TTPost outbound and return; REPAIRED_ORIGINAL | RETURN_IN_TRANSIT; TTPOST_MANUFACTURER_RETURN_CUSTODY |
| I | TKT00000046 / exception 7 / MFR8 | Job 16; device 37 / `P8A-G-20261013-01` | TTPost outbound, P8B-EXT-COURIER return; REPAIRED_ORIGINAL | COMPLETED / MANUFACTURER_RETURN_COMPLETED; ticket COMPLETED, logistics READY_FOR_RETURN, device AVAILABLE, REPAIR_CENTRE_RETURN_RECEIVED; undispatched and Phase 7F eligible |
| J | TKT00000070 / exception 26 / MFR20 | Job 35; device 53 / `P8B-V3-POOL-J-20261013` | TTPost outbound and return; REPLACEMENT_SUPPLIED | MFR COMPLETED; exception PENDING_HEAD_OFFICE_APPROVAL; ticket UNDER_REPAIR; logistics AT_REPAIR_CENTRE; original device MANUFACTURER_RETURN; staged serial `P8B-V3-REPLACEMENT-J-20261013` received, no devices row; MANUFACTURER_RETAINED_PENDING_REPLACEMENT. Head Office approval was not performed. |
| K | TKT00000049 / exception 10 / MFR7 | Job 19; device 40 / `P8A-DRR-20261013` | TTPost outbound and return; BEYOND_ECONOMICAL_REPAIR | COMPLETED / PENDING_DISTRICT_DECISION; ticket UNDER_REPAIR, logistics AT_REPAIR_CENTRE, device IN_REPAIR, REPAIR_CENTRE_RETURN_RECEIVED |

Pool-TIMESTAMP is ticket 61 / exception 19 / MFR13, job 28, device 30,
`P7F-CONCURRENCY-20261012`; completed REPAIRED_ORIGINAL, TTPost both legs,
Repair Centre return custody. Pool-X is ticket 62 / exception 20 / MFR15,
job 29, device 31, `P7G-GOLDEN-20261012`; REPAIRED_ORIGINAL with TTPost
outbound and external return, currently RETURN_IN_TRANSIT with
EXTERNAL_COURIER_RETURN_CUSTODY.

The former GUI-J MFR10 was not changed. Fresh MFR20 is the requested GUI-J
state. Failed earlier candidate setup left ordinary API-created ticket
records 57–59 (ticket 57 approved but blocked by an existing active pickup;
tickets 58–59 remain submitted). They have no new MFR cycle and were not
deleted or altered by SQL.

### Authorization, Read Scope, and Custody

Positive Repair Centre and TTPost workflow writes have direct successful
evidence in MFR13–MFR21, including external pickup and final receipt. Carrier
administration create/save/status success remains covered by the existing V2
direct evidence; the V2 test carrier remains inactive and the GUI carrier is
untouched.

Fresh negative probes returned HTTP 403 with `{"success":false,"error":"Forbidden."}`:

| Role | Probe evidence |
| --- | --- |
| District, Head Office, Oversight, School, Technical Officer | Manufacturer outcome mutation guard |
| TTPost | Outcome, manufacturer acknowledgement, Repair Centre final receipt, carrier save |
| Repair Centre | Carrier save |

These requests used empty bodies; permission checks ran first and no mutation
was possible. Prior equivalent endpoint/guard evidence remains in the V2
ledger.

Read/scope results: Repair Centre list HTTP 200 returned 21 cases at service
location 8; District 4 list HTTP 200 returned only District 4 cases and detail
MFR14 HTTP 200, while Tobago MFR12 returned HTTP 403; national Head Office
and Oversight lists returned HTTP 200 with both represented districts; the
no-scope non-Super `phase3.district.test` received HTTP 403; School and
Technical Officer manufacturer-return lists each returned HTTP 403. TTPost
list returned 17 relevant cases. A direct TTPost detail read of external-only
MFR14 initially returned HTTP 200, revealing a scope defect. The existing
Wappler-native guard now requires `has_ttpost_participation`; retest returned
HTTP 403 for MFR14 while participating MFR13 remained HTTP 200.

The required custody states are represented by the simultaneous A–K pool and
Pool-X: preparation, pending outbound pickup, TTPost outbound, external
outbound, manufacturer custody, pending return pickup, TTPost return,
external return, repaired-original receipt, warranty-rejected receipt, BER
receipt, and replacement-supplied manufacturer retention. MFR21 detail and
the ticket-summary API both report `TTPOST_MANUFACTURER_RETURN_CUSTODY`.
Exception Detail previously rendered the stale Phase 7 custody field. Its
view now prefers `manufacturerReturnSummary.data.summary.physical_custody_code`
and falls back to the Phase 7 field only when no 8B summary exists. The
authenticated Exception Detail page returned HTTP 200 with that binding.

### Privacy and Database Consistency

Fresh activity responses for repaired-original (ticket 61), replacement
supplied (ticket 70), warranty rejected (ticket 54), and BER (ticket 49) were
scanned. The authorized queue response contained 21 cases and was also scanned.
No `rma_number`, tracking/shipment reference, manufacturer case/warranty or
resolution reference, staged-unit serial, cost/financial field, student name,
guardian, requester email, or requester phone field/value was found in those
activity/queue projections.

Read-only `laptop_tickets_db` checks; `raw / valid exclusion / final
uncontrolled` counts:

| # | Check | Raw / exclusion / uncontrolled |
| --- | --- | ---: |
| 1 | Multiple active manufacturer cycles per exception | 0 / 0 / 0 |
| 2 | Closed case with active key | 0 / 0 / 0 |
| 3 | Closed case missing `closed_at` | 0 / 0 / 0 |
| 4 | Dangling case/device/manufacturer/ticket/logistics/repair relationships | 0 / 0 / 0 |
| 5 | Multiple outbound shipments per cycle | 0 / 0 / 0 |
| 6 | Multiple return shipments per cycle | 0 / 0 / 0 |
| 7 | OUTBOUND_IN_TRANSIT without pickup | 0 / 0 / 0 |
| 8 | AT_MANUFACTURER without outbound acknowledgement/receipt | 0 / 0 / 0 |
| 9 | RETURN_IN_TRANSIT without return pickup | 0 / 0 / 0 |
| 10 | COMPLETED without final Repair Centre receipt | 0 / 0 / 0 |
| 11 | Active manufacturer-transit device lifecycle mismatch | 0 / 0 / 0 |
| 12 | REPAIRED_ORIGINAL ticket not completed | 3 / 3 / 0 |
| 13 | REPAIRED_ORIGINAL logistics not READY_FOR_RETURN | 3 / 3 / 0 |
| 14 | REPAIRED_ORIGINAL final device lifecycle mismatch | 3 / 3 / 0 |
| 15 | Completed non-student allocation repaired-original device not AVAILABLE | 0 / 0 / 0 |
| 16 | Pending replacement staged serial already in devices | 0 / 0 / 0 |
| 17 | Pending replacement original prematurely marked REPLACED | 0 / 0 / 0 |
| 18 | Duplicate normalized staged serial | 0 / 0 / 0 |
| 19 | Staged serial matching a device serial | 0 / 0 / 0 |
| 20 | Phase 5 allocation mutation attribution | N/A / combined evidence / 0 observed |
| 21 | Ticket work-owner mutation attribution | N/A / combined evidence / 0 observed |
| 22 | Current MFR status differs from latest history | 0 / 0 / 0 |
| 23 | Dangling shipment reference | 0 / 0 / 0 |
| 24 | Dangling outcome reference | 0 / 0 / 0 |
| 25 | Active Phase 7F handoff after REPLACEMENT_SUPPLIED | 0 / 0 / 0 |
| 26 | Active Phase 7F handoff after WARRANTY_REJECTED | 0 / 0 / 0 |
| 27 | Active Phase 7F handoff after BER | 0 / 0 / 0 |
| 28 | Active Phase 7F handoff for incomplete MFR cycle | 0 / 0 / 0 |
| 29 | Duplicate logical Ticket Activity caused by rejected retries | 9 groups / 9 valid review-stage mappings / 0 retry duplicates |
| 30 | Temporary Phase 8B triggers | 0 / 0 / 0 |

Checks 12–14 each found the three intentionally active repaired-original
cycles MFR15, MFR19, and MFR21. They have not reached final receipt, so their
current ticket/logistics/device states are valid later progression, not
closed-route defects. Check 29's nine repeated `EXCEPTION_REVIEW_STARTED`
projection groups come from distinct source transitions into District or
Head Office review states, all mapped by the view to that same activity code;
they are not rejected-retry writes. The fresh MFR13 chain contains no
duplicate manufacturer event.

Checks 20–21 are covered by combined evidence: the six new pool devices retain
active district allocation IDs 49–54 and school allocation IDs 41–46 created
before their manufacturer-return starts; the pool tickets have no assignment
rows; manufacturer-return audit rows show only manufacturer-return actions;
and static inspection of `app/api/manufacturer-returns` and
`app/api/exceptions` found no writes/references to Phase 5 allocation or
`ticket_assignments` tables. No Phase 5/work-owner mutation attributable to
Phase 8B was observed. Handoff 91 remains a corrected historical defect; the
two active repaired-original handoffs 90 and 92 remain valid later
progressions.

### Static Checks, Changes, and Final State

`jq empty` passed for all six timestamp-modified Server Connect JSON files
and the changed manufacturer-return detail endpoint. No runtime raw SQL,
custom Express, custom Node business logic, or temporary/permanent triggers
were introduced. SQL was read-only in this V3 pass.

Files changed in this V3 pass:

- `app/api/manufacturer-returns/detail.json` — TTPost detail requires a
  TTPost-participating case.
- `views/exceptions-detail.ejs` — current manufacturer-return custody takes
  precedence over stale Phase 7 custody in the displayed operational state.
- `docs/testing/phase-08b-manufacturer-return-test-report.md` — this V3
  acceptance record.

All five GUI accounts authenticated and remain active: `p7d.repair.test`
(REPAIR_CENTRE, service location 8), `p7b.ttpost.test` (TTPOST_LOGISTICS),
`p8b.district.1` (ICT_DISTRICT_COORDINATOR, District 4), `p8b.ho.1`
(MOE_HEAD_OFFICE, national), and `p8b.oversight` (TSTT_OVERSIGHT, national
read-only). `P8B-EXT-COURIER` (id 2) remains ACTIVE and retained for GUI
acceptance. Temporary Phase 8B triggers: 0. No account or carrier cleanup was
performed.

**V3 test ledger: COMPLETE. Phase 8B command acceptance: COMPLETE. GUI
acceptance: NOT PERFORMED — USER WILL TEST. Phase 8B is READY FOR GUI
ACCEPTANCE. Phase 8C and Phase 8D were not started.**

## GUI DEFECT REGRESSION

Date: 2026-10-13

Scope: Phase 8B GUI defect fix and final GUI regression only. Phase 8C and
Phase 8D were not started.

### Oversight Mutation Button Visibility

Result: PASS

`p8b.oversight` authenticated successfully and retained read access to MFR7,
MFR8, and MFR11. Browser-level visible-button checks confirmed the following
operational mutation controls were absent for the oversight role:

- Prepare Outbound Shipment
- Confirm TTPost Manufacturer Pickup
- Record External Courier Pickup
- Record Manufacturer Acknowledgement
- Record Manufacturer Outcome
- Prepare Return Shipment
- Confirm TTPost Return Pickup
- Record External Return Pickup
- Confirm Manufacturer Return Receipt

Carrier management controls were also absent for `p8b.oversight` on the carrier
administration page:

- Add Carrier
- Edit
- Activate
- Deactivate

Implementation note: manufacturer-return detail buttons now use permission-aware
auth context flags derived from the same permission model used by backend
Server Connect actions. No role-name exclusion such as `role != TSTT_OVERSIGHT`
was added.

### Backend Authorization Denial

Result: PASS

Using the `p8b.oversight` session, a representative write call to
`/api/manufacturer-returns/outcome/create` returned HTTP 403 with
`{"success":false,"error":"Forbidden."}`. This confirms frontend hiding remains
UX only and backend authorization remains authoritative.

### Static Validation

Result: PASS

Changed JSON and EJS files were validated:

- `app/api/auth/context.json`
- `app/api/manufacturer-returns/list.json`
- `app/api/manufacturer-returns/filter-options.json`
- `app/api/manufacturer-returns/detail.json`
- `views/manufacturer-returns-detail.ejs`
- `views/admin/carriers.ejs`
- `views/manufacturer-returns.ejs`
- `views/exceptions-detail.ejs`

No custom Express route, custom Node business logic, runtime raw SQL, permanent
trigger, or Wappler runtime-file modification was introduced.

### Mixed Carrier GUI Fixture

Result: PASS - existing intact fixture found; no new fixture was created.

- Ticket: TKT00000062
- Manufacturer return: MFR15
- Status: RETURN_IN_TRANSIT / Return In Transit
- Physical custody: EXTERNAL_COURIER_RETURN_CUSTODY
- Outbound carrier: TTPost
- Return carrier: P8B Temporary External Courier
- Return carrier code evidence: P8B-EXT-COURIER

The fixture proves outbound and return carrier independence in a user-inspectable
GUI state: outbound is TTPost while return is the Phase 8B external courier.

### User Retest Instructions

Test 7 mixed carrier fixture:

1. Log in as `p8b.oversight` with password `test`.
2. Open Manufacturer Returns.
3. Open ticket `TKT00000062` / manufacturer return `MFR15`.
4. Expected outbound carrier: `TTPost`.
5. Expected return carrier: `P8B Temporary External Courier`
   (`P8B-EXT-COURIER`).
6. Expected manufacturer-return status: `Return In Transit`
   (`RETURN_IN_TRANSIT`).
7. Expected physical custody: `EXTERNAL_COURIER_RETURN_CUSTODY`.

Test 12 oversight regression:

1. Log in as `p8b.oversight` with password `test`.
2. Open Manufacturer Returns.
3. Open MFR7, MFR8, and MFR11.
4. Expected: read access works.
5. Expected: `Record Manufacturer Outcome` is absent.
6. Expected: `Prepare Outbound Shipment`,
   `Record Manufacturer Acknowledgement`, `Prepare Return Shipment`,
   `Confirm Manufacturer Return Receipt`, and carrier-management actions are
   absent.

Phase 8B GUI acceptance remains OPEN pending user retest of Tests 7 and 12.

## PHASE 8B FINAL CLEANUP

Date: 2026-10-13

Result: PASS

Phase 8B is formally closed after GUI acceptance. Cleanup was limited to
Phase 8B-specific test identities and the temporary external carrier. Shared
Phase 7 regression users were retained.

Disabled users:

| User ID | Username | Old Status | New Status |
| ---: | --- | --- | --- |
| 33 | `p8b.district.1` | active | disabled |
| 31 | `p8b.ho.1` | active | disabled |
| 32 | `p8b.oversight` | active | disabled |

Retained shared users:

| User ID | Username | Status |
| ---: | --- | --- |
| 16 | `p7b.ttpost.test` | active |
| 18 | `p7d.repair.test` | active |

Disabled-user login verification:

| Username | Login Result |
| --- | --- |
| `p8b.district.1` | HTTP 401 |
| `p8b.ho.1` | HTTP 401 |
| `p8b.oversight` | HTTP 401 |

Temporary carrier:

| Carrier ID | Carrier Code | Carrier Name | Old Status | New Status |
| ---: | --- | --- | --- | --- |
| 2 | `P8B-EXT-COURIER` | P8B Temporary External Courier | active | inactive |

Historical carrier reference verification:

| MFR | Direction | Carrier Code | Carrier Name | Carrier Status |
| --- | --- | --- | --- | --- |
| MFR15 | OUTBOUND | `TTPOST` | TTPost | active |
| MFR15 | RETURN | `P8B-EXT-COURIER` | P8B Temporary External Courier | inactive |

New carrier-selection options now include only active carriers for the tested
Phase 8B endpoint; `P8B-EXT-COURIER` is no longer returned.

Phase 8B temporary trigger count: 0.
