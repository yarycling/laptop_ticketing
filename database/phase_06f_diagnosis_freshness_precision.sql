-- Preserve event ordering when a diagnosis and clarification response occur
-- within the same second. New records use the database's microsecond clock.
ALTER TABLE ticket_status_history
  MODIFY changed_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6);

ALTER TABLE ticket_diagnoses
  MODIFY diagnosed_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6);
