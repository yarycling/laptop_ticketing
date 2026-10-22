# Phase 7 Logistics Data Model

## Purpose

Phase 7 models physical device transport between a School, TTPost and a Repair Centre. It is a separate operational layer from device allocation and assignment.

## Allocation and Physical Logistics

Phase 5 allocation answers which District, School or Student the device is assigned to. Phase 7 handoffs record who physically has the device during transport and repair. A device can remain allocated to a School and Student while physically held by TTPost or a Repair Centre.

Logistics does not close or rewrite `device_district_allocations`, `device_school_allocations` or `device_student_assignments`. The Phase 5 `v_device_current_custody` view remains unchanged. Fields included from it in `v_logistics_current_context` are prefixed `allocation_` and represent allocation context, not physical custody.

## Ticket and Logistics Status

Ticket status remains the customer/support workflow. Logistics status describes the physical transport cycle. The two catalogues are separate; this foundation adds neither ticket statuses nor device lifecycle statuses. In particular, `IN_TRANSIT` is a ticket status, not a device lifecycle status.

## Logistics Case

`ticket_logistics_cases` represents one logistics cycle and references its ticket, device, pickup School, optional Repair Centre service location and current logistics status. Its current status pointer is a read-optimized value; every later status change must append a row in `logistics_status_history` in the same transaction.

`active_record_key = 1` with `closed_at IS NULL` represents an active case. Closing a case sets `closed_at` and nulls the key. MySQL's allowance of multiple NULL values in unique keys permits historical cases while the unique ticket/key and device/key constraints enforce at most one active case per ticket and device. Future case creation must validate `ticket.device_id = case.device_id` in application logic; the existing ticket schema does not provide a matching composite key, and no ticket architecture is altered here.

## Logistics Status Catalogue

`logistics_statuses` is a configurable VARCHAR-backed reference catalogue, not an ENUM:

| Code | Meaning | Terminal |
| --- | --- | --- |
| `REQUESTED` | Awaiting TTPost processing | No |
| `ACCEPTED` | TTPost accepted processing; possession is not implied | No |
| `OUTBOUND_IN_TRANSIT` | Device entered outbound physical transport | No |
| `AT_REPAIR_CENTRE` | Repair Centre physically received the device | No |
| `READY_FOR_RETURN` | Ready for return logistics | No |
| `RETURN_IN_TRANSIT` | Moving toward the School | No |
| `RETURNED_TO_SCHOOL` | Physical logistics cycle completed at School | Yes |
| `CANCELLED` | Cancelled before normal completion | Yes |

Future case creation must insert the initial `NULL → REQUESTED` status-history row in the same transaction as the case.

## Service Locations

`service_locations` stores operational locations such as TTPost hubs/offices and Repair Centres. It does not duplicate Schools, which are referenced directly through `schools.id`. `location_type` is VARCHAR; later application validation must ensure a selected Repair Centre has type `REPAIR_CENTRE`. No sample or production locations are seeded by this phase.

## Physical Handoffs

`logistics_handoffs` is append-oriented history: one row is one physical transfer leg. Supported future logical types are `SCHOOL_TO_TTPOST`, `TTPOST_TO_REPAIR_CENTRE`, `REPAIR_CENTRE_TO_TTPOST` and `TTPOST_TO_SCHOOL`. Their endpoint combinations and service-location types are application rules for a later phase, not database triggers.

At dispatch, `dispatched_at` and `dispatched_by_user_id` are populated, `received_at`/`received_by_user_id` remain NULL and `active_record_key = 1`. Receipt records the receiving actor and time and nulls `active_record_key`, retaining the completed handoff. The unique `(logistics_case_id, active_record_key)` key allows at most one pending handoff per case and multiple historical handoffs.

## Scan Evidence and QR Security

`logistics_handoff_scans` stores append-only dispatch/receive scan evidence and permits multiple scans for each handoff. Future scan types include `DISPATCH` and `RECEIVE`; methods may include `QR`, `MANUAL` and `SYSTEM`. A scan reference must never contain passwords, authentication secrets or raw secure tokens. If signed QR credentials are introduced, store only an appropriately designed non-secret reference/hash/identifier.

## Read Model and Deferred Work

`v_logistics_current_context` provides one row per logistics case, combining its ticket/device, pickup School/District, optional Repair Centre, logistics status, ticket status, pending handoff and clearly named Phase 5 allocation context. It is not a final physical-custody overlay. `v_device_physical_custody` is intentionally deferred until dispatch/receipt semantics have been implemented and proven.

No logistics permissions, APIs, Server Connect workflows, GUI, TTPost queue, notifications, triggers or runtime behavior are added in 7A.

## Phase 7B Pickup Requests and TTPost Queue

Pickup initiation is an explicit action after a ticket reaches `APPROVED_FOR_PICKUP`; district approval alone creates no logistics case. An authorized School or District requester can create one only for a ticket within its immutable origin scope. The server derives the device and pickup School from the ticket. A transaction inserts the case, finalizes its `LOG` number from the generated case ID, appends the initial `NULL → REQUESTED` history row, and records `logistics_pickup_requested`. Unique active-case keys on ticket and device are the concurrency barrier; duplicate or racing requests are rejected without success history or audit.

`REQUESTED` means a pickup request exists. `ACCEPTED` means TTPost accepted the request for processing; acceptance does not mean the device was collected or that custody changed. TTPost has a national operational queue through the logistics APIs and does not receive general ticket permission. Queue output is minimized to logistics, ticket, device and pickup-location identifiers/statuses; it excludes requester contact data, student information, diagnosis and clarification content. TTPost is not assigned as a case owner in 7B, and no service location is selected.

The `logistics.view`, `logistics.request_pickup` and `logistics.accept` permissions are mapped separately. School/District/MOE/TSTT users are restricted by active ticket-origin scope; TTPOST_LOGISTICS receives national queue visibility solely through the logistics APIs. A request or acceptance does not change ticket status, device lifecycle, Phase 5 allocations, custody, or assignment. 7B does not create handoffs or scans. The next phase boundary is physical handoff: only that workflow may record School-to-TTPost custody and transit state.

## Cross-Domain Ticket Activity

The existing `v_ticket_activity` read model is cross-domain and includes concise logistics events alongside ticket status, diagnosis, clarification, approval and assignment events. Phase 7B contributes `PICKUP_REQUESTED` from the initial `NULL → REQUESTED` row and `PICKUP_REQUEST_ACCEPTED` from the `REQUESTED → ACCEPTED` row in `logistics_status_history`; the history actor and microsecond-capable `changed_at` timestamp are retained, and the related `logistics_number` is exposed as the generic activity reference. No separate event is synthesized from `requested_at`, so a pickup request appears once. Logistics status remains a separate workflow from ticket status, and neither event implies physical pickup, transit or custody transfer. The timeline does not expose logistics free-text notes or requester contact/other PII.

## Future Transaction Boundaries

Later School-to-TTPost pickup processing must validate `APPROVED_FOR_PICKUP`, validate the active logistics case, create/complete the handoff and scan evidence, update logistics status and ticket status to `IN_TRANSIT`, and preserve Phase 5 allocation lineage in one transaction.

Later Repair Centre receipt must complete the TTPost-to-Repair Centre handoff, set logistics status to `AT_REPAIR_CENTRE`, ticket status to `UNDER_REPAIR` and device lifecycle to `IN_REPAIR` transactionally. Repair Centre receipt will own the `IN_REPAIR` transition. Neither transaction is implemented in 7A.

## Phase 7D TTPost-to-Repair Centre Handoff

Phase 7D adds a second physical handoff leg using the existing `logistics_handoffs` and `logistics_handoff_scans` tables. TTPost dispatch creates a pending `TTPOST_TO_REPAIR_CENTRE` row, sourced from the physically current TTPost location and destined for an active `REPAIR_CENTRE` service location. It records dispatch scan and audit evidence and sets `ticket_logistics_cases.repair_centre_location_id`; it does not change ticket status, logistics status, device lifecycle, allocation, or ticket ownership. The read model reports `PENDING_REPAIR_CENTRE_RECEIPT`; it does not claim the Repair Centre has custody.

Repair Centre permissions answer what an operator may do; `user_service_location_scopes` limits which active Repair Centre they may operate at. A scoped Repair Centre user sees only a case whose pending handoff destination or confirmed physical Repair Centre location matches their active scope. The role does not grant general `tickets.view`. TTPost remains nationally visible and does not require a TTPost location scope.

Repair Centre receipt is a separate, scoped confirmation. One Server Connect transaction completes the pending handoff, inserts a manual RECEIVE scan, changes logistics `OUTBOUND_IN_TRANSIT → AT_REPAIR_CENTRE` and ticket `IN_TRANSIT → UNDER_REPAIR` with their respective history rows, sets device lifecycle to existing `IN_REPAIR`, and writes the receive audit. Receipt is the only 7D action that makes these status/lifecycle changes. Phase 5 district/school/student allocation and Phase 6 ticket work ownership are unchanged. Any failure rolls back all these writes.

The extended `v_logistics_physical_custody` preserves `AWAITING_SCHOOL_HANDOFF`, `PENDING_TTPOST_RECEIPT`, and `TTPOST_CUSTODY`, and adds `PENDING_REPAIR_CENTRE_RECEIPT` and `REPAIR_CENTRE_CUSTODY`. The pending transit leg has no current physical location until independent receipt. `v_ticket_activity` includes `REPAIR_HANDOFF_DISPATCHED`, `REPAIR_CENTRE_DEVICE_RECEIVED`, and `ARRIVED_AT_REPAIR_CENTRE`; the separate ticket status history continues to show `IN_TRANSIT → UNDER_REPAIR`. The activity read model exposes only actor/time and logistics number, not scan/tracking references or student/requester/diagnosis/clarification data.

Phase 7D ends at repair-centre receipt and entry to `UNDER_REPAIR`. Repair diagnosis, technician ownership, parts, repair actions, completion, QA, return logistics, replacement, notifications, and SLA escalation are not implemented.

## Phase 7E Repair Processing

Phase 7E adds one `repair_jobs` row per logistics case after confirmed Repair Centre custody. Starting a repair does not change the ticket, logistics, physical custody, device lifecycle, Phase 5 allocation or Phase 6 ticket work owner. The unique logistics-case key is the database concurrency barrier. Repair Centre actions require both a repair permission and an active `user_service_location_scopes` assignment for the case's Repair Centre; `SUPER_ADMIN` retains the existing bypass.

`repair_assessments` and `repair_work_logs` are append-only records with server timestamps and authenticated actors. Assessment and work narratives remain in the Repair Centre operational detail. Ticket activity and generic audit descriptions contain only the event, actor/time and safe reference, never the narratives or completion summary. `repair_outcomes` is a reference table (not an ENUM): `REPAIRED_SUCCESSFULLY` and `NO_FAULT_FOUND` are return-ready; `UNABLE_TO_REPAIR`, `MANUFACTURER_RETURN_REQUIRED` and `REPLACEMENT_REQUIRED` record a disposition requiring a future workflow.

Return-ready completion is a single Server Connect transaction. It completes the repair job; derives device lifecycle from the live `v_device_current_custody` allocation (`STUDENT` becomes `ASSIGNED`, other recognized allocation levels become `AVAILABLE`); changes logistics `AT_REPAIR_CENTRE → READY_FOR_RETURN` with logistics history; changes ticket `UNDER_REPAIR → COMPLETED` with ticket history; and writes one success audit. An inconsistent allocation or any write failure rolls back the transaction. Phase 5 allocations and ticket work ownership are not updated. `COMPLETED` here means repair processing completed, not that the device was returned or the ticket's later return journey finished.

Non-return-ready completion records the outcome and summary on the repair job and writes `repair_disposition_recorded`; it intentionally leaves the ticket `UNDER_REPAIR`, logistics `AT_REPAIR_CENTRE`, device lifecycle `IN_REPAIR`, and physical custody at the Repair Centre. Manufacturer return, replacement, parts, QA, and return-logistics workflows remain deferred. `READY_FOR_RETURN` does not create a `REPAIR_CENTRE_TO_TTPOST` handoff or dispatch scan. The physical custody read model continues to report `REPAIR_CENTRE_CUSTODY` while logistics is `READY_FOR_RETURN`.

`v_repair_current_context` derives `AWAITING_REPAIR_START`, `IN_PROGRESS`, `READY_FOR_RETURN` or `DISPOSITION_RECORDED` from the physical/logistics context and repair job/outcome. The existing `v_ticket_activity` is extended with `REPAIR_STARTED`, `REPAIR_ASSESSMENT_RECORDED`, `REPAIR_WORK_RECORDED`, `REPAIR_COMPLETED`, `REPAIR_DISPOSITION_RECORDED` and logistics `READY_FOR_RETURN`; ticket status history independently records `UNDER_REPAIR → COMPLETED` for return-ready outcomes. The Ticket and Logistics details expose only repair state, outcome, Repair Centre and timestamps; the Repairs detail is the authoritative protected view for internal assessment/work text.

Transaction boundaries are: start + `repair_started` audit; assessment + `repair_assessment_recorded` audit; work record + `repair_work_recorded` audit; return-ready job/logistics/ticket/device/history/audit as one transaction; or non-return-ready job + disposition audit as one transaction. No Phase 7F return behavior is implemented.

## Phase 7F Repair Centre-to-School Return Logistics

Phase 7F uses the existing `REPAIR_CENTRE_TO_TTPOST` and `TTPOST_TO_SCHOOL` handoff types, `logistics_handoffs`, scan evidence, and status catalogues. It adds no status, lifecycle, allocation, history-table, or trigger concepts. Return processing has two independent custody confirmations: the Repair Centre dispatches to TTPost, then TTPost confirms receipt; TTPost separately dispatches to the case's immutable origin School, then that School confirms receipt.

The return transitions are deliberately receipt-gated. Repair Centre dispatch leaves ticket `COMPLETED` and logistics `READY_FOR_RETURN`, with physical state `PENDING_TTPOST_RETURN_RECEIPT`. TTPost receipt changes logistics to `RETURN_IN_TRANSIT` while ticket remains `COMPLETED`, yielding `TTPOST_RETURN_CUSTODY`. TTPost-to-School dispatch records a pending handoff without claiming School receipt. Only School receipt changes logistics to `RETURNED_TO_SCHOOL`, closes the case, and changes ticket `COMPLETED → RETURNED`. Device lifecycle, Phase 5 allocation, and Phase 6 ticket work ownership are unchanged.

The active-only `v_logistics_physical_custody` remains an active-case operational read model. It adds `PENDING_TTPOST_RETURN_RECEIPT`, `TTPOST_RETURN_CUSTODY`, and `PENDING_SCHOOL_RETURN_RECEIPT`; closed final return state is derived from `RETURNED_TO_SCHOOL` plus the completed `TTPOST_TO_SCHOOL` handoff. `v_logistics_case_detail_context` is the historical-capable detail source. The `/logistics` list and summary remain active-queue views; completed return cases remain visible through Ticket Detail, Logistics Detail, and Ticket Activity.

Four action-specific permissions govern the handoffs: `logistics.return_dispatch` (Repair Centre and SUPER_ADMIN), `logistics.return_ttpost_receive` and `logistics.return_school_dispatch` (TTPOST_LOGISTICS and SUPER_ADMIN), and `logistics.return_school_receive` (School Administrator, ICT Technical Officer, and SUPER_ADMIN). Repair Centre dispatch additionally requires an active matching service-location scope; School receipt derives its destination from the logistics case and checks the actor's School/District/national scope. TTPost return-location options expose active TTPost locations only. These permissions do not grant TTPost `tickets.view`.

The existing `v_ticket_activity` gains the six return events `RETURN_HANDOFF_DISPATCHED`, `RETURN_TTPOST_DEVICE_RECEIVED`, `RETURN_TRANSIT_STARTED`, `SCHOOL_RETURN_HANDOFF_DISPATCHED`, `SCHOOL_RETURN_DEVICE_RECEIVED`, and `RETURNED_TO_SCHOOL`. Ticket status history independently records `COMPLETED → RETURNED`. Same-time ordering uses a read-model sort key, preserving stored microsecond timestamps. Activity exposes actor, time, and logistics number, not scan/tracking values or operational narratives. Logistics Detail displays the four-leg physical handoff chain with endpoints, actors, and readable dispatch/receipt times; tracking and scan references are omitted.

Phase 7F does not implement manufacturer return, replacement, parts, QA, or notifications.

## Phase 7G Integrated Regression and Closure

The completed normal-return lifecycle is:

`APPROVED_FOR_PICKUP` ticket and existing Phase 5 allocation → pickup request (`REQUESTED`) → TTPost acceptance (`ACCEPTED`) → School dispatch and TTPost receipt (`OUTBOUND_IN_TRANSIT`) → TTPost dispatch and Repair Centre receipt (`AT_REPAIR_CENTRE`, ticket `UNDER_REPAIR`, device `IN_REPAIR`) → repair processing → return-ready completion (`READY_FOR_RETURN`, ticket `COMPLETED`) → Repair Centre dispatch and TTPost receipt (`RETURN_IN_TRANSIT`) → TTPost dispatch and School receipt (`RETURNED_TO_SCHOOL`, ticket `RETURNED`, case closed).

The four physical legs remain independent, receipt-confirmed handoffs: `SCHOOL_TO_TTPOST`, `TTPOST_TO_REPAIR_CENTRE`, `REPAIR_CENTRE_TO_TTPOST`, and `TTPOST_TO_SCHOOL`. Each leg records a dispatch and a separate receipt scan. Transport and repair do not rewrite Phase 5 district/school/student allocations or Phase 6 ticket work ownership. A student-held device returns from `IN_REPAIR` to `ASSIGNED`; a non-student allocation returns to `AVAILABLE` according to the existing allocation context. Ticket status, logistics status, physical custody, device lifecycle, educational allocation, work ownership, and repair state remain distinct domains.

The final `v_ticket_activity` read model includes the Phase 7B `PICKUP_REQUESTED` and `PICKUP_REQUEST_ACCEPTED` events as well as the Phase 7C–7F handoff, repair, and return events. Later view replacements had dropped the two pickup-request events; the forward-only, rerunnable `database/phase_07g_ticket_activity_pickup_events.sql` restores them without changing workflow state or adding a catalogue value. Activity remains newest-first and omits requester contact data, student names, repair narratives, tracking references, and scan references.

Phase 7G performed an integrated runtime journey and cross-domain consistency review. The final acceptance evidence is recorded in `docs/testing/phase-07-final-regression-closure-report.md`. No post-Phase-7 functionality is implied by this closure.
