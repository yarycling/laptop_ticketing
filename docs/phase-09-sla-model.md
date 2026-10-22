# Phase 9 SLA Model

## Phase 9A Scope

Phase 9A establishes global policy configuration and a configurable business calendar. Phase 9B adds an operational instance/event schema and read model; it does not change ticket/logistics/repair states, send notifications, or escalate work.

## Entities

- `sla_calendars` stores named calendars, timezone, active state, and the default-calendar marker.
- `sla_calendar_weekdays` stores the seven recurring weekday rules. The seeded Trinidad and Tobago / Portal Operations calendar uses Monday–Friday as business days and Saturday/Sunday as non-business days.
- `sla_calendar_overrides` stores explicit date-specific exceptions. Supported types are public holiday, exceptional closure, and exceptional working day. An override takes precedence over the recurring weekday rule when active. No public-holiday dates are presumed by the seed.
- `sla_calendar_override_history` stores the immutable configuration snapshot and action for each add, change, or deactivation.
- `sla_policies` stores the stable policy code.
- `sla_policy_versions` stores immutable policy configuration snapshots, including target business days, calendar, status, sort order, and nullable future start/completion/pause event codes. A save appends a version; prior versions remain available.
- `v_sla_policy_current` exposes the latest version per policy. `v_sla_policy_version_history` exposes all snapshots with calendar names.
- `sla_instance_states` keeps SLA states separate from operational workflow states.
- `sla_calendar_dates` is a MySQL 5.7-compatible date spine covering 2020-01-01 through 2102-02-19. `v_sla_calendar_business_dates` overlays active calendar overrides over weekday rules.
- `sla_instances` stores each clock with an idempotency key and immutable policy/version/target/calendar snapshots, workflow links, deadlines, and terminal timestamps.
- `sla_instance_events` stores the append-only state transition history. A unique instance/event-code key prevents duplicate STARTED, AT_RISK, BREACHED, COMPLETED, and CANCELLED events.
- `v_sla_operational_queue` is a read-only operational projection. Access must be scoped by the calling Server Connect action; the view itself is not an authorization boundary.

Policy target and status changes create a new version. Calendar assignment is also captured per version, so later changes to a policy do not overwrite the prior configuration. Each SLA instance retains the selected version, target, and calendar ID. Calendar overrides are live configuration, not versioned snapshots; changing a calendar override does not rewrite already stored due timestamps.

## Seeded Policies

| Code | Initial target |
| --- | ---: |
| PICKUP | 2 business days |
| DIAGNOSIS | 1 business day |
| REPAIR | 3 business days |
| QA | 1 business day |
| RETURN_LOGISTICS | 2 business days |

REPAIR uses the maximum standard target from the documented 2–3 business-day range. Start, completion, and pause event mappings remain unset pending Phase 9B workflow mapping.

## RBAC and Audit

`sla.view` is seeded for SUPER_ADMIN, MOE_HEAD_OFFICE, TSTT_OVERSIGHT, ICT_DISTRICT_COORDINATOR, and REPAIR_CENTRE. `sla.manage` is seeded for SUPER_ADMIN and MOE_HEAD_OFFICE. Route and Server Connect guards enforce view/manage permissions; UI visibility is only a convenience.

Configuration mutations use the existing `audit_logs` table in the same database transaction as the change. Policy actions are `sla.policy.created`, `sla.policy.updated`, `sla.policy.activated`, and `sla.policy.deactivated`. Calendar actions are `sla.calendar_override.added`, `.changed`, and `.deactivated`; each override mutation also appends a snapshot to `sla_calendar_override_history`.

## Phase 9B Workflow Mapping

| Policy | Start event | Completion event | Cancel / N/A | Status |
| --- | --- | --- | --- | --- |
| PICKUP | Ticket enters `APPROVED_FOR_PICKUP` in the district approval transaction | Successful `SCHOOL_TO_TTPOST` handoff receipt | No ticket-cancellation workflow currently exists; unapproved tickets do not start a clock. Add cancellation handling with that authoritative workflow if introduced. | **IMPLEMENTED** |
| DIAGNOSIS | Successful `TTPOST_TO_REPAIR_CENTRE` receipt | First authoritative Repair Centre assessment for the repair job | No synthetic primary-diagnosis substitute; subsequent submissions are idempotent after completion | **IMPLEMENTED** |
| REPAIR | `repair_jobs.started_at` when a repair job is created | `REPAIRED_SUCCESSFULLY` completion | Any completed non-local outcome cancels the local repair clock | **IMPLEMENTED** |
| QA | No genuine QA table, event, or authoritative start/completion transition was found in the current schema | None | N/A | **DEFERRED**; requires an approved QA record with start and pass/fail timestamps |
| RETURN_LOGISTICS | Actual `READY_FOR_RETURN` transition for successful local repair, permanent replacement acceptance, or repaired-original manufacturer return; effective-device source must not be `TEMPORARY_LOAN_CONVERSION` | `TTPOST_TO_SCHOOL` handoff receipt at school/recipient | Non-return repair outcome is N/A; conversion workflow cancels any stale active return clock and never starts one | **IMPLEMENTED** |

The source records were verified in `phase_06a_ticketing_foundation.sql`, `phase_07a_logistics_foundation.sql`, `phase_07e_repair_foundation.sql`, `phase_08c_d_effective_return_device.sql`, and the corresponding Server Connect workflow actions. A Repair Centre assessment is distinct from `ticket_diagnoses`; school primary diagnosis is not used as the DIAGNOSIS completion event.

## Evaluation Rules

- An instance retains a stable idempotency key derived from policy and the authoritative source event. Event history also has a unique `(sla_instance_id, event_code)` constraint.
- Due dates use the selected policy version's configured calendar business dates; active overrides take precedence over recurring weekday rules. A start on a business date counts that date as business day one; a start on a non-business date begins counting at the next eligible business date. `due_at` is stored as a calendar-local wall-clock `DATETIME`, at 23:59:59 on the selected final business date. Extend the fixed date spine before its final date is reached.
- `sla_evaluate` reads `v_sla_evaluation_queue`, which joins each SLA instance through its snapshotted `calendar_id` to `sla_calendars.timezone_name`. MySQL computes current local business datetime using `CONVERT_TZ(UTC_TIMESTAMP(6), '+00:00', timezone_name)` and derives the `is_at_risk` and `is_breached` flags before Wappler/JavaScript date serialization. `AT_RISK` begins on the final business date when local evaluation datetime is less than or equal to local `due_at`; `BREACHED` begins only when local evaluation datetime is strictly later than local `due_at`.
- **Deployment prerequisite:** MySQL named timezone tables must contain every IANA timezone name referenced by an active SLA calendar. Application migrations do not populate MySQL system timezone tables. An unresolved name makes `CONVERT_TZ` return `NULL`; that SLA remains unchanged, is excluded from transitions, and is returned in the evaluator's `timezone_errors` output with its SLA, calendar, and timezone identifiers. Operators must resolve the database timezone data/configuration and re-evaluate; no host, browser, UTC-date, or fixed-offset fallback is used.
- Run `docs/testing/phase-09c-timezone-acceptance.sql` after deployment to verify the Port of Spain and New York rules, every active calendar, and SLA state/history integrity. The SQL is SELECT-only and MySQL 5.7 compatible.
- Risk and breach are SLA states only. No SLA action may mutate ticket status, lifecycle, custody, logistics handoffs, replacement, or temporary-loan state.
- The read model is not a scope boundary. Queue/detail Server Connect actions must enforce `sla.view` and the matching ticket, school/district, or repair-centre scope.
- Wappler-native `sla_start`, `sla_complete`, `sla_cancel`, and `sla_evaluate` Server Connect libraries are invoked by authoritative workflow transactions. Explicit POST `/api/sla/evaluate` requires `sla.manage`; recurring scheduling is not introduced.
- Queue, detail, and ticket-summary reads require `sla.view` and enforce national, district, school, or repair-centre scope server-side. Static implementation is not runtime acceptance; local database execution remains outstanding.

## Phase 9C Escalation Management

The timezone-safe evaluator implementation is in `app/modules/lib/sla_evaluate.json`; its database read model is installed by `database/phase_09c_timezone_safe_sla_evaluation.sql`. This patch is repeatable and does not alter existing SLA instances or workflow data.

Escalation rules are data-driven by policy, trigger (`AT_RISK` or `BREACHED`), level, target role, reason label, order, and active status. Active duplicate policy/trigger/level/role tuples are rejected by a generated-key unique index. Rules are deactivated, never deleted. The migration seeds the eight approved initial mappings below for implemented SLA policies only.

| Policy | Trigger | Level | Target role | Status |
| --- | --- | ---: | --- | --- |
| PICKUP | AT_RISK | 1 | TTPOST_LOGISTICS | ACTIVE |
| PICKUP | BREACHED | 2 | MOE_HEAD_OFFICE | ACTIVE |
| DIAGNOSIS | AT_RISK | 1 | REPAIR_CENTRE | ACTIVE |
| DIAGNOSIS | BREACHED | 2 | MOE_HEAD_OFFICE | ACTIVE |
| REPAIR | AT_RISK | 1 | REPAIR_CENTRE | ACTIVE |
| REPAIR | BREACHED | 2 | MOE_HEAD_OFFICE | ACTIVE |
| RETURN_LOGISTICS | AT_RISK | 1 | TTPOST_LOGISTICS | ACTIVE |
| RETURN_LOGISTICS | BREACHED | 2 | MOE_HEAD_OFFICE | ACTIVE |
| QA | — | — | — | DEFERRED / NO RULES |

`escalation_cases` holds one case per SLA instance and snapshots policy, ticket, district, school, logistics, repair, reason, trigger, and state. `escalation_assignments` retains each level/role assignment and its rule/reason snapshots; promotion adds level 2 without erasing level 1. `escalation_history` is append-only and has idempotency keys and one-event-per-case constraints. `v_escalation_operational_queue` is a read model, not an authorization boundary.

The SLA evaluator opens level 1 on `AT_RISK` and promotes the existing case on `BREACHED`. If an evaluator first observes a breach and no case exists, it creates the case and both the opened and promoted history transitions in the same workflow transaction. Promotion preserves `ACKNOWLEDGED` as the case state while raising current level to 2 and trigger to `BREACHED`; acknowledgement does not pause or complete the SLA. SLA completion resolves an unresolved case; SLA cancellation cancels it. Each terminal SLA transition, its SLA event, escalation closeout, and audit writes share a transaction. Missing optional rules do not prevent SLA state transitions. QA receives no escalation rules or instances.

Acknowledgement requires `escalations.respond`; operational responders must belong to a current-level target role and match existing district, school, logistics, or Repair Centre scope. A user with existing national scope, or SUPER_ADMIN, may use the administrative override. Only an `OPEN` case may be acknowledged. The operation records actor/time/note and history/audit; repeated acknowledgement conflicts. No manual resolution is provided while the SLA is unresolved.

Permissions are `escalations.view`, `escalations.respond`, and `escalations.manage`. TSTT_OVERSIGHT receives view only. MOE_HEAD_OFFICE and SUPER_ADMIN receive all three; Repair Centre and TTPost receive view/respond; district coordinators, technical officers, and school administrators receive view. The target role does not supersede the backend scope checks used by existing operational APIs.

SLA transition hooks call Wappler-native `escalation_open`, `escalation_promote`, and `escalation_close` actions from `sla_evaluate`, `sla_complete`, and `sla_cancel`. Compare-and-set state updates plus database uniqueness prevent duplicate case/event/assignment creation under retry or concurrent evaluation. Audit actions are `escalation_opened`, `escalation_promoted`, `escalation_acknowledged`, `escalation_resolved`, `escalation_cancelled`, and the four `escalation_rule_*` configuration actions. Notifications remain out of scope until Phase 9D.

## Deferred Work

- 9D: notification delivery and templates.
- 9E: SLA dashboards and reports.
- 9F: integrated regression and closure.

Ticket status, device lifecycle, logistics status, and manufacturer RMA timing remain separate. No workflow milestone is inferred or hard-coded in 9A.
