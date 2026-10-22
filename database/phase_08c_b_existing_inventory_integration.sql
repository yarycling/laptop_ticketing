-- Phase 8C-B existing-inventory candidates. Repeatable read model; no runtime SQL.
CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_permanent_replacement_inventory_candidates AS
SELECT
  prc.id AS replacement_case_id,
  stock.stock_location_id,
  stock.device_id,
  stock.serial_number,
  stock.asset_tag,
  stock.manufacturer_name,
  stock.model_name,
  stock.lifecycle_code,
  stock.allocation_level,
  stock.district_id,
  stock.district_name,
  stock.school_id,
  stock.school_name,
  stock.service_location_id,
  stock.service_location_name,
  stock.stock_status,
  stock.is_reserved_for_replacement,
  candidate.lifecycle_status_id
FROM permanent_replacement_cases prc
JOIN repair_exception_cases exception_case ON exception_case.id = prc.exception_case_id
JOIN v_device_current_custody original_allocation ON original_allocation.device_id = prc.original_device_id
JOIN v_device_stock_queue stock ON stock.service_location_id = prc.repair_service_location_id
JOIN service_locations repair_centre ON repair_centre.id = stock.service_location_id
JOIN devices candidate ON candidate.id = stock.device_id
WHERE prc.active_record_key = 1
  AND prc.current_status_code = 'SELECTION_REQUIRED'
  AND prc.replacement_source_type IS NULL
  AND prc.active_selection_key IS NULL
  AND exception_case.current_status_code = 'REPLACEMENT_APPROVED'
  AND repair_centre.location_type = 'REPAIR_CENTRE'
  AND repair_centre.is_active = 1
  AND stock.device_id <> prc.original_device_id
  AND stock.lifecycle_code = 'AVAILABLE'
  AND stock.stock_status = 'IN_STOCK'
  AND stock.allocation_level <> 'STUDENT'
  AND stock.is_reserved_for_replacement = 0
  AND stock.has_active_logistics = 0
  AND stock.has_active_manufacturer_return = 0
  AND stock.has_active_repair = 0
  AND NOT EXISTS (
    SELECT 1 FROM device_replacements consumed
    WHERE consumed.replacement_device_id = stock.device_id
  )
  AND NOT EXISTS (
    SELECT 1 FROM permanent_replacement_cases reserved
    WHERE reserved.replacement_device_id = stock.device_id
      AND reserved.active_selection_key IS NOT NULL
  )
  AND (
    stock.allocation_level = 'CENTRAL'
    OR (stock.allocation_level = 'DISTRICT'
      AND original_allocation.district_id IS NOT NULL
      AND stock.district_id = original_allocation.district_id)
    OR (stock.allocation_level = 'SCHOOL'
      AND original_allocation.school_id IS NOT NULL
      AND stock.school_id = original_allocation.school_id)
  );
