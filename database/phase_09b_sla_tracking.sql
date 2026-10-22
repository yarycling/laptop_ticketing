-- Phase 9B operational SLA tracking (MySQL 5.7).
-- No workflow state is changed by these records or views.

CREATE TABLE IF NOT EXISTS sla_instance_states (
  code VARCHAR(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  name VARCHAR(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  sort_order SMALLINT UNSIGNED NOT NULL,
  is_terminal TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO sla_instance_states (code, name, sort_order, is_terminal) VALUES
  ('PENDING', 'Pending', 10, 0),
  ('ACTIVE', 'Active', 20, 0),
  ('AT_RISK', 'At Risk', 30, 0),
  ('BREACHED', 'Breached', 40, 0),
  ('COMPLETED_WITHIN_SLA', 'Completed Within SLA', 50, 1),
  ('COMPLETED_OUTSIDE_SLA', 'Completed Outside SLA', 60, 1),
  ('CANCELLED', 'Cancelled', 70, 1);

CREATE TABLE IF NOT EXISTS sla_calendar_dates (
  calendar_date DATE NOT NULL,
  PRIMARY KEY (calendar_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- A static date spine avoids MySQL 8 recursive CTEs. Extend this seed range in a
-- later migration before 2102; calendar rules and overrides remain live data.
INSERT IGNORE INTO sla_calendar_dates (calendar_date)
SELECT DATE_ADD('2020-01-01', INTERVAL numbers.n DAY)
FROM (
  SELECT d0.n + d1.n * 10 + d2.n * 100 + d3.n * 1000 + d4.n * 10000 AS n
  FROM (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d0
  CROSS JOIN (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d1
  CROSS JOIN (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d2
  CROSS JOIN (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d3
  CROSS JOIN (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d4
) numbers
WHERE numbers.n <= 29999;

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_sla_calendar_business_dates AS
SELECT c.id AS calendar_id, d.calendar_date,
  TIMESTAMP(d.calendar_date, '23:59:59') AS business_due_at,
  CASE
    WHEN o.id IS NOT NULL THEN o.is_business_day
    ELSE COALESCE(w.is_business_day, 0)
  END AS is_business_day
FROM sla_calendars c
CROSS JOIN sla_calendar_dates d
LEFT JOIN sla_calendar_weekdays w
  ON w.calendar_id = c.id AND w.weekday_number = WEEKDAY(d.calendar_date) + 1
LEFT JOIN sla_calendar_overrides o
  ON o.calendar_id = c.id AND o.override_date = d.calendar_date AND o.status = 'active';

CREATE TABLE IF NOT EXISTS sla_instances (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  idempotency_key VARCHAR(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  policy_id INT UNSIGNED NOT NULL,
  policy_version_id BIGINT UNSIGNED NOT NULL,
  policy_code_snapshot VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  target_business_days_snapshot DECIMAL(6,2) UNSIGNED NOT NULL,
  calendar_id INT UNSIGNED NOT NULL,
  ticket_id INT UNSIGNED NOT NULL,
  logistics_case_id INT UNSIGNED NULL,
  repair_job_id INT UNSIGNED NULL,
  device_id INT UNSIGNED NULL,
  effective_device_id INT UNSIGNED NULL,
  source_workflow VARCHAR(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  source_entity_type VARCHAR(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  source_entity_id BIGINT UNSIGNED NOT NULL,
  current_state_code VARCHAR(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  started_at DATETIME(6) NOT NULL,
  due_at DATETIME(6) NOT NULL,
  at_risk_at DATETIME(6) NULL,
  breached_at DATETIME(6) NULL,
  completed_at DATETIME(6) NULL,
  cancelled_at DATETIME(6) NULL,
  completion_event VARCHAR(100) COLLATE utf8mb4_unicode_ci NULL,
  started_by_user_id INT UNSIGNED NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_sla_instances_idempotency (idempotency_key),
  KEY idx_sla_instances_policy_state_due (policy_code_snapshot, current_state_code, due_at),
  KEY idx_sla_instances_ticket (ticket_id, started_at),
  KEY idx_sla_instances_logistics (logistics_case_id, policy_code_snapshot),
  KEY idx_sla_instances_repair (repair_job_id, policy_code_snapshot),
  KEY idx_sla_instances_source (source_workflow, source_entity_type, source_entity_id),
  CONSTRAINT fk_sla_instances_policy FOREIGN KEY (policy_id) REFERENCES sla_policies(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_sla_instances_policy_version FOREIGN KEY (policy_version_id) REFERENCES sla_policy_versions(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_sla_instances_calendar FOREIGN KEY (calendar_id) REFERENCES sla_calendars(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_sla_instances_ticket FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_sla_instances_logistics FOREIGN KEY (logistics_case_id) REFERENCES ticket_logistics_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_sla_instances_repair FOREIGN KEY (repair_job_id) REFERENCES repair_jobs(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_sla_instances_device FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_sla_instances_effective_device FOREIGN KEY (effective_device_id) REFERENCES devices(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_sla_instances_state FOREIGN KEY (current_state_code) REFERENCES sla_instance_states(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_sla_instances_started_by FOREIGN KEY (started_by_user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT chk_sla_instances_target CHECK (target_business_days_snapshot > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS sla_instance_events (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  sla_instance_id BIGINT UNSIGNED NOT NULL,
  event_code VARCHAR(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  from_state_code VARCHAR(40) COLLATE utf8mb4_unicode_ci NULL,
  to_state_code VARCHAR(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  event_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  source_entity_type VARCHAR(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  source_entity_id BIGINT UNSIGNED NOT NULL,
  actor_user_id INT UNSIGNED NULL,
  notes VARCHAR(500) COLLATE utf8mb4_unicode_ci NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_sla_instance_event (sla_instance_id, event_code),
  KEY idx_sla_instance_events_timeline (sla_instance_id, event_at, id),
  KEY idx_sla_instance_events_source (source_entity_type, source_entity_id, event_code),
  CONSTRAINT fk_sla_instance_events_instance FOREIGN KEY (sla_instance_id) REFERENCES sla_instances(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_sla_instance_events_from FOREIGN KEY (from_state_code) REFERENCES sla_instance_states(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_sla_instance_events_to FOREIGN KEY (to_state_code) REFERENCES sla_instance_states(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_sla_instance_events_actor FOREIGN KEY (actor_user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT chk_sla_instance_event_code CHECK (event_code IN ('STARTED','AT_RISK','BREACHED','COMPLETED','CANCELLED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_sla_operational_queue AS
SELECT i.id AS sla_instance_id, i.idempotency_key, i.policy_code_snapshot,
  pv.name AS policy_name, i.target_business_days_snapshot, i.current_state_code,
  st.name AS current_state_name, i.started_at, i.due_at, i.at_risk_at,
  i.breached_at, i.completed_at, i.cancelled_at, i.completion_event,
  i.ticket_id, t.ticket_number, t.origin_district_id, d.name AS origin_district_name,
  t.origin_school_id, s.name AS origin_school_name,
  i.logistics_case_id, lc.logistics_number, lc.repair_centre_location_id,
  i.repair_job_id, i.device_id, i.effective_device_id, i.source_workflow,
  i.source_entity_type, i.source_entity_id
FROM sla_instances i
JOIN sla_instance_states st ON st.code = i.current_state_code
JOIN sla_policy_versions pv ON pv.id = i.policy_version_id
JOIN tickets t ON t.id = i.ticket_id
LEFT JOIN districts d ON d.id = t.origin_district_id
LEFT JOIN schools s ON s.id = t.origin_school_id
LEFT JOIN ticket_logistics_cases lc ON lc.id = i.logistics_case_id;
