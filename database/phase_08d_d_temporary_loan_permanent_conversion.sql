-- Phase 8D-D: convert an issued temporary spare into the permanent replacement.
-- Repeatable migration. The conversion reuses permanent_replacement_cases and
-- device_replacements; no Repair Centre stock or Phase 7 handoff is created.
CREATE TABLE IF NOT EXISTS temporary_loan_conversion_statuses (
  code VARCHAR(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  name VARCHAR(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  is_terminal TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO temporary_loan_conversion_statuses (code,name,is_terminal) VALUES
 ('PENDING','Pending Head Office',0),('APPROVED','Approved',1),('REJECTED','Rejected',1);

CREATE TABLE IF NOT EXISTS temporary_loan_conversion_reasons (
  code VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  name VARCHAR(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  sort_order SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO temporary_loan_conversion_reasons (code,name,is_active,sort_order) VALUES
 ('ORIGINAL_UNRECOVERABLE','Original device unrecoverable',1,10),
 ('REPLACEMENT_REQUIRED','Replacement required',1,20),
 ('LOAN_DEVICE_SUITABLE_FOR_PERMANENT_USE','Loan device suitable for permanent use',1,30),
 ('ADMINISTRATIVE_DECISION','Administrative decision',1,40),
 ('OTHER','Other',1,50)
ON DUPLICATE KEY UPDATE name=VALUES(name),is_active=VALUES(is_active),sort_order=VALUES(sort_order);

CREATE TABLE IF NOT EXISTS temporary_loan_conversion_requests (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  conversion_request_number VARCHAR(32) COLLATE utf8mb4_unicode_ci NULL,
  temporary_loan_case_id INT UNSIGNED NOT NULL,
  status_code VARCHAR(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  reason_code VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  request_notes VARCHAR(1000) COLLATE utf8mb4_unicode_ci NULL,
  original_custody_level VARCHAR(16) COLLATE utf8mb4_unicode_ci NULL,
  original_district_id INT UNSIGNED NULL,
  original_school_id INT UNSIGNED NULL,
  original_student_id INT UNSIGNED NULL,
  original_district_allocation_id INT UNSIGNED NULL,
  original_school_allocation_id INT UNSIGNED NULL,
  original_student_assignment_id INT UNSIGNED NULL,
  requested_by INT UNSIGNED NOT NULL,
  requested_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  active_record_key TINYINT UNSIGNED NULL DEFAULT 1,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_tl_conversion_number (conversion_request_number),
  UNIQUE KEY uq_tl_conversion_active (temporary_loan_case_id,active_record_key),
  KEY idx_tl_conversion_status (status_code,requested_at),
  KEY idx_tl_conversion_reason (reason_code),
  CONSTRAINT fk_tl_conversion_loan FOREIGN KEY (temporary_loan_case_id) REFERENCES temporary_loan_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_tl_conversion_status FOREIGN KEY (status_code) REFERENCES temporary_loan_conversion_statuses(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_tl_conversion_reason FOREIGN KEY (reason_code) REFERENCES temporary_loan_conversion_reasons(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_tl_conversion_requested_by FOREIGN KEY (requested_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS temporary_loan_conversion_decisions (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  conversion_request_id BIGINT UNSIGNED NOT NULL,
  decision_code VARCHAR(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  decided_by INT UNSIGNED NOT NULL,
  decided_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  decision_notes VARCHAR(1000) COLLATE utf8mb4_unicode_ci NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_tl_conversion_decision_request (conversion_request_id),
  CONSTRAINT chk_tl_conversion_decision CHECK (decision_code IN ('APPROVE','REJECT')),
  CONSTRAINT fk_tl_conversion_decision_request FOREIGN KEY (conversion_request_id) REFERENCES temporary_loan_conversion_requests(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_tl_conversion_decided_by FOREIGN KEY (decided_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP PROCEDURE IF EXISTS p8dd_apply_conversion_schema;
DELIMITER //
CREATE PROCEDURE p8dd_apply_conversion_schema()
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_conversion_requests' AND COLUMN_NAME='original_custody_level') THEN
    ALTER TABLE temporary_loan_conversion_requests ADD COLUMN original_custody_level VARCHAR(16) COLLATE utf8mb4_unicode_ci NULL AFTER request_notes;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_conversion_requests' AND COLUMN_NAME='original_district_id') THEN
    ALTER TABLE temporary_loan_conversion_requests ADD COLUMN original_district_id INT UNSIGNED NULL AFTER original_custody_level;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_conversion_requests' AND COLUMN_NAME='original_school_id') THEN
    ALTER TABLE temporary_loan_conversion_requests ADD COLUMN original_school_id INT UNSIGNED NULL AFTER original_district_id;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_conversion_requests' AND COLUMN_NAME='original_student_id') THEN
    ALTER TABLE temporary_loan_conversion_requests ADD COLUMN original_student_id INT UNSIGNED NULL AFTER original_school_id;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_conversion_requests' AND COLUMN_NAME='original_district_allocation_id') THEN
    ALTER TABLE temporary_loan_conversion_requests ADD COLUMN original_district_allocation_id INT UNSIGNED NULL AFTER original_student_id;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_conversion_requests' AND COLUMN_NAME='original_school_allocation_id') THEN
    ALTER TABLE temporary_loan_conversion_requests ADD COLUMN original_school_allocation_id INT UNSIGNED NULL AFTER original_district_allocation_id;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_conversion_requests' AND COLUMN_NAME='original_student_assignment_id') THEN
    ALTER TABLE temporary_loan_conversion_requests ADD COLUMN original_student_assignment_id INT UNSIGNED NULL AFTER original_school_allocation_id;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND COLUMN_NAME='conversion_request_id') THEN
    ALTER TABLE temporary_loan_cases ADD COLUMN conversion_request_id BIGINT UNSIGNED NULL AFTER conversion_status;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND INDEX_NAME='idx_temporary_loan_conversion_request') THEN
    ALTER TABLE temporary_loan_cases ADD KEY idx_temporary_loan_conversion_request (conversion_request_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND CONSTRAINT_NAME='fk_temporary_loan_conversion_request') THEN
    ALTER TABLE temporary_loan_cases ADD CONSTRAINT fk_temporary_loan_conversion_request FOREIGN KEY (conversion_request_id) REFERENCES temporary_loan_conversion_requests(id) ON DELETE RESTRICT ON UPDATE RESTRICT;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='permanent_replacement_cases' AND COLUMN_NAME='temporary_loan_case_id') THEN
    ALTER TABLE permanent_replacement_cases ADD COLUMN temporary_loan_case_id INT UNSIGNED NULL AFTER exception_case_id;
  END IF;
  IF EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='permanent_replacement_cases' AND COLUMN_NAME='exception_case_id' AND IS_NULLABLE='NO') THEN
    ALTER TABLE permanent_replacement_cases DROP FOREIGN KEY fk_perm_repl_exception;
    ALTER TABLE permanent_replacement_cases MODIFY exception_case_id INT UNSIGNED NULL;
    ALTER TABLE permanent_replacement_cases ADD CONSTRAINT fk_perm_repl_exception FOREIGN KEY (exception_case_id) REFERENCES repair_exception_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='permanent_replacement_cases' AND INDEX_NAME='uq_perm_repl_temporary_loan') THEN
    ALTER TABLE permanent_replacement_cases ADD UNIQUE KEY uq_perm_repl_temporary_loan (temporary_loan_case_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='permanent_replacement_cases' AND CONSTRAINT_NAME='fk_perm_repl_temporary_loan') THEN
    ALTER TABLE permanent_replacement_cases ADD CONSTRAINT fk_perm_repl_temporary_loan FOREIGN KEY (temporary_loan_case_id) REFERENCES temporary_loan_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT;
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='device_replacements' AND COLUMN_NAME='approved_exception_case_id' AND IS_NULLABLE='NO') THEN
    ALTER TABLE device_replacements DROP FOREIGN KEY fk_device_repl_exception;
    ALTER TABLE device_replacements MODIFY approved_exception_case_id INT UNSIGNED NULL;
    ALTER TABLE device_replacements ADD CONSTRAINT fk_device_repl_exception FOREIGN KEY (approved_exception_case_id) REFERENCES repair_exception_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT;
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='permanent_replacement_cases' AND CONSTRAINT_NAME='chk_perm_repl_source_type' AND CONSTRAINT_TYPE='CHECK') THEN
    SET @p8dd_sql='ALTER TABLE permanent_replacement_cases DROP CHECK chk_perm_repl_source_type';
    PREPARE p8dd_stmt FROM @p8dd_sql; EXECUTE p8dd_stmt; DEALLOCATE PREPARE p8dd_stmt;
  END IF;
  ALTER TABLE permanent_replacement_cases ADD CONSTRAINT chk_perm_repl_source_type CHECK (replacement_source_type IS NULL OR replacement_source_type IN ('MANUFACTURER_SUPPLIED','EXISTING_INVENTORY','TEMPORARY_LOAN_CONVERSION'));

  INSERT IGNORE INTO temporary_loan_statuses (code,name,sort_order,is_terminal) VALUES
    ('CONVERSION_PENDING_HEAD_OFFICE','Conversion Pending Head Office',70,0),
    ('CONVERTED_PERMANENT','Converted to Permanent',80,1);
  IF EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND CONSTRAINT_NAME='chk_temporary_loan_active' AND CONSTRAINT_TYPE='CHECK') THEN
    SET @p8dd_sql='ALTER TABLE temporary_loan_cases DROP CHECK chk_temporary_loan_active';
    PREPARE p8dd_stmt FROM @p8dd_sql; EXECUTE p8dd_stmt; DEALLOCATE PREPARE p8dd_stmt;
  END IF;
  ALTER TABLE temporary_loan_cases ADD CONSTRAINT chk_temporary_loan_active CHECK (
    (current_status_code IN ('PENDING_DISTRICT_APPROVAL','AUTHORIZED','SPARE_SELECTED','ACTIVE_LOAN','RETURN_REQUIRED','CONVERSION_PENDING_HEAD_OFFICE') AND active_record_key=1 AND closed_at IS NULL)
    OR (current_status_code IN ('REJECTED','CANCELLED','RETURNED','CONVERTED_PERMANENT') AND active_record_key IS NULL AND closed_at IS NOT NULL));
  IF EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='temporary_loan_cases' AND CONSTRAINT_NAME='chk_temporary_loan_no_issue' AND CONSTRAINT_TYPE='CHECK') THEN
    SET @p8dd_sql='ALTER TABLE temporary_loan_cases DROP CHECK chk_temporary_loan_no_issue';
    PREPARE p8dd_stmt FROM @p8dd_sql; EXECUTE p8dd_stmt; DEALLOCATE PREPARE p8dd_stmt;
  END IF;
  ALTER TABLE temporary_loan_cases ADD CONSTRAINT chk_temporary_loan_no_issue CHECK (
    (current_status_code IN ('PENDING_DISTRICT_APPROVAL','AUTHORIZED','REJECTED','CANCELLED') AND selected_spare_device_id IS NULL AND selected_by IS NULL AND selected_at IS NULL AND issued_at IS NULL AND issued_by IS NULL AND return_requested_by IS NULL AND return_requested_at IS NULL AND return_reason_code IS NULL AND returned_by IS NULL AND returned_at IS NULL)
    OR (current_status_code='SPARE_SELECTED' AND selected_spare_device_id IS NOT NULL AND selected_by IS NOT NULL AND selected_at IS NOT NULL AND issued_at IS NULL AND issued_by IS NULL AND return_requested_by IS NULL AND return_requested_at IS NULL AND return_reason_code IS NULL AND returned_by IS NULL AND returned_at IS NULL)
    OR (current_status_code IN ('ACTIVE_LOAN','CONVERSION_PENDING_HEAD_OFFICE','CONVERTED_PERMANENT') AND selected_spare_device_id IS NOT NULL AND selected_by IS NOT NULL AND selected_at IS NOT NULL AND issued_at IS NOT NULL AND issued_by IS NOT NULL AND return_requested_by IS NULL AND return_requested_at IS NULL AND return_reason_code IS NULL AND returned_by IS NULL AND returned_at IS NULL)
    OR (current_status_code='RETURN_REQUIRED' AND selected_spare_device_id IS NOT NULL AND issued_at IS NOT NULL AND issued_by IS NOT NULL AND return_requested_by IS NOT NULL AND return_requested_at IS NOT NULL AND return_reason_code IS NOT NULL AND returned_by IS NULL AND returned_at IS NULL)
    OR (current_status_code='RETURNED' AND selected_spare_device_id IS NOT NULL AND issued_at IS NOT NULL AND issued_by IS NOT NULL AND return_requested_by IS NOT NULL AND return_requested_at IS NOT NULL AND return_reason_code IS NOT NULL AND return_condition_code='SERVICEABLE' AND returned_by IS NOT NULL AND returned_at IS NOT NULL));
END //
DELIMITER ;
CALL p8dd_apply_conversion_schema();
DROP PROCEDURE IF EXISTS p8dd_apply_conversion_schema;

INSERT IGNORE INTO permissions (name,label,module) VALUES
 ('temporary_loans.request_conversion','Request Permanent Conversion','temporary_loans'),
 ('temporary_loans.approve_conversion','Approve Temporary Loan Conversion','temporary_loans');
INSERT IGNORE INTO role_permissions (role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p
WHERE r.name IN ('SUPER_ADMIN','REPAIR_CENTRE') AND p.name='temporary_loans.request_conversion';
INSERT IGNORE INTO role_permissions (role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p
WHERE r.name IN ('SUPER_ADMIN','MOE_HEAD_OFFICE') AND p.name='temporary_loans.approve_conversion';

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_temporary_loan_queue AS
SELECT loan.id AS temporary_loan_case_id,loan.loan_number,loan.ticket_id,t.ticket_number,
  loan.original_device_id,original.serial_number AS original_serial_number,
  original.asset_tag AS original_asset_tag,loan.origin_district_id,district.name AS origin_district_name,
  loan.origin_school_id,school.name AS origin_school_name,loan.repair_job_id,
  loan.repair_service_location_id,centre.name AS repair_centre_name,loan.spare_pool_id,
  pool.pool_code,pool.name AS spare_pool_name,loan.current_status_code,status.name AS loan_status_name,
  loan.request_reason_code,loan.requested_by,loan.requested_at,loan.request_notes,lc.id AS logistics_case_id,
  loan.authorized_by,loan.authorized_at,loan.authorization_notes,loan.rejected_by,
  loan.rejected_at,loan.rejection_reason,loan.selected_spare_device_id,loan.selected_by,
  loan.selected_at,loan.issued_by,loan.issued_at,loan.return_requested_by,
  loan.return_requested_at,loan.return_reason_code,return_reason.name AS return_reason_name,
  loan.return_notes,loan.return_condition_code,loan.returned_by,loan.returned_at,
  loan.conversion_status,loan.conversion_request_id,loan.active_record_key,loan.created_at,
  loan.updated_at,loan.closed_at,ts.code AS ticket_status_code,ls.code AS logistics_status_code,
  rj.completed_at AS repair_completed_at,
  (SELECT m.current_status_code FROM manufacturer_return_cases m WHERE m.ticket_id=loan.ticket_id ORDER BY m.id DESC LIMIT 1) AS manufacturer_return_status_code,
  spare.serial_number AS selected_spare_serial_number,spare.asset_tag AS selected_spare_asset_tag,
  manufacturer.name AS selected_spare_manufacturer_name,model.model_name AS selected_spare_model_name,
  spare_lifecycle.code AS selected_spare_lifecycle_code,
  CASE WHEN spare.id IS NULL THEN NULL WHEN active_stock.id IS NULL THEN 'NOT_IN_FREE_STOCK' ELSE active_stock.stock_status END AS selected_spare_stock_status,
  active_stock.service_location_id AS selected_spare_stock_location_id,
  reservation.reservation_status AS spare_reservation_status,
  CASE WHEN reservation.active_record_key=1 THEN 1 ELSE 0 END AS spare_reservation_active,
  CASE WHEN loan.current_status_code='CONVERTED_PERMANENT' THEN 'WITH_RECIPIENT'
       ELSE latest_custody.to_custody_code END AS physical_custody_code,
  latest_custody.created_at AS custody_recorded_at,
  conversion.id AS latest_conversion_request_id,conversion.conversion_request_number,
  conversion.status_code AS conversion_request_status,conversion.reason_code AS conversion_reason_code,
  conversion_reason.name AS conversion_reason_name,conversion.request_notes AS conversion_request_notes,
  conversion.requested_by AS conversion_requested_by,requester.display_name AS conversion_requested_by_name,
  conversion.requested_at AS conversion_requested_at,decision.decision_code AS conversion_decision,
  decision.decided_by AS conversion_decided_by,decider.display_name AS conversion_decided_by_name,
  decision.decided_at AS conversion_decided_at,decision.decision_notes AS conversion_decision_notes,
  replacement_case.id AS permanent_replacement_case_id,replacement_case.replacement_number AS permanent_replacement_number,
  replacement_case.current_status_code AS permanent_replacement_status,
  original_lifecycle.code AS original_device_lifecycle_code
FROM temporary_loan_cases loan
JOIN tickets t ON t.id=loan.ticket_id
JOIN ticket_statuses ts ON ts.id=t.current_status_id
JOIN devices original ON original.id=loan.original_device_id
JOIN device_lifecycle_statuses original_lifecycle ON original_lifecycle.id=original.lifecycle_status_id
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
LEFT JOIN device_stock_locations active_stock ON active_stock.device_id=spare.id AND active_stock.active_record_key=1 AND active_stock.stock_status='IN_STOCK'
LEFT JOIN temporary_loan_spare_reservations reservation ON reservation.id=(SELECT MAX(r.id) FROM temporary_loan_spare_reservations r WHERE r.temporary_loan_case_id=loan.id)
LEFT JOIN temporary_loan_custody_history latest_custody ON latest_custody.id=(SELECT MAX(ch.id) FROM temporary_loan_custody_history ch WHERE ch.temporary_loan_case_id=loan.id)
LEFT JOIN temporary_loan_conversion_requests conversion ON conversion.id=(SELECT MAX(cr.id) FROM temporary_loan_conversion_requests cr WHERE cr.temporary_loan_case_id=loan.id)
LEFT JOIN temporary_loan_conversion_reasons conversion_reason ON conversion_reason.code=conversion.reason_code
LEFT JOIN users requester ON requester.id=conversion.requested_by
LEFT JOIN temporary_loan_conversion_decisions decision ON decision.conversion_request_id=conversion.id
LEFT JOIN users decider ON decider.id=decision.decided_by
LEFT JOIN permanent_replacement_cases replacement_case ON replacement_case.temporary_loan_case_id=loan.id;

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_permanent_replacement_queue AS
SELECT prc.id AS replacement_case_id,prc.replacement_number,prc.exception_case_id,
  prc.temporary_loan_case_id,loan.loan_number,conversion_request.conversion_request_number,
  prc.ticket_id,t.ticket_number,prc.logistics_case_id,
  tlc.logistics_number,ls.code AS logistics_status_code,ls.name AS logistics_status_name,
  prc.repair_job_id,prc.original_device_id,od.serial_number AS original_serial_number,
  od.asset_tag AS original_asset_tag,dm.model_name AS original_model_name,m.name AS original_manufacturer_name,
  prc.replacement_source_type,prc.staged_manufacturer_unit_id,msu.serial_number AS staged_serial_number,
  msu.model_description AS staged_model_description,prc.replacement_device_id,
  rd.serial_number AS replacement_serial_number,rd.asset_tag AS replacement_asset_tag,
  prc.repair_service_location_id,sl.name AS repair_centre_name,t.origin_school_id,
  s.name AS origin_school_name,t.origin_district_id,d.name AS origin_district_name,
  prc.current_status_code AS replacement_status_code,prs.name AS replacement_status_name,
  ec.current_status_code AS exception_status_code,tss.code AS ticket_status_code,
  tss.name AS ticket_status_name,lc.code AS original_device_lifecycle_code,
  lc.name AS original_device_lifecycle_name,vc.current_custody_level AS phase5_custody_level,
  vc.district_id AS phase5_district_id,vc.school_id AS phase5_school_id,vc.student_id AS phase5_student_id,
  prc.created_by,prc.created_at,prc.updated_by,prc.updated_at,prc.completed_by,prc.completed_at,
  prc.closed_at,prc.active_record_key
FROM permanent_replacement_cases prc
LEFT JOIN repair_exception_cases ec ON ec.id=prc.exception_case_id
LEFT JOIN temporary_loan_cases loan ON loan.id=prc.temporary_loan_case_id
LEFT JOIN temporary_loan_conversion_requests conversion_request ON conversion_request.id=loan.conversion_request_id
JOIN tickets t ON t.id=prc.ticket_id
JOIN ticket_logistics_cases tlc ON tlc.id=prc.logistics_case_id
JOIN logistics_statuses ls ON ls.id=tlc.current_status_id
JOIN ticket_statuses tss ON tss.id=t.current_status_id
JOIN devices od ON od.id=prc.original_device_id
JOIN device_lifecycle_statuses lc ON lc.id=od.lifecycle_status_id
JOIN device_models dm ON dm.id=od.device_model_id
JOIN manufacturers m ON m.id=dm.manufacturer_id
JOIN service_locations sl ON sl.id=prc.repair_service_location_id
JOIN permanent_replacement_statuses prs ON prs.code=prc.current_status_code
LEFT JOIN schools s ON s.id=t.origin_school_id
LEFT JOIN districts d ON d.id=t.origin_district_id
LEFT JOIN manufacturer_supplied_units msu ON msu.id=prc.staged_manufacturer_unit_id
LEFT JOIN devices rd ON rd.id=prc.replacement_device_id
LEFT JOIN v_device_current_custody vc ON vc.device_id=prc.original_device_id;

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_ticket_activity_08d_b AS
SELECT ticket_id,activity_at,activity_type,activity_code,related_record_id,actor_user_id,subject_user_id,from_status_id,to_status_id,reference_code,activity_sort_order
FROM v_ticket_activity_08d_a
UNION ALL
SELECT loan.ticket_id,history.created_at,'TEMPORARY_LOAN',
  CASE history.to_status_code
    WHEN 'SPARE_SELECTED' THEN 'TEMPORARY_SPARE_SELECTED'
    WHEN 'ACTIVE_LOAN' THEN 'TEMPORARY_LOAN_ISSUED'
    WHEN 'RETURN_REQUIRED' THEN 'TEMPORARY_LOAN_RETURN_REQUIRED'
    WHEN 'RETURNED' THEN 'TEMPORARY_LOAN_RETURNED'
    WHEN 'CONVERSION_PENDING_HEAD_OFFICE' THEN 'TEMPORARY_LOAN_CONVERSION_REQUESTED'
    WHEN 'CONVERTED_PERMANENT' THEN 'TEMPORARY_LOAN_CONVERTED_PERMANENT'
  END,
  history.id,history.actor_user_id,NULL,NULL,NULL,loan.loan_number,40
FROM temporary_loan_status_history history
JOIN temporary_loan_cases loan ON loan.id=history.temporary_loan_case_id
WHERE history.to_status_code IN ('SPARE_SELECTED','ACTIVE_LOAN','RETURN_REQUIRED','RETURNED','CONVERSION_PENDING_HEAD_OFFICE','CONVERTED_PERMANENT')
UNION ALL
SELECT loan.ticket_id,decision.decided_at,'TEMPORARY_LOAN','TEMPORARY_LOAN_CONVERSION_REJECTED',
  decision.id,decision.decided_by,NULL,NULL,NULL,loan.loan_number,41
FROM temporary_loan_conversion_decisions decision
JOIN temporary_loan_conversion_requests request ON request.id=decision.conversion_request_id
JOIN temporary_loan_cases loan ON loan.id=request.temporary_loan_case_id
WHERE decision.decision_code='REJECT';
