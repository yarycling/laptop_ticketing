-- Carrier directory; TTPOST is the sole initial active default.
CREATE TABLE IF NOT EXISTS carriers (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  carrier_code VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  name VARCHAR(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  carrier_type VARCHAR(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  is_default TINYINT(1) NOT NULL DEFAULT 0,
  status VARCHAR(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  active_default_key TINYINT GENERATED ALWAYS AS (CASE WHEN status = 'active' AND is_default = 1 THEN 1 ELSE NULL END) STORED,
  sort_order SMALLINT UNSIGNED NOT NULL DEFAULT 100,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id), UNIQUE KEY uq_carriers_code (carrier_code), UNIQUE KEY uq_carriers_active_default (active_default_key),
  KEY idx_carriers_status_sort (status,sort_order),
  CONSTRAINT chk_carriers_type CHECK (carrier_type IN ('TTPOST','EXTERNAL')),
  CONSTRAINT chk_carriers_status CHECK (status IN ('active','inactive'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO carriers (carrier_code,name,carrier_type,is_default,status,sort_order)
SELECT 'TTPOST','TTPost','TTPOST',1,'active',10
WHERE NOT EXISTS (SELECT 1 FROM carriers WHERE carrier_code='TTPOST');

-- Normalize a pre-existing directory to the single supported initial default.
UPDATE carriers SET is_default=0 WHERE carrier_code<>'TTPOST' AND status='active' AND is_default=1;
UPDATE carriers SET name='TTPost',carrier_type='TTPOST',is_default=1,status='active',sort_order=10 WHERE carrier_code='TTPOST';
