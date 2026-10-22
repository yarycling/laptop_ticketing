# User & Security Group Administration

Implemented 2026-10-18. This module uses the existing Wappler Security Provider, Server Connect, Database components/transactions, Mailer, App Connect and Bootstrap 5 shell. No custom runtime authentication, routes, SQL workflows, session store, mailer, role builder or database triggers were introduced. Security Groups is the user-facing name for existing roles.

## Existing security model

- User table: `users`.
- Role table: `roles`; mapping: `user_roles` (composite user/role key). The existing model supports multiple roles per user, and authorization combines their permissions and scopes.
- Permission tables: `permissions`, `role_permissions`; existing permission guard: `security_require_permission`; administrator guard: `security_require_super_admin`.
- Scope tables: `user_national_scopes`, `user_district_scopes`, `user_school_scopes`, `user_service_location_scopes`. Multiple assigned districts, schools and repair locations are supported by the existing schema.
- Existing permissions reused: `users.view`, `users.create`, `users.update`, `users.disable`, `roles.view`, `user_scopes.manage`. No parallel `users.manage` or `security_groups.view` permission was created. All new admin actions also require SUPER_ADMIN server-side.
- Role metadata in `role_administration_profiles` describes assignability and scope requirements; it does not replace roles or authorize requests independently.

## Group and scope rules

| Existing role | Scope assigned by administration |
|---|---|
| SUPER_ADMIN | Global; no artificial scope record |
| MOE_HEAD_OFFICE | National |
| TSTT_OVERSIGHT | National |
| ICT_DISTRICT_COORDINATOR | One or more active districts |
| ICT_TECHNICAL_OFFICER | Assigned active schools, filtered by active district(s) |
| SCHOOL_ADMINISTRATOR | Assigned active schools, filtered by active district(s) |
| REPAIR_CENTRE | Active REPAIR_CENTRE service locations |
| TTPOST_LOGISTICS | Existing role-wide national logistics access; no general national scope record |

Technical-officer school assignment follows AGENTS.md's assigned-school model and the notification scope documentation. Existing broader scope inheritance remains in legacy authorization guards; this form grants the explicit school scope. TTPost follows the approved logistics model (`docs/phase-07-logistics-model.md`); it does not gain unrelated national access.

For multiple groups, scopes represent the union needed by the selected groups. Global access supersedes all explicit scopes. National organisational access supersedes district/school scope records; a separate repair-location requirement is retained unless the user is global. Selected school districts filter valid choices and are checked against authoritative school records; district IDs are not duplicated on school scope rows.

## Pages and actions

- `/admin/users`: search name/username/email; group/status/district filters; 25 users per page.
- `/admin/users/new`: profile, multiple security groups and appropriate scope; no administrator-created password.
- `/admin/users/detail?user_id=…`: safe profile, configured groups/scopes/permissions, security dates and latest 30 administration events; email and status actions.
- `/admin/users/edit?user_id=…`: immutable username, profile/security updates; deactivation confirmation.
- `/admin/security-groups`: read-only definitions, permission summary, scope type and user count.

Server Connect APIs under `app/api/admin/users/`: `list`, `detail`, `form-options`, `create`, `update`, `deactivate`, `reactivate`, `send-setup`, `send-password-reset`. Group listing uses `app/api/admin/security-groups/list.json`. Form options return current assignable roles, active districts, district-filtered schools and active repair locations. School options are bounded to 1,000 records per request.

The old organisation scope assignment/revoke actions return a safe conflict directing administrators to Users, preventing a second mutation path from bypassing role/scope validation and session invalidation. The organisation page links to the new interface.

## Creation and lifecycle

Names, normalized unique username/email, assignable roles, compatible active scope entities and active/disabled status are validated server-side. Username uses lowercase letters, digits, dots, underscores and hyphens. Cross username/email collisions are rejected to keep login/recovery identity unambiguous. Existing locked accounts remain visible; edits must explicitly choose Active or Inactive.

Creation atomically writes the user, groups, scope and audit. An unpredictable generated password is hashed and discarded; neither administrator nor email recipient receives it. After commit the shared email library issues a setup credential and sends the setup message. Delivery failure retains the user and returns a safe resend instruction. SMTP details are not exposed.

On the user detail page, resend setup is shown only while the account has no recorded password change. Established active accounts are offered password reset instead.

Inactive accounts remain in the application with their attribution/history intact. Deactivation prevents login, advances `auth_version` and invalidates setup/reset credentials. Reactivation validates current groups and scope entities; it cannot silently restore obsolete access. No normal-user hard-delete UI exists.

## Security changes and last-administrator protection

`user_admin_mutate` serializes administration mutations by updating singleton `user_administration_lock` inside a Wappler Database Transaction. It then revalidates the authenticated actor's active status, session version and SUPER_ADMIN role. Role and scope replacement is atomic; prior scopes are revoked with attribution, preserving history. Old/new role and scope context is audited. Version predicates on user updates detect concurrent credential/security changes.

Profile editing uses the supplied current `auth_version` for stale-edit rejection. Role, scope, email and status changes advance `auth_version`; existing global auth-version enforcement rejects the next protected request from an old session. Outstanding setup/reset credentials are invalidated when security/email/status changes make them obsolete.

Inside the same serialized transaction, deactivation or removal of SUPER_ADMIN requires another active SUPER_ADMIN. Rejection text is: “At least one active Super Administrator must remain.” Direct API calls use the same guard. Concurrent attempts cannot each count the other administrator and leave zero active administrators. Self-deactivation/demotion is permitted only when another active administrator remains; the caller's old session then fails its next protected request.

## Setup and password recovery

`password_email_issue` is shared by public forgot-password and authenticated setup/reset actions. It reuses native random-secret generation, a 52-character public request identifier, Argon2id hash-only storage and 15-minute expiration. `password_reset_requests.purpose` distinguishes ACCOUNT_SETUP and PASSWORD_RESET. Per-user serialization invalidates previous unused credentials before issuance. Token secrets are present only in the recipient's email link, never returned to the admin or stored in plaintext.

Public forgot-password retains generic enumeration-safe responses and the existing account throttle. Authenticated administrators receive explicit safe delivery outcomes. The existing Wappler Mailer and branded email templates are reused. The setup message contains username and group labels, a Set Password link and expiration notice; no temporary password or hash.

Setup and reset use the accepted 15–128-character password policy, spaces/passphrases, common-password and account-derived-password rejection, confirmation and strength indicator. Successful completion consumes the credential, invalidates outstanding credentials, stores Argon2id and advances the auth version. Sending an email alone never changes a user's password.

## Audit

Existing `audit_logs` stores actor, target user, timestamp and safe context. Events include USER_CREATED, USER_PROFILE_UPDATED, USER_SECURITY_GROUP_CHANGED, USER_SCOPE_CHANGED, USER_DEACTIVATED, USER_REACTIVATED, ACCOUNT_SETUP_EMAIL_SENT/FAILED and ADMIN_PASSWORD_RESET_EMAIL_SENT, plus shared credential-request/completion events. Audit failure within an administration transaction rolls back profile/access changes. Passwords, hashes and raw credential URLs are excluded from audit and admin responses.

## Migration and operation

Apply repeatable `database/user_administration.sql` through controlled database administration. It adds the lock/profile metadata, purpose column and safe read-model views. Runtime actions use Wappler Database components against those tables/views. The migration was applied and reapplied locally. No dependency/runtime versions were changed; no manual Wappler restart is currently required.

See `docs/testing/user-administration-test-report.md` for evidence and outstanding acceptance. Production Mailer configuration remains the existing deployment configuration; local delivery was verified using MailHog.
