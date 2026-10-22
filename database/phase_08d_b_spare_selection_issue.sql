-- Phase 8D-B: exclusive spare reservation and temporary-loan issue.
-- Repeatable migration; devices remain in the shared devices/stock model.
DROP PROCEDURE IF EXISTS p8db_apply_spare_selection_issue;
DELIMITER //
CREATE PROCEDURE p8db_apply_spare_selection_issue()
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND COLUMN_NAME='selected_by') THEN
    ALTER TABLE temporary_loan_cases ADD COLUMN selected_by INT UNSIGNED NULL AFTER selected_spare_device_id;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND COLUMN_NAME='selected_at') THEN
    ALTER TABLE temporary_loan_cases ADD COLUMN selected_at DATETIME(6) NULL AFTER selected_by;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND COLUMN_NAME='issued_by') THEN
    ALTER TABLE temporary_loan_cases ADD COLUMN issued_by INT UNSIGNED NULL AFTER issued_at;
  END IF;

  INSERT IGNORE INTO temporary_loan_statuses (code,name,sort_order,is_terminal) VALUES
    ('SPARE_SELECTED','Spare Selected',30,0),('ACTIVE_LOAN','Active Loan',40,0);

  IF EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND CONSTRAINT_NAME='chk_temporary_loan_active' AND CONSTRAINT_TYPE='CHECK') THEN
    SET @p8db_sql='ALTER TABLE temporary_loan_cases DROP CHECK chk_temporary_loan_active';
    PREPARE p8db_stmt FROM @p8db_sql; EXECUTE p8db_stmt; DEALLOCATE PREPARE p8db_stmt;
  END IF;
  IF EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND CONSTRAINT_NAME='chk_temporary_loan_no_issue' AND CONSTRAINT_TYPE='CHECK') THEN
    SET @p8db_sql='ALTER TABLE temporary_loan_cases DROP CHECK chk_temporary_loan_no_issue';
    PREPARE p8db_stmt FROM @p8db_sql; EXECUTE p8db_stmt; DEALLOCATE PREPARE p8db_stmt;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND CONSTRAINT_NAME='chk_temporary_loan_active' AND CONSTRAINT_TYPE='CHECK') THEN
    ALTER TABLE temporary_loan_cases ADD CONSTRAINT chk_temporary_loan_active CHECK (
      (current_status_code IN ('PENDING_DISTRICT_APPROVAL','AUTHORIZED','SPARE_SELECTED','ACTIVE_LOAN') AND active_record_key=1 AND closed_at IS NULL)
      OR (current_status_code IN ('REJECTED','CANCELLED') AND active_record_key IS NULL AND closed_at IS NOT NULL));
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND CONSTRAINT_NAME='chk_temporary_loan_no_issue' AND CONSTRAINT_TYPE='CHECK') THEN
    ALTER TABLE temporary_loan_cases ADD CONSTRAINT chk_temporary_loan_no_issue CHECK (
      (current_status_code IN ('PENDING_DISTRICT_APPROVAL','AUTHORIZED','REJECTED','CANCELLED') AND selected_spare_device_id IS NULL AND selected_by IS NULL AND selected_at IS NULL AND issued_at IS NULL AND issued_by IS NULL)
      OR (current_status_code='SPARE_SELECTED' AND selected_spare_device_id IS NOT NULL AND selected_by IS NOT NULL AND selected_at IS NOT NULL AND issued_at IS NULL AND issued_by IS NULL)
      OR (current_status_code='ACTIVE_LOAN' AND selected_spare_device_id IS NOT NULL AND selected_by IS NOT NULL AND selected_at IS NOT NULL AND issued_at IS NOT NULL AND issued_by IS NOT NULL));
  END IF;

  IF NOT EXISTS (SELECT 1 FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND INDEX_NAME='idx_temporary_loan_selected_by') THEN
    ALTER TABLE temporary_loan_cases ADD KEY idx_temporary_loan_selected_by (selected_by);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND INDEX_NAME='idx_temporary_loan_issued_by') THEN
    ALTER TABLE temporary_loan_cases ADD KEY idx_temporary_loan_issued_by (issued_by);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND CONSTRAINT_NAME='fk_temporary_loan_selected_by') THEN
    ALTER TABLE temporary_loan_cases ADD CONSTRAINT fk_temporary_loan_selected_by FOREIGN KEY (selected_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND CONSTRAINT_NAME='fk_temporary_loan_issued_by') THEN
    ALTER TABLE temporary_loan_cases ADD CONSTRAINT fk_temporary_loan_issued_by FOREIGN KEY (issued_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT;
  END IF;
END //
DELIMITER ;
CALL p8db_apply_spare_selection_issue();
DROP PROCEDURE IF EXISTS p8db_apply_spare_selection_issue;

CREATE TABLE IF NOT EXISTS temporary_loan_spare_reservations (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  temporary_loan_case_id INT UNSIGNED NOT NULL,
  device_id INT UNSIGNED NOT NULL,
  reservation_status VARCHAR(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'RESERVED',
  active_record_key TINYINT UNSIGNED NULL DEFAULT 1,
  reserved_by INT UNSIGNED NOT NULL,
  reserved_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  consumed_by INT UNSIGNED NULL,
  consumed_at DATETIME(6) NULL,
  released_by INT UNSIGNED NULL,
  released_at DATETIME(6) NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_temporary_loan_spare_device_active (device_id,active_record_key),
  UNIQUE KEY uq_temporary_loan_spare_case_active (temporary_loan_case_id,active_record_key),
  KEY idx_temporary_loan_reservation_case (temporary_loan_case_id,reservation_status),
  CONSTRAINT chk_temporary_loan_reservation_status CHECK (
    (reservation_status='RESERVED' AND active_record_key=1 AND consumed_at IS NULL AND released_at IS NULL)
    OR (reservation_status='CONSUMED' AND active_record_key IS NULL AND consumed_at IS NOT NULL)
    OR (reservation_status='RELEASED' AND active_record_key IS NULL AND released_at IS NOT NULL)),
  CONSTRAINT fk_temporary_loan_reservation_case FOREIGN KEY (temporary_loan_case_id) REFERENCES temporary_loan_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_temporary_loan_reservation_device FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_temporary_loan_reservation_actor FOREIGN KEY (reserved_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_temporary_loan_reservation_consumed_by FOREIGN KEY (consumed_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_temporary_loan_reservation_released_by FOREIGN KEY (released_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS temporary_loan_custody_history (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  temporary_loan_case_id INT UNSIGNED NOT NULL,
  device_id INT UNSIGNED NOT NULL,
  from_custody_code VARCHAR(50) COLLATE utf8mb4_unicode_ci NULL,
  to_custody_code VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  actor_user_id INT UNSIGNED NOT NULL,
  notes VARCHAR(1000) COLLATE utf8mb4_unicode_ci NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  KEY idx_temporary_loan_custody_case (temporary_loan_case_id,created_at,id),
  KEY idx_temporary_loan_custody_device (device_id,created_at,id),
  CONSTRAINT fk_temporary_loan_custody_case FOREIGN KEY (temporary_loan_case_id) REFERENCES temporary_loan_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_temporary_loan_custody_device FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_temporary_loan_custody_actor FOREIGN KEY (actor_user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO permissions (name,label,module) VALUES
 ('temporary_loans.select_spare','Select Temporary Loan Spare','temporary_loans'),
 ('temporary_loans.issue','Issue Temporary Loan Spare','temporary_loans');
INSERT IGNORE INTO role_permissions (role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p
WHERE r.name IN ('SUPER_ADMIN','REPAIR_CENTRE') AND p.name IN ('temporary_loans.select_spare','temporary_loans.issue');

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_temporary_loan_spare_candidates AS
SELECT loan.id AS temporary_loan_case_id,loan.repair_service_location_id,loan.spare_pool_id,
  stock.stock_location_id,stock.device_id,stock.serial_number,stock.asset_tag,
  stock.manufacturer_name,stock.model_name,stock.lifecycle_code,stock.stock_status,
  stock.service_location_id,stock.service_location_name,stock.allocation_level,
  stock.is_reserved_for_replacement,stock.has_active_logistics,
  stock.has_active_manufacturer_return,stock.has_active_repair,
  lifecycle.id AS lifecycle_status_id
FROM temporary_loan_cases loan
JOIN spare_pools pool ON pool.id=loan.spare_pool_id
JOIN service_locations centre ON centre.id=loan.repair_service_location_id
JOIN v_device_stock_queue stock ON stock.service_location_id=loan.repair_service_location_id
JOIN devices candidate ON candidate.id=stock.device_id
JOIN device_lifecycle_statuses lifecycle ON lifecycle.id=candidate.lifecycle_status_id
WHERE loan.current_status_code='AUTHORIZED' AND loan.active_record_key=1
  AND pool.status='active' AND pool.is_default=1
  AND pool.service_location_id=loan.repair_service_location_id
  AND centre.location_type='REPAIR_CENTRE' AND centre.is_active=1
  AND stock.stock_status='IN_STOCK' AND stock.lifecycle_code='AVAILABLE'
  AND stock.allocation_level='CENTRAL'
  AND stock.device_id<>loan.original_device_id
  AND stock.is_reserved_for_replacement=0
  AND stock.has_active_logistics=0
  AND stock.has_active_manufacturer_return=0
  AND stock.has_active_repair=0
  AND NOT EXISTS (SELECT 1 FROM temporary_loan_spare_reservations reservation
    WHERE reservation.device_id=stock.device_id AND reservation.active_record_key=1
      AND reservation.reservation_status='RESERVED')
  AND NOT EXISTS (SELECT 1 FROM temporary_loan_cases other_loan
    WHERE other_loan.selected_spare_device_id=stock.device_id
      AND other_loan.active_record_key=1 AND other_loan.current_status_code IN ('SPARE_SELECTED','ACTIVE_LOAN'))
  AND NOT EXISTS (SELECT 1 FROM permanent_replacement_cases replacement_case
    WHERE replacement_case.replacement_device_id=stock.device_id
      AND replacement_case.active_selection_key IS NOT NULL)
  AND NOT EXISTS (SELECT 1 FROM device_replacements replacement
    WHERE replacement.replacement_device_id=stock.device_id)
  AND NOT EXISTS (SELECT 1 FROM device_student_assignments assignment
    WHERE assignment.device_id=stock.device_id AND assignment.active_record_key=1
      AND assignment.returned_at IS NULL);

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_temporary_loan_queue AS
SELECT loan.id AS temporary_loan_case_id,loan.loan_number,loan.ticket_id,t.ticket_number,
  loan.original_device_id,original.serial_number AS original_serial_number,
  original.asset_tag AS original_asset_tag,loan.origin_district_id,district.name AS origin_district_name,
  loan.origin_school_id,school.name AS origin_school_name,loan.repair_job_id,
  loan.repair_service_location_id,centre.name AS repair_centre_name,loan.spare_pool_id,
  pool.pool_code,pool.name AS spare_pool_name,loan.current_status_code,status.name AS loan_status_name,
  loan.request_reason_code,loan.requested_by,loan.requested_at,loan.request_notes,
  loan.authorized_by,loan.authorized_at,loan.authorization_notes,loan.rejected_by,
  loan.rejected_at,loan.rejection_reason,loan.selected_spare_device_id,loan.selected_by,
  loan.selected_at,loan.issued_by,loan.issued_at,loan.active_record_key,loan.created_at,
  loan.updated_at,loan.closed_at,ts.code AS ticket_status_code,ls.code AS logistics_status_code,
  rj.completed_at AS repair_completed_at,
  (SELECT m.current_status_code FROM manufacturer_return_cases m
    WHERE m.ticket_id=loan.ticket_id ORDER BY m.id DESC LIMIT 1) AS manufacturer_return_status_code,
  spare.serial_number AS selected_spare_serial_number,
  spare.asset_tag AS selected_spare_asset_tag,manufacturer.name AS selected_spare_manufacturer_name,
  model.model_name AS selected_spare_model_name,spare_lifecycle.code AS selected_spare_lifecycle_code,
  CASE WHEN spare.id IS NULL THEN NULL
       WHEN active_stock.id IS NULL THEN 'NOT_IN_FREE_STOCK'
       ELSE active_stock.stock_status END AS selected_spare_stock_status,
  reservation.reservation_status AS spare_reservation_status,
  CASE WHEN reservation.active_record_key=1 THEN 1 ELSE 0 END AS spare_reservation_active,
  latest_custody.to_custody_code AS physical_custody_code,
  latest_custody.created_at AS custody_recorded_at
FROM temporary_loan_cases loan
JOIN tickets t ON t.id=loan.ticket_id
JOIN ticket_statuses ts ON ts.id=t.current_status_id
JOIN devices original ON original.id=loan.original_device_id
JOIN districts district ON district.id=loan.origin_district_id
LEFT JOIN schools school ON school.id=loan.origin_school_id
JOIN service_locations centre ON centre.id=loan.repair_service_location_id
JOIN spare_pools pool ON pool.id=loan.spare_pool_id
JOIN temporary_loan_statuses status ON status.code=loan.current_status_code
JOIN repair_jobs rj ON rj.id=loan.repair_job_id
JOIN ticket_logistics_cases lc ON lc.id=rj.logistics_case_id
JOIN logistics_statuses ls ON ls.id=lc.current_status_id
LEFT JOIN devices spare ON spare.id=loan.selected_spare_device_id
LEFT JOIN device_lifecycle_statuses spare_lifecycle ON spare_lifecycle.id=spare.lifecycle_status_id
LEFT JOIN device_models model ON model.id=spare.device_model_id
LEFT JOIN manufacturers manufacturer ON manufacturer.id=model.manufacturer_id
LEFT JOIN device_stock_locations active_stock ON active_stock.device_id=spare.id
  AND active_stock.active_record_key=1 AND active_stock.stock_status='IN_STOCK'
LEFT JOIN temporary_loan_spare_reservations reservation ON reservation.id=(
  SELECT MAX(r.id) FROM temporary_loan_spare_reservations r WHERE r.temporary_loan_case_id=loan.id)
LEFT JOIN temporary_loan_custody_history latest_custody ON latest_custody.id=(
  SELECT MAX(ch.id) FROM temporary_loan_custody_history ch WHERE ch.temporary_loan_case_id=loan.id);

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_ticket_activity_08d_b AS
SELECT ticket_id,activity_at,activity_type,activity_code,related_record_id,actor_user_id,
  subject_user_id,from_status_id,to_status_id,reference_code,activity_sort_order
FROM v_ticket_activity_08d_a
UNION ALL
SELECT loan.ticket_id,history.created_at,'TEMPORARY_LOAN',
  CASE history.to_status_code
    WHEN 'SPARE_SELECTED' THEN 'TEMPORARY_SPARE_SELECTED'
    WHEN 'ACTIVE_LOAN' THEN 'TEMPORARY_LOAN_ISSUED'
  END,
  history.id,history.actor_user_id,NULL,NULL,NULL,loan.loan_number,40
FROM temporary_loan_status_history history
JOIN temporary_loan_cases loan ON loan.id=history.temporary_loan_case_id
WHERE history.to_status_code IN ('SPARE_SELECTED','ACTIVE_LOAN');
