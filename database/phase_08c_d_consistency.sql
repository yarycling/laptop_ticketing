-- Administrative verification only. Never used by runtime actions.
SELECT 'completed_effective_mismatch' AS metric, COUNT(*) AS anomalies
FROM permanent_replacement_cases p
JOIN v_ticket_effective_device e ON e.replacement_case_id = p.id
WHERE p.current_status_code = 'COMPLETED'
  AND NOT (e.effective_device_id <=> p.replacement_device_id)
UNION ALL
SELECT 'active_return_original', COUNT(*)
FROM logistics_handoffs h JOIN v_ticket_effective_device e ON e.logistics_case_id = h.logistics_case_id
WHERE e.replacement_case_id IS NOT NULL AND h.active_record_key = 1
  AND h.handoff_type IN ('REPAIR_CENTRE_TO_TTPOST','TTPOST_TO_SCHOOL')
  AND h.device_id = e.original_device_id
UNION ALL
SELECT 'active_return_unrelated', COUNT(*)
FROM logistics_handoffs h JOIN v_ticket_effective_device e ON e.logistics_case_id = h.logistics_case_id
WHERE e.replacement_case_id IS NOT NULL AND h.active_record_key = 1
  AND h.handoff_type IN ('REPAIR_CENTRE_TO_TTPOST','TTPOST_TO_SCHOOL')
  AND h.device_id IS NOT NULL AND h.device_id <> e.effective_device_id
  AND h.device_id <> e.original_device_id
UNION ALL
SELECT 'returned_original_not_replaced', COUNT(*)
FROM v_ticket_effective_device e
JOIN ticket_logistics_cases lc ON lc.id = e.logistics_case_id
JOIN logistics_statuses ls ON ls.id = lc.current_status_id
JOIN devices d ON d.id = e.original_device_id
JOIN device_lifecycle_statuses life ON life.id = d.lifecycle_status_id
WHERE e.replacement_case_id IS NOT NULL AND ls.code = 'RETURNED_TO_SCHOOL'
  AND life.code <> 'REPLACED'
UNION ALL
SELECT 'returned_replacement_allocation_missing', COUNT(*)
FROM v_ticket_effective_device e
JOIN ticket_logistics_cases lc ON lc.id = e.logistics_case_id
JOIN logistics_statuses ls ON ls.id = lc.current_status_id
LEFT JOIN v_device_current_custody allocation ON allocation.device_id = e.effective_device_id
WHERE e.replacement_case_id IS NOT NULL AND ls.code = 'RETURNED_TO_SCHOOL'
  AND (allocation.device_id IS NULL OR allocation.current_custody_level IS NULL)
UNION ALL
SELECT 'returned_replacement_lifecycle_mismatch', COUNT(*)
FROM v_ticket_effective_device e
JOIN ticket_logistics_cases lc ON lc.id = e.logistics_case_id
JOIN logistics_statuses ls ON ls.id = lc.current_status_id
JOIN devices d ON d.id = e.effective_device_id
JOIN device_lifecycle_statuses life ON life.id = d.lifecycle_status_id
JOIN v_device_current_custody allocation ON allocation.device_id = e.effective_device_id
WHERE e.replacement_case_id IS NOT NULL AND ls.code = 'RETURNED_TO_SCHOOL'
  AND ((allocation.current_custody_level = 'STUDENT' AND life.code <> 'ASSIGNED')
    OR (allocation.current_custody_level <> 'STUDENT' AND life.code <> 'AVAILABLE'))
UNION ALL
SELECT 'ready_effective_null', COUNT(*)
FROM v_ticket_effective_device e
JOIN ticket_logistics_cases lc ON lc.id = e.logistics_case_id
JOIN logistics_statuses ls ON ls.id = lc.current_status_id
WHERE e.replacement_case_id IS NOT NULL AND ls.code = 'READY_FOR_RETURN'
  AND e.effective_device_id IS NULL
UNION ALL
SELECT 'ttpost_custody_original', COUNT(*)
FROM v_logistics_physical_custody pc
WHERE pc.replacement_case_id IS NOT NULL AND pc.physical_state_code = 'TTPOST_RETURN_CUSTODY'
  AND pc.device_id = pc.original_device_id
UNION ALL
SELECT 'school_receipt_original', COUNT(*)
FROM logistics_handoffs h JOIN v_ticket_effective_device e ON e.logistics_case_id = h.logistics_case_id
WHERE e.replacement_case_id IS NOT NULL AND h.handoff_type = 'TTPOST_TO_SCHOOL'
  AND h.received_at IS NOT NULL AND h.device_id = e.original_device_id
UNION ALL
SELECT 'replacement_relationship_mismatch', COUNT(*)
FROM permanent_replacement_cases p
JOIN ticket_logistics_cases lc ON lc.id = p.logistics_case_id
JOIN v_ticket_effective_device e ON e.replacement_case_id = p.id
WHERE p.current_status_code = 'COMPLETED'
  AND (p.original_device_id <> lc.device_id OR p.replacement_device_id <> e.effective_device_id)
UNION ALL
SELECT 'allocation_transfer_mismatch', COUNT(*)
FROM permanent_replacement_cases p
JOIN permanent_replacement_allocation_transfers transfer ON transfer.replacement_case_id = p.id
LEFT JOIN v_device_current_custody allocation ON allocation.device_id = p.replacement_device_id
WHERE p.current_status_code = 'COMPLETED'
  AND (NOT (allocation.current_custody_level <=> transfer.allocation_level)
    OR NOT (allocation.district_id <=> transfer.district_id)
    OR NOT (allocation.school_id <=> transfer.school_id)
    OR NOT (allocation.student_id <=> transfer.student_id))
UNION ALL
SELECT 'replacement_lifecycle_incorrect', COUNT(*)
FROM permanent_replacement_cases p
JOIN devices d ON d.id = p.replacement_device_id
JOIN device_lifecycle_statuses life ON life.id = d.lifecycle_status_id
JOIN permanent_replacement_allocation_transfers transfer ON transfer.replacement_case_id = p.id
WHERE p.current_status_code = 'COMPLETED'
  AND ((transfer.allocation_level = 'STUDENT' AND life.code <> 'ASSIGNED')
    OR (transfer.allocation_level <> 'STUDENT' AND life.code <> 'AVAILABLE'))
UNION ALL
SELECT 'duplicate_active_return_handoff', COUNT(*)
FROM (SELECT logistics_case_id FROM logistics_handoffs
  WHERE active_record_key = 1 AND handoff_type IN ('REPAIR_CENTRE_TO_TTPOST','TTPOST_TO_SCHOOL')
  GROUP BY logistics_case_id HAVING COUNT(*) > 1) duplicates
UNION ALL
SELECT 'ticket_logistics_status_mismatch', COUNT(*)
FROM v_ticket_effective_device e
JOIN ticket_logistics_cases lc ON lc.id = e.logistics_case_id
JOIN logistics_statuses ls ON ls.id = lc.current_status_id
JOIN tickets t ON t.id = e.ticket_id
JOIN ticket_statuses ts ON ts.id = t.current_status_id
WHERE e.replacement_case_id IS NOT NULL
  AND ((ls.code = 'RETURNED_TO_SCHOOL' AND ts.code <> 'RETURNED')
    OR (ls.code IN ('READY_FOR_RETURN','RETURN_IN_TRANSIT') AND ts.code <> 'COMPLETED'))
UNION ALL
SELECT 'effective_read_model_mismatch', COUNT(*)
FROM v_ticket_effective_device e
WHERE (e.replacement_case_id IS NULL AND e.effective_device_id <> e.original_device_id)
  OR (e.replacement_case_id IS NOT NULL AND e.effective_device_id = e.original_device_id)
UNION ALL
SELECT 'dangling_replacement_logistics', COUNT(*)
FROM permanent_replacement_cases p
LEFT JOIN ticket_logistics_cases lc ON lc.id = p.logistics_case_id
LEFT JOIN tickets t ON t.id = p.ticket_id
LEFT JOIN v_ticket_effective_device e ON e.replacement_case_id = p.id
WHERE p.current_status_code = 'COMPLETED'
  AND (lc.id IS NULL OR t.id IS NULL OR e.logistics_case_id IS NULL)
UNION ALL
SELECT 'temporary_triggers', COUNT(*)
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA = DATABASE() AND TRIGGER_NAME LIKE 'phase8cd%';
