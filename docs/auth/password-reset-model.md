# Password Reset and Session Revocation

## Design

The reset credential is a **PUBLIC REQUEST IDENTIFIER + ARGON2ID SECRET VERIFIER**.
The indexed `request_id` locates one reset row but is not a credential. A separate
256-bit Wappler OTP secret is included in the email link and stored only as the
project's Argon2id password hash. Wappler's `crypto.passwordVerify` validates the
provided secret. The raw secret is never written to the database.

Reset links expire after 15 minutes. The request is claimed using a conditional
update inside a Wappler transaction, so concurrent submissions cannot both claim
the same unused row. The transaction updates the password, increments the account
version, marks the request used, invalidates the user's other reset requests, and
writes security audit events. Confirmation email is sent after commit; delivery
failure does not undo the password change.

## AUTH_VERSION SERVER-SIDE SESSION REVOCATION

`users.auth_version` is initialized to 1. Successful login stores that database
value in the server-side `portalSecurityAuthVersion` session variable. The
Wappler Server Connect Global Action in `app/modules/global.json` identifies the
Security Provider user and compares the current active database account/version
with the session value before every Server Connect action. Missing or stale
versions fail closed: APIs receive 401; page requests log out and redirect to the
sign-in screen. Successful password reset increments the database version in the
same transaction as the password update. Existing sessions are rejected on their
next protected request; reset does not auto-login the user.

This guard uses the Wappler global-action execution point. Wappler's route-level
page restriction remains in place as a separate authentication check.

## Request and Password Policy

- The public request accepts a username or email and always returns the same
  success message, including for missing, disabled, or email-less accounts.
- Eligible requests are limited to three issuances per account in a rolling
  15-minute window. The account-row update serializes the count/insert section.
- A source-IP limit is not enabled. This deployment has Express
  `trust proxy` enabled, so `req.ip` may be derived from client-supplied forwarded
  headers and is not a reliable security boundary without trusted-proxy
  configuration. No browser-supplied address is used.
- Passwords must be 15–128 characters; spaces and passphrases are allowed. No
  character-composition rule is imposed. A small common-password list, username
  matches, email address/local-part matches, confirmation mismatch, and reuse of
  the current password are rejected server-side. The strength meter is advisory
  only.
- The reset page uses the local auth layout, local assets, and
  `Referrer-Policy: no-referrer`; it does not load third-party resources.
- Reset links use `APP_BASE_URL`, with a development default of
  `http://localhost:3000`. Set that environment variable to the trusted HTTPS
  production origin in deployment; the request Host header is not used.
- The existing Wappler Mailer sends the reset and post-reset confirmation emails.

## Schema and Operations

Apply `database/phase_password_reset.sql` once after the existing auth/RBAC schema.
It adds the user version/throttle fields and `password_reset_requests`. The
migration also changes only the known greenfield placeholder email for username
`yarycling` (`yarycling@localhost` to `yarycling@yahoo.com`); it does not change
that account's role, status, or password. If the placeholder has already been
changed, the correction is a no-op. The greenfield reset script truncates reset
requests before clearing users.

All runtime persistence, hashing, token validation, email delivery, and session
version handling are Wappler Server Connect / Security Provider actions. There
are no new custom Express routes, runtime raw SQL queries, custom crypto, session
store manipulation, or triggers.
