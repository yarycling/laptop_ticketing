-- Phase 9D-A notification foundation. No workflow event hooks are installed.
CREATE TABLE IF NOT EXISTS notification_event_types (
  code VARCHAR(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  name VARCHAR(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS notification_severities (
  code VARCHAR(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  name VARCHAR(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  sort_order TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS notification_events (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  idempotency_key VARCHAR(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  event_type_code VARCHAR(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  source_type VARCHAR(60) COLLATE utf8mb4_unicode_ci NULL,
  source_id VARCHAR(100) COLLATE utf8mb4_unicode_ci NULL,
  ticket_id INT UNSIGNED NULL,
  sla_instance_id BIGINT UNSIGNED NULL,
  escalation_case_id BIGINT UNSIGNED NULL,
  logistics_case_id INT UNSIGNED NULL,
  repair_job_id INT UNSIGNED NULL,
  temporary_loan_case_id BIGINT UNSIGNED NULL,
  permanent_replacement_case_id BIGINT UNSIGNED NULL,
  severity_code VARCHAR(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  title VARCHAR(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  message VARCHAR(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  action_type VARCHAR(40) COLLATE utf8mb4_unicode_ci NULL,
  action_reference VARCHAR(120) COLLATE utf8mb4_unicode_ci NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  created_by INT UNSIGNED NULL,
  metadata_json JSON NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_notification_event_idempotency (idempotency_key),
  KEY idx_notification_event_created (created_at, id),
  KEY idx_notification_event_ticket (ticket_id, created_at),
  KEY idx_notification_event_source (source_type, source_id),
  CONSTRAINT fk_notification_event_type FOREIGN KEY (event_type_code) REFERENCES notification_event_types(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_notification_event_severity FOREIGN KEY (severity_code) REFERENCES notification_severities(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_notification_event_ticket FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_notification_event_creator FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS notification_recipients (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  notification_event_id BIGINT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  recipient_role_code VARCHAR(100) COLLATE utf8mb4_unicode_ci NULL,
  delivered_in_app_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  read_at DATETIME(6) NULL,
  read_by INT UNSIGNED NULL,
  archived_at DATETIME(6) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_notification_recipient_event_user (notification_event_id, user_id),
  KEY idx_notification_recipient_inbox (user_id, read_at, archived_at, notification_event_id),
  CONSTRAINT fk_notification_recipient_event FOREIGN KEY (notification_event_id) REFERENCES notification_events(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_notification_recipient_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_notification_recipient_reader FOREIGN KEY (read_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO notification_event_types (code,name) VALUES
 ('SYSTEM_INFORMATION','System information'),
 ('SYSTEM_WARNING','System warning'),
 ('TEST_NOTIFICATION','Test notification');


INSERT IGNORE INTO notification_severities (code,name,sort_order) VALUES
 ('INFO','Information',10),('SUCCESS','Success',20),('WARNING','Warning',30),('CRITICAL','Critical',40);

INSERT IGNORE INTO permissions (name,label,module) VALUES
 ('notifications.view','View Own Notifications','notifications'),
 ('notifications.respond','Manage Own Notification Read State','notifications'),
 ('notifications.manage','Manage Notifications','notifications');

INSERT IGNORE INTO role_permissions (role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p
WHERE (r.name='SUPER_ADMIN' AND p.name IN ('notifications.view','notifications.respond','notifications.manage'))
   OR (r.name='MOE_HEAD_OFFICE' AND p.name IN ('notifications.view','notifications.respond','notifications.manage'))
   OR (r.name IN ('ICT_DISTRICT_COORDINATOR','ICT_TECHNICAL_OFFICER','SCHOOL_ADMINISTRATOR','REPAIR_CENTRE','TTPOST_LOGISTICS','TSTT_OVERSIGHT') AND p.name IN ('notifications.view','notifications.respond'));

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_notification_inbox AS
SELECT nr.id AS recipient_id, nr.notification_event_id, nr.user_id,
  nr.recipient_role_code, nr.delivered_in_app_at, nr.read_at, nr.read_by,
  nr.archived_at, IF(nr.read_at IS NULL,0,1) AS read_state,
  e.idempotency_key, e.event_type_code, et.name AS event_type_name,
  e.source_type, e.source_id, e.ticket_id, t.ticket_number, e.sla_instance_id,
  e.escalation_case_id, e.logistics_case_id, e.repair_job_id,
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
LEFT JOIN users creator ON creator.id=e.created_by;

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_notification_unread_recipients AS
SELECT id, notification_event_id, user_id, read_at, read_by, archived_at
FROM notification_recipients
WHERE read_at IS NULL AND archived_at IS NULL;
