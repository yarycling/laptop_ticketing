# Phase 2 Auth/RBAC Test Report

Test date: 2026-10-06  
Application environment: Local Wappler Node/Express runtime  
Database used: MySQL/MariaDB-compatible local database `laptop_tickets_db` via `mysql2`  
Server port: `3001`

## PHASE 2A ARCHITECTURE REMEDIATION

Status: Partially Completed

Phase 2A reviewed the Phase 2 authentication/RBAC build against the project rules. The runtime is now aligned to the MySQL/MariaDB target, connection files use environment placeholders instead of committed credentials, the Phase 2 schema script is MySQL/MariaDB-compatible, and the local migration was applied successfully.

The custom Server Connect extension `extensions/server_connect/modules/portal_auth.js` still exists. It was reviewed action-by-action and reduced where practical: runtime raw SQL was removed, date writes were changed to MySQL-compatible `DATETIME` values, and login session establishment now delegates to Wappler Security Provider `portalSecurity` through provider validation/login instead of manually writing Wappler session keys. The extension remains because this stripped-down project does not include Wappler GUI-generated native Server Connect action files that can fully replace the bootstrap/admin/RBAC helper operations in this remediation pass.

Final architecture verdict: FAIL for full Phase 2A compliance because custom auth/RBAC runtime remains. Runtime verification verdict: PASS for the 32-test auth/RBAC matrix below.

## Extension Review

| Extension action | Current use | Wappler-native replacement path | Phase 2A status |
| --- | --- | --- | --- |
| `setup_status` | Counts users for setup gate | DB count action + condition | Still in extension |
| `initial_admin` | Validates and creates bootstrap admin, assigns SUPER_ADMIN, writes audit | Wappler validators + password hash + DB transaction/actions | Still in extension |
| `login` | Normalizes identifier, uses `portalSecurity.validate/login`, updates login timestamp/audit | Wappler Security Provider login + DB update/audit actions | Still in extension; now delegates session creation to `portalSecurity` |
| `logout` | Writes audit and calls `portalSecurity.logout` | Wappler Security Provider logout + DB audit action | Still in extension |
| `me` | Returns safe current-user profile | Security identify + DB single query | Still in extension |
| `context` | Returns roles, permissions, super-admin flag | DB query/repeat/actions | Still in extension |
| `change_password` | Verifies current password, hashes new password, audits | Wappler crypto/password actions + DB update/audit | Still in extension |
| `require_permission` | Server-side permission guard helper | Wappler Security Restrict for fixed permissions + DB conditions | Still in extension |
| `require_super_admin` | Server-side role guard helper | Wappler Security Restrict/DB condition | Still in extension |

## Remediation Notes

- `portal_auth.js` removed: No.
- `portal_auth.js` still required: Yes, temporarily, because equivalent Wappler-native action files were not available to regenerate safely in this code-only pass.
- Wappler Security Provider: `portalSecurity` remains configured in `app/modules/SecurityProviders/portalSecurity.json` and is used for login validation/session establishment.
- Database engine: MySQL/MariaDB via `mysql2`; `.wappler/project.json` and connection JSON now target MySQL-compatible configuration.
- Runtime raw SQL: None found in `app`, `extensions`, `public/js`, or `views`. SQL remains only in the schema/migration file.
- Custom auth runtime: Present, limited to `extensions/server_connect/modules/portal_auth.js`.
- Wappler runtime modifications: None.
- GUI regression: Phase 1 GUI files were not redesigned in Phase 2A; only security/runtime configuration was remediated.

## 32-Test Matrix

| Test | Scenario | Expected | Actual | Result |
| --- | --- | --- | --- | --- |
| 01 | Setup status endpoint | Returns initialized state | HTTP 200 with initialized boolean | PASS |
| 02 | Anonymous root access | Redirected or denied | Protected route redirected/blocked | PASS |
| 03 | Anonymous `/api/auth/me` | Denied | HTTP 401 | PASS |
| 04 | Initial admin setup | Creates admin or reports setup already initialized | HTTP 409 in remediated database with existing admin | PASS |
| 05 | Second setup attempt | Blocked | HTTP 409 | PASS |
| 06 | Wrong password login | Denied with generic failure | HTTP 401 | PASS |
| 07 | Unknown user login | Denied with generic failure | HTTP 401 | PASS |
| 08 | Username login | Authenticated | HTTP 200 | PASS |
| 09 | Authenticated `/api/auth/me` | Safe user fields only | HTTP 200; no password/hash/token fields | PASS |
| 10 | Auth context shape | Roles and permissions returned | HTTP 200 with roles/permissions arrays | PASS |
| 11 | Super admin role | SUPER_ADMIN present | SUPER_ADMIN and `is_super_admin=true` | PASS |
| 12 | Permission catalogue | Super admin receives seeded permissions | 25 permissions returned | PASS |
| 13 | Authenticated dashboard route | Dashboard HTML loads | HTTP 200 authenticated dashboard shell | PASS |
| 14 | Logout | Session termination succeeds | HTTP 200 | PASS |
| 15 | Session after logout | Protected API denied | HTTP 401 | PASS |
| 16 | Email login | Authenticated | HTTP 200 | PASS |
| 17 | Super admin permission guard | Allows `dashboard.view` | HTTP 200 | PASS |
| 18 | Super admin guard | Allows super admin | HTTP 200 | PASS |
| 19 | Anonymous permission guard | Denied | HTTP 401 | PASS |
| 20 | Anonymous super-admin guard | Denied | HTTP 401 | PASS |
| 21 | Change password wrong current | Rejected | HTTP 400 | PASS |
| 22 | Change password mismatch | Rejected | HTTP 400 confirmation mismatch | PASS |
| 23 | Change password success | Accepted | HTTP 200 | PASS |
| 24 | Old password after rotation | Rejected | HTTP 401 after successful rotation | PASS |
| 25 | New/current password after rotation | Accepted | HTTP 200 | PASS |
| 26 | Temporary limited user seed | Test user can be created and cleaned up | Seeded and removed | PASS |
| 27 | Limited user login | Authenticated | HTTP 200 | PASS |
| 28 | Limited user assigned permission | Allows `dashboard.view` | HTTP 200 | PASS |
| 29 | Limited user unassigned permission | Denies `users.disable` | HTTP 403 | PASS |
| 30 | Duplicate username | Blocked | MySQL unique constraint rejected duplicate username | PASS |
| 31 | Duplicate email | Blocked | MySQL unique constraint rejected duplicate email | PASS |
| 32 | Server Connect JSON validity | All app JSON parses | 16 app JSON files parsed successfully | PASS |

Critical tests required by Phase 2A all passed at runtime: 02, 03, 04, 06, 07, 08, 09, 10, 11, 12, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 30, 31, and 32.

## Verification Commands

- Applied MySQL migration with `database/phase_02_auth_rbac.sql`.
- Started app with `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`, and `WAPPLER_SERVER_PORT=3001`.
- Ran local HTTP/MySQL auth/RBAC verification against `http://localhost:3001`.
- Ran static syntax check for `extensions/server_connect/modules/portal_auth.js`.
- Parsed all `app/**/*.json` files successfully.
- Searched for runtime raw SQL patterns in `app`, `extensions`, `public/js`, and `views`; none found.

## Admin Password Note

The local development admin account remains in the local MySQL database. No password, password hash, session ID, or token is recorded in this report.

## Required Next Step

Before Phase 3, rebuild the remaining `portal_auth.js` operations as Wappler-native Server Connect actions through Wappler's GUI/action system, then remove the custom extension and rerun this same 32-test matrix.
