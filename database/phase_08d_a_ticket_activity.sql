-- Phase 8D-A adds privacy-safe temporary loan events to the existing ticket read model.
-- The 8C view remains the source for all earlier activity types.
CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_ticket_activity_08d_a AS
SELECT ticket_id, activity_at, activity_type, activity_code, related_record_id,
  actor_user_id, subject_user_id, from_status_id, to_status_id, reference_code,
  activity_sort_order
FROM v_ticket_activity
UNION ALL
SELECT c.ticket_id, h.created_at, 'TEMPORARY_LOAN',
  CASE h.to_status_code
    WHEN 'PENDING_DISTRICT_APPROVAL' THEN 'TEMPORARY_LOAN_REQUESTED'
    WHEN 'AUTHORIZED' THEN 'TEMPORARY_LOAN_AUTHORIZED'
    WHEN 'REJECTED' THEN 'TEMPORARY_LOAN_REJECTED'
    WHEN 'CANCELLED' THEN 'TEMPORARY_LOAN_CANCELLED'
  END,
  h.id, h.actor_user_id, NULL, NULL, NULL, c.loan_number, 40
FROM temporary_loan_status_history h
JOIN temporary_loan_cases c ON c.id = h.temporary_loan_case_id
WHERE h.to_status_code IN ('PENDING_DISTRICT_APPROVAL', 'AUTHORIZED', 'REJECTED', 'CANCELLED');
