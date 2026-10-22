# Repair Centre Stock Location Model (Phase 8C-B2)

`device_stock_locations` is the authoritative record that an unencumbered
`AVAILABLE` device has been physically accepted into a Repair Centre's stock.
It is distinct from Phase 5 educational allocation, device lifecycle, ticket
status, and active logistics/manufacturer/repair custody.

## Storage and Read Models

- `device_stock_locations` retains every placement and release. Intake inserts a
  new `IN_STOCK` row; release closes only that row with `RELEASED`, `removed_at`,
  `removed_by`, and a null `active_record_key`. Rows are not deleted or moved by
  changing `service_location_id`.
- `UNIQUE (device_id, active_record_key)` permits no more than one active row
  per device; released rows have a null key and remain as history. Foreign keys
  protect device, location, and actor references. A check constraint keeps the
  active/released fields internally consistent.
- `v_device_current_stock_location` exposes at most one active location per
  device, its placement details, and `REPAIR_CENTRE_STOCK` / `Repair Centre
  Stock`. It derives replacement reservation from an active permanent
  replacement selection; reservation does not release physical stock.
- `v_device_stock_intake_eligibility` exposes lifecycle, educational allocation,
  and active physical-workflow/reservation flags. `v_device_stock_queue` joins
  the current stock location to the safe device identity and allocation fields.
- `service_locations` is the sole location catalogue. Intake requires an active
  `location_type = REPAIR_CENTRE` row; no separate stock-location catalogue or
  display-name inference is used.

## Intake and Release

`POST /api/device-stock/intake` requires `device_stock.intake`, an authenticated
actor, and a Repair Centre location in the actor's service-location scope
(unless `SUPER_ADMIN`). The Wappler transaction rechecks the eligibility view,
inserts the stock row, and writes an audit record. A non-`AVAILABLE` device,
student allocation, active stock, logistics case, manufacturer return, repair
job, replacement reservation, or replacement consumption is rejected. A DB
unique key resolves simultaneous intakes; one succeeds and one gets 409.

`POST /api/device-stock/release` requires `device_stock.release` and the same
location scope. Its transaction checks the active row and reservation state,
closes the row, and audits release. It does not reassign the device, modify
Phase 5, or alter lifecycle/ticket/work ownership. Duplicate or reserved-row
release gets 409; simultaneous release has one winner. Both transactions roll
back if audit insertion fails.

The stock APIs and Device Detail show physical stock only under their
authorization/scope rules. Device Detail displays stock only for `AVAILABLE`
devices without an active logistics, manufacturer-return, or repair workflow.
Phase 5 allocation remains separately labeled. Where physical workflows
exist, their custody takes precedence over stock, then educational allocation
is the fallback. The stock detail page labels active workflow custody rather
than presenting stock as its replacement.

## Permissions and Scope

- `SUPER_ADMIN`: view, intake, release across locations.
- `REPAIR_CENTRE`: view, intake, release only at assigned service locations.
- `MOE_HEAD_OFFICE` and `TSTT_OVERSIGHT`: national view, no mutation.
- TTPost, school, and technical users: no stock permissions.
- District view was not granted in this foundation; it can be added later with
  an explicit district-scoped read rule.

Frontend visibility is convenience only. The Server Connect actions enforce
permission and scope independently. Read APIs return no student information.

## Boundary With Phase 8C-B and 8D

The physical-location Gate 0 prerequisite for existing-inventory candidate
selection now exists. `permanent-replacements/source-options.json` and
`permanent-replacements/select.json` are deliberately unchanged and still
block `EXISTING_INVENTORY`. The next pass must select only an eligible,
unreserved device physically in the same Repair Centre as the replacement
case. Selection must leave stock active and mark it reserved; final acceptance
in 8C-C will consume/release it in a controlled transaction.

No temporary-loan workflow or table was created. Phase 8D can reuse this
stock-location history but must add its own specialized custody rules.

Migration: `database/phase_08c_b2_device_stock_location.sql`.
