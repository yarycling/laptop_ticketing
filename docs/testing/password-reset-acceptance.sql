-- Read-only password-reset deployment checks (MySQL 5.7).
-- Run after database/phase_password_reset.sql has been applied.

-- Confirm required schema fields and that the table has no raw-token column.
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND (
    (TABLE_NAME = 'users' AND COLUMN_NAME IN ('auth_version', 'password_reset_throttle_touched_at'))
    OR TABLE_NAME = 'password_reset_requests'
  )
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- Confirm the greenfield administrator's target email, role, and status.
SELECT u.username, u.email, u.status, r.name AS role_name
FROM users u
LEFT JOIN user_roles ur ON ur.user_id = u.id
LEFT JOIN roles r ON r.id = ur.role_id
WHERE u.username = 'yarycling';

-- Aggregate only; never display request IDs or token hashes in acceptance output.
SELECT
  COUNT(*) AS reset_request_count,
  SUM(token_hash LIKE '$argon2id$%') AS argon2id_hash_count,
  SUM(used_at IS NOT NULL) AS used_request_count,
  SUM(invalidated_at IS NOT NULL) AS invalidated_request_count,
  SUM(expires_at <= NOW()) AS expired_request_count
FROM password_reset_requests;

-- Confirm no triggers were added by this feature.
SELECT COUNT(*) AS password_reset_trigger_count
FROM INFORMATION_SCHEMA.TRIGGERS
WHERE TRIGGER_SCHEMA = DATABASE()
  AND EVENT_OBJECT_TABLE IN ('users', 'password_reset_requests');
