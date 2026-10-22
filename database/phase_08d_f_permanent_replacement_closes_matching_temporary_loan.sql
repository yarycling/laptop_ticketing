-- Phase 8D-F: allow an accepted permanent replacement to complete the
-- matching selected temporary spare without inventing a temporary issue event.
-- Repeatable MySQL schema migration.

DROP PROCEDURE IF EXISTS p8df_apply_temporary_loan_completion_schema;
DELIMITER //
CREATE PROCEDURE p8df_apply_temporary_loan_completion_schema()
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_SCHEMA=DATABASE()
      AND TABLE_NAME='temporary_loan_cases'
      AND CONSTRAINT_NAME='chk_temporary_loan_no_issue'
      AND CONSTRAINT_TYPE='CHECK'
  ) THEN
    SET @p8df_sql='ALTER TABLE temporary_loan_cases DROP CHECK chk_temporary_loan_no_issue';
    PREPARE p8df_stmt FROM @p8df_sql;
    EXECUTE p8df_stmt;
    DEALLOCATE PREPARE p8df_stmt;
  END IF;

  ALTER TABLE temporary_loan_cases ADD CONSTRAINT chk_temporary_loan_no_issue CHECK (
    (current_status_code IN ('PENDING_DISTRICT_APPROVAL','AUTHORIZED','REJECTED','CANCELLED')
      AND selected_spare_device_id IS NULL AND selected_by IS NULL AND selected_at IS NULL
      AND issued_at IS NULL AND issued_by IS NULL AND return_requested_by IS NULL
      AND return_requested_at IS NULL AND return_reason_code IS NULL
      AND returned_by IS NULL AND returned_at IS NULL)
    OR (current_status_code='SPARE_SELECTED' AND selected_spare_device_id IS NOT NULL
      AND selected_by IS NOT NULL AND selected_at IS NOT NULL AND issued_at IS NULL
      AND issued_by IS NULL AND return_requested_by IS NULL AND return_requested_at IS NULL
      AND return_reason_code IS NULL AND returned_by IS NULL AND returned_at IS NULL)
    OR (current_status_code IN ('ACTIVE_LOAN','CONVERSION_PENDING_HEAD_OFFICE')
      AND selected_spare_device_id IS NOT NULL AND selected_by IS NOT NULL
      AND selected_at IS NOT NULL AND issued_at IS NOT NULL AND issued_by IS NOT NULL
      AND return_requested_by IS NULL AND return_requested_at IS NULL
      AND return_reason_code IS NULL AND returned_by IS NULL AND returned_at IS NULL)
    OR (current_status_code='CONVERTED_PERMANENT' AND selected_spare_device_id IS NOT NULL
      AND selected_by IS NOT NULL AND selected_at IS NOT NULL
      AND ((issued_at IS NULL AND issued_by IS NULL)
        OR (issued_at IS NOT NULL AND issued_by IS NOT NULL))
      AND return_requested_by IS NULL AND return_requested_at IS NULL
      AND return_reason_code IS NULL AND returned_by IS NULL AND returned_at IS NULL)
    OR (current_status_code='RETURN_REQUIRED' AND selected_spare_device_id IS NOT NULL
      AND issued_at IS NOT NULL AND issued_by IS NOT NULL
      AND return_requested_by IS NOT NULL AND return_requested_at IS NOT NULL
      AND return_reason_code IS NOT NULL AND returned_by IS NULL AND returned_at IS NULL)
    OR (current_status_code='RETURNED' AND selected_spare_device_id IS NOT NULL
      AND issued_at IS NOT NULL AND issued_by IS NOT NULL
      AND return_requested_by IS NOT NULL AND return_requested_at IS NOT NULL
      AND return_reason_code IS NOT NULL AND return_condition_code='SERVICEABLE'
      AND returned_by IS NOT NULL AND returned_at IS NOT NULL)
  );
END //
DELIMITER ;

CALL p8df_apply_temporary_loan_completion_schema();
DROP PROCEDURE IF EXISTS p8df_apply_temporary_loan_completion_schema;
