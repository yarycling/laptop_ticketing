-- Phase 7E repair processing foundation. Safe to apply repeatedly.
CREATE TABLE IF NOT EXISTS repair_outcomes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  code VARCHAR(50) NOT NULL,
  name VARCHAR(120) NOT NULL,
  description VARCHAR(500) NULL,
  is_return_ready TINYINT(1) NOT NULL DEFAULT 0,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  sort_order INT UNSIGNED NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_repair_outcomes_code (code),
  KEY idx_repair_outcomes_active_sort (is_active, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO repair_outcomes (code, name, description, is_return_ready, sort_order)
VALUES
  ('REPAIRED_SUCCESSFULLY', 'Repaired Successfully', 'Repair completed and ready for return logistics.', 1, 10),
  ('NO_FAULT_FOUND', 'No Fault Found', 'No fault was reproduced; device is ready for return logistics.', 1, 20),
  ('UNABLE_TO_REPAIR', 'Unable to Repair', 'Repair Centre could not complete the repair; downstream disposition is required.', 0, 30),
  ('MANUFACTURER_RETURN_REQUIRED', 'Manufacturer Return Required', 'Manufacturer disposition is required; workflow is deferred.', 0, 40),
  ('REPLACEMENT_REQUIRED', 'Replacement Required', 'Replacement disposition is required; workflow is deferred.', 0, 50)
ON DUPLICATE KEY UPDATE
  name = VALUES(name), description = VALUES(description),
  is_return_ready = VALUES(is_return_ready), is_active = 1, sort_order = VALUES(sort_order);

-- READY_FOR_RETURN changes operational state, not physical custody.
CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_logistics_physical_custody AS
SELECT
  c.id AS logistics_case_id,
  c.logistics_number,
  c.ticket_id,
  c.device_id,
  c.current_status_id AS logistics_status_id,
  ls.code AS logistics_status_code,
  t.current_status_id AS ticket_status_id,
  ts.code AS ticket_status_code,
  CASE
    WHEN ls.code = 'ACCEPTED' AND pending.handoff_type = 'SCHOOL_TO_TTPOST' THEN 'PENDING_TTPOST_RECEIPT'
    WHEN ls.code = 'ACCEPTED' THEN 'AWAITING_SCHOOL_HANDOFF'
    WHEN ls.code = 'OUTBOUND_IN_TRANSIT' AND pending_repair.id IS NOT NULL THEN 'PENDING_REPAIR_CENTRE_RECEIPT'
    WHEN ls.code = 'OUTBOUND_IN_TRANSIT' AND completed.handoff_type = 'SCHOOL_TO_TTPOST' THEN 'TTPOST_CUSTODY'
    WHEN ls.code IN ('AT_REPAIR_CENTRE', 'READY_FOR_RETURN') AND completed.handoff_type = 'TTPOST_TO_REPAIR_CENTRE' THEN 'REPAIR_CENTRE_CUSTODY'
    ELSE NULL
  END AS physical_state_code,
  CASE
    WHEN ls.code = 'OUTBOUND_IN_TRANSIT' AND completed.handoff_type = 'SCHOOL_TO_TTPOST' THEN completed.to_service_location_id
    WHEN ls.code IN ('AT_REPAIR_CENTRE', 'READY_FOR_RETURN') AND completed.handoff_type = 'TTPOST_TO_REPAIR_CENTRE' THEN completed.to_service_location_id
    ELSE NULL
  END AS current_service_location_id,
  CASE
    WHEN ls.code = 'OUTBOUND_IN_TRANSIT' AND completed.handoff_type = 'SCHOOL_TO_TTPOST' THEN completed_location.code
    WHEN ls.code IN ('AT_REPAIR_CENTRE', 'READY_FOR_RETURN') AND completed.handoff_type = 'TTPOST_TO_REPAIR_CENTRE' THEN completed_location.code
    ELSE NULL
  END AS current_service_location_code,
  CASE
    WHEN ls.code = 'OUTBOUND_IN_TRANSIT' AND completed.handoff_type = 'SCHOOL_TO_TTPOST' THEN completed_location.name
    WHEN ls.code IN ('AT_REPAIR_CENTRE', 'READY_FOR_RETURN') AND completed.handoff_type = 'TTPOST_TO_REPAIR_CENTRE' THEN completed_location.name
    ELSE NULL
  END AS current_service_location_name,
  pending.id AS pending_handoff_id,
  pending.handoff_type AS pending_handoff_type,
  pending.dispatched_at AS pending_since,
  pending.dispatched_by_user_id AS handoff_dispatched_by_user_id,
  completed.id AS last_completed_handoff_id,
  completed.handoff_type AS last_completed_handoff_type,
  completed.received_at AS last_handoff_received_at,
  completed.received_by_user_id AS handoff_received_by_user_id,
  CASE
    WHEN pending.handoff_type = 'SCHOOL_TO_TTPOST' THEN pending.to_service_location_id
    WHEN completed.handoff_type = 'SCHOOL_TO_TTPOST' THEN completed.to_service_location_id
    ELSE NULL
  END AS ttpost_location_id,
  CASE
    WHEN pending.handoff_type = 'SCHOOL_TO_TTPOST' THEN pending_location.code
    WHEN completed.handoff_type = 'SCHOOL_TO_TTPOST' THEN completed_location.code
    ELSE NULL
  END AS ttpost_location_code,
  CASE
    WHEN pending.handoff_type = 'SCHOOL_TO_TTPOST' THEN pending_location.name
    WHEN completed.handoff_type = 'SCHOOL_TO_TTPOST' THEN completed_location.name
    ELSE NULL
  END AS ttpost_location_name,
  COALESCE(pending_repair.to_service_location_id, c.repair_centre_location_id) AS repair_centre_location_id,
  repair_location.code AS repair_centre_location_code,
  repair_location.name AS repair_centre_location_name,
  pending_repair.id AS pending_repair_handoff_id,
  allocation.current_custody_level AS allocation_custody_level,
  allocation.district_id AS allocation_district_id,
  allocation.school_id AS allocation_school_id,
  allocation.student_id AS allocation_student_id
FROM ticket_logistics_cases c
INNER JOIN tickets t ON t.id = c.ticket_id
INNER JOIN logistics_statuses ls ON ls.id = c.current_status_id
INNER JOIN ticket_statuses ts ON ts.id = t.current_status_id
LEFT JOIN logistics_handoffs pending
  ON pending.logistics_case_id = c.id AND pending.active_record_key = 1
  AND pending.received_at IS NULL
  AND pending.handoff_type IN ('SCHOOL_TO_TTPOST', 'TTPOST_TO_REPAIR_CENTRE')
LEFT JOIN logistics_handoffs pending_repair
  ON pending_repair.logistics_case_id = c.id
  AND pending_repair.handoff_type = 'TTPOST_TO_REPAIR_CENTRE'
  AND pending_repair.active_record_key = 1 AND pending_repair.received_at IS NULL
LEFT JOIN (
  SELECT h.logistics_case_id, MAX(h.id) AS id
  FROM logistics_handoffs h
  WHERE h.handoff_type IN ('SCHOOL_TO_TTPOST', 'TTPOST_TO_REPAIR_CENTRE')
    AND h.received_at IS NOT NULL GROUP BY h.logistics_case_id
) completed_id ON completed_id.logistics_case_id = c.id
LEFT JOIN logistics_handoffs completed ON completed.id = completed_id.id
LEFT JOIN service_locations pending_location ON pending_location.id = pending.to_service_location_id
LEFT JOIN service_locations completed_location ON completed_location.id = completed.to_service_location_id
LEFT JOIN service_locations repair_location ON repair_location.id = COALESCE(pending_repair.to_service_location_id, c.repair_centre_location_id)
LEFT JOIN v_device_current_custody allocation ON allocation.device_id = c.device_id
WHERE c.active_record_key = 1 AND c.closed_at IS NULL;

CREATE TABLE IF NOT EXISTS repair_jobs (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  logistics_case_id INT UNSIGNED NOT NULL,
  repair_centre_location_id INT UNSIGNED NOT NULL,
  started_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  started_by_user_id INT UNSIGNED NOT NULL,
  completed_at DATETIME(6) NULL,
  completed_by_user_id INT UNSIGNED NULL,
  outcome_id INT UNSIGNED NULL,
  completion_summary VARCHAR(2000) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_repair_jobs_logistics_case (logistics_case_id),
  KEY idx_repair_jobs_location_started (repair_centre_location_id, started_at),
  KEY idx_repair_jobs_outcome (outcome_id),
  CONSTRAINT fk_repair_jobs_logistics_case FOREIGN KEY (logistics_case_id) REFERENCES ticket_logistics_cases(id),
  CONSTRAINT fk_repair_jobs_location FOREIGN KEY (repair_centre_location_id) REFERENCES service_locations(id),
  CONSTRAINT fk_repair_jobs_started_by FOREIGN KEY (started_by_user_id) REFERENCES users(id),
  CONSTRAINT fk_repair_jobs_completed_by FOREIGN KEY (completed_by_user_id) REFERENCES users(id),
  CONSTRAINT fk_repair_jobs_outcome FOREIGN KEY (outcome_id) REFERENCES repair_outcomes(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS repair_assessments (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  repair_job_id INT UNSIGNED NOT NULL,
  assessment_summary VARCHAR(2000) NOT NULL,
  suspected_cause VARCHAR(1000) NULL,
  recommended_action VARCHAR(1000) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  created_by_user_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  KEY idx_repair_assessments_job_created (repair_job_id, created_at, id),
  CONSTRAINT fk_repair_assessments_job FOREIGN KEY (repair_job_id) REFERENCES repair_jobs(id),
  CONSTRAINT fk_repair_assessments_actor FOREIGN KEY (created_by_user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS repair_work_logs (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  repair_job_id INT UNSIGNED NOT NULL,
  action_summary VARCHAR(2000) NOT NULL,
  result_summary VARCHAR(1000) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  created_by_user_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  KEY idx_repair_work_logs_job_created (repair_job_id, created_at, id),
  CONSTRAINT fk_repair_work_logs_job FOREIGN KEY (repair_job_id) REFERENCES repair_jobs(id),
  CONSTRAINT fk_repair_work_logs_actor FOREIGN KEY (created_by_user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_repair_current_context AS
SELECT
  p.logistics_case_id,
  p.logistics_number,
  p.ticket_id,
  t.ticket_number,
  p.device_id,
  d.serial_number,
  d.asset_tag,
  p.repair_centre_location_id,
  p.repair_centre_location_code AS repair_centre_code,
  p.repair_centre_location_name AS repair_centre_name,
  p.repair_centre_location_code,
  p.repair_centre_location_name,
  p.physical_state_code,
  p.logistics_status_code,
  p.ticket_status_code,
  p.allocation_custody_level,
  p.allocation_district_id,
  p.allocation_school_id,
  p.allocation_student_id,
  ls.code AS device_lifecycle_code,
  j.id AS repair_job_id,
  j.started_at,
  j.started_by_user_id,
  started_by.display_name AS started_by_display_name,
  j.completed_at,
  j.completed_by_user_id,
  completed_by.display_name AS completed_by_display_name,
  o.id AS outcome_id,
  o.code AS outcome_code,
  o.name AS outcome_name,
  o.is_return_ready AS outcome_is_return_ready,
  o.is_return_ready,
  (SELECT COUNT(*) FROM repair_assessments ra WHERE ra.repair_job_id = j.id) AS assessment_count,
  (SELECT COUNT(*) FROM repair_work_logs rw WHERE rw.repair_job_id = j.id) AS work_log_count,
  CASE
    WHEN j.id IS NULL THEN 'AWAITING_REPAIR_START'
    WHEN j.completed_at IS NULL THEN 'IN_PROGRESS'
    WHEN o.is_return_ready = 1 THEN 'READY_FOR_RETURN'
    ELSE 'DISPOSITION_RECORDED'
  END AS repair_state_code,
  CASE
    WHEN j.id IS NULL THEN 'AWAITING_REPAIR_START'
    WHEN j.completed_at IS NULL THEN 'IN_PROGRESS'
    WHEN o.is_return_ready = 1 THEN 'READY_FOR_RETURN'
    ELSE 'DISPOSITION_RECORDED'
  END AS repair_state
FROM v_logistics_physical_custody p
INNER JOIN tickets t ON t.id = p.ticket_id
INNER JOIN devices d ON d.id = p.device_id
INNER JOIN device_lifecycle_statuses ls ON ls.id = d.lifecycle_status_id
LEFT JOIN repair_jobs j ON j.logistics_case_id = p.logistics_case_id
LEFT JOIN repair_outcomes o ON o.id = j.outcome_id
LEFT JOIN users started_by ON started_by.id = j.started_by_user_id
LEFT JOIN users completed_by ON completed_by.id = j.completed_by_user_id
WHERE p.physical_state_code = 'REPAIR_CENTRE_CUSTODY';
