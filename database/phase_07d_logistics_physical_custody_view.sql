-- Extend the established physical custody read model without changing the
-- separate Phase 5 allocation context.
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
    WHEN ls.code = 'AT_REPAIR_CENTRE' AND completed.handoff_type = 'TTPOST_TO_REPAIR_CENTRE' THEN 'REPAIR_CENTRE_CUSTODY'
    ELSE NULL
  END AS physical_state_code,
  CASE
    WHEN ls.code = 'OUTBOUND_IN_TRANSIT' AND completed.handoff_type = 'SCHOOL_TO_TTPOST' THEN completed.to_service_location_id
    WHEN ls.code = 'AT_REPAIR_CENTRE' AND completed.handoff_type = 'TTPOST_TO_REPAIR_CENTRE' THEN completed.to_service_location_id
    ELSE NULL
  END AS current_service_location_id,
  CASE
    WHEN ls.code = 'OUTBOUND_IN_TRANSIT' AND completed.handoff_type = 'SCHOOL_TO_TTPOST' THEN completed_location.code
    WHEN ls.code = 'AT_REPAIR_CENTRE' AND completed.handoff_type = 'TTPOST_TO_REPAIR_CENTRE' THEN completed_location.code
    ELSE NULL
  END AS current_service_location_code,
  CASE
    WHEN ls.code = 'OUTBOUND_IN_TRANSIT' AND completed.handoff_type = 'SCHOOL_TO_TTPOST' THEN completed_location.name
    WHEN ls.code = 'AT_REPAIR_CENTRE' AND completed.handoff_type = 'TTPOST_TO_REPAIR_CENTRE' THEN completed_location.name
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
  ON pending.logistics_case_id = c.id
  AND pending.active_record_key = 1
  AND pending.received_at IS NULL
  AND pending.handoff_type IN ('SCHOOL_TO_TTPOST', 'TTPOST_TO_REPAIR_CENTRE')
LEFT JOIN logistics_handoffs pending_repair
  ON pending_repair.logistics_case_id = c.id
  AND pending_repair.handoff_type = 'TTPOST_TO_REPAIR_CENTRE'
  AND pending_repair.active_record_key = 1
  AND pending_repair.received_at IS NULL
LEFT JOIN (
  SELECT h.logistics_case_id, MAX(h.id) AS id
  FROM logistics_handoffs h
  WHERE h.handoff_type IN ('SCHOOL_TO_TTPOST', 'TTPOST_TO_REPAIR_CENTRE')
    AND h.received_at IS NOT NULL
  GROUP BY h.logistics_case_id
) completed_id ON completed_id.logistics_case_id = c.id
LEFT JOIN logistics_handoffs completed ON completed.id = completed_id.id
LEFT JOIN service_locations pending_location ON pending_location.id = pending.to_service_location_id
LEFT JOIN service_locations completed_location ON completed_location.id = completed.to_service_location_id
LEFT JOIN service_locations repair_location ON repair_location.id = COALESCE(pending_repair.to_service_location_id, c.repair_centre_location_id)
LEFT JOIN v_device_current_custody allocation ON allocation.device_id = c.device_id
WHERE c.active_record_key = 1
  AND c.closed_at IS NULL;
