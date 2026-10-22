-- Phase 8B manufacturer return/RMA domain. Re-runnable reference seeds and tables.
INSERT IGNORE INTO exception_case_statuses (code, name, sort_order) VALUES
 ('MANUFACTURER_RETURN_IN_PROGRESS','Manufacturer Return In Progress',75),
 ('MANUFACTURER_RETURN_COMPLETED','Manufacturer Return Completed',80);

CREATE TABLE IF NOT EXISTS manufacturer_return_statuses (
  code VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  name VARCHAR(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  sort_order SMALLINT UNSIGNED NOT NULL,
  is_terminal TINYINT(1) NOT NULL DEFAULT 0,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (code), KEY idx_mfr_status_active_sort (is_active, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO manufacturer_return_statuses (code,name,sort_order,is_terminal) VALUES
 ('PREPARATION_REQUIRED','Preparation Required',10,0),
 ('AWAITING_OUTBOUND_CARRIER_PICKUP','Awaiting Outbound Carrier Pickup',20,0),
 ('OUTBOUND_IN_TRANSIT','Outbound In Transit',30,0),
 ('AT_MANUFACTURER','At Manufacturer',40,0),
 ('AWAITING_RETURN_CARRIER_PICKUP','Awaiting Return Carrier Pickup',50,0),
 ('RETURN_IN_TRANSIT','Return In Transit',60,0),
 ('COMPLETED','Completed',70,1);

CREATE TABLE IF NOT EXISTS manufacturer_return_cases (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  manufacturer_return_number VARCHAR(32) COLLATE utf8mb4_unicode_ci NULL,
  exception_case_id INT UNSIGNED NOT NULL,
  ticket_id INT UNSIGNED NOT NULL,
  logistics_case_id INT UNSIGNED NOT NULL,
  repair_job_id INT UNSIGNED NOT NULL,
  original_device_id INT UNSIGNED NOT NULL,
  manufacturer_id INT UNSIGNED NOT NULL,
  repair_centre_location_id INT UNSIGNED NOT NULL,
  current_status_code VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  rma_number VARCHAR(180) COLLATE utf8mb4_unicode_ci NULL,
  manufacturer_case_reference VARCHAR(180) COLLATE utf8mb4_unicode_ci NULL,
  warranty_reference VARCHAR(180) COLLATE utf8mb4_unicode_ci NULL,
  expected_return_date DATE NULL,
  started_by INT UNSIGNED NOT NULL,
  started_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  closed_by INT UNSIGNED NULL,
  closed_at DATETIME(6) NULL,
  active_record_key TINYINT UNSIGNED NULL DEFAULT 1,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_mfr_return_number (manufacturer_return_number),
  UNIQUE KEY uq_mfr_return_case_active (exception_case_id, active_record_key),
  KEY idx_mfr_return_ticket (ticket_id, started_at),
  KEY idx_mfr_return_status (current_status_code, updated_at),
  KEY idx_mfr_return_location (repair_centre_location_id, current_status_code),
  CONSTRAINT fk_mfr_case_exception FOREIGN KEY (exception_case_id) REFERENCES repair_exception_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_mfr_case_ticket FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_mfr_case_logistics FOREIGN KEY (logistics_case_id) REFERENCES ticket_logistics_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_mfr_case_job FOREIGN KEY (repair_job_id) REFERENCES repair_jobs(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_mfr_case_device FOREIGN KEY (original_device_id) REFERENCES devices(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_mfr_case_manufacturer FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_mfr_case_location FOREIGN KEY (repair_centre_location_id) REFERENCES service_locations(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_mfr_case_status FOREIGN KEY (current_status_code) REFERENCES manufacturer_return_statuses(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_mfr_case_started_by FOREIGN KEY (started_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_mfr_case_closed_by FOREIGN KEY (closed_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS manufacturer_return_status_history (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  manufacturer_return_case_id INT UNSIGNED NOT NULL,
  from_status_code VARCHAR(50) COLLATE utf8mb4_unicode_ci NULL,
  to_status_code VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  actor_user_id INT UNSIGNED NOT NULL,
  reason VARCHAR(1000) COLLATE utf8mb4_unicode_ci NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id), KEY idx_mfr_status_history_case_time (manufacturer_return_case_id,created_at,id),
  CONSTRAINT fk_mfr_history_case FOREIGN KEY (manufacturer_return_case_id) REFERENCES manufacturer_return_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_mfr_history_from FOREIGN KEY (from_status_code) REFERENCES manufacturer_return_statuses(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_mfr_history_to FOREIGN KEY (to_status_code) REFERENCES manufacturer_return_statuses(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_mfr_history_actor FOREIGN KEY (actor_user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS manufacturer_return_shipments (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  manufacturer_return_case_id INT UNSIGNED NOT NULL,
  direction VARCHAR(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  carrier_id INT UNSIGNED NOT NULL,
  tracking_reference VARCHAR(180) COLLATE utf8mb4_unicode_ci NULL,
  shipment_reference VARCHAR(180) COLLATE utf8mb4_unicode_ci NULL,
  prepared_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  prepared_by_user_id INT UNSIGNED NOT NULL,
  carrier_pickup_at DATETIME(6) NULL,
  carrier_pickup_by_user_id INT UNSIGNED NULL,
  destination_received_at DATETIME(6) NULL,
  destination_received_by_user_id INT UNSIGNED NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id), UNIQUE KEY uq_mfr_shipment_direction (manufacturer_return_case_id,direction),
  KEY idx_mfr_shipment_carrier_pickup (carrier_id,direction,carrier_pickup_at),
  CONSTRAINT chk_mfr_shipment_direction CHECK (direction IN ('OUTBOUND','RETURN')),
  CONSTRAINT fk_mfr_shipment_case FOREIGN KEY (manufacturer_return_case_id) REFERENCES manufacturer_return_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_mfr_shipment_carrier FOREIGN KEY (carrier_id) REFERENCES carriers(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_mfr_shipment_prepared_by FOREIGN KEY (prepared_by_user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_mfr_shipment_pickup_by FOREIGN KEY (carrier_pickup_by_user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_mfr_shipment_received_by FOREIGN KEY (destination_received_by_user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS manufacturer_return_outcomes (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  manufacturer_return_case_id INT UNSIGNED NOT NULL,
  outcome_code VARCHAR(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  outcome_date DATE NOT NULL,
  manufacturer_resolution_reference VARCHAR(180) COLLATE utf8mb4_unicode_ci NULL,
  reason VARCHAR(1000) COLLATE utf8mb4_unicode_ci NULL,
  notes VARCHAR(4000) COLLATE utf8mb4_unicode_ci NULL,
  created_by INT UNSIGNED NOT NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id), KEY idx_mfr_outcome_case_time (manufacturer_return_case_id,created_at,id),
  CONSTRAINT chk_mfr_outcome_code CHECK (outcome_code IN ('REPAIRED_ORIGINAL','REPLACEMENT_SUPPLIED','WARRANTY_REJECTED','BEYOND_ECONOMICAL_REPAIR')),
  CONSTRAINT fk_mfr_outcome_case FOREIGN KEY (manufacturer_return_case_id) REFERENCES manufacturer_return_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_mfr_outcome_actor FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS manufacturer_supplied_units (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  manufacturer_return_case_id INT UNSIGNED NOT NULL,
  manufacturer_return_outcome_id BIGINT UNSIGNED NOT NULL,
  manufacturer_id INT UNSIGNED NOT NULL,
  serial_number VARCHAR(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  normalized_serial_number VARCHAR(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  manufacturer_model_reference VARCHAR(180) COLLATE utf8mb4_unicode_ci NULL,
  resolved_model_id INT UNSIGNED NULL,
  model_description VARCHAR(500) COLLATE utf8mb4_unicode_ci NULL,
  manufacturer_warranty_reference VARCHAR(180) COLLATE utf8mb4_unicode_ci NULL,
  warranty_start DATE NULL,
  warranty_end DATE NULL,
  received_at DATETIME(6) NULL,
  created_by INT UNSIGNED NOT NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id), UNIQUE KEY uq_mfr_supplied_normalized_serial (normalized_serial_number),
  KEY idx_mfr_supplied_case (manufacturer_return_case_id),
  CONSTRAINT fk_mfr_unit_case FOREIGN KEY (manufacturer_return_case_id) REFERENCES manufacturer_return_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_mfr_unit_outcome FOREIGN KEY (manufacturer_return_outcome_id) REFERENCES manufacturer_return_outcomes(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_mfr_unit_manufacturer FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_mfr_unit_model FOREIGN KEY (resolved_model_id) REFERENCES device_models(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_mfr_unit_actor FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
