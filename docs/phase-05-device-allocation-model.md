# Phase 5 Device Allocation and Assignment Model

## Purpose and Scope

Phase 5A establishes historical allocation and student-assignment storage plus a derived current-custody read model. Later phases add the forward allocation/assignment workflows. Phase 5E adds explicit reverse custody returns and read-only history; it does not add logistics/movement, TTPost, tickets, repairs, temporary spares, permanent replacements, or manufacturer returns.

The hierarchy is **Central inventory → District allocation → School allocation → Student assignment**. Device lifecycle, inventory allocation/custody, student assignment, and logistics movement are distinct concepts. This model does not add mutable current-holder or location cache columns/tables.

## Historical Records

- `device_district_allocations` records device-to-district allocations, their actor and time, optional return information, notes, and audit-friendly timestamps.
- `device_school_allocations` records school allocations linked to a district-allocation parent for the same device.
- `device_student_assignments` records student assignments linked to a school-allocation parent for the same device. `assignment_type` is a flexible string, defaulting to `PRIMARY`; future values may include temporary-spare or permanent-replacement concepts without implementing those workflows here.

Each table uses `active_record_key = 1` for its active row and `NULL` for ended historical rows. A unique key on `(device_id, active_record_key)` allows one active row per device while allowing multiple ended rows because MySQL permits multiple `NULL` values in a unique index. No active uniqueness is imposed on `student_id`, so future workflows can associate multiple devices with one student.

Foreign keys use restrictive delete/update behavior. Historical allocation and assignment rows are not cascade-deleted from devices, districts, schools, students, or users. Composite parent keys and child foreign keys enforce that a school allocation references a district allocation for the same device and a student assignment references a school allocation for the same device.

## Current Custody Read Model

`v_device_current_custody` is derived from the historical tables and includes every device. It resolves only child rows whose parent is active and whose device lineage matches. Precedence is `STUDENT`, then `SCHOOL`, then `DISTRICT`, then `CENTRAL`. The view does not mutate or cache current state.

Future scope behavior: SUPER_ADMIN/national scope can see all devices; district scope includes devices whose active district allocation belongs to an assigned district, including descendants at schools/students; school scope includes devices whose active school allocation belongs to an assigned school, including student assignments there; central inventory comprises devices with no active district allocation.

## Return and Reassignment Rules (Phase 5E)

Returns follow the controlled reverse chain **Student → School → District → Central**. Each level is returned explicitly; there is no cascade return. A parent allocation cannot close while its active child record remains. Student returns require lifecycle `ASSIGNED` and change it to `AVAILABLE`; school and district returns require lifecycle `AVAILABLE` and preserve it. Current custody is derived from the remaining active lineage.

Every return requires a trimmed nonblank `return_reason` of at most 500 characters, stored in the existing return column. Return actor and server timestamp are recorded with it. Existing allocation/assignment rows are never deleted or overwritten; a return closes only the active row by setting `returned_at`, `returned_by_user_id`, `return_reason`, and `active_record_key = NULL`.

Return permissions are `device_student_returns.manage`, `device_school_returns.manage`, and `device_district_returns.manage`. SUPER_ADMIN and MOE_HEAD_OFFICE receive all three; SCHOOL_ADMINISTRATOR receives student return only; ICT_DISTRICT_COORDINATOR receives school return only. TSTT oversight, ICT technical officers, repair-centre, and TTPost logistics receive none. Student return is limited to authorized school scope or national/SUPER_ADMIN authority; school return to authorized district scope or national/SUPER_ADMIN authority; district return to national/SUPER_ADMIN authority.

Reassignment is **return + the existing forward workflow**, never an overwrite-style transfer. A student return is followed by the Phase 5D assignment action; a school return by Phase 5C allocation; a district return by Phase 5B allocation. Historical rows remain queryable through active, historical, and all filters.

Existing scoped history list APIs accept an exact `device_id` filter. It combines with, and never replaces, the API's permission and organizational-scope predicates. Device detail renders separate district, school, and minimal student history sections only when the corresponding existing view permission is present.

## Future Workflow Rules

Later application phases must require an active district allocation before school allocation, require the target school to belong to that district, require an active school allocation before student assignment, and require the student to currently belong to that school. A district allocation cannot be returned while an active child school allocation exists; a school allocation cannot be returned while an active student assignment exists. Student assignment must end before reassignment. These are application workflow rules for future Server Connect actions; Phase 5A adds no triggers.

Future lifecycle interaction is documented, not implemented: central-to-district and district-to-school allocation leave lifecycle `AVAILABLE`; school-to-student assignment changes `AVAILABLE` to `ASSIGNED`; student return changes `ASSIGNED` to `AVAILABLE`. Allocation records do not replace lifecycle status.

Allocation permissions and role mappings are deferred until the corresponding action phases. Future actions must write audit events through the established audit mechanism.
