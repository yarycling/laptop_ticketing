-- Phase 8D-A only. Repeatable schema, reference data, and read models.
INSERT IGNORE INTO device_lifecycle_statuses (code,name,description,sort_order,status)
VALUES ('TEMPORARY_LOAN','Temporary Loan','Issued as a temporary spare device',65,'active');

CREATE TABLE IF NOT EXISTS spare_pools (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  pool_code VARCHAR(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  name VARCHAR(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  service_location_id INT UNSIGNED NOT NULL,
  status VARCHAR(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  is_default TINYINT(1) NOT NULL DEFAULT 1,
  active_default_key TINYINT UNSIGNED NULL DEFAULT 1,
  created_by INT UNSIGNED NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_by INT UNSIGNED NULL,
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_spare_pool_code (pool_code),
  UNIQUE KEY uq_spare_pool_active_default (service_location_id,active_default_key),
  CONSTRAINT chk_spare_pool_status CHECK (status IN ('active','inactive')),
  CONSTRAINT chk_spare_pool_default CHECK (
    (status='active' AND is_default=1 AND active_default_key=1)
    OR ((status='inactive' OR is_default=0) AND active_default_key IS NULL)),
  CONSTRAINT fk_spare_pool_location FOREIGN KEY (service_location_id) REFERENCES service_locations(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_spare_pool_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_spare_pool_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO spare_pools (pool_code,name,service_location_id)
SELECT 'RC8-DEFAULT','P7D Repair Centre Default Spare Pool',loc.id
FROM service_locations loc
WHERE loc.id=8 AND loc.location_type='REPAIR_CENTRE' AND loc.is_active=1;

CREATE TABLE IF NOT EXISTS temporary_loan_statuses (
  code VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  name VARCHAR(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  sort_order SMALLINT UNSIGNED NOT NULL,
  is_terminal TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO temporary_loan_statuses (code,name,sort_order,is_terminal) VALUES
 ('PENDING_DISTRICT_APPROVAL','Pending District Approval',10,0),
 ('AUTHORIZED','Authorized',20,0),
 ('REJECTED','Rejected',90,1),
 ('CANCELLED','Cancelled',95,1);

CREATE TABLE IF NOT EXISTS temporary_loan_cases (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  loan_number VARCHAR(32) COLLATE utf8mb4_unicode_ci NULL,
  ticket_id INT UNSIGNED NOT NULL,
  repair_job_id INT UNSIGNED NOT NULL,
  original_device_id INT UNSIGNED NOT NULL,
  origin_district_id INT UNSIGNED NOT NULL,
  origin_school_id INT UNSIGNED NULL,
  repair_service_location_id INT UNSIGNED NOT NULL,
  spare_pool_id INT UNSIGNED NOT NULL,
  current_status_code VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  requested_by INT UNSIGNED NOT NULL,
  requested_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  request_reason_code VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  request_notes VARCHAR(1000) COLLATE utf8mb4_unicode_ci NULL,
  authorized_by INT UNSIGNED NULL,
  authorized_at DATETIME(6) NULL,
  authorization_notes VARCHAR(1000) COLLATE utf8mb4_unicode_ci NULL,
  rejected_by INT UNSIGNED NULL,
  rejected_at DATETIME(6) NULL,
  rejection_reason VARCHAR(1000) COLLATE utf8mb4_unicode_ci NULL,
  selected_spare_device_id INT UNSIGNED NULL,
  issued_at DATETIME(6) NULL,
  returned_at DATETIME(6) NULL,
  conversion_status VARCHAR(50) COLLATE utf8mb4_unicode_ci NULL,
  active_record_key TINYINT UNSIGNED NULL DEFAULT 1,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  closed_at DATETIME(6) NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_temporary_loan_number (loan_number),
  UNIQUE KEY uq_temporary_loan_active (ticket_id,original_device_id,active_record_key),
  KEY idx_temporary_loan_district (origin_district_id,current_status_code),
  KEY idx_temporary_loan_repair (repair_service_location_id,current_status_code),
  KEY idx_temporary_loan_ticket (ticket_id,created_at),
  CONSTRAINT chk_temporary_loan_active CHECK (
    (current_status_code IN ('PENDING_DISTRICT_APPROVAL','AUTHORIZED') AND active_record_key=1 AND closed_at IS NULL)
    OR (current_status_code IN ('REJECTED','CANCELLED') AND active_record_key IS NULL AND closed_at IS NOT NULL)),
  CONSTRAINT chk_temporary_loan_no_issue CHECK (selected_spare_device_id IS NULL AND issued_at IS NULL AND returned_at IS NULL AND conversion_status IS NULL),
  CONSTRAINT fk_temporary_loan_status FOREIGN KEY (current_status_code) REFERENCES temporary_loan_statuses(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_temporary_loan_ticket FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_temporary_loan_job FOREIGN KEY (repair_job_id) REFERENCES repair_jobs(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_temporary_loan_original FOREIGN KEY (original_device_id) REFERENCES devices(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_temporary_loan_district FOREIGN KEY (origin_district_id) REFERENCES districts(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_temporary_loan_school FOREIGN KEY (origin_school_id) REFERENCES schools(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_temporary_loan_location FOREIGN KEY (repair_service_location_id) REFERENCES service_locations(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_temporary_loan_pool FOREIGN KEY (spare_pool_id) REFERENCES spare_pools(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_temporary_loan_requested_by FOREIGN KEY (requested_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_temporary_loan_authorized_by FOREIGN KEY (authorized_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_temporary_loan_rejected_by FOREIGN KEY (rejected_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_temporary_loan_selected FOREIGN KEY (selected_spare_device_id) REFERENCES devices(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS temporary_loan_status_history (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  temporary_loan_case_id INT UNSIGNED NOT NULL,
  from_status_code VARCHAR(50) COLLATE utf8mb4_unicode_ci NULL,
  to_status_code VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  actor_user_id INT UNSIGNED NOT NULL,
  notes VARCHAR(1000) COLLATE utf8mb4_unicode_ci NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  KEY idx_temporary_loan_history (temporary_loan_case_id,created_at,id),
  CONSTRAINT fk_temporary_loan_history_case FOREIGN KEY (temporary_loan_case_id) REFERENCES temporary_loan_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_temporary_loan_history_from FOREIGN KEY (from_status_code) REFERENCES temporary_loan_statuses(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_temporary_loan_history_to FOREIGN KEY (to_status_code) REFERENCES temporary_loan_statuses(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_temporary_loan_history_actor FOREIGN KEY (actor_user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS temporary_loan_decisions (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  temporary_loan_case_id INT UNSIGNED NOT NULL,
  decision_code VARCHAR(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  actor_user_id INT UNSIGNED NOT NULL,
  notes VARCHAR(1000) COLLATE utf8mb4_unicode_ci NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_temporary_loan_decision_case (temporary_loan_case_id),
  CONSTRAINT chk_temporary_loan_decision CHECK (decision_code IN ('APPROVE','REJECT')),
  CONSTRAINT fk_temporary_loan_decision_case FOREIGN KEY (temporary_loan_case_id) REFERENCES temporary_loan_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_temporary_loan_decision_actor FOREIGN KEY (actor_user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO permissions (name,label,module) VALUES
 ('temporary_loans.view','View Temporary Loans','temporary_loans'),
 ('temporary_loans.request','Request Temporary Spare','temporary_loans'),
 ('temporary_loans.authorize','Authorize Temporary Spare','temporary_loans'),
 ('temporary_loans.cancel','Cancel Pending Temporary Spare','temporary_loans');

INSERT IGNORE INTO role_permissions (role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p
WHERE r.name='SUPER_ADMIN' AND p.name IN ('temporary_loans.view','temporary_loans.request','temporary_loans.authorize','temporary_loans.cancel');
INSERT IGNORE INTO role_permissions (role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p
WHERE r.name='REPAIR_CENTRE' AND p.name IN ('temporary_loans.view','temporary_loans.request');
INSERT IGNORE INTO role_permissions (role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p
WHERE r.name='ICT_DISTRICT_COORDINATOR' AND p.name IN ('temporary_loans.view','temporary_loans.authorize');
INSERT IGNORE INTO role_permissions (role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p
WHERE r.name IN ('MOE_HEAD_OFFICE','TSTT_OVERSIGHT') AND p.name='temporary_loans.view';

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_temporary_loan_request_context AS
SELECT t.id AS ticket_id,t.ticket_number,t.device_id AS original_device_id,
  t.origin_district_id,t.origin_school_id,ts.code AS ticket_status_code,
  lc.id AS logistics_case_id,lc.repair_centre_location_id AS repair_service_location_id,
  ls.code AS logistics_status_code,rj.id AS repair_job_id,
  life.code AS original_lifecycle_code,
  pool.id AS spare_pool_id,pool.pool_code,pool.name AS spare_pool_name,
  CASE WHEN ts.code='UNDER_REPAIR' AND ls.code='AT_REPAIR_CENTRE'
    AND rj.id IS NOT NULL AND lc.active_record_key=1 AND lc.closed_at IS NULL
    AND life.code IN ('IN_REPAIR','MANUFACTURER_RETURN')
    AND pool.id IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM permanent_replacement_cases pr
      WHERE pr.ticket_id=t.id AND pr.current_status_code='COMPLETED')
    AND NOT EXISTS (SELECT 1 FROM temporary_loan_cases loan
      WHERE loan.ticket_id=t.id AND loan.original_device_id=t.device_id
        AND loan.active_record_key=1)
    THEN 1 ELSE 0 END AS can_request
FROM tickets t
JOIN ticket_statuses ts ON ts.id=t.current_status_id
JOIN devices original ON original.id=t.device_id
JOIN device_lifecycle_statuses life ON life.id=original.lifecycle_status_id
LEFT JOIN ticket_logistics_cases lc ON lc.id=(
  SELECT x.id FROM ticket_logistics_cases x WHERE x.ticket_id=t.id
  ORDER BY x.id DESC LIMIT 1)
LEFT JOIN logistics_statuses ls ON ls.id=lc.current_status_id
LEFT JOIN repair_jobs rj ON rj.logistics_case_id=lc.id
LEFT JOIN service_locations loc ON loc.id=lc.repair_centre_location_id
LEFT JOIN spare_pools pool ON pool.service_location_id=loc.id
  AND pool.status='active' AND pool.is_default=1 AND pool.active_default_key=1
WHERE loc.location_type='REPAIR_CENTRE' AND loc.is_active=1;

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_temporary_loan_queue AS
SELECT loan.id AS temporary_loan_case_id,loan.loan_number,
  loan.ticket_id,t.ticket_number,loan.original_device_id,
  original.serial_number AS original_serial_number,original.asset_tag AS original_asset_tag,
  loan.origin_district_id,district.name AS origin_district_name,
  loan.origin_school_id,school.name AS origin_school_name,
  loan.repair_job_id,loan.repair_service_location_id,loc.name AS repair_centre_name,
  loan.spare_pool_id,pool.pool_code,pool.name AS spare_pool_name,
  loan.current_status_code,status.name AS loan_status_name,
  loan.request_reason_code,loan.requested_by,loan.requested_at,loan.request_notes,
  loan.authorized_by,loan.authorized_at,loan.authorization_notes,
  loan.rejected_by,loan.rejected_at,loan.rejection_reason,
  loan.selected_spare_device_id,loan.active_record_key,loan.created_at,loan.updated_at,loan.closed_at,
  ts.code AS ticket_status_code,ls.code AS logistics_status_code,
  rj.completed_at AS repair_completed_at,
  (SELECT m.current_status_code FROM manufacturer_return_cases m
    WHERE m.ticket_id=loan.ticket_id ORDER BY m.id DESC LIMIT 1) AS manufacturer_return_status_code
FROM temporary_loan_cases loan
JOIN tickets t ON t.id=loan.ticket_id
JOIN ticket_statuses ts ON ts.id=t.current_status_id
JOIN devices original ON original.id=loan.original_device_id
JOIN districts district ON district.id=loan.origin_district_id
LEFT JOIN schools school ON school.id=loan.origin_school_id
JOIN service_locations loc ON loc.id=loan.repair_service_location_id
JOIN spare_pools pool ON pool.id=loan.spare_pool_id
JOIN temporary_loan_statuses status ON status.code=loan.current_status_code
JOIN repair_jobs rj ON rj.id=loan.repair_job_id
JOIN ticket_logistics_cases lc ON lc.id=rj.logistics_case_id
JOIN logistics_statuses ls ON ls.id=lc.current_status_id;
