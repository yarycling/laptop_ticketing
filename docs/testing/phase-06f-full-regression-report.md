# Phase 6F Full Regression and Acceptance

Date: 2026-10-12  
Environment: Wappler development instance at `http://localhost:3000`; database `laptop_tickets_db`.  
Result: **6F PASS WITH LIMITATION**. Command acceptance passed after the freshness defect was fixed and retested. User GUI acceptance remains outstanding. One ticket created during the initial, failed regression attempt is retained as an immutable acceptance artifact and must not be used as a clean GUI fixture.

## Scope and Architecture

Phase 6 remains one integrated ticketing system, without adding a later-phase workflow. Ticket origin is a server-derived historical snapshot of district, school, and student at creation. Ticket status is an independent state pointer backed by append-oriented status history. Work ownership is represented by assignment intervals. Device lifecycle and custody remain Phase 5 data and are not changed by ticket actions. Reads and reporting use ticket origin, not current device custody.

Implemented ticket statuses remain `SUBMITTED`, `NEEDS_CLARIFICATION`, and `APPROVED_FOR_PICKUP`; later catalogue statuses are not activated by this workflow. Diagnosis is history, not a status transition. A clarification response resubmits the ticket and invalidates diagnoses recorded before that transition. Approval is a named, transactional District Coordinator action requiring a current diagnosis and valid school/district lineage. Assignment, claim, reassignment, and release do not alter ticket status or device custody. Activity and operational metrics remain read-only Wappler database views; age bands are descriptive, not SLA claims.

### Diagnosis Freshness Defect

The first test run showed that the approval endpoint accepted a stale diagnosis. Root cause: diagnosis and resubmission event times were written at second precision, and the guard considered equal timestamps fresh. The fix changes the guard to require diagnosis time strictly later than the latest `SUBMITTED` transition. A narrow migration changes `ticket_diagnoses.diagnosed_at` and `ticket_status_history.changed_at` to `DATETIME(6)` with database-managed microsecond defaults. The diagnosis insert and clarification-response history insert now use those defaults instead of constructing second-precision timestamps in App Connect.

Retest: on `TKT00000034`, original diagnosis `07:53:58.388901` preceded clarification resubmission `07:53:58.422022`. Detail returned `has_current_diagnosis: false`; District approval returned HTTP 409 with `A current School IT diagnosis is required before approval.` No approval/history/status mutation occurred. A new diagnosis at `07:54:11.554976` made the ticket eligible, and approval then succeeded. The clean submitted/stale GUI fixture `TKT00000035` was separately verified to report stale and reject approval with the same controlled 409.

### Role and Action Matrix

Effective grants match the accepted Phase 6 permission migrations. Each required Phase 6 permission exists exactly once. The legacy `tickets.manage` permission is pre-existing from Phase 2, mapped only to `SUPER_ADMIN`, and unused by the Phase 6 endpoints; it was not changed.

| Role | Effective Phase 6 permissions |
|---|---|
| `SUPER_ADMIN` | view, create, diagnose, clarification request/respond, pickup approval, assign, dashboard, report |
| `MOE_HEAD_OFFICE` | view, create, dashboard, report |
| `ICT_DISTRICT_COORDINATOR` | view, create, clarification request, pickup approval, assign, dashboard, report |
| `SCHOOL_ADMINISTRATOR` | view, create, diagnose, clarification request/respond, assign, dashboard, report |
| `ICT_TECHNICAL_OFFICER` | view, create, diagnose, clarification request/respond, claim |
| `TSTT_OVERSIGHT` | view, dashboard, report |
| `REPAIR_CENTRE` | no Phase 6 ticket permissions |
| `TTPOST_LOGISTICS` | no Phase 6 ticket permissions |

The account/scope checks confirmed school, district, and no-active-scope visibility is bounded by historical origin. Out-of-scope detail/activity returned 403; a scoped school list excluded Tobago-origin records; the no-scope District Coordinator list was empty. Temporary School 2 and Tobago scopes used to execute the integrated journey were revoked through the standard admin API. No temporary user was created.

## Test Matrix

Prior accepted runtime evidence is reused only where the relevant implementation is unchanged. The underlying prior reports are `phase-06b-ticket-intake-test-report.md`, `phase-06c-diagnosis-approval-test-report.md`, `phase-06d-ticket-assignment-test-report.md`, and `phase-06e-dashboard-reporting-test-report.md` in this directory.

| # | Test | Result and evidence |
|---:|---|---|
| 1 | Schema foundation | PASS. Required Phase 6 tables and all three views exist and query. |
| 2 | Status catalogue | PASS. Eight active statuses each occur once; only `RETURNED` and `CANCELLED` are terminal. |
| 3 | Migration idempotency | PASS. Reapplied 6B–6E migrations/views and the new 6F precision migration; no errors or duplicate permission rows; views remain queryable. |
| 4 | Permission inventory | PASS. Every required Phase 6 permission occurs exactly once; effective grants match accepted migrations. |
| 5 | Auth context | PASS. Existing admin, School 1, Caroni District, no-scope District, and technical accounts authenticated; role mapping for Head Office, Oversight, Repair Centre, and TTPost verified against migrations. |
| 6 | Create E2E ticket | PASS. `TKT00000034` created through `/api/tickets/create`; HTTP 200; server-generated ticket number. |
| 7 | E2E origin | PASS. Origin is School 2 / Tobago, server-derived from device 22 custody when created. |
| 8 | Device unchanged at creation/workflow | PASS. Device 22 remained `AVAILABLE`, `SCHOOL` custody, district 8, school 2, no student throughout ticket actions. |
| 9 | Initial unassigned | PASS. Ticket 34 initially had zero assignments before the explicit manager assignment. |
| 10 | Manager assignment | PASS. Explicit assign returned HTTP 200; one active owner; status stayed `SUBMITTED`. |
| 11 | Diagnosis | PASS. Diagnosis returned HTTP 200; status and assignment remained unchanged. |
| 12 | Clarification request | PASS. Request/comment and `SUBMITTED → NEEDS_CLARIFICATION` recorded; owner remained. |
| 13 | Clarification response | PASS. School role response returned HTTP 200; `NEEDS_CLARIFICATION → SUBMITTED` recorded. |
| 14 | Old diagnosis stale | PASS after fix. Detail says stale; approval returns safe HTTP 409; no mutation. |
| 15 | Re-diagnosis | PASS. Second diagnosis retained; detail reports current. |
| 16 | District approval | PASS. Authorized Caroni/Tobago-scoped coordinator returned HTTP 200; approval row and `APPROVED_FOR_PICKUP` status recorded. |
| 17 | Assignment survives status workflow | PASS. Owner persisted through diagnosis, clarification, response, re-diagnosis, and approval until explicit reassignment. |
| 18 | Reassignment | PASS. Manager reassigned to another eligible in-scope technician; history retained; status unchanged. |
| 19 | Release | PASS. Authorized School Administrator released owner; assignment history retained; status unchanged. |
| 20 | Claim again | PASS. Eligible technician claimed; later final ownership was moved to the persistent Tobago-scoped technician. |
| 21 | Status history | PASS. Ticket 34 has exactly `NULL → SUBMITTED → NEEDS_CLARIFICATION → SUBMITTED → APPROVED_FOR_PICKUP`; assignment actions added no status rows. |
| 22 | Diagnosis history | PASS. Both diagnoses remain, with first stale and second current. |
| 23 | Clarification history | PASS. Request and response remain in order with actors/times. |
| 24 | Approval history | PASS. `APPROVED`, coordinator actor, timestamp, and note retained. |
| 25 | Assignment history | PASS. Four intervals show initial assign, reassign, release, and subsequent claims; one active owner remains. |
| 26 | Activity | PASS. Activity API returned the ticket’s status, assignment, diagnosis, clarification, and approval events; no free-text PII fields. |
| 27 | Origin immutability | PASS. Prior movement fixture ticket 29 retains its origin; no Phase 6 endpoint rewrites it. |
| 28 | Origin-based School visibility | PASS. Prior runtime proof: School 1 still reads ticket 29 after its device moved, while device list excludes the moved device. |
| 29 | Origin-based District visibility | PASS. Prior ticket 29 movement evidence and 6F scope checks confirm origin-based reporting/access. |
| 30 | School scope | PASS. 6B/6C role tests plus 6F: School 1 cannot read Tobago ticket 34; detail/activity return 403. |
| 31 | District scope | PASS. 6B/6C tests plus 6F: Caroni cannot read Tobago ticket 34; 403. |
| 32 | No-scope user | PASS. Revoked-scope District Coordinator list is empty; direct ticket detail returns 403. |
| 33 | National scope | PASS. Prior accepted National/SUPER_ADMIN coverage; 6F admin report/list queries see global records. |
| 34 | School write boundaries | PASS. Prior role matrix tests; 6F School approval attempt returned 403. |
| 35 | District write boundaries | PASS. Prior accepted tests: approval/request/assign allowed only in scope; diagnosis/response denied. |
| 36 | Technician write boundaries | PASS. Prior accepted tests: scoped diagnosis/clarification/claim allowed; assign/approval denied. |
| 37 | Oversight read-only | PASS. Prior Phase 6B/6E runtime permission tests and current migration mapping; no workflow mutation grants. |
| 38 | Head Office boundaries | PASS. Prior Phase 6B/6C runtime tests and current migration mapping; no diagnosis/approval/assignment grants. |
| 39 | Repair Centre boundary | PASS. Prior protected-route tests and current migration mapping show no Phase 6 access. |
| 40 | TTPost boundary | PASS. Prior protected-route tests and current migration mapping show no Phase 6 access. |
| 41 | Concurrent ticket number | PASS, reused. Prior eight-way create test proved unique ticket numbers; `create.json` unchanged since. |
| 42 | Concurrent claim | PASS, reused. Prior two-claim runtime test yielded one 200 and one 409; assignment implementation unchanged. |
| 43 | Create rollback | PASS, reused. Prior injected post-insert failure proved rollback; create transaction unchanged. |
| 44 | Reassign rollback | PASS, reused. Prior injected insert failure proved rollback; assignment transaction unchanged. |
| 45 | Clarification atomicity | PASS, reused. Prior transaction failure injection proved rollback; transaction structure unchanged. |
| 46 | Approval atomicity | PASS, reused. Prior transaction failure injection proved rollback; transaction structure unchanged. |
| 47 | No automatic assignment | PASS. Ticket 34 began unassigned; only explicit assign added ownership. Ticket 35 also has only its explicit assignment. |
| 48 | No status from assignment | PASS. Assign/reassign/release/claim left status unchanged. |
| 49 | No device mutation from ticketing | PASS. Device 22 custody/lifecycle and allocation remained unchanged across ticket workflow. |
| 50 | Detail integration | PASS. Ticket detail returns origin, current device context, status/freshness, owner/history, diagnoses, clarifications, approval, and status history. |
| 51 | Dashboard counts | PASS. 24 tickets reconcile: 24 open, 0 terminal, 13 submitted, 3 needs clarification, 8 approved, 17 assigned, 7 unassigned. |
| 52 | Dashboard aging | PASS. All 24 open tickets have exactly one age bucket; 24 are `<24h`, none missing. |
| 53 | Performance metrics | PASS. Dashboard values reconcile contemporaneously to the reporting view: average open age 1,134 minutes, first diagnosis 46 minutes, approval 110 minutes. Missing milestones remain NULL, not fabricated zeros. |
| 54 | Dashboard workload | PASS. Active nonterminal ownership totals 17 and reconciles to users 12=10, 13=5, 15=2; historical assignments excluded. |
| 55 | Reporting scope | PASS. Dashboard/report use origin; school/district/no-scope API results remain bounded. |
| 56 | Report filters | PASS. Pagination (1 row), Caroni + Submitted (10 rows), and search for ticket 34 (1 row) returned expected results. |
| 57 | Activity PII | PASS. Activity payload has no requester contact, diagnosis body/recommendation, clarification text, or release reason fields. |
| 58 | Report PII | PASS. Operational report omits requester contact, student details, diagnosis and clarification content. |
| 59 | SLA language | PASS. UI/API use objective elapsed time and age bands; no SLA met/breached/compliance claims introduced. |
| 60 | Page routes | PASS. Authenticated `/tickets`, `/tickets/new`, `/tickets/detail?id=34`, and `/tickets/dashboard` each returned HTTP 200. |
| 61 | Static UI architecture | PASS. Existing Phase 6 views use Wappler dynamic events and modal conventions; no static `onclick`/`onsuccess`/`onerror` found in reviewed ticket views. |
| 62 | No generic status API | PASS. No generic set/change/transition status endpoint exists. |
| 63 | No generic ticket edit | PASS. No unrestricted ticket editing endpoint exists. |
| 64 | Origin immutability | PASS. Ticket 29 movement fixture and new E2E origins remained stable. |
| 65 | Status/history consistency | PASS. Current-status vs latest-history mismatch: 0. |
| 66 | Initial-history consistency | PASS. Tickets missing initial history: 0. |
| 67 | Approval consistency | PASS. Approved without approval: 0; approval without approved status history: 0. |
| 68 | Clarification consistency | PASS. Current Needs Clarification tickets without request/history: 0. |
| 69 | Assignment consistency | PASS. Duplicate active owners: 0; malformed assignment intervals: 0. |
| 70 | Assignee validity | PASS. Inactive, nontechnical, or out-of-scope active owners: 0. |
| 71 | Reporting view consistency | PASS. 24 metrics rows / 24 distinct tickets; negative elapsed metrics: 0; orphan activity: 0. |
| 72 | Audit chain | PASS. Ticket 34 has safe created, assigned, diagnosed, clarification request/response, approval, reassignment, release, and claim audit events. |
| 73 | Safe errors | PASS. 400/401/403/404/409 responses scanned; no SQL, stack, filesystem, driver, dependency, or raw error details. Generic unexpected-500 injection remains deferred. |
| 74 | Phase 5 regression | PASS. No devices missing custody; lifecycle/custody mismatch count 0. Ticket actions did not mutate device 22. |
| 75 | No premature later workflow | PASS. No TTPost, logistics, repair, parts, QA, completion, return, replacement, or spare workflow added. |
| 76 | Custom code boundary | PASS. No custom Express, custom Node business logic, or runtime raw SQL added. |
| 77 | Final consistency | PASS for specified structural checks: status mismatch 0; missing initial history 0; duplicate active assignments 0; malformed intervals 0; approval inconsistencies 0; clarification inconsistencies 0; orphan histories/diagnoses/comments/approvals/activity 0; duplicate metrics 0; negative metrics 0; `TMP-%` numbers 0; temporary fault objects 0. |
| 78 | Final GUI fixtures | PASS WITH LIMITATION. Clean fixtures are listed below. Ticket 33 is excluded because it records the pre-fix stale-approval defect. |

## Final Database Snapshot

| Check | Result |
|---|---:|
| Tickets / metrics rows / distinct metrics tickets | 24 / 24 / 24 |
| Open / terminal | 24 / 0 |
| Submitted / Needs Clarification / Approved for Pickup | 13 / 3 / 8 |
| Assigned open / unassigned open | 17 / 7 |
| Age buckets `<24h` / `1–3d` / `4–7d` / `>7d` | 24 / 0 / 0 / 0 |
| Status-history mismatch / missing initial history | 0 / 0 |
| Duplicate active owners / malformed assignment intervals | 0 / 0 |
| Approved without approval / approval without status transition | 0 / 0 |
| Orphan history / diagnosis / comment / approval / activity | 0 / 0 / 0 / 0 / 0 |
| Duplicate metrics rows / negative metrics / provisional ticket numbers | 0 / 0 / 0 |
| Invalid active assignees / missing device custody / lifecycle-custody mismatches | 0 / 0 / 0 |
| Active temporary scopes / temporary fault-injection objects | 0 / 0 |

## GUI Fixtures

Use these records for final user regression:

| State | Ticket | Notes |
|---|---|---|
| SUBMITTED / UNASSIGNED | ID 11 / `TKT00000011` | Tobago; no diagnosis. |
| SUBMITTED / ASSIGNED | ID 22 / `TKT00000022` | Caroni; current diagnosis; owner `p6d.caroni.tech.test`. |
| NEEDS_CLARIFICATION / ASSIGNED | ID 23 / `TKT00000023` | Caroni; owner `p6c.tech.test`. |
| SUBMITTED / CURRENT DIAGNOSIS | ID 22 / `TKT00000022` | Same clean current-diagnosis fixture. |
| SUBMITTED / STALE DIAGNOSIS | ID 35 / `TKT00000035` | Dedicated device ID 28, `P6F-GUI-STALE-1791806584939`; one diagnosis predates clarification response; assigned to `p6d.caroni.tech.test`. Approval is verified to return 409. |
| APPROVED_FOR_PICKUP / ASSIGNED | ID 34 / `TKT00000034` | Tobago; owner `p6d.tobago.tech.test`; complete integrated workflow. |
| Clarification + multiple diagnoses + approval + assignment/reassignment + full activity | ID 34 / `TKT00000034` | Full create → assign → diagnose → clarification → response → re-diagnose → approve → reassign → release → claim trail. |
| Moved-device origin | ID 29 / `TKT00000029` | Origin District 4 / School 1; device now District 4 custody. |

Existing logins remain `portal.admin / test`, `phase3.school.test / test`, `phase5b.district.test / test`, `p6c.tech.test / test`, `p6d.caroni.tech.test / test`, and `p6d.tobago.tech.test / test`. No temporary users remain. Device 22 was allocated from Tobago District inventory to Tobago School 2 using the normal Phase 5 APIs as an E2E fixture; device 28 was created and allocated through normal APIs for the stale-diagnosis GUI fixture.

### Retained Acceptance Artifact

Ticket ID 33 / `TKT00000033` was created during the first run and the then-defective approval guard accepted its stale diagnosis. After identifying the precision defect, the implementation was corrected and the full affected journey was repeated successfully on ticket 34. Ticket 33 and its append-only records were not deleted or silently repaired. Its detail now correctly reports `has_current_diagnosis: false`, but its status is already Approved for Pickup; do not use it as a clean GUI fixture. This retained artifact is why the overall result is **PASS WITH LIMITATION** and is disclosed for administrative disposition.

## Deferred Work and Boundaries

- The global unexpected-500 fault-injection test remains a **PRE-PRODUCTION DEFERMENT**; it was not run in this Phase 6F acceptance.
- No Phase 7 or later workflow was started.
- GUI/browser acceptance was not performed; the user performs that final step.
- No custom Express, custom Node business logic, runtime raw SQL, or Wappler runtime modification was introduced. Controlled test setup used normal APIs; database queries were read-only except the documented schema migration.

## Files Changed

- `app/api/tickets/diagnosis/create.json`
- `app/api/tickets/clarification/respond.json`
- `app/api/tickets/approval/approve-pickup.json`
- `app/api/tickets/detail.json`
- `database/phase_06f_diagnosis_freshness_precision.sql`
- `docs/testing/phase-06f-full-regression-report.md`

The timestamp migration was applied and reapplied successfully to the local acceptance database. No production runtime configuration was changed.
