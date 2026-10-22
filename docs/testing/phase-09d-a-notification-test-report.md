# Phase 9D-A Notification Acceptance Report

## Scope

Phase 9D-A implements the notification foundation and in-app inbox only. No automatic workflow notification hooks, outbound channels, or Phase 9D-B/C functionality were added.

## Implementation

- Migration `database/phase_09d_a_notification_foundation.sql` applied to `laptop_tickets_db`.
- Tables: `notification_event_types`, `notification_severities`, `notification_events`, `notification_recipients`.
- Views: `v_notification_inbox`, `v_notification_unread_recipients`.
- Event types: `SYSTEM_INFORMATION`, `SYSTEM_WARNING`, `TEST_NOTIFICATION`.
- Severities: `INFO`, `SUCCESS`, `WARNING`, `CRITICAL`.
- Permissions: `notifications.view`, `notifications.respond`, `notifications.manage`. `SUPER_ADMIN` and `MOE_HEAD_OFFICE` have all three; operational roles have view/respond only.
- `notification_events.idempotency_key` is unique; `(notification_event_id,user_id)` is unique on recipients. Creation, recipient insertion, and audit use a Wappler transaction.
- Inbox page `/notifications` is registered with the `main` layout and `notifications.view` permission guard. Header unread count and sidebar navigation use the same permission context.

## API and Security Acceptance

All API calls used the Wappler Server Connect runtime at `http://localhost:3000`.

- Own inbox and unread count: PASS; records were limited to the authenticated recipient.
- Detail for another user's row: 404, PASS.
- Mark another user's row read: 404, PASS.
- Non-manager admin test endpoint: 403, PASS.
- Malformed notification ID: safe 404, PASS.
- Invalid event type and severity: 400, PASS.
- Unsupported `javascript:` action URL input: not stored or rendered; event schema/API have no `action_url`. The controlled test API returned null `action_type` and `action_reference` for that record, which was then removed.
- Event idempotency: initial create returned event 4 / `created:true`; retry returned event 4 / `created:false`.
- Mark-read retry: first request changed unread state; retry returned `already_read:true` without another read audit.
- Mark-all-read changed only the admin's unread rows. At that point admin unread count was 0 while TTPost still had 1 unread notification.
- Creation and read audit rows were verified. Mark-all audit is written only when rows change.

## Browser Functional Acceptance

Functional checks were run without screenshot or subjective visual review.

- `portal.admin`: signed in, opened Notification Center, saw the notification, opened detail, saw the server-formatted timestamp, marked it read, and verified the unread count changed. Read/unread and search filters returned the expected rows. Mark-all-read cleared the remaining admin unread rows.
- `p7b.ttpost.test`: signed in, opened the same page, saw only its own inbox item, and did not receive the admin-only “Create test notification” control.
- The first browser check exposed a missing `/notifications` Wappler route. The authenticated route and reusable permission guard were added and then verified in the running app.

## Workflow and Database Regression

- No workflow API was called and no workflow table was written by notification operations. The protected fixture probes remained readable: TKT00000075 / SLA 8 / ESC00000003 / LOG00000061 reported their existing statuses (`IN_TRANSIT`, `COMPLETED_OUTSIDE_SLA`, `RESOLVED`, `OUTBOUND_IN_TRANSIT`).
- Phase 8/9B and protected Phase 9C fixture data were not modified.
- Trigger count: 0.
- Disposable test notifications were removed. Two unread final GUI records remain:
  - event 7, recipient `portal.admin`;
  - event 8, recipient `p7b.ttpost.test`.

## Result

Command acceptance: PASS. Browser functional acceptance: PASS. Static JSON parsing, EJS compilation, and `git diff --check`: PASS. No Wappler restart is required; the route was confirmed live. User visual acceptance remains outstanding. Phase 9D-B: NOT STARTED.
