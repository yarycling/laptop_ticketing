-- Phase 6C district approval history. Safe to re-run.
CREATE TABLE IF NOT EXISTS ticket_district_approvals (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  ticket_id INT UNSIGNED NOT NULL,
  decision VARCHAR(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  decision_note TEXT COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  decided_by_user_id INT UNSIGNED NOT NULL,
  decided_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_ticket_district_approvals_ticket_decided (ticket_id, decided_at),
  KEY idx_ticket_district_approvals_decided_by (decided_by_user_id),
  KEY idx_ticket_district_approvals_decision (decision),
  CONSTRAINT fk_ticket_district_approvals_ticket FOREIGN KEY (ticket_id) REFERENCES tickets (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_ticket_district_approvals_decided_by FOREIGN KEY (decided_by_user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
