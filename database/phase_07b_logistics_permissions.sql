-- Phase 7B logistics permissions. Safe to re-run.
INSERT IGNORE INTO permissions (name, label, module) VALUES
  ('logistics.view', 'View Logistics', 'logistics'),
  ('logistics.request_pickup', 'Request Device Pickup', 'logistics'),
  ('logistics.accept', 'Accept Pickup Requests', 'logistics');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name = 'SUPER_ADMIN'
  AND p.name IN ('logistics.view', 'logistics.request_pickup', 'logistics.accept');

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name IN ('MOE_HEAD_OFFICE', 'ICT_TECHNICAL_OFFICER', 'TSTT_OVERSIGHT', 'TTPOST_LOGISTICS', 'ICT_DISTRICT_COORDINATOR', 'SCHOOL_ADMINISTRATOR')
  AND p.name = 'logistics.view';

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name IN ('ICT_DISTRICT_COORDINATOR', 'SCHOOL_ADMINISTRATOR')
  AND p.name = 'logistics.request_pickup';

INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name = 'TTPOST_LOGISTICS'
  AND p.name = 'logistics.accept';
