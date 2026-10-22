# Phase 2B User Test Plan

This test pack is for manual acceptance testing by the user. Do not store administrator, limited-user, or database passwords in this file.

## A. COMMAND-LINE TESTS

Open Terminal A and start the app. If the app is already running, stop it first and restart it because Server Connect API JSON is loaded when the Node server starts:

```zsh
cd /Users/jamesthomas/mobileApps/ticketing_solution
export DB_HOST="127.0.0.1"
export DB_PORT="3306"
export DB_NAME="laptop_tickets_db"
read -r "DB_USER?MySQL user: "
read -s "DB_PASSWORD?MySQL password: "
echo
export DB_USER DB_PASSWORD
export WAPPLER_SERVER_PORT="3000"
npm start
```

Open Terminal B and set shared test variables:

```zsh
export BASE_URL="http://localhost:3000"
export COOKIE_JAR="/tmp/tstt_ticketing_auth.cookies"
export LIMITED_COOKIE_JAR="/tmp/tstt_ticketing_limited.cookies"
rm -f "$COOKIE_JAR" "$LIMITED_COOKIE_JAR"
read -r "ADMIN_USERNAME?Admin username: "
read -r "ADMIN_EMAIL?Admin email: "
read -s "ADMIN_PASSWORD?Admin password: "
echo
```

TEST C01 - server starts:

```zsh
curl -sS -o /tmp/tstt_c01.txt -w "%{http_code}\n" "$BASE_URL/login"
```

Expected: `200`.

TEST C02 - unauthenticated `/` redirects to `/login`:

```zsh
curl -sS -o /tmp/tstt_c02.txt -w "%{http_code} %{redirect_url}\n" "$BASE_URL/"
```

Expected: `302` and `/login`.

TEST C03 - invalid login fails:

```zsh
curl -sS -i -X POST "$BASE_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  --data '{"login_identifier":"bad.user","password":"WrongPassword123!"}'
```

Expected: HTTP `401` with generic message `Invalid username/email or password.`

TEST C04 - username login succeeds:

```zsh
curl -sS -i -c "$COOKIE_JAR" -b "$COOKIE_JAR" -X POST "$BASE_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  --data "{\"login_identifier\":\"$ADMIN_USERNAME\",\"password\":\"$ADMIN_PASSWORD\"}"
```

Expected: HTTP `200` and JSON success.

TEST C05 - authenticated `/` succeeds:

```zsh
curl -sS -o /tmp/tstt_c05.html -w "%{http_code}\n" -b "$COOKIE_JAR" "$BASE_URL/"
```

Expected: `200` and dashboard HTML in `/tmp/tstt_c05.html`.

TEST C06 - `/api/auth/me`:

```zsh
curl -sS -b "$COOKIE_JAR" "$BASE_URL/api/auth/me"
```

Expected: safe user fields only: `id`, `username`, `email`, names, `display_name`, `status`; no password hash or session internals.

TEST C07 - `/api/auth/context`:

```zsh
curl -sS -b "$COOKIE_JAR" "$BASE_URL/api/auth/context"
```

Expected: `authenticated:true`, safe `user`, `roles`, `permissions`, and `is_super_admin`.

TEST C08 - verify SUPER_ADMIN role:

```zsh
curl -sS -b "$COOKIE_JAR" "$BASE_URL/api/auth/context" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const j=JSON.parse(s);console.log(j.roles.includes("SUPER_ADMIN"), j.is_super_admin)})'
```

Expected: `true true`.

TEST C09 - verify permissions returned:

```zsh
curl -sS -b "$COOKIE_JAR" "$BASE_URL/api/auth/context" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const j=JSON.parse(s);console.log(j.permissions.length, j.permissions.includes("dashboard.view"))})'
```

Expected: permission count greater than zero and `true`.

TEST C10 - logout:

```zsh
curl -sS -i -b "$COOKIE_JAR" -c "$COOKIE_JAR" -X POST "$BASE_URL/api/auth/logout"
```

Expected: HTTP `200` and JSON redirect `/login`.

TEST C11 - prior session cannot access protected resources:

```zsh
curl -sS -o /tmp/tstt_c11.html -w "%{http_code} %{redirect_url}\n" -b "$COOKIE_JAR" "$BASE_URL/"
curl -sS -i -b "$COOKIE_JAR" "$BASE_URL/api/auth/me"
```

Expected: dashboard request redirects to `/login`; `/api/auth/me` returns HTTP `401`.

TEST C12 - email login:

```zsh
curl -sS -i -c "$COOKIE_JAR" -b "$COOKIE_JAR" -X POST "$BASE_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  --data "{\"login_identifier\":\"$ADMIN_EMAIL\",\"password\":\"$ADMIN_PASSWORD\"}"
```

Expected: HTTP `200`.

TEST C13 - change password with wrong current password:

```zsh
read -s "NEW_ADMIN_PASSWORD?Temporary new admin password for test: "
echo
curl -sS -i -b "$COOKIE_JAR" -X POST "$BASE_URL/api/auth/change_password" \
  -H "Content-Type: application/json" \
  --data "{\"current_password\":\"WrongPassword123!\",\"new_password\":\"$NEW_ADMIN_PASSWORD\",\"confirm_password\":\"$NEW_ADMIN_PASSWORD\"}"
```

Expected: HTTP `400` with safe validation error.

TEST C14 - change password confirmation mismatch:

```zsh
curl -sS -i -b "$COOKIE_JAR" -X POST "$BASE_URL/api/auth/change_password" \
  -H "Content-Type: application/json" \
  --data "{\"current_password\":\"$ADMIN_PASSWORD\",\"new_password\":\"$NEW_ADMIN_PASSWORD\",\"confirm_password\":\"MismatchPassword123!\"}"
```

Expected: HTTP `400` confirmation mismatch.

TEST C15 - successful password change:

```zsh
curl -sS -i -b "$COOKIE_JAR" -X POST "$BASE_URL/api/auth/change_password" \
  -H "Content-Type: application/json" \
  --data "{\"current_password\":\"$ADMIN_PASSWORD\",\"new_password\":\"$NEW_ADMIN_PASSWORD\",\"confirm_password\":\"$NEW_ADMIN_PASSWORD\"}"
```

Expected: HTTP `200`. Then update the shell variable:

```zsh
export OLD_ADMIN_PASSWORD="$ADMIN_PASSWORD"
export ADMIN_PASSWORD="$NEW_ADMIN_PASSWORD"
```

TEST C16 - old password no longer works:

```zsh
curl -sS -i -X POST "$BASE_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  --data "{\"login_identifier\":\"$ADMIN_USERNAME\",\"password\":\"$OLD_ADMIN_PASSWORD\"}"
```

Expected: HTTP `401`.

TEST C17 - new password works:

```zsh
curl -sS -i -c "$COOKIE_JAR" -b "$COOKIE_JAR" -X POST "$BASE_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  --data "{\"login_identifier\":\"$ADMIN_USERNAME\",\"password\":\"$ADMIN_PASSWORD\"}"
```

Expected: HTTP `200`.

TEST C18 - duplicate username validation where applicable:

```zsh
node --input-type=commonjs <<'NODE'
const knex = require('knex')({ client: 'mysql2', connection: {
  host: process.env.DB_HOST, port: process.env.DB_PORT, user: process.env.DB_USER,
  password: process.env.DB_PASSWORD, database: process.env.DB_NAME
}});
(async () => {
  const existing = await knex('users').first('username', 'email', 'password_hash', 'first_name', 'last_name', 'display_name', 'status');
  try {
    await knex('users').insert({ ...existing, email: `duplicate_${Date.now()}@example.test` });
    console.log('FAIL duplicate username was inserted');
  } catch (error) {
    console.log('PASS duplicate username blocked');
  } finally {
    await knex.destroy();
  }
})();
NODE
```

Expected: `PASS duplicate username blocked`.

TEST C19 - duplicate email validation where applicable:

```zsh
node --input-type=commonjs <<'NODE'
const knex = require('knex')({ client: 'mysql2', connection: {
  host: process.env.DB_HOST, port: process.env.DB_PORT, user: process.env.DB_USER,
  password: process.env.DB_PASSWORD, database: process.env.DB_NAME
}});
(async () => {
  const existing = await knex('users').first('username', 'email', 'password_hash', 'first_name', 'last_name', 'display_name', 'status');
  try {
    await knex('users').insert({ ...existing, username: `duplicate_${Date.now()}` });
    console.log('FAIL duplicate email was inserted');
  } catch (error) {
    console.log('PASS duplicate email blocked');
  } finally {
    await knex.destroy();
  }
})();
NODE
```

Expected: `PASS duplicate email blocked`.

TEST C20 - second initial-admin bootstrap rejected:

```zsh
curl -sS -i -X POST "$BASE_URL/api/setup/initial_admin" \
  -H "Content-Type: application/json" \
  --data '{"username":"second.admin","email":"second.admin@example.test","first_name":"Second","last_name":"Admin","password":"NeverStoreThis123!","confirm_password":"NeverStoreThis123!"}'
```

Expected: HTTP `409`.

TEST C21 - unauthenticated protected API rejected:

```zsh
curl -sS -i -X POST "$BASE_URL/api/security/require_permission" \
  -H "Content-Type: application/json" \
  --data '{"permission":"dashboard.view"}'
```

Expected: HTTP `401`.

TEST C22 and C23 - limited-user forbidden and allowed tests.

Create a development-only limited user:

```zsh
read -r "LIMITED_USERNAME?Limited test username: "
read -r "LIMITED_EMAIL?Limited test email: "
read -s "LIMITED_PASSWORD?Limited test password: "
echo
export LIMITED_USERNAME LIMITED_EMAIL LIMITED_PASSWORD
node --input-type=commonjs <<'NODE'
const argon2 = require('argon2');
const knex = require('knex')({ client: 'mysql2', connection: {
  host: process.env.DB_HOST, port: process.env.DB_PORT, user: process.env.DB_USER,
  password: process.env.DB_PASSWORD, database: process.env.DB_NAME
}});
(async () => {
  const hash = await argon2.hash(process.env.LIMITED_PASSWORD, { type: argon2.argon2id });
  const role = await knex('roles').where({ name: 'SCHOOL_ADMINISTRATOR' }).first('id');
  const [userId] = await knex('users').insert({
    username: process.env.LIMITED_USERNAME,
    email: process.env.LIMITED_EMAIL,
    password_hash: hash,
    first_name: 'Limited',
    last_name: 'Tester',
    display_name: 'Limited Tester',
    status: 'active'
  });
  await knex('user_roles').insert({ user_id: userId, role_id: role.id });
  console.log(`Created limited user id ${userId}`);
  await knex.destroy();
})();
NODE
```

Login as the limited user:

```zsh
curl -sS -i -c "$LIMITED_COOKIE_JAR" -b "$LIMITED_COOKIE_JAR" -X POST "$BASE_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  --data "{\"login_identifier\":\"$LIMITED_USERNAME\",\"password\":\"$LIMITED_PASSWORD\"}"
```

Allowed permission:

```zsh
curl -sS -i -b "$LIMITED_COOKIE_JAR" -X POST "$BASE_URL/api/security/require_permission" \
  -H "Content-Type: application/json" \
  --data '{"permission":"dashboard.view"}'
```

Expected C23: HTTP `200`.

Forbidden permission:

```zsh
curl -sS -i -b "$LIMITED_COOKIE_JAR" -X POST "$BASE_URL/api/security/require_permission" \
  -H "Content-Type: application/json" \
  --data '{"permission":"users.disable"}'
```

Expected C22: HTTP `403`.

TEST C24 - direct API access cannot bypass RBAC:

```zsh
curl -sS -i -b "$LIMITED_COOKIE_JAR" -X POST "$BASE_URL/api/security/require_super_admin"
```

Expected: HTTP `403`.

Remove the temporary limited account:

```zsh
node --input-type=commonjs <<'NODE'
const knex = require('knex')({ client: 'mysql2', connection: {
  host: process.env.DB_HOST, port: process.env.DB_PORT, user: process.env.DB_USER,
  password: process.env.DB_PASSWORD, database: process.env.DB_NAME
}});
(async () => {
  const user = await knex('users').where({ username: process.env.LIMITED_USERNAME }).first('id');
  if (user) {
    await knex('user_roles').where({ user_id: user.id }).del();
    await knex('users').where({ id: user.id }).del();
  }
  console.log('Limited test user removed');
  await knex.destroy();
})();
NODE
```

TEST C25 - MySQL verification queries:

```zsh
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p "$DB_NAME" <<SQL
SELECT id, username, email, status, password_hash LIKE '\$argon2%' AS password_is_hash
FROM users
ORDER BY id;

SELECT u.username, r.name AS role_name
FROM users u
JOIN user_roles ur ON ur.user_id = u.id
JOIN roles r ON r.id = ur.role_id
ORDER BY u.username, r.name;

SELECT r.name AS role_name, COUNT(*) AS permission_count
FROM roles r
JOIN role_permissions rp ON rp.role_id = r.id
JOIN permissions p ON p.id = rp.permission_id
GROUP BY r.name
ORDER BY r.name;

SELECT action, module, entity_type, COUNT(*) AS event_count
FROM audit_logs
WHERE action IN ('initial_admin_created', 'login_success', 'logout', 'password_changed')
GROUP BY action, module, entity_type
ORDER BY action;

SELECT username, COUNT(*) AS duplicate_count
FROM users
GROUP BY username
HAVING COUNT(*) > 1;

SELECT email, COUNT(*) AS duplicate_count
FROM users
WHERE email IS NOT NULL
GROUP BY email
HAVING COUNT(*) > 1;

SELECT username, password_changed_at
FROM users
WHERE username = '${ADMIN_USERNAME}';
SQL
```

Expected: password hashes begin with Argon2 marker, admin role assignment exists, permission mappings exist, audit rows exist, duplicate queries return no rows, and `password_changed_at` is populated after password change.

## B. GUI TESTS

GUI 01 - Open `/` while logged out. Expected: redirect to `/login`.

GUI 02 - Check login desktop layout. Expected: approved Phase 1 design is preserved.

GUI 03 - Enter wrong password. Expected: generic safe error.

GUI 04 - Login with username. Expected: dashboard appears.

GUI 05 - Verify topbar. Expected: authenticated display name appears.

GUI 06 - Verify sidebar. Expected: navigation reflects permissions.

GUI 07 - Open user dropdown. Expected: Change Password and Sign Out are available.

GUI 08 - Open Change Password. Expected: Wappler Bootstrap 5 modal works.

GUI 09 - Wrong current password. Expected: safe validation error.

GUI 10 - Password confirmation mismatch. Expected: validation error.

GUI 11 - Successful password change. Expected: success feedback and modal closes.

GUI 12 - Sign out. Expected: return to login.

GUI 13 - Use browser Back or direct `/`. Expected: protected dashboard is not accessible without authentication.

GUI 14 - Login using email. Expected: success.

GUI 15 - Limited-role account login. Expected: unauthorized sidebar items are hidden.

GUI 16 - Try directly navigating or calling a restricted operation. Expected: server-side `403`, not merely hidden UI.

GUI 17 - Check 1440px viewport. Expected: no horizontal overflow; login and dashboard usable.

GUI 18 - Check 1024px viewport. Expected: no horizontal overflow; topbar/sidebar remain usable.

GUI 19 - Check 768px viewport. Expected: no horizontal overflow; mobile sidebar/offcanvas usable.

GUI 20 - Check 375px viewport. Expected: no horizontal overflow; login, dashboard, topbar, and mobile navigation remain usable.
