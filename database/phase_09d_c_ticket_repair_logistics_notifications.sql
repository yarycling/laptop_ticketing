-- Phase 9D-C notification types and inbox read-model context.
-- Wappler Server Connect workflow actions create notification events; no triggers are used.
-- The Phase 9D-A event code length is expanded for the required Head Office event code.
ALTER TABLE notification_events DROP FOREIGN KEY fk_notification_event_type;
ALTER TABLE notification_event_types MODIFY code VARCHAR(64) COLLATE utf8mb4_unicode_ci NOT NULL;
ALTER TABLE notification_events MODIFY event_type_code VARCHAR(64) COLLATE utf8mb4_unicode_ci NOT NULL;
ALTER TABLE notification_events ADD CONSTRAINT fk_notification_event_type
  FOREIGN KEY (event_type_code) REFERENCES notification_event_types(code)
  ON DELETE RESTRICT ON UPDATE RESTRICT;

INSERT IGNORE INTO notification_event_types (code, name) VALUES
 ('TICKET_SUBMITTED','Ticket submitted'),
 ('TICKET_CLARIFICATION_REQUESTED','Ticket clarification requested'),
 ('DISTRICT_APPROVAL_REQUIRED','District approval required'),
 ('TICKET_APPROVED_FOR_PICKUP','Ticket approved for pickup'),
 ('LOGISTICS_PICKUP_REQUESTED','Logistics pickup requested'),
 ('LOGISTICS_SCHOOL_RELEASED','Device released by school'),
 ('LOGISTICS_RECEIVED_BY_TTPOST','Device received by TTPost'),
 ('LOGISTICS_SENT_TO_REPAIR_CENTRE','Device sent to Repair Centre'),
 ('LOGISTICS_RECEIVED_BY_REPAIR_CENTRE','Device received by Repair Centre'),
 ('LOGISTICS_READY_FOR_RETURN_PICKUP','Device ready for return pickup'),
 ('LOGISTICS_RETURN_RECEIVED_BY_TTPOST','Return received by TTPost'),
 ('LOGISTICS_RETURN_IN_TRANSIT_TO_SCHOOL','Return in transit to school'),
 ('LOGISTICS_RETURNED_TO_SCHOOL','Device returned to school'),
 ('REPAIR_STARTED','Repair started'),
 ('REPAIR_COMPLETED','Repair completed'),
 ('DISTRICT_REPAIR_DECISION_REQUIRED','District repair decision required'),
 ('HEAD_OFFICE_REPLACEMENT_APPROVAL_REQUIRED','Head Office replacement approval required');

CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_notification_inbox AS
SELECT nr.id AS recipient_id, nr.notification_event_id, nr.user_id,
  nr.recipient_role_code, nr.delivered_in_app_at, nr.read_at, nr.read_by,
  nr.archived_at, IF(nr.read_at IS NULL,0,1) AS read_state,
  e.idempotency_key, e.event_type_code, et.name AS event_type_name,
  e.source_type, e.source_id, e.ticket_id, t.ticket_number,
  t.origin_school_id, school.name AS school_name,
  t.origin_district_id, district.name AS district_name,
  device.serial_number, device.asset_tag,
  e.sla_instance_id, COALESCE(ec.policy_code_snapshot,si.policy_code_snapshot) AS sla_policy_code,
  e.escalation_case_id, ec.escalation_number,
  ec.current_level AS escalation_level, ec.current_state_code AS escalation_state_code,
  e.logistics_case_id, lc.logistics_number, h.handoff_type,
  e.repair_job_id, COALESCE(rj.repair_centre_location_id,lc.repair_centre_location_id) AS repair_centre_location_id,
  location.name AS repair_centre_name,
  e.temporary_loan_case_id, e.permanent_replacement_case_id,
  e.severity_code, sv.name AS severity_name, e.title, e.message,
  e.action_type, e.action_reference, e.created_at,
  DATE_FORMAT(e.created_at, '%b %e, %Y %l:%i %p') AS created_at_display,
  creator.display_name AS created_by_name
FROM notification_recipients nr
JOIN notification_events e ON e.id=nr.notification_event_id
JOIN notification_event_types et ON et.code=e.event_type_code
JOIN notification_severities sv ON sv.code=e.severity_code
LEFT JOIN tickets t ON t.id=e.ticket_id
LEFT JOIN schools school ON school.id=t.origin_school_id
LEFT JOIN districts district ON district.id=t.origin_district_id
LEFT JOIN devices device ON device.id=t.device_id
LEFT JOIN ticket_logistics_cases lc ON lc.id=e.logistics_case_id
LEFT JOIN logistics_handoffs h ON e.source_type='LOGISTICS_HANDOFF'
  AND h.id=CAST(e.source_id AS UNSIGNED)
LEFT JOIN repair_jobs rj ON rj.id=e.repair_job_id
LEFT JOIN service_locations location ON location.id=COALESCE(rj.repair_centre_location_id,lc.repair_centre_location_id)
LEFT JOIN sla_instances si ON si.id=e.sla_instance_id
LEFT JOIN escalation_cases ec ON ec.id=e.escalation_case_id
LEFT JOIN users creator ON creator.id=e.created_by;
