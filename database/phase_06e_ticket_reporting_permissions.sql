-- Phase 6E read-only ticket reporting permissions. Safe to re-run.
INSERT IGNORE INTO permissions (name, label, module) VALUES
  ('tickets.dashboard', 'View Ticket Dashboard', 'tickets'),
  ('tickets.report', 'View Operational Ticket Reports', 'tickets');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name IN (
  'SUPER_ADMIN',
  'MOE_HEAD_OFFICE',
  'ICT_DISTRICT_COORDINATOR',
  'SCHOOL_ADMINISTRATOR',
  'TSTT_OVERSIGHT'
)
  AND p.name IN ('tickets.dashboard', 'tickets.report');
