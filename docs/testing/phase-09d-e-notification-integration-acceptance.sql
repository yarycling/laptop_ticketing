-- Phase 9D-E integration acceptance. MySQL 5.7; read-only SELECT statements only.
-- Event 83 is the documented pre-fix fan-out case. Event 84 is the accepted fix
-- proof. Current/post-fix checks start at event 84 and retain exact older cases
-- as separate informational evidence below.

SELECT '01 duplicate event idempotency keys' AS check_name, COUNT(*) AS anomalies
FROM (SELECT idempotency_key FROM notification_events GROUP BY idempotency_key HAVING COUNT(*) > 1) x;

SELECT '02 duplicate event/user recipient rows' AS check_name, COUNT(*) AS anomalies
FROM (SELECT notification_event_id, user_id FROM notification_recipients GROUP BY notification_event_id, user_id HAVING COUNT(*) > 1) x;

SELECT '03 orphan notification recipients' AS check_name, COUNT(*) AS anomalies
FROM notification_recipients r LEFT JOIN notification_events e ON e.id = r.notification_event_id
WHERE e.id IS NULL;

SELECT '04 inactive/missing users on current/post-fix events' AS check_name, COUNT(*) AS anomalies
FROM notification_events e
JOIN notification_recipients r ON r.notification_event_id = e.id
LEFT JOIN users u ON u.id = r.user_id
WHERE e.id >= 84 AND (u.id IS NULL OR u.status <> 'active');

SELECT '05 invalid notification event types' AS check_name, COUNT(*) AS anomalies
FROM notification_events e LEFT JOIN notification_event_types t ON t.code = e.event_type_code
WHERE t.code IS NULL;

SELECT '06 invalid notification severities' AS check_name, COUNT(*) AS anomalies
FROM notification_events e LEFT JOIN notification_severities s ON s.code = e.severity_code
WHERE s.code IS NULL;

SELECT '07 invalid ticket references' AS check_name, COUNT(*) AS anomalies
FROM notification_events e LEFT JOIN tickets t ON t.id = e.ticket_id
WHERE e.ticket_id IS NOT NULL AND t.id IS NULL;

SELECT '08 invalid SLA references' AS check_name, COUNT(*) AS anomalies
FROM notification_events e LEFT JOIN sla_instances s ON s.id = e.sla_instance_id
WHERE e.sla_instance_id IS NOT NULL AND s.id IS NULL;

SELECT '09 invalid escalation references' AS check_name, COUNT(*) AS anomalies
FROM notification_events e LEFT JOIN escalation_cases x ON x.id = e.escalation_case_id
WHERE e.escalation_case_id IS NOT NULL AND x.id IS NULL;

SELECT '10 invalid logistics references' AS check_name, COUNT(*) AS anomalies
FROM notification_events e LEFT JOIN ticket_logistics_cases l ON l.id = e.logistics_case_id
WHERE e.logistics_case_id IS NOT NULL AND l.id IS NULL;

SELECT '11 invalid repair-job references' AS check_name, COUNT(*) AS anomalies
FROM notification_events e LEFT JOIN repair_jobs j ON j.id = e.repair_job_id
WHERE e.repair_job_id IS NOT NULL AND j.id IS NULL;

SELECT '12 invalid repair-exception source references' AS check_name, COUNT(*) AS anomalies
FROM notification_events e
LEFT JOIN repair_exception_cases x
  ON e.source_type = 'REPAIR_EXCEPTION'
 AND e.source_id REGEXP '^[0-9]+$'
 AND x.id = CAST(e.source_id AS UNSIGNED)
WHERE e.source_type = 'REPAIR_EXCEPTION' AND x.id IS NULL;

SELECT '13 unsafe email action URLs' AS check_name, COUNT(*) AS anomalies
FROM notification_deliveries d
WHERE d.action_url_snapshot IS NOT NULL
  AND (LOWER(d.action_url_snapshot) REGEXP '^(javascript:|data:|https?:|//)'
       OR d.action_url_snapshot NOT LIKE '/%');

SELECT '14 email deliveries without notification recipients' AS check_name, COUNT(*) AS anomalies
FROM notification_deliveries d
LEFT JOIN notification_recipients r ON r.id = d.notification_recipient_id
WHERE r.id IS NULL;

SELECT '15 duplicate recipient/channel delivery rows' AS check_name, COUNT(*) AS anomalies
FROM (SELECT notification_recipient_id, channel_code FROM notification_deliveries
      GROUP BY notification_recipient_id, channel_code HAVING COUNT(*) > 1) x;

SELECT '16 duplicate delivery attempt numbers' AS check_name, COUNT(*) AS anomalies
FROM (SELECT notification_delivery_id, attempt_number FROM notification_delivery_attempts
      GROUP BY notification_delivery_id, attempt_number HAVING COUNT(*) > 1) x;

SELECT '17 SENT deliveries without sent_at' AS check_name, COUNT(*) AS anomalies
FROM notification_deliveries d WHERE d.status_code = 'SENT' AND d.sent_at IS NULL;

SELECT '18 SENT deliveries without successful attempt' AS check_name, COUNT(*) AS anomalies
FROM notification_deliveries d
WHERE d.status_code = 'SENT'
  AND NOT EXISTS (SELECT 1 FROM notification_delivery_attempts a
                  WHERE a.notification_delivery_id = d.id AND a.outcome_code = 'SENT');

SELECT '19 RETRY_PENDING without next_attempt_at' AS check_name, COUNT(*) AS anomalies
FROM notification_deliveries d WHERE d.status_code = 'RETRY_PENDING' AND d.next_attempt_at IS NULL;

SELECT '20 FAILED_PERMANENT due for automatic processing' AS check_name, COUNT(*) AS anomalies
FROM notification_deliveries d
WHERE d.status_code = 'FAILED_PERMANENT' AND d.next_attempt_at IS NOT NULL AND d.next_attempt_at <= NOW();

SELECT '21 SKIPPED_NO_ADDRESS with SMTP/send attempts' AS check_name, COUNT(*) AS anomalies
FROM notification_deliveries d
WHERE d.status_code = 'SKIPPED_NO_ADDRESS'
  AND (d.attempt_count <> 0 OR EXISTS (SELECT 1 FROM notification_delivery_attempts a
                                       WHERE a.notification_delivery_id = d.id));

SELECT '22 notification recipient user differs from email delivery user' AS check_name, COUNT(*) AS anomalies
FROM notification_deliveries d
JOIN notification_recipients r ON r.id = d.notification_recipient_id
WHERE d.user_id <> r.user_id;

SELECT '23 attempted delivery missing recipient snapshot' AS check_name, COUNT(*) AS anomalies
FROM notification_deliveries d
WHERE d.attempt_count > 0 AND (d.recipient_address IS NULL OR TRIM(d.recipient_address) = '');

SELECT '24 credential-like content in notification/email data' AS check_name, COUNT(*) AS anomalies
FROM (
  SELECT e.id
  FROM notification_events e
  WHERE LOWER(CONCAT_WS(' ', e.title, e.message, CAST(e.metadata_json AS CHAR)))
        REGEXP '(password[[:space:]_:=]|passwd[[:space:]_:=]|smtp[._[:space:]]+(password|secret)|api[._ -]?key[[:space:]_:=]|stack trace)'
  UNION
  SELECT d.id
  FROM notification_deliveries d
  WHERE LOWER(CONCAT_WS(' ', d.recipient_address, d.subject_snapshot, d.body_text_snapshot,
                         d.last_error_code, d.last_error_message))
        REGEXP '(password[[:space:]_:=]|passwd[[:space:]_:=]|smtp[._[:space:]]+(password|secret)|api[._ -]?key[[:space:]_:=]|stack trace)'
) x;

SELECT '25 database notification triggers' AS check_name, COUNT(*) AS anomalies
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA = DATABASE()
  AND EVENT_OBJECT_TABLE IN ('notification_events', 'notification_recipients',
                             'notification_deliveries', 'notification_delivery_attempts');

SELECT '26 current/post-fix recipient role and scope anomalies' AS check_name, COUNT(*) AS anomalies
FROM notification_events e
JOIN notification_recipients nr ON nr.notification_event_id = e.id
LEFT JOIN users u ON u.id = nr.user_id
LEFT JOIN user_roles ur ON ur.user_id = u.id
LEFT JOIN roles ro ON ro.id = ur.role_id AND ro.name = nr.recipient_role_code
LEFT JOIN repair_exception_cases re
  ON e.source_type = 'REPAIR_EXCEPTION' AND e.source_id REGEXP '^[0-9]+$'
 AND re.id = CAST(e.source_id AS UNSIGNED)
LEFT JOIN ticket_logistics_cases el ON el.id = e.logistics_case_id
LEFT JOIN repair_jobs ej ON ej.id = e.repair_job_id
LEFT JOIN ticket_logistics_cases rjl ON rjl.id = ej.logistics_case_id
LEFT JOIN tickets t ON t.id = COALESCE(e.ticket_id, re.ticket_id, el.ticket_id, rjl.ticket_id)
WHERE e.id >= 84 AND nr.recipient_role_code IS NOT NULL
  AND (
    u.id IS NULL OR ro.id IS NULL OR
    (nr.recipient_role_code IN ('SCHOOL_ADMINISTRATOR', 'ICT_TECHNICAL_OFFICER')
      AND NOT EXISTS (SELECT 1 FROM user_school_scopes s
                      WHERE s.user_id = nr.user_id AND s.school_id = t.origin_school_id AND s.status = 'active')) OR
    (nr.recipient_role_code = 'ICT_DISTRICT_COORDINATOR'
      AND NOT EXISTS (SELECT 1 FROM user_district_scopes s
                      WHERE s.user_id = nr.user_id AND s.district_id = t.origin_district_id AND s.status = 'active')) OR
    (nr.recipient_role_code = 'MOE_HEAD_OFFICE'
      AND NOT EXISTS (SELECT 1 FROM user_national_scopes s
                      WHERE s.user_id = nr.user_id AND s.status = 'active')) OR
    (nr.recipient_role_code = 'REPAIR_CENTRE'
      AND NOT EXISTS (SELECT 1 FROM user_service_location_scopes s
                      WHERE s.user_id = nr.user_id AND s.service_location_id =
                        COALESCE(el.repair_centre_location_id, rjl.repair_centre_location_id)
                        AND s.status = 'active'))
  );

SELECT '27 current/post-fix email fan-out missing delivery rows' AS check_name, COUNT(*) AS anomalies
FROM notification_events e
JOIN notification_recipients r ON r.notification_event_id = e.id
JOIN notification_channel_rules cr ON cr.event_type_code = e.event_type_code
                                    AND cr.channel_code = 'EMAIL' AND cr.is_enabled = 1
LEFT JOIN notification_deliveries d ON d.notification_recipient_id = r.id AND d.channel_code = 'EMAIL'
WHERE e.id >= 84 AND d.id IS NULL;

SELECT '28 current/post-fix repair completion/workflow integrity anomalies' AS check_name,
       (SELECT COUNT(*)
        FROM repair_jobs j
        JOIN repair_outcomes o ON o.id = j.outcome_id
        JOIN ticket_logistics_cases l ON l.id = j.logistics_case_id
        JOIN tickets t ON t.id = l.ticket_id
        JOIN ticket_statuses ts ON ts.id = t.current_status_id
        WHERE o.is_return_ready = 1 AND j.completed_at IS NOT NULL
          AND ts.code NOT IN ('COMPLETED', 'RETURNED') AND t.id <> 86)
       +
       (SELECT COUNT(*)
        FROM ticket_logistics_cases l
        JOIN logistics_statuses ls ON ls.id = l.current_status_id
        JOIN repair_jobs j ON j.logistics_case_id = l.id
        JOIN repair_outcomes o ON o.id = j.outcome_id
        WHERE ls.code = 'READY_FOR_RETURN'
          AND j.completed_at IS NULL
          AND l.ticket_id <> 86) AS anomalies;

-- Historical/pre-fix evidence is informational and intentionally not included
-- in current/post-fix anomaly counts.
SELECT 'Historical diagnostic: Event 83 pre-fix email fan-out' AS information,
       e.id AS event_id, e.event_type_code,
       (SELECT COUNT(*) FROM notification_recipients r WHERE r.notification_event_id = e.id) AS in_app_recipients,
       (SELECT COUNT(*) FROM notification_deliveries d
        JOIN notification_recipients r ON r.id = d.notification_recipient_id
        WHERE r.notification_event_id = e.id AND d.channel_code = 'EMAIL') AS email_deliveries,
       (SELECT COUNT(*) FROM notification_deliveries d
        JOIN notification_recipients r ON r.id = d.notification_recipient_id
        WHERE r.notification_event_id = e.id AND d.channel_code = 'EMAIL' AND d.status_code = 'SENT') AS sent
FROM notification_events e WHERE e.id = 83;

SELECT 'Accepted post-fix fan-out: Event 84' AS information,
       e.id AS event_id, e.event_type_code, t.ticket_number,
       (SELECT COUNT(*) FROM notification_recipients r WHERE r.notification_event_id = e.id) AS in_app_recipients,
       (SELECT COUNT(*) FROM notification_deliveries d
        JOIN notification_recipients r ON r.id = d.notification_recipient_id
        WHERE r.notification_event_id = e.id AND d.channel_code = 'EMAIL') AS email_deliveries,
       (SELECT COUNT(*) FROM notification_deliveries d
        JOIN notification_recipients r ON r.id = d.notification_recipient_id
        WHERE r.notification_event_id = e.id AND d.channel_code = 'EMAIL' AND d.status_code = 'SENT') AS sent
FROM notification_events e LEFT JOIN tickets t ON t.id = e.ticket_id WHERE e.id = 84;

SELECT 'Historical protected workflow diagnostics' AS information, t.ticket_number, t.device_id,
       l.logistics_number, j.id AS repair_job_id, ts.code AS ticket_status,
       ls.code AS logistics_status, j.completed_at, o.code AS repair_outcome
FROM tickets t
LEFT JOIN ticket_statuses ts ON ts.id = t.current_status_id
LEFT JOIN ticket_logistics_cases l ON l.ticket_id = t.id
LEFT JOIN logistics_statuses ls ON ls.id = l.current_status_id
LEFT JOIN repair_jobs j ON j.logistics_case_id = l.id
LEFT JOIN repair_outcomes o ON o.id = j.outcome_id
WHERE t.id IN (86, 79, 80, 81, 82, 83, 84, 85, 87, 89, 91)
ORDER BY t.id;
