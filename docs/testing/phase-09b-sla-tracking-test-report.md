# Phase 9B SLA Tracking Test Report

## Status

**IMPLEMENTATION WIRED — LIVE COMMAND ACCEPTANCE PASS; USER GUI ACCEPTANCE OPEN.** The false `SLA_START_CONFIGURATION` guard has been corrected and the same disposable case completed the normal pickup, logistics, and repair workflow through `READY_FOR_RETURN`. Exactly one `RETURN_LOGISTICS` SLA was created and is active. No GUI testing was performed.

## Final Live Return SLA Command Acceptance

The authoritative Phase 9B activation boundary is **2026-10-15 16:57:51** in the application/local Trinidad & Tobago time convention, as confirmed for final acceptance. The database acceptance uses this boundary to distinguish post-activation `READY_FOR_RETURN` transitions from historical records; historical cases are not backfilled.

Accepted Phase 8 golden fixtures were not advanced. The disposable fixture was created through the application's normal APIs and then advanced only through regular workflow APIs:

| Entity | Identifier | Current state |
| --- | --- | --- |
| Device | ID 79; serial `P9B-RET-20261015-210820`; asset tag `P9B-RET-20261015-210820-TAG` | `AVAILABLE`, school custody at Caroni / `PHASE3 TEST SCHOOL A UPDATED` |
| Ticket | ID 71; `TKT00000071` | `COMPLETED` |
| Diagnosis | ID 53 | Current diagnosis recorded; controlled disposable fixture description |
| District approval | ID 46 | `APPROVED_FOR_PICKUP` |
| Logistics | ID 57; `LOG00000057` | `READY_FOR_RETURN`; physical custody remains at Repair Centre location 8, `P7D Repair Centre Test Facility` |
| Repair job | ID 39 | `READY_FOR_RETURN`; outcome `REPAIRED_SUCCESSFULLY` |
| Return Logistics SLA | ID 4 | `ACTIVE`, target 2 business days; started `2026-10-15T22:40:59.000Z`; due `2026-10-17T07:59:59.000Z`; source `NORMAL_RETURN` |

### Guard Root Cause and Fix

The caller supplied `started_at` as an already formatted timestamp (`yyyy-MM-dd HH:mm:ss.SSS`), but the shared SLA start action attempted to call `formatDate('yyyy-MM-dd')` on that string again. Wappler produced an empty date filter, so the business-date query returned zero rows and the configuration guard fired. The shared action now uses `started_at.substr(0, 10)` for the date filter. It also converts the MySQL DECIMAL policy target to a number once (`target_days`) and uses that numeric value consistently for the query limit, validation, and snapshot. The generic `SLA_START_CONFIGURATION` response was retained; diagnostic output was removed.

### Live Command Acceptance

The same fixture passed through the normal workflow APIs using `portal.admin` (test account, permission bypass):

| Step | Result |
| --- | --- |
| District pickup approval | HTTP 200; ticket 71, approval 46, `APPROVED_FOR_PICKUP` |
| Pickup SLA read | Exactly one `PICKUP:TICKET:71`; policy `PICKUP`, target 2, then `ACTIVE`; completed when TTPost received the school handoff |
| Repeat pickup approval | HTTP 409, expected state conflict; still exactly one pickup SLA |
| Pickup request / TTPost accept / School dispatch / TTPost receive | HTTP 200 for each; created LOG00000057 and completed pickup SLA once |
| TTPost dispatch to Repair Centre / Repair Centre receipt | HTTP 200 for each; ticket entered `UNDER_REPAIR`, logistics `AT_REPAIR_CENTRE`, custody `REPAIR_CENTRE_CUSTODY` |
| Repair start / assessment / work log / completion | HTTP 200 for each; repair job 39, ticket `COMPLETED`, logistics `READY_FOR_RETURN` |
| Return SLA read | Exactly one instance: ID 4, `RETURN_LOGISTICS`, target 2, `ACTIVE`, started and due dates populated, linked to ticket 71 and logistics case 57 |
| Repeated repair completion | HTTP 409; follow-up read still returned exactly one Return Logistics SLA |
| Final logistics detail | HTTP 200; `READY_FOR_RETURN`, `REPAIR_CENTRE_CUSTODY`, physical location `P7D Repair Centre Test Facility`; no school return/receipt was performed |

All workflow actions were application APIs; no database rows or state were directly fabricated. The fixture remains at `READY_FOR_RETURN` for user GUI inspection.

The shared SLA-start guard was subsequently fixed and verified against this same disposable fixture. The live command evidence and final state above supersede the earlier blocked note.

## Workflow Event Mapping

| Policy | Start event | Completion event | Cancel / N-A event | Status | Reason |
| --- | --- | --- | --- | --- | --- |
| PICKUP | District approval reaches `APPROVED_FOR_PICKUP` | Successful `SCHOOL_TO_TTPOST` handoff receipt | No cancellation endpoint exists; unapproved ticket is N/A | IMPLEMENTED | Start/complete calls execute in the existing workflow transactions. |
| DIAGNOSIS | Successful `TTPOST_TO_REPAIR_CENTRE` receipt | Repair Centre assessment record | No synthetic school diagnosis | IMPLEMENTED | Uses logistics-case idempotency; repeat assessment after completion is a no-op. |
| REPAIR | Repair job work start | Successful local repair completion | Completed non-local disposition cancels | IMPLEMENTED | Uses repair-job identity; terminal updates append one history/audit transition. |
| QA | No authoritative QA start/completion event exists | None | N/A | DEFERRED | No QA table/event was found; do not fabricate a milestone. A first-class QA record with start and pass/fail timestamps is required. |
| RETURN_LOGISTICS | Actual READY transition from local repair, permanent replacement, or repaired-original manufacturer return | Successful `TTPOST_TO_SCHOOL` final receipt | Non-return dispositions are N/A; conversion fulfillment cancels any existing clock and never starts one | IMPLEMENTED | Effective-device source excludes `TEMPORARY_LOAN_CONVERSION`; hooks share the workflow transaction. |

## Delivered

- `database/phase_09b_sla_tracking.sql`: MySQL 5.7 schema for separate SLA states, policy snapshots, instance idempotency, append-only events, a business-calendar date spine, and read-only operational views.
- `docs/phase-09-sla-model.md`: 9B entities, event mappings, QA deferral, evaluation rules, and safeguards.
- `/tmp/phase09b_db_acceptance.sql`: SELECT-only MySQL 5.7 acceptance checks for local user execution.
- `app/modules/lib/sla_start.json`, `sla_complete.json`, `sla_cancel.json`, and `sla_evaluate.json`: reusable Wappler Server Connect actions.
- `app/api/sla/list.json`, `detail.json`, `ticket-summary.json`, and `evaluate.json`: scoped reads and explicit permission-guarded evaluation.
- `app/api/sla/filter-options.json`: district and school selectors limited to the authenticated user's organization scope.
- `views/sla-tracking.ejs` and ticket detail: view-only operational SLA information.

## Not Yet Delivered

- User GUI/runtime workflow regression. The user should inspect the disposable ticket 71 / logistics case `LOG00000057` and its active Return Logistics SLA.

## Verification Constraints

## Protected SLA 3 Timestamp Integrity Follow-up

- SLA 3 (`REPAIR:JOB:39`, `TKT00000071`, `LOG00000057`, repair job 39, policy `REPAIR`) is a **current implementation defect reproduced in the historical fixture**, not an unrelated historical artifact. The repair job's authoritative `started_at` is `2026-10-15 18:40:45.754091`; SLA 3 was created at `18:40:45.764161`, but both its instance and STARTED event stored `22:40:45.754000`. The repair job's `completed_at`, SLA `completed_at`, and COMPLETED event are `18:40:59` (the completion audit was recorded at `18:40:59`). The four-hour displacement is isolated to start serialization.
- Root cause: `app/api/repairs/start.json` passed the MySQL DATETIME returned as `new_job.started_at` directly to `sla_start`. Wappler's date handling shifted that DATETIME by the local calendar offset before persistence. The repair-start hook now supplies a formatted Server Connect `now` timestamp, matching the established start-hook pattern; the protected SLA 3, event history, and repair job were not changed.
- The code-path correction is static-verified, but a fresh disposable repair-start workflow has **not** been run. Existing repair-eligible contexts already have jobs, and accepted fixtures were not repurposed. Therefore Phase 9B history integrity has zero current anomalies plus one explicitly reported protected SLA 3 anomaly; runtime verification of the repair-start correction remains open.
- Added `docs/testing/phase-09b-sla-event-integrity-delta.sql`. It checks current state against the last appended event, counts duplicate starts/completions, fails on every timestamp-order anomaly except the exact immutable SLA 3 identity, and separately reports/details that one protected anomaly. No generic historical cutoff or broad exclusion is used.
- The revised activation-boundary Check 22 remains authoritative and passes: 0 post-activation anomalies; 22 historical pre-activation cases are informational; fulfilled-at-recipient and duplicate return-SLA exclusions are both 0.

## Phase 9C Repair-Start Runtime Regression

- Fresh disposable marker `P9C-REPAIR-START-REG-20261016-A2`; ticket `TKT00000077`; device 85; logistics `LOG00000063`; repair job 41; REPAIR SLA 14 (`REPAIR:JOB:41`). The real scoped Repair Centre API returned HTTP 200. Before start, the ticket was `UNDER_REPAIR`, device `IN_REPAIR`, custody `REPAIR_CENTRE_CUSTODY` at the Repair Centre, with no repair job or REPAIR SLA. This workflow creates the job inside the repair-start action, so there is no separate pre-existing unstarted job row.
- Captured immediately before start: UTC `2026-10-16 07:32:36.544883`; timezone `America/Port_of_Spain`; calendar-local time `2026-10-16 03:32:36.544883`.
- Raw local DATETIME values: repair job `started_at` `2026-10-16 03:32:38.633781`; SLA `started_at` and STARTED event `2026-10-16 03:32:38.000000`. SLA/event differ from the domain start by 633,781 microseconds (less than one second; SLA write precision is seconds). No timezone-scale shift occurred. SLA is `ACTIVE`; target is 3; exactly one REPAIR SLA, one STARTED event, and one `sla_started` audit exist.
- Due-date verification found a separate serialization issue during this acceptance: the original calendar view returned a DATETIME through Wappler and the SLA stored `03:59:59` instead of local end-of-day `23:59:59`. Added and applied `database/phase_09c_sla_due_datetime_serialization.sql`, which returns the calendar-local due value as a formatted string. The regression SLA's due date is now `2026-10-20 23:59:59`, exactly matching the view's third eligible business date: Oct 16 counts as day 1, Oct 17–18 are non-business days, and Oct 19–20 are days 2–3. API readback showed policy REPAIR, ACTIVE, target 3, timezone `America/Port_of_Spain`; its due value is the equivalent UTC serialization.
- Retrying repair start for the same case returned HTTP 409. Post-retry counts remained one repair job, one REPAIR SLA, one STARTED event, and one SLA-start audit.
- Disposable markers A1 and A2 and all linked tickets, logistics, repair/SLA histories, allocations, and marker-linked audits were cleaned. Marker-linked row counts are zero. Protected SLA3 and the accepted GUI fixture remain unchanged.
- Final Phase 9B delta: current start-after-completion anomalies 0; exact protected SLA3 anomaly 1 and reported separately; append-order and duplicate start/completion checks 0. Activation-boundary Check 22 remains 0 post-activation anomalies, 22 historical cases informational, and both exclusion/duplicate checks 0.

## Command / Static Results

- JSON parsing: PASS for every `app/**/*.json` file.
- EJS compilation: PASS for SLA Tracking, Ticket Detail, and the shared portal sidebar.
- `/sla` route structure: PASS; main layout, authenticated provider, and `sla.view` guard are configured.
- Workflow wiring inspection: PASS; all SLA service calls found in the authoritative pickup, diagnosis, repair, return, manufacturer-repair, and temporary-conversion workflows are inside their existing transactions.
- Shared SLA-start guard regression: PASS; date filter is taken from the already formatted start timestamp and numeric policy target is used consistently.
- Live post-9B Return Logistics hook: PASS; normal repair completion created exactly one active `RETURN_LOGISTICS` SLA for `TKT00000071` / `LOG00000057`; a repeated completion returned 409 and did not create a duplicate.
- Static hook mappings: PASS for `PICKUP`, `DIAGNOSIS`, `REPAIR`, and `RETURN_LOGISTICS`.
- Scoped read APIs and option API: PASS by static inspection; each requires `sla.view` and applies organizational filters before returning records/options.
- Acceptance SQL: PASS static scan; 42 SELECT statements, no mutation/DDL, CTE, or window-function syntax.
- MySQL 5.7 migration scan: PASS; no CTE or window functions.
- Dynamic event convention: PASS; no static inline event handlers were added.
- Custom Express/Node SLA runtime: NOT INTRODUCED.

- MySQL execution: not performed by Codex; the user reported the migration applied and acceptance checks closed except historical Check 22, which was corrected separately.
- Browser/GUI testing: not performed; user responsibility.
- The generated SQL acceptance file is SELECT-only and must be run by the user after applying the migration.
- Phase 9B acceptance remains closed; Phase 9C work is tracked separately in `phase-09c-escalation-test-report.md`.
