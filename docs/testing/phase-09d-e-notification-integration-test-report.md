# Phase 9D-E Notification Integration and Regression Test Report

**Status: READY FOR FINAL USER VISUAL SANITY CHECK.** The live workflow/email path, current database checks, port-3000 scheduler retry, browser role smoke, and all three final regression gaps passed. Phase 9D command acceptance is closed; only the user's final visual sanity check remains.

## Service and Inventory

- Authoritative app: `http://localhost:3000`; `/login` returned HTTP 200 and the portal-admin login succeeded. MySQL database `laptop_tickets_db` and MailHog were reachable. No app or database service was restarted by this run.
- The Wappler process serving port 3000 started on 2026-10-17 at 07:10 AST, after `app/schedule/notification-email-retry.json` was present. Wappler configuration has `cron: true`; the schedule is every five minutes and invokes the native Server Connect library `notification_email_process_due`.
- Database inventory: 24 event types, 21 enabled operational EMAIL rules. Automatic channel classes: 21 `IN_APP_AND_EMAIL`, 3 `IN_APP_ONLY` (`SYSTEM_INFORMATION`, `SYSTEM_WARNING`, `TEST_NOTIFICATION`). A manager-forced test email is not an automatic EMAIL rule.
- The full event/source/recipient/channel/coverage matrix is maintained in `docs/phase-09-notification-model.md`.

## Fresh Workflow Integration

- Marker/device: `P9D-E-INTEGRATION-20261017-A`, device 93, ticket `TKT00000093`.
- The device was created with `/api/devices/create`, transitioned using `/api/devices/set-lifecycle`, allocated through the district and school allocation APIs, then submitted through `/api/tickets/create`. The device remains `AVAILABLE` in `SCHOOL` custody at school 1 / district 4; ticket 93 remains `SUBMITTED`. No logistics, repair, SLA, escalation, custody, or additional lifecycle transition was created.
- One `TICKET_SUBMITTED` event was created (event 85, idempotency key `TICKET:93:SUBMITTED`). It resolved exactly three distinct active school recipients: `phase3.school.test` (`SCHOOL_ADMINISTRATOR`), `p6c.tech.test` and `p6d.caroni.tech.test` (`ICT_TECHNICAL_OFFICER`). Each has exactly one `SENT` EMAIL delivery, attempt count 1, and a matching delivery user ID. MailHog contained exactly one matching message for each `.example.test` recipient.
- Mail subject/body contain the ticket number and operational notice only; no student/customer identity, credentials, SMTP settings, raw HTML, or stack trace.
- The exact create request was retried once after adding the duplicate guard. It returned HTTP 409 with the identical-active-ticket message. The database remains at one ticket, one logical event, three recipients, three delivery rows, and three sent messages. The guard is Wappler-native and compares the same device, requester type/name, subject, and description against nonterminal tickets; distinct issues remain eligible.
- Event 85 row 163 was marked read through the own-inbox API and then toggled unread/read through the browser row action. Its three email deliveries remained `SENT`, `sent_at` and attempt history unchanged. The other two recipients remained unread. This confirms read-state independence without touching accepted events.

## Notification Center and Browser

- API list, detail, unread count, unread/read filters, event-type filter, search filter, mark-read, mark-unread, and mark-all-read passed against disposable notifications. For the bulk ownership test, temporary test users were created using the documented controlled test-user seed convention: `p9de.schoola.20261017` (user 35, active School Administrator, school 1) and `p9de.schoolb.20261017` (user 36, active School Administrator, school 2). Both identities are test-only. Normal scope APIs assigned each school scope.
- Before mark-all, User A had exactly 3 unread recipient rows (IDs 170, 174, 178; events 87–89); User B had exactly 1 unread row (ID 179; event 90). The real `POST /api/notifications/mark-all-read` was called as User A with forged `user_id`, `recipient_user_id`, and `school_id` fields pointing to User B/school 2. It returned HTTP 200, `marked_count: 3`; all three User A rows received `read_at` and `read_by=35`; User A unread count became 0; User B's row remained unread. The immediate repeat returned HTTP 200, `marked_count: 0`, preserved the original timestamps, and added no second bulk audit row. The request contract has no user/scope parameter; identity is resolved from the authenticated session.
- Browser functional smoke logged in as `portal.admin`, `phase3.school.test`, `phase5b.district.test`, `p7b.ttpost.test`, `p7d.repair.test`, and `p9db.ho.test`. Notification Center loaded with notification data for each. No subjective visual assessment was performed.
- The original school user's ticket-93 notification opened its detail modal; the internal `/tickets/detail?id=93` link was followed successfully and displayed the matching ticket. For the final school-scope check, disposable tickets 94–96 created three School A notifications; ticket 97 created one School B notification. School A (school 1) could open its notification detail and ticket 94 (HTTP 200). School B (school 2) saw only its own ticket-97 notification; School A event 87 was absent from its inbox. Direct detail for recipient 170 and mark-read for recipient 170 both returned HTTP 404 as School B. Direct ticket detail for School A ticket 94 returned HTTP 403. Thus cross-school inbox exclusion, detail/mark-read denial, source-resource RBAC, and School A legitimate access all passed.

## Security Regression

- District isolation: the active Tobago District Coordinator (`p6d.tobago.tech.test`) received HTTP 404 for Caroni recipient row 68.
- TTPost isolation: `p7b.ttpost.test` received HTTP 404 for Repair Centre recipient row 77, HTTP 404 when attempting to mark school recipient 163 read, and HTTP 403 from the delivery-manager API.
- Repair Centre isolation: `p7d.repair.test` received HTTP 200 for its own notification 77 and HTTP 404 for school recipient 65.
- Head Office: `p9db.ho.test` received HTTP 200 for its own Head Office exception notification 142. It also received HTTP 200 for school recipient 163 because the account has `notifications.manage` and active national scope; this matches the existing Phase 9D model's manager inspection permission and national access model. The portal administrator delivery list returned HTTP 200; a forged nonexistent notification ID returned HTTP 404.
- School-to-school ownership was independently exercised with active School A and School B identities on different school scopes; the scope-matrix query returned zero anomalies.

## Scheduler and Delivery

- A disposable manager test event (event 86, delivery `EML-16`) was created for `p7b.ttpost.test` using the fixed `EMAIL_RETRY` test slot and deferred-send option. Controlled test setup placed it in due `RETRY_PENDING` with one recorded retryable attempt.
- The port-3000 native Scheduler processed it naturally at 07:45 AST: state became `SENT`, attempt count moved from 1 to 2, and one successful attempt was added. The next five-minute cycle had occurred by 07:50:41 AST; state, sent timestamp, attempt count, and MailHog message count remained unchanged. MailHog recorded one new matching message at 11:45 UTC.
- The processor query only selects `PENDING` and due `RETRY_PENDING`; the send action explicitly rejects `SENT`, `FAILED_PERMANENT`, `SKIPPED_NO_ADDRESS`, `SKIPPED_INVALID_ADDRESS`, `PROCESSING`, and not-due retries. This was verified statically. The prior Phase 9D-D command report contains natural-cycle tests for not-due and terminal states on its temporary scheduler instance; those states were not all recreated on port 3000.
- Concurrent claim regression: event 91 / delivery `EML-30` was prepared through the protected manager test API for safe recipient `p7b.ttpost.test`, then placed in due `RETRY_PENDING` with `attempt_count=1`, `max_attempts=3`, and one pre-race attempt row. Two simultaneous calls to `POST /api/admin/notifications/email/process-due` both returned HTTP 200 with `processed_count: 1` because that response reports selected due rows, not successful claims. The conditional `RETRY_PENDING`→`PROCESSING` update allowed only one claim/send: the delivery ended `SENT`, attempt count became 2, exactly one new attempt row (`attempt_number=2`, `SENT`) was added, claim token/start fields were cleared, and no delivery remained `PROCESSING`. Exactly one successful-send audit was recorded for delivery 30. MailHog had 2 matching messages to the safe recipient before the race and 3 after it, a delta of exactly 1. No duplicate send occurred.
- SMTP semantics remain at-least-once at the provider boundary if acceptance is ambiguous after provider acceptance but before local `SENT` persistence; the test proves single application claim under concurrent processors, not impossible exactly-once SMTP delivery.

## Database, Ordering, and Audit

- `docs/testing/phase-09d-e-notification-integration-acceptance.sql` is MySQL 5.7 compatible and contains only SELECT statements. It ran successfully: all 28 current checks returned zero, including scope, references, channel fan-out, recipient parity, delivery/attempt integrity, credential scan, triggers, and repair/workflow integrity.
- Across post-fix email-enabled events 84 and 85, cross-channel parity was 6 in-app recipients / 6 email deliveries / 0 user mismatches / 0 missing deliveries. Event 86 is test-only and has no automatic email rule.
- The previously accepted Phase 9D-C read-only matrix was rerun: all 12 required type/reference/scope/action-target/trigger checks returned zero.
- Static workflow ordering remains authoritative transaction first, `notification_from_workflow` second, then per-recipient `notification_email_enqueue`; email sending is isolated in its own Wappler Mailer action and contained catch. No notification/email failure path encloses or rolls back the ticket transaction. No fault-injection endpoint was added.
- Event creation and the actual read/unread transitions were audited. Each fresh email delivery has a `SENT` attempt and `EMAIL_DELIVERY_SENT` audit. The controlled retry setup inserted its initial retryable attempt directly for acceptance; only the naturally sent attempt was generated by Wappler. Old audit rows from the prior cleaned scheduler fixture share recycled numeric IDs with current disposable records; their timestamps predate this run and are retained as historical audit evidence, not counted as duplicate current sends.
- Notification database trigger count: 0. No custom Express route, runtime raw SQL, custom mailer, OS cron, worker, or external queue was introduced.

## Event 83, Event 84, and Historical Exceptions

- Event 83 remains unchanged: 3 intended in-app recipients, 1 historical email delivery, 1 sent. This is the documented pre-fix fan-out defect; it was not backfilled or resent.
- Event 84 remains unchanged: 3 in-app recipients, 3 email deliveries, 3 sent. It remains the accepted corrected fan-out proof and was not resent.
- Historical diagnostic records remain visible and separate from current checks: SLA 3 timestamp anomaly; TKT00000086 / device 69 / LOG00000064 / repair job 40 incomplete failed workflow; diagnostic tickets 79–85; retained append-oriented tickets 87, 89, and 91; and Event 83's pre-fix fan-out gap. None was altered in this run.
- Protected fixtures TKT76, TKT88, TKT90, TKT92, TKT75, TKT71, Phase 8 TL11/TL18/TL20/TL24/PR9, Event 7/8, and EML-10 through EML-12 were not mutated. Event 84 was not resent. The earlier disposable scheduler event 86 remains as previously documented. After acceptance, all final-regression recipient rows 167–180 were marked read through their respective owners' normal API; no accepted notification read state was changed.
- Fresh workflow fixture ticket 93/event 85, scheduler event 86/EML-16, and final regression fixtures tickets 94–97/events 87–90 and event 91/EML-30 are retained because there is no supported cleanup endpoint and notification/audit history is append-oriented. The two test accounts remain active and scoped to schools 1 and 2 so their immutable recipient records remain valid and the current scope matrix stays clean. No accepted fixture was modified, and no database cleanup was performed.

## Final Assessment

- Final Phase 9D-E database matrix: **28 checks, all 0 anomalies**. Historical Event 83 fan-out and previously documented diagnostic records remain informational and unchanged.
- Phase 9D-D email-delivery acceptance rerun: **PASS**; delivery status catalogue/rules and trigger check verified, with no protected delivery resend.
- Relevant Phase 9D-C notification matrix: **12 checks, all 0 anomalies**.
- Current/post-fix notification, recipient scope, fan-out, delivery/attempt, and trigger anomalies: **0**.
- Mark-all ownership, idempotency, and forged-scope isolation: **PASS**.
- Alternate-school scope isolation (school 1 vs school 2): **PASS**.
- Simultaneous email-delivery claim: **PASS**, exactly one successful claim/send, attempt, audit, and MailHog message added.
- Accepted/protected fixtures remain unchanged: Events 7/8 and 84/85; tickets 71, 75, 76, 88, 90, 92, 93; logistics 61, 63, 66, 68; SLA 3/8/9; escalation cases 3/4; repair jobs 42/44; Phase 8 golden fixtures; and EML-10 through EML-12. Event 83 remains its documented pre-fix historical exception. The final test added only new IDs 35–36 (test users), devices/tickets 94–97, events 87–91, and delivery EML-30.

**Phase 9D-E command acceptance: PASS.**
**Phase 9D-E status: READY FOR FINAL USER VISUAL SANITY CHECK.**
**Phase 9D overall status: READY TO CLOSE.**
**Next phase: NOT STARTED.**
