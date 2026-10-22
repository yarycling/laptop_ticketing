-- Repeatable administration metadata/read models. No runtime SQL or triggers.
CREATE TABLE IF NOT EXISTS user_administration_lock (
 id TINYINT UNSIGNED PRIMARY KEY, touched_at DATETIME(3) NULL
) ENGINE=InnoDB;
INSERT IGNORE INTO user_administration_lock(id) VALUES (1);
CREATE TABLE IF NOT EXISTS role_administration_profiles (
 role_id INT UNSIGNED PRIMARY KEY, scope_type VARCHAR(30) NOT NULL,
 assignable TINYINT NOT NULL DEFAULT 1,
 FOREIGN KEY (role_id) REFERENCES roles(id)
) ENGINE=InnoDB;
INSERT INTO role_administration_profiles(role_id,scope_type) SELECT id,'GLOBAL' FROM roles WHERE name='SUPER_ADMIN' ON DUPLICATE KEY UPDATE scope_type=VALUES(scope_type);
INSERT INTO role_administration_profiles(role_id,scope_type) SELECT id,'NATIONAL' FROM roles WHERE name='MOE_HEAD_OFFICE' ON DUPLICATE KEY UPDATE scope_type=VALUES(scope_type);
INSERT INTO role_administration_profiles(role_id,scope_type) SELECT id,'DISTRICT' FROM roles WHERE name='ICT_DISTRICT_COORDINATOR' ON DUPLICATE KEY UPDATE scope_type=VALUES(scope_type);
INSERT INTO role_administration_profiles(role_id,scope_type) SELECT id,'SCHOOL' FROM roles WHERE name='ICT_TECHNICAL_OFFICER' ON DUPLICATE KEY UPDATE scope_type=VALUES(scope_type);
INSERT INTO role_administration_profiles(role_id,scope_type) SELECT id,'SCHOOL' FROM roles WHERE name='SCHOOL_ADMINISTRATOR' ON DUPLICATE KEY UPDATE scope_type=VALUES(scope_type);
INSERT INTO role_administration_profiles(role_id,scope_type) SELECT id,'REPAIR_LOCATION' FROM roles WHERE name='REPAIR_CENTRE' ON DUPLICATE KEY UPDATE scope_type=VALUES(scope_type);
INSERT INTO role_administration_profiles(role_id,scope_type) SELECT id,'LOGISTICS_NATIONAL' FROM roles WHERE name='TTPOST_LOGISTICS' ON DUPLICATE KEY UPDATE scope_type=VALUES(scope_type);
INSERT INTO role_administration_profiles(role_id,scope_type) SELECT id,'NATIONAL' FROM roles WHERE name='TSTT_OVERSIGHT' ON DUPLICATE KEY UPDATE scope_type=VALUES(scope_type);
SET @ua_ddl = IF(EXISTS(SELECT 1 FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='password_reset_requests' AND column_name='purpose'), 'SELECT 1', "ALTER TABLE password_reset_requests ADD COLUMN purpose ENUM('PASSWORD_RESET','ACCOUNT_SETUP') NOT NULL DEFAULT 'PASSWORD_RESET'");
PREPARE ua_stmt FROM @ua_ddl; EXECUTE ua_stmt; DEALLOCATE PREPARE ua_stmt;
CREATE OR REPLACE VIEW admin_security_groups AS
 SELECT r.id,r.name,r.label,r.description,p.scope_type,p.assignable,
 (SELECT COUNT(*) FROM user_roles ur WHERE ur.role_id=r.id) AS user_count
 FROM roles r JOIN role_administration_profiles p ON p.role_id=r.id;
CREATE OR REPLACE VIEW admin_user_roles AS
 SELECT ur.user_id,r.id,r.name,r.label,r.description,p.scope_type,p.assignable
 FROM user_roles ur JOIN roles r ON r.id=ur.role_id
 LEFT JOIN role_administration_profiles p ON p.role_id=r.id;
CREATE OR REPLACE VIEW admin_user_scopes AS
 SELECT s.id,s.user_id,'NATIONAL' AS scope_type,NULL AS entity_id,NULL AS district_id,'National' AS label,1 AS entity_active FROM user_national_scopes s WHERE s.status='active'
 UNION ALL SELECT s.id,s.user_id,'DISTRICT',d.id,d.id,d.name,d.status='active' FROM user_district_scopes s JOIN districts d ON d.id=s.district_id WHERE s.status='active'
 UNION ALL SELECT s.id,s.user_id,'SCHOOL',sch.id,sch.district_id,COALESCE(CONCAT(d.name,' / ',sch.name),sch.name),sch.status='active' AND (d.id IS NULL OR d.status='active') FROM user_school_scopes s JOIN schools sch ON sch.id=s.school_id LEFT JOIN districts d ON d.id=sch.district_id WHERE s.status='active'
 UNION ALL SELECT s.id,s.user_id,'REPAIR_LOCATION',l.id,NULL,l.name,l.is_active=1 AND l.location_type='REPAIR_CENTRE' FROM user_service_location_scopes s JOIN service_locations l ON l.id=s.service_location_id WHERE s.status='active';
CREATE OR REPLACE VIEW admin_user_directory AS
 SELECT u.id,u.username,u.email,u.display_name,u.status,u.last_login_at,u.password_changed_at,u.created_at,u.updated_at,u.auth_version,
 (SELECT GROUP_CONCAT(r.label ORDER BY r.name SEPARATOR ', ') FROM admin_user_roles r WHERE r.user_id=u.id) AS security_groups,
 (SELECT CONCAT('|',GROUP_CONCAT(r.name ORDER BY r.name SEPARATOR '|'),'|') FROM admin_user_roles r WHERE r.user_id=u.id) AS role_codes,
 COALESCE((SELECT GROUP_CONCAT(s.label ORDER BY s.scope_type,s.entity_id SEPARATOR '; ') FROM admin_user_scopes s WHERE s.user_id=u.id),
 CASE WHEN EXISTS(SELECT 1 FROM admin_user_roles r WHERE r.user_id=u.id AND r.name='SUPER_ADMIN') THEN 'Global' WHEN EXISTS(SELECT 1 FROM admin_user_roles r WHERE r.user_id=u.id AND r.name='TTPOST_LOGISTICS') THEN 'National logistics' ELSE 'No assigned scope' END) AS scope_summary,
 (SELECT CONCAT('|',GROUP_CONCAT(DISTINCT s.district_id SEPARATOR '|'),'|') FROM admin_user_scopes s WHERE s.user_id=u.id AND s.district_id IS NOT NULL) AS district_ids
 FROM users u;
INSERT IGNORE INTO role_permissions(role_id,permission_id)
 SELECT r.id,p.id FROM roles r CROSS JOIN permissions p WHERE r.name='SUPER_ADMIN' AND p.name IN ('users.view','users.create','users.update','users.disable','roles.view','user_scopes.manage');
