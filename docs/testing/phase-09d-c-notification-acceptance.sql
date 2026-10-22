-- Phase 9D-C read-only acceptance checks. MySQL 5.7 compatible; SELECT only.

SELECT '01_REQUIRED_EVENT_TYPES' AS check_name, COUNT(*) AS anomalies
FROM (
  SELECT required.code
  FROM (
    SELECT 'TICKET_SUBMITTED' AS code UNION ALL SELECT 'TICKET_CLARIFICATION_REQUESTED' UNION ALL
    SELECT 'DISTRICT_APPROVAL_REQUIRED' UNION ALL SELECT 'TICKET_APPROVED_FOR_PICKUP' UNION ALL
    SELECT 'LOGISTICS_PICKUP_REQUESTED' UNION ALL SELECT 'LOGISTICS_SCHOOL_RELEASED' UNION ALL
    SELECT 'LOGISTICS_RECEIVED_BY_TTPOST' UNION ALL SELECT 'LOGISTICS_SENT_TO_REPAIR_CENTRE' UNION ALL
    SELECT 'LOGISTICS_RECEIVED_BY_REPAIR_CENTRE' UNION ALL SELECT 'LOGISTICS_READY_FOR_RETURN_PICKUP' UNION ALL
    SELECT 'LOGISTICS_RETURN_RECEIVED_BY_TTPOST' UNION ALL SELECT 'LOGISTICS_RETURN_IN_TRANSIT_TO_SCHOOL' UNION ALL
    SELECT 'LOGISTICS_RETURNED_TO_SCHOOL' UNION ALL SELECT 'REPAIR_STARTED' UNION ALL
    SELECT 'REPAIR_COMPLETED' UNION ALL SELECT 'DISTRICT_REPAIR_DECISION_REQUIRED' UNION ALL
    SELECT 'HEAD_OFFICE_REPLACEMENT_APPROVAL_REQUIRED'
  ) required
  LEFT JOIN notification_event_types et ON et.code=required.code
  WHERE et.code IS NULL
) missing_types;

SELECT '02_DUPLICATE_IDEMPOTENCY_KEYS' AS check_name, COUNT(*) AS anomalies
FROM (SELECT idempotency_key FROM notification_events GROUP BY idempotency_key HAVING COUNT(*) > 1) d;

SELECT '03_DUPLICATE_EVENT_RECIPIENTS' AS check_name, COUNT(*) AS anomalies
FROM (SELECT notification_event_id,user_id FROM notification_recipients GROUP BY notification_event_id,user_id HAVING COUNT(*) > 1) d;

SELECT '04_INACTIVE_RECIPIENTS' AS check_name, COUNT(*) AS anomalies
FROM notification_recipients nr JOIN users u ON u.id=nr.user_id
WHERE u.status <> 'active';

SELECT '05_TICKET_SOURCE_REFERENCES' AS check_name, COUNT(*) AS anomalies
FROM notification_events e LEFT JOIN tickets t ON t.id=e.ticket_id
WHERE e.event_type_code IN ('TICKET_SUBMITTED','TICKET_CLARIFICATION_REQUESTED','DISTRICT_APPROVAL_REQUIRED','TICKET_APPROVED_FOR_PICKUP')
  AND (e.ticket_id IS NULL OR t.id IS NULL);

SELECT '06_LOGISTICS_CASE_REFERENCES' AS check_name, COUNT(*) AS anomalies
FROM notification_events e LEFT JOIN ticket_logistics_cases lc ON lc.id=e.logistics_case_id
WHERE e.event_type_code LIKE 'LOGISTICS_%'
  AND (e.logistics_case_id IS NULL OR lc.id IS NULL);

SELECT '07_LOGISTICS_HANDOFF_REFERENCES' AS check_name, COUNT(*) AS anomalies
FROM notification_events e
LEFT JOIN logistics_handoffs h ON h.id=CAST(e.source_id AS UNSIGNED)
WHERE e.event_type_code IN ('LOGISTICS_SCHOOL_RELEASED','LOGISTICS_RECEIVED_BY_TTPOST','LOGISTICS_SENT_TO_REPAIR_CENTRE','LOGISTICS_RECEIVED_BY_REPAIR_CENTRE','LOGISTICS_RETURN_RECEIVED_BY_TTPOST','LOGISTICS_RETURN_IN_TRANSIT_TO_SCHOOL','LOGISTICS_RETURNED_TO_SCHOOL')
  AND (e.source_type <> 'LOGISTICS_HANDOFF' OR e.source_id IS NULL OR h.id IS NULL OR h.logistics_case_id <> e.logistics_case_id);

SELECT '08_REPAIR_JOB_REFERENCES' AS check_name, COUNT(*) AS anomalies
FROM notification_events e LEFT JOIN repair_jobs rj ON rj.id=e.repair_job_id
WHERE e.event_type_code IN ('REPAIR_STARTED','REPAIR_COMPLETED')
  AND (e.repair_job_id IS NULL OR rj.id IS NULL OR rj.logistics_case_id <> e.logistics_case_id);

SELECT '09_EXCEPTION_REFERENCES' AS check_name, COUNT(*) AS anomalies
FROM notification_events e
LEFT JOIN repair_exception_cases ec ON ec.id=CAST(e.source_id AS UNSIGNED)
WHERE e.event_type_code IN ('DISTRICT_REPAIR_DECISION_REQUIRED','HEAD_OFFICE_REPLACEMENT_APPROVAL_REQUIRED')
  AND (e.source_type <> 'REPAIR_EXCEPTION' OR e.source_id IS NULL OR ec.id IS NULL OR ec.ticket_id <> e.ticket_id OR ec.logistics_case_id <> e.logistics_case_id);

SELECT '10_RECIPIENT_SCOPE' AS check_name, COUNT(*) AS anomalies
FROM notification_events e
JOIN notification_recipients nr ON nr.notification_event_id=e.id
JOIN users u ON u.id=nr.user_id
WHERE e.event_type_code IN (
  'TICKET_SUBMITTED','TICKET_CLARIFICATION_REQUESTED','DISTRICT_APPROVAL_REQUIRED','TICKET_APPROVED_FOR_PICKUP',
  'LOGISTICS_PICKUP_REQUESTED','LOGISTICS_SCHOOL_RELEASED','LOGISTICS_RECEIVED_BY_TTPOST','LOGISTICS_SENT_TO_REPAIR_CENTRE',
  'LOGISTICS_RECEIVED_BY_REPAIR_CENTRE','LOGISTICS_READY_FOR_RETURN_PICKUP','LOGISTICS_RETURN_RECEIVED_BY_TTPOST',
  'LOGISTICS_RETURN_IN_TRANSIT_TO_SCHOOL','LOGISTICS_RETURNED_TO_SCHOOL','REPAIR_STARTED','REPAIR_COMPLETED',
  'DISTRICT_REPAIR_DECISION_REQUIRED','HEAD_OFFICE_REPLACEMENT_APPROVAL_REQUIRED'
) AND (
  (e.event_type_code IN ('TICKET_SUBMITTED','TICKET_CLARIFICATION_REQUESTED','TICKET_APPROVED_FOR_PICKUP','LOGISTICS_RECEIVED_BY_TTPOST','LOGISTICS_RECEIVED_BY_REPAIR_CENTRE','LOGISTICS_RETURN_RECEIVED_BY_TTPOST','LOGISTICS_RETURN_IN_TRANSIT_TO_SCHOOL','LOGISTICS_RETURNED_TO_SCHOOL','REPAIR_STARTED','REPAIR_COMPLETED')
   AND nr.recipient_role_code IN ('SCHOOL_ADMINISTRATOR','ICT_TECHNICAL_OFFICER')
   AND NOT EXISTS (SELECT 1 FROM user_school_scopes ss, tickets t WHERE ss.user_id=u.id AND t.id=e.ticket_id AND ss.school_id=t.origin_school_id AND ss.status='active'))
  OR (e.event_type_code IN ('DISTRICT_APPROVAL_REQUIRED','DISTRICT_REPAIR_DECISION_REQUIRED','LOGISTICS_RETURNED_TO_SCHOOL','REPAIR_STARTED','REPAIR_COMPLETED')
   AND nr.recipient_role_code='ICT_DISTRICT_COORDINATOR'
   AND NOT EXISTS (SELECT 1 FROM user_district_scopes ds, tickets t WHERE ds.user_id=u.id AND t.id=e.ticket_id AND ds.district_id=t.origin_district_id AND ds.status='active'))
  OR (e.event_type_code='LOGISTICS_SENT_TO_REPAIR_CENTRE' AND nr.recipient_role_code='REPAIR_CENTRE'
   AND NOT EXISTS (SELECT 1 FROM user_service_location_scopes ls, logistics_handoffs h WHERE ls.user_id=u.id AND h.id=CAST(e.source_id AS UNSIGNED) AND ls.service_location_id=h.to_service_location_id AND ls.status='active'))
  OR (e.event_type_code='HEAD_OFFICE_REPLACEMENT_APPROVAL_REQUIRED' AND nr.recipient_role_code='MOE_HEAD_OFFICE'
   AND NOT EXISTS (SELECT 1 FROM user_national_scopes ns WHERE ns.user_id=u.id AND ns.status='active'))
  OR (nr.recipient_role_code IS NULL OR NOT EXISTS (SELECT 1 FROM user_roles ur JOIN roles r ON r.id=ur.role_id WHERE ur.user_id=u.id AND r.name=nr.recipient_role_code)));

SELECT '11_SAFE_ACTION_TARGETS' AS check_name, COUNT(*) AS anomalies
FROM notification_events e
WHERE e.event_type_code IN (
  'TICKET_SUBMITTED','TICKET_CLARIFICATION_REQUESTED','DISTRICT_APPROVAL_REQUIRED','TICKET_APPROVED_FOR_PICKUP',
  'LOGISTICS_PICKUP_REQUESTED','LOGISTICS_SCHOOL_RELEASED','LOGISTICS_RECEIVED_BY_TTPOST','LOGISTICS_SENT_TO_REPAIR_CENTRE',
  'LOGISTICS_RECEIVED_BY_REPAIR_CENTRE','LOGISTICS_READY_FOR_RETURN_PICKUP','LOGISTICS_RETURN_RECEIVED_BY_TTPOST',
  'LOGISTICS_RETURN_IN_TRANSIT_TO_SCHOOL','LOGISTICS_RETURNED_TO_SCHOOL','REPAIR_STARTED','REPAIR_COMPLETED',
  'DISTRICT_REPAIR_DECISION_REQUIRED','HEAD_OFFICE_REPLACEMENT_APPROVAL_REQUIRED'
) AND (
  (e.action_type NOT IN ('TICKET_DETAIL','LOGISTICS_DETAIL','REPAIR_DETAIL','EXCEPTION_DETAIL')) OR e.action_type IS NULL OR e.action_reference IS NULL
  OR (e.action_type='TICKET_DETAIL' AND e.action_reference <> CAST(e.ticket_id AS CHAR))
  OR (e.action_type='LOGISTICS_DETAIL' AND e.action_reference <> CAST(e.logistics_case_id AS CHAR))
  OR (e.action_type='REPAIR_DETAIL' AND (e.repair_job_id IS NULL OR e.repair_job_id < 1))
  OR (e.action_type='EXCEPTION_DETAIL' AND e.action_reference <> e.source_id)
);

SELECT '12_NOTIFICATION_DATABASE_TRIGGERS' AS check_name, COUNT(*) AS anomalies
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA=DATABASE();

SELECT id,event_type_code,idempotency_key,ticket_id,logistics_case_id,escalation_case_id
FROM notification_events WHERE id IN (7,8) ORDER BY id;

SELECT id,event_type_code,idempotency_key,ticket_id,logistics_case_id,escalation_case_id
FROM notification_events
WHERE ticket_id=76 AND event_type_code IN ('SLA_AT_RISK','SLA_BREACHED','ESCALATION_RESOLVED','ESCALATION_CANCELLED')
ORDER BY id;
