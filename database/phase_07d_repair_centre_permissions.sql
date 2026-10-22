-- Phase 7D permissions. Grants only the explicitly approved actions.
INSERT IGNORE INTO permissions (name, label, module) VALUES
  ('logistics.forward_to_repair', 'Dispatch Devices to Repair Centre', 'logistics'),
  ('logistics.repair_receive', 'Confirm Repair Centre Receipt', 'logistics');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name = 'SUPER_ADMIN'
  AND p.name IN ('logistics.forward_to_repair', 'logistics.repair_receive');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name = 'TTPOST_LOGISTICS'
  AND p.name = 'logistics.forward_to_repair';

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name = 'REPAIR_CENTRE'
  AND p.name IN ('logistics.view', 'logistics.repair_receive');
