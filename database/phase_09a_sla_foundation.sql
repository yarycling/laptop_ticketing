-- Phase 9A SLA policy and business calendar foundation (MySQL 5.7).
-- Policy versions and calendar override history preserve prior configuration.

CREATE TABLE IF NOT EXISTS sla_calendars (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  calendar_code VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  name VARCHAR(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  description VARCHAR(1000) COLLATE utf8mb4_unicode_ci NULL,
  timezone_name VARCHAR(64) NOT NULL DEFAULT 'America/Port_of_Spain',
  status VARCHAR(16) NOT NULL DEFAULT 'active',
  is_default TINYINT(1) NOT NULL DEFAULT 0,
  created_by INT UNSIGNED NULL,
  updated_by INT UNSIGNED NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_sla_calendars_code (calendar_code),
  KEY idx_sla_calendars_status_default (status, is_default),
  CONSTRAINT fk_sla_calendars_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_sla_calendars_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT chk_sla_calendars_status CHECK (status IN ('active','inactive')),
  CONSTRAINT chk_sla_calendars_default CHECK (is_default IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS sla_calendar_weekdays (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  calendar_id INT UNSIGNED NOT NULL,
  weekday_number TINYINT UNSIGNED NOT NULL,
  weekday_name VARCHAR(12) NOT NULL,
  is_business_day TINYINT(1) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_sla_calendar_weekday (calendar_id, weekday_number),
  CONSTRAINT fk_sla_calendar_weekdays_calendar FOREIGN KEY (calendar_id) REFERENCES sla_calendars(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT chk_sla_calendar_weekday_number CHECK (weekday_number BETWEEN 1 AND 7),
  CONSTRAINT chk_sla_calendar_weekday_business CHECK (is_business_day IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS sla_calendar_overrides (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  calendar_id INT UNSIGNED NOT NULL,
  override_date DATE NOT NULL,
  override_type VARCHAR(32) NOT NULL,
  is_business_day TINYINT(1) NOT NULL,
  description VARCHAR(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  status VARCHAR(16) NOT NULL DEFAULT 'active',
  created_by INT UNSIGNED NOT NULL,
  updated_by INT UNSIGNED NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_sla_calendar_override_date (calendar_id, override_date),
  KEY idx_sla_calendar_overrides_date_status (override_date, status),
  CONSTRAINT fk_sla_calendar_overrides_calendar FOREIGN KEY (calendar_id) REFERENCES sla_calendars(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_sla_calendar_overrides_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_sla_calendar_overrides_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT chk_sla_calendar_override_type CHECK (override_type IN ('PUBLIC_HOLIDAY','EXCEPTIONAL_CLOSURE','EXCEPTIONAL_WORKING_DAY')),
  CONSTRAINT chk_sla_calendar_override_business CHECK (is_business_day IN (0,1)),
  CONSTRAINT chk_sla_calendar_override_status CHECK (status IN ('active','inactive'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS sla_calendar_override_history (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  calendar_override_id BIGINT UNSIGNED NOT NULL,
  calendar_id INT UNSIGNED NOT NULL,
  override_date DATE NOT NULL,
  override_type VARCHAR(32) NOT NULL,
  is_business_day TINYINT(1) NOT NULL,
  description VARCHAR(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  status VARCHAR(16) NOT NULL,
  action_code VARCHAR(24) NOT NULL,
  changed_by INT UNSIGNED NOT NULL,
  changed_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  KEY idx_sla_override_history_date (calendar_id, override_date, changed_at, id),
  KEY idx_sla_override_history_record (calendar_override_id, id),
  CONSTRAINT fk_sla_override_history_override FOREIGN KEY (calendar_override_id) REFERENCES sla_calendar_overrides(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_sla_override_history_calendar FOREIGN KEY (calendar_id) REFERENCES sla_calendars(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_sla_override_history_actor FOREIGN KEY (changed_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT chk_sla_override_history_action CHECK (action_code IN ('ADDED','CHANGED','DEACTIVATED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS sla_policies (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  policy_code VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  created_by INT UNSIGNED NULL,
  updated_by INT UNSIGNED NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_sla_policies_code (policy_code),
  CONSTRAINT fk_sla_policies_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_sla_policies_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS sla_policy_versions (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  policy_id INT UNSIGNED NOT NULL,
  version_number INT UNSIGNED NOT NULL,
  name VARCHAR(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  description VARCHAR(1000) COLLATE utf8mb4_unicode_ci NULL,
  calendar_id INT UNSIGNED NOT NULL,
  target_business_days DECIMAL(6,2) UNSIGNED NOT NULL,
  status VARCHAR(16) NOT NULL DEFAULT 'active',
  sort_order SMALLINT UNSIGNED NOT NULL DEFAULT 100,
  start_event_code VARCHAR(80) NULL,
  completion_event_code VARCHAR(80) NULL,
  pause_condition_code VARCHAR(80) NULL,
  created_by INT UNSIGNED NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_sla_policy_version (policy_id, version_number),
  KEY idx_sla_policy_versions_calendar_status (calendar_id, status),
  CONSTRAINT fk_sla_policy_versions_policy FOREIGN KEY (policy_id) REFERENCES sla_policies(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_sla_policy_versions_calendar FOREIGN KEY (calendar_id) REFERENCES sla_calendars(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_sla_policy_versions_actor FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT chk_sla_policy_version_status CHECK (status IN ('active','inactive')),
  CONSTRAINT chk_sla_policy_version_target CHECK (target_business_days > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_sla_policy_current AS
SELECT p.id AS policy_id, p.policy_code,
  v.id AS policy_version_id, v.version_number, v.name, v.description,
  v.calendar_id, c.calendar_code, c.name AS calendar_name,
  v.target_business_days, v.status, v.sort_order,
  v.start_event_code, v.completion_event_code, v.pause_condition_code,
  v.created_by AS version_created_by, v.created_at AS version_created_at,
  p.created_at AS policy_created_at, p.updated_at AS policy_updated_at
FROM sla_policies p
JOIN sla_policy_versions v ON v.policy_id = p.id
JOIN sla_calendars c ON c.id = v.calendar_id
WHERE NOT EXISTS (
  SELECT 1 FROM sla_policy_versions newer
  WHERE newer.policy_id = v.policy_id AND newer.version_number > v.version_number
);

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_sla_policy_version_history AS
SELECT v.id AS policy_version_id, v.policy_id, p.policy_code, v.version_number,
  v.name, v.description, v.calendar_id, c.calendar_code, c.name AS calendar_name,
  v.target_business_days, v.status, v.sort_order, v.start_event_code,
  v.completion_event_code, v.pause_condition_code, v.created_by, v.created_at
FROM sla_policy_versions v
JOIN sla_policies p ON p.id = v.policy_id
JOIN sla_calendars c ON c.id = v.calendar_id;

INSERT IGNORE INTO sla_calendars
  (calendar_code, name, description, timezone_name, status, is_default)
VALUES
  ('TTO_PORTAL_OPERATIONS', 'Trinidad & Tobago / Portal Operations',
   'Default national service calendar. Monday to Friday are business days; weekend and date-specific exceptions are configured separately.',
   'America/Port_of_Spain', 'active', 1);

INSERT IGNORE INTO sla_calendar_weekdays
  (calendar_id, weekday_number, weekday_name, is_business_day)
SELECT c.id, days.weekday_number, days.weekday_name, days.is_business_day
FROM sla_calendars c
CROSS JOIN (
  SELECT 1 AS weekday_number, 'Monday' AS weekday_name, 1 AS is_business_day
  UNION ALL SELECT 2, 'Tuesday', 1
  UNION ALL SELECT 3, 'Wednesday', 1
  UNION ALL SELECT 4, 'Thursday', 1
  UNION ALL SELECT 5, 'Friday', 1
  UNION ALL SELECT 6, 'Saturday', 0
  UNION ALL SELECT 7, 'Sunday', 0
) days
WHERE c.calendar_code = 'TTO_PORTAL_OPERATIONS';

INSERT IGNORE INTO sla_policies (policy_code)
VALUES ('PICKUP'), ('DIAGNOSIS'), ('REPAIR'), ('QA'), ('RETURN_LOGISTICS');

INSERT INTO sla_policy_versions
  (policy_id, version_number, name, description, calendar_id, target_business_days, status, sort_order, created_by)
SELECT p.id, 1,
  CASE p.policy_code
    WHEN 'PICKUP' THEN 'Pickup'
    WHEN 'DIAGNOSIS' THEN 'Diagnosis'
    WHEN 'REPAIR' THEN 'Repair'
    WHEN 'QA' THEN 'Quality Assurance'
    WHEN 'RETURN_LOGISTICS' THEN 'Return Logistics'
  END,
  CASE p.policy_code
    WHEN 'PICKUP' THEN 'Target for authorized pickup processing.'
    WHEN 'DIAGNOSIS' THEN 'Target for initial diagnosis.'
    WHEN 'REPAIR' THEN 'Maximum standard local repair target; configured at the upper end of the 2–3 business day range.'
    WHEN 'QA' THEN 'Target for quality assurance after repair.'
    WHEN 'RETURN_LOGISTICS' THEN 'Target for return logistics after repair completion.'
  END,
  c.id,
  CASE p.policy_code
    WHEN 'PICKUP' THEN 2
    WHEN 'DIAGNOSIS' THEN 1
    WHEN 'REPAIR' THEN 3
    WHEN 'QA' THEN 1
    WHEN 'RETURN_LOGISTICS' THEN 2
  END,
  'active',
  CASE p.policy_code
    WHEN 'PICKUP' THEN 10
    WHEN 'DIAGNOSIS' THEN 20
    WHEN 'REPAIR' THEN 30
    WHEN 'QA' THEN 40
    WHEN 'RETURN_LOGISTICS' THEN 50
  END,
  NULL
FROM sla_policies p
CROSS JOIN sla_calendars c
WHERE c.calendar_code = 'TTO_PORTAL_OPERATIONS'
  AND p.policy_code IN ('PICKUP','DIAGNOSIS','REPAIR','QA','RETURN_LOGISTICS')
  AND NOT EXISTS (
    SELECT 1 FROM sla_policy_versions existing
    WHERE existing.policy_id = p.id AND existing.version_number = 1
  );

INSERT IGNORE INTO permissions (name, label, module) VALUES
  ('sla.view', 'View SLA Configuration', 'sla'),
  ('sla.manage', 'Manage SLA Configuration', 'sla');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.name = 'SUPER_ADMIN' AND p.name IN ('sla.view','sla.manage');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.name = 'MOE_HEAD_OFFICE' AND p.name IN ('sla.view','sla.manage');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.name IN ('TSTT_OVERSIGHT','ICT_DISTRICT_COORDINATOR','REPAIR_CENTRE')
  AND p.name = 'sla.view';
