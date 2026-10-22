-- Phase 8C-B replacement source selection. Safe to re-run.
-- Existing inventory selection remains blocked until an authoritative Repair
-- Centre stock-location model exists.

DROP PROCEDURE IF EXISTS p8cb_apply_replacement_source_selection;
DELIMITER //
CREATE PROCEDURE p8cb_apply_replacement_source_selection()
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'permanent_replacement_cases'
      AND COLUMN_NAME = 'selected_by'
  ) THEN
    ALTER TABLE permanent_replacement_cases
      ADD COLUMN selected_by INT UNSIGNED NULL AFTER replacement_device_id;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'permanent_replacement_cases'
      AND COLUMN_NAME = 'selected_at'
  ) THEN
    ALTER TABLE permanent_replacement_cases
      ADD COLUMN selected_at DATETIME(6) NULL AFTER selected_by;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'permanent_replacement_cases'
      AND COLUMN_NAME = 'active_selection_key'
  ) THEN
    ALTER TABLE permanent_replacement_cases
      ADD COLUMN active_selection_key VARCHAR(80) COLLATE utf8mb4_unicode_ci NULL AFTER active_record_key;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'permanent_replacement_cases'
      AND INDEX_NAME = 'idx_perm_repl_selected_by'
  ) THEN
    ALTER TABLE permanent_replacement_cases
      ADD KEY idx_perm_repl_selected_by (selected_by);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'permanent_replacement_cases'
      AND INDEX_NAME = 'uq_perm_repl_active_selection'
  ) THEN
    ALTER TABLE permanent_replacement_cases
      ADD UNIQUE KEY uq_perm_repl_active_selection (active_selection_key);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'permanent_replacement_cases'
      AND CONSTRAINT_NAME = 'fk_perm_repl_selected_by'
  ) THEN
    ALTER TABLE permanent_replacement_cases
      ADD CONSTRAINT fk_perm_repl_selected_by
        FOREIGN KEY (selected_by) REFERENCES users(id)
        ON DELETE RESTRICT ON UPDATE RESTRICT;
  END IF;
END //
DELIMITER ;

CALL p8cb_apply_replacement_source_selection();
DROP PROCEDURE IF EXISTS p8cb_apply_replacement_source_selection;
