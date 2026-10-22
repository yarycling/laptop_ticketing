-- Preserve raw SLA timestamps and expose calendar-local display strings for UI use.
CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_sla_operational_queue AS
SELECT i.id AS sla_instance_id, i.idempotency_key, i.policy_code_snapshot,
  pv.name AS policy_name, i.target_business_days_snapshot, i.current_state_code,
  st.name AS current_state_name,
  i.started_at, i.due_at, i.at_risk_at, i.breached_at, i.completed_at,
  i.cancelled_at,
  DATE_FORMAT(i.started_at, '%b %e, %Y %l:%i %p') AS started_at_display,
  DATE_FORMAT(i.due_at, '%b %e, %Y %l:%i %p') AS due_at_display,
  DATE_FORMAT(i.at_risk_at, '%b %e, %Y %l:%i %p') AS at_risk_at_display,
  DATE_FORMAT(i.breached_at, '%b %e, %Y %l:%i %p') AS breached_at_display,
  DATE_FORMAT(i.completed_at, '%b %e, %Y %l:%i %p') AS completed_at_display,
  DATE_FORMAT(i.cancelled_at, '%b %e, %Y %l:%i %p') AS cancelled_at_display,
  i.completion_event, i.ticket_id, t.ticket_number, t.origin_district_id,
  d.name AS origin_district_name, t.origin_school_id,
  s.name AS origin_school_name, i.logistics_case_id, lc.logistics_number,
  lc.repair_centre_location_id, i.repair_job_id, i.device_id,
  i.effective_device_id, i.source_workflow, i.source_entity_type,
  i.source_entity_id
FROM sla_instances i
JOIN sla_instance_states st ON st.code = i.current_state_code
JOIN sla_policy_versions pv ON pv.id = i.policy_version_id
JOIN tickets t ON t.id = i.ticket_id
LEFT JOIN districts d ON d.id = t.origin_district_id
LEFT JOIN schools s ON s.id = t.origin_school_id
LEFT JOIN ticket_logistics_cases lc ON lc.id = i.logistics_case_id;

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_escalation_operational_queue AS
SELECT ec.id AS escalation_case_id, ec.escalation_number, ec.sla_instance_id,
  ec.policy_code_snapshot, ec.ticket_id, t.ticket_number, ec.logistics_case_id,
  lc.logistics_number, ec.repair_job_id, ec.district_id, d.name AS district_name,
  ec.school_id, s.name AS school_name, ec.repair_centre_location_id,
  loc.name AS repair_centre_name, ec.current_level, ec.current_trigger,
  ec.current_state_code, es.name AS current_state_name, ec.reason_snapshot,
  ec.opened_at, ec.acknowledged_at,
  DATE_FORMAT(ec.opened_at, '%b %e, %Y %l:%i %p') AS opened_at_display,
  DATE_FORMAT(ec.acknowledged_at, '%b %e, %Y %l:%i %p') AS acknowledged_at_display,
  ec.acknowledged_by, au.display_name AS acknowledged_by_name,
  ec.acknowledgement_note,
  ec.resolved_at, ec.cancelled_at,
  DATE_FORMAT(ec.resolved_at, '%b %e, %Y %l:%i %p') AS resolved_at_display,
  DATE_FORMAT(ec.cancelled_at, '%b %e, %Y %l:%i %p') AS cancelled_at_display,
  i.current_state_code AS sla_state_code, ist.name AS sla_state_name,
  i.started_at AS sla_started_at, i.due_at AS sla_due_at,
  i.at_risk_at AS sla_at_risk_at, i.breached_at AS sla_breached_at,
  i.completed_at AS sla_completed_at, i.cancelled_at AS sla_cancelled_at,
  DATE_FORMAT(i.started_at, '%b %e, %Y %l:%i %p') AS sla_started_at_display,
  DATE_FORMAT(i.due_at, '%b %e, %Y %l:%i %p') AS sla_due_at_display,
  GROUP_CONCAT(DISTINCT CONCAT(a.target_role_name_snapshot, '|',
    a.level_snapshot) ORDER BY a.level_snapshot SEPARATOR ',') AS responsible_roles
FROM escalation_cases ec
JOIN tickets t ON t.id = ec.ticket_id
JOIN escalation_states es ON es.code = ec.current_state_code
JOIN sla_instances i ON i.id = ec.sla_instance_id
JOIN sla_instance_states ist ON ist.code = i.current_state_code
LEFT JOIN ticket_logistics_cases lc ON lc.id = ec.logistics_case_id
LEFT JOIN districts d ON d.id = ec.district_id
LEFT JOIN schools s ON s.id = ec.school_id
LEFT JOIN service_locations loc ON loc.id = ec.repair_centre_location_id
LEFT JOIN users au ON au.id = ec.acknowledged_by
LEFT JOIN escalation_assignments a ON a.escalation_case_id = ec.id
GROUP BY ec.id, ec.escalation_number, ec.sla_instance_id,
  ec.policy_code_snapshot, ec.ticket_id, t.ticket_number, ec.logistics_case_id,
  lc.logistics_number, ec.repair_job_id, ec.district_id, d.name, ec.school_id,
  s.name, ec.repair_centre_location_id, loc.name, ec.current_level,
  ec.current_trigger, ec.current_state_code, es.name, ec.reason_snapshot,
  ec.opened_at, ec.acknowledged_at, ec.acknowledged_by, au.display_name,
  ec.acknowledgement_note, ec.resolved_at, ec.cancelled_at,
  i.current_state_code, ist.name, i.started_at, i.due_at, i.at_risk_at,
  i.breached_at, i.completed_at, i.cancelled_at;
