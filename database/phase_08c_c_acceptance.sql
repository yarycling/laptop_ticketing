-- Phase 8C-C acceptance history and replacement-aware return identity.
-- Repeatable: tables are created once and the read model can be replaced.
CREATE TABLE IF NOT EXISTS manufacturer_supplied_unit_acceptances (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  staged_unit_id BIGINT UNSIGNED NOT NULL,
  replacement_case_id INT UNSIGNED NOT NULL,
  replacement_device_id INT UNSIGNED NOT NULL,
  accepted_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  accepted_by INT UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_msu_acceptance_stage (staged_unit_id),
  UNIQUE KEY uq_msu_acceptance_case (replacement_case_id),
  UNIQUE KEY uq_msu_acceptance_device (replacement_device_id),
  CONSTRAINT fk_msu_acceptance_stage FOREIGN KEY (staged_unit_id) REFERENCES manufacturer_supplied_units(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_msu_acceptance_case FOREIGN KEY (replacement_case_id) REFERENCES permanent_replacement_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_msu_acceptance_device FOREIGN KEY (replacement_device_id) REFERENCES devices(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_msu_acceptance_actor FOREIGN KEY (accepted_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS permanent_replacement_allocation_transfers (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  replacement_case_id INT UNSIGNED NOT NULL,
  allocation_level VARCHAR(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  district_id INT UNSIGNED NULL,
  school_id INT UNSIGNED NULL,
  student_id INT UNSIGNED NULL,
  original_district_allocation_id INT UNSIGNED NULL,
  original_school_allocation_id INT UNSIGNED NULL,
  original_student_assignment_id INT UNSIGNED NULL,
  replacement_district_allocation_id INT UNSIGNED NULL,
  replacement_school_allocation_id INT UNSIGNED NULL,
  replacement_student_assignment_id INT UNSIGNED NULL,
  source_stock_location_id BIGINT UNSIGNED NULL,
  transferred_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  transferred_by INT UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_pr_allocation_transfer_case (replacement_case_id),
  CONSTRAINT chk_pr_transfer_level CHECK (allocation_level IN ('CENTRAL','DISTRICT','SCHOOL','STUDENT')),
  CONSTRAINT fk_pr_transfer_case FOREIGN KEY (replacement_case_id) REFERENCES permanent_replacement_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_pr_transfer_district FOREIGN KEY (district_id) REFERENCES districts(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_pr_transfer_school FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_pr_transfer_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_pr_transfer_original_district FOREIGN KEY (original_district_allocation_id) REFERENCES device_district_allocations(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_pr_transfer_original_school FOREIGN KEY (original_school_allocation_id) REFERENCES device_school_allocations(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_pr_transfer_original_student FOREIGN KEY (original_student_assignment_id) REFERENCES device_student_assignments(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_pr_transfer_replacement_district FOREIGN KEY (replacement_district_allocation_id) REFERENCES device_district_allocations(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_pr_transfer_replacement_school FOREIGN KEY (replacement_school_allocation_id) REFERENCES device_school_allocations(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_pr_transfer_replacement_student FOREIGN KEY (replacement_student_assignment_id) REFERENCES device_student_assignments(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_pr_transfer_stock FOREIGN KEY (source_stock_location_id) REFERENCES device_stock_locations(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_pr_transfer_actor FOREIGN KEY (transferred_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_logistics_return_device AS
SELECT lc.id AS logistics_case_id,
  lc.device_id AS original_device_id,
  CASE WHEN prc.current_status_code = 'COMPLETED' THEN prc.replacement_device_id ELSE lc.device_id END AS return_device_id,
  CASE WHEN prc.current_status_code = 'COMPLETED' THEN prc.id ELSE NULL END AS completed_replacement_case_id,
  CASE WHEN prc.current_status_code = 'COMPLETED' THEN 'REPLACEMENT_READY_FOR_RETURN' ELSE NULL END AS replacement_physical_custody_code,
  CASE
    WHEN prc.current_status_code = 'COMPLETED' AND mpc.physical_custody_code = 'MANUFACTURER_RETAINED_PENDING_REPLACEMENT' THEN 'MANUFACTURER_RETAINED_REPLACED'
    WHEN prc.current_status_code = 'COMPLETED' THEN 'REPAIR_CENTRE_REPLACED_PENDING_DISPOSITION'
    ELSE NULL
  END AS original_replacement_physical_custody_code
FROM ticket_logistics_cases lc
LEFT JOIN permanent_replacement_cases prc ON prc.id = (
  SELECT MAX(p.id) FROM permanent_replacement_cases p
  WHERE p.logistics_case_id = lc.id AND p.current_status_code = 'COMPLETED'
)
LEFT JOIN manufacturer_return_cases mrc ON mrc.id = (
  SELECT MAX(m.id) FROM manufacturer_return_cases m
  WHERE m.exception_case_id = prc.exception_case_id
    AND prc.replacement_source_type = 'MANUFACTURER_SUPPLIED'
)
LEFT JOIN v_manufacturer_return_physical_custody mpc ON mpc.manufacturer_return_case_id = mrc.id;
