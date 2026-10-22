-- District coordinators land on the dashboard after login, so grant access to that route.
INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON p.name = 'dashboard.view'
WHERE r.name = 'ICT_DISTRICT_COORDINATOR';
