-- Phase 6E reporting read models. No operational tables or workflow writes.
-- Terminal tickets missing closed_at use NOW() for ticket age; no timestamp is
-- synthesized into closed_at. Durations with inconsistent chronology are NULL.
CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_ticket_operational_metrics AS
SELECT
  t.id AS ticket_id,
  t.ticket_number,
  t.device_id,
  t.origin_district_id,
  t.origin_school_id,
  t.origin_student_id,
  t.requester_type,
  t.current_status_id,
  ts.code AS current_status_code,
  ts.name AS current_status_name,
  ts.is_terminal,
  t.submitted_at,
  t.closed_at,
  ctx.active_assignment_id,
  ctx.assigned_to_user_id,
  active_assignment.assigned_at,
  status_times.latest_status_at,
  diagnosis_times.first_diagnosed_at,
  diagnosis_times.latest_diagnosed_at,
  approval_times.first_approved_at,
  CASE
    WHEN TIMESTAMPDIFF(MINUTE, t.submitted_at,
      CASE WHEN ts.is_terminal = 1 AND t.closed_at IS NOT NULL THEN t.closed_at ELSE NOW() END) >= 0
    THEN TIMESTAMPDIFF(MINUTE, t.submitted_at,
      CASE WHEN ts.is_terminal = 1 AND t.closed_at IS NOT NULL THEN t.closed_at ELSE NOW() END)
    ELSE NULL
  END AS ticket_age_minutes,
  CASE
    WHEN ts.is_terminal = 1 THEN NULL
    WHEN TIMESTAMPDIFF(MINUTE, t.submitted_at, NOW()) < 0 THEN NULL
    WHEN TIMESTAMPDIFF(MINUTE, t.submitted_at, NOW()) < 1440 THEN 'LESS_THAN_24_HOURS'
    WHEN TIMESTAMPDIFF(MINUTE, t.submitted_at, NOW()) < 4320 THEN 'ONE_TO_THREE_DAYS'
    WHEN TIMESTAMPDIFF(MINUTE, t.submitted_at, NOW()) < 10080 THEN 'FOUR_TO_SEVEN_DAYS'
    ELSE 'MORE_THAN_SEVEN_DAYS'
  END AS ticket_age_bucket,
  CASE
    WHEN status_times.latest_status_at IS NOT NULL
      AND TIMESTAMPDIFF(MINUTE, status_times.latest_status_at, NOW()) >= 0
    THEN TIMESTAMPDIFF(MINUTE, status_times.latest_status_at, NOW())
    ELSE NULL
  END AS current_status_age_minutes,
  CASE
    WHEN active_assignment.assigned_at IS NOT NULL
      AND TIMESTAMPDIFF(MINUTE, active_assignment.assigned_at, NOW()) >= 0
    THEN TIMESTAMPDIFF(MINUTE, active_assignment.assigned_at, NOW())
    ELSE NULL
  END AS assignment_age_minutes,
  CASE
    WHEN diagnosis_times.first_diagnosed_at IS NOT NULL
      AND TIMESTAMPDIFF(MINUTE, t.submitted_at, diagnosis_times.first_diagnosed_at) >= 0
    THEN TIMESTAMPDIFF(MINUTE, t.submitted_at, diagnosis_times.first_diagnosed_at)
    ELSE NULL
  END AS time_to_first_diagnosis_minutes,
  CASE
    WHEN approval_times.first_approved_at IS NOT NULL
      AND TIMESTAMPDIFF(MINUTE, t.submitted_at, approval_times.first_approved_at) >= 0
    THEN TIMESTAMPDIFF(MINUTE, t.submitted_at, approval_times.first_approved_at)
    ELSE NULL
  END AS time_to_approval_minutes
FROM tickets t
INNER JOIN ticket_statuses ts ON ts.id = t.current_status_id
INNER JOIN v_ticket_current_context ctx ON ctx.ticket_id = t.id
LEFT JOIN ticket_assignments active_assignment
  ON active_assignment.id = ctx.active_assignment_id
  AND active_assignment.active_record_key = 1
LEFT JOIN (
  SELECT ticket_id, MAX(changed_at) AS latest_status_at
  FROM ticket_status_history
  GROUP BY ticket_id
) status_times ON status_times.ticket_id = t.id
LEFT JOIN (
  SELECT ticket_id, MIN(diagnosed_at) AS first_diagnosed_at, MAX(diagnosed_at) AS latest_diagnosed_at
  FROM ticket_diagnoses
  GROUP BY ticket_id
) diagnosis_times ON diagnosis_times.ticket_id = t.id
LEFT JOIN (
  SELECT ticket_id, MIN(decided_at) AS first_approved_at
  FROM ticket_district_approvals
  WHERE decision = 'APPROVED'
  GROUP BY ticket_id
) approval_times ON approval_times.ticket_id = t.id;

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
  tsh.to_status_id
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
  NULL AS to_status_id
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
  NULL AS to_status_id
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
  NULL AS to_status_id
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
  NULL AS to_status_id
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
  NULL AS to_status_id
FROM ticket_assignments ta
WHERE ta.ended_at IS NOT NULL;
