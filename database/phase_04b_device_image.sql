-- Repeatable migration: private device image file metadata.
SET @device_image_column_exists = (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'devices' AND COLUMN_NAME = 'image_path'
);
SET @device_image_migration = IF(
  @device_image_column_exists = 0,
  'ALTER TABLE devices ADD COLUMN image_path VARCHAR(1024) NULL AFTER warranty_reference',
  'SELECT 1'
);
PREPARE device_image_statement FROM @device_image_migration;
EXECUTE device_image_statement;
DEALLOCATE PREPARE device_image_statement;

SET @device_image_available_exists = (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'devices' AND COLUMN_NAME = 'image_available'
);
SET @device_image_available_migration = IF(
  @device_image_available_exists = 0,
  'ALTER TABLE devices ADD COLUMN image_available TINYINT(1) NOT NULL DEFAULT 0 AFTER image_path',
  'SELECT 1'
);
PREPARE device_image_available_statement FROM @device_image_available_migration;
EXECUTE device_image_available_statement;
DEALLOCATE PREPARE device_image_available_statement;
