-- Phase 5D school-to-student assignment permissions. Safe to re-run.
INSERT IGNORE INTO permissions (name, label, module) VALUES
  ('device_student_assignments.view', 'View Student Device Assignments', 'device_student_assignments'),
  ('device_student_assignments.manage', 'Assign Devices to Students', 'device_student_assignments');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name IN ('SUPER_ADMIN', 'MOE_HEAD_OFFICE', 'SCHOOL_ADMINISTRATOR')
  AND p.name IN ('device_student_assignments.view', 'device_student_assignments.manage');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON p.name = 'device_student_assignments.view'
WHERE r.name IN ('ICT_DISTRICT_COORDINATOR', 'TSTT_OVERSIGHT');
