-- Active operational custody only. Closed return cases remain in their
-- handoff/history records and are displayed by detail/activity read models.
CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_logistics_physical_custody AS
SELECT
  c.id AS logistics_case_id, c.logistics_number, c.ticket_id,
  effective.original_device_id, effective.effective_device_id AS device_id,
  effective.device_source, effective.replacement_case_id, effective.replacement_number,
  effective.temporary_loan_case_id,
  c.current_status_id AS logistics_status_id, ls.code AS logistics_status_code,
  t.current_status_id AS ticket_status_id, ts.code AS ticket_status_code,
  CASE
    WHEN ls.code = 'FULFILLED_AT_RECIPIENT' AND effective.device_source = 'TEMPORARY_LOAN_CONVERSION' THEN 'WITH_RECIPIENT'
    WHEN ls.code = 'ACCEPTED' AND pending.handoff_type = 'SCHOOL_TO_TTPOST' THEN 'PENDING_TTPOST_RECEIPT'
    WHEN ls.code = 'ACCEPTED' THEN 'AWAITING_SCHOOL_HANDOFF'
    WHEN ls.code = 'OUTBOUND_IN_TRANSIT' AND pending.handoff_type = 'TTPOST_TO_REPAIR_CENTRE' THEN 'PENDING_REPAIR_CENTRE_RECEIPT'
    WHEN ls.code = 'OUTBOUND_IN_TRANSIT' AND completed.handoff_type = 'SCHOOL_TO_TTPOST' THEN 'TTPOST_CUSTODY'
    WHEN ls.code IN ('AT_REPAIR_CENTRE', 'READY_FOR_RETURN') AND pending.handoff_type = 'REPAIR_CENTRE_TO_TTPOST' THEN 'PENDING_TTPOST_RETURN_RECEIPT'
    WHEN ls.code IN ('AT_REPAIR_CENTRE', 'READY_FOR_RETURN') AND completed.handoff_type = 'TTPOST_TO_REPAIR_CENTRE' THEN 'REPAIR_CENTRE_CUSTODY'
    WHEN ls.code = 'RETURN_IN_TRANSIT' AND pending.handoff_type = 'TTPOST_TO_SCHOOL' THEN 'PENDING_SCHOOL_RETURN_RECEIPT'
    WHEN ls.code = 'RETURN_IN_TRANSIT' AND completed.handoff_type = 'REPAIR_CENTRE_TO_TTPOST' THEN 'TTPOST_RETURN_CUSTODY'
    ELSE NULL
  END AS physical_state_code,
  CASE
    WHEN ls.code = 'OUTBOUND_IN_TRANSIT' AND completed.handoff_type = 'SCHOOL_TO_TTPOST' THEN completed.to_service_location_id
    WHEN ls.code IN ('AT_REPAIR_CENTRE', 'READY_FOR_RETURN') AND completed.handoff_type = 'TTPOST_TO_REPAIR_CENTRE' THEN completed.to_service_location_id
    WHEN ls.code = 'RETURN_IN_TRANSIT' AND completed.handoff_type = 'REPAIR_CENTRE_TO_TTPOST' THEN completed.to_service_location_id
    ELSE NULL
  END AS current_service_location_id,
  CASE
    WHEN ls.code = 'OUTBOUND_IN_TRANSIT' AND completed.handoff_type = 'SCHOOL_TO_TTPOST' THEN completed_location.code
    WHEN ls.code IN ('AT_REPAIR_CENTRE', 'READY_FOR_RETURN') AND completed.handoff_type = 'TTPOST_TO_REPAIR_CENTRE' THEN completed_location.code
    WHEN ls.code = 'RETURN_IN_TRANSIT' AND completed.handoff_type = 'REPAIR_CENTRE_TO_TTPOST' THEN completed_location.code
    ELSE NULL
  END AS current_service_location_code,
  CASE
    WHEN ls.code = 'OUTBOUND_IN_TRANSIT' AND completed.handoff_type = 'SCHOOL_TO_TTPOST' THEN completed_location.name
    WHEN ls.code IN ('AT_REPAIR_CENTRE', 'READY_FOR_RETURN') AND completed.handoff_type = 'TTPOST_TO_REPAIR_CENTRE' THEN completed_location.name
    WHEN ls.code = 'RETURN_IN_TRANSIT' AND completed.handoff_type = 'REPAIR_CENTRE_TO_TTPOST' THEN completed_location.name
    ELSE NULL
  END AS current_service_location_name,
  pending.id AS pending_handoff_id, pending.handoff_type AS pending_handoff_type,
  pending.device_id AS pending_handoff_device_id,
  pending.dispatched_at AS pending_since, pending.dispatched_by_user_id AS handoff_dispatched_by_user_id,
  completed.id AS last_completed_handoff_id, completed.handoff_type AS last_completed_handoff_type,
  completed.device_id AS last_completed_handoff_device_id,
  completed.received_at AS last_handoff_received_at, completed.received_by_user_id AS handoff_received_by_user_id,
  CASE
    WHEN pending.handoff_type = 'SCHOOL_TO_TTPOST' THEN pending.to_service_location_id
    WHEN completed.handoff_type = 'SCHOOL_TO_TTPOST' THEN completed.to_service_location_id
    WHEN ls.code = 'RETURN_IN_TRANSIT' AND pending.handoff_type = 'TTPOST_TO_SCHOOL' THEN pending.from_service_location_id
    WHEN ls.code = 'RETURN_IN_TRANSIT' AND completed.handoff_type = 'REPAIR_CENTRE_TO_TTPOST' THEN completed.to_service_location_id
    ELSE NULL
  END AS ttpost_location_id,
  CASE
    WHEN pending.handoff_type = 'SCHOOL_TO_TTPOST' THEN pending_location.code
    WHEN completed.handoff_type = 'SCHOOL_TO_TTPOST' THEN completed_location.code
    WHEN ls.code = 'RETURN_IN_TRANSIT' AND pending.handoff_type = 'TTPOST_TO_SCHOOL' THEN pending_from_location.code
    WHEN ls.code = 'RETURN_IN_TRANSIT' AND completed.handoff_type = 'REPAIR_CENTRE_TO_TTPOST' THEN completed_location.code
    ELSE NULL
  END AS ttpost_location_code,
  CASE
    WHEN pending.handoff_type = 'SCHOOL_TO_TTPOST' THEN pending_location.name
    WHEN completed.handoff_type = 'SCHOOL_TO_TTPOST' THEN completed_location.name
    WHEN ls.code = 'RETURN_IN_TRANSIT' AND pending.handoff_type = 'TTPOST_TO_SCHOOL' THEN pending_from_location.name
    WHEN ls.code = 'RETURN_IN_TRANSIT' AND completed.handoff_type = 'REPAIR_CENTRE_TO_TTPOST' THEN completed_location.name
    ELSE NULL
  END AS ttpost_location_name,
  COALESCE(pending_repair.to_service_location_id, c.repair_centre_location_id) AS repair_centre_location_id,
  repair_location.code AS repair_centre_location_code, repair_location.name AS repair_centre_location_name,
  pending_repair.id AS pending_repair_handoff_id,
  allocation.current_custody_level AS allocation_custody_level,
  allocation.district_id AS allocation_district_id,
  allocation.school_id AS allocation_school_id,
  allocation_school.name AS allocation_school_name,
  allocation.student_id AS allocation_student_id,
  lifecycle.code AS device_lifecycle_code
FROM ticket_logistics_cases c
JOIN tickets t ON t.id = c.ticket_id
JOIN logistics_statuses ls ON ls.id = c.current_status_id
JOIN ticket_statuses ts ON ts.id = t.current_status_id
JOIN v_ticket_effective_device effective ON effective.logistics_case_id = c.id
JOIN devices d ON d.id = effective.effective_device_id
JOIN device_lifecycle_statuses lifecycle ON lifecycle.id = d.lifecycle_status_id
LEFT JOIN logistics_handoffs pending ON pending.logistics_case_id = c.id
  AND pending.active_record_key = 1 AND pending.received_at IS NULL
LEFT JOIN logistics_handoffs pending_repair ON pending_repair.logistics_case_id = c.id
  AND pending_repair.handoff_type = 'TTPOST_TO_REPAIR_CENTRE'
  AND pending_repair.active_record_key = 1 AND pending_repair.received_at IS NULL
LEFT JOIN (
  SELECT h.logistics_case_id, MAX(h.id) AS id
  FROM logistics_handoffs h WHERE h.received_at IS NOT NULL GROUP BY h.logistics_case_id
) completed_id ON completed_id.logistics_case_id = c.id
LEFT JOIN logistics_handoffs completed ON completed.id = completed_id.id
LEFT JOIN service_locations pending_location ON pending_location.id = pending.to_service_location_id
LEFT JOIN service_locations pending_from_location ON pending_from_location.id = pending.from_service_location_id
LEFT JOIN service_locations completed_location ON completed_location.id = completed.to_service_location_id
LEFT JOIN service_locations repair_location ON repair_location.id = COALESCE(pending_repair.to_service_location_id, c.repair_centre_location_id)
LEFT JOIN v_device_current_custody allocation ON allocation.device_id = effective.effective_device_id
LEFT JOIN schools allocation_school ON allocation_school.id = allocation.school_id
WHERE c.active_record_key = 1 AND (c.closed_at IS NULL
  OR (ls.code = 'FULFILLED_AT_RECIPIENT' AND effective.device_source = 'TEMPORARY_LOAN_CONVERSION'));

-- Historical-capable detail source. This does not alter active queue semantics.
CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_logistics_case_detail_context AS
SELECT c.id AS logistics_case_id, c.logistics_number, c.ticket_id, t.ticket_number,
  effective.effective_device_id AS device_id, effective.original_device_id,
  effective.device_source, effective.replacement_case_id, effective.replacement_number,
  effective.temporary_loan_case_id,
  d.serial_number, d.asset_tag, original.serial_number AS original_serial_number,
  original.asset_tag AS original_asset_tag, c.pickup_school_id,
  s.name AS pickup_school_name, s.district_id AS pickup_district_id,
  district.name AS pickup_district_name, c.repair_centre_location_id,
  repair_location.name AS repair_centre_name, c.current_status_id AS current_logistics_status_id,
  ls.code AS current_logistics_status_code, ls.name AS current_logistics_status_name,
  c.requested_at, c.closed_at, c.active_record_key,
  (c.active_record_key = 1 AND c.closed_at IS NULL) AS is_active,
  CASE WHEN ls.code = 'RETURNED_TO_SCHOOL' THEN 'RETURNED_TO_SCHOOL' ELSE NULL END AS returned_physical_state_code,
  t.current_status_id AS ticket_current_status_id, ts.code AS ticket_current_status_code,
  allocation.current_custody_level AS allocation_custody_level,
  allocation.district_id AS allocation_district_id,
  allocation.school_id AS allocation_school_id,
  allocation_school.name AS allocation_school_name,
  allocation.student_id AS allocation_student_id,
  lifecycle.code AS device_lifecycle_code, lifecycle.name AS device_lifecycle_name
FROM ticket_logistics_cases c
JOIN tickets t ON t.id = c.ticket_id
JOIN v_ticket_effective_device effective ON effective.logistics_case_id = c.id
JOIN devices d ON d.id = effective.effective_device_id
JOIN devices original ON original.id = effective.original_device_id
JOIN device_lifecycle_statuses lifecycle ON lifecycle.id = d.lifecycle_status_id
JOIN schools s ON s.id = c.pickup_school_id
JOIN districts district ON district.id = s.district_id
JOIN logistics_statuses ls ON ls.id = c.current_status_id
JOIN ticket_statuses ts ON ts.id = t.current_status_id
LEFT JOIN service_locations repair_location ON repair_location.id = c.repair_centre_location_id
LEFT JOIN v_device_current_custody allocation ON allocation.device_id = effective.effective_device_id
LEFT JOIN schools allocation_school ON allocation_school.id = allocation.school_id;
