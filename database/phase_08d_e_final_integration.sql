-- Phase 8D-E: close converted-loan service fulfillment without inventing a return journey.
-- Idempotent reference-data addition and bounded reconciliation of completed 8D-D conversions.
INSERT INTO logistics_statuses (code,name,is_terminal)
VALUES ('FULFILLED_AT_RECIPIENT','Fulfilled at Recipient',1)
ON DUPLICATE KEY UPDATE name=VALUES(name),is_terminal=1;

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_ticket_activity_08d_e AS
SELECT ticket_id,activity_at,activity_type,activity_code,related_record_id,actor_user_id,
  subject_user_id,from_status_id,to_status_id,reference_code,activity_sort_order
FROM v_ticket_activity_08d_b
UNION ALL
SELECT lc.ticket_id,GREATEST(h.changed_at,conversion_history.created_at + INTERVAL 1 MICROSECOND),
  'LOGISTICS','SERVICE_FULFILLED_AT_RECIPIENT',h.id,
  h.changed_by_user_id,NULL,NULL,NULL,lc.logistics_number,45
FROM logistics_status_history h
JOIN ticket_logistics_cases lc ON lc.id=h.logistics_case_id
JOIN logistics_statuses fulfilled ON fulfilled.id=h.to_status_id
JOIN permanent_replacement_cases pr ON pr.logistics_case_id=lc.id
  AND pr.replacement_source_type='TEMPORARY_LOAN_CONVERSION'
JOIN temporary_loan_cases loan ON loan.id=pr.temporary_loan_case_id
JOIN temporary_loan_status_history conversion_history ON conversion_history.temporary_loan_case_id=loan.id
  AND conversion_history.to_status_code='CONVERTED_PERMANENT'
WHERE fulfilled.code='FULFILLED_AT_RECIPIENT' AND h.reason='TEMPORARY_LOAN_CONVERSION';

START TRANSACTION;

-- Preserve the ticket's original device and add only the missing terminal transition.
INSERT INTO ticket_status_history
  (ticket_id,from_status_id,to_status_id,changed_at,changed_by_user_id,reason,comment)
SELECT t.id,old_status.id,new_status.id,NOW(6),pr.completed_by,
  'TEMPORARY_LOAN_CONVERSION',
  'Permanent replacement fulfilled at recipient through temporary-loan conversion; no Phase 7F return transport was required.'
FROM temporary_loan_cases loan
JOIN permanent_replacement_cases pr ON pr.temporary_loan_case_id=loan.id
  AND pr.replacement_source_type='TEMPORARY_LOAN_CONVERSION'
  AND pr.current_status_code='COMPLETED' AND pr.completed_at IS NOT NULL
JOIN devices original ON original.id=loan.original_device_id
JOIN device_lifecycle_statuses original_state ON original_state.id=original.lifecycle_status_id
JOIN tickets t ON t.id=loan.ticket_id
JOIN ticket_statuses old_status ON old_status.id=t.current_status_id AND old_status.code='UNDER_REPAIR'
JOIN ticket_statuses new_status ON new_status.code='RETURNED'
JOIN ticket_logistics_cases lc ON lc.id=pr.logistics_case_id AND lc.ticket_id=t.id
JOIN logistics_statuses old_logistics ON old_logistics.id=lc.current_status_id AND old_logistics.code='AT_REPAIR_CENTRE'
JOIN logistics_statuses fulfilled ON fulfilled.code='FULFILLED_AT_RECIPIENT'
WHERE loan.current_status_code='CONVERTED_PERMANENT'
  AND original_state.code='REPLACED'
  AND NOT EXISTS (
    SELECT 1 FROM ticket_status_history h
    WHERE h.ticket_id=t.id AND h.to_status_id=new_status.id
      AND h.reason='TEMPORARY_LOAN_CONVERSION'
  );

UPDATE tickets t
JOIN temporary_loan_cases loan ON loan.ticket_id=t.id AND loan.current_status_code='CONVERTED_PERMANENT'
JOIN permanent_replacement_cases pr ON pr.temporary_loan_case_id=loan.id
  AND pr.replacement_source_type='TEMPORARY_LOAN_CONVERSION'
  AND pr.current_status_code='COMPLETED' AND pr.completed_at IS NOT NULL
JOIN devices original ON original.id=loan.original_device_id
JOIN device_lifecycle_statuses original_state ON original_state.id=original.lifecycle_status_id
JOIN ticket_statuses old_status ON old_status.id=t.current_status_id AND old_status.code='UNDER_REPAIR'
JOIN ticket_statuses new_status ON new_status.code='RETURNED'
SET t.current_status_id=new_status.id,t.closed_at=COALESCE(t.closed_at,NOW(6)),
    t.updated_by_user_id=pr.completed_by,t.updated_at=NOW(6)
WHERE original_state.code='REPLACED';

INSERT INTO logistics_status_history
  (logistics_case_id,from_status_id,to_status_id,changed_at,changed_by_user_id,reason,comment)
SELECT lc.id,old_status.id,fulfilled.id,NOW(6),pr.completed_by,
  'TEMPORARY_LOAN_CONVERSION',
  'Service logistics fulfilled because the converted permanent replacement was already with the recipient; no Phase 7F return handoff was created.'
FROM temporary_loan_cases loan
JOIN permanent_replacement_cases pr ON pr.temporary_loan_case_id=loan.id
  AND pr.replacement_source_type='TEMPORARY_LOAN_CONVERSION'
  AND pr.current_status_code='COMPLETED' AND pr.completed_at IS NOT NULL
JOIN devices original ON original.id=loan.original_device_id
JOIN device_lifecycle_statuses original_state ON original_state.id=original.lifecycle_status_id
JOIN ticket_logistics_cases lc ON lc.id=pr.logistics_case_id AND lc.ticket_id=loan.ticket_id
JOIN logistics_statuses old_status ON old_status.id=lc.current_status_id AND old_status.code='AT_REPAIR_CENTRE'
JOIN logistics_statuses fulfilled ON fulfilled.code='FULFILLED_AT_RECIPIENT'
WHERE loan.current_status_code='CONVERTED_PERMANENT' AND original_state.code='REPLACED'
  AND NOT EXISTS (
    SELECT 1 FROM logistics_status_history h
    WHERE h.logistics_case_id=lc.id AND h.to_status_id=fulfilled.id
      AND h.reason='TEMPORARY_LOAN_CONVERSION'
  );

UPDATE ticket_logistics_cases lc
JOIN permanent_replacement_cases pr ON pr.logistics_case_id=lc.id
  AND pr.replacement_source_type='TEMPORARY_LOAN_CONVERSION'
  AND pr.current_status_code='COMPLETED' AND pr.completed_at IS NOT NULL
JOIN temporary_loan_cases loan ON loan.id=pr.temporary_loan_case_id
  AND loan.current_status_code='CONVERTED_PERMANENT'
JOIN devices original ON original.id=loan.original_device_id
JOIN device_lifecycle_statuses original_state ON original_state.id=original.lifecycle_status_id
JOIN logistics_statuses old_status ON old_status.id=lc.current_status_id AND old_status.code='AT_REPAIR_CENTRE'
JOIN logistics_statuses fulfilled ON fulfilled.code='FULFILLED_AT_RECIPIENT'
SET lc.current_status_id=fulfilled.id,lc.closed_at=COALESCE(lc.closed_at,NOW(6)),
    lc.closed_by_user_id=pr.completed_by,lc.close_reason='TEMPORARY_LOAN_CONVERSION',
    lc.updated_by_user_id=pr.completed_by,lc.updated_at=NOW(6)
WHERE original_state.code='REPLACED' AND lc.active_record_key=1 AND lc.closed_at IS NULL;

-- A transfer can leave parent-level allocations active after a student assignment closes.
-- Retire every remaining active Phase 5 row on the replaced original, preserving history.
UPDATE device_student_assignments assignment_record
JOIN temporary_loan_cases loan ON loan.original_device_id=assignment_record.device_id
  AND loan.current_status_code='CONVERTED_PERMANENT'
JOIN permanent_replacement_cases pr ON pr.temporary_loan_case_id=loan.id
  AND pr.replacement_source_type='TEMPORARY_LOAN_CONVERSION'
  AND pr.current_status_code='COMPLETED' AND pr.completed_at IS NOT NULL
JOIN devices original ON original.id=loan.original_device_id
JOIN device_lifecycle_statuses original_state ON original_state.id=original.lifecycle_status_id
SET assignment_record.returned_at=COALESCE(assignment_record.returned_at,NOW()),
    assignment_record.returned_by_user_id=pr.completed_by,
    assignment_record.return_reason='PERMANENT_REPLACEMENT',
    assignment_record.active_record_key=NULL
WHERE original_state.code='REPLACED' AND assignment_record.active_record_key=1
  AND assignment_record.returned_at IS NULL;

UPDATE device_school_allocations allocation_record
JOIN temporary_loan_cases loan ON loan.original_device_id=allocation_record.device_id
  AND loan.current_status_code='CONVERTED_PERMANENT'
JOIN permanent_replacement_cases pr ON pr.temporary_loan_case_id=loan.id
  AND pr.replacement_source_type='TEMPORARY_LOAN_CONVERSION'
  AND pr.current_status_code='COMPLETED' AND pr.completed_at IS NOT NULL
JOIN devices original ON original.id=loan.original_device_id
JOIN device_lifecycle_statuses original_state ON original_state.id=original.lifecycle_status_id
SET allocation_record.returned_at=COALESCE(allocation_record.returned_at,NOW()),
    allocation_record.returned_by_user_id=pr.completed_by,
    allocation_record.return_reason='PERMANENT_REPLACEMENT',
    allocation_record.active_record_key=NULL
WHERE original_state.code='REPLACED' AND allocation_record.active_record_key=1
  AND allocation_record.returned_at IS NULL;

UPDATE ticket_status_history h
JOIN temporary_loan_cases loan ON loan.ticket_id=h.ticket_id AND loan.current_status_code='CONVERTED_PERMANENT'
JOIN temporary_loan_status_history converted ON converted.temporary_loan_case_id=loan.id
  AND converted.to_status_code='CONVERTED_PERMANENT'
SET h.changed_at=GREATEST(h.changed_at,converted.created_at + INTERVAL 1 MICROSECOND)
WHERE h.reason='TEMPORARY_LOAN_CONVERSION';

UPDATE logistics_status_history h
JOIN ticket_logistics_cases lc ON lc.id=h.logistics_case_id
JOIN temporary_loan_cases loan ON loan.ticket_id=lc.ticket_id AND loan.current_status_code='CONVERTED_PERMANENT'
JOIN temporary_loan_status_history converted ON converted.temporary_loan_case_id=loan.id
  AND converted.to_status_code='CONVERTED_PERMANENT'
SET h.changed_at=GREATEST(h.changed_at,converted.created_at + INTERVAL 1 MICROSECOND)
WHERE h.reason='TEMPORARY_LOAN_CONVERSION';

UPDATE device_district_allocations allocation_record
JOIN temporary_loan_cases loan ON loan.original_device_id=allocation_record.device_id
  AND loan.current_status_code='CONVERTED_PERMANENT'
JOIN permanent_replacement_cases pr ON pr.temporary_loan_case_id=loan.id
  AND pr.replacement_source_type='TEMPORARY_LOAN_CONVERSION'
  AND pr.current_status_code='COMPLETED' AND pr.completed_at IS NOT NULL
JOIN devices original ON original.id=loan.original_device_id
JOIN device_lifecycle_statuses original_state ON original_state.id=original.lifecycle_status_id
SET allocation_record.returned_at=COALESCE(allocation_record.returned_at,NOW()),
    allocation_record.returned_by_user_id=pr.completed_by,
    allocation_record.return_reason='PERMANENT_REPLACEMENT',
    allocation_record.active_record_key=NULL
WHERE original_state.code='REPLACED' AND allocation_record.active_record_key=1
  AND allocation_record.returned_at IS NULL;

INSERT INTO audit_logs (actor_user_id,action,module,entity_type,entity_id,description,created_at)
SELECT pr.completed_by,'temporary_loan_conversion_fulfillment_reconciled','temporary_loans',
  'temporary_loan_case',loan.id,
  'Idempotently reconciled completed conversion to ticket RETURNED and logistics FULFILLED_AT_RECIPIENT; no Phase 7F return was fabricated.',NOW()
FROM temporary_loan_cases loan
JOIN permanent_replacement_cases pr ON pr.temporary_loan_case_id=loan.id
  AND pr.replacement_source_type='TEMPORARY_LOAN_CONVERSION'
  AND pr.current_status_code='COMPLETED' AND pr.completed_at IS NOT NULL
JOIN tickets t ON t.id=loan.ticket_id
JOIN ticket_statuses ts ON ts.id=t.current_status_id AND ts.code='RETURNED'
JOIN ticket_logistics_cases lc ON lc.id=pr.logistics_case_id
JOIN logistics_statuses ls ON ls.id=lc.current_status_id AND ls.code='FULFILLED_AT_RECIPIENT'
WHERE loan.current_status_code='CONVERTED_PERMANENT'
  AND NOT EXISTS (SELECT 1 FROM audit_logs a WHERE a.action='temporary_loan_conversion_fulfillment_reconciled'
    AND a.entity_type='temporary_loan_case' AND a.entity_id=CAST(loan.id AS CHAR));

COMMIT;
