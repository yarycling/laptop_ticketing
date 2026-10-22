-- Exposes one row for each student with an active primary laptop assignment.
-- Keeping the literal eligibility rules in a view lets Wappler join using
-- column-to-column clauses only, which its query builder requires.
CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW v_device_active_primary_student_assignments AS
SELECT assignment.student_id
FROM device_student_assignments AS assignment
WHERE assignment.assignment_type = 'PRIMARY'
  AND assignment.active_record_key = 1
GROUP BY assignment.student_id;
