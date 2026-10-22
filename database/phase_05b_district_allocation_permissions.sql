-- Phase 5B district allocation permissions. Safe to re-run.
INSERT IGNORE INTO permissions (name, label, module) VALUES
  ('device_district_allocations.view', 'View District Device Allocations', 'device_district_allocations'),
  ('device_district_allocations.manage', 'Allocate Devices to Districts', 'device_district_allocations');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name IN ('SUPER_ADMIN', 'MOE_HEAD_OFFICE')
  AND p.name IN ('device_district_allocations.view', 'device_district_allocations.manage');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON p.name = 'device_district_allocations.view'
WHERE r.name IN ('TSTT_OVERSIGHT', 'ICT_DISTRICT_COORDINATOR');
