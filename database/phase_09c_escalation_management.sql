-- Phase 9C configurable escalation management (MySQL 5.7).
-- Apply after phase_09b_sla_tracking.sql. No workflow state is backfilled.

CREATE TABLE IF NOT EXISTS escalation_states (
  code VARCHAR(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  name VARCHAR(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  is_terminal TINYINT(1) NOT NULL DEFAULT 0,
  sort_order SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO escalation_states (code,name,is_terminal,sort_order) VALUES
 ('OPEN','Open',0,10),('ACKNOWLEDGED','Acknowledged',0,20),
 ('RESOLVED','Resolved',1,30),('CANCELLED','Cancelled',1,40);

CREATE TABLE IF NOT EXISTS escalation_rules (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  policy_id INT UNSIGNED NOT NULL,
  trigger_code VARCHAR(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  escalation_level TINYINT UNSIGNED NOT NULL,
  target_role_id INT UNSIGNED NOT NULL,
  reason_label VARCHAR(240) COLLATE utf8mb4_unicode_ci NOT NULL,
  sort_order SMALLINT UNSIGNED NOT NULL DEFAULT 100,
  status VARCHAR(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  active_identity VARCHAR(180) COLLATE utf8mb4_unicode_ci GENERATED ALWAYS AS
    (CASE WHEN status='active' THEN CONCAT(policy_id,':',trigger_code,':',escalation_level,':',target_role_id) ELSE NULL END) STORED,
  created_by INT UNSIGNED NULL,
  updated_by INT UNSIGNED NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_escalation_rule_active_identity (active_identity),
  KEY idx_escalation_rules_match (policy_id,trigger_code,status,escalation_level,sort_order),
  KEY idx_escalation_rules_role (target_role_id,status),
  CONSTRAINT fk_escalation_rules_policy FOREIGN KEY (policy_id) REFERENCES sla_policies(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_escalation_rules_role FOREIGN KEY (target_role_id) REFERENCES roles(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_escalation_rules_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_escalation_rules_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT chk_escalation_rule_trigger CHECK (trigger_code IN ('AT_RISK','BREACHED')),
  CONSTRAINT chk_escalation_rule_level CHECK (escalation_level IN (1,2)),
  CONSTRAINT chk_escalation_rule_status CHECK (status IN ('active','inactive'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS escalation_cases (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  sla_instance_id BIGINT UNSIGNED NOT NULL,
  escalation_number VARCHAR(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  policy_code_snapshot VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  ticket_id INT UNSIGNED NOT NULL,
  logistics_case_id INT UNSIGNED NULL,
  repair_job_id INT UNSIGNED NULL,
  district_id INT UNSIGNED NULL,
  school_id INT UNSIGNED NULL,
  repair_centre_location_id INT UNSIGNED NULL,
  current_level TINYINT UNSIGNED NOT NULL,
  current_trigger VARCHAR(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  current_state_code VARCHAR(24) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'OPEN',
  reason_snapshot VARCHAR(240) COLLATE utf8mb4_unicode_ci NOT NULL,
  opened_at DATETIME(6) NOT NULL,
  acknowledged_at DATETIME(6) NULL,
  acknowledged_by INT UNSIGNED NULL,
  acknowledgement_note VARCHAR(500) COLLATE utf8mb4_unicode_ci NULL,
  resolved_at DATETIME(6) NULL,
  cancelled_at DATETIME(6) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_escalation_case_sla (sla_instance_id),
  UNIQUE KEY uq_escalation_case_number (escalation_number),
  KEY idx_escalation_case_queue (current_state_code,current_level,current_trigger,opened_at),
  KEY idx_escalation_case_ticket (ticket_id,current_state_code),
  KEY idx_escalation_case_scope (district_id,school_id,repair_centre_location_id),
  CONSTRAINT fk_escalation_case_sla FOREIGN KEY (sla_instance_id) REFERENCES sla_instances(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_escalation_case_ticket FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_escalation_case_logistics FOREIGN KEY (logistics_case_id) REFERENCES ticket_logistics_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_escalation_case_repair FOREIGN KEY (repair_job_id) REFERENCES repair_jobs(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_escalation_case_district FOREIGN KEY (district_id) REFERENCES districts(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_escalation_case_school FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_escalation_case_location FOREIGN KEY (repair_centre_location_id) REFERENCES service_locations(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_escalation_case_state FOREIGN KEY (current_state_code) REFERENCES escalation_states(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_escalation_case_ack_user FOREIGN KEY (acknowledged_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT chk_escalation_case_level CHECK (current_level IN (1,2)),
  CONSTRAINT chk_escalation_case_trigger CHECK (current_trigger IN ('AT_RISK','BREACHED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS escalation_assignments (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  escalation_case_id BIGINT UNSIGNED NOT NULL,
  escalation_rule_id BIGINT UNSIGNED NOT NULL,
  level_snapshot TINYINT UNSIGNED NOT NULL,
  trigger_snapshot VARCHAR(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  target_role_id INT UNSIGNED NOT NULL,
  target_role_name_snapshot VARCHAR(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  reason_snapshot VARCHAR(240) COLLATE utf8mb4_unicode_ci NOT NULL,
  assigned_at DATETIME(6) NOT NULL,
  assigned_by INT UNSIGNED NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_escalation_assignment (escalation_case_id,escalation_rule_id,level_snapshot,target_role_id),
  KEY idx_escalation_assignment_target (target_role_id,level_snapshot,escalation_case_id),
  CONSTRAINT fk_escalation_assignment_case FOREIGN KEY (escalation_case_id) REFERENCES escalation_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_escalation_assignment_rule FOREIGN KEY (escalation_rule_id) REFERENCES escalation_rules(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_escalation_assignment_role FOREIGN KEY (target_role_id) REFERENCES roles(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_escalation_assignment_actor FOREIGN KEY (assigned_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT chk_escalation_assignment_level CHECK (level_snapshot IN (1,2))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS escalation_history (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  escalation_case_id BIGINT UNSIGNED NOT NULL,
  event_code VARCHAR(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  event_key VARCHAR(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  old_state_code VARCHAR(24) COLLATE utf8mb4_unicode_ci NULL,
  new_state_code VARCHAR(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  old_level TINYINT UNSIGNED NULL,
  new_level TINYINT UNSIGNED NOT NULL,
  trigger_code VARCHAR(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  source_sla_event_id BIGINT UNSIGNED NULL,
  actor_user_id INT UNSIGNED NULL,
  event_at DATETIME(6) NOT NULL,
  notes VARCHAR(500) COLLATE utf8mb4_unicode_ci NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_escalation_history_event_key (event_key),
  UNIQUE KEY uq_escalation_history_case_event (escalation_case_id,event_code),
  KEY idx_escalation_history_timeline (escalation_case_id,event_at,id),
  CONSTRAINT fk_escalation_history_case FOREIGN KEY (escalation_case_id) REFERENCES escalation_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_escalation_history_old_state FOREIGN KEY (old_state_code) REFERENCES escalation_states(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_escalation_history_new_state FOREIGN KEY (new_state_code) REFERENCES escalation_states(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_escalation_history_sla_event FOREIGN KEY (source_sla_event_id) REFERENCES sla_instance_events(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_escalation_history_actor FOREIGN KEY (actor_user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT chk_escalation_history_event CHECK (event_code IN ('OPENED','PROMOTED','ACKNOWLEDGED','RESOLVED','CANCELLED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO escalation_rules (policy_id,trigger_code,escalation_level,target_role_id,reason_label,sort_order,status)
SELECT p.id,'AT_RISK',1,r.id,
  CASE p.policy_code WHEN 'PICKUP' THEN 'Approved device is awaiting School-to-TTPost pickup.'
    WHEN 'DIAGNOSIS' THEN 'Repair Centre diagnosis/assessment is approaching SLA breach.'
    WHEN 'REPAIR' THEN 'Repair work is approaching SLA breach.'
    WHEN 'RETURN_LOGISTICS' THEN 'Ready-for-return device is approaching return-logistics SLA breach.' END,
  10,'active'
FROM sla_policies p JOIN roles r ON r.name=CASE p.policy_code WHEN 'PICKUP' THEN 'TTPOST_LOGISTICS' WHEN 'DIAGNOSIS' THEN 'REPAIR_CENTRE' WHEN 'REPAIR' THEN 'REPAIR_CENTRE' WHEN 'RETURN_LOGISTICS' THEN 'TTPOST_LOGISTICS' END
WHERE p.policy_code IN ('PICKUP','DIAGNOSIS','REPAIR','RETURN_LOGISTICS');

INSERT IGNORE INTO escalation_rules (policy_id,trigger_code,escalation_level,target_role_id,reason_label,sort_order,status)
SELECT p.id,'BREACHED',2,r.id,CONCAT(p.policy_code,' SLA has breached its configured target.'),20,'active'
FROM sla_policies p JOIN roles r ON r.name='MOE_HEAD_OFFICE'
WHERE p.policy_code IN ('PICKUP','DIAGNOSIS','REPAIR','RETURN_LOGISTICS');

INSERT IGNORE INTO permissions (name,label,module) VALUES
 ('escalations.view','View Escalations','escalations'),
 ('escalations.respond','Acknowledge Escalations','escalations'),
 ('escalations.manage','Manage Escalation Rules','escalations');

INSERT IGNORE INTO role_permissions (role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p
WHERE (r.name='SUPER_ADMIN' AND p.name IN ('escalations.view','escalations.respond','escalations.manage'))
   OR (r.name='MOE_HEAD_OFFICE' AND p.name IN ('escalations.view','escalations.respond','escalations.manage'))
   OR (r.name='TSTT_OVERSIGHT' AND p.name='escalations.view')
   OR (r.name='ICT_DISTRICT_COORDINATOR' AND p.name='escalations.view')
   OR (r.name='ICT_TECHNICAL_OFFICER' AND p.name='escalations.view')
   OR (r.name='SCHOOL_ADMINISTRATOR' AND p.name='escalations.view')
   OR (r.name IN ('REPAIR_CENTRE','TTPOST_LOGISTICS') AND p.name IN ('escalations.view','escalations.respond'));

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_escalation_operational_queue AS
SELECT ec.id AS escalation_case_id, ec.escalation_number, ec.sla_instance_id,
  ec.policy_code_snapshot, ec.ticket_id, t.ticket_number, ec.logistics_case_id,
  lc.logistics_number, ec.repair_job_id, ec.district_id, d.name AS district_name,
  ec.school_id, s.name AS school_name, ec.repair_centre_location_id,
  loc.name AS repair_centre_name, ec.current_level, ec.current_trigger,
  ec.current_state_code, es.name AS current_state_name, ec.reason_snapshot,
  ec.opened_at, ec.acknowledged_at, ec.acknowledged_by,
  au.display_name AS acknowledged_by_name, ec.acknowledgement_note,
  ec.resolved_at, ec.cancelled_at, i.current_state_code AS sla_state_code,
  ist.name AS sla_state_name, i.started_at AS sla_started_at, i.due_at AS sla_due_at,
  i.at_risk_at AS sla_at_risk_at, i.breached_at AS sla_breached_at,
  i.completed_at AS sla_completed_at, i.cancelled_at AS sla_cancelled_at,
  GROUP_CONCAT(DISTINCT CONCAT(a.target_role_name_snapshot,'|',a.level_snapshot) ORDER BY a.level_snapshot SEPARATOR ',') AS responsible_roles
FROM escalation_cases ec
JOIN tickets t ON t.id=ec.ticket_id
JOIN escalation_states es ON es.code=ec.current_state_code
JOIN sla_instances i ON i.id=ec.sla_instance_id
JOIN sla_instance_states ist ON ist.code=i.current_state_code
LEFT JOIN ticket_logistics_cases lc ON lc.id=ec.logistics_case_id
LEFT JOIN districts d ON d.id=ec.district_id
LEFT JOIN schools s ON s.id=ec.school_id
LEFT JOIN service_locations loc ON loc.id=ec.repair_centre_location_id
LEFT JOIN users au ON au.id=ec.acknowledged_by
LEFT JOIN escalation_assignments a ON a.escalation_case_id=ec.id
GROUP BY ec.id,ec.escalation_number,ec.sla_instance_id,ec.policy_code_snapshot,
  ec.ticket_id,t.ticket_number,ec.logistics_case_id,lc.logistics_number,ec.repair_job_id,
  ec.district_id,d.name,ec.school_id,s.name,ec.repair_centre_location_id,loc.name,
  ec.current_level,ec.current_trigger,ec.current_state_code,es.name,ec.reason_snapshot,
  ec.opened_at,ec.acknowledged_at,ec.acknowledged_by,au.display_name,
  ec.acknowledgement_note,ec.resolved_at,ec.cancelled_at,i.current_state_code,
  ist.name,i.started_at,i.due_at,i.at_risk_at,i.breached_at,i.completed_at,i.cancelled_at;

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_escalation_case_targets AS
SELECT a.escalation_case_id,a.id AS assignment_id,a.level_snapshot,
  a.trigger_snapshot,a.target_role_id,a.target_role_name_snapshot,a.reason_snapshot,
  a.assigned_at,a.assigned_by,ec.current_state_code,ec.current_level,
  ec.district_id,ec.school_id,ec.repair_centre_location_id
FROM escalation_assignments a JOIN escalation_cases ec ON ec.id=a.escalation_case_id;
