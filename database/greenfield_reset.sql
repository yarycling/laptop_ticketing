-- DESTRUCTIVE DEVELOPMENT/TEST RESET
-- DO NOT RUN AGAINST PRODUCTION.
-- Database: laptop_tickets_db (MySQL 5.7).
-- Preserve schema, migration state (not stored as app tables), seeded reference
-- data, canonical districts, SLA baseline policy version 1, and runtime config.
-- Clears all mutable application/test data. Re-running is destructive.

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE audit_logs;
TRUNCATE TABLE devices;
TRUNCATE TABLE device_district_allocations;
TRUNCATE TABLE device_import_batches;
TRUNCATE TABLE device_import_rows;
TRUNCATE TABLE device_replacements;
TRUNCATE TABLE device_school_allocations;
TRUNCATE TABLE device_stock_locations;
TRUNCATE TABLE device_student_assignments;
TRUNCATE TABLE escalation_assignments;
TRUNCATE TABLE escalation_cases;
TRUNCATE TABLE escalation_history;
TRUNCATE TABLE exception_case_status_history;
TRUNCATE TABLE exception_decisions;
TRUNCATE TABLE exception_financial_assessments;
TRUNCATE TABLE logistics_handoffs;
TRUNCATE TABLE logistics_handoff_scans;
TRUNCATE TABLE logistics_status_history;
TRUNCATE TABLE manufacturer_return_cases;
TRUNCATE TABLE manufacturer_return_outcomes;
TRUNCATE TABLE manufacturer_return_shipments;
TRUNCATE TABLE manufacturer_return_status_history;
TRUNCATE TABLE manufacturer_supplied_unit_acceptances;
TRUNCATE TABLE manufacturer_supplied_units;
TRUNCATE TABLE notification_deliveries;
TRUNCATE TABLE notification_delivery_attempts;
TRUNCATE TABLE notification_events;
TRUNCATE TABLE notification_recipients;
TRUNCATE TABLE permanent_replacement_allocation_transfers;
TRUNCATE TABLE permanent_replacement_cases;
TRUNCATE TABLE permanent_replacement_status_history;
TRUNCATE TABLE password_reset_requests;
TRUNCATE TABLE repair_assessments;
TRUNCATE TABLE repair_exception_cases;
TRUNCATE TABLE repair_jobs;
TRUNCATE TABLE repair_work_logs;
TRUNCATE TABLE schools;
TRUNCATE TABLE service_locations;
TRUNCATE TABLE sla_calendar_override_history;
TRUNCATE TABLE sla_calendar_overrides;
TRUNCATE TABLE sla_instance_events;
TRUNCATE TABLE sla_instances;
TRUNCATE TABLE spare_pools;
TRUNCATE TABLE students;
TRUNCATE TABLE temporary_loan_conversion_decisions;
TRUNCATE TABLE temporary_loan_conversion_requests;
TRUNCATE TABLE temporary_loan_custody_history;
TRUNCATE TABLE temporary_loan_decisions;
TRUNCATE TABLE temporary_loan_cases;
TRUNCATE TABLE temporary_loan_spare_reservations;
TRUNCATE TABLE temporary_loan_status_history;
TRUNCATE TABLE ticket_assignments;
TRUNCATE TABLE ticket_comments;
TRUNCATE TABLE ticket_diagnoses;
TRUNCATE TABLE ticket_district_approvals;
TRUNCATE TABLE ticket_logistics_cases;
TRUNCATE TABLE ticket_status_history;
TRUNCATE TABLE tickets;
TRUNCATE TABLE user_district_scopes;
TRUNCATE TABLE user_national_scopes;
TRUNCATE TABLE user_roles;
TRUNCATE TABLE user_school_scopes;
TRUNCATE TABLE user_service_location_scopes;
TRUNCATE TABLE users;

-- These directories contain only Phase 4B/7C/7D/8B test records, not seed data.
DELETE FROM device_models;
DELETE FROM manufacturers;
DELETE FROM carriers WHERE carrier_code <> 'TTPOST';

-- Retain the migration-seeded baseline policy versions; remove GUI test edits.
DELETE FROM sla_policy_versions WHERE version_number <> 1;
UPDATE sla_policies SET created_by = NULL, updated_by = NULL;
UPDATE escalation_rules SET created_by = NULL, updated_by = NULL;
UPDATE sla_calendars SET created_by = NULL, updated_by = NULL;

SET FOREIGN_KEY_CHECKS = 1;
