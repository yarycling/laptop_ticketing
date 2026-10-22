-- Phase 9D-D email delivery and bounded retry model. Apply once after 9D-C.
-- Delivery state is independent of notification_recipients.read_at.
CREATE TABLE IF NOT EXISTS notification_channels (
  code VARCHAR(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  name VARCHAR(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS notification_delivery_statuses (
  code VARCHAR(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  name VARCHAR(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  is_terminal TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS notification_channel_rules (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  event_type_code VARCHAR(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  channel_code VARCHAR(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  is_enabled TINYINT(1) NOT NULL DEFAULT 0,
  max_attempts TINYINT UNSIGNED NOT NULL DEFAULT 3,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_notification_channel_rule (event_type_code, channel_code),
  CONSTRAINT fk_notification_channel_rule_event FOREIGN KEY (event_type_code) REFERENCES notification_event_types(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_notification_channel_rule_channel FOREIGN KEY (channel_code) REFERENCES notification_channels(code) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS notification_deliveries (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  delivery_number VARCHAR(32) COLLATE utf8mb4_unicode_ci NULL,
  notification_event_id BIGINT UNSIGNED NOT NULL,
  notification_recipient_id BIGINT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  channel_code VARCHAR(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  recipient_address VARCHAR(254) COLLATE utf8mb4_unicode_ci NULL,
  recipient_name VARCHAR(220) COLLATE utf8mb4_unicode_ci NULL,
  subject_snapshot VARCHAR(220) COLLATE utf8mb4_unicode_ci NOT NULL,
  body_text_snapshot TEXT COLLATE utf8mb4_unicode_ci NOT NULL,
  body_html_snapshot MEDIUMTEXT COLLATE utf8mb4_unicode_ci NULL,
  action_url_snapshot VARCHAR(500) COLLATE utf8mb4_unicode_ci NULL,
  status_code VARCHAR(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  attempt_count TINYINT UNSIGNED NOT NULL DEFAULT 0,
  max_attempts TINYINT UNSIGNED NOT NULL DEFAULT 3,
  next_attempt_at DATETIME(6) NULL,
  last_attempt_at DATETIME(6) NULL,
  sent_at DATETIME(6) NULL,
  processing_started_at DATETIME(6) NULL,
  processing_token VARCHAR(96) COLLATE utf8mb4_unicode_ci NULL,
  last_error_code VARCHAR(64) COLLATE utf8mb4_unicode_ci NULL,
  last_error_message VARCHAR(500) COLLATE utf8mb4_unicode_ci NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_notification_delivery_number (delivery_number),
  UNIQUE KEY uq_notification_delivery_recipient_channel (notification_recipient_id, channel_code),
  KEY idx_notification_delivery_due (status_code, next_attempt_at, id),
  KEY idx_notification_delivery_event (notification_event_id, id),
  KEY idx_notification_delivery_user (user_id, created_at),
  KEY idx_notification_delivery_processing (status_code, processing_started_at),
  CONSTRAINT fk_notification_delivery_event FOREIGN KEY (notification_event_id) REFERENCES notification_events(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_notification_delivery_recipient FOREIGN KEY (notification_recipient_id) REFERENCES notification_recipients(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_notification_delivery_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_notification_delivery_channel FOREIGN KEY (channel_code) REFERENCES notification_channels(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_notification_delivery_status FOREIGN KEY (status_code) REFERENCES notification_delivery_statuses(code) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS notification_delivery_attempts (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  notification_delivery_id BIGINT UNSIGNED NOT NULL,
  attempt_number TINYINT UNSIGNED NOT NULL,
  attempted_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  outcome_code VARCHAR(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  error_code VARCHAR(64) COLLATE utf8mb4_unicode_ci NULL,
  error_message VARCHAR(500) COLLATE utf8mb4_unicode_ci NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_notification_delivery_attempt_number (notification_delivery_id, attempt_number),
  KEY idx_notification_delivery_attempted (attempted_at, notification_delivery_id),
  CONSTRAINT fk_notification_delivery_attempt_delivery FOREIGN KEY (notification_delivery_id) REFERENCES notification_deliveries(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO notification_channels (code, name) VALUES ('EMAIL','Email');

INSERT IGNORE INTO notification_delivery_statuses (code, name, is_terminal) VALUES
 ('PENDING','Pending',0),
 ('PROCESSING','Processing',0),
 ('SENT','Sent',1),
 ('RETRY_PENDING','Retry pending',0),
 ('FAILED_PERMANENT','Failed permanently',1),
 ('SKIPPED_NO_ADDRESS','Skipped: no address',1),
 ('SKIPPED_INVALID_ADDRESS','Skipped: invalid address',1);

INSERT INTO notification_channel_rules (event_type_code, channel_code, is_enabled, max_attempts)
SELECT event_type_code, 'EMAIL', 1, 3 FROM (
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
) AS operational_events
ON DUPLICATE KEY UPDATE is_enabled=VALUES(is_enabled), max_attempts=VALUES(max_attempts);

-- notifications.manage was granted to the relevant admin roles in 9D-A.
-- No triggers are introduced by this migration.
