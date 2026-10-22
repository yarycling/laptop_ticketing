-- Allow schools to remain active while unassigned to an education district.
-- Repeatable: changes the column only when it is currently NOT NULL.
SET @school_district_nullable_ddl = IF(
  (SELECT IS_NULLABLE FROM information_schema.columns
   WHERE table_schema = DATABASE() AND table_name = 'schools' AND column_name = 'district_id') = 'NO',
  'ALTER TABLE schools MODIFY district_id INT UNSIGNED NULL',
  'SELECT 1'
);
PREPARE school_district_nullable_stmt FROM @school_district_nullable_ddl;
EXECUTE school_district_nullable_stmt;
DEALLOCATE PREPARE school_district_nullable_stmt;
