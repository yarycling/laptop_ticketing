-- Phase 9C completion classification context (MySQL 5.7).
-- SLA due_at and completed_at are calendar-local wall-clock DATETIME values.
-- Fail closed in sla_complete when this conversion cannot resolve.

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_sla_completion_context AS
SELECT i.id,
  i.idempotency_key,
  i.current_state_code,
    DATE_FORMAT(i.due_at, '%Y-%m-%d %H:%i:%s.%f') AS due_at,
  i.policy_code_snapshot,
  i.calendar_id,
  c.timezone_name,
    DATE_FORMAT(
      CONVERT_TZ(UTC_TIMESTAMP(6), '+00:00', c.timezone_name),
      '%Y-%m-%d %H:%i:%s.%f'
    ) AS completion_business_datetime,
  CASE
    WHEN CONVERT_TZ(UTC_TIMESTAMP(6), '+00:00', c.timezone_name) IS NULL THEN 1
    ELSE 0
  END AS timezone_resolution_error
FROM sla_instances i
JOIN sla_calendars c ON c.id = i.calendar_id;
