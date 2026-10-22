# Phase 8D-A: Temporary Loan Foundation

Phase 8D-A records a request and District decision only. It does not select, reserve, issue, return, or convert a spare. The original device remains the Phase 5 educationally allocated device. The `TEMPORARY_LOAN` device lifecycle code is seeded for later issuance but is not assigned by this phase.

## Data model

- `spare_pools`: logical pool at an active Repair Centre `service_locations` row. `active_default_key` and a unique `(service_location_id, active_default_key)` key permit at most one active default pool per location. The initial pool is `RC8-DEFAULT` at service location 8. A pool does not own or duplicate device assets; Phase 8D-B must derive candidates from `devices` and `device_stock_locations`.
- `temporary_loan_statuses`: `PENDING_DISTRICT_APPROVAL`, `AUTHORIZED`, `REJECTED`, `CANCELLED`.
- `temporary_loan_cases`: server-derived ticket, original device, origin district/school, repair job/location, and default pool. The unique `(ticket_id, original_device_id, active_record_key)` key limits active cases to one per pair. Rejected/closed cases clear the active key. The schema prohibits a selected device, issue, return, or conversion field being populated in 8D-A.
- `temporary_loan_status_history`: append-only status transitions; the request and District decision write here in the same transaction as the case update and audit.
- `temporary_loan_decisions`: one immutable approve/reject decision per case, with actor, timestamp, and note. A rejected case is closed; an authorized case remains active for later phases.
- `v_temporary_loan_request_context`: eligibility from the active ticket/logistics/repair context and original lifecycle. It supports local repair and manufacturer-return unavailability, excludes completed permanent replacements and existing active loans, and requires an active default pool at the Repair Centre.
- `v_temporary_loan_queue`: safe scoped read model without student names, financial data, or private contact details.
- `v_ticket_activity_08d_a`: layers high-level request/authorize/reject/cancel status-history events on the existing ticket activity view. It exposes only the loan number, actor, and timestamp, not notes.

## Permissions and scope

`temporary_loans.view`, `.request`, `.authorize`, and `.cancel` are seeded. `SUPER_ADMIN` has all; `REPAIR_CENTRE` has view/request within its service location; `ICT_DISTRICT_COORDINATOR` has view/authorize within the origin district; `MOE_HEAD_OFFICE` and `TSTT_OVERSIGHT` have read-only national access. TTPost, School, and Technical Officer roles have no 8D-A management access. Every API checks server-side permission and scope; frontend visibility is only a usability layer.

Request accepts only a ticket ID and optional note. District decision accepts only the loan ID, `APPROVE` or `REJECT`, and a note (mandatory on rejection). District, school, original device, Repair Centre, and pool are never trusted from the client. The transaction updates the loan, writes history/decision and safe audit; a failed write rolls the transaction back.

Cancellation is not exposed in 8D-A: there is no confirmed business need or authorized cancellation owner yet. The `CANCELLED` status and `temporary_loans.cancel` permission are reserved, with the permission granted only to `SUPER_ADMIN`; no endpoint or button exists. This requires a business decision before activation.

## Phase 8D-B: spare selection and issue

8D-B adds the controlled lifecycle `AUTHORIZED → SPARE_SELECTED → ACTIVE_LOAN`.
The repeatable migration `database/phase_08d_b_spare_selection_issue.sql`
extends the 8D-A status constraints, creates an exclusive active reservation
table and an independent temporary-loan custody history, grants only the
Repair Centre and Super Admin mutation permissions, and adds candidate,
queue, and activity read models.

`v_temporary_loan_spare_candidates` reuses `devices`,
`device_stock_locations`, and `v_device_stock_queue`. It requires an active
default pool at the loan's active Repair Centre and filters to `AVAILABLE`,
centrally allocated, active `IN_STOCK` devices at that same location. It
excludes the original device, active replacement reservations/consumption,
active temporary-loan reservations, student assignments, and logistics,
manufacturer-return, and repair conflicts. It does not copy devices into a
separate inventory.

`/api/temporary-loans/spare-options` returns only safe eligible-device fields.
`/api/temporary-loans/select-spare` revalidates in a Wappler transaction and
creates one exclusive reservation. Selection leaves the device `AVAILABLE`
and the active stock row `IN_STOCK`; it does not change Phase 5 allocation or
the original device, ticket, logistics, repair, manufacturer-return, or
permanent-replacement state. The unique active-device reservation key and
conditional case update make competing selections fail closed.

`/api/temporary-loans/issue` revalidates the active reservation, candidate,
location, lifecycle, stock, and workflow conflicts in one Wappler transaction.
It consumes the reservation, releases the stock row, changes only the spare's
lifecycle to `TEMPORARY_LOAN`, records the issue actor/time, moves the loan to
`ACTIVE_LOAN`, and adds a `REPAIR_CENTRE_STOCK → TEMPORARY_LOAN_ISSUED` custody
event, status history, and audit entry. It does not claim school receipt or
TTPost custody and does not create a Phase 7 transport. The original remains
the Phase 5 asset.

`v_ticket_activity_08d_b` layers `TEMPORARY_SPARE_SELECTED` and
`TEMPORARY_LOAN_ISSUED` onto the existing activity read model. Detail/list
surfaces show selected device, lifecycle, free-stock state, reservation,
issue time, and temporary-loan custody. The detail actions are displayed from
permission capabilities and the authorized status only.

## Phase 8D-C: temporary-loan return and reclaim

8D-C adds `ACTIVE_LOAN → RETURN_REQUIRED → RETURNED`. The repeatable
`database/phase_08d_c_temporary_loan_return_reclaim.sql` migration adds the
return actor/timestamp/reason/note/condition fields, the terminal `RETURNED`
state, the nonterminal `RETURN_REQUIRED` state, and controlled return-reason
and return-condition lookup tables. `OTHER` requires nonblank notes. Only
`SERVICEABLE` is accepted for normal reclaim; damaged, lost, stolen, or
unverified conditions remain outside this phase.

`/api/temporary-loans/request-return` is available to scoped Repair Centre
users and Super Admin. Its Wappler transaction conditionally moves an active
loan to `RETURN_REQUIRED` and appends status history, a distinct
`TEMPORARY_LOAN_RETURN_REQUIRED` custody event, and an audit entry. It leaves
the spare `TEMPORARY_LOAN`, out of free stock, and physically outstanding.
Return notes are not copied to the ticket activity read model.

`/api/temporary-loans/reclaim` accepts only the loan ID and a `SERVICEABLE`
condition. The server derives the selected spare and Repair Centre from the
loan. Its transaction conditionally restores the spare lifecycle to
`AVAILABLE`, creates a new active `IN_STOCK` row at that loan's service
location, closes the loan as `RETURNED`, and appends custody, status, and audit
history. It does not reactivate the released stock row and does not change
Phase 5 allocation, the original device, ticket, logistics, repair, exception,
manufacturer-return, or replacement records. The unique active stock key,
conditional lifecycle/case updates, and transaction rollback protect duplicate
reclaims.

`v_temporary_loan_queue` includes the return dates, reason, condition, stock
location, and latest physical custody. `v_ticket_activity_08d_b` adds
`TEMPORARY_LOAN_RETURN_REQUIRED` and `TEMPORARY_LOAN_RETURNED`; it exposes no
private return notes. The loan detail/list and ticket detail identify the
temporary spare separately from the original educational asset.

Conversion markers and existing permanent-replacement relationships block
return/reclaim. No conversion behavior, Phase 5 transfer, TTPost/school
transport, or Phase 7 handoff is implemented in 8D-C. Only `SUPER_ADMIN` and
`REPAIR_CENTRE` receive the two mutation permissions; each Repair Centre
mutation also requires the loan's service-location scope.

## Phase 8D-D: Head Office conversion to permanent replacement

8D-D permits an issued `ACTIVE_LOAN` to be recommended by its scoped Repair
Centre and converted only by `MOE_HEAD_OFFICE` or `SUPER_ADMIN`. The transition
is `ACTIVE_LOAN → CONVERSION_PENDING_HEAD_OFFICE → CONVERTED_PERMANENT`; a
rejection returns to `ACTIVE_LOAN` and remains nonterminal. The repeatable
`database/phase_08d_d_temporary_loan_permanent_conversion.sql` migration adds
controlled conversion statuses/reasons, conversion request records and
immutable decision/status history, and the request-time Phase 5 allocation snapshot used to reject stale
approvals. It minimally extends the existing Phase 8C
`permanent_replacement_cases` / `device_replacements` model with a nullable
`temporary_loan_case_id`, allows the legitimate conversion source, and makes
the 8A exception link nullable for this path rather than fabricating an
exception. `v_permanent_replacement_queue` and
`v_ticket_activity_08d_b` expose the replacement link and safe activity.

`/api/temporary-loans/request-conversion` derives the loan, original/spare,
scope, and Phase 5 context server-side. A Wappler transaction records the
pending request and status/audit/activity history without changing device
lifecycle, stock, Phase 5, or the outer ticket/logistics/repair/manufacturer
state. `/api/temporary-loans/conversion-decide` permits only Head Office or
Super Admin. Approval locks and revalidates the request, loan, devices,
allocation snapshot, stock, and conflicting replacement state, then performs
the existing Phase 5 transfer and permanent-replacement relationship/case
completion atomically. It links the already-issued spare; it does not create a
device. The original becomes `REPLACED`, while the spare lifecycle follows the
transferred allocation. Custody records `CONVERTED_TO_PERMANENT` from the loan
recipient state. Rejection records the decision and returns the loan to
`ACTIVE_LOAN` without replacement or Phase 5 writes.

Conversion does not create Repair Centre stock: the spare is already issued
and out with the temporary-loan recipient, so it has no active free-stock row
before or after conversion. A Phase 7 return is not fabricated: no device was
shipped back to the Repair Centre, dispatched by TTPost, or received again by
the school.

## Phase 8D-E: final fulfillment integration

`TEMPORARY_LOAN_CONVERSION` is a distinct fulfillment route. The replacement
is already with the recipient, so successful conversion closes the ticket as
`RETURNED` and logistics as the terminal `FULFILLED_AT_RECIPIENT`. This state
is not `RETURNED_TO_SCHOOL`, and it does not create a Phase 7F handoff, scan,
receipt, stock movement, or duplicate custody event. Ordinary temporary-loan
returns continue to use `RETURNED` and restore serviceable spares to
`AVAILABLE` / `IN_STOCK` at Repair Centre stock. Standard Phase 8C
`MANUFACTURER_SUPPLIED` and `EXISTING_INVENTORY` replacements retain the
normal `READY_FOR_RETURN` → Phase 7F → `RETURNED_TO_SCHOOL` route.

The ticket's original device remains historical. The effective-device view
resolves the completed conversion PR and spare as the current permanent
replacement, with source `TEMPORARY_LOAN_CONVERSION` and the TL/PR references.
The conversion custody history resolves to `WITH_RECIPIENT`; the original
device's repair/manufacturer context remains separate. A bounded, rerunnable
reconciliation updates only completed conversion cases whose original is
`REPLACED` and whose outer states still match `UNDER_REPAIR` /
`AT_REPAIR_CENTRE`. Future approvals perform the same ticket/logistics updates
inside the existing conversion transaction.

The implementation migration is `database/phase_08d_e_final_integration.sql`.
The updated effective-device and physical-custody view definitions remain in
`database/phase_08c_d_effective_return_device.sql` and
`database/phase_07f_logistics_physical_custody_view.sql`.
