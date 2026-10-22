-- Administrative verification only. Never used by runtime actions.
SELECT 'completed_without_replacement_device' AS metric, COUNT(*) AS anomalies
FROM permanent_replacement_cases p
WHERE p.current_status_code = 'COMPLETED' AND p.replacement_device_id IS NULL
UNION ALL
SELECT 'completed_original_not_replaced', COUNT(*)
FROM permanent_replacement_cases p
JOIN devices d ON d.id = p.original_device_id
JOIN device_lifecycle_statuses life ON life.id = d.lifecycle_status_id
WHERE p.current_status_code = 'COMPLETED' AND life.code <> 'REPLACED'
UNION ALL
SELECT 'duplicate_device_replacements', COUNT(*)
FROM (SELECT replacement_case_id FROM device_replacements
  GROUP BY replacement_case_id HAVING COUNT(*) > 1) duplicate_cases
UNION ALL
SELECT 'manufacturer_without_consumed_stage', COUNT(*)
FROM permanent_replacement_cases p
LEFT JOIN manufacturer_supplied_unit_acceptances a ON a.replacement_case_id = p.id
  AND a.staged_unit_id = p.staged_manufacturer_unit_id
  AND a.replacement_device_id = p.replacement_device_id
WHERE p.current_status_code = 'COMPLETED'
  AND p.replacement_source_type = 'MANUFACTURER_SUPPLIED' AND a.id IS NULL
UNION ALL
SELECT 'inventory_with_active_stock', COUNT(*)
FROM permanent_replacement_cases p
JOIN device_stock_locations stock ON stock.device_id = p.replacement_device_id
  AND stock.active_record_key = 1
WHERE p.current_status_code = 'COMPLETED'
  AND p.replacement_source_type = 'EXISTING_INVENTORY'
UNION ALL
SELECT 'replacement_allocation_missing', COUNT(*)
FROM permanent_replacement_cases p
LEFT JOIN permanent_replacement_allocation_transfers transfer ON transfer.replacement_case_id = p.id
LEFT JOIN v_device_current_custody custody ON custody.device_id = p.replacement_device_id
WHERE p.current_status_code = 'COMPLETED'
  AND (transfer.id IS NULL OR custody.device_id IS NULL
    OR custody.current_custody_level IS NULL
    OR NOT (custody.current_custody_level <=> transfer.allocation_level)
    OR NOT (custody.district_id <=> transfer.district_id)
    OR NOT (custody.school_id <=> transfer.school_id)
    OR NOT (custody.student_id <=> transfer.student_id))
UNION ALL
SELECT 'original_active_at_replaced_level', COUNT(*)
FROM permanent_replacement_cases p
JOIN permanent_replacement_allocation_transfers transfer ON transfer.replacement_case_id = p.id
LEFT JOIN device_district_allocations district ON district.id = transfer.original_district_allocation_id
LEFT JOIN device_school_allocations school ON school.id = transfer.original_school_allocation_id
LEFT JOIN device_student_assignments student ON student.id = transfer.original_student_assignment_id
WHERE p.current_status_code = 'COMPLETED'
  AND ((transfer.allocation_level = 'DISTRICT' AND district.active_record_key = 1)
    OR (transfer.allocation_level = 'SCHOOL' AND school.active_record_key = 1)
    OR (transfer.allocation_level = 'STUDENT' AND student.active_record_key = 1))
UNION ALL
SELECT 'replacement_lifecycle_allocation_mismatch', COUNT(*)
FROM permanent_replacement_cases p
JOIN devices d ON d.id = p.replacement_device_id
JOIN device_lifecycle_statuses life ON life.id = d.lifecycle_status_id
JOIN permanent_replacement_allocation_transfers transfer ON transfer.replacement_case_id = p.id
WHERE p.current_status_code = 'COMPLETED'
  AND ((transfer.allocation_level = 'STUDENT' AND life.code <> 'ASSIGNED')
    OR (transfer.allocation_level <> 'STUDENT' AND life.code <> 'AVAILABLE'))
UNION ALL
SELECT 'ticket_logistics_state_mismatch', COUNT(*)
FROM permanent_replacement_cases p
JOIN tickets t ON t.id = p.ticket_id
JOIN ticket_statuses ticket_status ON ticket_status.id = t.current_status_id
JOIN ticket_logistics_cases logistics ON logistics.id = p.logistics_case_id
JOIN logistics_statuses logistics_status ON logistics_status.id = logistics.current_status_id
WHERE p.current_status_code = 'COMPLETED'
  AND ((logistics_status.code = 'RETURNED_TO_SCHOOL' AND ticket_status.code <> 'RETURNED')
    OR (logistics_status.code IN ('READY_FOR_RETURN', 'RETURN_IN_TRANSIT')
      AND ticket_status.code <> 'COMPLETED'))
UNION ALL
SELECT 'effective_device_mismatch', COUNT(*)
FROM permanent_replacement_cases p
LEFT JOIN v_ticket_effective_device effective ON effective.replacement_case_id = p.id
WHERE p.current_status_code = 'COMPLETED'
  AND (effective.logistics_case_id IS NULL
    OR NOT (effective.effective_device_id <=> p.replacement_device_id)
    OR effective.original_device_id <> p.original_device_id)
UNION ALL
SELECT 'active_return_handoff_uses_original', COUNT(*)
FROM logistics_handoffs h
JOIN v_ticket_effective_device effective ON effective.logistics_case_id = h.logistics_case_id
WHERE effective.replacement_case_id IS NOT NULL AND h.active_record_key = 1
  AND h.handoff_type IN ('REPAIR_CENTRE_TO_TTPOST', 'TTPOST_TO_SCHOOL')
  AND h.device_id = effective.original_device_id
UNION ALL
SELECT 'stock_reservation_after_completion', COUNT(*)
FROM permanent_replacement_cases p
WHERE p.current_status_code = 'COMPLETED'
  AND p.replacement_source_type = 'EXISTING_INVENTORY'
  AND p.active_selection_key IS NOT NULL
UNION ALL
SELECT 'staged_reservation_after_completion', COUNT(*)
FROM permanent_replacement_cases p
WHERE p.current_status_code = 'COMPLETED'
  AND p.replacement_source_type = 'MANUFACTURER_SUPPLIED'
  AND p.active_selection_key IS NOT NULL
UNION ALL
SELECT 'status_latest_history_mismatch', COUNT(*)
FROM permanent_replacement_cases p
LEFT JOIN permanent_replacement_status_history history ON history.id = (
  SELECT MAX(h.id) FROM permanent_replacement_status_history h
  WHERE h.replacement_case_id = p.id)
WHERE history.id IS NULL OR history.to_status_code <> p.current_status_code
UNION ALL
SELECT 'dangling_replacement_source_reference', COUNT(*)
FROM permanent_replacement_cases p
LEFT JOIN device_replacements relationship ON relationship.replacement_case_id = p.id
LEFT JOIN permanent_replacement_allocation_transfers transfer ON transfer.replacement_case_id = p.id
LEFT JOIN devices device ON device.id = p.replacement_device_id
LEFT JOIN manufacturer_supplied_units staged ON staged.id = p.staged_manufacturer_unit_id
LEFT JOIN device_stock_locations stock ON stock.id = transfer.source_stock_location_id
WHERE p.current_status_code = 'COMPLETED'
  AND (relationship.id IS NULL OR transfer.id IS NULL OR device.id IS NULL
    OR relationship.original_device_id <> p.original_device_id
    OR relationship.replacement_device_id <> p.replacement_device_id
    OR (p.replacement_source_type = 'MANUFACTURER_SUPPLIED' AND staged.id IS NULL)
    OR (p.replacement_source_type = 'EXISTING_INVENTORY' AND stock.id IS NULL))
UNION ALL
SELECT 'duplicate_completion_activity', COUNT(*)
FROM (SELECT ticket_id, related_record_id FROM v_ticket_activity
  WHERE activity_code = 'PERMANENT_REPLACEMENT_COMPLETED'
  GROUP BY ticket_id, related_record_id HAVING COUNT(*) > 1) duplicate_events
UNION ALL
SELECT 'temporary_triggers', COUNT(*)
FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA = DATABASE();
