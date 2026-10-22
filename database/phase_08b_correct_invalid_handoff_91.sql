-- One-time, idempotent correction for the invalid Phase 7F test dispatch.
-- Keep the handoff and scan rows as historical evidence; clear only the
-- current/pending pointer. Do not rewind later, valid workflow state.
START TRANSACTION;

UPDATE logistics_handoffs
SET active_record_key = NULL
WHERE id = 91
  AND logistics_case_id = 42
  AND handoff_type = 'REPAIR_CENTRE_TO_TTPOST'
  AND received_at IS NULL
  AND active_record_key = 1;

INSERT INTO audit_logs
  (actor_user_id, action, module, entity_type, entity_id, description)
SELECT
  NULL,
  'phase8b_invalid_return_dispatch_corrected',
  'manufacturer_returns',
  'logistics_handoffs',
  '91',
  'Invalid manufacturer-return dispatch corrected.'
WHERE EXISTS (
  SELECT 1
  FROM logistics_handoffs
  WHERE id = 91
    AND logistics_case_id = 42
    AND handoff_type = 'REPAIR_CENTRE_TO_TTPOST'
    AND received_at IS NULL
    AND active_record_key IS NULL
)
AND NOT EXISTS (
  SELECT 1
  FROM audit_logs
  WHERE action = 'phase8b_invalid_return_dispatch_corrected'
    AND module = 'manufacturer_returns'
    AND entity_type = 'logistics_handoffs'
    AND entity_id = '91'
);

COMMIT;
