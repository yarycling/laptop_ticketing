-- Current, derived physical custody for a manufacturer-return cycle.
CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_manufacturer_return_physical_custody AS
SELECT c.id AS manufacturer_return_case_id, c.ticket_id, c.original_device_id,
  c.repair_centre_location_id, c.current_status_code AS manufacturer_return_status_code,
  outc.outcome_code AS current_outcome_code,
  outbound.carrier_id AS outbound_carrier_id, outbound.carrier_type AS outbound_carrier_type,
  returned.carrier_id AS return_carrier_id, returned.carrier_type AS return_carrier_type,
  CASE
    WHEN c.current_status_code = 'PREPARATION_REQUIRED' THEN 'REPAIR_CENTRE_MANUFACTURER_PREPARATION'
    WHEN c.current_status_code = 'AWAITING_OUTBOUND_CARRIER_PICKUP' THEN 'PENDING_OUTBOUND_CARRIER_PICKUP'
    WHEN c.current_status_code = 'OUTBOUND_IN_TRANSIT' AND outbound.carrier_type = 'TTPOST' THEN 'TTPOST_MANUFACTURER_OUTBOUND_CUSTODY'
    WHEN c.current_status_code = 'OUTBOUND_IN_TRANSIT' THEN 'EXTERNAL_COURIER_OUTBOUND_CUSTODY'
    WHEN c.current_status_code = 'AT_MANUFACTURER' AND outc.outcome_code IS NULL THEN 'MANUFACTURER_CUSTODY'
    WHEN c.current_status_code = 'AT_MANUFACTURER' THEN 'MANUFACTURER_CUSTODY'
    WHEN c.current_status_code = 'AWAITING_RETURN_CARRIER_PICKUP' THEN 'PENDING_RETURN_CARRIER_PICKUP'
    WHEN c.current_status_code = 'RETURN_IN_TRANSIT' AND returned.carrier_type = 'TTPOST' THEN 'TTPOST_MANUFACTURER_RETURN_CUSTODY'
    WHEN c.current_status_code = 'RETURN_IN_TRANSIT' THEN 'EXTERNAL_COURIER_RETURN_CUSTODY'
    WHEN c.current_status_code = 'COMPLETED' AND outc.outcome_code = 'REPLACEMENT_SUPPLIED' THEN 'MANUFACTURER_RETAINED_PENDING_REPLACEMENT'
    WHEN c.current_status_code = 'COMPLETED' THEN 'REPAIR_CENTRE_RETURN_RECEIVED'
    ELSE 'UNKNOWN'
  END AS physical_custody_code,
  CASE WHEN outbound.carrier_type = 'TTPOST' OR returned.carrier_type = 'TTPOST' THEN 1 ELSE 0 END AS has_ttpost_participation
FROM manufacturer_return_cases c
LEFT JOIN (SELECT o.manufacturer_return_case_id, o.outcome_code
  FROM manufacturer_return_outcomes o
  JOIN (SELECT manufacturer_return_case_id, MAX(id) AS latest_id FROM manufacturer_return_outcomes GROUP BY manufacturer_return_case_id) latest ON latest.latest_id = o.id) outc ON outc.manufacturer_return_case_id = c.id
LEFT JOIN (SELECT s.manufacturer_return_case_id, s.carrier_id, cr.carrier_type FROM manufacturer_return_shipments s JOIN carriers cr ON cr.id=s.carrier_id WHERE s.direction='OUTBOUND') outbound ON outbound.manufacturer_return_case_id=c.id
LEFT JOIN (SELECT s.manufacturer_return_case_id, s.carrier_id, cr.carrier_type FROM manufacturer_return_shipments s JOIN carriers cr ON cr.id=s.carrier_id WHERE s.direction='RETURN') returned ON returned.manufacturer_return_case_id=c.id;

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_manufacturer_return_queue AS
SELECT c.id AS manufacturer_return_case_id,c.manufacturer_return_number,c.ticket_id,t.ticket_number,
 lc.logistics_number,ls.code AS logistics_status_code,ls.name AS logistics_status_name,lp.physical_state_code AS phase7_physical_state_code,
 c.original_device_id,d.serial_number,d.asset_tag,c.manufacturer_id,m.name AS manufacturer_name,
 c.repair_centre_location_id,loc.name AS repair_centre_name,t.origin_school_id,school.name AS origin_school_name,
 t.origin_district_id,dist.name AS origin_district_name,c.current_status_code AS manufacturer_return_status_code,
 ms.name AS manufacturer_return_status_name,ec.current_status_code AS exception_status_code,es.name AS exception_status_name,
 pc.outbound_carrier_id,oc.name AS outbound_carrier_name,pc.outbound_carrier_type,
 pc.return_carrier_id,rc.name AS return_carrier_name,pc.return_carrier_type,pc.current_outcome_code,
 CASE pc.current_outcome_code WHEN 'REPAIRED_ORIGINAL' THEN 'Repaired Original' WHEN 'REPLACEMENT_SUPPLIED' THEN 'Replacement Supplied' WHEN 'WARRANTY_REJECTED' THEN 'Warranty Rejected' WHEN 'BEYOND_ECONOMICAL_REPAIR' THEN 'Beyond Economical Repair' ELSE NULL END AS current_outcome_name,
 c.started_at,c.updated_at,c.closed_at,pc.physical_custody_code,pc.has_ttpost_participation
FROM manufacturer_return_cases c
JOIN v_manufacturer_return_physical_custody pc ON pc.manufacturer_return_case_id=c.id
JOIN ticket_logistics_cases lc ON lc.id=c.logistics_case_id
JOIN logistics_statuses ls ON ls.id=lc.current_status_id
LEFT JOIN v_logistics_physical_custody lp ON lp.logistics_case_id=lc.id
JOIN tickets t ON t.id=c.ticket_id
JOIN devices d ON d.id=c.original_device_id
JOIN manufacturers m ON m.id=c.manufacturer_id
LEFT JOIN service_locations loc ON loc.id=c.repair_centre_location_id
LEFT JOIN schools school ON school.id=t.origin_school_id
LEFT JOIN districts dist ON dist.id=t.origin_district_id
JOIN manufacturer_return_statuses ms ON ms.code=c.current_status_code
JOIN repair_exception_cases ec ON ec.id=c.exception_case_id
LEFT JOIN exception_case_statuses es ON es.code=ec.current_status_code
LEFT JOIN carriers oc ON oc.id=pc.outbound_carrier_id
LEFT JOIN carriers rc ON rc.id=pc.return_carrier_id;
