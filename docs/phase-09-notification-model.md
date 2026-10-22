# Phase 9 Notifications

## 9D-A Scope

Phase 9D-A provides the notification event/recipient model, own-inbox APIs, unread/read operations, administrative inspection, a controlled test-notification endpoint, and the in-app notification center. Notifications are derived side effects only. Phase 9D-B adds SLA/escalation lifecycle notifications; other ticket, repair, logistics, custody, loan, and replacement notifications remain out of scope until their later phases.

## Model

- `notification_events` is the immutable logical event. Its unique `idempotency_key` identifies one logical occurrence. Controlled type and severity values are enforced by reference-table foreign keys. Optional source/entity references are descriptive identifiers; `ticket_id` is FK-constrained when supplied.
- `notification_recipients` stores delivery/read state per user. `(notification_event_id, user_id)` is unique, so one user cannot receive duplicate rows for an event. `read_at IS NULL` means unread. `read_by` is set from the authenticated session when read.
- `notification_event_types` includes the foundation types plus `SLA_AT_RISK`, `SLA_BREACHED`, `ESCALATION_RESOLVED`, and `ESCALATION_CANCELLED`; `notification_severities` uses `INFO`, `SUCCESS`, `WARNING`, and `CRITICAL`.
- `v_notification_inbox` joins event and recipient data and exposes `created_at_display` as a server-generated readable string while preserving raw `created_at`.

Creation resolves an active recipient on the server and is available as a reusable Server Connect library action. Event and initial recipient are inserted together with their audit entry in a database transaction. Retries with the same key reuse the event and existing recipient; database unique constraints remain authoritative under concurrent retries.

## Ownership and Permissions

Inbox list, count, detail, mark-read, and mark-all-read derive the user from Wappler Security Provider. Browser-supplied `user_id`, role, and organisation scope are not trusted. Detail permits own-recipient access; `notifications.manage` may inspect other recipient rows through the admin read API. Mark-read and mark-all-read only update the authenticated user's recipient rows. The test endpoint is manager-only, has fixed content, and only resolves the approved Phase 9D-A test usernames; it is not a general messaging API.

`SUPER_ADMIN` and `MOE_HEAD_OFFICE` receive manage/view/respond. Operational portal roles receive view/respond. No other role receives manage.

## Audit and Channels

Creation and actual read-state transitions are audited. Idempotent read retries do not add duplicate audits. Mark-all-read is audited when it changes one or more rows.

Email was not sent in 9D-A. Phase 9D-D added a separate `notification_deliveries` model keyed by recipient and channel, with append-only delivery attempts, status, provider reference, and retry data. Read state remains independent of delivery state: email processing does not read or write `read_at`.

## Action Links

No free-form `action_url` is stored or rendered in 9D-A. The UI constructs the ticket link from the trusted numeric `ticket_id` field returned by the scoped inbox query, and only renders it when the authenticated context grants `tickets.view` or `tickets.create`. Users without ticket-view permission see the ticket number as text and retain the authorized escalation-queue link. This excludes arbitrary schemes and external destinations.

## 9D-B SLA and Escalation Events

The Wappler `notification_from_escalation` library is called after the SLA transition transaction completes. It reads the authoritative escalation case and the persisted assignment rows; recipient user IDs, roles, and scopes are never accepted from the browser.

| Event | Trigger | Severity | Idempotency key |
| --- | --- | --- | --- |
| `SLA_AT_RISK` | SLA transitions to `AT_RISK` and Level-1 assignment is present | `WARNING` | `SLA:<sla id>:AT_RISK` |
| `SLA_BREACHED` | SLA transitions to `BREACHED` and Level-2 promotion/assignment is present | `CRITICAL` | `SLA:<sla id>:BREACHED` |
| `ESCALATION_RESOLVED` | SLA completion resolves an escalation | `SUCCESS` | `ESCALATION:<case id>:RESOLVED` |
| `ESCALATION_CANCELLED` | SLA cancellation cancels an escalation | `INFO` | `ESCALATION:<case id>:CANCELLED` |

Level 1 uses the case's Level-1 assignment role and requires an active user with that role. TTPost assignment is role-wide, matching the Phase 9C authorization rule. Other operational recipients must have an active national, matching district, matching school, or matching repair-centre scope. Level 2 likewise requires the assigned role and an active applicable scope; the configured Head Office target is matched to active national scope. Disabled/locked accounts are excluded. Terminal notifications reuse distinct users present in the prior risk/breach notification recipient history rather than resolving current role membership again.

At-risk and breach notifications combine the SLA and escalation business event in one notification. Acknowledgement does not generate a notification. Notifications store trusted numeric ticket references and an internal action type; the client constructs only the existing `/tickets/detail?id=<ticket id>` route when the user has ticket-view permission, or the `/escalations` route for authorized escalation recipients. No external URL is stored.

The notification helper runs after the relevant state/assignment transaction. For pickup completion, it also runs after the enclosing TTPost receipt transaction commits, so the terminal notification reads the committed SLA and escalation state. Its local catch contains notification-only failures so a derived notification error cannot roll back committed SLA, escalation, or logistics state. It does not enqueue retries; durable delivery queues and external channels are deferred.

## 9D-C Ticket, Repair, and Logistics Events

The Phase 9D-C migration seeds the event types and extends the inbox view with school, district, device, logistics, handoff, and repair-centre context. The type-code columns are widened for `HEAD_OFFICE_REPLACEMENT_APPROVAL_REQUIRED`; apply the migration once before restarting Wappler. No database triggers are used.

`notification_from_workflow` is an internal Wappler Server Connect library. Its input comes from completed Server Connect workflows, not browser-supplied recipients. It resolves active users through current role membership and matching active scope rows. School roles are `SCHOOL_ADMINISTRATOR` and `ICT_TECHNICAL_OFFICER`; District is `ICT_DISTRICT_COORDINATOR`; Repair Centre is `REPAIR_CENTRE`; TTPost is `TTPOST_LOGISTICS`; Head Office is `MOE_HEAD_OFFICE` with active national scope. TTPost remains role-wide as established in Phase 9D-B and Phase 9C authorization; the selected hub is retained in notification context, not used to invent a second TTPost scope engine. Repair Centre dispatch is restricted to the target repair location.

| Event | Authoritative hook | Severity | Recipients / scope | Idempotency key | Action |
| --- | --- | --- | --- | --- | --- |
| `TICKET_SUBMITTED` | `tickets/create` after ticket transaction | INFO | School operational roles / origin school | `TICKET:<id>:SUBMITTED` | Ticket detail |
| `TICKET_CLARIFICATION_REQUESTED` | `tickets/clarification/request` after request transaction | WARNING | School operational roles / origin school | `TICKET:<id>:CLARIFICATION:<request id>` | Ticket detail |
| `DISTRICT_APPROVAL_REQUIRED` | `tickets/diagnosis/create` after diagnosis transaction | WARNING | District Coordinator / origin district | `TICKET:<id>:DISTRICT_APPROVAL_REQUIRED` | Ticket detail |
| `TICKET_APPROVED_FOR_PICKUP` | `tickets/approval/approve-pickup` after approval transaction | SUCCESS | School operational roles / origin school | `TICKET:<id>:APPROVED_FOR_PICKUP` | Ticket detail |
| `LOGISTICS_PICKUP_REQUESTED` | `logistics/request-pickup` after case transaction | INFO | TTPost / active operational users | `LOGISTICS:<id>:PICKUP_REQUESTED` | Logistics detail |
| `LOGISTICS_SCHOOL_RELEASED` | `logistics/handoff/school-dispatch` after dispatch transaction | INFO | TTPost operational role | `HANDOFF:<id>:LOGISTICS_SCHOOL_RELEASED` | Logistics detail |
| `LOGISTICS_RECEIVED_BY_TTPOST` | `logistics/handoff/tt-post-receive` after receipt transaction | SUCCESS | School operational roles / origin school | `HANDOFF:<id>:LOGISTICS_RECEIVED_BY_TTPOST` | Ticket and logistics detail where permitted |
| `LOGISTICS_SENT_TO_REPAIR_CENTRE` | `logistics/handoff/tt-post-dispatch-repair` after dispatch transaction | INFO | Repair Centre / target location | `HANDOFF:<id>:LOGISTICS_SENT_TO_REPAIR_CENTRE` | Logistics detail |
| `LOGISTICS_RECEIVED_BY_REPAIR_CENTRE` | `logistics/handoff/repair-centre-receive` after receipt transaction | SUCCESS | School operational roles / origin school | `HANDOFF:<id>:LOGISTICS_RECEIVED_BY_REPAIR_CENTRE` | Ticket and logistics detail where permitted |
| `LOGISTICS_READY_FOR_RETURN_PICKUP` | `repairs/complete` for a configured return-ready outcome | INFO | TTPost / active operational users | `LOGISTICS:<id>:READY_FOR_RETURN_PICKUP` | Logistics detail |
| `LOGISTICS_RETURN_RECEIVED_BY_TTPOST` | `logistics/handoff/tt-post-return-receive` after receipt transaction | SUCCESS | School operational roles / origin school | `HANDOFF:<id>:LOGISTICS_RETURN_RECEIVED_BY_TTPOST` | Ticket and logistics detail where permitted |
| `LOGISTICS_RETURN_IN_TRANSIT_TO_SCHOOL` | `logistics/handoff/tt-post-school-dispatch` after dispatch transaction | INFO | School operational roles / origin school | `HANDOFF:<id>:LOGISTICS_RETURN_IN_TRANSIT_TO_SCHOOL` | Ticket and logistics detail where permitted |
| `LOGISTICS_RETURNED_TO_SCHOOL` | `logistics/handoff/school-return-receive` after receipt transaction | SUCCESS | School operational roles and District Coordinator / matching school and district | `HANDOFF:<id>:LOGISTICS_RETURNED_TO_SCHOOL` | Ticket and logistics detail where permitted |
| `REPAIR_STARTED` | `repairs/start` after repair-start transaction | INFO | School and District operational stakeholders / origin scope | `REPAIR:<id>:STARTED` | Repair detail by repair-job ID |
| `REPAIR_COMPLETED` | `repairs/complete` for a successful return-ready outcome | SUCCESS | School and District operational stakeholders / origin scope | `REPAIR:<id>:COMPLETED` | Repair detail by repair-job ID |
| `DISTRICT_REPAIR_DECISION_REQUIRED` | `exceptions/submit` after a District decision state is persisted | WARNING | District Coordinator / origin district | `EXCEPTION:<id>:DISTRICT_REPAIR_DECISION_REQUIRED` | Exception detail |
| `HEAD_OFFICE_REPLACEMENT_APPROVAL_REQUIRED` | `exceptions/submit` or `exceptions/district/decide` after Head Office approval state is persisted | WARNING | MOE Head Office / active national scope | `EXCEPTION:<id>:HEAD_OFFICE_REPLACEMENT_APPROVAL_REQUIRED` | Exception detail |

The ticket-approved notice is an informational school update; the separate pickup request is the TTPost next-action event, so TTPost does not receive duplicate notices for the same step. The Repair Centre is not notified of its own receipt or repair-start action. Repair completion goes to origin stakeholders, while the independent ready-for-return event goes to TTPost.

Notification hooks run after their authoritative transaction and use the same contained failure pattern as Phase 9D-B. A failed derived notification is audited as `notification_delivery_failed`; it does not undo ticket, exception, repair, handoff, custody, ticket-status, logistics-status, device, or SLA writes. The notification model remains in-app only; email, delivery queues, retries, SMS, push, and preferences remain out of scope.

Repair completion preserves the Phase 7E domain contract in one Wappler Database Transaction: repair job completion, ticket `COMPLETED`, logistics `READY_FOR_RETURN`, related histories/audit, and the applicable lifecycle update commit together. SLA completion/cancellation and return-SLA creation run only after that transaction commits, followed by workflow notification generation. The post-commit SLA helper contains and audits its own failure; it cannot roll back the completed repair, and its catch does not enclose or convert a core transaction failure into success.

The notification detail modal exposes the server-provided school, district, device serial/asset tag, logistics number, handoff type, repair job, repair centre, SLA, and escalation context. It constructs only links to the existing ticket, logistics, repair, and exception routes and checks the corresponding view capability before rendering links.

## 9D-D Email Delivery and Retry

Email is a separate delivery channel for an already-persisted `notification_recipients` row. The email path never resolves roles or scopes again. `notification_channel_rules` gates automatic email for 9D-B/C operational events; `TEST_NOTIFICATION`, `SYSTEM_INFORMATION`, and `SYSTEM_WARNING` remain in-app only unless a manager explicitly uses the fixed test-notification API's email acceptance option. The migration seeds email for the operational 9D-B/C event codes and does not backfill old notifications.

`notification_deliveries` is unique by `(notification_recipient_id, channel_code)` and stores the destination and message snapshots. The nullable user `email` is copied lowercased and trimmed; absent or invalid values produce `SKIPPED_NO_ADDRESS` or `SKIPPED_INVALID_ADDRESS` without invoking Mailer. The application’s user onboarding normalizes email to lowercase; email remains nullable and unique. `notification_delivery_attempts` is append-only and unique by delivery/attempt number. Neither table reads or writes `notification_recipients.read_at`.

Sending uses the existing Wappler `mail` instance and the exact `mail.send` pattern in `app/api/test-email.json`: configured sender name, from/reply-to address, recipient name/address, subject, and plain-text body. The HTML snapshot is unused and action links are omitted because this project has no trusted canonical public base URL. The body includes notification title/message and ticket number where present, but no student identity, raw HTML, SMTP credentials, or stack trace. Mail send failure is contained after the event/recipient transaction and records only a generic error code/message.

Delivery states are `PENDING`, `PROCESSING`, `SENT`, `RETRY_PENDING`, `FAILED_PERMANENT`, `SKIPPED_NO_ADDRESS`, and `SKIPPED_INVALID_ADDRESS`. Retry is bounded to 3 attempts: initial send immediately, first retry after 5 minutes, second after 30 minutes, then terminal failure. A Wappler conditional update from eligible state to `PROCESSING` is the atomic claim; the processor is limited to 10 due rows per request. Concurrent claims are serialized by that state transition. SMTP remains at-least-once at the provider boundary: if the provider accepts a message but the application loses the response before persisting `SENT`, a later retry can duplicate it.

The protected `POST /api/admin/notifications/email/process-due` action is available to `notifications.manage`. Automatic retries use the Wappler-native scheduled action at `app/schedule/notification-email-retry.json`, configured every five minutes and invoking the reusable `notification_email_process_due` library. No OS cron, custom worker, external queue, or custom mailer is used. Manage-only list/detail/manual-retry APIs are under `/api/admin/notifications/email/`. Email delivery status remains independent of the normal Notification Center’s read/unread state.

## 9D-E Integration and Regression

The complete current event/channel inventory comes from `notification_event_types` and `notification_channel_rules`. At the Phase 9D-E acceptance snapshot there are 24 event types: 21 operational event types are enabled for both in-app and email; `SYSTEM_INFORMATION`, `SYSTEM_WARNING`, and `TEST_NOTIFICATION` are in-app-only by rule. A manager may explicitly request email for the fixed test-notification endpoint, but that does not change its automatic channel classification.

| Event type | Email | Source workflow | Primary recipient role/scope | Existing coverage evidence |
| --- | --- | --- | --- | --- |
| `DISTRICT_APPROVAL_REQUIRED` | Yes | Ticket diagnosis | District Coordinator / ticket origin district | 5 historical operational events |
| `DISTRICT_REPAIR_DECISION_REQUIRED` | Yes | Exception submission | District Coordinator / exception district | 1 operational event |
| `ESCALATION_CANCELLED` | Yes | SLA cancellation | Persisted escalation assignment / matching role and scope | No current event; static hook mapping |
| `ESCALATION_RESOLVED` | Yes | SLA completion | Persisted escalation recipients / assigned roles and scopes | 1 event, 2 recipients |
| `HEAD_OFFICE_REPLACEMENT_APPROVAL_REQUIRED` | Yes | Exception submission or district decision | MOE Head Office / active national scope | 2 events |
| `LOGISTICS_PICKUP_REQUESTED` | Yes | Pickup request | TTPost Logistics / role-wide | 5 events |
| `LOGISTICS_READY_FOR_RETURN_PICKUP` | Yes | Successful return-ready repair outcome | TTPost Logistics / role-wide | 2 events |
| `LOGISTICS_RECEIVED_BY_REPAIR_CENTRE` | Yes | Repair-centre receipt | School roles / origin school | 5 events, 15 recipients |
| `LOGISTICS_RECEIVED_BY_TTPOST` | Yes | TTPost receipt | School roles / origin school | 5 events, 15 recipients |
| `LOGISTICS_RETURN_IN_TRANSIT_TO_SCHOOL` | Yes | TTPost school dispatch | School roles / origin school | 1 event, 3 recipients |
| `LOGISTICS_RETURN_RECEIVED_BY_TTPOST` | Yes | TTPost return receipt | School roles / origin school | 1 event, 3 recipients |
| `LOGISTICS_RETURNED_TO_SCHOOL` | Yes | School return receipt | School roles and District Coordinator / matching school and district | 1 event, 4 recipients |
| `LOGISTICS_SCHOOL_RELEASED` | Yes | School dispatch | TTPost Logistics / role-wide | 5 events |
| `LOGISTICS_SENT_TO_REPAIR_CENTRE` | Yes | TTPost dispatch to repair centre | Repair Centre / matching service location | 5 events |
| `REPAIR_COMPLETED` | Yes | Successful repair completion | School and District roles / origin scopes | 2 events, 8 recipients |
| `REPAIR_STARTED` | Yes | Repair start | School and District roles / origin scopes | 5 events, 20 recipients |
| `SLA_AT_RISK` | Yes | SLA warning and Level-1 assignment | Persisted escalation assignment / applicable scope | 1 event |
| `SLA_BREACHED` | Yes | SLA breach and Level-2 promotion | Persisted escalation assignment / applicable scope | 1 event |
| `SYSTEM_INFORMATION` | No | System informational event | Event-specific in-app recipient | No operational event |
| `SYSTEM_WARNING` | No | System warning | Event-specific in-app recipient | No operational event |
| `TEST_NOTIFICATION` | No | Manager-controlled test endpoint | Explicit approved test user | Events 7, 8, 82, and 86; manager force-email scheduler tests are separate |
| `TICKET_APPROVED_FOR_PICKUP` | Yes | District pickup approval | School roles / origin school | 5 events, 15 recipients |
| `TICKET_CLARIFICATION_REQUESTED` | Yes | Clarification request | School roles / origin school | Event 84: 3 recipients and 3 sent emails |
| `TICKET_SUBMITTED` | Yes | Ticket creation | School roles / origin school | Event 83 retained as pre-fix evidence; Event 85 is the fresh 9D-E integration smoke |

The static/runtime implementation keeps the authoritative transaction first, then invokes in-app notification generation, then enqueues email. The notification/email paths are derived side effects and are contained so they do not roll back committed workflow state. Email delivery does not resolve recipients independently: each delivery is tied to the existing in-app recipient row and `user_id`.

The MySQL 5.7 read-only regression matrix is `docs/testing/phase-09d-e-notification-integration-acceptance.sql`; the execution record and bounded residuals are in `docs/testing/phase-09d-e-notification-integration-test-report.md`. Event 83 is an exact historical pre-fix exception and is never backfilled. Event 84 remains unchanged and is the accepted corrected fan-out proof. Current/post-fix checks use the explicit accepted boundary at event 84 and continue to include later events.

The Phase 9D-E scheduler smoke verified the native five-minute retry schedule on the authoritative port-3000 process. Its disposable manager test event is retained as event 86 / `EML-16`; this is a test-only forced email and does not alter `TEST_NOTIFICATION`'s automatic channel rule.
