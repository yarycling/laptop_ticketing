-- Phase 5A historical allocation and assignment foundation.
-- Safe to re-run: tables use IF NOT EXISTS and the read model is replaced.

CREATE TABLE IF NOT EXISTS device_district_allocations (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  device_id INT UNSIGNED NOT NULL,
  district_id INT UNSIGNED NOT NULL,
  allocated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  allocated_by_user_id INT UNSIGNED NOT NULL,
  returned_at DATETIME NULL,
  returned_by_user_id INT UNSIGNED NULL,
  return_reason VARCHAR(500) NULL,
  notes TEXT NULL,
  active_record_key TINYINT UNSIGNED NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_device_district_allocations_active (device_id, active_record_key),
  UNIQUE KEY uq_device_district_allocations_device_id (device_id, id),
  KEY idx_device_district_allocations_district_active (district_id, active_record_key),
  KEY idx_device_district_allocations_allocated_at (allocated_at),
  KEY idx_device_district_allocations_returned_at (returned_at),
  CONSTRAINT fk_device_district_allocations_device FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_device_district_allocations_district FOREIGN KEY (district_id) REFERENCES districts(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_device_district_allocations_allocated_by FOREIGN KEY (allocated_by_user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_device_district_allocations_returned_by FOREIGN KEY (returned_by_user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS device_school_allocations (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  device_id INT UNSIGNED NOT NULL,
  district_allocation_id INT UNSIGNED NOT NULL,
  school_id INT UNSIGNED NOT NULL,
  allocated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  allocated_by_user_id INT UNSIGNED NOT NULL,
  returned_at DATETIME NULL,
  returned_by_user_id INT UNSIGNED NULL,
  return_reason VARCHAR(500) NULL,
  notes TEXT NULL,
  active_record_key TINYINT UNSIGNED NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_device_school_allocations_active (device_id, active_record_key),
  UNIQUE KEY uq_device_school_allocations_device_id (device_id, id),
  KEY idx_device_school_allocations_device_parent (device_id, district_allocation_id),
  KEY idx_device_school_allocations_district_parent (district_allocation_id, device_id),
  KEY idx_device_school_allocations_school_active (school_id, active_record_key),
  KEY idx_device_school_allocations_allocated_at (allocated_at),
  KEY idx_device_school_allocations_returned_at (returned_at),
  CONSTRAINT fk_device_school_allocations_device FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_device_school_allocations_district_parent FOREIGN KEY (device_id, district_allocation_id) REFERENCES device_district_allocations(device_id, id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_device_school_allocations_school FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_device_school_allocations_allocated_by FOREIGN KEY (allocated_by_user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_device_school_allocations_returned_by FOREIGN KEY (returned_by_user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS device_student_assignments (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  device_id INT UNSIGNED NOT NULL,
  school_allocation_id INT UNSIGNED NOT NULL,
  student_id INT UNSIGNED NOT NULL,
  assignment_type VARCHAR(40) NOT NULL DEFAULT 'PRIMARY',
  assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  assigned_by_user_id INT UNSIGNED NOT NULL,
  returned_at DATETIME NULL,
  returned_by_user_id INT UNSIGNED NULL,
  return_reason VARCHAR(500) NULL,
  notes TEXT NULL,
  active_record_key TINYINT UNSIGNED NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_device_student_assignments_active (device_id, active_record_key),
  UNIQUE KEY uq_device_student_assignments_device_id (device_id, id),
  KEY idx_device_student_assignments_device_school_parent (device_id, school_allocation_id),
  KEY idx_device_student_assignments_school_parent_device (school_allocation_id, device_id),
  KEY idx_device_student_assignments_student_active (student_id, active_record_key),
  KEY idx_device_student_assignments_assigned_at (assigned_at),
  KEY idx_device_student_assignments_returned_at (returned_at),
  CONSTRAINT fk_device_student_assignments_device FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_device_student_assignments_school_parent FOREIGN KEY (device_id, school_allocation_id) REFERENCES device_school_allocations(device_id, id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_device_student_assignments_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_device_student_assignments_assigned_by FOREIGN KEY (assigned_by_user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_device_student_assignments_returned_by FOREIGN KEY (returned_by_user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_device_current_custody AS
SELECT
  d.id AS device_id,
  CASE
    WHEN sa.id IS NOT NULL THEN 'STUDENT'
    WHEN sha.id IS NOT NULL THEN 'SCHOOL'
    WHEN da.id IS NOT NULL THEN 'DISTRICT'
    ELSE 'CENTRAL'
  END AS current_custody_level,
  da.id AS district_allocation_id,
  da.district_id AS district_id,
  sha.id AS school_allocation_id,
  sha.school_id AS school_id,
  sa.id AS student_assignment_id,
  sa.student_id AS student_id,
  sa.assignment_type AS student_assignment_type
FROM devices d
LEFT JOIN device_district_allocations da
  ON da.device_id = d.id
  AND da.active_record_key = 1
LEFT JOIN device_school_allocations sha
  ON sha.device_id = d.id
  AND sha.district_allocation_id = da.id
  AND sha.active_record_key = 1
LEFT JOIN device_student_assignments sa
  ON sa.device_id = d.id
  AND sa.school_allocation_id = sha.id
  AND sa.active_record_key = 1;
