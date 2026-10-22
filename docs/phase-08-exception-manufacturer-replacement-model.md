# Phase 8 Exception, Manufacturer, and Replacement Model

## Phase Boundaries

Phase 8A adds exception disposition review after a completed repair that cannot
follow the normal return-ready path. It records technical recommendation,
financial and warranty assessment, approval decisions, and append-only history.
It does not execute a manufacturer shipment, select or assign a replacement
device, issue a temporary loan, or collect payment.

Phase 8B owns manufacturer return/RMA processing and carrier movements. Phase
8C owns replacement device creation and permanent assignment. Phase 8D owns
temporary spare/loan issuance and spare-pool inventory. A manufacturer does not
receive a portal account.

## 8A Case and State Model

Each completed non-return repair job has at most one `repair_exception_cases`
row, enforced by a unique key on `repair_job_id`. The case links its ticket,
logistics case, repair job, device, and originating repair outcome. The current
case status and recommended disposition are read from the case; append-only
status history and decisions retain prior actions.

Initial routing is:

| Repair outcome | Initial status | Initial recommendation |
| --- | --- | --- |
| `MANUFACTURER_RETURN_REQUIRED` | `ASSESSMENT_REQUIRED` | `MANUFACTURER_RETURN` |
| `REPLACEMENT_REQUIRED` | `ASSESSMENT_REQUIRED` | `PERMANENT_REPLACEMENT` |
| `UNABLE_TO_REPAIR` | `ASSESSMENT_REQUIRED` | None; District must decide |

Repair Centre assessment submission routes the first two outcomes to District
manufacturer-return approval or Head Office replacement approval respectively;
`UNABLE_TO_REPAIR` routes to District disposition decision. District can approve
a manufacturer return, select manufacturer return or permanent replacement for
an unable-to-repair case, or return a case for Repair Centre review. A District
replacement selection requires a separate Head Office approval. Head Office
approval does not create, select, or assign a replacement device.

Returning for review changes the current status to
`REPAIR_CENTRE_REVIEW_REQUIRED` and preserves all assessments and decisions.
Repair Centre must record a new assessment revision before resubmission.

## Operational State Invariants

While Phase 8A is processing a case, the outer operational state remains:

- Ticket: `UNDER_REPAIR`
- Logistics: `AT_REPAIR_CENTRE`
- Physical custody: `REPAIR_CENTRE_CUSTODY`
- Device lifecycle: `IN_REPAIR`
- Phase 5 allocation and Phase 6 work ownership: unchanged

The individual Server Connect actions validate these states before writing.
State-changing workflows use transactions and compare-and-set status updates.

## Assessment and Privacy

`exception_financial_assessments` is append-only and uses `DECIMAL(12,2)` for
cost values. Catalogues constrain warranty decision, responsibility party,
negligence/misuse determination, financial status, disposition, and decision
type. A `NOT_COVERED` warranty assessment requires a rejection reason. Assessment
notes remain in the case detail, not generic Ticket Activity or audit
descriptions. No payment, invoice, receipting, or accounts-receivable workflow is
part of 8A.

Ticket Activity contains only the safe high-level event code, timestamp, and
actor. It does not include costs, assessment notes/reference, warranty rejection
reason, responsibility party, or negligence narrative.

## Permissions and Scope

`SUPER_ADMIN` receives the five 8A permissions. `REPAIR_CENTRE` receives view,
assess, and submit; its cases are restricted to assigned service locations.
`ICT_DISTRICT_COORDINATOR` receives view and District decision within the
ticket's origin District. `MOE_HEAD_OFFICE` receives view and replacement
approval within national scope. `TSTT_OVERSIGHT` is read-only. School,
technical-officer, and TTPost roles receive no 8A permission. Server Connect
guards enforce these permissions; navigation hiding is only presentation.

## Data Objects and APIs

The schema uses `repair_exception_cases`, `exception_case_status_history`,
`exception_financial_assessments`, `exception_decisions`, and lookup tables with
foreign keys. The Wappler APIs are `/api/exceptions/list`, `/summary`, `/detail`,
`/assessment/create`, `/submit`, `/district/decide`, and
`/head-office/decide`. There is no generic exception-status endpoint.

Repair completion creates the case and initial history inside the existing
Phase 7E completion transaction for non-return outcomes only. Normal
`REPAIRED_SUCCESSFULLY` and `NO_FAULT_FOUND` behavior is unchanged. Historical
completed non-return jobs are backfilled at `ASSESSMENT_REQUIRED`, preserving
their completion time/actor without fabricating an approval or altering outer
state.

## Later Phase Ownership

- **8B:** RMA/manufacturer-return records, carrier selection (TTPost by default
  but not exclusive), dispatch, tracking, manufacturer communication, and
  return logistics. Manufacturer sites are not service locations.
- **8C:** Create a distinct replacement device identity and record formal
  acceptance/permanent assignment. The original device becomes `REPLACED` only
  at the approved replacement execution point.
- **8D:** District-approved temporary loans, location-based spare pools, loan
  return, and spare-to-permanent conversion subject to Head Office approval.

These later-phase objects and execution controls are intentionally absent from
8A.

## Phase 8B Implementation Boundary (2026-10-13)

Phase 8B implementation completion is in place; command and GUI acceptance
remain open. `carriers` is a separate directory with an active-default
uniqueness key and an idempotently seeded TTPost default.
`manufacturer_return_cases` records one active cycle per exception and derives
its internal `MFR` number from the database-generated case ID. Separate status
history, outbound/return shipment, outcome, and staged manufacturer-supplied
unit tables keep manufacturer processing separate from Phase 7 logistics and
active `devices` records.

Wappler Server Connect workflow actions cover cycle start, outbound
preparation, TTPost and external outbound pickup, manufacturer acknowledgement,
outcome recording/staged replacement capture, return preparation, TTPost and
external return pickup, final Repair Centre receipt, carrier options, scoped
queue/summary/detail/history reads, outcome options, and carrier administration.
Multi-row state transitions use Wappler Database Transactions and safe catches.
Shipment carrier selections are independent. The original device only changes
to `MANUFACTURER_RETURN` on physical outbound pickup. Replacement-supplied units
remain outside `devices`.

The derived `v_manufacturer_return_physical_custody` and
`v_manufacturer_return_queue` views keep manufacturer custody distinct from
Phase 7 logistics custody. Manufacturer state takes precedence while the
manufacturer cycle is active. Ticket Activity includes safe high-level
manufacturer events without RMA, tracking, shipment references, internal notes,
replacement serials, financial data, or requester/student details. Ticket,
Exception, Repair, and Logistics screens show scoped high-level context; deeper
operational references remain in Manufacturer Return Detail. The Phase 7F
dispatch action accepts a completed `REPAIRED_ORIGINAL` manufacturer outcome
under the existing state, scope, lifecycle, custody, and active-cycle guards.

Replacement-supplied units are staged only: the manufacturer-supplied unit
record does not create a `devices` row, asset tag, assignment, replacement
relationship, or Phase 5 transition. Those operations remain owned by Phase
8C. Temporary loans and spare-pool workflows remain owned by Phase 8D.

Static validation and bounded port-3000 smoke checks are recorded in the
Phase 8B test report. The fixture-driven command acceptance matrix and GUI
acceptance have not been run; Phase 8B remains open pending those tests. Phase
8C and 8D remain not started.
