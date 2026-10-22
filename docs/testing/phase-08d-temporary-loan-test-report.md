# Phase 8D-A Command Test Report

Date: 2026-10-15. Runtime: `http://localhost:3000`. Testing was command-only (curl, MySQL, JSON parsing, EJS compilation). Codex did not open a browser, inspect a rendered page, take screenshots, or perform GUI automation. GUI acceptance is for the user.

## Command acceptance

| Check | Evidence |
| --- | --- |
| Valid Repair Centre request | `p7d.repair.test` requested TKT00000056: HTTP 200, TL1, `PENDING_DISTRICT_APPROVAL`; derived device 47, Caroni, school 1, service location 8, pool 1. A manufacturer-return path, TKT00000069, also returned 200 as TL2. |
| Duplicate request | TKT00000056 again: HTTP 409, one active loan. |
| Terminal ticket | Returned TKT00000031: HTTP 409. |
| Completed permanent replacement | TKT00000055: HTTP 409. |
| Repair Centre out of scope | Temporarily enabled `p7e.concurrent.test` scoped only to Repair Centre 9; request for RC8 ticket TKT00000053: HTTP 403. Temporary scope was removed and account restored to disabled. |
| TTPost | `p7b.ttpost.test` request and list: HTTP 403 each. |
| District approval | `phase5b.district.test` approved TL2: HTTP 200, `AUTHORIZED`, actor 4 and timestamp set. |
| Wrong District | Temporarily activated the existing Tobago scope for `phase3.district.test`; its decision on Caroni TL1 returned HTTP 403. The exact previous revoked scope was restored. |
| District rejection | TL3 / TKT00000052: HTTP 200, `REJECTED`, closed timestamp set, active key NULL. |
| Duplicate decision | Approval after TL3 rejection: HTTP 409. |
| Request race | Two concurrent requests for TKT00000065: one HTTP 200 (TL4), one 409; one active case. |
| Same-decision race | Two concurrent approvals for TL4: one HTTP 200, one 409; exactly one decision. |
| Conflicting race | Concurrent approve/reject on TL6: reject HTTP 200, approve 409; exactly one final decision. |
| Forced rollback | Temporary `BEFORE INSERT` decision trigger caused TL7 approval to return sanitized HTTP 500. Case remained pending, all decision fields NULL, zero decisions, zero decision activity; trigger removed. Retry returned HTTP 200. Exactly one decision, authorized history, audit, and activity remained after retry. |
| Oversight | Temporarily enabled `p8b.oversight`: scoped detail HTTP 200, decision HTTP 403. Account restored to disabled. |
| Activity | TKT00000056 activity API returned one `TEMPORARY_LOAN_REQUESTED` with TL1 and readable timestamp. No notes or student data. |
| Outer-state preservation | Before/after snapshots of TKT00000068 request and authorization matched exactly: ticket status 5, original lifecycle 5, logistics status 4, repair completion, exception 24, manufacturer return 14, no permanent replacement, Phase 5 allocations 52/44, stock none, work owner none, custody `REPAIR_CENTRE_CUSTODY`. Observed mutation count: 0 in each outer domain. |
| Static / migration | Changed JSON parsed; changed EJS compiled; foundation migration reran successfully. |

## Database integrity

All counts below were **0** after command acceptance: duplicate active loans; active loan with terminal ticket; active loan after completed replacement; pending case with decision fields; authorized without actor; authorized without timestamp; rejected without actor; rejected without timestamp; rejected with active key; cancelled with active key; pool/loan location mismatch; pool at invalid Repair Centre; duplicate active default pool; latest-history/status mismatch; duplicate logical temporary-loan activity; temporary test triggers; selected/issued spare devices. The RC8 default pool references an active `REPAIR_CENTRE` location. Request/authorization outer-state snapshot differences: Phase 5, lifecycle, stock, ticket/logistics, work owner, and physical custody all **0**.

## GUI fixtures for user testing

All fixtures are in **Caroni**, school **PHASE3 TEST SCHOOL A UPDATED**, Repair Centre **P7D Repair Centre Test Facility**, pool **P7D Repair Centre Default Spare Pool** (`RC8-DEFAULT`). Password for each listed account: `test`.

| Fixture | Ticket | Loan | Original device | Status |
| --- | --- | --- | --- | --- |
| A: eligible, no loan | TKT00000053 (ID 53) | none | P8A-HCON-20261013 (device 44) | request eligible |
| B: pending | TKT00000056 (ID 56) | TL1 (ID 1) | P8A-FIN-20261013 (device 47) | `PENDING_DISTRICT_APPROVAL` |
| C: authorized | TKT00000069 (ID 69) | TL2 (ID 2) | P8B-V3-POOL-G-20261013 (device 52) | `AUTHORIZED` |
| D: rejected | TKT00000052 (ID 52) | TL3 (ID 3) | P8A-DRACE-20261013 (device 43) | `REJECTED` |

### Exact GUI instructions

1. **GUI A, Repair Centre request:** Log in as `p7d.repair.test` / `test` (REPAIR_CENTRE, service location 8). Open **Tickets** > **TKT00000053**. Expect **Request Temporary Spare**; its modal asks only for an optional note and explains no spare is issued. Leave this fixture unsubmitted if you want to preserve the no-loan case.
2. **GUI B, pending District decision:** Log in as `phase5b.district.test` / `test` (ICT_DISTRICT_COORDINATOR, Caroni district 4). Open **Temporary Loans** > **TL1** (TKT00000056). Expect Pending District Approval, original P8A-FIN-20261013, RC8 pool, **Approve Temporary Spare** and **Reject Temporary Spare** buttons. Do not submit a decision if this fixture should remain pending.
3. **GUI C, authorized read:** Log in as `p7d.repair.test` / `test`, open **Temporary Loans** > **TL2** (TKT00000069). Expect Authorized and **Spare Device: Not Selected**; no issue, reserve, or conversion action. No District decision buttons for Repair Centre.
4. **GUI D, rejected read:** Log in as `phase5b.district.test` / `test`, open **Temporary Loans** > **TL3** (TKT00000052). Expect Rejected, a District decision and history with readable dates, no approve/reject buttons. Its active key is closed.
5. **Read-only role:** The `p8b.oversight` fixture was restored to its prior disabled state after command testing, so it is **not** a login instruction. A new approved active Oversight test account is needed for personal GUI read-only verification. Backend denial was confirmed by command test.

Phase 8D-A command acceptance is complete. GUI acceptance remains open pending the user's personal tests.

## PHASE 8D-B — SPARE POOL SELECTION + RESERVATION + ISSUE

Date: 2026-10-15. Runtime: `http://localhost:3000`. Testing remained command-only (curl, MySQL, JSON parsing, EJS compilation). No browser, rendering, screenshot, visual inspection, or GUI automation was used.

### Implementation and command results

| Check | Result |
| --- | --- |
| Migration / views | Repeatable migration installed successfully on MySQL 5.7.39; candidate, queue, and activity views queried successfully. |
| Spare options | PASS. Authorized TL2 returned only RC8 central `AVAILABLE` / `IN_STOCK` devices. Original device 52 was absent. Options include device, serial/asset tag, manufacturer/model, lifecycle, stock location, and Repair Centre; no student/private fields. |
| Normal stock staging | Devices 54, 56, and 57 were added to RC8 through the existing Repair Centre stock-intake API. Device 59 (`P8CB2-OTHER-STOCK-20261013`) was released from RC9 and re-intaken to RC8 through existing Super Admin stock APIs to leave an eligible available device for GUI A. No inventory rows were fabricated. |
| Valid selection | PASS. TL7 selected device 54: HTTP 200, `SPARE_SELECTED`; reservation active, lifecycle `AVAILABLE`, stock active `IN_STOCK`. |
| Duplicate selection | PASS. Repeat selection after TL7 was selected: HTTP 409. |
| Same-case select race | PASS. Concurrent TL7/device54 requests: one HTTP 200, one HTTP 409. One selected case and one active reservation. |
| Same-spare/two-loan race | PASS. TL2 and TL4 concurrently selected device 57: TL4 HTTP 200, TL2 HTTP 409. Exactly one active reservation for device 57. TL2 then selected device 56 successfully. |
| Wrong-centre / no-stock / invalid candidate | PASS for rejection. Before device59 was relocated for GUI A, it was absent from RC8 options while stocked at RC9. Direct selection of device1 (no stock, `RECEIVED` lifecycle), device63 (district allocation), and other ineligible records returned HTTP 409. |
| Workflow conflicts | PASS for fail-closed rejection. Direct selection returned HTTP 409 for device54 (active temporary-loan reservation), device60 (replacement reservation), device47 (active logistics/repair workflow), device52 (manufacturer-return workflow), device53 (`REPLACED`), and device56 (`TEMPORARY_LOAN`). Student-assignment and active replacement-consumption exclusions are enforced by the candidate view. |
| Valid issue | PASS. TL4/device57 and TL2/device56 each issued with HTTP 200; both loans became `ACTIVE_LOAN`, spares became `TEMPORARY_LOAN`, active stock rows were released, reservations consumed, issue actor/time populated, and exactly one custody row recorded per loan. |
| Duplicate issue | PASS. Repeat issue for an already active loan returned HTTP 409; no duplicate transition, custody, history, or activity was created. |
| Lost reservation | PASS. Controlled temporary invalidation of TL7's reservation returned HTTP 409; reservation was restored exactly and TL7 remains `SPARE_SELECTED`. |
| Missing stock | PASS. Controlled temporary removal of TL7's active stock row returned HTTP 409; active row was restored exactly. |
| Changed lifecycle | PASS. Controlled change from `AVAILABLE` to `IN_REPAIR` returned HTTP 409; lifecycle was restored exactly. |
| Permission denial | PASS. `phase5b.district.test` received HTTP 403 for both select and issue. Only `REPAIR_CENTRE` and `SUPER_ADMIN` received the new mutation grants; other roles remain without these permissions. |
| Issue concurrency from genuine selected state | PASS. Created disposable device70 (`P8DB-ISSUE-RACE-20261015`) through the device-create API, transitioned it to `AVAILABLE`, and intaked it to RC8 through normal APIs. Opened TL9 for TKT00000010 through request/approval APIs and selected device70 through the spare-selection API. Pre-race: TL9 `SPARE_SELECTED`; spare `AVAILABLE`; RC8 stock `IN_STOCK`; reservation `RESERVED`, active; repair-centre scope correct. Two simultaneous issue requests returned one HTTP 200 and one HTTP 409. TL9 is now `ACTIVE_LOAN`; the spare is `TEMPORARY_LOAN`; active stock and reservation counts are 0; issue time/actor are populated. Exactly one stock row was released, one custody issue event, one status transition, one activity event, and one audit event exist. No SQL state fabrication or GUI-fixture consumption. |
| Selection rollback | PASS. Temporary `BEFORE INSERT` reservation failure returned sanitized HTTP 500. TL7 remained `AUTHORIZED`, with no selected spare, reservation, or selection history. Trigger was removed and the retry race succeeded. |
| Issue rollback | PASS. Temporary `BEFORE INSERT` custody failure, after stock/lifecycle/case writes inside the transaction, returned sanitized HTTP 500. TL4 stayed `SPARE_SELECTED`; spare remained `AVAILABLE`, stock `IN_STOCK`, reservation active; no custody was recorded. Trigger was removed; issue then succeeded. |
| Read APIs | PASS. Detail for TL7 exposed selection, active reservation, unchanged lifecycle/stock and readable history date. Ticket activity exposed `TEMPORARY_SPARE_SELECTED`; issue activities are present once each for TL2/TL4. |
| Outer-state preservation | PASS. All issue writes are limited to temporary-loan reservation/case/status, the selected spare's stock/lifecycle, custody, audit and read-model-derived activity. Ticket status, logistics status, repair completion, manufacturer-return status, exception, permanent replacement, and original lifecycle/allocation are unchanged for the tested loan records. |
| Static validation | PASS. All changed/new JSON parsed; changed EJS templates compiled in async mode. Migration reran without error. No custom Express route, custom Node business logic, runtime raw SQL, or permanent test trigger was added. |

### Database consistency

After the concurrent issue test, all measured Phase 8D-B anomaly counts were **0**: selected without spare; selected without active reservation; selected with wrong lifecycle; selected without active stock; active loan without spare; active loan with wrong lifecycle; active loan with active free stock; active loan with active reservation; active loan without issue timestamp/actor/custody; duplicate active spare; spare equal to original; permanent-replacement selection/reservation conflicts; Repair Centre/stock-location mismatch; latest status/history mismatch; duplicate issue history; and duplicate issue activity. The spare has exactly one released stock row. Total database triggers: **0**. TL9 has exactly one `SPARE_SELECTED -> ACTIVE_LOAN` history transition, one `TEMPORARY_LOAN_ISSUED` activity, one issue custody event, and one issue audit record. TL8 remains `AUTHORIZED`; TL7 remains `SPARE_SELECTED` with device54 available, stocked, and actively reserved; TL4 and TL2 remain `ACTIVE_LOAN` with their original spares. Ticket 10 remains `UNDER_REPAIR`, original device24 remains `IN_REPAIR`, logistics remains `AT_REPAIR_CENTRE`, and the repair-completion timestamp is unchanged. Phase 5 district/school allocation and active assignment rows for original device24 are unchanged; disposable spare70 has no Phase 5 allocation or assignment.

### Prepared GUI fixtures

All listed fixtures are at **P7D Repair Centre Test Facility** (service location 8), pool **RC8-DEFAULT / P7D Repair Centre Default Spare Pool**. Password: `test`.

| GUI | Loan / Ticket | Original device | Selected spare | Status and expected state |
| --- | --- | --- | --- | --- |
| A | TL8 / TKT00000068 | P8B-V3-POOL-F-20261013 (device 51) | Not selected; option P8CB2-OTHER-STOCK-20261013 (device 59) is eligible | `AUTHORIZED`; device59 `AVAILABLE`, active stock `IN_STOCK`, not reserved. |
| B | TL7 / TKT00000067 | P8B-V3-POOL-D-20261013 (device 50) | P8CB2-STOCK-A-20261013 (device 54), asset tag `P8CB2-STOCK-A-TAG` | `SPARE_SELECTED`; spare `AVAILABLE`, stock `IN_STOCK`, reservation `RESERVED` and active. |
| C | TL4 / TKT00000065 | P8B-V3-POOL-B-20261013 (device 48) | P8CB2-STOCK-CX-20261013 (device 57) | `ACTIVE_LOAN`; spare `TEMPORARY_LOAN`, stock `RELEASED`, reservation `CONSUMED`, issue actor/time present. |
| D | TL2 / TKT00000069 | P8B-V3-POOL-G-20261013 (device 52) | P8CB2-STOCK-R-20261013 (device 56) | `ACTIVE_LOAN`; spare `TEMPORARY_LOAN`, stock `RELEASED`, reservation `CONSUMED`; detail/history and ticket activity include custody/issue. |

### Exact user GUI instructions

1. Log in as `p7d.repair.test` / `test`. Open **Temporary Loans** > **TL8** (TKT00000068). Confirm Authorized, no spare selected, and P8CB2-OTHER-STOCK-20261013 appears as an eligible option. Do not select it.
2. As `p7d.repair.test` / `test`, open **Temporary Loans** > **TL7** (TKT00000067). Confirm P8CB2-STOCK-A-20261013, lifecycle Available, stock In Stock, active reservation, and **Issue Temporary Spare**. Do not issue it.
3. As `p7d.repair.test` / `test`, open **Temporary Loans** > **TL4** (TKT00000065). Confirm Active Loan, P8CB2-STOCK-CX-20261013, lifecycle Temporary Loan, stock not in free stock, consumed reservation, readable issued time, and temporary-loan custody history.
4. As `p7d.repair.test` / `test`, open **Temporary Loans** > **TL2** (TKT00000069), then **Tickets** > **TKT00000069**. Confirm Active Loan and the detail/history/custody fields; ticket activity should show **Temporary Spare Selected** and **Temporary Loan Issued** once each.

`CODEX GUI TESTING: NOT PERFORMED — USER RESPONSIBILITY.` Phase 8D-B command acceptance, including the genuine `SPARE_SELECTED` issue concurrency race, is complete. GUI acceptance remains open pending the user's personal tests. Phase 8D-C is documented below; Phase 8D-D and 8D-E are not started.

## PHASE 8D-C — TEMPORARY LOAN RETURN / RECLAIM

Date: 2026-10-15. Runtime: `http://localhost:3000`. Acceptance was command-only: curl/API calls, MySQL checks, JSON parsing, and EJS compilation. Codex did not open a browser, inspect rendered pages, take screenshots, or perform GUI automation.

### Implementation and command results

| Check | Result |
| --- | --- |
| Migration and read models | PASS. `database/phase_08d_c_temporary_loan_return_reclaim.sql` applied and rerun successfully on MySQL 5.7.39. It adds controlled return reasons/conditions, return metadata, status constraints, two action permissions, and queue/activity view fields. Existing trigger count remains 0. |
| Request return | PASS. Repair Centre API moves only an eligible `ACTIVE_LOAN` to `RETURN_REQUIRED`, persists reason/request actor/time and optional notes, and appends custody, status history, and audit. It explicitly leaves the device `TEMPORARY_LOAN` and out of free stock. Duplicate request on TL11 returned HTTP 409. |
| Reclaim | PASS. Only a serviceable physically received spare can be reclaimed. The transaction conditionally moves lifecycle to `AVAILABLE`, creates one active `IN_STOCK` row at the loan's Repair Centre, closes the case as `RETURNED`, and appends custody, status history, and audit. Duplicate reclaim on TL16 returned HTTP 409. |
| Other return reason validation | PASS after correcting a discovered defect. Whitespace-only notes for `OTHER` initially passed validation on disposable TL10; validation now trims and requires nonblank notes. Retest on TL15 returned HTTP 400 and left its `ACTIVE_LOAN` state unchanged. TL10's disposable test note was corrected via one-time controlled data correction; its lifecycle/status were preserved. |
| Request/reclaim conflicts | PASS. Invalid pre-issue/terminal states and non-serviceable return condition fail closed. Active conversion conflicts, changed spare lifecycle, existing stock, wrong Repair Centre scope, and client-supplied device/location tampering were exercised. Conflict requests returned HTTP 403/409 as applicable; reclaim derives the device and service location from the loan, not client input. |
| Return-request concurrency | PASS. Two simultaneous requests against TL11 from `ACTIVE_LOAN`: one HTTP 200 and one HTTP 409; exactly one transition and one return-request event were committed. TL11 is preserved as the GUI `RETURN_REQUIRED` fixture. |
| Reclaim concurrency | PASS. Two simultaneous requests against TL12 from genuine `RETURN_REQUIRED`: one HTTP 200 and one HTTP 409; exactly one stock row, custody event, status transition, and return activity were committed. |
| Transaction rollback | PASS. Temporary failure triggers injected failure during request and reclaim transactions. Each API returned sanitized HTTP 500; all earlier writes in each transaction rolled back. Triggers were dropped immediately and verified absent. Each case then succeeded on retry. |
| Permission and scope | PASS. `REPAIR_CENTRE` in matching RC8 scope can use the actions. District, Head Office, Oversight, TTPost, School, and Technical test roles received HTTP 403. A Repair Centre user scoped only to RC9 received HTTP 403 for an RC8 loan. Temporary test-account activation/scope changes were restored. |
| Read APIs and activity | PASS. Detail/list/ticket summary expose readable return dates, reason/condition, stock and custody state. Ticket activity includes `TEMPORARY_LOAN_RETURN_REQUIRED` and `TEMPORARY_LOAN_RETURNED`; private return notes are not included in ticket activity. |
| Outer-state preservation | PASS. Tested loan records' read-model snapshots show ticket status, logistics status, repair-completion timestamp, manufacturer-return state, and original device identity unchanged by return/reclaim. Selected spare devices have no Phase 5 allocation/assignment rows. |
| Static validation | PASS. All changed Wappler JSON parsed and changed EJS templates compiled in async mode. No custom Express route, custom Node business logic, runtime raw SQL, or permanent trigger was introduced. The SQL is a controlled repeatable migration only. |

### Final database consistency

Final anomaly counts were all **0**: return-required missing spare; return-required wrong lifecycle; return-required active free-stock row; missing return-request metadata; returned missing spare; returned wrong lifecycle; returned missing active stock; returned stock at a different location; returned missing actor/date/serviceable condition or open active key; returned custody not at Repair Centre stock; `OTHER` with blank notes; duplicate active spare; duplicate return-required or returned history; duplicate return-request or reclaim custody; and duplicate return activity. Total database triggers: **0**.

The exact concurrency and duplicate-action outcomes were one HTTP 200 / one HTTP 409 for each race, HTTP 409 for repeated return/reclaim, and no duplicate history, custody, stock, or activity writes. Existing Phase 8D-B GUI fixtures remained unchanged: TL8 `AUTHORIZED` with no spare; TL7 `SPARE_SELECTED` with device54; TL4 `ACTIVE_LOAN` with device57; TL2 `ACTIVE_LOAN` with device56. No GUI fixture was consumed.

### Prepared GUI fixtures

All cases below are under Repair Centre **P7D Repair Centre Test Facility** (service location 8), pool **RC8-DEFAULT / P7D Repair Centre Default Spare Pool**, and scope can be checked using `p7d.repair.test` (password `test`). They were prepared through existing APIs. Ticket and repair/logistics states remain as recorded; do not submit the modal actions during inspection if you want to preserve the fixtures.

| GUI | Loan / Ticket | Original device | Selected spare | Expected state |
| --- | --- | --- | --- | --- |
| A: request return | TL15 (ID 15) / TKT00000053 (ID 53) | P8A-HCON-20261013 (device 44) | P8DC-SPARE-F-20261015 (device 76; asset tag `P8DC-SPARE-F-20261015-TAG`) | `ACTIVE_LOAN`; spare lifecycle `TEMPORARY_LOAN`; no free-stock row; custody `TEMPORARY_LOAN_ISSUED`; no return metadata. |
| B: return required | TL11 (ID 11) / TKT00000047 (ID 47) | P8A-U2M-20261013 (device 38) | P8DC-SPARE-B-20261015 (device 72; asset tag `P8DC-SPARE-B-20261015-TAG`) | `RETURN_REQUIRED`; reason Original device returned; requested Oct 15, 2026 at 11:09 AM; spare remains `TEMPORARY_LOAN`, not in free stock; custody `TEMPORARY_LOAN_RETURN_REQUIRED`. |
| C: returned | TL16 (ID 16) / TKT00000060 (ID 60) | P7F-ROLLBACK-20261012 (device 29) | P8DC-SPARE-G-20261015 (device 77; asset tag `P8DC-SPARE-G-20261015-TAG`) | `RETURNED`; reason Other; condition Serviceable; requested/returned Oct 15, 2026 at 11:15 AM; spare `AVAILABLE` / `IN_STOCK` at RC8; custody `REPAIR_CENTRE_STOCK`. |
| D: returned history/activity | TL14 (ID 14) / TKT00000052 (ID 52) | P8A-DRACE-20261013 (device 43) | P8DC-SPARE-E-20261015 (device 75; asset tag `P8DC-SPARE-E-20261015-TAG`) | `RETURNED`; reason Loan no longer required; condition Serviceable; requested/returned Oct 15, 2026 at 11:11 AM; spare `AVAILABLE` / `IN_STOCK` at RC8; custody `REPAIR_CENTRE_STOCK`. Ticket activity includes the request and reclaim events. |

### Exact user GUI instructions

1. Log in as `p7d.repair.test` / `test`. Open **Temporary Loans** > **TL15** (TKT00000053). Confirm Active Loan and spare P8DC-SPARE-F-20261015. Open **Request Spare Return** to inspect the reason/notes fields, then cancel without submitting.
2. As `p7d.repair.test` / `test`, open **Temporary Loans** > **TL11** (TKT00000047). Confirm Return Required, readable request date/reason, spare still Temporary Loan and not in stock, and return-request custody. Open **Record Spare Reclaimed** to inspect, then cancel without submitting.
3. Open **Temporary Loans** > **TL16** (TKT00000060). Confirm Returned, readable requested/returned dates, Other reason, Serviceable condition, Available/In Stock at RC8, and Repair Centre Stock custody. This is a read-only inspection fixture.
4. Open **Temporary Loans** > **TL14** (TKT00000052), then open **Tickets** > **TKT00000052**. Confirm return/reclaim activity appears once each and inspect the custody/stock history. The ticket status remains Under Repair; the temporary-loan return does not close or replace the ticket.

`CODEX GUI TESTING: NOT PERFORMED — USER RESPONSIBILITY.` Phase 8D-C command acceptance is complete; GUI acceptance remains open pending the user's personal tests.

## PHASE 8D-D — HEAD OFFICE CONVERSION TO PERMANENT REPLACEMENT

Date: 2026-10-15. Runtime tested at `http://localhost:3000`. Testing was
command-only: curl/API, MySQL, static JSON parsing, and asynchronous EJS
compilation. No browser, rendered-page inspection, screenshot, visual check,
or GUI automation was performed.

### Implementation and command acceptance

| Check | Result |
| --- | --- |
| Wappler foundation | PASS. Repeatable migration `phase_08d_d_temporary_loan_permanent_conversion.sql` applied and rerun. It adds conversion status/reason/request/decision structures, request-time Phase 5 snapshots, the temporary-loan link and `TEMPORARY_LOAN_CONVERSION` source to the existing Phase 8C permanent-replacement model, and the corresponding queue/activity read fields. No parallel replacement relationship system was created. |
| Valid request / duplicate / invalid status | PASS. Normal request from an issued `ACTIVE_LOAN` returned HTTP 200 and `CONVERSION_PENDING_HEAD_OFFICE`; a simultaneous duplicate returned HTTP 409. Duplicate requests and invalid loan statuses returned 409. Requesting conversion did not change Phase 5, lifecycle, stock, or outer workflow state. |
| Already replaced / replacement conflict | PASS. An original already superseded by a completed replacement was rejected with HTTP 409. A competing active permanent-replacement case was also rejected with HTTP 409. |
| Scope and permissions | PASS. Matching scoped Repair Centre request is allowed. A Repair Centre request outside its service-location scope returned 403. Repair Centre approval of pending TL21 returned HTTP 403; `p8b.ho.1` has the `MOE_HEAD_OFFICE` role and `temporary_loans.approve_conversion`. District, TTPost, School, Technical Officer, and Oversight decision attempts were denied (403). |
| Head Office rejection / duplicate decision | PASS. Head Office rejection returned HTTP 200 and moved the loan back to `ACTIVE_LOAN`; spare remained `TEMPORARY_LOAN`, with no stock, replacement case, relationship, or Phase 5 transfer. Repeating a decision returned HTTP 409. |
| Student and school-level approvals | PASS. Student-level conversion TL20/TLC3 completed as PR13, with student assignment moved to the spare. School-level conversion TL18/TLC1 completed as PR12, with the school allocation transferred. Original lifecycle is `REPLACED`; replacement lifecycle follows the transferred allocation. |
| Stale spare / stock / original allocation | PASS. Approval returned 409 for altered spare lifecycle, unexpected active free-stock row, or stale request-time Phase 5 allocation snapshot. Test-only changes were restored immediately. |
| Return/reclaim guards | PASS. Pending and converted loans cannot enter incompatible normal return/reclaim actions (409). Existing 8D-C return and serviceable reclaim still returned HTTP 200 on the disposable TL19 path; the loan reached `RETURNED` and the spare returned to `AVAILABLE` / `IN_STOCK`. |
| Request concurrency | PASS. Two simultaneous requests on genuine active TL24: one HTTP 200, one HTTP 409; exactly one request was created by the race. |
| Approval concurrency | PASS. Two simultaneous Head Office approvals on a pending loan: one HTTP 200, one HTTP 409; one conversion committed. |
| Approve/reject concurrency | PASS. Separate pending loan, simultaneous APPROVE/REJECT: one HTTP 200, one HTTP 409; final state matched the winning decision without mixed writes. |
| Request rollback | PASS. Injected write failure returned sanitized HTTP 500; the loan remained active with no pending request or success activity. Retry succeeded. |
| Approval rollback | PASS. Injected failure after early conversion writes returned sanitized HTTP 500. Request remained pending; original/spare lifecycle, Phase 5, permanent-replacement case/relationship, custody, stock, and outer workflow state rolled back. Retry succeeded on the disposable conversion fixture. |
| Device/stock/Phase 5/custody | PASS. Conversion links the existing spare ID; it does not insert a device. Converted spare has no active free-stock row. Historical allocation rows remain; new allocation-transfer rows point to the existing spare. Custody history records `TEMPORARY_LOAN_ISSUED → CONVERTED_TO_PERMANENT`. |
| Ticket/logistics/repair/manufacturer state | PASS. Conversion leaves ticket, logistics, repair, manufacturer-return, and work-owner state unchanged. Verified examples include TKT00000049 (`UNDER_REPAIR` / `AT_REPAIR_CENTRE`, manufacturer return `COMPLETED`) and TKT00000062 (`UNDER_REPAIR` / `AT_REPAIR_CENTRE`, manufacturer return `RETURN_IN_TRANSIT`). |
| Permanent-replacement detail read | PASS after a read-model correction. Conversion cases now use `v_temporary_loan_queue` custody and return `return_identity` / `return_custody` as null; they no longer report the spare as physically at the Repair Centre. Phase 8C manufacturer-supplied PR11 and existing-inventory PR9 still return their original source types and data. |
| Static / migration / runtime architecture | PASS. Eight changed Server Connect JSON files parsed; four changed EJS templates compiled in async mode. Migration reran successfully. No custom Express, custom Node business logic, runtime raw SQL, or permanent triggers. |

### Database consistency

All requested current-state consistency counts were **0**: pending without a
pending request; pending with wrong spare lifecycle or active free stock;
converted without approved request, completed replacement case, or device
relationship; converted original not `REPLACED`; converted spare still
`TEMPORARY_LOAN` or in free stock; student replacement without active spare
assignment or with original still actively assigned; non-student Phase 5 / lifecycle mismatch; duplicate relationship or completed replacement per
loan; converted source mismatch; converted active key not null; rejected
decision missing its `CONVERSION_PENDING_HEAD_OFFICE → ACTIVE_LOAN` history;
rejected case with replacement/transfer; status/latest-history mismatch;
duplicate request/completion activity; dangling loan/replacement link; and
converted loan missing its linked replacement case. Temporary trigger count:
**0**. Device table count at final check: **74**; conversion records link the
already-issued spare IDs and the conversion action does not create a device.

One loan with a latest rejected conversion is no longer currently
`ACTIVE_LOAN`: TL19 is `RETURNED` after the separately authorized 8D-C
request-return/reclaim flow. Its rejection history contains the expected
`CONVERSION_PENDING_HEAD_OFFICE → ACTIVE_LOAN` transition; it has zero
permanent-replacement cases and zero Phase 5 transfers. This is expected later
workflow state, not a conversion-rejection mutation. All other latest rejected
conversion loans remain `ACTIVE_LOAN`.

### Bounded regressions

- **8D-B PASS:** preserved TL8 remains `AUTHORIZED` with no spare; TL7 remains
  `SPARE_SELECTED` with device54 `AVAILABLE` / one active stock row; TL4 and
  TL2 remain `ACTIVE_LOAN`, with devices57 and56 respectively `TEMPORARY_LOAN`
  and no active stock rows. No fixture was consumed.
- **8D-C PASS:** TL11 remains `RETURN_REQUIRED` with device72 still
  `TEMPORARY_LOAN` and out of stock; TL16 remains `RETURNED` with device77
  assigned/available per its existing returned allocation and no active stock
  row. Positive request-return/reclaim was exercised on the disposable TL19
  flow; pending/converted guards rejected incompatible paths.
- **8C PASS:** list/detail reads for PR11 (`MANUFACTURER_SUPPLIED`) and PR9
  (`EXISTING_INVENTORY`) succeeded unchanged. Their conversion-specific loan
  fields remain null.

### Prepared GUI fixtures

All records are in Caroni, school **PHASE3 TEST SCHOOL A UPDATED**, Repair
Centre **P7D Repair Centre Test Facility** (service location 8), pool
**RC8-DEFAULT**. Repair Centre login: `p7d.repair.test` / `test`.
Head Office login: `p8b.ho.1` / `test`, role `MOE_HEAD_OFFICE`, national
scope. This existing disabled test identity was reactivated for acceptance;
disable it after GUI acceptance. Do not submit actions if preserving the
fixture state is desired.

| GUI | Exact record and expected state |
| --- | --- |
| A: eligible request | TL24 (case ID24), TKT00000052, original device43 `P8A-DRACE-20261013`, spare device75 `P8DC-SPARE-E-20261015` (`P8DC-SPARE-E-20261015-TAG`); `ACTIVE_LOAN`, latest request TLC11 is `REJECTED`, spare `TEMPORARY_LOAN`, no free stock. It is eligible for a new request. |
| B: Head Office decision | TL21 (case ID21), TKT00000066, original device49 `P8B-V3-POOL-C-20261013`, spare device59 `P8CB2-OTHER-STOCK-20261013`; TLC10 (request ID10) `PENDING`; loan `CONVERSION_PENDING_HEAD_OFFICE`; spare `TEMPORARY_LOAN`, no free stock. Request snapshot is school-level, district4/school1, original allocation IDs 50/42. |
| C: rejected request | TL24/TKT00000052 (same record as GUI A because no separate disposable active spare remained without consuming protected GUI stock); latest request TLC11 is `REJECTED`; loan is back to `ACTIVE_LOAN`; spare remains `TEMPORARY_LOAN`. |
| D: student conversion | TL20 (case ID20), TKT00000062, original device31 `P7G-GOLDEN-20261012`, spare device77 `P8DC-SPARE-G-20261015` (`P8DC-SPARE-G-20261015-TAG`), TLC3 approved, PR13 completed; original `REPLACED`, spare `ASSIGNED`; Phase 5 allocation STUDENT, district4/school1/student13. |
| E: school conversion | TL18 (case ID18), TKT00000049, original device40 `P8A-DRR-20261013`, spare device74 `P8DC-SPARE-D-20261015` (`P8DC-SPARE-D-20261015-TAG`), TLC1 approved, PR12 completed; original `REPLACED`, spare `AVAILABLE`; Phase 5 allocation SCHOOL, district4/school1. |

For all five GUI entries, ticket is `UNDER_REPAIR`, logistics is
`AT_REPAIR_CENTRE`; these outer statuses are intentionally not reconciled in
8D-D. Manufacturer-return status remains the pre-conversion state (TL21:
`AWAITING_OUTBOUND_CARRIER_PICKUP`; TL18: `COMPLETED`; TL20:
`RETURN_IN_TRANSIT`; TL24: no manufacturer-return case). The spare stays
physically with the loan recipient; no Phase 7 return shipment or Repair
Centre stock intake exists for converted devices.

### Exact user GUI retest

1. At `http://localhost:3000`, log in as `p7d.repair.test` / `test`. Open
   **Temporary Loans** and TL24 (TKT00000052). Confirm Active Loan, the
   rejected TLC11 history, spare P8DC-SPARE-E-20261015, and the available
   request-conversion action. Inspect the request modal and cancel without
   submitting for GUI A/C preservation.
2. Log in as `p8b.ho.1` / `test`. Open **Temporary Loans** > TL21
   (TKT00000066). Confirm TLC10 is pending and inspect the request-time Phase 5
   context. Do not decide it unless intentionally consuming the pending GUI
   fixture.
3. Open **Permanent Replacements** > PR13 for GUI D and PR12 for GUI E.
   Confirm source `Temporary Loan Conversion`, linked loan/request, transferred
   Phase 5 allocation, original/spare lifecycle, `CONVERTED_TO_PERMANENT`
   custody, and no Repair Centre / Phase 7 return custody presented.
4. For all fixtures, verify the current ticket/logistics/repair states remain
   visible and unchanged; do not infer ticket closure from replacement
   completion. Oversight/District read-only GUI verification is not required by
   this phase's accepted identity; Head Office conversion authority is.

`CODEX GUI TESTING: NOT PERFORMED — USER RESPONSIBILITY.` Phase 8D-D command
acceptance is **PASS** and is ready for user GUI acceptance. Phase 8D-E is
**NOT STARTED**.

## PHASE 8D-E — FINAL INTEGRATION / READ MODEL / REGRESSION / CLOSURE

### Implemented and verified by command

- Added terminal logistics status `FULFILLED_AT_RECIPIENT`, distinct from
  `RETURNED_TO_SCHOOL`; completed conversion cases close ticket as `RETURNED`
  and logistics as `FULFILLED_AT_RECIPIENT` without changing historical
  handoffs or creating Phase 7F return events.
- Reconciled five exact completed `TEMPORARY_LOAN_CONVERSION` cases (TL18,
  TL20, TL21, TL22, TL24). Each has one ticket transition, one logistics
  transition, one fulfillment activity, and one correction audit. Re-running
  the migration did not add duplicate histories or audits.
- Effective-device and physical-custody reads resolve original and
  replacement separately; source is `TEMPORARY_LOAN_CONVERSION`, the
  replacement is the effective device, and physical state is
  `WITH_RECIPIENT`. Converted cases are absent from active logistics and
  school-receipt queues.
- The reconciliation also retired residual active student, school, and
  district allocation/assignment rows on converted original devices while
  preserving their historical rows. All five conversion replacements retain
  one allocation transfer each; student replacement is `ASSIGNED`, school
  replacements are `AVAILABLE`, and no converted replacement is in free
  stock.
- New conversion approvals now close ticket and logistics inside the existing
  conversion transaction and close any residual Phase 5 records on the
  replaced original. Four Phase 7F endpoints have converted-source guards.
- A controlled rollback test returned sanitized HTTP 500 after the approval
  had performed conversion/ticket/logistics writes. TL21 remained pending,
  with no PR/device relationship or approval decision. The test trigger was
  dropped; trigger count is zero. Retrying the same request concurrently
  returned one HTTP 200 and one HTTP 409.
- A new conversion request TLC14 on TL24 was approved concurrently after the
  integration change: one HTTP 200, one HTTP 409. It completed as PR20 with
  ticket `RETURNED` and logistics `FULFILLED_AT_RECIPIENT`. This is a fresh
  conversion request on an existing active-loan fixture, not a newly created
  loan case.
- The normal return action reclaimed TL11 through the existing API. It is now
  `RETURNED`; device72 `P8DC-SPARE-B-20261015` is `AVAILABLE`, `IN_STOCK` at
  Repair Centre location 8. Standard PR9 remains `EXISTING_INVENTORY` with
  normal `RETURNED_TO_SCHOOL` logistics.
- Both changed migrations were rerun. Core consistency counts are zero for
  missing PR/device relationship, original lifecycle mismatch, Phase 5 rows
  remaining on converted originals, wrong ticket/logistics state, effective
  device mismatch, active return handoff/queue, wrong custody, duplicate
  fulfillment transition, normal TL11 stock mismatch, standard 8C false
  fulfillment, and temporary triggers. Fulfillment activity count is five.
- Repair Centre return dispatch and TTPost return receipt/dispatch returned
  safe HTTP 409 responses without writes. School return receipt returned HTTP
  409 without writes for the already-fulfilled case when invoked by the
  administrative test account; the out-of-scope Tobago technical account
  correctly received HTTP 403 for the Caroni record. An authorized Caroni
  school identity was not available for a separate scope-positive invocation.
- District, TTPost, and School/Technical users received 403 for a temporary
  loan conversion mutation. Head Office could decide conversions but received
  403 for temporary-loan return mutation. All account checks were command-only.

### Prepared final GUI fixtures

Use `p7d.repair.test` / `test` (Repair Centre scope, location 8). Do not use
the temporary Head Office account; it has been disabled after command testing.

| GUI | Record and expected state |
| --- | --- |
| A, student conversion | TL20 / PR13 / TKT00000062 / LOG00000047; original `P7G-GOLDEN-20261012` is `REPLACED`; replacement `P8DC-SPARE-G-20261015` is `ASSIGNED` to Caroni / PHASE3 TEST SCHOOL A UPDATED / student 13; ticket `RETURNED`; logistics `FULFILLED_AT_RECIPIENT`; physical custody `WITH_RECIPIENT`; no stock. |
| B, school conversion | TL18 / PR12 / TKT00000049 / LOG00000037; original `P8A-DRR-20261013` is `REPLACED`; replacement `P8DC-SPARE-D-20261015` is `AVAILABLE` at the same school allocation; ticket `RETURNED`; logistics `FULFILLED_AT_RECIPIENT`; physical custody `WITH_RECIPIENT`; no stock. |
| C, ordinary temporary-loan return | TL11 / TKT00000047; device72 `P8DC-SPARE-B-20261015` is `AVAILABLE`, `IN_STOCK` at P7D Repair Centre Test Facility; loan `RETURNED`; ticket remains `UNDER_REPAIR`; logistics remains `AT_REPAIR_CENTRE`. |
| D, standard Phase 8C replacement | PR9 / TKT00000033 / LOG00000054; source `EXISTING_INVENTORY`; replacement `P8CB2-STOCK-B-20261013`; ticket `RETURNED`; logistics `RETURNED_TO_SCHOOL`; not `FULFILLED_AT_RECIPIENT`. |
| E, activity/effective-device/custody inspection | TL24 / PR20 / TKT00000052 / LOG00000040; original `P8A-DRACE-20261013` is `REPLACED`; current device `P8DC-SPARE-E-20261015` is `AVAILABLE` at Caroni / PHASE3 TEST SCHOOL A UPDATED; ticket `RETURNED`; logistics `FULFILLED_AT_RECIPIENT`; physical custody `WITH_RECIPIENT`; no stock. |

### Outstanding acceptance

No browser, screenshot, rendered-page inspection, or GUI automation was
performed. The School receipt `409` path was not exercised under an authorized
Caroni school scope, and the concurrency test used a newly created conversion
request on an existing loan rather than a newly created disposable loan case.
An additional disposable device was created through the normal device API, but
normal Repair Centre stock intake rejected it with HTTP 409 as ineligible; it
was not SQL-modified and remains unstocked. The project database subsequently
became unavailable on `127.0.0.1:3306`, preventing further database-backed
checks or cleanup. Therefore Phase 8D-E command acceptance remains **OPEN**
pending those remaining command checks and user GUI acceptance. Phase 8D-C and
8D-D remain closed as previously accepted.
