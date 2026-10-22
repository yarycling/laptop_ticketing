-- Phase 9C generic SLA evaluation read model (MySQL 5.7).
-- Requires populated MySQL named-timezone tables for every active SLA calendar.
-- due_at is a calendar-local wall-clock DATETIME; evaluation flags are computed
-- here against the same calendar's current local datetime.

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_sla_evaluation_queue AS
SELECT evaluated.*,
  DATE(evaluated.due_at) AS due_business_date,
  DATE(evaluated.evaluation_business_datetime) AS evaluation_business_date,
  CASE
    WHEN evaluated.evaluation_business_datetime IS NOT NULL
      AND evaluated.evaluation_business_datetime > evaluated.due_at THEN 1
    ELSE 0
  END AS is_breached,
  CASE
    WHEN evaluated.evaluation_business_datetime IS NOT NULL
      AND evaluated.current_state_code = 'ACTIVE'
      AND DATE(evaluated.evaluation_business_datetime) = DATE(evaluated.due_at)
      AND evaluated.evaluation_business_datetime <= evaluated.due_at THEN 1
    ELSE 0
  END AS is_at_risk,
  CASE
    WHEN evaluated.evaluation_business_datetime IS NULL THEN 1
    ELSE 0
  END AS timezone_resolution_error
FROM (
  SELECT i.id, i.policy_code_snapshot, i.current_state_code, i.due_at,
    i.at_risk_at, i.source_entity_type, i.source_entity_id,
    i.calendar_id, c.timezone_name,
    CONVERT_TZ(UTC_TIMESTAMP(6), '+00:00', c.timezone_name)
      AS evaluation_business_datetime
  FROM sla_instances i
  JOIN sla_calendars c ON c.id = i.calendar_id
) evaluated;
