# Phase 8C — Permanent Replacement Model

Phase 8C introduces permanent replacement as its own workflow. It does not reuse
manufacturer-return cases, ticket status, logistics status, device lifecycle, or
Phase 5 allocation rows as substitutes for replacement workflow state.

## Phase 8C-A Scope

This foundation pass adds:

- `permanent_replacement_cases`
- `permanent_replacement_statuses`
- `permanent_replacement_status_history`
- `device_replacements`
- replacement permissions
- `v_permanent_replacement_queue`
- start/list/detail/summary Server Connect actions
- queue and detail shell pages
- ticket/exception links
- `PERMANENT_REPLACEMENT_STARTED` ticket activity

It deliberately does not implement source selection, device creation, Phase 5
transfer, replacement acceptance, Phase 7F replacement dispatch, or temporary
spare/loan workflows.

## Entry Rule

A permanent replacement case may start only when the exception is
`REPLACEMENT_APPROVED` and no active permanent replacement case exists for that
exception.

Starting a case creates a replacement case with status `SELECTION_REQUIRED`.
It does not change:

- exception status
- ticket status
- logistics status
- original device lifecycle
- Phase 5 allocation or assignment history
- physical custody

## Statuses

The Phase 8C replacement workflow uses:

- `SELECTION_REQUIRED`
- `REPLACEMENT_SELECTED`
- `AWAITING_ACCEPTANCE`
- `COMPLETED`
- `CANCELLED`

`REPLACEMENT_SELECTED` and `AWAITING_ACCEPTANCE` are retained for later 8C
steps because selection and acceptance are separate business controls.

## Permissions

Permissions are action-oriented:

- `replacements.view`
- `replacements.start`
- `replacements.select`
- `replacements.accept`

`SUPER_ADMIN` receives all. `REPAIR_CENTRE` receives view/start/select/accept
within service-location scope. `MOE_HEAD_OFFICE`, `TSTT_OVERSIGHT`, and
`ICT_DISTRICT_COORDINATOR` receive view only according to national/district
scope. TTPost, school administrators, and technical officers receive no
replacement workflow mutation permissions.

## Phase 8C-B Source Selection

Phase 8C-B allows a Repair Centre user with `replacements.select` to select a
replacement source after a permanent replacement case is started. Source
selection changes only the replacement workflow state from `SELECTION_REQUIRED`
to `REPLACEMENT_SELECTED`.

Selection does not change:

- exception status
- ticket status
- logistics status
- original device lifecycle
- Phase 5 allocation or assignment history
- physical custody
- replacement device records
- `device_replacements` relationships

Supported source types in 8C-B:

- `MANUFACTURER_SUPPLIED`
- `EXISTING_INVENTORY`

The manufacturer-supplied source must be a staged unit from a completed
manufacturer return case for the same exception and the same Repair Centre. The
manufacturer outcome must be `REPLACEMENT_SUPPLIED`, the staged unit must have
been received, the staged serial must not already exist as a device, and no
active permanent replacement case may already have selected the staged unit.

Phase 8C-B2 added `device_stock_locations` and its current-location and
eligibility views (see [Repair Centre Stock Location Model](device-stock-location-model.md)).
The existing-inventory branch uses that physical stock model, not Phase 5 or
Phase 7 as a substitute for it. Its candidate view returns only `AVAILABLE`,
unassigned, unreserved devices actively `IN_STOCK` at the case's Repair Centre
without active logistics, manufacturer-return, repair, or prior consumption
conflicts. Phase 5 must be compatible: `CENTRAL` is allowed for any case,
`DISTRICT` only for the original device's district, and `SCHOOL` only for its
school. No temporary-loan model exists before Phase 8D, so a future loan
conflict is not yet applicable.

Selection is a transaction that serializes the case, candidate device, and
active stock row before assigning `DEVICE:<device_id>` as the unique active
selection key. It appends replacement status history and audit. The candidate
remains `AVAILABLE`, `IN_STOCK`, and physically at the Repair Centre, with an
active permanent-replacement reservation. Selection does not release stock,
change Phase 5, assign the device, or create a `device_replacements` row.
Those final acceptance steps belong to Phase 8C-C.

## Phase 8C-C Final Acceptance

`POST /api/permanent-replacements/accept` requires `replacements.accept` and
the user's scoped Repair Centre. It accepts only `REPLACEMENT_SELECTED` cases
whose exception is still `REPLACEMENT_APPROVED`. The Wappler Database
Transaction locks and revalidates the case, exception, ticket, logistics,
original device, and selected source. A duplicate or stale request returns 409.

For `MANUFACTURER_SUPPLIED`, acceptance validates the same-exception received
staged unit and its unique serial, resolves an active manufacturer catalogue
model if necessary, creates a new device, and inserts a unique row in
`manufacturer_supplied_unit_acceptances`. The staged record remains intact.
For `EXISTING_INVENTORY`, acceptance rechecks the active `IN_STOCK` row,
reservation, Repair Centre, `AVAILABLE` lifecycle, Phase 5 compatibility, and
competing workflows, then closes the stock row without creating a device.

The transfer follows the original device's current Phase 5 hierarchy. A
student assignment closes on the original and opens for the same student on
the replacement; the parent school and district history on the original stays
intact. School and district transfers close only the corresponding current
level on the original. `permanent_replacement_allocation_transfers` records a
unique per-case snapshot of old and new allocation IDs and the transferred
level. Student replacements become `ASSIGNED`; other levels remain
`AVAILABLE`. Only after the transfer validates does the original become
`REPLACED` and `device_replacements` link the two devices.

The same transaction completes the replacement case and exception, sets the
ticket to `COMPLETED` (not `RETURNED`), sets logistics to `READY_FOR_RETURN`,
clears active case and source reservations, and appends status histories and
audit. The Ticket Activity read model derives one
`PERMANENT_REPLACEMENT_COMPLETED` event from the completed case.

`v_logistics_return_device` is the authoritative replacement-aware return
identity: after acceptance, the return unit is the replacement device, while
the original remains separately identified as manufacturer-retained or at the
Repair Centre pending disposition. Permanent Replacement Detail and Logistics
Detail expose that identity. At the end of Phase 8C-C, the existing Phase 7F
dispatch action rejected completed replacement cases; Phase 8C-D integrates
them into that same return journey as described below.

## Activity

The ticket activity read model exposes privacy-safe permanent replacement
activities:

- `PERMANENT_REPLACEMENT_STARTED`
- `PERMANENT_REPLACEMENT_SELECTED`
- `PERMANENT_REPLACEMENT_COMPLETED`

The activity includes the replacement number as the reference and does not
expose staged serial details, financial data, manufacturer notes, or student
private data.

## Phase 8C-D - Phase 7F / Read Model / UI Integration

### Prior Return-Device Derivation

Before this integration, Phase 7F handoff actions read the logistics case's
`device_id`, which is the original ticket device. The return queue and physical
custody views likewise followed that original identity. Phase 8C-C guarded the
dispatch action by rejecting completed replacement cases, leaving their normal
return journey unavailable. This phase retains `tickets.device_id` and
`ticket_logistics_cases.device_id` as historical original-device references.

### Effective Device

`database/phase_08c_d_effective_return_device.sql` defines
`v_ticket_effective_device`. It returns the original and effective device IDs,
`ORIGINAL_DEVICE` or `PERMANENT_REPLACEMENT` source, replacement case/number,
and completion time for each logistics case. When there is a completed
replacement, it uses its `replacement_device_id`; otherwise it uses the
original logistics device. If multiple completed cases ever exist, the latest
`completed_at`, then highest case ID, wins deterministically. A malformed
completed case with no replacement is surfaced as a NULL effective ID for
consistency detection; it does not silently fall back to the original.

`v_logistics_return_device`, `v_logistics_current_context`, and the Phase 7F
physical-custody views consume this read model. The active return queue and
detail screens identify the replacement as the operational asset and label the
original separately. `logistics_handoffs.device_id` records the derived
effective device for new return handoffs; earlier handoffs retain their
historical NULL. The server derives this ID and rejects any supplied
`device_id` that differs with HTTP 409. Downstream actions verify the handoff
ID against the current effective device.

### Existing Return Journey

Completed replacements reuse the normal Phase 7F Repair Centre dispatch,
TTPost receipt, TTPost School dispatch, and School receipt actions. The
dispatch gate requires a completed replacement exception, a `COMPLETED`
ticket, `READY_FOR_RETURN` logistics, an existing replacement device, and a
School in the replacement's active Phase 5 allocation. The School destination
is derived from that allocation, not the historical pickup School or browser.
No destination is invented for `CENTRAL` or `DISTRICT` allocations without an
active School: they remain `READY_FOR_RETURN`, with dispatch safely ineligible
until an approved destination workflow exists. This phase does not add a
district/central return workflow or modify Phase 5 to create a destination.

Return handoffs update ticket/logistics status and the effective device's
physical custody through the existing Phase 7F model. They do not modify the
completed replacement case, relationship, transferred Phase 5 allocation,
replacement lifecycle, or original `REPLACED` lifecycle. School receipt sets
the ticket to `RETURNED` and logistics to `RETURNED_TO_SCHOOL`; a student-level
replacement stays `ASSIGNED`, and a school-level replacement stays
`AVAILABLE`. Original physical disposition remains separate:
`MANUFACTURER_RETAINED_REPLACED` or
`REPAIR_CENTRE_REPLACED_PENDING_DISPOSITION`.

Ticket, Logistics, Permanent Replacement, and Exception detail views expose
the original/replacement distinction and link to the existing Logistics Detail
for return actions. Ticket Activity continues using the established
chronological Phase 8C replacement and Phase 7F handoff events; the UI receives
server-formatted readable activity dates. Phase 7F permissions and existing
organisational scope remain authoritative. No Phase 8C-E or Phase 8D behavior
is introduced.

## Phase 8C-E - Final Regression / Closure

Phase 8C-E adds no runtime business behavior. The final regression completed
one previously started/selected manufacturer-supplied case (PR6) and one
previously started/selected existing-inventory case (PR2) through acceptance
and the four existing Phase 7F return actions. Their recorded start and
selection history establishes the earlier approved gates; this pass did not
create new cases or repeat those historical actions. Both tickets reached
`RETURNED` only on School receipt, with the replacement as the effective
device and the original still `REPLACED`.

Acceptance remains separate from Head Office's Phase 8A approval and from the
Phase 8B manufacturer-return cycle. Manufacturer acceptance consumes the
received staged unit by a unique acceptance row but retains its staged and
manufacturer histories. Inventory acceptance releases, rather than deletes,
the selected Repair Centre stock row. The Phase 5 transfer retains historical
allocation rows, closes the original allocation at the transferred level, and
opens the corresponding replacement allocation; parent levels remain where
the Phase 5 hierarchy requires them. Phase 7F return does not repeat that
transfer or alter either device's lifecycle.

The administrative-only `database/phase_08c_e_consistency.sql` documents the
final 17 integrity checks. It is not invoked by a runtime action. The final
Phase 8C-E test report records zero anomalies, role/scope regression, and the
prior Phase 8C-D concurrency/rollback evidence. No temporary user or trigger
is left active, and Phase 8D remains unstarted. Phase 8C is closed on the
documented command and GUI regression evidence.
