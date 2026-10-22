-- Phase 9B SLA event-integrity delta (MySQL 5.7, SELECT-only).
-- Event primary-key order is append order. SLA 3's wall-clock timestamps are
-- separately surfaced as a protected historical anomaly; no other instance
-- receives an exclusion.

-- State must match the final appended event for every SLA.
SELECT '17_current_state_matches_last_appended_event' AS check_name,
  COUNT(*) AS anomaly_count
FROM sla_instances i
LEFT JOIN sla_instance_events e
  ON e.sla_instance_id = i.id
  AND e.id = (
    SELECT MAX(e2.id)
    FROM sla_instance_events e2
    WHERE e2.sla_instance_id = i.id
  )
WHERE e.id IS NULL OR e.to_state_code <> i.current_state_code;

-- Current event-ordering anomalies: only the exact protected SLA 3 fixture is
-- omitted here, and it is explicitly counted and detailed below.
SELECT 'current_start_after_completion_anomalies' AS check_name,
  COUNT(*) AS anomaly_count
FROM sla_instances i
JOIN sla_instance_events started
  ON started.sla_instance_id = i.id AND started.event_code = 'STARTED'
JOIN sla_instance_events completed
  ON completed.sla_instance_id = i.id AND completed.event_code = 'COMPLETED'
WHERE started.event_at > completed.event_at
  AND NOT (i.id = 3 AND i.idempotency_key = 'REPAIR:JOB:39'
    AND i.ticket_id = 71 AND i.logistics_case_id = 57
    AND i.repair_job_id = 39);

SELECT 'protected_historical_sla3_timestamp_anomalies' AS check_name,
  COUNT(*) AS anomaly_count
FROM sla_instances i
JOIN sla_instance_events started
  ON started.sla_instance_id = i.id AND started.event_code = 'STARTED'
JOIN sla_instance_events completed
  ON completed.sla_instance_id = i.id AND completed.event_code = 'COMPLETED'
WHERE i.id = 3 AND i.idempotency_key = 'REPAIR:JOB:39'
  AND i.ticket_id = 71 AND i.logistics_case_id = 57 AND i.repair_job_id = 39
  AND started.event_at > completed.event_at;

-- Relevant event-uniqueness checks.
SELECT '15_duplicate_started_event_groups' AS check_name,
  COUNT(*) AS anomaly_count
FROM (
  SELECT sla_instance_id FROM sla_instance_events
  WHERE event_code = 'STARTED'
  GROUP BY sla_instance_id HAVING COUNT(*) > 1
) duplicates;

SELECT '16_duplicate_completed_event_groups' AS check_name,
  COUNT(*) AS anomaly_count
FROM (
  SELECT sla_instance_id FROM sla_instance_events
  WHERE event_code = 'COMPLETED'
  GROUP BY sla_instance_id HAVING COUNT(*) > 1
) duplicates;

-- Full detail for ordering anomalies, including the protected historical row.
SELECT CASE
    WHEN i.id = 3 AND i.idempotency_key = 'REPAIR:JOB:39'
      AND i.ticket_id = 71 AND i.logistics_case_id = 57 AND i.repair_job_id = 39
      THEN 'PROTECTED_HISTORICAL_SLA3'
    ELSE 'CURRENT_ANOMALY'
  END AS classification,
  i.id AS sla_instance_id, i.idempotency_key, i.policy_code_snapshot,
  i.ticket_id, i.logistics_case_id, i.repair_job_id,
  started.id AS started_event_id, started.event_at AS started_event_at,
  completed.id AS completed_event_id, completed.event_at AS completed_event_at
FROM sla_instances i
JOIN sla_instance_events started
  ON started.sla_instance_id = i.id AND started.event_code = 'STARTED'
JOIN sla_instance_events completed
  ON completed.sla_instance_id = i.id AND completed.event_code = 'COMPLETED'
WHERE started.event_at > completed.event_at
ORDER BY i.id, started.id, completed.id;
