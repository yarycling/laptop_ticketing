-- Repeatable permissions for the Wappler Spare Pool Administration screen.
INSERT IGNORE INTO permissions (name,label,module) VALUES
  ('spare_pools.view','View Repair Centre Spare Pools','spare_pools'),
  ('spare_pools.manage','Manage Repair Centre Spare Pools','spare_pools');

INSERT IGNORE INTO role_permissions (role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p
WHERE r.name='SUPER_ADMIN' AND p.name IN ('spare_pools.view','spare_pools.manage');
