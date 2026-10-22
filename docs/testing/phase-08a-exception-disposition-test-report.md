# Phase 8A Exception and Disposition Acceptance Report

**Status: 8A PASS WITH LIMITATION. Command acceptance is complete; GUI acceptance remains with the user.**

Date: 2026-10-13  
Application: local Wappler instance on port 3000  
Database: laptop_tickets_db

## Acceptance Ledger

| Tests | Result | Evidence |
| --- | --- | --- |
| Fresh non-return completion, uniqueness, return-ready regression | PASS | Exception created through the completion workflow; duplicate completion returned 409 with one case; return-ready job completed without an exception. |
| Manufacturer return and direct replacement | PASS | Fixture E reached MANUFACTURER_RETURN_APPROVED; Fixture F reached REPLACEMENT_APPROVED. Replacement endpoint returned replacement_device_selected: false; no replacement device/RMA/shipment workflow was created. |
| Unable-to-repair branches | PASS | Disposable case 8 selected manufacturer return and was approved by District without Head Office; case 9 selected permanent replacement by District and was approved by Head Office. |
| District and Head Office return for review; revision/resubmission | PASS | Case 10 returned by District, retained assessment 1, accepted assessment 2, and resubmitted to PENDING_DISTRICT_APPROVAL. Case 11 returned by Head Office after a District replacement selection, retained the District decision, accepted assessment 2, and resubmitted to PENDING_DISTRICT_DECISION. |
| District approval concurrency | PASS | Case 12, two Caroni District actors: one HTTP 200 and one HTTP 409. Exactly one approval transition/decision/audit was committed. |
| Conflicting District disposition race | PASS | Case 13, manufacturer-return vs permanent-replacement requests: one HTTP 200 and one HTTP 409. Permanent replacement won; final state is PENDING_HEAD_OFFICE_APPROVAL, with no mixed disposition. |
| Head Office concurrency | PASS | Case 14, p8a.ho.1 vs p8a.ho.2: one HTTP 200 and one HTTP 409. Exactly one Head Office approval was committed. |
| District and Head Office transaction rollback | PASS | Cases 15 and 16 each returned a generic HTTP 500 under a temporary failure trigger. Before normal retry, each remained pending with unchanged history/decision/audit counts and unchanged outer state. Both then succeeded through normal API approval. |
| Sanitized 500 responses | PASS | Both rollback responses contained only the controlled generic message. Scans found none of the specified SQL, stack, filesystem, runtime, or raw-error tokens. |
| Head Office/Oversight roles and authorization | PASS | Head Office and Oversight list/detail returned 200. Head Office assessment, submit, and District decision returned 403; Oversight assessment, submit, District decision, and Head Office decision returned 403. Correct-state Head Office approvals succeeded. |
| No-scope regression | PASS | No-scope District list, detail, and summary each returned controlled 403. |
| Financial validation remainder | PASS | Pending warranty and nullable amounts accepted; approved charge 1.239 persisted as 1.24; actual cost 2.345 persisted as 2.35; DECIMAL(12,2) maximum 9999999999.99 accepted; 10000000000 rejected with controlled 400. Prior negative, catalogue, reason, and text-length validations remain passing. |
| Activity completeness and privacy | PASS | Activity contains review-started, assessment-recorded, manufacturer-approved, replacement-requested, replacement-approved, and returned-for-review events. Repeated review-started events on revised cases map to distinct status-history transitions, not duplicate writes. Activity and list payload scans exposed no prohibited financial, narrative, contact, or student fields. |
| Outer state, Phase 5, ownership | PASS | All 17 cases remain ticket UNDER_REPAIR, logistics AT_REPAIR_CENTRE, physical state REPAIR_CENTRE_CUSTODY, device IN_REPAIR. Each has one current district and school allocation; no new test ticket has an owner assignment. |
| Final database consistency | PASS | All specified anomaly counts are zero; details below. |
| GUI fixtures A–G | PASS / READY FOR USER GUI CHECK | A and B were not mutated. C–G are retained simultaneously at their required states. |

## Retained GUI Fixtures

| Fixture | Ticket | Case | Repair Job | Device | Serial / Asset Tag | Repair Centre / District | Outcome / Disposition | Status |
| --- | --- | ---: | ---: | ---: | --- | --- | --- | --- |
| A | TKT00000034 | 1 | 2 | 22 | P5B-BULK-2-20261008 / none | P7D Repair Centre Test Facility / Tobago | MANUFACTURER_RETURN_REQUIRED / MANUFACTURER_RETURN | ASSESSMENT_REQUIRED |
| B | TKT00000041 | 2 | 11 | 32 | P8A-GAP-20261013-01 / P8A-GAP-TAG-20261013-01 | P7D Repair Centre Test Facility / Caroni | MANUFACTURER_RETURN_REQUIRED / MANUFACTURER_RETURN | PENDING_DISTRICT_APPROVAL |
| C | TKT00000042 | 3 | 12 | 33 | P8A-C-20261013-01 / P8A-C-TAG-20261013-01 | P7D Repair Centre Test Facility / Caroni | UNABLE_TO_REPAIR / undecided | PENDING_DISTRICT_DECISION |
| D | TKT00000043 | 4 | 13 | 34 | P8A-D-20261013-01 / P8A-D-20261013-01-TAG | P7D Repair Centre Test Facility / Caroni | REPLACEMENT_REQUIRED / PERMANENT_REPLACEMENT | PENDING_HEAD_OFFICE_APPROVAL |
| E | TKT00000044 | 5 | 14 | 35 | P8A-E-20261013-01 / P8A-E-20261013-01-TAG | P7D Repair Centre Test Facility / Caroni | MANUFACTURER_RETURN_REQUIRED / MANUFACTURER_RETURN | MANUFACTURER_RETURN_APPROVED |
| F | TKT00000045 | 6 | 15 | 36 | P8A-F-20261013-01 / P8A-F-20261013-01-TAG | P7D Repair Centre Test Facility / Caroni | REPLACEMENT_REQUIRED / PERMANENT_REPLACEMENT | REPLACEMENT_APPROVED |
| G | TKT00000046 | 7 | 16 | 37 | P8A-G-20261013-01 / P8A-G-20261013-01-TAG | P7D Repair Centre Test Facility / Caroni | MANUFACTURER_RETURN_REQUIRED / MANUFACTURER_RETURN | REPAIR_CENTRE_REVIEW_REQUIRED |

All seven fixtures have the required outer state. Fixture G was left at review-required and not resubmitted. Disposable concurrency, rollback, review, and financial cases use separate tickets and devices.

## Role Seed and Cleanup

The application-generated login, current-user, role/permission, and scope contexts were verified before tests. Seeded users used the existing valid test fixture credential; no password hash is included here. After acceptance, all four accounts were disabled and all active national/district/school/service-location scopes were revoked. Fresh login attempts returned HTTP 401. Users and role links were retained for audit/history integrity.

| User ID | Username | Retained role | Final state | Active scopes | Audit references / domain-history references |
| ---: | --- | --- | --- | ---: | ---: |
| 27 | p8a.ho.1 | MOE_HEAD_OFFICE | disabled | 0 | 13 / 8 |
| 28 | p8a.ho.2 | MOE_HEAD_OFFICE | disabled | 0 | 5 / 2 |
| 29 | p8a.oversight | TSTT_OVERSIGHT | disabled | 0 | 4 / 0 |
| 30 | p8a.district.2 | ICT_DISTRICT_COORDINATOR | disabled | 0 | 18 / 16 |

p8a.repair.2 was not created. No historical disabled account was reactivated; other historical test identities were not altered.

## Final Database Counts

There are 17 exception cases, 48 status-history rows, 21 assessments, and 31 decisions. The financial boundary test is retained as a separate assessment-required disposable case (ticket TKT00000056 / case 17); it does not replace or alter GUI fixtures A–G.

| Anomaly | Count |
| --- | ---: |
| Multiple exception cases per repair job | 0 |
| Return-ready outcome with exception case | 0 |
| Ticket not UNDER_REPAIR | 0 |
| Logistics not AT_REPAIR_CENTRE | 0 |
| Physical state not REPAIR_CENTRE_CUSTODY | 0 |
| Device not IN_REPAIR | 0 |
| Pending District approval without assessment | 0 |
| Pending District decision without assessment | 0 |
| Pending Head Office approval without assessment | 0 |
| Manufacturer approval without District evidence | 0 |
| Replacement approval without Head Office evidence | 0 |
| Status/history mismatch | 0 |
| Dangling assessment | 0 |
| Dangling decision | 0 |
| Duplicate successful District decisions | 0 |
| Conflicting District dispositions | 0 |
| Duplicate successful Head Office approvals | 0 |
| Phase 5 allocation anomalies | 0 |
| Multiple active ticket owners | 0 |
| New acceptance tickets with owner assignments | 0 |
| Temporary/permanent database triggers | 0 |

## Implementation and Test Hygiene

- This closure run changed no application implementation files.
- The earlier no-scope authorization fix remains in app/api/exceptions/list.json, detail.json, and summary.json.
- Test-only SQL was used only to seed/disable temporary test identities, revoke their scopes, and create/drop temporary rollback fault triggers. No SQL fixture script was retained in the repository.
- Runtime raw SQL: none. Custom Express: none. Custom Node business logic: none.
- All temporary triggers were explicitly dropped and the final trigger count is zero.
- No business workflow state was fabricated through SQL; business fixtures were created and transitioned through normal application APIs.

## Final Disposition

**Test ledger: COMPLETE.**  
**Phase 8A command acceptance: COMPLETE.**  
**GUI acceptance: NOT PERFORMED — USER WILL TEST.**  
**Phase 8A overall: READY FOR GUI ACCEPTANCE; remains limited only by user GUI regression.**

Do not begin Phase 8B until the user confirms GUI acceptance.

