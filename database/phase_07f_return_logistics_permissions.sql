-- Phase 7F return permissions. Idempotent grants for the four custody actions.
INSERT IGNORE INTO permissions (name, label, module) VALUES
  ('logistics.return_dispatch', 'Dispatch Return Device to TTPost', 'logistics'),
  ('logistics.return_ttpost_receive', 'Confirm TTPost Return Receipt', 'logistics'),
  ('logistics.return_school_dispatch', 'Dispatch Returned Device to School', 'logistics'),
  ('logistics.return_school_receive', 'Confirm School Return Receipt', 'logistics');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.name = 'SUPER_ADMIN'
  AND p.name IN (
    'logistics.return_dispatch',
    'logistics.return_ttpost_receive',
    'logistics.return_school_dispatch',
    'logistics.return_school_receive'
  );

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.name = 'REPAIR_CENTRE'
  AND p.name = 'logistics.return_dispatch';

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.name = 'TTPOST_LOGISTICS'
  AND p.name IN ('logistics.return_ttpost_receive', 'logistics.return_school_dispatch');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.name IN ('SCHOOL_ADMINISTRATOR', 'ICT_TECHNICAL_OFFICER')
  AND p.name = 'logistics.return_school_receive';
