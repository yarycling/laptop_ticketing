# Phase 9D-B SLA and Escalation Notification Trigger Report

## Implementation

- Added `database/phase_09d_b_sla_escalation_notification_triggers.sql` and applied it to `laptop_tickets_db`. It seeds the four Phase 9D-B event types and extends `v_notification_inbox` with SLA policy, escalation number, level, and state context. No severity rows, permissions, tables, or database triggers were added.
- Added the Wappler-native `notification_from_escalation` library. It derives recipients from persisted escalation assignments, active user-role links, active account status, and active matching organisation scope. TTPost assignment follows the existing role-wide Phase 9C authorization convention; Head Office recipients require active national scope; Repair Centre recipients require the case's repair-centre scope; other operational roles require a matching active scope.
- Extended the reusable `notification_create` library to persist ticket, SLA, escalation, logistics, and repair references. The existing unique idempotency and event/user recipient constraints remain authoritative.
- Added hooks after SLA evaluation transitions, SLA completion, and SLA cancellation. Acknowledgement does not create a notification. Notification-only failure is caught after operational state/assignment work and recorded through the existing audit log when available; audit failure is also contained. No queue, external delivery, or workflow state mutation was introduced.
- Runtime testing found the pickup-completion hook nested inside the outer TTPost receipt transaction. Moved only that hook to immediately after the transaction and committed custody read-model step, so terminal-recipient resolution sees the committed `RESOLVED` state. The real TTPost receipt workflow then created the resolution event for both distinct prior recipients.
- The Notification Center list/detail APIs now return SLA/escalation context. The detail panel shows the policy and escalation number/level when present. Trusted links use the existing ticket detail and escalation queue routes; no arbitrary URL is stored.

## Trigger Matrix

| Event | Transition | Severity | Idempotency key |
| --- | --- | --- | --- |
| `SLA_AT_RISK` | SLA reaches `AT_RISK`, after Level-1 assignment creation | `WARNING` | `SLA:<sla id>:AT_RISK` |
| `SLA_BREACHED` | SLA reaches `BREACHED`, after Level-2 assignment/promotion | `CRITICAL` | `SLA:<sla id>:BREACHED` |
| `ESCALATION_RESOLVED` | SLA completion resolves an escalation | `SUCCESS` | `ESCALATION:<case id>:RESOLVED` |
| `ESCALATION_CANCELLED` | SLA cancellation cancels an escalation | `INFO` | `ESCALATION:<case id>:CANCELLED` |

Terminal recipients are the distinct active users previously notified for that escalation's at-risk and/or breach events. There is no `ESCALATION_ACKNOWLEDGED` event. At-risk/escalation-open and breach/escalation-promoted are combined into one logical notification each.

## Verification

- All 256 application JSON files parsed successfully; modified notification EJS compiled successfully.
- Migration applied successfully twice, confirming its event seeds and view replacement are repeatable.
- `docs/testing/phase-09d-b-notification-trigger-acceptance.sql` ran read-only after fixture cleanup. Required event types, duplicate-key/recipient, link integrity, terminal-state, active-recipient, orphan, action-reference, context, and trigger checks each returned 0. Trigger count is 0.
- Protected Phase 9D-A events 7 (`portal.admin`) and 8 (`p7b.ttpost.test`) retained their existing test-notification values and recipients.
- The known `p8b.ho.1` account (user 31) remains disabled and was not reactivated. It has an active national scope and established Phase 8D activity, so it was not reused. Created `p9db.ho.test` (user 34) through the supported test-user mechanism; it is active, has `MOE_HEAD_OFFICE`, active NATIONAL scope, and the established test password `test`. The resolver selects by active assignment, role, and scope; it does not check `notifications.manage` to deliver. The MOE role currently has view/respond/manage capabilities.
- `p7b.ttpost.test` (user 16) is active with `TTPOST_LOGISTICS`, notifications.view/respond, and no notifications.manage permission. It received Level 1 through the existing role-wide TTPost assignment rule.
- Final retained fixture: `TKT00000076`, device 84 (`P9DB-PICKUP-NOTIFY-20261016-001`), PICKUP SLA 9, `ESC00000004`, `LOG00000063`, handoff 136. SLA 9 is `COMPLETED_OUTSIDE_SLA`; escalation is `RESOLVED`; ticket is `IN_TRANSIT`; logistics is `OUTBOUND_IN_TRANSIT`; physical custody is `TTPOST_CUSTODY` at `P7C TTPost Test Hub`.
- SLA 9 has exactly one `SLA_AT_RISK` / WARNING event (notification 10, TTPost recipient), one `SLA_BREACHED` / CRITICAL event (notification 11, MOE recipient), and one `ESCALATION_RESOLVED` / SUCCESS event (notification 15, both distinct recipients). Repeated evaluation and receipt attempts created no duplicates; receipt retry returned HTTP 409. The event/user counts are 1, 1, and 2 respectively.
- Browser functional checks passed for both roles on the retained fixture: TTPost saw the warning and resolution but not the Level-2 breach; MOE saw the breach and resolution but not the Level-1 warning in its own inbox. Both could open notification details and use the trusted escalation-queue link. The queue showed `ESC00000004` as RESOLVED. No subjective visual acceptance was performed.
- API security checks passed: TTPost own detail 200, MOE-only detail 404, and forged MOE recipient mark-read 404; MOE own detail 200 and forged TTPost recipient mark-read 404; unrelated Repair Centre list empty and detail 404. MOE detail is allowed to inspect another recipient through its documented `notifications.manage` read capability, but its own inbox does not automatically include the TTPost-only warning. Read state remains recipient-specific.
- Notification ticket links now follow `authContext.data.can_tickets_view`: TTPost sees the ticket number as text and the working escalation link, while authorized MOE users retain the ticket link. Browser checks confirmed the rendered behavior for both accounts.
- Acknowledgement was exercised on the second disposable pickup case before breach and created no notification event. The cancellation path was exercised through the existing `sla_cancel` service using a temporary permission-guarded Wappler test action on disposable ticket 78 / SLA 11 / `ESC00000006`; SLA and escalation became `CANCELLED`, one `ESCALATION_CANCELLED` / INFO event with one prior TTPost recipient was created, and retry produced no duplicate. The temporary action was removed.
- Notification failure isolation was exercised by a contained delivery failure on the disposable workflow. Audit row 2803 recorded the notification failure while the SLA/escalation transition remained committed. The cause was a Wappler join filter using a literal value inside the join clause, compiling to `undefined.undefined`; the scope-active checks are now in recipient eligibility branches. A later completion-path defect was fixed by moving the hook after the outer receipt transaction.
- Command-only fixtures `TKT00000077` / device 85 / `LOG00000062` and `TKT00000078` / device 86, their SLAs/escalations/notifications and associated audit rows were transactionally cleaned after their acceptance checks. The retained final fixture `TKT00000076` / device 84 / `LOG00000063` remains intact. Protected TKT71/SLA1–4/LOG57, TKT75/SLA8/ESC00000003/LOG61, Phase 9D-A events 7/8, and the known SLA 3 historical anomaly were not modified. The dedicated Head Office test account remains active for user visual acceptance; disable it after GUI acceptance if it is no longer needed.

## Result

Implementation: PASS. Phase 9D-B command and browser functional acceptance are complete. User visual acceptance remains outstanding. The dedicated account `p9db.ho.test / test` remains active for that check; disable it after visual acceptance if no longer needed. Phase 9D-C was not started.
