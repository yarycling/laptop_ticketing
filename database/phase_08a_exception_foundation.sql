-- Phase 8A exception and disposition foundation. Safe to apply repeatedly.

CREATE TABLE IF NOT EXISTS exception_case_statuses (
  code VARCHAR(50) NOT NULL,
  name VARCHAR(120) NOT NULL,
  sort_order SMALLINT UNSIGNED NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (code),
  KEY idx_exception_case_statuses_active_sort (is_active, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO exception_case_statuses (code, name, sort_order) VALUES
 ('ASSESSMENT_REQUIRED','Assessment Required',10),
 ('PENDING_DISTRICT_APPROVAL','Pending District Approval',20),
 ('PENDING_DISTRICT_DECISION','Pending District Decision',30),
 ('PENDING_HEAD_OFFICE_APPROVAL','Pending Head Office Approval',40),
 ('REPAIR_CENTRE_REVIEW_REQUIRED','Repair Centre Review Required',50),
 ('MANUFACTURER_RETURN_APPROVED','Manufacturer Return Approved',60),
 ('REPLACEMENT_APPROVED','Replacement Approved',70);

CREATE TABLE IF NOT EXISTS exception_dispositions (
  code VARCHAR(50) NOT NULL,
  name VARCHAR(120) NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT IGNORE INTO exception_dispositions (code,name) VALUES
 ('MANUFACTURER_RETURN','Manufacturer Return'),
 ('PERMANENT_REPLACEMENT','Permanent Replacement');

CREATE TABLE IF NOT EXISTS exception_warranty_decisions (
  code VARCHAR(30) NOT NULL,
  name VARCHAR(80) NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT IGNORE INTO exception_warranty_decisions (code,name) VALUES
 ('PENDING','Pending'),('COVERED','Covered'),('NOT_COVERED','Not Covered');

CREATE TABLE IF NOT EXISTS exception_responsibility_parties (
  code VARCHAR(40) NOT NULL,
  name VARCHAR(100) NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT IGNORE INTO exception_responsibility_parties (code,name) VALUES
 ('WARRANTY_MANUFACTURER','Warranty Manufacturer'),('TSTT','TSTT'),('MOE','Ministry of Education'),
 ('PARENT_GUARDIAN','Parent / Guardian'),('UNDETERMINED','Undetermined');

CREATE TABLE IF NOT EXISTS exception_negligence_determinations (
  code VARCHAR(30) NOT NULL,
  name VARCHAR(80) NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT IGNORE INTO exception_negligence_determinations (code,name) VALUES
 ('NOT_ASSESSED','Not Assessed'),('NO_EVIDENCE','No Evidence'),('SUSPECTED','Suspected'),('CONFIRMED','Confirmed');

CREATE TABLE IF NOT EXISTS exception_financial_statuses (
  code VARCHAR(30) NOT NULL,
  name VARCHAR(80) NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT IGNORE INTO exception_financial_statuses (code,name) VALUES
 ('PENDING','Pending'),('ESTIMATED','Estimated'),('APPROVED','Approved'),('INCURRED','Incurred'),('NOT_APPLICABLE','Not Applicable');

CREATE TABLE IF NOT EXISTS exception_decision_types (
  code VARCHAR(50) NOT NULL,
  name VARCHAR(120) NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT IGNORE INTO exception_decision_types (code,name) VALUES
 ('DISTRICT_MANUFACTURER_APPROVAL','District Manufacturer Return Approval'),
 ('DISTRICT_DISPOSITION_DECISION','District Disposition Decision'),
 ('HEAD_OFFICE_REPLACEMENT_APPROVAL','Head Office Replacement Approval'),
 ('REPAIR_CENTRE_SUBMISSION','Repair Centre Exception Submission'),
 ('RETURN_FOR_REVIEW','Return for Review');

CREATE TABLE IF NOT EXISTS repair_exception_cases (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  ticket_id INT UNSIGNED NOT NULL,
  logistics_case_id INT UNSIGNED NOT NULL,
  repair_job_id INT UNSIGNED NOT NULL,
  device_id INT UNSIGNED NOT NULL,
  originating_repair_outcome_id INT UNSIGNED NOT NULL,
  current_status_code VARCHAR(50) NOT NULL,
  recommended_disposition_code VARCHAR(50) NULL,
  created_by_user_id INT UNSIGNED NOT NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_repair_exception_cases_job (repair_job_id),
  KEY idx_repair_exception_cases_status (current_status_code, updated_at),
  KEY idx_repair_exception_cases_ticket (ticket_id),
  KEY idx_repair_exception_cases_district (ticket_id, current_status_code),
  CONSTRAINT fk_exception_case_ticket FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_exception_case_logistics FOREIGN KEY (logistics_case_id) REFERENCES ticket_logistics_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_exception_case_job FOREIGN KEY (repair_job_id) REFERENCES repair_jobs(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_exception_case_device FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_exception_case_outcome FOREIGN KEY (originating_repair_outcome_id) REFERENCES repair_outcomes(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_exception_case_status FOREIGN KEY (current_status_code) REFERENCES exception_case_statuses(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_exception_case_disposition FOREIGN KEY (recommended_disposition_code) REFERENCES exception_dispositions(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_exception_case_creator FOREIGN KEY (created_by_user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS exception_case_status_history (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  exception_case_id INT UNSIGNED NOT NULL,
  from_status_code VARCHAR(50) NULL,
  to_status_code VARCHAR(50) NOT NULL,
  actor_user_id INT UNSIGNED NOT NULL,
  reason VARCHAR(1000) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  KEY idx_exception_status_history_case_time (exception_case_id, created_at, id),
  CONSTRAINT fk_exception_status_history_case FOREIGN KEY (exception_case_id) REFERENCES repair_exception_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_exception_status_history_from FOREIGN KEY (from_status_code) REFERENCES exception_case_statuses(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_exception_status_history_to FOREIGN KEY (to_status_code) REFERENCES exception_case_statuses(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_exception_status_history_actor FOREIGN KEY (actor_user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS exception_financial_assessments (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  exception_case_id INT UNSIGNED NOT NULL,
  warranty_decision_code VARCHAR(30) NOT NULL,
  warranty_rejection_reason VARCHAR(1000) NULL,
  responsibility_party_code VARCHAR(40) NOT NULL,
  negligence_determination_code VARCHAR(30) NOT NULL,
  estimated_cost DECIMAL(12,2) NULL,
  approved_charge_amount DECIMAL(12,2) NULL,
  actual_cost DECIMAL(12,2) NULL,
  financial_status_code VARCHAR(30) NOT NULL,
  reference VARCHAR(120) NULL,
  notes VARCHAR(4000) NULL,
  created_by_user_id INT UNSIGNED NOT NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  KEY idx_exception_assessments_case_time (exception_case_id, created_at, id),
  CONSTRAINT fk_exception_assessment_case FOREIGN KEY (exception_case_id) REFERENCES repair_exception_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_exception_assessment_warranty FOREIGN KEY (warranty_decision_code) REFERENCES exception_warranty_decisions(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_exception_assessment_party FOREIGN KEY (responsibility_party_code) REFERENCES exception_responsibility_parties(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_exception_assessment_negligence FOREIGN KEY (negligence_determination_code) REFERENCES exception_negligence_determinations(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_exception_assessment_financial FOREIGN KEY (financial_status_code) REFERENCES exception_financial_statuses(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_exception_assessment_actor FOREIGN KEY (created_by_user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT chk_exception_assessment_estimated_cost CHECK (estimated_cost IS NULL OR estimated_cost >= 0),
  CONSTRAINT chk_exception_assessment_approved_charge CHECK (approved_charge_amount IS NULL OR approved_charge_amount >= 0),
  CONSTRAINT chk_exception_assessment_actual_cost CHECK (actual_cost IS NULL OR actual_cost >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS exception_decisions (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  exception_case_id INT UNSIGNED NOT NULL,
  decision_type_code VARCHAR(50) NOT NULL,
  selected_disposition_code VARCHAR(50) NULL,
  decision_code VARCHAR(50) NOT NULL,
  reason VARCHAR(1000) NULL,
  actor_user_id INT UNSIGNED NOT NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  KEY idx_exception_decisions_case_time (exception_case_id, created_at, id),
  KEY idx_exception_decisions_type (decision_type_code, decision_code),
  CONSTRAINT fk_exception_decision_case FOREIGN KEY (exception_case_id) REFERENCES repair_exception_cases(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_exception_decision_type FOREIGN KEY (decision_type_code) REFERENCES exception_decision_types(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_exception_decision_disposition FOREIGN KEY (selected_disposition_code) REFERENCES exception_dispositions(code) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_exception_decision_actor FOREIGN KEY (actor_user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
