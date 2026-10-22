-- Move device photos to the catalogue model so all units of the same model share one image.
SET @model_image_path_exists = (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'device_models' AND COLUMN_NAME = 'image_path'
);
SET @model_image_path_migration = IF(
  @model_image_path_exists = 0,
  'ALTER TABLE device_models ADD COLUMN image_path VARCHAR(1024) NULL AFTER model_name',
  'SELECT 1'
);
PREPARE model_image_path_statement FROM @model_image_path_migration;
EXECUTE model_image_path_statement;
DEALLOCATE PREPARE model_image_path_statement;

SET @model_image_available_exists = (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'device_models' AND COLUMN_NAME = 'image_available'
);
SET @model_image_available_migration = IF(
  @model_image_available_exists = 0,
  'ALTER TABLE device_models ADD COLUMN image_available TINYINT(1) NOT NULL DEFAULT 0 AFTER image_path',
  'SELECT 1'
);
PREPARE model_image_available_statement FROM @model_image_available_migration;
EXECUTE model_image_available_statement;
DEALLOCATE PREPARE model_image_available_statement;

-- Keep existing uploads usable by adopting the first available image for each model.
UPDATE device_models AS m
SET m.image_path = (
      SELECT d.image_path
      FROM devices AS d
      WHERE d.device_model_id = m.id AND d.image_path IS NOT NULL AND d.image_path <> ''
      ORDER BY d.id
      LIMIT 1
    ),
    m.image_available = IF((
      SELECT COUNT(*)
      FROM devices AS d
      WHERE d.device_model_id = m.id AND d.image_path IS NOT NULL AND d.image_path <> ''
    ) > 0, 1, 0)
WHERE m.id > 0 AND (m.image_path IS NULL OR m.image_path = '');
