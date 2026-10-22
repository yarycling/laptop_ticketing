-- Add Phase 7B logistics request events to the existing cross-domain ticket
-- activity read model. Logistics statuses remain separate from ticket status.
-- Safe to re-run: the view is replaced in place and no data is written.
CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_ticket_activity AS
SELECT
  tsh.ticket_id,
  tsh.changed_at AS activity_at,
  'STATUS_CHANGE' AS activity_type,
  CAST(tsh.to_status_id AS CHAR) AS activity_code,
  tsh.id AS related_record_id,
  tsh.changed_by_user_id AS actor_user_id,
  NULL AS subject_user_id,
  tsh.from_status_id,
  tsh.to_status_id,
  CAST(NULL AS CHAR(50)) AS reference_code
FROM ticket_status_history tsh
UNION ALL
SELECT
  td.ticket_id,
  td.diagnosed_at AS activity_at,
  'DIAGNOSIS' AS activity_type,
  'DIAGNOSIS_RECORDED' AS activity_code,
  td.id AS related_record_id,
  td.diagnosed_by_user_id AS actor_user_id,
  NULL AS subject_user_id,
  NULL AS from_status_id,
  NULL AS to_status_id,
  CAST(NULL AS CHAR(50)) AS reference_code
FROM ticket_diagnoses td
UNION ALL
SELECT
  tc.ticket_id,
  tc.created_at AS activity_at,
  tc.comment_type AS activity_type,
  tc.comment_type AS activity_code,
  tc.id AS related_record_id,
  tc.created_by_user_id AS actor_user_id,
  NULL AS subject_user_id,
  NULL AS from_status_id,
  NULL AS to_status_id,
  CAST(NULL AS CHAR(50)) AS reference_code
FROM ticket_comments tc
WHERE tc.comment_type IN ('CLARIFICATION_REQUEST', 'CLARIFICATION_RESPONSE')
UNION ALL
SELECT
  tda.ticket_id,
  tda.decided_at AS activity_at,
  'DISTRICT_APPROVAL' AS activity_type,
  tda.decision AS activity_code,
  tda.id AS related_record_id,
  tda.decided_by_user_id AS actor_user_id,
  NULL AS subject_user_id,
  NULL AS from_status_id,
  NULL AS to_status_id,
  CAST(NULL AS CHAR(50)) AS reference_code
FROM ticket_district_approvals tda
UNION ALL
SELECT
  ta.ticket_id,
  ta.assigned_at AS activity_at,
  'ASSIGNMENT_STARTED' AS activity_type,
  'ASSIGNED' AS activity_code,
  ta.id AS related_record_id,
  ta.assigned_by_user_id AS actor_user_id,
  ta.assigned_to_user_id AS subject_user_id,
  NULL AS from_status_id,
  NULL AS to_status_id,
  CAST(NULL AS CHAR(50)) AS reference_code
FROM ticket_assignments ta
UNION ALL
SELECT
  ta.ticket_id,
  ta.ended_at AS activity_at,
  'ASSIGNMENT_ENDED' AS activity_type,
  'ENDED' AS activity_code,
  ta.id AS related_record_id,
  ta.ended_by_user_id AS actor_user_id,
  ta.assigned_to_user_id AS subject_user_id,
  NULL AS from_status_id,
  NULL AS to_status_id,
  CAST(NULL AS CHAR(50)) AS reference_code
FROM ticket_assignments ta
WHERE ta.ended_at IS NOT NULL
UNION ALL
SELECT
  c.ticket_id,
  h.changed_at AS activity_at,
  'LOGISTICS' AS activity_type,
  CASE
    WHEN h.from_status_id IS NULL AND status_to.code = 'REQUESTED' THEN 'PICKUP_REQUESTED'
    WHEN status_from.code = 'REQUESTED' AND status_to.code = 'ACCEPTED' THEN 'PICKUP_REQUEST_ACCEPTED'
  END AS activity_code,
  h.id AS related_record_id,
  h.changed_by_user_id AS actor_user_id,
  NULL AS subject_user_id,
  NULL AS from_status_id,
  NULL AS to_status_id,
  c.logistics_number AS reference_code
FROM logistics_status_history h
INNER JOIN ticket_logistics_cases c ON c.id = h.logistics_case_id
LEFT JOIN logistics_statuses status_from ON status_from.id = h.from_status_id
INNER JOIN logistics_statuses status_to ON status_to.id = h.to_status_id
WHERE (h.from_status_id IS NULL AND status_to.code = 'REQUESTED')
   OR (status_from.code = 'REQUESTED' AND status_to.code = 'ACCEPTED');
