-- One-time migration: adds school-specific identity and enrollment date fields to students.
-- Apply after phase_04a_student_device_asset_foundation.sql.
ALTER TABLE students
  ADD COLUMN school_student_id_number VARCHAR(100) NULL AFTER student_reference,
  ADD COLUMN school_start_date DATE NULL AFTER school_student_id_number;
