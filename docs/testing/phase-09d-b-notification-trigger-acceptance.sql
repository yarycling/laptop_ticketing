-- Phase 9D-B read-only acceptance queries (MySQL 5.7).
SELECT 'required_event_types_missing' AS check_name, COUNT(*) AS anomalies
FROM (
  SELECT req.code
  FROM (SELECT 'SLA_AT_RISK' AS code UNION ALL SELECT 'SLA_BREACHED' UNION ALL SELECT 'ESCALATION_RESOLVED' UNION ALL SELECT 'ESCALATION_CANCELLED') req
  LEFT JOIN notification_event_types et ON et.code=req.code
  WHERE et.code IS NULL
) missing;

SELECT 'duplicate_idempotency_keys' AS check_name, COUNT(*) AS anomalies
FROM (SELECT idempotency_key FROM notification_events GROUP BY idempotency_key HAVING COUNT(*)>1) duplicates;

SELECT 'duplicate_event_user_recipients' AS check_name, COUNT(*) AS anomalies
FROM (SELECT notification_event_id,user_id FROM notification_recipients GROUP BY notification_event_id,user_id HAVING COUNT(*)>1) duplicates;

SELECT 'at_risk_linkage_anomalies' AS check_name, COUNT(*) AS anomalies
FROM notification_events n
LEFT JOIN sla_instances i ON i.id=n.sla_instance_id
LEFT JOIN sla_instance_events se ON se.sla_instance_id=n.sla_instance_id AND se.event_code='AT_RISK'
LEFT JOIN escalation_cases ec ON ec.id=n.escalation_case_id AND ec.sla_instance_id=n.sla_instance_id
LEFT JOIN escalation_assignments a ON a.escalation_case_id=ec.id AND a.level_snapshot=1
WHERE n.event_type_code='SLA_AT_RISK'
  AND (i.id IS NULL OR se.id IS NULL OR ec.id IS NULL OR a.id IS NULL);

SELECT 'breach_linkage_anomalies' AS check_name, COUNT(*) AS anomalies
FROM notification_events n
LEFT JOIN sla_instances i ON i.id=n.sla_instance_id
LEFT JOIN escalation_cases ec ON ec.id=n.escalation_case_id AND ec.sla_instance_id=n.sla_instance_id
LEFT JOIN escalation_history h ON h.escalation_case_id=ec.id AND h.event_code='PROMOTED'
LEFT JOIN escalation_assignments a ON a.escalation_case_id=ec.id AND a.level_snapshot=2
WHERE n.event_type_code='SLA_BREACHED'
  AND (i.id IS NULL OR i.breached_at IS NULL OR ec.id IS NULL OR (h.id IS NULL AND a.id IS NULL));

SELECT 'terminal_state_anomalies' AS check_name, COUNT(*) AS anomalies
FROM notification_events n
LEFT JOIN escalation_cases ec ON ec.id=n.escalation_case_id
WHERE (n.event_type_code='ESCALATION_RESOLVED' AND (ec.id IS NULL OR ec.current_state_code<>'RESOLVED'))
   OR (n.event_type_code='ESCALATION_CANCELLED' AND (ec.id IS NULL OR ec.current_state_code<>'CANCELLED'));

SELECT 'inactive_or_missing_recipients' AS check_name, COUNT(*) AS anomalies
FROM notification_events n
JOIN notification_recipients nr ON nr.notification_event_id=n.id
LEFT JOIN users u ON u.id=nr.user_id
WHERE n.event_type_code IN ('SLA_AT_RISK','SLA_BREACHED','ESCALATION_RESOLVED','ESCALATION_CANCELLED')
  AND (u.id IS NULL OR u.status<>'active');

SELECT 'orphan_source_relationships' AS check_name, COUNT(*) AS anomalies
FROM notification_events n
LEFT JOIN tickets t ON t.id=n.ticket_id
LEFT JOIN sla_instances i ON i.id=n.sla_instance_id
LEFT JOIN escalation_cases ec ON ec.id=n.escalation_case_id
LEFT JOIN ticket_logistics_cases lc ON lc.id=n.logistics_case_id
LEFT JOIN repair_jobs rj ON rj.id=n.repair_job_id
WHERE (n.ticket_id IS NOT NULL AND t.id IS NULL)
   OR (n.sla_instance_id IS NOT NULL AND i.id IS NULL)
   OR (n.escalation_case_id IS NOT NULL AND ec.id IS NULL)
   OR (n.logistics_case_id IS NOT NULL AND lc.id IS NULL)
   OR (n.repair_job_id IS NOT NULL AND rj.id IS NULL);

SELECT 'unsafe_sla_escalation_action_references' AS check_name, COUNT(*) AS anomalies
FROM notification_events
WHERE event_type_code IN ('SLA_AT_RISK','SLA_BREACHED','ESCALATION_RESOLVED','ESCALATION_CANCELLED')
  AND (action_type<>'TICKET_DETAIL' OR action_reference IS NULL OR action_reference NOT REGEXP '^[0-9]+$');

SELECT 'missing_escalation_read_context' AS check_name, COUNT(*) AS anomalies
FROM v_notification_inbox
WHERE event_type_code IN ('SLA_AT_RISK','SLA_BREACHED','ESCALATION_RESOLVED','ESCALATION_CANCELLED')
  AND (sla_policy_code IS NULL OR escalation_number IS NULL OR escalation_level IS NULL OR ticket_number IS NULL);

SELECT 'database_triggers' AS check_name, COUNT(*) AS triggers_found
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA=DATABASE();

-- Protected notification fixtures are reported for before/after comparison; this query writes nothing.
SELECT id,event_type_code,source_type,source_id,ticket_id,sla_instance_id,escalation_case_id,created_at
FROM notification_events WHERE id IN (7,8) ORDER BY id;
