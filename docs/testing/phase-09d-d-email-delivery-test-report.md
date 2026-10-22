# Phase 9D-D Email Delivery and Retry Test Report

**Status: Phase 9D-D command acceptance closed / pass.** The original retry checks were run on a temporary Wappler instance because the port-3000 process had not loaded the new schedule. Phase 9D-E later verified the native Scheduler naturally on the authoritative port 3000; see `phase-09d-e-notification-integration-test-report.md`. Any final visual/email review is user acceptance, not an outstanding Phase 9D-D command test.

## Workflow Email

- Dedicated safe recipients were test accounts with reserved `.example.test` addresses routed to local MailHog. The workflow event was school-scoped `TICKET_CLARIFICATION_REQUESTED`; its controlled eligible recipients were `phase3.school.test` (school administrator), `p6c.tech.test` (technical officer), and `p6d.caroni.tech.test` (technical officer).
- Disposable workflow marker: `P9D-D-WORKFLOW-EMAIL-20261016-A`; device ID 92, serial `P9D-D-WORKFLOW-EMAIL-20261016-A`, ticket `TKT00000092`.
- The legitimate ticket creation produced event 83 (`TICKET_SUBMITTED`). Before the fan-out correction, only the first of its three eligible recipients received an email delivery. This pre-fix test artifact is retained in workflow history and is not the final acceptance event.
- A legitimate clarification request on the same disposable ticket produced event 84 (`TICKET_CLARIFICATION_REQUESTED`) after the correction. It had exactly 3 in-app recipients and 3 email deliveries: `EML-10`, `EML-11`, and `EML-12`. All were `SENT`, with one successful attempt and `sent_at` populated. Each delivery's user/address matched its corresponding in-app recipient.
- MailHog captured exactly one clarification email per controlled recipient at `2026-10-16 18:34:12 UTC`. Subject: `Ticket clarification requested · TKT00000092`. The body contains the ticket reference and clarification notice; it contains no student/customer PII.
- Repeating the clarification action returned HTTP 409 because the ticket was no longer in the submitted state. Event 84, its 3 recipients, and its 3 email deliveries remained singular; no duplicate workflow transition or email was created.
- The workflow exposed a fan-out gap in `app/modules/lib/notification_from_workflow.json`: after the notification event/recipient creation, the helper did not reliably enqueue email for every eligible recipient. It now resolves the event by its idempotency key and invokes the existing idempotent `notification_email_enqueue` for each eligible recipient. No custom runtime code or mail transport was introduced.

## Scheduler and Retry

- Wappler-native Scheduler facility: available. Configuration: `app/schedule/notification-email-retry.json`. Frequency: every 5 minutes (`0 */5 * * * *`). Wappler's native Exec Action calls reusable Server Connect library `notification_email_process_due`; it calls no HTTP endpoint and does not weaken API authorization.
- The configured processor selects bounded batches of 10 `PENDING` or due `RETRY_PENDING` deliveries. It does not select `FAILED_PERMANENT`.
- Scheduler command acceptance used a temporary instance of this same Wappler app on port 3010 because the existing port-3000 instance could not reload (`EADDRINUSE`). It ran with the project's Wappler scheduler enabled; no OS cron, PM2, custom worker, or external queue was used.
- The temporary port-3010 instance was stopped after the natural-cycle tests. No extra application server was left running.
- Initial scheduled execution: `EML-13` (`p9db.ho.test`) was queued as `PENDING`, then naturally became `SENT` at `18:40 UTC`, attempt count 1. On the next cycle at `18:45 UTC`, its status, timestamp, and attempt count were unchanged. MailHog contained one matching message at 18:40 and no duplicate.
- Automatic retry execution: `EML-16` (`p7b.ttpost.test`) was prepared as due `RETRY_PENDING`, attempt count 1, with one controlled `FAILED_RETRYABLE` attempt. At the 18:50 UTC scheduler cycle it became `SENT`, attempt count 2, with one new `SENT` attempt and populated `sent_at`. MailHog captured exactly one matching message at 18:50 UTC. On the next cycle at 18:55 UTC, status, timestamp, count, and message count were unchanged.
- Not-due check: `EML-14` remained `RETRY_PENDING` at attempt count 1 through scheduler cycles; its next attempt time was later than those cycles. No MailHog message was generated.
- Terminal check: `EML-15` remained `FAILED_PERMANENT`, attempt count 3, with no new attempt through the scheduler cycles.
- The four disposable scheduler events/deliveries (events 85–88; deliveries `EML-13`–`EML-16`) were removed after recording the results. The operational workflow fixture was retained.
- On 2026-10-17 the port-3000 Wappler process was confirmed to have started after the schedule file was present. Phase 9D-E used a new manager test slot for an automatic due retry, observed one natural send on the first five-minute cycle, and confirmed no resend on the next cycle. This current-port evidence supersedes the former restart-pending note below.

## Authorization and Database Checks

- Manager login (`portal.admin`) successfully listed and opened delivery detail, including `EML-16`'s two-attempt history. Non-manager login (`p7b.ttpost.test`) received HTTP 403 from the delivery-list API. Manual retry remains a manager-only action; its existing eligible-state guard and delivery claim remain unchanged.
- Ran `docs/testing/phase-09d-d-email-delivery-acceptance.sql` after cleanup. All anomaly queries returned zero rows; enabled email rules = 21; trigger count = 0. Protected Phase 9D-A/B/C event fixtures showed zero email backfills.
- Targeted event 84 query: ticket `TKT00000092`, 3 recipients, 3 email deliveries, 3 sent, 3 attempts, 3 attempt-history rows. No duplicate delivery/attempt anomalies.
- No protected workflow fixture was advanced or edited. The only operational workflow case created was the disposable ticket 92 fixture; the only direct SQL changes were acceptance-only scheduler states and their cleanup.

## Final User Inspection Fixture

- Workflow: `TICKET_CLARIFICATION_REQUESTED`.
- Marker/ticket: `P9D-D-WORKFLOW-EMAIL-20261016-A` / `TKT00000092`.
- Notification event: 84.
- Recipients: `phase3.school.test`, `p6c.tech.test`, `p6d.caroni.tech.test`; all are dedicated test accounts with reserved `.example.test` MailHog addresses.
- Deliveries: `EML-10`, `EML-11`, `EML-12`, each `SENT`, attempt count 1.
- Subject: `Ticket clarification requested · TKT00000092`.
- Sent time: `2026-10-16 18:34:12 UTC`.
- Do not resend for visual acceptance. Inspect the Notification Center entry and the corresponding three MailHog messages for subject, body, operational context, and absence of unnecessary PII.

## Remaining

The Schedule action is saved and has passed natural execution both in the earlier temporary acceptance instance and, subsequently, on port 3000 in Phase 9D-E. No subjective visual testing was performed by Codex.
