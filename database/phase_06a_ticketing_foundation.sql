-- Phase 6A ticketing data foundation.
-- Safe to re-run: tables are created only when absent, status seeds are
-- inserted only when absent, and the read model is replaced in place.

CREATE TABLE IF NOT EXISTS ticket_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  code VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  name VARCHAR(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  description VARCHAR(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  sort_order SMALLINT UNSIGNED NOT NULL,
  is_terminal TINYINT(1) NOT NULL DEFAULT 0,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_ticket_statuses_code (code),
  KEY idx_ticket_statuses_active_sort (is_active, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO ticket_statuses
  (code, name, description, sort_order, is_terminal, is_active)
VALUES
  ('SUBMITTED', 'Submitted', 'Ticket submitted for school review.', 10, 0, 1),
  ('NEEDS_CLARIFICATION', 'Needs Clarification', 'Additional information is required.', 20, 0, 1),
  ('APPROVED_FOR_PICKUP', 'Approved for Pickup', 'Approved to proceed to the pickup workflow.', 30, 0, 1),
  ('IN_TRANSIT', 'In Transit', 'Device is in an authorized transit stage.', 40, 0, 1),
  ('UNDER_REPAIR', 'Under Repair', 'Device is undergoing repair.', 50, 0, 1),
  ('COMPLETED', 'Completed', 'Repair or support work is complete; physical return may remain.', 60, 0, 1),
  ('RETURNED', 'Returned', 'Device has been returned and the ticket process is terminal.', 70, 1, 1),
  ('CANCELLED', 'Cancelled', 'Ticket was cancelled.', 80, 1, 1);

CREATE TABLE IF NOT EXISTS tickets (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  ticket_number VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  device_id INT UNSIGNED NOT NULL,
  origin_district_id INT UNSIGNED DEFAULT NULL,
  origin_school_id INT UNSIGNED DEFAULT NULL,
  origin_student_id INT UNSIGNED DEFAULT NULL,
  requester_type VARCHAR(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  requester_name VARCHAR(220) COLLATE utf8mb4_unicode_ci NOT NULL,
  requester_email VARCHAR(254) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  requester_phone VARCHAR(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  subject VARCHAR(220) COLLATE utf8mb4_unicode_ci NOT NULL,
  description TEXT COLLATE utf8mb4_unicode_ci NOT NULL,
  current_status_id INT UNSIGNED NOT NULL,
  created_by_user_id INT UNSIGNED DEFAULT NULL,
  updated_by_user_id INT UNSIGNED DEFAULT NULL,
  submitted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  closed_at DATETIME DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_tickets_ticket_number (ticket_number),
  KEY idx_tickets_device (device_id),
  KEY idx_tickets_current_status (current_status_id),
  KEY idx_tickets_origin_district (origin_district_id),
  KEY idx_tickets_origin_school (origin_school_id),
  KEY idx_tickets_origin_student (origin_student_id),
  KEY idx_tickets_submitted_at (submitted_at),
  KEY idx_tickets_created_at (created_at),
  KEY idx_tickets_created_by (created_by_user_id),
  KEY idx_tickets_updated_by (updated_by_user_id),
  CONSTRAINT fk_tickets_device FOREIGN KEY (device_id) REFERENCES devices (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_tickets_origin_district FOREIGN KEY (origin_district_id) REFERENCES districts (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_tickets_origin_school FOREIGN KEY (origin_school_id) REFERENCES schools (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_tickets_origin_student FOREIGN KEY (origin_student_id) REFERENCES students (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_tickets_current_status FOREIGN KEY (current_status_id) REFERENCES ticket_statuses (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_tickets_created_by FOREIGN KEY (created_by_user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_tickets_updated_by FOREIGN KEY (updated_by_user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS ticket_status_history (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  ticket_id INT UNSIGNED NOT NULL,
  from_status_id INT UNSIGNED DEFAULT NULL,
  to_status_id INT UNSIGNED NOT NULL,
  changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  changed_by_user_id INT UNSIGNED DEFAULT NULL,
  reason VARCHAR(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  comment TEXT COLLATE utf8mb4_unicode_ci,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_ticket_status_history_ticket_changed (ticket_id, changed_at),
  KEY idx_ticket_status_history_from_status (from_status_id),
  KEY idx_ticket_status_history_to_status (to_status_id),
  KEY idx_ticket_status_history_changed_by (changed_by_user_id),
  CONSTRAINT fk_ticket_status_history_ticket FOREIGN KEY (ticket_id) REFERENCES tickets (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_ticket_status_history_from_status FOREIGN KEY (from_status_id) REFERENCES ticket_statuses (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_ticket_status_history_to_status FOREIGN KEY (to_status_id) REFERENCES ticket_statuses (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_ticket_status_history_changed_by FOREIGN KEY (changed_by_user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS ticket_assignments (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  ticket_id INT UNSIGNED NOT NULL,
  assigned_to_user_id INT UNSIGNED NOT NULL,
  assigned_by_user_id INT UNSIGNED NOT NULL,
  assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ended_at DATETIME DEFAULT NULL,
  ended_by_user_id INT UNSIGNED DEFAULT NULL,
  end_reason VARCHAR(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  active_record_key TINYINT UNSIGNED DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_ticket_assignments_active (ticket_id, active_record_key),
  KEY idx_ticket_assignments_assignee_active (assigned_to_user_id, active_record_key),
  KEY idx_ticket_assignments_assigned_at (assigned_at),
  KEY idx_ticket_assignments_ended_at (ended_at),
  KEY idx_ticket_assignments_assigned_by (assigned_by_user_id),
  KEY idx_ticket_assignments_ended_by (ended_by_user_id),
  CONSTRAINT fk_ticket_assignments_ticket FOREIGN KEY (ticket_id) REFERENCES tickets (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_ticket_assignments_assigned_to FOREIGN KEY (assigned_to_user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_ticket_assignments_assigned_by FOREIGN KEY (assigned_by_user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_ticket_assignments_ended_by FOREIGN KEY (ended_by_user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS ticket_comments (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  ticket_id INT UNSIGNED NOT NULL,
  comment_type VARCHAR(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  comment_text TEXT COLLATE utf8mb4_unicode_ci NOT NULL,
  created_by_user_id INT UNSIGNED DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  is_internal TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  KEY idx_ticket_comments_ticket_created (ticket_id, created_at),
  KEY idx_ticket_comments_created_by (created_by_user_id),
  CONSTRAINT fk_ticket_comments_ticket FOREIGN KEY (ticket_id) REFERENCES tickets (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_ticket_comments_created_by FOREIGN KEY (created_by_user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS ticket_diagnoses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  ticket_id INT UNSIGNED NOT NULL,
  diagnosis_summary TEXT COLLATE utf8mb4_unicode_ci NOT NULL,
  recommended_action VARCHAR(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  diagnosed_by_user_id INT UNSIGNED NOT NULL,
  diagnosed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_ticket_diagnoses_ticket_diagnosed (ticket_id, diagnosed_at),
  KEY idx_ticket_diagnoses_diagnosed_by (diagnosed_by_user_id),
  CONSTRAINT fk_ticket_diagnoses_ticket FOREIGN KEY (ticket_id) REFERENCES tickets (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_ticket_diagnoses_diagnosed_by FOREIGN KEY (diagnosed_by_user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_ticket_current_context AS
SELECT
  t.id AS ticket_id,
  t.ticket_number,
  t.device_id,
  d.serial_number,
  d.asset_tag,
  t.current_status_id,
  ts.code AS current_status_code,
  ts.name AS current_status_name,
  t.origin_district_id,
  t.origin_school_id,
  t.origin_student_id,
  t.requester_type,
  ta.id AS active_assignment_id,
  ta.assigned_to_user_id,
  t.submitted_at,
  t.closed_at
FROM tickets t
INNER JOIN devices d ON d.id = t.device_id
INNER JOIN ticket_statuses ts ON ts.id = t.current_status_id
LEFT JOIN ticket_assignments ta
  ON ta.ticket_id = t.id
  AND ta.active_record_key = 1;
