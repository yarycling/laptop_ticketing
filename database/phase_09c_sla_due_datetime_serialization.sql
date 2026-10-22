-- Preserve calendar-local wall-clock due dates as strings across Wappler's
-- Server Connect database read/write boundary (MySQL 5.7).
-- Apply after phase_09b_sla_tracking.sql. No business rows are modified.
CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_sla_calendar_business_dates AS
SELECT c.id AS calendar_id,
       d.calendar_date,
       DATE_FORMAT(TIMESTAMP(d.calendar_date, '23:59:59'), '%Y-%m-%d %H:%i:%s') AS business_due_at,
       CASE WHEN o.id IS NOT NULL THEN o.is_business_day ELSE COALESCE(w.is_business_day, 0) END AS is_business_day
FROM sla_calendars c
JOIN sla_calendar_dates d
LEFT JOIN sla_calendar_weekdays w
  ON w.calendar_id = c.id
 AND w.weekday_number = WEEKDAY(d.calendar_date) + 1
LEFT JOIN sla_calendar_overrides o
  ON o.calendar_id = c.id
 AND o.override_date = d.calendar_date
 AND o.status = 'active';
