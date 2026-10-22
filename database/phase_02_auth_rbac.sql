SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE IF NOT EXISTS users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  username VARCHAR(150) NOT NULL,
  email VARCHAR(254) NULL,
  password_hash VARCHAR(255) NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  display_name VARCHAR(220) NOT NULL,
  status ENUM('active', 'disabled', 'locked') NOT NULL DEFAULT 'active',
  last_login_at DATETIME NULL,
  password_changed_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_users_username (username),
  UNIQUE KEY uq_users_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS roles (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  label VARCHAR(150) NOT NULL,
  description VARCHAR(500) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_roles_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS permissions (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  label VARCHAR(180) NOT NULL,
  module VARCHAR(80) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_permissions_name (name),
  KEY idx_permissions_module (module)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS user_roles (
  user_id INT UNSIGNED NOT NULL,
  role_id INT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, role_id),
  KEY idx_user_roles_role_id (role_id),
  CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS role_permissions (
  role_id INT UNSIGNED NOT NULL,
  permission_id INT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (role_id, permission_id),
  KEY idx_role_permissions_permission_id (permission_id),
  CONSTRAINT fk_role_permissions_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
  CONSTRAINT fk_role_permissions_permission FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS audit_logs (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  actor_user_id INT UNSIGNED NULL,
  action VARCHAR(120) NOT NULL,
  module VARCHAR(80) NOT NULL,
  entity_type VARCHAR(100) NULL,
  entity_id VARCHAR(100) NULL,
  description VARCHAR(1000) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_audit_actor_user_id (actor_user_id),
  KEY idx_audit_action (action),
  KEY idx_audit_module (module),
  CONSTRAINT fk_audit_logs_actor FOREIGN KEY (actor_user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP VIEW IF EXISTS user_login_identities;
CREATE VIEW user_login_identities AS
SELECT id, username AS login_identifier, password_hash
FROM users
WHERE status = 'active'
UNION
SELECT id, email AS login_identifier, password_hash
FROM users
WHERE email IS NOT NULL AND email <> '' AND status = 'active';

DROP VIEW IF EXISTS user_effective_permissions;
CREATE VIEW user_effective_permissions AS
SELECT DISTINCT
  ur.user_id AS user_id,
  p.name AS permission_name
FROM user_roles ur
JOIN roles r ON r.id = ur.role_id
JOIN role_permissions rp ON rp.role_id = r.id
JOIN permissions p ON p.id = rp.permission_id
JOIN users u ON u.id = ur.user_id
WHERE u.status = 'active';

INSERT IGNORE INTO roles (name, label, description) VALUES
  ('SUPER_ADMIN', 'Super Administrator', 'Full system access across all Phase 2 permissions.'),
  ('MOE_HEAD_OFFICE', 'MOE Head Office', 'Ministry head office oversight.'),
  ('ICT_DISTRICT_COORDINATOR', 'ICT District Coordinator', 'District-level ICT coordination.'),
  ('ICT_TECHNICAL_OFFICER', 'ICT Technical Officer', 'ICT technical support and diagnosis.'),
  ('SCHOOL_ADMINISTRATOR', 'School Administrator', 'School requester and administration role.'),
  ('REPAIR_CENTRE', 'Repair Centre', 'Authorized repair centre operations.'),
  ('TTPOST_LOGISTICS', 'TTPost Logistics', 'Collection and logistics partner operations.'),
  ('TSTT_OVERSIGHT', 'TSTT Oversight', 'TSTT oversight and reporting.');

INSERT IGNORE INTO permissions (name, label, module) VALUES
  ('dashboard.view', 'View Dashboard', 'dashboard'),
  ('users.view', 'View Users', 'users'),
  ('users.create', 'Create Users', 'users'),
  ('users.update', 'Update Users', 'users'),
  ('users.disable', 'Disable Users', 'users'),
  ('roles.view', 'View Roles', 'roles'),
  ('roles.manage', 'Manage Roles', 'roles'),
  ('permissions.view', 'View Permissions', 'permissions'),
  ('audit.view', 'View Audit Logs', 'audit'),
  ('admin.access', 'Access Administration', 'admin'),
  ('devices.view', 'View Devices', 'devices'),
  ('devices.manage', 'Manage Devices', 'devices'),
  ('tickets.view', 'View Tickets', 'tickets'),
  ('tickets.create', 'Create Tickets', 'tickets'),
  ('tickets.manage', 'Manage Tickets', 'tickets'),
  ('collections.view', 'View Collections', 'collections'),
  ('collections.manage', 'Manage Collections', 'collections'),
  ('repairs.view', 'View Repairs', 'repairs'),
  ('repairs.manage', 'Manage Repairs', 'repairs'),
  ('returns.view', 'View Returns', 'returns'),
  ('returns.manage', 'Manage Returns', 'returns'),
  ('inventory.view', 'View Inventory', 'inventory'),
  ('inventory.manage', 'Manage Inventory', 'inventory'),
  ('reports.view', 'View Reports', 'reports'),
  ('reports.export', 'Export Reports', 'reports');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name = 'SUPER_ADMIN';

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON p.name IN (
  'dashboard.view',
  'devices.view',
  'tickets.view',
  'tickets.create'
)
WHERE r.name = 'SCHOOL_ADMINISTRATOR';
