# User administration acceptance report

Date: 2026-10-18. Status: **Ready for user GUI acceptance.** Implementation and required yarycling functional acceptance are complete. No subjective visual acceptance was performed; visual review belongs to the user.

## Environments and account protection

API/database tests used the local portal on localhost:3000 and clearly marked `ua.acceptance.1792321659472…` disposable accounts. Functional browser and last-administrator race tests used the same application in an isolated local database/server on port 3107. This allowed testing destructive failure cases without changing the real administrator.

The real `yarycling` account was never deactivated, demoted or given a new password by these tests. Cleanup verified its username, email, password hash, active status and auth_version unchanged, with SUPER_ADMIN as its sole role. All 11 live disposable users, their fixture scope/credential records, two schools and one repair location were removed after private backup. Audit history was retained. The live greenfield baseline contains **yarycling only**.

## Command and database results

| Area | Result |
|---|---|
| All eight existing groups | Creation, role mapping, authoritative scope, audit, setup mail/hash/purpose/15-minute expiry verified |
| Negative validation and multi-group tests | 20/20 passed on corrected implementation |
| Final API/concurrency/regression tests | 11/11 passed |
| Password-policy regressions | 10/10 passed |
| Isolated sole-admin/concurrency/rollback tests | 8/8 passed |
| Simulated Mailer failure | User retained and failure audited: both passed |
| Latest user-detail permission query | Active and inactive configured-permission summaries passed |
| Database acceptance | 24/24 zero-violation SELECT checks before and after cleanup |
| Migration | Applied and reapplied successfully |
| Syntax | 19 relevant JSON files parsed; six admin EJS templates compiled using Wappler's async EJS settings |

The initial broad API run found a Wappler catch-array shape error: 14 rejection checks returned an empty HTTP 200 instead of the intended safe validation response. No partial users were created. The error handlers were corrected and all affected cases passed in the subsequent 20-check suite. An initial standalone EJS check omitted async mode; rerunning with the application's async setting passed. These were resolved verification defects, not omitted failures.

Validation covered duplicate username/email, missing/bad email, malformed/forged/unassignable role inputs, missing/invalid/incompatible scopes, school/district mismatch, repair-location mismatch, invalid status, duplicate groups, immutable username, stale edit and multiple-group persistence. Anonymous callers were denied; non-admin callers could not list or create users.

A disposable school administrator authenticated successfully, then changed to district coordinator: the prior session failed, the old school scope was revoked, new district scope became authoritative and new access context matched. Deactivation invalidated credentials and sessions, denied new login and generated audit. Reactivation restored valid login but rejected an inactive school scope. Version-guarded updates passed.

Concurrent duplicate creation committed one user. Concurrent credential issuance retained one current credential. Setup completion supported passphrases with spaces, rejected weak/common/account-derived/mismatched/oversized/reused passwords, consumed the link and permitted login. Resend invalidated the first link. Expired links failed. Admin reset email did not immediately change the password. Public forgot-password remained generic and enforced throttling.

In the isolated database, sole-admin deactivation and demotion returned the mandatory rejection. Two concurrent admin deactivations and two concurrent role removals each allowed only one successful change and preserved one active administrator. Induced audit failure rolled back profile and security changes. 

## Browser functional verification

Passed using a disposable isolated Super Administrator:

- Administration menu, Users list and read-only Security Groups page.
- Add User, native required validation and security-group selection.
- School-dependent scope controls and district-filtered school options.
- Successful creation and setup-mail result; matching list filters and detail navigation.
- Hydrated edit controls, immutable username, profile update and school-to-district access change.
- Deactivation confirmation, inactive detail and reactivation.
- Resend setup and send password reset with audit feedback.
- Correct per-group permission summaries and no role-edit controls.
- Functional responsive checks at widths 1440, 1024, 768 and 375: form controls remained within their containers and tables used responsive containment.

Browser testing found and corrected a client formatter argument order issue in per-group permission filtering and a district-array serialization issue in school options. The corrected behavior was verified in the browser.

Functional evidence: `docs/testing/evidence/user-administration-functional.png` shows the disposable account detail after its group/scope change. It is functional evidence only, not visual sign-off.



## Database checks and handoff

`docs/testing/user-administration-acceptance.sql` is SELECT-only. It checks normalized identity uniqueness, valid/assignable group mappings, required/current compatible scopes, school/district integrity, scope entity validity, last-admin invariant, hash-only credential/password storage, auth_version, audit secrecy, absence of security triggers, one active credential, duplicate active scopes and expiry policy. All 24 checks passed after the live database was restored to the greenfield baseline.

Model: `docs/security/user-administration-model.md`. Migration: `database/user_administration.sql`. No manual Wappler restart required in the tested local environment. Next: user visual acceptance, then continue greenfield top-down application retesting.

## Final yarycling acceptance

A real login through the portal form succeeded for yarycling and opened the Super Administrator dashboard. The authenticated session was verified through /api/auth/me: username yarycling, email yarycling@yahoo.com, status active. Protected Users and Security Groups pages loaded in the authenticated session, confirming current authorization and session-version validity. The credential was not recorded or changed.

- Administration navigation exposed Users and Security Groups. /admin/users displayed the single yarycling account with SUPER_ADMIN, Global scope and ACTIVE status.
- /admin/security-groups displayed all eight expected predefined groups, descriptions, scope summaries, permissions, and counts. SUPER_ADMIN count was 1. The page exposed no role-edit/delete actions.
- The user detail showed the expected profile, active status, SUPER_ADMIN, Global scope, security dates, all portal permissions and recent activity. No password hash, credential hash, session ID or raw token appeared.
- GUI self-deactivation and GUI replacement of SUPER_ADMIN with MOE Head Office were both rejected with “At least one active Super Administrator must remain.”
- Direct same-origin API submissions to deactivate the account and remove its last SUPER_ADMIN role returned the same rejection. Forged role, forged district, SUPER_ADMIN with incompatible district scope, invalid status and missing create fields each returned safe validation errors. Database reads after the attempts confirmed no partial access change, and auth_version remained unchanged. Invalid-user calls to reactivate, setup email and reset email also reached their authenticated validation paths without changing data. List, detail, form-options and group-list authorization were exercised through the live pages.
- A safe profile edit changed the display name through the GUI and restored its original value. Username, email, role, scope, status, password and auth_version remained unchanged; append-only audit entries remain.
- The detail page now hides “Resend setup email” for established accounts and shows “Send password reset email.” That visibility was confirmed for yarycling.
- The existing Mailer targets 127.0.0.1:1025. One reset email was sent and captured in local MailHog: the captured count rose from 28 to 29, with one message to yarycling and subject “Reset your TSTT Laptop Portal password.” The password hash, status and auth_version remained unchanged, and /api/auth/me still succeeded afterward. The reset link was not opened. The unused hash-only reset credential was invalidated after verification.
- No page or API returned a 500 during these checks.

The final database check ran after the email request was invalidated: all 24 SELECT-only acceptance checks passed with zero anomalies. The live database has one user, yarycling; email yarycling@yahoo.com; active status; one SUPER_ADMIN role; Global access with no artificial scope row; no active setup/reset credential; and no disposable accounts. The original display name, password hash and auth_version were verified restored/unchanged. Audit records from the explicitly requested safe profile edit and reset-email action were retained.

Feature status: READY FOR USER GUI ACCEPTANCE. Functional browser acceptance passed; Codex did not perform subjective visual acceptance. No user terminal commands or Wappler restart are required.

Model: docs/security/user-administration-model.md. Migration: database/user_administration.sql. Select-only checks: docs/testing/user-administration-acceptance.sql. Prior disposable-account functional evidence: docs/testing/evidence/user-administration-functional.png.
