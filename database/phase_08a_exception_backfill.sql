-- Create one pre-approval exception case for each completed historical
-- non-return repair job. Preserve repair completion time and actor.
INSERT INTO repair_exception_cases
  (ticket_id, logistics_case_id, repair_job_id, device_id, originating_repair_outcome_id,
   current_status_code, recommended_disposition_code, created_by_user_id, created_at)
SELECT c.ticket_id, j.logistics_case_id, j.id, c.device_id, o.id,
       'ASSESSMENT_REQUIRED',
       CASE o.code
         WHEN 'MANUFACTURER_RETURN_REQUIRED' THEN 'MANUFACTURER_RETURN'
         WHEN 'REPLACEMENT_REQUIRED' THEN 'PERMANENT_REPLACEMENT'
         ELSE NULL
       END,
       COALESCE(j.completed_by_user_id, j.started_by_user_id), j.completed_at
FROM repair_jobs j
JOIN ticket_logistics_cases c ON c.id = j.logistics_case_id
JOIN repair_outcomes o ON o.id = j.outcome_id
WHERE j.completed_at IS NOT NULL
  AND o.is_return_ready = 0
  AND NOT EXISTS (SELECT 1 FROM repair_exception_cases ec WHERE ec.repair_job_id = j.id);

INSERT INTO exception_case_status_history
  (exception_case_id, from_status_code, to_status_code, actor_user_id, reason, created_at)
SELECT ec.id, NULL, 'ASSESSMENT_REQUIRED', ec.created_by_user_id,
       'Backfilled from completed non-return repair outcome; no approval is implied.', ec.created_at
FROM repair_exception_cases ec
WHERE NOT EXISTS (
  SELECT 1 FROM exception_case_status_history h
  WHERE h.exception_case_id = ec.id
    AND h.from_status_code IS NULL
    AND h.to_status_code = 'ASSESSMENT_REQUIRED'
);
