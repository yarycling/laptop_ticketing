-- Phase 6B ticket intake permissions. Safe to re-run.
INSERT IGNORE INTO permissions (name, label, module) VALUES
  ('tickets.view', 'View Tickets', 'tickets'),
  ('tickets.create', 'Create Tickets', 'tickets');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name IN (
  'SUPER_ADMIN',
  'MOE_HEAD_OFFICE',
  'ICT_DISTRICT_COORDINATOR',
  'ICT_TECHNICAL_OFFICER',
  'SCHOOL_ADMINISTRATOR'
)
  AND p.name IN ('tickets.view', 'tickets.create');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON p.name = 'tickets.view'
WHERE r.name = 'TSTT_OVERSIGHT';
