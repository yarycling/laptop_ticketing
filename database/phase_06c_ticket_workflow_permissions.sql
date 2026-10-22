-- Phase 6C named ticket workflow permissions. Safe to re-run.
INSERT IGNORE INTO permissions (name, label, module) VALUES
  ('tickets.diagnose', 'Record Ticket Diagnosis', 'tickets'),
  ('tickets.clarification_request', 'Request Ticket Clarification', 'tickets'),
  ('tickets.clarification_respond', 'Respond to Ticket Clarification', 'tickets'),
  ('tickets.approve_pickup', 'Approve Ticket for Pickup', 'tickets');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name = 'SUPER_ADMIN'
  AND p.name IN ('tickets.diagnose', 'tickets.clarification_request', 'tickets.clarification_respond', 'tickets.approve_pickup');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name IN ('SCHOOL_ADMINISTRATOR', 'ICT_TECHNICAL_OFFICER')
  AND p.name IN ('tickets.diagnose', 'tickets.clarification_request', 'tickets.clarification_respond');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name = 'ICT_DISTRICT_COORDINATOR'
  AND p.name IN ('tickets.clarification_request', 'tickets.approve_pickup');
