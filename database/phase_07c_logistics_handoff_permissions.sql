-- Phase 7C permissions. Safe to re-run; grants only the explicit 7C actions.
INSERT IGNORE INTO permissions (name, label, module) VALUES
  ('logistics.dispatch', 'Release Devices to TTPost', 'logistics'),
  ('logistics.receive', 'Confirm TTPost Device Receipt', 'logistics'),
  ('logistics.locations_manage', 'Manage Logistics Locations', 'logistics');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name = 'SUPER_ADMIN'
  AND p.name IN ('logistics.dispatch', 'logistics.receive', 'logistics.locations_manage');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name IN ('SCHOOL_ADMINISTRATOR', 'ICT_TECHNICAL_OFFICER')
  AND p.name = 'logistics.dispatch';

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name = 'TTPOST_LOGISTICS'
  AND p.name = 'logistics.receive';
