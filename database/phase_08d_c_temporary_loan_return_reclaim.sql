-- Phase 8D-C: temporary-loan return request and physical Repair Centre reclaim.
-- Repeatable migration; the spare remains a shared device/stock asset.
CREATE TABLE IF NOT EXISTS temporary_loan_return_reasons (
  code VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  name VARCHAR(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  sort_order SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO temporary_loan_return_reasons (code,name,is_active,sort_order) VALUES
  ('ORIGINAL_DEVICE_RETURNED','Original device returned',1,10),
  ('PERMANENT_REPLACEMENT_AVAILABLE','Permanent replacement available',1,20),
  ('LOAN_NO_LONGER_REQUIRED','Loan no longer required',1,30),
  ('ADMINISTRATIVE_RECALL','Administrative recall',1,40),
  ('OTHER','Other',1,50)
ON DUPLICATE KEY UPDATE name=VALUES(name),is_active=VALUES(is_active),sort_order=VALUES(sort_order);

CREATE TABLE IF NOT EXISTS temporary_loan_return_conditions (
  code VARCHAR(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  name VARCHAR(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  is_serviceable TINYINT(1) NOT NULL DEFAULT 0,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO temporary_loan_return_conditions (code,name,is_serviceable,is_active) VALUES
  ('SERVICEABLE','Serviceable',1,1),('DAMAGED','Damaged',0,1),
  ('LOST','Lost',0,1),('STOLEN','Stolen',0,1),('OTHER','Other / unverified',0,1)
ON DUPLICATE KEY UPDATE name=VALUES(name),is_serviceable=VALUES(is_serviceable),is_active=VALUES(is_active);

DROP PROCEDURE IF EXISTS p8dc_apply_temporary_loan_return;
DELIMITER //
CREATE PROCEDURE p8dc_apply_temporary_loan_return()
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND COLUMN_NAME='return_requested_by') THEN
    ALTER TABLE temporary_loan_cases ADD COLUMN return_requested_by INT UNSIGNED NULL AFTER issued_by;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND COLUMN_NAME='return_requested_at') THEN
    ALTER TABLE temporary_loan_cases ADD COLUMN return_requested_at DATETIME(6) NULL AFTER return_requested_by;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND COLUMN_NAME='return_reason_code') THEN
    ALTER TABLE temporary_loan_cases ADD COLUMN return_reason_code VARCHAR(50) COLLATE utf8mb4_unicode_ci NULL AFTER return_requested_at;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND COLUMN_NAME='return_notes') THEN
    ALTER TABLE temporary_loan_cases ADD COLUMN return_notes VARCHAR(1000) COLLATE utf8mb4_unicode_ci NULL AFTER return_reason_code;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND COLUMN_NAME='return_condition_code') THEN
    ALTER TABLE temporary_loan_cases ADD COLUMN return_condition_code VARCHAR(30) COLLATE utf8mb4_unicode_ci NULL AFTER return_notes;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND COLUMN_NAME='returned_by') THEN
    ALTER TABLE temporary_loan_cases ADD COLUMN returned_by INT UNSIGNED NULL AFTER return_condition_code;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND COLUMN_NAME='returned_at') THEN
    ALTER TABLE temporary_loan_cases ADD COLUMN returned_at DATETIME(6) NULL AFTER returned_by;
  END IF;

  INSERT IGNORE INTO temporary_loan_statuses (code,name,sort_order,is_terminal) VALUES
    ('RETURN_REQUIRED','Return Required',50,0),('RETURNED','Returned',60,1);

  IF NOT EXISTS (SELECT 1 FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND INDEX_NAME='idx_temporary_loan_return_requested_by') THEN
    ALTER TABLE temporary_loan_cases ADD KEY idx_temporary_loan_return_requested_by (return_requested_by);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND INDEX_NAME='idx_temporary_loan_returned_by') THEN
    ALTER TABLE temporary_loan_cases ADD KEY idx_temporary_loan_returned_by (returned_by);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND CONSTRAINT_NAME='fk_temporary_loan_return_reason') THEN
    ALTER TABLE temporary_loan_cases ADD CONSTRAINT fk_temporary_loan_return_reason FOREIGN KEY (return_reason_code) REFERENCES temporary_loan_return_reasons(code) ON DELETE RESTRICT ON UPDATE RESTRICT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND CONSTRAINT_NAME='fk_temporary_loan_return_condition') THEN
    ALTER TABLE temporary_loan_cases ADD CONSTRAINT fk_temporary_loan_return_condition FOREIGN KEY (return_condition_code) REFERENCES temporary_loan_return_conditions(code) ON DELETE RESTRICT ON UPDATE RESTRICT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND CONSTRAINT_NAME='fk_temporary_loan_return_requested_by') THEN
    ALTER TABLE temporary_loan_cases ADD CONSTRAINT fk_temporary_loan_return_requested_by FOREIGN KEY (return_requested_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND CONSTRAINT_NAME='fk_temporary_loan_returned_by') THEN
    ALTER TABLE temporary_loan_cases ADD CONSTRAINT fk_temporary_loan_returned_by FOREIGN KEY (returned_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT;
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND CONSTRAINT_NAME='chk_temporary_loan_active' AND CONSTRAINT_TYPE='CHECK') THEN
    SET @p8dc_sql='ALTER TABLE temporary_loan_cases DROP CHECK chk_temporary_loan_active';
    PREPARE p8dc_stmt FROM @p8dc_sql; EXECUTE p8dc_stmt; DEALLOCATE PREPARE p8dc_stmt;
  END IF;
  IF EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND CONSTRAINT_NAME='chk_temporary_loan_no_issue' AND CONSTRAINT_TYPE='CHECK') THEN
    SET @p8dc_sql='ALTER TABLE temporary_loan_cases DROP CHECK chk_temporary_loan_no_issue';
    PREPARE p8dc_stmt FROM @p8dc_sql; EXECUTE p8dc_stmt; DEALLOCATE PREPARE p8dc_stmt;
  END IF;
  ALTER TABLE temporary_loan_cases ADD CONSTRAINT chk_temporary_loan_active CHECK (
    (current_status_code IN ('PENDING_DISTRICT_APPROVAL','AUTHORIZED','SPARE_SELECTED','ACTIVE_LOAN','RETURN_REQUIRED') AND active_record_key=1 AND closed_at IS NULL)
    OR (current_status_code IN ('REJECTED','CANCELLED','RETURNED') AND active_record_key IS NULL AND closed_at IS NOT NULL));
  ALTER TABLE temporary_loan_cases ADD CONSTRAINT chk_temporary_loan_no_issue CHECK (
    (current_status_code IN ('PENDING_DISTRICT_APPROVAL','AUTHORIZED','REJECTED','CANCELLED') AND selected_spare_device_id IS NULL AND selected_by IS NULL AND selected_at IS NULL AND issued_at IS NULL AND issued_by IS NULL AND return_requested_by IS NULL AND return_requested_at IS NULL AND return_reason_code IS NULL AND returned_by IS NULL AND returned_at IS NULL)
    OR (current_status_code='SPARE_SELECTED' AND selected_spare_device_id IS NOT NULL AND selected_by IS NOT NULL AND selected_at IS NOT NULL AND issued_at IS NULL AND issued_by IS NULL AND return_requested_by IS NULL AND return_requested_at IS NULL AND return_reason_code IS NULL AND returned_by IS NULL AND returned_at IS NULL)
    OR (current_status_code='ACTIVE_LOAN' AND selected_spare_device_id IS NOT NULL AND selected_by IS NOT NULL AND selected_at IS NOT NULL AND issued_at IS NOT NULL AND issued_by IS NOT NULL AND return_requested_by IS NULL AND return_requested_at IS NULL AND return_reason_code IS NULL AND returned_by IS NULL AND returned_at IS NULL)
    OR (current_status_code='RETURN_REQUIRED' AND selected_spare_device_id IS NOT NULL AND issued_at IS NOT NULL AND issued_by IS NOT NULL AND return_requested_by IS NOT NULL AND return_requested_at IS NOT NULL AND return_reason_code IS NOT NULL AND returned_by IS NULL AND returned_at IS NULL)
    OR (current_status_code='RETURNED' AND selected_spare_device_id IS NOT NULL AND issued_at IS NOT NULL AND issued_by IS NOT NULL AND return_requested_by IS NOT NULL AND return_requested_at IS NOT NULL AND return_reason_code IS NOT NULL AND return_condition_code='SERVICEABLE' AND returned_by IS NOT NULL AND returned_at IS NOT NULL));
END //
DELIMITER ;
CALL p8dc_apply_temporary_loan_return();
DROP PROCEDURE IF EXISTS p8dc_apply_temporary_loan_return;

INSERT IGNORE INTO permissions (name,label,module) VALUES
  ('temporary_loans.request_return','Request Temporary Spare Return','temporary_loans'),
  ('temporary_loans.reclaim','Reclaim Temporary Spare','temporary_loans');
INSERT IGNORE INTO role_permissions (role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p
WHERE r.name IN ('SUPER_ADMIN','REPAIR_CENTRE')
  AND p.name IN ('temporary_loans.request_return','temporary_loans.reclaim');

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
  loan.selected_at,loan.issued_by,loan.issued_at,loan.return_requested_by,loan.return_requested_at,
  loan.return_reason_code,return_reason.name AS return_reason_name,loan.return_notes,
  loan.return_condition_code,loan.returned_by,loan.returned_at,loan.conversion_status,
  loan.active_record_key,loan.created_at,loan.updated_at,loan.closed_at,
  ts.code AS ticket_status_code,ls.code AS logistics_status_code,rj.completed_at AS repair_completed_at,
  (SELECT m.current_status_code FROM manufacturer_return_cases m
    WHERE m.ticket_id=loan.ticket_id ORDER BY m.id DESC LIMIT 1) AS manufacturer_return_status_code,
  spare.serial_number AS selected_spare_serial_number,spare.asset_tag AS selected_spare_asset_tag,
  manufacturer.name AS selected_spare_manufacturer_name,model.model_name AS selected_spare_model_name,
  spare_lifecycle.code AS selected_spare_lifecycle_code,
  CASE WHEN spare.id IS NULL THEN NULL WHEN active_stock.id IS NULL THEN 'NOT_IN_FREE_STOCK'
       ELSE active_stock.stock_status END AS selected_spare_stock_status,
  active_stock.service_location_id AS selected_spare_stock_location_id,
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
LEFT JOIN temporary_loan_return_reasons return_reason ON return_reason.code=loan.return_reason_code
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
    WHEN 'RETURN_REQUIRED' THEN 'TEMPORARY_LOAN_RETURN_REQUIRED'
    WHEN 'RETURNED' THEN 'TEMPORARY_LOAN_RETURNED'
  END,
  history.id,history.actor_user_id,NULL,NULL,NULL,loan.loan_number,40
FROM temporary_loan_status_history history
JOIN temporary_loan_cases loan ON loan.id=history.temporary_loan_case_id
WHERE history.to_status_code IN ('SPARE_SELECTED','ACTIVE_LOAN','RETURN_REQUIRED','RETURNED');
