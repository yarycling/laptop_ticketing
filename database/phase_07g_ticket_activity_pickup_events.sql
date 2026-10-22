-- Restore the Phase 7B pickup-request activity rows omitted by later view
-- replacements. Re-running this migration safely replaces the read-only view.
CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_ticket_activity AS
SELECT tsh.ticket_id, tsh.changed_at AS activity_at, 'STATUS_CHANGE' AS activity_type,
  CAST(tsh.to_status_id AS CHAR) AS activity_code, tsh.id AS related_record_id,
  tsh.changed_by_user_id AS actor_user_id, NULL AS subject_user_id,
  tsh.from_status_id, tsh.to_status_id, CAST(NULL AS CHAR(50)) AS reference_code,
  CASE WHEN st.code = 'RETURNED' THEN 10 ELSE 40 END AS activity_sort_order
FROM ticket_status_history tsh
LEFT JOIN ticket_statuses st ON st.id = tsh.to_status_id
UNION ALL
SELECT c.ticket_id, h.changed_at, 'LOGISTICS', 'PICKUP_REQUESTED', h.id,
  h.changed_by_user_id, NULL, NULL, NULL, c.logistics_number, 40
FROM logistics_status_history h
JOIN ticket_logistics_cases c ON c.id = h.logistics_case_id
JOIN logistics_statuses status_to ON status_to.id = h.to_status_id
WHERE h.from_status_id IS NULL AND status_to.code = 'REQUESTED'
UNION ALL
SELECT c.ticket_id, h.changed_at, 'LOGISTICS', 'PICKUP_REQUEST_ACCEPTED', h.id,
  h.changed_by_user_id, NULL, NULL, NULL, c.logistics_number, 40
FROM logistics_status_history h
JOIN ticket_logistics_cases c ON c.id = h.logistics_case_id
JOIN logistics_statuses status_from ON status_from.id = h.from_status_id
JOIN logistics_statuses status_to ON status_to.id = h.to_status_id
WHERE status_from.code = 'REQUESTED' AND status_to.code = 'ACCEPTED'
UNION ALL
SELECT td.ticket_id, td.diagnosed_at, 'DIAGNOSIS', 'DIAGNOSIS_RECORDED', td.id,
  td.diagnosed_by_user_id, NULL, NULL, NULL, CAST(NULL AS CHAR(50)), 40
FROM ticket_diagnoses td
UNION ALL
SELECT tc.ticket_id, tc.created_at, tc.comment_type, tc.comment_type, tc.id,
  tc.created_by_user_id, NULL, NULL, NULL, CAST(NULL AS CHAR(50)), 40
FROM ticket_comments tc WHERE tc.comment_type IN ('CLARIFICATION_REQUEST', 'CLARIFICATION_RESPONSE')
UNION ALL
SELECT tda.ticket_id, tda.decided_at, 'DISTRICT_APPROVAL', tda.decision, tda.id,
  tda.decided_by_user_id, NULL, NULL, NULL, CAST(NULL AS CHAR(50)), 40
FROM ticket_district_approvals tda
UNION ALL
SELECT ta.ticket_id, ta.assigned_at, 'ASSIGNMENT_STARTED', 'ASSIGNED', ta.id,
  ta.assigned_by_user_id, ta.assigned_to_user_id, NULL, NULL, CAST(NULL AS CHAR(50)), 40
FROM ticket_assignments ta
UNION ALL
SELECT ta.ticket_id, ta.ended_at, 'ASSIGNMENT_ENDED', 'ENDED', ta.id,
  ta.ended_by_user_id, ta.assigned_to_user_id, NULL, NULL, CAST(NULL AS CHAR(50)), 40
FROM ticket_assignments ta WHERE ta.ended_at IS NOT NULL
UNION ALL
SELECT c.ticket_id, h.dispatched_at, 'LOGISTICS', 'SCHOOL_TTPOST_HANDOFF_DISPATCHED', h.id,
  h.dispatched_by_user_id, NULL, NULL, NULL, c.logistics_number, 40
FROM logistics_handoffs h JOIN ticket_logistics_cases c ON c.id = h.logistics_case_id
WHERE h.handoff_type = 'SCHOOL_TO_TTPOST' AND h.dispatched_at IS NOT NULL
UNION ALL
SELECT c.ticket_id, h.received_at, 'LOGISTICS', 'TTPOST_DEVICE_RECEIVED', h.id,
  h.received_by_user_id, NULL, NULL, NULL, c.logistics_number, 40
FROM logistics_handoffs h JOIN ticket_logistics_cases c ON c.id = h.logistics_case_id
WHERE h.handoff_type = 'SCHOOL_TO_TTPOST' AND h.received_at IS NOT NULL
UNION ALL
SELECT c.ticket_id, sh.changed_at, 'LOGISTICS', 'OUTBOUND_TRANSIT_STARTED', sh.id,
  sh.changed_by_user_id, NULL, NULL, NULL, c.logistics_number, 40
FROM logistics_status_history sh JOIN ticket_logistics_cases c ON c.id = sh.logistics_case_id
JOIN logistics_statuses sf ON sf.id = sh.from_status_id JOIN logistics_statuses st ON st.id = sh.to_status_id
WHERE sf.code = 'ACCEPTED' AND st.code = 'OUTBOUND_IN_TRANSIT'
UNION ALL
SELECT c.ticket_id, h.dispatched_at, 'LOGISTICS', 'REPAIR_HANDOFF_DISPATCHED', h.id,
  h.dispatched_by_user_id, NULL, NULL, NULL, c.logistics_number, 40
FROM logistics_handoffs h JOIN ticket_logistics_cases c ON c.id = h.logistics_case_id
WHERE h.handoff_type = 'TTPOST_TO_REPAIR_CENTRE' AND h.dispatched_at IS NOT NULL
UNION ALL
SELECT c.ticket_id, h.received_at, 'LOGISTICS', 'REPAIR_CENTRE_DEVICE_RECEIVED', h.id,
  h.received_by_user_id, NULL, NULL, NULL, c.logistics_number, 40
FROM logistics_handoffs h JOIN ticket_logistics_cases c ON c.id = h.logistics_case_id
WHERE h.handoff_type = 'TTPOST_TO_REPAIR_CENTRE' AND h.received_at IS NOT NULL
UNION ALL
SELECT c.ticket_id, sh.changed_at, 'LOGISTICS', 'ARRIVED_AT_REPAIR_CENTRE', sh.id,
  sh.changed_by_user_id, NULL, NULL, NULL, c.logistics_number, 40
FROM logistics_status_history sh JOIN ticket_logistics_cases c ON c.id = sh.logistics_case_id
JOIN logistics_statuses sf ON sf.id = sh.from_status_id JOIN logistics_statuses st ON st.id = sh.to_status_id
WHERE sf.code = 'OUTBOUND_IN_TRANSIT' AND st.code = 'AT_REPAIR_CENTRE'
UNION ALL
SELECT c.ticket_id, j.started_at, 'REPAIR', 'REPAIR_STARTED', j.id,
  j.started_by_user_id, NULL, NULL, NULL, c.logistics_number, 40
FROM repair_jobs j JOIN ticket_logistics_cases c ON c.id = j.logistics_case_id
UNION ALL
SELECT c.ticket_id, a.created_at, 'REPAIR', 'REPAIR_ASSESSMENT_RECORDED', a.id,
  a.created_by_user_id, NULL, NULL, NULL, c.logistics_number, 40
FROM repair_assessments a JOIN repair_jobs j ON j.id = a.repair_job_id
JOIN ticket_logistics_cases c ON c.id = j.logistics_case_id
UNION ALL
SELECT c.ticket_id, w.created_at, 'REPAIR', 'REPAIR_WORK_RECORDED', w.id,
  w.created_by_user_id, NULL, NULL, NULL, c.logistics_number, 40
FROM repair_work_logs w JOIN repair_jobs j ON j.id = w.repair_job_id
JOIN ticket_logistics_cases c ON c.id = j.logistics_case_id
UNION ALL
SELECT c.ticket_id, j.completed_at, 'REPAIR',
  CASE WHEN o.is_return_ready = 1 THEN 'REPAIR_COMPLETED' ELSE 'REPAIR_DISPOSITION_RECORDED' END,
  j.id, j.completed_by_user_id, NULL, NULL, NULL, c.logistics_number, 40
FROM repair_jobs j JOIN repair_outcomes o ON o.id = j.outcome_id
JOIN ticket_logistics_cases c ON c.id = j.logistics_case_id WHERE j.completed_at IS NOT NULL
UNION ALL
SELECT c.ticket_id, sh.changed_at, 'LOGISTICS', 'READY_FOR_RETURN', sh.id,
  sh.changed_by_user_id, NULL, NULL, NULL, c.logistics_number, 40
FROM logistics_status_history sh JOIN ticket_logistics_cases c ON c.id = sh.logistics_case_id
JOIN logistics_statuses sf ON sf.id = sh.from_status_id JOIN logistics_statuses st ON st.id = sh.to_status_id
WHERE sf.code = 'AT_REPAIR_CENTRE' AND st.code = 'READY_FOR_RETURN'
UNION ALL
SELECT c.ticket_id, h.dispatched_at, 'LOGISTICS', 'RETURN_HANDOFF_DISPATCHED', h.id,
  h.dispatched_by_user_id, NULL, NULL, NULL, c.logistics_number, 40
FROM logistics_handoffs h JOIN ticket_logistics_cases c ON c.id = h.logistics_case_id
WHERE h.handoff_type = 'REPAIR_CENTRE_TO_TTPOST' AND h.dispatched_at IS NOT NULL
UNION ALL
SELECT c.ticket_id, h.received_at, 'LOGISTICS', 'RETURN_TTPOST_DEVICE_RECEIVED', h.id,
  h.received_by_user_id, NULL, NULL, NULL, c.logistics_number, 20
FROM logistics_handoffs h JOIN ticket_logistics_cases c ON c.id = h.logistics_case_id
WHERE h.handoff_type = 'REPAIR_CENTRE_TO_TTPOST' AND h.received_at IS NOT NULL
UNION ALL
SELECT c.ticket_id, sh.changed_at, 'LOGISTICS', 'RETURN_TRANSIT_STARTED', sh.id,
  sh.changed_by_user_id, NULL, NULL, NULL, c.logistics_number, 10
FROM logistics_status_history sh JOIN ticket_logistics_cases c ON c.id = sh.logistics_case_id
JOIN logistics_statuses sf ON sf.id = sh.from_status_id JOIN logistics_statuses st ON st.id = sh.to_status_id
WHERE sf.code = 'READY_FOR_RETURN' AND st.code = 'RETURN_IN_TRANSIT'
UNION ALL
SELECT c.ticket_id, h.dispatched_at, 'LOGISTICS', 'SCHOOL_RETURN_HANDOFF_DISPATCHED', h.id,
  h.dispatched_by_user_id, NULL, NULL, NULL, c.logistics_number, 40
FROM logistics_handoffs h JOIN ticket_logistics_cases c ON c.id = h.logistics_case_id
WHERE h.handoff_type = 'TTPOST_TO_SCHOOL' AND h.dispatched_at IS NOT NULL
UNION ALL
SELECT c.ticket_id, h.received_at, 'LOGISTICS', 'SCHOOL_RETURN_DEVICE_RECEIVED', h.id,
  h.received_by_user_id, NULL, NULL, NULL, c.logistics_number, 30
FROM logistics_handoffs h JOIN ticket_logistics_cases c ON c.id = h.logistics_case_id
WHERE h.handoff_type = 'TTPOST_TO_SCHOOL' AND h.received_at IS NOT NULL
UNION ALL
SELECT c.ticket_id, sh.changed_at, 'LOGISTICS', 'RETURNED_TO_SCHOOL', sh.id,
  sh.changed_by_user_id, NULL, NULL, NULL, c.logistics_number, 20
FROM logistics_status_history sh JOIN ticket_logistics_cases c ON c.id = sh.logistics_case_id
JOIN logistics_statuses sf ON sf.id = sh.from_status_id JOIN logistics_statuses st ON st.id = sh.to_status_id
WHERE sf.code = 'RETURN_IN_TRANSIT' AND st.code = 'RETURNED_TO_SCHOOL';
