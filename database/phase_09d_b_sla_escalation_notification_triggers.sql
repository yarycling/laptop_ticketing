-- Phase 9D-B notification event types. Workflow hooks remain Wappler Server Connect actions.
-- Safe to reapply; existing severities and notification schema are reused.
INSERT IGNORE INTO notification_event_types (code,name) VALUES
 ('SLA_AT_RISK','SLA at risk'),
 ('SLA_BREACHED','SLA breached'),
 ('ESCALATION_RESOLVED','Escalation resolved'),
 ('ESCALATION_CANCELLED','Escalation cancelled');

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_notification_inbox AS
SELECT nr.id AS recipient_id, nr.notification_event_id, nr.user_id,
  nr.recipient_role_code, nr.delivered_in_app_at, nr.read_at, nr.read_by,
  nr.archived_at, IF(nr.read_at IS NULL,0,1) AS read_state,
  e.idempotency_key, e.event_type_code, et.name AS event_type_name,
  e.source_type, e.source_id, e.ticket_id, t.ticket_number, e.sla_instance_id,
  COALESCE(ec.policy_code_snapshot,si.policy_code_snapshot) AS sla_policy_code,
  e.escalation_case_id, ec.escalation_number,
  ec.current_level AS escalation_level, ec.current_state_code AS escalation_state_code,
  e.logistics_case_id, e.repair_job_id,
  e.temporary_loan_case_id, e.permanent_replacement_case_id,
  e.severity_code, sv.name AS severity_name, e.title, e.message,
  e.action_type, e.action_reference, e.created_at,
  DATE_FORMAT(e.created_at, '%b %e, %Y %l:%i %p') AS created_at_display,
  creator.display_name AS created_by_name
FROM notification_recipients nr
JOIN notification_events e ON e.id=nr.notification_event_id
JOIN notification_event_types et ON et.code=e.event_type_code
JOIN notification_severities sv ON sv.code=e.severity_code
LEFT JOIN tickets t ON t.id=e.ticket_id
LEFT JOIN sla_instances si ON si.id=e.sla_instance_id
LEFT JOIN escalation_cases ec ON ec.id=e.escalation_case_id
LEFT JOIN users creator ON creator.id=e.created_by;
