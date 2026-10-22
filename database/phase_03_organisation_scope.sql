CREATE TABLE IF NOT EXISTS districts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(180) NOT NULL,
  status ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_districts_name (name),
  KEY idx_districts_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS schools (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  district_id INT UNSIGNED NULL,
  school_code VARCHAR(80) NULL,
  name VARCHAR(220) NOT NULL,
  status ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_schools_school_code (school_code),
  KEY idx_schools_district_id (district_id),
  KEY idx_schools_status (status),
  KEY idx_schools_name (name),
  CONSTRAINT fk_schools_district FOREIGN KEY (district_id) REFERENCES districts(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS user_national_scopes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INT UNSIGNED NOT NULL,
  status ENUM('active', 'revoked') NOT NULL DEFAULT 'active',
  assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  assigned_by INT UNSIGNED NULL,
  revoked_at DATETIME NULL,
  revoked_by INT UNSIGNED NULL,
  PRIMARY KEY (id),
  KEY idx_user_national_scopes_user_status (user_id, status),
  KEY idx_user_national_scopes_status (status),
  CONSTRAINT fk_user_national_scopes_user FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_user_national_scopes_assigned_by FOREIGN KEY (assigned_by) REFERENCES users(id) ON DELETE SET NULL,
  CONSTRAINT fk_user_national_scopes_revoked_by FOREIGN KEY (revoked_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS user_district_scopes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INT UNSIGNED NOT NULL,
  district_id INT UNSIGNED NOT NULL,
  status ENUM('active', 'revoked') NOT NULL DEFAULT 'active',
  assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  assigned_by INT UNSIGNED NULL,
  revoked_at DATETIME NULL,
  revoked_by INT UNSIGNED NULL,
  PRIMARY KEY (id),
  KEY idx_user_district_scopes_user_status (user_id, status),
  KEY idx_user_district_scopes_district_status (district_id, status),
  CONSTRAINT fk_user_district_scopes_user FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_user_district_scopes_district FOREIGN KEY (district_id) REFERENCES districts(id),
  CONSTRAINT fk_user_district_scopes_assigned_by FOREIGN KEY (assigned_by) REFERENCES users(id) ON DELETE SET NULL,
  CONSTRAINT fk_user_district_scopes_revoked_by FOREIGN KEY (revoked_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS user_school_scopes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INT UNSIGNED NOT NULL,
  school_id INT UNSIGNED NOT NULL,
  status ENUM('active', 'revoked') NOT NULL DEFAULT 'active',
  assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  assigned_by INT UNSIGNED NULL,
  revoked_at DATETIME NULL,
  revoked_by INT UNSIGNED NULL,
  PRIMARY KEY (id),
  KEY idx_user_school_scopes_user_status (user_id, status),
  KEY idx_user_school_scopes_school_status (school_id, status),
  CONSTRAINT fk_user_school_scopes_user FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_user_school_scopes_school FOREIGN KEY (school_id) REFERENCES schools(id),
  CONSTRAINT fk_user_school_scopes_assigned_by FOREIGN KEY (assigned_by) REFERENCES users(id) ON DELETE SET NULL,
  CONSTRAINT fk_user_school_scopes_revoked_by FOREIGN KEY (revoked_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO districts (name, status) VALUES
  ('Port of Spain & Environs', 'active'),
  ('St. George East', 'active'),
  ('North Eastern', 'active'),
  ('Caroni', 'active'),
  ('Victoria', 'active'),
  ('St. Patrick', 'active'),
  ('South Eastern', 'active'),
  ('Tobago', 'active');

INSERT IGNORE INTO permissions (name, label, module) VALUES
  ('districts.view', 'View Districts', 'districts'),
  ('districts.manage', 'Manage Districts', 'districts'),
  ('schools.view', 'View Schools', 'schools'),
  ('schools.manage', 'Manage Schools', 'schools'),
  ('user_scopes.view', 'View User Scopes', 'user_scopes'),
  ('user_scopes.manage', 'Manage User Scopes', 'user_scopes');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name = 'SUPER_ADMIN';
