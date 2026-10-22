-- Phase 7D Repair Centre service-location authorization scope.
-- Mirrors the Phase 3 active/revoked assignment and actor conventions.
CREATE TABLE IF NOT EXISTS user_service_location_scopes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INT UNSIGNED NOT NULL,
  service_location_id INT UNSIGNED NOT NULL,
  status ENUM('active', 'revoked') NOT NULL DEFAULT 'active',
  assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  assigned_by INT UNSIGNED NULL,
  revoked_at DATETIME NULL,
  revoked_by INT UNSIGNED NULL,
  PRIMARY KEY (id),
  KEY idx_user_service_location_scopes_user_status (user_id, status),
  KEY idx_user_service_location_scopes_location_status (service_location_id, status),
  CONSTRAINT fk_user_service_location_scopes_user FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_user_service_location_scopes_location FOREIGN KEY (service_location_id) REFERENCES service_locations(id),
  CONSTRAINT fk_user_service_location_scopes_assigned_by FOREIGN KEY (assigned_by) REFERENCES users(id) ON DELETE SET NULL,
  CONSTRAINT fk_user_service_location_scopes_revoked_by FOREIGN KEY (revoked_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
