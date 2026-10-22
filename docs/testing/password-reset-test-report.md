# Forgot Password / Secure Password Reset Test Report

## Architecture and Static Checks

| Check | Result | Evidence |
|---|---|---|
| Arbitrary-token Argon2id | PASS | Wappler OTP secret generation, passwordHash, and passwordVerify were exercised; the correct secret verified and a modified secret failed. The secret was not recorded. |
| Auth-version guard | PASS | `app/modules/global.json` identifies the Security Provider user and checks active status plus the server-side session version on Server Connect requests. |
| Wappler-native implementation | PASS | Runtime work uses Server Connect, Security Provider, database actions/transactions, Wappler crypto, and the configured Mailer. No custom Express route, runtime SQL, crypto, or session-store manipulation was introduced. |
| Wappler JSON/EJS validation | PASS | Eight relevant JSON files parsed; four EJS templates compiled with the async mode used by Wappler. No unsupported `operation: is null` filters remain in auth actions. |
| Trigger check | PASS | Database trigger count is 0. |

## Command Acceptance

Command acceptance was run against localhost using disposable, active accounts
with no operational roles. No reset token or test password is recorded here.

| Check | Result | Evidence |
|---|---|---|
| Generic response / enumeration | PASS | Existing username, existing email, nonexistent username/email, disabled account, and no-email account returned the same generic response. SQL-like and script-like identifiers also returned the generic response. |
| Reset issuance and Mailer | PASS | Wappler response was generic; the request row used a separate public identifier and Argon2id secret hash; MailHog received the reset message. |
| Token verification | PASS | Correct token passed; modified token and mismatched request identifier failed. Missing/oversized inputs were rejected. |
| Expiry, use, supersession | PASS | An expired disposable request returned `valid:false` and could not be submitted; used and superseded requests were rejected. |
| Password rules | PASS | Too short, over maximum, blocklisted, username-derived, email-derived, current-password reuse, and confirmation mismatch were rejected. A policy-compliant reset succeeded. |
| Single-use concurrency | PASS | Two simultaneous submissions: one HTTP 200 success and one generic HTTP 400 invalid/expired response. Exactly one new token use, auth-version increment, and completion audit occurred. No internal action output was returned to the losing request. |
| Session revocation | PASS | Two independent sessions were authenticated before reset; both received 401 on their next protected request. Old-password login failed and new-password login succeeded. |
| Account rate limit | PASS | Three test-account reset emails were issued in the 15-minute window; the fourth attempt returned the same generic response and created/sent no additional request. |
| Normal password change | PASS | A pending reset link was invalidated by the authenticated password-change workflow. That workflow does not change `auth_version`, preserving its existing session behavior. |
| Raw-token storage | PASS | Reset rows store Argon2id hashes; the schema has no raw-token field. |

The account-row timestamp of only the disposable acceptance accounts was moved
outside the 15-minute window between isolated rate-limit/expiry/race runs. One
disposable request expiry was moved into the past to exercise expiry behavior.
No production or existing user account was modified for these tests.

The source-address request cap is not enabled. The current Express `trust proxy`
setting means forwarded-IP-derived `req.ip` is not a reliable security boundary
without trusted-proxy configuration. No browser-supplied address is trusted.
The account-based limit is active and tested.

## Database Acceptance

`docs/testing/password-reset-acceptance.sql` was executed read-only after
migration. It confirmed the required `auth_version` and reset-request fields,
Argon2id hashes for all rows present at that check, and zero reset-related
triggers. The greenfield administrator remained `yarycling@yahoo.com`, active,
with role `SUPER_ADMIN`; its password was not changed.

## Browser and User Acceptance

The forgot-password screen was opened in the browser and its initial state
verified: success/error alerts are hidden and the submit control is enabled. A
test-account request was submitted through the UI; the generic confirmation
appeared and further submission was disabled. An active reset link remains
available in MailHog for the disposable GUI account below.

The reset form/password-strength interaction and final password submission were
not completed in the browser. The API acceptance covered the successful reset;
the user should perform the final browser reset flow using the disposable account.

## GUI Acceptance Fixture

- Username: `p9reset.flow.20261017`
- Email: `p9-reset-flow-20261017@example.invalid`
- State: active, no operational role, one valid unused reset link in MailHog at
  the time this report was updated.
- Open `http://localhost:8025`, find the latest “Reset your TSTT Laptop Portal
  password” message for this fixture, and open its link. Do not reuse earlier
  messages; they may be superseded or expired.
- Verify the password fields start masked, strength guidance updates, mismatch
  is rejected, and the generic forgot-password message does not reveal account
  state. The browser reset submission changes this disposable account's
  password; after submission, use the new password for any further testing.

## Deployment Notes

Apply `database/phase_password_reset.sql` once after the existing auth/RBAC
schema. Set trusted production `APP_BASE_URL` to the HTTPS portal origin. The
local Wappler instance picked up and served the changed actions during command
acceptance; restart/reload the deployed Wappler target so the migration, routes,
actions, and Global Action are active. Pre-existing sessions without an
`auth_version` session value are intentionally required to sign in again.


## Strength indicator regression — 2026-10-17

Confirmed in an isolated browser preview using the actual reset view, auth layout, and Wappler assets, with token validation removed and submission disabled only in the temporary preview. No account password was changed.

- Reproduced the original stuck label and empty meter: App Connect does not resolve the string `.length` property.
- Changed bindings to the native `.length()` formatter. Wappler installed its official formatter asset through the GUI; the auth layout loads it.
- Verified lengths 0, 1, 7, 8, 11, 12, 14, 15, 19, 20, and 128: label, bar classes, and accessible meter value update live. Clearing restores “Enter a password” and zero active bars.
- Corrected visibility variables to boolean false; both fields start masked, and showing/hiding the new password preserves the strength result.
- Existing length-based guidance and server-side password acceptance rules are unchanged.


## Strong-password submission requirement — 2026-10-17

- Reset submit is disabled for empty passwords, lengths below 15 or above 128, empty/mismatched confirmation, invalid reset links, and an executing request. The existing meter rates 15–19 characters Strong and 20+ Very strong.
- Removed `novalidate` so the native Wappler form validation enforces required/minimum/maximum constraints before submission. Added visible and associated guidance explaining the requirement.
- Browser-verified in an isolated preview with a non-account endpoint: matching lengths 0, 7, 8, 12, and 14 kept submit disabled; 15, 20, and 128 enabled it; a mismatch disabled it again. Enter with a 12-character password did not submit.
- Inspected the unchanged Server Connect action: it rejects lengths below 15 or above 128 and mismatches before password writes, alongside existing blocklist, account-derived, and reuse checks. No account reset or database mutation was performed.
