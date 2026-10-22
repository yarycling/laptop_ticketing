-- Phase 8C cleanup: allow Repair Centre users to open ticket records.
-- Safe to re-run.
INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON p.name = 'tickets.view'
WHERE r.name = 'REPAIR_CENTRE';
