-- Phase 8C-D: apply before reapplying the Phase 7F custody views.
-- The column migration is repeatable; pre-8C-D handoffs remain historical NULL.
SET @has_handoff_device := (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'logistics_handoffs'
    AND COLUMN_NAME = 'device_id'
);
SET @handoff_device_ddl := IF(@has_handoff_device = 0,
  'ALTER TABLE logistics_handoffs ADD COLUMN device_id INT UNSIGNED NULL, ADD KEY idx_logistics_handoff_device (device_id), ADD CONSTRAINT fk_logistics_handoff_device FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE RESTRICT ON UPDATE RESTRICT',
  'SELECT 1');
PREPARE handoff_device_stmt FROM @handoff_device_ddl;
EXECUTE handoff_device_stmt;
DEALLOCATE PREPARE handoff_device_stmt;

-- The ticket keeps its original device; only the operational return identity changes.
-- A completed case without a replacement device is deliberately surfaced as NULL.
CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_ticket_effective_device AS
SELECT lc.ticket_id, lc.id AS logistics_case_id,
  lc.device_id AS original_device_id,
  CASE WHEN prc.id IS NULL THEN lc.device_id ELSE prc.replacement_device_id END AS effective_device_id,
  CASE WHEN prc.replacement_source_type = 'TEMPORARY_LOAN_CONVERSION' THEN 'TEMPORARY_LOAN_CONVERSION'
       WHEN prc.id IS NULL THEN 'ORIGINAL_DEVICE' ELSE 'PERMANENT_REPLACEMENT' END AS device_source,
  prc.id AS replacement_case_id, prc.replacement_number,
  prc.temporary_loan_case_id,
  prc.completed_at AS replacement_completed_at,
  prc.exception_case_id, ec.current_status_code AS exception_status_code,
  prc.replacement_source_type
FROM ticket_logistics_cases lc
LEFT JOIN permanent_replacement_cases prc ON prc.id = (
  SELECT p.id FROM permanent_replacement_cases p
  WHERE p.logistics_case_id = lc.id AND p.current_status_code = 'COMPLETED'
  ORDER BY p.completed_at DESC, p.id DESC LIMIT 1
)
LEFT JOIN repair_exception_cases ec ON ec.id = prc.exception_case_id;

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_logistics_return_device AS
SELECT e.logistics_case_id, e.original_device_id,
  e.effective_device_id AS return_device_id,
  e.replacement_case_id AS completed_replacement_case_id,
  CASE WHEN e.replacement_case_id IS NOT NULL THEN
    COALESCE(pc.physical_state_code,
      CASE WHEN ls.code = 'RETURNED_TO_SCHOOL' THEN 'RETURNED_TO_SCHOOL' ELSE 'REPAIR_CENTRE_RETURN_RECEIVED' END)
    ELSE NULL END AS replacement_physical_custody_code,
  CASE
    WHEN e.replacement_case_id IS NOT NULL AND mpc.physical_custody_code = 'MANUFACTURER_RETAINED_PENDING_REPLACEMENT' THEN 'MANUFACTURER_RETAINED_REPLACED'
    WHEN e.replacement_case_id IS NOT NULL THEN 'REPAIR_CENTRE_REPLACED_PENDING_DISPOSITION'
    ELSE NULL
  END AS original_replacement_physical_custody_code
FROM v_ticket_effective_device e
JOIN ticket_logistics_cases lc ON lc.id = e.logistics_case_id
JOIN logistics_statuses ls ON ls.id = lc.current_status_id
LEFT JOIN v_logistics_physical_custody pc ON pc.logistics_case_id = e.logistics_case_id
LEFT JOIN manufacturer_return_cases mrc ON mrc.id = (
  SELECT MAX(m.id) FROM manufacturer_return_cases m
  WHERE m.exception_case_id = e.exception_case_id
    AND e.replacement_source_type = 'MANUFACTURER_SUPPLIED'
)
LEFT JOIN v_manufacturer_return_physical_custody mpc ON mpc.manufacturer_return_case_id = mrc.id;

-- Existing Phase 7 logistics queue, with effective identity for the return leg.
CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_logistics_current_context AS
SELECT lc.id AS logistics_case_id, lc.logistics_number,
  t.id AS ticket_id, t.ticket_number,
  d.id AS device_id, d.serial_number, d.asset_tag,
  effective.original_device_id, effective.device_source,
  effective.replacement_case_id, effective.replacement_number,
  effective.temporary_loan_case_id,
  lc.pickup_school_id, pickup_school.name AS pickup_school_name,
  pickup_school.district_id AS pickup_district_id,
  pickup_district.name AS pickup_district_name,
  lc.repair_centre_location_id, repair_location.name AS repair_centre_name,
  lc.current_status_id AS current_logistics_status_id,
  logistics_status.code AS current_logistics_status_code,
  logistics_status.name AS current_logistics_status_name,
  lc.requested_at, lc.closed_at, lc.active_record_key,
  (lc.active_record_key = 1 AND lc.closed_at IS NULL) AS is_active,
  pending_handoff.id AS pending_handoff_id,
  pending_handoff.handoff_type AS pending_handoff_type,
  pending_handoff.dispatched_at AS pending_handoff_dispatched_at,
  t.current_status_id AS ticket_current_status_id,
  ticket_status.code AS ticket_current_status_code,
  allocation.current_custody_level AS allocation_custody_level,
  allocation.district_id AS allocation_district_id,
  allocation.school_id AS allocation_school_id,
  allocation.student_id AS allocation_student_id
FROM ticket_logistics_cases lc
INNER JOIN tickets t ON t.id = lc.ticket_id
INNER JOIN v_ticket_effective_device effective ON effective.logistics_case_id = lc.id
INNER JOIN devices d ON d.id = effective.effective_device_id
INNER JOIN schools pickup_school ON pickup_school.id = lc.pickup_school_id
INNER JOIN districts pickup_district ON pickup_district.id = pickup_school.district_id
LEFT JOIN service_locations repair_location ON repair_location.id = lc.repair_centre_location_id
INNER JOIN logistics_statuses logistics_status ON logistics_status.id = lc.current_status_id
INNER JOIN ticket_statuses ticket_status ON ticket_status.id = t.current_status_id
LEFT JOIN logistics_handoffs pending_handoff
  ON pending_handoff.logistics_case_id = lc.id AND pending_handoff.active_record_key = 1
LEFT JOIN v_device_current_custody allocation ON allocation.device_id = effective.effective_device_id;
