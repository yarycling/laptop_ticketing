-- Phase 5E custody return permissions. Safe to re-run.
INSERT IGNORE INTO permissions (name, label, module) VALUES
  ('device_student_returns.manage', 'Return Student Device Assignments', 'device_student_returns'),
  ('device_school_returns.manage', 'Return School Device Allocations', 'device_school_returns'),
  ('device_district_returns.manage', 'Return District Device Allocations', 'device_district_returns');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name IN ('SUPER_ADMIN', 'MOE_HEAD_OFFICE')
  AND p.name IN ('device_student_returns.manage', 'device_school_returns.manage', 'device_district_returns.manage');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON p.name = 'device_student_returns.manage'
WHERE r.name = 'SCHOOL_ADMINISTRATOR';

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON p.name = 'device_school_returns.manage'
WHERE r.name = 'ICT_DISTRICT_COORDINATOR';
