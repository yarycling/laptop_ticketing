-- Phase 7A logistics data foundation.
-- Safe to re-run: tables use IF NOT EXISTS, catalogue rows use INSERT IGNORE,
-- and the read model is replaced in place.

CREATE TABLE IF NOT EXISTS logistics_statuses (
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
  UNIQUE KEY uq_logistics_statuses_code (code),
  KEY idx_logistics_statuses_active_sort (is_active, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO logistics_statuses
  (code, name, description, sort_order, is_terminal, is_active)
VALUES
  ('REQUESTED', 'Requested', 'Logistics case created and awaiting TTPost processing.', 10, 0, 1),
  ('ACCEPTED', 'Accepted', 'TTPost accepted processing responsibility; physical possession is not implied.', 20, 0, 1),
  ('OUTBOUND_IN_TRANSIT', 'Outbound In Transit', 'Device entered the physical transport chain toward the Repair Centre.', 30, 0, 1),
  ('AT_REPAIR_CENTRE', 'At Repair Centre', 'Device was physically received by the Repair Centre.', 40, 0, 1),
  ('READY_FOR_RETURN', 'Ready for Return', 'Repair workflow is ready for logistics return to begin.', 50, 0, 1),
  ('RETURN_IN_TRANSIT', 'Return In Transit', 'Device is moving from the Repair Centre toward the School.', 60, 0, 1),
  ('RETURNED_TO_SCHOOL', 'Returned to School', 'Physical logistics cycle completed at School.', 70, 1, 1),
  ('CANCELLED', 'Cancelled', 'Logistics case cancelled before normal completion.', 80, 1, 1);

CREATE TABLE IF NOT EXISTS service_locations (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  location_type VARCHAR(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  code VARCHAR(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  name VARCHAR(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_service_locations_code (code),
  KEY idx_service_locations_type_active (location_type, is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS ticket_logistics_cases (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  logistics_number VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  ticket_id INT UNSIGNED NOT NULL,
  device_id INT UNSIGNED NOT NULL,
  pickup_school_id INT UNSIGNED NOT NULL,
  repair_centre_location_id INT UNSIGNED DEFAULT NULL,
  current_status_id INT UNSIGNED NOT NULL,
  requested_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  closed_at DATETIME(6) DEFAULT NULL,
  closed_by_user_id INT UNSIGNED DEFAULT NULL,
  close_reason VARCHAR(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  created_by_user_id INT UNSIGNED NOT NULL,
  updated_by_user_id INT UNSIGNED DEFAULT NULL,
  active_record_key TINYINT UNSIGNED DEFAULT 1,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_ticket_logistics_cases_number (logistics_number),
  UNIQUE KEY uq_ticket_logistics_cases_ticket_active (ticket_id, active_record_key),
  UNIQUE KEY uq_ticket_logistics_cases_device_active (device_id, active_record_key),
  KEY idx_ticket_logistics_cases_current_status (current_status_id),
  KEY idx_ticket_logistics_cases_pickup_school (pickup_school_id),
  KEY idx_ticket_logistics_cases_repair_location (repair_centre_location_id),
  KEY idx_ticket_logistics_cases_requested_at (requested_at),
  KEY idx_ticket_logistics_cases_created_by (created_by_user_id),
  KEY idx_ticket_logistics_cases_updated_by (updated_by_user_id),
  KEY idx_ticket_logistics_cases_closed_by (closed_by_user_id),
  CONSTRAINT fk_ticket_logistics_cases_ticket FOREIGN KEY (ticket_id) REFERENCES tickets (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_ticket_logistics_cases_device FOREIGN KEY (device_id) REFERENCES devices (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_ticket_logistics_cases_pickup_school FOREIGN KEY (pickup_school_id) REFERENCES schools (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_ticket_logistics_cases_repair_location FOREIGN KEY (repair_centre_location_id) REFERENCES service_locations (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_ticket_logistics_cases_current_status FOREIGN KEY (current_status_id) REFERENCES logistics_statuses (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_ticket_logistics_cases_closed_by FOREIGN KEY (closed_by_user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_ticket_logistics_cases_created_by FOREIGN KEY (created_by_user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_ticket_logistics_cases_updated_by FOREIGN KEY (updated_by_user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS logistics_status_history (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  logistics_case_id INT UNSIGNED NOT NULL,
  from_status_id INT UNSIGNED DEFAULT NULL,
  to_status_id INT UNSIGNED NOT NULL,
  changed_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  changed_by_user_id INT UNSIGNED DEFAULT NULL,
  reason VARCHAR(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  comment TEXT COLLATE utf8mb4_unicode_ci,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  KEY idx_logistics_status_history_case_changed (logistics_case_id, changed_at),
  KEY idx_logistics_status_history_to_status (to_status_id),
  KEY idx_logistics_status_history_changed_by (changed_by_user_id),
  CONSTRAINT fk_logistics_status_history_case FOREIGN KEY (logistics_case_id) REFERENCES ticket_logistics_cases (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_logistics_status_history_from FOREIGN KEY (from_status_id) REFERENCES logistics_statuses (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_logistics_status_history_to FOREIGN KEY (to_status_id) REFERENCES logistics_statuses (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_logistics_status_history_actor FOREIGN KEY (changed_by_user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS logistics_handoffs (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  logistics_case_id INT UNSIGNED NOT NULL,
  handoff_type VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  from_school_id INT UNSIGNED DEFAULT NULL,
  from_service_location_id INT UNSIGNED DEFAULT NULL,
  to_school_id INT UNSIGNED DEFAULT NULL,
  to_service_location_id INT UNSIGNED DEFAULT NULL,
  dispatched_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  dispatched_by_user_id INT UNSIGNED NOT NULL,
  received_at DATETIME(6) DEFAULT NULL,
  received_by_user_id INT UNSIGNED DEFAULT NULL,
  tracking_reference VARCHAR(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  notes TEXT COLLATE utf8mb4_unicode_ci,
  active_record_key TINYINT UNSIGNED DEFAULT 1,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_logistics_handoffs_case_pending (logistics_case_id, active_record_key),
  KEY idx_logistics_handoffs_case_dispatched (logistics_case_id, dispatched_at),
  KEY idx_logistics_handoffs_from_school (from_school_id),
  KEY idx_logistics_handoffs_to_school (to_school_id),
  KEY idx_logistics_handoffs_from_location (from_service_location_id),
  KEY idx_logistics_handoffs_to_location (to_service_location_id),
  KEY idx_logistics_handoffs_received_at (received_at),
  KEY idx_logistics_handoffs_dispatched_by (dispatched_by_user_id),
  KEY idx_logistics_handoffs_received_by (received_by_user_id),
  CONSTRAINT fk_logistics_handoffs_case FOREIGN KEY (logistics_case_id) REFERENCES ticket_logistics_cases (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_logistics_handoffs_from_school FOREIGN KEY (from_school_id) REFERENCES schools (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_logistics_handoffs_from_location FOREIGN KEY (from_service_location_id) REFERENCES service_locations (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_logistics_handoffs_to_school FOREIGN KEY (to_school_id) REFERENCES schools (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_logistics_handoffs_to_location FOREIGN KEY (to_service_location_id) REFERENCES service_locations (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_logistics_handoffs_dispatched_by FOREIGN KEY (dispatched_by_user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_logistics_handoffs_received_by FOREIGN KEY (received_by_user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS logistics_handoff_scans (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  logistics_handoff_id INT UNSIGNED NOT NULL,
  scan_type VARCHAR(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  scan_method VARCHAR(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  scan_reference VARCHAR(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  scanned_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  scanned_by_user_id INT UNSIGNED NOT NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  KEY idx_logistics_handoff_scans_handoff_scanned (logistics_handoff_id, scanned_at),
  KEY idx_logistics_handoff_scans_scanned_by (scanned_by_user_id),
  CONSTRAINT fk_logistics_handoff_scans_handoff FOREIGN KEY (logistics_handoff_id) REFERENCES logistics_handoffs (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_logistics_handoff_scans_actor FOREIGN KEY (scanned_by_user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_logistics_current_context AS
SELECT
  lc.id AS logistics_case_id,
  lc.logistics_number,
  t.id AS ticket_id,
  t.ticket_number,
  d.id AS device_id,
  d.serial_number,
  d.asset_tag,
  lc.pickup_school_id,
  pickup_school.name AS pickup_school_name,
  pickup_school.district_id AS pickup_district_id,
  pickup_district.name AS pickup_district_name,
  lc.repair_centre_location_id,
  repair_location.name AS repair_centre_name,
  lc.current_status_id AS current_logistics_status_id,
  logistics_status.code AS current_logistics_status_code,
  logistics_status.name AS current_logistics_status_name,
  lc.requested_at,
  lc.closed_at,
  lc.active_record_key,
  (lc.active_record_key = 1 AND lc.closed_at IS NULL) AS is_active,
  pending_handoff.id AS pending_handoff_id,
  pending_handoff.handoff_type AS pending_handoff_type,
  pending_handoff.dispatched_at AS pending_handoff_dispatched_at,
  t.current_status_id AS ticket_current_status_id,
  ticket_status.code AS ticket_current_status_code,
  allocation.current_custody_level AS allocation_custody_level,
  allocation.district_id AS allocation_district_id,
  allocation.school_id AS allocation_school_id,
  allocation.student_id AS allocation_student_id
FROM ticket_logistics_cases lc
INNER JOIN tickets t ON t.id = lc.ticket_id
INNER JOIN devices d ON d.id = lc.device_id
INNER JOIN schools pickup_school ON pickup_school.id = lc.pickup_school_id
INNER JOIN districts pickup_district ON pickup_district.id = pickup_school.district_id
LEFT JOIN service_locations repair_location ON repair_location.id = lc.repair_centre_location_id
INNER JOIN logistics_statuses logistics_status ON logistics_status.id = lc.current_status_id
INNER JOIN ticket_statuses ticket_status ON ticket_status.id = t.current_status_id
LEFT JOIN logistics_handoffs pending_handoff
  ON pending_handoff.logistics_case_id = lc.id
  AND pending_handoff.active_record_key = 1
LEFT JOIN v_device_current_custody allocation ON allocation.device_id = lc.device_id;
