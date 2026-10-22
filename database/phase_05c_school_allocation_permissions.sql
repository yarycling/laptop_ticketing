-- Phase 5C district-to-school allocation permissions. Safe to re-run.
INSERT IGNORE INTO permissions (name, label, module) VALUES
  ('device_school_allocations.view', 'View School Device Allocations', 'device_school_allocations'),
  ('device_school_allocations.manage', 'Allocate Devices to Schools', 'device_school_allocations');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name IN ('SUPER_ADMIN', 'MOE_HEAD_OFFICE', 'ICT_DISTRICT_COORDINATOR')
  AND p.name IN ('device_school_allocations.view', 'device_school_allocations.manage');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON p.name = 'device_school_allocations.view'
WHERE r.name IN ('TSTT_OVERSIGHT', 'SCHOOL_ADMINISTRATOR');
