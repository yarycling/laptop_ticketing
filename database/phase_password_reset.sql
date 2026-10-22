-- One-time migration for Wappler-native password reset and user-wide session revocation.
ALTER TABLE users
  ADD COLUMN auth_version INT UNSIGNED NOT NULL DEFAULT 1 AFTER status,
  ADD COLUMN password_reset_throttle_touched_at DATETIME(3) NULL AFTER auth_version;

CREATE TABLE password_reset_requests (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  request_id CHAR(52) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  token_hash VARCHAR(255) NOT NULL,
  email_snapshot VARCHAR(254) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME NOT NULL,
  used_at DATETIME NULL,
  invalidated_at DATETIME NULL,
  email_sent_at DATETIME NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_password_reset_request_id (request_id),
  KEY idx_password_reset_user_created (user_id, created_at),
  KEY idx_password_reset_expiry (expires_at),
  KEY idx_password_reset_user_active (user_id, used_at, invalidated_at, expires_at),
  CONSTRAINT fk_password_reset_user FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Greenfield setup used a non-routable placeholder for its initial admin.
-- Correct only that known placeholder; preserve the account's role and status.
UPDATE users
SET email = 'yarycling@yahoo.com'
WHERE username = 'yarycling'
  AND email = 'yarycling@localhost';
