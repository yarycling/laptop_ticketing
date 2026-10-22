-- Physical custody is deliberately separate from Phase 5 allocation custody.
-- Safe to re-run: this replaces only the Phase 7C logistics read model.
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
    WHEN ls.code = 'ACCEPTED' AND pending.id IS NOT NULL THEN 'PENDING_TTPOST_RECEIPT'
    WHEN ls.code = 'ACCEPTED' THEN 'AWAITING_SCHOOL_HANDOFF'
    WHEN ls.code = 'OUTBOUND_IN_TRANSIT' AND completed.id IS NOT NULL THEN 'TTPOST_CUSTODY'
    ELSE NULL
  END AS physical_state_code,
  CASE WHEN ls.code = 'OUTBOUND_IN_TRANSIT' AND completed.id IS NOT NULL THEN completed.to_service_location_id ELSE NULL END AS current_service_location_id,
  CASE WHEN ls.code = 'OUTBOUND_IN_TRANSIT' AND completed.id IS NOT NULL THEN completed_location.code ELSE NULL END AS current_service_location_code,
  CASE WHEN ls.code = 'OUTBOUND_IN_TRANSIT' AND completed.id IS NOT NULL THEN completed_location.name ELSE NULL END AS current_service_location_name,
  pending.id AS pending_handoff_id,
  pending.handoff_type AS pending_handoff_type,
  COALESCE(pending.dispatched_at, completed.dispatched_at) AS pending_since,
  COALESCE(pending.dispatched_by_user_id, completed.dispatched_by_user_id) AS handoff_dispatched_by_user_id,
  completed.id AS last_completed_handoff_id,
  completed.handoff_type AS last_completed_handoff_type,
  completed.received_at AS last_handoff_received_at,
  completed.received_by_user_id AS handoff_received_by_user_id,
  COALESCE(pending.to_service_location_id, completed.to_service_location_id) AS ttpost_location_id,
  COALESCE(pending_location.code, completed_location.code) AS ttpost_location_code,
  COALESCE(pending_location.name, completed_location.name) AS ttpost_location_name,
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
  AND pending.handoff_type = 'SCHOOL_TO_TTPOST'
  AND pending.active_record_key = 1
  AND pending.received_at IS NULL
LEFT JOIN (
  SELECT h.logistics_case_id, MAX(h.id) AS id
  FROM logistics_handoffs h
  WHERE h.handoff_type = 'SCHOOL_TO_TTPOST'
    AND h.received_at IS NOT NULL
  GROUP BY h.logistics_case_id
) completed_id ON completed_id.logistics_case_id = c.id
LEFT JOIN logistics_handoffs completed ON completed.id = completed_id.id
LEFT JOIN service_locations pending_location ON pending_location.id = pending.to_service_location_id
LEFT JOIN service_locations completed_location ON completed_location.id = completed.to_service_location_id
LEFT JOIN v_device_current_custody allocation ON allocation.device_id = c.device_id
WHERE c.active_record_key = 1
  AND c.closed_at IS NULL;
