-- Phase 9D-D read-only acceptance checks. MySQL 5.7 compatible; SELECT only.

-- 1. Required operational email rules are present and enabled (expected 0 missing).
SELECT required.event_type_code AS missing_email_rule
FROM (
  SELECT 'SLA_AT_RISK' AS event_type_code UNION ALL SELECT 'SLA_BREACHED' UNION ALL
  SELECT 'ESCALATION_RESOLVED' UNION ALL SELECT 'ESCALATION_CANCELLED' UNION ALL
  SELECT 'TICKET_SUBMITTED' UNION ALL SELECT 'TICKET_CLARIFICATION_REQUESTED' UNION ALL
  SELECT 'DISTRICT_APPROVAL_REQUIRED' UNION ALL SELECT 'TICKET_APPROVED_FOR_PICKUP' UNION ALL
  SELECT 'LOGISTICS_PICKUP_REQUESTED' UNION ALL SELECT 'LOGISTICS_SCHOOL_RELEASED' UNION ALL
  SELECT 'LOGISTICS_RECEIVED_BY_TTPOST' UNION ALL SELECT 'LOGISTICS_SENT_TO_REPAIR_CENTRE' UNION ALL
  SELECT 'LOGISTICS_RECEIVED_BY_REPAIR_CENTRE' UNION ALL SELECT 'LOGISTICS_READY_FOR_RETURN_PICKUP' UNION ALL
  SELECT 'LOGISTICS_RETURN_RECEIVED_BY_TTPOST' UNION ALL SELECT 'LOGISTICS_RETURN_IN_TRANSIT_TO_SCHOOL' UNION ALL
  SELECT 'LOGISTICS_RETURNED_TO_SCHOOL' UNION ALL SELECT 'REPAIR_STARTED' UNION ALL
  SELECT 'REPAIR_COMPLETED' UNION ALL SELECT 'DISTRICT_REPAIR_DECISION_REQUIRED' UNION ALL
  SELECT 'HEAD_OFFICE_REPLACEMENT_APPROVAL_REQUIRED'
) required
LEFT JOIN notification_channel_rules r ON r.event_type_code=required.event_type_code AND r.channel_code='EMAIL' AND r.is_enabled=1
WHERE r.id IS NULL;

-- 2. Delivery channel and status reference rows.
SELECT 'EMAIL_CHANNEL' AS check_name, COUNT(*) AS actual_count FROM notification_channels WHERE code='EMAIL'
UNION ALL SELECT 'DELIVERY_STATUSES', COUNT(*) FROM notification_delivery_statuses
UNION ALL SELECT 'ENABLED_EMAIL_RULES', COUNT(*) FROM notification_channel_rules WHERE channel_code='EMAIL' AND is_enabled=1;

-- 3. Duplicate recipient/channel deliveries (expected 0).
SELECT notification_recipient_id,channel_code,COUNT(*) AS duplicate_count
FROM notification_deliveries GROUP BY notification_recipient_id,channel_code HAVING COUNT(*)>1;

-- 4. Duplicate attempt numbers (expected 0).
SELECT notification_delivery_id,attempt_number,COUNT(*) AS duplicate_count
FROM notification_delivery_attempts GROUP BY notification_delivery_id,attempt_number HAVING COUNT(*)>1;

-- 5. SENT rows without sent_at (expected 0).
SELECT id,delivery_number,status_code,sent_at FROM notification_deliveries WHERE status_code='SENT' AND sent_at IS NULL;

-- 6. SENT rows without a successful attempt (expected 0).
SELECT d.id,d.delivery_number,d.status_code
FROM notification_deliveries d
LEFT JOIN notification_delivery_attempts a ON a.notification_delivery_id=d.id AND a.outcome_code='SENT'
WHERE d.status_code='SENT' AND a.id IS NULL;

-- 7. RETRY_PENDING without a due timestamp (expected 0).
SELECT id,delivery_number,status_code,next_attempt_at FROM notification_deliveries
WHERE status_code='RETRY_PENDING' AND next_attempt_at IS NULL;

-- 8. FAILED_PERMANENT still eligible for automatic processing (expected 0).
SELECT id,delivery_number,status_code,attempt_count,max_attempts,next_attempt_at FROM notification_deliveries
WHERE status_code='FAILED_PERMANENT' AND next_attempt_at IS NOT NULL AND next_attempt_at<=NOW(6);

-- 9. SKIPPED_NO_ADDRESS with an address or send attempt (expected 0).
SELECT d.id,d.delivery_number,d.recipient_address,d.status_code,d.attempt_count,COUNT(a.id) AS attempt_rows
FROM notification_deliveries d LEFT JOIN notification_delivery_attempts a ON a.notification_delivery_id=d.id
WHERE d.status_code='SKIPPED_NO_ADDRESS'
GROUP BY d.id,d.delivery_number,d.recipient_address,d.status_code,d.attempt_count
HAVING d.recipient_address IS NOT NULL OR d.attempt_count<>0 OR COUNT(a.id)<>0;

-- 10. Delivery identity must match its authoritative notification recipient (expected 0).
SELECT d.id,d.notification_event_id,d.notification_recipient_id,d.user_id,
       nr.notification_event_id AS recipient_event_id,nr.user_id AS recipient_user_id
FROM notification_deliveries d
LEFT JOIN notification_recipients nr ON nr.id=d.notification_recipient_id
WHERE nr.id IS NULL OR nr.notification_event_id<>d.notification_event_id OR nr.user_id<>d.user_id;

-- 11. Missing recipient or inactive/missing user anomalies (expected 0).
SELECT d.id,d.notification_recipient_id,d.user_id,u.status
FROM notification_deliveries d
LEFT JOIN notification_recipients nr ON nr.id=d.notification_recipient_id
LEFT JOIN users u ON u.id=d.user_id
WHERE nr.id IS NULL OR u.id IS NULL OR u.status<>'active';

-- 12. Unsafe action URLs (currently all action URL snapshots are intentionally NULL).
SELECT id,delivery_number,action_url_snapshot FROM notification_deliveries
WHERE action_url_snapshot IS NOT NULL
  AND (action_url_snapshot NOT LIKE '/%' OR action_url_snapshot LIKE '//%'
       OR LOWER(action_url_snapshot) LIKE '%javascript:%'
       OR LOWER(action_url_snapshot) LIKE '%data:%'
       OR LOWER(action_url_snapshot) LIKE '%http:%'
       OR LOWER(action_url_snapshot) LIKE '%https:%');

-- 13. Credential-like delivery columns (expected no rows).
SELECT table_name,column_name FROM information_schema.columns
WHERE table_schema=DATABASE()
  AND table_name IN ('notification_deliveries','notification_delivery_attempts')
  AND (LOWER(column_name) LIKE '%password%' OR LOWER(column_name) LIKE '%credential%'
       OR LOWER(column_name) LIKE '%secret%' OR LOWER(column_name) LIKE '%smtp%');

-- 14. Protected Phase 9D-A/B/C event fixture counts, informational; no email backfill is expected.
SELECT e.id,e.event_type_code,e.idempotency_key,COUNT(d.id) AS email_deliveries
FROM notification_events e
LEFT JOIN notification_recipients nr ON nr.notification_event_id=e.id
LEFT JOIN notification_deliveries d ON d.notification_recipient_id=nr.id AND d.channel_code='EMAIL'
WHERE e.id IN (7,8)
   OR e.idempotency_key IN ('SLA:9:AT_RISK','SLA:9:BREACHED','ESCALATION:4:RESOLVED')
   OR e.ticket_id IN (76,88,90)
GROUP BY e.id,e.event_type_code,e.idempotency_key
ORDER BY e.id;

-- 15. Database trigger count (expected 0).
SELECT COUNT(*) AS notification_delivery_trigger_count
FROM information_schema.triggers
WHERE trigger_schema=DATABASE()
  AND event_object_table IN ('notification_events','notification_recipients','notification_deliveries','notification_delivery_attempts');
