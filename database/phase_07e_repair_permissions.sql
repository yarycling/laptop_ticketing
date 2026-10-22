-- Phase 7E repair permissions. Only SUPER_ADMIN and REPAIR_CENTRE receive them.
INSERT IGNORE INTO permissions (name, label, module) VALUES
  ('repairs.view', 'View Repair Queue', 'repairs'),
  ('repairs.start', 'Start Repair Processing', 'repairs'),
  ('repairs.assess', 'Record Repair Assessment', 'repairs'),
  ('repairs.record_work', 'Record Repair Work', 'repairs'),
  ('repairs.complete', 'Complete Repair Processing', 'repairs');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.name IN ('SUPER_ADMIN', 'REPAIR_CENTRE')
  AND p.name IN ('repairs.view', 'repairs.start', 'repairs.assess', 'repairs.record_work', 'repairs.complete');
