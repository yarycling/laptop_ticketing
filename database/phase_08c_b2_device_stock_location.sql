-- Phase 8C-B2. Repeatable foundation; stock is separate from educational allocation.
CREATE TABLE IF NOT EXISTS device_stock_locations (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  device_id INT UNSIGNED NOT NULL,
  service_location_id INT UNSIGNED NOT NULL,
  stock_status VARCHAR(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'IN_STOCK',
  reason_code VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'VERIFIED_INTAKE',
  active_record_key TINYINT UNSIGNED NULL DEFAULT 1,
  placed_by INT UNSIGNED NOT NULL,
  placed_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  removed_by INT UNSIGNED NULL,
  removed_at DATETIME(6) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_device_stock_active (device_id, active_record_key),
  KEY idx_device_stock_location_active (service_location_id, active_record_key),
  KEY idx_device_stock_device_placed (device_id, placed_at, id),
  CONSTRAINT chk_device_stock_status CHECK
    ((stock_status = 'IN_STOCK' AND active_record_key = 1 AND removed_at IS NULL AND removed_by IS NULL)
     OR (stock_status = 'RELEASED' AND active_record_key IS NULL AND removed_at IS NOT NULL AND removed_by IS NOT NULL)),
  CONSTRAINT fk_device_stock_device FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_device_stock_location FOREIGN KEY (service_location_id) REFERENCES service_locations(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_device_stock_placed_by FOREIGN KEY (placed_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_device_stock_removed_by FOREIGN KEY (removed_by) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_device_current_stock_location AS
SELECT sl.id AS stock_location_id, sl.device_id, sl.service_location_id,
  loc.code AS service_location_code, loc.name AS service_location_name,
  sl.stock_status, sl.reason_code, sl.placed_at, sl.placed_by,
  'REPAIR_CENTRE_STOCK' AS physical_custody_code,
  'Repair Centre Stock' AS physical_custody_name,
  reservation.id AS replacement_case_id,
  CASE WHEN reservation.id IS NULL THEN 0 ELSE 1 END AS is_reserved_for_replacement
FROM device_stock_locations sl
JOIN service_locations loc ON loc.id = sl.service_location_id
LEFT JOIN permanent_replacement_cases reservation
  ON reservation.replacement_device_id = sl.device_id
  AND reservation.active_selection_key = (CONVERT(CONCAT('DEVICE:', sl.device_id) USING utf8mb4) COLLATE utf8mb4_unicode_ci)
  AND reservation.current_status_code IN ('REPLACEMENT_SELECTED', 'AWAITING_ACCEPTANCE')
WHERE sl.active_record_key = 1 AND sl.stock_status = 'IN_STOCK' AND sl.removed_at IS NULL;

-- One device row with flags; Wappler Database components query this view.
CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_device_stock_intake_eligibility AS
SELECT d.id AS device_id, d.serial_number, d.asset_tag,
  m.name AS manufacturer_name, dm.model_name, life.code AS lifecycle_code,
  allocation.current_custody_level AS allocation_level,
  allocation.district_id, district.name AS district_name,
  allocation.school_id, school.name AS school_name,
  CASE WHEN active_stock.stock_location_id IS NULL THEN 0 ELSE 1 END AS has_active_stock,
  CASE WHEN EXISTS (SELECT 1 FROM ticket_logistics_cases lc WHERE lc.device_id = d.id AND lc.active_record_key = 1 AND lc.closed_at IS NULL) THEN 1 ELSE 0 END AS has_active_logistics,
  CASE WHEN EXISTS (SELECT 1 FROM manufacturer_return_cases mrc WHERE mrc.original_device_id = d.id AND mrc.active_record_key = 1 AND mrc.closed_at IS NULL AND mrc.current_status_code NOT IN ('COMPLETED','CANCELLED')) THEN 1 ELSE 0 END AS has_active_manufacturer_return,
  CASE WHEN EXISTS (SELECT 1 FROM repair_jobs job JOIN ticket_logistics_cases lc ON lc.id = job.logistics_case_id WHERE lc.device_id = d.id AND job.completed_at IS NULL) THEN 1 ELSE 0 END AS has_active_repair,
  CASE WHEN EXISTS (SELECT 1 FROM permanent_replacement_cases prc WHERE prc.replacement_device_id = d.id AND prc.current_status_code IN ('REPLACEMENT_SELECTED','AWAITING_ACCEPTANCE')) THEN 1 ELSE 0 END AS has_replacement_reservation,
  CASE WHEN EXISTS (SELECT 1 FROM device_replacements dr WHERE dr.replacement_device_id = d.id) THEN 1 ELSE 0 END AS has_replacement_consumption
FROM devices d
JOIN device_lifecycle_statuses life ON life.id = d.lifecycle_status_id
JOIN device_models dm ON dm.id = d.device_model_id
JOIN manufacturers m ON m.id = dm.manufacturer_id
JOIN v_device_current_custody allocation ON allocation.device_id = d.id
LEFT JOIN districts district ON district.id = allocation.district_id
LEFT JOIN schools school ON school.id = allocation.school_id
LEFT JOIN v_device_current_stock_location active_stock ON active_stock.device_id = d.id;

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_device_stock_queue AS
SELECT stock.stock_location_id, stock.device_id, eligibility.serial_number, eligibility.asset_tag,
  eligibility.manufacturer_name, eligibility.model_name, eligibility.lifecycle_code,
  eligibility.allocation_level, eligibility.district_id, district.name AS district_name,
  eligibility.school_id, school.name AS school_name,
  stock.service_location_id, stock.service_location_code, stock.service_location_name,
  stock.stock_status, stock.physical_custody_code, stock.physical_custody_name,
  stock.placed_at, stock.placed_by, stock.is_reserved_for_replacement, stock.replacement_case_id,
  eligibility.has_active_logistics, eligibility.has_active_manufacturer_return, eligibility.has_active_repair
FROM v_device_current_stock_location stock
JOIN v_device_stock_intake_eligibility eligibility ON eligibility.device_id = stock.device_id
LEFT JOIN districts district ON district.id = eligibility.district_id
LEFT JOIN schools school ON school.id = eligibility.school_id;

INSERT IGNORE INTO permissions (name,label,module) VALUES
 ('device_stock.view','View Repair Centre Stock','device_stock'),
 ('device_stock.intake','Record Repair Centre Stock Intake','device_stock'),
 ('device_stock.release','Release Repair Centre Stock','device_stock');

INSERT IGNORE INTO role_permissions (role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p
WHERE r.name IN ('SUPER_ADMIN','REPAIR_CENTRE')
  AND p.name IN ('device_stock.view','device_stock.intake','device_stock.release');

INSERT IGNORE INTO role_permissions (role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p
WHERE r.name IN ('MOE_HEAD_OFFICE','TSTT_OVERSIGHT') AND p.name = 'device_stock.view';
