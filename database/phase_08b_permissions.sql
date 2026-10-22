-- Explicit, action-oriented Phase 8B grants; no implicit permission inheritance.
INSERT IGNORE INTO permissions (name,label,module) VALUES
 ('manufacturer_returns.view','View Manufacturer Returns','manufacturer_returns'),
 ('manufacturer_returns.start','Start Manufacturer Return','manufacturer_returns'),
 ('manufacturer_returns.prepare_outbound','Prepare Manufacturer Outbound Shipment','manufacturer_returns'),
 ('manufacturer_returns.external_outbound_pickup','Record External Outbound Pickup','manufacturer_returns'),
 ('manufacturer_returns.ttpost_outbound_pickup','Confirm TTPost Outbound Pickup','manufacturer_returns'),
 ('manufacturer_returns.manufacturer_acknowledge','Record Manufacturer Acknowledgement','manufacturer_returns'),
 ('manufacturer_returns.record_outcome','Record Manufacturer Outcome','manufacturer_returns'),
 ('manufacturer_returns.prepare_return','Prepare Manufacturer Return Shipment','manufacturer_returns'),
 ('manufacturer_returns.external_return_pickup','Record External Return Pickup','manufacturer_returns'),
 ('manufacturer_returns.ttpost_return_pickup','Confirm TTPost Return Pickup','manufacturer_returns'),
 ('manufacturer_returns.repair_receive','Receive Manufacturer Return at Repair Centre','manufacturer_returns'),
 ('carriers.view','View Carriers','carriers'),
 ('carriers.manage','Manage Carriers','carriers');

INSERT IGNORE INTO role_permissions (role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p
WHERE r.name='SUPER_ADMIN' AND p.name IN (
 'manufacturer_returns.view','manufacturer_returns.start','manufacturer_returns.prepare_outbound',
 'manufacturer_returns.external_outbound_pickup','manufacturer_returns.ttpost_outbound_pickup',
 'manufacturer_returns.manufacturer_acknowledge','manufacturer_returns.record_outcome',
 'manufacturer_returns.prepare_return','manufacturer_returns.external_return_pickup',
 'manufacturer_returns.ttpost_return_pickup','manufacturer_returns.repair_receive','carriers.view','carriers.manage');

INSERT IGNORE INTO role_permissions (role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p
WHERE r.name='REPAIR_CENTRE' AND p.name IN (
 'manufacturer_returns.view','manufacturer_returns.start','manufacturer_returns.prepare_outbound',
 'manufacturer_returns.external_outbound_pickup','manufacturer_returns.manufacturer_acknowledge',
 'manufacturer_returns.record_outcome','manufacturer_returns.prepare_return',
 'manufacturer_returns.external_return_pickup','manufacturer_returns.repair_receive','carriers.view');

INSERT IGNORE INTO role_permissions (role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p
WHERE r.name='TTPOST_LOGISTICS' AND p.name IN (
 'manufacturer_returns.view','manufacturer_returns.ttpost_outbound_pickup','manufacturer_returns.ttpost_return_pickup');

INSERT IGNORE INTO role_permissions (role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p
WHERE r.name IN ('ICT_DISTRICT_COORDINATOR','MOE_HEAD_OFFICE','TSTT_OVERSIGHT')
 AND p.name IN ('manufacturer_returns.view','carriers.view');
