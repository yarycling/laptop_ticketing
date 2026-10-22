# Phase 6E Dashboard and Reporting Test Report

## Scope

Command-side implementation and acceptance record for Phase 6E. The user performs final GUI acceptance. Tests are limited to read-only reporting, ticket-origin scope, activity output, and existing workflow regression checks.

## Implemented

- Idempotent reporting-view migration: `v_ticket_operational_metrics` and `v_ticket_activity` only.
- Idempotent role-permission seed for `tickets.dashboard` and `tickets.report`.
- Protected `/api/tickets/dashboard`, `/api/tickets/reports/operational`, and `/api/tickets/activity` endpoints.
- Permission-gated `/tickets/dashboard`, scoped navigation link, filters, dashboard summaries and breakdowns, paginated operational report, and ticket-detail activity section.
- Existing dashboard/activity/report reads use historical ticket origin and do not change business records.

## Verification Results

| Check | Result | Evidence |
| --- | --- | --- |
| JSON/static validation | PASS | Six changed Server Connect/route JSON files parse. Dashboard/detail templates contain no static DOM event attributes. Read APIs contain no insert/update/delete actions. |
| View migration rerun | PASS | Reapplied successfully; both views remain queryable. |
| Permission migration rerun | PASS | Reapplied successfully. Both permissions are granted only to `SUPER_ADMIN`, `MOE_HEAD_OFFICE`, `ICT_DISTRICT_COORDINATOR`, `SCHOOL_ADMINISTRATOR`, and `TSTT_OVERSIGHT`. |
| One row per ticket / age consistency | PASS | 21 tickets, 21 metrics rows, 21 distinct ticket IDs. |
| Negative elapsed metrics | PASS | Zero negative ticket, status, assignment, diagnosis, or approval durations. Future-dated ticket age buckets remain NULL. |
| Activity foreign keys / payload | PASS | Zero orphan activity rows. Activity contains event metadata/actor IDs, not diagnosis text, clarification free text, contact data, or assignment reasons. |
| API authorization and scope | PASS | Super-admin reporting succeeds; school and district accounts receive origin-scoped results; no-scope district account receives zero rows; technical officer is denied; out-of-scope activity returns 403. |
| Filters and pagination | PASS | Status, assignment, and search filters return expected fixture counts; pagination returns requested page size. Invalid dates, assignment filter, and page-size bounds return controlled 400 responses. Missing activity ID returns 404. |
| Dashboard breakdown rendering data | PASS | Endpoint now returns native grouped `status_breakdown`, `district_breakdown`, `school_breakdown`, and `requester_breakdown` arrays. Base fixture values reconcile to 21 tickets; a combined Caroni + Student filter returns one ticket consistently across all four arrays. |
| Performance metric display | PASS | Server Connect now returns rounded numeric duration values and the dashboard binds those values directly. Current API values are 1,258, 66, and 147 minutes for open age, first diagnosis, and pickup approval respectively. |
| Query plan review | PASS WITH SCALE NOTE | Report joins use primary/indexed keys and active assignment unique index. At the 21-ticket fixture size, report metrics materialize/scan the small ticket set; activity union members scan small history tables because MySQL 5.7 does not push ticket filters through the union view. Existing ticket-history indexes are present; reassess at production volume. |
| Phase 6B–6D and Phase 5 spot checks | PASS, READ-ONLY | Existing ticket detail and activity reads succeeded; reporting/reconciliation performed no business-record mutations. No fixture histories were created or deleted. |
| GUI acceptance | User pending | Verify `/tickets/dashboard`, filters, report pagination, and ticket activity in browser. |

## Known Fixture Accounts and Records

Use `portal.admin / test` for super-admin GUI/API acceptance. Verified scope accounts: `phase3.school.test` (School Administrator, School 1), `phase5b.district.test` (District Coordinator, Caroni), and `phase3.district.test` (District Coordinator with no active scopes). `p6c.tech.test` (Technical Officer) is denied managerial dashboard/report access. Useful records include ticket 9 (assigned/open), ticket 11 (unassigned), ticket 15 (approval/diagnosis/clarification history), ticket 21 (needs clarification), ticket 25 (assignment history), and ticket 29 (origin/current-custody divergence). Do not modify or delete Phase 6B–6D ticket histories to create test data.

## Boundaries

No SLA targets or breach labels are inferred. Database duration arithmetic uses the MySQL/server timezone. There are no dashboard/report mutations, exports, repair/logistics actions, custom Express routes, custom Node business logic, or runtime raw SQL.
