# Phase 6 Ticketing Data Model

## Purpose and Scope

The ticket is the durable support record for a device problem. Phase 6A established the relational data foundation. Phase 6B adds authenticated staff-assisted intake and read-only ticket listing/detail; it does not add operational transitions.

## Device and Origin

Every ticket references one existing device. `origin_district_id`, `origin_school_id`, and `origin_student_id` are nullable foreign-key snapshots describing where and for whom the problem was reported. They are independent of the device's current custody and are not rewritten when the device moves. The current device custody remains derived from the Phase 5 allocation and assignment histories.

## Requester and Privacy

`requester_type` is flexible text, initially intended for `STUDENT`, `PARENT`, `TEACHER`, or `STAFF`. The ticket stores the requester's required name and optional email/phone only. It does not duplicate student profile details or add addresses, dates of birth, identity numbers, or medical information. Type validation belongs to the later intake workflow.

## Status Catalogue and History

`ticket_statuses` seeds `SUBMITTED`, `NEEDS_CLARIFICATION`, `APPROVED_FOR_PICKUP`, `IN_TRANSIT`, `UNDER_REPAIR`, `COMPLETED`, `RETURNED`, and `CANCELLED`. `RETURNED` and `CANCELLED` are terminal in the initial catalogue; `COMPLETED` is deliberately non-terminal because the device may still need to be returned.

`tickets.current_status_id` is the current read pointer, not the status history. `ticket_status_history` is append-oriented. Future ticket creation must record `NULL -> SUBMITTED`; each later transition must insert its history row and update the pointer atomically. A status transition must validate the current status, append history, update the pointer, and set `closed_at` only when the later workflow defines closure. No database trigger performs these actions.

## Staff Assignment History

`ticket_assignments` records assignment intervals. `active_record_key = 1` denotes the current assignee and `NULL` denotes a historical assignment. A unique `(ticket_id, active_record_key)` index allows only one active assignment while permitting multiple historical rows under MySQL's NULL uniqueness behavior. Reassignment must end the old row and add a new active row transactionally; rows are not overwritten.

## Comments, Diagnosis, Clarification, and Approval

`ticket_comments` stores append-only comments and clarification exchanges using flexible `comment_type` text and an `is_internal` flag. Phase 6C writes only the controlled `CLARIFICATION_REQUEST` and `CLARIFICATION_RESPONSE` types through their named APIs; no generic comment API is provided. Both clarification entries are non-internal and returned in conversational order, while unrelated internal comments are excluded from the detail response.

`ticket_diagnoses` stores historical School IT diagnosis summaries, optional recommended actions, diagnosing user, and diagnosis time. Multiple records may be retained for the same ticket and are returned newest first. Recording a diagnosis does not change `tickets.current_status_id` or create status history: the ticket remains `SUBMITTED` and can display “Diagnosis Recorded — Awaiting District Approval”.

Clarification request transitions `SUBMITTED → NEEDS_CLARIFICATION`; an authorized School Administrator, ICT Technical Officer, or SUPER_ADMIN records the response, which transitions `NEEDS_CLARIFICATION → SUBMITTED`. Each transition writes the comment, status history, ticket pointer, actor update, and safe audit event atomically. The existing diagnosis is retained but becomes stale after the return to `SUBMITTED`: approval requires the newest diagnosis to be at or after the latest status-history transition into `SUBMITTED`.

District approval is recorded append-only in `ticket_district_approvals`, with a VARCHAR decision (`APPROVED` in Phase 6C), optional note, actor, and time. Approval requires a current diagnosis and a structurally valid origin school/district. It transitions `SUBMITTED → APPROVED_FOR_PICKUP` atomically with the approval record, status history, and audit event. Operational approval is limited to an ICT District Coordinator with active scope for the ticket's historical origin district; SUPER_ADMIN is the administrative exception. The workflow uses ticket origin scope, not current device custody. Approval does not change device lifecycle, custody/allocation history, or ticket assignments.

## Separation and Deferred Work

Ticket status is distinct from device lifecycle; a ticket status change does not itself alter device state. The Phase 6A model includes no district-approval workflow, logistics/TTPost, repair/parts/QA, AI fields, notifications, attachments, or final ticket permissions. Tickets and their history are protected by restrictive foreign keys and are not hard-deleted through this model. No audit events are manufactured during migration.

## Current Read Model

`v_ticket_current_context` joins the ticket to its device and current status, preserves origin IDs, and left-joins only the active staff assignment. With no active assignment, assignment fields are `NULL`. It intentionally omits current custody so historical origin cannot be confused with present custody.

## Phase 6B Intake

Ticket intake is performed by authenticated staff. Student, Parent, Teacher, and Staff are requester types only; public/direct requester submission and public ticket lookup are deferred. Creation is limited to the `tickets.create` permission. `tickets.view` gates list, summary, status and organisation options, and ticket detail. The Phase 6B role seed grants view and create to SUPER_ADMIN, MOE_HEAD_OFFICE, ICT_DISTRICT_COORDINATOR, ICT_TECHNICAL_OFFICER, and SCHOOL_ADMINISTRATOR; TSTT_OVERSIGHT receives view only. Repair-centre and TTPost roles receive neither permission in this phase. No `tickets.manage`, diagnosis, approval, or assignment permission is added.

Ticket reads and all Phase 6C workflow actions use the saved origin snapshot: district scopes authorize `origin_district_id`, school roles authorize `origin_school_id`, and a user without applicable scope cannot access the ticket. This remains true if the device later moves. Creation instead authorizes against the device's current custody context. Only SCHOOL custody with AVAILABLE lifecycle or STUDENT custody with ASSIGNED lifecycle is eligible, and the active school must match the current district lineage. Central and district custody are excluded. The origin district and school are derived from `v_device_current_custody`; the origin student is saved only for STUDENT custody. Browser-supplied origin fields are not accepted.

Creation accepts only device ID, requester type/name/email/phone, subject, and description. Requester fields are trimmed and validated without truncation. The ticket number is generated server-side from the inserted ticket identity as `TKT` plus an eight-digit zero-padded ID. A unique temporary UUID ticket number is inserted and replaced inside the same Wappler database transaction. The ticket, initial `NULL → SUBMITTED` status-history row, final ticket number, and `ticket_created` audit event commit together or roll back together. The audit description contains only ticket number, device serial, and origin school; requester contact and issue description are excluded.

Phase 6B creates tickets only in SUBMITTED and does not auto-assign them. Phase 6C adds named diagnosis, clarification, and approval actions without generic status mutation. Phase 6D adds assignment, claim, reassignment, and release using the existing `ticket_assignments` interval history; assignment actions do not change ticket status or device custody/lifecycle. The queue is derived from ticket origin, current status, and the active assignment rather than a new routing table. Only active `ICT_TECHNICAL_OFFICER` users whose active school, district, or national scope covers the historical ticket origin may own work. Requester PII remains minimized; list results omit email/phone and detail returns only the recorded requester contact and minimal origin student identity.

## Phase 6D Work Ownership

The idempotent permission seed is `database/phase_06d_ticket_assignment_permissions.sql`. `tickets.assign` is granted to SUPER_ADMIN, SCHOOL_ADMINISTRATOR, and ICT_DISTRICT_COORDINATOR; `tickets.claim` is granted to ICT_TECHNICAL_OFFICER only. Assignment-management scope follows the origin school for school administrators and origin district for district coordinators. An ICT Technical Officer can claim only an unassigned eligible ticket for themself. The database's unique `(ticket_id, active_record_key)` index remains the concurrency barrier for one active owner.

Eligible assignment states are SUBMITTED, NEEDS_CLARIFICATION, and APPROVED_FOR_PICKUP. Reassignment closes the old interval and inserts a new interval in one Wappler transaction; release closes the active interval and returns the work to the unassigned queue. All four actions are audited with safe summaries. Assignment history is returned newest first by ticket detail. No auto-assignment, assignment-triggered status transition, device mutation, or custody event is performed.

## Phase 6E Operational Reporting

Phase 6E adds two read-only SQL views: `v_ticket_operational_metrics` (one row per ticket) and `v_ticket_activity` (a unified, newest-first source for status, diagnosis, clarification, district-approval, and assignment events). The metrics view derives ticket age, current-status age, active-assignment age, time to first diagnosis, and time to first pickup approval in minutes. Impossible negative elapsed values are `NULL`; missing milestone timestamps remain `NULL`. Terminal-ticket age uses `closed_at` when recorded and otherwise the current database time without writing a synthetic close timestamp. Calculations use the database/server timezone; displayed timestamps use the existing App Connect date formatting convention.

The dashboard and operational report use the ticket's historical origin district/school, never the device's current custody. Optional date, location, status, and requester filters only narrow the caller's origin scope. No applicable active scope yields no ticket data. The dashboard shows ticket aging buckets (`<24 hours`, `1–3 days`, `4–7 days`, `>7 days`) for non-terminal tickets; these are descriptive age bands, not SLA thresholds. Status breakdowns display active catalogue statuses, including zero-count statuses. Workload counts use only active assignments on non-terminal tickets. Diagnosis and approval averages exclude records without those milestone timestamps and are factual elapsed-time metrics, not SLA response/resolution measures.

`tickets.dashboard` and `tickets.report` are granted only to SUPER_ADMIN, MOE_HEAD_OFFICE, ICT_DISTRICT_COORDINATOR, SCHOOL_ADMINISTRATOR, and TSTT_OVERSIGHT. TSTT oversight is read-only. ICT_TECHNICAL_OFFICER, REPAIR_CENTRE, and TTPOST_LOGISTICS do not receive these managerial reporting permissions. The dashboard contains no mutation controls. Operational report results omit requester contact details, student profile data, diagnosis text, clarification text, and assignment reasons. Activity output omits diagnosis and clarification text and assignment end reasons; authorized detailed history remains on the ticket detail page.

Phase 6E adds no ticket status, operational table, workflow mutation, SLA threshold/breach logic, logistics or repair workflow, or export workflow. It does not mutate assignments, devices, custody, or tickets. Query plans and reconciliation findings are recorded in `docs/testing/phase-06e-dashboard-reporting-test-report.md`.
