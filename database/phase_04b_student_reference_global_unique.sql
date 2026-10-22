-- Student references are globally unique, regardless of school assignment.
-- Read-only preflight confirmed there are no existing cross-school duplicates.
ALTER TABLE students
  DROP INDEX uq_students_school_reference,
  ADD UNIQUE KEY uq_students_student_reference (student_reference);
