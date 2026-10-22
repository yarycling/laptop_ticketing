-- Phase 8A action permissions. Idempotent grants; no permission inheritance is added.
INSERT IGNORE INTO permissions (name, label, module) VALUES
 ('exceptions.view','View Exception Cases','exceptions'),
 ('exceptions.assess','Record Exception Assessment','exceptions'),
 ('exceptions.submit','Submit Exception Review','exceptions'),
 ('exceptions.district_decide','Decide District Exception Disposition','exceptions'),
 ('exceptions.head_office_approve','Approve Permanent Replacement','exceptions');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.name = 'SUPER_ADMIN'
  AND p.name IN ('exceptions.view','exceptions.assess','exceptions.submit','exceptions.district_decide','exceptions.head_office_approve');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.name = 'REPAIR_CENTRE'
  AND p.name IN ('exceptions.view','exceptions.assess','exceptions.submit');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.name = 'ICT_DISTRICT_COORDINATOR'
  AND p.name IN ('exceptions.view','exceptions.district_decide');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.name = 'MOE_HEAD_OFFICE'
  AND p.name IN ('exceptions.view','exceptions.head_office_approve');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.name = 'TSTT_OVERSIGHT' AND p.name = 'exceptions.view';
