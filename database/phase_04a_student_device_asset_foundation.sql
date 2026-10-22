-- Phase 4A data foundation. Apply after the Phase 2 and Phase 3 migrations.

CREATE TABLE IF NOT EXISTS manufacturers (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  manufacturer_code VARCHAR(50) NOT NULL,
  name VARCHAR(180) NOT NULL,
  status VARCHAR(16) NOT NULL DEFAULT 'active',
  created_by_user_id INT UNSIGNED NULL,
  updated_by_user_id INT UNSIGNED NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_manufacturers_code (manufacturer_code),
  UNIQUE KEY uq_manufacturers_name (name),
  KEY idx_manufacturers_status (status),
  KEY idx_manufacturers_created_by (created_by_user_id),
  KEY idx_manufacturers_updated_by (updated_by_user_id),
  CONSTRAINT fk_manufacturers_created_by FOREIGN KEY (created_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
  CONSTRAINT fk_manufacturers_updated_by FOREIGN KEY (updated_by_user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS device_models (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  manufacturer_id INT UNSIGNED NOT NULL,
  model_code VARCHAR(80) NOT NULL,
  model_name VARCHAR(180) NOT NULL,
  image_path VARCHAR(1024) NULL,
  image_available TINYINT(1) NOT NULL DEFAULT 0,
  status VARCHAR(16) NOT NULL DEFAULT 'active',
  created_by_user_id INT UNSIGNED NULL,
  updated_by_user_id INT UNSIGNED NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_device_models_manufacturer_code (manufacturer_id, model_code),
  KEY idx_device_models_manufacturer_status (manufacturer_id, status),
  KEY idx_device_models_created_by (created_by_user_id),
  KEY idx_device_models_updated_by (updated_by_user_id),
  CONSTRAINT fk_device_models_manufacturer FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id),
  CONSTRAINT fk_device_models_created_by FOREIGN KEY (created_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
  CONSTRAINT fk_device_models_updated_by FOREIGN KEY (updated_by_user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS device_conditions (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  code VARCHAR(40) NOT NULL,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(500) NULL,
  sort_order INT UNSIGNED NOT NULL DEFAULT 0,
  status VARCHAR(16) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_device_conditions_code (code),
  KEY idx_device_conditions_status_sort (status, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS device_lifecycle_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  code VARCHAR(40) NOT NULL,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(500) NULL,
  sort_order INT UNSIGNED NOT NULL DEFAULT 0,
  status VARCHAR(16) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_device_lifecycle_statuses_code (code),
  KEY idx_device_lifecycle_statuses_status_sort (status, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS students (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  school_id INT UNSIGNED NOT NULL,
  student_reference VARCHAR(100) NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  status VARCHAR(16) NOT NULL DEFAULT 'active',
  created_by_user_id INT UNSIGNED NULL,
  updated_by_user_id INT UNSIGNED NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_students_school_reference (school_id, student_reference),
  KEY idx_students_school_status (school_id, status),
  KEY idx_students_last_first (last_name, first_name),
  KEY idx_students_created_by (created_by_user_id),
  KEY idx_students_updated_by (updated_by_user_id),
  CONSTRAINT fk_students_school FOREIGN KEY (school_id) REFERENCES schools(id),
  CONSTRAINT fk_students_created_by FOREIGN KEY (created_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
  CONSTRAINT fk_students_updated_by FOREIGN KEY (updated_by_user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS devices (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  serial_number VARCHAR(150) NOT NULL,
  asset_tag VARCHAR(120) NULL,
  device_model_id INT UNSIGNED NOT NULL,
  lifecycle_status_id INT UNSIGNED NOT NULL,
  condition_id INT UNSIGNED NOT NULL,
  warranty_start_date DATE NULL,
  warranty_end_date DATE NULL,
  received_date DATE NULL,
  procurement_reference VARCHAR(180) NULL,
  supplier_name VARCHAR(180) NULL,
  warranty_reference VARCHAR(180) NULL,
  image_path VARCHAR(1024) NULL,
  image_available TINYINT(1) NOT NULL DEFAULT 0,
  notes TEXT NULL,
  created_by_user_id INT UNSIGNED NULL,
  updated_by_user_id INT UNSIGNED NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_devices_serial_number (serial_number),
  UNIQUE KEY uq_devices_asset_tag (asset_tag),
  KEY idx_devices_model (device_model_id),
  KEY idx_devices_lifecycle_status (lifecycle_status_id),
  KEY idx_devices_condition (condition_id),
  KEY idx_devices_warranty_end_date (warranty_end_date),
  KEY idx_devices_received_date (received_date),
  KEY idx_devices_created_by (created_by_user_id),
  KEY idx_devices_updated_by (updated_by_user_id),
  CONSTRAINT fk_devices_model FOREIGN KEY (device_model_id) REFERENCES device_models(id),
  CONSTRAINT fk_devices_lifecycle_status FOREIGN KEY (lifecycle_status_id) REFERENCES device_lifecycle_statuses(id),
  CONSTRAINT fk_devices_condition FOREIGN KEY (condition_id) REFERENCES device_conditions(id),
  CONSTRAINT fk_devices_created_by FOREIGN KEY (created_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
  CONSTRAINT fk_devices_updated_by FOREIGN KEY (updated_by_user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS device_import_batches (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  batch_number VARCHAR(80) NOT NULL,
  original_filename VARCHAR(255) NOT NULL,
  stored_file_path VARCHAR(1024) NOT NULL,
  status VARCHAR(32) NOT NULL DEFAULT 'uploaded',
  total_rows INT UNSIGNED NOT NULL DEFAULT 0,
  valid_rows INT UNSIGNED NOT NULL DEFAULT 0,
  invalid_rows INT UNSIGNED NOT NULL DEFAULT 0,
  imported_rows INT UNSIGNED NOT NULL DEFAULT 0,
  uploaded_by_user_id INT UNSIGNED NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  validated_at DATETIME NULL,
  committed_at DATETIME NULL,
  cancelled_at DATETIME NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_device_import_batches_number (batch_number),
  KEY idx_device_import_batches_status_created (status, created_at),
  KEY idx_device_import_batches_created_at (created_at),
  KEY idx_device_import_batches_uploaded_by (uploaded_by_user_id),
  CONSTRAINT fk_device_import_batches_uploaded_by FOREIGN KEY (uploaded_by_user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS device_import_rows (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  batch_id INT UNSIGNED NOT NULL,
  row_number INT UNSIGNED NOT NULL,
  raw_payload LONGTEXT NOT NULL,
  serial_number_raw VARCHAR(255) NULL,
  serial_number_normalized VARCHAR(150) NULL,
  asset_tag_raw VARCHAR(255) NULL,
  asset_tag_normalized VARCHAR(120) NULL,
  manufacturer_code_raw VARCHAR(255) NULL,
  model_code_raw VARCHAR(255) NULL,
  condition_code_raw VARCHAR(255) NULL,
  warranty_start_raw VARCHAR(255) NULL,
  warranty_end_raw VARCHAR(255) NULL,
  received_date_raw VARCHAR(255) NULL,
  procurement_reference_raw VARCHAR(255) NULL,
  supplier_name_raw VARCHAR(255) NULL,
  warranty_reference_raw VARCHAR(255) NULL,
  validation_status VARCHAR(32) NOT NULL DEFAULT 'pending',
  validation_errors TEXT NULL,
  resolved_manufacturer_id INT UNSIGNED NULL,
  resolved_model_id INT UNSIGNED NULL,
  resolved_condition_id INT UNSIGNED NULL,
  imported_device_id INT UNSIGNED NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_device_import_rows_batch_row (batch_id, row_number),
  KEY idx_device_import_rows_batch_validation (batch_id, validation_status),
  KEY idx_device_import_rows_serial (serial_number_normalized),
  KEY idx_device_import_rows_asset_tag (asset_tag_normalized),
  KEY idx_device_import_rows_manufacturer (resolved_manufacturer_id),
  KEY idx_device_import_rows_model (resolved_model_id),
  KEY idx_device_import_rows_condition (resolved_condition_id),
  KEY idx_device_import_rows_device (imported_device_id),
  CONSTRAINT fk_device_import_rows_batch FOREIGN KEY (batch_id) REFERENCES device_import_batches(id) ON DELETE CASCADE,
  CONSTRAINT fk_device_import_rows_manufacturer FOREIGN KEY (resolved_manufacturer_id) REFERENCES manufacturers(id),
  CONSTRAINT fk_device_import_rows_model FOREIGN KEY (resolved_model_id) REFERENCES device_models(id),
  CONSTRAINT fk_device_import_rows_condition FOREIGN KEY (resolved_condition_id) REFERENCES device_conditions(id),
  CONSTRAINT fk_device_import_rows_device FOREIGN KEY (imported_device_id) REFERENCES devices(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO device_conditions (code, name, description, sort_order) VALUES
  ('NEW', 'New', 'New device.', 10),
  ('GOOD', 'Good', 'Good working condition.', 20),
  ('FAIR', 'Fair', 'Usable with visible wear.', 30),
  ('DAMAGED', 'Damaged', 'Physical damage recorded.', 40),
  ('NON_FUNCTIONAL', 'Non-functional', 'Device is not functioning.', 50),
  ('REFURBISHED', 'Refurbished', 'Refurbished device.', 60);

INSERT IGNORE INTO device_lifecycle_statuses (code, name, description, sort_order) VALUES
  ('RECEIVED', 'Received', 'Device received into the asset register.', 10),
  ('AVAILABLE', 'Available', 'Device available for an authorized assignment.', 20),
  ('ASSIGNED', 'Assigned', 'Device assigned through a later workflow.', 30),
  ('IN_REPAIR', 'In Repair', 'Device undergoing repair.', 40),
  ('MANUFACTURER_RETURN', 'Manufacturer Return', 'Device sent for manufacturer processing.', 50),
  ('REPLACED', 'Replaced', 'Device replaced by another asset.', 60),
  ('RETIRED', 'Retired', 'Device retired from service.', 70),
  ('LOST', 'Lost', 'Device reported lost.', 80),
  ('STOLEN', 'Stolen', 'Device reported stolen.', 90),
  ('DISPOSED', 'Disposed', 'Device disposed of through an approved process.', 100);

INSERT IGNORE INTO permissions (name, label, module) VALUES
  ('students.view', 'View Students', 'students'),
  ('students.manage', 'Manage Students', 'students'),
  ('device_imports.view', 'View Device Imports', 'device_imports'),
  ('device_imports.manage', 'Manage Device Imports', 'device_imports');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r JOIN permissions p ON p.name IN (
  'students.view', 'students.manage', 'devices.view', 'devices.manage',
  'device_imports.view', 'device_imports.manage'
) WHERE r.name = 'MOE_HEAD_OFFICE';

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r JOIN permissions p ON p.name IN (
  'dashboard.view', 'students.view', 'devices.view'
) WHERE r.name = 'ICT_DISTRICT_COORDINATOR';

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r JOIN permissions p ON p.name IN (
  'students.view', 'devices.view'
) WHERE r.name = 'ICT_TECHNICAL_OFFICER';

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r JOIN permissions p ON p.name IN (
  'students.view', 'students.manage', 'devices.view'
) WHERE r.name = 'SCHOOL_ADMINISTRATOR';

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r JOIN permissions p ON p.name = 'devices.view'
WHERE r.name = 'REPAIR_CENTRE';

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r JOIN permissions p ON p.name = 'devices.view'
WHERE r.name = 'TTPOST_LOGISTICS';

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r JOIN permissions p ON p.name IN (
  'devices.view', 'device_imports.view'
) WHERE r.name = 'TSTT_OVERSIGHT';
