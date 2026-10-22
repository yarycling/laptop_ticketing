-- Phase 9C SLA completion classification acceptance (MySQL 5.7, SELECT-only).
-- due_at and completed_at are calendar-local wall-clock DATETIME values.

-- 1. COMPLETED_WITHIN_SLA must have a completion at/before due_at and no prior breach.
SELECT 'within_sla_classification_anomalies' AS check_name, COUNT(*) AS anomalies
FROM sla_instances i
WHERE i.current_state_code = 'COMPLETED_WITHIN_SLA'
  AND (i.completed_at IS NULL OR i.completed_at > i.due_at
    OR EXISTS (
      SELECT 1 FROM sla_instance_events e
      WHERE e.sla_instance_id = i.id
        AND e.event_code = 'BREACHED'
        AND e.event_at <= i.completed_at
    ));

-- 2. COMPLETED_OUTSIDE_SLA must be overdue at completion or have a prior breach.
SELECT 'outside_sla_classification_anomalies' AS check_name, COUNT(*) AS anomalies
FROM sla_instances i
WHERE i.current_state_code = 'COMPLETED_OUTSIDE_SLA'
  AND (i.completed_at IS NULL
    OR (i.completed_at <= i.due_at AND NOT EXISTS (
      SELECT 1 FROM sla_instance_events e
      WHERE e.sla_instance_id = i.id
        AND e.event_code = 'BREACHED'
        AND e.event_at <= i.completed_at
    )));

-- 3. Explicit BREACHED-to-WITHIN invariant.
SELECT 'breached_completed_within_anomalies' AS check_name, COUNT(*) AS anomalies
FROM sla_instances i
WHERE i.current_state_code = 'COMPLETED_WITHIN_SLA'
  AND EXISTS (
    SELECT 1 FROM sla_instance_events e
    WHERE e.sla_instance_id = i.id
      AND e.event_code = 'BREACHED'
      AND e.event_at <= i.completed_at
  );

-- 4. Every calendar referenced by an SLA must resolve its configured IANA zone.
SELECT 'invalid_sla_calendar_timezone_count' AS check_name, COUNT(*) AS anomalies
FROM sla_instances i
JOIN sla_calendars c ON c.id = i.calendar_id
WHERE CONVERT_TZ(UTC_TIMESTAMP(6), '+00:00', c.timezone_name) IS NULL;

-- 5. Duplicate completion events.
SELECT 'duplicate_sla_completion_event_groups' AS check_name, COUNT(*) AS anomalies
FROM (
  SELECT sla_instance_id
  FROM sla_instance_events
  WHERE event_code = 'COMPLETED'
  GROUP BY sla_instance_id
  HAVING COUNT(*) > 1
) duplicates;

-- 6. Duplicate escalation resolution events.
SELECT 'duplicate_escalation_resolution_event_groups' AS check_name, COUNT(*) AS anomalies
FROM (
  SELECT escalation_case_id
  FROM escalation_history
  WHERE event_code = 'RESOLVED'
  GROUP BY escalation_case_id
  HAVING COUNT(*) > 1
) duplicates;

-- Diagnostic details for any completion classification anomaly.
SELECT i.id AS sla_instance_id, i.idempotency_key, i.current_state_code,
  i.due_at, i.completed_at, c.timezone_name,
  SUM(CASE WHEN e.event_code = 'BREACHED' AND e.event_at <= i.completed_at THEN 1 ELSE 0 END)
    AS prior_breach_events
FROM sla_instances i
JOIN sla_calendars c ON c.id = i.calendar_id
LEFT JOIN sla_instance_events e ON e.sla_instance_id = i.id
WHERE i.current_state_code IN ('COMPLETED_WITHIN_SLA', 'COMPLETED_OUTSIDE_SLA')
GROUP BY i.id, i.idempotency_key, i.current_state_code, i.due_at,
  i.completed_at, c.timezone_name
HAVING (i.current_state_code = 'COMPLETED_WITHIN_SLA'
        AND (i.completed_at IS NULL OR i.completed_at > i.due_at
          OR SUM(CASE WHEN e.event_code = 'BREACHED' AND e.event_at <= i.completed_at THEN 1 ELSE 0 END) > 0))
    OR (i.current_state_code = 'COMPLETED_OUTSIDE_SLA'
        AND (i.completed_at IS NULL
          OR (i.completed_at <= i.due_at
            AND SUM(CASE WHEN e.event_code = 'BREACHED' AND e.event_at <= i.completed_at THEN 1 ELSE 0 END) = 0)));

-- Fresh Phase 9C workflow fixtures and an existing within-SLA regression sample.
SELECT i.id AS sla_instance_id, i.idempotency_key, i.current_state_code,
  i.due_at, i.completed_at, c.timezone_name,
  t.ticket_number, d.serial_number
FROM sla_instances i
JOIN sla_calendars c ON c.id = i.calendar_id
LEFT JOIN tickets t ON t.id = i.ticket_id
LEFT JOIN devices d ON d.id = COALESCE(i.device_id, t.device_id)
WHERE i.id IN (1, 7, 8)
ORDER BY i.id;

-- 7. Current SLA start-to-completion ordering anomalies.
-- SLA 3 is reported separately below by its immutable fixture identity; no other
-- instance is exempt, so later anomalies remain visible and fail this check.
SELECT 'current_sla_start_after_completion_anomalies' AS check_name,
  COUNT(*) AS anomalies
FROM sla_instances i
JOIN sla_instance_events started
  ON started.sla_instance_id = i.id AND started.event_code = 'STARTED'
JOIN sla_instance_events completed
  ON completed.sla_instance_id = i.id AND completed.event_code = 'COMPLETED'
WHERE started.event_at > completed.event_at
  AND NOT (i.id = 3 AND i.idempotency_key = 'REPAIR:JOB:39'
    AND i.ticket_id = 71 AND i.logistics_case_id = 57
    AND i.repair_job_id = 39);

-- Protected historical SLA 3 anomaly, reported rather than suppressed.
SELECT 'protected_historical_sla3_start_after_completion' AS check_name,
  COUNT(*) AS historical_anomalies
FROM sla_instances i
JOIN sla_instance_events started
  ON started.sla_instance_id = i.id AND started.event_code = 'STARTED'
JOIN sla_instance_events completed
  ON completed.sla_instance_id = i.id AND completed.event_code = 'COMPLETED'
WHERE i.id = 3 AND i.idempotency_key = 'REPAIR:JOB:39'
  AND i.ticket_id = 71 AND i.logistics_case_id = 57 AND i.repair_job_id = 39
  AND started.event_at > completed.event_at;

-- Details for every current ordering anomaly, plus the explicitly identified
-- protected SLA 3 row so its historical status remains auditable.
SELECT CASE
    WHEN i.id = 3 AND i.idempotency_key = 'REPAIR:JOB:39'
      AND i.ticket_id = 71 AND i.logistics_case_id = 57 AND i.repair_job_id = 39
      THEN 'PROTECTED_HISTORICAL_SLA3'
    ELSE 'CURRENT_ANOMALY'
  END AS classification,
  i.id AS sla_instance_id, i.idempotency_key, i.ticket_id,
  i.logistics_case_id, i.repair_job_id,
  started.id AS started_event_id, started.event_at AS started_event_at,
  completed.id AS completed_event_id, completed.event_at AS completed_event_at
FROM sla_instances i
JOIN sla_instance_events started
  ON started.sla_instance_id = i.id AND started.event_code = 'STARTED'
JOIN sla_instance_events completed
  ON completed.sla_instance_id = i.id AND completed.event_code = 'COMPLETED'
WHERE started.event_at > completed.event_at
ORDER BY i.id, started.id, completed.id;
