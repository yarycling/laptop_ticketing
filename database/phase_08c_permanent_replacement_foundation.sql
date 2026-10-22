-- Phase 8C-A permanent replacement foundation. Safe to apply repeatedly.
-- This creates the replacement workflow shell only; source selection,
-- acceptance, Phase 5 transfer, and Phase 7F dispatch are later 8C steps.

INSERT IGNORE INTO exception_case_statuses (code, name, sort_order) VALUES
 ('PERMANENT_REPLACEMENT_COMPLETED','Permanent Replacement Completed',90);

CREATE TABLE IF NOT EXISTS permanent_replacement_statuses (
  code VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  name VARCHAR(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  sort_order SMALLINT UNSIGNED NOT NULL,
  is_terminal TINYINT(1) NOT NULL DEFAULT 0,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (code),
  KEY idx_perm_repl_status_active_sort (is_active, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO permanent_replacement_statuses (code, name, sort_order, is_terminal) VALUES
 ('SELECTION_REQUIRED','Selection Required',10,0),
 ('REPLACEMENT_SELECTED','Replacement Selected',20,0),
 ('AWAITING_ACCEPTANCE','Awaiting Acceptance',30,0),
 ('COMPLETED','Completed',40,1),
 ('CANCELLED','Cancelled',90,1);

CREATE TABLE IF NOT EXISTS permanent_replacement_cases (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  replacement_number VARCHAR(32) COLLATE utf8mb4_unicode_ci NULL,
  exception_case_id INT UNSIGNED NOT NULL,
  ticket_id INT UNSIGNED NOT NULL,
  logistics_case_id INT UNSIGNED NOT NULL,
  repair_job_id INT UNSIGNED NOT NULL,
  original_device_id INT UNSIGNED NOT NULL,
  replacement_source_type VARCHAR(32) COLLATE utf8mb4_unicode_ci NULL,
  staged_manufacturer_unit_id BIGINT UNSIGNED NULL,
  replacement_device_id INT UNSIGNED NULL,
  repair_service_location_id INT UNSIGNED NOT NULL,
  current_status_code VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  active_record_key TINYINT UNSIGNED NULL DEFAULT 1,
  created_by INT UNSIGNED NOT NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_by INT UNSIGNED NULL,
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  completed_by INT UNSIGNED NULL,
  completed_at DATETIME(6) NULL,
  closed_at DATETIME(6) NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_perm_repl_number (replacement_number),
  UNIQUE KEY uq_perm_repl_exception_active (exception_case_id, active_record_key),
  KEY idx_perm_repl_ticket (ticket_id, created_at),
  KEY idx_perm_repl_status (current_status_code, updated_at),
  KEY idx_perm_repl_location (repair_service_location_id, current_status_code),
  KEY idx_perm_repl_original_device (original_device_id),
  KEY idx_perm_repl_replacement_device (replacement_device_id),
  CONSTRAINT chk_perm_repl_source_type CHECK (replacement_source_type IS NULL OR replacement_source_type IN ('MANUFACTURER_SUPPLIED','EXISTING_INVENTORY')),
  CONSTRAINT fk_perm_repl_exception FOREIGN KEY (exception_case_id) REFERENCES repair_exception_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_perm_repl_ticket FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_perm_repl_logistics FOREIGN KEY (logistics_case_id) REFERENCES ticket_logistics_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_perm_repl_job FOREIGN KEY (repair_job_id) REFERENCES repair_jobs(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_perm_repl_original_device FOREIGN KEY (original_device_id) REFERENCES devices(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_perm_repl_staged_unit FOREIGN KEY (staged_manufacturer_unit_id) REFERENCES manufacturer_supplied_units(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_perm_repl_replacement_device FOREIGN KEY (replacement_device_id) REFERENCES devices(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_perm_repl_location FOREIGN KEY (repair_service_location_id) REFERENCES service_locations(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_perm_repl_status FOREIGN KEY (current_status_code) REFERENCES permanent_replacement_statuses(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_perm_repl_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_perm_repl_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_perm_repl_completed_by FOREIGN KEY (completed_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS permanent_replacement_status_history (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  replacement_case_id INT UNSIGNED NOT NULL,
  from_status_code VARCHAR(50) COLLATE utf8mb4_unicode_ci NULL,
  to_status_code VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  actor_user_id INT UNSIGNED NOT NULL,
  reason VARCHAR(1000) COLLATE utf8mb4_unicode_ci NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  KEY idx_perm_repl_history_case_time (replacement_case_id, created_at, id),
  CONSTRAINT fk_perm_repl_history_case FOREIGN KEY (replacement_case_id) REFERENCES permanent_replacement_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_perm_repl_history_from FOREIGN KEY (from_status_code) REFERENCES permanent_replacement_statuses(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_perm_repl_history_to FOREIGN KEY (to_status_code) REFERENCES permanent_replacement_statuses(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_perm_repl_history_actor FOREIGN KEY (actor_user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS device_replacements (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  replacement_case_id INT UNSIGNED NOT NULL,
  original_device_id INT UNSIGNED NOT NULL,
  replacement_device_id INT UNSIGNED NOT NULL,
  reason_code VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  approved_exception_case_id INT UNSIGNED NOT NULL,
  effective_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  created_by INT UNSIGNED NOT NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_device_repl_case_original (replacement_case_id, original_device_id),
  KEY idx_device_repl_original (original_device_id, effective_at),
  KEY idx_device_repl_replacement (replacement_device_id, effective_at),
  CONSTRAINT fk_device_repl_case FOREIGN KEY (replacement_case_id) REFERENCES permanent_replacement_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_device_repl_original FOREIGN KEY (original_device_id) REFERENCES devices(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_device_repl_replacement FOREIGN KEY (replacement_device_id) REFERENCES devices(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_device_repl_exception FOREIGN KEY (approved_exception_case_id) REFERENCES repair_exception_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_device_repl_actor FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO permissions (name,label,module) VALUES
 ('replacements.view','View Permanent Replacements','replacements'),
 ('replacements.start','Start Permanent Replacement','replacements'),
 ('replacements.select','Select Permanent Replacement Source','replacements'),
 ('replacements.accept','Accept Permanent Replacement','replacements');

INSERT IGNORE INTO role_permissions (role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p
WHERE r.name='SUPER_ADMIN' AND p.name IN ('replacements.view','replacements.start','replacements.select','replacements.accept');

INSERT IGNORE INTO role_permissions (role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p
WHERE r.name='REPAIR_CENTRE' AND p.name IN ('replacements.view','replacements.start','replacements.select','replacements.accept');

INSERT IGNORE INTO role_permissions (role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p
WHERE r.name IN ('MOE_HEAD_OFFICE','TSTT_OVERSIGHT','ICT_DISTRICT_COORDINATOR')
 AND p.name='replacements.view';

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_permanent_replacement_queue AS
SELECT
  prc.id AS replacement_case_id,
  prc.replacement_number,
  prc.exception_case_id,
  prc.ticket_id,
  t.ticket_number,
  prc.logistics_case_id,
  tlc.logistics_number,
  ls.code AS logistics_status_code,
  ls.name AS logistics_status_name,
  prc.repair_job_id,
  prc.original_device_id,
  od.serial_number AS original_serial_number,
  od.asset_tag AS original_asset_tag,
  dm.model_name AS original_model_name,
  m.name AS original_manufacturer_name,
  prc.replacement_source_type,
  prc.staged_manufacturer_unit_id,
  msu.serial_number AS staged_serial_number,
  msu.model_description AS staged_model_description,
  prc.replacement_device_id,
  rd.serial_number AS replacement_serial_number,
  rd.asset_tag AS replacement_asset_tag,
  prc.repair_service_location_id,
  sl.name AS repair_centre_name,
  t.origin_school_id,
  s.name AS origin_school_name,
  t.origin_district_id,
  d.name AS origin_district_name,
  prc.current_status_code AS replacement_status_code,
  prs.name AS replacement_status_name,
  ec.current_status_code AS exception_status_code,
  tss.code AS ticket_status_code,
  tss.name AS ticket_status_name,
  lc.code AS original_device_lifecycle_code,
  lc.name AS original_device_lifecycle_name,
  vc.current_custody_level AS phase5_custody_level,
  vc.district_id AS phase5_district_id,
  vc.school_id AS phase5_school_id,
  vc.student_id AS phase5_student_id,
  prc.created_by,
  prc.created_at,
  prc.updated_by,
  prc.updated_at,
  prc.completed_by,
  prc.completed_at,
  prc.closed_at,
  prc.active_record_key
FROM permanent_replacement_cases prc
JOIN repair_exception_cases ec ON ec.id = prc.exception_case_id
JOIN tickets t ON t.id = prc.ticket_id
JOIN ticket_logistics_cases tlc ON tlc.id = prc.logistics_case_id
JOIN logistics_statuses ls ON ls.id = tlc.current_status_id
JOIN ticket_statuses tss ON tss.id = t.current_status_id
JOIN devices od ON od.id = prc.original_device_id
JOIN device_lifecycle_statuses lc ON lc.id = od.lifecycle_status_id
JOIN device_models dm ON dm.id = od.device_model_id
JOIN manufacturers m ON m.id = dm.manufacturer_id
JOIN service_locations sl ON sl.id = prc.repair_service_location_id
JOIN permanent_replacement_statuses prs ON prs.code = prc.current_status_code
LEFT JOIN schools s ON s.id = t.origin_school_id
LEFT JOIN districts d ON d.id = t.origin_district_id
LEFT JOIN manufacturer_supplied_units msu ON msu.id = prc.staged_manufacturer_unit_id
LEFT JOIN devices rd ON rd.id = prc.replacement_device_id
LEFT JOIN v_device_current_custody vc ON vc.device_id = prc.original_device_id;
