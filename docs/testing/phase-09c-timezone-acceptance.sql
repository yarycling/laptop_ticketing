-- Phase 9C named-timezone and SLA state/history acceptance (MySQL 5.7).
-- Read-only. A deployment must load MySQL timezone tables before this passes.

-- 1. Verify the named timezone used by the default Trinidad and Tobago calendar.
SELECT 'PORT_OF_SPAIN_TIMEZONE' AS check_name,
  CONVERT_TZ(UTC_TIMESTAMP(), '+00:00', 'America/Port_of_Spain') AS local_now,
  CASE WHEN CONVERT_TZ(UTC_TIMESTAMP(), '+00:00', 'America/Port_of_Spain') IS NULL
    THEN 'FAIL' ELSE 'PASS' END AS result;

-- 2. Confirm New York's IANA rules resolve with distinct winter/summer offsets.
SELECT 'NEW_YORK_DST_RULES' AS check_name,
  CONVERT_TZ('2026-07-15 12:00:00', '+00:00', 'America/New_York') AS summer_local,
  CONVERT_TZ('2026-01-15 12:00:00', '+00:00', 'America/New_York') AS winter_local,
  CASE
    WHEN CONVERT_TZ('2026-07-15 12:00:00', '+00:00', 'America/New_York') = '2026-07-15 08:00:00'
      AND CONVERT_TZ('2026-01-15 12:00:00', '+00:00', 'America/New_York') = '2026-01-15 07:00:00'
    THEN 'PASS' ELSE 'FAIL'
  END AS result;

-- 3. Every active calendar must resolve its own configured IANA timezone.
SELECT c.id AS calendar_id, c.calendar_code, c.name, c.timezone_name,
  CONVERT_TZ(UTC_TIMESTAMP(), '+00:00', c.timezone_name) AS local_now,
  CASE WHEN CONVERT_TZ(UTC_TIMESTAMP(), '+00:00', c.timezone_name) IS NULL
    THEN 'FAIL' ELSE 'PASS' END AS result
FROM sla_calendars c
WHERE c.status = 'active'
ORDER BY c.id;

-- 4. Count active calendars that cannot currently resolve their timezone.
SELECT COUNT(*) AS unresolved_active_calendar_count
FROM sla_calendars c
WHERE c.status = 'active'
  AND CONVERT_TZ(UTC_TIMESTAMP(), '+00:00', c.timezone_name) IS NULL;

-- 5. Report SLA state/history mismatches. Expected result: zero rows.
SELECT i.id AS sla_instance_id, i.idempotency_key, i.current_state_code,
  expected.event_code AS expected_event_code,
  e.to_state_code AS recorded_event_state,
  e.event_at AS recorded_event_at
FROM sla_instances i
LEFT JOIN sla_instance_events e
  ON e.sla_instance_id = i.id
  AND e.event_code = CASE
    WHEN i.current_state_code = 'ACTIVE' THEN 'STARTED'
    WHEN i.current_state_code = 'AT_RISK' THEN 'AT_RISK'
    WHEN i.current_state_code = 'BREACHED' THEN 'BREACHED'
    WHEN i.current_state_code IN ('COMPLETED_WITHIN_SLA', 'COMPLETED_OUTSIDE_SLA') THEN 'COMPLETED'
    WHEN i.current_state_code = 'CANCELLED' THEN 'CANCELLED'
    ELSE NULL
  END
LEFT JOIN (
  SELECT 'ACTIVE' AS state_code, 'STARTED' AS event_code
  UNION ALL SELECT 'AT_RISK', 'AT_RISK'
  UNION ALL SELECT 'BREACHED', 'BREACHED'
  UNION ALL SELECT 'COMPLETED_WITHIN_SLA', 'COMPLETED'
  UNION ALL SELECT 'COMPLETED_OUTSIDE_SLA', 'COMPLETED'
  UNION ALL SELECT 'CANCELLED', 'CANCELLED'
) expected ON expected.state_code = i.current_state_code
WHERE expected.event_code IS NOT NULL
  AND (e.id IS NULL OR e.to_state_code <> i.current_state_code);

-- 6. Summary count for automated acceptance reporting; expected result: zero.
SELECT COUNT(*) AS sla_state_history_anomaly_count
FROM sla_instances i
LEFT JOIN sla_instance_events e
  ON e.sla_instance_id = i.id
  AND e.event_code = CASE
    WHEN i.current_state_code = 'ACTIVE' THEN 'STARTED'
    WHEN i.current_state_code = 'AT_RISK' THEN 'AT_RISK'
    WHEN i.current_state_code = 'BREACHED' THEN 'BREACHED'
    WHEN i.current_state_code IN ('COMPLETED_WITHIN_SLA', 'COMPLETED_OUTSIDE_SLA') THEN 'COMPLETED'
    WHEN i.current_state_code = 'CANCELLED' THEN 'CANCELLED'
    ELSE NULL
  END
WHERE i.current_state_code IN (
    'ACTIVE', 'AT_RISK', 'BREACHED',
    'COMPLETED_WITHIN_SLA', 'COMPLETED_OUTSIDE_SLA', 'CANCELLED'
  )
  AND (e.id IS NULL OR e.to_state_code <> i.current_state_code);
