# AGENTS.md — TSTT / MoE Laptop Warranty & Repair Management Portal

## Purpose

This file defines the permanent development instructions for Codex and other coding agents working on the **TSTT / Ministry of Education Laptop Warranty & Repair Management Portal**.

These rules apply to the entire project unless a more specific nested `AGENTS.md` explicitly overrides them.

The solution is a purpose-built **device asset, warranty, ticketing, logistics, repair, SLA, reporting, and audit platform** for laptops issued under the Ministry of Education laptop programme.

The application must be materially better than the legacy solution. Do not simply reproduce the old generic ITSM interface. Preserve useful legacy capabilities while improving workflow control, data quality, chain of custody, reporting, role security, usability, auditability, and AI-assisted reporting.

---

# 1. Product Objectives

The platform must provide a reliable system of record for:

- laptop/device inventory,
- device age and warranty,
- school and district allocation,
- student/device assignment,
- ticket creation and management,
- primary diagnosis,
- Ministry approval for pickup,
- TTPost collection and return logistics,
- repair-centre intake and diagnosis,
- warranty determination,
- negligence/misuse handling,
- repair activity,
- spare parts usage,
- temporary spare devices,
- permanent replacement devices,
- return-to-factory cases,
- quality assurance,
- device return to school,
- SLA monitoring,
- notifications,
- operational reporting,
- management dashboards,
- full device history,
- full ticket history,
- chain-of-custody history,
- audit logging,
- AI-assisted reporting and decision support.

The **device is the central business entity**.

A user opening a device must be able to understand its complete lifecycle without searching multiple disconnected modules.

---

# 2. Business Source of Truth

The approved business process and requirements must be derived from the project's supplied documentation, including:

- `Laptop Warranty Logistic Plan - Final (2).pdf`
- `Laptop Portal - MoE Feedback Assessment - as of 10052026 based on development.docx`
- the project's fact-finding workbook and approved process-flow diagrams,
- approved GUI designs and bmobile brand references.

When implementation details conflict with the documented process:

1. do not silently guess,
2. identify the conflict,
3. preserve configurable architecture,
4. request a business decision where needed.

Do not hard-code an ambiguous business rule merely to complete a task.

---

# 3. Platform Stack

Preferred application stack:

- Wappler
- Node.js / Express target
- MySQL / MariaDB
- Bootstrap 5
- Wappler App Connect
- Wappler Server Connect
- Wappler Security Provider
- Wappler Database components
- Wappler File Upload
- Wappler Mailer / approved notification components where applicable
- Wappler-managed dependencies

The project must remain manageable through the **Wappler GUI**.

Do not change the project's Wappler, Node, Bootstrap, database, or dependency versions unless explicitly instructed.

---

# 4. Core Wappler Development Rule

All runtime application functionality must remain compatible with and editable through Wappler unless explicitly approved otherwise.

Prefer Wappler-native components and workflows.

Use, where applicable:

- Server Connect
- Server Connect Libraries
- Security Restrict
- Security Identify
- Database Query
- Database Single Query
- Database Insert
- Database Update
- Database Delete only where explicitly permitted
- Database Transaction
- Validator
- Conditions
- Repeat
- Set Value
- App Connect
- Dynamic Attributes
- Dynamic Events
- Bootstrap 5 Wappler components
- Wappler formatters
- Wappler File Upload
- Wappler Mailer
- Wappler-managed dependencies

Do not replace native Wappler functionality with custom code merely for convenience.

---

# 5. No Custom Runtime Architecture Unless Explicitly Approved

Do not create or introduce the following unless the user explicitly approves it:

- custom Express routes,
- custom Node.js business logic,
- custom authentication,
- custom authorization,
- custom database access layers,
- ORM models,
- runtime raw SQL,
- custom JavaScript workflow engines,
- custom middleware,
- direct low-level replacements for Wappler components,
- handwritten replacements for Wappler-generated runtime code.

If a requirement cannot be implemented cleanly using Wappler-native capabilities:

1. state the exact limitation,
2. identify whether a proper Wappler Extension is appropriate,
3. complete the Wappler-safe portion,
4. return `Partially Completed`,
5. do not invent an unmanaged runtime workaround.

## Approved Infrastructure Exception — Device Import Excel Adapter

A Wappler Server Connect extension may use ExcelJS solely for XLSX workbook generation and parsing for the Device Import workflow.

The extension may create/read worksheets, workbook metadata, lookup sheets, named ranges, cell formats, Excel data validation and dropdowns.

The extension must NOT perform database access, authorization, business validation, import workflow/state management, device creation, or database transactions.

All application and business logic remains Wappler Server Connect.

This exception applies only to the approved Device Import Excel Adapter and does not generally permit custom Node business logic.

---

# 6. Raw SQL Rule

Raw SQL is permitted only for controlled development or administration tasks such as:

- initial schema creation,
- one-time schema migrations,
- one-time seed data,
- one-time data cleanup,
- controlled data correction.

Raw SQL must not become the runtime application architecture.

Runtime reads and writes must use Wappler Database components unless explicitly approved otherwise.

Migration SQL must be repeatable or clearly documented as one-time.

---

# 7. Wappler Runtime Integrity

Never manually modify, recreate, or patch Wappler runtime files.

This includes, but is not limited to:

```text
dmxAppConnect.js
dmxFormatter.js
public/dmxAppConnect/
Wappler-generated runtime libraries
Bootstrap runtime files
```

If a component or formatter is required:

1. use the official Wappler component/dependency,
2. allow Wappler to generate/manage it,
3. do not hand-write missing Wappler runtime functions.

---

# 8. Wappler UI and Event Rules

These rules are mandatory unless explicitly overridden.

## Bootstrap 5 Modals

All Bootstrap 5 modals must use:

```html
is="dmx-bs5-modal"
```

Do not implement ordinary Bootstrap modal behavior outside the Wappler App Connect modal component.

## Dynamic Events Only

Use App Connect dynamic events:

```html
dmx-on:*
```

Examples:

```html
dmx-on:click="ticketModal.show()"
dmx-on:success="ticketList.load()"
dmx-on:error="errorAlert.show()"
```

Do not use static DOM handlers such as:

```text
onclick
onsuccess
onerror
onchange
onsubmit
```

## Wappler Component Methods

Use Wappler component methods:

```text
modalId.show()
modalId.hide()
serverConnectId.load()
formId.reset()
```

Do not substitute custom JavaScript or direct Bootstrap DOM manipulation when a Wappler method exists.

---

# 9. Filter Binding Standard

Server Connect filter requests must read directly from the actual control values.

Preferred pattern:

```html
dmx-param:status="statusSelect.value"
dmx-on:change="deviceList.load({status:statusSelect.value}, true)"
dmx-on:input="deviceList.load({search:searchInput.value}, true)"
```

For select and date controls use:

```html
dmx-on:change
```

Do not use:

```html
dmx-on:changed
```

When multiple filters exist, every reload must preserve and submit the current value of every active filter.

Do not create unnecessary `dmx-value` filter state when the actual control value can be used directly.

---

# 10. Project Scope Discipline

Codex must work only within the scope of the requested task.

Avoid broad inspection or modification of:

- unrelated pages,
- unrelated Server Connect actions,
- `node_modules`,
- generated Wappler runtime files,
- unrelated CSS,
- unrelated modules,
- unrelated database objects.

Before changing anything:

1. inspect the directly relevant files,
2. identify the existing Wappler pattern,
3. reuse it,
4. make the smallest complete change.

Prefer targeted changes over broad refactors.

---

# 11. Application Modules

The application is expected to evolve around these logical modules:

- Dashboard
- Devices / Laptop Assets
- Device Assignment
- Students
- Schools
- Districts
- Tickets
- Primary Diagnostics
- Collections
- TTPost Logistics
- Repair Centre
- Repairs
- Quality Assurance
- Returns
- Warranty
- Spare / Replacement Devices
- Parts Inventory
- Notifications
- Reports & Analytics
- AI Assistant
- Administration
- Users / Roles / Permissions
- SLA Policies
- Audit & History

Do not introduce generic ITSM modules that are unrelated to the laptop warranty process merely because a generic service-desk product would contain them.

---

# 12. Organisational Scope Model

Do not hard-code access based only on role names.

Authorization must combine:

```text
User
  + Role / Permission
  + Organisational Scope
```

Supported scopes may include:

- National / Head Office
- District
- School
- Multiple assigned schools
- Repair centre
- Logistics / TTPost
- TSTT oversight

The known business visibility model includes:

- School IT / School Administrators: only authorized school data,
- ICT Technical Officers: only assigned school/s,
- ICT District Coordinators: authorized district data,
- ICT Head Office / authorized national users: all schools,
- TSTT / repair / logistics users: only the operational data required for their function.

Do not rely on frontend hiding to enforce scope.

---

# 13. RBAC Rules

Frontend permission visibility is for user experience only.

Backend authorization is authoritative.

Every protected Server Connect action must enforce:

- authenticated user,
- required permission,
- required organisational scope,
- entity ownership/scope where applicable.

Do not rely only on:

- hidden buttons,
- disabled controls,
- hidden navigation,
- frontend conditional regions.

Permissions should be granular and action-oriented, for example:

```text
devices.view
devices.create
devices.update
devices.assign
devices.transfer
tickets.view
tickets.create
tickets.assign
tickets.diagnose
tickets.change_priority
tickets.approve_pickup
tickets.close
repairs.view
repairs.update
repairs.authorize_replacement
logistics.view
logistics.update_custody
reports.view
reports.export
admin.users
admin.roles
admin.sla
audit.view
```

Exact codes may be adjusted to the project's existing convention, but the principle must remain.

---

# 14. Authentication Rules

Use Wappler Security Provider for authentication.

Do not create custom login/session/authentication architecture without explicit approval.

Security-sensitive behavior must remain server-side.

Do not:

- trust a user ID supplied by the browser when it can be derived from the authenticated session,
- trust a school/district ID merely because it was submitted by the browser,
- expose password hashes,
- expose session internals,
- return authentication implementation details.

Login, logout, current-user/context, password change, password reset, lockout, and MFA must be implemented with Wappler-compatible patterns.

---

# 15. Device-Centric Architecture

The laptop/device is the central asset.

A device record should support the lifecycle relationship:

```text
Device
  → Allocation History
  → Assignment History
  → Student
  → School
  → District
  → Tickets
  → Diagnostics
  → Collection / Custody Events
  → Repairs
  → Parts
  → Warranty Decisions
  → Spare / Replacement Events
  → Return Events
  → Audit / Timeline
```

Do not treat the ticket as the only source of device history.

Do not duplicate current device information across unrelated tables when it can be joined safely from the source record.

---

# 16. Device Identity Rules

Serial number and approved asset identifier must be treated as unique business identifiers where required.

The system must support duplicate detection during:

- import,
- manual creation,
- ticket creation,
- logistics intake,
- repair-centre intake.

Do not expose database primary keys as the only user-facing identifier.

Use business identifiers for user workflows.

Exact identifier format must be configurable or defined by an approved implementation requirement.

---

# 17. Device Lifecycle Rules

Device lifecycle status must be distinct from ticket status and logistics status.

Example device lifecycle concepts include:

- In Stock / Available
- Allocated to District
- Allocated to School
- Assigned / Active
- Awaiting Collection
- In Transit
- At Repair Centre
- Under Repair
- Awaiting Return
- Temporarily Replaced
- Replaced
- Lost
- Stolen
- Written Off / BER
- Retired

Do not hard-code status behavior into scattered UI code.

Use controlled status values and explicit server-side transition actions.

A lifecycle transition should:

1. validate current state,
2. validate requested next state,
3. update the device,
4. append history,
5. create custody/history where required,
6. audit the action,
7. notify relevant parties where required.

Use a Wappler Database Transaction for related writes.

---

# 18. Allocation and Assignment History

Never overwrite historical allocation or assignment records.

District allocation, school allocation, student assignment, reassignment, transfer, temporary loan, return, and replacement must create history.

A device reassigned from Student A to Student B must not erase Student A's historical assignment.

For each assignment history record, capture as applicable:

- device,
- student,
- school,
- district,
- assignment type,
- start date/time,
- end date/time,
- assigned by,
- reason,
- acknowledgement/reference,
- active/current flag if used.

The current relationship may be optimized for fast display, but history remains authoritative for past state.

---

# 19. Student and Minor Data Rules

Students are business subjects associated with devices; they are not automatically application users.

Store only student data required by the approved Ministry process.

Avoid unnecessary duplication of:

- date of birth,
- home address,
- guardian data,
- identity numbers,
- sensitive personal information.

Do not expose student data outside the user's authorized organisational scope.

Do not place unnecessary student PII into:

- generic audit logs,
- notification logs,
- URLs,
- client-side hidden fields,
- AI prompts,
- broad reporting endpoints.

Student data minimization is a design requirement.

---

# 20. Ticket Creation Rules

Tickets must be linked to the device.

Where possible, the system should derive from the device record:

- serial number,
- asset identifier,
- model,
- current student,
- school,
- district,
- warranty status,
- current device status.

Do not force users to retype data already held by the system.

Ticket creation should support:

- issue category,
- issue subcategory,
- free-text description,
- requester,
- reporter role,
- attachments/photos,
- priority,
- expedited flag,
- current usability,
- initial troubleshooting,
- contact information where approved.

---

# 21. Duplicate Ticket Protection

The rebuilt solution must improve on the legacy platform by detecting existing active tickets for the same device.

Before creating a new ticket:

1. check existing open/active tickets for the device,
2. warn the user,
3. allow viewing/updating an existing case when appropriate,
4. allow a genuinely separate issue only when business rules permit it.

Do not implement a blanket rule that a device can only ever have one ticket.

A device may have many tickets over its lifetime.

---

# 22. Ticket State Machine

Do not allow unrestricted free-form status editing.

Use explicit transition actions.

A baseline lifecycle may include:

```text
New
Assigned
Acknowledged
In Diagnosis
Pending District Review
Approved for Pickup
Awaiting Collection
Collected
In Transit to Repair Centre
Received at Repair Centre
Under Investigation
Under Repair
Awaiting Parts
QA / Testing
Ready for Return
In Transit to School
Returned
Resolved
Closed
Cancelled
```

The final status catalogue must be driven by approved requirements/configuration.

Ticket state and device state are related but separate.

Every significant ticket transition must append status history and audit.

---

# 23. Primary Diagnostic Workflow

The Primary Diagnostic Report is a first-class business object, not merely an attachment.

It should support structured capture of:

- device/serial number,
- student,
- school,
- district,
- reported issue,
- troubleshooting performed,
- power/charging checks,
- visual inspection,
- software/configuration checks,
- device condition,
- supporting photos,
- initial assessment,
- technician,
- diagnostic date/time.

Initial assessment must support the approved classifications, including:

- resolved through troubleshooting,
- suspected negligence / malicious damage / misuse,
- suspected hardware defect,
- further review where needed.

Where possible, generate the formal report from structured data instead of requiring Word/PDF upload.

---

# 24. District Review / Pickup Authorization Gate

A device must not proceed automatically from primary diagnosis to TTPost collection.

For escalated cases, the workflow must include Ministry review by the authorized ICT District Coordinator or designate.

The review may:

- request clarification,
- investigate suspected negligence/misuse,
- classify a technical defect,
- authorize escalation to the repair process,
- authorize transfer to the Repair Centre,
- reject or redirect the request.

Collection must only begin after the required authorization is recorded.

This approval gate is mandatory unless a later approved process explicitly changes it.

---

# 25. Negligence / Misuse Workflow

Suspected negligence, malicious damage, or misuse must not be handled only as free-text comments.

The platform must support structured:

- suspicion flag,
- evidence,
- investigation notes,
- district review,
- decision,
- warranty impact,
- cost responsibility,
- dispute notes where applicable,
- decision date,
- decision-maker,
- supporting documents.

Confirmed negligence may affect warranty status according to approved policy.

Do not let AI make the final negligence or cost-responsibility decision.

---

# 26. TTPost Collection Workflow

The logistics workflow begins only after the required pickup authorization.

Collection processing should support:

- authorized collection request,
- school,
- school contact,
- device,
- ticket,
- pickup window/date,
- TTPost/courier reference,
- collection status,
- collected date/time,
- person handing over,
- person/courier receiving,
- packaging/accessories,
- condition at handoff,
- proof of collection,
- scan-out event,
- notifications.

The collection SLA must be tracked independently from other SLA stages.

---

# 27. Chain of Custody

Every physical device movement must create an append-only custody event.

Examples:

```text
Student / School
  → TTPost
  → Repair Centre
  → TTPost
  → School
  → Student
```

Custody events should capture, as applicable:

- device,
- ticket,
- from party/location,
- to party/location,
- event type,
- date/time,
- person performing handoff,
- person receiving,
- courier/tracking reference,
- condition,
- accessories,
- proof/signature/photo where approved,
- system user recording the event.

Do not overwrite custody events.

The platform must be able to answer:

> Who had physical custody of this device at a given point in time?

---

# 28. Repair Centre Intake

Repair Centre intake must verify that the physical device matches the authorized collection record.

Capture:

- serial number,
- asset identifier,
- school,
- district,
- student reference where authorized,
- received date/time,
- condition on receipt,
- accessories received,
- packaging condition,
- courier reference,
- discrepancies,
- intake user.

If there is a mismatch, damaged transit package, missing device, or missing accessory, create an exception workflow rather than silently continuing.

---

# 29. Repair Investigation

The Repair Investigation Report is a first-class structured record.

Capture:

- detailed diagnostic findings,
- confirmed root cause,
- defect vs negligence/misuse,
- warranty applicability,
- cost responsibility where applicable,
- recommended action,
- parts required,
- technician/vendor,
- investigation date/time,
- evidence,
- notes.

Recommended actions may include:

- local repair,
- replacement,
- return to factory,
- beyond economical repair (BER),
- no fault found,
- return without repair,
- other approved action.

---

# 30. Repair and Parts Rules

Repairs must be linked to:

- device,
- ticket,
- repair investigation,
- technician/vendor,
- work performed,
- parts used,
- repair dates,
- repair result,
- warranty reference,
- QA outcome.

Parts usage must not be stored only as free text.

Where the parts module is enabled, support inventory concepts such as:

- part,
- compatible model,
- stock quantity,
- reserved quantity,
- consumed quantity,
- replenishment,
- repair usage,
- low-stock alert.

Known spare-part categories may include:

- batteries,
- keyboards,
- trackpads,
- LCD panels,
- SSDs,
- RAM where modular,
- power adapters.

Do not hard-code the parts catalogue into application logic.

---

# 31. Temporary Spare and Replacement Device Rules

Temporary spare and permanent replacement are different business events.

The system must distinguish at least:

- temporary spare/loan device,
- permanent replacement device,
- manufacturer replacement,
- original device returned after repair.

Each spare/replacement issuance must be tracked as an assignment/warranty event.

If a temporary spare is issued:

- link it to the original ticket/device,
- record start date,
- record student/school,
- record reason,
- record return or conversion to permanent assignment.

Do not overwrite the original device's history.

---

# 32. Return-to-Factory Workflow

If a device is not reasonably repairable locally, the system must support return-to-factory / manufacturer processing.

Track:

- manufacturer/RMA reference,
- date shipped,
- courier,
- date manufacturer received,
- status,
- repair vs replacement outcome,
- expected return,
- actual return,
- returned serial number,
- replacement serial number where applicable,
- warranty decision,
- logistics back to Trinidad/school.

Long-running manufacturer cases must remain visible in SLA/aging reports.

---

# 33. Quality Assurance

Repair completion is not the same as successful closure.

Before a repaired device is returned:

1. perform QA / functional testing,
2. record tests,
3. record pass/fail,
4. return failed QA cases to repair,
5. only mark Ready for Return after QA passes.

QA history must be retained.

---

# 34. Device Return Workflow

Return logistics must support:

- Ready for Return,
- return request,
- TTPost/courier dispatch,
- scan-out from Repair Centre,
- in transit to school,
- school receipt,
- scan-in,
- condition on receipt,
- received by,
- receipt date/time,
- proof/signature where approved,
- school/technician confirmation of operation.

Do not close the ticket merely because the Repair Centre marked the repair complete.

Ticket closure should occur only after the approved confirmation/return step.

---

# 35. SLA Architecture

SLA handling must be stage-based and configurable.

Do not implement one generic ticket due date as the only SLA mechanism.

Potential SLA stages include:

- ticket acknowledgement,
- pickup,
- diagnosis,
- repair,
- QA,
- return logistics,
- overall turnaround,
- expedited case handling,
- exception/escalation thresholds.

Known source documentation contains SLA values such as:

- pickup within 2 business days,
- diagnosis documented as 1 business day in one SLA table,
- repair 2–3 business days,
- QA 1 business day,
- return logistics within 2 business days after repair.

The source documents also contain wording that can imply a 2-working-day investigation/initial-action target.

Therefore:

**Do not hard-code the diagnosis SLA until the approved business rule is confirmed.**

Store SLA policies in configuration tables.

SLA calculations should support:

- business days,
- configurable working calendar,
- Trinidad & Tobago public holidays where approved,
- stage start,
- stage pause,
- stage resume,
- stage complete,
- due date,
- breach,
- warning threshold,
- expedited policy,
- escalation.

---

# 36. Escalation Rules

Escalations must be configurable.

Do not scatter thresholds in page code.

Possible aging/escalation concepts include:

- warning before SLA breach,
- SLA breach,
- 7-day review,
- 14-day management escalation,
- 30+ day contractual/steering escalation.

The exact thresholds and recipients must come from approved configuration.

Every escalation should record:

- trigger,
- ticket/device,
- stage,
- date/time,
- recipient/role,
- action,
- resolution,
- audit history.

---

# 37. Notifications

Notifications are part of the workflow, not an afterthought.

Support approved channels such as:

- email,
- SMS where integration exists,
- in-application notifications.

Important events may include:

- ticket created,
- ticket assigned,
- ticket acknowledged,
- district review required,
- pickup approved,
- pickup scheduled,
- device collected,
- device received by Repair Centre,
- diagnosis completed,
- repair completed,
- QA completed,
- return dispatched,
- school receipt,
- ticket closed,
- SLA warning,
- SLA breach,
- exception.

Notification templates must be configurable.

Do not place sensitive student information in notifications unless specifically required.

---

# 38. Internal Ticket Communication

The rebuilt platform must provide first-class internal ticket comments/notes.

Comments must:

- be linked to the ticket,
- record author,
- record timestamp,
- support internal visibility rules,
- support attachments where approved,
- be append-oriented,
- not overwrite prior comments.

Do not force staff to use a separate unrelated table screen merely to review ticket conversation history.

---

# 39. Attachments and File Security

Use Wappler-native upload where possible.

For uploaded diagnostics, photos, receipts, signatures, repair documents, and other protected files:

- use generated unique storage names,
- retain original filename only as metadata where needed,
- validate file type,
- validate size,
- block executable/active content,
- do not store protected files in a publicly browsable directory,
- do not expose filesystem paths to the browser.

Secure retrieval must be based on:

- authenticated user,
- authorized entity/document,
- organisational scope,
- permission.

Do not create custom Node.js upload/download handlers unless explicitly approved.

---

# 40. Audit Rules

Auditability is a core requirement.

Audit records should capture:

- authenticated actor,
- action,
- module/domain,
- entity type,
- entity ID,
- timestamp,
- safe before/after context where appropriate,
- safe description.

Do not place passwords, password hashes, sensitive identifiers, full student PII, or raw file paths into generic audit logs.

Detailed domain history belongs in domain-specific history tables.

Core business histories should be append-oriented and treated as immutable through ordinary application functionality.

---

# 41. Unified Timeline

Where practical, provide a device/ticket timeline that presents important historical events in chronological order.

Examples:

- device registered,
- allocated to district,
- allocated to school,
- assigned to student,
- ticket created,
- diagnosis completed,
- pickup approved,
- collected,
- received at Repair Centre,
- repair completed,
- QA passed,
- dispatched,
- returned,
- reassigned/replaced,
- ticket closed.

The timeline is a read model.

Do not make the timeline itself the source of truth.

Its data must come from the underlying authoritative records.

---

# 42. Delete and Recovery Rules

Core operational history must not be hard-deleted through normal application workflows.

This includes, as applicable:

- device history,
- assignment history,
- ticket history,
- diagnostics,
- approvals,
- custody events,
- repair history,
- warranty decisions,
- audit history.

Where administrative correction/deletion is allowed:

- require appropriate permission,
- prefer soft-delete/recoverable state,
- record who deleted/restored it,
- record date/time,
- record reason,
- prevent deletion when business rules forbid it.

The rebuilt solution must improve on the legacy platform's lack of recoverable-delete capability.

---

# 43. Dashboard Rules

Dashboards must be useful operational tools, not decorative charts.

The approved bmobile-styled dashboard may surface metrics such as:

- total laptops,
- open tickets,
- awaiting collection,
- in repair,
- ready for return,
- closed this month,
- warranty status,
- ticket status,
- collection/return status,
- upcoming collections,
- recent tickets,
- SLA risks.

Every dashboard metric must have a traceable underlying query.

Do not display fake placeholder operational data in production.

Dashboard visibility must respect RBAC and organisational scope.

---

# 44. Reporting Requirements

The rebuilt solution must provide stronger reporting than the legacy portal.

Support fixed operational and management reports, including as applicable:

- tickets created,
- tickets closed,
- average turnaround time,
- school-by-school breakdown,
- district breakdown,
- aging buckets,
- overdue tickets,
- SLA performance,
- collection performance,
- return performance,
- repeat repairs by serial number,
- repair history,
- fault categories,
- parts usage,
- warranty utilization,
- warranty expiry,
- devices outside warranty,
- temporary spare devices,
- replacement devices,
- BER devices,
- technician/vendor performance,
- open vs closed trends,
- audit exports,
- device history.

Where required support:

- on-screen charts,
- PDF output,
- Excel output,
- CSV output,
- role-limited export permission.

Do not assume that permission to view automatically grants permission to export.

---

# 45. AI Assistant Rules

AI is an enhancement layer, not a bypass around security or workflow.

Potential AI capabilities include:

- natural-language reporting,
- chart/report request interpretation,
- ticket summarization,
- suggested categorization,
- suggested priority,
- similar-incident search,
- suggested troubleshooting,
- trend detection,
- repeat-failure analysis,
- warranty/repair insights.

AI must never:

- bypass RBAC,
- bypass organisational scope,
- execute unrestricted raw SQL generated by an LLM,
- create unmanaged custom runtime architecture,
- make final negligence decisions,
- make final warranty-liability decisions,
- silently change ticket/device status,
- silently assign cost responsibility,
- fabricate device/ticket/repair data.

AI suggestions must remain advisory unless the user explicitly confirms an authorized action.

---

# 46. AI Natural-Language Reporting Architecture

Because runtime raw SQL is prohibited, do not implement generic LLM-to-SQL execution directly against the production database.

Preferred safe pattern:

```text
User question
  → authenticated user context
  → AI intent / report interpretation
  → approved report/query definition
  → validated filters
  → server-side RBAC/scope enforcement
  → Wappler-managed data query
  → structured result
  → chart/table/summary
```

The AI layer must only have access to data the authenticated user is authorized to see.

If fully general natural-language querying cannot be achieved without custom runtime logic:

1. stop,
2. state the limitation,
3. propose a proper Wappler Extension or explicitly approved integration,
4. do not silently introduce direct SQL execution.

---

# 47. API / Server Connect Design Rules

Prefer narrow, purpose-specific Server Connect actions.

Avoid giant endpoints that return unrelated data domains.

Examples of logical action groups may include:

```text
auth/
devices/
assignments/
students/
schools/
districts/
tickets/
diagnostics/
approvals/
collections/
custody/
repairs/
parts/
returns/
reports/
admin/
```

These are logical Wappler Server Connect groupings, not custom Express route instructions.

Return only the fields required for the current screen/function.

Do not fetch sensitive data merely to hide it on the frontend.

---

# 48. Mutation Transaction Rules

Use Wappler Database Transactions for related multi-step writes.

Examples:

- create device + initial lifecycle history + audit,
- assign device + close prior assignment + new assignment history + audit,
- ticket status transition + history + audit + notification queue record,
- pickup approval + ticket transition + collection request + audit,
- collection scan + custody event + device status + ticket status,
- repair completion + parts consumption + repair history + device status,
- spare assignment + assignment history + warranty event,
- replacement + close original assignment + new assignment + device lifecycle updates,
- ticket closure + final status history + SLA completion.

Avoid partially committed workflow state.

---

# 49. Loading, Success, and Error States

Use App Connect-native state handling.

For Server Connect forms/actions:

- disable duplicate submission where appropriate,
- show processing state,
- reload affected data after success,
- reset forms where appropriate,
- close Wappler modals using native methods,
- avoid full-page refresh when `.load()` is sufficient.

Example:

```html
dmx-on:success="ticketList.load();ticketModal.hide();ticketForm.reset()"
```

Do not expose:

- SQL,
- stack traces,
- filesystem paths,
- Server Connect internals,
- security implementation details.

User-facing errors must be safe, clear, and actionable.

---

# 50. Data Refresh Rule

After create/update/status/mutation actions, refresh the affected existing Server Connect component using `.load()`.

Concept:

```text
mutation succeeds
  → reload affected list/detail
  → reset form if needed
  → hide modal if needed
  → preserve user filters where possible
```

Do not require a browser refresh to see saved data.

Do not create duplicate Server Connect components merely to refresh existing data.

---

# 51. Branding — bmobile

Use the approved bmobile brand identity for the application.

Primary brand color:

```text
#00E556
```

Dark grey:

```text
#4D4D4D
```

Use the approved bmobile logo supplied to the project.

Respect the logo safety area.

Do not distort, recolor, crop, recreate, or alter the approved logo without explicit instruction.

Typography from the supplied brand guide:

- Stag
- Stag Sans

Use project-provided/licensed font assets only.

Do not download, redistribute, or invent proprietary font files.

If approved fonts are not available in the project, use the project's approved fallback stack while preserving hierarchy.

---

# 52. GUI Design Language

The interface must be modern, clean, enterprise-grade, and purpose-built.

Preferred visual characteristics:

- white/light content surfaces,
- bmobile green as primary accent/action color,
- dark grey/charcoal text,
- restrained use of secondary status colors,
- left-side desktop navigation,
- top utility bar,
- strong search,
- rounded cards,
- clear data tables,
- visible status badges,
- strong whitespace,
- readable hierarchy,
- consistent iconography,
- accessible contrast.

Avoid:

- cluttered generic ITSM menus,
- excessive gradients,
- excessive decorative animation,
- inconsistent icon families,
- arbitrary colors,
- tiny text,
- dense tables without responsive treatment.

---

# 53. Iconography

Where feasible, use iconography consistent with the bmobile guide:

- simple geometric construction,
- uniform strokes,
- rounded corners,
- consistent visual weight.

Do not mix multiple unrelated icon styles on the same screen.

---

# 54. Responsive Design

All pages must work responsively at approximately:

- 1440px
- 1024px
- 768px
- 375px

Avoid page-level horizontal overflow.

Do not squeeze wide desktop tables into unreadable mobile tables.

On smaller screens, prefer:

- stacked cards,
- compact summary rows,
- responsive offcanvas navigation,
- priority columns only,
- drill-down detail views.

Critical actions must remain usable on mobile/tablet.

---

# 55. Accessibility

Use:

- proper labels,
- keyboard-accessible controls,
- visible focus states,
- semantic buttons/links,
- adequate contrast,
- descriptive validation errors,
- accessible modal focus behavior,
- meaningful text labels in addition to color.

Do not communicate status using color alone.

---

# 56. Search

Global and module search must be intentional.

Device search should support approved identifiers such as:

- serial number,
- asset tag,
- student,
- school,
- district.

Ticket search should support:

- ticket number,
- device identifiers,
- school,
- student where authorized,
- status,
- priority,
- date ranges.

Search results must respect the authenticated user's scope.

---

# 57. Saved Views

The platform should support operational views such as:

- New
- Assigned
- Awaiting District Review
- Approved for Pickup
- Awaiting Collection
- In Transit
- Under Repair
- Ready for Return
- Closed
- Overdue

Saved views should be based on approved query/filter rules and must respect RBAC.

---

# 58. Warranty Rules

Warranty status should be computed from authoritative dates/policy where possible rather than manually maintained as an independent truth.

Track:

- warranty start,
- warranty end,
- current computed status,
- warranty voided indicator where approved,
- void reason,
- warranty decisions,
- repair warranty events.

Do not allow a manually editable display field to contradict authoritative warranty dates/history without a controlled exception process.

---

# 59. Data Quality Rules

The rebuilt solution must improve data quality.

Use validation for:

- required fields,
- serial number,
- asset identifier,
- duplicate devices,
- valid school/district relationships,
- assignment consistency,
- ticket/device relationship,
- warranty dates,
- chronological date logic,
- custody transitions,
- repair status transitions,
- replacement relationships.

Provide controlled data-cleanup tools only to authorized administrators.

---

# 60. Configuration Over Hard-Coding

Do not hard-code business lists in page logic when they are expected to change.

Prefer configuration/reference tables for:

- districts,
- schools,
- issue categories,
- issue subcategories,
- ticket priorities,
- status values where practical,
- SLA policies,
- escalation rules,
- repair outcomes,
- warranty decisions,
- notification templates,
- parts catalogue,
- vendors,
- repair centres,
- public holidays/business calendar.

Seed data may initialize these values, but runtime behavior should remain configurable.

---

# 61. Districts

The known Ministry education districts are:

- Port of Spain & Environs
- St. George East
- North Eastern
- Caroni
- Victoria
- St. Patrick
- South Eastern
- Tobago

Treat these as reference/seed data.

Do not hard-code district names into authorization logic or UI conditionals.

---

# 62. Fault Categories

Known fault categories from the business documentation include:

- Batteries
- Keyboards & Trackpads
- LCD Panels
- SSDs & RAM where modular
- Power Adapters

The approved catalogue may expand.

Use configuration tables.

Do not hard-code category options into multiple pages.

---

# 63. Legacy-System Improvement Rule

When a feature exists in the old portal, the new implementation should preserve its useful outcome while improving usability and control.

Known legacy capabilities to preserve or improve include:

- laptop listing,
- ticket listing,
- unique ticket tracking,
- school/district visibility,
- attachments,
- ticket status,
- notifications,
- audit activity.

Known legacy gaps to improve include:

- real dashboards,
- richer reports,
- PDF/Excel reporting,
- district filtering,
- duplicate active-ticket detection,
- role-specific export control,
- recoverable deletion,
- ticket comment thread,
- automatic warranty status,
- repair counts/history,
- branding/navigation,
- purpose-built workflow.

Do not carry forward generic legacy clutter merely because it existed.

---

# 64. Data Migration

Historic data from the existing solution may be migrated.

Do not assume migration scope.

When migration is requested:

1. profile the source data,
2. map source fields to target entities,
3. identify duplicates,
4. identify invalid references,
5. preserve historical IDs/references as legacy references,
6. do not overwrite new-system identifiers,
7. reconcile counts,
8. document exclusions,
9. test rollback/re-run approach.

Do not silently discard historic ticket, repair, assignment, or audit information.

---

# 65. Testing Rules

Do not assume Wappler has a generic test button for every Server Connect action.

Use appropriate testing methods such as:

- browser,
- application UI,
- curl,
- Postman,
- controlled SQL verification for test/validation only.

For authenticated curl testing, use a cookie jar/session pattern where required.

Test both happy-path and denial-path scenarios.

---

# 66. Security Test Expectations

Where relevant, validate:

- unauthenticated access rejected,
- wrong-role access rejected,
- wrong-school access rejected,
- wrong-district access rejected,
- export denied without export permission,
- direct API calls cannot bypass hidden UI,
- user cannot change submitted scope IDs to view another school,
- protected files require authorization,
- deleted/retired records behave as intended,
- audit/history remains intact.

---

# 67. Workflow Test Expectations

For lifecycle work, test:

- valid transition,
- invalid transition,
- duplicate submission,
- repeated API call,
- missing required fields,
- stale record/state,
- unauthorized transition,
- multi-write rollback,
- history creation,
- audit creation,
- notification trigger where applicable.

Do not claim a workflow is complete after testing only the visual page.

---

# 68. Performance

Avoid unnecessary broad queries.

Use:

- paging,
- filters,
- indexes,
- narrow result sets,
- server-side aggregation where appropriate,
- efficient joins through Wappler components.

Do not load the full national laptop dataset into the browser merely to filter client-side.

Large reports must be designed with server-side filtering/aggregation.

---

# 69. Security Backlog Awareness

Do not weaken security while implementing features.

The project should remain compatible with future hardening such as:

- MFA,
- failed-login lockout,
- session revocation,
- secure production cookies,
- password-reset hardening,
- IP/device risk controls,
- enhanced audit review,
- notification security.

Do not implement speculative security architecture unless tasked, but do not create designs that prevent later hardening.

---

# 70. Codex Work Discipline

Before changing code:

1. restate the requested scope internally,
2. inspect only directly relevant files,
3. inspect existing database/API/UI conventions,
4. reuse existing patterns,
5. identify affected permissions,
6. identify affected history/audit requirements,
7. make the smallest complete implementation,
8. test,
9. report exactly what changed.

Do not repeatedly scan the entire project.

Do not inspect `node_modules` broadly.

Do not redesign working architecture without a requirement.

---

# 71. Do Not Invent Unsupported Functionality

If a requested feature cannot be completed safely using the approved Wappler architecture:

- do not silently create custom runtime code,
- do not modify Wappler runtime files,
- do not fake completion,
- do not fabricate test results.

Instead:

1. state the limitation,
2. identify the Wappler-native option,
3. identify whether a Wappler Extension is needed,
4. complete the safe portion,
5. return `Partially Completed`.

---

# 72. Final Response Standard for Coding Tasks

Codex completion responses should be concise and factual.

Where relevant, return:

1. `Completed` or `Partially Completed`
2. scope completed
3. files changed
4. Server Connect actions/components created or reused
5. database/migration changes
6. RBAC/scope behavior
7. transaction behavior
8. history/audit behavior
9. responsive behavior
10. validation/testing performed
11. known limitation
12. manual Wappler save/restart/configuration required

Do not claim runtime behavior was tested if only syntax or template compilation was checked.

---

# 73. Default Quality Gate

Before considering a task complete, verify:

- Wappler GUI compatibility preserved,
- no custom runtime workaround introduced,
- no Wappler runtime file modified,
- runtime raw SQL not introduced,
- RBAC enforced server-side,
- organisational scope enforced server-side,
- frontend visibility matches RBAC,
- student data minimized,
- device/ticket/custody history preserved,
- audit generated where required,
- multi-step writes use transactions where appropriate,
- no hard deletion of protected history,
- bmobile design language preserved,
- responsive behavior preserved,
- affected data refreshes without unnecessary full-page reload,
- AI does not bypass permissions,
- no fake operational data introduced,
- no unapproved business rule was hard-coded.

---

# 74. Instruction Priority

If a direct user instruction conflicts with this file, follow the user's explicit instruction.

If a more deeply nested `AGENTS.md` exists, follow its narrower directory/project rules where applicable.

Otherwise, these instructions are the default development contract for the TSTT / MoE Laptop Warranty & Repair Management Portal.
