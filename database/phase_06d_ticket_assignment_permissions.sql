-- Phase 6D named ticket ownership permissions. Safe to re-run.
INSERT IGNORE INTO permissions (name, label, module) VALUES
  ('tickets.assign', 'Manage Ticket Assignments', 'tickets'),
  ('tickets.claim', 'Claim Unassigned Tickets', 'tickets');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name IN ('SUPER_ADMIN', 'SCHOOL_ADMINISTRATOR', 'ICT_DISTRICT_COORDINATOR')
  AND p.name = 'tickets.assign';

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name = 'ICT_TECHNICAL_OFFICER'
  AND p.name = 'tickets.claim';
