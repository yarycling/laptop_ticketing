# Greenfield Reset Baseline

## Pre-Reset Record

- Date: 2026-10-17 (America/Port_of_Spain)
- Database: `laptop_tickets_db`
- Backup: `/tmp/laptop_tickets_db_pre_greenfield_20261017_150315.sql`
- Backup size: 5,654,083 bytes; `mysqldump` exit code 0
- Pre-reset row counts for every base table: [`/tmp/greenfield_pre_reset_counts.txt`](/tmp/greenfield_pre_reset_counts.txt)
- Inventory: 102 base tables and 35 views. Views are schema read models and are preserved.
- Classification was completed before reset execution. No schema, migration files, Wappler application configuration, or views are reset.

## Table Classification

### REFERENCE_CONFIG_PRESERVE

These tables hold migration-seeded catalog, security, workflow, calendar, and policy configuration. Mixed tables are handled by guarded cleanup noted below.

`carriers` (preserve canonical `TTPOST` row only); `device_conditions`; `device_lifecycle_statuses`; `districts`; `escalation_rules`; `escalation_states`; `exception_case_statuses`; `exception_decision_types`; `exception_dispositions`; `exception_financial_statuses`; `exception_negligence_determinations`; `exception_responsibility_parties`; `exception_warranty_decisions`; `logistics_statuses`; `manufacturer_return_statuses`; `notification_channels`; `notification_channel_rules`; `notification_delivery_statuses`; `notification_event_types`; `notification_severities`; `permanent_replacement_statuses`; `permissions`; `repair_outcomes`; `roles`; `role_permissions`; `sla_calendars`; `sla_calendar_dates`; `sla_calendar_weekdays`; `sla_instance_states`; `sla_policies`; `sla_policy_versions` (retain migration baseline version 1 only); `temporary_loan_conversion_reasons`; `temporary_loan_conversion_statuses`; `temporary_loan_return_conditions`; `temporary_loan_return_reasons`; `temporary_loan_statuses`; `ticket_statuses`.

Canonical district seed provenance is `database/phase_03_organisation_scope.sql`. Carrier provenance is `database/phase_08b_carriers.sql`. SLA baseline policy/calendar provenance is `database/phase_09a_sla_foundation.sql`; escalation rule/state provenance is `database/phase_09c_escalation_management.sql`. Other status/catalog seeds were inspected in their corresponding phase migrations.

### OPERATIONAL_CLEAR

`audit_logs`; `devices`; `device_district_allocations`; `device_import_batches`; `device_import_rows`; `device_replacements`; `device_school_allocations`; `device_stock_locations`; `device_student_assignments`; `device_models`; `manufacturers`; `escalation_assignments`; `escalation_cases`; `escalation_history`; `exception_case_status_history`; `exception_decisions`; `exception_financial_assessments`; `logistics_handoffs`; `logistics_handoff_scans`; `logistics_status_history`; `manufacturer_return_cases`; `manufacturer_return_outcomes`; `manufacturer_return_shipments`; `manufacturer_return_status_history`; `manufacturer_supplied_unit_acceptances`; `manufacturer_supplied_units`; `notification_deliveries`; `notification_delivery_attempts`; `notification_events`; `notification_recipients`; `permanent_replacement_allocation_transfers`; `permanent_replacement_cases`; `permanent_replacement_status_history`; `repair_assessments`; `repair_exception_cases`; `repair_jobs`; `repair_work_logs`; `schools`; `service_locations`; `sla_calendar_override_history`; `sla_calendar_overrides`; `sla_instance_events`; `sla_instances`; `spare_pools`; `students`; `temporary_loan_conversion_decisions`; `temporary_loan_conversion_requests`; `temporary_loan_custody_history`; `temporary_loan_decisions`; `temporary_loan_cases`; `temporary_loan_spare_reservations`; `temporary_loan_status_history`; `ticket_assignments`; `ticket_comments`; `ticket_diagnoses`; `ticket_district_approvals`; `ticket_logistics_cases`; `ticket_status_history`; `tickets`; `user_district_scopes`; `user_national_scopes`; `user_roles`; `user_school_scopes`; `user_service_location_scopes`; `users`.

`device_models`, `manufacturers`, and all `service_locations` were inspected; every current record is a dated test fixture rather than immutable seed data. Test carrier rows are removed with `DELETE WHERE carrier_code <> 'TTPOST'`. SLA policy versions above baseline version 1 are removed; policy/calendar actor references are nulled as needed before user cleanup. All pure operational tables are truncated to reset auto-increment.

### SYSTEM_METADATA_PRESERVE

No system-metadata base tables exist in this database. All 35 views are preserved: `user_effective_permissions`, `user_login_identities`, `v_device_current_custody`, `v_device_current_stock_location`, `v_device_stock_intake_eligibility`, `v_device_stock_queue`, `v_escalation_case_targets`, `v_escalation_operational_queue`, `v_logistics_case_detail_context`, `v_logistics_current_context`, `v_logistics_physical_custody`, `v_logistics_return_device`, `v_manufacturer_return_physical_custody`, `v_manufacturer_return_queue`, `v_notification_inbox`, `v_notification_unread_recipients`, `v_permanent_replacement_inventory_candidates`, `v_permanent_replacement_queue`, `v_repair_current_context`, `v_sla_calendar_business_dates`, `v_sla_completion_context`, `v_sla_evaluation_queue`, `v_sla_operational_queue`, `v_sla_policy_current`, `v_sla_policy_version_history`, `v_temporary_loan_queue`, `v_temporary_loan_request_context`, `v_temporary_loan_spare_candidates`, `v_ticket_activity`, `v_ticket_activity_08d_a`, `v_ticket_activity_08d_b`, `v_ticket_activity_08d_e`, `v_ticket_current_context`, `v_ticket_effective_device`, and `v_ticket_operational_metrics`.

## Pre-Reset Counts

The complete captured count listing (102 rows, one for every base table) is saved at `/tmp/greenfield_pre_reset_counts.txt` and reproduced here. It was captured before any deletion. Prominent test-state counts included 90 devices, 82 tickets, 46 logistics cases, 43 repair jobs, 23 manufacturer-return cases, 15 permanent-replacement cases, 23 temporary loans, 24 SLA instances, and 25 users.

```text
audit_logs 3306
carriers 3
devices 90
device_conditions 6
device_district_allocations 73
device_import_batches 26
device_import_rows 15045
device_lifecycle_statuses 11
device_models 5
device_replacements 13
device_school_allocations 72
device_stock_locations 30
device_student_assignments 17
districts 8
escalation_assignments 4
escalation_cases 2
escalation_history 7
escalation_rules 8
escalation_states 4
exception_case_statuses 10
exception_case_status_history 149
exception_decisions 73
exception_decision_types 5
exception_dispositions 2
exception_financial_assessments 37
exception_financial_statuses 5
exception_negligence_determinations 4
exception_responsibility_parties 5
exception_warranty_decisions 3
logistics_handoffs 118
logistics_handoff_scans 231
logistics_statuses 9
logistics_status_history 236
manufacturers 4
manufacturer_return_cases 23
manufacturer_return_outcomes 17
manufacturer_return_shipments 38
manufacturer_return_statuses 7
manufacturer_return_status_history 129
manufacturer_supplied_units 4
manufacturer_supplied_unit_acceptances 4
notification_channels 1
notification_channel_rules 21
notification_deliveries 23
notification_delivery_attempts 25
notification_delivery_statuses 7
notification_events 72
notification_event_types 24
notification_recipients 160
notification_severities 4
permanent_replacement_allocation_transfers 13
permanent_replacement_cases 15
permanent_replacement_statuses 5
permanent_replacement_status_history 31
permissions 111
repair_assessments 44
repair_exception_cases 31
repair_jobs 43
repair_outcomes 5
repair_work_logs 16
roles 8
role_permissions 282
schools 3
service_locations 5
sla_calendars 1
sla_calendar_dates 30000
sla_calendar_overrides 1
sla_calendar_override_history 10
sla_calendar_weekdays 7
sla_instances 24
sla_instance_events 49
sla_instance_states 7
sla_policies 5
sla_policy_versions 7
spare_pools 1
students 11
temporary_loan_cases 23
temporary_loan_conversion_decisions 9
temporary_loan_conversion_reasons 5
temporary_loan_conversion_requests 9
temporary_loan_conversion_statuses 3
temporary_loan_custody_history 37
temporary_loan_decisions 22
temporary_loan_return_conditions 5
temporary_loan_return_reasons 5
temporary_loan_spare_reservations 18
temporary_loan_statuses 10
temporary_loan_status_history 113
tickets 82
ticket_assignments 36
ticket_comments 22
ticket_diagnoses 59
ticket_district_approvals 50
ticket_logistics_cases 46
ticket_statuses 8
ticket_status_history 283
users 25
user_district_scopes 10
user_national_scopes 9
user_roles 25
user_school_scopes 9
user_service_location_scopes 3
```

## Reset SQL

`database/greenfield_reset.sql` uses MySQL 5.7-compatible administrative SQL, disables FK checks only for the explicit operational TRUNCATE allowlist, restores FK checks, and does not alter schema or preserved seeded catalogs. This file is intentionally destructive and must never be run against production.

## Execution Results

Reset completed 2026-10-17. The backup was verified before execution. `database/greenfield_reset.sql` returned exit code 0; the schema, migration-defined catalogs, and 35 views remain present.

### Post-Reset Counts

- Users: 1 (`yarycling`, `active`); old users: 0.
- User-role assignments: 1 (`SUPER_ADMIN`); national/district/school/service-location scopes: 0. SUPER_ADMIN is explicitly bypassed by the permission guard and does not require a fabricated scope row.
- The 65 classified operational tables are zero, except `users` (1), `user_roles` (1), and `audit_logs` (3). Those three audit entries are only the new `initial_admin_created` event and the two successful `login_success` events for the new account; there is no pre-reset/development audit history.
- Devices, allocations, import batches/rows, schools, operational locations, students, tickets, logistics cases/handoffs, repairs, exceptions, manufacturer returns, permanent replacements, temporary loans, SLA instances/events/overrides, escalation cases/history, notifications/recipients/deliveries/attempts: all 0.
- Canonical districts: 8; schools: 0; service locations: 0; carriers: 1 (canonical TTPost); device models/manufacturers: 0 (the prior records were all test fixtures).
- Roles: 8; permissions: 111; role-permission mappings: 282; ticket statuses: 8; device lifecycle statuses: 11; logistics statuses: 9; repair outcomes: 5; Phase 8 exception/return/replacement/loan lookup tables retained.
- SLA calendars: 1; business calendar weekdays: 7; calendar dates: 30,000; policy definitions: 5; retained baseline version 1 policies: 5; escalation rules: 8.
- Notification event types: 24; severities: 4; email delivery statuses: 7; active email channel rules: 21. Triggers: 0.

### Super Admin and Login

- Account: `yarycling`; role `SUPER_ADMIN`; status `active`; display name `Super Administrator`.
- The Wappler initial-admin action generated the password using the application's Argon2id implementation. The API requires an email value; `yarycling@localhost` is a non-routable local placeholder, not a personal address. Password is supplied securely by project owner and is not recorded here.
- Login: PASS (HTTP 200). `/api/auth/me`: HTTP 200 with the new active account. `/api/auth/context`: HTTP 200, role `SUPER_ADMIN`, `is_super_admin: true`, and full Super Admin permissions.

### Empty-Screen Functional Check

Using the authenticated browser session, the dashboard and shell/navigation loaded. Devices, tickets, logistics, repairs, SLA tracking, escalations, notifications, Organisation, SLA Management, and Escalation Rules pages loaded. Operational list tables had headers but no data rows; no error/500 state appeared. The organisation screen showed the retained district master list. This was functional verification only, not visual acceptance, and no business records were created.

### Mailer and Scheduler

The reset was database-only. `app/modules/Mailer/mail.json`, `app/api/test-email.json`, and `app/schedule/notification-email-retry.json` were not edited; their modification times predate this reset. Email channel configuration remains in the database.

### Final Status

Database reset: PASS. Application baseline: GREENFIELD READY for full top-down manual retest. No Wappler restart is required based on successful post-reset authentication and application-page checks. User commands required: NONE.
