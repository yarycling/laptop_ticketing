-- Extend the shared ticket activity read model with the two-sided 7D handoff.
CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_ticket_activity AS
SELECT tsh.ticket_id, tsh.changed_at AS activity_at, 'STATUS_CHANGE' AS activity_type,
  CAST(tsh.to_status_id AS CHAR) AS activity_code, tsh.id AS related_record_id,
  tsh.changed_by_user_id AS actor_user_id, NULL AS subject_user_id,
  tsh.from_status_id, tsh.to_status_id, CAST(NULL AS CHAR(50)) AS reference_code
FROM ticket_status_history tsh
UNION ALL
SELECT td.ticket_id, td.diagnosed_at, 'DIAGNOSIS', 'DIAGNOSIS_RECORDED', td.id,
  td.diagnosed_by_user_id, NULL, NULL, NULL, CAST(NULL AS CHAR(50))
FROM ticket_diagnoses td
UNION ALL
SELECT tc.ticket_id, tc.created_at, tc.comment_type, tc.comment_type, tc.id,
  tc.created_by_user_id, NULL, NULL, NULL, CAST(NULL AS CHAR(50))
FROM ticket_comments tc
WHERE tc.comment_type IN ('CLARIFICATION_REQUEST', 'CLARIFICATION_RESPONSE')
UNION ALL
SELECT tda.ticket_id, tda.decided_at, 'DISTRICT_APPROVAL', tda.decision, tda.id,
  tda.decided_by_user_id, NULL, NULL, NULL, CAST(NULL AS CHAR(50))
FROM ticket_district_approvals tda
UNION ALL
SELECT ta.ticket_id, ta.assigned_at, 'ASSIGNMENT_STARTED', 'ASSIGNED', ta.id,
  ta.assigned_by_user_id, ta.assigned_to_user_id, NULL, NULL, CAST(NULL AS CHAR(50))
FROM ticket_assignments ta
UNION ALL
SELECT ta.ticket_id, ta.ended_at, 'ASSIGNMENT_ENDED', 'ENDED', ta.id,
  ta.ended_by_user_id, ta.assigned_to_user_id, NULL, NULL, CAST(NULL AS CHAR(50))
FROM ticket_assignments ta
WHERE ta.ended_at IS NOT NULL
UNION ALL
SELECT c.ticket_id, h.dispatched_at, 'LOGISTICS', 'SCHOOL_TTPOST_HANDOFF_DISPATCHED', h.id,
  h.dispatched_by_user_id, NULL, NULL, NULL, c.logistics_number
FROM logistics_handoffs h
INNER JOIN ticket_logistics_cases c ON c.id = h.logistics_case_id
WHERE h.handoff_type = 'SCHOOL_TO_TTPOST' AND h.dispatched_at IS NOT NULL
UNION ALL
SELECT c.ticket_id, h.received_at, 'LOGISTICS', 'TTPOST_DEVICE_RECEIVED', h.id,
  h.received_by_user_id, NULL, NULL, NULL, c.logistics_number
FROM logistics_handoffs h
INNER JOIN ticket_logistics_cases c ON c.id = h.logistics_case_id
WHERE h.handoff_type = 'SCHOOL_TO_TTPOST' AND h.received_at IS NOT NULL
UNION ALL
SELECT c.ticket_id, h.changed_at, 'LOGISTICS', 'OUTBOUND_TRANSIT_STARTED', h.id,
  h.changed_by_user_id, NULL, NULL, NULL, c.logistics_number
FROM logistics_status_history h
INNER JOIN ticket_logistics_cases c ON c.id = h.logistics_case_id
INNER JOIN logistics_statuses status_from ON status_from.id = h.from_status_id
INNER JOIN logistics_statuses status_to ON status_to.id = h.to_status_id
WHERE status_from.code = 'ACCEPTED' AND status_to.code = 'OUTBOUND_IN_TRANSIT'
UNION ALL
SELECT c.ticket_id, h.dispatched_at, 'LOGISTICS', 'REPAIR_HANDOFF_DISPATCHED', h.id,
  h.dispatched_by_user_id, NULL, NULL, NULL, c.logistics_number
FROM logistics_handoffs h
INNER JOIN ticket_logistics_cases c ON c.id = h.logistics_case_id
WHERE h.handoff_type = 'TTPOST_TO_REPAIR_CENTRE' AND h.dispatched_at IS NOT NULL
UNION ALL
SELECT c.ticket_id, h.received_at, 'LOGISTICS', 'REPAIR_CENTRE_DEVICE_RECEIVED', h.id,
  h.received_by_user_id, NULL, NULL, NULL, c.logistics_number
FROM logistics_handoffs h
INNER JOIN ticket_logistics_cases c ON c.id = h.logistics_case_id
WHERE h.handoff_type = 'TTPOST_TO_REPAIR_CENTRE' AND h.received_at IS NOT NULL
UNION ALL
SELECT c.ticket_id, h.changed_at, 'LOGISTICS', 'ARRIVED_AT_REPAIR_CENTRE', h.id,
  h.changed_by_user_id, NULL, NULL, NULL, c.logistics_number
FROM logistics_status_history h
INNER JOIN ticket_logistics_cases c ON c.id = h.logistics_case_id
INNER JOIN logistics_statuses status_from ON status_from.id = h.from_status_id
INNER JOIN logistics_statuses status_to ON status_to.id = h.to_status_id
WHERE status_from.code = 'OUTBOUND_IN_TRANSIT' AND status_to.code = 'AT_REPAIR_CENTRE';
