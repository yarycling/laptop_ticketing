# Phase 3 Organisation Foundation User Test Plan

Application: `http://localhost:3000`  
Database: `laptop_tickets_db`

Do not store portal passwords or database passwords in this file.

## Setup

Terminal A - start the app:

```zsh
cd /Users/jamesthomas/mobileApps/ticketing_solution
export WAPPLER_SERVER_PORT="3000"
npm start
```

Terminal B - shared variables:

```zsh
export BASE_URL="http://localhost:3000"
read -s "DB_PASSWORD?Database password: "
echo
export DB_PASSWORD
export COOKIE_JAR="/tmp/tstt_phase3_admin.cookies"
export SCHOOL_COOKIE_JAR="/tmp/tstt_phase3_school.cookies"
export DISTRICT_COOKIE_JAR="/tmp/tstt_phase3_district.cookies"
export NATIONAL_COOKIE_JAR="/tmp/tstt_phase3_national.cookies"
rm -f "$COOKIE_JAR" "$SCHOOL_COOKIE_JAR" "$DISTRICT_COOKIE_JAR" "$NATIONAL_COOKIE_JAR"
read -r "ADMIN_USERNAME?Admin username: "
read -s "ADMIN_PASSWORD?Admin password: "
echo
```

Apply the Phase 3 migration if it has not already been applied:

```zsh
mysql -h 127.0.0.1 -P 3306 -u root -p laptop_tickets_db < /Users/jamesthomas/mobileApps/ticketing_solution/database/phase_03_organisation_scope.sql
```

## Command-Line Tests

C01 - Super Admin login:

```zsh
curl -sS -i -c "$COOKIE_JAR" -b "$COOKIE_JAR" -X POST "$BASE_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  --data "{\"login_identifier\":\"$ADMIN_USERNAME\",\"password\":\"$ADMIN_PASSWORD\"}"
```

Expected: HTTP `200`.

C02 - District list returns exactly eight seeded districts:

```zsh
curl -sS -b "$COOKIE_JAR" "$BASE_URL/api/admin/districts/list" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const j=JSON.parse(s); console.log(j.districts.length);})'
```

Expected: `8`.

C03 - Verify district names:

```zsh
curl -sS -b "$COOKIE_JAR" "$BASE_URL/api/admin/districts/list" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const got=JSON.parse(s).districts.map(d=>d.name).sort(); const exp=["Port of Spain & Environs","St. George East","North Eastern","Caroni","Victoria","St. Patrick","South Eastern","Tobago"].sort(); console.log(JSON.stringify(got)===JSON.stringify(exp) ? "PASS" : got);})'
```

C04 - Create two temporary Phase 3 test schools:

```zsh
export CARONI_ID="$(curl -sS -b "$COOKIE_JAR" "$BASE_URL/api/admin/districts/list" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const d=JSON.parse(s).districts.find(x=>x.name==="Caroni"); console.log(d.id);})')"
export TOBAGO_ID="$(curl -sS -b "$COOKIE_JAR" "$BASE_URL/api/admin/districts/list" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const d=JSON.parse(s).districts.find(x=>x.name==="Tobago"); console.log(d.id);})')"
curl -sS -i -b "$COOKIE_JAR" -X POST "$BASE_URL/api/admin/schools/save" -H "Content-Type: application/json" --data "{\"district_id\":\"$CARONI_ID\",\"school_code\":\"PH3-A\",\"name\":\"PHASE3 TEST SCHOOL A\",\"status\":\"active\"}"
curl -sS -i -b "$COOKIE_JAR" -X POST "$BASE_URL/api/admin/schools/save" -H "Content-Type: application/json" --data "{\"district_id\":\"$TOBAGO_ID\",\"school_code\":\"PH3-B\",\"name\":\"PHASE3 TEST SCHOOL B\",\"status\":\"active\"}"
```

Expected: HTTP `200` for both.

C05 - Duplicate school code validation:

```zsh
curl -sS -i -b "$COOKIE_JAR" -X POST "$BASE_URL/api/admin/schools/save" \
  -H "Content-Type: application/json" \
  --data "{\"district_id\":\"$CARONI_ID\",\"school_code\":\"PH3-A\",\"name\":\"PHASE3 DUPLICATE SCHOOL\",\"status\":\"active\"}"
```

Expected: HTTP `409`.

C06 - School list filtering by district:

```zsh
curl -sS -b "$COOKIE_JAR" "$BASE_URL/api/admin/schools/list" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const j=JSON.parse(s); console.log(j.schools.filter(x=>String(x.district_id)===process.env.CARONI_ID).map(x=>x.name).includes("PHASE3 TEST SCHOOL A"));})'
```

Expected: `true`.

C07 - Update temporary school:

```zsh
export SCHOOL_A_ID="$(curl -sS -b "$COOKIE_JAR" "$BASE_URL/api/admin/schools/list" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const x=JSON.parse(s).schools.find(s=>s.school_code==="PH3-A"); console.log(x.id);})')"
curl -sS -i -b "$COOKIE_JAR" -X POST "$BASE_URL/api/admin/schools/save" -H "Content-Type: application/json" --data "{\"id\":\"$SCHOOL_A_ID\",\"district_id\":\"$CARONI_ID\",\"school_code\":\"PH3-A\",\"name\":\"PHASE3 TEST SCHOOL A UPDATED\",\"status\":\"active\"}"
```

Expected: HTTP `200`.

C08 - Deactivate/reactivate temporary school:

```zsh
curl -sS -i -b "$COOKIE_JAR" -X POST "$BASE_URL/api/admin/schools/save" -H "Content-Type: application/json" --data "{\"id\":\"$SCHOOL_A_ID\",\"district_id\":\"$CARONI_ID\",\"school_code\":\"PH3-A\",\"name\":\"PHASE3 TEST SCHOOL A UPDATED\",\"status\":\"inactive\"}"
curl -sS -i -b "$COOKIE_JAR" -X POST "$BASE_URL/api/admin/schools/save" -H "Content-Type: application/json" --data "{\"id\":\"$SCHOOL_A_ID\",\"district_id\":\"$CARONI_ID\",\"school_code\":\"PH3-A\",\"name\":\"PHASE3 TEST SCHOOL A UPDATED\",\"status\":\"active\"}"
```

Expected: HTTP `200` for both.

C09 - Create temporary scope test users:

```zsh
read -s "PHASE3_PASSWORD?Temporary Phase 3 test password: "
echo
node --input-type=commonjs <<'NODE'
const argon2 = require('argon2');
const knex = require('knex')({ client: 'mysql2', connection: { host:'127.0.0.1', port:3306, user:'root', password:process.env.DB_PASSWORD, database:'laptop_tickets_db' }});
(async () => {
  const hash = await argon2.hash(process.env.PHASE3_PASSWORD, { type: argon2.argon2id });
  for (const username of ['phase3.school.test','phase3.district.test','phase3.national.test','phase3.noscope.test']) {
    await knex('users').insert({ username, email:`${username}@example.test`, password_hash:hash, first_name:'Phase3', last_name:'Tester', display_name:username, status:'active', password_changed_at:knex.fn.now() }).onConflict('username').ignore();
  }
  await knex.destroy();
})();
NODE
```

C10-C27 - Assign, guard, redundancy, and revocation tests:

Resolve test ids:

```zsh
export SCHOOL_B_ID="$(curl -sS -b "$COOKIE_JAR" "$BASE_URL/api/admin/schools/list" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const x=JSON.parse(s).schools.find(s=>s.school_code==="PH3-B"); console.log(x.id);})')"
export SCHOOL_USER_ID="$(curl -sS -b "$COOKIE_JAR" "$BASE_URL/api/admin/user-scopes/user-search" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const x=JSON.parse(s).users.find(u=>u.username==="phase3.school.test"); console.log(x.id);})')"
export DISTRICT_USER_ID="$(curl -sS -b "$COOKIE_JAR" "$BASE_URL/api/admin/user-scopes/user-search" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const x=JSON.parse(s).users.find(u=>u.username==="phase3.district.test"); console.log(x.id);})')"
export NATIONAL_USER_ID="$(curl -sS -b "$COOKIE_JAR" "$BASE_URL/api/admin/user-scopes/user-search" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const x=JSON.parse(s).users.find(u=>u.username==="phase3.national.test"); console.log(x.id);})')"
export NOSCOPE_USER_ID="$(curl -sS -b "$COOKIE_JAR" "$BASE_URL/api/admin/user-scopes/user-search" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const x=JSON.parse(s).users.find(u=>u.username==="phase3.noscope.test"); console.log(x.id);})')"
curl -sS -i -b "$COOKIE_JAR" -X POST "$BASE_URL/api/admin/user-scopes/assign-school" -H "Content-Type: application/json" --data "{\"user_id\":\"$SCHOOL_USER_ID\",\"school_id\":\"$SCHOOL_A_ID\"}"
curl -sS -i -c "$SCHOOL_COOKIE_JAR" -b "$SCHOOL_COOKIE_JAR" -X POST "$BASE_URL/api/auth/login" -H "Content-Type: application/json" --data "{\"login_identifier\":\"phase3.school.test\",\"password\":\"$PHASE3_PASSWORD\"}"
curl -sS -i -b "$SCHOOL_COOKIE_JAR" -X POST "$BASE_URL/api/security/require_school_scope" -H "Content-Type: application/json" --data "{\"school_id\":\"$SCHOOL_A_ID\"}"
curl -sS -i -b "$SCHOOL_COOKIE_JAR" -X POST "$BASE_URL/api/security/require_school_scope" -H "Content-Type: application/json" --data "{\"school_id\":\"$SCHOOL_B_ID\"}"
curl -sS -i -b "$COOKIE_JAR" -X POST "$BASE_URL/api/admin/user-scopes/assign-district" -H "Content-Type: application/json" --data "{\"user_id\":\"$DISTRICT_USER_ID\",\"district_id\":\"$CARONI_ID\"}"
curl -sS -i -b "$COOKIE_JAR" -X POST "$BASE_URL/api/admin/user-scopes/assign-national" -H "Content-Type: application/json" --data "{\"user_id\":\"$NATIONAL_USER_ID\"}"
curl -sS -i -b "$COOKIE_JAR" -X POST "$BASE_URL/api/admin/user-scopes/revoke" -H "Content-Type: application/json" --data "{\"scope_type\":\"school\",\"scope_id\":\"$SCOPE_ID\"}"
```

Expected highlights: assigned school guard `200`, other school `403`, district inheritance for same district `200`, other district `403`, national permits both district and school, redundant national+district and district+same-district-school assignments return `409`, revoked scope removes access.

C25 - Unauthenticated guards:

```zsh
curl -sS -i -X POST "$BASE_URL/api/security/require_district_scope" -H "Content-Type: application/json" --data "{\"district_id\":\"$CARONI_ID\"}"
curl -sS -i -X POST "$BASE_URL/api/security/require_school_scope" -H "Content-Type: application/json" --data "{\"school_id\":\"$SCHOOL_A_ID\"}"
```

Expected: HTTP `401`.

C28 - Audit rows exist:

```zsh
mysql -h 127.0.0.1 -P 3306 -u root -p laptop_tickets_db -e "SELECT action, COUNT(*) FROM audit_logs WHERE action LIKE 'scope.%' OR action LIKE 'school.%' OR action LIKE 'district.%' GROUP BY action ORDER BY action;"
```

C29 - No password/hash/session leaked:

```zsh
curl -sS -b "$COOKIE_JAR" "$BASE_URL/api/admin/user-scopes/user-search" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{console.log(/password|hash|session/i.test(s) ? "FAIL" : "PASS")})'
```

C30 - Phase 2 regression smoke:

```zsh
curl -sS -b "$COOKIE_JAR" "$BASE_URL/api/auth/me"
curl -sS -b "$COOKIE_JAR" "$BASE_URL/api/auth/context"
curl -sS -i -b "$COOKIE_JAR" -X POST "$BASE_URL/api/security/require_permission" -H "Content-Type: application/json" --data '{"permission":"dashboard.view"}'
curl -sS -i -b "$COOKIE_JAR" -X POST "$BASE_URL/api/security/require_super_admin"
curl -sS -i -b "$COOKIE_JAR" -c "$COOKIE_JAR" -X POST "$BASE_URL/api/auth/logout"
```

## GUI Tests

1. Login as `portal.admin`.
2. Open `Administration -> Organisation`.
3. Districts tab: verify eight districts, search, status filter, add/edit district, and no hard-delete action.
4. Schools tab: verify search, district filter, status filter, Add/Edit School modal, required validation, duplicate school-code validation, deactivate/reactivate behavior.
5. User Scope Assignments tab: search/select a user, view roles, view national/district/school scopes, assign national/district/school, revoke active scopes.
6. Permission test: login as a user without `user_scopes.manage`; direct mutation API calls must return `403`.
7. Responsive checks at 1440px, 1024px, 768px, and 375px: no horizontal page overflow; modals usable.

## Deferred Security Test

Unexpected 500 error sanitization runtime fault-injection test deferred. Wappler `debug=false` remains enabled. Static inspection of the installed Wappler runtime confirms that when `debug=false`, the global 500 handler does not return `err.code`, `err.message`, or `err.stack` to the client. Runtime fault-injection acceptance will be revisited before production release.

## Cleanup

Development-only cleanup may hard-delete temporary Phase 3 data:

```zsh
mysql -h 127.0.0.1 -P 3306 -u root -p laptop_tickets_db <<'SQL'
DELETE FROM user_school_scopes WHERE user_id IN (SELECT id FROM users WHERE username LIKE 'phase3.%');
DELETE FROM user_district_scopes WHERE user_id IN (SELECT id FROM users WHERE username LIKE 'phase3.%');
DELETE FROM user_national_scopes WHERE user_id IN (SELECT id FROM users WHERE username LIKE 'phase3.%');
DELETE FROM users WHERE username LIKE 'phase3.%';
DELETE FROM schools WHERE school_code IN ('PH3-A','PH3-B');
SQL
```
