-- MySQL dump 10.13  Distrib 5.7.39, for osx10.12 (x86_64)
--
-- Host: localhost    Database: laptop_tickets_db
-- ------------------------------------------------------
-- Server version	5.7.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `laptop_tickets_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `laptop_tickets_db` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `laptop_tickets_db`;

--
-- Temporary table structure for view `admin_security_groups`
--

DROP TABLE IF EXISTS `admin_security_groups`;
/*!50001 DROP VIEW IF EXISTS `admin_security_groups`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `admin_security_groups` AS SELECT 
 1 AS `id`,
 1 AS `name`,
 1 AS `label`,
 1 AS `description`,
 1 AS `scope_type`,
 1 AS `assignable`,
 1 AS `user_count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `admin_user_directory`
--

DROP TABLE IF EXISTS `admin_user_directory`;
/*!50001 DROP VIEW IF EXISTS `admin_user_directory`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `admin_user_directory` AS SELECT 
 1 AS `id`,
 1 AS `username`,
 1 AS `email`,
 1 AS `display_name`,
 1 AS `status`,
 1 AS `last_login_at`,
 1 AS `password_changed_at`,
 1 AS `created_at`,
 1 AS `updated_at`,
 1 AS `auth_version`,
 1 AS `security_groups`,
 1 AS `role_codes`,
 1 AS `scope_summary`,
 1 AS `district_ids`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `admin_user_roles`
--

DROP TABLE IF EXISTS `admin_user_roles`;
/*!50001 DROP VIEW IF EXISTS `admin_user_roles`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `admin_user_roles` AS SELECT 
 1 AS `user_id`,
 1 AS `id`,
 1 AS `name`,
 1 AS `label`,
 1 AS `description`,
 1 AS `scope_type`,
 1 AS `assignable`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `admin_user_scopes`
--

DROP TABLE IF EXISTS `admin_user_scopes`;
/*!50001 DROP VIEW IF EXISTS `admin_user_scopes`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `admin_user_scopes` AS SELECT 
 1 AS `id`,
 1 AS `user_id`,
 1 AS `scope_type`,
 1 AS `entity_id`,
 1 AS `district_id`,
 1 AS `label`,
 1 AS `entity_active`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audit_logs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `actor_user_id` int(10) unsigned DEFAULT NULL,
  `action` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `module` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `entity_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_audit_actor_user_id` (`actor_user_id`),
  KEY `idx_audit_action` (`action`),
  KEY `idx_audit_module` (`module`),
  CONSTRAINT `fk_audit_logs_actor` FOREIGN KEY (`actor_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (1,1,'login_success','security','user','1','User signed in.','2026-10-20 20:38:32'),(2,1,'logistics_location_created','logistics','service_location','1','Created logistics location PORT-OF-SPAIN (TTPOST)','2026-10-20 20:39:26'),(3,1,'logistics_location_created','logistics','service_location','2','Created logistics location ARIMA (REPAIR_CENTRE)','2026-10-20 20:39:36'),(4,1,'manufacturer_created','device_catalogue','manufacturer','1','Manufacturer created.','2026-10-20 20:41:10'),(5,1,'model_created','device_catalogue','device_model','1','Device model created.','2026-10-20 20:42:00'),(6,1,'device_created','devices','device','1','Device asset created.','2026-10-20 20:43:16'),(7,1,'device_created','devices','device','2','Device asset created.','2026-10-20 20:43:59'),(8,1,'school.created','organisation','school','1','School created.','2026-10-20 20:45:43'),(9,1,'student_created','students','student','1','Student created.','2026-10-20 20:46:58'),(10,1,'device_marked_available','devices','device','2','Device lifecycle status changed.','2026-10-20 20:47:29'),(11,1,'device_marked_available','devices','device','1','Device lifecycle status changed.','2026-10-20 20:47:32'),(12,1,'device_allocated_to_district','device_allocations','device_district_allocation','1','Allocated device LENO-01 to St. Patrick','2026-10-20 20:47:46'),(13,1,'device_allocated_to_district','device_allocations','device_district_allocation','2','Allocated device LENO-02 to St. Patrick','2026-10-20 20:47:46'),(14,1,'device_allocated_to_school','device_allocations','device_school_allocation','1','Allocated device LENO-01 to Point Fortin Senior Secondary (6)','2026-10-20 20:48:25'),(15,1,'device_allocated_to_school','device_allocations','device_school_allocation','2','Allocated device LENO-02 to Point Fortin Senior Secondary (6)','2026-10-20 20:48:25'),(16,1,'device_assigned_to_student','device_assignments','device_student_assignment','1','Assigned device LENO-01 to jluise at Point Fortin Senior Secondary','2026-10-20 20:49:11'),(17,1,'ticket_created','tickets','ticket','1','Created ticket TKT00000001 for device LENO-01 at Point Fortin Senior Secondary','2026-10-20 21:01:51'),(18,1,'notification_delivery_failed','notifications','TICKET_SUBMITTED','1','Derived in-app notification failed after the operational workflow committed. Event TICKET_SUBMITTED; stage source_context.','2026-10-20 21:01:51'),(19,1,'ticket_claimed','tickets','ticket_assignment','1','Claimed TKT00000001','2026-10-20 21:02:10'),(20,1,'ticket_diagnosed','tickets','ticket_diagnosis','1','Recorded diagnosis for TKT00000001','2026-10-20 21:02:19'),(21,1,'notification_delivery_failed','notifications','DISTRICT_APPROVAL_REQUIRED','1','Derived in-app notification failed after the operational workflow committed. Event DISTRICT_APPROVAL_REQUIRED; stage source_context.','2026-10-20 21:02:19'),(22,1,'ticket_approved_for_pickup','tickets','ticket_district_approval','1','Approved TKT00000001 for pickup at Point Fortin Senior Secondary','2026-10-20 21:02:29'),(23,1,'sla_started','sla','sla_instance','1','Started PICKUP SLA for ticket TKT00000001','2026-10-20 21:02:29'),(24,1,'notification_delivery_failed','notifications','TICKET_APPROVED_FOR_PICKUP','1','Derived in-app notification failed after the operational workflow committed. Event TICKET_APPROVED_FOR_PICKUP; stage source_context.','2026-10-20 21:02:29'),(25,1,'logistics_pickup_requested','logistics','ticket_logistics_case','1','Created LOG00000001 for ticket TKT00000001 at Point Fortin Senior Secondary','2026-10-20 21:02:46'),(26,1,'notification_delivery_failed','notifications','LOGISTICS_PICKUP_REQUESTED','1','Derived in-app notification failed after the operational workflow committed. Event LOGISTICS_PICKUP_REQUESTED; stage source_context.','2026-10-20 21:02:46'),(27,1,'logistics_request_accepted','logistics','ticket_logistics_case','1','Accepted LOG00000001 for ticket TKT00000001','2026-10-20 21:03:10'),(28,1,'logistics_school_handoff_dispatched','logistics','logistics_handoff','1','Released LOG00000001 for ticket TKT00000001 to PORT OF SPAIN','2026-10-20 21:03:17'),(29,1,'notification_delivery_failed','notifications','LOGISTICS_SCHOOL_RELEASED','1','Derived in-app notification failed after the operational workflow committed. Event LOGISTICS_SCHOOL_RELEASED; stage source_context.','2026-10-20 21:03:17'),(30,1,'logistics_ttpost_handoff_received','logistics','logistics_handoff','1','TTPost received LOG00000001 for ticket TKT00000001','2026-10-20 21:03:20'),(31,1,'sla_completed','sla','sla_instance','1','Completed PICKUP SLA as COMPLETED_WITHIN_SLA','2026-10-20 21:03:20'),(32,1,'notification_delivery_failed','notifications','LOGISTICS_RECEIVED_BY_TTPOST','1','Derived in-app notification failed after the operational workflow committed. Event LOGISTICS_RECEIVED_BY_TTPOST; stage source_context.','2026-10-20 21:03:20'),(33,1,'logistics_repair_handoff_dispatched','logistics','logistics_handoff','2','Dispatched LOG00000001 for ticket TKT00000001 to ','2026-10-20 21:03:26'),(34,1,'notification_delivery_failed','notifications','LOGISTICS_SENT_TO_REPAIR_CENTRE','2','Derived in-app notification failed after the operational workflow committed. Event LOGISTICS_SENT_TO_REPAIR_CENTRE; stage source_context.','2026-10-20 21:03:26'),(35,1,'logistics_repair_centre_received','logistics','logistics_handoff','2','Repair Centre received LOG00000001 for ticket TKT00000001 at ARIMA','2026-10-20 21:03:29'),(36,1,'sla_started','sla','sla_instance','2','Started DIAGNOSIS SLA for ticket TKT00000001','2026-10-20 21:03:29'),(37,1,'notification_delivery_failed','notifications','LOGISTICS_RECEIVED_BY_REPAIR_CENTRE','2','Derived in-app notification failed after the operational workflow committed. Event LOGISTICS_RECEIVED_BY_REPAIR_CENTRE; stage source_context.','2026-10-20 21:03:29'),(38,1,'repair_started','repairs','repair_job','1','Repair processing started for repair job 1','2026-10-20 21:03:46'),(39,1,'sla_started','sla','sla_instance','3','Started REPAIR SLA for ticket TKT00000001','2026-10-20 21:03:46'),(40,1,'notification_delivery_failed','notifications','REPAIR_STARTED','1','Derived in-app notification failed after the operational workflow committed. Event REPAIR_STARTED; stage source_context.','2026-10-20 21:03:46'),(41,1,'repair_assessment_recorded','repairs','repair_job','1','Repair assessment recorded for repair job.','2026-10-20 21:04:06'),(42,1,'sla_completed','sla','sla_instance','2','Completed DIAGNOSIS SLA as COMPLETED_WITHIN_SLA','2026-10-20 21:04:06'),(43,1,'repair_work_recorded','repairs','repair_job','1','Repair work recorded for repair job.','2026-10-20 21:04:27'),(44,1,'device_stock_intake','device_stock','device','2','Verified Repair Centre stock intake.','2026-10-20 21:11:38'),(45,1,'spare_pool_created','spare_pools','spare_pool','1','Created spare pool ARIMA-SPARE-POOL at ARIMA','2026-10-20 21:15:10'),(46,1,'spare_pool_default_changed','spare_pools','spare_pool','1','Changed default spare pool at ARIMA from none to ARIMA-SPARE-POOL','2026-10-20 21:17:39'),(47,1,'temporary_loan_requested','temporary_loans','temporary_loan_case','1','Temporary spare authorization requested.','2026-10-20 21:18:18'),(48,1,'temporary_loan_authorized','temporary_loans','temporary_loan_case','1','District authorized temporary spare.','2026-10-20 21:18:50'),(49,1,'device_returned_to_district','device_allocations','device_school_allocation','2','Returned device LENO-02 from 1 to district 6','2026-10-20 21:23:49'),(50,1,'device_returned_to_central','device_allocations','device_district_allocation','2','Returned device LENO-02 from district 6 to Central','2026-10-20 21:25:45'),(51,1,'temporary_spare_selected','temporary_loans','temporary_loan_case','1','Temporary spare selected and reserved.','2026-10-20 21:26:19'),(52,1,'temporary_loan_issued','temporary_loans','temporary_loan_case','1','Temporary spare issued and activated.','2026-10-20 21:26:32'),(53,1,'repair_completed_ready_for_return','repairs','repair_job','1','Repair processing completed; case is awaiting return logistics.','2026-10-20 21:28:19'),(54,1,'sla_completed','sla','sla_instance','3','Completed REPAIR SLA as COMPLETED_WITHIN_SLA','2026-10-20 21:28:19'),(55,1,'sla_started','sla','sla_instance','4','Started RETURN_LOGISTICS SLA for ticket TKT00000001','2026-10-20 21:28:19'),(56,1,'notification_delivery_failed','notifications','REPAIR_COMPLETED','1','Derived in-app notification failed after the operational workflow committed. Event REPAIR_COMPLETED; stage source_context.','2026-10-20 21:28:19'),(57,1,'notification_delivery_failed','notifications','LOGISTICS_READY_FOR_RETURN_PICKUP','1','Derived in-app notification failed after the operational workflow committed. Event LOGISTICS_READY_FOR_RETURN_PICKUP; stage source_context.','2026-10-20 21:28:19'),(58,1,'logistics_return_handoff_dispatched','logistics','logistics_handoff','3','Repair Centre dispatched LOG00000001 to TTPost.','2026-10-20 21:28:57'),(59,1,'logistics_return_ttpost_received','logistics','logistics_handoff','3','TTPost received return device for LOG00000001.','2026-10-20 21:28:59'),(60,1,'notification_delivery_failed','notifications','LOGISTICS_RETURN_RECEIVED_BY_TTPOST','3','Derived in-app notification failed after the operational workflow committed. Event LOGISTICS_RETURN_RECEIVED_BY_TTPOST; stage source_context.','2026-10-20 21:28:59'),(61,1,'logistics_school_return_dispatched','logistics','logistics_handoff','4','TTPost dispatched LOG00000001 to the origin School.','2026-10-20 21:29:02'),(62,1,'notification_delivery_failed','notifications','LOGISTICS_RETURN_IN_TRANSIT_TO_SCHOOL','4','Derived in-app notification failed after the operational workflow committed. Event LOGISTICS_RETURN_IN_TRANSIT_TO_SCHOOL; stage source_context.','2026-10-20 21:29:02'),(63,1,'logistics_school_return_received','logistics','logistics_handoff','4','School confirmed return receipt for LOG00000001.','2026-10-20 21:29:05'),(64,1,'sla_completed','sla','sla_instance','4','Completed RETURN_LOGISTICS SLA as COMPLETED_WITHIN_SLA','2026-10-20 21:29:05'),(65,1,'notification_delivery_failed','notifications','LOGISTICS_RETURNED_TO_SCHOOL','4','Derived in-app notification failed after the operational workflow committed. Event LOGISTICS_RETURNED_TO_SCHOOL; stage source_context.','2026-10-20 21:29:05'),(66,1,'temporary_loan_return_required','temporary_loans','temporary_loan_case','1','Temporary spare return requested; physical receipt is not confirmed.','2026-10-20 21:29:30'),(67,1,'temporary_loan_returned','temporary_loans','temporary_loan_case','1','Serviceable temporary spare reclaimed into Repair Centre free stock.','2026-10-20 21:30:04'),(68,1,'ticket_created','tickets','ticket','2','Created ticket TKT00000002 for device LENO-01 at Point Fortin Senior Secondary','2026-10-20 21:31:27'),(69,1,'notification_delivery_failed','notifications','TICKET_SUBMITTED','2','Derived in-app notification failed after the operational workflow committed. Event TICKET_SUBMITTED; stage source_context.','2026-10-20 21:31:27'),(70,1,'ticket_claimed','tickets','ticket_assignment','2','Claimed TKT00000002','2026-10-20 21:31:33'),(71,1,'ticket_diagnosed','tickets','ticket_diagnosis','2','Recorded diagnosis for TKT00000002','2026-10-20 21:31:39'),(72,1,'notification_delivery_failed','notifications','DISTRICT_APPROVAL_REQUIRED','2','Derived in-app notification failed after the operational workflow committed. Event DISTRICT_APPROVAL_REQUIRED; stage source_context.','2026-10-20 21:31:39'),(73,1,'ticket_approved_for_pickup','tickets','ticket_district_approval','2','Approved TKT00000002 for pickup at Point Fortin Senior Secondary','2026-10-20 21:31:44'),(74,1,'sla_started','sla','sla_instance','5','Started PICKUP SLA for ticket TKT00000002','2026-10-20 21:31:44'),(75,1,'notification_delivery_failed','notifications','TICKET_APPROVED_FOR_PICKUP','2','Derived in-app notification failed after the operational workflow committed. Event TICKET_APPROVED_FOR_PICKUP; stage source_context.','2026-10-20 21:31:44'),(76,1,'logistics_pickup_requested','logistics','ticket_logistics_case','2','Created LOG00000002 for ticket TKT00000002 at Point Fortin Senior Secondary','2026-10-20 21:31:47'),(77,1,'notification_delivery_failed','notifications','LOGISTICS_PICKUP_REQUESTED','2','Derived in-app notification failed after the operational workflow committed. Event LOGISTICS_PICKUP_REQUESTED; stage source_context.','2026-10-20 21:31:47'),(78,1,'logistics_request_accepted','logistics','ticket_logistics_case','2','Accepted LOG00000002 for ticket TKT00000002','2026-10-20 21:31:59'),(79,1,'logistics_school_handoff_dispatched','logistics','logistics_handoff','5','Released LOG00000002 for ticket TKT00000002 to PORT OF SPAIN','2026-10-20 21:32:04'),(80,1,'notification_delivery_failed','notifications','LOGISTICS_SCHOOL_RELEASED','5','Derived in-app notification failed after the operational workflow committed. Event LOGISTICS_SCHOOL_RELEASED; stage source_context.','2026-10-20 21:32:04'),(81,1,'logistics_ttpost_handoff_received','logistics','logistics_handoff','5','TTPost received LOG00000002 for ticket TKT00000002','2026-10-20 21:32:07'),(82,1,'sla_completed','sla','sla_instance','5','Completed PICKUP SLA as COMPLETED_WITHIN_SLA','2026-10-20 21:32:07'),(83,1,'notification_delivery_failed','notifications','LOGISTICS_RECEIVED_BY_TTPOST','5','Derived in-app notification failed after the operational workflow committed. Event LOGISTICS_RECEIVED_BY_TTPOST; stage source_context.','2026-10-20 21:32:07'),(84,1,'logistics_repair_handoff_dispatched','logistics','logistics_handoff','6','Dispatched LOG00000002 for ticket TKT00000002 to ','2026-10-20 21:32:12'),(85,1,'notification_delivery_failed','notifications','LOGISTICS_SENT_TO_REPAIR_CENTRE','6','Derived in-app notification failed after the operational workflow committed. Event LOGISTICS_SENT_TO_REPAIR_CENTRE; stage source_context.','2026-10-20 21:32:12'),(86,1,'logistics_repair_centre_received','logistics','logistics_handoff','6','Repair Centre received LOG00000002 for ticket TKT00000002 at ARIMA','2026-10-20 21:32:15'),(87,1,'sla_started','sla','sla_instance','6','Started DIAGNOSIS SLA for ticket TKT00000002','2026-10-20 21:32:15'),(88,1,'notification_delivery_failed','notifications','LOGISTICS_RECEIVED_BY_REPAIR_CENTRE','6','Derived in-app notification failed after the operational workflow committed. Event LOGISTICS_RECEIVED_BY_REPAIR_CENTRE; stage source_context.','2026-10-20 21:32:15'),(89,1,'repair_started','repairs','repair_job','2','Repair processing started for repair job 2','2026-10-20 21:32:43'),(90,1,'sla_started','sla','sla_instance','7','Started REPAIR SLA for ticket TKT00000002','2026-10-20 21:32:43'),(91,1,'notification_delivery_failed','notifications','REPAIR_STARTED','2','Derived in-app notification failed after the operational workflow committed. Event REPAIR_STARTED; stage source_context.','2026-10-20 21:32:43'),(92,1,'temporary_loan_requested','temporary_loans','temporary_loan_case','2','Temporary spare authorization requested.','2026-10-20 21:32:52'),(93,1,'temporary_loan_authorized','temporary_loans','temporary_loan_case','2','District authorized temporary spare.','2026-10-20 21:33:02'),(94,1,'temporary_spare_selected','temporary_loans','temporary_loan_case','2','Temporary spare selected and reserved.','2026-10-20 21:33:08'),(95,1,'repair_assessment_recorded','repairs','repair_job','2','Repair assessment recorded for repair job.','2026-10-20 21:33:34'),(96,1,'sla_completed','sla','sla_instance','6','Completed DIAGNOSIS SLA as COMPLETED_WITHIN_SLA','2026-10-20 21:33:34'),(97,1,'exception_case_created','exceptions','repair_exception_case','1','Exception case created for repair job; assessment is required.','2026-10-20 21:33:45'),(98,1,'repair_disposition_recorded','repairs','repair_job','2','Repair disposition recorded; downstream workflow is required.','2026-10-20 21:33:45'),(99,1,'sla_cancelled','sla','sla_instance','7','Cancelled REPAIR SLA: Local repair ended in a non-local disposition.','2026-10-20 21:33:45'),(100,1,'exception_assessment_recorded','exceptions','repair_exception_case','1','Warranty and responsibility assessment recorded for exception case.','2026-10-20 21:34:24'),(101,1,'exception_submitted','exceptions','repair_exception_case','1','Exception assessment submitted for disposition review.','2026-10-20 21:34:30'),(102,1,'notification_delivery_failed','notifications','DISTRICT_REPAIR_DECISION_REQUIRED','1','Derived in-app notification failed after the operational workflow committed. Event DISTRICT_REPAIR_DECISION_REQUIRED; stage source_context.','2026-10-20 21:34:30'),(103,1,'exception_replacement_requested','exceptions','repair_exception_case','1','District selected permanent replacement; Head Office approval is pending.','2026-10-20 21:34:41'),(104,1,'notification_delivery_failed','notifications','HEAD_OFFICE_REPLACEMENT_APPROVAL_REQUIRED','1','Derived in-app notification failed after the operational workflow committed. Event HEAD_OFFICE_REPLACEMENT_APPROVAL_REQUIRED; stage source_context.','2026-10-20 21:34:41'),(105,1,'exception_replacement_approved','exceptions','repair_exception_case','1','Head Office approved permanent replacement; replacement processing is pending.','2026-10-20 21:34:56'),(106,1,'permanent_replacement_started','replacements','permanent_replacement_case','1','Permanent replacement processing started.','2026-10-20 21:34:59'),(107,1,'permanent_replacement_selected','replacements','permanent_replacement_case','1','Permanent replacement source selected.','2026-10-20 21:35:16'),(108,1,'sla_started','sla','sla_instance','8','Started RETURN_LOGISTICS SLA for ticket TKT00000002','2026-10-20 21:35:23'),(109,1,'permanent_replacement_completed','replacements','permanent_replacement_case','1','Permanent replacement PR1 accepted.','2026-10-20 21:35:23'),(110,1,'temporary_loan_converted_permanent','temporary_loans','temporary_loan_case','2','Temporary loan completed through permanent replacement acceptance using the same device.','2026-10-20 21:46:45'),(111,1,'login_success','security','user','1','User signed in.','2026-10-21 08:41:09'),(112,1,'device_created','devices','device','3','Device asset created.','2026-10-21 08:42:17'),(113,1,'device_marked_available','devices','device','3','Device lifecycle status changed.','2026-10-21 08:42:29'),(114,1,'device_stock_intake','device_stock','device','3','Verified Repair Centre stock intake.','2026-10-21 08:43:17'),(115,1,'login_success','security','user','1','User signed in.','2026-10-21 08:51:36');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carriers`
--

DROP TABLE IF EXISTS `carriers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `carriers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `carrier_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `carrier_type` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `active_default_key` tinyint(4) GENERATED ALWAYS AS ((case when ((`status` = 'active') and (`is_default` = 1)) then 1 else NULL end)) STORED,
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT '100',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_carriers_code` (`carrier_code`),
  UNIQUE KEY `uq_carriers_active_default` (`active_default_key`),
  KEY `idx_carriers_status_sort` (`status`,`sort_order`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carriers`
--

LOCK TABLES `carriers` WRITE;
/*!40000 ALTER TABLE `carriers` DISABLE KEYS */;
INSERT INTO `carriers` (`id`, `carrier_code`, `name`, `carrier_type`, `is_default`, `status`, `sort_order`, `created_at`, `updated_at`) VALUES (1,'TTPOST','TTPost','TTPOST',1,'active',10,'2026-10-13 09:35:58.833153','2026-10-13 09:35:58.833153'),(3,'TTPOST-01','TTPOST','EXTERNAL',0,'inactive',100,'2026-10-20 20:40:05.476940','2026-10-20 20:40:11.070089');
/*!40000 ALTER TABLE `carriers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_conditions`
--

DROP TABLE IF EXISTS `device_conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_conditions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` int(10) unsigned NOT NULL DEFAULT '0',
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_device_conditions_code` (`code`),
  KEY `idx_device_conditions_status_sort` (`status`,`sort_order`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_conditions`
--

LOCK TABLES `device_conditions` WRITE;
/*!40000 ALTER TABLE `device_conditions` DISABLE KEYS */;
INSERT INTO `device_conditions` VALUES (1,'NEW','New','New device.',10,'active','2026-10-07 16:05:03'),(2,'GOOD','Good','Good working condition.',20,'active','2026-10-07 16:05:03'),(3,'FAIR','Fair','Usable with visible wear.',30,'active','2026-10-07 16:05:03'),(4,'DAMAGED','Damaged','Physical damage recorded.',40,'active','2026-10-07 16:05:03'),(5,'NON_FUNCTIONAL','Non-functional','Device is not functioning.',50,'active','2026-10-07 16:05:03'),(6,'REFURBISHED','Refurbished','Refurbished device.',60,'active','2026-10-07 16:05:03');
/*!40000 ALTER TABLE `device_conditions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_district_allocations`
--

DROP TABLE IF EXISTS `device_district_allocations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_district_allocations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `device_id` int(10) unsigned NOT NULL,
  `district_id` int(10) unsigned NOT NULL,
  `allocated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `allocated_by_user_id` int(10) unsigned NOT NULL,
  `returned_at` datetime DEFAULT NULL,
  `returned_by_user_id` int(10) unsigned DEFAULT NULL,
  `return_reason` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `active_record_key` tinyint(3) unsigned DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_device_district_allocations_device_id` (`device_id`,`id`),
  UNIQUE KEY `uq_device_district_allocations_active` (`device_id`,`active_record_key`),
  KEY `idx_device_district_allocations_district_active` (`district_id`,`active_record_key`),
  KEY `idx_device_district_allocations_allocated_at` (`allocated_at`),
  KEY `idx_device_district_allocations_returned_at` (`returned_at`),
  KEY `fk_device_district_allocations_allocated_by` (`allocated_by_user_id`),
  KEY `fk_device_district_allocations_returned_by` (`returned_by_user_id`),
  CONSTRAINT `fk_device_district_allocations_allocated_by` FOREIGN KEY (`allocated_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_device_district_allocations_device` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_device_district_allocations_district` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`),
  CONSTRAINT `fk_device_district_allocations_returned_by` FOREIGN KEY (`returned_by_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_district_allocations`
--

LOCK TABLES `device_district_allocations` WRITE;
/*!40000 ALTER TABLE `device_district_allocations` DISABLE KEYS */;
INSERT INTO `device_district_allocations` VALUES (1,1,6,'2026-10-20 20:47:46',1,NULL,NULL,NULL,NULL,1,'2026-10-20 20:47:46','2026-10-20 20:47:46'),(2,2,6,'2026-10-20 20:47:46',1,'2026-10-20 21:25:45',1,'NEED TO BE SPARE',NULL,NULL,'2026-10-20 20:47:46','2026-10-20 21:25:45'),(3,2,6,'2026-10-20 21:35:23',1,NULL,NULL,NULL,'Permanent replacement PR1',1,'2026-10-20 21:35:23','2026-10-20 21:35:23');
/*!40000 ALTER TABLE `device_district_allocations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_import_batches`
--

DROP TABLE IF EXISTS `device_import_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_import_batches` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `batch_number` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `original_filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `stored_file_path` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'uploaded',
  `total_rows` int(10) unsigned NOT NULL DEFAULT '0',
  `valid_rows` int(10) unsigned NOT NULL DEFAULT '0',
  `invalid_rows` int(10) unsigned NOT NULL DEFAULT '0',
  `imported_rows` int(10) unsigned NOT NULL DEFAULT '0',
  `uploaded_by_user_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validated_at` datetime DEFAULT NULL,
  `committed_at` datetime DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_device_import_batches_number` (`batch_number`),
  KEY `idx_device_import_batches_status_created` (`status`,`created_at`),
  KEY `idx_device_import_batches_created_at` (`created_at`),
  KEY `idx_device_import_batches_uploaded_by` (`uploaded_by_user_id`),
  CONSTRAINT `fk_device_import_batches_uploaded_by` FOREIGN KEY (`uploaded_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_import_batches`
--

LOCK TABLES `device_import_batches` WRITE;
/*!40000 ALTER TABLE `device_import_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_import_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_import_rows`
--

DROP TABLE IF EXISTS `device_import_rows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_import_rows` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `batch_id` int(10) unsigned NOT NULL,
  `row_number` int(10) unsigned NOT NULL,
  `raw_payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `serial_number_raw` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `serial_number_normalized` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `asset_tag_raw` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `asset_tag_normalized` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `manufacturer_code_raw` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `model_code_raw` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `condition_code_raw` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `warranty_start_raw` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `warranty_end_raw` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `received_date_raw` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `procurement_reference_raw` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `supplier_name_raw` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `warranty_reference_raw` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `validation_status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `validation_errors` text COLLATE utf8mb4_unicode_ci,
  `resolved_manufacturer_id` int(10) unsigned DEFAULT NULL,
  `resolved_model_id` int(10) unsigned DEFAULT NULL,
  `resolved_condition_id` int(10) unsigned DEFAULT NULL,
  `imported_device_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_device_import_rows_batch_row` (`batch_id`,`row_number`),
  KEY `idx_device_import_rows_batch_validation` (`batch_id`,`validation_status`),
  KEY `idx_device_import_rows_serial` (`serial_number_normalized`),
  KEY `idx_device_import_rows_asset_tag` (`asset_tag_normalized`),
  KEY `idx_device_import_rows_manufacturer` (`resolved_manufacturer_id`),
  KEY `idx_device_import_rows_model` (`resolved_model_id`),
  KEY `idx_device_import_rows_condition` (`resolved_condition_id`),
  KEY `idx_device_import_rows_device` (`imported_device_id`),
  CONSTRAINT `fk_device_import_rows_batch` FOREIGN KEY (`batch_id`) REFERENCES `device_import_batches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_device_import_rows_condition` FOREIGN KEY (`resolved_condition_id`) REFERENCES `device_conditions` (`id`),
  CONSTRAINT `fk_device_import_rows_device` FOREIGN KEY (`imported_device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_device_import_rows_manufacturer` FOREIGN KEY (`resolved_manufacturer_id`) REFERENCES `manufacturers` (`id`),
  CONSTRAINT `fk_device_import_rows_model` FOREIGN KEY (`resolved_model_id`) REFERENCES `device_models` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_import_rows`
--

LOCK TABLES `device_import_rows` WRITE;
/*!40000 ALTER TABLE `device_import_rows` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_import_rows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_lifecycle_statuses`
--

DROP TABLE IF EXISTS `device_lifecycle_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_lifecycle_statuses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` int(10) unsigned NOT NULL DEFAULT '0',
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_device_lifecycle_statuses_code` (`code`),
  KEY `idx_device_lifecycle_statuses_status_sort` (`status`,`sort_order`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_lifecycle_statuses`
--

LOCK TABLES `device_lifecycle_statuses` WRITE;
/*!40000 ALTER TABLE `device_lifecycle_statuses` DISABLE KEYS */;
INSERT INTO `device_lifecycle_statuses` VALUES (1,'RECEIVED','Received','Device received into the asset register.',10,'active','2026-10-07 16:05:03'),(2,'AVAILABLE','Available','Device available for an authorized assignment.',20,'active','2026-10-07 16:05:03'),(3,'ASSIGNED','Assigned','Device assigned through a later workflow.',30,'active','2026-10-07 16:05:03'),(4,'IN_REPAIR','In Repair','Device undergoing repair.',40,'active','2026-10-07 16:05:03'),(5,'MANUFACTURER_RETURN','Manufacturer Return','Device sent for manufacturer processing.',50,'active','2026-10-07 16:05:03'),(6,'REPLACED','Replaced','Device replaced by another asset.',60,'active','2026-10-07 16:05:03'),(7,'RETIRED','Retired','Device retired from service.',70,'active','2026-10-07 16:05:03'),(8,'LOST','Lost','Device reported lost.',80,'active','2026-10-07 16:05:03'),(9,'STOLEN','Stolen','Device reported stolen.',90,'active','2026-10-07 16:05:03'),(10,'DISPOSED','Disposed','Device disposed of through an approved process.',100,'active','2026-10-07 16:05:03'),(11,'TEMPORARY_LOAN','Temporary Loan','Issued as a temporary spare device',65,'active','2026-10-15 09:26:27');
/*!40000 ALTER TABLE `device_lifecycle_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_models`
--

DROP TABLE IF EXISTS `device_models`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_models` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `manufacturer_id` int(10) unsigned NOT NULL,
  `model_code` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_name` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_path` varchar(1024) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_available` tinyint(1) NOT NULL DEFAULT '0',
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_by_user_id` int(10) unsigned DEFAULT NULL,
  `updated_by_user_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_device_models_manufacturer_code` (`manufacturer_id`,`model_code`),
  KEY `idx_device_models_manufacturer_status` (`manufacturer_id`,`status`),
  KEY `idx_device_models_created_by` (`created_by_user_id`),
  KEY `idx_device_models_updated_by` (`updated_by_user_id`),
  CONSTRAINT `fk_device_models_created_by` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_device_models_manufacturer` FOREIGN KEY (`manufacturer_id`) REFERENCES `manufacturers` (`id`),
  CONSTRAINT `fk_device_models_updated_by` FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_models`
--

LOCK TABLES `device_models` WRITE;
/*!40000 ALTER TABLE `device_models` DISABLE KEYS */;
INSERT INTO `device_models` VALUES (1,1,'P4BMODEL1792543320','ThinkPad X1 Carbon','/storage/model-images/7d06d311-e210-481f-8896-7ad1931936f6..avif',1,'active',1,1,'2026-10-20 20:42:00','2026-10-20 20:42:00');
/*!40000 ALTER TABLE `device_models` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_replacements`
--

DROP TABLE IF EXISTS `device_replacements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_replacements` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `replacement_case_id` int(10) unsigned NOT NULL,
  `original_device_id` int(10) unsigned NOT NULL,
  `replacement_device_id` int(10) unsigned NOT NULL,
  `reason_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `approved_exception_case_id` int(10) unsigned DEFAULT NULL,
  `effective_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` int(10) unsigned NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_device_repl_case_original` (`replacement_case_id`,`original_device_id`),
  KEY `idx_device_repl_original` (`original_device_id`,`effective_at`),
  KEY `idx_device_repl_replacement` (`replacement_device_id`,`effective_at`),
  KEY `fk_device_repl_actor` (`created_by`),
  KEY `fk_device_repl_exception` (`approved_exception_case_id`),
  CONSTRAINT `fk_device_repl_actor` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_device_repl_case` FOREIGN KEY (`replacement_case_id`) REFERENCES `permanent_replacement_cases` (`id`),
  CONSTRAINT `fk_device_repl_exception` FOREIGN KEY (`approved_exception_case_id`) REFERENCES `repair_exception_cases` (`id`),
  CONSTRAINT `fk_device_repl_original` FOREIGN KEY (`original_device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_device_repl_replacement` FOREIGN KEY (`replacement_device_id`) REFERENCES `devices` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_replacements`
--

LOCK TABLES `device_replacements` WRITE;
/*!40000 ALTER TABLE `device_replacements` DISABLE KEYS */;
INSERT INTO `device_replacements` VALUES (1,1,1,2,'PERMANENT_REPLACEMENT',1,'2026-10-20 21:35:23.906346',1,'2026-10-20 21:35:23.906346');
/*!40000 ALTER TABLE `device_replacements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_school_allocations`
--

DROP TABLE IF EXISTS `device_school_allocations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_school_allocations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `device_id` int(10) unsigned NOT NULL,
  `district_allocation_id` int(10) unsigned NOT NULL,
  `school_id` int(10) unsigned NOT NULL,
  `allocated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `allocated_by_user_id` int(10) unsigned NOT NULL,
  `returned_at` datetime DEFAULT NULL,
  `returned_by_user_id` int(10) unsigned DEFAULT NULL,
  `return_reason` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `active_record_key` tinyint(3) unsigned DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_device_school_allocations_device_id` (`device_id`,`id`),
  UNIQUE KEY `uq_device_school_allocations_active` (`device_id`,`active_record_key`),
  KEY `idx_device_school_allocations_device_parent` (`device_id`,`district_allocation_id`),
  KEY `idx_device_school_allocations_district_parent` (`district_allocation_id`,`device_id`),
  KEY `idx_device_school_allocations_school_active` (`school_id`,`active_record_key`),
  KEY `idx_device_school_allocations_allocated_at` (`allocated_at`),
  KEY `idx_device_school_allocations_returned_at` (`returned_at`),
  KEY `fk_device_school_allocations_allocated_by` (`allocated_by_user_id`),
  KEY `fk_device_school_allocations_returned_by` (`returned_by_user_id`),
  CONSTRAINT `fk_device_school_allocations_allocated_by` FOREIGN KEY (`allocated_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_device_school_allocations_device` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_device_school_allocations_district_parent` FOREIGN KEY (`device_id`, `district_allocation_id`) REFERENCES `device_district_allocations` (`device_id`, `id`),
  CONSTRAINT `fk_device_school_allocations_returned_by` FOREIGN KEY (`returned_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_device_school_allocations_school` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_school_allocations`
--

LOCK TABLES `device_school_allocations` WRITE;
/*!40000 ALTER TABLE `device_school_allocations` DISABLE KEYS */;
INSERT INTO `device_school_allocations` VALUES (1,1,1,1,'2026-10-20 20:48:25',1,NULL,NULL,NULL,NULL,1,'2026-10-20 20:48:25','2026-10-20 20:48:25'),(2,2,2,1,'2026-10-20 20:48:25',1,'2026-10-20 21:23:49',1,'NEED AS A SPARE',NULL,NULL,'2026-10-20 20:48:25','2026-10-20 21:23:49'),(3,2,3,1,'2026-10-20 21:35:23',1,NULL,NULL,NULL,'Permanent replacement PR1',1,'2026-10-20 21:35:23','2026-10-20 21:35:23');
/*!40000 ALTER TABLE `device_school_allocations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_stock_locations`
--

DROP TABLE IF EXISTS `device_stock_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_stock_locations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `device_id` int(10) unsigned NOT NULL,
  `service_location_id` int(10) unsigned NOT NULL,
  `stock_status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'IN_STOCK',
  `reason_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'VERIFIED_INTAKE',
  `active_record_key` tinyint(3) unsigned DEFAULT '1',
  `placed_by` int(10) unsigned NOT NULL,
  `placed_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `removed_by` int(10) unsigned DEFAULT NULL,
  `removed_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_device_stock_active` (`device_id`,`active_record_key`),
  KEY `idx_device_stock_location_active` (`service_location_id`,`active_record_key`),
  KEY `idx_device_stock_device_placed` (`device_id`,`placed_at`,`id`),
  KEY `fk_device_stock_placed_by` (`placed_by`),
  KEY `fk_device_stock_removed_by` (`removed_by`),
  CONSTRAINT `fk_device_stock_device` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_device_stock_location` FOREIGN KEY (`service_location_id`) REFERENCES `service_locations` (`id`),
  CONSTRAINT `fk_device_stock_placed_by` FOREIGN KEY (`placed_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_device_stock_removed_by` FOREIGN KEY (`removed_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_stock_locations`
--

LOCK TABLES `device_stock_locations` WRITE;
/*!40000 ALTER TABLE `device_stock_locations` DISABLE KEYS */;
INSERT INTO `device_stock_locations` VALUES (1,2,2,'RELEASED','VERIFIED_INTAKE',NULL,1,'2026-10-20 21:11:38.663884',1,'2026-10-20 21:26:32.000000','2026-10-20 21:11:38.663884','2026-10-20 21:26:32.370735'),(2,2,2,'RELEASED','TEMPORARY_LOAN_RETURNED',NULL,1,'2026-10-20 21:30:04.584432',1,'2026-10-20 21:35:23.000000','2026-10-20 21:30:04.584432','2026-10-20 21:35:23.884079'),(3,3,2,'IN_STOCK','VERIFIED_INTAKE',1,1,'2026-10-21 08:43:17.229475',NULL,NULL,'2026-10-21 08:43:17.229475','2026-10-21 08:43:17.229475');
/*!40000 ALTER TABLE `device_stock_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_student_assignments`
--

DROP TABLE IF EXISTS `device_student_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_student_assignments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `device_id` int(10) unsigned NOT NULL,
  `school_allocation_id` int(10) unsigned NOT NULL,
  `student_id` int(10) unsigned NOT NULL,
  `assignment_type` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PRIMARY',
  `assigned_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `assigned_by_user_id` int(10) unsigned NOT NULL,
  `returned_at` datetime DEFAULT NULL,
  `returned_by_user_id` int(10) unsigned DEFAULT NULL,
  `return_reason` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `active_record_key` tinyint(3) unsigned DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_device_student_assignments_device_id` (`device_id`,`id`),
  UNIQUE KEY `uq_device_student_assignments_active` (`device_id`,`active_record_key`),
  KEY `idx_device_student_assignments_device_school_parent` (`device_id`,`school_allocation_id`),
  KEY `idx_device_student_assignments_school_parent_device` (`school_allocation_id`,`device_id`),
  KEY `idx_device_student_assignments_student_active` (`student_id`,`active_record_key`),
  KEY `idx_device_student_assignments_assigned_at` (`assigned_at`),
  KEY `idx_device_student_assignments_returned_at` (`returned_at`),
  KEY `fk_device_student_assignments_assigned_by` (`assigned_by_user_id`),
  KEY `fk_device_student_assignments_returned_by` (`returned_by_user_id`),
  CONSTRAINT `fk_device_student_assignments_assigned_by` FOREIGN KEY (`assigned_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_device_student_assignments_device` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_device_student_assignments_returned_by` FOREIGN KEY (`returned_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_device_student_assignments_school_parent` FOREIGN KEY (`device_id`, `school_allocation_id`) REFERENCES `device_school_allocations` (`device_id`, `id`),
  CONSTRAINT `fk_device_student_assignments_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_student_assignments`
--

LOCK TABLES `device_student_assignments` WRITE;
/*!40000 ALTER TABLE `device_student_assignments` DISABLE KEYS */;
INSERT INTO `device_student_assignments` VALUES (1,1,1,1,'PRIMARY','2026-10-20 20:49:11',1,'2026-10-20 21:35:23',1,'PERMANENT_REPLACEMENT',NULL,NULL,'2026-10-20 20:49:11','2026-10-20 21:35:23'),(2,2,3,1,'PRIMARY','2026-10-20 21:35:23',1,NULL,NULL,NULL,'Permanent replacement PR1',1,'2026-10-20 21:35:23','2026-10-20 21:35:23');
/*!40000 ALTER TABLE `device_student_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devices` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `serial_number` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `asset_tag` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `device_model_id` int(10) unsigned NOT NULL,
  `lifecycle_status_id` int(10) unsigned NOT NULL,
  `condition_id` int(10) unsigned NOT NULL,
  `warranty_start_date` date DEFAULT NULL,
  `warranty_end_date` date DEFAULT NULL,
  `received_date` date DEFAULT NULL,
  `procurement_reference` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `supplier_name` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `warranty_reference` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_path` varchar(1024) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_available` tinyint(1) NOT NULL DEFAULT '0',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_by_user_id` int(10) unsigned DEFAULT NULL,
  `updated_by_user_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_devices_serial_number` (`serial_number`),
  UNIQUE KEY `uq_devices_asset_tag` (`asset_tag`),
  KEY `idx_devices_model` (`device_model_id`),
  KEY `idx_devices_lifecycle_status` (`lifecycle_status_id`),
  KEY `idx_devices_condition` (`condition_id`),
  KEY `idx_devices_warranty_end_date` (`warranty_end_date`),
  KEY `idx_devices_received_date` (`received_date`),
  KEY `idx_devices_created_by` (`created_by_user_id`),
  KEY `idx_devices_updated_by` (`updated_by_user_id`),
  CONSTRAINT `fk_devices_condition` FOREIGN KEY (`condition_id`) REFERENCES `device_conditions` (`id`),
  CONSTRAINT `fk_devices_created_by` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_devices_lifecycle_status` FOREIGN KEY (`lifecycle_status_id`) REFERENCES `device_lifecycle_statuses` (`id`),
  CONSTRAINT `fk_devices_model` FOREIGN KEY (`device_model_id`) REFERENCES `device_models` (`id`),
  CONSTRAINT `fk_devices_updated_by` FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
INSERT INTO `devices` VALUES (1,'LENO-01','LENO-01',1,6,1,'2026-10-01','2026-10-31','2026-10-20','ETEN-2026-01','800-TECH','waranty-01',NULL,0,'Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium',1,1,'2026-10-20 20:43:16','2026-10-20 21:35:23'),(2,'LENO-02','LENO-02',1,3,1,'2026-10-01','2026-10-31','2026-10-20','ETEN-2026-01','800-TECH','waranty-01',NULL,0,'Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium',1,1,'2026-10-20 20:43:59','2026-10-20 21:35:23'),(3,'LENO-03','LENO-03',1,2,1,'2026-10-01','2026-10-31','2026-10-21','ETEN-2026-01','800-TECH','waranty-01',NULL,0,NULL,1,1,'2026-10-21 08:42:17','2026-10-21 08:42:29');
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `districts`
--

DROP TABLE IF EXISTS `districts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `districts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_districts_name` (`name`),
  KEY `idx_districts_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `districts`
--

LOCK TABLES `districts` WRITE;
/*!40000 ALTER TABLE `districts` DISABLE KEYS */;
INSERT INTO `districts` VALUES (1,'Port of Spain & Environs','active','2026-10-06 19:50:41','2026-10-06 19:50:41'),(2,'St. George East','active','2026-10-06 19:50:41','2026-10-06 19:50:41'),(3,'North Eastern','active','2026-10-06 19:50:41','2026-10-06 19:50:41'),(4,'Caroni','active','2026-10-06 19:50:41','2026-10-06 19:50:41'),(5,'Victoria','active','2026-10-06 19:50:41','2026-10-06 19:50:41'),(6,'St. Patrick','active','2026-10-06 19:50:41','2026-10-06 19:50:41'),(7,'South Eastern','active','2026-10-06 19:50:41','2026-10-08 19:07:28'),(8,'Tobago','active','2026-10-06 19:50:41','2026-10-06 19:50:41');
/*!40000 ALTER TABLE `districts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `escalation_assignments`
--

DROP TABLE IF EXISTS `escalation_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `escalation_assignments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `escalation_case_id` bigint(20) unsigned NOT NULL,
  `escalation_rule_id` bigint(20) unsigned NOT NULL,
  `level_snapshot` tinyint(3) unsigned NOT NULL,
  `trigger_snapshot` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `target_role_id` int(10) unsigned NOT NULL,
  `target_role_name_snapshot` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reason_snapshot` varchar(240) COLLATE utf8mb4_unicode_ci NOT NULL,
  `assigned_at` datetime(6) NOT NULL,
  `assigned_by` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_escalation_assignment` (`escalation_case_id`,`escalation_rule_id`,`level_snapshot`,`target_role_id`),
  KEY `idx_escalation_assignment_target` (`target_role_id`,`level_snapshot`,`escalation_case_id`),
  KEY `fk_escalation_assignment_rule` (`escalation_rule_id`),
  KEY `fk_escalation_assignment_actor` (`assigned_by`),
  CONSTRAINT `fk_escalation_assignment_actor` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_escalation_assignment_case` FOREIGN KEY (`escalation_case_id`) REFERENCES `escalation_cases` (`id`),
  CONSTRAINT `fk_escalation_assignment_role` FOREIGN KEY (`target_role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `fk_escalation_assignment_rule` FOREIGN KEY (`escalation_rule_id`) REFERENCES `escalation_rules` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `escalation_assignments`
--

LOCK TABLES `escalation_assignments` WRITE;
/*!40000 ALTER TABLE `escalation_assignments` DISABLE KEYS */;
/*!40000 ALTER TABLE `escalation_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `escalation_cases`
--

DROP TABLE IF EXISTS `escalation_cases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `escalation_cases` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sla_instance_id` bigint(20) unsigned NOT NULL,
  `escalation_number` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `policy_code_snapshot` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ticket_id` int(10) unsigned NOT NULL,
  `logistics_case_id` int(10) unsigned DEFAULT NULL,
  `repair_job_id` int(10) unsigned DEFAULT NULL,
  `district_id` int(10) unsigned DEFAULT NULL,
  `school_id` int(10) unsigned DEFAULT NULL,
  `repair_centre_location_id` int(10) unsigned DEFAULT NULL,
  `current_level` tinyint(3) unsigned NOT NULL,
  `current_trigger` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `current_state_code` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'OPEN',
  `reason_snapshot` varchar(240) COLLATE utf8mb4_unicode_ci NOT NULL,
  `opened_at` datetime(6) NOT NULL,
  `acknowledged_at` datetime(6) DEFAULT NULL,
  `acknowledged_by` int(10) unsigned DEFAULT NULL,
  `acknowledgement_note` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `resolved_at` datetime(6) DEFAULT NULL,
  `cancelled_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_escalation_case_sla` (`sla_instance_id`),
  UNIQUE KEY `uq_escalation_case_number` (`escalation_number`),
  KEY `idx_escalation_case_queue` (`current_state_code`,`current_level`,`current_trigger`,`opened_at`),
  KEY `idx_escalation_case_ticket` (`ticket_id`,`current_state_code`),
  KEY `idx_escalation_case_scope` (`district_id`,`school_id`,`repair_centre_location_id`),
  KEY `fk_escalation_case_logistics` (`logistics_case_id`),
  KEY `fk_escalation_case_repair` (`repair_job_id`),
  KEY `fk_escalation_case_school` (`school_id`),
  KEY `fk_escalation_case_location` (`repair_centre_location_id`),
  KEY `fk_escalation_case_ack_user` (`acknowledged_by`),
  CONSTRAINT `fk_escalation_case_ack_user` FOREIGN KEY (`acknowledged_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_escalation_case_district` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`),
  CONSTRAINT `fk_escalation_case_location` FOREIGN KEY (`repair_centre_location_id`) REFERENCES `service_locations` (`id`),
  CONSTRAINT `fk_escalation_case_logistics` FOREIGN KEY (`logistics_case_id`) REFERENCES `ticket_logistics_cases` (`id`),
  CONSTRAINT `fk_escalation_case_repair` FOREIGN KEY (`repair_job_id`) REFERENCES `repair_jobs` (`id`),
  CONSTRAINT `fk_escalation_case_school` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`),
  CONSTRAINT `fk_escalation_case_sla` FOREIGN KEY (`sla_instance_id`) REFERENCES `sla_instances` (`id`),
  CONSTRAINT `fk_escalation_case_state` FOREIGN KEY (`current_state_code`) REFERENCES `escalation_states` (`code`),
  CONSTRAINT `fk_escalation_case_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `escalation_cases`
--

LOCK TABLES `escalation_cases` WRITE;
/*!40000 ALTER TABLE `escalation_cases` DISABLE KEYS */;
/*!40000 ALTER TABLE `escalation_cases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `escalation_history`
--

DROP TABLE IF EXISTS `escalation_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `escalation_history` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `escalation_case_id` bigint(20) unsigned NOT NULL,
  `event_code` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `event_key` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `old_state_code` varchar(24) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `new_state_code` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `old_level` tinyint(3) unsigned DEFAULT NULL,
  `new_level` tinyint(3) unsigned NOT NULL,
  `trigger_code` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_sla_event_id` bigint(20) unsigned DEFAULT NULL,
  `actor_user_id` int(10) unsigned DEFAULT NULL,
  `event_at` datetime(6) NOT NULL,
  `notes` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_escalation_history_event_key` (`event_key`),
  UNIQUE KEY `uq_escalation_history_case_event` (`escalation_case_id`,`event_code`),
  KEY `idx_escalation_history_timeline` (`escalation_case_id`,`event_at`,`id`),
  KEY `fk_escalation_history_old_state` (`old_state_code`),
  KEY `fk_escalation_history_new_state` (`new_state_code`),
  KEY `fk_escalation_history_sla_event` (`source_sla_event_id`),
  KEY `fk_escalation_history_actor` (`actor_user_id`),
  CONSTRAINT `fk_escalation_history_actor` FOREIGN KEY (`actor_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_escalation_history_case` FOREIGN KEY (`escalation_case_id`) REFERENCES `escalation_cases` (`id`),
  CONSTRAINT `fk_escalation_history_new_state` FOREIGN KEY (`new_state_code`) REFERENCES `escalation_states` (`code`),
  CONSTRAINT `fk_escalation_history_old_state` FOREIGN KEY (`old_state_code`) REFERENCES `escalation_states` (`code`),
  CONSTRAINT `fk_escalation_history_sla_event` FOREIGN KEY (`source_sla_event_id`) REFERENCES `sla_instance_events` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `escalation_history`
--

LOCK TABLES `escalation_history` WRITE;
/*!40000 ALTER TABLE `escalation_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `escalation_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `escalation_rules`
--

DROP TABLE IF EXISTS `escalation_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `escalation_rules` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `policy_id` int(10) unsigned NOT NULL,
  `trigger_code` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `escalation_level` tinyint(3) unsigned NOT NULL,
  `target_role_id` int(10) unsigned NOT NULL,
  `reason_label` varchar(240) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT '100',
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `active_identity` varchar(180) COLLATE utf8mb4_unicode_ci GENERATED ALWAYS AS ((case when (`status` = 'active') then concat(`policy_id`,':',`trigger_code`,':',`escalation_level`,':',`target_role_id`) else NULL end)) STORED,
  `created_by` int(10) unsigned DEFAULT NULL,
  `updated_by` int(10) unsigned DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_escalation_rule_active_identity` (`active_identity`),
  KEY `idx_escalation_rules_match` (`policy_id`,`trigger_code`,`status`,`escalation_level`,`sort_order`),
  KEY `idx_escalation_rules_role` (`target_role_id`,`status`),
  KEY `fk_escalation_rules_created_by` (`created_by`),
  KEY `fk_escalation_rules_updated_by` (`updated_by`),
  CONSTRAINT `fk_escalation_rules_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_escalation_rules_policy` FOREIGN KEY (`policy_id`) REFERENCES `sla_policies` (`id`),
  CONSTRAINT `fk_escalation_rules_role` FOREIGN KEY (`target_role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `fk_escalation_rules_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `escalation_rules`
--

LOCK TABLES `escalation_rules` WRITE;
/*!40000 ALTER TABLE `escalation_rules` DISABLE KEYS */;
INSERT INTO `escalation_rules` (`id`, `policy_id`, `trigger_code`, `escalation_level`, `target_role_id`, `reason_label`, `sort_order`, `status`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES (1,2,'AT_RISK',1,6,'Repair Centre diagnosis/assessment is approaching SLA breach.',10,'active',NULL,NULL,'2026-10-15 20:15:39.009680','2026-10-15 20:15:39.009680'),(2,1,'AT_RISK',1,7,'Approved device is awaiting School-to-TTPost pickup.',10,'active',NULL,NULL,'2026-10-15 20:15:39.009680','2026-10-15 20:15:39.009680'),(3,3,'AT_RISK',1,6,'Repair work is approaching SLA breach.',10,'active',NULL,NULL,'2026-10-15 20:15:39.009680','2026-10-15 20:15:39.009680'),(4,5,'AT_RISK',1,7,'Ready-for-return device is approaching return-logistics SLA breach.',10,'active',NULL,NULL,'2026-10-15 20:15:39.009680','2026-10-15 20:15:39.009680'),(8,2,'BREACHED',2,2,'DIAGNOSIS SLA has breached its configured target.',20,'active',NULL,NULL,'2026-10-15 20:15:39.011493','2026-10-15 20:15:39.011493'),(9,1,'BREACHED',2,2,'PICKUP SLA has breached its configured target.',20,'active',NULL,NULL,'2026-10-15 20:15:39.011493','2026-10-15 20:15:39.011493'),(10,3,'BREACHED',2,2,'REPAIR SLA has breached its configured target.',20,'active',NULL,NULL,'2026-10-15 20:15:39.011493','2026-10-15 20:15:39.011493'),(11,5,'BREACHED',2,2,'RETURN_LOGISTICS SLA has breached its configured target.',20,'active',NULL,NULL,'2026-10-15 20:15:39.011493','2026-10-15 20:15:39.011493');
/*!40000 ALTER TABLE `escalation_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `escalation_states`
--

DROP TABLE IF EXISTS `escalation_states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `escalation_states` (
  `code` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_terminal` tinyint(1) NOT NULL DEFAULT '0',
  `sort_order` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `escalation_states`
--

LOCK TABLES `escalation_states` WRITE;
/*!40000 ALTER TABLE `escalation_states` DISABLE KEYS */;
INSERT INTO `escalation_states` VALUES ('ACKNOWLEDGED','Acknowledged',0,20),('CANCELLED','Cancelled',1,40),('OPEN','Open',0,10),('RESOLVED','Resolved',1,30);
/*!40000 ALTER TABLE `escalation_states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exception_case_status_history`
--

DROP TABLE IF EXISTS `exception_case_status_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exception_case_status_history` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `exception_case_id` int(10) unsigned NOT NULL,
  `from_status_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `to_status_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `actor_user_id` int(10) unsigned NOT NULL,
  `reason` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_exception_status_history_case_time` (`exception_case_id`,`created_at`,`id`),
  KEY `fk_exception_status_history_from` (`from_status_code`),
  KEY `fk_exception_status_history_to` (`to_status_code`),
  KEY `fk_exception_status_history_actor` (`actor_user_id`),
  CONSTRAINT `fk_exception_status_history_actor` FOREIGN KEY (`actor_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_exception_status_history_case` FOREIGN KEY (`exception_case_id`) REFERENCES `repair_exception_cases` (`id`),
  CONSTRAINT `fk_exception_status_history_from` FOREIGN KEY (`from_status_code`) REFERENCES `exception_case_statuses` (`code`),
  CONSTRAINT `fk_exception_status_history_to` FOREIGN KEY (`to_status_code`) REFERENCES `exception_case_statuses` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exception_case_status_history`
--

LOCK TABLES `exception_case_status_history` WRITE;
/*!40000 ALTER TABLE `exception_case_status_history` DISABLE KEYS */;
INSERT INTO `exception_case_status_history` VALUES (1,1,NULL,'ASSESSMENT_REQUIRED',1,'Exception case created from completed non-return repair outcome.','2026-10-20 21:33:45.750959'),(2,1,'ASSESSMENT_REQUIRED','PENDING_DISTRICT_DECISION',1,'Repair Centre submitted the exception assessment for disposition review.','2026-10-20 21:34:30.951283'),(3,1,'PENDING_DISTRICT_DECISION','PENDING_HEAD_OFFICE_APPROVAL',1,NULL,'2026-10-20 21:34:41.196026'),(4,1,'PENDING_HEAD_OFFICE_APPROVAL','REPLACEMENT_APPROVED',1,NULL,'2026-10-20 21:34:56.347604'),(5,1,'REPLACEMENT_APPROVED','PERMANENT_REPLACEMENT_COMPLETED',1,'Permanent replacement accepted.','2026-10-20 21:35:23.933934');
/*!40000 ALTER TABLE `exception_case_status_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exception_case_statuses`
--

DROP TABLE IF EXISTS `exception_case_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exception_case_statuses` (
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` smallint(5) unsigned NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`code`),
  KEY `idx_exception_case_statuses_active_sort` (`is_active`,`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exception_case_statuses`
--

LOCK TABLES `exception_case_statuses` WRITE;
/*!40000 ALTER TABLE `exception_case_statuses` DISABLE KEYS */;
INSERT INTO `exception_case_statuses` VALUES ('ASSESSMENT_REQUIRED','Assessment Required',10,1),('MANUFACTURER_RETURN_APPROVED','Manufacturer Return Approved',60,1),('MANUFACTURER_RETURN_COMPLETED','Manufacturer Return Completed',80,1),('MANUFACTURER_RETURN_IN_PROGRESS','Manufacturer Return In Progress',75,1),('PENDING_DISTRICT_APPROVAL','Pending District Approval',20,1),('PENDING_DISTRICT_DECISION','Pending District Decision',30,1),('PENDING_HEAD_OFFICE_APPROVAL','Pending Head Office Approval',40,1),('PERMANENT_REPLACEMENT_COMPLETED','Permanent Replacement Completed',90,1),('REPAIR_CENTRE_REVIEW_REQUIRED','Repair Centre Review Required',50,1),('REPLACEMENT_APPROVED','Replacement Approved',70,1);
/*!40000 ALTER TABLE `exception_case_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exception_decision_types`
--

DROP TABLE IF EXISTS `exception_decision_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exception_decision_types` (
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exception_decision_types`
--

LOCK TABLES `exception_decision_types` WRITE;
/*!40000 ALTER TABLE `exception_decision_types` DISABLE KEYS */;
INSERT INTO `exception_decision_types` VALUES ('DISTRICT_DISPOSITION_DECISION','District Disposition Decision',1),('DISTRICT_MANUFACTURER_APPROVAL','District Manufacturer Return Approval',1),('HEAD_OFFICE_REPLACEMENT_APPROVAL','Head Office Replacement Approval',1),('REPAIR_CENTRE_SUBMISSION','Repair Centre Exception Submission',1),('RETURN_FOR_REVIEW','Return for Review',1);
/*!40000 ALTER TABLE `exception_decision_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exception_decisions`
--

DROP TABLE IF EXISTS `exception_decisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exception_decisions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `exception_case_id` int(10) unsigned NOT NULL,
  `decision_type_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `selected_disposition_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `decision_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reason` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `actor_user_id` int(10) unsigned NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_exception_decisions_case_time` (`exception_case_id`,`created_at`,`id`),
  KEY `idx_exception_decisions_type` (`decision_type_code`,`decision_code`),
  KEY `fk_exception_decision_disposition` (`selected_disposition_code`),
  KEY `fk_exception_decision_actor` (`actor_user_id`),
  CONSTRAINT `fk_exception_decision_actor` FOREIGN KEY (`actor_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_exception_decision_case` FOREIGN KEY (`exception_case_id`) REFERENCES `repair_exception_cases` (`id`),
  CONSTRAINT `fk_exception_decision_disposition` FOREIGN KEY (`selected_disposition_code`) REFERENCES `exception_dispositions` (`code`),
  CONSTRAINT `fk_exception_decision_type` FOREIGN KEY (`decision_type_code`) REFERENCES `exception_decision_types` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exception_decisions`
--

LOCK TABLES `exception_decisions` WRITE;
/*!40000 ALTER TABLE `exception_decisions` DISABLE KEYS */;
INSERT INTO `exception_decisions` VALUES (1,1,'REPAIR_CENTRE_SUBMISSION',NULL,'SUBMITTED','Exception assessment submitted for approval or district decision.',1,'2026-10-20 21:34:30.952974'),(2,1,'DISTRICT_DISPOSITION_DECISION','PERMANENT_REPLACEMENT','SELECTED',NULL,1,'2026-10-20 21:34:41.201714'),(3,1,'HEAD_OFFICE_REPLACEMENT_APPROVAL',NULL,'APPROVED',NULL,1,'2026-10-20 21:34:56.349158');
/*!40000 ALTER TABLE `exception_decisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exception_dispositions`
--

DROP TABLE IF EXISTS `exception_dispositions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exception_dispositions` (
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exception_dispositions`
--

LOCK TABLES `exception_dispositions` WRITE;
/*!40000 ALTER TABLE `exception_dispositions` DISABLE KEYS */;
INSERT INTO `exception_dispositions` VALUES ('MANUFACTURER_RETURN','Manufacturer Return',1),('PERMANENT_REPLACEMENT','Permanent Replacement',1);
/*!40000 ALTER TABLE `exception_dispositions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exception_financial_assessments`
--

DROP TABLE IF EXISTS `exception_financial_assessments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exception_financial_assessments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `exception_case_id` int(10) unsigned NOT NULL,
  `warranty_decision_code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `warranty_rejection_reason` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `responsibility_party_code` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `negligence_determination_code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estimated_cost` decimal(12,2) DEFAULT NULL,
  `approved_charge_amount` decimal(12,2) DEFAULT NULL,
  `actual_cost` decimal(12,2) DEFAULT NULL,
  `financial_status_code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` varchar(4000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by_user_id` int(10) unsigned NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_exception_assessments_case_time` (`exception_case_id`,`created_at`,`id`),
  KEY `fk_exception_assessment_warranty` (`warranty_decision_code`),
  KEY `fk_exception_assessment_party` (`responsibility_party_code`),
  KEY `fk_exception_assessment_negligence` (`negligence_determination_code`),
  KEY `fk_exception_assessment_financial` (`financial_status_code`),
  KEY `fk_exception_assessment_actor` (`created_by_user_id`),
  CONSTRAINT `fk_exception_assessment_actor` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_exception_assessment_case` FOREIGN KEY (`exception_case_id`) REFERENCES `repair_exception_cases` (`id`),
  CONSTRAINT `fk_exception_assessment_financial` FOREIGN KEY (`financial_status_code`) REFERENCES `exception_financial_statuses` (`code`),
  CONSTRAINT `fk_exception_assessment_negligence` FOREIGN KEY (`negligence_determination_code`) REFERENCES `exception_negligence_determinations` (`code`),
  CONSTRAINT `fk_exception_assessment_party` FOREIGN KEY (`responsibility_party_code`) REFERENCES `exception_responsibility_parties` (`code`),
  CONSTRAINT `fk_exception_assessment_warranty` FOREIGN KEY (`warranty_decision_code`) REFERENCES `exception_warranty_decisions` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exception_financial_assessments`
--

LOCK TABLES `exception_financial_assessments` WRITE;
/*!40000 ALTER TABLE `exception_financial_assessments` DISABLE KEYS */;
INSERT INTO `exception_financial_assessments` VALUES (1,1,'COVERED',NULL,'WARRANTY_MANUFACTURER','NO_EVIDENCE',0.00,0.00,0.00,'PENDING',NULL,NULL,1,'2026-10-20 21:34:24.665104');
/*!40000 ALTER TABLE `exception_financial_assessments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exception_financial_statuses`
--

DROP TABLE IF EXISTS `exception_financial_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exception_financial_statuses` (
  `code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exception_financial_statuses`
--

LOCK TABLES `exception_financial_statuses` WRITE;
/*!40000 ALTER TABLE `exception_financial_statuses` DISABLE KEYS */;
INSERT INTO `exception_financial_statuses` VALUES ('APPROVED','Approved',1),('ESTIMATED','Estimated',1),('INCURRED','Incurred',1),('NOT_APPLICABLE','Not Applicable',1),('PENDING','Pending',1);
/*!40000 ALTER TABLE `exception_financial_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exception_negligence_determinations`
--

DROP TABLE IF EXISTS `exception_negligence_determinations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exception_negligence_determinations` (
  `code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exception_negligence_determinations`
--

LOCK TABLES `exception_negligence_determinations` WRITE;
/*!40000 ALTER TABLE `exception_negligence_determinations` DISABLE KEYS */;
INSERT INTO `exception_negligence_determinations` VALUES ('CONFIRMED','Confirmed',1),('NO_EVIDENCE','No Evidence',1),('NOT_ASSESSED','Not Assessed',1),('SUSPECTED','Suspected',1);
/*!40000 ALTER TABLE `exception_negligence_determinations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exception_responsibility_parties`
--

DROP TABLE IF EXISTS `exception_responsibility_parties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exception_responsibility_parties` (
  `code` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exception_responsibility_parties`
--

LOCK TABLES `exception_responsibility_parties` WRITE;
/*!40000 ALTER TABLE `exception_responsibility_parties` DISABLE KEYS */;
INSERT INTO `exception_responsibility_parties` VALUES ('MOE','Ministry of Education',1),('PARENT_GUARDIAN','Parent / Guardian',1),('TSTT','TSTT',1),('UNDETERMINED','Undetermined',1),('WARRANTY_MANUFACTURER','Warranty Manufacturer',1);
/*!40000 ALTER TABLE `exception_responsibility_parties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exception_warranty_decisions`
--

DROP TABLE IF EXISTS `exception_warranty_decisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exception_warranty_decisions` (
  `code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exception_warranty_decisions`
--

LOCK TABLES `exception_warranty_decisions` WRITE;
/*!40000 ALTER TABLE `exception_warranty_decisions` DISABLE KEYS */;
INSERT INTO `exception_warranty_decisions` VALUES ('COVERED','Covered',1),('NOT_COVERED','Not Covered',1),('PENDING','Pending',1);
/*!40000 ALTER TABLE `exception_warranty_decisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logistics_handoff_scans`
--

DROP TABLE IF EXISTS `logistics_handoff_scans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logistics_handoff_scans` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `logistics_handoff_id` int(10) unsigned NOT NULL,
  `scan_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `scan_method` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `scan_reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scanned_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `scanned_by_user_id` int(10) unsigned NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_logistics_handoff_scans_handoff_scanned` (`logistics_handoff_id`,`scanned_at`),
  KEY `idx_logistics_handoff_scans_scanned_by` (`scanned_by_user_id`),
  CONSTRAINT `fk_logistics_handoff_scans_actor` FOREIGN KEY (`scanned_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_logistics_handoff_scans_handoff` FOREIGN KEY (`logistics_handoff_id`) REFERENCES `logistics_handoffs` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logistics_handoff_scans`
--

LOCK TABLES `logistics_handoff_scans` WRITE;
/*!40000 ALTER TABLE `logistics_handoff_scans` DISABLE KEYS */;
INSERT INTO `logistics_handoff_scans` VALUES (1,1,'DISPATCH','MANUAL',NULL,'2026-10-20 21:03:17.464474',1,'2026-10-20 21:03:17.464474'),(2,1,'RECEIVE','MANUAL',NULL,'2026-10-20 21:03:20.391956',1,'2026-10-20 21:03:20.391956'),(3,2,'DISPATCH','MANUAL',NULL,'2026-10-20 21:03:26.190834',1,'2026-10-20 21:03:26.190834'),(4,2,'RECEIVE','MANUAL',NULL,'2026-10-20 21:03:29.469579',1,'2026-10-20 21:03:29.469579'),(5,3,'DISPATCH','MANUAL',NULL,'2026-10-20 21:28:57.445186',1,'2026-10-20 21:28:57.445186'),(6,3,'RECEIVE','MANUAL',NULL,'2026-10-20 21:28:59.756450',1,'2026-10-20 21:28:59.756450'),(7,4,'DISPATCH','MANUAL',NULL,'2026-10-20 21:29:02.784112',1,'2026-10-20 21:29:02.784112'),(8,4,'RECEIVE','MANUAL',NULL,'2026-10-20 21:29:05.330419',1,'2026-10-20 21:29:05.330419'),(9,5,'DISPATCH','MANUAL',NULL,'2026-10-20 21:32:04.195494',1,'2026-10-20 21:32:04.195494'),(10,5,'RECEIVE','MANUAL',NULL,'2026-10-20 21:32:07.200090',1,'2026-10-20 21:32:07.200090'),(11,6,'DISPATCH','MANUAL',NULL,'2026-10-20 21:32:12.293709',1,'2026-10-20 21:32:12.293709'),(12,6,'RECEIVE','MANUAL',NULL,'2026-10-20 21:32:15.304807',1,'2026-10-20 21:32:15.304807');
/*!40000 ALTER TABLE `logistics_handoff_scans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logistics_handoffs`
--

DROP TABLE IF EXISTS `logistics_handoffs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logistics_handoffs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `logistics_case_id` int(10) unsigned NOT NULL,
  `handoff_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_school_id` int(10) unsigned DEFAULT NULL,
  `from_service_location_id` int(10) unsigned DEFAULT NULL,
  `to_school_id` int(10) unsigned DEFAULT NULL,
  `to_service_location_id` int(10) unsigned DEFAULT NULL,
  `dispatched_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `dispatched_by_user_id` int(10) unsigned NOT NULL,
  `received_at` datetime(6) DEFAULT NULL,
  `received_by_user_id` int(10) unsigned DEFAULT NULL,
  `tracking_reference` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `active_record_key` tinyint(3) unsigned DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `device_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_logistics_handoffs_case_pending` (`logistics_case_id`,`active_record_key`),
  KEY `idx_logistics_handoffs_case_dispatched` (`logistics_case_id`,`dispatched_at`),
  KEY `idx_logistics_handoffs_from_school` (`from_school_id`),
  KEY `idx_logistics_handoffs_to_school` (`to_school_id`),
  KEY `idx_logistics_handoffs_from_location` (`from_service_location_id`),
  KEY `idx_logistics_handoffs_to_location` (`to_service_location_id`),
  KEY `idx_logistics_handoffs_received_at` (`received_at`),
  KEY `idx_logistics_handoffs_dispatched_by` (`dispatched_by_user_id`),
  KEY `idx_logistics_handoffs_received_by` (`received_by_user_id`),
  KEY `idx_logistics_handoff_device` (`device_id`),
  CONSTRAINT `fk_logistics_handoff_device` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_logistics_handoffs_case` FOREIGN KEY (`logistics_case_id`) REFERENCES `ticket_logistics_cases` (`id`),
  CONSTRAINT `fk_logistics_handoffs_dispatched_by` FOREIGN KEY (`dispatched_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_logistics_handoffs_from_location` FOREIGN KEY (`from_service_location_id`) REFERENCES `service_locations` (`id`),
  CONSTRAINT `fk_logistics_handoffs_from_school` FOREIGN KEY (`from_school_id`) REFERENCES `schools` (`id`),
  CONSTRAINT `fk_logistics_handoffs_received_by` FOREIGN KEY (`received_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_logistics_handoffs_to_location` FOREIGN KEY (`to_service_location_id`) REFERENCES `service_locations` (`id`),
  CONSTRAINT `fk_logistics_handoffs_to_school` FOREIGN KEY (`to_school_id`) REFERENCES `schools` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logistics_handoffs`
--

LOCK TABLES `logistics_handoffs` WRITE;
/*!40000 ALTER TABLE `logistics_handoffs` DISABLE KEYS */;
INSERT INTO `logistics_handoffs` VALUES (1,1,'SCHOOL_TO_TTPOST',1,NULL,NULL,1,'2026-10-20 21:03:17.463313',1,'2026-10-20 21:03:20.000000',1,NULL,NULL,NULL,'2026-10-20 21:03:17.463313','2026-10-20 21:03:20.390953',NULL),(2,1,'TTPOST_TO_REPAIR_CENTRE',NULL,1,NULL,2,'2026-10-20 21:03:26.189270',1,'2026-10-20 21:03:29.000000',1,NULL,NULL,NULL,'2026-10-20 21:03:26.189270','2026-10-20 21:03:29.467929',NULL),(3,1,'REPAIR_CENTRE_TO_TTPOST',NULL,2,NULL,1,'2026-10-20 21:28:57.443757',1,'2026-10-20 21:28:59.000000',1,NULL,NULL,NULL,'2026-10-20 21:28:57.443757','2026-10-20 21:28:59.754372',1),(4,1,'TTPOST_TO_SCHOOL',NULL,1,1,NULL,'2026-10-20 21:29:02.781906',1,'2026-10-20 21:29:05.000000',1,NULL,NULL,NULL,'2026-10-20 21:29:02.781906','2026-10-20 21:29:05.329019',1),(5,2,'SCHOOL_TO_TTPOST',1,NULL,NULL,1,'2026-10-20 21:32:04.193840',1,'2026-10-20 21:32:07.000000',1,NULL,NULL,NULL,'2026-10-20 21:32:04.193840','2026-10-20 21:32:07.198468',NULL),(6,2,'TTPOST_TO_REPAIR_CENTRE',NULL,1,NULL,2,'2026-10-20 21:32:12.289290',1,'2026-10-20 21:32:15.000000',1,NULL,NULL,NULL,'2026-10-20 21:32:12.289290','2026-10-20 21:32:15.303264',NULL);
/*!40000 ALTER TABLE `logistics_handoffs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logistics_status_history`
--

DROP TABLE IF EXISTS `logistics_status_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logistics_status_history` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `logistics_case_id` int(10) unsigned NOT NULL,
  `from_status_id` int(10) unsigned DEFAULT NULL,
  `to_status_id` int(10) unsigned NOT NULL,
  `changed_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `changed_by_user_id` int(10) unsigned DEFAULT NULL,
  `reason` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_logistics_status_history_case_changed` (`logistics_case_id`,`changed_at`),
  KEY `idx_logistics_status_history_to_status` (`to_status_id`),
  KEY `idx_logistics_status_history_changed_by` (`changed_by_user_id`),
  KEY `fk_logistics_status_history_from` (`from_status_id`),
  CONSTRAINT `fk_logistics_status_history_actor` FOREIGN KEY (`changed_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_logistics_status_history_case` FOREIGN KEY (`logistics_case_id`) REFERENCES `ticket_logistics_cases` (`id`),
  CONSTRAINT `fk_logistics_status_history_from` FOREIGN KEY (`from_status_id`) REFERENCES `logistics_statuses` (`id`),
  CONSTRAINT `fk_logistics_status_history_to` FOREIGN KEY (`to_status_id`) REFERENCES `logistics_statuses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logistics_status_history`
--

LOCK TABLES `logistics_status_history` WRITE;
/*!40000 ALTER TABLE `logistics_status_history` DISABLE KEYS */;
INSERT INTO `logistics_status_history` VALUES (1,1,NULL,1,'2026-10-20 21:02:46.215905',1,NULL,NULL,'2026-10-20 21:02:46.215905'),(2,1,1,2,'2026-10-20 21:03:10.365548',1,NULL,NULL,'2026-10-20 21:03:10.365548'),(3,1,2,3,'2026-10-20 21:03:20.394631',1,NULL,NULL,'2026-10-20 21:03:20.394631'),(4,1,3,4,'2026-10-20 21:03:29.471785',1,NULL,NULL,'2026-10-20 21:03:29.471785'),(5,1,4,5,'2026-10-20 21:28:19.644242',1,'Repair processing completed; return logistics is pending.',NULL,'2026-10-20 21:28:19.644242'),(6,1,5,6,'2026-10-20 21:28:59.758782',1,NULL,NULL,'2026-10-20 21:28:59.758782'),(7,1,6,7,'2026-10-20 21:29:05.333181',1,NULL,NULL,'2026-10-20 21:29:05.333181'),(8,2,NULL,1,'2026-10-20 21:31:47.022618',1,NULL,NULL,'2026-10-20 21:31:47.022618'),(9,2,1,2,'2026-10-20 21:31:59.213324',1,NULL,NULL,'2026-10-20 21:31:59.213324'),(10,2,2,3,'2026-10-20 21:32:07.203967',1,NULL,NULL,'2026-10-20 21:32:07.203967'),(11,2,3,4,'2026-10-20 21:32:15.306022',1,NULL,NULL,'2026-10-20 21:32:15.306022'),(12,2,4,5,'2026-10-20 21:35:23.935335',1,'Replacement device ready for return.',NULL,'2026-10-20 21:35:23.935335'),(13,2,5,9,'2026-10-20 21:46:45.610516',1,'TEMPORARY_LOAN_CONVERSION','The permanent replacement is the same spare already selected for this ticket; no return transport is required.','2026-10-20 21:46:45.610516');
/*!40000 ALTER TABLE `logistics_status_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logistics_statuses`
--

DROP TABLE IF EXISTS `logistics_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logistics_statuses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` smallint(5) unsigned NOT NULL,
  `is_terminal` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_logistics_statuses_code` (`code`),
  KEY `idx_logistics_statuses_active_sort` (`is_active`,`sort_order`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logistics_statuses`
--

LOCK TABLES `logistics_statuses` WRITE;
/*!40000 ALTER TABLE `logistics_statuses` DISABLE KEYS */;
INSERT INTO `logistics_statuses` VALUES (1,'REQUESTED','Requested','Logistics case created and awaiting TTPost processing.',10,0,1,'2026-10-12 08:43:55','2026-10-12 08:43:55'),(2,'ACCEPTED','Accepted','TTPost accepted processing responsibility; physical possession is not implied.',20,0,1,'2026-10-12 08:43:55','2026-10-12 08:43:55'),(3,'OUTBOUND_IN_TRANSIT','Outbound In Transit','Device entered the physical transport chain toward the Repair Centre.',30,0,1,'2026-10-12 08:43:55','2026-10-12 08:43:55'),(4,'AT_REPAIR_CENTRE','At Repair Centre','Device was physically received by the Repair Centre.',40,0,1,'2026-10-12 08:43:55','2026-10-12 08:43:55'),(5,'READY_FOR_RETURN','Ready for Return','Repair workflow is ready for logistics return to begin.',50,0,1,'2026-10-12 08:43:55','2026-10-12 08:43:55'),(6,'RETURN_IN_TRANSIT','Return In Transit','Device is moving from the Repair Centre toward the School.',60,0,1,'2026-10-12 08:43:55','2026-10-12 08:43:55'),(7,'RETURNED_TO_SCHOOL','Returned to School','Physical logistics cycle completed at School.',70,1,1,'2026-10-12 08:43:55','2026-10-12 08:43:55'),(8,'CANCELLED','Cancelled','Logistics case cancelled before normal completion.',80,1,1,'2026-10-12 08:43:55','2026-10-12 08:43:55'),(9,'FULFILLED_AT_RECIPIENT','Fulfilled at Recipient',NULL,0,1,1,'2026-10-15 12:45:12','2026-10-15 12:45:12');
/*!40000 ALTER TABLE `logistics_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manufacturer_return_cases`
--

DROP TABLE IF EXISTS `manufacturer_return_cases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `manufacturer_return_cases` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `manufacturer_return_number` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `exception_case_id` int(10) unsigned NOT NULL,
  `ticket_id` int(10) unsigned NOT NULL,
  `logistics_case_id` int(10) unsigned NOT NULL,
  `repair_job_id` int(10) unsigned NOT NULL,
  `original_device_id` int(10) unsigned NOT NULL,
  `manufacturer_id` int(10) unsigned NOT NULL,
  `repair_centre_location_id` int(10) unsigned NOT NULL,
  `current_status_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rma_number` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `manufacturer_case_reference` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `warranty_reference` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `expected_return_date` date DEFAULT NULL,
  `started_by` int(10) unsigned NOT NULL,
  `started_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `closed_by` int(10) unsigned DEFAULT NULL,
  `closed_at` datetime(6) DEFAULT NULL,
  `active_record_key` tinyint(3) unsigned DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_mfr_return_number` (`manufacturer_return_number`),
  UNIQUE KEY `uq_mfr_return_case_active` (`exception_case_id`,`active_record_key`),
  KEY `idx_mfr_return_ticket` (`ticket_id`,`started_at`),
  KEY `idx_mfr_return_status` (`current_status_code`,`updated_at`),
  KEY `idx_mfr_return_location` (`repair_centre_location_id`,`current_status_code`),
  KEY `fk_mfr_case_logistics` (`logistics_case_id`),
  KEY `fk_mfr_case_job` (`repair_job_id`),
  KEY `fk_mfr_case_device` (`original_device_id`),
  KEY `fk_mfr_case_manufacturer` (`manufacturer_id`),
  KEY `fk_mfr_case_started_by` (`started_by`),
  KEY `fk_mfr_case_closed_by` (`closed_by`),
  CONSTRAINT `fk_mfr_case_closed_by` FOREIGN KEY (`closed_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_mfr_case_device` FOREIGN KEY (`original_device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_mfr_case_exception` FOREIGN KEY (`exception_case_id`) REFERENCES `repair_exception_cases` (`id`),
  CONSTRAINT `fk_mfr_case_job` FOREIGN KEY (`repair_job_id`) REFERENCES `repair_jobs` (`id`),
  CONSTRAINT `fk_mfr_case_location` FOREIGN KEY (`repair_centre_location_id`) REFERENCES `service_locations` (`id`),
  CONSTRAINT `fk_mfr_case_logistics` FOREIGN KEY (`logistics_case_id`) REFERENCES `ticket_logistics_cases` (`id`),
  CONSTRAINT `fk_mfr_case_manufacturer` FOREIGN KEY (`manufacturer_id`) REFERENCES `manufacturers` (`id`),
  CONSTRAINT `fk_mfr_case_started_by` FOREIGN KEY (`started_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_mfr_case_status` FOREIGN KEY (`current_status_code`) REFERENCES `manufacturer_return_statuses` (`code`),
  CONSTRAINT `fk_mfr_case_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manufacturer_return_cases`
--

LOCK TABLES `manufacturer_return_cases` WRITE;
/*!40000 ALTER TABLE `manufacturer_return_cases` DISABLE KEYS */;
/*!40000 ALTER TABLE `manufacturer_return_cases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manufacturer_return_outcomes`
--

DROP TABLE IF EXISTS `manufacturer_return_outcomes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `manufacturer_return_outcomes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `manufacturer_return_case_id` int(10) unsigned NOT NULL,
  `outcome_code` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `outcome_date` date NOT NULL,
  `manufacturer_resolution_reference` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reason` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` varchar(4000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_mfr_outcome_case_time` (`manufacturer_return_case_id`,`created_at`,`id`),
  KEY `fk_mfr_outcome_actor` (`created_by`),
  CONSTRAINT `fk_mfr_outcome_actor` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_mfr_outcome_case` FOREIGN KEY (`manufacturer_return_case_id`) REFERENCES `manufacturer_return_cases` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manufacturer_return_outcomes`
--

LOCK TABLES `manufacturer_return_outcomes` WRITE;
/*!40000 ALTER TABLE `manufacturer_return_outcomes` DISABLE KEYS */;
/*!40000 ALTER TABLE `manufacturer_return_outcomes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manufacturer_return_shipments`
--

DROP TABLE IF EXISTS `manufacturer_return_shipments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `manufacturer_return_shipments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `manufacturer_return_case_id` int(10) unsigned NOT NULL,
  `direction` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  `carrier_id` int(10) unsigned NOT NULL,
  `tracking_reference` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipment_reference` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `prepared_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `prepared_by_user_id` int(10) unsigned NOT NULL,
  `carrier_pickup_at` datetime(6) DEFAULT NULL,
  `carrier_pickup_by_user_id` int(10) unsigned DEFAULT NULL,
  `destination_received_at` datetime(6) DEFAULT NULL,
  `destination_received_by_user_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_mfr_shipment_direction` (`manufacturer_return_case_id`,`direction`),
  KEY `idx_mfr_shipment_carrier_pickup` (`carrier_id`,`direction`,`carrier_pickup_at`),
  KEY `fk_mfr_shipment_prepared_by` (`prepared_by_user_id`),
  KEY `fk_mfr_shipment_pickup_by` (`carrier_pickup_by_user_id`),
  KEY `fk_mfr_shipment_received_by` (`destination_received_by_user_id`),
  CONSTRAINT `fk_mfr_shipment_carrier` FOREIGN KEY (`carrier_id`) REFERENCES `carriers` (`id`),
  CONSTRAINT `fk_mfr_shipment_case` FOREIGN KEY (`manufacturer_return_case_id`) REFERENCES `manufacturer_return_cases` (`id`),
  CONSTRAINT `fk_mfr_shipment_pickup_by` FOREIGN KEY (`carrier_pickup_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_mfr_shipment_prepared_by` FOREIGN KEY (`prepared_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_mfr_shipment_received_by` FOREIGN KEY (`destination_received_by_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manufacturer_return_shipments`
--

LOCK TABLES `manufacturer_return_shipments` WRITE;
/*!40000 ALTER TABLE `manufacturer_return_shipments` DISABLE KEYS */;
/*!40000 ALTER TABLE `manufacturer_return_shipments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manufacturer_return_status_history`
--

DROP TABLE IF EXISTS `manufacturer_return_status_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `manufacturer_return_status_history` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `manufacturer_return_case_id` int(10) unsigned NOT NULL,
  `from_status_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `to_status_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `actor_user_id` int(10) unsigned NOT NULL,
  `reason` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_mfr_status_history_case_time` (`manufacturer_return_case_id`,`created_at`,`id`),
  KEY `fk_mfr_history_from` (`from_status_code`),
  KEY `fk_mfr_history_to` (`to_status_code`),
  KEY `fk_mfr_history_actor` (`actor_user_id`),
  CONSTRAINT `fk_mfr_history_actor` FOREIGN KEY (`actor_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_mfr_history_case` FOREIGN KEY (`manufacturer_return_case_id`) REFERENCES `manufacturer_return_cases` (`id`),
  CONSTRAINT `fk_mfr_history_from` FOREIGN KEY (`from_status_code`) REFERENCES `manufacturer_return_statuses` (`code`),
  CONSTRAINT `fk_mfr_history_to` FOREIGN KEY (`to_status_code`) REFERENCES `manufacturer_return_statuses` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manufacturer_return_status_history`
--

LOCK TABLES `manufacturer_return_status_history` WRITE;
/*!40000 ALTER TABLE `manufacturer_return_status_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `manufacturer_return_status_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manufacturer_return_statuses`
--

DROP TABLE IF EXISTS `manufacturer_return_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `manufacturer_return_statuses` (
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` smallint(5) unsigned NOT NULL,
  `is_terminal` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`code`),
  KEY `idx_mfr_status_active_sort` (`is_active`,`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manufacturer_return_statuses`
--

LOCK TABLES `manufacturer_return_statuses` WRITE;
/*!40000 ALTER TABLE `manufacturer_return_statuses` DISABLE KEYS */;
INSERT INTO `manufacturer_return_statuses` VALUES ('AT_MANUFACTURER','At Manufacturer',40,0,1),('AWAITING_OUTBOUND_CARRIER_PICKUP','Awaiting Outbound Carrier Pickup',20,0,1),('AWAITING_RETURN_CARRIER_PICKUP','Awaiting Return Carrier Pickup',50,0,1),('COMPLETED','Completed',70,1,1),('OUTBOUND_IN_TRANSIT','Outbound In Transit',30,0,1),('PREPARATION_REQUIRED','Preparation Required',10,0,1),('RETURN_IN_TRANSIT','Return In Transit',60,0,1);
/*!40000 ALTER TABLE `manufacturer_return_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manufacturer_supplied_unit_acceptances`
--

DROP TABLE IF EXISTS `manufacturer_supplied_unit_acceptances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `manufacturer_supplied_unit_acceptances` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `staged_unit_id` bigint(20) unsigned NOT NULL,
  `replacement_case_id` int(10) unsigned NOT NULL,
  `replacement_device_id` int(10) unsigned NOT NULL,
  `accepted_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `accepted_by` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_msu_acceptance_stage` (`staged_unit_id`),
  UNIQUE KEY `uq_msu_acceptance_case` (`replacement_case_id`),
  UNIQUE KEY `uq_msu_acceptance_device` (`replacement_device_id`),
  KEY `fk_msu_acceptance_actor` (`accepted_by`),
  CONSTRAINT `fk_msu_acceptance_actor` FOREIGN KEY (`accepted_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_msu_acceptance_case` FOREIGN KEY (`replacement_case_id`) REFERENCES `permanent_replacement_cases` (`id`),
  CONSTRAINT `fk_msu_acceptance_device` FOREIGN KEY (`replacement_device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_msu_acceptance_stage` FOREIGN KEY (`staged_unit_id`) REFERENCES `manufacturer_supplied_units` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manufacturer_supplied_unit_acceptances`
--

LOCK TABLES `manufacturer_supplied_unit_acceptances` WRITE;
/*!40000 ALTER TABLE `manufacturer_supplied_unit_acceptances` DISABLE KEYS */;
/*!40000 ALTER TABLE `manufacturer_supplied_unit_acceptances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manufacturer_supplied_units`
--

DROP TABLE IF EXISTS `manufacturer_supplied_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `manufacturer_supplied_units` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `manufacturer_return_case_id` int(10) unsigned NOT NULL,
  `manufacturer_return_outcome_id` bigint(20) unsigned NOT NULL,
  `manufacturer_id` int(10) unsigned NOT NULL,
  `serial_number` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `normalized_serial_number` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `manufacturer_model_reference` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `resolved_model_id` int(10) unsigned DEFAULT NULL,
  `model_description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `manufacturer_warranty_reference` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `warranty_start` date DEFAULT NULL,
  `warranty_end` date DEFAULT NULL,
  `received_at` datetime(6) DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_mfr_supplied_normalized_serial` (`normalized_serial_number`),
  KEY `idx_mfr_supplied_case` (`manufacturer_return_case_id`),
  KEY `fk_mfr_unit_outcome` (`manufacturer_return_outcome_id`),
  KEY `fk_mfr_unit_manufacturer` (`manufacturer_id`),
  KEY `fk_mfr_unit_model` (`resolved_model_id`),
  KEY `fk_mfr_unit_actor` (`created_by`),
  CONSTRAINT `fk_mfr_unit_actor` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_mfr_unit_case` FOREIGN KEY (`manufacturer_return_case_id`) REFERENCES `manufacturer_return_cases` (`id`),
  CONSTRAINT `fk_mfr_unit_manufacturer` FOREIGN KEY (`manufacturer_id`) REFERENCES `manufacturers` (`id`),
  CONSTRAINT `fk_mfr_unit_model` FOREIGN KEY (`resolved_model_id`) REFERENCES `device_models` (`id`),
  CONSTRAINT `fk_mfr_unit_outcome` FOREIGN KEY (`manufacturer_return_outcome_id`) REFERENCES `manufacturer_return_outcomes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manufacturer_supplied_units`
--

LOCK TABLES `manufacturer_supplied_units` WRITE;
/*!40000 ALTER TABLE `manufacturer_supplied_units` DISABLE KEYS */;
/*!40000 ALTER TABLE `manufacturer_supplied_units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manufacturers`
--

DROP TABLE IF EXISTS `manufacturers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `manufacturers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `manufacturer_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_by_user_id` int(10) unsigned DEFAULT NULL,
  `updated_by_user_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_manufacturers_code` (`manufacturer_code`),
  UNIQUE KEY `uq_manufacturers_name` (`name`),
  KEY `idx_manufacturers_status` (`status`),
  KEY `idx_manufacturers_created_by` (`created_by_user_id`),
  KEY `idx_manufacturers_updated_by` (`updated_by_user_id`),
  CONSTRAINT `fk_manufacturers_created_by` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_manufacturers_updated_by` FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manufacturers`
--

LOCK TABLES `manufacturers` WRITE;
/*!40000 ALTER TABLE `manufacturers` DISABLE KEYS */;
INSERT INTO `manufacturers` VALUES (1,'P4BMFG1792543270','LENOVO','active',1,1,'2026-10-20 20:41:10','2026-10-20 20:41:10');
/*!40000 ALTER TABLE `manufacturers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_channel_rules`
--

DROP TABLE IF EXISTS `notification_channel_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification_channel_rules` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `event_type_code` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `channel_code` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `max_attempts` tinyint(3) unsigned NOT NULL DEFAULT '3',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_notification_channel_rule` (`event_type_code`,`channel_code`),
  KEY `fk_notification_channel_rule_channel` (`channel_code`),
  CONSTRAINT `fk_notification_channel_rule_channel` FOREIGN KEY (`channel_code`) REFERENCES `notification_channels` (`code`),
  CONSTRAINT `fk_notification_channel_rule_event` FOREIGN KEY (`event_type_code`) REFERENCES `notification_event_types` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_channel_rules`
--

LOCK TABLES `notification_channel_rules` WRITE;
/*!40000 ALTER TABLE `notification_channel_rules` DISABLE KEYS */;
INSERT INTO `notification_channel_rules` VALUES (1,'SLA_AT_RISK','EMAIL',1,3,'2026-10-16 14:02:14.829255','2026-10-16 14:02:14.829255'),(2,'SLA_BREACHED','EMAIL',1,3,'2026-10-16 14:02:14.829255','2026-10-16 14:02:14.829255'),(3,'ESCALATION_RESOLVED','EMAIL',1,3,'2026-10-16 14:02:14.829255','2026-10-16 14:02:14.829255'),(4,'ESCALATION_CANCELLED','EMAIL',1,3,'2026-10-16 14:02:14.829255','2026-10-16 14:02:14.829255'),(5,'TICKET_SUBMITTED','EMAIL',1,3,'2026-10-16 14:02:14.829255','2026-10-16 14:02:14.829255'),(6,'TICKET_CLARIFICATION_REQUESTED','EMAIL',1,3,'2026-10-16 14:02:14.829255','2026-10-16 14:02:14.829255'),(7,'DISTRICT_APPROVAL_REQUIRED','EMAIL',1,3,'2026-10-16 14:02:14.829255','2026-10-16 14:02:14.829255'),(8,'TICKET_APPROVED_FOR_PICKUP','EMAIL',1,3,'2026-10-16 14:02:14.829255','2026-10-16 14:02:14.829255'),(9,'LOGISTICS_PICKUP_REQUESTED','EMAIL',1,3,'2026-10-16 14:02:14.829255','2026-10-16 14:02:14.829255'),(10,'LOGISTICS_SCHOOL_RELEASED','EMAIL',1,3,'2026-10-16 14:02:14.829255','2026-10-16 14:02:14.829255'),(11,'LOGISTICS_RECEIVED_BY_TTPOST','EMAIL',1,3,'2026-10-16 14:02:14.829255','2026-10-16 14:02:14.829255'),(12,'LOGISTICS_SENT_TO_REPAIR_CENTRE','EMAIL',1,3,'2026-10-16 14:02:14.829255','2026-10-16 14:02:14.829255'),(13,'LOGISTICS_RECEIVED_BY_REPAIR_CENTRE','EMAIL',1,3,'2026-10-16 14:02:14.829255','2026-10-16 14:02:14.829255'),(14,'LOGISTICS_READY_FOR_RETURN_PICKUP','EMAIL',1,3,'2026-10-16 14:02:14.829255','2026-10-16 14:02:14.829255'),(15,'LOGISTICS_RETURN_RECEIVED_BY_TTPOST','EMAIL',1,3,'2026-10-16 14:02:14.829255','2026-10-16 14:02:14.829255'),(16,'LOGISTICS_RETURN_IN_TRANSIT_TO_SCHOOL','EMAIL',1,3,'2026-10-16 14:02:14.829255','2026-10-16 14:02:14.829255'),(17,'LOGISTICS_RETURNED_TO_SCHOOL','EMAIL',1,3,'2026-10-16 14:02:14.829255','2026-10-16 14:02:14.829255'),(18,'REPAIR_STARTED','EMAIL',1,3,'2026-10-16 14:02:14.829255','2026-10-16 14:02:14.829255'),(19,'REPAIR_COMPLETED','EMAIL',1,3,'2026-10-16 14:02:14.829255','2026-10-16 14:02:14.829255'),(20,'DISTRICT_REPAIR_DECISION_REQUIRED','EMAIL',1,3,'2026-10-16 14:02:14.829255','2026-10-16 14:02:14.829255'),(21,'HEAD_OFFICE_REPLACEMENT_APPROVAL_REQUIRED','EMAIL',1,3,'2026-10-16 14:02:14.829255','2026-10-16 14:02:14.829255');
/*!40000 ALTER TABLE `notification_channel_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_channels`
--

DROP TABLE IF EXISTS `notification_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification_channels` (
  `code` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_channels`
--

LOCK TABLES `notification_channels` WRITE;
/*!40000 ALTER TABLE `notification_channels` DISABLE KEYS */;
INSERT INTO `notification_channels` VALUES ('EMAIL','Email');
/*!40000 ALTER TABLE `notification_channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_deliveries`
--

DROP TABLE IF EXISTS `notification_deliveries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification_deliveries` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `delivery_number` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notification_event_id` bigint(20) unsigned NOT NULL,
  `notification_recipient_id` bigint(20) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `channel_code` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `recipient_address` varchar(254) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `recipient_name` varchar(220) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subject_snapshot` varchar(220) COLLATE utf8mb4_unicode_ci NOT NULL,
  `body_text_snapshot` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `body_html_snapshot` mediumtext COLLATE utf8mb4_unicode_ci,
  `action_url_snapshot` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status_code` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempt_count` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `max_attempts` tinyint(3) unsigned NOT NULL DEFAULT '3',
  `next_attempt_at` datetime(6) DEFAULT NULL,
  `last_attempt_at` datetime(6) DEFAULT NULL,
  `sent_at` datetime(6) DEFAULT NULL,
  `processing_started_at` datetime(6) DEFAULT NULL,
  `processing_token` varchar(96) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_error_code` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_error_message` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_notification_delivery_recipient_channel` (`notification_recipient_id`,`channel_code`),
  UNIQUE KEY `uq_notification_delivery_number` (`delivery_number`),
  KEY `idx_notification_delivery_due` (`status_code`,`next_attempt_at`,`id`),
  KEY `idx_notification_delivery_event` (`notification_event_id`,`id`),
  KEY `idx_notification_delivery_user` (`user_id`,`created_at`),
  KEY `idx_notification_delivery_processing` (`status_code`,`processing_started_at`),
  KEY `fk_notification_delivery_channel` (`channel_code`),
  CONSTRAINT `fk_notification_delivery_channel` FOREIGN KEY (`channel_code`) REFERENCES `notification_channels` (`code`),
  CONSTRAINT `fk_notification_delivery_event` FOREIGN KEY (`notification_event_id`) REFERENCES `notification_events` (`id`),
  CONSTRAINT `fk_notification_delivery_recipient` FOREIGN KEY (`notification_recipient_id`) REFERENCES `notification_recipients` (`id`),
  CONSTRAINT `fk_notification_delivery_status` FOREIGN KEY (`status_code`) REFERENCES `notification_delivery_statuses` (`code`),
  CONSTRAINT `fk_notification_delivery_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_deliveries`
--

LOCK TABLES `notification_deliveries` WRITE;
/*!40000 ALTER TABLE `notification_deliveries` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_deliveries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_delivery_attempts`
--

DROP TABLE IF EXISTS `notification_delivery_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification_delivery_attempts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `notification_delivery_id` bigint(20) unsigned NOT NULL,
  `attempt_number` tinyint(3) unsigned NOT NULL,
  `attempted_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `outcome_code` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `error_code` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `error_message` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_notification_delivery_attempt_number` (`notification_delivery_id`,`attempt_number`),
  KEY `idx_notification_delivery_attempted` (`attempted_at`,`notification_delivery_id`),
  CONSTRAINT `fk_notification_delivery_attempt_delivery` FOREIGN KEY (`notification_delivery_id`) REFERENCES `notification_deliveries` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_delivery_attempts`
--

LOCK TABLES `notification_delivery_attempts` WRITE;
/*!40000 ALTER TABLE `notification_delivery_attempts` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_delivery_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_delivery_statuses`
--

DROP TABLE IF EXISTS `notification_delivery_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification_delivery_statuses` (
  `code` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_terminal` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_delivery_statuses`
--

LOCK TABLES `notification_delivery_statuses` WRITE;
/*!40000 ALTER TABLE `notification_delivery_statuses` DISABLE KEYS */;
INSERT INTO `notification_delivery_statuses` VALUES ('FAILED_PERMANENT','Failed permanently',1),('PENDING','Pending',0),('PROCESSING','Processing',0),('RETRY_PENDING','Retry pending',0),('SENT','Sent',1),('SKIPPED_INVALID_ADDRESS','Skipped: invalid address',1),('SKIPPED_NO_ADDRESS','Skipped: no address',1);
/*!40000 ALTER TABLE `notification_delivery_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_event_types`
--

DROP TABLE IF EXISTS `notification_event_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification_event_types` (
  `code` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_event_types`
--

LOCK TABLES `notification_event_types` WRITE;
/*!40000 ALTER TABLE `notification_event_types` DISABLE KEYS */;
INSERT INTO `notification_event_types` VALUES ('DISTRICT_APPROVAL_REQUIRED','District approval required'),('DISTRICT_REPAIR_DECISION_REQUIRED','District repair decision required'),('ESCALATION_CANCELLED','Escalation cancelled'),('ESCALATION_RESOLVED','Escalation resolved'),('HEAD_OFFICE_REPLACEMENT_APPROVAL_REQUIRED','Head Office replacement approval required'),('LOGISTICS_PICKUP_REQUESTED','Logistics pickup requested'),('LOGISTICS_READY_FOR_RETURN_PICKUP','Device ready for return pickup'),('LOGISTICS_RECEIVED_BY_REPAIR_CENTRE','Device received by Repair Centre'),('LOGISTICS_RECEIVED_BY_TTPOST','Device received by TTPost'),('LOGISTICS_RETURN_IN_TRANSIT_TO_SCHOOL','Return in transit to school'),('LOGISTICS_RETURN_RECEIVED_BY_TTPOST','Return received by TTPost'),('LOGISTICS_RETURNED_TO_SCHOOL','Device returned to school'),('LOGISTICS_SCHOOL_RELEASED','Device released by school'),('LOGISTICS_SENT_TO_REPAIR_CENTRE','Device sent to Repair Centre'),('REPAIR_COMPLETED','Repair completed'),('REPAIR_STARTED','Repair started'),('SLA_AT_RISK','SLA at risk'),('SLA_BREACHED','SLA breached'),('SYSTEM_INFORMATION','System information'),('SYSTEM_WARNING','System warning'),('TEST_NOTIFICATION','Test notification'),('TICKET_APPROVED_FOR_PICKUP','Ticket approved for pickup'),('TICKET_CLARIFICATION_REQUESTED','Ticket clarification requested'),('TICKET_SUBMITTED','Ticket submitted');
/*!40000 ALTER TABLE `notification_event_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_events`
--

DROP TABLE IF EXISTS `notification_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification_events` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `idempotency_key` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `event_type_code` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_type` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `source_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ticket_id` int(10) unsigned DEFAULT NULL,
  `sla_instance_id` bigint(20) unsigned DEFAULT NULL,
  `escalation_case_id` bigint(20) unsigned DEFAULT NULL,
  `logistics_case_id` int(10) unsigned DEFAULT NULL,
  `repair_job_id` int(10) unsigned DEFAULT NULL,
  `temporary_loan_case_id` bigint(20) unsigned DEFAULT NULL,
  `permanent_replacement_case_id` bigint(20) unsigned DEFAULT NULL,
  `severity_code` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_type` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `action_reference` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` int(10) unsigned DEFAULT NULL,
  `metadata_json` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_notification_event_idempotency` (`idempotency_key`),
  KEY `idx_notification_event_created` (`created_at`,`id`),
  KEY `idx_notification_event_ticket` (`ticket_id`,`created_at`),
  KEY `idx_notification_event_source` (`source_type`,`source_id`),
  KEY `fk_notification_event_severity` (`severity_code`),
  KEY `fk_notification_event_creator` (`created_by`),
  KEY `fk_notification_event_type` (`event_type_code`),
  CONSTRAINT `fk_notification_event_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_notification_event_severity` FOREIGN KEY (`severity_code`) REFERENCES `notification_severities` (`code`),
  CONSTRAINT `fk_notification_event_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`),
  CONSTRAINT `fk_notification_event_type` FOREIGN KEY (`event_type_code`) REFERENCES `notification_event_types` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_events`
--

LOCK TABLES `notification_events` WRITE;
/*!40000 ALTER TABLE `notification_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_recipients`
--

DROP TABLE IF EXISTS `notification_recipients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification_recipients` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `notification_event_id` bigint(20) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `recipient_role_code` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivered_in_app_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `read_at` datetime(6) DEFAULT NULL,
  `read_by` int(10) unsigned DEFAULT NULL,
  `archived_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_notification_recipient_event_user` (`notification_event_id`,`user_id`),
  KEY `idx_notification_recipient_inbox` (`user_id`,`read_at`,`archived_at`,`notification_event_id`),
  KEY `fk_notification_recipient_reader` (`read_by`),
  CONSTRAINT `fk_notification_recipient_event` FOREIGN KEY (`notification_event_id`) REFERENCES `notification_events` (`id`),
  CONSTRAINT `fk_notification_recipient_reader` FOREIGN KEY (`read_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_notification_recipient_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_recipients`
--

LOCK TABLES `notification_recipients` WRITE;
/*!40000 ALTER TABLE `notification_recipients` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_recipients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_severities`
--

DROP TABLE IF EXISTS `notification_severities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification_severities` (
  `code` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_severities`
--

LOCK TABLES `notification_severities` WRITE;
/*!40000 ALTER TABLE `notification_severities` DISABLE KEYS */;
INSERT INTO `notification_severities` VALUES ('CRITICAL','Critical',40),('INFO','Information',10),('SUCCESS','Success',20),('WARNING','Warning',30);
/*!40000 ALTER TABLE `notification_severities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_requests`
--

DROP TABLE IF EXISTS `password_reset_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `password_reset_requests` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `request_id` char(52) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `token_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_snapshot` varchar(254) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime NOT NULL,
  `used_at` datetime DEFAULT NULL,
  `invalidated_at` datetime DEFAULT NULL,
  `email_sent_at` datetime DEFAULT NULL,
  `purpose` enum('PASSWORD_RESET','ACCOUNT_SETUP') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PASSWORD_RESET',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_password_reset_request_id` (`request_id`),
  KEY `idx_password_reset_user_created` (`user_id`,`created_at`),
  KEY `idx_password_reset_expiry` (`expires_at`),
  KEY `idx_password_reset_user_active` (`user_id`,`used_at`,`invalidated_at`,`expires_at`),
  CONSTRAINT `fk_password_reset_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_requests`
--

LOCK TABLES `password_reset_requests` WRITE;
/*!40000 ALTER TABLE `password_reset_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permanent_replacement_allocation_transfers`
--

DROP TABLE IF EXISTS `permanent_replacement_allocation_transfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permanent_replacement_allocation_transfers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `replacement_case_id` int(10) unsigned NOT NULL,
  `allocation_level` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `district_id` int(10) unsigned DEFAULT NULL,
  `school_id` int(10) unsigned DEFAULT NULL,
  `student_id` int(10) unsigned DEFAULT NULL,
  `original_district_allocation_id` int(10) unsigned DEFAULT NULL,
  `original_school_allocation_id` int(10) unsigned DEFAULT NULL,
  `original_student_assignment_id` int(10) unsigned DEFAULT NULL,
  `replacement_district_allocation_id` int(10) unsigned DEFAULT NULL,
  `replacement_school_allocation_id` int(10) unsigned DEFAULT NULL,
  `replacement_student_assignment_id` int(10) unsigned DEFAULT NULL,
  `source_stock_location_id` bigint(20) unsigned DEFAULT NULL,
  `transferred_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `transferred_by` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_pr_allocation_transfer_case` (`replacement_case_id`),
  KEY `fk_pr_transfer_district` (`district_id`),
  KEY `fk_pr_transfer_school` (`school_id`),
  KEY `fk_pr_transfer_student` (`student_id`),
  KEY `fk_pr_transfer_original_district` (`original_district_allocation_id`),
  KEY `fk_pr_transfer_original_school` (`original_school_allocation_id`),
  KEY `fk_pr_transfer_original_student` (`original_student_assignment_id`),
  KEY `fk_pr_transfer_replacement_district` (`replacement_district_allocation_id`),
  KEY `fk_pr_transfer_replacement_school` (`replacement_school_allocation_id`),
  KEY `fk_pr_transfer_replacement_student` (`replacement_student_assignment_id`),
  KEY `fk_pr_transfer_stock` (`source_stock_location_id`),
  KEY `fk_pr_transfer_actor` (`transferred_by`),
  CONSTRAINT `fk_pr_transfer_actor` FOREIGN KEY (`transferred_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_pr_transfer_case` FOREIGN KEY (`replacement_case_id`) REFERENCES `permanent_replacement_cases` (`id`),
  CONSTRAINT `fk_pr_transfer_district` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`),
  CONSTRAINT `fk_pr_transfer_original_district` FOREIGN KEY (`original_district_allocation_id`) REFERENCES `device_district_allocations` (`id`),
  CONSTRAINT `fk_pr_transfer_original_school` FOREIGN KEY (`original_school_allocation_id`) REFERENCES `device_school_allocations` (`id`),
  CONSTRAINT `fk_pr_transfer_original_student` FOREIGN KEY (`original_student_assignment_id`) REFERENCES `device_student_assignments` (`id`),
  CONSTRAINT `fk_pr_transfer_replacement_district` FOREIGN KEY (`replacement_district_allocation_id`) REFERENCES `device_district_allocations` (`id`),
  CONSTRAINT `fk_pr_transfer_replacement_school` FOREIGN KEY (`replacement_school_allocation_id`) REFERENCES `device_school_allocations` (`id`),
  CONSTRAINT `fk_pr_transfer_replacement_student` FOREIGN KEY (`replacement_student_assignment_id`) REFERENCES `device_student_assignments` (`id`),
  CONSTRAINT `fk_pr_transfer_school` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`),
  CONSTRAINT `fk_pr_transfer_stock` FOREIGN KEY (`source_stock_location_id`) REFERENCES `device_stock_locations` (`id`),
  CONSTRAINT `fk_pr_transfer_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permanent_replacement_allocation_transfers`
--

LOCK TABLES `permanent_replacement_allocation_transfers` WRITE;
/*!40000 ALTER TABLE `permanent_replacement_allocation_transfers` DISABLE KEYS */;
INSERT INTO `permanent_replacement_allocation_transfers` VALUES (1,1,'STUDENT',6,1,1,1,1,1,3,3,2,2,'2026-10-20 21:35:23.911209',1);
/*!40000 ALTER TABLE `permanent_replacement_allocation_transfers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permanent_replacement_cases`
--

DROP TABLE IF EXISTS `permanent_replacement_cases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permanent_replacement_cases` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `replacement_number` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `exception_case_id` int(10) unsigned DEFAULT NULL,
  `temporary_loan_case_id` int(10) unsigned DEFAULT NULL,
  `ticket_id` int(10) unsigned NOT NULL,
  `logistics_case_id` int(10) unsigned NOT NULL,
  `repair_job_id` int(10) unsigned NOT NULL,
  `original_device_id` int(10) unsigned NOT NULL,
  `replacement_source_type` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `staged_manufacturer_unit_id` bigint(20) unsigned DEFAULT NULL,
  `replacement_device_id` int(10) unsigned DEFAULT NULL,
  `selected_by` int(10) unsigned DEFAULT NULL,
  `selected_at` datetime(6) DEFAULT NULL,
  `repair_service_location_id` int(10) unsigned NOT NULL,
  `current_status_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active_record_key` tinyint(3) unsigned DEFAULT '1',
  `active_selection_key` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` int(10) unsigned DEFAULT NULL,
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `completed_by` int(10) unsigned DEFAULT NULL,
  `completed_at` datetime(6) DEFAULT NULL,
  `closed_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_perm_repl_number` (`replacement_number`),
  UNIQUE KEY `uq_perm_repl_exception_active` (`exception_case_id`,`active_record_key`),
  UNIQUE KEY `uq_perm_repl_active_selection` (`active_selection_key`),
  UNIQUE KEY `uq_perm_repl_temporary_loan` (`temporary_loan_case_id`),
  KEY `idx_perm_repl_ticket` (`ticket_id`,`created_at`),
  KEY `idx_perm_repl_status` (`current_status_code`,`updated_at`),
  KEY `idx_perm_repl_location` (`repair_service_location_id`,`current_status_code`),
  KEY `idx_perm_repl_original_device` (`original_device_id`),
  KEY `idx_perm_repl_replacement_device` (`replacement_device_id`),
  KEY `fk_perm_repl_logistics` (`logistics_case_id`),
  KEY `fk_perm_repl_job` (`repair_job_id`),
  KEY `fk_perm_repl_staged_unit` (`staged_manufacturer_unit_id`),
  KEY `fk_perm_repl_created_by` (`created_by`),
  KEY `fk_perm_repl_updated_by` (`updated_by`),
  KEY `fk_perm_repl_completed_by` (`completed_by`),
  KEY `idx_perm_repl_selected_by` (`selected_by`),
  CONSTRAINT `fk_perm_repl_completed_by` FOREIGN KEY (`completed_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_perm_repl_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_perm_repl_exception` FOREIGN KEY (`exception_case_id`) REFERENCES `repair_exception_cases` (`id`),
  CONSTRAINT `fk_perm_repl_job` FOREIGN KEY (`repair_job_id`) REFERENCES `repair_jobs` (`id`),
  CONSTRAINT `fk_perm_repl_location` FOREIGN KEY (`repair_service_location_id`) REFERENCES `service_locations` (`id`),
  CONSTRAINT `fk_perm_repl_logistics` FOREIGN KEY (`logistics_case_id`) REFERENCES `ticket_logistics_cases` (`id`),
  CONSTRAINT `fk_perm_repl_original_device` FOREIGN KEY (`original_device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_perm_repl_replacement_device` FOREIGN KEY (`replacement_device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_perm_repl_selected_by` FOREIGN KEY (`selected_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_perm_repl_staged_unit` FOREIGN KEY (`staged_manufacturer_unit_id`) REFERENCES `manufacturer_supplied_units` (`id`),
  CONSTRAINT `fk_perm_repl_status` FOREIGN KEY (`current_status_code`) REFERENCES `permanent_replacement_statuses` (`code`),
  CONSTRAINT `fk_perm_repl_temporary_loan` FOREIGN KEY (`temporary_loan_case_id`) REFERENCES `temporary_loan_cases` (`id`),
  CONSTRAINT `fk_perm_repl_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`),
  CONSTRAINT `fk_perm_repl_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permanent_replacement_cases`
--

LOCK TABLES `permanent_replacement_cases` WRITE;
/*!40000 ALTER TABLE `permanent_replacement_cases` DISABLE KEYS */;
INSERT INTO `permanent_replacement_cases` VALUES (1,'PR1',1,2,2,2,2,1,'TEMPORARY_LOAN_CONVERSION',NULL,2,1,'2026-10-20 21:35:16.000000',2,'COMPLETED',NULL,NULL,1,'2026-10-20 21:34:59.696450',1,'2026-10-20 21:46:45.606886',1,'2026-10-20 21:35:23.000000','2026-10-20 21:35:23.000000');
/*!40000 ALTER TABLE `permanent_replacement_cases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permanent_replacement_status_history`
--

DROP TABLE IF EXISTS `permanent_replacement_status_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permanent_replacement_status_history` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `replacement_case_id` int(10) unsigned NOT NULL,
  `from_status_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `to_status_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `actor_user_id` int(10) unsigned NOT NULL,
  `reason` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_perm_repl_history_case_time` (`replacement_case_id`,`created_at`,`id`),
  KEY `fk_perm_repl_history_from` (`from_status_code`),
  KEY `fk_perm_repl_history_to` (`to_status_code`),
  KEY `fk_perm_repl_history_actor` (`actor_user_id`),
  CONSTRAINT `fk_perm_repl_history_actor` FOREIGN KEY (`actor_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_perm_repl_history_case` FOREIGN KEY (`replacement_case_id`) REFERENCES `permanent_replacement_cases` (`id`),
  CONSTRAINT `fk_perm_repl_history_from` FOREIGN KEY (`from_status_code`) REFERENCES `permanent_replacement_statuses` (`code`),
  CONSTRAINT `fk_perm_repl_history_to` FOREIGN KEY (`to_status_code`) REFERENCES `permanent_replacement_statuses` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permanent_replacement_status_history`
--

LOCK TABLES `permanent_replacement_status_history` WRITE;
/*!40000 ALTER TABLE `permanent_replacement_status_history` DISABLE KEYS */;
INSERT INTO `permanent_replacement_status_history` VALUES (1,1,NULL,'SELECTION_REQUIRED',1,'Permanent replacement case started after Head Office approval.','2026-10-20 21:34:59.698905'),(2,1,'SELECTION_REQUIRED','REPLACEMENT_SELECTED',1,'Permanent replacement source selected.','2026-10-20 21:35:16.761526'),(3,1,'REPLACEMENT_SELECTED','COMPLETED',1,'Permanent replacement accepted and allocation transferred.','2026-10-20 21:35:23.931236');
/*!40000 ALTER TABLE `permanent_replacement_status_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permanent_replacement_statuses`
--

DROP TABLE IF EXISTS `permanent_replacement_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permanent_replacement_statuses` (
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` smallint(5) unsigned NOT NULL,
  `is_terminal` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`code`),
  KEY `idx_perm_repl_status_active_sort` (`is_active`,`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permanent_replacement_statuses`
--

LOCK TABLES `permanent_replacement_statuses` WRITE;
/*!40000 ALTER TABLE `permanent_replacement_statuses` DISABLE KEYS */;
INSERT INTO `permanent_replacement_statuses` VALUES ('AWAITING_ACCEPTANCE','Awaiting Acceptance',30,0,1),('CANCELLED','Cancelled',90,1,1),('COMPLETED','Completed',40,1,1),('REPLACEMENT_SELECTED','Replacement Selected',20,0,1),('SELECTION_REQUIRED','Selection Required',10,0,1);
/*!40000 ALTER TABLE `permanent_replacement_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `module` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_permissions_name` (`name`),
  KEY `idx_permissions_module` (`module`)
) ENGINE=InnoDB AUTO_INCREMENT=197 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (1,'dashboard.view','View Dashboard','dashboard','2026-10-06 14:58:07','2026-10-06 14:58:07'),(2,'users.view','View Users','users','2026-10-06 14:58:07','2026-10-06 14:58:07'),(3,'users.create','Create Users','users','2026-10-06 14:58:07','2026-10-06 14:58:07'),(4,'users.update','Update Users','users','2026-10-06 14:58:07','2026-10-06 14:58:07'),(5,'users.disable','Disable Users','users','2026-10-06 14:58:07','2026-10-06 14:58:07'),(6,'roles.view','View Roles','roles','2026-10-06 14:58:07','2026-10-06 14:58:07'),(7,'roles.manage','Manage Roles','roles','2026-10-06 14:58:07','2026-10-06 14:58:07'),(8,'permissions.view','View Permissions','permissions','2026-10-06 14:58:07','2026-10-06 14:58:07'),(9,'audit.view','View Audit Logs','audit','2026-10-06 14:58:07','2026-10-06 14:58:07'),(10,'admin.access','Access Administration','admin','2026-10-06 14:58:07','2026-10-06 14:58:07'),(11,'devices.view','View Devices','devices','2026-10-06 14:58:07','2026-10-06 14:58:07'),(12,'devices.manage','Manage Devices','devices','2026-10-06 14:58:07','2026-10-06 14:58:07'),(13,'tickets.view','View Tickets','tickets','2026-10-06 14:58:07','2026-10-06 14:58:07'),(14,'tickets.create','Create Tickets','tickets','2026-10-06 14:58:07','2026-10-06 14:58:07'),(15,'tickets.manage','Manage Tickets','tickets','2026-10-06 14:58:07','2026-10-06 14:58:07'),(16,'collections.view','View Collections','collections','2026-10-06 14:58:07','2026-10-06 14:58:07'),(17,'collections.manage','Manage Collections','collections','2026-10-06 14:58:07','2026-10-06 14:58:07'),(18,'repairs.view','View Repairs','repairs','2026-10-06 14:58:07','2026-10-06 14:58:07'),(19,'repairs.manage','Manage Repairs','repairs','2026-10-06 14:58:07','2026-10-06 14:58:07'),(20,'returns.view','View Returns','returns','2026-10-06 14:58:07','2026-10-06 14:58:07'),(21,'returns.manage','Manage Returns','returns','2026-10-06 14:58:07','2026-10-06 14:58:07'),(22,'inventory.view','View Inventory','inventory','2026-10-06 14:58:07','2026-10-06 14:58:07'),(23,'inventory.manage','Manage Inventory','inventory','2026-10-06 14:58:07','2026-10-06 14:58:07'),(24,'reports.view','View Reports','reports','2026-10-06 14:58:07','2026-10-06 14:58:07'),(25,'reports.export','Export Reports','reports','2026-10-06 14:58:07','2026-10-06 14:58:07'),(26,'districts.view','View Districts','districts','2026-10-06 19:50:41','2026-10-06 19:50:41'),(27,'districts.manage','Manage Districts','districts','2026-10-06 19:50:41','2026-10-06 19:50:41'),(28,'schools.view','View Schools','schools','2026-10-06 19:50:41','2026-10-06 19:50:41'),(29,'schools.manage','Manage Schools','schools','2026-10-06 19:50:41','2026-10-06 19:50:41'),(30,'user_scopes.view','View User Scopes','user_scopes','2026-10-06 19:50:41','2026-10-06 19:50:41'),(31,'user_scopes.manage','Manage User Scopes','user_scopes','2026-10-06 19:50:41','2026-10-06 19:50:41'),(32,'students.view','View Students','students','2026-10-07 16:05:03','2026-10-07 16:05:03'),(33,'students.manage','Manage Students','students','2026-10-07 16:05:03','2026-10-07 16:05:03'),(34,'device_imports.view','View Device Imports','device_imports','2026-10-07 16:05:03','2026-10-07 16:05:03'),(35,'device_imports.manage','Manage Device Imports','device_imports','2026-10-07 16:05:03','2026-10-07 16:05:03'),(36,'device_district_allocations.view','View District Device Allocations','device_district_allocations','2026-10-08 18:59:56','2026-10-08 18:59:56'),(37,'device_district_allocations.manage','Allocate Devices to Districts','device_district_allocations','2026-10-08 18:59:56','2026-10-08 18:59:56'),(38,'device_school_allocations.view','View School Device Allocations','device_school_allocations','2026-10-09 03:36:02','2026-10-09 03:36:02'),(39,'device_school_allocations.manage','Allocate Devices to Schools','device_school_allocations','2026-10-09 03:36:02','2026-10-09 03:36:02'),(40,'device_student_assignments.view','View Student Device Assignments','device_student_assignments','2026-10-10 17:48:12','2026-10-10 17:48:12'),(41,'device_student_assignments.manage','Assign Devices to Students','device_student_assignments','2026-10-10 17:48:12','2026-10-10 17:48:12'),(44,'device_student_returns.manage','Return Student Device Assignments','device_student_returns','2026-10-10 18:30:14','2026-10-10 18:30:14'),(45,'device_school_returns.manage','Return School Device Allocations','device_school_returns','2026-10-10 18:30:14','2026-10-10 18:30:14'),(46,'device_district_returns.manage','Return District Device Allocations','device_district_returns','2026-10-10 18:30:14','2026-10-10 18:30:14'),(65,'tickets.diagnose','Record Ticket Diagnosis','tickets','2026-10-11 11:04:59','2026-10-11 11:04:59'),(66,'tickets.clarification_request','Request Ticket Clarification','tickets','2026-10-11 11:04:59','2026-10-11 11:04:59'),(67,'tickets.clarification_respond','Respond to Ticket Clarification','tickets','2026-10-11 11:04:59','2026-10-11 11:04:59'),(68,'tickets.approve_pickup','Approve Ticket for Pickup','tickets','2026-10-11 11:04:59','2026-10-11 11:04:59'),(69,'tickets.assign','Manage Ticket Assignments','tickets','2026-10-11 20:08:57','2026-10-11 20:08:57'),(70,'tickets.claim','Claim Unassigned Tickets','tickets','2026-10-11 20:08:57','2026-10-11 20:08:57'),(71,'tickets.dashboard','View Ticket Dashboard','tickets','2026-10-12 05:54:28','2026-10-12 05:54:28'),(72,'tickets.report','View Operational Ticket Reports','tickets','2026-10-12 05:54:28','2026-10-12 05:54:28'),(73,'logistics.view','View Logistics','logistics','2026-10-12 09:53:29','2026-10-12 09:53:29'),(74,'logistics.request_pickup','Request Device Pickup','logistics','2026-10-12 09:53:29','2026-10-12 09:53:29'),(75,'logistics.accept','Accept Pickup Requests','logistics','2026-10-12 09:53:29','2026-10-12 09:53:29'),(79,'logistics.dispatch','Release Devices to TTPost','logistics','2026-10-12 11:36:03','2026-10-12 11:36:03'),(80,'logistics.receive','Confirm TTPost Device Receipt','logistics','2026-10-12 11:36:03','2026-10-12 11:36:03'),(81,'logistics.locations_manage','Manage Logistics Locations','logistics','2026-10-12 11:36:03','2026-10-12 11:36:03'),(85,'logistics.forward_to_repair','Dispatch Devices to Repair Centre','logistics','2026-10-12 12:38:52','2026-10-12 12:38:52'),(86,'logistics.repair_receive','Confirm Repair Centre Receipt','logistics','2026-10-12 12:38:52','2026-10-12 12:38:52'),(89,'repairs.start','Start Repair Processing','repairs','2026-10-12 13:29:06','2026-10-12 13:29:06'),(90,'repairs.assess','Record Repair Assessment','repairs','2026-10-12 13:29:06','2026-10-12 13:29:06'),(91,'repairs.record_work','Record Repair Work','repairs','2026-10-12 13:29:06','2026-10-12 13:29:06'),(92,'repairs.complete','Complete Repair Processing','repairs','2026-10-12 13:29:06','2026-10-12 13:29:06'),(99,'logistics.return_dispatch','Dispatch Return Device to TTPost','logistics','2026-10-12 16:06:52','2026-10-12 16:06:52'),(100,'logistics.return_ttpost_receive','Confirm TTPost Return Receipt','logistics','2026-10-12 16:06:52','2026-10-12 16:06:52'),(101,'logistics.return_school_dispatch','Dispatch Returned Device to School','logistics','2026-10-12 16:06:52','2026-10-12 16:06:52'),(102,'logistics.return_school_receive','Confirm School Return Receipt','logistics','2026-10-12 16:06:52','2026-10-12 16:06:52'),(107,'exceptions.view','View Exception Cases','exceptions','2026-10-12 19:18:50','2026-10-12 19:18:50'),(108,'exceptions.assess','Record Exception Assessment','exceptions','2026-10-12 19:18:50','2026-10-12 19:18:50'),(109,'exceptions.submit','Submit Exception Review','exceptions','2026-10-12 19:18:50','2026-10-12 19:18:50'),(110,'exceptions.district_decide','Decide District Exception Disposition','exceptions','2026-10-12 19:18:50','2026-10-12 19:18:50'),(111,'exceptions.head_office_approve','Approve Permanent Replacement','exceptions','2026-10-12 19:18:50','2026-10-12 19:18:50'),(122,'manufacturer_returns.view','View Manufacturer Returns','manufacturer_returns','2026-10-13 09:36:05','2026-10-13 09:36:05'),(123,'manufacturer_returns.start','Start Manufacturer Return','manufacturer_returns','2026-10-13 09:36:05','2026-10-13 09:36:05'),(124,'manufacturer_returns.prepare_outbound','Prepare Manufacturer Outbound Shipment','manufacturer_returns','2026-10-13 09:36:05','2026-10-13 09:36:05'),(125,'manufacturer_returns.external_outbound_pickup','Record External Outbound Pickup','manufacturer_returns','2026-10-13 09:36:05','2026-10-13 09:36:05'),(126,'manufacturer_returns.ttpost_outbound_pickup','Confirm TTPost Outbound Pickup','manufacturer_returns','2026-10-13 09:36:05','2026-10-13 09:36:05'),(127,'manufacturer_returns.manufacturer_acknowledge','Record Manufacturer Acknowledgement','manufacturer_returns','2026-10-13 09:36:05','2026-10-13 09:36:05'),(128,'manufacturer_returns.record_outcome','Record Manufacturer Outcome','manufacturer_returns','2026-10-13 09:36:05','2026-10-13 09:36:05'),(129,'manufacturer_returns.prepare_return','Prepare Manufacturer Return Shipment','manufacturer_returns','2026-10-13 09:36:05','2026-10-13 09:36:05'),(130,'manufacturer_returns.external_return_pickup','Record External Return Pickup','manufacturer_returns','2026-10-13 09:36:05','2026-10-13 09:36:05'),(131,'manufacturer_returns.ttpost_return_pickup','Confirm TTPost Return Pickup','manufacturer_returns','2026-10-13 09:36:05','2026-10-13 09:36:05'),(132,'manufacturer_returns.repair_receive','Receive Manufacturer Return at Repair Centre','manufacturer_returns','2026-10-13 09:36:05','2026-10-13 09:36:05'),(133,'carriers.view','View Carriers','carriers','2026-10-13 09:36:05','2026-10-13 09:36:05'),(134,'carriers.manage','Manage Carriers','carriers','2026-10-13 09:36:05','2026-10-13 09:36:05'),(148,'replacements.view','View Permanent Replacements','replacements','2026-10-13 16:37:13','2026-10-13 16:37:13'),(149,'replacements.start','Start Permanent Replacement','replacements','2026-10-13 16:37:13','2026-10-13 16:37:13'),(150,'replacements.select','Select Permanent Replacement Source','replacements','2026-10-13 16:37:13','2026-10-13 16:37:13'),(151,'replacements.accept','Accept Permanent Replacement','replacements','2026-10-13 16:37:13','2026-10-13 16:37:13'),(160,'device_stock.view','View Repair Centre Stock','device_stock','2026-10-13 18:03:22','2026-10-13 18:03:22'),(161,'device_stock.intake','Record Repair Centre Stock Intake','device_stock','2026-10-13 18:03:22','2026-10-13 18:03:22'),(162,'device_stock.release','Release Repair Centre Stock','device_stock','2026-10-13 18:03:22','2026-10-13 18:03:22'),(163,'temporary_loans.view','View Temporary Loans','temporary_loans','2026-10-15 09:26:27','2026-10-15 09:26:27'),(164,'temporary_loans.request','Request Temporary Spare','temporary_loans','2026-10-15 09:26:27','2026-10-15 09:26:27'),(165,'temporary_loans.authorize','Authorize Temporary Spare','temporary_loans','2026-10-15 09:26:27','2026-10-15 09:26:27'),(166,'temporary_loans.cancel','Cancel Pending Temporary Spare','temporary_loans','2026-10-15 09:26:27','2026-10-15 09:26:27'),(171,'temporary_loans.select_spare','Select Temporary Loan Spare','temporary_loans','2026-10-15 10:09:52','2026-10-15 10:09:52'),(172,'temporary_loans.issue','Issue Temporary Loan Spare','temporary_loans','2026-10-15 10:09:52','2026-10-15 10:09:52'),(179,'temporary_loans.request_return','Request Temporary Spare Return','temporary_loans','2026-10-15 11:07:46','2026-10-15 11:07:46'),(180,'temporary_loans.reclaim','Reclaim Temporary Spare','temporary_loans','2026-10-15 11:07:46','2026-10-15 11:07:46'),(185,'temporary_loans.request_conversion','Request Permanent Conversion','temporary_loans','2026-10-15 11:49:14','2026-10-15 11:49:14'),(186,'temporary_loans.approve_conversion','Approve Temporary Loan Conversion','temporary_loans','2026-10-15 11:49:14','2026-10-15 11:49:14'),(187,'sla.view','View SLA Configuration','sla','2026-10-15 14:18:19','2026-10-15 14:18:19'),(188,'sla.manage','Manage SLA Configuration','sla','2026-10-15 14:18:19','2026-10-15 14:18:19'),(189,'escalations.view','View Escalations','escalations','2026-10-15 20:15:39','2026-10-15 20:15:39'),(190,'escalations.respond','Acknowledge Escalations','escalations','2026-10-15 20:15:39','2026-10-15 20:15:39'),(191,'escalations.manage','Manage Escalation Rules','escalations','2026-10-15 20:15:39','2026-10-15 20:15:39'),(192,'notifications.view','View Own Notifications','notifications','2026-10-16 09:54:32','2026-10-16 09:54:32'),(193,'notifications.respond','Manage Own Notification Read State','notifications','2026-10-16 09:54:32','2026-10-16 09:54:32'),(194,'notifications.manage','Manage Notifications','notifications','2026-10-16 09:54:32','2026-10-16 09:54:32'),(195,'spare_pools.view','View Repair Centre Spare Pools','spare_pools','2026-10-20 14:35:57','2026-10-20 14:35:57'),(196,'spare_pools.manage','Manage Repair Centre Spare Pools','spare_pools','2026-10-20 14:35:57','2026-10-20 14:35:57');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `repair_assessments`
--

DROP TABLE IF EXISTS `repair_assessments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `repair_assessments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `repair_job_id` int(10) unsigned NOT NULL,
  `assessment_summary` varchar(2000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `suspected_cause` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `recommended_action` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by_user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_repair_assessments_job_created` (`repair_job_id`,`created_at`,`id`),
  KEY `fk_repair_assessments_actor` (`created_by_user_id`),
  CONSTRAINT `fk_repair_assessments_actor` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_repair_assessments_job` FOREIGN KEY (`repair_job_id`) REFERENCES `repair_jobs` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repair_assessments`
--

LOCK TABLES `repair_assessments` WRITE;
/*!40000 ALTER TABLE `repair_assessments` DISABLE KEYS */;
INSERT INTO `repair_assessments` VALUES (1,1,'Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus','Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus','Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus','2026-10-20 21:04:06.130867',1),(2,2,'Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus','Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus','Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus','2026-10-20 21:33:34.350390',1);
/*!40000 ALTER TABLE `repair_assessments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `repair_exception_cases`
--

DROP TABLE IF EXISTS `repair_exception_cases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `repair_exception_cases` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(10) unsigned NOT NULL,
  `logistics_case_id` int(10) unsigned NOT NULL,
  `repair_job_id` int(10) unsigned NOT NULL,
  `device_id` int(10) unsigned NOT NULL,
  `originating_repair_outcome_id` int(10) unsigned NOT NULL,
  `current_status_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `recommended_disposition_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by_user_id` int(10) unsigned NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_repair_exception_cases_job` (`repair_job_id`),
  KEY `idx_repair_exception_cases_status` (`current_status_code`,`updated_at`),
  KEY `idx_repair_exception_cases_ticket` (`ticket_id`),
  KEY `idx_repair_exception_cases_district` (`ticket_id`,`current_status_code`),
  KEY `fk_exception_case_logistics` (`logistics_case_id`),
  KEY `fk_exception_case_device` (`device_id`),
  KEY `fk_exception_case_outcome` (`originating_repair_outcome_id`),
  KEY `fk_exception_case_disposition` (`recommended_disposition_code`),
  KEY `fk_exception_case_creator` (`created_by_user_id`),
  CONSTRAINT `fk_exception_case_creator` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_exception_case_device` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_exception_case_disposition` FOREIGN KEY (`recommended_disposition_code`) REFERENCES `exception_dispositions` (`code`),
  CONSTRAINT `fk_exception_case_job` FOREIGN KEY (`repair_job_id`) REFERENCES `repair_jobs` (`id`),
  CONSTRAINT `fk_exception_case_logistics` FOREIGN KEY (`logistics_case_id`) REFERENCES `ticket_logistics_cases` (`id`),
  CONSTRAINT `fk_exception_case_outcome` FOREIGN KEY (`originating_repair_outcome_id`) REFERENCES `repair_outcomes` (`id`),
  CONSTRAINT `fk_exception_case_status` FOREIGN KEY (`current_status_code`) REFERENCES `exception_case_statuses` (`code`),
  CONSTRAINT `fk_exception_case_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repair_exception_cases`
--

LOCK TABLES `repair_exception_cases` WRITE;
/*!40000 ALTER TABLE `repair_exception_cases` DISABLE KEYS */;
INSERT INTO `repair_exception_cases` VALUES (1,2,2,2,1,3,'PERMANENT_REPLACEMENT_COMPLETED','PERMANENT_REPLACEMENT',1,'2026-10-20 21:33:45.749239','2026-10-20 21:35:23.914266');
/*!40000 ALTER TABLE `repair_exception_cases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `repair_jobs`
--

DROP TABLE IF EXISTS `repair_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `repair_jobs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `logistics_case_id` int(10) unsigned NOT NULL,
  `repair_centre_location_id` int(10) unsigned NOT NULL,
  `started_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `started_by_user_id` int(10) unsigned NOT NULL,
  `completed_at` datetime(6) DEFAULT NULL,
  `completed_by_user_id` int(10) unsigned DEFAULT NULL,
  `outcome_id` int(10) unsigned DEFAULT NULL,
  `completion_summary` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_repair_jobs_logistics_case` (`logistics_case_id`),
  KEY `idx_repair_jobs_location_started` (`repair_centre_location_id`,`started_at`),
  KEY `idx_repair_jobs_outcome` (`outcome_id`),
  KEY `fk_repair_jobs_started_by` (`started_by_user_id`),
  KEY `fk_repair_jobs_completed_by` (`completed_by_user_id`),
  CONSTRAINT `fk_repair_jobs_completed_by` FOREIGN KEY (`completed_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_repair_jobs_location` FOREIGN KEY (`repair_centre_location_id`) REFERENCES `service_locations` (`id`),
  CONSTRAINT `fk_repair_jobs_logistics_case` FOREIGN KEY (`logistics_case_id`) REFERENCES `ticket_logistics_cases` (`id`),
  CONSTRAINT `fk_repair_jobs_outcome` FOREIGN KEY (`outcome_id`) REFERENCES `repair_outcomes` (`id`),
  CONSTRAINT `fk_repair_jobs_started_by` FOREIGN KEY (`started_by_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repair_jobs`
--

LOCK TABLES `repair_jobs` WRITE;
/*!40000 ALTER TABLE `repair_jobs` DISABLE KEYS */;
INSERT INTO `repair_jobs` VALUES (1,1,2,'2026-10-20 21:03:46.522445',1,'2026-10-20 21:28:19.000000',1,1,'Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus','2026-10-20 21:03:46.522445','2026-10-20 21:28:19.638595'),(2,2,2,'2026-10-20 21:32:43.538848',1,'2026-10-20 21:33:45.000000',1,3,'Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus','2026-10-20 21:32:43.538848','2026-10-20 21:33:45.747606');
/*!40000 ALTER TABLE `repair_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `repair_outcomes`
--

DROP TABLE IF EXISTS `repair_outcomes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `repair_outcomes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_return_ready` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int(10) unsigned NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_repair_outcomes_code` (`code`),
  KEY `idx_repair_outcomes_active_sort` (`is_active`,`sort_order`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repair_outcomes`
--

LOCK TABLES `repair_outcomes` WRITE;
/*!40000 ALTER TABLE `repair_outcomes` DISABLE KEYS */;
INSERT INTO `repair_outcomes` VALUES (1,'REPAIRED_SUCCESSFULLY','Repaired Successfully','Repair completed and ready for return logistics.',1,1,10,'2026-10-12 13:28:24'),(2,'NO_FAULT_FOUND','No Fault Found','No fault was reproduced; device is ready for return logistics.',1,1,20,'2026-10-12 13:28:24'),(3,'UNABLE_TO_REPAIR','Unable to Repair','Repair Centre could not complete the repair; downstream disposition is required.',0,1,30,'2026-10-12 13:28:24'),(4,'MANUFACTURER_RETURN_REQUIRED','Manufacturer Return Required','Manufacturer disposition is required; workflow is deferred.',0,1,40,'2026-10-12 13:28:24'),(5,'REPLACEMENT_REQUIRED','Replacement Required','Replacement disposition is required; workflow is deferred.',0,1,50,'2026-10-12 13:28:24');
/*!40000 ALTER TABLE `repair_outcomes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `repair_work_logs`
--

DROP TABLE IF EXISTS `repair_work_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `repair_work_logs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `repair_job_id` int(10) unsigned NOT NULL,
  `action_summary` varchar(2000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `result_summary` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by_user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_repair_work_logs_job_created` (`repair_job_id`,`created_at`,`id`),
  KEY `fk_repair_work_logs_actor` (`created_by_user_id`),
  CONSTRAINT `fk_repair_work_logs_actor` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_repair_work_logs_job` FOREIGN KEY (`repair_job_id`) REFERENCES `repair_jobs` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repair_work_logs`
--

LOCK TABLES `repair_work_logs` WRITE;
/*!40000 ALTER TABLE `repair_work_logs` DISABLE KEYS */;
INSERT INTO `repair_work_logs` VALUES (1,1,'Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus','Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus','2026-10-20 21:04:27.214115',1);
/*!40000 ALTER TABLE `repair_work_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_administration_profiles`
--

DROP TABLE IF EXISTS `role_administration_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role_administration_profiles` (
  `role_id` int(10) unsigned NOT NULL,
  `scope_type` varchar(30) NOT NULL,
  `assignable` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`role_id`),
  CONSTRAINT `role_administration_profiles_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_administration_profiles`
--

LOCK TABLES `role_administration_profiles` WRITE;
/*!40000 ALTER TABLE `role_administration_profiles` DISABLE KEYS */;
INSERT INTO `role_administration_profiles` VALUES (1,'GLOBAL',1),(2,'NATIONAL',1),(3,'DISTRICT',1),(4,'SCHOOL',1),(5,'SCHOOL',1),(6,'REPAIR_LOCATION',1),(7,'LOGISTICS_NATIONAL',1),(8,'NATIONAL',1);
/*!40000 ALTER TABLE `role_administration_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_permissions`
--

DROP TABLE IF EXISTS `role_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role_permissions` (
  `role_id` int(10) unsigned NOT NULL,
  `permission_id` int(10) unsigned NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `idx_role_permissions_permission_id` (`permission_id`),
  CONSTRAINT `fk_role_permissions_permission` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_role_permissions_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_permissions`
--

LOCK TABLES `role_permissions` WRITE;
/*!40000 ALTER TABLE `role_permissions` DISABLE KEYS */;
INSERT INTO `role_permissions` VALUES (1,1,'2026-10-06 14:58:07'),(1,2,'2026-10-06 14:58:07'),(1,3,'2026-10-06 14:58:07'),(1,4,'2026-10-06 14:58:07'),(1,5,'2026-10-06 14:58:07'),(1,6,'2026-10-06 14:58:07'),(1,7,'2026-10-06 14:58:07'),(1,8,'2026-10-06 14:58:07'),(1,9,'2026-10-06 14:58:07'),(1,10,'2026-10-06 14:58:07'),(1,11,'2026-10-06 14:58:07'),(1,12,'2026-10-06 14:58:07'),(1,13,'2026-10-06 14:58:07'),(1,14,'2026-10-06 14:58:07'),(1,15,'2026-10-06 14:58:07'),(1,16,'2026-10-06 14:58:07'),(1,17,'2026-10-06 14:58:07'),(1,18,'2026-10-06 14:58:07'),(1,19,'2026-10-06 14:58:07'),(1,20,'2026-10-06 14:58:07'),(1,21,'2026-10-06 14:58:07'),(1,22,'2026-10-06 14:58:07'),(1,23,'2026-10-06 14:58:07'),(1,24,'2026-10-06 14:58:07'),(1,25,'2026-10-06 14:58:07'),(1,26,'2026-10-06 19:50:41'),(1,27,'2026-10-06 19:50:41'),(1,28,'2026-10-06 19:50:41'),(1,29,'2026-10-06 19:50:41'),(1,30,'2026-10-06 19:50:41'),(1,31,'2026-10-06 19:50:41'),(1,36,'2026-10-08 18:59:56'),(1,37,'2026-10-08 18:59:56'),(1,38,'2026-10-09 03:36:02'),(1,39,'2026-10-09 03:36:02'),(1,40,'2026-10-10 17:48:12'),(1,41,'2026-10-10 17:48:12'),(1,44,'2026-10-10 18:30:14'),(1,45,'2026-10-10 18:30:14'),(1,46,'2026-10-10 18:30:14'),(1,65,'2026-10-11 11:04:59'),(1,66,'2026-10-11 11:04:59'),(1,67,'2026-10-11 11:04:59'),(1,68,'2026-10-11 11:04:59'),(1,69,'2026-10-11 20:08:57'),(1,71,'2026-10-12 05:54:28'),(1,72,'2026-10-12 05:54:28'),(1,73,'2026-10-12 09:53:29'),(1,74,'2026-10-12 09:53:29'),(1,75,'2026-10-12 09:53:29'),(1,79,'2026-10-12 11:36:03'),(1,80,'2026-10-12 11:36:03'),(1,81,'2026-10-12 11:36:03'),(1,85,'2026-10-12 12:38:52'),(1,86,'2026-10-12 12:38:52'),(1,89,'2026-10-12 13:29:06'),(1,90,'2026-10-12 13:29:06'),(1,91,'2026-10-12 13:29:06'),(1,92,'2026-10-12 13:29:06'),(1,99,'2026-10-12 16:06:52'),(1,100,'2026-10-12 16:06:52'),(1,101,'2026-10-12 16:06:52'),(1,102,'2026-10-12 16:06:52'),(1,107,'2026-10-12 19:18:50'),(1,108,'2026-10-12 19:18:50'),(1,109,'2026-10-12 19:18:50'),(1,110,'2026-10-12 19:18:50'),(1,111,'2026-10-12 19:18:50'),(1,122,'2026-10-13 09:36:05'),(1,123,'2026-10-13 09:36:05'),(1,124,'2026-10-13 09:36:05'),(1,125,'2026-10-13 09:36:05'),(1,126,'2026-10-13 09:36:05'),(1,127,'2026-10-13 09:36:05'),(1,128,'2026-10-13 09:36:05'),(1,129,'2026-10-13 09:36:05'),(1,130,'2026-10-13 09:36:05'),(1,131,'2026-10-13 09:36:05'),(1,132,'2026-10-13 09:36:05'),(1,133,'2026-10-13 09:36:05'),(1,134,'2026-10-13 09:36:05'),(1,148,'2026-10-13 16:37:13'),(1,149,'2026-10-13 16:37:13'),(1,150,'2026-10-13 16:37:13'),(1,151,'2026-10-13 16:37:13'),(1,160,'2026-10-13 18:03:22'),(1,161,'2026-10-13 18:03:22'),(1,162,'2026-10-13 18:03:22'),(1,163,'2026-10-15 09:26:27'),(1,164,'2026-10-15 09:26:27'),(1,165,'2026-10-15 09:26:27'),(1,166,'2026-10-15 09:26:27'),(1,171,'2026-10-15 10:09:52'),(1,172,'2026-10-15 10:09:52'),(1,179,'2026-10-15 11:07:46'),(1,180,'2026-10-15 11:07:46'),(1,185,'2026-10-15 11:49:14'),(1,186,'2026-10-15 11:49:14'),(1,187,'2026-10-15 14:18:19'),(1,188,'2026-10-15 14:18:19'),(1,189,'2026-10-15 20:15:39'),(1,190,'2026-10-15 20:15:39'),(1,191,'2026-10-15 20:15:39'),(1,192,'2026-10-16 09:54:32'),(1,193,'2026-10-16 09:54:32'),(1,194,'2026-10-16 09:54:32'),(1,195,'2026-10-20 14:35:57'),(1,196,'2026-10-20 14:35:57'),(2,11,'2026-10-07 16:05:03'),(2,12,'2026-10-07 16:05:03'),(2,13,'2026-10-11 08:59:06'),(2,14,'2026-10-11 08:59:06'),(2,32,'2026-10-07 16:05:03'),(2,33,'2026-10-07 16:05:03'),(2,34,'2026-10-07 16:05:03'),(2,35,'2026-10-07 16:05:03'),(2,36,'2026-10-08 18:59:56'),(2,37,'2026-10-08 18:59:56'),(2,38,'2026-10-09 03:36:02'),(2,39,'2026-10-09 03:36:02'),(2,40,'2026-10-10 17:48:12'),(2,41,'2026-10-10 17:48:12'),(2,44,'2026-10-10 18:30:14'),(2,45,'2026-10-10 18:30:14'),(2,46,'2026-10-10 18:30:14'),(2,71,'2026-10-12 05:54:28'),(2,72,'2026-10-12 05:54:28'),(2,73,'2026-10-12 09:53:29'),(2,107,'2026-10-12 19:18:50'),(2,111,'2026-10-12 19:18:50'),(2,122,'2026-10-13 09:36:05'),(2,133,'2026-10-13 09:36:05'),(2,148,'2026-10-13 16:37:13'),(2,160,'2026-10-13 18:03:22'),(2,163,'2026-10-15 09:26:27'),(2,186,'2026-10-15 11:49:14'),(2,187,'2026-10-15 14:18:19'),(2,188,'2026-10-15 14:18:19'),(2,189,'2026-10-15 20:15:39'),(2,190,'2026-10-15 20:15:39'),(2,191,'2026-10-15 20:15:39'),(2,192,'2026-10-16 09:54:32'),(2,193,'2026-10-16 09:54:32'),(2,194,'2026-10-16 09:54:32'),(3,1,'2026-10-07 17:41:35'),(3,11,'2026-10-07 16:05:03'),(3,13,'2026-10-11 08:59:06'),(3,14,'2026-10-11 08:59:06'),(3,32,'2026-10-07 16:05:03'),(3,36,'2026-10-08 18:59:56'),(3,38,'2026-10-09 03:36:02'),(3,39,'2026-10-09 03:36:02'),(3,40,'2026-10-10 17:48:12'),(3,45,'2026-10-10 18:30:14'),(3,66,'2026-10-11 11:04:59'),(3,68,'2026-10-11 11:04:59'),(3,69,'2026-10-11 20:08:57'),(3,71,'2026-10-12 05:54:28'),(3,72,'2026-10-12 05:54:28'),(3,73,'2026-10-12 09:53:29'),(3,74,'2026-10-12 09:53:29'),(3,107,'2026-10-12 19:18:50'),(3,110,'2026-10-12 19:18:50'),(3,122,'2026-10-13 09:36:05'),(3,133,'2026-10-13 09:36:05'),(3,148,'2026-10-13 16:37:13'),(3,163,'2026-10-15 09:26:27'),(3,165,'2026-10-15 09:26:27'),(3,187,'2026-10-15 14:18:19'),(3,189,'2026-10-15 20:15:39'),(3,192,'2026-10-16 09:54:32'),(3,193,'2026-10-16 09:54:32'),(4,11,'2026-10-07 16:05:03'),(4,13,'2026-10-11 08:59:06'),(4,14,'2026-10-11 08:59:06'),(4,32,'2026-10-07 16:05:03'),(4,65,'2026-10-11 11:04:59'),(4,66,'2026-10-11 11:04:59'),(4,67,'2026-10-11 11:04:59'),(4,70,'2026-10-11 20:08:57'),(4,73,'2026-10-12 09:53:29'),(4,79,'2026-10-12 11:36:04'),(4,102,'2026-10-12 16:06:52'),(4,189,'2026-10-15 20:15:39'),(4,192,'2026-10-16 09:54:32'),(4,193,'2026-10-16 09:54:32'),(5,1,'2026-10-06 14:58:07'),(5,11,'2026-10-06 14:58:07'),(5,13,'2026-10-06 14:58:07'),(5,14,'2026-10-06 14:58:07'),(5,32,'2026-10-07 16:05:03'),(5,33,'2026-10-07 16:05:03'),(5,38,'2026-10-09 03:36:02'),(5,40,'2026-10-10 17:48:12'),(5,41,'2026-10-10 17:48:12'),(5,44,'2026-10-10 18:30:14'),(5,65,'2026-10-11 11:04:59'),(5,66,'2026-10-11 11:04:59'),(5,67,'2026-10-11 11:04:59'),(5,69,'2026-10-11 20:08:57'),(5,71,'2026-10-12 05:54:28'),(5,72,'2026-10-12 05:54:28'),(5,73,'2026-10-12 09:53:29'),(5,74,'2026-10-12 09:53:29'),(5,79,'2026-10-12 11:36:04'),(5,102,'2026-10-12 16:06:52'),(5,189,'2026-10-15 20:15:39'),(5,192,'2026-10-16 09:54:32'),(5,193,'2026-10-16 09:54:32'),(6,11,'2026-10-07 16:05:03'),(6,13,'2026-10-13 17:14:25'),(6,18,'2026-10-12 13:29:06'),(6,73,'2026-10-12 12:38:52'),(6,86,'2026-10-12 12:38:52'),(6,89,'2026-10-12 13:29:06'),(6,90,'2026-10-12 13:29:06'),(6,91,'2026-10-12 13:29:06'),(6,92,'2026-10-12 13:29:06'),(6,99,'2026-10-12 16:06:52'),(6,107,'2026-10-12 19:18:50'),(6,108,'2026-10-12 19:18:50'),(6,109,'2026-10-12 19:18:50'),(6,122,'2026-10-13 09:36:05'),(6,123,'2026-10-13 09:36:05'),(6,124,'2026-10-13 09:36:05'),(6,125,'2026-10-13 09:36:05'),(6,127,'2026-10-13 09:36:05'),(6,128,'2026-10-13 09:36:05'),(6,129,'2026-10-13 09:36:05'),(6,130,'2026-10-13 09:36:05'),(6,132,'2026-10-13 09:36:05'),(6,133,'2026-10-13 09:36:05'),(6,148,'2026-10-13 16:37:13'),(6,149,'2026-10-13 16:37:13'),(6,150,'2026-10-13 16:37:13'),(6,151,'2026-10-13 16:37:13'),(6,160,'2026-10-13 18:03:22'),(6,161,'2026-10-13 18:03:22'),(6,162,'2026-10-13 18:03:22'),(6,163,'2026-10-15 09:26:27'),(6,164,'2026-10-15 09:26:27'),(6,171,'2026-10-15 10:09:52'),(6,172,'2026-10-15 10:09:52'),(6,179,'2026-10-15 11:07:46'),(6,180,'2026-10-15 11:07:46'),(6,185,'2026-10-15 11:49:14'),(6,187,'2026-10-15 14:18:19'),(6,189,'2026-10-15 20:15:39'),(6,190,'2026-10-15 20:15:39'),(6,192,'2026-10-16 09:54:32'),(6,193,'2026-10-16 09:54:32'),(7,11,'2026-10-07 16:05:03'),(7,73,'2026-10-12 09:53:29'),(7,75,'2026-10-12 09:53:29'),(7,80,'2026-10-12 11:36:04'),(7,85,'2026-10-12 12:38:52'),(7,100,'2026-10-12 16:06:52'),(7,101,'2026-10-12 16:06:52'),(7,122,'2026-10-13 09:36:05'),(7,126,'2026-10-13 09:36:05'),(7,131,'2026-10-13 09:36:05'),(7,189,'2026-10-15 20:15:39'),(7,190,'2026-10-15 20:15:39'),(7,192,'2026-10-16 09:54:32'),(7,193,'2026-10-16 09:54:32'),(8,11,'2026-10-07 16:05:03'),(8,13,'2026-10-11 08:59:06'),(8,34,'2026-10-07 16:05:03'),(8,36,'2026-10-08 18:59:56'),(8,38,'2026-10-09 03:36:02'),(8,40,'2026-10-10 17:48:12'),(8,71,'2026-10-12 05:54:28'),(8,72,'2026-10-12 05:54:28'),(8,73,'2026-10-12 09:53:29'),(8,107,'2026-10-12 19:18:50'),(8,122,'2026-10-13 09:36:05'),(8,133,'2026-10-13 09:36:05'),(8,148,'2026-10-13 16:37:13'),(8,160,'2026-10-13 18:03:22'),(8,163,'2026-10-15 09:26:27'),(8,187,'2026-10-15 14:18:19'),(8,189,'2026-10-15 20:15:39'),(8,192,'2026-10-16 09:54:32'),(8,193,'2026-10-16 09:54:32');
/*!40000 ALTER TABLE `role_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_roles_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'SUPER_ADMIN','Super Administrator','Full system access across all Phase 2 permissions.','2026-10-06 14:58:07','2026-10-06 14:58:07'),(2,'MOE_HEAD_OFFICE','MOE Head Office','Ministry head office oversight.','2026-10-06 14:58:07','2026-10-06 14:58:07'),(3,'ICT_DISTRICT_COORDINATOR','ICT District Coordinator','District-level ICT coordination.','2026-10-06 14:58:07','2026-10-06 14:58:07'),(4,'ICT_TECHNICAL_OFFICER','ICT Technical Officer','ICT technical support and diagnosis.','2026-10-06 14:58:07','2026-10-06 14:58:07'),(5,'SCHOOL_ADMINISTRATOR','School Administrator','School requester and administration role.','2026-10-06 14:58:07','2026-10-06 14:58:07'),(6,'REPAIR_CENTRE','Repair Centre','Authorized repair centre operations.','2026-10-06 14:58:07','2026-10-06 14:58:07'),(7,'TTPOST_LOGISTICS','TTPost Logistics','Collection and logistics partner operations.','2026-10-06 14:58:07','2026-10-06 14:58:07'),(8,'TSTT_OVERSIGHT','TSTT Oversight','TSTT oversight and reporting.','2026-10-06 14:58:07','2026-10-06 14:58:07');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schools`
--

DROP TABLE IF EXISTS `schools`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schools` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `district_id` int(10) unsigned DEFAULT NULL,
  `school_code` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(220) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_schools_school_code` (`school_code`),
  KEY `idx_schools_district_id` (`district_id`),
  KEY `idx_schools_status` (`status`),
  KEY `idx_schools_name` (`name`),
  CONSTRAINT `fk_schools_district` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schools`
--

LOCK TABLES `schools` WRITE;
/*!40000 ALTER TABLE `schools` DISABLE KEYS */;
INSERT INTO `schools` VALUES (1,6,'POINT-FORTIN-SENIOR-SECONDARY','Point Fortin Senior Secondary','active','2026-10-20 20:45:43','2026-10-20 20:45:43');
/*!40000 ALTER TABLE `schools` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_locations`
--

DROP TABLE IF EXISTS `service_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_locations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `location_type` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_service_locations_code` (`code`),
  KEY `idx_service_locations_type_active` (`location_type`,`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_locations`
--

LOCK TABLES `service_locations` WRITE;
/*!40000 ALTER TABLE `service_locations` DISABLE KEYS */;
INSERT INTO `service_locations` VALUES (1,'TTPOST','PORT-OF-SPAIN','PORT OF SPAIN',1,'2026-10-20 20:39:26','2026-10-20 20:39:26'),(2,'REPAIR_CENTRE','ARIMA','ARIMA',1,'2026-10-20 20:39:36','2026-10-20 20:39:36');
/*!40000 ALTER TABLE `service_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sla_calendar_dates`
--

DROP TABLE IF EXISTS `sla_calendar_dates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sla_calendar_dates` (
  `calendar_date` date NOT NULL,
  PRIMARY KEY (`calendar_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sla_calendar_dates`
--

LOCK TABLES `sla_calendar_dates` WRITE;
/*!40000 ALTER TABLE `sla_calendar_dates` DISABLE KEYS */;
INSERT INTO `sla_calendar_dates` VALUES ('2020-01-01'),('2020-01-02'),('2020-01-03'),('2020-01-04'),('2020-01-05'),('2020-01-06'),('2020-01-07'),('2020-01-08'),('2020-01-09'),('2020-01-10'),('2020-01-11'),('2020-01-12'),('2020-01-13'),('2020-01-14'),('2020-01-15'),('2020-01-16'),('2020-01-17'),('2020-01-18'),('2020-01-19'),('2020-01-20'),('2020-01-21'),('2020-01-22'),('2020-01-23'),('2020-01-24'),('2020-01-25'),('2020-01-26'),('2020-01-27'),('2020-01-28'),('2020-01-29'),('2020-01-30'),('2020-01-31'),('2020-02-01'),('2020-02-02'),('2020-02-03'),('2020-02-04'),('2020-02-05'),('2020-02-06'),('2020-02-07'),('2020-02-08'),('2020-02-09'),('2020-02-10'),('2020-02-11'),('2020-02-12'),('2020-02-13'),('2020-02-14'),('2020-02-15'),('2020-02-16'),('2020-02-17'),('2020-02-18'),('2020-02-19'),('2020-02-20'),('2020-02-21'),('2020-02-22'),('2020-02-23'),('2020-02-24'),('2020-02-25'),('2020-02-26'),('2020-02-27'),('2020-02-28'),('2020-02-29'),('2020-03-01'),('2020-03-02'),('2020-03-03'),('2020-03-04'),('2020-03-05'),('2020-03-06'),('2020-03-07'),('2020-03-08'),('2020-03-09'),('2020-03-10'),('2020-03-11'),('2020-03-12'),('2020-03-13'),('2020-03-14'),('2020-03-15'),('2020-03-16'),('2020-03-17'),('2020-03-18'),('2020-03-19'),('2020-03-20'),('2020-03-21'),('2020-03-22'),('2020-03-23'),('2020-03-24'),('2020-03-25'),('2020-03-26'),('2020-03-27'),('2020-03-28'),('2020-03-29'),('2020-03-30'),('2020-03-31'),('2020-04-01'),('2020-04-02'),('2020-04-03'),('2020-04-04'),('2020-04-05'),('2020-04-06'),('2020-04-07'),('2020-04-08'),('2020-04-09'),('2020-04-10'),('2020-04-11'),('2020-04-12'),('2020-04-13'),('2020-04-14'),('2020-04-15'),('2020-04-16'),('2020-04-17'),('2020-04-18'),('2020-04-19'),('2020-04-20'),('2020-04-21'),('2020-04-22'),('2020-04-23'),('2020-04-24'),('2020-04-25'),('2020-04-26'),('2020-04-27'),('2020-04-28'),('2020-04-29'),('2020-04-30'),('2020-05-01'),('2020-05-02'),('2020-05-03'),('2020-05-04'),('2020-05-05'),('2020-05-06'),('2020-05-07'),('2020-05-08'),('2020-05-09'),('2020-05-10'),('2020-05-11'),('2020-05-12'),('2020-05-13'),('2020-05-14'),('2020-05-15'),('2020-05-16'),('2020-05-17'),('2020-05-18'),('2020-05-19'),('2020-05-20'),('2020-05-21'),('2020-05-22'),('2020-05-23'),('2020-05-24'),('2020-05-25'),('2020-05-26'),('2020-05-27'),('2020-05-28'),('2020-05-29'),('2020-05-30'),('2020-05-31'),('2020-06-01'),('2020-06-02'),('2020-06-03'),('2020-06-04'),('2020-06-05'),('2020-06-06'),('2020-06-07'),('2020-06-08'),('2020-06-09'),('2020-06-10'),('2020-06-11'),('2020-06-12'),('2020-06-13'),('2020-06-14'),('2020-06-15'),('2020-06-16'),('2020-06-17'),('2020-06-18'),('2020-06-19'),('2020-06-20'),('2020-06-21'),('2020-06-22'),('2020-06-23'),('2020-06-24'),('2020-06-25'),('2020-06-26'),('2020-06-27'),('2020-06-28'),('2020-06-29'),('2020-06-30'),('2020-07-01'),('2020-07-02'),('2020-07-03'),('2020-07-04'),('2020-07-05'),('2020-07-06'),('2020-07-07'),('2020-07-08'),('2020-07-09'),('2020-07-10'),('2020-07-11'),('2020-07-12'),('2020-07-13'),('2020-07-14'),('2020-07-15'),('2020-07-16'),('2020-07-17'),('2020-07-18'),('2020-07-19'),('2020-07-20'),('2020-07-21'),('2020-07-22'),('2020-07-23'),('2020-07-24'),('2020-07-25'),('2020-07-26'),('2020-07-27'),('2020-07-28'),('2020-07-29'),('2020-07-30'),('2020-07-31'),('2020-08-01'),('2020-08-02'),('2020-08-03'),('2020-08-04'),('2020-08-05'),('2020-08-06'),('2020-08-07'),('2020-08-08'),('2020-08-09'),('2020-08-10'),('2020-08-11'),('2020-08-12'),('2020-08-13'),('2020-08-14'),('2020-08-15'),('2020-08-16'),('2020-08-17'),('2020-08-18'),('2020-08-19'),('2020-08-20'),('2020-08-21'),('2020-08-22'),('2020-08-23'),('2020-08-24'),('2020-08-25'),('2020-08-26'),('2020-08-27'),('2020-08-28'),('2020-08-29'),('2020-08-30'),('2020-08-31'),('2020-09-01'),('2020-09-02'),('2020-09-03'),('2020-09-04'),('2020-09-05'),('2020-09-06'),('2020-09-07'),('2020-09-08'),('2020-09-09'),('2020-09-10'),('2020-09-11'),('2020-09-12'),('2020-09-13'),('2020-09-14'),('2020-09-15'),('2020-09-16'),('2020-09-17'),('2020-09-18'),('2020-09-19'),('2020-09-20'),('2020-09-21'),('2020-09-22'),('2020-09-23'),('2020-09-24'),('2020-09-25'),('2020-09-26'),('2020-09-27'),('2020-09-28'),('2020-09-29'),('2020-09-30'),('2020-10-01'),('2020-10-02'),('2020-10-03'),('2020-10-04'),('2020-10-05'),('2020-10-06'),('2020-10-07'),('2020-10-08'),('2020-10-09'),('2020-10-10'),('2020-10-11'),('2020-10-12'),('2020-10-13'),('2020-10-14'),('2020-10-15'),('2020-10-16'),('2020-10-17'),('2020-10-18'),('2020-10-19'),('2020-10-20'),('2020-10-21'),('2020-10-22'),('2020-10-23'),('2020-10-24'),('2020-10-25'),('2020-10-26'),('2020-10-27'),('2020-10-28'),('2020-10-29'),('2020-10-30'),('2020-10-31'),('2020-11-01'),('2020-11-02'),('2020-11-03'),('2020-11-04'),('2020-11-05'),('2020-11-06'),('2020-11-07'),('2020-11-08'),('2020-11-09'),('2020-11-10'),('2020-11-11'),('2020-11-12'),('2020-11-13'),('2020-11-14'),('2020-11-15'),('2020-11-16'),('2020-11-17'),('2020-11-18'),('2020-11-19'),('2020-11-20'),('2020-11-21'),('2020-11-22'),('2020-11-23'),('2020-11-24'),('2020-11-25'),('2020-11-26'),('2020-11-27'),('2020-11-28'),('2020-11-29'),('2020-11-30'),('2020-12-01'),('2020-12-02'),('2020-12-03'),('2020-12-04'),('2020-12-05'),('2020-12-06'),('2020-12-07'),('2020-12-08'),('2020-12-09'),('2020-12-10'),('2020-12-11'),('2020-12-12'),('2020-12-13'),('2020-12-14'),('2020-12-15'),('2020-12-16'),('2020-12-17'),('2020-12-18'),('2020-12-19'),('2020-12-20'),('2020-12-21'),('2020-12-22'),('2020-12-23'),('2020-12-24'),('2020-12-25'),('2020-12-26'),('2020-12-27'),('2020-12-28'),('2020-12-29'),('2020-12-30'),('2020-12-31'),('2021-01-01'),('2021-01-02'),('2021-01-03'),('2021-01-04'),('2021-01-05'),('2021-01-06'),('2021-01-07'),('2021-01-08'),('2021-01-09'),('2021-01-10'),('2021-01-11'),('2021-01-12'),('2021-01-13'),('2021-01-14'),('2021-01-15'),('2021-01-16'),('2021-01-17'),('2021-01-18'),('2021-01-19'),('2021-01-20'),('2021-01-21'),('2021-01-22'),('2021-01-23'),('2021-01-24'),('2021-01-25'),('2021-01-26'),('2021-01-27'),('2021-01-28'),('2021-01-29'),('2021-01-30'),('2021-01-31'),('2021-02-01'),('2021-02-02'),('2021-02-03'),('2021-02-04'),('2021-02-05'),('2021-02-06'),('2021-02-07'),('2021-02-08'),('2021-02-09'),('2021-02-10'),('2021-02-11'),('2021-02-12'),('2021-02-13'),('2021-02-14'),('2021-02-15'),('2021-02-16'),('2021-02-17'),('2021-02-18'),('2021-02-19'),('2021-02-20'),('2021-02-21'),('2021-02-22'),('2021-02-23'),('2021-02-24'),('2021-02-25'),('2021-02-26'),('2021-02-27'),('2021-02-28'),('2021-03-01'),('2021-03-02'),('2021-03-03'),('2021-03-04'),('2021-03-05'),('2021-03-06'),('2021-03-07'),('2021-03-08'),('2021-03-09'),('2021-03-10'),('2021-03-11'),('2021-03-12'),('2021-03-13'),('2021-03-14'),('2021-03-15'),('2021-03-16'),('2021-03-17'),('2021-03-18'),('2021-03-19'),('2021-03-20'),('2021-03-21'),('2021-03-22'),('2021-03-23'),('2021-03-24'),('2021-03-25'),('2021-03-26'),('2021-03-27'),('2021-03-28'),('2021-03-29'),('2021-03-30'),('2021-03-31'),('2021-04-01'),('2021-04-02'),('2021-04-03'),('2021-04-04'),('2021-04-05'),('2021-04-06'),('2021-04-07'),('2021-04-08'),('2021-04-09'),('2021-04-10'),('2021-04-11'),('2021-04-12'),('2021-04-13'),('2021-04-14'),('2021-04-15'),('2021-04-16'),('2021-04-17'),('2021-04-18'),('2021-04-19'),('2021-04-20'),('2021-04-21'),('2021-04-22'),('2021-04-23'),('2021-04-24'),('2021-04-25'),('2021-04-26'),('2021-04-27'),('2021-04-28'),('2021-04-29'),('2021-04-30'),('2021-05-01'),('2021-05-02'),('2021-05-03'),('2021-05-04'),('2021-05-05'),('2021-05-06'),('2021-05-07'),('2021-05-08'),('2021-05-09'),('2021-05-10'),('2021-05-11'),('2021-05-12'),('2021-05-13'),('2021-05-14'),('2021-05-15'),('2021-05-16'),('2021-05-17'),('2021-05-18'),('2021-05-19'),('2021-05-20'),('2021-05-21'),('2021-05-22'),('2021-05-23'),('2021-05-24'),('2021-05-25'),('2021-05-26'),('2021-05-27'),('2021-05-28'),('2021-05-29'),('2021-05-30'),('2021-05-31'),('2021-06-01'),('2021-06-02'),('2021-06-03'),('2021-06-04'),('2021-06-05'),('2021-06-06'),('2021-06-07'),('2021-06-08'),('2021-06-09'),('2021-06-10'),('2021-06-11'),('2021-06-12'),('2021-06-13'),('2021-06-14'),('2021-06-15'),('2021-06-16'),('2021-06-17'),('2021-06-18'),('2021-06-19'),('2021-06-20'),('2021-06-21'),('2021-06-22'),('2021-06-23'),('2021-06-24'),('2021-06-25'),('2021-06-26'),('2021-06-27'),('2021-06-28'),('2021-06-29'),('2021-06-30'),('2021-07-01'),('2021-07-02'),('2021-07-03'),('2021-07-04'),('2021-07-05'),('2021-07-06'),('2021-07-07'),('2021-07-08'),('2021-07-09'),('2021-07-10'),('2021-07-11'),('2021-07-12'),('2021-07-13'),('2021-07-14'),('2021-07-15'),('2021-07-16'),('2021-07-17'),('2021-07-18'),('2021-07-19'),('2021-07-20'),('2021-07-21'),('2021-07-22'),('2021-07-23'),('2021-07-24'),('2021-07-25'),('2021-07-26'),('2021-07-27'),('2021-07-28'),('2021-07-29'),('2021-07-30'),('2021-07-31'),('2021-08-01'),('2021-08-02'),('2021-08-03'),('2021-08-04'),('2021-08-05'),('2021-08-06'),('2021-08-07'),('2021-08-08'),('2021-08-09'),('2021-08-10'),('2021-08-11'),('2021-08-12'),('2021-08-13'),('2021-08-14'),('2021-08-15'),('2021-08-16'),('2021-08-17'),('2021-08-18'),('2021-08-19'),('2021-08-20'),('2021-08-21'),('2021-08-22'),('2021-08-23'),('2021-08-24'),('2021-08-25'),('2021-08-26'),('2021-08-27'),('2021-08-28'),('2021-08-29'),('2021-08-30'),('2021-08-31'),('2021-09-01'),('2021-09-02'),('2021-09-03'),('2021-09-04'),('2021-09-05'),('2021-09-06'),('2021-09-07'),('2021-09-08'),('2021-09-09'),('2021-09-10'),('2021-09-11'),('2021-09-12'),('2021-09-13'),('2021-09-14'),('2021-09-15'),('2021-09-16'),('2021-09-17'),('2021-09-18'),('2021-09-19'),('2021-09-20'),('2021-09-21'),('2021-09-22'),('2021-09-23'),('2021-09-24'),('2021-09-25'),('2021-09-26'),('2021-09-27'),('2021-09-28'),('2021-09-29'),('2021-09-30'),('2021-10-01'),('2021-10-02'),('2021-10-03'),('2021-10-04'),('2021-10-05'),('2021-10-06'),('2021-10-07'),('2021-10-08'),('2021-10-09'),('2021-10-10'),('2021-10-11'),('2021-10-12'),('2021-10-13'),('2021-10-14'),('2021-10-15'),('2021-10-16'),('2021-10-17'),('2021-10-18'),('2021-10-19'),('2021-10-20'),('2021-10-21'),('2021-10-22'),('2021-10-23'),('2021-10-24'),('2021-10-25'),('2021-10-26'),('2021-10-27'),('2021-10-28'),('2021-10-29'),('2021-10-30'),('2021-10-31'),('2021-11-01'),('2021-11-02'),('2021-11-03'),('2021-11-04'),('2021-11-05'),('2021-11-06'),('2021-11-07'),('2021-11-08'),('2021-11-09'),('2021-11-10'),('2021-11-11'),('2021-11-12'),('2021-11-13'),('2021-11-14'),('2021-11-15'),('2021-11-16'),('2021-11-17'),('2021-11-18'),('2021-11-19'),('2021-11-20'),('2021-11-21'),('2021-11-22'),('2021-11-23'),('2021-11-24'),('2021-11-25'),('2021-11-26'),('2021-11-27'),('2021-11-28'),('2021-11-29'),('2021-11-30'),('2021-12-01'),('2021-12-02'),('2021-12-03'),('2021-12-04'),('2021-12-05'),('2021-12-06'),('2021-12-07'),('2021-12-08'),('2021-12-09'),('2021-12-10'),('2021-12-11'),('2021-12-12'),('2021-12-13'),('2021-12-14'),('2021-12-15'),('2021-12-16'),('2021-12-17'),('2021-12-18'),('2021-12-19'),('2021-12-20'),('2021-12-21'),('2021-12-22'),('2021-12-23'),('2021-12-24'),('2021-12-25'),('2021-12-26'),('2021-12-27'),('2021-12-28'),('2021-12-29'),('2021-12-30'),('2021-12-31'),('2022-01-01'),('2022-01-02'),('2022-01-03'),('2022-01-04'),('2022-01-05'),('2022-01-06'),('2022-01-07'),('2022-01-08'),('2022-01-09'),('2022-01-10'),('2022-01-11'),('2022-01-12'),('2022-01-13'),('2022-01-14'),('2022-01-15'),('2022-01-16'),('2022-01-17'),('2022-01-18'),('2022-01-19'),('2022-01-20'),('2022-01-21'),('2022-01-22'),('2022-01-23'),('2022-01-24'),('2022-01-25'),('2022-01-26'),('2022-01-27'),('2022-01-28'),('2022-01-29'),('2022-01-30'),('2022-01-31'),('2022-02-01'),('2022-02-02'),('2022-02-03'),('2022-02-04'),('2022-02-05'),('2022-02-06'),('2022-02-07'),('2022-02-08'),('2022-02-09'),('2022-02-10'),('2022-02-11'),('2022-02-12'),('2022-02-13'),('2022-02-14'),('2022-02-15'),('2022-02-16'),('2022-02-17'),('2022-02-18'),('2022-02-19'),('2022-02-20'),('2022-02-21'),('2022-02-22'),('2022-02-23'),('2022-02-24'),('2022-02-25'),('2022-02-26'),('2022-02-27'),('2022-02-28'),('2022-03-01'),('2022-03-02'),('2022-03-03'),('2022-03-04'),('2022-03-05'),('2022-03-06'),('2022-03-07'),('2022-03-08'),('2022-03-09'),('2022-03-10'),('2022-03-11'),('2022-03-12'),('2022-03-13'),('2022-03-14'),('2022-03-15'),('2022-03-16'),('2022-03-17'),('2022-03-18'),('2022-03-19'),('2022-03-20'),('2022-03-21'),('2022-03-22'),('2022-03-23'),('2022-03-24'),('2022-03-25'),('2022-03-26'),('2022-03-27'),('2022-03-28'),('2022-03-29'),('2022-03-30'),('2022-03-31'),('2022-04-01'),('2022-04-02'),('2022-04-03'),('2022-04-04'),('2022-04-05'),('2022-04-06'),('2022-04-07'),('2022-04-08'),('2022-04-09'),('2022-04-10'),('2022-04-11'),('2022-04-12'),('2022-04-13'),('2022-04-14'),('2022-04-15'),('2022-04-16'),('2022-04-17'),('2022-04-18'),('2022-04-19'),('2022-04-20'),('2022-04-21'),('2022-04-22'),('2022-04-23'),('2022-04-24'),('2022-04-25'),('2022-04-26'),('2022-04-27'),('2022-04-28'),('2022-04-29'),('2022-04-30'),('2022-05-01'),('2022-05-02'),('2022-05-03'),('2022-05-04'),('2022-05-05'),('2022-05-06'),('2022-05-07'),('2022-05-08'),('2022-05-09'),('2022-05-10'),('2022-05-11'),('2022-05-12'),('2022-05-13'),('2022-05-14'),('2022-05-15'),('2022-05-16'),('2022-05-17'),('2022-05-18'),('2022-05-19'),('2022-05-20'),('2022-05-21'),('2022-05-22'),('2022-05-23'),('2022-05-24'),('2022-05-25'),('2022-05-26'),('2022-05-27'),('2022-05-28'),('2022-05-29'),('2022-05-30'),('2022-05-31'),('2022-06-01'),('2022-06-02'),('2022-06-03'),('2022-06-04'),('2022-06-05'),('2022-06-06'),('2022-06-07'),('2022-06-08'),('2022-06-09'),('2022-06-10'),('2022-06-11'),('2022-06-12'),('2022-06-13'),('2022-06-14'),('2022-06-15'),('2022-06-16'),('2022-06-17'),('2022-06-18'),('2022-06-19'),('2022-06-20'),('2022-06-21'),('2022-06-22'),('2022-06-23'),('2022-06-24'),('2022-06-25'),('2022-06-26'),('2022-06-27'),('2022-06-28'),('2022-06-29'),('2022-06-30'),('2022-07-01'),('2022-07-02'),('2022-07-03'),('2022-07-04'),('2022-07-05'),('2022-07-06'),('2022-07-07'),('2022-07-08'),('2022-07-09'),('2022-07-10'),('2022-07-11'),('2022-07-12'),('2022-07-13'),('2022-07-14'),('2022-07-15'),('2022-07-16'),('2022-07-17'),('2022-07-18'),('2022-07-19'),('2022-07-20'),('2022-07-21'),('2022-07-22'),('2022-07-23'),('2022-07-24'),('2022-07-25'),('2022-07-26'),('2022-07-27'),('2022-07-28'),('2022-07-29'),('2022-07-30'),('2022-07-31'),('2022-08-01'),('2022-08-02'),('2022-08-03'),('2022-08-04'),('2022-08-05'),('2022-08-06'),('2022-08-07'),('2022-08-08'),('2022-08-09'),('2022-08-10'),('2022-08-11'),('2022-08-12'),('2022-08-13'),('2022-08-14'),('2022-08-15'),('2022-08-16'),('2022-08-17'),('2022-08-18'),('2022-08-19'),('2022-08-20'),('2022-08-21'),('2022-08-22'),('2022-08-23'),('2022-08-24'),('2022-08-25'),('2022-08-26'),('2022-08-27'),('2022-08-28'),('2022-08-29'),('2022-08-30'),('2022-08-31'),('2022-09-01'),('2022-09-02'),('2022-09-03'),('2022-09-04'),('2022-09-05'),('2022-09-06'),('2022-09-07'),('2022-09-08'),('2022-09-09'),('2022-09-10'),('2022-09-11'),('2022-09-12'),('2022-09-13'),('2022-09-14'),('2022-09-15'),('2022-09-16'),('2022-09-17'),('2022-09-18'),('2022-09-19'),('2022-09-20'),('2022-09-21'),('2022-09-22'),('2022-09-23'),('2022-09-24'),('2022-09-25'),('2022-09-26'),('2022-09-27'),('2022-09-28'),('2022-09-29'),('2022-09-30'),('2022-10-01'),('2022-10-02'),('2022-10-03'),('2022-10-04'),('2022-10-05'),('2022-10-06'),('2022-10-07'),('2022-10-08'),('2022-10-09'),('2022-10-10'),('2022-10-11'),('2022-10-12'),('2022-10-13'),('2022-10-14'),('2022-10-15'),('2022-10-16'),('2022-10-17'),('2022-10-18'),('2022-10-19'),('2022-10-20'),('2022-10-21'),('2022-10-22'),('2022-10-23'),('2022-10-24'),('2022-10-25'),('2022-10-26'),('2022-10-27'),('2022-10-28'),('2022-10-29'),('2022-10-30'),('2022-10-31'),('2022-11-01'),('2022-11-02'),('2022-11-03'),('2022-11-04'),('2022-11-05'),('2022-11-06'),('2022-11-07'),('2022-11-08'),('2022-11-09'),('2022-11-10'),('2022-11-11'),('2022-11-12'),('2022-11-13'),('2022-11-14'),('2022-11-15'),('2022-11-16'),('2022-11-17'),('2022-11-18'),('2022-11-19'),('2022-11-20'),('2022-11-21'),('2022-11-22'),('2022-11-23'),('2022-11-24'),('2022-11-25'),('2022-11-26'),('2022-11-27'),('2022-11-28'),('2022-11-29'),('2022-11-30'),('2022-12-01'),('2022-12-02'),('2022-12-03'),('2022-12-04'),('2022-12-05'),('2022-12-06'),('2022-12-07'),('2022-12-08'),('2022-12-09'),('2022-12-10'),('2022-12-11'),('2022-12-12'),('2022-12-13'),('2022-12-14'),('2022-12-15'),('2022-12-16'),('2022-12-17'),('2022-12-18'),('2022-12-19'),('2022-12-20'),('2022-12-21'),('2022-12-22'),('2022-12-23'),('2022-12-24'),('2022-12-25'),('2022-12-26'),('2022-12-27'),('2022-12-28'),('2022-12-29'),('2022-12-30'),('2022-12-31'),('2023-01-01'),('2023-01-02'),('2023-01-03'),('2023-01-04'),('2023-01-05'),('2023-01-06'),('2023-01-07'),('2023-01-08'),('2023-01-09'),('2023-01-10'),('2023-01-11'),('2023-01-12'),('2023-01-13'),('2023-01-14'),('2023-01-15'),('2023-01-16'),('2023-01-17'),('2023-01-18'),('2023-01-19'),('2023-01-20'),('2023-01-21'),('2023-01-22'),('2023-01-23'),('2023-01-24'),('2023-01-25'),('2023-01-26'),('2023-01-27'),('2023-01-28'),('2023-01-29'),('2023-01-30'),('2023-01-31'),('2023-02-01'),('2023-02-02'),('2023-02-03'),('2023-02-04'),('2023-02-05'),('2023-02-06'),('2023-02-07'),('2023-02-08'),('2023-02-09'),('2023-02-10'),('2023-02-11'),('2023-02-12'),('2023-02-13'),('2023-02-14'),('2023-02-15'),('2023-02-16'),('2023-02-17'),('2023-02-18'),('2023-02-19'),('2023-02-20'),('2023-02-21'),('2023-02-22'),('2023-02-23'),('2023-02-24'),('2023-02-25'),('2023-02-26'),('2023-02-27'),('2023-02-28'),('2023-03-01'),('2023-03-02'),('2023-03-03'),('2023-03-04'),('2023-03-05'),('2023-03-06'),('2023-03-07'),('2023-03-08'),('2023-03-09'),('2023-03-10'),('2023-03-11'),('2023-03-12'),('2023-03-13'),('2023-03-14'),('2023-03-15'),('2023-03-16'),('2023-03-17'),('2023-03-18'),('2023-03-19'),('2023-03-20'),('2023-03-21'),('2023-03-22'),('2023-03-23'),('2023-03-24'),('2023-03-25'),('2023-03-26'),('2023-03-27'),('2023-03-28'),('2023-03-29'),('2023-03-30'),('2023-03-31'),('2023-04-01'),('2023-04-02'),('2023-04-03'),('2023-04-04'),('2023-04-05'),('2023-04-06'),('2023-04-07'),('2023-04-08'),('2023-04-09'),('2023-04-10'),('2023-04-11'),('2023-04-12'),('2023-04-13'),('2023-04-14'),('2023-04-15'),('2023-04-16'),('2023-04-17'),('2023-04-18'),('2023-04-19'),('2023-04-20'),('2023-04-21'),('2023-04-22'),('2023-04-23'),('2023-04-24'),('2023-04-25'),('2023-04-26'),('2023-04-27'),('2023-04-28'),('2023-04-29'),('2023-04-30'),('2023-05-01'),('2023-05-02'),('2023-05-03'),('2023-05-04'),('2023-05-05'),('2023-05-06'),('2023-05-07'),('2023-05-08'),('2023-05-09'),('2023-05-10'),('2023-05-11'),('2023-05-12'),('2023-05-13'),('2023-05-14'),('2023-05-15'),('2023-05-16'),('2023-05-17'),('2023-05-18'),('2023-05-19'),('2023-05-20'),('2023-05-21'),('2023-05-22'),('2023-05-23'),('2023-05-24'),('2023-05-25'),('2023-05-26'),('2023-05-27'),('2023-05-28'),('2023-05-29'),('2023-05-30'),('2023-05-31'),('2023-06-01'),('2023-06-02'),('2023-06-03'),('2023-06-04'),('2023-06-05'),('2023-06-06'),('2023-06-07'),('2023-06-08'),('2023-06-09'),('2023-06-10'),('2023-06-11'),('2023-06-12'),('2023-06-13'),('2023-06-14'),('2023-06-15'),('2023-06-16'),('2023-06-17'),('2023-06-18'),('2023-06-19'),('2023-06-20'),('2023-06-21'),('2023-06-22'),('2023-06-23'),('2023-06-24'),('2023-06-25'),('2023-06-26'),('2023-06-27'),('2023-06-28'),('2023-06-29'),('2023-06-30'),('2023-07-01'),('2023-07-02'),('2023-07-03'),('2023-07-04'),('2023-07-05'),('2023-07-06'),('2023-07-07'),('2023-07-08'),('2023-07-09'),('2023-07-10'),('2023-07-11'),('2023-07-12'),('2023-07-13'),('2023-07-14'),('2023-07-15'),('2023-07-16'),('2023-07-17'),('2023-07-18'),('2023-07-19'),('2023-07-20'),('2023-07-21'),('2023-07-22'),('2023-07-23'),('2023-07-24'),('2023-07-25'),('2023-07-26'),('2023-07-27'),('2023-07-28'),('2023-07-29'),('2023-07-30'),('2023-07-31'),('2023-08-01'),('2023-08-02'),('2023-08-03'),('2023-08-04'),('2023-08-05'),('2023-08-06'),('2023-08-07'),('2023-08-08'),('2023-08-09'),('2023-08-10'),('2023-08-11'),('2023-08-12'),('2023-08-13'),('2023-08-14'),('2023-08-15'),('2023-08-16'),('2023-08-17'),('2023-08-18'),('2023-08-19'),('2023-08-20'),('2023-08-21'),('2023-08-22'),('2023-08-23'),('2023-08-24'),('2023-08-25'),('2023-08-26'),('2023-08-27'),('2023-08-28'),('2023-08-29'),('2023-08-30'),('2023-08-31'),('2023-09-01'),('2023-09-02'),('2023-09-03'),('2023-09-04'),('2023-09-05'),('2023-09-06'),('2023-09-07'),('2023-09-08'),('2023-09-09'),('2023-09-10'),('2023-09-11'),('2023-09-12'),('2023-09-13'),('2023-09-14'),('2023-09-15'),('2023-09-16'),('2023-09-17'),('2023-09-18'),('2023-09-19'),('2023-09-20'),('2023-09-21'),('2023-09-22'),('2023-09-23'),('2023-09-24'),('2023-09-25'),('2023-09-26'),('2023-09-27'),('2023-09-28'),('2023-09-29'),('2023-09-30'),('2023-10-01'),('2023-10-02'),('2023-10-03'),('2023-10-04'),('2023-10-05'),('2023-10-06'),('2023-10-07'),('2023-10-08'),('2023-10-09'),('2023-10-10'),('2023-10-11'),('2023-10-12'),('2023-10-13'),('2023-10-14'),('2023-10-15'),('2023-10-16'),('2023-10-17'),('2023-10-18'),('2023-10-19'),('2023-10-20'),('2023-10-21'),('2023-10-22'),('2023-10-23'),('2023-10-24'),('2023-10-25'),('2023-10-26'),('2023-10-27'),('2023-10-28'),('2023-10-29'),('2023-10-30'),('2023-10-31'),('2023-11-01'),('2023-11-02'),('2023-11-03'),('2023-11-04'),('2023-11-05'),('2023-11-06'),('2023-11-07'),('2023-11-08'),('2023-11-09'),('2023-11-10'),('2023-11-11'),('2023-11-12'),('2023-11-13'),('2023-11-14'),('2023-11-15'),('2023-11-16'),('2023-11-17'),('2023-11-18'),('2023-11-19'),('2023-11-20'),('2023-11-21'),('2023-11-22'),('2023-11-23'),('2023-11-24'),('2023-11-25'),('2023-11-26'),('2023-11-27'),('2023-11-28'),('2023-11-29'),('2023-11-30'),('2023-12-01'),('2023-12-02'),('2023-12-03'),('2023-12-04'),('2023-12-05'),('2023-12-06'),('2023-12-07'),('2023-12-08'),('2023-12-09'),('2023-12-10'),('2023-12-11'),('2023-12-12'),('2023-12-13'),('2023-12-14'),('2023-12-15'),('2023-12-16'),('2023-12-17'),('2023-12-18'),('2023-12-19'),('2023-12-20'),('2023-12-21'),('2023-12-22'),('2023-12-23'),('2023-12-24'),('2023-12-25'),('2023-12-26'),('2023-12-27'),('2023-12-28'),('2023-12-29'),('2023-12-30'),('2023-12-31'),('2024-01-01'),('2024-01-02'),('2024-01-03'),('2024-01-04'),('2024-01-05'),('2024-01-06'),('2024-01-07'),('2024-01-08'),('2024-01-09'),('2024-01-10'),('2024-01-11'),('2024-01-12'),('2024-01-13'),('2024-01-14'),('2024-01-15'),('2024-01-16'),('2024-01-17'),('2024-01-18'),('2024-01-19'),('2024-01-20'),('2024-01-21'),('2024-01-22'),('2024-01-23'),('2024-01-24'),('2024-01-25'),('2024-01-26'),('2024-01-27'),('2024-01-28'),('2024-01-29'),('2024-01-30'),('2024-01-31'),('2024-02-01'),('2024-02-02'),('2024-02-03'),('2024-02-04'),('2024-02-05'),('2024-02-06'),('2024-02-07'),('2024-02-08'),('2024-02-09'),('2024-02-10'),('2024-02-11'),('2024-02-12'),('2024-02-13'),('2024-02-14'),('2024-02-15'),('2024-02-16'),('2024-02-17'),('2024-02-18'),('2024-02-19'),('2024-02-20'),('2024-02-21'),('2024-02-22'),('2024-02-23'),('2024-02-24'),('2024-02-25'),('2024-02-26'),('2024-02-27'),('2024-02-28'),('2024-02-29'),('2024-03-01'),('2024-03-02'),('2024-03-03'),('2024-03-04'),('2024-03-05'),('2024-03-06'),('2024-03-07'),('2024-03-08'),('2024-03-09'),('2024-03-10'),('2024-03-11'),('2024-03-12'),('2024-03-13'),('2024-03-14'),('2024-03-15'),('2024-03-16'),('2024-03-17'),('2024-03-18'),('2024-03-19'),('2024-03-20'),('2024-03-21'),('2024-03-22'),('2024-03-23'),('2024-03-24'),('2024-03-25'),('2024-03-26'),('2024-03-27'),('2024-03-28'),('2024-03-29'),('2024-03-30'),('2024-03-31'),('2024-04-01'),('2024-04-02'),('2024-04-03'),('2024-04-04'),('2024-04-05'),('2024-04-06'),('2024-04-07'),('2024-04-08'),('2024-04-09'),('2024-04-10'),('2024-04-11'),('2024-04-12'),('2024-04-13'),('2024-04-14'),('2024-04-15'),('2024-04-16'),('2024-04-17'),('2024-04-18'),('2024-04-19'),('2024-04-20'),('2024-04-21'),('2024-04-22'),('2024-04-23'),('2024-04-24'),('2024-04-25'),('2024-04-26'),('2024-04-27'),('2024-04-28'),('2024-04-29'),('2024-04-30'),('2024-05-01'),('2024-05-02'),('2024-05-03'),('2024-05-04'),('2024-05-05'),('2024-05-06'),('2024-05-07'),('2024-05-08'),('2024-05-09'),('2024-05-10'),('2024-05-11'),('2024-05-12'),('2024-05-13'),('2024-05-14'),('2024-05-15'),('2024-05-16'),('2024-05-17'),('2024-05-18'),('2024-05-19'),('2024-05-20'),('2024-05-21'),('2024-05-22'),('2024-05-23'),('2024-05-24'),('2024-05-25'),('2024-05-26'),('2024-05-27'),('2024-05-28'),('2024-05-29'),('2024-05-30'),('2024-05-31'),('2024-06-01'),('2024-06-02'),('2024-06-03'),('2024-06-04'),('2024-06-05'),('2024-06-06'),('2024-06-07'),('2024-06-08'),('2024-06-09'),('2024-06-10'),('2024-06-11'),('2024-06-12'),('2024-06-13'),('2024-06-14'),('2024-06-15'),('2024-06-16'),('2024-06-17'),('2024-06-18'),('2024-06-19'),('2024-06-20'),('2024-06-21'),('2024-06-22'),('2024-06-23'),('2024-06-24'),('2024-06-25'),('2024-06-26'),('2024-06-27'),('2024-06-28'),('2024-06-29'),('2024-06-30'),('2024-07-01'),('2024-07-02'),('2024-07-03'),('2024-07-04'),('2024-07-05'),('2024-07-06'),('2024-07-07'),('2024-07-08'),('2024-07-09'),('2024-07-10'),('2024-07-11'),('2024-07-12'),('2024-07-13'),('2024-07-14'),('2024-07-15'),('2024-07-16'),('2024-07-17'),('2024-07-18'),('2024-07-19'),('2024-07-20'),('2024-07-21'),('2024-07-22'),('2024-07-23'),('2024-07-24'),('2024-07-25'),('2024-07-26'),('2024-07-27'),('2024-07-28'),('2024-07-29'),('2024-07-30'),('2024-07-31'),('2024-08-01'),('2024-08-02'),('2024-08-03'),('2024-08-04'),('2024-08-05'),('2024-08-06'),('2024-08-07'),('2024-08-08'),('2024-08-09'),('2024-08-10'),('2024-08-11'),('2024-08-12'),('2024-08-13'),('2024-08-14'),('2024-08-15'),('2024-08-16'),('2024-08-17'),('2024-08-18'),('2024-08-19'),('2024-08-20'),('2024-08-21'),('2024-08-22'),('2024-08-23'),('2024-08-24'),('2024-08-25'),('2024-08-26'),('2024-08-27'),('2024-08-28'),('2024-08-29'),('2024-08-30'),('2024-08-31'),('2024-09-01'),('2024-09-02'),('2024-09-03'),('2024-09-04'),('2024-09-05'),('2024-09-06'),('2024-09-07'),('2024-09-08'),('2024-09-09'),('2024-09-10'),('2024-09-11'),('2024-09-12'),('2024-09-13'),('2024-09-14'),('2024-09-15'),('2024-09-16'),('2024-09-17'),('2024-09-18'),('2024-09-19'),('2024-09-20'),('2024-09-21'),('2024-09-22'),('2024-09-23'),('2024-09-24'),('2024-09-25'),('2024-09-26'),('2024-09-27'),('2024-09-28'),('2024-09-29'),('2024-09-30'),('2024-10-01'),('2024-10-02'),('2024-10-03'),('2024-10-04'),('2024-10-05'),('2024-10-06'),('2024-10-07'),('2024-10-08'),('2024-10-09'),('2024-10-10'),('2024-10-11'),('2024-10-12'),('2024-10-13'),('2024-10-14'),('2024-10-15'),('2024-10-16'),('2024-10-17'),('2024-10-18'),('2024-10-19'),('2024-10-20'),('2024-10-21'),('2024-10-22'),('2024-10-23'),('2024-10-24'),('2024-10-25'),('2024-10-26'),('2024-10-27'),('2024-10-28'),('2024-10-29'),('2024-10-30'),('2024-10-31'),('2024-11-01'),('2024-11-02'),('2024-11-03'),('2024-11-04'),('2024-11-05'),('2024-11-06'),('2024-11-07'),('2024-11-08'),('2024-11-09'),('2024-11-10'),('2024-11-11'),('2024-11-12'),('2024-11-13'),('2024-11-14'),('2024-11-15'),('2024-11-16'),('2024-11-17'),('2024-11-18'),('2024-11-19'),('2024-11-20'),('2024-11-21'),('2024-11-22'),('2024-11-23'),('2024-11-24'),('2024-11-25'),('2024-11-26'),('2024-11-27'),('2024-11-28'),('2024-11-29'),('2024-11-30'),('2024-12-01'),('2024-12-02'),('2024-12-03'),('2024-12-04'),('2024-12-05'),('2024-12-06'),('2024-12-07'),('2024-12-08'),('2024-12-09'),('2024-12-10'),('2024-12-11'),('2024-12-12'),('2024-12-13'),('2024-12-14'),('2024-12-15'),('2024-12-16'),('2024-12-17'),('2024-12-18'),('2024-12-19'),('2024-12-20'),('2024-12-21'),('2024-12-22'),('2024-12-23'),('2024-12-24'),('2024-12-25'),('2024-12-26'),('2024-12-27'),('2024-12-28'),('2024-12-29'),('2024-12-30'),('2024-12-31'),('2025-01-01'),('2025-01-02'),('2025-01-03'),('2025-01-04'),('2025-01-05'),('2025-01-06'),('2025-01-07'),('2025-01-08'),('2025-01-09'),('2025-01-10'),('2025-01-11'),('2025-01-12'),('2025-01-13'),('2025-01-14'),('2025-01-15'),('2025-01-16'),('2025-01-17'),('2025-01-18'),('2025-01-19'),('2025-01-20'),('2025-01-21'),('2025-01-22'),('2025-01-23'),('2025-01-24'),('2025-01-25'),('2025-01-26'),('2025-01-27'),('2025-01-28'),('2025-01-29'),('2025-01-30'),('2025-01-31'),('2025-02-01'),('2025-02-02'),('2025-02-03'),('2025-02-04'),('2025-02-05'),('2025-02-06'),('2025-02-07'),('2025-02-08'),('2025-02-09'),('2025-02-10'),('2025-02-11'),('2025-02-12'),('2025-02-13'),('2025-02-14'),('2025-02-15'),('2025-02-16'),('2025-02-17'),('2025-02-18'),('2025-02-19'),('2025-02-20'),('2025-02-21'),('2025-02-22'),('2025-02-23'),('2025-02-24'),('2025-02-25'),('2025-02-26'),('2025-02-27'),('2025-02-28'),('2025-03-01'),('2025-03-02'),('2025-03-03'),('2025-03-04'),('2025-03-05'),('2025-03-06'),('2025-03-07'),('2025-03-08'),('2025-03-09'),('2025-03-10'),('2025-03-11'),('2025-03-12'),('2025-03-13'),('2025-03-14'),('2025-03-15'),('2025-03-16'),('2025-03-17'),('2025-03-18'),('2025-03-19'),('2025-03-20'),('2025-03-21'),('2025-03-22'),('2025-03-23'),('2025-03-24'),('2025-03-25'),('2025-03-26'),('2025-03-27'),('2025-03-28'),('2025-03-29'),('2025-03-30'),('2025-03-31'),('2025-04-01'),('2025-04-02'),('2025-04-03'),('2025-04-04'),('2025-04-05'),('2025-04-06'),('2025-04-07'),('2025-04-08'),('2025-04-09'),('2025-04-10'),('2025-04-11'),('2025-04-12'),('2025-04-13'),('2025-04-14'),('2025-04-15'),('2025-04-16'),('2025-04-17'),('2025-04-18'),('2025-04-19'),('2025-04-20'),('2025-04-21'),('2025-04-22'),('2025-04-23'),('2025-04-24'),('2025-04-25'),('2025-04-26'),('2025-04-27'),('2025-04-28'),('2025-04-29'),('2025-04-30'),('2025-05-01'),('2025-05-02'),('2025-05-03'),('2025-05-04'),('2025-05-05'),('2025-05-06'),('2025-05-07'),('2025-05-08'),('2025-05-09'),('2025-05-10'),('2025-05-11'),('2025-05-12'),('2025-05-13'),('2025-05-14'),('2025-05-15'),('2025-05-16'),('2025-05-17'),('2025-05-18'),('2025-05-19'),('2025-05-20'),('2025-05-21'),('2025-05-22'),('2025-05-23'),('2025-05-24'),('2025-05-25'),('2025-05-26'),('2025-05-27'),('2025-05-28'),('2025-05-29'),('2025-05-30'),('2025-05-31'),('2025-06-01'),('2025-06-02'),('2025-06-03'),('2025-06-04'),('2025-06-05'),('2025-06-06'),('2025-06-07'),('2025-06-08'),('2025-06-09'),('2025-06-10'),('2025-06-11'),('2025-06-12'),('2025-06-13'),('2025-06-14'),('2025-06-15'),('2025-06-16'),('2025-06-17'),('2025-06-18'),('2025-06-19'),('2025-06-20'),('2025-06-21'),('2025-06-22'),('2025-06-23'),('2025-06-24'),('2025-06-25'),('2025-06-26'),('2025-06-27'),('2025-06-28'),('2025-06-29'),('2025-06-30'),('2025-07-01'),('2025-07-02'),('2025-07-03'),('2025-07-04'),('2025-07-05'),('2025-07-06'),('2025-07-07'),('2025-07-08'),('2025-07-09'),('2025-07-10'),('2025-07-11'),('2025-07-12'),('2025-07-13'),('2025-07-14'),('2025-07-15'),('2025-07-16'),('2025-07-17'),('2025-07-18'),('2025-07-19'),('2025-07-20'),('2025-07-21'),('2025-07-22'),('2025-07-23'),('2025-07-24'),('2025-07-25'),('2025-07-26'),('2025-07-27'),('2025-07-28'),('2025-07-29'),('2025-07-30'),('2025-07-31'),('2025-08-01'),('2025-08-02'),('2025-08-03'),('2025-08-04'),('2025-08-05'),('2025-08-06'),('2025-08-07'),('2025-08-08'),('2025-08-09'),('2025-08-10'),('2025-08-11'),('2025-08-12'),('2025-08-13'),('2025-08-14'),('2025-08-15'),('2025-08-16'),('2025-08-17'),('2025-08-18'),('2025-08-19'),('2025-08-20'),('2025-08-21'),('2025-08-22'),('2025-08-23'),('2025-08-24'),('2025-08-25'),('2025-08-26'),('2025-08-27'),('2025-08-28'),('2025-08-29'),('2025-08-30'),('2025-08-31'),('2025-09-01'),('2025-09-02'),('2025-09-03'),('2025-09-04'),('2025-09-05'),('2025-09-06'),('2025-09-07'),('2025-09-08'),('2025-09-09'),('2025-09-10'),('2025-09-11'),('2025-09-12'),('2025-09-13'),('2025-09-14'),('2025-09-15'),('2025-09-16'),('2025-09-17'),('2025-09-18'),('2025-09-19'),('2025-09-20'),('2025-09-21'),('2025-09-22'),('2025-09-23'),('2025-09-24'),('2025-09-25'),('2025-09-26'),('2025-09-27'),('2025-09-28'),('2025-09-29'),('2025-09-30'),('2025-10-01'),('2025-10-02'),('2025-10-03'),('2025-10-04'),('2025-10-05'),('2025-10-06'),('2025-10-07'),('2025-10-08'),('2025-10-09'),('2025-10-10'),('2025-10-11'),('2025-10-12'),('2025-10-13'),('2025-10-14'),('2025-10-15'),('2025-10-16'),('2025-10-17'),('2025-10-18'),('2025-10-19'),('2025-10-20'),('2025-10-21'),('2025-10-22'),('2025-10-23'),('2025-10-24'),('2025-10-25'),('2025-10-26'),('2025-10-27'),('2025-10-28'),('2025-10-29'),('2025-10-30'),('2025-10-31'),('2025-11-01'),('2025-11-02'),('2025-11-03'),('2025-11-04'),('2025-11-05'),('2025-11-06'),('2025-11-07'),('2025-11-08'),('2025-11-09'),('2025-11-10'),('2025-11-11'),('2025-11-12'),('2025-11-13'),('2025-11-14'),('2025-11-15'),('2025-11-16'),('2025-11-17'),('2025-11-18'),('2025-11-19'),('2025-11-20'),('2025-11-21'),('2025-11-22'),('2025-11-23'),('2025-11-24'),('2025-11-25'),('2025-11-26'),('2025-11-27'),('2025-11-28'),('2025-11-29'),('2025-11-30'),('2025-12-01'),('2025-12-02'),('2025-12-03'),('2025-12-04'),('2025-12-05'),('2025-12-06'),('2025-12-07'),('2025-12-08'),('2025-12-09'),('2025-12-10'),('2025-12-11'),('2025-12-12'),('2025-12-13'),('2025-12-14'),('2025-12-15'),('2025-12-16'),('2025-12-17'),('2025-12-18'),('2025-12-19'),('2025-12-20'),('2025-12-21'),('2025-12-22'),('2025-12-23'),('2025-12-24'),('2025-12-25'),('2025-12-26'),('2025-12-27'),('2025-12-28'),('2025-12-29'),('2025-12-30'),('2025-12-31'),('2026-01-01'),('2026-01-02'),('2026-01-03'),('2026-01-04'),('2026-01-05'),('2026-01-06'),('2026-01-07'),('2026-01-08'),('2026-01-09'),('2026-01-10'),('2026-01-11'),('2026-01-12'),('2026-01-13'),('2026-01-14'),('2026-01-15'),('2026-01-16'),('2026-01-17'),('2026-01-18'),('2026-01-19'),('2026-01-20'),('2026-01-21'),('2026-01-22'),('2026-01-23'),('2026-01-24'),('2026-01-25'),('2026-01-26'),('2026-01-27'),('2026-01-28'),('2026-01-29'),('2026-01-30'),('2026-01-31'),('2026-02-01'),('2026-02-02'),('2026-02-03'),('2026-02-04'),('2026-02-05'),('2026-02-06'),('2026-02-07'),('2026-02-08'),('2026-02-09'),('2026-02-10'),('2026-02-11'),('2026-02-12'),('2026-02-13'),('2026-02-14'),('2026-02-15'),('2026-02-16'),('2026-02-17'),('2026-02-18'),('2026-02-19'),('2026-02-20'),('2026-02-21'),('2026-02-22'),('2026-02-23'),('2026-02-24'),('2026-02-25'),('2026-02-26'),('2026-02-27'),('2026-02-28'),('2026-03-01'),('2026-03-02'),('2026-03-03'),('2026-03-04'),('2026-03-05'),('2026-03-06'),('2026-03-07'),('2026-03-08'),('2026-03-09'),('2026-03-10'),('2026-03-11'),('2026-03-12'),('2026-03-13'),('2026-03-14'),('2026-03-15'),('2026-03-16'),('2026-03-17'),('2026-03-18'),('2026-03-19'),('2026-03-20'),('2026-03-21'),('2026-03-22'),('2026-03-23'),('2026-03-24'),('2026-03-25'),('2026-03-26'),('2026-03-27'),('2026-03-28'),('2026-03-29'),('2026-03-30'),('2026-03-31'),('2026-04-01'),('2026-04-02'),('2026-04-03'),('2026-04-04'),('2026-04-05'),('2026-04-06'),('2026-04-07'),('2026-04-08'),('2026-04-09'),('2026-04-10'),('2026-04-11'),('2026-04-12'),('2026-04-13'),('2026-04-14'),('2026-04-15'),('2026-04-16'),('2026-04-17'),('2026-04-18'),('2026-04-19'),('2026-04-20'),('2026-04-21'),('2026-04-22'),('2026-04-23'),('2026-04-24'),('2026-04-25'),('2026-04-26'),('2026-04-27'),('2026-04-28'),('2026-04-29'),('2026-04-30'),('2026-05-01'),('2026-05-02'),('2026-05-03'),('2026-05-04'),('2026-05-05'),('2026-05-06'),('2026-05-07'),('2026-05-08'),('2026-05-09'),('2026-05-10'),('2026-05-11'),('2026-05-12'),('2026-05-13'),('2026-05-14'),('2026-05-15'),('2026-05-16'),('2026-05-17'),('2026-05-18'),('2026-05-19'),('2026-05-20'),('2026-05-21'),('2026-05-22'),('2026-05-23'),('2026-05-24'),('2026-05-25'),('2026-05-26'),('2026-05-27'),('2026-05-28'),('2026-05-29'),('2026-05-30'),('2026-05-31'),('2026-06-01'),('2026-06-02'),('2026-06-03'),('2026-06-04'),('2026-06-05'),('2026-06-06'),('2026-06-07'),('2026-06-08'),('2026-06-09'),('2026-06-10'),('2026-06-11'),('2026-06-12'),('2026-06-13'),('2026-06-14'),('2026-06-15'),('2026-06-16'),('2026-06-17'),('2026-06-18'),('2026-06-19'),('2026-06-20'),('2026-06-21'),('2026-06-22'),('2026-06-23'),('2026-06-24'),('2026-06-25'),('2026-06-26'),('2026-06-27'),('2026-06-28'),('2026-06-29'),('2026-06-30'),('2026-07-01'),('2026-07-02'),('2026-07-03'),('2026-07-04'),('2026-07-05'),('2026-07-06'),('2026-07-07'),('2026-07-08'),('2026-07-09'),('2026-07-10'),('2026-07-11'),('2026-07-12'),('2026-07-13'),('2026-07-14'),('2026-07-15'),('2026-07-16'),('2026-07-17'),('2026-07-18'),('2026-07-19'),('2026-07-20'),('2026-07-21'),('2026-07-22'),('2026-07-23'),('2026-07-24'),('2026-07-25'),('2026-07-26'),('2026-07-27'),('2026-07-28'),('2026-07-29'),('2026-07-30'),('2026-07-31'),('2026-08-01'),('2026-08-02'),('2026-08-03'),('2026-08-04'),('2026-08-05'),('2026-08-06'),('2026-08-07'),('2026-08-08'),('2026-08-09'),('2026-08-10'),('2026-08-11'),('2026-08-12'),('2026-08-13'),('2026-08-14'),('2026-08-15'),('2026-08-16'),('2026-08-17'),('2026-08-18'),('2026-08-19'),('2026-08-20'),('2026-08-21'),('2026-08-22'),('2026-08-23'),('2026-08-24'),('2026-08-25'),('2026-08-26'),('2026-08-27'),('2026-08-28'),('2026-08-29'),('2026-08-30'),('2026-08-31'),('2026-09-01'),('2026-09-02'),('2026-09-03'),('2026-09-04'),('2026-09-05'),('2026-09-06'),('2026-09-07'),('2026-09-08'),('2026-09-09'),('2026-09-10'),('2026-09-11'),('2026-09-12'),('2026-09-13'),('2026-09-14'),('2026-09-15'),('2026-09-16'),('2026-09-17'),('2026-09-18'),('2026-09-19'),('2026-09-20'),('2026-09-21'),('2026-09-22'),('2026-09-23'),('2026-09-24'),('2026-09-25'),('2026-09-26'),('2026-09-27'),('2026-09-28'),('2026-09-29'),('2026-09-30'),('2026-10-01'),('2026-10-02'),('2026-10-03'),('2026-10-04'),('2026-10-05'),('2026-10-06'),('2026-10-07'),('2026-10-08'),('2026-10-09'),('2026-10-10'),('2026-10-11'),('2026-10-12'),('2026-10-13'),('2026-10-14'),('2026-10-15'),('2026-10-16'),('2026-10-17'),('2026-10-18'),('2026-10-19'),('2026-10-20'),('2026-10-21'),('2026-10-22'),('2026-10-23'),('2026-10-24'),('2026-10-25'),('2026-10-26'),('2026-10-27'),('2026-10-28'),('2026-10-29'),('2026-10-30'),('2026-10-31'),('2026-11-01'),('2026-11-02'),('2026-11-03'),('2026-11-04'),('2026-11-05'),('2026-11-06'),('2026-11-07'),('2026-11-08'),('2026-11-09'),('2026-11-10'),('2026-11-11'),('2026-11-12'),('2026-11-13'),('2026-11-14'),('2026-11-15'),('2026-11-16'),('2026-11-17'),('2026-11-18'),('2026-11-19'),('2026-11-20'),('2026-11-21'),('2026-11-22'),('2026-11-23'),('2026-11-24'),('2026-11-25'),('2026-11-26'),('2026-11-27'),('2026-11-28'),('2026-11-29'),('2026-11-30'),('2026-12-01'),('2026-12-02'),('2026-12-03'),('2026-12-04'),('2026-12-05'),('2026-12-06'),('2026-12-07'),('2026-12-08'),('2026-12-09'),('2026-12-10'),('2026-12-11'),('2026-12-12'),('2026-12-13'),('2026-12-14'),('2026-12-15'),('2026-12-16'),('2026-12-17'),('2026-12-18'),('2026-12-19'),('2026-12-20'),('2026-12-21'),('2026-12-22'),('2026-12-23'),('2026-12-24'),('2026-12-25'),('2026-12-26'),('2026-12-27'),('2026-12-28'),('2026-12-29'),('2026-12-30'),('2026-12-31'),('2027-01-01'),('2027-01-02'),('2027-01-03'),('2027-01-04'),('2027-01-05'),('2027-01-06'),('2027-01-07'),('2027-01-08'),('2027-01-09'),('2027-01-10'),('2027-01-11'),('2027-01-12'),('2027-01-13'),('2027-01-14'),('2027-01-15'),('2027-01-16'),('2027-01-17'),('2027-01-18'),('2027-01-19'),('2027-01-20'),('2027-01-21'),('2027-01-22'),('2027-01-23'),('2027-01-24'),('2027-01-25'),('2027-01-26'),('2027-01-27'),('2027-01-28'),('2027-01-29'),('2027-01-30'),('2027-01-31'),('2027-02-01'),('2027-02-02'),('2027-02-03'),('2027-02-04'),('2027-02-05'),('2027-02-06'),('2027-02-07'),('2027-02-08'),('2027-02-09'),('2027-02-10'),('2027-02-11'),('2027-02-12'),('2027-02-13'),('2027-02-14'),('2027-02-15'),('2027-02-16'),('2027-02-17'),('2027-02-18'),('2027-02-19'),('2027-02-20'),('2027-02-21'),('2027-02-22'),('2027-02-23'),('2027-02-24'),('2027-02-25'),('2027-02-26'),('2027-02-27'),('2027-02-28'),('2027-03-01'),('2027-03-02'),('2027-03-03'),('2027-03-04'),('2027-03-05'),('2027-03-06'),('2027-03-07'),('2027-03-08'),('2027-03-09'),('2027-03-10'),('2027-03-11'),('2027-03-12'),('2027-03-13'),('2027-03-14'),('2027-03-15'),('2027-03-16'),('2027-03-17'),('2027-03-18'),('2027-03-19'),('2027-03-20'),('2027-03-21'),('2027-03-22'),('2027-03-23'),('2027-03-24'),('2027-03-25'),('2027-03-26'),('2027-03-27'),('2027-03-28'),('2027-03-29'),('2027-03-30'),('2027-03-31'),('2027-04-01'),('2027-04-02'),('2027-04-03'),('2027-04-04'),('2027-04-05'),('2027-04-06'),('2027-04-07'),('2027-04-08'),('2027-04-09'),('2027-04-10'),('2027-04-11'),('2027-04-12'),('2027-04-13'),('2027-04-14'),('2027-04-15'),('2027-04-16'),('2027-04-17'),('2027-04-18'),('2027-04-19'),('2027-04-20'),('2027-04-21'),('2027-04-22'),('2027-04-23'),('2027-04-24'),('2027-04-25'),('2027-04-26'),('2027-04-27'),('2027-04-28'),('2027-04-29'),('2027-04-30'),('2027-05-01'),('2027-05-02'),('2027-05-03'),('2027-05-04'),('2027-05-05'),('2027-05-06'),('2027-05-07'),('2027-05-08'),('2027-05-09'),('2027-05-10'),('2027-05-11'),('2027-05-12'),('2027-05-13'),('2027-05-14'),('2027-05-15'),('2027-05-16'),('2027-05-17'),('2027-05-18'),('2027-05-19'),('2027-05-20'),('2027-05-21'),('2027-05-22'),('2027-05-23'),('2027-05-24'),('2027-05-25'),('2027-05-26'),('2027-05-27'),('2027-05-28'),('2027-05-29'),('2027-05-30'),('2027-05-31'),('2027-06-01'),('2027-06-02'),('2027-06-03'),('2027-06-04'),('2027-06-05'),('2027-06-06'),('2027-06-07'),('2027-06-08'),('2027-06-09'),('2027-06-10'),('2027-06-11'),('2027-06-12'),('2027-06-13'),('2027-06-14'),('2027-06-15'),('2027-06-16'),('2027-06-17'),('2027-06-18'),('2027-06-19'),('2027-06-20'),('2027-06-21'),('2027-06-22'),('2027-06-23'),('2027-06-24'),('2027-06-25'),('2027-06-26'),('2027-06-27'),('2027-06-28'),('2027-06-29'),('2027-06-30'),('2027-07-01'),('2027-07-02'),('2027-07-03'),('2027-07-04'),('2027-07-05'),('2027-07-06'),('2027-07-07'),('2027-07-08'),('2027-07-09'),('2027-07-10'),('2027-07-11'),('2027-07-12'),('2027-07-13'),('2027-07-14'),('2027-07-15'),('2027-07-16'),('2027-07-17'),('2027-07-18'),('2027-07-19'),('2027-07-20'),('2027-07-21'),('2027-07-22'),('2027-07-23'),('2027-07-24'),('2027-07-25'),('2027-07-26'),('2027-07-27'),('2027-07-28'),('2027-07-29'),('2027-07-30'),('2027-07-31'),('2027-08-01'),('2027-08-02'),('2027-08-03'),('2027-08-04'),('2027-08-05'),('2027-08-06'),('2027-08-07'),('2027-08-08'),('2027-08-09'),('2027-08-10'),('2027-08-11'),('2027-08-12'),('2027-08-13'),('2027-08-14'),('2027-08-15'),('2027-08-16'),('2027-08-17'),('2027-08-18'),('2027-08-19'),('2027-08-20'),('2027-08-21'),('2027-08-22'),('2027-08-23'),('2027-08-24'),('2027-08-25'),('2027-08-26'),('2027-08-27'),('2027-08-28'),('2027-08-29'),('2027-08-30'),('2027-08-31'),('2027-09-01'),('2027-09-02'),('2027-09-03'),('2027-09-04'),('2027-09-05'),('2027-09-06'),('2027-09-07'),('2027-09-08'),('2027-09-09'),('2027-09-10'),('2027-09-11'),('2027-09-12'),('2027-09-13'),('2027-09-14'),('2027-09-15'),('2027-09-16'),('2027-09-17'),('2027-09-18'),('2027-09-19'),('2027-09-20'),('2027-09-21'),('2027-09-22'),('2027-09-23'),('2027-09-24'),('2027-09-25'),('2027-09-26'),('2027-09-27'),('2027-09-28'),('2027-09-29'),('2027-09-30'),('2027-10-01'),('2027-10-02'),('2027-10-03'),('2027-10-04'),('2027-10-05'),('2027-10-06'),('2027-10-07'),('2027-10-08'),('2027-10-09'),('2027-10-10'),('2027-10-11'),('2027-10-12'),('2027-10-13'),('2027-10-14'),('2027-10-15'),('2027-10-16'),('2027-10-17'),('2027-10-18'),('2027-10-19'),('2027-10-20'),('2027-10-21'),('2027-10-22'),('2027-10-23'),('2027-10-24'),('2027-10-25'),('2027-10-26'),('2027-10-27'),('2027-10-28'),('2027-10-29'),('2027-10-30'),('2027-10-31'),('2027-11-01'),('2027-11-02'),('2027-11-03'),('2027-11-04'),('2027-11-05'),('2027-11-06'),('2027-11-07'),('2027-11-08'),('2027-11-09'),('2027-11-10'),('2027-11-11'),('2027-11-12'),('2027-11-13'),('2027-11-14'),('2027-11-15'),('2027-11-16'),('2027-11-17'),('2027-11-18'),('2027-11-19'),('2027-11-20'),('2027-11-21'),('2027-11-22'),('2027-11-23'),('2027-11-24'),('2027-11-25'),('2027-11-26'),('2027-11-27'),('2027-11-28'),('2027-11-29'),('2027-11-30'),('2027-12-01'),('2027-12-02'),('2027-12-03'),('2027-12-04'),('2027-12-05'),('2027-12-06'),('2027-12-07'),('2027-12-08'),('2027-12-09'),('2027-12-10'),('2027-12-11'),('2027-12-12'),('2027-12-13'),('2027-12-14'),('2027-12-15'),('2027-12-16'),('2027-12-17'),('2027-12-18'),('2027-12-19'),('2027-12-20'),('2027-12-21'),('2027-12-22'),('2027-12-23'),('2027-12-24'),('2027-12-25'),('2027-12-26'),('2027-12-27'),('2027-12-28'),('2027-12-29'),('2027-12-30'),('2027-12-31'),('2028-01-01'),('2028-01-02'),('2028-01-03'),('2028-01-04'),('2028-01-05'),('2028-01-06'),('2028-01-07'),('2028-01-08'),('2028-01-09'),('2028-01-10'),('2028-01-11'),('2028-01-12'),('2028-01-13'),('2028-01-14'),('2028-01-15'),('2028-01-16'),('2028-01-17'),('2028-01-18'),('2028-01-19'),('2028-01-20'),('2028-01-21'),('2028-01-22'),('2028-01-23'),('2028-01-24'),('2028-01-25'),('2028-01-26'),('2028-01-27'),('2028-01-28'),('2028-01-29'),('2028-01-30'),('2028-01-31'),('2028-02-01'),('2028-02-02'),('2028-02-03'),('2028-02-04'),('2028-02-05'),('2028-02-06'),('2028-02-07'),('2028-02-08'),('2028-02-09'),('2028-02-10'),('2028-02-11'),('2028-02-12'),('2028-02-13'),('2028-02-14'),('2028-02-15'),('2028-02-16'),('2028-02-17'),('2028-02-18'),('2028-02-19'),('2028-02-20'),('2028-02-21'),('2028-02-22'),('2028-02-23'),('2028-02-24'),('2028-02-25'),('2028-02-26'),('2028-02-27'),('2028-02-28'),('2028-02-29'),('2028-03-01'),('2028-03-02'),('2028-03-03'),('2028-03-04'),('2028-03-05'),('2028-03-06'),('2028-03-07'),('2028-03-08'),('2028-03-09'),('2028-03-10'),('2028-03-11'),('2028-03-12'),('2028-03-13'),('2028-03-14'),('2028-03-15'),('2028-03-16'),('2028-03-17'),('2028-03-18'),('2028-03-19'),('2028-03-20'),('2028-03-21'),('2028-03-22'),('2028-03-23'),('2028-03-24'),('2028-03-25'),('2028-03-26'),('2028-03-27'),('2028-03-28'),('2028-03-29'),('2028-03-30'),('2028-03-31'),('2028-04-01'),('2028-04-02'),('2028-04-03'),('2028-04-04'),('2028-04-05'),('2028-04-06'),('2028-04-07'),('2028-04-08'),('2028-04-09'),('2028-04-10'),('2028-04-11'),('2028-04-12'),('2028-04-13'),('2028-04-14'),('2028-04-15'),('2028-04-16'),('2028-04-17'),('2028-04-18'),('2028-04-19'),('2028-04-20'),('2028-04-21'),('2028-04-22'),('2028-04-23'),('2028-04-24'),('2028-04-25'),('2028-04-26'),('2028-04-27'),('2028-04-28'),('2028-04-29'),('2028-04-30'),('2028-05-01'),('2028-05-02'),('2028-05-03'),('2028-05-04'),('2028-05-05'),('2028-05-06'),('2028-05-07'),('2028-05-08'),('2028-05-09'),('2028-05-10'),('2028-05-11'),('2028-05-12'),('2028-05-13'),('2028-05-14'),('2028-05-15'),('2028-05-16'),('2028-05-17'),('2028-05-18'),('2028-05-19'),('2028-05-20'),('2028-05-21'),('2028-05-22'),('2028-05-23'),('2028-05-24'),('2028-05-25'),('2028-05-26'),('2028-05-27'),('2028-05-28'),('2028-05-29'),('2028-05-30'),('2028-05-31'),('2028-06-01'),('2028-06-02'),('2028-06-03'),('2028-06-04'),('2028-06-05'),('2028-06-06'),('2028-06-07'),('2028-06-08'),('2028-06-09'),('2028-06-10'),('2028-06-11'),('2028-06-12'),('2028-06-13'),('2028-06-14'),('2028-06-15'),('2028-06-16'),('2028-06-17'),('2028-06-18'),('2028-06-19'),('2028-06-20'),('2028-06-21'),('2028-06-22'),('2028-06-23'),('2028-06-24'),('2028-06-25'),('2028-06-26'),('2028-06-27'),('2028-06-28'),('2028-06-29'),('2028-06-30'),('2028-07-01'),('2028-07-02'),('2028-07-03'),('2028-07-04'),('2028-07-05'),('2028-07-06'),('2028-07-07'),('2028-07-08'),('2028-07-09'),('2028-07-10'),('2028-07-11'),('2028-07-12'),('2028-07-13'),('2028-07-14'),('2028-07-15'),('2028-07-16'),('2028-07-17'),('2028-07-18'),('2028-07-19'),('2028-07-20'),('2028-07-21'),('2028-07-22'),('2028-07-23'),('2028-07-24'),('2028-07-25'),('2028-07-26'),('2028-07-27'),('2028-07-28'),('2028-07-29'),('2028-07-30'),('2028-07-31'),('2028-08-01'),('2028-08-02'),('2028-08-03'),('2028-08-04'),('2028-08-05'),('2028-08-06'),('2028-08-07'),('2028-08-08'),('2028-08-09'),('2028-08-10'),('2028-08-11'),('2028-08-12'),('2028-08-13'),('2028-08-14'),('2028-08-15'),('2028-08-16'),('2028-08-17'),('2028-08-18'),('2028-08-19'),('2028-08-20'),('2028-08-21'),('2028-08-22'),('2028-08-23'),('2028-08-24'),('2028-08-25'),('2028-08-26'),('2028-08-27'),('2028-08-28'),('2028-08-29'),('2028-08-30'),('2028-08-31'),('2028-09-01'),('2028-09-02'),('2028-09-03'),('2028-09-04'),('2028-09-05'),('2028-09-06'),('2028-09-07'),('2028-09-08'),('2028-09-09'),('2028-09-10'),('2028-09-11'),('2028-09-12'),('2028-09-13'),('2028-09-14'),('2028-09-15'),('2028-09-16'),('2028-09-17'),('2028-09-18'),('2028-09-19'),('2028-09-20'),('2028-09-21'),('2028-09-22'),('2028-09-23'),('2028-09-24'),('2028-09-25'),('2028-09-26'),('2028-09-27'),('2028-09-28'),('2028-09-29'),('2028-09-30'),('2028-10-01'),('2028-10-02'),('2028-10-03'),('2028-10-04'),('2028-10-05'),('2028-10-06'),('2028-10-07'),('2028-10-08'),('2028-10-09'),('2028-10-10'),('2028-10-11'),('2028-10-12'),('2028-10-13'),('2028-10-14'),('2028-10-15'),('2028-10-16'),('2028-10-17'),('2028-10-18'),('2028-10-19'),('2028-10-20'),('2028-10-21'),('2028-10-22'),('2028-10-23'),('2028-10-24'),('2028-10-25'),('2028-10-26'),('2028-10-27'),('2028-10-28'),('2028-10-29'),('2028-10-30'),('2028-10-31'),('2028-11-01'),('2028-11-02'),('2028-11-03'),('2028-11-04'),('2028-11-05'),('2028-11-06'),('2028-11-07'),('2028-11-08'),('2028-11-09'),('2028-11-10'),('2028-11-11'),('2028-11-12'),('2028-11-13'),('2028-11-14'),('2028-11-15'),('2028-11-16'),('2028-11-17'),('2028-11-18'),('2028-11-19'),('2028-11-20'),('2028-11-21'),('2028-11-22'),('2028-11-23'),('2028-11-24'),('2028-11-25'),('2028-11-26'),('2028-11-27'),('2028-11-28'),('2028-11-29'),('2028-11-30'),('2028-12-01'),('2028-12-02'),('2028-12-03'),('2028-12-04'),('2028-12-05'),('2028-12-06'),('2028-12-07'),('2028-12-08'),('2028-12-09'),('2028-12-10'),('2028-12-11'),('2028-12-12'),('2028-12-13'),('2028-12-14'),('2028-12-15'),('2028-12-16'),('2028-12-17'),('2028-12-18'),('2028-12-19'),('2028-12-20'),('2028-12-21'),('2028-12-22'),('2028-12-23'),('2028-12-24'),('2028-12-25'),('2028-12-26'),('2028-12-27'),('2028-12-28'),('2028-12-29'),('2028-12-30'),('2028-12-31'),('2029-01-01'),('2029-01-02'),('2029-01-03'),('2029-01-04'),('2029-01-05'),('2029-01-06'),('2029-01-07'),('2029-01-08'),('2029-01-09'),('2029-01-10'),('2029-01-11'),('2029-01-12'),('2029-01-13'),('2029-01-14'),('2029-01-15'),('2029-01-16'),('2029-01-17'),('2029-01-18'),('2029-01-19'),('2029-01-20'),('2029-01-21'),('2029-01-22'),('2029-01-23'),('2029-01-24'),('2029-01-25'),('2029-01-26'),('2029-01-27'),('2029-01-28'),('2029-01-29'),('2029-01-30'),('2029-01-31'),('2029-02-01'),('2029-02-02'),('2029-02-03'),('2029-02-04'),('2029-02-05'),('2029-02-06'),('2029-02-07'),('2029-02-08'),('2029-02-09'),('2029-02-10'),('2029-02-11'),('2029-02-12'),('2029-02-13'),('2029-02-14'),('2029-02-15'),('2029-02-16'),('2029-02-17'),('2029-02-18'),('2029-02-19'),('2029-02-20'),('2029-02-21'),('2029-02-22'),('2029-02-23'),('2029-02-24'),('2029-02-25'),('2029-02-26'),('2029-02-27'),('2029-02-28'),('2029-03-01'),('2029-03-02'),('2029-03-03'),('2029-03-04'),('2029-03-05'),('2029-03-06'),('2029-03-07'),('2029-03-08'),('2029-03-09'),('2029-03-10'),('2029-03-11'),('2029-03-12'),('2029-03-13'),('2029-03-14'),('2029-03-15'),('2029-03-16'),('2029-03-17'),('2029-03-18'),('2029-03-19'),('2029-03-20'),('2029-03-21'),('2029-03-22'),('2029-03-23'),('2029-03-24'),('2029-03-25'),('2029-03-26'),('2029-03-27'),('2029-03-28'),('2029-03-29'),('2029-03-30'),('2029-03-31'),('2029-04-01'),('2029-04-02'),('2029-04-03'),('2029-04-04'),('2029-04-05'),('2029-04-06'),('2029-04-07'),('2029-04-08'),('2029-04-09'),('2029-04-10'),('2029-04-11'),('2029-04-12'),('2029-04-13'),('2029-04-14'),('2029-04-15'),('2029-04-16'),('2029-04-17'),('2029-04-18'),('2029-04-19'),('2029-04-20'),('2029-04-21'),('2029-04-22'),('2029-04-23'),('2029-04-24'),('2029-04-25'),('2029-04-26'),('2029-04-27'),('2029-04-28'),('2029-04-29'),('2029-04-30'),('2029-05-01'),('2029-05-02'),('2029-05-03'),('2029-05-04'),('2029-05-05'),('2029-05-06'),('2029-05-07'),('2029-05-08'),('2029-05-09'),('2029-05-10'),('2029-05-11'),('2029-05-12'),('2029-05-13'),('2029-05-14'),('2029-05-15'),('2029-05-16'),('2029-05-17'),('2029-05-18'),('2029-05-19'),('2029-05-20'),('2029-05-21'),('2029-05-22'),('2029-05-23'),('2029-05-24'),('2029-05-25'),('2029-05-26'),('2029-05-27'),('2029-05-28'),('2029-05-29'),('2029-05-30'),('2029-05-31'),('2029-06-01'),('2029-06-02'),('2029-06-03'),('2029-06-04'),('2029-06-05'),('2029-06-06'),('2029-06-07'),('2029-06-08'),('2029-06-09'),('2029-06-10'),('2029-06-11'),('2029-06-12'),('2029-06-13'),('2029-06-14'),('2029-06-15'),('2029-06-16'),('2029-06-17'),('2029-06-18'),('2029-06-19'),('2029-06-20'),('2029-06-21'),('2029-06-22'),('2029-06-23'),('2029-06-24'),('2029-06-25'),('2029-06-26'),('2029-06-27'),('2029-06-28'),('2029-06-29'),('2029-06-30'),('2029-07-01'),('2029-07-02'),('2029-07-03'),('2029-07-04'),('2029-07-05'),('2029-07-06'),('2029-07-07'),('2029-07-08'),('2029-07-09'),('2029-07-10'),('2029-07-11'),('2029-07-12'),('2029-07-13'),('2029-07-14'),('2029-07-15'),('2029-07-16'),('2029-07-17'),('2029-07-18'),('2029-07-19'),('2029-07-20'),('2029-07-21'),('2029-07-22'),('2029-07-23'),('2029-07-24'),('2029-07-25'),('2029-07-26'),('2029-07-27'),('2029-07-28'),('2029-07-29'),('2029-07-30'),('2029-07-31'),('2029-08-01'),('2029-08-02'),('2029-08-03'),('2029-08-04'),('2029-08-05'),('2029-08-06'),('2029-08-07'),('2029-08-08'),('2029-08-09'),('2029-08-10'),('2029-08-11'),('2029-08-12'),('2029-08-13'),('2029-08-14'),('2029-08-15'),('2029-08-16'),('2029-08-17'),('2029-08-18'),('2029-08-19'),('2029-08-20'),('2029-08-21'),('2029-08-22'),('2029-08-23'),('2029-08-24'),('2029-08-25'),('2029-08-26'),('2029-08-27'),('2029-08-28'),('2029-08-29'),('2029-08-30'),('2029-08-31'),('2029-09-01'),('2029-09-02'),('2029-09-03'),('2029-09-04'),('2029-09-05'),('2029-09-06'),('2029-09-07'),('2029-09-08'),('2029-09-09'),('2029-09-10'),('2029-09-11'),('2029-09-12'),('2029-09-13'),('2029-09-14'),('2029-09-15'),('2029-09-16'),('2029-09-17'),('2029-09-18'),('2029-09-19'),('2029-09-20'),('2029-09-21'),('2029-09-22'),('2029-09-23'),('2029-09-24'),('2029-09-25'),('2029-09-26'),('2029-09-27'),('2029-09-28'),('2029-09-29'),('2029-09-30'),('2029-10-01'),('2029-10-02'),('2029-10-03'),('2029-10-04'),('2029-10-05'),('2029-10-06'),('2029-10-07'),('2029-10-08'),('2029-10-09'),('2029-10-10'),('2029-10-11'),('2029-10-12'),('2029-10-13'),('2029-10-14'),('2029-10-15'),('2029-10-16'),('2029-10-17'),('2029-10-18'),('2029-10-19'),('2029-10-20'),('2029-10-21'),('2029-10-22'),('2029-10-23'),('2029-10-24'),('2029-10-25'),('2029-10-26'),('2029-10-27'),('2029-10-28'),('2029-10-29'),('2029-10-30'),('2029-10-31'),('2029-11-01'),('2029-11-02'),('2029-11-03'),('2029-11-04'),('2029-11-05'),('2029-11-06'),('2029-11-07'),('2029-11-08'),('2029-11-09'),('2029-11-10'),('2029-11-11'),('2029-11-12'),('2029-11-13'),('2029-11-14'),('2029-11-15'),('2029-11-16'),('2029-11-17'),('2029-11-18'),('2029-11-19'),('2029-11-20'),('2029-11-21'),('2029-11-22'),('2029-11-23'),('2029-11-24'),('2029-11-25'),('2029-11-26'),('2029-11-27'),('2029-11-28'),('2029-11-29'),('2029-11-30'),('2029-12-01'),('2029-12-02'),('2029-12-03'),('2029-12-04'),('2029-12-05'),('2029-12-06'),('2029-12-07'),('2029-12-08'),('2029-12-09'),('2029-12-10'),('2029-12-11'),('2029-12-12'),('2029-12-13'),('2029-12-14'),('2029-12-15'),('2029-12-16'),('2029-12-17'),('2029-12-18'),('2029-12-19'),('2029-12-20'),('2029-12-21'),('2029-12-22'),('2029-12-23'),('2029-12-24'),('2029-12-25'),('2029-12-26'),('2029-12-27'),('2029-12-28'),('2029-12-29'),('2029-12-30'),('2029-12-31'),('2030-01-01'),('2030-01-02'),('2030-01-03'),('2030-01-04'),('2030-01-05'),('2030-01-06'),('2030-01-07'),('2030-01-08'),('2030-01-09'),('2030-01-10'),('2030-01-11'),('2030-01-12'),('2030-01-13'),('2030-01-14'),('2030-01-15'),('2030-01-16'),('2030-01-17'),('2030-01-18'),('2030-01-19'),('2030-01-20'),('2030-01-21'),('2030-01-22'),('2030-01-23'),('2030-01-24'),('2030-01-25'),('2030-01-26'),('2030-01-27'),('2030-01-28'),('2030-01-29'),('2030-01-30'),('2030-01-31'),('2030-02-01'),('2030-02-02'),('2030-02-03'),('2030-02-04'),('2030-02-05'),('2030-02-06'),('2030-02-07'),('2030-02-08'),('2030-02-09'),('2030-02-10'),('2030-02-11'),('2030-02-12'),('2030-02-13'),('2030-02-14'),('2030-02-15'),('2030-02-16'),('2030-02-17'),('2030-02-18'),('2030-02-19'),('2030-02-20'),('2030-02-21'),('2030-02-22'),('2030-02-23'),('2030-02-24'),('2030-02-25'),('2030-02-26'),('2030-02-27'),('2030-02-28'),('2030-03-01'),('2030-03-02'),('2030-03-03'),('2030-03-04'),('2030-03-05'),('2030-03-06'),('2030-03-07'),('2030-03-08'),('2030-03-09'),('2030-03-10'),('2030-03-11'),('2030-03-12'),('2030-03-13'),('2030-03-14'),('2030-03-15'),('2030-03-16'),('2030-03-17'),('2030-03-18'),('2030-03-19'),('2030-03-20'),('2030-03-21'),('2030-03-22'),('2030-03-23'),('2030-03-24'),('2030-03-25'),('2030-03-26'),('2030-03-27'),('2030-03-28'),('2030-03-29'),('2030-03-30'),('2030-03-31'),('2030-04-01'),('2030-04-02'),('2030-04-03'),('2030-04-04'),('2030-04-05'),('2030-04-06'),('2030-04-07'),('2030-04-08'),('2030-04-09'),('2030-04-10'),('2030-04-11'),('2030-04-12'),('2030-04-13'),('2030-04-14'),('2030-04-15'),('2030-04-16'),('2030-04-17'),('2030-04-18'),('2030-04-19'),('2030-04-20'),('2030-04-21'),('2030-04-22'),('2030-04-23'),('2030-04-24'),('2030-04-25'),('2030-04-26'),('2030-04-27'),('2030-04-28'),('2030-04-29'),('2030-04-30'),('2030-05-01'),('2030-05-02'),('2030-05-03'),('2030-05-04'),('2030-05-05'),('2030-05-06'),('2030-05-07'),('2030-05-08'),('2030-05-09'),('2030-05-10'),('2030-05-11'),('2030-05-12'),('2030-05-13'),('2030-05-14'),('2030-05-15'),('2030-05-16'),('2030-05-17'),('2030-05-18'),('2030-05-19'),('2030-05-20'),('2030-05-21'),('2030-05-22'),('2030-05-23'),('2030-05-24'),('2030-05-25'),('2030-05-26'),('2030-05-27'),('2030-05-28'),('2030-05-29'),('2030-05-30'),('2030-05-31'),('2030-06-01'),('2030-06-02'),('2030-06-03'),('2030-06-04'),('2030-06-05'),('2030-06-06'),('2030-06-07'),('2030-06-08'),('2030-06-09'),('2030-06-10'),('2030-06-11'),('2030-06-12'),('2030-06-13'),('2030-06-14'),('2030-06-15'),('2030-06-16'),('2030-06-17'),('2030-06-18'),('2030-06-19'),('2030-06-20'),('2030-06-21'),('2030-06-22'),('2030-06-23'),('2030-06-24'),('2030-06-25'),('2030-06-26'),('2030-06-27'),('2030-06-28'),('2030-06-29'),('2030-06-30'),('2030-07-01'),('2030-07-02'),('2030-07-03'),('2030-07-04'),('2030-07-05'),('2030-07-06'),('2030-07-07'),('2030-07-08'),('2030-07-09'),('2030-07-10'),('2030-07-11'),('2030-07-12'),('2030-07-13'),('2030-07-14'),('2030-07-15'),('2030-07-16'),('2030-07-17'),('2030-07-18'),('2030-07-19'),('2030-07-20'),('2030-07-21'),('2030-07-22'),('2030-07-23'),('2030-07-24'),('2030-07-25'),('2030-07-26'),('2030-07-27'),('2030-07-28'),('2030-07-29'),('2030-07-30'),('2030-07-31'),('2030-08-01'),('2030-08-02'),('2030-08-03'),('2030-08-04'),('2030-08-05'),('2030-08-06'),('2030-08-07'),('2030-08-08'),('2030-08-09'),('2030-08-10'),('2030-08-11'),('2030-08-12'),('2030-08-13'),('2030-08-14'),('2030-08-15'),('2030-08-16'),('2030-08-17'),('2030-08-18'),('2030-08-19'),('2030-08-20'),('2030-08-21'),('2030-08-22'),('2030-08-23'),('2030-08-24'),('2030-08-25'),('2030-08-26'),('2030-08-27'),('2030-08-28'),('2030-08-29'),('2030-08-30'),('2030-08-31'),('2030-09-01'),('2030-09-02'),('2030-09-03'),('2030-09-04'),('2030-09-05'),('2030-09-06'),('2030-09-07'),('2030-09-08'),('2030-09-09'),('2030-09-10'),('2030-09-11'),('2030-09-12'),('2030-09-13'),('2030-09-14'),('2030-09-15'),('2030-09-16'),('2030-09-17'),('2030-09-18'),('2030-09-19'),('2030-09-20'),('2030-09-21'),('2030-09-22'),('2030-09-23'),('2030-09-24'),('2030-09-25'),('2030-09-26'),('2030-09-27'),('2030-09-28'),('2030-09-29'),('2030-09-30'),('2030-10-01'),('2030-10-02'),('2030-10-03'),('2030-10-04'),('2030-10-05'),('2030-10-06'),('2030-10-07'),('2030-10-08'),('2030-10-09'),('2030-10-10'),('2030-10-11'),('2030-10-12'),('2030-10-13'),('2030-10-14'),('2030-10-15'),('2030-10-16'),('2030-10-17'),('2030-10-18'),('2030-10-19'),('2030-10-20'),('2030-10-21'),('2030-10-22'),('2030-10-23'),('2030-10-24'),('2030-10-25'),('2030-10-26'),('2030-10-27'),('2030-10-28'),('2030-10-29'),('2030-10-30'),('2030-10-31'),('2030-11-01'),('2030-11-02'),('2030-11-03'),('2030-11-04'),('2030-11-05'),('2030-11-06'),('2030-11-07'),('2030-11-08'),('2030-11-09'),('2030-11-10'),('2030-11-11'),('2030-11-12'),('2030-11-13'),('2030-11-14'),('2030-11-15'),('2030-11-16'),('2030-11-17'),('2030-11-18'),('2030-11-19'),('2030-11-20'),('2030-11-21'),('2030-11-22'),('2030-11-23'),('2030-11-24'),('2030-11-25'),('2030-11-26'),('2030-11-27'),('2030-11-28'),('2030-11-29'),('2030-11-30'),('2030-12-01'),('2030-12-02'),('2030-12-03'),('2030-12-04'),('2030-12-05'),('2030-12-06'),('2030-12-07'),('2030-12-08'),('2030-12-09'),('2030-12-10'),('2030-12-11'),('2030-12-12'),('2030-12-13'),('2030-12-14'),('2030-12-15'),('2030-12-16'),('2030-12-17'),('2030-12-18'),('2030-12-19'),('2030-12-20'),('2030-12-21'),('2030-12-22'),('2030-12-23'),('2030-12-24'),('2030-12-25'),('2030-12-26'),('2030-12-27'),('2030-12-28'),('2030-12-29'),('2030-12-30'),('2030-12-31'),('2031-01-01'),('2031-01-02'),('2031-01-03'),('2031-01-04'),('2031-01-05'),('2031-01-06'),('2031-01-07'),('2031-01-08'),('2031-01-09'),('2031-01-10'),('2031-01-11'),('2031-01-12'),('2031-01-13'),('2031-01-14'),('2031-01-15'),('2031-01-16'),('2031-01-17'),('2031-01-18'),('2031-01-19'),('2031-01-20'),('2031-01-21'),('2031-01-22'),('2031-01-23'),('2031-01-24'),('2031-01-25'),('2031-01-26'),('2031-01-27'),('2031-01-28'),('2031-01-29'),('2031-01-30'),('2031-01-31'),('2031-02-01'),('2031-02-02'),('2031-02-03'),('2031-02-04'),('2031-02-05'),('2031-02-06'),('2031-02-07'),('2031-02-08'),('2031-02-09'),('2031-02-10'),('2031-02-11'),('2031-02-12'),('2031-02-13'),('2031-02-14'),('2031-02-15'),('2031-02-16'),('2031-02-17'),('2031-02-18'),('2031-02-19'),('2031-02-20'),('2031-02-21'),('2031-02-22'),('2031-02-23'),('2031-02-24'),('2031-02-25'),('2031-02-26'),('2031-02-27'),('2031-02-28'),('2031-03-01'),('2031-03-02'),('2031-03-03'),('2031-03-04'),('2031-03-05'),('2031-03-06'),('2031-03-07'),('2031-03-08'),('2031-03-09'),('2031-03-10'),('2031-03-11'),('2031-03-12'),('2031-03-13'),('2031-03-14'),('2031-03-15'),('2031-03-16'),('2031-03-17'),('2031-03-18'),('2031-03-19'),('2031-03-20'),('2031-03-21'),('2031-03-22'),('2031-03-23'),('2031-03-24'),('2031-03-25'),('2031-03-26'),('2031-03-27'),('2031-03-28'),('2031-03-29'),('2031-03-30'),('2031-03-31'),('2031-04-01'),('2031-04-02'),('2031-04-03'),('2031-04-04'),('2031-04-05'),('2031-04-06'),('2031-04-07'),('2031-04-08'),('2031-04-09'),('2031-04-10'),('2031-04-11'),('2031-04-12'),('2031-04-13'),('2031-04-14'),('2031-04-15'),('2031-04-16'),('2031-04-17'),('2031-04-18'),('2031-04-19'),('2031-04-20'),('2031-04-21'),('2031-04-22'),('2031-04-23'),('2031-04-24'),('2031-04-25'),('2031-04-26'),('2031-04-27'),('2031-04-28'),('2031-04-29'),('2031-04-30'),('2031-05-01'),('2031-05-02'),('2031-05-03'),('2031-05-04'),('2031-05-05'),('2031-05-06'),('2031-05-07'),('2031-05-08'),('2031-05-09'),('2031-05-10'),('2031-05-11'),('2031-05-12'),('2031-05-13'),('2031-05-14'),('2031-05-15'),('2031-05-16'),('2031-05-17'),('2031-05-18'),('2031-05-19'),('2031-05-20'),('2031-05-21'),('2031-05-22'),('2031-05-23'),('2031-05-24'),('2031-05-25'),('2031-05-26'),('2031-05-27'),('2031-05-28'),('2031-05-29'),('2031-05-30'),('2031-05-31'),('2031-06-01'),('2031-06-02'),('2031-06-03'),('2031-06-04'),('2031-06-05'),('2031-06-06'),('2031-06-07'),('2031-06-08'),('2031-06-09'),('2031-06-10'),('2031-06-11'),('2031-06-12'),('2031-06-13'),('2031-06-14'),('2031-06-15'),('2031-06-16'),('2031-06-17'),('2031-06-18'),('2031-06-19'),('2031-06-20'),('2031-06-21'),('2031-06-22'),('2031-06-23'),('2031-06-24'),('2031-06-25'),('2031-06-26'),('2031-06-27'),('2031-06-28'),('2031-06-29'),('2031-06-30'),('2031-07-01'),('2031-07-02'),('2031-07-03'),('2031-07-04'),('2031-07-05'),('2031-07-06'),('2031-07-07'),('2031-07-08'),('2031-07-09'),('2031-07-10'),('2031-07-11'),('2031-07-12'),('2031-07-13'),('2031-07-14'),('2031-07-15'),('2031-07-16'),('2031-07-17'),('2031-07-18'),('2031-07-19'),('2031-07-20'),('2031-07-21'),('2031-07-22'),('2031-07-23'),('2031-07-24'),('2031-07-25'),('2031-07-26'),('2031-07-27'),('2031-07-28'),('2031-07-29'),('2031-07-30'),('2031-07-31'),('2031-08-01'),('2031-08-02'),('2031-08-03'),('2031-08-04'),('2031-08-05'),('2031-08-06'),('2031-08-07'),('2031-08-08'),('2031-08-09'),('2031-08-10'),('2031-08-11'),('2031-08-12'),('2031-08-13'),('2031-08-14'),('2031-08-15'),('2031-08-16'),('2031-08-17'),('2031-08-18'),('2031-08-19'),('2031-08-20'),('2031-08-21'),('2031-08-22'),('2031-08-23'),('2031-08-24'),('2031-08-25'),('2031-08-26'),('2031-08-27'),('2031-08-28'),('2031-08-29'),('2031-08-30'),('2031-08-31'),('2031-09-01'),('2031-09-02'),('2031-09-03'),('2031-09-04'),('2031-09-05'),('2031-09-06'),('2031-09-07'),('2031-09-08'),('2031-09-09'),('2031-09-10'),('2031-09-11'),('2031-09-12'),('2031-09-13'),('2031-09-14'),('2031-09-15'),('2031-09-16'),('2031-09-17'),('2031-09-18'),('2031-09-19'),('2031-09-20'),('2031-09-21'),('2031-09-22'),('2031-09-23'),('2031-09-24'),('2031-09-25'),('2031-09-26'),('2031-09-27'),('2031-09-28'),('2031-09-29'),('2031-09-30'),('2031-10-01'),('2031-10-02'),('2031-10-03'),('2031-10-04'),('2031-10-05'),('2031-10-06'),('2031-10-07'),('2031-10-08'),('2031-10-09'),('2031-10-10'),('2031-10-11'),('2031-10-12'),('2031-10-13'),('2031-10-14'),('2031-10-15'),('2031-10-16'),('2031-10-17'),('2031-10-18'),('2031-10-19'),('2031-10-20'),('2031-10-21'),('2031-10-22'),('2031-10-23'),('2031-10-24'),('2031-10-25'),('2031-10-26'),('2031-10-27'),('2031-10-28'),('2031-10-29'),('2031-10-30'),('2031-10-31'),('2031-11-01'),('2031-11-02'),('2031-11-03'),('2031-11-04'),('2031-11-05'),('2031-11-06'),('2031-11-07'),('2031-11-08'),('2031-11-09'),('2031-11-10'),('2031-11-11'),('2031-11-12'),('2031-11-13'),('2031-11-14'),('2031-11-15'),('2031-11-16'),('2031-11-17'),('2031-11-18'),('2031-11-19'),('2031-11-20'),('2031-11-21'),('2031-11-22'),('2031-11-23'),('2031-11-24'),('2031-11-25'),('2031-11-26'),('2031-11-27'),('2031-11-28'),('2031-11-29'),('2031-11-30'),('2031-12-01'),('2031-12-02'),('2031-12-03'),('2031-12-04'),('2031-12-05'),('2031-12-06'),('2031-12-07'),('2031-12-08'),('2031-12-09'),('2031-12-10'),('2031-12-11'),('2031-12-12'),('2031-12-13'),('2031-12-14'),('2031-12-15'),('2031-12-16'),('2031-12-17'),('2031-12-18'),('2031-12-19'),('2031-12-20'),('2031-12-21'),('2031-12-22'),('2031-12-23'),('2031-12-24'),('2031-12-25'),('2031-12-26'),('2031-12-27'),('2031-12-28'),('2031-12-29'),('2031-12-30'),('2031-12-31'),('2032-01-01'),('2032-01-02'),('2032-01-03'),('2032-01-04'),('2032-01-05'),('2032-01-06'),('2032-01-07'),('2032-01-08'),('2032-01-09'),('2032-01-10'),('2032-01-11'),('2032-01-12'),('2032-01-13'),('2032-01-14'),('2032-01-15'),('2032-01-16'),('2032-01-17'),('2032-01-18'),('2032-01-19'),('2032-01-20'),('2032-01-21'),('2032-01-22'),('2032-01-23'),('2032-01-24'),('2032-01-25'),('2032-01-26'),('2032-01-27'),('2032-01-28'),('2032-01-29'),('2032-01-30'),('2032-01-31'),('2032-02-01'),('2032-02-02'),('2032-02-03'),('2032-02-04'),('2032-02-05'),('2032-02-06'),('2032-02-07'),('2032-02-08'),('2032-02-09'),('2032-02-10'),('2032-02-11'),('2032-02-12'),('2032-02-13'),('2032-02-14'),('2032-02-15'),('2032-02-16'),('2032-02-17'),('2032-02-18'),('2032-02-19'),('2032-02-20'),('2032-02-21'),('2032-02-22'),('2032-02-23'),('2032-02-24'),('2032-02-25'),('2032-02-26'),('2032-02-27'),('2032-02-28'),('2032-02-29'),('2032-03-01'),('2032-03-02'),('2032-03-03'),('2032-03-04'),('2032-03-05'),('2032-03-06'),('2032-03-07'),('2032-03-08'),('2032-03-09'),('2032-03-10'),('2032-03-11'),('2032-03-12'),('2032-03-13'),('2032-03-14'),('2032-03-15'),('2032-03-16'),('2032-03-17'),('2032-03-18'),('2032-03-19'),('2032-03-20'),('2032-03-21'),('2032-03-22'),('2032-03-23'),('2032-03-24'),('2032-03-25'),('2032-03-26'),('2032-03-27'),('2032-03-28'),('2032-03-29'),('2032-03-30'),('2032-03-31'),('2032-04-01'),('2032-04-02'),('2032-04-03'),('2032-04-04'),('2032-04-05'),('2032-04-06'),('2032-04-07'),('2032-04-08'),('2032-04-09'),('2032-04-10'),('2032-04-11'),('2032-04-12'),('2032-04-13'),('2032-04-14'),('2032-04-15'),('2032-04-16'),('2032-04-17'),('2032-04-18'),('2032-04-19'),('2032-04-20'),('2032-04-21'),('2032-04-22'),('2032-04-23'),('2032-04-24'),('2032-04-25'),('2032-04-26'),('2032-04-27'),('2032-04-28'),('2032-04-29'),('2032-04-30'),('2032-05-01'),('2032-05-02'),('2032-05-03'),('2032-05-04'),('2032-05-05'),('2032-05-06'),('2032-05-07'),('2032-05-08'),('2032-05-09'),('2032-05-10'),('2032-05-11'),('2032-05-12'),('2032-05-13'),('2032-05-14'),('2032-05-15'),('2032-05-16'),('2032-05-17'),('2032-05-18'),('2032-05-19'),('2032-05-20'),('2032-05-21'),('2032-05-22'),('2032-05-23'),('2032-05-24'),('2032-05-25'),('2032-05-26'),('2032-05-27'),('2032-05-28'),('2032-05-29'),('2032-05-30'),('2032-05-31'),('2032-06-01'),('2032-06-02'),('2032-06-03'),('2032-06-04'),('2032-06-05'),('2032-06-06'),('2032-06-07'),('2032-06-08'),('2032-06-09'),('2032-06-10'),('2032-06-11'),('2032-06-12'),('2032-06-13'),('2032-06-14'),('2032-06-15'),('2032-06-16'),('2032-06-17'),('2032-06-18'),('2032-06-19'),('2032-06-20'),('2032-06-21'),('2032-06-22'),('2032-06-23'),('2032-06-24'),('2032-06-25'),('2032-06-26'),('2032-06-27'),('2032-06-28'),('2032-06-29'),('2032-06-30'),('2032-07-01'),('2032-07-02'),('2032-07-03'),('2032-07-04'),('2032-07-05'),('2032-07-06'),('2032-07-07'),('2032-07-08'),('2032-07-09'),('2032-07-10'),('2032-07-11'),('2032-07-12'),('2032-07-13'),('2032-07-14'),('2032-07-15'),('2032-07-16'),('2032-07-17'),('2032-07-18'),('2032-07-19'),('2032-07-20'),('2032-07-21'),('2032-07-22'),('2032-07-23'),('2032-07-24'),('2032-07-25'),('2032-07-26'),('2032-07-27'),('2032-07-28'),('2032-07-29'),('2032-07-30'),('2032-07-31'),('2032-08-01'),('2032-08-02'),('2032-08-03'),('2032-08-04'),('2032-08-05'),('2032-08-06'),('2032-08-07'),('2032-08-08'),('2032-08-09'),('2032-08-10'),('2032-08-11'),('2032-08-12'),('2032-08-13'),('2032-08-14'),('2032-08-15'),('2032-08-16'),('2032-08-17'),('2032-08-18'),('2032-08-19'),('2032-08-20'),('2032-08-21'),('2032-08-22'),('2032-08-23'),('2032-08-24'),('2032-08-25'),('2032-08-26'),('2032-08-27'),('2032-08-28'),('2032-08-29'),('2032-08-30'),('2032-08-31'),('2032-09-01'),('2032-09-02'),('2032-09-03'),('2032-09-04'),('2032-09-05'),('2032-09-06'),('2032-09-07'),('2032-09-08'),('2032-09-09'),('2032-09-10'),('2032-09-11'),('2032-09-12'),('2032-09-13'),('2032-09-14'),('2032-09-15'),('2032-09-16'),('2032-09-17'),('2032-09-18'),('2032-09-19'),('2032-09-20'),('2032-09-21'),('2032-09-22'),('2032-09-23'),('2032-09-24'),('2032-09-25'),('2032-09-26'),('2032-09-27'),('2032-09-28'),('2032-09-29'),('2032-09-30'),('2032-10-01'),('2032-10-02'),('2032-10-03'),('2032-10-04'),('2032-10-05'),('2032-10-06'),('2032-10-07'),('2032-10-08'),('2032-10-09'),('2032-10-10'),('2032-10-11'),('2032-10-12'),('2032-10-13'),('2032-10-14'),('2032-10-15'),('2032-10-16'),('2032-10-17'),('2032-10-18'),('2032-10-19'),('2032-10-20'),('2032-10-21'),('2032-10-22'),('2032-10-23'),('2032-10-24'),('2032-10-25'),('2032-10-26'),('2032-10-27'),('2032-10-28'),('2032-10-29'),('2032-10-30'),('2032-10-31'),('2032-11-01'),('2032-11-02'),('2032-11-03'),('2032-11-04'),('2032-11-05'),('2032-11-06'),('2032-11-07'),('2032-11-08'),('2032-11-09'),('2032-11-10'),('2032-11-11'),('2032-11-12'),('2032-11-13'),('2032-11-14'),('2032-11-15'),('2032-11-16'),('2032-11-17'),('2032-11-18'),('2032-11-19'),('2032-11-20'),('2032-11-21'),('2032-11-22'),('2032-11-23'),('2032-11-24'),('2032-11-25'),('2032-11-26'),('2032-11-27'),('2032-11-28'),('2032-11-29'),('2032-11-30'),('2032-12-01'),('2032-12-02'),('2032-12-03'),('2032-12-04'),('2032-12-05'),('2032-12-06'),('2032-12-07'),('2032-12-08'),('2032-12-09'),('2032-12-10'),('2032-12-11'),('2032-12-12'),('2032-12-13'),('2032-12-14'),('2032-12-15'),('2032-12-16'),('2032-12-17'),('2032-12-18'),('2032-12-19'),('2032-12-20'),('2032-12-21'),('2032-12-22'),('2032-12-23'),('2032-12-24'),('2032-12-25'),('2032-12-26'),('2032-12-27'),('2032-12-28'),('2032-12-29'),('2032-12-30'),('2032-12-31'),('2033-01-01'),('2033-01-02'),('2033-01-03'),('2033-01-04'),('2033-01-05'),('2033-01-06'),('2033-01-07'),('2033-01-08'),('2033-01-09'),('2033-01-10'),('2033-01-11'),('2033-01-12'),('2033-01-13'),('2033-01-14'),('2033-01-15'),('2033-01-16'),('2033-01-17'),('2033-01-18'),('2033-01-19'),('2033-01-20'),('2033-01-21'),('2033-01-22'),('2033-01-23'),('2033-01-24'),('2033-01-25'),('2033-01-26'),('2033-01-27'),('2033-01-28'),('2033-01-29'),('2033-01-30'),('2033-01-31'),('2033-02-01'),('2033-02-02'),('2033-02-03'),('2033-02-04'),('2033-02-05'),('2033-02-06'),('2033-02-07'),('2033-02-08'),('2033-02-09'),('2033-02-10'),('2033-02-11'),('2033-02-12'),('2033-02-13'),('2033-02-14'),('2033-02-15'),('2033-02-16'),('2033-02-17'),('2033-02-18'),('2033-02-19'),('2033-02-20'),('2033-02-21'),('2033-02-22'),('2033-02-23'),('2033-02-24'),('2033-02-25'),('2033-02-26'),('2033-02-27'),('2033-02-28'),('2033-03-01'),('2033-03-02'),('2033-03-03'),('2033-03-04'),('2033-03-05'),('2033-03-06'),('2033-03-07'),('2033-03-08'),('2033-03-09'),('2033-03-10'),('2033-03-11'),('2033-03-12'),('2033-03-13'),('2033-03-14'),('2033-03-15'),('2033-03-16'),('2033-03-17'),('2033-03-18'),('2033-03-19'),('2033-03-20'),('2033-03-21'),('2033-03-22'),('2033-03-23'),('2033-03-24'),('2033-03-25'),('2033-03-26'),('2033-03-27'),('2033-03-28'),('2033-03-29'),('2033-03-30'),('2033-03-31'),('2033-04-01'),('2033-04-02'),('2033-04-03'),('2033-04-04'),('2033-04-05'),('2033-04-06'),('2033-04-07'),('2033-04-08'),('2033-04-09'),('2033-04-10'),('2033-04-11'),('2033-04-12'),('2033-04-13'),('2033-04-14'),('2033-04-15'),('2033-04-16'),('2033-04-17'),('2033-04-18'),('2033-04-19'),('2033-04-20'),('2033-04-21'),('2033-04-22'),('2033-04-23'),('2033-04-24'),('2033-04-25'),('2033-04-26'),('2033-04-27'),('2033-04-28'),('2033-04-29'),('2033-04-30'),('2033-05-01'),('2033-05-02'),('2033-05-03'),('2033-05-04'),('2033-05-05'),('2033-05-06'),('2033-05-07'),('2033-05-08'),('2033-05-09'),('2033-05-10'),('2033-05-11'),('2033-05-12'),('2033-05-13'),('2033-05-14'),('2033-05-15'),('2033-05-16'),('2033-05-17'),('2033-05-18'),('2033-05-19'),('2033-05-20'),('2033-05-21'),('2033-05-22'),('2033-05-23'),('2033-05-24'),('2033-05-25'),('2033-05-26'),('2033-05-27'),('2033-05-28'),('2033-05-29'),('2033-05-30'),('2033-05-31'),('2033-06-01'),('2033-06-02'),('2033-06-03'),('2033-06-04'),('2033-06-05'),('2033-06-06'),('2033-06-07'),('2033-06-08'),('2033-06-09'),('2033-06-10'),('2033-06-11'),('2033-06-12'),('2033-06-13'),('2033-06-14'),('2033-06-15'),('2033-06-16'),('2033-06-17'),('2033-06-18'),('2033-06-19'),('2033-06-20'),('2033-06-21'),('2033-06-22'),('2033-06-23'),('2033-06-24'),('2033-06-25'),('2033-06-26'),('2033-06-27'),('2033-06-28'),('2033-06-29'),('2033-06-30'),('2033-07-01'),('2033-07-02'),('2033-07-03'),('2033-07-04'),('2033-07-05'),('2033-07-06'),('2033-07-07'),('2033-07-08'),('2033-07-09'),('2033-07-10'),('2033-07-11'),('2033-07-12'),('2033-07-13'),('2033-07-14'),('2033-07-15'),('2033-07-16'),('2033-07-17'),('2033-07-18'),('2033-07-19'),('2033-07-20'),('2033-07-21'),('2033-07-22'),('2033-07-23'),('2033-07-24'),('2033-07-25'),('2033-07-26'),('2033-07-27'),('2033-07-28'),('2033-07-29'),('2033-07-30'),('2033-07-31'),('2033-08-01'),('2033-08-02'),('2033-08-03'),('2033-08-04'),('2033-08-05'),('2033-08-06'),('2033-08-07'),('2033-08-08'),('2033-08-09'),('2033-08-10'),('2033-08-11'),('2033-08-12'),('2033-08-13'),('2033-08-14'),('2033-08-15'),('2033-08-16'),('2033-08-17'),('2033-08-18'),('2033-08-19'),('2033-08-20'),('2033-08-21'),('2033-08-22'),('2033-08-23'),('2033-08-24'),('2033-08-25'),('2033-08-26'),('2033-08-27'),('2033-08-28'),('2033-08-29'),('2033-08-30'),('2033-08-31'),('2033-09-01'),('2033-09-02'),('2033-09-03'),('2033-09-04'),('2033-09-05'),('2033-09-06'),('2033-09-07'),('2033-09-08'),('2033-09-09'),('2033-09-10'),('2033-09-11'),('2033-09-12'),('2033-09-13'),('2033-09-14'),('2033-09-15'),('2033-09-16'),('2033-09-17'),('2033-09-18'),('2033-09-19'),('2033-09-20'),('2033-09-21'),('2033-09-22'),('2033-09-23'),('2033-09-24'),('2033-09-25'),('2033-09-26'),('2033-09-27'),('2033-09-28'),('2033-09-29'),('2033-09-30'),('2033-10-01'),('2033-10-02'),('2033-10-03'),('2033-10-04'),('2033-10-05'),('2033-10-06'),('2033-10-07'),('2033-10-08'),('2033-10-09'),('2033-10-10'),('2033-10-11'),('2033-10-12'),('2033-10-13'),('2033-10-14'),('2033-10-15'),('2033-10-16'),('2033-10-17'),('2033-10-18'),('2033-10-19'),('2033-10-20'),('2033-10-21'),('2033-10-22'),('2033-10-23'),('2033-10-24'),('2033-10-25'),('2033-10-26'),('2033-10-27'),('2033-10-28'),('2033-10-29'),('2033-10-30'),('2033-10-31'),('2033-11-01'),('2033-11-02'),('2033-11-03'),('2033-11-04'),('2033-11-05'),('2033-11-06'),('2033-11-07'),('2033-11-08'),('2033-11-09'),('2033-11-10'),('2033-11-11'),('2033-11-12'),('2033-11-13'),('2033-11-14'),('2033-11-15'),('2033-11-16'),('2033-11-17'),('2033-11-18'),('2033-11-19'),('2033-11-20'),('2033-11-21'),('2033-11-22'),('2033-11-23'),('2033-11-24'),('2033-11-25'),('2033-11-26'),('2033-11-27'),('2033-11-28'),('2033-11-29'),('2033-11-30'),('2033-12-01'),('2033-12-02'),('2033-12-03'),('2033-12-04'),('2033-12-05'),('2033-12-06'),('2033-12-07'),('2033-12-08'),('2033-12-09'),('2033-12-10'),('2033-12-11'),('2033-12-12'),('2033-12-13'),('2033-12-14'),('2033-12-15'),('2033-12-16'),('2033-12-17'),('2033-12-18'),('2033-12-19'),('2033-12-20'),('2033-12-21'),('2033-12-22'),('2033-12-23'),('2033-12-24'),('2033-12-25'),('2033-12-26'),('2033-12-27'),('2033-12-28'),('2033-12-29'),('2033-12-30'),('2033-12-31'),('2034-01-01'),('2034-01-02'),('2034-01-03'),('2034-01-04'),('2034-01-05'),('2034-01-06'),('2034-01-07'),('2034-01-08'),('2034-01-09'),('2034-01-10'),('2034-01-11'),('2034-01-12'),('2034-01-13'),('2034-01-14'),('2034-01-15'),('2034-01-16'),('2034-01-17'),('2034-01-18'),('2034-01-19'),('2034-01-20'),('2034-01-21'),('2034-01-22'),('2034-01-23'),('2034-01-24'),('2034-01-25'),('2034-01-26'),('2034-01-27'),('2034-01-28'),('2034-01-29'),('2034-01-30'),('2034-01-31'),('2034-02-01'),('2034-02-02'),('2034-02-03'),('2034-02-04'),('2034-02-05'),('2034-02-06'),('2034-02-07'),('2034-02-08'),('2034-02-09'),('2034-02-10'),('2034-02-11'),('2034-02-12'),('2034-02-13'),('2034-02-14'),('2034-02-15'),('2034-02-16'),('2034-02-17'),('2034-02-18'),('2034-02-19'),('2034-02-20'),('2034-02-21'),('2034-02-22'),('2034-02-23'),('2034-02-24'),('2034-02-25'),('2034-02-26'),('2034-02-27'),('2034-02-28'),('2034-03-01'),('2034-03-02'),('2034-03-03'),('2034-03-04'),('2034-03-05'),('2034-03-06'),('2034-03-07'),('2034-03-08'),('2034-03-09'),('2034-03-10'),('2034-03-11'),('2034-03-12'),('2034-03-13'),('2034-03-14'),('2034-03-15'),('2034-03-16'),('2034-03-17'),('2034-03-18'),('2034-03-19'),('2034-03-20'),('2034-03-21'),('2034-03-22'),('2034-03-23'),('2034-03-24'),('2034-03-25'),('2034-03-26'),('2034-03-27'),('2034-03-28'),('2034-03-29'),('2034-03-30'),('2034-03-31'),('2034-04-01'),('2034-04-02'),('2034-04-03'),('2034-04-04'),('2034-04-05'),('2034-04-06'),('2034-04-07'),('2034-04-08'),('2034-04-09'),('2034-04-10'),('2034-04-11'),('2034-04-12'),('2034-04-13'),('2034-04-14'),('2034-04-15'),('2034-04-16'),('2034-04-17'),('2034-04-18'),('2034-04-19'),('2034-04-20'),('2034-04-21'),('2034-04-22'),('2034-04-23'),('2034-04-24'),('2034-04-25'),('2034-04-26'),('2034-04-27'),('2034-04-28'),('2034-04-29'),('2034-04-30'),('2034-05-01'),('2034-05-02'),('2034-05-03'),('2034-05-04'),('2034-05-05'),('2034-05-06'),('2034-05-07'),('2034-05-08'),('2034-05-09'),('2034-05-10'),('2034-05-11'),('2034-05-12'),('2034-05-13'),('2034-05-14'),('2034-05-15'),('2034-05-16'),('2034-05-17'),('2034-05-18'),('2034-05-19'),('2034-05-20'),('2034-05-21'),('2034-05-22'),('2034-05-23'),('2034-05-24'),('2034-05-25'),('2034-05-26'),('2034-05-27'),('2034-05-28'),('2034-05-29'),('2034-05-30'),('2034-05-31'),('2034-06-01'),('2034-06-02'),('2034-06-03'),('2034-06-04'),('2034-06-05'),('2034-06-06'),('2034-06-07'),('2034-06-08'),('2034-06-09'),('2034-06-10'),('2034-06-11'),('2034-06-12'),('2034-06-13'),('2034-06-14'),('2034-06-15'),('2034-06-16'),('2034-06-17'),('2034-06-18'),('2034-06-19'),('2034-06-20'),('2034-06-21'),('2034-06-22'),('2034-06-23'),('2034-06-24'),('2034-06-25'),('2034-06-26'),('2034-06-27'),('2034-06-28'),('2034-06-29'),('2034-06-30'),('2034-07-01'),('2034-07-02'),('2034-07-03'),('2034-07-04'),('2034-07-05'),('2034-07-06'),('2034-07-07'),('2034-07-08'),('2034-07-09'),('2034-07-10'),('2034-07-11'),('2034-07-12'),('2034-07-13'),('2034-07-14'),('2034-07-15'),('2034-07-16'),('2034-07-17'),('2034-07-18'),('2034-07-19'),('2034-07-20'),('2034-07-21'),('2034-07-22'),('2034-07-23'),('2034-07-24'),('2034-07-25'),('2034-07-26'),('2034-07-27'),('2034-07-28'),('2034-07-29'),('2034-07-30'),('2034-07-31'),('2034-08-01'),('2034-08-02'),('2034-08-03'),('2034-08-04'),('2034-08-05'),('2034-08-06'),('2034-08-07'),('2034-08-08'),('2034-08-09'),('2034-08-10'),('2034-08-11'),('2034-08-12'),('2034-08-13'),('2034-08-14'),('2034-08-15'),('2034-08-16'),('2034-08-17'),('2034-08-18'),('2034-08-19'),('2034-08-20'),('2034-08-21'),('2034-08-22'),('2034-08-23'),('2034-08-24'),('2034-08-25'),('2034-08-26'),('2034-08-27'),('2034-08-28'),('2034-08-29'),('2034-08-30'),('2034-08-31'),('2034-09-01'),('2034-09-02'),('2034-09-03'),('2034-09-04'),('2034-09-05'),('2034-09-06'),('2034-09-07'),('2034-09-08'),('2034-09-09'),('2034-09-10'),('2034-09-11'),('2034-09-12'),('2034-09-13'),('2034-09-14'),('2034-09-15'),('2034-09-16'),('2034-09-17'),('2034-09-18'),('2034-09-19'),('2034-09-20'),('2034-09-21'),('2034-09-22'),('2034-09-23'),('2034-09-24'),('2034-09-25'),('2034-09-26'),('2034-09-27'),('2034-09-28'),('2034-09-29'),('2034-09-30'),('2034-10-01'),('2034-10-02'),('2034-10-03'),('2034-10-04'),('2034-10-05'),('2034-10-06'),('2034-10-07'),('2034-10-08'),('2034-10-09'),('2034-10-10'),('2034-10-11'),('2034-10-12'),('2034-10-13'),('2034-10-14'),('2034-10-15'),('2034-10-16'),('2034-10-17'),('2034-10-18'),('2034-10-19'),('2034-10-20'),('2034-10-21'),('2034-10-22'),('2034-10-23'),('2034-10-24'),('2034-10-25'),('2034-10-26'),('2034-10-27'),('2034-10-28'),('2034-10-29'),('2034-10-30'),('2034-10-31'),('2034-11-01'),('2034-11-02'),('2034-11-03'),('2034-11-04'),('2034-11-05'),('2034-11-06'),('2034-11-07'),('2034-11-08'),('2034-11-09'),('2034-11-10'),('2034-11-11'),('2034-11-12'),('2034-11-13'),('2034-11-14'),('2034-11-15'),('2034-11-16'),('2034-11-17'),('2034-11-18'),('2034-11-19'),('2034-11-20'),('2034-11-21'),('2034-11-22'),('2034-11-23'),('2034-11-24'),('2034-11-25'),('2034-11-26'),('2034-11-27'),('2034-11-28'),('2034-11-29'),('2034-11-30'),('2034-12-01'),('2034-12-02'),('2034-12-03'),('2034-12-04'),('2034-12-05'),('2034-12-06'),('2034-12-07'),('2034-12-08'),('2034-12-09'),('2034-12-10'),('2034-12-11'),('2034-12-12'),('2034-12-13'),('2034-12-14'),('2034-12-15'),('2034-12-16'),('2034-12-17'),('2034-12-18'),('2034-12-19'),('2034-12-20'),('2034-12-21'),('2034-12-22'),('2034-12-23'),('2034-12-24'),('2034-12-25'),('2034-12-26'),('2034-12-27'),('2034-12-28'),('2034-12-29'),('2034-12-30'),('2034-12-31'),('2035-01-01'),('2035-01-02'),('2035-01-03'),('2035-01-04'),('2035-01-05'),('2035-01-06'),('2035-01-07'),('2035-01-08'),('2035-01-09'),('2035-01-10'),('2035-01-11'),('2035-01-12'),('2035-01-13'),('2035-01-14'),('2035-01-15'),('2035-01-16'),('2035-01-17'),('2035-01-18'),('2035-01-19'),('2035-01-20'),('2035-01-21'),('2035-01-22'),('2035-01-23'),('2035-01-24'),('2035-01-25'),('2035-01-26'),('2035-01-27'),('2035-01-28'),('2035-01-29'),('2035-01-30'),('2035-01-31'),('2035-02-01'),('2035-02-02'),('2035-02-03'),('2035-02-04'),('2035-02-05'),('2035-02-06'),('2035-02-07'),('2035-02-08'),('2035-02-09'),('2035-02-10'),('2035-02-11'),('2035-02-12'),('2035-02-13'),('2035-02-14'),('2035-02-15'),('2035-02-16'),('2035-02-17'),('2035-02-18'),('2035-02-19'),('2035-02-20'),('2035-02-21'),('2035-02-22'),('2035-02-23'),('2035-02-24'),('2035-02-25'),('2035-02-26'),('2035-02-27'),('2035-02-28'),('2035-03-01'),('2035-03-02'),('2035-03-03'),('2035-03-04'),('2035-03-05'),('2035-03-06'),('2035-03-07'),('2035-03-08'),('2035-03-09'),('2035-03-10'),('2035-03-11'),('2035-03-12'),('2035-03-13'),('2035-03-14'),('2035-03-15'),('2035-03-16'),('2035-03-17'),('2035-03-18'),('2035-03-19'),('2035-03-20'),('2035-03-21'),('2035-03-22'),('2035-03-23'),('2035-03-24'),('2035-03-25'),('2035-03-26'),('2035-03-27'),('2035-03-28'),('2035-03-29'),('2035-03-30'),('2035-03-31'),('2035-04-01'),('2035-04-02'),('2035-04-03'),('2035-04-04'),('2035-04-05'),('2035-04-06'),('2035-04-07'),('2035-04-08'),('2035-04-09'),('2035-04-10'),('2035-04-11'),('2035-04-12'),('2035-04-13'),('2035-04-14'),('2035-04-15'),('2035-04-16'),('2035-04-17'),('2035-04-18'),('2035-04-19'),('2035-04-20'),('2035-04-21'),('2035-04-22'),('2035-04-23'),('2035-04-24'),('2035-04-25'),('2035-04-26'),('2035-04-27'),('2035-04-28'),('2035-04-29'),('2035-04-30'),('2035-05-01'),('2035-05-02'),('2035-05-03'),('2035-05-04'),('2035-05-05'),('2035-05-06'),('2035-05-07'),('2035-05-08'),('2035-05-09'),('2035-05-10'),('2035-05-11'),('2035-05-12'),('2035-05-13'),('2035-05-14'),('2035-05-15'),('2035-05-16'),('2035-05-17'),('2035-05-18'),('2035-05-19'),('2035-05-20'),('2035-05-21'),('2035-05-22'),('2035-05-23'),('2035-05-24'),('2035-05-25'),('2035-05-26'),('2035-05-27'),('2035-05-28'),('2035-05-29'),('2035-05-30'),('2035-05-31'),('2035-06-01'),('2035-06-02'),('2035-06-03'),('2035-06-04'),('2035-06-05'),('2035-06-06'),('2035-06-07'),('2035-06-08'),('2035-06-09'),('2035-06-10'),('2035-06-11'),('2035-06-12'),('2035-06-13'),('2035-06-14'),('2035-06-15'),('2035-06-16'),('2035-06-17'),('2035-06-18'),('2035-06-19'),('2035-06-20'),('2035-06-21'),('2035-06-22'),('2035-06-23'),('2035-06-24'),('2035-06-25'),('2035-06-26'),('2035-06-27'),('2035-06-28'),('2035-06-29'),('2035-06-30'),('2035-07-01'),('2035-07-02'),('2035-07-03'),('2035-07-04'),('2035-07-05'),('2035-07-06'),('2035-07-07'),('2035-07-08'),('2035-07-09'),('2035-07-10'),('2035-07-11'),('2035-07-12'),('2035-07-13'),('2035-07-14'),('2035-07-15'),('2035-07-16'),('2035-07-17'),('2035-07-18'),('2035-07-19'),('2035-07-20'),('2035-07-21'),('2035-07-22'),('2035-07-23'),('2035-07-24'),('2035-07-25'),('2035-07-26'),('2035-07-27'),('2035-07-28'),('2035-07-29'),('2035-07-30'),('2035-07-31'),('2035-08-01'),('2035-08-02'),('2035-08-03'),('2035-08-04'),('2035-08-05'),('2035-08-06'),('2035-08-07'),('2035-08-08'),('2035-08-09'),('2035-08-10'),('2035-08-11'),('2035-08-12'),('2035-08-13'),('2035-08-14'),('2035-08-15'),('2035-08-16'),('2035-08-17'),('2035-08-18'),('2035-08-19'),('2035-08-20'),('2035-08-21'),('2035-08-22'),('2035-08-23'),('2035-08-24'),('2035-08-25'),('2035-08-26'),('2035-08-27'),('2035-08-28'),('2035-08-29'),('2035-08-30'),('2035-08-31'),('2035-09-01'),('2035-09-02'),('2035-09-03'),('2035-09-04'),('2035-09-05'),('2035-09-06'),('2035-09-07'),('2035-09-08'),('2035-09-09'),('2035-09-10'),('2035-09-11'),('2035-09-12'),('2035-09-13'),('2035-09-14'),('2035-09-15'),('2035-09-16'),('2035-09-17'),('2035-09-18'),('2035-09-19'),('2035-09-20'),('2035-09-21'),('2035-09-22'),('2035-09-23'),('2035-09-24'),('2035-09-25'),('2035-09-26'),('2035-09-27'),('2035-09-28'),('2035-09-29'),('2035-09-30'),('2035-10-01'),('2035-10-02'),('2035-10-03'),('2035-10-04'),('2035-10-05'),('2035-10-06'),('2035-10-07'),('2035-10-08'),('2035-10-09'),('2035-10-10'),('2035-10-11'),('2035-10-12'),('2035-10-13'),('2035-10-14'),('2035-10-15'),('2035-10-16'),('2035-10-17'),('2035-10-18'),('2035-10-19'),('2035-10-20'),('2035-10-21'),('2035-10-22'),('2035-10-23'),('2035-10-24'),('2035-10-25'),('2035-10-26'),('2035-10-27'),('2035-10-28'),('2035-10-29'),('2035-10-30'),('2035-10-31'),('2035-11-01'),('2035-11-02'),('2035-11-03'),('2035-11-04'),('2035-11-05'),('2035-11-06'),('2035-11-07'),('2035-11-08'),('2035-11-09'),('2035-11-10'),('2035-11-11'),('2035-11-12'),('2035-11-13'),('2035-11-14'),('2035-11-15'),('2035-11-16'),('2035-11-17'),('2035-11-18'),('2035-11-19'),('2035-11-20'),('2035-11-21'),('2035-11-22'),('2035-11-23'),('2035-11-24'),('2035-11-25'),('2035-11-26'),('2035-11-27'),('2035-11-28'),('2035-11-29'),('2035-11-30'),('2035-12-01'),('2035-12-02'),('2035-12-03'),('2035-12-04'),('2035-12-05'),('2035-12-06'),('2035-12-07'),('2035-12-08'),('2035-12-09'),('2035-12-10'),('2035-12-11'),('2035-12-12'),('2035-12-13'),('2035-12-14'),('2035-12-15'),('2035-12-16'),('2035-12-17'),('2035-12-18'),('2035-12-19'),('2035-12-20'),('2035-12-21'),('2035-12-22'),('2035-12-23'),('2035-12-24'),('2035-12-25'),('2035-12-26'),('2035-12-27'),('2035-12-28'),('2035-12-29'),('2035-12-30'),('2035-12-31'),('2036-01-01'),('2036-01-02'),('2036-01-03'),('2036-01-04'),('2036-01-05'),('2036-01-06'),('2036-01-07'),('2036-01-08'),('2036-01-09'),('2036-01-10'),('2036-01-11'),('2036-01-12'),('2036-01-13'),('2036-01-14'),('2036-01-15'),('2036-01-16'),('2036-01-17'),('2036-01-18'),('2036-01-19'),('2036-01-20'),('2036-01-21'),('2036-01-22'),('2036-01-23'),('2036-01-24'),('2036-01-25'),('2036-01-26'),('2036-01-27'),('2036-01-28'),('2036-01-29'),('2036-01-30'),('2036-01-31'),('2036-02-01'),('2036-02-02'),('2036-02-03'),('2036-02-04'),('2036-02-05'),('2036-02-06'),('2036-02-07'),('2036-02-08'),('2036-02-09'),('2036-02-10'),('2036-02-11'),('2036-02-12'),('2036-02-13'),('2036-02-14'),('2036-02-15'),('2036-02-16'),('2036-02-17'),('2036-02-18'),('2036-02-19'),('2036-02-20'),('2036-02-21'),('2036-02-22'),('2036-02-23'),('2036-02-24'),('2036-02-25'),('2036-02-26'),('2036-02-27'),('2036-02-28'),('2036-02-29'),('2036-03-01'),('2036-03-02'),('2036-03-03'),('2036-03-04'),('2036-03-05'),('2036-03-06'),('2036-03-07'),('2036-03-08'),('2036-03-09'),('2036-03-10'),('2036-03-11'),('2036-03-12'),('2036-03-13'),('2036-03-14'),('2036-03-15'),('2036-03-16'),('2036-03-17'),('2036-03-18'),('2036-03-19'),('2036-03-20'),('2036-03-21'),('2036-03-22'),('2036-03-23'),('2036-03-24'),('2036-03-25'),('2036-03-26'),('2036-03-27'),('2036-03-28'),('2036-03-29'),('2036-03-30'),('2036-03-31'),('2036-04-01'),('2036-04-02'),('2036-04-03'),('2036-04-04'),('2036-04-05'),('2036-04-06'),('2036-04-07'),('2036-04-08'),('2036-04-09'),('2036-04-10'),('2036-04-11'),('2036-04-12'),('2036-04-13'),('2036-04-14'),('2036-04-15'),('2036-04-16'),('2036-04-17'),('2036-04-18'),('2036-04-19'),('2036-04-20'),('2036-04-21'),('2036-04-22'),('2036-04-23'),('2036-04-24'),('2036-04-25'),('2036-04-26'),('2036-04-27'),('2036-04-28'),('2036-04-29'),('2036-04-30'),('2036-05-01'),('2036-05-02'),('2036-05-03'),('2036-05-04'),('2036-05-05'),('2036-05-06'),('2036-05-07'),('2036-05-08'),('2036-05-09'),('2036-05-10'),('2036-05-11'),('2036-05-12'),('2036-05-13'),('2036-05-14'),('2036-05-15'),('2036-05-16'),('2036-05-17'),('2036-05-18'),('2036-05-19'),('2036-05-20'),('2036-05-21'),('2036-05-22'),('2036-05-23'),('2036-05-24'),('2036-05-25'),('2036-05-26'),('2036-05-27'),('2036-05-28'),('2036-05-29'),('2036-05-30'),('2036-05-31'),('2036-06-01'),('2036-06-02'),('2036-06-03'),('2036-06-04'),('2036-06-05'),('2036-06-06'),('2036-06-07'),('2036-06-08'),('2036-06-09'),('2036-06-10'),('2036-06-11'),('2036-06-12'),('2036-06-13'),('2036-06-14'),('2036-06-15'),('2036-06-16'),('2036-06-17'),('2036-06-18'),('2036-06-19'),('2036-06-20'),('2036-06-21'),('2036-06-22'),('2036-06-23'),('2036-06-24'),('2036-06-25'),('2036-06-26'),('2036-06-27'),('2036-06-28'),('2036-06-29'),('2036-06-30'),('2036-07-01'),('2036-07-02'),('2036-07-03'),('2036-07-04'),('2036-07-05'),('2036-07-06'),('2036-07-07'),('2036-07-08'),('2036-07-09'),('2036-07-10'),('2036-07-11'),('2036-07-12'),('2036-07-13'),('2036-07-14'),('2036-07-15'),('2036-07-16'),('2036-07-17'),('2036-07-18'),('2036-07-19'),('2036-07-20'),('2036-07-21'),('2036-07-22'),('2036-07-23'),('2036-07-24'),('2036-07-25'),('2036-07-26'),('2036-07-27'),('2036-07-28'),('2036-07-29'),('2036-07-30'),('2036-07-31'),('2036-08-01'),('2036-08-02'),('2036-08-03'),('2036-08-04'),('2036-08-05'),('2036-08-06'),('2036-08-07'),('2036-08-08'),('2036-08-09'),('2036-08-10'),('2036-08-11'),('2036-08-12'),('2036-08-13'),('2036-08-14'),('2036-08-15'),('2036-08-16'),('2036-08-17'),('2036-08-18'),('2036-08-19'),('2036-08-20'),('2036-08-21'),('2036-08-22'),('2036-08-23'),('2036-08-24'),('2036-08-25'),('2036-08-26'),('2036-08-27'),('2036-08-28'),('2036-08-29'),('2036-08-30'),('2036-08-31'),('2036-09-01'),('2036-09-02'),('2036-09-03'),('2036-09-04'),('2036-09-05'),('2036-09-06'),('2036-09-07'),('2036-09-08'),('2036-09-09'),('2036-09-10'),('2036-09-11'),('2036-09-12'),('2036-09-13'),('2036-09-14'),('2036-09-15'),('2036-09-16'),('2036-09-17'),('2036-09-18'),('2036-09-19'),('2036-09-20'),('2036-09-21'),('2036-09-22'),('2036-09-23'),('2036-09-24'),('2036-09-25'),('2036-09-26'),('2036-09-27'),('2036-09-28'),('2036-09-29'),('2036-09-30'),('2036-10-01'),('2036-10-02'),('2036-10-03'),('2036-10-04'),('2036-10-05'),('2036-10-06'),('2036-10-07'),('2036-10-08'),('2036-10-09'),('2036-10-10'),('2036-10-11'),('2036-10-12'),('2036-10-13'),('2036-10-14'),('2036-10-15'),('2036-10-16'),('2036-10-17'),('2036-10-18'),('2036-10-19'),('2036-10-20'),('2036-10-21'),('2036-10-22'),('2036-10-23'),('2036-10-24'),('2036-10-25'),('2036-10-26'),('2036-10-27'),('2036-10-28'),('2036-10-29'),('2036-10-30'),('2036-10-31'),('2036-11-01'),('2036-11-02'),('2036-11-03'),('2036-11-04'),('2036-11-05'),('2036-11-06'),('2036-11-07'),('2036-11-08'),('2036-11-09'),('2036-11-10'),('2036-11-11'),('2036-11-12'),('2036-11-13'),('2036-11-14'),('2036-11-15'),('2036-11-16'),('2036-11-17'),('2036-11-18'),('2036-11-19'),('2036-11-20'),('2036-11-21'),('2036-11-22'),('2036-11-23'),('2036-11-24'),('2036-11-25'),('2036-11-26'),('2036-11-27'),('2036-11-28'),('2036-11-29'),('2036-11-30'),('2036-12-01'),('2036-12-02'),('2036-12-03'),('2036-12-04'),('2036-12-05'),('2036-12-06'),('2036-12-07'),('2036-12-08'),('2036-12-09'),('2036-12-10'),('2036-12-11'),('2036-12-12'),('2036-12-13'),('2036-12-14'),('2036-12-15'),('2036-12-16'),('2036-12-17'),('2036-12-18'),('2036-12-19'),('2036-12-20'),('2036-12-21'),('2036-12-22'),('2036-12-23'),('2036-12-24'),('2036-12-25'),('2036-12-26'),('2036-12-27'),('2036-12-28'),('2036-12-29'),('2036-12-30'),('2036-12-31'),('2037-01-01'),('2037-01-02'),('2037-01-03'),('2037-01-04'),('2037-01-05'),('2037-01-06'),('2037-01-07'),('2037-01-08'),('2037-01-09'),('2037-01-10'),('2037-01-11'),('2037-01-12'),('2037-01-13'),('2037-01-14'),('2037-01-15'),('2037-01-16'),('2037-01-17'),('2037-01-18'),('2037-01-19'),('2037-01-20'),('2037-01-21'),('2037-01-22'),('2037-01-23'),('2037-01-24'),('2037-01-25'),('2037-01-26'),('2037-01-27'),('2037-01-28'),('2037-01-29'),('2037-01-30'),('2037-01-31'),('2037-02-01'),('2037-02-02'),('2037-02-03'),('2037-02-04'),('2037-02-05'),('2037-02-06'),('2037-02-07'),('2037-02-08'),('2037-02-09'),('2037-02-10'),('2037-02-11'),('2037-02-12'),('2037-02-13'),('2037-02-14'),('2037-02-15'),('2037-02-16'),('2037-02-17'),('2037-02-18'),('2037-02-19'),('2037-02-20'),('2037-02-21'),('2037-02-22'),('2037-02-23'),('2037-02-24'),('2037-02-25'),('2037-02-26'),('2037-02-27'),('2037-02-28'),('2037-03-01'),('2037-03-02'),('2037-03-03'),('2037-03-04'),('2037-03-05'),('2037-03-06'),('2037-03-07'),('2037-03-08'),('2037-03-09'),('2037-03-10'),('2037-03-11'),('2037-03-12'),('2037-03-13'),('2037-03-14'),('2037-03-15'),('2037-03-16'),('2037-03-17'),('2037-03-18'),('2037-03-19'),('2037-03-20'),('2037-03-21'),('2037-03-22'),('2037-03-23'),('2037-03-24'),('2037-03-25'),('2037-03-26'),('2037-03-27'),('2037-03-28'),('2037-03-29'),('2037-03-30'),('2037-03-31'),('2037-04-01'),('2037-04-02'),('2037-04-03'),('2037-04-04'),('2037-04-05'),('2037-04-06'),('2037-04-07'),('2037-04-08'),('2037-04-09'),('2037-04-10'),('2037-04-11'),('2037-04-12'),('2037-04-13'),('2037-04-14'),('2037-04-15'),('2037-04-16'),('2037-04-17'),('2037-04-18'),('2037-04-19'),('2037-04-20'),('2037-04-21'),('2037-04-22'),('2037-04-23'),('2037-04-24'),('2037-04-25'),('2037-04-26'),('2037-04-27'),('2037-04-28'),('2037-04-29'),('2037-04-30'),('2037-05-01'),('2037-05-02'),('2037-05-03'),('2037-05-04'),('2037-05-05'),('2037-05-06'),('2037-05-07'),('2037-05-08'),('2037-05-09'),('2037-05-10'),('2037-05-11'),('2037-05-12'),('2037-05-13'),('2037-05-14'),('2037-05-15'),('2037-05-16'),('2037-05-17'),('2037-05-18'),('2037-05-19'),('2037-05-20'),('2037-05-21'),('2037-05-22'),('2037-05-23'),('2037-05-24'),('2037-05-25'),('2037-05-26'),('2037-05-27'),('2037-05-28'),('2037-05-29'),('2037-05-30'),('2037-05-31'),('2037-06-01'),('2037-06-02'),('2037-06-03'),('2037-06-04'),('2037-06-05'),('2037-06-06'),('2037-06-07'),('2037-06-08'),('2037-06-09'),('2037-06-10'),('2037-06-11'),('2037-06-12'),('2037-06-13'),('2037-06-14'),('2037-06-15'),('2037-06-16'),('2037-06-17'),('2037-06-18'),('2037-06-19'),('2037-06-20'),('2037-06-21'),('2037-06-22'),('2037-06-23'),('2037-06-24'),('2037-06-25'),('2037-06-26'),('2037-06-27'),('2037-06-28'),('2037-06-29'),('2037-06-30'),('2037-07-01'),('2037-07-02'),('2037-07-03'),('2037-07-04'),('2037-07-05'),('2037-07-06'),('2037-07-07'),('2037-07-08'),('2037-07-09'),('2037-07-10'),('2037-07-11'),('2037-07-12'),('2037-07-13'),('2037-07-14'),('2037-07-15'),('2037-07-16'),('2037-07-17'),('2037-07-18'),('2037-07-19'),('2037-07-20'),('2037-07-21'),('2037-07-22'),('2037-07-23'),('2037-07-24'),('2037-07-25'),('2037-07-26'),('2037-07-27'),('2037-07-28'),('2037-07-29'),('2037-07-30'),('2037-07-31'),('2037-08-01'),('2037-08-02'),('2037-08-03'),('2037-08-04'),('2037-08-05'),('2037-08-06'),('2037-08-07'),('2037-08-08'),('2037-08-09'),('2037-08-10'),('2037-08-11'),('2037-08-12'),('2037-08-13'),('2037-08-14'),('2037-08-15'),('2037-08-16'),('2037-08-17'),('2037-08-18'),('2037-08-19'),('2037-08-20'),('2037-08-21'),('2037-08-22'),('2037-08-23'),('2037-08-24'),('2037-08-25'),('2037-08-26'),('2037-08-27'),('2037-08-28'),('2037-08-29'),('2037-08-30'),('2037-08-31'),('2037-09-01'),('2037-09-02'),('2037-09-03'),('2037-09-04'),('2037-09-05'),('2037-09-06'),('2037-09-07'),('2037-09-08'),('2037-09-09'),('2037-09-10'),('2037-09-11'),('2037-09-12'),('2037-09-13'),('2037-09-14'),('2037-09-15'),('2037-09-16'),('2037-09-17'),('2037-09-18'),('2037-09-19'),('2037-09-20'),('2037-09-21'),('2037-09-22'),('2037-09-23'),('2037-09-24'),('2037-09-25'),('2037-09-26'),('2037-09-27'),('2037-09-28'),('2037-09-29'),('2037-09-30'),('2037-10-01'),('2037-10-02'),('2037-10-03'),('2037-10-04'),('2037-10-05'),('2037-10-06'),('2037-10-07'),('2037-10-08'),('2037-10-09'),('2037-10-10'),('2037-10-11'),('2037-10-12'),('2037-10-13'),('2037-10-14'),('2037-10-15'),('2037-10-16'),('2037-10-17'),('2037-10-18'),('2037-10-19'),('2037-10-20'),('2037-10-21'),('2037-10-22'),('2037-10-23'),('2037-10-24'),('2037-10-25'),('2037-10-26'),('2037-10-27'),('2037-10-28'),('2037-10-29'),('2037-10-30'),('2037-10-31'),('2037-11-01'),('2037-11-02'),('2037-11-03'),('2037-11-04'),('2037-11-05'),('2037-11-06'),('2037-11-07'),('2037-11-08'),('2037-11-09'),('2037-11-10'),('2037-11-11'),('2037-11-12'),('2037-11-13'),('2037-11-14'),('2037-11-15'),('2037-11-16'),('2037-11-17'),('2037-11-18'),('2037-11-19'),('2037-11-20'),('2037-11-21'),('2037-11-22'),('2037-11-23'),('2037-11-24'),('2037-11-25'),('2037-11-26'),('2037-11-27'),('2037-11-28'),('2037-11-29'),('2037-11-30'),('2037-12-01'),('2037-12-02'),('2037-12-03'),('2037-12-04'),('2037-12-05'),('2037-12-06'),('2037-12-07'),('2037-12-08'),('2037-12-09'),('2037-12-10'),('2037-12-11'),('2037-12-12'),('2037-12-13'),('2037-12-14'),('2037-12-15'),('2037-12-16'),('2037-12-17'),('2037-12-18'),('2037-12-19'),('2037-12-20'),('2037-12-21'),('2037-12-22'),('2037-12-23'),('2037-12-24'),('2037-12-25'),('2037-12-26'),('2037-12-27'),('2037-12-28'),('2037-12-29'),('2037-12-30'),('2037-12-31'),('2038-01-01'),('2038-01-02'),('2038-01-03'),('2038-01-04'),('2038-01-05'),('2038-01-06'),('2038-01-07'),('2038-01-08'),('2038-01-09'),('2038-01-10'),('2038-01-11'),('2038-01-12'),('2038-01-13'),('2038-01-14'),('2038-01-15'),('2038-01-16'),('2038-01-17'),('2038-01-18'),('2038-01-19'),('2038-01-20'),('2038-01-21'),('2038-01-22'),('2038-01-23'),('2038-01-24'),('2038-01-25'),('2038-01-26'),('2038-01-27'),('2038-01-28'),('2038-01-29'),('2038-01-30'),('2038-01-31'),('2038-02-01'),('2038-02-02'),('2038-02-03'),('2038-02-04'),('2038-02-05'),('2038-02-06'),('2038-02-07'),('2038-02-08'),('2038-02-09'),('2038-02-10'),('2038-02-11'),('2038-02-12'),('2038-02-13'),('2038-02-14'),('2038-02-15'),('2038-02-16'),('2038-02-17'),('2038-02-18'),('2038-02-19'),('2038-02-20'),('2038-02-21'),('2038-02-22'),('2038-02-23'),('2038-02-24'),('2038-02-25'),('2038-02-26'),('2038-02-27'),('2038-02-28'),('2038-03-01'),('2038-03-02'),('2038-03-03'),('2038-03-04'),('2038-03-05'),('2038-03-06'),('2038-03-07'),('2038-03-08'),('2038-03-09'),('2038-03-10'),('2038-03-11'),('2038-03-12'),('2038-03-13'),('2038-03-14'),('2038-03-15'),('2038-03-16'),('2038-03-17'),('2038-03-18'),('2038-03-19'),('2038-03-20'),('2038-03-21'),('2038-03-22'),('2038-03-23'),('2038-03-24'),('2038-03-25'),('2038-03-26'),('2038-03-27'),('2038-03-28'),('2038-03-29'),('2038-03-30'),('2038-03-31'),('2038-04-01'),('2038-04-02'),('2038-04-03'),('2038-04-04'),('2038-04-05'),('2038-04-06'),('2038-04-07'),('2038-04-08'),('2038-04-09'),('2038-04-10'),('2038-04-11'),('2038-04-12'),('2038-04-13'),('2038-04-14'),('2038-04-15'),('2038-04-16'),('2038-04-17'),('2038-04-18'),('2038-04-19'),('2038-04-20'),('2038-04-21'),('2038-04-22'),('2038-04-23'),('2038-04-24'),('2038-04-25'),('2038-04-26'),('2038-04-27'),('2038-04-28'),('2038-04-29'),('2038-04-30'),('2038-05-01'),('2038-05-02'),('2038-05-03'),('2038-05-04'),('2038-05-05'),('2038-05-06'),('2038-05-07'),('2038-05-08'),('2038-05-09'),('2038-05-10'),('2038-05-11'),('2038-05-12'),('2038-05-13'),('2038-05-14'),('2038-05-15'),('2038-05-16'),('2038-05-17'),('2038-05-18'),('2038-05-19'),('2038-05-20'),('2038-05-21'),('2038-05-22'),('2038-05-23'),('2038-05-24'),('2038-05-25'),('2038-05-26'),('2038-05-27'),('2038-05-28'),('2038-05-29'),('2038-05-30'),('2038-05-31'),('2038-06-01'),('2038-06-02'),('2038-06-03'),('2038-06-04'),('2038-06-05'),('2038-06-06'),('2038-06-07'),('2038-06-08'),('2038-06-09'),('2038-06-10'),('2038-06-11'),('2038-06-12'),('2038-06-13'),('2038-06-14'),('2038-06-15'),('2038-06-16'),('2038-06-17'),('2038-06-18'),('2038-06-19'),('2038-06-20'),('2038-06-21'),('2038-06-22'),('2038-06-23'),('2038-06-24'),('2038-06-25'),('2038-06-26'),('2038-06-27'),('2038-06-28'),('2038-06-29'),('2038-06-30'),('2038-07-01'),('2038-07-02'),('2038-07-03'),('2038-07-04'),('2038-07-05'),('2038-07-06'),('2038-07-07'),('2038-07-08'),('2038-07-09'),('2038-07-10'),('2038-07-11'),('2038-07-12'),('2038-07-13'),('2038-07-14'),('2038-07-15'),('2038-07-16'),('2038-07-17'),('2038-07-18'),('2038-07-19'),('2038-07-20'),('2038-07-21'),('2038-07-22'),('2038-07-23'),('2038-07-24'),('2038-07-25'),('2038-07-26'),('2038-07-27'),('2038-07-28'),('2038-07-29'),('2038-07-30'),('2038-07-31'),('2038-08-01'),('2038-08-02'),('2038-08-03'),('2038-08-04'),('2038-08-05'),('2038-08-06'),('2038-08-07'),('2038-08-08'),('2038-08-09'),('2038-08-10'),('2038-08-11'),('2038-08-12'),('2038-08-13'),('2038-08-14'),('2038-08-15'),('2038-08-16'),('2038-08-17'),('2038-08-18'),('2038-08-19'),('2038-08-20'),('2038-08-21'),('2038-08-22'),('2038-08-23'),('2038-08-24'),('2038-08-25'),('2038-08-26'),('2038-08-27'),('2038-08-28'),('2038-08-29'),('2038-08-30'),('2038-08-31'),('2038-09-01'),('2038-09-02'),('2038-09-03'),('2038-09-04'),('2038-09-05'),('2038-09-06'),('2038-09-07'),('2038-09-08'),('2038-09-09'),('2038-09-10'),('2038-09-11'),('2038-09-12'),('2038-09-13'),('2038-09-14'),('2038-09-15'),('2038-09-16'),('2038-09-17'),('2038-09-18'),('2038-09-19'),('2038-09-20'),('2038-09-21'),('2038-09-22'),('2038-09-23'),('2038-09-24'),('2038-09-25'),('2038-09-26'),('2038-09-27'),('2038-09-28'),('2038-09-29'),('2038-09-30'),('2038-10-01'),('2038-10-02'),('2038-10-03'),('2038-10-04'),('2038-10-05'),('2038-10-06'),('2038-10-07'),('2038-10-08'),('2038-10-09'),('2038-10-10'),('2038-10-11'),('2038-10-12'),('2038-10-13'),('2038-10-14'),('2038-10-15'),('2038-10-16'),('2038-10-17'),('2038-10-18'),('2038-10-19'),('2038-10-20'),('2038-10-21'),('2038-10-22'),('2038-10-23'),('2038-10-24'),('2038-10-25'),('2038-10-26'),('2038-10-27'),('2038-10-28'),('2038-10-29'),('2038-10-30'),('2038-10-31'),('2038-11-01'),('2038-11-02'),('2038-11-03'),('2038-11-04'),('2038-11-05'),('2038-11-06'),('2038-11-07'),('2038-11-08'),('2038-11-09'),('2038-11-10'),('2038-11-11'),('2038-11-12'),('2038-11-13'),('2038-11-14'),('2038-11-15'),('2038-11-16'),('2038-11-17'),('2038-11-18'),('2038-11-19'),('2038-11-20'),('2038-11-21'),('2038-11-22'),('2038-11-23'),('2038-11-24'),('2038-11-25'),('2038-11-26'),('2038-11-27'),('2038-11-28'),('2038-11-29'),('2038-11-30'),('2038-12-01'),('2038-12-02'),('2038-12-03'),('2038-12-04'),('2038-12-05'),('2038-12-06'),('2038-12-07'),('2038-12-08'),('2038-12-09'),('2038-12-10'),('2038-12-11'),('2038-12-12'),('2038-12-13'),('2038-12-14'),('2038-12-15'),('2038-12-16'),('2038-12-17'),('2038-12-18'),('2038-12-19'),('2038-12-20'),('2038-12-21'),('2038-12-22'),('2038-12-23'),('2038-12-24'),('2038-12-25'),('2038-12-26'),('2038-12-27'),('2038-12-28'),('2038-12-29'),('2038-12-30'),('2038-12-31'),('2039-01-01'),('2039-01-02'),('2039-01-03'),('2039-01-04'),('2039-01-05'),('2039-01-06'),('2039-01-07'),('2039-01-08'),('2039-01-09'),('2039-01-10'),('2039-01-11'),('2039-01-12'),('2039-01-13'),('2039-01-14'),('2039-01-15'),('2039-01-16'),('2039-01-17'),('2039-01-18'),('2039-01-19'),('2039-01-20'),('2039-01-21'),('2039-01-22'),('2039-01-23'),('2039-01-24'),('2039-01-25'),('2039-01-26'),('2039-01-27'),('2039-01-28'),('2039-01-29'),('2039-01-30'),('2039-01-31'),('2039-02-01'),('2039-02-02'),('2039-02-03'),('2039-02-04'),('2039-02-05'),('2039-02-06'),('2039-02-07'),('2039-02-08'),('2039-02-09'),('2039-02-10'),('2039-02-11'),('2039-02-12'),('2039-02-13'),('2039-02-14'),('2039-02-15'),('2039-02-16'),('2039-02-17'),('2039-02-18'),('2039-02-19'),('2039-02-20'),('2039-02-21'),('2039-02-22'),('2039-02-23'),('2039-02-24'),('2039-02-25'),('2039-02-26'),('2039-02-27'),('2039-02-28'),('2039-03-01'),('2039-03-02'),('2039-03-03'),('2039-03-04'),('2039-03-05'),('2039-03-06'),('2039-03-07'),('2039-03-08'),('2039-03-09'),('2039-03-10'),('2039-03-11'),('2039-03-12'),('2039-03-13'),('2039-03-14'),('2039-03-15'),('2039-03-16'),('2039-03-17'),('2039-03-18'),('2039-03-19'),('2039-03-20'),('2039-03-21'),('2039-03-22'),('2039-03-23'),('2039-03-24'),('2039-03-25'),('2039-03-26'),('2039-03-27'),('2039-03-28'),('2039-03-29'),('2039-03-30'),('2039-03-31'),('2039-04-01'),('2039-04-02'),('2039-04-03'),('2039-04-04'),('2039-04-05'),('2039-04-06'),('2039-04-07'),('2039-04-08'),('2039-04-09'),('2039-04-10'),('2039-04-11'),('2039-04-12'),('2039-04-13'),('2039-04-14'),('2039-04-15'),('2039-04-16'),('2039-04-17'),('2039-04-18'),('2039-04-19'),('2039-04-20'),('2039-04-21'),('2039-04-22'),('2039-04-23'),('2039-04-24'),('2039-04-25'),('2039-04-26'),('2039-04-27'),('2039-04-28'),('2039-04-29'),('2039-04-30'),('2039-05-01'),('2039-05-02'),('2039-05-03'),('2039-05-04'),('2039-05-05'),('2039-05-06'),('2039-05-07'),('2039-05-08'),('2039-05-09'),('2039-05-10'),('2039-05-11'),('2039-05-12'),('2039-05-13'),('2039-05-14'),('2039-05-15'),('2039-05-16'),('2039-05-17'),('2039-05-18'),('2039-05-19'),('2039-05-20'),('2039-05-21'),('2039-05-22'),('2039-05-23'),('2039-05-24'),('2039-05-25'),('2039-05-26'),('2039-05-27'),('2039-05-28'),('2039-05-29'),('2039-05-30'),('2039-05-31'),('2039-06-01'),('2039-06-02'),('2039-06-03'),('2039-06-04'),('2039-06-05'),('2039-06-06'),('2039-06-07'),('2039-06-08'),('2039-06-09'),('2039-06-10'),('2039-06-11'),('2039-06-12'),('2039-06-13'),('2039-06-14'),('2039-06-15'),('2039-06-16'),('2039-06-17'),('2039-06-18'),('2039-06-19'),('2039-06-20'),('2039-06-21'),('2039-06-22'),('2039-06-23'),('2039-06-24'),('2039-06-25'),('2039-06-26'),('2039-06-27'),('2039-06-28'),('2039-06-29'),('2039-06-30'),('2039-07-01'),('2039-07-02'),('2039-07-03'),('2039-07-04'),('2039-07-05'),('2039-07-06'),('2039-07-07'),('2039-07-08'),('2039-07-09'),('2039-07-10'),('2039-07-11'),('2039-07-12'),('2039-07-13'),('2039-07-14'),('2039-07-15'),('2039-07-16'),('2039-07-17'),('2039-07-18'),('2039-07-19'),('2039-07-20'),('2039-07-21'),('2039-07-22'),('2039-07-23'),('2039-07-24'),('2039-07-25'),('2039-07-26'),('2039-07-27'),('2039-07-28'),('2039-07-29'),('2039-07-30'),('2039-07-31'),('2039-08-01'),('2039-08-02'),('2039-08-03'),('2039-08-04'),('2039-08-05'),('2039-08-06'),('2039-08-07'),('2039-08-08'),('2039-08-09'),('2039-08-10'),('2039-08-11'),('2039-08-12'),('2039-08-13'),('2039-08-14'),('2039-08-15'),('2039-08-16'),('2039-08-17'),('2039-08-18'),('2039-08-19'),('2039-08-20'),('2039-08-21'),('2039-08-22'),('2039-08-23'),('2039-08-24'),('2039-08-25'),('2039-08-26'),('2039-08-27'),('2039-08-28'),('2039-08-29'),('2039-08-30'),('2039-08-31'),('2039-09-01'),('2039-09-02'),('2039-09-03'),('2039-09-04'),('2039-09-05'),('2039-09-06'),('2039-09-07'),('2039-09-08'),('2039-09-09'),('2039-09-10'),('2039-09-11'),('2039-09-12'),('2039-09-13'),('2039-09-14'),('2039-09-15'),('2039-09-16'),('2039-09-17'),('2039-09-18'),('2039-09-19'),('2039-09-20'),('2039-09-21'),('2039-09-22'),('2039-09-23'),('2039-09-24'),('2039-09-25'),('2039-09-26'),('2039-09-27'),('2039-09-28'),('2039-09-29'),('2039-09-30'),('2039-10-01'),('2039-10-02'),('2039-10-03'),('2039-10-04'),('2039-10-05'),('2039-10-06'),('2039-10-07'),('2039-10-08'),('2039-10-09'),('2039-10-10'),('2039-10-11'),('2039-10-12'),('2039-10-13'),('2039-10-14'),('2039-10-15'),('2039-10-16'),('2039-10-17'),('2039-10-18'),('2039-10-19'),('2039-10-20'),('2039-10-21'),('2039-10-22'),('2039-10-23'),('2039-10-24'),('2039-10-25'),('2039-10-26'),('2039-10-27'),('2039-10-28'),('2039-10-29'),('2039-10-30'),('2039-10-31'),('2039-11-01'),('2039-11-02'),('2039-11-03'),('2039-11-04'),('2039-11-05'),('2039-11-06'),('2039-11-07'),('2039-11-08'),('2039-11-09'),('2039-11-10'),('2039-11-11'),('2039-11-12'),('2039-11-13'),('2039-11-14'),('2039-11-15'),('2039-11-16'),('2039-11-17'),('2039-11-18'),('2039-11-19'),('2039-11-20'),('2039-11-21'),('2039-11-22'),('2039-11-23'),('2039-11-24'),('2039-11-25'),('2039-11-26'),('2039-11-27'),('2039-11-28'),('2039-11-29'),('2039-11-30'),('2039-12-01'),('2039-12-02'),('2039-12-03'),('2039-12-04'),('2039-12-05'),('2039-12-06'),('2039-12-07'),('2039-12-08'),('2039-12-09'),('2039-12-10'),('2039-12-11'),('2039-12-12'),('2039-12-13'),('2039-12-14'),('2039-12-15'),('2039-12-16'),('2039-12-17'),('2039-12-18'),('2039-12-19'),('2039-12-20'),('2039-12-21'),('2039-12-22'),('2039-12-23'),('2039-12-24'),('2039-12-25'),('2039-12-26'),('2039-12-27'),('2039-12-28'),('2039-12-29'),('2039-12-30'),('2039-12-31'),('2040-01-01'),('2040-01-02'),('2040-01-03'),('2040-01-04'),('2040-01-05'),('2040-01-06'),('2040-01-07'),('2040-01-08'),('2040-01-09'),('2040-01-10'),('2040-01-11'),('2040-01-12'),('2040-01-13'),('2040-01-14'),('2040-01-15'),('2040-01-16'),('2040-01-17'),('2040-01-18'),('2040-01-19'),('2040-01-20'),('2040-01-21'),('2040-01-22'),('2040-01-23'),('2040-01-24'),('2040-01-25'),('2040-01-26'),('2040-01-27'),('2040-01-28'),('2040-01-29'),('2040-01-30'),('2040-01-31'),('2040-02-01'),('2040-02-02'),('2040-02-03'),('2040-02-04'),('2040-02-05'),('2040-02-06'),('2040-02-07'),('2040-02-08'),('2040-02-09'),('2040-02-10'),('2040-02-11'),('2040-02-12'),('2040-02-13'),('2040-02-14'),('2040-02-15'),('2040-02-16'),('2040-02-17'),('2040-02-18'),('2040-02-19'),('2040-02-20'),('2040-02-21'),('2040-02-22'),('2040-02-23'),('2040-02-24'),('2040-02-25'),('2040-02-26'),('2040-02-27'),('2040-02-28'),('2040-02-29'),('2040-03-01'),('2040-03-02'),('2040-03-03'),('2040-03-04'),('2040-03-05'),('2040-03-06'),('2040-03-07'),('2040-03-08'),('2040-03-09'),('2040-03-10'),('2040-03-11'),('2040-03-12'),('2040-03-13'),('2040-03-14'),('2040-03-15'),('2040-03-16'),('2040-03-17'),('2040-03-18'),('2040-03-19'),('2040-03-20'),('2040-03-21'),('2040-03-22'),('2040-03-23'),('2040-03-24'),('2040-03-25'),('2040-03-26'),('2040-03-27'),('2040-03-28'),('2040-03-29'),('2040-03-30'),('2040-03-31'),('2040-04-01'),('2040-04-02'),('2040-04-03'),('2040-04-04'),('2040-04-05'),('2040-04-06'),('2040-04-07'),('2040-04-08'),('2040-04-09'),('2040-04-10'),('2040-04-11'),('2040-04-12'),('2040-04-13'),('2040-04-14'),('2040-04-15'),('2040-04-16'),('2040-04-17'),('2040-04-18'),('2040-04-19'),('2040-04-20'),('2040-04-21'),('2040-04-22'),('2040-04-23'),('2040-04-24'),('2040-04-25'),('2040-04-26'),('2040-04-27'),('2040-04-28'),('2040-04-29'),('2040-04-30'),('2040-05-01'),('2040-05-02'),('2040-05-03'),('2040-05-04'),('2040-05-05'),('2040-05-06'),('2040-05-07'),('2040-05-08'),('2040-05-09'),('2040-05-10'),('2040-05-11'),('2040-05-12'),('2040-05-13'),('2040-05-14'),('2040-05-15'),('2040-05-16'),('2040-05-17'),('2040-05-18'),('2040-05-19'),('2040-05-20'),('2040-05-21'),('2040-05-22'),('2040-05-23'),('2040-05-24'),('2040-05-25'),('2040-05-26'),('2040-05-27'),('2040-05-28'),('2040-05-29'),('2040-05-30'),('2040-05-31'),('2040-06-01'),('2040-06-02'),('2040-06-03'),('2040-06-04'),('2040-06-05'),('2040-06-06'),('2040-06-07'),('2040-06-08'),('2040-06-09'),('2040-06-10'),('2040-06-11'),('2040-06-12'),('2040-06-13'),('2040-06-14'),('2040-06-15'),('2040-06-16'),('2040-06-17'),('2040-06-18'),('2040-06-19'),('2040-06-20'),('2040-06-21'),('2040-06-22'),('2040-06-23'),('2040-06-24'),('2040-06-25'),('2040-06-26'),('2040-06-27'),('2040-06-28'),('2040-06-29'),('2040-06-30'),('2040-07-01'),('2040-07-02'),('2040-07-03'),('2040-07-04'),('2040-07-05'),('2040-07-06'),('2040-07-07'),('2040-07-08'),('2040-07-09'),('2040-07-10'),('2040-07-11'),('2040-07-12'),('2040-07-13'),('2040-07-14'),('2040-07-15'),('2040-07-16'),('2040-07-17'),('2040-07-18'),('2040-07-19'),('2040-07-20'),('2040-07-21'),('2040-07-22'),('2040-07-23'),('2040-07-24'),('2040-07-25'),('2040-07-26'),('2040-07-27'),('2040-07-28'),('2040-07-29'),('2040-07-30'),('2040-07-31'),('2040-08-01'),('2040-08-02'),('2040-08-03'),('2040-08-04'),('2040-08-05'),('2040-08-06'),('2040-08-07'),('2040-08-08'),('2040-08-09'),('2040-08-10'),('2040-08-11'),('2040-08-12'),('2040-08-13'),('2040-08-14'),('2040-08-15'),('2040-08-16'),('2040-08-17'),('2040-08-18'),('2040-08-19'),('2040-08-20'),('2040-08-21'),('2040-08-22'),('2040-08-23'),('2040-08-24'),('2040-08-25'),('2040-08-26'),('2040-08-27'),('2040-08-28'),('2040-08-29'),('2040-08-30'),('2040-08-31'),('2040-09-01'),('2040-09-02'),('2040-09-03'),('2040-09-04'),('2040-09-05'),('2040-09-06'),('2040-09-07'),('2040-09-08'),('2040-09-09'),('2040-09-10'),('2040-09-11'),('2040-09-12'),('2040-09-13'),('2040-09-14'),('2040-09-15'),('2040-09-16'),('2040-09-17'),('2040-09-18'),('2040-09-19'),('2040-09-20'),('2040-09-21'),('2040-09-22'),('2040-09-23'),('2040-09-24'),('2040-09-25'),('2040-09-26'),('2040-09-27'),('2040-09-28'),('2040-09-29'),('2040-09-30'),('2040-10-01'),('2040-10-02'),('2040-10-03'),('2040-10-04'),('2040-10-05'),('2040-10-06'),('2040-10-07'),('2040-10-08'),('2040-10-09'),('2040-10-10'),('2040-10-11'),('2040-10-12'),('2040-10-13'),('2040-10-14'),('2040-10-15'),('2040-10-16'),('2040-10-17'),('2040-10-18'),('2040-10-19'),('2040-10-20'),('2040-10-21'),('2040-10-22'),('2040-10-23'),('2040-10-24'),('2040-10-25'),('2040-10-26'),('2040-10-27'),('2040-10-28'),('2040-10-29'),('2040-10-30'),('2040-10-31'),('2040-11-01'),('2040-11-02'),('2040-11-03'),('2040-11-04'),('2040-11-05'),('2040-11-06'),('2040-11-07'),('2040-11-08'),('2040-11-09'),('2040-11-10'),('2040-11-11'),('2040-11-12'),('2040-11-13'),('2040-11-14'),('2040-11-15'),('2040-11-16'),('2040-11-17'),('2040-11-18'),('2040-11-19'),('2040-11-20'),('2040-11-21'),('2040-11-22'),('2040-11-23'),('2040-11-24'),('2040-11-25'),('2040-11-26'),('2040-11-27'),('2040-11-28'),('2040-11-29'),('2040-11-30'),('2040-12-01'),('2040-12-02'),('2040-12-03'),('2040-12-04'),('2040-12-05'),('2040-12-06'),('2040-12-07'),('2040-12-08'),('2040-12-09'),('2040-12-10'),('2040-12-11'),('2040-12-12'),('2040-12-13'),('2040-12-14'),('2040-12-15'),('2040-12-16'),('2040-12-17'),('2040-12-18'),('2040-12-19'),('2040-12-20'),('2040-12-21'),('2040-12-22'),('2040-12-23'),('2040-12-24'),('2040-12-25'),('2040-12-26'),('2040-12-27'),('2040-12-28'),('2040-12-29'),('2040-12-30'),('2040-12-31'),('2041-01-01'),('2041-01-02'),('2041-01-03'),('2041-01-04'),('2041-01-05'),('2041-01-06'),('2041-01-07'),('2041-01-08'),('2041-01-09'),('2041-01-10'),('2041-01-11'),('2041-01-12'),('2041-01-13'),('2041-01-14'),('2041-01-15'),('2041-01-16'),('2041-01-17'),('2041-01-18'),('2041-01-19'),('2041-01-20'),('2041-01-21'),('2041-01-22'),('2041-01-23'),('2041-01-24'),('2041-01-25'),('2041-01-26'),('2041-01-27'),('2041-01-28'),('2041-01-29'),('2041-01-30'),('2041-01-31'),('2041-02-01'),('2041-02-02'),('2041-02-03'),('2041-02-04'),('2041-02-05'),('2041-02-06'),('2041-02-07'),('2041-02-08'),('2041-02-09'),('2041-02-10'),('2041-02-11'),('2041-02-12'),('2041-02-13'),('2041-02-14'),('2041-02-15'),('2041-02-16'),('2041-02-17'),('2041-02-18'),('2041-02-19'),('2041-02-20'),('2041-02-21'),('2041-02-22'),('2041-02-23'),('2041-02-24'),('2041-02-25'),('2041-02-26'),('2041-02-27'),('2041-02-28'),('2041-03-01'),('2041-03-02'),('2041-03-03'),('2041-03-04'),('2041-03-05'),('2041-03-06'),('2041-03-07'),('2041-03-08'),('2041-03-09'),('2041-03-10'),('2041-03-11'),('2041-03-12'),('2041-03-13'),('2041-03-14'),('2041-03-15'),('2041-03-16'),('2041-03-17'),('2041-03-18'),('2041-03-19'),('2041-03-20'),('2041-03-21'),('2041-03-22'),('2041-03-23'),('2041-03-24'),('2041-03-25'),('2041-03-26'),('2041-03-27'),('2041-03-28'),('2041-03-29'),('2041-03-30'),('2041-03-31'),('2041-04-01'),('2041-04-02'),('2041-04-03'),('2041-04-04'),('2041-04-05'),('2041-04-06'),('2041-04-07'),('2041-04-08'),('2041-04-09'),('2041-04-10'),('2041-04-11'),('2041-04-12'),('2041-04-13'),('2041-04-14'),('2041-04-15'),('2041-04-16'),('2041-04-17'),('2041-04-18'),('2041-04-19'),('2041-04-20'),('2041-04-21'),('2041-04-22'),('2041-04-23'),('2041-04-24'),('2041-04-25'),('2041-04-26'),('2041-04-27'),('2041-04-28'),('2041-04-29'),('2041-04-30'),('2041-05-01'),('2041-05-02'),('2041-05-03'),('2041-05-04'),('2041-05-05'),('2041-05-06'),('2041-05-07'),('2041-05-08'),('2041-05-09'),('2041-05-10'),('2041-05-11'),('2041-05-12'),('2041-05-13'),('2041-05-14'),('2041-05-15'),('2041-05-16'),('2041-05-17'),('2041-05-18'),('2041-05-19'),('2041-05-20'),('2041-05-21'),('2041-05-22'),('2041-05-23'),('2041-05-24'),('2041-05-25'),('2041-05-26'),('2041-05-27'),('2041-05-28'),('2041-05-29'),('2041-05-30'),('2041-05-31'),('2041-06-01'),('2041-06-02'),('2041-06-03'),('2041-06-04'),('2041-06-05'),('2041-06-06'),('2041-06-07'),('2041-06-08'),('2041-06-09'),('2041-06-10'),('2041-06-11'),('2041-06-12'),('2041-06-13'),('2041-06-14'),('2041-06-15'),('2041-06-16'),('2041-06-17'),('2041-06-18'),('2041-06-19'),('2041-06-20'),('2041-06-21'),('2041-06-22'),('2041-06-23'),('2041-06-24'),('2041-06-25'),('2041-06-26'),('2041-06-27'),('2041-06-28'),('2041-06-29'),('2041-06-30'),('2041-07-01'),('2041-07-02'),('2041-07-03'),('2041-07-04'),('2041-07-05'),('2041-07-06'),('2041-07-07'),('2041-07-08'),('2041-07-09'),('2041-07-10'),('2041-07-11'),('2041-07-12'),('2041-07-13'),('2041-07-14'),('2041-07-15'),('2041-07-16'),('2041-07-17'),('2041-07-18'),('2041-07-19'),('2041-07-20'),('2041-07-21'),('2041-07-22'),('2041-07-23'),('2041-07-24'),('2041-07-25'),('2041-07-26'),('2041-07-27'),('2041-07-28'),('2041-07-29'),('2041-07-30'),('2041-07-31'),('2041-08-01'),('2041-08-02'),('2041-08-03'),('2041-08-04'),('2041-08-05'),('2041-08-06'),('2041-08-07'),('2041-08-08'),('2041-08-09'),('2041-08-10'),('2041-08-11'),('2041-08-12'),('2041-08-13'),('2041-08-14'),('2041-08-15'),('2041-08-16'),('2041-08-17'),('2041-08-18'),('2041-08-19'),('2041-08-20'),('2041-08-21'),('2041-08-22'),('2041-08-23'),('2041-08-24'),('2041-08-25'),('2041-08-26'),('2041-08-27'),('2041-08-28'),('2041-08-29'),('2041-08-30'),('2041-08-31'),('2041-09-01'),('2041-09-02'),('2041-09-03'),('2041-09-04'),('2041-09-05'),('2041-09-06'),('2041-09-07'),('2041-09-08'),('2041-09-09'),('2041-09-10'),('2041-09-11'),('2041-09-12'),('2041-09-13'),('2041-09-14'),('2041-09-15'),('2041-09-16'),('2041-09-17'),('2041-09-18'),('2041-09-19'),('2041-09-20'),('2041-09-21'),('2041-09-22'),('2041-09-23'),('2041-09-24'),('2041-09-25'),('2041-09-26'),('2041-09-27'),('2041-09-28'),('2041-09-29'),('2041-09-30'),('2041-10-01'),('2041-10-02'),('2041-10-03'),('2041-10-04'),('2041-10-05'),('2041-10-06'),('2041-10-07'),('2041-10-08'),('2041-10-09'),('2041-10-10'),('2041-10-11'),('2041-10-12'),('2041-10-13'),('2041-10-14'),('2041-10-15'),('2041-10-16'),('2041-10-17'),('2041-10-18'),('2041-10-19'),('2041-10-20'),('2041-10-21'),('2041-10-22'),('2041-10-23'),('2041-10-24'),('2041-10-25'),('2041-10-26'),('2041-10-27'),('2041-10-28'),('2041-10-29'),('2041-10-30'),('2041-10-31'),('2041-11-01'),('2041-11-02'),('2041-11-03'),('2041-11-04'),('2041-11-05'),('2041-11-06'),('2041-11-07'),('2041-11-08'),('2041-11-09'),('2041-11-10'),('2041-11-11'),('2041-11-12'),('2041-11-13'),('2041-11-14'),('2041-11-15'),('2041-11-16'),('2041-11-17'),('2041-11-18'),('2041-11-19'),('2041-11-20'),('2041-11-21'),('2041-11-22'),('2041-11-23'),('2041-11-24'),('2041-11-25'),('2041-11-26'),('2041-11-27'),('2041-11-28'),('2041-11-29'),('2041-11-30'),('2041-12-01'),('2041-12-02'),('2041-12-03'),('2041-12-04'),('2041-12-05'),('2041-12-06'),('2041-12-07'),('2041-12-08'),('2041-12-09'),('2041-12-10'),('2041-12-11'),('2041-12-12'),('2041-12-13'),('2041-12-14'),('2041-12-15'),('2041-12-16'),('2041-12-17'),('2041-12-18'),('2041-12-19'),('2041-12-20'),('2041-12-21'),('2041-12-22'),('2041-12-23'),('2041-12-24'),('2041-12-25'),('2041-12-26'),('2041-12-27'),('2041-12-28'),('2041-12-29'),('2041-12-30'),('2041-12-31'),('2042-01-01'),('2042-01-02'),('2042-01-03'),('2042-01-04'),('2042-01-05'),('2042-01-06'),('2042-01-07'),('2042-01-08'),('2042-01-09'),('2042-01-10'),('2042-01-11'),('2042-01-12'),('2042-01-13'),('2042-01-14'),('2042-01-15'),('2042-01-16'),('2042-01-17'),('2042-01-18'),('2042-01-19'),('2042-01-20'),('2042-01-21'),('2042-01-22'),('2042-01-23'),('2042-01-24'),('2042-01-25'),('2042-01-26'),('2042-01-27'),('2042-01-28'),('2042-01-29'),('2042-01-30'),('2042-01-31'),('2042-02-01'),('2042-02-02'),('2042-02-03'),('2042-02-04'),('2042-02-05'),('2042-02-06'),('2042-02-07'),('2042-02-08'),('2042-02-09'),('2042-02-10'),('2042-02-11'),('2042-02-12'),('2042-02-13'),('2042-02-14'),('2042-02-15'),('2042-02-16'),('2042-02-17'),('2042-02-18'),('2042-02-19'),('2042-02-20'),('2042-02-21'),('2042-02-22'),('2042-02-23'),('2042-02-24'),('2042-02-25'),('2042-02-26'),('2042-02-27'),('2042-02-28'),('2042-03-01'),('2042-03-02'),('2042-03-03'),('2042-03-04'),('2042-03-05'),('2042-03-06'),('2042-03-07'),('2042-03-08'),('2042-03-09'),('2042-03-10'),('2042-03-11'),('2042-03-12'),('2042-03-13'),('2042-03-14'),('2042-03-15'),('2042-03-16'),('2042-03-17'),('2042-03-18'),('2042-03-19'),('2042-03-20'),('2042-03-21'),('2042-03-22'),('2042-03-23'),('2042-03-24'),('2042-03-25'),('2042-03-26'),('2042-03-27'),('2042-03-28'),('2042-03-29'),('2042-03-30'),('2042-03-31'),('2042-04-01'),('2042-04-02'),('2042-04-03'),('2042-04-04'),('2042-04-05'),('2042-04-06'),('2042-04-07'),('2042-04-08'),('2042-04-09'),('2042-04-10'),('2042-04-11'),('2042-04-12'),('2042-04-13'),('2042-04-14'),('2042-04-15'),('2042-04-16'),('2042-04-17'),('2042-04-18'),('2042-04-19'),('2042-04-20'),('2042-04-21'),('2042-04-22'),('2042-04-23'),('2042-04-24'),('2042-04-25'),('2042-04-26'),('2042-04-27'),('2042-04-28'),('2042-04-29'),('2042-04-30'),('2042-05-01'),('2042-05-02'),('2042-05-03'),('2042-05-04'),('2042-05-05'),('2042-05-06'),('2042-05-07'),('2042-05-08'),('2042-05-09'),('2042-05-10'),('2042-05-11'),('2042-05-12'),('2042-05-13'),('2042-05-14'),('2042-05-15'),('2042-05-16'),('2042-05-17'),('2042-05-18'),('2042-05-19'),('2042-05-20'),('2042-05-21'),('2042-05-22'),('2042-05-23'),('2042-05-24'),('2042-05-25'),('2042-05-26'),('2042-05-27'),('2042-05-28'),('2042-05-29'),('2042-05-30'),('2042-05-31'),('2042-06-01'),('2042-06-02'),('2042-06-03'),('2042-06-04'),('2042-06-05'),('2042-06-06'),('2042-06-07'),('2042-06-08'),('2042-06-09'),('2042-06-10'),('2042-06-11'),('2042-06-12'),('2042-06-13'),('2042-06-14'),('2042-06-15'),('2042-06-16'),('2042-06-17'),('2042-06-18'),('2042-06-19'),('2042-06-20'),('2042-06-21'),('2042-06-22'),('2042-06-23'),('2042-06-24'),('2042-06-25'),('2042-06-26'),('2042-06-27'),('2042-06-28'),('2042-06-29'),('2042-06-30'),('2042-07-01'),('2042-07-02'),('2042-07-03'),('2042-07-04'),('2042-07-05'),('2042-07-06'),('2042-07-07'),('2042-07-08'),('2042-07-09'),('2042-07-10'),('2042-07-11'),('2042-07-12'),('2042-07-13'),('2042-07-14'),('2042-07-15'),('2042-07-16'),('2042-07-17'),('2042-07-18'),('2042-07-19'),('2042-07-20'),('2042-07-21'),('2042-07-22'),('2042-07-23'),('2042-07-24'),('2042-07-25'),('2042-07-26'),('2042-07-27'),('2042-07-28'),('2042-07-29'),('2042-07-30'),('2042-07-31'),('2042-08-01'),('2042-08-02'),('2042-08-03'),('2042-08-04'),('2042-08-05'),('2042-08-06'),('2042-08-07'),('2042-08-08'),('2042-08-09'),('2042-08-10'),('2042-08-11'),('2042-08-12'),('2042-08-13'),('2042-08-14'),('2042-08-15'),('2042-08-16'),('2042-08-17'),('2042-08-18'),('2042-08-19'),('2042-08-20'),('2042-08-21'),('2042-08-22'),('2042-08-23'),('2042-08-24'),('2042-08-25'),('2042-08-26'),('2042-08-27'),('2042-08-28'),('2042-08-29'),('2042-08-30'),('2042-08-31'),('2042-09-01'),('2042-09-02'),('2042-09-03'),('2042-09-04'),('2042-09-05'),('2042-09-06'),('2042-09-07'),('2042-09-08'),('2042-09-09'),('2042-09-10'),('2042-09-11'),('2042-09-12'),('2042-09-13'),('2042-09-14'),('2042-09-15'),('2042-09-16'),('2042-09-17'),('2042-09-18'),('2042-09-19'),('2042-09-20'),('2042-09-21'),('2042-09-22'),('2042-09-23'),('2042-09-24'),('2042-09-25'),('2042-09-26'),('2042-09-27'),('2042-09-28'),('2042-09-29'),('2042-09-30'),('2042-10-01'),('2042-10-02'),('2042-10-03'),('2042-10-04'),('2042-10-05'),('2042-10-06'),('2042-10-07'),('2042-10-08'),('2042-10-09'),('2042-10-10'),('2042-10-11'),('2042-10-12'),('2042-10-13'),('2042-10-14'),('2042-10-15'),('2042-10-16'),('2042-10-17'),('2042-10-18'),('2042-10-19'),('2042-10-20'),('2042-10-21'),('2042-10-22'),('2042-10-23'),('2042-10-24'),('2042-10-25'),('2042-10-26'),('2042-10-27'),('2042-10-28'),('2042-10-29'),('2042-10-30'),('2042-10-31'),('2042-11-01'),('2042-11-02'),('2042-11-03'),('2042-11-04'),('2042-11-05'),('2042-11-06'),('2042-11-07'),('2042-11-08'),('2042-11-09'),('2042-11-10'),('2042-11-11'),('2042-11-12'),('2042-11-13'),('2042-11-14'),('2042-11-15'),('2042-11-16'),('2042-11-17'),('2042-11-18'),('2042-11-19'),('2042-11-20'),('2042-11-21'),('2042-11-22'),('2042-11-23'),('2042-11-24'),('2042-11-25'),('2042-11-26'),('2042-11-27'),('2042-11-28'),('2042-11-29'),('2042-11-30'),('2042-12-01'),('2042-12-02'),('2042-12-03'),('2042-12-04'),('2042-12-05'),('2042-12-06'),('2042-12-07'),('2042-12-08'),('2042-12-09'),('2042-12-10'),('2042-12-11'),('2042-12-12'),('2042-12-13'),('2042-12-14'),('2042-12-15'),('2042-12-16'),('2042-12-17'),('2042-12-18'),('2042-12-19'),('2042-12-20'),('2042-12-21'),('2042-12-22'),('2042-12-23'),('2042-12-24'),('2042-12-25'),('2042-12-26'),('2042-12-27'),('2042-12-28'),('2042-12-29'),('2042-12-30'),('2042-12-31'),('2043-01-01'),('2043-01-02'),('2043-01-03'),('2043-01-04'),('2043-01-05'),('2043-01-06'),('2043-01-07'),('2043-01-08'),('2043-01-09'),('2043-01-10'),('2043-01-11'),('2043-01-12'),('2043-01-13'),('2043-01-14'),('2043-01-15'),('2043-01-16'),('2043-01-17'),('2043-01-18'),('2043-01-19'),('2043-01-20'),('2043-01-21'),('2043-01-22'),('2043-01-23'),('2043-01-24'),('2043-01-25'),('2043-01-26'),('2043-01-27'),('2043-01-28'),('2043-01-29'),('2043-01-30'),('2043-01-31'),('2043-02-01'),('2043-02-02'),('2043-02-03'),('2043-02-04'),('2043-02-05'),('2043-02-06'),('2043-02-07'),('2043-02-08'),('2043-02-09'),('2043-02-10'),('2043-02-11'),('2043-02-12'),('2043-02-13'),('2043-02-14'),('2043-02-15'),('2043-02-16'),('2043-02-17'),('2043-02-18'),('2043-02-19'),('2043-02-20'),('2043-02-21'),('2043-02-22'),('2043-02-23'),('2043-02-24'),('2043-02-25'),('2043-02-26'),('2043-02-27'),('2043-02-28'),('2043-03-01'),('2043-03-02'),('2043-03-03'),('2043-03-04'),('2043-03-05'),('2043-03-06'),('2043-03-07'),('2043-03-08'),('2043-03-09'),('2043-03-10'),('2043-03-11'),('2043-03-12'),('2043-03-13'),('2043-03-14'),('2043-03-15'),('2043-03-16'),('2043-03-17'),('2043-03-18'),('2043-03-19'),('2043-03-20'),('2043-03-21'),('2043-03-22'),('2043-03-23'),('2043-03-24'),('2043-03-25'),('2043-03-26'),('2043-03-27'),('2043-03-28'),('2043-03-29'),('2043-03-30'),('2043-03-31'),('2043-04-01'),('2043-04-02'),('2043-04-03'),('2043-04-04'),('2043-04-05'),('2043-04-06'),('2043-04-07'),('2043-04-08'),('2043-04-09'),('2043-04-10'),('2043-04-11'),('2043-04-12'),('2043-04-13'),('2043-04-14'),('2043-04-15'),('2043-04-16'),('2043-04-17'),('2043-04-18'),('2043-04-19'),('2043-04-20'),('2043-04-21'),('2043-04-22'),('2043-04-23'),('2043-04-24'),('2043-04-25'),('2043-04-26'),('2043-04-27'),('2043-04-28'),('2043-04-29'),('2043-04-30'),('2043-05-01'),('2043-05-02'),('2043-05-03'),('2043-05-04'),('2043-05-05'),('2043-05-06'),('2043-05-07'),('2043-05-08'),('2043-05-09'),('2043-05-10'),('2043-05-11'),('2043-05-12'),('2043-05-13'),('2043-05-14'),('2043-05-15'),('2043-05-16'),('2043-05-17'),('2043-05-18'),('2043-05-19'),('2043-05-20'),('2043-05-21'),('2043-05-22'),('2043-05-23'),('2043-05-24'),('2043-05-25'),('2043-05-26'),('2043-05-27'),('2043-05-28'),('2043-05-29'),('2043-05-30'),('2043-05-31'),('2043-06-01'),('2043-06-02'),('2043-06-03'),('2043-06-04'),('2043-06-05'),('2043-06-06'),('2043-06-07'),('2043-06-08'),('2043-06-09'),('2043-06-10'),('2043-06-11'),('2043-06-12'),('2043-06-13'),('2043-06-14'),('2043-06-15'),('2043-06-16'),('2043-06-17'),('2043-06-18'),('2043-06-19'),('2043-06-20'),('2043-06-21'),('2043-06-22'),('2043-06-23'),('2043-06-24'),('2043-06-25'),('2043-06-26'),('2043-06-27'),('2043-06-28'),('2043-06-29'),('2043-06-30'),('2043-07-01'),('2043-07-02'),('2043-07-03'),('2043-07-04'),('2043-07-05'),('2043-07-06'),('2043-07-07'),('2043-07-08'),('2043-07-09'),('2043-07-10'),('2043-07-11'),('2043-07-12'),('2043-07-13'),('2043-07-14'),('2043-07-15'),('2043-07-16'),('2043-07-17'),('2043-07-18'),('2043-07-19'),('2043-07-20'),('2043-07-21'),('2043-07-22'),('2043-07-23'),('2043-07-24'),('2043-07-25'),('2043-07-26'),('2043-07-27'),('2043-07-28'),('2043-07-29'),('2043-07-30'),('2043-07-31'),('2043-08-01'),('2043-08-02'),('2043-08-03'),('2043-08-04'),('2043-08-05'),('2043-08-06'),('2043-08-07'),('2043-08-08'),('2043-08-09'),('2043-08-10'),('2043-08-11'),('2043-08-12'),('2043-08-13'),('2043-08-14'),('2043-08-15'),('2043-08-16'),('2043-08-17'),('2043-08-18'),('2043-08-19'),('2043-08-20'),('2043-08-21'),('2043-08-22'),('2043-08-23'),('2043-08-24'),('2043-08-25'),('2043-08-26'),('2043-08-27'),('2043-08-28'),('2043-08-29'),('2043-08-30'),('2043-08-31'),('2043-09-01'),('2043-09-02'),('2043-09-03'),('2043-09-04'),('2043-09-05'),('2043-09-06'),('2043-09-07'),('2043-09-08'),('2043-09-09'),('2043-09-10'),('2043-09-11'),('2043-09-12'),('2043-09-13'),('2043-09-14'),('2043-09-15'),('2043-09-16'),('2043-09-17'),('2043-09-18'),('2043-09-19'),('2043-09-20'),('2043-09-21'),('2043-09-22'),('2043-09-23'),('2043-09-24'),('2043-09-25'),('2043-09-26'),('2043-09-27'),('2043-09-28'),('2043-09-29'),('2043-09-30'),('2043-10-01'),('2043-10-02'),('2043-10-03'),('2043-10-04'),('2043-10-05'),('2043-10-06'),('2043-10-07'),('2043-10-08'),('2043-10-09'),('2043-10-10'),('2043-10-11'),('2043-10-12'),('2043-10-13'),('2043-10-14'),('2043-10-15'),('2043-10-16'),('2043-10-17'),('2043-10-18'),('2043-10-19'),('2043-10-20'),('2043-10-21'),('2043-10-22'),('2043-10-23'),('2043-10-24'),('2043-10-25'),('2043-10-26'),('2043-10-27'),('2043-10-28'),('2043-10-29'),('2043-10-30'),('2043-10-31'),('2043-11-01'),('2043-11-02'),('2043-11-03'),('2043-11-04'),('2043-11-05'),('2043-11-06'),('2043-11-07'),('2043-11-08'),('2043-11-09'),('2043-11-10'),('2043-11-11'),('2043-11-12'),('2043-11-13'),('2043-11-14'),('2043-11-15'),('2043-11-16'),('2043-11-17'),('2043-11-18'),('2043-11-19'),('2043-11-20'),('2043-11-21'),('2043-11-22'),('2043-11-23'),('2043-11-24'),('2043-11-25'),('2043-11-26'),('2043-11-27'),('2043-11-28'),('2043-11-29'),('2043-11-30'),('2043-12-01'),('2043-12-02'),('2043-12-03'),('2043-12-04'),('2043-12-05'),('2043-12-06'),('2043-12-07'),('2043-12-08'),('2043-12-09'),('2043-12-10'),('2043-12-11'),('2043-12-12'),('2043-12-13'),('2043-12-14'),('2043-12-15'),('2043-12-16'),('2043-12-17'),('2043-12-18'),('2043-12-19'),('2043-12-20'),('2043-12-21'),('2043-12-22'),('2043-12-23'),('2043-12-24'),('2043-12-25'),('2043-12-26'),('2043-12-27'),('2043-12-28'),('2043-12-29'),('2043-12-30'),('2043-12-31'),('2044-01-01'),('2044-01-02'),('2044-01-03'),('2044-01-04'),('2044-01-05'),('2044-01-06'),('2044-01-07'),('2044-01-08'),('2044-01-09'),('2044-01-10'),('2044-01-11'),('2044-01-12'),('2044-01-13'),('2044-01-14'),('2044-01-15'),('2044-01-16'),('2044-01-17'),('2044-01-18'),('2044-01-19'),('2044-01-20'),('2044-01-21'),('2044-01-22'),('2044-01-23'),('2044-01-24'),('2044-01-25'),('2044-01-26'),('2044-01-27'),('2044-01-28'),('2044-01-29'),('2044-01-30'),('2044-01-31'),('2044-02-01'),('2044-02-02'),('2044-02-03'),('2044-02-04'),('2044-02-05'),('2044-02-06'),('2044-02-07'),('2044-02-08'),('2044-02-09'),('2044-02-10'),('2044-02-11'),('2044-02-12'),('2044-02-13'),('2044-02-14'),('2044-02-15'),('2044-02-16'),('2044-02-17'),('2044-02-18'),('2044-02-19'),('2044-02-20'),('2044-02-21'),('2044-02-22'),('2044-02-23'),('2044-02-24'),('2044-02-25'),('2044-02-26'),('2044-02-27'),('2044-02-28'),('2044-02-29'),('2044-03-01'),('2044-03-02'),('2044-03-03'),('2044-03-04'),('2044-03-05'),('2044-03-06'),('2044-03-07'),('2044-03-08'),('2044-03-09'),('2044-03-10'),('2044-03-11'),('2044-03-12'),('2044-03-13'),('2044-03-14'),('2044-03-15'),('2044-03-16'),('2044-03-17'),('2044-03-18'),('2044-03-19'),('2044-03-20'),('2044-03-21'),('2044-03-22'),('2044-03-23'),('2044-03-24'),('2044-03-25'),('2044-03-26'),('2044-03-27'),('2044-03-28'),('2044-03-29'),('2044-03-30'),('2044-03-31'),('2044-04-01'),('2044-04-02'),('2044-04-03'),('2044-04-04'),('2044-04-05'),('2044-04-06'),('2044-04-07'),('2044-04-08'),('2044-04-09'),('2044-04-10'),('2044-04-11'),('2044-04-12'),('2044-04-13'),('2044-04-14'),('2044-04-15'),('2044-04-16'),('2044-04-17'),('2044-04-18'),('2044-04-19'),('2044-04-20'),('2044-04-21'),('2044-04-22'),('2044-04-23'),('2044-04-24'),('2044-04-25'),('2044-04-26'),('2044-04-27'),('2044-04-28'),('2044-04-29'),('2044-04-30'),('2044-05-01'),('2044-05-02'),('2044-05-03'),('2044-05-04'),('2044-05-05'),('2044-05-06'),('2044-05-07'),('2044-05-08'),('2044-05-09'),('2044-05-10'),('2044-05-11'),('2044-05-12'),('2044-05-13'),('2044-05-14'),('2044-05-15'),('2044-05-16'),('2044-05-17'),('2044-05-18'),('2044-05-19'),('2044-05-20'),('2044-05-21'),('2044-05-22'),('2044-05-23'),('2044-05-24'),('2044-05-25'),('2044-05-26'),('2044-05-27'),('2044-05-28'),('2044-05-29'),('2044-05-30'),('2044-05-31'),('2044-06-01'),('2044-06-02'),('2044-06-03'),('2044-06-04'),('2044-06-05'),('2044-06-06'),('2044-06-07'),('2044-06-08'),('2044-06-09'),('2044-06-10'),('2044-06-11'),('2044-06-12'),('2044-06-13'),('2044-06-14'),('2044-06-15'),('2044-06-16'),('2044-06-17'),('2044-06-18'),('2044-06-19'),('2044-06-20'),('2044-06-21'),('2044-06-22'),('2044-06-23'),('2044-06-24'),('2044-06-25'),('2044-06-26'),('2044-06-27'),('2044-06-28'),('2044-06-29'),('2044-06-30'),('2044-07-01'),('2044-07-02'),('2044-07-03'),('2044-07-04'),('2044-07-05'),('2044-07-06'),('2044-07-07'),('2044-07-08'),('2044-07-09'),('2044-07-10'),('2044-07-11'),('2044-07-12'),('2044-07-13'),('2044-07-14'),('2044-07-15'),('2044-07-16'),('2044-07-17'),('2044-07-18'),('2044-07-19'),('2044-07-20'),('2044-07-21'),('2044-07-22'),('2044-07-23'),('2044-07-24'),('2044-07-25'),('2044-07-26'),('2044-07-27'),('2044-07-28'),('2044-07-29'),('2044-07-30'),('2044-07-31'),('2044-08-01'),('2044-08-02'),('2044-08-03'),('2044-08-04'),('2044-08-05'),('2044-08-06'),('2044-08-07'),('2044-08-08'),('2044-08-09'),('2044-08-10'),('2044-08-11'),('2044-08-12'),('2044-08-13'),('2044-08-14'),('2044-08-15'),('2044-08-16'),('2044-08-17'),('2044-08-18'),('2044-08-19'),('2044-08-20'),('2044-08-21'),('2044-08-22'),('2044-08-23'),('2044-08-24'),('2044-08-25'),('2044-08-26'),('2044-08-27'),('2044-08-28'),('2044-08-29'),('2044-08-30'),('2044-08-31'),('2044-09-01'),('2044-09-02'),('2044-09-03'),('2044-09-04'),('2044-09-05'),('2044-09-06'),('2044-09-07'),('2044-09-08'),('2044-09-09'),('2044-09-10'),('2044-09-11'),('2044-09-12'),('2044-09-13'),('2044-09-14'),('2044-09-15'),('2044-09-16'),('2044-09-17'),('2044-09-18'),('2044-09-19'),('2044-09-20'),('2044-09-21'),('2044-09-22'),('2044-09-23'),('2044-09-24'),('2044-09-25'),('2044-09-26'),('2044-09-27'),('2044-09-28'),('2044-09-29'),('2044-09-30'),('2044-10-01'),('2044-10-02'),('2044-10-03'),('2044-10-04'),('2044-10-05'),('2044-10-06'),('2044-10-07'),('2044-10-08'),('2044-10-09'),('2044-10-10'),('2044-10-11'),('2044-10-12'),('2044-10-13'),('2044-10-14'),('2044-10-15'),('2044-10-16'),('2044-10-17'),('2044-10-18'),('2044-10-19'),('2044-10-20'),('2044-10-21'),('2044-10-22'),('2044-10-23'),('2044-10-24'),('2044-10-25'),('2044-10-26'),('2044-10-27'),('2044-10-28'),('2044-10-29'),('2044-10-30'),('2044-10-31'),('2044-11-01'),('2044-11-02'),('2044-11-03'),('2044-11-04'),('2044-11-05'),('2044-11-06'),('2044-11-07'),('2044-11-08'),('2044-11-09'),('2044-11-10'),('2044-11-11'),('2044-11-12'),('2044-11-13'),('2044-11-14'),('2044-11-15'),('2044-11-16'),('2044-11-17'),('2044-11-18'),('2044-11-19'),('2044-11-20'),('2044-11-21'),('2044-11-22'),('2044-11-23'),('2044-11-24'),('2044-11-25'),('2044-11-26'),('2044-11-27'),('2044-11-28'),('2044-11-29'),('2044-11-30'),('2044-12-01'),('2044-12-02'),('2044-12-03'),('2044-12-04'),('2044-12-05'),('2044-12-06'),('2044-12-07'),('2044-12-08'),('2044-12-09'),('2044-12-10'),('2044-12-11'),('2044-12-12'),('2044-12-13'),('2044-12-14'),('2044-12-15'),('2044-12-16'),('2044-12-17'),('2044-12-18'),('2044-12-19'),('2044-12-20'),('2044-12-21'),('2044-12-22'),('2044-12-23'),('2044-12-24'),('2044-12-25'),('2044-12-26'),('2044-12-27'),('2044-12-28'),('2044-12-29'),('2044-12-30'),('2044-12-31'),('2045-01-01'),('2045-01-02'),('2045-01-03'),('2045-01-04'),('2045-01-05'),('2045-01-06'),('2045-01-07'),('2045-01-08'),('2045-01-09'),('2045-01-10'),('2045-01-11'),('2045-01-12'),('2045-01-13'),('2045-01-14'),('2045-01-15'),('2045-01-16'),('2045-01-17'),('2045-01-18'),('2045-01-19'),('2045-01-20'),('2045-01-21'),('2045-01-22'),('2045-01-23'),('2045-01-24'),('2045-01-25'),('2045-01-26'),('2045-01-27'),('2045-01-28'),('2045-01-29'),('2045-01-30'),('2045-01-31'),('2045-02-01'),('2045-02-02'),('2045-02-03'),('2045-02-04'),('2045-02-05'),('2045-02-06'),('2045-02-07'),('2045-02-08'),('2045-02-09'),('2045-02-10'),('2045-02-11'),('2045-02-12'),('2045-02-13'),('2045-02-14'),('2045-02-15'),('2045-02-16'),('2045-02-17'),('2045-02-18'),('2045-02-19'),('2045-02-20'),('2045-02-21'),('2045-02-22'),('2045-02-23'),('2045-02-24'),('2045-02-25'),('2045-02-26'),('2045-02-27'),('2045-02-28'),('2045-03-01'),('2045-03-02'),('2045-03-03'),('2045-03-04'),('2045-03-05'),('2045-03-06'),('2045-03-07'),('2045-03-08'),('2045-03-09'),('2045-03-10'),('2045-03-11'),('2045-03-12'),('2045-03-13'),('2045-03-14'),('2045-03-15'),('2045-03-16'),('2045-03-17'),('2045-03-18'),('2045-03-19'),('2045-03-20'),('2045-03-21'),('2045-03-22'),('2045-03-23'),('2045-03-24'),('2045-03-25'),('2045-03-26'),('2045-03-27'),('2045-03-28'),('2045-03-29'),('2045-03-30'),('2045-03-31'),('2045-04-01'),('2045-04-02'),('2045-04-03'),('2045-04-04'),('2045-04-05'),('2045-04-06'),('2045-04-07'),('2045-04-08'),('2045-04-09'),('2045-04-10'),('2045-04-11'),('2045-04-12'),('2045-04-13'),('2045-04-14'),('2045-04-15'),('2045-04-16'),('2045-04-17'),('2045-04-18'),('2045-04-19'),('2045-04-20'),('2045-04-21'),('2045-04-22'),('2045-04-23'),('2045-04-24'),('2045-04-25'),('2045-04-26'),('2045-04-27'),('2045-04-28'),('2045-04-29'),('2045-04-30'),('2045-05-01'),('2045-05-02'),('2045-05-03'),('2045-05-04'),('2045-05-05'),('2045-05-06'),('2045-05-07'),('2045-05-08'),('2045-05-09'),('2045-05-10'),('2045-05-11'),('2045-05-12'),('2045-05-13'),('2045-05-14'),('2045-05-15'),('2045-05-16'),('2045-05-17'),('2045-05-18'),('2045-05-19'),('2045-05-20'),('2045-05-21'),('2045-05-22'),('2045-05-23'),('2045-05-24'),('2045-05-25'),('2045-05-26'),('2045-05-27'),('2045-05-28'),('2045-05-29'),('2045-05-30'),('2045-05-31'),('2045-06-01'),('2045-06-02'),('2045-06-03'),('2045-06-04'),('2045-06-05'),('2045-06-06'),('2045-06-07'),('2045-06-08'),('2045-06-09'),('2045-06-10'),('2045-06-11'),('2045-06-12'),('2045-06-13'),('2045-06-14'),('2045-06-15'),('2045-06-16'),('2045-06-17'),('2045-06-18'),('2045-06-19'),('2045-06-20'),('2045-06-21'),('2045-06-22'),('2045-06-23'),('2045-06-24'),('2045-06-25'),('2045-06-26'),('2045-06-27'),('2045-06-28'),('2045-06-29'),('2045-06-30'),('2045-07-01'),('2045-07-02'),('2045-07-03'),('2045-07-04'),('2045-07-05'),('2045-07-06'),('2045-07-07'),('2045-07-08'),('2045-07-09'),('2045-07-10'),('2045-07-11'),('2045-07-12'),('2045-07-13'),('2045-07-14'),('2045-07-15'),('2045-07-16'),('2045-07-17'),('2045-07-18'),('2045-07-19'),('2045-07-20'),('2045-07-21'),('2045-07-22'),('2045-07-23'),('2045-07-24'),('2045-07-25'),('2045-07-26'),('2045-07-27'),('2045-07-28'),('2045-07-29'),('2045-07-30'),('2045-07-31'),('2045-08-01'),('2045-08-02'),('2045-08-03'),('2045-08-04'),('2045-08-05'),('2045-08-06'),('2045-08-07'),('2045-08-08'),('2045-08-09'),('2045-08-10'),('2045-08-11'),('2045-08-12'),('2045-08-13'),('2045-08-14'),('2045-08-15'),('2045-08-16'),('2045-08-17'),('2045-08-18'),('2045-08-19'),('2045-08-20'),('2045-08-21'),('2045-08-22'),('2045-08-23'),('2045-08-24'),('2045-08-25'),('2045-08-26'),('2045-08-27'),('2045-08-28'),('2045-08-29'),('2045-08-30'),('2045-08-31'),('2045-09-01'),('2045-09-02'),('2045-09-03'),('2045-09-04'),('2045-09-05'),('2045-09-06'),('2045-09-07'),('2045-09-08'),('2045-09-09'),('2045-09-10'),('2045-09-11'),('2045-09-12'),('2045-09-13'),('2045-09-14'),('2045-09-15'),('2045-09-16'),('2045-09-17'),('2045-09-18'),('2045-09-19'),('2045-09-20'),('2045-09-21'),('2045-09-22'),('2045-09-23'),('2045-09-24'),('2045-09-25'),('2045-09-26'),('2045-09-27'),('2045-09-28'),('2045-09-29'),('2045-09-30'),('2045-10-01'),('2045-10-02'),('2045-10-03'),('2045-10-04'),('2045-10-05'),('2045-10-06'),('2045-10-07'),('2045-10-08'),('2045-10-09'),('2045-10-10'),('2045-10-11'),('2045-10-12'),('2045-10-13'),('2045-10-14'),('2045-10-15'),('2045-10-16'),('2045-10-17'),('2045-10-18'),('2045-10-19'),('2045-10-20'),('2045-10-21'),('2045-10-22'),('2045-10-23'),('2045-10-24'),('2045-10-25'),('2045-10-26'),('2045-10-27'),('2045-10-28'),('2045-10-29'),('2045-10-30'),('2045-10-31'),('2045-11-01'),('2045-11-02'),('2045-11-03'),('2045-11-04'),('2045-11-05'),('2045-11-06'),('2045-11-07'),('2045-11-08'),('2045-11-09'),('2045-11-10'),('2045-11-11'),('2045-11-12'),('2045-11-13'),('2045-11-14'),('2045-11-15'),('2045-11-16'),('2045-11-17'),('2045-11-18'),('2045-11-19'),('2045-11-20'),('2045-11-21'),('2045-11-22'),('2045-11-23'),('2045-11-24'),('2045-11-25'),('2045-11-26'),('2045-11-27'),('2045-11-28'),('2045-11-29'),('2045-11-30'),('2045-12-01'),('2045-12-02'),('2045-12-03'),('2045-12-04'),('2045-12-05'),('2045-12-06'),('2045-12-07'),('2045-12-08'),('2045-12-09'),('2045-12-10'),('2045-12-11'),('2045-12-12'),('2045-12-13'),('2045-12-14'),('2045-12-15'),('2045-12-16'),('2045-12-17'),('2045-12-18'),('2045-12-19'),('2045-12-20'),('2045-12-21'),('2045-12-22'),('2045-12-23'),('2045-12-24'),('2045-12-25'),('2045-12-26'),('2045-12-27'),('2045-12-28'),('2045-12-29'),('2045-12-30'),('2045-12-31'),('2046-01-01'),('2046-01-02'),('2046-01-03'),('2046-01-04'),('2046-01-05'),('2046-01-06'),('2046-01-07'),('2046-01-08'),('2046-01-09'),('2046-01-10'),('2046-01-11'),('2046-01-12'),('2046-01-13'),('2046-01-14'),('2046-01-15'),('2046-01-16'),('2046-01-17'),('2046-01-18'),('2046-01-19'),('2046-01-20'),('2046-01-21'),('2046-01-22'),('2046-01-23'),('2046-01-24'),('2046-01-25'),('2046-01-26'),('2046-01-27'),('2046-01-28'),('2046-01-29'),('2046-01-30'),('2046-01-31'),('2046-02-01'),('2046-02-02'),('2046-02-03'),('2046-02-04'),('2046-02-05'),('2046-02-06'),('2046-02-07'),('2046-02-08'),('2046-02-09'),('2046-02-10'),('2046-02-11'),('2046-02-12'),('2046-02-13'),('2046-02-14'),('2046-02-15'),('2046-02-16'),('2046-02-17'),('2046-02-18'),('2046-02-19'),('2046-02-20'),('2046-02-21'),('2046-02-22'),('2046-02-23'),('2046-02-24'),('2046-02-25'),('2046-02-26'),('2046-02-27'),('2046-02-28'),('2046-03-01'),('2046-03-02'),('2046-03-03'),('2046-03-04'),('2046-03-05'),('2046-03-06'),('2046-03-07'),('2046-03-08'),('2046-03-09'),('2046-03-10'),('2046-03-11'),('2046-03-12'),('2046-03-13'),('2046-03-14'),('2046-03-15'),('2046-03-16'),('2046-03-17'),('2046-03-18'),('2046-03-19'),('2046-03-20'),('2046-03-21'),('2046-03-22'),('2046-03-23'),('2046-03-24'),('2046-03-25'),('2046-03-26'),('2046-03-27'),('2046-03-28'),('2046-03-29'),('2046-03-30'),('2046-03-31'),('2046-04-01'),('2046-04-02'),('2046-04-03'),('2046-04-04'),('2046-04-05'),('2046-04-06'),('2046-04-07'),('2046-04-08'),('2046-04-09'),('2046-04-10'),('2046-04-11'),('2046-04-12'),('2046-04-13'),('2046-04-14'),('2046-04-15'),('2046-04-16'),('2046-04-17'),('2046-04-18'),('2046-04-19'),('2046-04-20'),('2046-04-21'),('2046-04-22'),('2046-04-23'),('2046-04-24'),('2046-04-25'),('2046-04-26'),('2046-04-27'),('2046-04-28'),('2046-04-29'),('2046-04-30'),('2046-05-01'),('2046-05-02'),('2046-05-03'),('2046-05-04'),('2046-05-05'),('2046-05-06'),('2046-05-07'),('2046-05-08'),('2046-05-09'),('2046-05-10'),('2046-05-11'),('2046-05-12'),('2046-05-13'),('2046-05-14'),('2046-05-15'),('2046-05-16'),('2046-05-17'),('2046-05-18'),('2046-05-19'),('2046-05-20'),('2046-05-21'),('2046-05-22'),('2046-05-23'),('2046-05-24'),('2046-05-25'),('2046-05-26'),('2046-05-27'),('2046-05-28'),('2046-05-29'),('2046-05-30'),('2046-05-31'),('2046-06-01'),('2046-06-02'),('2046-06-03'),('2046-06-04'),('2046-06-05'),('2046-06-06'),('2046-06-07'),('2046-06-08'),('2046-06-09'),('2046-06-10'),('2046-06-11'),('2046-06-12'),('2046-06-13'),('2046-06-14'),('2046-06-15'),('2046-06-16'),('2046-06-17'),('2046-06-18'),('2046-06-19'),('2046-06-20'),('2046-06-21'),('2046-06-22'),('2046-06-23'),('2046-06-24'),('2046-06-25'),('2046-06-26'),('2046-06-27'),('2046-06-28'),('2046-06-29'),('2046-06-30'),('2046-07-01'),('2046-07-02'),('2046-07-03'),('2046-07-04'),('2046-07-05'),('2046-07-06'),('2046-07-07'),('2046-07-08'),('2046-07-09'),('2046-07-10'),('2046-07-11'),('2046-07-12'),('2046-07-13'),('2046-07-14'),('2046-07-15'),('2046-07-16'),('2046-07-17'),('2046-07-18'),('2046-07-19'),('2046-07-20'),('2046-07-21'),('2046-07-22'),('2046-07-23'),('2046-07-24'),('2046-07-25'),('2046-07-26'),('2046-07-27'),('2046-07-28'),('2046-07-29'),('2046-07-30'),('2046-07-31'),('2046-08-01'),('2046-08-02'),('2046-08-03'),('2046-08-04'),('2046-08-05'),('2046-08-06'),('2046-08-07'),('2046-08-08'),('2046-08-09'),('2046-08-10'),('2046-08-11'),('2046-08-12'),('2046-08-13'),('2046-08-14'),('2046-08-15'),('2046-08-16'),('2046-08-17'),('2046-08-18'),('2046-08-19'),('2046-08-20'),('2046-08-21'),('2046-08-22'),('2046-08-23'),('2046-08-24'),('2046-08-25'),('2046-08-26'),('2046-08-27'),('2046-08-28'),('2046-08-29'),('2046-08-30'),('2046-08-31'),('2046-09-01'),('2046-09-02'),('2046-09-03'),('2046-09-04'),('2046-09-05'),('2046-09-06'),('2046-09-07'),('2046-09-08'),('2046-09-09'),('2046-09-10'),('2046-09-11'),('2046-09-12'),('2046-09-13'),('2046-09-14'),('2046-09-15'),('2046-09-16'),('2046-09-17'),('2046-09-18'),('2046-09-19'),('2046-09-20'),('2046-09-21'),('2046-09-22'),('2046-09-23'),('2046-09-24'),('2046-09-25'),('2046-09-26'),('2046-09-27'),('2046-09-28'),('2046-09-29'),('2046-09-30'),('2046-10-01'),('2046-10-02'),('2046-10-03'),('2046-10-04'),('2046-10-05'),('2046-10-06'),('2046-10-07'),('2046-10-08'),('2046-10-09'),('2046-10-10'),('2046-10-11'),('2046-10-12'),('2046-10-13'),('2046-10-14'),('2046-10-15'),('2046-10-16'),('2046-10-17'),('2046-10-18'),('2046-10-19'),('2046-10-20'),('2046-10-21'),('2046-10-22'),('2046-10-23'),('2046-10-24'),('2046-10-25'),('2046-10-26'),('2046-10-27'),('2046-10-28'),('2046-10-29'),('2046-10-30'),('2046-10-31'),('2046-11-01'),('2046-11-02'),('2046-11-03'),('2046-11-04'),('2046-11-05'),('2046-11-06'),('2046-11-07'),('2046-11-08'),('2046-11-09'),('2046-11-10'),('2046-11-11'),('2046-11-12'),('2046-11-13'),('2046-11-14'),('2046-11-15'),('2046-11-16'),('2046-11-17'),('2046-11-18'),('2046-11-19'),('2046-11-20'),('2046-11-21'),('2046-11-22'),('2046-11-23'),('2046-11-24'),('2046-11-25'),('2046-11-26'),('2046-11-27'),('2046-11-28'),('2046-11-29'),('2046-11-30'),('2046-12-01'),('2046-12-02'),('2046-12-03'),('2046-12-04'),('2046-12-05'),('2046-12-06'),('2046-12-07'),('2046-12-08'),('2046-12-09'),('2046-12-10'),('2046-12-11'),('2046-12-12'),('2046-12-13'),('2046-12-14'),('2046-12-15'),('2046-12-16'),('2046-12-17'),('2046-12-18'),('2046-12-19'),('2046-12-20'),('2046-12-21'),('2046-12-22'),('2046-12-23'),('2046-12-24'),('2046-12-25'),('2046-12-26'),('2046-12-27'),('2046-12-28'),('2046-12-29'),('2046-12-30'),('2046-12-31'),('2047-01-01'),('2047-01-02'),('2047-01-03'),('2047-01-04'),('2047-01-05'),('2047-01-06'),('2047-01-07'),('2047-01-08'),('2047-01-09'),('2047-01-10'),('2047-01-11'),('2047-01-12'),('2047-01-13'),('2047-01-14'),('2047-01-15'),('2047-01-16'),('2047-01-17'),('2047-01-18'),('2047-01-19'),('2047-01-20'),('2047-01-21'),('2047-01-22'),('2047-01-23'),('2047-01-24'),('2047-01-25'),('2047-01-26'),('2047-01-27'),('2047-01-28'),('2047-01-29'),('2047-01-30'),('2047-01-31'),('2047-02-01'),('2047-02-02'),('2047-02-03'),('2047-02-04'),('2047-02-05'),('2047-02-06'),('2047-02-07'),('2047-02-08'),('2047-02-09'),('2047-02-10'),('2047-02-11'),('2047-02-12'),('2047-02-13'),('2047-02-14'),('2047-02-15'),('2047-02-16'),('2047-02-17'),('2047-02-18'),('2047-02-19'),('2047-02-20'),('2047-02-21'),('2047-02-22'),('2047-02-23'),('2047-02-24'),('2047-02-25'),('2047-02-26'),('2047-02-27'),('2047-02-28'),('2047-03-01'),('2047-03-02'),('2047-03-03'),('2047-03-04'),('2047-03-05'),('2047-03-06'),('2047-03-07'),('2047-03-08'),('2047-03-09'),('2047-03-10'),('2047-03-11'),('2047-03-12'),('2047-03-13'),('2047-03-14'),('2047-03-15'),('2047-03-16'),('2047-03-17'),('2047-03-18'),('2047-03-19'),('2047-03-20'),('2047-03-21'),('2047-03-22'),('2047-03-23'),('2047-03-24'),('2047-03-25'),('2047-03-26'),('2047-03-27'),('2047-03-28'),('2047-03-29'),('2047-03-30'),('2047-03-31'),('2047-04-01'),('2047-04-02'),('2047-04-03'),('2047-04-04'),('2047-04-05'),('2047-04-06'),('2047-04-07'),('2047-04-08'),('2047-04-09'),('2047-04-10'),('2047-04-11'),('2047-04-12'),('2047-04-13'),('2047-04-14'),('2047-04-15'),('2047-04-16'),('2047-04-17'),('2047-04-18'),('2047-04-19'),('2047-04-20'),('2047-04-21'),('2047-04-22'),('2047-04-23'),('2047-04-24'),('2047-04-25'),('2047-04-26'),('2047-04-27'),('2047-04-28'),('2047-04-29'),('2047-04-30'),('2047-05-01'),('2047-05-02'),('2047-05-03'),('2047-05-04'),('2047-05-05'),('2047-05-06'),('2047-05-07'),('2047-05-08'),('2047-05-09'),('2047-05-10'),('2047-05-11'),('2047-05-12'),('2047-05-13'),('2047-05-14'),('2047-05-15'),('2047-05-16'),('2047-05-17'),('2047-05-18'),('2047-05-19'),('2047-05-20'),('2047-05-21'),('2047-05-22'),('2047-05-23'),('2047-05-24'),('2047-05-25'),('2047-05-26'),('2047-05-27'),('2047-05-28'),('2047-05-29'),('2047-05-30'),('2047-05-31'),('2047-06-01'),('2047-06-02'),('2047-06-03'),('2047-06-04'),('2047-06-05'),('2047-06-06'),('2047-06-07'),('2047-06-08'),('2047-06-09'),('2047-06-10'),('2047-06-11'),('2047-06-12'),('2047-06-13'),('2047-06-14'),('2047-06-15'),('2047-06-16'),('2047-06-17'),('2047-06-18'),('2047-06-19'),('2047-06-20'),('2047-06-21'),('2047-06-22'),('2047-06-23'),('2047-06-24'),('2047-06-25'),('2047-06-26'),('2047-06-27'),('2047-06-28'),('2047-06-29'),('2047-06-30'),('2047-07-01'),('2047-07-02'),('2047-07-03'),('2047-07-04'),('2047-07-05'),('2047-07-06'),('2047-07-07'),('2047-07-08'),('2047-07-09'),('2047-07-10'),('2047-07-11'),('2047-07-12'),('2047-07-13'),('2047-07-14'),('2047-07-15'),('2047-07-16'),('2047-07-17'),('2047-07-18'),('2047-07-19'),('2047-07-20'),('2047-07-21'),('2047-07-22'),('2047-07-23'),('2047-07-24'),('2047-07-25'),('2047-07-26'),('2047-07-27'),('2047-07-28'),('2047-07-29'),('2047-07-30'),('2047-07-31'),('2047-08-01'),('2047-08-02'),('2047-08-03'),('2047-08-04'),('2047-08-05'),('2047-08-06'),('2047-08-07'),('2047-08-08'),('2047-08-09'),('2047-08-10'),('2047-08-11'),('2047-08-12'),('2047-08-13'),('2047-08-14'),('2047-08-15'),('2047-08-16'),('2047-08-17'),('2047-08-18'),('2047-08-19'),('2047-08-20'),('2047-08-21'),('2047-08-22'),('2047-08-23'),('2047-08-24'),('2047-08-25'),('2047-08-26'),('2047-08-27'),('2047-08-28'),('2047-08-29'),('2047-08-30'),('2047-08-31'),('2047-09-01'),('2047-09-02'),('2047-09-03'),('2047-09-04'),('2047-09-05'),('2047-09-06'),('2047-09-07'),('2047-09-08'),('2047-09-09'),('2047-09-10'),('2047-09-11'),('2047-09-12'),('2047-09-13'),('2047-09-14'),('2047-09-15'),('2047-09-16'),('2047-09-17'),('2047-09-18'),('2047-09-19'),('2047-09-20'),('2047-09-21'),('2047-09-22'),('2047-09-23'),('2047-09-24'),('2047-09-25'),('2047-09-26'),('2047-09-27'),('2047-09-28'),('2047-09-29'),('2047-09-30'),('2047-10-01'),('2047-10-02'),('2047-10-03'),('2047-10-04'),('2047-10-05'),('2047-10-06'),('2047-10-07'),('2047-10-08'),('2047-10-09'),('2047-10-10'),('2047-10-11'),('2047-10-12'),('2047-10-13'),('2047-10-14'),('2047-10-15'),('2047-10-16'),('2047-10-17'),('2047-10-18'),('2047-10-19'),('2047-10-20'),('2047-10-21'),('2047-10-22'),('2047-10-23'),('2047-10-24'),('2047-10-25'),('2047-10-26'),('2047-10-27'),('2047-10-28'),('2047-10-29'),('2047-10-30'),('2047-10-31'),('2047-11-01'),('2047-11-02'),('2047-11-03'),('2047-11-04'),('2047-11-05'),('2047-11-06'),('2047-11-07'),('2047-11-08'),('2047-11-09'),('2047-11-10'),('2047-11-11'),('2047-11-12'),('2047-11-13'),('2047-11-14'),('2047-11-15'),('2047-11-16'),('2047-11-17'),('2047-11-18'),('2047-11-19'),('2047-11-20'),('2047-11-21'),('2047-11-22'),('2047-11-23'),('2047-11-24'),('2047-11-25'),('2047-11-26'),('2047-11-27'),('2047-11-28'),('2047-11-29'),('2047-11-30'),('2047-12-01'),('2047-12-02'),('2047-12-03'),('2047-12-04'),('2047-12-05'),('2047-12-06'),('2047-12-07'),('2047-12-08'),('2047-12-09'),('2047-12-10'),('2047-12-11'),('2047-12-12'),('2047-12-13'),('2047-12-14'),('2047-12-15'),('2047-12-16'),('2047-12-17'),('2047-12-18'),('2047-12-19'),('2047-12-20'),('2047-12-21'),('2047-12-22'),('2047-12-23'),('2047-12-24'),('2047-12-25'),('2047-12-26'),('2047-12-27'),('2047-12-28'),('2047-12-29'),('2047-12-30'),('2047-12-31'),('2048-01-01'),('2048-01-02'),('2048-01-03'),('2048-01-04'),('2048-01-05'),('2048-01-06'),('2048-01-07'),('2048-01-08'),('2048-01-09'),('2048-01-10'),('2048-01-11'),('2048-01-12'),('2048-01-13'),('2048-01-14'),('2048-01-15'),('2048-01-16'),('2048-01-17'),('2048-01-18'),('2048-01-19'),('2048-01-20'),('2048-01-21'),('2048-01-22'),('2048-01-23'),('2048-01-24'),('2048-01-25'),('2048-01-26'),('2048-01-27'),('2048-01-28'),('2048-01-29'),('2048-01-30'),('2048-01-31'),('2048-02-01'),('2048-02-02'),('2048-02-03'),('2048-02-04'),('2048-02-05'),('2048-02-06'),('2048-02-07'),('2048-02-08'),('2048-02-09'),('2048-02-10'),('2048-02-11'),('2048-02-12'),('2048-02-13'),('2048-02-14'),('2048-02-15'),('2048-02-16'),('2048-02-17'),('2048-02-18'),('2048-02-19'),('2048-02-20'),('2048-02-21'),('2048-02-22'),('2048-02-23'),('2048-02-24'),('2048-02-25'),('2048-02-26'),('2048-02-27'),('2048-02-28'),('2048-02-29'),('2048-03-01'),('2048-03-02'),('2048-03-03'),('2048-03-04'),('2048-03-05'),('2048-03-06'),('2048-03-07'),('2048-03-08'),('2048-03-09'),('2048-03-10'),('2048-03-11'),('2048-03-12'),('2048-03-13'),('2048-03-14'),('2048-03-15'),('2048-03-16'),('2048-03-17'),('2048-03-18'),('2048-03-19'),('2048-03-20'),('2048-03-21'),('2048-03-22'),('2048-03-23'),('2048-03-24'),('2048-03-25'),('2048-03-26'),('2048-03-27'),('2048-03-28'),('2048-03-29'),('2048-03-30'),('2048-03-31'),('2048-04-01'),('2048-04-02'),('2048-04-03'),('2048-04-04'),('2048-04-05'),('2048-04-06'),('2048-04-07'),('2048-04-08'),('2048-04-09'),('2048-04-10'),('2048-04-11'),('2048-04-12'),('2048-04-13'),('2048-04-14'),('2048-04-15'),('2048-04-16'),('2048-04-17'),('2048-04-18'),('2048-04-19'),('2048-04-20'),('2048-04-21'),('2048-04-22'),('2048-04-23'),('2048-04-24'),('2048-04-25'),('2048-04-26'),('2048-04-27'),('2048-04-28'),('2048-04-29'),('2048-04-30'),('2048-05-01'),('2048-05-02'),('2048-05-03'),('2048-05-04'),('2048-05-05'),('2048-05-06'),('2048-05-07'),('2048-05-08'),('2048-05-09'),('2048-05-10'),('2048-05-11'),('2048-05-12'),('2048-05-13'),('2048-05-14'),('2048-05-15'),('2048-05-16'),('2048-05-17'),('2048-05-18'),('2048-05-19'),('2048-05-20'),('2048-05-21'),('2048-05-22'),('2048-05-23'),('2048-05-24'),('2048-05-25'),('2048-05-26'),('2048-05-27'),('2048-05-28'),('2048-05-29'),('2048-05-30'),('2048-05-31'),('2048-06-01'),('2048-06-02'),('2048-06-03'),('2048-06-04'),('2048-06-05'),('2048-06-06'),('2048-06-07'),('2048-06-08'),('2048-06-09'),('2048-06-10'),('2048-06-11'),('2048-06-12'),('2048-06-13'),('2048-06-14'),('2048-06-15'),('2048-06-16'),('2048-06-17'),('2048-06-18'),('2048-06-19'),('2048-06-20'),('2048-06-21'),('2048-06-22'),('2048-06-23'),('2048-06-24'),('2048-06-25'),('2048-06-26'),('2048-06-27'),('2048-06-28'),('2048-06-29'),('2048-06-30'),('2048-07-01'),('2048-07-02'),('2048-07-03'),('2048-07-04'),('2048-07-05'),('2048-07-06'),('2048-07-07'),('2048-07-08'),('2048-07-09'),('2048-07-10'),('2048-07-11'),('2048-07-12'),('2048-07-13'),('2048-07-14'),('2048-07-15'),('2048-07-16'),('2048-07-17'),('2048-07-18'),('2048-07-19'),('2048-07-20'),('2048-07-21'),('2048-07-22'),('2048-07-23'),('2048-07-24'),('2048-07-25'),('2048-07-26'),('2048-07-27'),('2048-07-28'),('2048-07-29'),('2048-07-30'),('2048-07-31'),('2048-08-01'),('2048-08-02'),('2048-08-03'),('2048-08-04'),('2048-08-05'),('2048-08-06'),('2048-08-07'),('2048-08-08'),('2048-08-09'),('2048-08-10'),('2048-08-11'),('2048-08-12'),('2048-08-13'),('2048-08-14'),('2048-08-15'),('2048-08-16'),('2048-08-17'),('2048-08-18'),('2048-08-19'),('2048-08-20'),('2048-08-21'),('2048-08-22'),('2048-08-23'),('2048-08-24'),('2048-08-25'),('2048-08-26'),('2048-08-27'),('2048-08-28'),('2048-08-29'),('2048-08-30'),('2048-08-31'),('2048-09-01'),('2048-09-02'),('2048-09-03'),('2048-09-04'),('2048-09-05'),('2048-09-06'),('2048-09-07'),('2048-09-08'),('2048-09-09'),('2048-09-10'),('2048-09-11'),('2048-09-12'),('2048-09-13'),('2048-09-14'),('2048-09-15'),('2048-09-16'),('2048-09-17'),('2048-09-18'),('2048-09-19'),('2048-09-20'),('2048-09-21'),('2048-09-22'),('2048-09-23'),('2048-09-24'),('2048-09-25'),('2048-09-26'),('2048-09-27'),('2048-09-28'),('2048-09-29'),('2048-09-30'),('2048-10-01'),('2048-10-02'),('2048-10-03'),('2048-10-04'),('2048-10-05'),('2048-10-06'),('2048-10-07'),('2048-10-08'),('2048-10-09'),('2048-10-10'),('2048-10-11'),('2048-10-12'),('2048-10-13'),('2048-10-14'),('2048-10-15'),('2048-10-16'),('2048-10-17'),('2048-10-18'),('2048-10-19'),('2048-10-20'),('2048-10-21'),('2048-10-22'),('2048-10-23'),('2048-10-24'),('2048-10-25'),('2048-10-26'),('2048-10-27'),('2048-10-28'),('2048-10-29'),('2048-10-30'),('2048-10-31'),('2048-11-01'),('2048-11-02'),('2048-11-03'),('2048-11-04'),('2048-11-05'),('2048-11-06'),('2048-11-07'),('2048-11-08'),('2048-11-09'),('2048-11-10'),('2048-11-11'),('2048-11-12'),('2048-11-13'),('2048-11-14'),('2048-11-15'),('2048-11-16'),('2048-11-17'),('2048-11-18'),('2048-11-19'),('2048-11-20'),('2048-11-21'),('2048-11-22'),('2048-11-23'),('2048-11-24'),('2048-11-25'),('2048-11-26'),('2048-11-27'),('2048-11-28'),('2048-11-29'),('2048-11-30'),('2048-12-01'),('2048-12-02'),('2048-12-03'),('2048-12-04'),('2048-12-05'),('2048-12-06'),('2048-12-07'),('2048-12-08'),('2048-12-09'),('2048-12-10'),('2048-12-11'),('2048-12-12'),('2048-12-13'),('2048-12-14'),('2048-12-15'),('2048-12-16'),('2048-12-17'),('2048-12-18'),('2048-12-19'),('2048-12-20'),('2048-12-21'),('2048-12-22'),('2048-12-23'),('2048-12-24'),('2048-12-25'),('2048-12-26'),('2048-12-27'),('2048-12-28'),('2048-12-29'),('2048-12-30'),('2048-12-31'),('2049-01-01'),('2049-01-02'),('2049-01-03'),('2049-01-04'),('2049-01-05'),('2049-01-06'),('2049-01-07'),('2049-01-08'),('2049-01-09'),('2049-01-10'),('2049-01-11'),('2049-01-12'),('2049-01-13'),('2049-01-14'),('2049-01-15'),('2049-01-16'),('2049-01-17'),('2049-01-18'),('2049-01-19'),('2049-01-20'),('2049-01-21'),('2049-01-22'),('2049-01-23'),('2049-01-24'),('2049-01-25'),('2049-01-26'),('2049-01-27'),('2049-01-28'),('2049-01-29'),('2049-01-30'),('2049-01-31'),('2049-02-01'),('2049-02-02'),('2049-02-03'),('2049-02-04'),('2049-02-05'),('2049-02-06'),('2049-02-07'),('2049-02-08'),('2049-02-09'),('2049-02-10'),('2049-02-11'),('2049-02-12'),('2049-02-13'),('2049-02-14'),('2049-02-15'),('2049-02-16'),('2049-02-17'),('2049-02-18'),('2049-02-19'),('2049-02-20'),('2049-02-21'),('2049-02-22'),('2049-02-23'),('2049-02-24'),('2049-02-25'),('2049-02-26'),('2049-02-27'),('2049-02-28'),('2049-03-01'),('2049-03-02'),('2049-03-03'),('2049-03-04'),('2049-03-05'),('2049-03-06'),('2049-03-07'),('2049-03-08'),('2049-03-09'),('2049-03-10'),('2049-03-11'),('2049-03-12'),('2049-03-13'),('2049-03-14'),('2049-03-15'),('2049-03-16'),('2049-03-17'),('2049-03-18'),('2049-03-19'),('2049-03-20'),('2049-03-21'),('2049-03-22'),('2049-03-23'),('2049-03-24'),('2049-03-25'),('2049-03-26'),('2049-03-27'),('2049-03-28'),('2049-03-29'),('2049-03-30'),('2049-03-31'),('2049-04-01'),('2049-04-02'),('2049-04-03'),('2049-04-04'),('2049-04-05'),('2049-04-06'),('2049-04-07'),('2049-04-08'),('2049-04-09'),('2049-04-10'),('2049-04-11'),('2049-04-12'),('2049-04-13'),('2049-04-14'),('2049-04-15'),('2049-04-16'),('2049-04-17'),('2049-04-18'),('2049-04-19'),('2049-04-20'),('2049-04-21'),('2049-04-22'),('2049-04-23'),('2049-04-24'),('2049-04-25'),('2049-04-26'),('2049-04-27'),('2049-04-28'),('2049-04-29'),('2049-04-30'),('2049-05-01'),('2049-05-02'),('2049-05-03'),('2049-05-04'),('2049-05-05'),('2049-05-06'),('2049-05-07'),('2049-05-08'),('2049-05-09'),('2049-05-10'),('2049-05-11'),('2049-05-12'),('2049-05-13'),('2049-05-14'),('2049-05-15'),('2049-05-16'),('2049-05-17'),('2049-05-18'),('2049-05-19'),('2049-05-20'),('2049-05-21'),('2049-05-22'),('2049-05-23'),('2049-05-24'),('2049-05-25'),('2049-05-26'),('2049-05-27'),('2049-05-28'),('2049-05-29'),('2049-05-30'),('2049-05-31'),('2049-06-01'),('2049-06-02'),('2049-06-03'),('2049-06-04'),('2049-06-05'),('2049-06-06'),('2049-06-07'),('2049-06-08'),('2049-06-09'),('2049-06-10'),('2049-06-11'),('2049-06-12'),('2049-06-13'),('2049-06-14'),('2049-06-15'),('2049-06-16'),('2049-06-17'),('2049-06-18'),('2049-06-19'),('2049-06-20'),('2049-06-21'),('2049-06-22'),('2049-06-23'),('2049-06-24'),('2049-06-25'),('2049-06-26'),('2049-06-27'),('2049-06-28'),('2049-06-29'),('2049-06-30'),('2049-07-01'),('2049-07-02'),('2049-07-03'),('2049-07-04'),('2049-07-05'),('2049-07-06'),('2049-07-07'),('2049-07-08'),('2049-07-09'),('2049-07-10'),('2049-07-11'),('2049-07-12'),('2049-07-13'),('2049-07-14'),('2049-07-15'),('2049-07-16'),('2049-07-17'),('2049-07-18'),('2049-07-19'),('2049-07-20'),('2049-07-21'),('2049-07-22'),('2049-07-23'),('2049-07-24'),('2049-07-25'),('2049-07-26'),('2049-07-27'),('2049-07-28'),('2049-07-29'),('2049-07-30'),('2049-07-31'),('2049-08-01'),('2049-08-02'),('2049-08-03'),('2049-08-04'),('2049-08-05'),('2049-08-06'),('2049-08-07'),('2049-08-08'),('2049-08-09'),('2049-08-10'),('2049-08-11'),('2049-08-12'),('2049-08-13'),('2049-08-14'),('2049-08-15'),('2049-08-16'),('2049-08-17'),('2049-08-18'),('2049-08-19'),('2049-08-20'),('2049-08-21'),('2049-08-22'),('2049-08-23'),('2049-08-24'),('2049-08-25'),('2049-08-26'),('2049-08-27'),('2049-08-28'),('2049-08-29'),('2049-08-30'),('2049-08-31'),('2049-09-01'),('2049-09-02'),('2049-09-03'),('2049-09-04'),('2049-09-05'),('2049-09-06'),('2049-09-07'),('2049-09-08'),('2049-09-09'),('2049-09-10'),('2049-09-11'),('2049-09-12'),('2049-09-13'),('2049-09-14'),('2049-09-15'),('2049-09-16'),('2049-09-17'),('2049-09-18'),('2049-09-19'),('2049-09-20'),('2049-09-21'),('2049-09-22'),('2049-09-23'),('2049-09-24'),('2049-09-25'),('2049-09-26'),('2049-09-27'),('2049-09-28'),('2049-09-29'),('2049-09-30'),('2049-10-01'),('2049-10-02'),('2049-10-03'),('2049-10-04'),('2049-10-05'),('2049-10-06'),('2049-10-07'),('2049-10-08'),('2049-10-09'),('2049-10-10'),('2049-10-11'),('2049-10-12'),('2049-10-13'),('2049-10-14'),('2049-10-15'),('2049-10-16'),('2049-10-17'),('2049-10-18'),('2049-10-19'),('2049-10-20'),('2049-10-21'),('2049-10-22'),('2049-10-23'),('2049-10-24'),('2049-10-25'),('2049-10-26'),('2049-10-27'),('2049-10-28'),('2049-10-29'),('2049-10-30'),('2049-10-31'),('2049-11-01'),('2049-11-02'),('2049-11-03'),('2049-11-04'),('2049-11-05'),('2049-11-06'),('2049-11-07'),('2049-11-08'),('2049-11-09'),('2049-11-10'),('2049-11-11'),('2049-11-12'),('2049-11-13'),('2049-11-14'),('2049-11-15'),('2049-11-16'),('2049-11-17'),('2049-11-18'),('2049-11-19'),('2049-11-20'),('2049-11-21'),('2049-11-22'),('2049-11-23'),('2049-11-24'),('2049-11-25'),('2049-11-26'),('2049-11-27'),('2049-11-28'),('2049-11-29'),('2049-11-30'),('2049-12-01'),('2049-12-02'),('2049-12-03'),('2049-12-04'),('2049-12-05'),('2049-12-06'),('2049-12-07'),('2049-12-08'),('2049-12-09'),('2049-12-10'),('2049-12-11'),('2049-12-12'),('2049-12-13'),('2049-12-14'),('2049-12-15'),('2049-12-16'),('2049-12-17'),('2049-12-18'),('2049-12-19'),('2049-12-20'),('2049-12-21'),('2049-12-22'),('2049-12-23'),('2049-12-24'),('2049-12-25'),('2049-12-26'),('2049-12-27'),('2049-12-28'),('2049-12-29'),('2049-12-30'),('2049-12-31'),('2050-01-01'),('2050-01-02'),('2050-01-03'),('2050-01-04'),('2050-01-05'),('2050-01-06'),('2050-01-07'),('2050-01-08'),('2050-01-09'),('2050-01-10'),('2050-01-11'),('2050-01-12'),('2050-01-13'),('2050-01-14'),('2050-01-15'),('2050-01-16'),('2050-01-17'),('2050-01-18'),('2050-01-19'),('2050-01-20'),('2050-01-21'),('2050-01-22'),('2050-01-23'),('2050-01-24'),('2050-01-25'),('2050-01-26'),('2050-01-27'),('2050-01-28'),('2050-01-29'),('2050-01-30'),('2050-01-31'),('2050-02-01'),('2050-02-02'),('2050-02-03'),('2050-02-04'),('2050-02-05'),('2050-02-06'),('2050-02-07'),('2050-02-08'),('2050-02-09'),('2050-02-10'),('2050-02-11'),('2050-02-12'),('2050-02-13'),('2050-02-14'),('2050-02-15'),('2050-02-16'),('2050-02-17'),('2050-02-18'),('2050-02-19'),('2050-02-20'),('2050-02-21'),('2050-02-22'),('2050-02-23'),('2050-02-24'),('2050-02-25'),('2050-02-26'),('2050-02-27'),('2050-02-28'),('2050-03-01'),('2050-03-02'),('2050-03-03'),('2050-03-04'),('2050-03-05'),('2050-03-06'),('2050-03-07'),('2050-03-08'),('2050-03-09'),('2050-03-10'),('2050-03-11'),('2050-03-12'),('2050-03-13'),('2050-03-14'),('2050-03-15'),('2050-03-16'),('2050-03-17'),('2050-03-18'),('2050-03-19'),('2050-03-20'),('2050-03-21'),('2050-03-22'),('2050-03-23'),('2050-03-24'),('2050-03-25'),('2050-03-26'),('2050-03-27'),('2050-03-28'),('2050-03-29'),('2050-03-30'),('2050-03-31'),('2050-04-01'),('2050-04-02'),('2050-04-03'),('2050-04-04'),('2050-04-05'),('2050-04-06'),('2050-04-07'),('2050-04-08'),('2050-04-09'),('2050-04-10'),('2050-04-11'),('2050-04-12'),('2050-04-13'),('2050-04-14'),('2050-04-15'),('2050-04-16'),('2050-04-17'),('2050-04-18'),('2050-04-19'),('2050-04-20'),('2050-04-21'),('2050-04-22'),('2050-04-23'),('2050-04-24'),('2050-04-25'),('2050-04-26'),('2050-04-27'),('2050-04-28'),('2050-04-29'),('2050-04-30'),('2050-05-01'),('2050-05-02'),('2050-05-03'),('2050-05-04'),('2050-05-05'),('2050-05-06'),('2050-05-07'),('2050-05-08'),('2050-05-09'),('2050-05-10'),('2050-05-11'),('2050-05-12'),('2050-05-13'),('2050-05-14'),('2050-05-15'),('2050-05-16'),('2050-05-17'),('2050-05-18'),('2050-05-19'),('2050-05-20'),('2050-05-21'),('2050-05-22'),('2050-05-23'),('2050-05-24'),('2050-05-25'),('2050-05-26'),('2050-05-27'),('2050-05-28'),('2050-05-29'),('2050-05-30'),('2050-05-31'),('2050-06-01'),('2050-06-02'),('2050-06-03'),('2050-06-04'),('2050-06-05'),('2050-06-06'),('2050-06-07'),('2050-06-08'),('2050-06-09'),('2050-06-10'),('2050-06-11'),('2050-06-12'),('2050-06-13'),('2050-06-14'),('2050-06-15'),('2050-06-16'),('2050-06-17'),('2050-06-18'),('2050-06-19'),('2050-06-20'),('2050-06-21'),('2050-06-22'),('2050-06-23'),('2050-06-24'),('2050-06-25'),('2050-06-26'),('2050-06-27'),('2050-06-28'),('2050-06-29'),('2050-06-30'),('2050-07-01'),('2050-07-02'),('2050-07-03'),('2050-07-04'),('2050-07-05'),('2050-07-06'),('2050-07-07'),('2050-07-08'),('2050-07-09'),('2050-07-10'),('2050-07-11'),('2050-07-12'),('2050-07-13'),('2050-07-14'),('2050-07-15'),('2050-07-16'),('2050-07-17'),('2050-07-18'),('2050-07-19'),('2050-07-20'),('2050-07-21'),('2050-07-22'),('2050-07-23'),('2050-07-24'),('2050-07-25'),('2050-07-26'),('2050-07-27'),('2050-07-28'),('2050-07-29'),('2050-07-30'),('2050-07-31'),('2050-08-01'),('2050-08-02'),('2050-08-03'),('2050-08-04'),('2050-08-05'),('2050-08-06'),('2050-08-07'),('2050-08-08'),('2050-08-09'),('2050-08-10'),('2050-08-11'),('2050-08-12'),('2050-08-13'),('2050-08-14'),('2050-08-15'),('2050-08-16'),('2050-08-17'),('2050-08-18'),('2050-08-19'),('2050-08-20'),('2050-08-21'),('2050-08-22'),('2050-08-23'),('2050-08-24'),('2050-08-25'),('2050-08-26'),('2050-08-27'),('2050-08-28'),('2050-08-29'),('2050-08-30'),('2050-08-31'),('2050-09-01'),('2050-09-02'),('2050-09-03'),('2050-09-04'),('2050-09-05'),('2050-09-06'),('2050-09-07'),('2050-09-08'),('2050-09-09'),('2050-09-10'),('2050-09-11'),('2050-09-12'),('2050-09-13'),('2050-09-14'),('2050-09-15'),('2050-09-16'),('2050-09-17'),('2050-09-18'),('2050-09-19'),('2050-09-20'),('2050-09-21'),('2050-09-22'),('2050-09-23'),('2050-09-24'),('2050-09-25'),('2050-09-26'),('2050-09-27'),('2050-09-28'),('2050-09-29'),('2050-09-30'),('2050-10-01'),('2050-10-02'),('2050-10-03'),('2050-10-04'),('2050-10-05'),('2050-10-06'),('2050-10-07'),('2050-10-08'),('2050-10-09'),('2050-10-10'),('2050-10-11'),('2050-10-12'),('2050-10-13'),('2050-10-14'),('2050-10-15'),('2050-10-16'),('2050-10-17'),('2050-10-18'),('2050-10-19'),('2050-10-20'),('2050-10-21'),('2050-10-22'),('2050-10-23'),('2050-10-24'),('2050-10-25'),('2050-10-26'),('2050-10-27'),('2050-10-28'),('2050-10-29'),('2050-10-30'),('2050-10-31'),('2050-11-01'),('2050-11-02'),('2050-11-03'),('2050-11-04'),('2050-11-05'),('2050-11-06'),('2050-11-07'),('2050-11-08'),('2050-11-09'),('2050-11-10'),('2050-11-11'),('2050-11-12'),('2050-11-13'),('2050-11-14'),('2050-11-15'),('2050-11-16'),('2050-11-17'),('2050-11-18'),('2050-11-19'),('2050-11-20'),('2050-11-21'),('2050-11-22'),('2050-11-23'),('2050-11-24'),('2050-11-25'),('2050-11-26'),('2050-11-27'),('2050-11-28'),('2050-11-29'),('2050-11-30'),('2050-12-01'),('2050-12-02'),('2050-12-03'),('2050-12-04'),('2050-12-05'),('2050-12-06'),('2050-12-07'),('2050-12-08'),('2050-12-09'),('2050-12-10'),('2050-12-11'),('2050-12-12'),('2050-12-13'),('2050-12-14'),('2050-12-15'),('2050-12-16'),('2050-12-17'),('2050-12-18'),('2050-12-19'),('2050-12-20'),('2050-12-21'),('2050-12-22'),('2050-12-23'),('2050-12-24'),('2050-12-25'),('2050-12-26'),('2050-12-27'),('2050-12-28'),('2050-12-29'),('2050-12-30'),('2050-12-31'),('2051-01-01'),('2051-01-02'),('2051-01-03'),('2051-01-04'),('2051-01-05'),('2051-01-06'),('2051-01-07'),('2051-01-08'),('2051-01-09'),('2051-01-10'),('2051-01-11'),('2051-01-12'),('2051-01-13'),('2051-01-14'),('2051-01-15'),('2051-01-16'),('2051-01-17'),('2051-01-18'),('2051-01-19'),('2051-01-20'),('2051-01-21'),('2051-01-22'),('2051-01-23'),('2051-01-24'),('2051-01-25'),('2051-01-26'),('2051-01-27'),('2051-01-28'),('2051-01-29'),('2051-01-30'),('2051-01-31'),('2051-02-01'),('2051-02-02'),('2051-02-03'),('2051-02-04'),('2051-02-05'),('2051-02-06'),('2051-02-07'),('2051-02-08'),('2051-02-09'),('2051-02-10'),('2051-02-11'),('2051-02-12'),('2051-02-13'),('2051-02-14'),('2051-02-15'),('2051-02-16'),('2051-02-17'),('2051-02-18'),('2051-02-19'),('2051-02-20'),('2051-02-21'),('2051-02-22'),('2051-02-23'),('2051-02-24'),('2051-02-25'),('2051-02-26'),('2051-02-27'),('2051-02-28'),('2051-03-01'),('2051-03-02'),('2051-03-03'),('2051-03-04'),('2051-03-05'),('2051-03-06'),('2051-03-07'),('2051-03-08'),('2051-03-09'),('2051-03-10'),('2051-03-11'),('2051-03-12'),('2051-03-13'),('2051-03-14'),('2051-03-15'),('2051-03-16'),('2051-03-17'),('2051-03-18'),('2051-03-19'),('2051-03-20'),('2051-03-21'),('2051-03-22'),('2051-03-23'),('2051-03-24'),('2051-03-25'),('2051-03-26'),('2051-03-27'),('2051-03-28'),('2051-03-29'),('2051-03-30'),('2051-03-31'),('2051-04-01'),('2051-04-02'),('2051-04-03'),('2051-04-04'),('2051-04-05'),('2051-04-06'),('2051-04-07'),('2051-04-08'),('2051-04-09'),('2051-04-10'),('2051-04-11'),('2051-04-12'),('2051-04-13'),('2051-04-14'),('2051-04-15'),('2051-04-16'),('2051-04-17'),('2051-04-18'),('2051-04-19'),('2051-04-20'),('2051-04-21'),('2051-04-22'),('2051-04-23'),('2051-04-24'),('2051-04-25'),('2051-04-26'),('2051-04-27'),('2051-04-28'),('2051-04-29'),('2051-04-30'),('2051-05-01'),('2051-05-02'),('2051-05-03'),('2051-05-04'),('2051-05-05'),('2051-05-06'),('2051-05-07'),('2051-05-08'),('2051-05-09'),('2051-05-10'),('2051-05-11'),('2051-05-12'),('2051-05-13'),('2051-05-14'),('2051-05-15'),('2051-05-16'),('2051-05-17'),('2051-05-18'),('2051-05-19'),('2051-05-20'),('2051-05-21'),('2051-05-22'),('2051-05-23'),('2051-05-24'),('2051-05-25'),('2051-05-26'),('2051-05-27'),('2051-05-28'),('2051-05-29'),('2051-05-30'),('2051-05-31'),('2051-06-01'),('2051-06-02'),('2051-06-03'),('2051-06-04'),('2051-06-05'),('2051-06-06'),('2051-06-07'),('2051-06-08'),('2051-06-09'),('2051-06-10'),('2051-06-11'),('2051-06-12'),('2051-06-13'),('2051-06-14'),('2051-06-15'),('2051-06-16'),('2051-06-17'),('2051-06-18'),('2051-06-19'),('2051-06-20'),('2051-06-21'),('2051-06-22'),('2051-06-23'),('2051-06-24'),('2051-06-25'),('2051-06-26'),('2051-06-27'),('2051-06-28'),('2051-06-29'),('2051-06-30'),('2051-07-01'),('2051-07-02'),('2051-07-03'),('2051-07-04'),('2051-07-05'),('2051-07-06'),('2051-07-07'),('2051-07-08'),('2051-07-09'),('2051-07-10'),('2051-07-11'),('2051-07-12'),('2051-07-13'),('2051-07-14'),('2051-07-15'),('2051-07-16'),('2051-07-17'),('2051-07-18'),('2051-07-19'),('2051-07-20'),('2051-07-21'),('2051-07-22'),('2051-07-23'),('2051-07-24'),('2051-07-25'),('2051-07-26'),('2051-07-27'),('2051-07-28'),('2051-07-29'),('2051-07-30'),('2051-07-31'),('2051-08-01'),('2051-08-02'),('2051-08-03'),('2051-08-04'),('2051-08-05'),('2051-08-06'),('2051-08-07'),('2051-08-08'),('2051-08-09'),('2051-08-10'),('2051-08-11'),('2051-08-12'),('2051-08-13'),('2051-08-14'),('2051-08-15'),('2051-08-16'),('2051-08-17'),('2051-08-18'),('2051-08-19'),('2051-08-20'),('2051-08-21'),('2051-08-22'),('2051-08-23'),('2051-08-24'),('2051-08-25'),('2051-08-26'),('2051-08-27'),('2051-08-28'),('2051-08-29'),('2051-08-30'),('2051-08-31'),('2051-09-01'),('2051-09-02'),('2051-09-03'),('2051-09-04'),('2051-09-05'),('2051-09-06'),('2051-09-07'),('2051-09-08'),('2051-09-09'),('2051-09-10'),('2051-09-11'),('2051-09-12'),('2051-09-13'),('2051-09-14'),('2051-09-15'),('2051-09-16'),('2051-09-17'),('2051-09-18'),('2051-09-19'),('2051-09-20'),('2051-09-21'),('2051-09-22'),('2051-09-23'),('2051-09-24'),('2051-09-25'),('2051-09-26'),('2051-09-27'),('2051-09-28'),('2051-09-29'),('2051-09-30'),('2051-10-01'),('2051-10-02'),('2051-10-03'),('2051-10-04'),('2051-10-05'),('2051-10-06'),('2051-10-07'),('2051-10-08'),('2051-10-09'),('2051-10-10'),('2051-10-11'),('2051-10-12'),('2051-10-13'),('2051-10-14'),('2051-10-15'),('2051-10-16'),('2051-10-17'),('2051-10-18'),('2051-10-19'),('2051-10-20'),('2051-10-21'),('2051-10-22'),('2051-10-23'),('2051-10-24'),('2051-10-25'),('2051-10-26'),('2051-10-27'),('2051-10-28'),('2051-10-29'),('2051-10-30'),('2051-10-31'),('2051-11-01'),('2051-11-02'),('2051-11-03'),('2051-11-04'),('2051-11-05'),('2051-11-06'),('2051-11-07'),('2051-11-08'),('2051-11-09'),('2051-11-10'),('2051-11-11'),('2051-11-12'),('2051-11-13'),('2051-11-14'),('2051-11-15'),('2051-11-16'),('2051-11-17'),('2051-11-18'),('2051-11-19'),('2051-11-20'),('2051-11-21'),('2051-11-22'),('2051-11-23'),('2051-11-24'),('2051-11-25'),('2051-11-26'),('2051-11-27'),('2051-11-28'),('2051-11-29'),('2051-11-30'),('2051-12-01'),('2051-12-02'),('2051-12-03'),('2051-12-04'),('2051-12-05'),('2051-12-06'),('2051-12-07'),('2051-12-08'),('2051-12-09'),('2051-12-10'),('2051-12-11'),('2051-12-12'),('2051-12-13'),('2051-12-14'),('2051-12-15'),('2051-12-16'),('2051-12-17'),('2051-12-18'),('2051-12-19'),('2051-12-20'),('2051-12-21'),('2051-12-22'),('2051-12-23'),('2051-12-24'),('2051-12-25'),('2051-12-26'),('2051-12-27'),('2051-12-28'),('2051-12-29'),('2051-12-30'),('2051-12-31'),('2052-01-01'),('2052-01-02'),('2052-01-03'),('2052-01-04'),('2052-01-05'),('2052-01-06'),('2052-01-07'),('2052-01-08'),('2052-01-09'),('2052-01-10'),('2052-01-11'),('2052-01-12'),('2052-01-13'),('2052-01-14'),('2052-01-15'),('2052-01-16'),('2052-01-17'),('2052-01-18'),('2052-01-19'),('2052-01-20'),('2052-01-21'),('2052-01-22'),('2052-01-23'),('2052-01-24'),('2052-01-25'),('2052-01-26'),('2052-01-27'),('2052-01-28'),('2052-01-29'),('2052-01-30'),('2052-01-31'),('2052-02-01'),('2052-02-02'),('2052-02-03'),('2052-02-04'),('2052-02-05'),('2052-02-06'),('2052-02-07'),('2052-02-08'),('2052-02-09'),('2052-02-10'),('2052-02-11'),('2052-02-12'),('2052-02-13'),('2052-02-14'),('2052-02-15'),('2052-02-16'),('2052-02-17'),('2052-02-18'),('2052-02-19'),('2052-02-20'),('2052-02-21'),('2052-02-22'),('2052-02-23'),('2052-02-24'),('2052-02-25'),('2052-02-26'),('2052-02-27'),('2052-02-28'),('2052-02-29'),('2052-03-01'),('2052-03-02'),('2052-03-03'),('2052-03-04'),('2052-03-05'),('2052-03-06'),('2052-03-07'),('2052-03-08'),('2052-03-09'),('2052-03-10'),('2052-03-11'),('2052-03-12'),('2052-03-13'),('2052-03-14'),('2052-03-15'),('2052-03-16'),('2052-03-17'),('2052-03-18'),('2052-03-19'),('2052-03-20'),('2052-03-21'),('2052-03-22'),('2052-03-23'),('2052-03-24'),('2052-03-25'),('2052-03-26'),('2052-03-27'),('2052-03-28'),('2052-03-29'),('2052-03-30'),('2052-03-31'),('2052-04-01'),('2052-04-02'),('2052-04-03'),('2052-04-04'),('2052-04-05'),('2052-04-06'),('2052-04-07'),('2052-04-08'),('2052-04-09'),('2052-04-10'),('2052-04-11'),('2052-04-12'),('2052-04-13'),('2052-04-14'),('2052-04-15'),('2052-04-16'),('2052-04-17'),('2052-04-18'),('2052-04-19'),('2052-04-20'),('2052-04-21'),('2052-04-22'),('2052-04-23'),('2052-04-24'),('2052-04-25'),('2052-04-26'),('2052-04-27'),('2052-04-28'),('2052-04-29'),('2052-04-30'),('2052-05-01'),('2052-05-02'),('2052-05-03'),('2052-05-04'),('2052-05-05'),('2052-05-06'),('2052-05-07'),('2052-05-08'),('2052-05-09'),('2052-05-10'),('2052-05-11'),('2052-05-12'),('2052-05-13'),('2052-05-14'),('2052-05-15'),('2052-05-16'),('2052-05-17'),('2052-05-18'),('2052-05-19'),('2052-05-20'),('2052-05-21'),('2052-05-22'),('2052-05-23'),('2052-05-24'),('2052-05-25'),('2052-05-26'),('2052-05-27'),('2052-05-28'),('2052-05-29'),('2052-05-30'),('2052-05-31'),('2052-06-01'),('2052-06-02'),('2052-06-03'),('2052-06-04'),('2052-06-05'),('2052-06-06'),('2052-06-07'),('2052-06-08'),('2052-06-09'),('2052-06-10'),('2052-06-11'),('2052-06-12'),('2052-06-13'),('2052-06-14'),('2052-06-15'),('2052-06-16'),('2052-06-17'),('2052-06-18'),('2052-06-19'),('2052-06-20'),('2052-06-21'),('2052-06-22'),('2052-06-23'),('2052-06-24'),('2052-06-25'),('2052-06-26'),('2052-06-27'),('2052-06-28'),('2052-06-29'),('2052-06-30'),('2052-07-01'),('2052-07-02'),('2052-07-03'),('2052-07-04'),('2052-07-05'),('2052-07-06'),('2052-07-07'),('2052-07-08'),('2052-07-09'),('2052-07-10'),('2052-07-11'),('2052-07-12'),('2052-07-13'),('2052-07-14'),('2052-07-15'),('2052-07-16'),('2052-07-17'),('2052-07-18'),('2052-07-19'),('2052-07-20'),('2052-07-21'),('2052-07-22'),('2052-07-23'),('2052-07-24'),('2052-07-25'),('2052-07-26'),('2052-07-27'),('2052-07-28'),('2052-07-29'),('2052-07-30'),('2052-07-31'),('2052-08-01'),('2052-08-02'),('2052-08-03'),('2052-08-04'),('2052-08-05'),('2052-08-06'),('2052-08-07'),('2052-08-08'),('2052-08-09'),('2052-08-10'),('2052-08-11'),('2052-08-12'),('2052-08-13'),('2052-08-14'),('2052-08-15'),('2052-08-16'),('2052-08-17'),('2052-08-18'),('2052-08-19'),('2052-08-20'),('2052-08-21'),('2052-08-22'),('2052-08-23'),('2052-08-24'),('2052-08-25'),('2052-08-26'),('2052-08-27'),('2052-08-28'),('2052-08-29'),('2052-08-30'),('2052-08-31'),('2052-09-01'),('2052-09-02'),('2052-09-03'),('2052-09-04'),('2052-09-05'),('2052-09-06'),('2052-09-07'),('2052-09-08'),('2052-09-09'),('2052-09-10'),('2052-09-11'),('2052-09-12'),('2052-09-13'),('2052-09-14'),('2052-09-15'),('2052-09-16'),('2052-09-17'),('2052-09-18'),('2052-09-19'),('2052-09-20'),('2052-09-21'),('2052-09-22'),('2052-09-23'),('2052-09-24'),('2052-09-25'),('2052-09-26'),('2052-09-27'),('2052-09-28'),('2052-09-29'),('2052-09-30'),('2052-10-01'),('2052-10-02'),('2052-10-03'),('2052-10-04'),('2052-10-05'),('2052-10-06'),('2052-10-07'),('2052-10-08'),('2052-10-09'),('2052-10-10'),('2052-10-11'),('2052-10-12'),('2052-10-13'),('2052-10-14'),('2052-10-15'),('2052-10-16'),('2052-10-17'),('2052-10-18'),('2052-10-19'),('2052-10-20'),('2052-10-21'),('2052-10-22'),('2052-10-23'),('2052-10-24'),('2052-10-25'),('2052-10-26'),('2052-10-27'),('2052-10-28'),('2052-10-29'),('2052-10-30'),('2052-10-31'),('2052-11-01'),('2052-11-02'),('2052-11-03'),('2052-11-04'),('2052-11-05'),('2052-11-06'),('2052-11-07'),('2052-11-08'),('2052-11-09'),('2052-11-10'),('2052-11-11'),('2052-11-12'),('2052-11-13'),('2052-11-14'),('2052-11-15'),('2052-11-16'),('2052-11-17'),('2052-11-18'),('2052-11-19'),('2052-11-20'),('2052-11-21'),('2052-11-22'),('2052-11-23'),('2052-11-24'),('2052-11-25'),('2052-11-26'),('2052-11-27'),('2052-11-28'),('2052-11-29'),('2052-11-30'),('2052-12-01'),('2052-12-02'),('2052-12-03'),('2052-12-04'),('2052-12-05'),('2052-12-06'),('2052-12-07'),('2052-12-08'),('2052-12-09'),('2052-12-10'),('2052-12-11'),('2052-12-12'),('2052-12-13'),('2052-12-14'),('2052-12-15'),('2052-12-16'),('2052-12-17'),('2052-12-18'),('2052-12-19'),('2052-12-20'),('2052-12-21'),('2052-12-22'),('2052-12-23'),('2052-12-24'),('2052-12-25'),('2052-12-26'),('2052-12-27'),('2052-12-28'),('2052-12-29'),('2052-12-30'),('2052-12-31'),('2053-01-01'),('2053-01-02'),('2053-01-03'),('2053-01-04'),('2053-01-05'),('2053-01-06'),('2053-01-07'),('2053-01-08'),('2053-01-09'),('2053-01-10'),('2053-01-11'),('2053-01-12'),('2053-01-13'),('2053-01-14'),('2053-01-15'),('2053-01-16'),('2053-01-17'),('2053-01-18'),('2053-01-19'),('2053-01-20'),('2053-01-21'),('2053-01-22'),('2053-01-23'),('2053-01-24'),('2053-01-25'),('2053-01-26'),('2053-01-27'),('2053-01-28'),('2053-01-29'),('2053-01-30'),('2053-01-31'),('2053-02-01'),('2053-02-02'),('2053-02-03'),('2053-02-04'),('2053-02-05'),('2053-02-06'),('2053-02-07'),('2053-02-08'),('2053-02-09'),('2053-02-10'),('2053-02-11'),('2053-02-12'),('2053-02-13'),('2053-02-14'),('2053-02-15'),('2053-02-16'),('2053-02-17'),('2053-02-18'),('2053-02-19'),('2053-02-20'),('2053-02-21'),('2053-02-22'),('2053-02-23'),('2053-02-24'),('2053-02-25'),('2053-02-26'),('2053-02-27'),('2053-02-28'),('2053-03-01'),('2053-03-02'),('2053-03-03'),('2053-03-04'),('2053-03-05'),('2053-03-06'),('2053-03-07'),('2053-03-08'),('2053-03-09'),('2053-03-10'),('2053-03-11'),('2053-03-12'),('2053-03-13'),('2053-03-14'),('2053-03-15'),('2053-03-16'),('2053-03-17'),('2053-03-18'),('2053-03-19'),('2053-03-20'),('2053-03-21'),('2053-03-22'),('2053-03-23'),('2053-03-24'),('2053-03-25'),('2053-03-26'),('2053-03-27'),('2053-03-28'),('2053-03-29'),('2053-03-30'),('2053-03-31'),('2053-04-01'),('2053-04-02'),('2053-04-03'),('2053-04-04'),('2053-04-05'),('2053-04-06'),('2053-04-07'),('2053-04-08'),('2053-04-09'),('2053-04-10'),('2053-04-11'),('2053-04-12'),('2053-04-13'),('2053-04-14'),('2053-04-15'),('2053-04-16'),('2053-04-17'),('2053-04-18'),('2053-04-19'),('2053-04-20'),('2053-04-21'),('2053-04-22'),('2053-04-23'),('2053-04-24'),('2053-04-25'),('2053-04-26'),('2053-04-27'),('2053-04-28'),('2053-04-29'),('2053-04-30'),('2053-05-01'),('2053-05-02'),('2053-05-03'),('2053-05-04'),('2053-05-05'),('2053-05-06'),('2053-05-07'),('2053-05-08'),('2053-05-09'),('2053-05-10'),('2053-05-11'),('2053-05-12'),('2053-05-13'),('2053-05-14'),('2053-05-15'),('2053-05-16'),('2053-05-17'),('2053-05-18'),('2053-05-19'),('2053-05-20'),('2053-05-21'),('2053-05-22'),('2053-05-23'),('2053-05-24'),('2053-05-25'),('2053-05-26'),('2053-05-27'),('2053-05-28'),('2053-05-29'),('2053-05-30'),('2053-05-31'),('2053-06-01'),('2053-06-02'),('2053-06-03'),('2053-06-04'),('2053-06-05'),('2053-06-06'),('2053-06-07'),('2053-06-08'),('2053-06-09'),('2053-06-10'),('2053-06-11'),('2053-06-12'),('2053-06-13'),('2053-06-14'),('2053-06-15'),('2053-06-16'),('2053-06-17'),('2053-06-18'),('2053-06-19'),('2053-06-20'),('2053-06-21'),('2053-06-22'),('2053-06-23'),('2053-06-24'),('2053-06-25'),('2053-06-26'),('2053-06-27'),('2053-06-28'),('2053-06-29'),('2053-06-30'),('2053-07-01'),('2053-07-02'),('2053-07-03'),('2053-07-04'),('2053-07-05'),('2053-07-06'),('2053-07-07'),('2053-07-08'),('2053-07-09'),('2053-07-10'),('2053-07-11'),('2053-07-12'),('2053-07-13'),('2053-07-14'),('2053-07-15'),('2053-07-16'),('2053-07-17'),('2053-07-18'),('2053-07-19'),('2053-07-20'),('2053-07-21'),('2053-07-22'),('2053-07-23'),('2053-07-24'),('2053-07-25'),('2053-07-26'),('2053-07-27'),('2053-07-28'),('2053-07-29'),('2053-07-30'),('2053-07-31'),('2053-08-01'),('2053-08-02'),('2053-08-03'),('2053-08-04'),('2053-08-05'),('2053-08-06'),('2053-08-07'),('2053-08-08'),('2053-08-09'),('2053-08-10'),('2053-08-11'),('2053-08-12'),('2053-08-13'),('2053-08-14'),('2053-08-15'),('2053-08-16'),('2053-08-17'),('2053-08-18'),('2053-08-19'),('2053-08-20'),('2053-08-21'),('2053-08-22'),('2053-08-23'),('2053-08-24'),('2053-08-25'),('2053-08-26'),('2053-08-27'),('2053-08-28'),('2053-08-29'),('2053-08-30'),('2053-08-31'),('2053-09-01'),('2053-09-02'),('2053-09-03'),('2053-09-04'),('2053-09-05'),('2053-09-06'),('2053-09-07'),('2053-09-08'),('2053-09-09'),('2053-09-10'),('2053-09-11'),('2053-09-12'),('2053-09-13'),('2053-09-14'),('2053-09-15'),('2053-09-16'),('2053-09-17'),('2053-09-18'),('2053-09-19'),('2053-09-20'),('2053-09-21'),('2053-09-22'),('2053-09-23'),('2053-09-24'),('2053-09-25'),('2053-09-26'),('2053-09-27'),('2053-09-28'),('2053-09-29'),('2053-09-30'),('2053-10-01'),('2053-10-02'),('2053-10-03'),('2053-10-04'),('2053-10-05'),('2053-10-06'),('2053-10-07'),('2053-10-08'),('2053-10-09'),('2053-10-10'),('2053-10-11'),('2053-10-12'),('2053-10-13'),('2053-10-14'),('2053-10-15'),('2053-10-16'),('2053-10-17'),('2053-10-18'),('2053-10-19'),('2053-10-20'),('2053-10-21'),('2053-10-22'),('2053-10-23'),('2053-10-24'),('2053-10-25'),('2053-10-26'),('2053-10-27'),('2053-10-28'),('2053-10-29'),('2053-10-30'),('2053-10-31'),('2053-11-01'),('2053-11-02'),('2053-11-03'),('2053-11-04'),('2053-11-05'),('2053-11-06'),('2053-11-07'),('2053-11-08'),('2053-11-09'),('2053-11-10'),('2053-11-11'),('2053-11-12'),('2053-11-13'),('2053-11-14'),('2053-11-15'),('2053-11-16'),('2053-11-17'),('2053-11-18'),('2053-11-19'),('2053-11-20'),('2053-11-21'),('2053-11-22'),('2053-11-23'),('2053-11-24'),('2053-11-25'),('2053-11-26'),('2053-11-27'),('2053-11-28'),('2053-11-29'),('2053-11-30'),('2053-12-01'),('2053-12-02'),('2053-12-03'),('2053-12-04'),('2053-12-05'),('2053-12-06'),('2053-12-07'),('2053-12-08'),('2053-12-09'),('2053-12-10'),('2053-12-11'),('2053-12-12'),('2053-12-13'),('2053-12-14'),('2053-12-15'),('2053-12-16'),('2053-12-17'),('2053-12-18'),('2053-12-19'),('2053-12-20'),('2053-12-21'),('2053-12-22'),('2053-12-23'),('2053-12-24'),('2053-12-25'),('2053-12-26'),('2053-12-27'),('2053-12-28'),('2053-12-29'),('2053-12-30'),('2053-12-31'),('2054-01-01'),('2054-01-02'),('2054-01-03'),('2054-01-04'),('2054-01-05'),('2054-01-06'),('2054-01-07'),('2054-01-08'),('2054-01-09'),('2054-01-10'),('2054-01-11'),('2054-01-12'),('2054-01-13'),('2054-01-14'),('2054-01-15'),('2054-01-16'),('2054-01-17'),('2054-01-18'),('2054-01-19'),('2054-01-20'),('2054-01-21'),('2054-01-22'),('2054-01-23'),('2054-01-24'),('2054-01-25'),('2054-01-26'),('2054-01-27'),('2054-01-28'),('2054-01-29'),('2054-01-30'),('2054-01-31'),('2054-02-01'),('2054-02-02'),('2054-02-03'),('2054-02-04'),('2054-02-05'),('2054-02-06'),('2054-02-07'),('2054-02-08'),('2054-02-09'),('2054-02-10'),('2054-02-11'),('2054-02-12'),('2054-02-13'),('2054-02-14'),('2054-02-15'),('2054-02-16'),('2054-02-17'),('2054-02-18'),('2054-02-19'),('2054-02-20'),('2054-02-21'),('2054-02-22'),('2054-02-23'),('2054-02-24'),('2054-02-25'),('2054-02-26'),('2054-02-27'),('2054-02-28'),('2054-03-01'),('2054-03-02'),('2054-03-03'),('2054-03-04'),('2054-03-05'),('2054-03-06'),('2054-03-07'),('2054-03-08'),('2054-03-09'),('2054-03-10'),('2054-03-11'),('2054-03-12'),('2054-03-13'),('2054-03-14'),('2054-03-15'),('2054-03-16'),('2054-03-17'),('2054-03-18'),('2054-03-19'),('2054-03-20'),('2054-03-21'),('2054-03-22'),('2054-03-23'),('2054-03-24'),('2054-03-25'),('2054-03-26'),('2054-03-27'),('2054-03-28'),('2054-03-29'),('2054-03-30'),('2054-03-31'),('2054-04-01'),('2054-04-02'),('2054-04-03'),('2054-04-04'),('2054-04-05'),('2054-04-06'),('2054-04-07'),('2054-04-08'),('2054-04-09'),('2054-04-10'),('2054-04-11'),('2054-04-12'),('2054-04-13'),('2054-04-14'),('2054-04-15'),('2054-04-16'),('2054-04-17'),('2054-04-18'),('2054-04-19'),('2054-04-20'),('2054-04-21'),('2054-04-22'),('2054-04-23'),('2054-04-24'),('2054-04-25'),('2054-04-26'),('2054-04-27'),('2054-04-28'),('2054-04-29'),('2054-04-30'),('2054-05-01'),('2054-05-02'),('2054-05-03'),('2054-05-04'),('2054-05-05'),('2054-05-06'),('2054-05-07'),('2054-05-08'),('2054-05-09'),('2054-05-10'),('2054-05-11'),('2054-05-12'),('2054-05-13'),('2054-05-14'),('2054-05-15'),('2054-05-16'),('2054-05-17'),('2054-05-18'),('2054-05-19'),('2054-05-20'),('2054-05-21'),('2054-05-22'),('2054-05-23'),('2054-05-24'),('2054-05-25'),('2054-05-26'),('2054-05-27'),('2054-05-28'),('2054-05-29'),('2054-05-30'),('2054-05-31'),('2054-06-01'),('2054-06-02'),('2054-06-03'),('2054-06-04'),('2054-06-05'),('2054-06-06'),('2054-06-07'),('2054-06-08'),('2054-06-09'),('2054-06-10'),('2054-06-11'),('2054-06-12'),('2054-06-13'),('2054-06-14'),('2054-06-15'),('2054-06-16'),('2054-06-17'),('2054-06-18'),('2054-06-19'),('2054-06-20'),('2054-06-21'),('2054-06-22'),('2054-06-23'),('2054-06-24'),('2054-06-25'),('2054-06-26'),('2054-06-27'),('2054-06-28'),('2054-06-29'),('2054-06-30'),('2054-07-01'),('2054-07-02'),('2054-07-03'),('2054-07-04'),('2054-07-05'),('2054-07-06'),('2054-07-07'),('2054-07-08'),('2054-07-09'),('2054-07-10'),('2054-07-11'),('2054-07-12'),('2054-07-13'),('2054-07-14'),('2054-07-15'),('2054-07-16'),('2054-07-17'),('2054-07-18'),('2054-07-19'),('2054-07-20'),('2054-07-21'),('2054-07-22'),('2054-07-23'),('2054-07-24'),('2054-07-25'),('2054-07-26'),('2054-07-27'),('2054-07-28'),('2054-07-29'),('2054-07-30'),('2054-07-31'),('2054-08-01'),('2054-08-02'),('2054-08-03'),('2054-08-04'),('2054-08-05'),('2054-08-06'),('2054-08-07'),('2054-08-08'),('2054-08-09'),('2054-08-10'),('2054-08-11'),('2054-08-12'),('2054-08-13'),('2054-08-14'),('2054-08-15'),('2054-08-16'),('2054-08-17'),('2054-08-18'),('2054-08-19'),('2054-08-20'),('2054-08-21'),('2054-08-22'),('2054-08-23'),('2054-08-24'),('2054-08-25'),('2054-08-26'),('2054-08-27'),('2054-08-28'),('2054-08-29'),('2054-08-30'),('2054-08-31'),('2054-09-01'),('2054-09-02'),('2054-09-03'),('2054-09-04'),('2054-09-05'),('2054-09-06'),('2054-09-07'),('2054-09-08'),('2054-09-09'),('2054-09-10'),('2054-09-11'),('2054-09-12'),('2054-09-13'),('2054-09-14'),('2054-09-15'),('2054-09-16'),('2054-09-17'),('2054-09-18'),('2054-09-19'),('2054-09-20'),('2054-09-21'),('2054-09-22'),('2054-09-23'),('2054-09-24'),('2054-09-25'),('2054-09-26'),('2054-09-27'),('2054-09-28'),('2054-09-29'),('2054-09-30'),('2054-10-01'),('2054-10-02'),('2054-10-03'),('2054-10-04'),('2054-10-05'),('2054-10-06'),('2054-10-07'),('2054-10-08'),('2054-10-09'),('2054-10-10'),('2054-10-11'),('2054-10-12'),('2054-10-13'),('2054-10-14'),('2054-10-15'),('2054-10-16'),('2054-10-17'),('2054-10-18'),('2054-10-19'),('2054-10-20'),('2054-10-21'),('2054-10-22'),('2054-10-23'),('2054-10-24'),('2054-10-25'),('2054-10-26'),('2054-10-27'),('2054-10-28'),('2054-10-29'),('2054-10-30'),('2054-10-31'),('2054-11-01'),('2054-11-02'),('2054-11-03'),('2054-11-04'),('2054-11-05'),('2054-11-06'),('2054-11-07'),('2054-11-08'),('2054-11-09'),('2054-11-10'),('2054-11-11'),('2054-11-12'),('2054-11-13'),('2054-11-14'),('2054-11-15'),('2054-11-16'),('2054-11-17'),('2054-11-18'),('2054-11-19'),('2054-11-20'),('2054-11-21'),('2054-11-22'),('2054-11-23'),('2054-11-24'),('2054-11-25'),('2054-11-26'),('2054-11-27'),('2054-11-28'),('2054-11-29'),('2054-11-30'),('2054-12-01'),('2054-12-02'),('2054-12-03'),('2054-12-04'),('2054-12-05'),('2054-12-06'),('2054-12-07'),('2054-12-08'),('2054-12-09'),('2054-12-10'),('2054-12-11'),('2054-12-12'),('2054-12-13'),('2054-12-14'),('2054-12-15'),('2054-12-16'),('2054-12-17'),('2054-12-18'),('2054-12-19'),('2054-12-20'),('2054-12-21'),('2054-12-22'),('2054-12-23'),('2054-12-24'),('2054-12-25'),('2054-12-26'),('2054-12-27'),('2054-12-28'),('2054-12-29'),('2054-12-30'),('2054-12-31'),('2055-01-01'),('2055-01-02'),('2055-01-03'),('2055-01-04'),('2055-01-05'),('2055-01-06'),('2055-01-07'),('2055-01-08'),('2055-01-09'),('2055-01-10'),('2055-01-11'),('2055-01-12'),('2055-01-13'),('2055-01-14'),('2055-01-15'),('2055-01-16'),('2055-01-17'),('2055-01-18'),('2055-01-19'),('2055-01-20'),('2055-01-21'),('2055-01-22'),('2055-01-23'),('2055-01-24'),('2055-01-25'),('2055-01-26'),('2055-01-27'),('2055-01-28'),('2055-01-29'),('2055-01-30'),('2055-01-31'),('2055-02-01'),('2055-02-02'),('2055-02-03'),('2055-02-04'),('2055-02-05'),('2055-02-06'),('2055-02-07'),('2055-02-08'),('2055-02-09'),('2055-02-10'),('2055-02-11'),('2055-02-12'),('2055-02-13'),('2055-02-14'),('2055-02-15'),('2055-02-16'),('2055-02-17'),('2055-02-18'),('2055-02-19'),('2055-02-20'),('2055-02-21'),('2055-02-22'),('2055-02-23'),('2055-02-24'),('2055-02-25'),('2055-02-26'),('2055-02-27'),('2055-02-28'),('2055-03-01'),('2055-03-02'),('2055-03-03'),('2055-03-04'),('2055-03-05'),('2055-03-06'),('2055-03-07'),('2055-03-08'),('2055-03-09'),('2055-03-10'),('2055-03-11'),('2055-03-12'),('2055-03-13'),('2055-03-14'),('2055-03-15'),('2055-03-16'),('2055-03-17'),('2055-03-18'),('2055-03-19'),('2055-03-20'),('2055-03-21'),('2055-03-22'),('2055-03-23'),('2055-03-24'),('2055-03-25'),('2055-03-26'),('2055-03-27'),('2055-03-28'),('2055-03-29'),('2055-03-30'),('2055-03-31'),('2055-04-01'),('2055-04-02'),('2055-04-03'),('2055-04-04'),('2055-04-05'),('2055-04-06'),('2055-04-07'),('2055-04-08'),('2055-04-09'),('2055-04-10'),('2055-04-11'),('2055-04-12'),('2055-04-13'),('2055-04-14'),('2055-04-15'),('2055-04-16'),('2055-04-17'),('2055-04-18'),('2055-04-19'),('2055-04-20'),('2055-04-21'),('2055-04-22'),('2055-04-23'),('2055-04-24'),('2055-04-25'),('2055-04-26'),('2055-04-27'),('2055-04-28'),('2055-04-29'),('2055-04-30'),('2055-05-01'),('2055-05-02'),('2055-05-03'),('2055-05-04'),('2055-05-05'),('2055-05-06'),('2055-05-07'),('2055-05-08'),('2055-05-09'),('2055-05-10'),('2055-05-11'),('2055-05-12'),('2055-05-13'),('2055-05-14'),('2055-05-15'),('2055-05-16'),('2055-05-17'),('2055-05-18'),('2055-05-19'),('2055-05-20'),('2055-05-21'),('2055-05-22'),('2055-05-23'),('2055-05-24'),('2055-05-25'),('2055-05-26'),('2055-05-27'),('2055-05-28'),('2055-05-29'),('2055-05-30'),('2055-05-31'),('2055-06-01'),('2055-06-02'),('2055-06-03'),('2055-06-04'),('2055-06-05'),('2055-06-06'),('2055-06-07'),('2055-06-08'),('2055-06-09'),('2055-06-10'),('2055-06-11'),('2055-06-12'),('2055-06-13'),('2055-06-14'),('2055-06-15'),('2055-06-16'),('2055-06-17'),('2055-06-18'),('2055-06-19'),('2055-06-20'),('2055-06-21'),('2055-06-22'),('2055-06-23'),('2055-06-24'),('2055-06-25'),('2055-06-26'),('2055-06-27'),('2055-06-28'),('2055-06-29'),('2055-06-30'),('2055-07-01'),('2055-07-02'),('2055-07-03'),('2055-07-04'),('2055-07-05'),('2055-07-06'),('2055-07-07'),('2055-07-08'),('2055-07-09'),('2055-07-10'),('2055-07-11'),('2055-07-12'),('2055-07-13'),('2055-07-14'),('2055-07-15'),('2055-07-16'),('2055-07-17'),('2055-07-18'),('2055-07-19'),('2055-07-20'),('2055-07-21'),('2055-07-22'),('2055-07-23'),('2055-07-24'),('2055-07-25'),('2055-07-26'),('2055-07-27'),('2055-07-28'),('2055-07-29'),('2055-07-30'),('2055-07-31'),('2055-08-01'),('2055-08-02'),('2055-08-03'),('2055-08-04'),('2055-08-05'),('2055-08-06'),('2055-08-07'),('2055-08-08'),('2055-08-09'),('2055-08-10'),('2055-08-11'),('2055-08-12'),('2055-08-13'),('2055-08-14'),('2055-08-15'),('2055-08-16'),('2055-08-17'),('2055-08-18'),('2055-08-19'),('2055-08-20'),('2055-08-21'),('2055-08-22'),('2055-08-23'),('2055-08-24'),('2055-08-25'),('2055-08-26'),('2055-08-27'),('2055-08-28'),('2055-08-29'),('2055-08-30'),('2055-08-31'),('2055-09-01'),('2055-09-02'),('2055-09-03'),('2055-09-04'),('2055-09-05'),('2055-09-06'),('2055-09-07'),('2055-09-08'),('2055-09-09'),('2055-09-10'),('2055-09-11'),('2055-09-12'),('2055-09-13'),('2055-09-14'),('2055-09-15'),('2055-09-16'),('2055-09-17'),('2055-09-18'),('2055-09-19'),('2055-09-20'),('2055-09-21'),('2055-09-22'),('2055-09-23'),('2055-09-24'),('2055-09-25'),('2055-09-26'),('2055-09-27'),('2055-09-28'),('2055-09-29'),('2055-09-30'),('2055-10-01'),('2055-10-02'),('2055-10-03'),('2055-10-04'),('2055-10-05'),('2055-10-06'),('2055-10-07'),('2055-10-08'),('2055-10-09'),('2055-10-10'),('2055-10-11'),('2055-10-12'),('2055-10-13'),('2055-10-14'),('2055-10-15'),('2055-10-16'),('2055-10-17'),('2055-10-18'),('2055-10-19'),('2055-10-20'),('2055-10-21'),('2055-10-22'),('2055-10-23'),('2055-10-24'),('2055-10-25'),('2055-10-26'),('2055-10-27'),('2055-10-28'),('2055-10-29'),('2055-10-30'),('2055-10-31'),('2055-11-01'),('2055-11-02'),('2055-11-03'),('2055-11-04'),('2055-11-05'),('2055-11-06'),('2055-11-07'),('2055-11-08'),('2055-11-09'),('2055-11-10'),('2055-11-11'),('2055-11-12'),('2055-11-13'),('2055-11-14'),('2055-11-15'),('2055-11-16'),('2055-11-17'),('2055-11-18'),('2055-11-19'),('2055-11-20'),('2055-11-21'),('2055-11-22'),('2055-11-23'),('2055-11-24'),('2055-11-25'),('2055-11-26'),('2055-11-27'),('2055-11-28'),('2055-11-29'),('2055-11-30'),('2055-12-01'),('2055-12-02'),('2055-12-03'),('2055-12-04'),('2055-12-05'),('2055-12-06'),('2055-12-07'),('2055-12-08'),('2055-12-09'),('2055-12-10'),('2055-12-11'),('2055-12-12'),('2055-12-13'),('2055-12-14'),('2055-12-15'),('2055-12-16'),('2055-12-17'),('2055-12-18'),('2055-12-19'),('2055-12-20'),('2055-12-21'),('2055-12-22'),('2055-12-23'),('2055-12-24'),('2055-12-25'),('2055-12-26'),('2055-12-27'),('2055-12-28'),('2055-12-29'),('2055-12-30'),('2055-12-31'),('2056-01-01'),('2056-01-02'),('2056-01-03'),('2056-01-04'),('2056-01-05'),('2056-01-06'),('2056-01-07'),('2056-01-08'),('2056-01-09'),('2056-01-10'),('2056-01-11'),('2056-01-12'),('2056-01-13'),('2056-01-14'),('2056-01-15'),('2056-01-16'),('2056-01-17'),('2056-01-18'),('2056-01-19'),('2056-01-20'),('2056-01-21'),('2056-01-22'),('2056-01-23'),('2056-01-24'),('2056-01-25'),('2056-01-26'),('2056-01-27'),('2056-01-28'),('2056-01-29'),('2056-01-30'),('2056-01-31'),('2056-02-01'),('2056-02-02'),('2056-02-03'),('2056-02-04'),('2056-02-05'),('2056-02-06'),('2056-02-07'),('2056-02-08'),('2056-02-09'),('2056-02-10'),('2056-02-11'),('2056-02-12'),('2056-02-13'),('2056-02-14'),('2056-02-15'),('2056-02-16'),('2056-02-17'),('2056-02-18'),('2056-02-19'),('2056-02-20'),('2056-02-21'),('2056-02-22'),('2056-02-23'),('2056-02-24'),('2056-02-25'),('2056-02-26'),('2056-02-27'),('2056-02-28'),('2056-02-29'),('2056-03-01'),('2056-03-02'),('2056-03-03'),('2056-03-04'),('2056-03-05'),('2056-03-06'),('2056-03-07'),('2056-03-08'),('2056-03-09'),('2056-03-10'),('2056-03-11'),('2056-03-12'),('2056-03-13'),('2056-03-14'),('2056-03-15'),('2056-03-16'),('2056-03-17'),('2056-03-18'),('2056-03-19'),('2056-03-20'),('2056-03-21'),('2056-03-22'),('2056-03-23'),('2056-03-24'),('2056-03-25'),('2056-03-26'),('2056-03-27'),('2056-03-28'),('2056-03-29'),('2056-03-30'),('2056-03-31'),('2056-04-01'),('2056-04-02'),('2056-04-03'),('2056-04-04'),('2056-04-05'),('2056-04-06'),('2056-04-07'),('2056-04-08'),('2056-04-09'),('2056-04-10'),('2056-04-11'),('2056-04-12'),('2056-04-13'),('2056-04-14'),('2056-04-15'),('2056-04-16'),('2056-04-17'),('2056-04-18'),('2056-04-19'),('2056-04-20'),('2056-04-21'),('2056-04-22'),('2056-04-23'),('2056-04-24'),('2056-04-25'),('2056-04-26'),('2056-04-27'),('2056-04-28'),('2056-04-29'),('2056-04-30'),('2056-05-01'),('2056-05-02'),('2056-05-03'),('2056-05-04'),('2056-05-05'),('2056-05-06'),('2056-05-07'),('2056-05-08'),('2056-05-09'),('2056-05-10'),('2056-05-11'),('2056-05-12'),('2056-05-13'),('2056-05-14'),('2056-05-15'),('2056-05-16'),('2056-05-17'),('2056-05-18'),('2056-05-19'),('2056-05-20'),('2056-05-21'),('2056-05-22'),('2056-05-23'),('2056-05-24'),('2056-05-25'),('2056-05-26'),('2056-05-27'),('2056-05-28'),('2056-05-29'),('2056-05-30'),('2056-05-31'),('2056-06-01'),('2056-06-02'),('2056-06-03'),('2056-06-04'),('2056-06-05'),('2056-06-06'),('2056-06-07'),('2056-06-08'),('2056-06-09'),('2056-06-10'),('2056-06-11'),('2056-06-12'),('2056-06-13'),('2056-06-14'),('2056-06-15'),('2056-06-16'),('2056-06-17'),('2056-06-18'),('2056-06-19'),('2056-06-20'),('2056-06-21'),('2056-06-22'),('2056-06-23'),('2056-06-24'),('2056-06-25'),('2056-06-26'),('2056-06-27'),('2056-06-28'),('2056-06-29'),('2056-06-30'),('2056-07-01'),('2056-07-02'),('2056-07-03'),('2056-07-04'),('2056-07-05'),('2056-07-06'),('2056-07-07'),('2056-07-08'),('2056-07-09'),('2056-07-10'),('2056-07-11'),('2056-07-12'),('2056-07-13'),('2056-07-14'),('2056-07-15'),('2056-07-16'),('2056-07-17'),('2056-07-18'),('2056-07-19'),('2056-07-20'),('2056-07-21'),('2056-07-22'),('2056-07-23'),('2056-07-24'),('2056-07-25'),('2056-07-26'),('2056-07-27'),('2056-07-28'),('2056-07-29'),('2056-07-30'),('2056-07-31'),('2056-08-01'),('2056-08-02'),('2056-08-03'),('2056-08-04'),('2056-08-05'),('2056-08-06'),('2056-08-07'),('2056-08-08'),('2056-08-09'),('2056-08-10'),('2056-08-11'),('2056-08-12'),('2056-08-13'),('2056-08-14'),('2056-08-15'),('2056-08-16'),('2056-08-17'),('2056-08-18'),('2056-08-19'),('2056-08-20'),('2056-08-21'),('2056-08-22'),('2056-08-23'),('2056-08-24'),('2056-08-25'),('2056-08-26'),('2056-08-27'),('2056-08-28'),('2056-08-29'),('2056-08-30'),('2056-08-31'),('2056-09-01'),('2056-09-02'),('2056-09-03'),('2056-09-04'),('2056-09-05'),('2056-09-06'),('2056-09-07'),('2056-09-08'),('2056-09-09'),('2056-09-10'),('2056-09-11'),('2056-09-12'),('2056-09-13'),('2056-09-14'),('2056-09-15'),('2056-09-16'),('2056-09-17'),('2056-09-18'),('2056-09-19'),('2056-09-20'),('2056-09-21'),('2056-09-22'),('2056-09-23'),('2056-09-24'),('2056-09-25'),('2056-09-26'),('2056-09-27'),('2056-09-28'),('2056-09-29'),('2056-09-30'),('2056-10-01'),('2056-10-02'),('2056-10-03'),('2056-10-04'),('2056-10-05'),('2056-10-06'),('2056-10-07'),('2056-10-08'),('2056-10-09'),('2056-10-10'),('2056-10-11'),('2056-10-12'),('2056-10-13'),('2056-10-14'),('2056-10-15'),('2056-10-16'),('2056-10-17'),('2056-10-18'),('2056-10-19'),('2056-10-20'),('2056-10-21'),('2056-10-22'),('2056-10-23'),('2056-10-24'),('2056-10-25'),('2056-10-26'),('2056-10-27'),('2056-10-28'),('2056-10-29'),('2056-10-30'),('2056-10-31'),('2056-11-01'),('2056-11-02'),('2056-11-03'),('2056-11-04'),('2056-11-05'),('2056-11-06'),('2056-11-07'),('2056-11-08'),('2056-11-09'),('2056-11-10'),('2056-11-11'),('2056-11-12'),('2056-11-13'),('2056-11-14'),('2056-11-15'),('2056-11-16'),('2056-11-17'),('2056-11-18'),('2056-11-19'),('2056-11-20'),('2056-11-21'),('2056-11-22'),('2056-11-23'),('2056-11-24'),('2056-11-25'),('2056-11-26'),('2056-11-27'),('2056-11-28'),('2056-11-29'),('2056-11-30'),('2056-12-01'),('2056-12-02'),('2056-12-03'),('2056-12-04'),('2056-12-05'),('2056-12-06'),('2056-12-07'),('2056-12-08'),('2056-12-09'),('2056-12-10'),('2056-12-11'),('2056-12-12'),('2056-12-13'),('2056-12-14'),('2056-12-15'),('2056-12-16'),('2056-12-17'),('2056-12-18'),('2056-12-19'),('2056-12-20'),('2056-12-21'),('2056-12-22'),('2056-12-23'),('2056-12-24'),('2056-12-25'),('2056-12-26'),('2056-12-27'),('2056-12-28'),('2056-12-29'),('2056-12-30'),('2056-12-31'),('2057-01-01'),('2057-01-02'),('2057-01-03'),('2057-01-04'),('2057-01-05'),('2057-01-06'),('2057-01-07'),('2057-01-08'),('2057-01-09'),('2057-01-10'),('2057-01-11'),('2057-01-12'),('2057-01-13'),('2057-01-14'),('2057-01-15'),('2057-01-16'),('2057-01-17'),('2057-01-18'),('2057-01-19'),('2057-01-20'),('2057-01-21'),('2057-01-22'),('2057-01-23'),('2057-01-24'),('2057-01-25'),('2057-01-26'),('2057-01-27'),('2057-01-28'),('2057-01-29'),('2057-01-30'),('2057-01-31'),('2057-02-01'),('2057-02-02'),('2057-02-03'),('2057-02-04'),('2057-02-05'),('2057-02-06'),('2057-02-07'),('2057-02-08'),('2057-02-09'),('2057-02-10'),('2057-02-11'),('2057-02-12'),('2057-02-13'),('2057-02-14'),('2057-02-15'),('2057-02-16'),('2057-02-17'),('2057-02-18'),('2057-02-19'),('2057-02-20'),('2057-02-21'),('2057-02-22'),('2057-02-23'),('2057-02-24'),('2057-02-25'),('2057-02-26'),('2057-02-27'),('2057-02-28'),('2057-03-01'),('2057-03-02'),('2057-03-03'),('2057-03-04'),('2057-03-05'),('2057-03-06'),('2057-03-07'),('2057-03-08'),('2057-03-09'),('2057-03-10'),('2057-03-11'),('2057-03-12'),('2057-03-13'),('2057-03-14'),('2057-03-15'),('2057-03-16'),('2057-03-17'),('2057-03-18'),('2057-03-19'),('2057-03-20'),('2057-03-21'),('2057-03-22'),('2057-03-23'),('2057-03-24'),('2057-03-25'),('2057-03-26'),('2057-03-27'),('2057-03-28'),('2057-03-29'),('2057-03-30'),('2057-03-31'),('2057-04-01'),('2057-04-02'),('2057-04-03'),('2057-04-04'),('2057-04-05'),('2057-04-06'),('2057-04-07'),('2057-04-08'),('2057-04-09'),('2057-04-10'),('2057-04-11'),('2057-04-12'),('2057-04-13'),('2057-04-14'),('2057-04-15'),('2057-04-16'),('2057-04-17'),('2057-04-18'),('2057-04-19'),('2057-04-20'),('2057-04-21'),('2057-04-22'),('2057-04-23'),('2057-04-24'),('2057-04-25'),('2057-04-26'),('2057-04-27'),('2057-04-28'),('2057-04-29'),('2057-04-30'),('2057-05-01'),('2057-05-02'),('2057-05-03'),('2057-05-04'),('2057-05-05'),('2057-05-06'),('2057-05-07'),('2057-05-08'),('2057-05-09'),('2057-05-10'),('2057-05-11'),('2057-05-12'),('2057-05-13'),('2057-05-14'),('2057-05-15'),('2057-05-16'),('2057-05-17'),('2057-05-18'),('2057-05-19'),('2057-05-20'),('2057-05-21'),('2057-05-22'),('2057-05-23'),('2057-05-24'),('2057-05-25'),('2057-05-26'),('2057-05-27'),('2057-05-28'),('2057-05-29'),('2057-05-30'),('2057-05-31'),('2057-06-01'),('2057-06-02'),('2057-06-03'),('2057-06-04'),('2057-06-05'),('2057-06-06'),('2057-06-07'),('2057-06-08'),('2057-06-09'),('2057-06-10'),('2057-06-11'),('2057-06-12'),('2057-06-13'),('2057-06-14'),('2057-06-15'),('2057-06-16'),('2057-06-17'),('2057-06-18'),('2057-06-19'),('2057-06-20'),('2057-06-21'),('2057-06-22'),('2057-06-23'),('2057-06-24'),('2057-06-25'),('2057-06-26'),('2057-06-27'),('2057-06-28'),('2057-06-29'),('2057-06-30'),('2057-07-01'),('2057-07-02'),('2057-07-03'),('2057-07-04'),('2057-07-05'),('2057-07-06'),('2057-07-07'),('2057-07-08'),('2057-07-09'),('2057-07-10'),('2057-07-11'),('2057-07-12'),('2057-07-13'),('2057-07-14'),('2057-07-15'),('2057-07-16'),('2057-07-17'),('2057-07-18'),('2057-07-19'),('2057-07-20'),('2057-07-21'),('2057-07-22'),('2057-07-23'),('2057-07-24'),('2057-07-25'),('2057-07-26'),('2057-07-27'),('2057-07-28'),('2057-07-29'),('2057-07-30'),('2057-07-31'),('2057-08-01'),('2057-08-02'),('2057-08-03'),('2057-08-04'),('2057-08-05'),('2057-08-06'),('2057-08-07'),('2057-08-08'),('2057-08-09'),('2057-08-10'),('2057-08-11'),('2057-08-12'),('2057-08-13'),('2057-08-14'),('2057-08-15'),('2057-08-16'),('2057-08-17'),('2057-08-18'),('2057-08-19'),('2057-08-20'),('2057-08-21'),('2057-08-22'),('2057-08-23'),('2057-08-24'),('2057-08-25'),('2057-08-26'),('2057-08-27'),('2057-08-28'),('2057-08-29'),('2057-08-30'),('2057-08-31'),('2057-09-01'),('2057-09-02'),('2057-09-03'),('2057-09-04'),('2057-09-05'),('2057-09-06'),('2057-09-07'),('2057-09-08'),('2057-09-09'),('2057-09-10'),('2057-09-11'),('2057-09-12'),('2057-09-13'),('2057-09-14'),('2057-09-15'),('2057-09-16'),('2057-09-17'),('2057-09-18'),('2057-09-19'),('2057-09-20'),('2057-09-21'),('2057-09-22'),('2057-09-23'),('2057-09-24'),('2057-09-25'),('2057-09-26'),('2057-09-27'),('2057-09-28'),('2057-09-29'),('2057-09-30'),('2057-10-01'),('2057-10-02'),('2057-10-03'),('2057-10-04'),('2057-10-05'),('2057-10-06'),('2057-10-07'),('2057-10-08'),('2057-10-09'),('2057-10-10'),('2057-10-11'),('2057-10-12'),('2057-10-13'),('2057-10-14'),('2057-10-15'),('2057-10-16'),('2057-10-17'),('2057-10-18'),('2057-10-19'),('2057-10-20'),('2057-10-21'),('2057-10-22'),('2057-10-23'),('2057-10-24'),('2057-10-25'),('2057-10-26'),('2057-10-27'),('2057-10-28'),('2057-10-29'),('2057-10-30'),('2057-10-31'),('2057-11-01'),('2057-11-02'),('2057-11-03'),('2057-11-04'),('2057-11-05'),('2057-11-06'),('2057-11-07'),('2057-11-08'),('2057-11-09'),('2057-11-10'),('2057-11-11'),('2057-11-12'),('2057-11-13'),('2057-11-14'),('2057-11-15'),('2057-11-16'),('2057-11-17'),('2057-11-18'),('2057-11-19'),('2057-11-20'),('2057-11-21'),('2057-11-22'),('2057-11-23'),('2057-11-24'),('2057-11-25'),('2057-11-26'),('2057-11-27'),('2057-11-28'),('2057-11-29'),('2057-11-30'),('2057-12-01'),('2057-12-02'),('2057-12-03'),('2057-12-04'),('2057-12-05'),('2057-12-06'),('2057-12-07'),('2057-12-08'),('2057-12-09'),('2057-12-10'),('2057-12-11'),('2057-12-12'),('2057-12-13'),('2057-12-14'),('2057-12-15'),('2057-12-16'),('2057-12-17'),('2057-12-18'),('2057-12-19'),('2057-12-20'),('2057-12-21'),('2057-12-22'),('2057-12-23'),('2057-12-24'),('2057-12-25'),('2057-12-26'),('2057-12-27'),('2057-12-28'),('2057-12-29'),('2057-12-30'),('2057-12-31'),('2058-01-01'),('2058-01-02'),('2058-01-03'),('2058-01-04'),('2058-01-05'),('2058-01-06'),('2058-01-07'),('2058-01-08'),('2058-01-09'),('2058-01-10'),('2058-01-11'),('2058-01-12'),('2058-01-13'),('2058-01-14'),('2058-01-15'),('2058-01-16'),('2058-01-17'),('2058-01-18'),('2058-01-19'),('2058-01-20'),('2058-01-21'),('2058-01-22'),('2058-01-23'),('2058-01-24'),('2058-01-25'),('2058-01-26'),('2058-01-27'),('2058-01-28'),('2058-01-29'),('2058-01-30'),('2058-01-31'),('2058-02-01'),('2058-02-02'),('2058-02-03'),('2058-02-04'),('2058-02-05'),('2058-02-06'),('2058-02-07'),('2058-02-08'),('2058-02-09'),('2058-02-10'),('2058-02-11'),('2058-02-12'),('2058-02-13'),('2058-02-14'),('2058-02-15'),('2058-02-16'),('2058-02-17'),('2058-02-18'),('2058-02-19'),('2058-02-20'),('2058-02-21'),('2058-02-22'),('2058-02-23'),('2058-02-24'),('2058-02-25'),('2058-02-26'),('2058-02-27'),('2058-02-28'),('2058-03-01'),('2058-03-02'),('2058-03-03'),('2058-03-04'),('2058-03-05'),('2058-03-06'),('2058-03-07'),('2058-03-08'),('2058-03-09'),('2058-03-10'),('2058-03-11'),('2058-03-12'),('2058-03-13'),('2058-03-14'),('2058-03-15'),('2058-03-16'),('2058-03-17'),('2058-03-18'),('2058-03-19'),('2058-03-20'),('2058-03-21'),('2058-03-22'),('2058-03-23'),('2058-03-24'),('2058-03-25'),('2058-03-26'),('2058-03-27'),('2058-03-28'),('2058-03-29'),('2058-03-30'),('2058-03-31'),('2058-04-01'),('2058-04-02'),('2058-04-03'),('2058-04-04'),('2058-04-05'),('2058-04-06'),('2058-04-07'),('2058-04-08'),('2058-04-09'),('2058-04-10'),('2058-04-11'),('2058-04-12'),('2058-04-13'),('2058-04-14'),('2058-04-15'),('2058-04-16'),('2058-04-17'),('2058-04-18'),('2058-04-19'),('2058-04-20'),('2058-04-21'),('2058-04-22'),('2058-04-23'),('2058-04-24'),('2058-04-25'),('2058-04-26'),('2058-04-27'),('2058-04-28'),('2058-04-29'),('2058-04-30'),('2058-05-01'),('2058-05-02'),('2058-05-03'),('2058-05-04'),('2058-05-05'),('2058-05-06'),('2058-05-07'),('2058-05-08'),('2058-05-09'),('2058-05-10'),('2058-05-11'),('2058-05-12'),('2058-05-13'),('2058-05-14'),('2058-05-15'),('2058-05-16'),('2058-05-17'),('2058-05-18'),('2058-05-19'),('2058-05-20'),('2058-05-21'),('2058-05-22'),('2058-05-23'),('2058-05-24'),('2058-05-25'),('2058-05-26'),('2058-05-27'),('2058-05-28'),('2058-05-29'),('2058-05-30'),('2058-05-31'),('2058-06-01'),('2058-06-02'),('2058-06-03'),('2058-06-04'),('2058-06-05'),('2058-06-06'),('2058-06-07'),('2058-06-08'),('2058-06-09'),('2058-06-10'),('2058-06-11'),('2058-06-12'),('2058-06-13'),('2058-06-14'),('2058-06-15'),('2058-06-16'),('2058-06-17'),('2058-06-18'),('2058-06-19'),('2058-06-20'),('2058-06-21'),('2058-06-22'),('2058-06-23'),('2058-06-24'),('2058-06-25'),('2058-06-26'),('2058-06-27'),('2058-06-28'),('2058-06-29'),('2058-06-30'),('2058-07-01'),('2058-07-02'),('2058-07-03'),('2058-07-04'),('2058-07-05'),('2058-07-06'),('2058-07-07'),('2058-07-08'),('2058-07-09'),('2058-07-10'),('2058-07-11'),('2058-07-12'),('2058-07-13'),('2058-07-14'),('2058-07-15'),('2058-07-16'),('2058-07-17'),('2058-07-18'),('2058-07-19'),('2058-07-20'),('2058-07-21'),('2058-07-22'),('2058-07-23'),('2058-07-24'),('2058-07-25'),('2058-07-26'),('2058-07-27'),('2058-07-28'),('2058-07-29'),('2058-07-30'),('2058-07-31'),('2058-08-01'),('2058-08-02'),('2058-08-03'),('2058-08-04'),('2058-08-05'),('2058-08-06'),('2058-08-07'),('2058-08-08'),('2058-08-09'),('2058-08-10'),('2058-08-11'),('2058-08-12'),('2058-08-13'),('2058-08-14'),('2058-08-15'),('2058-08-16'),('2058-08-17'),('2058-08-18'),('2058-08-19'),('2058-08-20'),('2058-08-21'),('2058-08-22'),('2058-08-23'),('2058-08-24'),('2058-08-25'),('2058-08-26'),('2058-08-27'),('2058-08-28'),('2058-08-29'),('2058-08-30'),('2058-08-31'),('2058-09-01'),('2058-09-02'),('2058-09-03'),('2058-09-04'),('2058-09-05'),('2058-09-06'),('2058-09-07'),('2058-09-08'),('2058-09-09'),('2058-09-10'),('2058-09-11'),('2058-09-12'),('2058-09-13'),('2058-09-14'),('2058-09-15'),('2058-09-16'),('2058-09-17'),('2058-09-18'),('2058-09-19'),('2058-09-20'),('2058-09-21'),('2058-09-22'),('2058-09-23'),('2058-09-24'),('2058-09-25'),('2058-09-26'),('2058-09-27'),('2058-09-28'),('2058-09-29'),('2058-09-30'),('2058-10-01'),('2058-10-02'),('2058-10-03'),('2058-10-04'),('2058-10-05'),('2058-10-06'),('2058-10-07'),('2058-10-08'),('2058-10-09'),('2058-10-10'),('2058-10-11'),('2058-10-12'),('2058-10-13'),('2058-10-14'),('2058-10-15'),('2058-10-16'),('2058-10-17'),('2058-10-18'),('2058-10-19'),('2058-10-20'),('2058-10-21'),('2058-10-22'),('2058-10-23'),('2058-10-24'),('2058-10-25'),('2058-10-26'),('2058-10-27'),('2058-10-28'),('2058-10-29'),('2058-10-30'),('2058-10-31'),('2058-11-01'),('2058-11-02'),('2058-11-03'),('2058-11-04'),('2058-11-05'),('2058-11-06'),('2058-11-07'),('2058-11-08'),('2058-11-09'),('2058-11-10'),('2058-11-11'),('2058-11-12'),('2058-11-13'),('2058-11-14'),('2058-11-15'),('2058-11-16'),('2058-11-17'),('2058-11-18'),('2058-11-19'),('2058-11-20'),('2058-11-21'),('2058-11-22'),('2058-11-23'),('2058-11-24'),('2058-11-25'),('2058-11-26'),('2058-11-27'),('2058-11-28'),('2058-11-29'),('2058-11-30'),('2058-12-01'),('2058-12-02'),('2058-12-03'),('2058-12-04'),('2058-12-05'),('2058-12-06'),('2058-12-07'),('2058-12-08'),('2058-12-09'),('2058-12-10'),('2058-12-11'),('2058-12-12'),('2058-12-13'),('2058-12-14'),('2058-12-15'),('2058-12-16'),('2058-12-17'),('2058-12-18'),('2058-12-19'),('2058-12-20'),('2058-12-21'),('2058-12-22'),('2058-12-23'),('2058-12-24'),('2058-12-25'),('2058-12-26'),('2058-12-27'),('2058-12-28'),('2058-12-29'),('2058-12-30'),('2058-12-31'),('2059-01-01'),('2059-01-02'),('2059-01-03'),('2059-01-04'),('2059-01-05'),('2059-01-06'),('2059-01-07'),('2059-01-08'),('2059-01-09'),('2059-01-10'),('2059-01-11'),('2059-01-12'),('2059-01-13'),('2059-01-14'),('2059-01-15'),('2059-01-16'),('2059-01-17'),('2059-01-18'),('2059-01-19'),('2059-01-20'),('2059-01-21'),('2059-01-22'),('2059-01-23'),('2059-01-24'),('2059-01-25'),('2059-01-26'),('2059-01-27'),('2059-01-28'),('2059-01-29'),('2059-01-30'),('2059-01-31'),('2059-02-01'),('2059-02-02'),('2059-02-03'),('2059-02-04'),('2059-02-05'),('2059-02-06'),('2059-02-07'),('2059-02-08'),('2059-02-09'),('2059-02-10'),('2059-02-11'),('2059-02-12'),('2059-02-13'),('2059-02-14'),('2059-02-15'),('2059-02-16'),('2059-02-17'),('2059-02-18'),('2059-02-19'),('2059-02-20'),('2059-02-21'),('2059-02-22'),('2059-02-23'),('2059-02-24'),('2059-02-25'),('2059-02-26'),('2059-02-27'),('2059-02-28'),('2059-03-01'),('2059-03-02'),('2059-03-03'),('2059-03-04'),('2059-03-05'),('2059-03-06'),('2059-03-07'),('2059-03-08'),('2059-03-09'),('2059-03-10'),('2059-03-11'),('2059-03-12'),('2059-03-13'),('2059-03-14'),('2059-03-15'),('2059-03-16'),('2059-03-17'),('2059-03-18'),('2059-03-19'),('2059-03-20'),('2059-03-21'),('2059-03-22'),('2059-03-23'),('2059-03-24'),('2059-03-25'),('2059-03-26'),('2059-03-27'),('2059-03-28'),('2059-03-29'),('2059-03-30'),('2059-03-31'),('2059-04-01'),('2059-04-02'),('2059-04-03'),('2059-04-04'),('2059-04-05'),('2059-04-06'),('2059-04-07'),('2059-04-08'),('2059-04-09'),('2059-04-10'),('2059-04-11'),('2059-04-12'),('2059-04-13'),('2059-04-14'),('2059-04-15'),('2059-04-16'),('2059-04-17'),('2059-04-18'),('2059-04-19'),('2059-04-20'),('2059-04-21'),('2059-04-22'),('2059-04-23'),('2059-04-24'),('2059-04-25'),('2059-04-26'),('2059-04-27'),('2059-04-28'),('2059-04-29'),('2059-04-30'),('2059-05-01'),('2059-05-02'),('2059-05-03'),('2059-05-04'),('2059-05-05'),('2059-05-06'),('2059-05-07'),('2059-05-08'),('2059-05-09'),('2059-05-10'),('2059-05-11'),('2059-05-12'),('2059-05-13'),('2059-05-14'),('2059-05-15'),('2059-05-16'),('2059-05-17'),('2059-05-18'),('2059-05-19'),('2059-05-20'),('2059-05-21'),('2059-05-22'),('2059-05-23'),('2059-05-24'),('2059-05-25'),('2059-05-26'),('2059-05-27'),('2059-05-28'),('2059-05-29'),('2059-05-30'),('2059-05-31'),('2059-06-01'),('2059-06-02'),('2059-06-03'),('2059-06-04'),('2059-06-05'),('2059-06-06'),('2059-06-07'),('2059-06-08'),('2059-06-09'),('2059-06-10'),('2059-06-11'),('2059-06-12'),('2059-06-13'),('2059-06-14'),('2059-06-15'),('2059-06-16'),('2059-06-17'),('2059-06-18'),('2059-06-19'),('2059-06-20'),('2059-06-21'),('2059-06-22'),('2059-06-23'),('2059-06-24'),('2059-06-25'),('2059-06-26'),('2059-06-27'),('2059-06-28'),('2059-06-29'),('2059-06-30'),('2059-07-01'),('2059-07-02'),('2059-07-03'),('2059-07-04'),('2059-07-05'),('2059-07-06'),('2059-07-07'),('2059-07-08'),('2059-07-09'),('2059-07-10'),('2059-07-11'),('2059-07-12'),('2059-07-13'),('2059-07-14'),('2059-07-15'),('2059-07-16'),('2059-07-17'),('2059-07-18'),('2059-07-19'),('2059-07-20'),('2059-07-21'),('2059-07-22'),('2059-07-23'),('2059-07-24'),('2059-07-25'),('2059-07-26'),('2059-07-27'),('2059-07-28'),('2059-07-29'),('2059-07-30'),('2059-07-31'),('2059-08-01'),('2059-08-02'),('2059-08-03'),('2059-08-04'),('2059-08-05'),('2059-08-06'),('2059-08-07'),('2059-08-08'),('2059-08-09'),('2059-08-10'),('2059-08-11'),('2059-08-12'),('2059-08-13'),('2059-08-14'),('2059-08-15'),('2059-08-16'),('2059-08-17'),('2059-08-18'),('2059-08-19'),('2059-08-20'),('2059-08-21'),('2059-08-22'),('2059-08-23'),('2059-08-24'),('2059-08-25'),('2059-08-26'),('2059-08-27'),('2059-08-28'),('2059-08-29'),('2059-08-30'),('2059-08-31'),('2059-09-01'),('2059-09-02'),('2059-09-03'),('2059-09-04'),('2059-09-05'),('2059-09-06'),('2059-09-07'),('2059-09-08'),('2059-09-09'),('2059-09-10'),('2059-09-11'),('2059-09-12'),('2059-09-13'),('2059-09-14'),('2059-09-15'),('2059-09-16'),('2059-09-17'),('2059-09-18'),('2059-09-19'),('2059-09-20'),('2059-09-21'),('2059-09-22'),('2059-09-23'),('2059-09-24'),('2059-09-25'),('2059-09-26'),('2059-09-27'),('2059-09-28'),('2059-09-29'),('2059-09-30'),('2059-10-01'),('2059-10-02'),('2059-10-03'),('2059-10-04'),('2059-10-05'),('2059-10-06'),('2059-10-07'),('2059-10-08'),('2059-10-09'),('2059-10-10'),('2059-10-11'),('2059-10-12'),('2059-10-13'),('2059-10-14'),('2059-10-15'),('2059-10-16'),('2059-10-17'),('2059-10-18'),('2059-10-19'),('2059-10-20'),('2059-10-21'),('2059-10-22'),('2059-10-23'),('2059-10-24'),('2059-10-25'),('2059-10-26'),('2059-10-27'),('2059-10-28'),('2059-10-29'),('2059-10-30'),('2059-10-31'),('2059-11-01'),('2059-11-02'),('2059-11-03'),('2059-11-04'),('2059-11-05'),('2059-11-06'),('2059-11-07'),('2059-11-08'),('2059-11-09'),('2059-11-10'),('2059-11-11'),('2059-11-12'),('2059-11-13'),('2059-11-14'),('2059-11-15'),('2059-11-16'),('2059-11-17'),('2059-11-18'),('2059-11-19'),('2059-11-20'),('2059-11-21'),('2059-11-22'),('2059-11-23'),('2059-11-24'),('2059-11-25'),('2059-11-26'),('2059-11-27'),('2059-11-28'),('2059-11-29'),('2059-11-30'),('2059-12-01'),('2059-12-02'),('2059-12-03'),('2059-12-04'),('2059-12-05'),('2059-12-06'),('2059-12-07'),('2059-12-08'),('2059-12-09'),('2059-12-10'),('2059-12-11'),('2059-12-12'),('2059-12-13'),('2059-12-14'),('2059-12-15'),('2059-12-16'),('2059-12-17'),('2059-12-18'),('2059-12-19'),('2059-12-20'),('2059-12-21'),('2059-12-22'),('2059-12-23'),('2059-12-24'),('2059-12-25'),('2059-12-26'),('2059-12-27'),('2059-12-28'),('2059-12-29'),('2059-12-30'),('2059-12-31'),('2060-01-01'),('2060-01-02'),('2060-01-03'),('2060-01-04'),('2060-01-05'),('2060-01-06'),('2060-01-07'),('2060-01-08'),('2060-01-09'),('2060-01-10'),('2060-01-11'),('2060-01-12'),('2060-01-13'),('2060-01-14'),('2060-01-15'),('2060-01-16'),('2060-01-17'),('2060-01-18'),('2060-01-19'),('2060-01-20'),('2060-01-21'),('2060-01-22'),('2060-01-23'),('2060-01-24'),('2060-01-25'),('2060-01-26'),('2060-01-27'),('2060-01-28'),('2060-01-29'),('2060-01-30'),('2060-01-31'),('2060-02-01'),('2060-02-02'),('2060-02-03'),('2060-02-04'),('2060-02-05'),('2060-02-06'),('2060-02-07'),('2060-02-08'),('2060-02-09'),('2060-02-10'),('2060-02-11'),('2060-02-12'),('2060-02-13'),('2060-02-14'),('2060-02-15'),('2060-02-16'),('2060-02-17'),('2060-02-18'),('2060-02-19'),('2060-02-20'),('2060-02-21'),('2060-02-22'),('2060-02-23'),('2060-02-24'),('2060-02-25'),('2060-02-26'),('2060-02-27'),('2060-02-28'),('2060-02-29'),('2060-03-01'),('2060-03-02'),('2060-03-03'),('2060-03-04'),('2060-03-05'),('2060-03-06'),('2060-03-07'),('2060-03-08'),('2060-03-09'),('2060-03-10'),('2060-03-11'),('2060-03-12'),('2060-03-13'),('2060-03-14'),('2060-03-15'),('2060-03-16'),('2060-03-17'),('2060-03-18'),('2060-03-19'),('2060-03-20'),('2060-03-21'),('2060-03-22'),('2060-03-23'),('2060-03-24'),('2060-03-25'),('2060-03-26'),('2060-03-27'),('2060-03-28'),('2060-03-29'),('2060-03-30'),('2060-03-31'),('2060-04-01'),('2060-04-02'),('2060-04-03'),('2060-04-04'),('2060-04-05'),('2060-04-06'),('2060-04-07'),('2060-04-08'),('2060-04-09'),('2060-04-10'),('2060-04-11'),('2060-04-12'),('2060-04-13'),('2060-04-14'),('2060-04-15'),('2060-04-16'),('2060-04-17'),('2060-04-18'),('2060-04-19'),('2060-04-20'),('2060-04-21'),('2060-04-22'),('2060-04-23'),('2060-04-24'),('2060-04-25'),('2060-04-26'),('2060-04-27'),('2060-04-28'),('2060-04-29'),('2060-04-30'),('2060-05-01'),('2060-05-02'),('2060-05-03'),('2060-05-04'),('2060-05-05'),('2060-05-06'),('2060-05-07'),('2060-05-08'),('2060-05-09'),('2060-05-10'),('2060-05-11'),('2060-05-12'),('2060-05-13'),('2060-05-14'),('2060-05-15'),('2060-05-16'),('2060-05-17'),('2060-05-18'),('2060-05-19'),('2060-05-20'),('2060-05-21'),('2060-05-22'),('2060-05-23'),('2060-05-24'),('2060-05-25'),('2060-05-26'),('2060-05-27'),('2060-05-28'),('2060-05-29'),('2060-05-30'),('2060-05-31'),('2060-06-01'),('2060-06-02'),('2060-06-03'),('2060-06-04'),('2060-06-05'),('2060-06-06'),('2060-06-07'),('2060-06-08'),('2060-06-09'),('2060-06-10'),('2060-06-11'),('2060-06-12'),('2060-06-13'),('2060-06-14'),('2060-06-15'),('2060-06-16'),('2060-06-17'),('2060-06-18'),('2060-06-19'),('2060-06-20'),('2060-06-21'),('2060-06-22'),('2060-06-23'),('2060-06-24'),('2060-06-25'),('2060-06-26'),('2060-06-27'),('2060-06-28'),('2060-06-29'),('2060-06-30'),('2060-07-01'),('2060-07-02'),('2060-07-03'),('2060-07-04'),('2060-07-05'),('2060-07-06'),('2060-07-07'),('2060-07-08'),('2060-07-09'),('2060-07-10'),('2060-07-11'),('2060-07-12'),('2060-07-13'),('2060-07-14'),('2060-07-15'),('2060-07-16'),('2060-07-17'),('2060-07-18'),('2060-07-19'),('2060-07-20'),('2060-07-21'),('2060-07-22'),('2060-07-23'),('2060-07-24'),('2060-07-25'),('2060-07-26'),('2060-07-27'),('2060-07-28'),('2060-07-29'),('2060-07-30'),('2060-07-31'),('2060-08-01'),('2060-08-02'),('2060-08-03'),('2060-08-04'),('2060-08-05'),('2060-08-06'),('2060-08-07'),('2060-08-08'),('2060-08-09'),('2060-08-10'),('2060-08-11'),('2060-08-12'),('2060-08-13'),('2060-08-14'),('2060-08-15'),('2060-08-16'),('2060-08-17'),('2060-08-18'),('2060-08-19'),('2060-08-20'),('2060-08-21'),('2060-08-22'),('2060-08-23'),('2060-08-24'),('2060-08-25'),('2060-08-26'),('2060-08-27'),('2060-08-28'),('2060-08-29'),('2060-08-30'),('2060-08-31'),('2060-09-01'),('2060-09-02'),('2060-09-03'),('2060-09-04'),('2060-09-05'),('2060-09-06'),('2060-09-07'),('2060-09-08'),('2060-09-09'),('2060-09-10'),('2060-09-11'),('2060-09-12'),('2060-09-13'),('2060-09-14'),('2060-09-15'),('2060-09-16'),('2060-09-17'),('2060-09-18'),('2060-09-19'),('2060-09-20'),('2060-09-21'),('2060-09-22'),('2060-09-23'),('2060-09-24'),('2060-09-25'),('2060-09-26'),('2060-09-27'),('2060-09-28'),('2060-09-29'),('2060-09-30'),('2060-10-01'),('2060-10-02'),('2060-10-03'),('2060-10-04'),('2060-10-05'),('2060-10-06'),('2060-10-07'),('2060-10-08'),('2060-10-09'),('2060-10-10'),('2060-10-11'),('2060-10-12'),('2060-10-13'),('2060-10-14'),('2060-10-15'),('2060-10-16'),('2060-10-17'),('2060-10-18'),('2060-10-19'),('2060-10-20'),('2060-10-21'),('2060-10-22'),('2060-10-23'),('2060-10-24'),('2060-10-25'),('2060-10-26'),('2060-10-27'),('2060-10-28'),('2060-10-29'),('2060-10-30'),('2060-10-31'),('2060-11-01'),('2060-11-02'),('2060-11-03'),('2060-11-04'),('2060-11-05'),('2060-11-06'),('2060-11-07'),('2060-11-08'),('2060-11-09'),('2060-11-10'),('2060-11-11'),('2060-11-12'),('2060-11-13'),('2060-11-14'),('2060-11-15'),('2060-11-16'),('2060-11-17'),('2060-11-18'),('2060-11-19'),('2060-11-20'),('2060-11-21'),('2060-11-22'),('2060-11-23'),('2060-11-24'),('2060-11-25'),('2060-11-26'),('2060-11-27'),('2060-11-28'),('2060-11-29'),('2060-11-30'),('2060-12-01'),('2060-12-02'),('2060-12-03'),('2060-12-04'),('2060-12-05'),('2060-12-06'),('2060-12-07'),('2060-12-08'),('2060-12-09'),('2060-12-10'),('2060-12-11'),('2060-12-12'),('2060-12-13'),('2060-12-14'),('2060-12-15'),('2060-12-16'),('2060-12-17'),('2060-12-18'),('2060-12-19'),('2060-12-20'),('2060-12-21'),('2060-12-22'),('2060-12-23'),('2060-12-24'),('2060-12-25'),('2060-12-26'),('2060-12-27'),('2060-12-28'),('2060-12-29'),('2060-12-30'),('2060-12-31'),('2061-01-01'),('2061-01-02'),('2061-01-03'),('2061-01-04'),('2061-01-05'),('2061-01-06'),('2061-01-07'),('2061-01-08'),('2061-01-09'),('2061-01-10'),('2061-01-11'),('2061-01-12'),('2061-01-13'),('2061-01-14'),('2061-01-15'),('2061-01-16'),('2061-01-17'),('2061-01-18'),('2061-01-19'),('2061-01-20'),('2061-01-21'),('2061-01-22'),('2061-01-23'),('2061-01-24'),('2061-01-25'),('2061-01-26'),('2061-01-27'),('2061-01-28'),('2061-01-29'),('2061-01-30'),('2061-01-31'),('2061-02-01'),('2061-02-02'),('2061-02-03'),('2061-02-04'),('2061-02-05'),('2061-02-06'),('2061-02-07'),('2061-02-08'),('2061-02-09'),('2061-02-10'),('2061-02-11'),('2061-02-12'),('2061-02-13'),('2061-02-14'),('2061-02-15'),('2061-02-16'),('2061-02-17'),('2061-02-18'),('2061-02-19'),('2061-02-20'),('2061-02-21'),('2061-02-22'),('2061-02-23'),('2061-02-24'),('2061-02-25'),('2061-02-26'),('2061-02-27'),('2061-02-28'),('2061-03-01'),('2061-03-02'),('2061-03-03'),('2061-03-04'),('2061-03-05'),('2061-03-06'),('2061-03-07'),('2061-03-08'),('2061-03-09'),('2061-03-10'),('2061-03-11'),('2061-03-12'),('2061-03-13'),('2061-03-14'),('2061-03-15'),('2061-03-16'),('2061-03-17'),('2061-03-18'),('2061-03-19'),('2061-03-20'),('2061-03-21'),('2061-03-22'),('2061-03-23'),('2061-03-24'),('2061-03-25'),('2061-03-26'),('2061-03-27'),('2061-03-28'),('2061-03-29'),('2061-03-30'),('2061-03-31'),('2061-04-01'),('2061-04-02'),('2061-04-03'),('2061-04-04'),('2061-04-05'),('2061-04-06'),('2061-04-07'),('2061-04-08'),('2061-04-09'),('2061-04-10'),('2061-04-11'),('2061-04-12'),('2061-04-13'),('2061-04-14'),('2061-04-15'),('2061-04-16'),('2061-04-17'),('2061-04-18'),('2061-04-19'),('2061-04-20'),('2061-04-21'),('2061-04-22'),('2061-04-23'),('2061-04-24'),('2061-04-25'),('2061-04-26'),('2061-04-27'),('2061-04-28'),('2061-04-29'),('2061-04-30'),('2061-05-01'),('2061-05-02'),('2061-05-03'),('2061-05-04'),('2061-05-05'),('2061-05-06'),('2061-05-07'),('2061-05-08'),('2061-05-09'),('2061-05-10'),('2061-05-11'),('2061-05-12'),('2061-05-13'),('2061-05-14'),('2061-05-15'),('2061-05-16'),('2061-05-17'),('2061-05-18'),('2061-05-19'),('2061-05-20'),('2061-05-21'),('2061-05-22'),('2061-05-23'),('2061-05-24'),('2061-05-25'),('2061-05-26'),('2061-05-27'),('2061-05-28'),('2061-05-29'),('2061-05-30'),('2061-05-31'),('2061-06-01'),('2061-06-02'),('2061-06-03'),('2061-06-04'),('2061-06-05'),('2061-06-06'),('2061-06-07'),('2061-06-08'),('2061-06-09'),('2061-06-10'),('2061-06-11'),('2061-06-12'),('2061-06-13'),('2061-06-14'),('2061-06-15'),('2061-06-16'),('2061-06-17'),('2061-06-18'),('2061-06-19'),('2061-06-20'),('2061-06-21'),('2061-06-22'),('2061-06-23'),('2061-06-24'),('2061-06-25'),('2061-06-26'),('2061-06-27'),('2061-06-28'),('2061-06-29'),('2061-06-30'),('2061-07-01'),('2061-07-02'),('2061-07-03'),('2061-07-04'),('2061-07-05'),('2061-07-06'),('2061-07-07'),('2061-07-08'),('2061-07-09'),('2061-07-10'),('2061-07-11'),('2061-07-12'),('2061-07-13'),('2061-07-14'),('2061-07-15'),('2061-07-16'),('2061-07-17'),('2061-07-18'),('2061-07-19'),('2061-07-20'),('2061-07-21'),('2061-07-22'),('2061-07-23'),('2061-07-24'),('2061-07-25'),('2061-07-26'),('2061-07-27'),('2061-07-28'),('2061-07-29'),('2061-07-30'),('2061-07-31'),('2061-08-01'),('2061-08-02'),('2061-08-03'),('2061-08-04'),('2061-08-05'),('2061-08-06'),('2061-08-07'),('2061-08-08'),('2061-08-09'),('2061-08-10'),('2061-08-11'),('2061-08-12'),('2061-08-13'),('2061-08-14'),('2061-08-15'),('2061-08-16'),('2061-08-17'),('2061-08-18'),('2061-08-19'),('2061-08-20'),('2061-08-21'),('2061-08-22'),('2061-08-23'),('2061-08-24'),('2061-08-25'),('2061-08-26'),('2061-08-27'),('2061-08-28'),('2061-08-29'),('2061-08-30'),('2061-08-31'),('2061-09-01'),('2061-09-02'),('2061-09-03'),('2061-09-04'),('2061-09-05'),('2061-09-06'),('2061-09-07'),('2061-09-08'),('2061-09-09'),('2061-09-10'),('2061-09-11'),('2061-09-12'),('2061-09-13'),('2061-09-14'),('2061-09-15'),('2061-09-16'),('2061-09-17'),('2061-09-18'),('2061-09-19'),('2061-09-20'),('2061-09-21'),('2061-09-22'),('2061-09-23'),('2061-09-24'),('2061-09-25'),('2061-09-26'),('2061-09-27'),('2061-09-28'),('2061-09-29'),('2061-09-30'),('2061-10-01'),('2061-10-02'),('2061-10-03'),('2061-10-04'),('2061-10-05'),('2061-10-06'),('2061-10-07'),('2061-10-08'),('2061-10-09'),('2061-10-10'),('2061-10-11'),('2061-10-12'),('2061-10-13'),('2061-10-14'),('2061-10-15'),('2061-10-16'),('2061-10-17'),('2061-10-18'),('2061-10-19'),('2061-10-20'),('2061-10-21'),('2061-10-22'),('2061-10-23'),('2061-10-24'),('2061-10-25'),('2061-10-26'),('2061-10-27'),('2061-10-28'),('2061-10-29'),('2061-10-30'),('2061-10-31'),('2061-11-01'),('2061-11-02'),('2061-11-03'),('2061-11-04'),('2061-11-05'),('2061-11-06'),('2061-11-07'),('2061-11-08'),('2061-11-09'),('2061-11-10'),('2061-11-11'),('2061-11-12'),('2061-11-13'),('2061-11-14'),('2061-11-15'),('2061-11-16'),('2061-11-17'),('2061-11-18'),('2061-11-19'),('2061-11-20'),('2061-11-21'),('2061-11-22'),('2061-11-23'),('2061-11-24'),('2061-11-25'),('2061-11-26'),('2061-11-27'),('2061-11-28'),('2061-11-29'),('2061-11-30'),('2061-12-01'),('2061-12-02'),('2061-12-03'),('2061-12-04'),('2061-12-05'),('2061-12-06'),('2061-12-07'),('2061-12-08'),('2061-12-09'),('2061-12-10'),('2061-12-11'),('2061-12-12'),('2061-12-13'),('2061-12-14'),('2061-12-15'),('2061-12-16'),('2061-12-17'),('2061-12-18'),('2061-12-19'),('2061-12-20'),('2061-12-21'),('2061-12-22'),('2061-12-23'),('2061-12-24'),('2061-12-25'),('2061-12-26'),('2061-12-27'),('2061-12-28'),('2061-12-29'),('2061-12-30'),('2061-12-31'),('2062-01-01'),('2062-01-02'),('2062-01-03'),('2062-01-04'),('2062-01-05'),('2062-01-06'),('2062-01-07'),('2062-01-08'),('2062-01-09'),('2062-01-10'),('2062-01-11'),('2062-01-12'),('2062-01-13'),('2062-01-14'),('2062-01-15'),('2062-01-16'),('2062-01-17'),('2062-01-18'),('2062-01-19'),('2062-01-20'),('2062-01-21'),('2062-01-22'),('2062-01-23'),('2062-01-24'),('2062-01-25'),('2062-01-26'),('2062-01-27'),('2062-01-28'),('2062-01-29'),('2062-01-30'),('2062-01-31'),('2062-02-01'),('2062-02-02'),('2062-02-03'),('2062-02-04'),('2062-02-05'),('2062-02-06'),('2062-02-07'),('2062-02-08'),('2062-02-09'),('2062-02-10'),('2062-02-11'),('2062-02-12'),('2062-02-13'),('2062-02-14'),('2062-02-15'),('2062-02-16'),('2062-02-17'),('2062-02-18'),('2062-02-19'),('2062-02-20'),('2062-02-21'),('2062-02-22'),('2062-02-23'),('2062-02-24'),('2062-02-25'),('2062-02-26'),('2062-02-27'),('2062-02-28'),('2062-03-01'),('2062-03-02'),('2062-03-03'),('2062-03-04'),('2062-03-05'),('2062-03-06'),('2062-03-07'),('2062-03-08'),('2062-03-09'),('2062-03-10'),('2062-03-11'),('2062-03-12'),('2062-03-13'),('2062-03-14'),('2062-03-15'),('2062-03-16'),('2062-03-17'),('2062-03-18'),('2062-03-19'),('2062-03-20'),('2062-03-21'),('2062-03-22'),('2062-03-23'),('2062-03-24'),('2062-03-25'),('2062-03-26'),('2062-03-27'),('2062-03-28'),('2062-03-29'),('2062-03-30'),('2062-03-31'),('2062-04-01'),('2062-04-02'),('2062-04-03'),('2062-04-04'),('2062-04-05'),('2062-04-06'),('2062-04-07'),('2062-04-08'),('2062-04-09'),('2062-04-10'),('2062-04-11'),('2062-04-12'),('2062-04-13'),('2062-04-14'),('2062-04-15'),('2062-04-16'),('2062-04-17'),('2062-04-18'),('2062-04-19'),('2062-04-20'),('2062-04-21'),('2062-04-22'),('2062-04-23'),('2062-04-24'),('2062-04-25'),('2062-04-26'),('2062-04-27'),('2062-04-28'),('2062-04-29'),('2062-04-30'),('2062-05-01'),('2062-05-02'),('2062-05-03'),('2062-05-04'),('2062-05-05'),('2062-05-06'),('2062-05-07'),('2062-05-08'),('2062-05-09'),('2062-05-10'),('2062-05-11'),('2062-05-12'),('2062-05-13'),('2062-05-14'),('2062-05-15'),('2062-05-16'),('2062-05-17'),('2062-05-18'),('2062-05-19'),('2062-05-20'),('2062-05-21'),('2062-05-22'),('2062-05-23'),('2062-05-24'),('2062-05-25'),('2062-05-26'),('2062-05-27'),('2062-05-28'),('2062-05-29'),('2062-05-30'),('2062-05-31'),('2062-06-01'),('2062-06-02'),('2062-06-03'),('2062-06-04'),('2062-06-05'),('2062-06-06'),('2062-06-07'),('2062-06-08'),('2062-06-09'),('2062-06-10'),('2062-06-11'),('2062-06-12'),('2062-06-13'),('2062-06-14'),('2062-06-15'),('2062-06-16'),('2062-06-17'),('2062-06-18'),('2062-06-19'),('2062-06-20'),('2062-06-21'),('2062-06-22'),('2062-06-23'),('2062-06-24'),('2062-06-25'),('2062-06-26'),('2062-06-27'),('2062-06-28'),('2062-06-29'),('2062-06-30'),('2062-07-01'),('2062-07-02'),('2062-07-03'),('2062-07-04'),('2062-07-05'),('2062-07-06'),('2062-07-07'),('2062-07-08'),('2062-07-09'),('2062-07-10'),('2062-07-11'),('2062-07-12'),('2062-07-13'),('2062-07-14'),('2062-07-15'),('2062-07-16'),('2062-07-17'),('2062-07-18'),('2062-07-19'),('2062-07-20'),('2062-07-21'),('2062-07-22'),('2062-07-23'),('2062-07-24'),('2062-07-25'),('2062-07-26'),('2062-07-27'),('2062-07-28'),('2062-07-29'),('2062-07-30'),('2062-07-31'),('2062-08-01'),('2062-08-02'),('2062-08-03'),('2062-08-04'),('2062-08-05'),('2062-08-06'),('2062-08-07'),('2062-08-08'),('2062-08-09'),('2062-08-10'),('2062-08-11'),('2062-08-12'),('2062-08-13'),('2062-08-14'),('2062-08-15'),('2062-08-16'),('2062-08-17'),('2062-08-18'),('2062-08-19'),('2062-08-20'),('2062-08-21'),('2062-08-22'),('2062-08-23'),('2062-08-24'),('2062-08-25'),('2062-08-26'),('2062-08-27'),('2062-08-28'),('2062-08-29'),('2062-08-30'),('2062-08-31'),('2062-09-01'),('2062-09-02'),('2062-09-03'),('2062-09-04'),('2062-09-05'),('2062-09-06'),('2062-09-07'),('2062-09-08'),('2062-09-09'),('2062-09-10'),('2062-09-11'),('2062-09-12'),('2062-09-13'),('2062-09-14'),('2062-09-15'),('2062-09-16'),('2062-09-17'),('2062-09-18'),('2062-09-19'),('2062-09-20'),('2062-09-21'),('2062-09-22'),('2062-09-23'),('2062-09-24'),('2062-09-25'),('2062-09-26'),('2062-09-27'),('2062-09-28'),('2062-09-29'),('2062-09-30'),('2062-10-01'),('2062-10-02'),('2062-10-03'),('2062-10-04'),('2062-10-05'),('2062-10-06'),('2062-10-07'),('2062-10-08'),('2062-10-09'),('2062-10-10'),('2062-10-11'),('2062-10-12'),('2062-10-13'),('2062-10-14'),('2062-10-15'),('2062-10-16'),('2062-10-17'),('2062-10-18'),('2062-10-19'),('2062-10-20'),('2062-10-21'),('2062-10-22'),('2062-10-23'),('2062-10-24'),('2062-10-25'),('2062-10-26'),('2062-10-27'),('2062-10-28'),('2062-10-29'),('2062-10-30'),('2062-10-31'),('2062-11-01'),('2062-11-02'),('2062-11-03'),('2062-11-04'),('2062-11-05'),('2062-11-06'),('2062-11-07'),('2062-11-08'),('2062-11-09'),('2062-11-10'),('2062-11-11'),('2062-11-12'),('2062-11-13'),('2062-11-14'),('2062-11-15'),('2062-11-16'),('2062-11-17'),('2062-11-18'),('2062-11-19'),('2062-11-20'),('2062-11-21'),('2062-11-22'),('2062-11-23'),('2062-11-24'),('2062-11-25'),('2062-11-26'),('2062-11-27'),('2062-11-28'),('2062-11-29'),('2062-11-30'),('2062-12-01'),('2062-12-02'),('2062-12-03'),('2062-12-04'),('2062-12-05'),('2062-12-06'),('2062-12-07'),('2062-12-08'),('2062-12-09'),('2062-12-10'),('2062-12-11'),('2062-12-12'),('2062-12-13'),('2062-12-14'),('2062-12-15'),('2062-12-16'),('2062-12-17'),('2062-12-18'),('2062-12-19'),('2062-12-20'),('2062-12-21'),('2062-12-22'),('2062-12-23'),('2062-12-24'),('2062-12-25'),('2062-12-26'),('2062-12-27'),('2062-12-28'),('2062-12-29'),('2062-12-30'),('2062-12-31'),('2063-01-01'),('2063-01-02'),('2063-01-03'),('2063-01-04'),('2063-01-05'),('2063-01-06'),('2063-01-07'),('2063-01-08'),('2063-01-09'),('2063-01-10'),('2063-01-11'),('2063-01-12'),('2063-01-13'),('2063-01-14'),('2063-01-15'),('2063-01-16'),('2063-01-17'),('2063-01-18'),('2063-01-19'),('2063-01-20'),('2063-01-21'),('2063-01-22'),('2063-01-23'),('2063-01-24'),('2063-01-25'),('2063-01-26'),('2063-01-27'),('2063-01-28'),('2063-01-29'),('2063-01-30'),('2063-01-31'),('2063-02-01'),('2063-02-02'),('2063-02-03'),('2063-02-04'),('2063-02-05'),('2063-02-06'),('2063-02-07'),('2063-02-08'),('2063-02-09'),('2063-02-10'),('2063-02-11'),('2063-02-12'),('2063-02-13'),('2063-02-14'),('2063-02-15'),('2063-02-16'),('2063-02-17'),('2063-02-18'),('2063-02-19'),('2063-02-20'),('2063-02-21'),('2063-02-22'),('2063-02-23'),('2063-02-24'),('2063-02-25'),('2063-02-26'),('2063-02-27'),('2063-02-28'),('2063-03-01'),('2063-03-02'),('2063-03-03'),('2063-03-04'),('2063-03-05'),('2063-03-06'),('2063-03-07'),('2063-03-08'),('2063-03-09'),('2063-03-10'),('2063-03-11'),('2063-03-12'),('2063-03-13'),('2063-03-14'),('2063-03-15'),('2063-03-16'),('2063-03-17'),('2063-03-18'),('2063-03-19'),('2063-03-20'),('2063-03-21'),('2063-03-22'),('2063-03-23'),('2063-03-24'),('2063-03-25'),('2063-03-26'),('2063-03-27'),('2063-03-28'),('2063-03-29'),('2063-03-30'),('2063-03-31'),('2063-04-01'),('2063-04-02'),('2063-04-03'),('2063-04-04'),('2063-04-05'),('2063-04-06'),('2063-04-07'),('2063-04-08'),('2063-04-09'),('2063-04-10'),('2063-04-11'),('2063-04-12'),('2063-04-13'),('2063-04-14'),('2063-04-15'),('2063-04-16'),('2063-04-17'),('2063-04-18'),('2063-04-19'),('2063-04-20'),('2063-04-21'),('2063-04-22'),('2063-04-23'),('2063-04-24'),('2063-04-25'),('2063-04-26'),('2063-04-27'),('2063-04-28'),('2063-04-29'),('2063-04-30'),('2063-05-01'),('2063-05-02'),('2063-05-03'),('2063-05-04'),('2063-05-05'),('2063-05-06'),('2063-05-07'),('2063-05-08'),('2063-05-09'),('2063-05-10'),('2063-05-11'),('2063-05-12'),('2063-05-13'),('2063-05-14'),('2063-05-15'),('2063-05-16'),('2063-05-17'),('2063-05-18'),('2063-05-19'),('2063-05-20'),('2063-05-21'),('2063-05-22'),('2063-05-23'),('2063-05-24'),('2063-05-25'),('2063-05-26'),('2063-05-27'),('2063-05-28'),('2063-05-29'),('2063-05-30'),('2063-05-31'),('2063-06-01'),('2063-06-02'),('2063-06-03'),('2063-06-04'),('2063-06-05'),('2063-06-06'),('2063-06-07'),('2063-06-08'),('2063-06-09'),('2063-06-10'),('2063-06-11'),('2063-06-12'),('2063-06-13'),('2063-06-14'),('2063-06-15'),('2063-06-16'),('2063-06-17'),('2063-06-18'),('2063-06-19'),('2063-06-20'),('2063-06-21'),('2063-06-22'),('2063-06-23'),('2063-06-24'),('2063-06-25'),('2063-06-26'),('2063-06-27'),('2063-06-28'),('2063-06-29'),('2063-06-30'),('2063-07-01'),('2063-07-02'),('2063-07-03'),('2063-07-04'),('2063-07-05'),('2063-07-06'),('2063-07-07'),('2063-07-08'),('2063-07-09'),('2063-07-10'),('2063-07-11'),('2063-07-12'),('2063-07-13'),('2063-07-14'),('2063-07-15'),('2063-07-16'),('2063-07-17'),('2063-07-18'),('2063-07-19'),('2063-07-20'),('2063-07-21'),('2063-07-22'),('2063-07-23'),('2063-07-24'),('2063-07-25'),('2063-07-26'),('2063-07-27'),('2063-07-28'),('2063-07-29'),('2063-07-30'),('2063-07-31'),('2063-08-01'),('2063-08-02'),('2063-08-03'),('2063-08-04'),('2063-08-05'),('2063-08-06'),('2063-08-07'),('2063-08-08'),('2063-08-09'),('2063-08-10'),('2063-08-11'),('2063-08-12'),('2063-08-13'),('2063-08-14'),('2063-08-15'),('2063-08-16'),('2063-08-17'),('2063-08-18'),('2063-08-19'),('2063-08-20'),('2063-08-21'),('2063-08-22'),('2063-08-23'),('2063-08-24'),('2063-08-25'),('2063-08-26'),('2063-08-27'),('2063-08-28'),('2063-08-29'),('2063-08-30'),('2063-08-31'),('2063-09-01'),('2063-09-02'),('2063-09-03'),('2063-09-04'),('2063-09-05'),('2063-09-06'),('2063-09-07'),('2063-09-08'),('2063-09-09'),('2063-09-10'),('2063-09-11'),('2063-09-12'),('2063-09-13'),('2063-09-14'),('2063-09-15'),('2063-09-16'),('2063-09-17'),('2063-09-18'),('2063-09-19'),('2063-09-20'),('2063-09-21'),('2063-09-22'),('2063-09-23'),('2063-09-24'),('2063-09-25'),('2063-09-26'),('2063-09-27'),('2063-09-28'),('2063-09-29'),('2063-09-30'),('2063-10-01'),('2063-10-02'),('2063-10-03'),('2063-10-04'),('2063-10-05'),('2063-10-06'),('2063-10-07'),('2063-10-08'),('2063-10-09'),('2063-10-10'),('2063-10-11'),('2063-10-12'),('2063-10-13'),('2063-10-14'),('2063-10-15'),('2063-10-16'),('2063-10-17'),('2063-10-18'),('2063-10-19'),('2063-10-20'),('2063-10-21'),('2063-10-22'),('2063-10-23'),('2063-10-24'),('2063-10-25'),('2063-10-26'),('2063-10-27'),('2063-10-28'),('2063-10-29'),('2063-10-30'),('2063-10-31'),('2063-11-01'),('2063-11-02'),('2063-11-03'),('2063-11-04'),('2063-11-05'),('2063-11-06'),('2063-11-07'),('2063-11-08'),('2063-11-09'),('2063-11-10'),('2063-11-11'),('2063-11-12'),('2063-11-13'),('2063-11-14'),('2063-11-15'),('2063-11-16'),('2063-11-17'),('2063-11-18'),('2063-11-19'),('2063-11-20'),('2063-11-21'),('2063-11-22'),('2063-11-23'),('2063-11-24'),('2063-11-25'),('2063-11-26'),('2063-11-27'),('2063-11-28'),('2063-11-29'),('2063-11-30'),('2063-12-01'),('2063-12-02'),('2063-12-03'),('2063-12-04'),('2063-12-05'),('2063-12-06'),('2063-12-07'),('2063-12-08'),('2063-12-09'),('2063-12-10'),('2063-12-11'),('2063-12-12'),('2063-12-13'),('2063-12-14'),('2063-12-15'),('2063-12-16'),('2063-12-17'),('2063-12-18'),('2063-12-19'),('2063-12-20'),('2063-12-21'),('2063-12-22'),('2063-12-23'),('2063-12-24'),('2063-12-25'),('2063-12-26'),('2063-12-27'),('2063-12-28'),('2063-12-29'),('2063-12-30'),('2063-12-31'),('2064-01-01'),('2064-01-02'),('2064-01-03'),('2064-01-04'),('2064-01-05'),('2064-01-06'),('2064-01-07'),('2064-01-08'),('2064-01-09'),('2064-01-10'),('2064-01-11'),('2064-01-12'),('2064-01-13'),('2064-01-14'),('2064-01-15'),('2064-01-16'),('2064-01-17'),('2064-01-18'),('2064-01-19'),('2064-01-20'),('2064-01-21'),('2064-01-22'),('2064-01-23'),('2064-01-24'),('2064-01-25'),('2064-01-26'),('2064-01-27'),('2064-01-28'),('2064-01-29'),('2064-01-30'),('2064-01-31'),('2064-02-01'),('2064-02-02'),('2064-02-03'),('2064-02-04'),('2064-02-05'),('2064-02-06'),('2064-02-07'),('2064-02-08'),('2064-02-09'),('2064-02-10'),('2064-02-11'),('2064-02-12'),('2064-02-13'),('2064-02-14'),('2064-02-15'),('2064-02-16'),('2064-02-17'),('2064-02-18'),('2064-02-19'),('2064-02-20'),('2064-02-21'),('2064-02-22'),('2064-02-23'),('2064-02-24'),('2064-02-25'),('2064-02-26'),('2064-02-27'),('2064-02-28'),('2064-02-29'),('2064-03-01'),('2064-03-02'),('2064-03-03'),('2064-03-04'),('2064-03-05'),('2064-03-06'),('2064-03-07'),('2064-03-08'),('2064-03-09'),('2064-03-10'),('2064-03-11'),('2064-03-12'),('2064-03-13'),('2064-03-14'),('2064-03-15'),('2064-03-16'),('2064-03-17'),('2064-03-18'),('2064-03-19'),('2064-03-20'),('2064-03-21'),('2064-03-22'),('2064-03-23'),('2064-03-24'),('2064-03-25'),('2064-03-26'),('2064-03-27'),('2064-03-28'),('2064-03-29'),('2064-03-30'),('2064-03-31'),('2064-04-01'),('2064-04-02'),('2064-04-03'),('2064-04-04'),('2064-04-05'),('2064-04-06'),('2064-04-07'),('2064-04-08'),('2064-04-09'),('2064-04-10'),('2064-04-11'),('2064-04-12'),('2064-04-13'),('2064-04-14'),('2064-04-15'),('2064-04-16'),('2064-04-17'),('2064-04-18'),('2064-04-19'),('2064-04-20'),('2064-04-21'),('2064-04-22'),('2064-04-23'),('2064-04-24'),('2064-04-25'),('2064-04-26'),('2064-04-27'),('2064-04-28'),('2064-04-29'),('2064-04-30'),('2064-05-01'),('2064-05-02'),('2064-05-03'),('2064-05-04'),('2064-05-05'),('2064-05-06'),('2064-05-07'),('2064-05-08'),('2064-05-09'),('2064-05-10'),('2064-05-11'),('2064-05-12'),('2064-05-13'),('2064-05-14'),('2064-05-15'),('2064-05-16'),('2064-05-17'),('2064-05-18'),('2064-05-19'),('2064-05-20'),('2064-05-21'),('2064-05-22'),('2064-05-23'),('2064-05-24'),('2064-05-25'),('2064-05-26'),('2064-05-27'),('2064-05-28'),('2064-05-29'),('2064-05-30'),('2064-05-31'),('2064-06-01'),('2064-06-02'),('2064-06-03'),('2064-06-04'),('2064-06-05'),('2064-06-06'),('2064-06-07'),('2064-06-08'),('2064-06-09'),('2064-06-10'),('2064-06-11'),('2064-06-12'),('2064-06-13'),('2064-06-14'),('2064-06-15'),('2064-06-16'),('2064-06-17'),('2064-06-18'),('2064-06-19'),('2064-06-20'),('2064-06-21'),('2064-06-22'),('2064-06-23'),('2064-06-24'),('2064-06-25'),('2064-06-26'),('2064-06-27'),('2064-06-28'),('2064-06-29'),('2064-06-30'),('2064-07-01'),('2064-07-02'),('2064-07-03'),('2064-07-04'),('2064-07-05'),('2064-07-06'),('2064-07-07'),('2064-07-08'),('2064-07-09'),('2064-07-10'),('2064-07-11'),('2064-07-12'),('2064-07-13'),('2064-07-14'),('2064-07-15'),('2064-07-16'),('2064-07-17'),('2064-07-18'),('2064-07-19'),('2064-07-20'),('2064-07-21'),('2064-07-22'),('2064-07-23'),('2064-07-24'),('2064-07-25'),('2064-07-26'),('2064-07-27'),('2064-07-28'),('2064-07-29'),('2064-07-30'),('2064-07-31'),('2064-08-01'),('2064-08-02'),('2064-08-03'),('2064-08-04'),('2064-08-05'),('2064-08-06'),('2064-08-07'),('2064-08-08'),('2064-08-09'),('2064-08-10'),('2064-08-11'),('2064-08-12'),('2064-08-13'),('2064-08-14'),('2064-08-15'),('2064-08-16'),('2064-08-17'),('2064-08-18'),('2064-08-19'),('2064-08-20'),('2064-08-21'),('2064-08-22'),('2064-08-23'),('2064-08-24'),('2064-08-25'),('2064-08-26'),('2064-08-27'),('2064-08-28'),('2064-08-29'),('2064-08-30'),('2064-08-31'),('2064-09-01'),('2064-09-02'),('2064-09-03'),('2064-09-04'),('2064-09-05'),('2064-09-06'),('2064-09-07'),('2064-09-08'),('2064-09-09'),('2064-09-10'),('2064-09-11'),('2064-09-12'),('2064-09-13'),('2064-09-14'),('2064-09-15'),('2064-09-16'),('2064-09-17'),('2064-09-18'),('2064-09-19'),('2064-09-20'),('2064-09-21'),('2064-09-22'),('2064-09-23'),('2064-09-24'),('2064-09-25'),('2064-09-26'),('2064-09-27'),('2064-09-28'),('2064-09-29'),('2064-09-30'),('2064-10-01'),('2064-10-02'),('2064-10-03'),('2064-10-04'),('2064-10-05'),('2064-10-06'),('2064-10-07'),('2064-10-08'),('2064-10-09'),('2064-10-10'),('2064-10-11'),('2064-10-12'),('2064-10-13'),('2064-10-14'),('2064-10-15'),('2064-10-16'),('2064-10-17'),('2064-10-18'),('2064-10-19'),('2064-10-20'),('2064-10-21'),('2064-10-22'),('2064-10-23'),('2064-10-24'),('2064-10-25'),('2064-10-26'),('2064-10-27'),('2064-10-28'),('2064-10-29'),('2064-10-30'),('2064-10-31'),('2064-11-01'),('2064-11-02'),('2064-11-03'),('2064-11-04'),('2064-11-05'),('2064-11-06'),('2064-11-07'),('2064-11-08'),('2064-11-09'),('2064-11-10'),('2064-11-11'),('2064-11-12'),('2064-11-13'),('2064-11-14'),('2064-11-15'),('2064-11-16'),('2064-11-17'),('2064-11-18'),('2064-11-19'),('2064-11-20'),('2064-11-21'),('2064-11-22'),('2064-11-23'),('2064-11-24'),('2064-11-25'),('2064-11-26'),('2064-11-27'),('2064-11-28'),('2064-11-29'),('2064-11-30'),('2064-12-01'),('2064-12-02'),('2064-12-03'),('2064-12-04'),('2064-12-05'),('2064-12-06'),('2064-12-07'),('2064-12-08'),('2064-12-09'),('2064-12-10'),('2064-12-11'),('2064-12-12'),('2064-12-13'),('2064-12-14'),('2064-12-15'),('2064-12-16'),('2064-12-17'),('2064-12-18'),('2064-12-19'),('2064-12-20'),('2064-12-21'),('2064-12-22'),('2064-12-23'),('2064-12-24'),('2064-12-25'),('2064-12-26'),('2064-12-27'),('2064-12-28'),('2064-12-29'),('2064-12-30'),('2064-12-31'),('2065-01-01'),('2065-01-02'),('2065-01-03'),('2065-01-04'),('2065-01-05'),('2065-01-06'),('2065-01-07'),('2065-01-08'),('2065-01-09'),('2065-01-10'),('2065-01-11'),('2065-01-12'),('2065-01-13'),('2065-01-14'),('2065-01-15'),('2065-01-16'),('2065-01-17'),('2065-01-18'),('2065-01-19'),('2065-01-20'),('2065-01-21'),('2065-01-22'),('2065-01-23'),('2065-01-24'),('2065-01-25'),('2065-01-26'),('2065-01-27'),('2065-01-28'),('2065-01-29'),('2065-01-30'),('2065-01-31'),('2065-02-01'),('2065-02-02'),('2065-02-03'),('2065-02-04'),('2065-02-05'),('2065-02-06'),('2065-02-07'),('2065-02-08'),('2065-02-09'),('2065-02-10'),('2065-02-11'),('2065-02-12'),('2065-02-13'),('2065-02-14'),('2065-02-15'),('2065-02-16'),('2065-02-17'),('2065-02-18'),('2065-02-19'),('2065-02-20'),('2065-02-21'),('2065-02-22'),('2065-02-23'),('2065-02-24'),('2065-02-25'),('2065-02-26'),('2065-02-27'),('2065-02-28'),('2065-03-01'),('2065-03-02'),('2065-03-03'),('2065-03-04'),('2065-03-05'),('2065-03-06'),('2065-03-07'),('2065-03-08'),('2065-03-09'),('2065-03-10'),('2065-03-11'),('2065-03-12'),('2065-03-13'),('2065-03-14'),('2065-03-15'),('2065-03-16'),('2065-03-17'),('2065-03-18'),('2065-03-19'),('2065-03-20'),('2065-03-21'),('2065-03-22'),('2065-03-23'),('2065-03-24'),('2065-03-25'),('2065-03-26'),('2065-03-27'),('2065-03-28'),('2065-03-29'),('2065-03-30'),('2065-03-31'),('2065-04-01'),('2065-04-02'),('2065-04-03'),('2065-04-04'),('2065-04-05'),('2065-04-06'),('2065-04-07'),('2065-04-08'),('2065-04-09'),('2065-04-10'),('2065-04-11'),('2065-04-12'),('2065-04-13'),('2065-04-14'),('2065-04-15'),('2065-04-16'),('2065-04-17'),('2065-04-18'),('2065-04-19'),('2065-04-20'),('2065-04-21'),('2065-04-22'),('2065-04-23'),('2065-04-24'),('2065-04-25'),('2065-04-26'),('2065-04-27'),('2065-04-28'),('2065-04-29'),('2065-04-30'),('2065-05-01'),('2065-05-02'),('2065-05-03'),('2065-05-04'),('2065-05-05'),('2065-05-06'),('2065-05-07'),('2065-05-08'),('2065-05-09'),('2065-05-10'),('2065-05-11'),('2065-05-12'),('2065-05-13'),('2065-05-14'),('2065-05-15'),('2065-05-16'),('2065-05-17'),('2065-05-18'),('2065-05-19'),('2065-05-20'),('2065-05-21'),('2065-05-22'),('2065-05-23'),('2065-05-24'),('2065-05-25'),('2065-05-26'),('2065-05-27'),('2065-05-28'),('2065-05-29'),('2065-05-30'),('2065-05-31'),('2065-06-01'),('2065-06-02'),('2065-06-03'),('2065-06-04'),('2065-06-05'),('2065-06-06'),('2065-06-07'),('2065-06-08'),('2065-06-09'),('2065-06-10'),('2065-06-11'),('2065-06-12'),('2065-06-13'),('2065-06-14'),('2065-06-15'),('2065-06-16'),('2065-06-17'),('2065-06-18'),('2065-06-19'),('2065-06-20'),('2065-06-21'),('2065-06-22'),('2065-06-23'),('2065-06-24'),('2065-06-25'),('2065-06-26'),('2065-06-27'),('2065-06-28'),('2065-06-29'),('2065-06-30'),('2065-07-01'),('2065-07-02'),('2065-07-03'),('2065-07-04'),('2065-07-05'),('2065-07-06'),('2065-07-07'),('2065-07-08'),('2065-07-09'),('2065-07-10'),('2065-07-11'),('2065-07-12'),('2065-07-13'),('2065-07-14'),('2065-07-15'),('2065-07-16'),('2065-07-17'),('2065-07-18'),('2065-07-19'),('2065-07-20'),('2065-07-21'),('2065-07-22'),('2065-07-23'),('2065-07-24'),('2065-07-25'),('2065-07-26'),('2065-07-27'),('2065-07-28'),('2065-07-29'),('2065-07-30'),('2065-07-31'),('2065-08-01'),('2065-08-02'),('2065-08-03'),('2065-08-04'),('2065-08-05'),('2065-08-06'),('2065-08-07'),('2065-08-08'),('2065-08-09'),('2065-08-10'),('2065-08-11'),('2065-08-12'),('2065-08-13'),('2065-08-14'),('2065-08-15'),('2065-08-16'),('2065-08-17'),('2065-08-18'),('2065-08-19'),('2065-08-20'),('2065-08-21'),('2065-08-22'),('2065-08-23'),('2065-08-24'),('2065-08-25'),('2065-08-26'),('2065-08-27'),('2065-08-28'),('2065-08-29'),('2065-08-30'),('2065-08-31'),('2065-09-01'),('2065-09-02'),('2065-09-03'),('2065-09-04'),('2065-09-05'),('2065-09-06'),('2065-09-07'),('2065-09-08'),('2065-09-09'),('2065-09-10'),('2065-09-11'),('2065-09-12'),('2065-09-13'),('2065-09-14'),('2065-09-15'),('2065-09-16'),('2065-09-17'),('2065-09-18'),('2065-09-19'),('2065-09-20'),('2065-09-21'),('2065-09-22'),('2065-09-23'),('2065-09-24'),('2065-09-25'),('2065-09-26'),('2065-09-27'),('2065-09-28'),('2065-09-29'),('2065-09-30'),('2065-10-01'),('2065-10-02'),('2065-10-03'),('2065-10-04'),('2065-10-05'),('2065-10-06'),('2065-10-07'),('2065-10-08'),('2065-10-09'),('2065-10-10'),('2065-10-11'),('2065-10-12'),('2065-10-13'),('2065-10-14'),('2065-10-15'),('2065-10-16'),('2065-10-17'),('2065-10-18'),('2065-10-19'),('2065-10-20'),('2065-10-21'),('2065-10-22'),('2065-10-23'),('2065-10-24'),('2065-10-25'),('2065-10-26'),('2065-10-27'),('2065-10-28'),('2065-10-29'),('2065-10-30'),('2065-10-31'),('2065-11-01'),('2065-11-02'),('2065-11-03'),('2065-11-04'),('2065-11-05'),('2065-11-06'),('2065-11-07'),('2065-11-08'),('2065-11-09'),('2065-11-10'),('2065-11-11'),('2065-11-12'),('2065-11-13'),('2065-11-14'),('2065-11-15'),('2065-11-16'),('2065-11-17'),('2065-11-18'),('2065-11-19'),('2065-11-20'),('2065-11-21'),('2065-11-22'),('2065-11-23'),('2065-11-24'),('2065-11-25'),('2065-11-26'),('2065-11-27'),('2065-11-28'),('2065-11-29'),('2065-11-30'),('2065-12-01'),('2065-12-02'),('2065-12-03'),('2065-12-04'),('2065-12-05'),('2065-12-06'),('2065-12-07'),('2065-12-08'),('2065-12-09'),('2065-12-10'),('2065-12-11'),('2065-12-12'),('2065-12-13'),('2065-12-14'),('2065-12-15'),('2065-12-16'),('2065-12-17'),('2065-12-18'),('2065-12-19'),('2065-12-20'),('2065-12-21'),('2065-12-22'),('2065-12-23'),('2065-12-24'),('2065-12-25'),('2065-12-26'),('2065-12-27'),('2065-12-28'),('2065-12-29'),('2065-12-30'),('2065-12-31'),('2066-01-01'),('2066-01-02'),('2066-01-03'),('2066-01-04'),('2066-01-05'),('2066-01-06'),('2066-01-07'),('2066-01-08'),('2066-01-09'),('2066-01-10'),('2066-01-11'),('2066-01-12'),('2066-01-13'),('2066-01-14'),('2066-01-15'),('2066-01-16'),('2066-01-17'),('2066-01-18'),('2066-01-19'),('2066-01-20'),('2066-01-21'),('2066-01-22'),('2066-01-23'),('2066-01-24'),('2066-01-25'),('2066-01-26'),('2066-01-27'),('2066-01-28'),('2066-01-29'),('2066-01-30'),('2066-01-31'),('2066-02-01'),('2066-02-02'),('2066-02-03'),('2066-02-04'),('2066-02-05'),('2066-02-06'),('2066-02-07'),('2066-02-08'),('2066-02-09'),('2066-02-10'),('2066-02-11'),('2066-02-12'),('2066-02-13'),('2066-02-14'),('2066-02-15'),('2066-02-16'),('2066-02-17'),('2066-02-18'),('2066-02-19'),('2066-02-20'),('2066-02-21'),('2066-02-22'),('2066-02-23'),('2066-02-24'),('2066-02-25'),('2066-02-26'),('2066-02-27'),('2066-02-28'),('2066-03-01'),('2066-03-02'),('2066-03-03'),('2066-03-04'),('2066-03-05'),('2066-03-06'),('2066-03-07'),('2066-03-08'),('2066-03-09'),('2066-03-10'),('2066-03-11'),('2066-03-12'),('2066-03-13'),('2066-03-14'),('2066-03-15'),('2066-03-16'),('2066-03-17'),('2066-03-18'),('2066-03-19'),('2066-03-20'),('2066-03-21'),('2066-03-22'),('2066-03-23'),('2066-03-24'),('2066-03-25'),('2066-03-26'),('2066-03-27'),('2066-03-28'),('2066-03-29'),('2066-03-30'),('2066-03-31'),('2066-04-01'),('2066-04-02'),('2066-04-03'),('2066-04-04'),('2066-04-05'),('2066-04-06'),('2066-04-07'),('2066-04-08'),('2066-04-09'),('2066-04-10'),('2066-04-11'),('2066-04-12'),('2066-04-13'),('2066-04-14'),('2066-04-15'),('2066-04-16'),('2066-04-17'),('2066-04-18'),('2066-04-19'),('2066-04-20'),('2066-04-21'),('2066-04-22'),('2066-04-23'),('2066-04-24'),('2066-04-25'),('2066-04-26'),('2066-04-27'),('2066-04-28'),('2066-04-29'),('2066-04-30'),('2066-05-01'),('2066-05-02'),('2066-05-03'),('2066-05-04'),('2066-05-05'),('2066-05-06'),('2066-05-07'),('2066-05-08'),('2066-05-09'),('2066-05-10'),('2066-05-11'),('2066-05-12'),('2066-05-13'),('2066-05-14'),('2066-05-15'),('2066-05-16'),('2066-05-17'),('2066-05-18'),('2066-05-19'),('2066-05-20'),('2066-05-21'),('2066-05-22'),('2066-05-23'),('2066-05-24'),('2066-05-25'),('2066-05-26'),('2066-05-27'),('2066-05-28'),('2066-05-29'),('2066-05-30'),('2066-05-31'),('2066-06-01'),('2066-06-02'),('2066-06-03'),('2066-06-04'),('2066-06-05'),('2066-06-06'),('2066-06-07'),('2066-06-08'),('2066-06-09'),('2066-06-10'),('2066-06-11'),('2066-06-12'),('2066-06-13'),('2066-06-14'),('2066-06-15'),('2066-06-16'),('2066-06-17'),('2066-06-18'),('2066-06-19'),('2066-06-20'),('2066-06-21'),('2066-06-22'),('2066-06-23'),('2066-06-24'),('2066-06-25'),('2066-06-26'),('2066-06-27'),('2066-06-28'),('2066-06-29'),('2066-06-30'),('2066-07-01'),('2066-07-02'),('2066-07-03'),('2066-07-04'),('2066-07-05'),('2066-07-06'),('2066-07-07'),('2066-07-08'),('2066-07-09'),('2066-07-10'),('2066-07-11'),('2066-07-12'),('2066-07-13'),('2066-07-14'),('2066-07-15'),('2066-07-16'),('2066-07-17'),('2066-07-18'),('2066-07-19'),('2066-07-20'),('2066-07-21'),('2066-07-22'),('2066-07-23'),('2066-07-24'),('2066-07-25'),('2066-07-26'),('2066-07-27'),('2066-07-28'),('2066-07-29'),('2066-07-30'),('2066-07-31'),('2066-08-01'),('2066-08-02'),('2066-08-03'),('2066-08-04'),('2066-08-05'),('2066-08-06'),('2066-08-07'),('2066-08-08'),('2066-08-09'),('2066-08-10'),('2066-08-11'),('2066-08-12'),('2066-08-13'),('2066-08-14'),('2066-08-15'),('2066-08-16'),('2066-08-17'),('2066-08-18'),('2066-08-19'),('2066-08-20'),('2066-08-21'),('2066-08-22'),('2066-08-23'),('2066-08-24'),('2066-08-25'),('2066-08-26'),('2066-08-27'),('2066-08-28'),('2066-08-29'),('2066-08-30'),('2066-08-31'),('2066-09-01'),('2066-09-02'),('2066-09-03'),('2066-09-04'),('2066-09-05'),('2066-09-06'),('2066-09-07'),('2066-09-08'),('2066-09-09'),('2066-09-10'),('2066-09-11'),('2066-09-12'),('2066-09-13'),('2066-09-14'),('2066-09-15'),('2066-09-16'),('2066-09-17'),('2066-09-18'),('2066-09-19'),('2066-09-20'),('2066-09-21'),('2066-09-22'),('2066-09-23'),('2066-09-24'),('2066-09-25'),('2066-09-26'),('2066-09-27'),('2066-09-28'),('2066-09-29'),('2066-09-30'),('2066-10-01'),('2066-10-02'),('2066-10-03'),('2066-10-04'),('2066-10-05'),('2066-10-06'),('2066-10-07'),('2066-10-08'),('2066-10-09'),('2066-10-10'),('2066-10-11'),('2066-10-12'),('2066-10-13'),('2066-10-14'),('2066-10-15'),('2066-10-16'),('2066-10-17'),('2066-10-18'),('2066-10-19'),('2066-10-20'),('2066-10-21'),('2066-10-22'),('2066-10-23'),('2066-10-24'),('2066-10-25'),('2066-10-26'),('2066-10-27'),('2066-10-28'),('2066-10-29'),('2066-10-30'),('2066-10-31'),('2066-11-01'),('2066-11-02'),('2066-11-03'),('2066-11-04'),('2066-11-05'),('2066-11-06'),('2066-11-07'),('2066-11-08'),('2066-11-09'),('2066-11-10'),('2066-11-11'),('2066-11-12'),('2066-11-13'),('2066-11-14'),('2066-11-15'),('2066-11-16'),('2066-11-17'),('2066-11-18'),('2066-11-19'),('2066-11-20'),('2066-11-21'),('2066-11-22'),('2066-11-23'),('2066-11-24'),('2066-11-25'),('2066-11-26'),('2066-11-27'),('2066-11-28'),('2066-11-29'),('2066-11-30'),('2066-12-01'),('2066-12-02'),('2066-12-03'),('2066-12-04'),('2066-12-05'),('2066-12-06'),('2066-12-07'),('2066-12-08'),('2066-12-09'),('2066-12-10'),('2066-12-11'),('2066-12-12'),('2066-12-13'),('2066-12-14'),('2066-12-15'),('2066-12-16'),('2066-12-17'),('2066-12-18'),('2066-12-19'),('2066-12-20'),('2066-12-21'),('2066-12-22'),('2066-12-23'),('2066-12-24'),('2066-12-25'),('2066-12-26'),('2066-12-27'),('2066-12-28'),('2066-12-29'),('2066-12-30'),('2066-12-31'),('2067-01-01'),('2067-01-02'),('2067-01-03'),('2067-01-04'),('2067-01-05'),('2067-01-06'),('2067-01-07'),('2067-01-08'),('2067-01-09'),('2067-01-10'),('2067-01-11'),('2067-01-12'),('2067-01-13'),('2067-01-14'),('2067-01-15'),('2067-01-16'),('2067-01-17'),('2067-01-18'),('2067-01-19'),('2067-01-20'),('2067-01-21'),('2067-01-22'),('2067-01-23'),('2067-01-24'),('2067-01-25'),('2067-01-26'),('2067-01-27'),('2067-01-28'),('2067-01-29'),('2067-01-30'),('2067-01-31'),('2067-02-01'),('2067-02-02'),('2067-02-03'),('2067-02-04'),('2067-02-05'),('2067-02-06'),('2067-02-07'),('2067-02-08'),('2067-02-09'),('2067-02-10'),('2067-02-11'),('2067-02-12'),('2067-02-13'),('2067-02-14'),('2067-02-15'),('2067-02-16'),('2067-02-17'),('2067-02-18'),('2067-02-19'),('2067-02-20'),('2067-02-21'),('2067-02-22'),('2067-02-23'),('2067-02-24'),('2067-02-25'),('2067-02-26'),('2067-02-27'),('2067-02-28'),('2067-03-01'),('2067-03-02'),('2067-03-03'),('2067-03-04'),('2067-03-05'),('2067-03-06'),('2067-03-07'),('2067-03-08'),('2067-03-09'),('2067-03-10'),('2067-03-11'),('2067-03-12'),('2067-03-13'),('2067-03-14'),('2067-03-15'),('2067-03-16'),('2067-03-17'),('2067-03-18'),('2067-03-19'),('2067-03-20'),('2067-03-21'),('2067-03-22'),('2067-03-23'),('2067-03-24'),('2067-03-25'),('2067-03-26'),('2067-03-27'),('2067-03-28'),('2067-03-29'),('2067-03-30'),('2067-03-31'),('2067-04-01'),('2067-04-02'),('2067-04-03'),('2067-04-04'),('2067-04-05'),('2067-04-06'),('2067-04-07'),('2067-04-08'),('2067-04-09'),('2067-04-10'),('2067-04-11'),('2067-04-12'),('2067-04-13'),('2067-04-14'),('2067-04-15'),('2067-04-16'),('2067-04-17'),('2067-04-18'),('2067-04-19'),('2067-04-20'),('2067-04-21'),('2067-04-22'),('2067-04-23'),('2067-04-24'),('2067-04-25'),('2067-04-26'),('2067-04-27'),('2067-04-28'),('2067-04-29'),('2067-04-30'),('2067-05-01'),('2067-05-02'),('2067-05-03'),('2067-05-04'),('2067-05-05'),('2067-05-06'),('2067-05-07'),('2067-05-08'),('2067-05-09'),('2067-05-10'),('2067-05-11'),('2067-05-12'),('2067-05-13'),('2067-05-14'),('2067-05-15'),('2067-05-16'),('2067-05-17'),('2067-05-18'),('2067-05-19'),('2067-05-20'),('2067-05-21'),('2067-05-22'),('2067-05-23'),('2067-05-24'),('2067-05-25'),('2067-05-26'),('2067-05-27'),('2067-05-28'),('2067-05-29'),('2067-05-30'),('2067-05-31'),('2067-06-01'),('2067-06-02'),('2067-06-03'),('2067-06-04'),('2067-06-05'),('2067-06-06'),('2067-06-07'),('2067-06-08'),('2067-06-09'),('2067-06-10'),('2067-06-11'),('2067-06-12'),('2067-06-13'),('2067-06-14'),('2067-06-15'),('2067-06-16'),('2067-06-17'),('2067-06-18'),('2067-06-19'),('2067-06-20'),('2067-06-21'),('2067-06-22'),('2067-06-23'),('2067-06-24'),('2067-06-25'),('2067-06-26'),('2067-06-27'),('2067-06-28'),('2067-06-29'),('2067-06-30'),('2067-07-01'),('2067-07-02'),('2067-07-03'),('2067-07-04'),('2067-07-05'),('2067-07-06'),('2067-07-07'),('2067-07-08'),('2067-07-09'),('2067-07-10'),('2067-07-11'),('2067-07-12'),('2067-07-13'),('2067-07-14'),('2067-07-15'),('2067-07-16'),('2067-07-17'),('2067-07-18'),('2067-07-19'),('2067-07-20'),('2067-07-21'),('2067-07-22'),('2067-07-23'),('2067-07-24'),('2067-07-25'),('2067-07-26'),('2067-07-27'),('2067-07-28'),('2067-07-29'),('2067-07-30'),('2067-07-31'),('2067-08-01'),('2067-08-02'),('2067-08-03'),('2067-08-04'),('2067-08-05'),('2067-08-06'),('2067-08-07'),('2067-08-08'),('2067-08-09'),('2067-08-10'),('2067-08-11'),('2067-08-12'),('2067-08-13'),('2067-08-14'),('2067-08-15'),('2067-08-16'),('2067-08-17'),('2067-08-18'),('2067-08-19'),('2067-08-20'),('2067-08-21'),('2067-08-22'),('2067-08-23'),('2067-08-24'),('2067-08-25'),('2067-08-26'),('2067-08-27'),('2067-08-28'),('2067-08-29'),('2067-08-30'),('2067-08-31'),('2067-09-01'),('2067-09-02'),('2067-09-03'),('2067-09-04'),('2067-09-05'),('2067-09-06'),('2067-09-07'),('2067-09-08'),('2067-09-09'),('2067-09-10'),('2067-09-11'),('2067-09-12'),('2067-09-13'),('2067-09-14'),('2067-09-15'),('2067-09-16'),('2067-09-17'),('2067-09-18'),('2067-09-19'),('2067-09-20'),('2067-09-21'),('2067-09-22'),('2067-09-23'),('2067-09-24'),('2067-09-25'),('2067-09-26'),('2067-09-27'),('2067-09-28'),('2067-09-29'),('2067-09-30'),('2067-10-01'),('2067-10-02'),('2067-10-03'),('2067-10-04'),('2067-10-05'),('2067-10-06'),('2067-10-07'),('2067-10-08'),('2067-10-09'),('2067-10-10'),('2067-10-11'),('2067-10-12'),('2067-10-13'),('2067-10-14'),('2067-10-15'),('2067-10-16'),('2067-10-17'),('2067-10-18'),('2067-10-19'),('2067-10-20'),('2067-10-21'),('2067-10-22'),('2067-10-23'),('2067-10-24'),('2067-10-25'),('2067-10-26'),('2067-10-27'),('2067-10-28'),('2067-10-29'),('2067-10-30'),('2067-10-31'),('2067-11-01'),('2067-11-02'),('2067-11-03'),('2067-11-04'),('2067-11-05'),('2067-11-06'),('2067-11-07'),('2067-11-08'),('2067-11-09'),('2067-11-10'),('2067-11-11'),('2067-11-12'),('2067-11-13'),('2067-11-14'),('2067-11-15'),('2067-11-16'),('2067-11-17'),('2067-11-18'),('2067-11-19'),('2067-11-20'),('2067-11-21'),('2067-11-22'),('2067-11-23'),('2067-11-24'),('2067-11-25'),('2067-11-26'),('2067-11-27'),('2067-11-28'),('2067-11-29'),('2067-11-30'),('2067-12-01'),('2067-12-02'),('2067-12-03'),('2067-12-04'),('2067-12-05'),('2067-12-06'),('2067-12-07'),('2067-12-08'),('2067-12-09'),('2067-12-10'),('2067-12-11'),('2067-12-12'),('2067-12-13'),('2067-12-14'),('2067-12-15'),('2067-12-16'),('2067-12-17'),('2067-12-18'),('2067-12-19'),('2067-12-20'),('2067-12-21'),('2067-12-22'),('2067-12-23'),('2067-12-24'),('2067-12-25'),('2067-12-26'),('2067-12-27'),('2067-12-28'),('2067-12-29'),('2067-12-30'),('2067-12-31'),('2068-01-01'),('2068-01-02'),('2068-01-03'),('2068-01-04'),('2068-01-05'),('2068-01-06'),('2068-01-07'),('2068-01-08'),('2068-01-09'),('2068-01-10'),('2068-01-11'),('2068-01-12'),('2068-01-13'),('2068-01-14'),('2068-01-15'),('2068-01-16'),('2068-01-17'),('2068-01-18'),('2068-01-19'),('2068-01-20'),('2068-01-21'),('2068-01-22'),('2068-01-23'),('2068-01-24'),('2068-01-25'),('2068-01-26'),('2068-01-27'),('2068-01-28'),('2068-01-29'),('2068-01-30'),('2068-01-31'),('2068-02-01'),('2068-02-02'),('2068-02-03'),('2068-02-04'),('2068-02-05'),('2068-02-06'),('2068-02-07'),('2068-02-08'),('2068-02-09'),('2068-02-10'),('2068-02-11'),('2068-02-12'),('2068-02-13'),('2068-02-14'),('2068-02-15'),('2068-02-16'),('2068-02-17'),('2068-02-18'),('2068-02-19'),('2068-02-20'),('2068-02-21'),('2068-02-22'),('2068-02-23'),('2068-02-24'),('2068-02-25'),('2068-02-26'),('2068-02-27'),('2068-02-28'),('2068-02-29'),('2068-03-01'),('2068-03-02'),('2068-03-03'),('2068-03-04'),('2068-03-05'),('2068-03-06'),('2068-03-07'),('2068-03-08'),('2068-03-09'),('2068-03-10'),('2068-03-11'),('2068-03-12'),('2068-03-13'),('2068-03-14'),('2068-03-15'),('2068-03-16'),('2068-03-17'),('2068-03-18'),('2068-03-19'),('2068-03-20'),('2068-03-21'),('2068-03-22'),('2068-03-23'),('2068-03-24'),('2068-03-25'),('2068-03-26'),('2068-03-27'),('2068-03-28'),('2068-03-29'),('2068-03-30'),('2068-03-31'),('2068-04-01'),('2068-04-02'),('2068-04-03'),('2068-04-04'),('2068-04-05'),('2068-04-06'),('2068-04-07'),('2068-04-08'),('2068-04-09'),('2068-04-10'),('2068-04-11'),('2068-04-12'),('2068-04-13'),('2068-04-14'),('2068-04-15'),('2068-04-16'),('2068-04-17'),('2068-04-18'),('2068-04-19'),('2068-04-20'),('2068-04-21'),('2068-04-22'),('2068-04-23'),('2068-04-24'),('2068-04-25'),('2068-04-26'),('2068-04-27'),('2068-04-28'),('2068-04-29'),('2068-04-30'),('2068-05-01'),('2068-05-02'),('2068-05-03'),('2068-05-04'),('2068-05-05'),('2068-05-06'),('2068-05-07'),('2068-05-08'),('2068-05-09'),('2068-05-10'),('2068-05-11'),('2068-05-12'),('2068-05-13'),('2068-05-14'),('2068-05-15'),('2068-05-16'),('2068-05-17'),('2068-05-18'),('2068-05-19'),('2068-05-20'),('2068-05-21'),('2068-05-22'),('2068-05-23'),('2068-05-24'),('2068-05-25'),('2068-05-26'),('2068-05-27'),('2068-05-28'),('2068-05-29'),('2068-05-30'),('2068-05-31'),('2068-06-01'),('2068-06-02'),('2068-06-03'),('2068-06-04'),('2068-06-05'),('2068-06-06'),('2068-06-07'),('2068-06-08'),('2068-06-09'),('2068-06-10'),('2068-06-11'),('2068-06-12'),('2068-06-13'),('2068-06-14'),('2068-06-15'),('2068-06-16'),('2068-06-17'),('2068-06-18'),('2068-06-19'),('2068-06-20'),('2068-06-21'),('2068-06-22'),('2068-06-23'),('2068-06-24'),('2068-06-25'),('2068-06-26'),('2068-06-27'),('2068-06-28'),('2068-06-29'),('2068-06-30'),('2068-07-01'),('2068-07-02'),('2068-07-03'),('2068-07-04'),('2068-07-05'),('2068-07-06'),('2068-07-07'),('2068-07-08'),('2068-07-09'),('2068-07-10'),('2068-07-11'),('2068-07-12'),('2068-07-13'),('2068-07-14'),('2068-07-15'),('2068-07-16'),('2068-07-17'),('2068-07-18'),('2068-07-19'),('2068-07-20'),('2068-07-21'),('2068-07-22'),('2068-07-23'),('2068-07-24'),('2068-07-25'),('2068-07-26'),('2068-07-27'),('2068-07-28'),('2068-07-29'),('2068-07-30'),('2068-07-31'),('2068-08-01'),('2068-08-02'),('2068-08-03'),('2068-08-04'),('2068-08-05'),('2068-08-06'),('2068-08-07'),('2068-08-08'),('2068-08-09'),('2068-08-10'),('2068-08-11'),('2068-08-12'),('2068-08-13'),('2068-08-14'),('2068-08-15'),('2068-08-16'),('2068-08-17'),('2068-08-18'),('2068-08-19'),('2068-08-20'),('2068-08-21'),('2068-08-22'),('2068-08-23'),('2068-08-24'),('2068-08-25'),('2068-08-26'),('2068-08-27'),('2068-08-28'),('2068-08-29'),('2068-08-30'),('2068-08-31'),('2068-09-01'),('2068-09-02'),('2068-09-03'),('2068-09-04'),('2068-09-05'),('2068-09-06'),('2068-09-07'),('2068-09-08'),('2068-09-09'),('2068-09-10'),('2068-09-11'),('2068-09-12'),('2068-09-13'),('2068-09-14'),('2068-09-15'),('2068-09-16'),('2068-09-17'),('2068-09-18'),('2068-09-19'),('2068-09-20'),('2068-09-21'),('2068-09-22'),('2068-09-23'),('2068-09-24'),('2068-09-25'),('2068-09-26'),('2068-09-27'),('2068-09-28'),('2068-09-29'),('2068-09-30'),('2068-10-01'),('2068-10-02'),('2068-10-03'),('2068-10-04'),('2068-10-05'),('2068-10-06'),('2068-10-07'),('2068-10-08'),('2068-10-09'),('2068-10-10'),('2068-10-11'),('2068-10-12'),('2068-10-13'),('2068-10-14'),('2068-10-15'),('2068-10-16'),('2068-10-17'),('2068-10-18'),('2068-10-19'),('2068-10-20'),('2068-10-21'),('2068-10-22'),('2068-10-23'),('2068-10-24'),('2068-10-25'),('2068-10-26'),('2068-10-27'),('2068-10-28'),('2068-10-29'),('2068-10-30'),('2068-10-31'),('2068-11-01'),('2068-11-02'),('2068-11-03'),('2068-11-04'),('2068-11-05'),('2068-11-06'),('2068-11-07'),('2068-11-08'),('2068-11-09'),('2068-11-10'),('2068-11-11'),('2068-11-12'),('2068-11-13'),('2068-11-14'),('2068-11-15'),('2068-11-16'),('2068-11-17'),('2068-11-18'),('2068-11-19'),('2068-11-20'),('2068-11-21'),('2068-11-22'),('2068-11-23'),('2068-11-24'),('2068-11-25'),('2068-11-26'),('2068-11-27'),('2068-11-28'),('2068-11-29'),('2068-11-30'),('2068-12-01'),('2068-12-02'),('2068-12-03'),('2068-12-04'),('2068-12-05'),('2068-12-06'),('2068-12-07'),('2068-12-08'),('2068-12-09'),('2068-12-10'),('2068-12-11'),('2068-12-12'),('2068-12-13'),('2068-12-14'),('2068-12-15'),('2068-12-16'),('2068-12-17'),('2068-12-18'),('2068-12-19'),('2068-12-20'),('2068-12-21'),('2068-12-22'),('2068-12-23'),('2068-12-24'),('2068-12-25'),('2068-12-26'),('2068-12-27'),('2068-12-28'),('2068-12-29'),('2068-12-30'),('2068-12-31'),('2069-01-01'),('2069-01-02'),('2069-01-03'),('2069-01-04'),('2069-01-05'),('2069-01-06'),('2069-01-07'),('2069-01-08'),('2069-01-09'),('2069-01-10'),('2069-01-11'),('2069-01-12'),('2069-01-13'),('2069-01-14'),('2069-01-15'),('2069-01-16'),('2069-01-17'),('2069-01-18'),('2069-01-19'),('2069-01-20'),('2069-01-21'),('2069-01-22'),('2069-01-23'),('2069-01-24'),('2069-01-25'),('2069-01-26'),('2069-01-27'),('2069-01-28'),('2069-01-29'),('2069-01-30'),('2069-01-31'),('2069-02-01'),('2069-02-02'),('2069-02-03'),('2069-02-04'),('2069-02-05'),('2069-02-06'),('2069-02-07'),('2069-02-08'),('2069-02-09'),('2069-02-10'),('2069-02-11'),('2069-02-12'),('2069-02-13'),('2069-02-14'),('2069-02-15'),('2069-02-16'),('2069-02-17'),('2069-02-18'),('2069-02-19'),('2069-02-20'),('2069-02-21'),('2069-02-22'),('2069-02-23'),('2069-02-24'),('2069-02-25'),('2069-02-26'),('2069-02-27'),('2069-02-28'),('2069-03-01'),('2069-03-02'),('2069-03-03'),('2069-03-04'),('2069-03-05'),('2069-03-06'),('2069-03-07'),('2069-03-08'),('2069-03-09'),('2069-03-10'),('2069-03-11'),('2069-03-12'),('2069-03-13'),('2069-03-14'),('2069-03-15'),('2069-03-16'),('2069-03-17'),('2069-03-18'),('2069-03-19'),('2069-03-20'),('2069-03-21'),('2069-03-22'),('2069-03-23'),('2069-03-24'),('2069-03-25'),('2069-03-26'),('2069-03-27'),('2069-03-28'),('2069-03-29'),('2069-03-30'),('2069-03-31'),('2069-04-01'),('2069-04-02'),('2069-04-03'),('2069-04-04'),('2069-04-05'),('2069-04-06'),('2069-04-07'),('2069-04-08'),('2069-04-09'),('2069-04-10'),('2069-04-11'),('2069-04-12'),('2069-04-13'),('2069-04-14'),('2069-04-15'),('2069-04-16'),('2069-04-17'),('2069-04-18'),('2069-04-19'),('2069-04-20'),('2069-04-21'),('2069-04-22'),('2069-04-23'),('2069-04-24'),('2069-04-25'),('2069-04-26'),('2069-04-27'),('2069-04-28'),('2069-04-29'),('2069-04-30'),('2069-05-01'),('2069-05-02'),('2069-05-03'),('2069-05-04'),('2069-05-05'),('2069-05-06'),('2069-05-07'),('2069-05-08'),('2069-05-09'),('2069-05-10'),('2069-05-11'),('2069-05-12'),('2069-05-13'),('2069-05-14'),('2069-05-15'),('2069-05-16'),('2069-05-17'),('2069-05-18'),('2069-05-19'),('2069-05-20'),('2069-05-21'),('2069-05-22'),('2069-05-23'),('2069-05-24'),('2069-05-25'),('2069-05-26'),('2069-05-27'),('2069-05-28'),('2069-05-29'),('2069-05-30'),('2069-05-31'),('2069-06-01'),('2069-06-02'),('2069-06-03'),('2069-06-04'),('2069-06-05'),('2069-06-06'),('2069-06-07'),('2069-06-08'),('2069-06-09'),('2069-06-10'),('2069-06-11'),('2069-06-12'),('2069-06-13'),('2069-06-14'),('2069-06-15'),('2069-06-16'),('2069-06-17'),('2069-06-18'),('2069-06-19'),('2069-06-20'),('2069-06-21'),('2069-06-22'),('2069-06-23'),('2069-06-24'),('2069-06-25'),('2069-06-26'),('2069-06-27'),('2069-06-28'),('2069-06-29'),('2069-06-30'),('2069-07-01'),('2069-07-02'),('2069-07-03'),('2069-07-04'),('2069-07-05'),('2069-07-06'),('2069-07-07'),('2069-07-08'),('2069-07-09'),('2069-07-10'),('2069-07-11'),('2069-07-12'),('2069-07-13'),('2069-07-14'),('2069-07-15'),('2069-07-16'),('2069-07-17'),('2069-07-18'),('2069-07-19'),('2069-07-20'),('2069-07-21'),('2069-07-22'),('2069-07-23'),('2069-07-24'),('2069-07-25'),('2069-07-26'),('2069-07-27'),('2069-07-28'),('2069-07-29'),('2069-07-30'),('2069-07-31'),('2069-08-01'),('2069-08-02'),('2069-08-03'),('2069-08-04'),('2069-08-05'),('2069-08-06'),('2069-08-07'),('2069-08-08'),('2069-08-09'),('2069-08-10'),('2069-08-11'),('2069-08-12'),('2069-08-13'),('2069-08-14'),('2069-08-15'),('2069-08-16'),('2069-08-17'),('2069-08-18'),('2069-08-19'),('2069-08-20'),('2069-08-21'),('2069-08-22'),('2069-08-23'),('2069-08-24'),('2069-08-25'),('2069-08-26'),('2069-08-27'),('2069-08-28'),('2069-08-29'),('2069-08-30'),('2069-08-31'),('2069-09-01'),('2069-09-02'),('2069-09-03'),('2069-09-04'),('2069-09-05'),('2069-09-06'),('2069-09-07'),('2069-09-08'),('2069-09-09'),('2069-09-10'),('2069-09-11'),('2069-09-12'),('2069-09-13'),('2069-09-14'),('2069-09-15'),('2069-09-16'),('2069-09-17'),('2069-09-18'),('2069-09-19'),('2069-09-20'),('2069-09-21'),('2069-09-22'),('2069-09-23'),('2069-09-24'),('2069-09-25'),('2069-09-26'),('2069-09-27'),('2069-09-28'),('2069-09-29'),('2069-09-30'),('2069-10-01'),('2069-10-02'),('2069-10-03'),('2069-10-04'),('2069-10-05'),('2069-10-06'),('2069-10-07'),('2069-10-08'),('2069-10-09'),('2069-10-10'),('2069-10-11'),('2069-10-12'),('2069-10-13'),('2069-10-14'),('2069-10-15'),('2069-10-16'),('2069-10-17'),('2069-10-18'),('2069-10-19'),('2069-10-20'),('2069-10-21'),('2069-10-22'),('2069-10-23'),('2069-10-24'),('2069-10-25'),('2069-10-26'),('2069-10-27'),('2069-10-28'),('2069-10-29'),('2069-10-30'),('2069-10-31'),('2069-11-01'),('2069-11-02'),('2069-11-03'),('2069-11-04'),('2069-11-05'),('2069-11-06'),('2069-11-07'),('2069-11-08'),('2069-11-09'),('2069-11-10'),('2069-11-11'),('2069-11-12'),('2069-11-13'),('2069-11-14'),('2069-11-15'),('2069-11-16'),('2069-11-17'),('2069-11-18'),('2069-11-19'),('2069-11-20'),('2069-11-21'),('2069-11-22'),('2069-11-23'),('2069-11-24'),('2069-11-25'),('2069-11-26'),('2069-11-27'),('2069-11-28'),('2069-11-29'),('2069-11-30'),('2069-12-01'),('2069-12-02'),('2069-12-03'),('2069-12-04'),('2069-12-05'),('2069-12-06'),('2069-12-07'),('2069-12-08'),('2069-12-09'),('2069-12-10'),('2069-12-11'),('2069-12-12'),('2069-12-13'),('2069-12-14'),('2069-12-15'),('2069-12-16'),('2069-12-17'),('2069-12-18'),('2069-12-19'),('2069-12-20'),('2069-12-21'),('2069-12-22'),('2069-12-23'),('2069-12-24'),('2069-12-25'),('2069-12-26'),('2069-12-27'),('2069-12-28'),('2069-12-29'),('2069-12-30'),('2069-12-31'),('2070-01-01'),('2070-01-02'),('2070-01-03'),('2070-01-04'),('2070-01-05'),('2070-01-06'),('2070-01-07'),('2070-01-08'),('2070-01-09'),('2070-01-10'),('2070-01-11'),('2070-01-12'),('2070-01-13'),('2070-01-14'),('2070-01-15'),('2070-01-16'),('2070-01-17'),('2070-01-18'),('2070-01-19'),('2070-01-20'),('2070-01-21'),('2070-01-22'),('2070-01-23'),('2070-01-24'),('2070-01-25'),('2070-01-26'),('2070-01-27'),('2070-01-28'),('2070-01-29'),('2070-01-30'),('2070-01-31'),('2070-02-01'),('2070-02-02'),('2070-02-03'),('2070-02-04'),('2070-02-05'),('2070-02-06'),('2070-02-07'),('2070-02-08'),('2070-02-09'),('2070-02-10'),('2070-02-11'),('2070-02-12'),('2070-02-13'),('2070-02-14'),('2070-02-15'),('2070-02-16'),('2070-02-17'),('2070-02-18'),('2070-02-19'),('2070-02-20'),('2070-02-21'),('2070-02-22'),('2070-02-23'),('2070-02-24'),('2070-02-25'),('2070-02-26'),('2070-02-27'),('2070-02-28'),('2070-03-01'),('2070-03-02'),('2070-03-03'),('2070-03-04'),('2070-03-05'),('2070-03-06'),('2070-03-07'),('2070-03-08'),('2070-03-09'),('2070-03-10'),('2070-03-11'),('2070-03-12'),('2070-03-13'),('2070-03-14'),('2070-03-15'),('2070-03-16'),('2070-03-17'),('2070-03-18'),('2070-03-19'),('2070-03-20'),('2070-03-21'),('2070-03-22'),('2070-03-23'),('2070-03-24'),('2070-03-25'),('2070-03-26'),('2070-03-27'),('2070-03-28'),('2070-03-29'),('2070-03-30'),('2070-03-31'),('2070-04-01'),('2070-04-02'),('2070-04-03'),('2070-04-04'),('2070-04-05'),('2070-04-06'),('2070-04-07'),('2070-04-08'),('2070-04-09'),('2070-04-10'),('2070-04-11'),('2070-04-12'),('2070-04-13'),('2070-04-14'),('2070-04-15'),('2070-04-16'),('2070-04-17'),('2070-04-18'),('2070-04-19'),('2070-04-20'),('2070-04-21'),('2070-04-22'),('2070-04-23'),('2070-04-24'),('2070-04-25'),('2070-04-26'),('2070-04-27'),('2070-04-28'),('2070-04-29'),('2070-04-30'),('2070-05-01'),('2070-05-02'),('2070-05-03'),('2070-05-04'),('2070-05-05'),('2070-05-06'),('2070-05-07'),('2070-05-08'),('2070-05-09'),('2070-05-10'),('2070-05-11'),('2070-05-12'),('2070-05-13'),('2070-05-14'),('2070-05-15'),('2070-05-16'),('2070-05-17'),('2070-05-18'),('2070-05-19'),('2070-05-20'),('2070-05-21'),('2070-05-22'),('2070-05-23'),('2070-05-24'),('2070-05-25'),('2070-05-26'),('2070-05-27'),('2070-05-28'),('2070-05-29'),('2070-05-30'),('2070-05-31'),('2070-06-01'),('2070-06-02'),('2070-06-03'),('2070-06-04'),('2070-06-05'),('2070-06-06'),('2070-06-07'),('2070-06-08'),('2070-06-09'),('2070-06-10'),('2070-06-11'),('2070-06-12'),('2070-06-13'),('2070-06-14'),('2070-06-15'),('2070-06-16'),('2070-06-17'),('2070-06-18'),('2070-06-19'),('2070-06-20'),('2070-06-21'),('2070-06-22'),('2070-06-23'),('2070-06-24'),('2070-06-25'),('2070-06-26'),('2070-06-27'),('2070-06-28'),('2070-06-29'),('2070-06-30'),('2070-07-01'),('2070-07-02'),('2070-07-03'),('2070-07-04'),('2070-07-05'),('2070-07-06'),('2070-07-07'),('2070-07-08'),('2070-07-09'),('2070-07-10'),('2070-07-11'),('2070-07-12'),('2070-07-13'),('2070-07-14'),('2070-07-15'),('2070-07-16'),('2070-07-17'),('2070-07-18'),('2070-07-19'),('2070-07-20'),('2070-07-21'),('2070-07-22'),('2070-07-23'),('2070-07-24'),('2070-07-25'),('2070-07-26'),('2070-07-27'),('2070-07-28'),('2070-07-29'),('2070-07-30'),('2070-07-31'),('2070-08-01'),('2070-08-02'),('2070-08-03'),('2070-08-04'),('2070-08-05'),('2070-08-06'),('2070-08-07'),('2070-08-08'),('2070-08-09'),('2070-08-10'),('2070-08-11'),('2070-08-12'),('2070-08-13'),('2070-08-14'),('2070-08-15'),('2070-08-16'),('2070-08-17'),('2070-08-18'),('2070-08-19'),('2070-08-20'),('2070-08-21'),('2070-08-22'),('2070-08-23'),('2070-08-24'),('2070-08-25'),('2070-08-26'),('2070-08-27'),('2070-08-28'),('2070-08-29'),('2070-08-30'),('2070-08-31'),('2070-09-01'),('2070-09-02'),('2070-09-03'),('2070-09-04'),('2070-09-05'),('2070-09-06'),('2070-09-07'),('2070-09-08'),('2070-09-09'),('2070-09-10'),('2070-09-11'),('2070-09-12'),('2070-09-13'),('2070-09-14'),('2070-09-15'),('2070-09-16'),('2070-09-17'),('2070-09-18'),('2070-09-19'),('2070-09-20'),('2070-09-21'),('2070-09-22'),('2070-09-23'),('2070-09-24'),('2070-09-25'),('2070-09-26'),('2070-09-27'),('2070-09-28'),('2070-09-29'),('2070-09-30'),('2070-10-01'),('2070-10-02'),('2070-10-03'),('2070-10-04'),('2070-10-05'),('2070-10-06'),('2070-10-07'),('2070-10-08'),('2070-10-09'),('2070-10-10'),('2070-10-11'),('2070-10-12'),('2070-10-13'),('2070-10-14'),('2070-10-15'),('2070-10-16'),('2070-10-17'),('2070-10-18'),('2070-10-19'),('2070-10-20'),('2070-10-21'),('2070-10-22'),('2070-10-23'),('2070-10-24'),('2070-10-25'),('2070-10-26'),('2070-10-27'),('2070-10-28'),('2070-10-29'),('2070-10-30'),('2070-10-31'),('2070-11-01'),('2070-11-02'),('2070-11-03'),('2070-11-04'),('2070-11-05'),('2070-11-06'),('2070-11-07'),('2070-11-08'),('2070-11-09'),('2070-11-10'),('2070-11-11'),('2070-11-12'),('2070-11-13'),('2070-11-14'),('2070-11-15'),('2070-11-16'),('2070-11-17'),('2070-11-18'),('2070-11-19'),('2070-11-20'),('2070-11-21'),('2070-11-22'),('2070-11-23'),('2070-11-24'),('2070-11-25'),('2070-11-26'),('2070-11-27'),('2070-11-28'),('2070-11-29'),('2070-11-30'),('2070-12-01'),('2070-12-02'),('2070-12-03'),('2070-12-04'),('2070-12-05'),('2070-12-06'),('2070-12-07'),('2070-12-08'),('2070-12-09'),('2070-12-10'),('2070-12-11'),('2070-12-12'),('2070-12-13'),('2070-12-14'),('2070-12-15'),('2070-12-16'),('2070-12-17'),('2070-12-18'),('2070-12-19'),('2070-12-20'),('2070-12-21'),('2070-12-22'),('2070-12-23'),('2070-12-24'),('2070-12-25'),('2070-12-26'),('2070-12-27'),('2070-12-28'),('2070-12-29'),('2070-12-30'),('2070-12-31'),('2071-01-01'),('2071-01-02'),('2071-01-03'),('2071-01-04'),('2071-01-05'),('2071-01-06'),('2071-01-07'),('2071-01-08'),('2071-01-09'),('2071-01-10'),('2071-01-11'),('2071-01-12'),('2071-01-13'),('2071-01-14'),('2071-01-15'),('2071-01-16'),('2071-01-17'),('2071-01-18'),('2071-01-19'),('2071-01-20'),('2071-01-21'),('2071-01-22'),('2071-01-23'),('2071-01-24'),('2071-01-25'),('2071-01-26'),('2071-01-27'),('2071-01-28'),('2071-01-29'),('2071-01-30'),('2071-01-31'),('2071-02-01'),('2071-02-02'),('2071-02-03'),('2071-02-04'),('2071-02-05'),('2071-02-06'),('2071-02-07'),('2071-02-08'),('2071-02-09'),('2071-02-10'),('2071-02-11'),('2071-02-12'),('2071-02-13'),('2071-02-14'),('2071-02-15'),('2071-02-16'),('2071-02-17'),('2071-02-18'),('2071-02-19'),('2071-02-20'),('2071-02-21'),('2071-02-22'),('2071-02-23'),('2071-02-24'),('2071-02-25'),('2071-02-26'),('2071-02-27'),('2071-02-28'),('2071-03-01'),('2071-03-02'),('2071-03-03'),('2071-03-04'),('2071-03-05'),('2071-03-06'),('2071-03-07'),('2071-03-08'),('2071-03-09'),('2071-03-10'),('2071-03-11'),('2071-03-12'),('2071-03-13'),('2071-03-14'),('2071-03-15'),('2071-03-16'),('2071-03-17'),('2071-03-18'),('2071-03-19'),('2071-03-20'),('2071-03-21'),('2071-03-22'),('2071-03-23'),('2071-03-24'),('2071-03-25'),('2071-03-26'),('2071-03-27'),('2071-03-28'),('2071-03-29'),('2071-03-30'),('2071-03-31'),('2071-04-01'),('2071-04-02'),('2071-04-03'),('2071-04-04'),('2071-04-05'),('2071-04-06'),('2071-04-07'),('2071-04-08'),('2071-04-09'),('2071-04-10'),('2071-04-11'),('2071-04-12'),('2071-04-13'),('2071-04-14'),('2071-04-15'),('2071-04-16'),('2071-04-17'),('2071-04-18'),('2071-04-19'),('2071-04-20'),('2071-04-21'),('2071-04-22'),('2071-04-23'),('2071-04-24'),('2071-04-25'),('2071-04-26'),('2071-04-27'),('2071-04-28'),('2071-04-29'),('2071-04-30'),('2071-05-01'),('2071-05-02'),('2071-05-03'),('2071-05-04'),('2071-05-05'),('2071-05-06'),('2071-05-07'),('2071-05-08'),('2071-05-09'),('2071-05-10'),('2071-05-11'),('2071-05-12'),('2071-05-13'),('2071-05-14'),('2071-05-15'),('2071-05-16'),('2071-05-17'),('2071-05-18'),('2071-05-19'),('2071-05-20'),('2071-05-21'),('2071-05-22'),('2071-05-23'),('2071-05-24'),('2071-05-25'),('2071-05-26'),('2071-05-27'),('2071-05-28'),('2071-05-29'),('2071-05-30'),('2071-05-31'),('2071-06-01'),('2071-06-02'),('2071-06-03'),('2071-06-04'),('2071-06-05'),('2071-06-06'),('2071-06-07'),('2071-06-08'),('2071-06-09'),('2071-06-10'),('2071-06-11'),('2071-06-12'),('2071-06-13'),('2071-06-14'),('2071-06-15'),('2071-06-16'),('2071-06-17'),('2071-06-18'),('2071-06-19'),('2071-06-20'),('2071-06-21'),('2071-06-22'),('2071-06-23'),('2071-06-24'),('2071-06-25'),('2071-06-26'),('2071-06-27'),('2071-06-28'),('2071-06-29'),('2071-06-30'),('2071-07-01'),('2071-07-02'),('2071-07-03'),('2071-07-04'),('2071-07-05'),('2071-07-06'),('2071-07-07'),('2071-07-08'),('2071-07-09'),('2071-07-10'),('2071-07-11'),('2071-07-12'),('2071-07-13'),('2071-07-14'),('2071-07-15'),('2071-07-16'),('2071-07-17'),('2071-07-18'),('2071-07-19'),('2071-07-20'),('2071-07-21'),('2071-07-22'),('2071-07-23'),('2071-07-24'),('2071-07-25'),('2071-07-26'),('2071-07-27'),('2071-07-28'),('2071-07-29'),('2071-07-30'),('2071-07-31'),('2071-08-01'),('2071-08-02'),('2071-08-03'),('2071-08-04'),('2071-08-05'),('2071-08-06'),('2071-08-07'),('2071-08-08'),('2071-08-09'),('2071-08-10'),('2071-08-11'),('2071-08-12'),('2071-08-13'),('2071-08-14'),('2071-08-15'),('2071-08-16'),('2071-08-17'),('2071-08-18'),('2071-08-19'),('2071-08-20'),('2071-08-21'),('2071-08-22'),('2071-08-23'),('2071-08-24'),('2071-08-25'),('2071-08-26'),('2071-08-27'),('2071-08-28'),('2071-08-29'),('2071-08-30'),('2071-08-31'),('2071-09-01'),('2071-09-02'),('2071-09-03'),('2071-09-04'),('2071-09-05'),('2071-09-06'),('2071-09-07'),('2071-09-08'),('2071-09-09'),('2071-09-10'),('2071-09-11'),('2071-09-12'),('2071-09-13'),('2071-09-14'),('2071-09-15'),('2071-09-16'),('2071-09-17'),('2071-09-18'),('2071-09-19'),('2071-09-20'),('2071-09-21'),('2071-09-22'),('2071-09-23'),('2071-09-24'),('2071-09-25'),('2071-09-26'),('2071-09-27'),('2071-09-28'),('2071-09-29'),('2071-09-30'),('2071-10-01'),('2071-10-02'),('2071-10-03'),('2071-10-04'),('2071-10-05'),('2071-10-06'),('2071-10-07'),('2071-10-08'),('2071-10-09'),('2071-10-10'),('2071-10-11'),('2071-10-12'),('2071-10-13'),('2071-10-14'),('2071-10-15'),('2071-10-16'),('2071-10-17'),('2071-10-18'),('2071-10-19'),('2071-10-20'),('2071-10-21'),('2071-10-22'),('2071-10-23'),('2071-10-24'),('2071-10-25'),('2071-10-26'),('2071-10-27'),('2071-10-28'),('2071-10-29'),('2071-10-30'),('2071-10-31'),('2071-11-01'),('2071-11-02'),('2071-11-03'),('2071-11-04'),('2071-11-05'),('2071-11-06'),('2071-11-07'),('2071-11-08'),('2071-11-09'),('2071-11-10'),('2071-11-11'),('2071-11-12'),('2071-11-13'),('2071-11-14'),('2071-11-15'),('2071-11-16'),('2071-11-17'),('2071-11-18'),('2071-11-19'),('2071-11-20'),('2071-11-21'),('2071-11-22'),('2071-11-23'),('2071-11-24'),('2071-11-25'),('2071-11-26'),('2071-11-27'),('2071-11-28'),('2071-11-29'),('2071-11-30'),('2071-12-01'),('2071-12-02'),('2071-12-03'),('2071-12-04'),('2071-12-05'),('2071-12-06'),('2071-12-07'),('2071-12-08'),('2071-12-09'),('2071-12-10'),('2071-12-11'),('2071-12-12'),('2071-12-13'),('2071-12-14'),('2071-12-15'),('2071-12-16'),('2071-12-17'),('2071-12-18'),('2071-12-19'),('2071-12-20'),('2071-12-21'),('2071-12-22'),('2071-12-23'),('2071-12-24'),('2071-12-25'),('2071-12-26'),('2071-12-27'),('2071-12-28'),('2071-12-29'),('2071-12-30'),('2071-12-31'),('2072-01-01'),('2072-01-02'),('2072-01-03'),('2072-01-04'),('2072-01-05'),('2072-01-06'),('2072-01-07'),('2072-01-08'),('2072-01-09'),('2072-01-10'),('2072-01-11'),('2072-01-12'),('2072-01-13'),('2072-01-14'),('2072-01-15'),('2072-01-16'),('2072-01-17'),('2072-01-18'),('2072-01-19'),('2072-01-20'),('2072-01-21'),('2072-01-22'),('2072-01-23'),('2072-01-24'),('2072-01-25'),('2072-01-26'),('2072-01-27'),('2072-01-28'),('2072-01-29'),('2072-01-30'),('2072-01-31'),('2072-02-01'),('2072-02-02'),('2072-02-03'),('2072-02-04'),('2072-02-05'),('2072-02-06'),('2072-02-07'),('2072-02-08'),('2072-02-09'),('2072-02-10'),('2072-02-11'),('2072-02-12'),('2072-02-13'),('2072-02-14'),('2072-02-15'),('2072-02-16'),('2072-02-17'),('2072-02-18'),('2072-02-19'),('2072-02-20'),('2072-02-21'),('2072-02-22'),('2072-02-23'),('2072-02-24'),('2072-02-25'),('2072-02-26'),('2072-02-27'),('2072-02-28'),('2072-02-29'),('2072-03-01'),('2072-03-02'),('2072-03-03'),('2072-03-04'),('2072-03-05'),('2072-03-06'),('2072-03-07'),('2072-03-08'),('2072-03-09'),('2072-03-10'),('2072-03-11'),('2072-03-12'),('2072-03-13'),('2072-03-14'),('2072-03-15'),('2072-03-16'),('2072-03-17'),('2072-03-18'),('2072-03-19'),('2072-03-20'),('2072-03-21'),('2072-03-22'),('2072-03-23'),('2072-03-24'),('2072-03-25'),('2072-03-26'),('2072-03-27'),('2072-03-28'),('2072-03-29'),('2072-03-30'),('2072-03-31'),('2072-04-01'),('2072-04-02'),('2072-04-03'),('2072-04-04'),('2072-04-05'),('2072-04-06'),('2072-04-07'),('2072-04-08'),('2072-04-09'),('2072-04-10'),('2072-04-11'),('2072-04-12'),('2072-04-13'),('2072-04-14'),('2072-04-15'),('2072-04-16'),('2072-04-17'),('2072-04-18'),('2072-04-19'),('2072-04-20'),('2072-04-21'),('2072-04-22'),('2072-04-23'),('2072-04-24'),('2072-04-25'),('2072-04-26'),('2072-04-27'),('2072-04-28'),('2072-04-29'),('2072-04-30'),('2072-05-01'),('2072-05-02'),('2072-05-03'),('2072-05-04'),('2072-05-05'),('2072-05-06'),('2072-05-07'),('2072-05-08'),('2072-05-09'),('2072-05-10'),('2072-05-11'),('2072-05-12'),('2072-05-13'),('2072-05-14'),('2072-05-15'),('2072-05-16'),('2072-05-17'),('2072-05-18'),('2072-05-19'),('2072-05-20'),('2072-05-21'),('2072-05-22'),('2072-05-23'),('2072-05-24'),('2072-05-25'),('2072-05-26'),('2072-05-27'),('2072-05-28'),('2072-05-29'),('2072-05-30'),('2072-05-31'),('2072-06-01'),('2072-06-02'),('2072-06-03'),('2072-06-04'),('2072-06-05'),('2072-06-06'),('2072-06-07'),('2072-06-08'),('2072-06-09'),('2072-06-10'),('2072-06-11'),('2072-06-12'),('2072-06-13'),('2072-06-14'),('2072-06-15'),('2072-06-16'),('2072-06-17'),('2072-06-18'),('2072-06-19'),('2072-06-20'),('2072-06-21'),('2072-06-22'),('2072-06-23'),('2072-06-24'),('2072-06-25'),('2072-06-26'),('2072-06-27'),('2072-06-28'),('2072-06-29'),('2072-06-30'),('2072-07-01'),('2072-07-02'),('2072-07-03'),('2072-07-04'),('2072-07-05'),('2072-07-06'),('2072-07-07'),('2072-07-08'),('2072-07-09'),('2072-07-10'),('2072-07-11'),('2072-07-12'),('2072-07-13'),('2072-07-14'),('2072-07-15'),('2072-07-16'),('2072-07-17'),('2072-07-18'),('2072-07-19'),('2072-07-20'),('2072-07-21'),('2072-07-22'),('2072-07-23'),('2072-07-24'),('2072-07-25'),('2072-07-26'),('2072-07-27'),('2072-07-28'),('2072-07-29'),('2072-07-30'),('2072-07-31'),('2072-08-01'),('2072-08-02'),('2072-08-03'),('2072-08-04'),('2072-08-05'),('2072-08-06'),('2072-08-07'),('2072-08-08'),('2072-08-09'),('2072-08-10'),('2072-08-11'),('2072-08-12'),('2072-08-13'),('2072-08-14'),('2072-08-15'),('2072-08-16'),('2072-08-17'),('2072-08-18'),('2072-08-19'),('2072-08-20'),('2072-08-21'),('2072-08-22'),('2072-08-23'),('2072-08-24'),('2072-08-25'),('2072-08-26'),('2072-08-27'),('2072-08-28'),('2072-08-29'),('2072-08-30'),('2072-08-31'),('2072-09-01'),('2072-09-02'),('2072-09-03'),('2072-09-04'),('2072-09-05'),('2072-09-06'),('2072-09-07'),('2072-09-08'),('2072-09-09'),('2072-09-10'),('2072-09-11'),('2072-09-12'),('2072-09-13'),('2072-09-14'),('2072-09-15'),('2072-09-16'),('2072-09-17'),('2072-09-18'),('2072-09-19'),('2072-09-20'),('2072-09-21'),('2072-09-22'),('2072-09-23'),('2072-09-24'),('2072-09-25'),('2072-09-26'),('2072-09-27'),('2072-09-28'),('2072-09-29'),('2072-09-30'),('2072-10-01'),('2072-10-02'),('2072-10-03'),('2072-10-04'),('2072-10-05'),('2072-10-06'),('2072-10-07'),('2072-10-08'),('2072-10-09'),('2072-10-10'),('2072-10-11'),('2072-10-12'),('2072-10-13'),('2072-10-14'),('2072-10-15'),('2072-10-16'),('2072-10-17'),('2072-10-18'),('2072-10-19'),('2072-10-20'),('2072-10-21'),('2072-10-22'),('2072-10-23'),('2072-10-24'),('2072-10-25'),('2072-10-26'),('2072-10-27'),('2072-10-28'),('2072-10-29'),('2072-10-30'),('2072-10-31'),('2072-11-01'),('2072-11-02'),('2072-11-03'),('2072-11-04'),('2072-11-05'),('2072-11-06'),('2072-11-07'),('2072-11-08'),('2072-11-09'),('2072-11-10'),('2072-11-11'),('2072-11-12'),('2072-11-13'),('2072-11-14'),('2072-11-15'),('2072-11-16'),('2072-11-17'),('2072-11-18'),('2072-11-19'),('2072-11-20'),('2072-11-21'),('2072-11-22'),('2072-11-23'),('2072-11-24'),('2072-11-25'),('2072-11-26'),('2072-11-27'),('2072-11-28'),('2072-11-29'),('2072-11-30'),('2072-12-01'),('2072-12-02'),('2072-12-03'),('2072-12-04'),('2072-12-05'),('2072-12-06'),('2072-12-07'),('2072-12-08'),('2072-12-09'),('2072-12-10'),('2072-12-11'),('2072-12-12'),('2072-12-13'),('2072-12-14'),('2072-12-15'),('2072-12-16'),('2072-12-17'),('2072-12-18'),('2072-12-19'),('2072-12-20'),('2072-12-21'),('2072-12-22'),('2072-12-23'),('2072-12-24'),('2072-12-25'),('2072-12-26'),('2072-12-27'),('2072-12-28'),('2072-12-29'),('2072-12-30'),('2072-12-31'),('2073-01-01'),('2073-01-02'),('2073-01-03'),('2073-01-04'),('2073-01-05'),('2073-01-06'),('2073-01-07'),('2073-01-08'),('2073-01-09'),('2073-01-10'),('2073-01-11'),('2073-01-12'),('2073-01-13'),('2073-01-14'),('2073-01-15'),('2073-01-16'),('2073-01-17'),('2073-01-18'),('2073-01-19'),('2073-01-20'),('2073-01-21'),('2073-01-22'),('2073-01-23'),('2073-01-24'),('2073-01-25'),('2073-01-26'),('2073-01-27'),('2073-01-28'),('2073-01-29'),('2073-01-30'),('2073-01-31'),('2073-02-01'),('2073-02-02'),('2073-02-03'),('2073-02-04'),('2073-02-05'),('2073-02-06'),('2073-02-07'),('2073-02-08'),('2073-02-09'),('2073-02-10'),('2073-02-11'),('2073-02-12'),('2073-02-13'),('2073-02-14'),('2073-02-15'),('2073-02-16'),('2073-02-17'),('2073-02-18'),('2073-02-19'),('2073-02-20'),('2073-02-21'),('2073-02-22'),('2073-02-23'),('2073-02-24'),('2073-02-25'),('2073-02-26'),('2073-02-27'),('2073-02-28'),('2073-03-01'),('2073-03-02'),('2073-03-03'),('2073-03-04'),('2073-03-05'),('2073-03-06'),('2073-03-07'),('2073-03-08'),('2073-03-09'),('2073-03-10'),('2073-03-11'),('2073-03-12'),('2073-03-13'),('2073-03-14'),('2073-03-15'),('2073-03-16'),('2073-03-17'),('2073-03-18'),('2073-03-19'),('2073-03-20'),('2073-03-21'),('2073-03-22'),('2073-03-23'),('2073-03-24'),('2073-03-25'),('2073-03-26'),('2073-03-27'),('2073-03-28'),('2073-03-29'),('2073-03-30'),('2073-03-31'),('2073-04-01'),('2073-04-02'),('2073-04-03'),('2073-04-04'),('2073-04-05'),('2073-04-06'),('2073-04-07'),('2073-04-08'),('2073-04-09'),('2073-04-10'),('2073-04-11'),('2073-04-12'),('2073-04-13'),('2073-04-14'),('2073-04-15'),('2073-04-16'),('2073-04-17'),('2073-04-18'),('2073-04-19'),('2073-04-20'),('2073-04-21'),('2073-04-22'),('2073-04-23'),('2073-04-24'),('2073-04-25'),('2073-04-26'),('2073-04-27'),('2073-04-28'),('2073-04-29'),('2073-04-30'),('2073-05-01'),('2073-05-02'),('2073-05-03'),('2073-05-04'),('2073-05-05'),('2073-05-06'),('2073-05-07'),('2073-05-08'),('2073-05-09'),('2073-05-10'),('2073-05-11'),('2073-05-12'),('2073-05-13'),('2073-05-14'),('2073-05-15'),('2073-05-16'),('2073-05-17'),('2073-05-18'),('2073-05-19'),('2073-05-20'),('2073-05-21'),('2073-05-22'),('2073-05-23'),('2073-05-24'),('2073-05-25'),('2073-05-26'),('2073-05-27'),('2073-05-28'),('2073-05-29'),('2073-05-30'),('2073-05-31'),('2073-06-01'),('2073-06-02'),('2073-06-03'),('2073-06-04'),('2073-06-05'),('2073-06-06'),('2073-06-07'),('2073-06-08'),('2073-06-09'),('2073-06-10'),('2073-06-11'),('2073-06-12'),('2073-06-13'),('2073-06-14'),('2073-06-15'),('2073-06-16'),('2073-06-17'),('2073-06-18'),('2073-06-19'),('2073-06-20'),('2073-06-21'),('2073-06-22'),('2073-06-23'),('2073-06-24'),('2073-06-25'),('2073-06-26'),('2073-06-27'),('2073-06-28'),('2073-06-29'),('2073-06-30'),('2073-07-01'),('2073-07-02'),('2073-07-03'),('2073-07-04'),('2073-07-05'),('2073-07-06'),('2073-07-07'),('2073-07-08'),('2073-07-09'),('2073-07-10'),('2073-07-11'),('2073-07-12'),('2073-07-13'),('2073-07-14'),('2073-07-15'),('2073-07-16'),('2073-07-17'),('2073-07-18'),('2073-07-19'),('2073-07-20'),('2073-07-21'),('2073-07-22'),('2073-07-23'),('2073-07-24'),('2073-07-25'),('2073-07-26'),('2073-07-27'),('2073-07-28'),('2073-07-29'),('2073-07-30'),('2073-07-31'),('2073-08-01'),('2073-08-02'),('2073-08-03'),('2073-08-04'),('2073-08-05'),('2073-08-06'),('2073-08-07'),('2073-08-08'),('2073-08-09'),('2073-08-10'),('2073-08-11'),('2073-08-12'),('2073-08-13'),('2073-08-14'),('2073-08-15'),('2073-08-16'),('2073-08-17'),('2073-08-18'),('2073-08-19'),('2073-08-20'),('2073-08-21'),('2073-08-22'),('2073-08-23'),('2073-08-24'),('2073-08-25'),('2073-08-26'),('2073-08-27'),('2073-08-28'),('2073-08-29'),('2073-08-30'),('2073-08-31'),('2073-09-01'),('2073-09-02'),('2073-09-03'),('2073-09-04'),('2073-09-05'),('2073-09-06'),('2073-09-07'),('2073-09-08'),('2073-09-09'),('2073-09-10'),('2073-09-11'),('2073-09-12'),('2073-09-13'),('2073-09-14'),('2073-09-15'),('2073-09-16'),('2073-09-17'),('2073-09-18'),('2073-09-19'),('2073-09-20'),('2073-09-21'),('2073-09-22'),('2073-09-23'),('2073-09-24'),('2073-09-25'),('2073-09-26'),('2073-09-27'),('2073-09-28'),('2073-09-29'),('2073-09-30'),('2073-10-01'),('2073-10-02'),('2073-10-03'),('2073-10-04'),('2073-10-05'),('2073-10-06'),('2073-10-07'),('2073-10-08'),('2073-10-09'),('2073-10-10'),('2073-10-11'),('2073-10-12'),('2073-10-13'),('2073-10-14'),('2073-10-15'),('2073-10-16'),('2073-10-17'),('2073-10-18'),('2073-10-19'),('2073-10-20'),('2073-10-21'),('2073-10-22'),('2073-10-23'),('2073-10-24'),('2073-10-25'),('2073-10-26'),('2073-10-27'),('2073-10-28'),('2073-10-29'),('2073-10-30'),('2073-10-31'),('2073-11-01'),('2073-11-02'),('2073-11-03'),('2073-11-04'),('2073-11-05'),('2073-11-06'),('2073-11-07'),('2073-11-08'),('2073-11-09'),('2073-11-10'),('2073-11-11'),('2073-11-12'),('2073-11-13'),('2073-11-14'),('2073-11-15'),('2073-11-16'),('2073-11-17'),('2073-11-18'),('2073-11-19'),('2073-11-20'),('2073-11-21'),('2073-11-22'),('2073-11-23'),('2073-11-24'),('2073-11-25'),('2073-11-26'),('2073-11-27'),('2073-11-28'),('2073-11-29'),('2073-11-30'),('2073-12-01'),('2073-12-02'),('2073-12-03'),('2073-12-04'),('2073-12-05'),('2073-12-06'),('2073-12-07'),('2073-12-08'),('2073-12-09'),('2073-12-10'),('2073-12-11'),('2073-12-12'),('2073-12-13'),('2073-12-14'),('2073-12-15'),('2073-12-16'),('2073-12-17'),('2073-12-18'),('2073-12-19'),('2073-12-20'),('2073-12-21'),('2073-12-22'),('2073-12-23'),('2073-12-24'),('2073-12-25'),('2073-12-26'),('2073-12-27'),('2073-12-28'),('2073-12-29'),('2073-12-30'),('2073-12-31'),('2074-01-01'),('2074-01-02'),('2074-01-03'),('2074-01-04'),('2074-01-05'),('2074-01-06'),('2074-01-07'),('2074-01-08'),('2074-01-09'),('2074-01-10'),('2074-01-11'),('2074-01-12'),('2074-01-13'),('2074-01-14'),('2074-01-15'),('2074-01-16'),('2074-01-17'),('2074-01-18'),('2074-01-19'),('2074-01-20'),('2074-01-21'),('2074-01-22'),('2074-01-23'),('2074-01-24'),('2074-01-25'),('2074-01-26'),('2074-01-27'),('2074-01-28'),('2074-01-29'),('2074-01-30'),('2074-01-31'),('2074-02-01'),('2074-02-02'),('2074-02-03'),('2074-02-04'),('2074-02-05'),('2074-02-06'),('2074-02-07'),('2074-02-08'),('2074-02-09'),('2074-02-10'),('2074-02-11'),('2074-02-12'),('2074-02-13'),('2074-02-14'),('2074-02-15'),('2074-02-16'),('2074-02-17'),('2074-02-18'),('2074-02-19'),('2074-02-20'),('2074-02-21'),('2074-02-22'),('2074-02-23'),('2074-02-24'),('2074-02-25'),('2074-02-26'),('2074-02-27'),('2074-02-28'),('2074-03-01'),('2074-03-02'),('2074-03-03'),('2074-03-04'),('2074-03-05'),('2074-03-06'),('2074-03-07'),('2074-03-08'),('2074-03-09'),('2074-03-10'),('2074-03-11'),('2074-03-12'),('2074-03-13'),('2074-03-14'),('2074-03-15'),('2074-03-16'),('2074-03-17'),('2074-03-18'),('2074-03-19'),('2074-03-20'),('2074-03-21'),('2074-03-22'),('2074-03-23'),('2074-03-24'),('2074-03-25'),('2074-03-26'),('2074-03-27'),('2074-03-28'),('2074-03-29'),('2074-03-30'),('2074-03-31'),('2074-04-01'),('2074-04-02'),('2074-04-03'),('2074-04-04'),('2074-04-05'),('2074-04-06'),('2074-04-07'),('2074-04-08'),('2074-04-09'),('2074-04-10'),('2074-04-11'),('2074-04-12'),('2074-04-13'),('2074-04-14'),('2074-04-15'),('2074-04-16'),('2074-04-17'),('2074-04-18'),('2074-04-19'),('2074-04-20'),('2074-04-21'),('2074-04-22'),('2074-04-23'),('2074-04-24'),('2074-04-25'),('2074-04-26'),('2074-04-27'),('2074-04-28'),('2074-04-29'),('2074-04-30'),('2074-05-01'),('2074-05-02'),('2074-05-03'),('2074-05-04'),('2074-05-05'),('2074-05-06'),('2074-05-07'),('2074-05-08'),('2074-05-09'),('2074-05-10'),('2074-05-11'),('2074-05-12'),('2074-05-13'),('2074-05-14'),('2074-05-15'),('2074-05-16'),('2074-05-17'),('2074-05-18'),('2074-05-19'),('2074-05-20'),('2074-05-21'),('2074-05-22'),('2074-05-23'),('2074-05-24'),('2074-05-25'),('2074-05-26'),('2074-05-27'),('2074-05-28'),('2074-05-29'),('2074-05-30'),('2074-05-31'),('2074-06-01'),('2074-06-02'),('2074-06-03'),('2074-06-04'),('2074-06-05'),('2074-06-06'),('2074-06-07'),('2074-06-08'),('2074-06-09'),('2074-06-10'),('2074-06-11'),('2074-06-12'),('2074-06-13'),('2074-06-14'),('2074-06-15'),('2074-06-16'),('2074-06-17'),('2074-06-18'),('2074-06-19'),('2074-06-20'),('2074-06-21'),('2074-06-22'),('2074-06-23'),('2074-06-24'),('2074-06-25'),('2074-06-26'),('2074-06-27'),('2074-06-28'),('2074-06-29'),('2074-06-30'),('2074-07-01'),('2074-07-02'),('2074-07-03'),('2074-07-04'),('2074-07-05'),('2074-07-06'),('2074-07-07'),('2074-07-08'),('2074-07-09'),('2074-07-10'),('2074-07-11'),('2074-07-12'),('2074-07-13'),('2074-07-14'),('2074-07-15'),('2074-07-16'),('2074-07-17'),('2074-07-18'),('2074-07-19'),('2074-07-20'),('2074-07-21'),('2074-07-22'),('2074-07-23'),('2074-07-24'),('2074-07-25'),('2074-07-26'),('2074-07-27'),('2074-07-28'),('2074-07-29'),('2074-07-30'),('2074-07-31'),('2074-08-01'),('2074-08-02'),('2074-08-03'),('2074-08-04'),('2074-08-05'),('2074-08-06'),('2074-08-07'),('2074-08-08'),('2074-08-09'),('2074-08-10'),('2074-08-11'),('2074-08-12'),('2074-08-13'),('2074-08-14'),('2074-08-15'),('2074-08-16'),('2074-08-17'),('2074-08-18'),('2074-08-19'),('2074-08-20'),('2074-08-21'),('2074-08-22'),('2074-08-23'),('2074-08-24'),('2074-08-25'),('2074-08-26'),('2074-08-27'),('2074-08-28'),('2074-08-29'),('2074-08-30'),('2074-08-31'),('2074-09-01'),('2074-09-02'),('2074-09-03'),('2074-09-04'),('2074-09-05'),('2074-09-06'),('2074-09-07'),('2074-09-08'),('2074-09-09'),('2074-09-10'),('2074-09-11'),('2074-09-12'),('2074-09-13'),('2074-09-14'),('2074-09-15'),('2074-09-16'),('2074-09-17'),('2074-09-18'),('2074-09-19'),('2074-09-20'),('2074-09-21'),('2074-09-22'),('2074-09-23'),('2074-09-24'),('2074-09-25'),('2074-09-26'),('2074-09-27'),('2074-09-28'),('2074-09-29'),('2074-09-30'),('2074-10-01'),('2074-10-02'),('2074-10-03'),('2074-10-04'),('2074-10-05'),('2074-10-06'),('2074-10-07'),('2074-10-08'),('2074-10-09'),('2074-10-10'),('2074-10-11'),('2074-10-12'),('2074-10-13'),('2074-10-14'),('2074-10-15'),('2074-10-16'),('2074-10-17'),('2074-10-18'),('2074-10-19'),('2074-10-20'),('2074-10-21'),('2074-10-22'),('2074-10-23'),('2074-10-24'),('2074-10-25'),('2074-10-26'),('2074-10-27'),('2074-10-28'),('2074-10-29'),('2074-10-30'),('2074-10-31'),('2074-11-01'),('2074-11-02'),('2074-11-03'),('2074-11-04'),('2074-11-05'),('2074-11-06'),('2074-11-07'),('2074-11-08'),('2074-11-09'),('2074-11-10'),('2074-11-11'),('2074-11-12'),('2074-11-13'),('2074-11-14'),('2074-11-15'),('2074-11-16'),('2074-11-17'),('2074-11-18'),('2074-11-19'),('2074-11-20'),('2074-11-21'),('2074-11-22'),('2074-11-23'),('2074-11-24'),('2074-11-25'),('2074-11-26'),('2074-11-27'),('2074-11-28'),('2074-11-29'),('2074-11-30'),('2074-12-01'),('2074-12-02'),('2074-12-03'),('2074-12-04'),('2074-12-05'),('2074-12-06'),('2074-12-07'),('2074-12-08'),('2074-12-09'),('2074-12-10'),('2074-12-11'),('2074-12-12'),('2074-12-13'),('2074-12-14'),('2074-12-15'),('2074-12-16'),('2074-12-17'),('2074-12-18'),('2074-12-19'),('2074-12-20'),('2074-12-21'),('2074-12-22'),('2074-12-23'),('2074-12-24'),('2074-12-25'),('2074-12-26'),('2074-12-27'),('2074-12-28'),('2074-12-29'),('2074-12-30'),('2074-12-31'),('2075-01-01'),('2075-01-02'),('2075-01-03'),('2075-01-04'),('2075-01-05'),('2075-01-06'),('2075-01-07'),('2075-01-08'),('2075-01-09'),('2075-01-10'),('2075-01-11'),('2075-01-12'),('2075-01-13'),('2075-01-14'),('2075-01-15'),('2075-01-16'),('2075-01-17'),('2075-01-18'),('2075-01-19'),('2075-01-20'),('2075-01-21'),('2075-01-22'),('2075-01-23'),('2075-01-24'),('2075-01-25'),('2075-01-26'),('2075-01-27'),('2075-01-28'),('2075-01-29'),('2075-01-30'),('2075-01-31'),('2075-02-01'),('2075-02-02'),('2075-02-03'),('2075-02-04'),('2075-02-05'),('2075-02-06'),('2075-02-07'),('2075-02-08'),('2075-02-09'),('2075-02-10'),('2075-02-11'),('2075-02-12'),('2075-02-13'),('2075-02-14'),('2075-02-15'),('2075-02-16'),('2075-02-17'),('2075-02-18'),('2075-02-19'),('2075-02-20'),('2075-02-21'),('2075-02-22'),('2075-02-23'),('2075-02-24'),('2075-02-25'),('2075-02-26'),('2075-02-27'),('2075-02-28'),('2075-03-01'),('2075-03-02'),('2075-03-03'),('2075-03-04'),('2075-03-05'),('2075-03-06'),('2075-03-07'),('2075-03-08'),('2075-03-09'),('2075-03-10'),('2075-03-11'),('2075-03-12'),('2075-03-13'),('2075-03-14'),('2075-03-15'),('2075-03-16'),('2075-03-17'),('2075-03-18'),('2075-03-19'),('2075-03-20'),('2075-03-21'),('2075-03-22'),('2075-03-23'),('2075-03-24'),('2075-03-25'),('2075-03-26'),('2075-03-27'),('2075-03-28'),('2075-03-29'),('2075-03-30'),('2075-03-31'),('2075-04-01'),('2075-04-02'),('2075-04-03'),('2075-04-04'),('2075-04-05'),('2075-04-06'),('2075-04-07'),('2075-04-08'),('2075-04-09'),('2075-04-10'),('2075-04-11'),('2075-04-12'),('2075-04-13'),('2075-04-14'),('2075-04-15'),('2075-04-16'),('2075-04-17'),('2075-04-18'),('2075-04-19'),('2075-04-20'),('2075-04-21'),('2075-04-22'),('2075-04-23'),('2075-04-24'),('2075-04-25'),('2075-04-26'),('2075-04-27'),('2075-04-28'),('2075-04-29'),('2075-04-30'),('2075-05-01'),('2075-05-02'),('2075-05-03'),('2075-05-04'),('2075-05-05'),('2075-05-06'),('2075-05-07'),('2075-05-08'),('2075-05-09'),('2075-05-10'),('2075-05-11'),('2075-05-12'),('2075-05-13'),('2075-05-14'),('2075-05-15'),('2075-05-16'),('2075-05-17'),('2075-05-18'),('2075-05-19'),('2075-05-20'),('2075-05-21'),('2075-05-22'),('2075-05-23'),('2075-05-24'),('2075-05-25'),('2075-05-26'),('2075-05-27'),('2075-05-28'),('2075-05-29'),('2075-05-30'),('2075-05-31'),('2075-06-01'),('2075-06-02'),('2075-06-03'),('2075-06-04'),('2075-06-05'),('2075-06-06'),('2075-06-07'),('2075-06-08'),('2075-06-09'),('2075-06-10'),('2075-06-11'),('2075-06-12'),('2075-06-13'),('2075-06-14'),('2075-06-15'),('2075-06-16'),('2075-06-17'),('2075-06-18'),('2075-06-19'),('2075-06-20'),('2075-06-21'),('2075-06-22'),('2075-06-23'),('2075-06-24'),('2075-06-25'),('2075-06-26'),('2075-06-27'),('2075-06-28'),('2075-06-29'),('2075-06-30'),('2075-07-01'),('2075-07-02'),('2075-07-03'),('2075-07-04'),('2075-07-05'),('2075-07-06'),('2075-07-07'),('2075-07-08'),('2075-07-09'),('2075-07-10'),('2075-07-11'),('2075-07-12'),('2075-07-13'),('2075-07-14'),('2075-07-15'),('2075-07-16'),('2075-07-17'),('2075-07-18'),('2075-07-19'),('2075-07-20'),('2075-07-21'),('2075-07-22'),('2075-07-23'),('2075-07-24'),('2075-07-25'),('2075-07-26'),('2075-07-27'),('2075-07-28'),('2075-07-29'),('2075-07-30'),('2075-07-31'),('2075-08-01'),('2075-08-02'),('2075-08-03'),('2075-08-04'),('2075-08-05'),('2075-08-06'),('2075-08-07'),('2075-08-08'),('2075-08-09'),('2075-08-10'),('2075-08-11'),('2075-08-12'),('2075-08-13'),('2075-08-14'),('2075-08-15'),('2075-08-16'),('2075-08-17'),('2075-08-18'),('2075-08-19'),('2075-08-20'),('2075-08-21'),('2075-08-22'),('2075-08-23'),('2075-08-24'),('2075-08-25'),('2075-08-26'),('2075-08-27'),('2075-08-28'),('2075-08-29'),('2075-08-30'),('2075-08-31'),('2075-09-01'),('2075-09-02'),('2075-09-03'),('2075-09-04'),('2075-09-05'),('2075-09-06'),('2075-09-07'),('2075-09-08'),('2075-09-09'),('2075-09-10'),('2075-09-11'),('2075-09-12'),('2075-09-13'),('2075-09-14'),('2075-09-15'),('2075-09-16'),('2075-09-17'),('2075-09-18'),('2075-09-19'),('2075-09-20'),('2075-09-21'),('2075-09-22'),('2075-09-23'),('2075-09-24'),('2075-09-25'),('2075-09-26'),('2075-09-27'),('2075-09-28'),('2075-09-29'),('2075-09-30'),('2075-10-01'),('2075-10-02'),('2075-10-03'),('2075-10-04'),('2075-10-05'),('2075-10-06'),('2075-10-07'),('2075-10-08'),('2075-10-09'),('2075-10-10'),('2075-10-11'),('2075-10-12'),('2075-10-13'),('2075-10-14'),('2075-10-15'),('2075-10-16'),('2075-10-17'),('2075-10-18'),('2075-10-19'),('2075-10-20'),('2075-10-21'),('2075-10-22'),('2075-10-23'),('2075-10-24'),('2075-10-25'),('2075-10-26'),('2075-10-27'),('2075-10-28'),('2075-10-29'),('2075-10-30'),('2075-10-31'),('2075-11-01'),('2075-11-02'),('2075-11-03'),('2075-11-04'),('2075-11-05'),('2075-11-06'),('2075-11-07'),('2075-11-08'),('2075-11-09'),('2075-11-10'),('2075-11-11'),('2075-11-12'),('2075-11-13'),('2075-11-14'),('2075-11-15'),('2075-11-16'),('2075-11-17'),('2075-11-18'),('2075-11-19'),('2075-11-20'),('2075-11-21'),('2075-11-22'),('2075-11-23'),('2075-11-24'),('2075-11-25'),('2075-11-26'),('2075-11-27'),('2075-11-28'),('2075-11-29'),('2075-11-30'),('2075-12-01'),('2075-12-02'),('2075-12-03'),('2075-12-04'),('2075-12-05'),('2075-12-06'),('2075-12-07'),('2075-12-08'),('2075-12-09'),('2075-12-10'),('2075-12-11'),('2075-12-12'),('2075-12-13'),('2075-12-14'),('2075-12-15'),('2075-12-16'),('2075-12-17'),('2075-12-18'),('2075-12-19'),('2075-12-20'),('2075-12-21'),('2075-12-22'),('2075-12-23'),('2075-12-24'),('2075-12-25'),('2075-12-26'),('2075-12-27'),('2075-12-28'),('2075-12-29'),('2075-12-30'),('2075-12-31'),('2076-01-01'),('2076-01-02'),('2076-01-03'),('2076-01-04'),('2076-01-05'),('2076-01-06'),('2076-01-07'),('2076-01-08'),('2076-01-09'),('2076-01-10'),('2076-01-11'),('2076-01-12'),('2076-01-13'),('2076-01-14'),('2076-01-15'),('2076-01-16'),('2076-01-17'),('2076-01-18'),('2076-01-19'),('2076-01-20'),('2076-01-21'),('2076-01-22'),('2076-01-23'),('2076-01-24'),('2076-01-25'),('2076-01-26'),('2076-01-27'),('2076-01-28'),('2076-01-29'),('2076-01-30'),('2076-01-31'),('2076-02-01'),('2076-02-02'),('2076-02-03'),('2076-02-04'),('2076-02-05'),('2076-02-06'),('2076-02-07'),('2076-02-08'),('2076-02-09'),('2076-02-10'),('2076-02-11'),('2076-02-12'),('2076-02-13'),('2076-02-14'),('2076-02-15'),('2076-02-16'),('2076-02-17'),('2076-02-18'),('2076-02-19'),('2076-02-20'),('2076-02-21'),('2076-02-22'),('2076-02-23'),('2076-02-24'),('2076-02-25'),('2076-02-26'),('2076-02-27'),('2076-02-28'),('2076-02-29'),('2076-03-01'),('2076-03-02'),('2076-03-03'),('2076-03-04'),('2076-03-05'),('2076-03-06'),('2076-03-07'),('2076-03-08'),('2076-03-09'),('2076-03-10'),('2076-03-11'),('2076-03-12'),('2076-03-13'),('2076-03-14'),('2076-03-15'),('2076-03-16'),('2076-03-17'),('2076-03-18'),('2076-03-19'),('2076-03-20'),('2076-03-21'),('2076-03-22'),('2076-03-23'),('2076-03-24'),('2076-03-25'),('2076-03-26'),('2076-03-27'),('2076-03-28'),('2076-03-29'),('2076-03-30'),('2076-03-31'),('2076-04-01'),('2076-04-02'),('2076-04-03'),('2076-04-04'),('2076-04-05'),('2076-04-06'),('2076-04-07'),('2076-04-08'),('2076-04-09'),('2076-04-10'),('2076-04-11'),('2076-04-12'),('2076-04-13'),('2076-04-14'),('2076-04-15'),('2076-04-16'),('2076-04-17'),('2076-04-18'),('2076-04-19'),('2076-04-20'),('2076-04-21'),('2076-04-22'),('2076-04-23'),('2076-04-24'),('2076-04-25'),('2076-04-26'),('2076-04-27'),('2076-04-28'),('2076-04-29'),('2076-04-30'),('2076-05-01'),('2076-05-02'),('2076-05-03'),('2076-05-04'),('2076-05-05'),('2076-05-06'),('2076-05-07'),('2076-05-08'),('2076-05-09'),('2076-05-10'),('2076-05-11'),('2076-05-12'),('2076-05-13'),('2076-05-14'),('2076-05-15'),('2076-05-16'),('2076-05-17'),('2076-05-18'),('2076-05-19'),('2076-05-20'),('2076-05-21'),('2076-05-22'),('2076-05-23'),('2076-05-24'),('2076-05-25'),('2076-05-26'),('2076-05-27'),('2076-05-28'),('2076-05-29'),('2076-05-30'),('2076-05-31'),('2076-06-01'),('2076-06-02'),('2076-06-03'),('2076-06-04'),('2076-06-05'),('2076-06-06'),('2076-06-07'),('2076-06-08'),('2076-06-09'),('2076-06-10'),('2076-06-11'),('2076-06-12'),('2076-06-13'),('2076-06-14'),('2076-06-15'),('2076-06-16'),('2076-06-17'),('2076-06-18'),('2076-06-19'),('2076-06-20'),('2076-06-21'),('2076-06-22'),('2076-06-23'),('2076-06-24'),('2076-06-25'),('2076-06-26'),('2076-06-27'),('2076-06-28'),('2076-06-29'),('2076-06-30'),('2076-07-01'),('2076-07-02'),('2076-07-03'),('2076-07-04'),('2076-07-05'),('2076-07-06'),('2076-07-07'),('2076-07-08'),('2076-07-09'),('2076-07-10'),('2076-07-11'),('2076-07-12'),('2076-07-13'),('2076-07-14'),('2076-07-15'),('2076-07-16'),('2076-07-17'),('2076-07-18'),('2076-07-19'),('2076-07-20'),('2076-07-21'),('2076-07-22'),('2076-07-23'),('2076-07-24'),('2076-07-25'),('2076-07-26'),('2076-07-27'),('2076-07-28'),('2076-07-29'),('2076-07-30'),('2076-07-31'),('2076-08-01'),('2076-08-02'),('2076-08-03'),('2076-08-04'),('2076-08-05'),('2076-08-06'),('2076-08-07'),('2076-08-08'),('2076-08-09'),('2076-08-10'),('2076-08-11'),('2076-08-12'),('2076-08-13'),('2076-08-14'),('2076-08-15'),('2076-08-16'),('2076-08-17'),('2076-08-18'),('2076-08-19'),('2076-08-20'),('2076-08-21'),('2076-08-22'),('2076-08-23'),('2076-08-24'),('2076-08-25'),('2076-08-26'),('2076-08-27'),('2076-08-28'),('2076-08-29'),('2076-08-30'),('2076-08-31'),('2076-09-01'),('2076-09-02'),('2076-09-03'),('2076-09-04'),('2076-09-05'),('2076-09-06'),('2076-09-07'),('2076-09-08'),('2076-09-09'),('2076-09-10'),('2076-09-11'),('2076-09-12'),('2076-09-13'),('2076-09-14'),('2076-09-15'),('2076-09-16'),('2076-09-17'),('2076-09-18'),('2076-09-19'),('2076-09-20'),('2076-09-21'),('2076-09-22'),('2076-09-23'),('2076-09-24'),('2076-09-25'),('2076-09-26'),('2076-09-27'),('2076-09-28'),('2076-09-29'),('2076-09-30'),('2076-10-01'),('2076-10-02'),('2076-10-03'),('2076-10-04'),('2076-10-05'),('2076-10-06'),('2076-10-07'),('2076-10-08'),('2076-10-09'),('2076-10-10'),('2076-10-11'),('2076-10-12'),('2076-10-13'),('2076-10-14'),('2076-10-15'),('2076-10-16'),('2076-10-17'),('2076-10-18'),('2076-10-19'),('2076-10-20'),('2076-10-21'),('2076-10-22'),('2076-10-23'),('2076-10-24'),('2076-10-25'),('2076-10-26'),('2076-10-27'),('2076-10-28'),('2076-10-29'),('2076-10-30'),('2076-10-31'),('2076-11-01'),('2076-11-02'),('2076-11-03'),('2076-11-04'),('2076-11-05'),('2076-11-06'),('2076-11-07'),('2076-11-08'),('2076-11-09'),('2076-11-10'),('2076-11-11'),('2076-11-12'),('2076-11-13'),('2076-11-14'),('2076-11-15'),('2076-11-16'),('2076-11-17'),('2076-11-18'),('2076-11-19'),('2076-11-20'),('2076-11-21'),('2076-11-22'),('2076-11-23'),('2076-11-24'),('2076-11-25'),('2076-11-26'),('2076-11-27'),('2076-11-28'),('2076-11-29'),('2076-11-30'),('2076-12-01'),('2076-12-02'),('2076-12-03'),('2076-12-04'),('2076-12-05'),('2076-12-06'),('2076-12-07'),('2076-12-08'),('2076-12-09'),('2076-12-10'),('2076-12-11'),('2076-12-12'),('2076-12-13'),('2076-12-14'),('2076-12-15'),('2076-12-16'),('2076-12-17'),('2076-12-18'),('2076-12-19'),('2076-12-20'),('2076-12-21'),('2076-12-22'),('2076-12-23'),('2076-12-24'),('2076-12-25'),('2076-12-26'),('2076-12-27'),('2076-12-28'),('2076-12-29'),('2076-12-30'),('2076-12-31'),('2077-01-01'),('2077-01-02'),('2077-01-03'),('2077-01-04'),('2077-01-05'),('2077-01-06'),('2077-01-07'),('2077-01-08'),('2077-01-09'),('2077-01-10'),('2077-01-11'),('2077-01-12'),('2077-01-13'),('2077-01-14'),('2077-01-15'),('2077-01-16'),('2077-01-17'),('2077-01-18'),('2077-01-19'),('2077-01-20'),('2077-01-21'),('2077-01-22'),('2077-01-23'),('2077-01-24'),('2077-01-25'),('2077-01-26'),('2077-01-27'),('2077-01-28'),('2077-01-29'),('2077-01-30'),('2077-01-31'),('2077-02-01'),('2077-02-02'),('2077-02-03'),('2077-02-04'),('2077-02-05'),('2077-02-06'),('2077-02-07'),('2077-02-08'),('2077-02-09'),('2077-02-10'),('2077-02-11'),('2077-02-12'),('2077-02-13'),('2077-02-14'),('2077-02-15'),('2077-02-16'),('2077-02-17'),('2077-02-18'),('2077-02-19'),('2077-02-20'),('2077-02-21'),('2077-02-22'),('2077-02-23'),('2077-02-24'),('2077-02-25'),('2077-02-26'),('2077-02-27'),('2077-02-28'),('2077-03-01'),('2077-03-02'),('2077-03-03'),('2077-03-04'),('2077-03-05'),('2077-03-06'),('2077-03-07'),('2077-03-08'),('2077-03-09'),('2077-03-10'),('2077-03-11'),('2077-03-12'),('2077-03-13'),('2077-03-14'),('2077-03-15'),('2077-03-16'),('2077-03-17'),('2077-03-18'),('2077-03-19'),('2077-03-20'),('2077-03-21'),('2077-03-22'),('2077-03-23'),('2077-03-24'),('2077-03-25'),('2077-03-26'),('2077-03-27'),('2077-03-28'),('2077-03-29'),('2077-03-30'),('2077-03-31'),('2077-04-01'),('2077-04-02'),('2077-04-03'),('2077-04-04'),('2077-04-05'),('2077-04-06'),('2077-04-07'),('2077-04-08'),('2077-04-09'),('2077-04-10'),('2077-04-11'),('2077-04-12'),('2077-04-13'),('2077-04-14'),('2077-04-15'),('2077-04-16'),('2077-04-17'),('2077-04-18'),('2077-04-19'),('2077-04-20'),('2077-04-21'),('2077-04-22'),('2077-04-23'),('2077-04-24'),('2077-04-25'),('2077-04-26'),('2077-04-27'),('2077-04-28'),('2077-04-29'),('2077-04-30'),('2077-05-01'),('2077-05-02'),('2077-05-03'),('2077-05-04'),('2077-05-05'),('2077-05-06'),('2077-05-07'),('2077-05-08'),('2077-05-09'),('2077-05-10'),('2077-05-11'),('2077-05-12'),('2077-05-13'),('2077-05-14'),('2077-05-15'),('2077-05-16'),('2077-05-17'),('2077-05-18'),('2077-05-19'),('2077-05-20'),('2077-05-21'),('2077-05-22'),('2077-05-23'),('2077-05-24'),('2077-05-25'),('2077-05-26'),('2077-05-27'),('2077-05-28'),('2077-05-29'),('2077-05-30'),('2077-05-31'),('2077-06-01'),('2077-06-02'),('2077-06-03'),('2077-06-04'),('2077-06-05'),('2077-06-06'),('2077-06-07'),('2077-06-08'),('2077-06-09'),('2077-06-10'),('2077-06-11'),('2077-06-12'),('2077-06-13'),('2077-06-14'),('2077-06-15'),('2077-06-16'),('2077-06-17'),('2077-06-18'),('2077-06-19'),('2077-06-20'),('2077-06-21'),('2077-06-22'),('2077-06-23'),('2077-06-24'),('2077-06-25'),('2077-06-26'),('2077-06-27'),('2077-06-28'),('2077-06-29'),('2077-06-30'),('2077-07-01'),('2077-07-02'),('2077-07-03'),('2077-07-04'),('2077-07-05'),('2077-07-06'),('2077-07-07'),('2077-07-08'),('2077-07-09'),('2077-07-10'),('2077-07-11'),('2077-07-12'),('2077-07-13'),('2077-07-14'),('2077-07-15'),('2077-07-16'),('2077-07-17'),('2077-07-18'),('2077-07-19'),('2077-07-20'),('2077-07-21'),('2077-07-22'),('2077-07-23'),('2077-07-24'),('2077-07-25'),('2077-07-26'),('2077-07-27'),('2077-07-28'),('2077-07-29'),('2077-07-30'),('2077-07-31'),('2077-08-01'),('2077-08-02'),('2077-08-03'),('2077-08-04'),('2077-08-05'),('2077-08-06'),('2077-08-07'),('2077-08-08'),('2077-08-09'),('2077-08-10'),('2077-08-11'),('2077-08-12'),('2077-08-13'),('2077-08-14'),('2077-08-15'),('2077-08-16'),('2077-08-17'),('2077-08-18'),('2077-08-19'),('2077-08-20'),('2077-08-21'),('2077-08-22'),('2077-08-23'),('2077-08-24'),('2077-08-25'),('2077-08-26'),('2077-08-27'),('2077-08-28'),('2077-08-29'),('2077-08-30'),('2077-08-31'),('2077-09-01'),('2077-09-02'),('2077-09-03'),('2077-09-04'),('2077-09-05'),('2077-09-06'),('2077-09-07'),('2077-09-08'),('2077-09-09'),('2077-09-10'),('2077-09-11'),('2077-09-12'),('2077-09-13'),('2077-09-14'),('2077-09-15'),('2077-09-16'),('2077-09-17'),('2077-09-18'),('2077-09-19'),('2077-09-20'),('2077-09-21'),('2077-09-22'),('2077-09-23'),('2077-09-24'),('2077-09-25'),('2077-09-26'),('2077-09-27'),('2077-09-28'),('2077-09-29'),('2077-09-30'),('2077-10-01'),('2077-10-02'),('2077-10-03'),('2077-10-04'),('2077-10-05'),('2077-10-06'),('2077-10-07'),('2077-10-08'),('2077-10-09'),('2077-10-10'),('2077-10-11'),('2077-10-12'),('2077-10-13'),('2077-10-14'),('2077-10-15'),('2077-10-16'),('2077-10-17'),('2077-10-18'),('2077-10-19'),('2077-10-20'),('2077-10-21'),('2077-10-22'),('2077-10-23'),('2077-10-24'),('2077-10-25'),('2077-10-26'),('2077-10-27'),('2077-10-28'),('2077-10-29'),('2077-10-30'),('2077-10-31'),('2077-11-01'),('2077-11-02'),('2077-11-03'),('2077-11-04'),('2077-11-05'),('2077-11-06'),('2077-11-07'),('2077-11-08'),('2077-11-09'),('2077-11-10'),('2077-11-11'),('2077-11-12'),('2077-11-13'),('2077-11-14'),('2077-11-15'),('2077-11-16'),('2077-11-17'),('2077-11-18'),('2077-11-19'),('2077-11-20'),('2077-11-21'),('2077-11-22'),('2077-11-23'),('2077-11-24'),('2077-11-25'),('2077-11-26'),('2077-11-27'),('2077-11-28'),('2077-11-29'),('2077-11-30'),('2077-12-01'),('2077-12-02'),('2077-12-03'),('2077-12-04'),('2077-12-05'),('2077-12-06'),('2077-12-07'),('2077-12-08'),('2077-12-09'),('2077-12-10'),('2077-12-11'),('2077-12-12'),('2077-12-13'),('2077-12-14'),('2077-12-15'),('2077-12-16'),('2077-12-17'),('2077-12-18'),('2077-12-19'),('2077-12-20'),('2077-12-21'),('2077-12-22'),('2077-12-23'),('2077-12-24'),('2077-12-25'),('2077-12-26'),('2077-12-27'),('2077-12-28'),('2077-12-29'),('2077-12-30'),('2077-12-31'),('2078-01-01'),('2078-01-02'),('2078-01-03'),('2078-01-04'),('2078-01-05'),('2078-01-06'),('2078-01-07'),('2078-01-08'),('2078-01-09'),('2078-01-10'),('2078-01-11'),('2078-01-12'),('2078-01-13'),('2078-01-14'),('2078-01-15'),('2078-01-16'),('2078-01-17'),('2078-01-18'),('2078-01-19'),('2078-01-20'),('2078-01-21'),('2078-01-22'),('2078-01-23'),('2078-01-24'),('2078-01-25'),('2078-01-26'),('2078-01-27'),('2078-01-28'),('2078-01-29'),('2078-01-30'),('2078-01-31'),('2078-02-01'),('2078-02-02'),('2078-02-03'),('2078-02-04'),('2078-02-05'),('2078-02-06'),('2078-02-07'),('2078-02-08'),('2078-02-09'),('2078-02-10'),('2078-02-11'),('2078-02-12'),('2078-02-13'),('2078-02-14'),('2078-02-15'),('2078-02-16'),('2078-02-17'),('2078-02-18'),('2078-02-19'),('2078-02-20'),('2078-02-21'),('2078-02-22'),('2078-02-23'),('2078-02-24'),('2078-02-25'),('2078-02-26'),('2078-02-27'),('2078-02-28'),('2078-03-01'),('2078-03-02'),('2078-03-03'),('2078-03-04'),('2078-03-05'),('2078-03-06'),('2078-03-07'),('2078-03-08'),('2078-03-09'),('2078-03-10'),('2078-03-11'),('2078-03-12'),('2078-03-13'),('2078-03-14'),('2078-03-15'),('2078-03-16'),('2078-03-17'),('2078-03-18'),('2078-03-19'),('2078-03-20'),('2078-03-21'),('2078-03-22'),('2078-03-23'),('2078-03-24'),('2078-03-25'),('2078-03-26'),('2078-03-27'),('2078-03-28'),('2078-03-29'),('2078-03-30'),('2078-03-31'),('2078-04-01'),('2078-04-02'),('2078-04-03'),('2078-04-04'),('2078-04-05'),('2078-04-06'),('2078-04-07'),('2078-04-08'),('2078-04-09'),('2078-04-10'),('2078-04-11'),('2078-04-12'),('2078-04-13'),('2078-04-14'),('2078-04-15'),('2078-04-16'),('2078-04-17'),('2078-04-18'),('2078-04-19'),('2078-04-20'),('2078-04-21'),('2078-04-22'),('2078-04-23'),('2078-04-24'),('2078-04-25'),('2078-04-26'),('2078-04-27'),('2078-04-28'),('2078-04-29'),('2078-04-30'),('2078-05-01'),('2078-05-02'),('2078-05-03'),('2078-05-04'),('2078-05-05'),('2078-05-06'),('2078-05-07'),('2078-05-08'),('2078-05-09'),('2078-05-10'),('2078-05-11'),('2078-05-12'),('2078-05-13'),('2078-05-14'),('2078-05-15'),('2078-05-16'),('2078-05-17'),('2078-05-18'),('2078-05-19'),('2078-05-20'),('2078-05-21'),('2078-05-22'),('2078-05-23'),('2078-05-24'),('2078-05-25'),('2078-05-26'),('2078-05-27'),('2078-05-28'),('2078-05-29'),('2078-05-30'),('2078-05-31'),('2078-06-01'),('2078-06-02'),('2078-06-03'),('2078-06-04'),('2078-06-05'),('2078-06-06'),('2078-06-07'),('2078-06-08'),('2078-06-09'),('2078-06-10'),('2078-06-11'),('2078-06-12'),('2078-06-13'),('2078-06-14'),('2078-06-15'),('2078-06-16'),('2078-06-17'),('2078-06-18'),('2078-06-19'),('2078-06-20'),('2078-06-21'),('2078-06-22'),('2078-06-23'),('2078-06-24'),('2078-06-25'),('2078-06-26'),('2078-06-27'),('2078-06-28'),('2078-06-29'),('2078-06-30'),('2078-07-01'),('2078-07-02'),('2078-07-03'),('2078-07-04'),('2078-07-05'),('2078-07-06'),('2078-07-07'),('2078-07-08'),('2078-07-09'),('2078-07-10'),('2078-07-11'),('2078-07-12'),('2078-07-13'),('2078-07-14'),('2078-07-15'),('2078-07-16'),('2078-07-17'),('2078-07-18'),('2078-07-19'),('2078-07-20'),('2078-07-21'),('2078-07-22'),('2078-07-23'),('2078-07-24'),('2078-07-25'),('2078-07-26'),('2078-07-27'),('2078-07-28'),('2078-07-29'),('2078-07-30'),('2078-07-31'),('2078-08-01'),('2078-08-02'),('2078-08-03'),('2078-08-04'),('2078-08-05'),('2078-08-06'),('2078-08-07'),('2078-08-08'),('2078-08-09'),('2078-08-10'),('2078-08-11'),('2078-08-12'),('2078-08-13'),('2078-08-14'),('2078-08-15'),('2078-08-16'),('2078-08-17'),('2078-08-18'),('2078-08-19'),('2078-08-20'),('2078-08-21'),('2078-08-22'),('2078-08-23'),('2078-08-24'),('2078-08-25'),('2078-08-26'),('2078-08-27'),('2078-08-28'),('2078-08-29'),('2078-08-30'),('2078-08-31'),('2078-09-01'),('2078-09-02'),('2078-09-03'),('2078-09-04'),('2078-09-05'),('2078-09-06'),('2078-09-07'),('2078-09-08'),('2078-09-09'),('2078-09-10'),('2078-09-11'),('2078-09-12'),('2078-09-13'),('2078-09-14'),('2078-09-15'),('2078-09-16'),('2078-09-17'),('2078-09-18'),('2078-09-19'),('2078-09-20'),('2078-09-21'),('2078-09-22'),('2078-09-23'),('2078-09-24'),('2078-09-25'),('2078-09-26'),('2078-09-27'),('2078-09-28'),('2078-09-29'),('2078-09-30'),('2078-10-01'),('2078-10-02'),('2078-10-03'),('2078-10-04'),('2078-10-05'),('2078-10-06'),('2078-10-07'),('2078-10-08'),('2078-10-09'),('2078-10-10'),('2078-10-11'),('2078-10-12'),('2078-10-13'),('2078-10-14'),('2078-10-15'),('2078-10-16'),('2078-10-17'),('2078-10-18'),('2078-10-19'),('2078-10-20'),('2078-10-21'),('2078-10-22'),('2078-10-23'),('2078-10-24'),('2078-10-25'),('2078-10-26'),('2078-10-27'),('2078-10-28'),('2078-10-29'),('2078-10-30'),('2078-10-31'),('2078-11-01'),('2078-11-02'),('2078-11-03'),('2078-11-04'),('2078-11-05'),('2078-11-06'),('2078-11-07'),('2078-11-08'),('2078-11-09'),('2078-11-10'),('2078-11-11'),('2078-11-12'),('2078-11-13'),('2078-11-14'),('2078-11-15'),('2078-11-16'),('2078-11-17'),('2078-11-18'),('2078-11-19'),('2078-11-20'),('2078-11-21'),('2078-11-22'),('2078-11-23'),('2078-11-24'),('2078-11-25'),('2078-11-26'),('2078-11-27'),('2078-11-28'),('2078-11-29'),('2078-11-30'),('2078-12-01'),('2078-12-02'),('2078-12-03'),('2078-12-04'),('2078-12-05'),('2078-12-06'),('2078-12-07'),('2078-12-08'),('2078-12-09'),('2078-12-10'),('2078-12-11'),('2078-12-12'),('2078-12-13'),('2078-12-14'),('2078-12-15'),('2078-12-16'),('2078-12-17'),('2078-12-18'),('2078-12-19'),('2078-12-20'),('2078-12-21'),('2078-12-22'),('2078-12-23'),('2078-12-24'),('2078-12-25'),('2078-12-26'),('2078-12-27'),('2078-12-28'),('2078-12-29'),('2078-12-30'),('2078-12-31'),('2079-01-01'),('2079-01-02'),('2079-01-03'),('2079-01-04'),('2079-01-05'),('2079-01-06'),('2079-01-07'),('2079-01-08'),('2079-01-09'),('2079-01-10'),('2079-01-11'),('2079-01-12'),('2079-01-13'),('2079-01-14'),('2079-01-15'),('2079-01-16'),('2079-01-17'),('2079-01-18'),('2079-01-19'),('2079-01-20'),('2079-01-21'),('2079-01-22'),('2079-01-23'),('2079-01-24'),('2079-01-25'),('2079-01-26'),('2079-01-27'),('2079-01-28'),('2079-01-29'),('2079-01-30'),('2079-01-31'),('2079-02-01'),('2079-02-02'),('2079-02-03'),('2079-02-04'),('2079-02-05'),('2079-02-06'),('2079-02-07'),('2079-02-08'),('2079-02-09'),('2079-02-10'),('2079-02-11'),('2079-02-12'),('2079-02-13'),('2079-02-14'),('2079-02-15'),('2079-02-16'),('2079-02-17'),('2079-02-18'),('2079-02-19'),('2079-02-20'),('2079-02-21'),('2079-02-22'),('2079-02-23'),('2079-02-24'),('2079-02-25'),('2079-02-26'),('2079-02-27'),('2079-02-28'),('2079-03-01'),('2079-03-02'),('2079-03-03'),('2079-03-04'),('2079-03-05'),('2079-03-06'),('2079-03-07'),('2079-03-08'),('2079-03-09'),('2079-03-10'),('2079-03-11'),('2079-03-12'),('2079-03-13'),('2079-03-14'),('2079-03-15'),('2079-03-16'),('2079-03-17'),('2079-03-18'),('2079-03-19'),('2079-03-20'),('2079-03-21'),('2079-03-22'),('2079-03-23'),('2079-03-24'),('2079-03-25'),('2079-03-26'),('2079-03-27'),('2079-03-28'),('2079-03-29'),('2079-03-30'),('2079-03-31'),('2079-04-01'),('2079-04-02'),('2079-04-03'),('2079-04-04'),('2079-04-05'),('2079-04-06'),('2079-04-07'),('2079-04-08'),('2079-04-09'),('2079-04-10'),('2079-04-11'),('2079-04-12'),('2079-04-13'),('2079-04-14'),('2079-04-15'),('2079-04-16'),('2079-04-17'),('2079-04-18'),('2079-04-19'),('2079-04-20'),('2079-04-21'),('2079-04-22'),('2079-04-23'),('2079-04-24'),('2079-04-25'),('2079-04-26'),('2079-04-27'),('2079-04-28'),('2079-04-29'),('2079-04-30'),('2079-05-01'),('2079-05-02'),('2079-05-03'),('2079-05-04'),('2079-05-05'),('2079-05-06'),('2079-05-07'),('2079-05-08'),('2079-05-09'),('2079-05-10'),('2079-05-11'),('2079-05-12'),('2079-05-13'),('2079-05-14'),('2079-05-15'),('2079-05-16'),('2079-05-17'),('2079-05-18'),('2079-05-19'),('2079-05-20'),('2079-05-21'),('2079-05-22'),('2079-05-23'),('2079-05-24'),('2079-05-25'),('2079-05-26'),('2079-05-27'),('2079-05-28'),('2079-05-29'),('2079-05-30'),('2079-05-31'),('2079-06-01'),('2079-06-02'),('2079-06-03'),('2079-06-04'),('2079-06-05'),('2079-06-06'),('2079-06-07'),('2079-06-08'),('2079-06-09'),('2079-06-10'),('2079-06-11'),('2079-06-12'),('2079-06-13'),('2079-06-14'),('2079-06-15'),('2079-06-16'),('2079-06-17'),('2079-06-18'),('2079-06-19'),('2079-06-20'),('2079-06-21'),('2079-06-22'),('2079-06-23'),('2079-06-24'),('2079-06-25'),('2079-06-26'),('2079-06-27'),('2079-06-28'),('2079-06-29'),('2079-06-30'),('2079-07-01'),('2079-07-02'),('2079-07-03'),('2079-07-04'),('2079-07-05'),('2079-07-06'),('2079-07-07'),('2079-07-08'),('2079-07-09'),('2079-07-10'),('2079-07-11'),('2079-07-12'),('2079-07-13'),('2079-07-14'),('2079-07-15'),('2079-07-16'),('2079-07-17'),('2079-07-18'),('2079-07-19'),('2079-07-20'),('2079-07-21'),('2079-07-22'),('2079-07-23'),('2079-07-24'),('2079-07-25'),('2079-07-26'),('2079-07-27'),('2079-07-28'),('2079-07-29'),('2079-07-30'),('2079-07-31'),('2079-08-01'),('2079-08-02'),('2079-08-03'),('2079-08-04'),('2079-08-05'),('2079-08-06'),('2079-08-07'),('2079-08-08'),('2079-08-09'),('2079-08-10'),('2079-08-11'),('2079-08-12'),('2079-08-13'),('2079-08-14'),('2079-08-15'),('2079-08-16'),('2079-08-17'),('2079-08-18'),('2079-08-19'),('2079-08-20'),('2079-08-21'),('2079-08-22'),('2079-08-23'),('2079-08-24'),('2079-08-25'),('2079-08-26'),('2079-08-27'),('2079-08-28'),('2079-08-29'),('2079-08-30'),('2079-08-31'),('2079-09-01'),('2079-09-02'),('2079-09-03'),('2079-09-04'),('2079-09-05'),('2079-09-06'),('2079-09-07'),('2079-09-08'),('2079-09-09'),('2079-09-10'),('2079-09-11'),('2079-09-12'),('2079-09-13'),('2079-09-14'),('2079-09-15'),('2079-09-16'),('2079-09-17'),('2079-09-18'),('2079-09-19'),('2079-09-20'),('2079-09-21'),('2079-09-22'),('2079-09-23'),('2079-09-24'),('2079-09-25'),('2079-09-26'),('2079-09-27'),('2079-09-28'),('2079-09-29'),('2079-09-30'),('2079-10-01'),('2079-10-02'),('2079-10-03'),('2079-10-04'),('2079-10-05'),('2079-10-06'),('2079-10-07'),('2079-10-08'),('2079-10-09'),('2079-10-10'),('2079-10-11'),('2079-10-12'),('2079-10-13'),('2079-10-14'),('2079-10-15'),('2079-10-16'),('2079-10-17'),('2079-10-18'),('2079-10-19'),('2079-10-20'),('2079-10-21'),('2079-10-22'),('2079-10-23'),('2079-10-24'),('2079-10-25'),('2079-10-26'),('2079-10-27'),('2079-10-28'),('2079-10-29'),('2079-10-30'),('2079-10-31'),('2079-11-01'),('2079-11-02'),('2079-11-03'),('2079-11-04'),('2079-11-05'),('2079-11-06'),('2079-11-07'),('2079-11-08'),('2079-11-09'),('2079-11-10'),('2079-11-11'),('2079-11-12'),('2079-11-13'),('2079-11-14'),('2079-11-15'),('2079-11-16'),('2079-11-17'),('2079-11-18'),('2079-11-19'),('2079-11-20'),('2079-11-21'),('2079-11-22'),('2079-11-23'),('2079-11-24'),('2079-11-25'),('2079-11-26'),('2079-11-27'),('2079-11-28'),('2079-11-29'),('2079-11-30'),('2079-12-01'),('2079-12-02'),('2079-12-03'),('2079-12-04'),('2079-12-05'),('2079-12-06'),('2079-12-07'),('2079-12-08'),('2079-12-09'),('2079-12-10'),('2079-12-11'),('2079-12-12'),('2079-12-13'),('2079-12-14'),('2079-12-15'),('2079-12-16'),('2079-12-17'),('2079-12-18'),('2079-12-19'),('2079-12-20'),('2079-12-21'),('2079-12-22'),('2079-12-23'),('2079-12-24'),('2079-12-25'),('2079-12-26'),('2079-12-27'),('2079-12-28'),('2079-12-29'),('2079-12-30'),('2079-12-31'),('2080-01-01'),('2080-01-02'),('2080-01-03'),('2080-01-04'),('2080-01-05'),('2080-01-06'),('2080-01-07'),('2080-01-08'),('2080-01-09'),('2080-01-10'),('2080-01-11'),('2080-01-12'),('2080-01-13'),('2080-01-14'),('2080-01-15'),('2080-01-16'),('2080-01-17'),('2080-01-18'),('2080-01-19'),('2080-01-20'),('2080-01-21'),('2080-01-22'),('2080-01-23'),('2080-01-24'),('2080-01-25'),('2080-01-26'),('2080-01-27'),('2080-01-28'),('2080-01-29'),('2080-01-30'),('2080-01-31'),('2080-02-01'),('2080-02-02'),('2080-02-03'),('2080-02-04'),('2080-02-05'),('2080-02-06'),('2080-02-07'),('2080-02-08'),('2080-02-09'),('2080-02-10'),('2080-02-11'),('2080-02-12'),('2080-02-13'),('2080-02-14'),('2080-02-15'),('2080-02-16'),('2080-02-17'),('2080-02-18'),('2080-02-19'),('2080-02-20'),('2080-02-21'),('2080-02-22'),('2080-02-23'),('2080-02-24'),('2080-02-25'),('2080-02-26'),('2080-02-27'),('2080-02-28'),('2080-02-29'),('2080-03-01'),('2080-03-02'),('2080-03-03'),('2080-03-04'),('2080-03-05'),('2080-03-06'),('2080-03-07'),('2080-03-08'),('2080-03-09'),('2080-03-10'),('2080-03-11'),('2080-03-12'),('2080-03-13'),('2080-03-14'),('2080-03-15'),('2080-03-16'),('2080-03-17'),('2080-03-18'),('2080-03-19'),('2080-03-20'),('2080-03-21'),('2080-03-22'),('2080-03-23'),('2080-03-24'),('2080-03-25'),('2080-03-26'),('2080-03-27'),('2080-03-28'),('2080-03-29'),('2080-03-30'),('2080-03-31'),('2080-04-01'),('2080-04-02'),('2080-04-03'),('2080-04-04'),('2080-04-05'),('2080-04-06'),('2080-04-07'),('2080-04-08'),('2080-04-09'),('2080-04-10'),('2080-04-11'),('2080-04-12'),('2080-04-13'),('2080-04-14'),('2080-04-15'),('2080-04-16'),('2080-04-17'),('2080-04-18'),('2080-04-19'),('2080-04-20'),('2080-04-21'),('2080-04-22'),('2080-04-23'),('2080-04-24'),('2080-04-25'),('2080-04-26'),('2080-04-27'),('2080-04-28'),('2080-04-29'),('2080-04-30'),('2080-05-01'),('2080-05-02'),('2080-05-03'),('2080-05-04'),('2080-05-05'),('2080-05-06'),('2080-05-07'),('2080-05-08'),('2080-05-09'),('2080-05-10'),('2080-05-11'),('2080-05-12'),('2080-05-13'),('2080-05-14'),('2080-05-15'),('2080-05-16'),('2080-05-17'),('2080-05-18'),('2080-05-19'),('2080-05-20'),('2080-05-21'),('2080-05-22'),('2080-05-23'),('2080-05-24'),('2080-05-25'),('2080-05-26'),('2080-05-27'),('2080-05-28'),('2080-05-29'),('2080-05-30'),('2080-05-31'),('2080-06-01'),('2080-06-02'),('2080-06-03'),('2080-06-04'),('2080-06-05'),('2080-06-06'),('2080-06-07'),('2080-06-08'),('2080-06-09'),('2080-06-10'),('2080-06-11'),('2080-06-12'),('2080-06-13'),('2080-06-14'),('2080-06-15'),('2080-06-16'),('2080-06-17'),('2080-06-18'),('2080-06-19'),('2080-06-20'),('2080-06-21'),('2080-06-22'),('2080-06-23'),('2080-06-24'),('2080-06-25'),('2080-06-26'),('2080-06-27'),('2080-06-28'),('2080-06-29'),('2080-06-30'),('2080-07-01'),('2080-07-02'),('2080-07-03'),('2080-07-04'),('2080-07-05'),('2080-07-06'),('2080-07-07'),('2080-07-08'),('2080-07-09'),('2080-07-10'),('2080-07-11'),('2080-07-12'),('2080-07-13'),('2080-07-14'),('2080-07-15'),('2080-07-16'),('2080-07-17'),('2080-07-18'),('2080-07-19'),('2080-07-20'),('2080-07-21'),('2080-07-22'),('2080-07-23'),('2080-07-24'),('2080-07-25'),('2080-07-26'),('2080-07-27'),('2080-07-28'),('2080-07-29'),('2080-07-30'),('2080-07-31'),('2080-08-01'),('2080-08-02'),('2080-08-03'),('2080-08-04'),('2080-08-05'),('2080-08-06'),('2080-08-07'),('2080-08-08'),('2080-08-09'),('2080-08-10'),('2080-08-11'),('2080-08-12'),('2080-08-13'),('2080-08-14'),('2080-08-15'),('2080-08-16'),('2080-08-17'),('2080-08-18'),('2080-08-19'),('2080-08-20'),('2080-08-21'),('2080-08-22'),('2080-08-23'),('2080-08-24'),('2080-08-25'),('2080-08-26'),('2080-08-27'),('2080-08-28'),('2080-08-29'),('2080-08-30'),('2080-08-31'),('2080-09-01'),('2080-09-02'),('2080-09-03'),('2080-09-04'),('2080-09-05'),('2080-09-06'),('2080-09-07'),('2080-09-08'),('2080-09-09'),('2080-09-10'),('2080-09-11'),('2080-09-12'),('2080-09-13'),('2080-09-14'),('2080-09-15'),('2080-09-16'),('2080-09-17'),('2080-09-18'),('2080-09-19'),('2080-09-20'),('2080-09-21'),('2080-09-22'),('2080-09-23'),('2080-09-24'),('2080-09-25'),('2080-09-26'),('2080-09-27'),('2080-09-28'),('2080-09-29'),('2080-09-30'),('2080-10-01'),('2080-10-02'),('2080-10-03'),('2080-10-04'),('2080-10-05'),('2080-10-06'),('2080-10-07'),('2080-10-08'),('2080-10-09'),('2080-10-10'),('2080-10-11'),('2080-10-12'),('2080-10-13'),('2080-10-14'),('2080-10-15'),('2080-10-16'),('2080-10-17'),('2080-10-18'),('2080-10-19'),('2080-10-20'),('2080-10-21'),('2080-10-22'),('2080-10-23'),('2080-10-24'),('2080-10-25'),('2080-10-26'),('2080-10-27'),('2080-10-28'),('2080-10-29'),('2080-10-30'),('2080-10-31'),('2080-11-01'),('2080-11-02'),('2080-11-03'),('2080-11-04'),('2080-11-05'),('2080-11-06'),('2080-11-07'),('2080-11-08'),('2080-11-09'),('2080-11-10'),('2080-11-11'),('2080-11-12'),('2080-11-13'),('2080-11-14'),('2080-11-15'),('2080-11-16'),('2080-11-17'),('2080-11-18'),('2080-11-19'),('2080-11-20'),('2080-11-21'),('2080-11-22'),('2080-11-23'),('2080-11-24'),('2080-11-25'),('2080-11-26'),('2080-11-27'),('2080-11-28'),('2080-11-29'),('2080-11-30'),('2080-12-01'),('2080-12-02'),('2080-12-03'),('2080-12-04'),('2080-12-05'),('2080-12-06'),('2080-12-07'),('2080-12-08'),('2080-12-09'),('2080-12-10'),('2080-12-11'),('2080-12-12'),('2080-12-13'),('2080-12-14'),('2080-12-15'),('2080-12-16'),('2080-12-17'),('2080-12-18'),('2080-12-19'),('2080-12-20'),('2080-12-21'),('2080-12-22'),('2080-12-23'),('2080-12-24'),('2080-12-25'),('2080-12-26'),('2080-12-27'),('2080-12-28'),('2080-12-29'),('2080-12-30'),('2080-12-31'),('2081-01-01'),('2081-01-02'),('2081-01-03'),('2081-01-04'),('2081-01-05'),('2081-01-06'),('2081-01-07'),('2081-01-08'),('2081-01-09'),('2081-01-10'),('2081-01-11'),('2081-01-12'),('2081-01-13'),('2081-01-14'),('2081-01-15'),('2081-01-16'),('2081-01-17'),('2081-01-18'),('2081-01-19'),('2081-01-20'),('2081-01-21'),('2081-01-22'),('2081-01-23'),('2081-01-24'),('2081-01-25'),('2081-01-26'),('2081-01-27'),('2081-01-28'),('2081-01-29'),('2081-01-30'),('2081-01-31'),('2081-02-01'),('2081-02-02'),('2081-02-03'),('2081-02-04'),('2081-02-05'),('2081-02-06'),('2081-02-07'),('2081-02-08'),('2081-02-09'),('2081-02-10'),('2081-02-11'),('2081-02-12'),('2081-02-13'),('2081-02-14'),('2081-02-15'),('2081-02-16'),('2081-02-17'),('2081-02-18'),('2081-02-19'),('2081-02-20'),('2081-02-21'),('2081-02-22'),('2081-02-23'),('2081-02-24'),('2081-02-25'),('2081-02-26'),('2081-02-27'),('2081-02-28'),('2081-03-01'),('2081-03-02'),('2081-03-03'),('2081-03-04'),('2081-03-05'),('2081-03-06'),('2081-03-07'),('2081-03-08'),('2081-03-09'),('2081-03-10'),('2081-03-11'),('2081-03-12'),('2081-03-13'),('2081-03-14'),('2081-03-15'),('2081-03-16'),('2081-03-17'),('2081-03-18'),('2081-03-19'),('2081-03-20'),('2081-03-21'),('2081-03-22'),('2081-03-23'),('2081-03-24'),('2081-03-25'),('2081-03-26'),('2081-03-27'),('2081-03-28'),('2081-03-29'),('2081-03-30'),('2081-03-31'),('2081-04-01'),('2081-04-02'),('2081-04-03'),('2081-04-04'),('2081-04-05'),('2081-04-06'),('2081-04-07'),('2081-04-08'),('2081-04-09'),('2081-04-10'),('2081-04-11'),('2081-04-12'),('2081-04-13'),('2081-04-14'),('2081-04-15'),('2081-04-16'),('2081-04-17'),('2081-04-18'),('2081-04-19'),('2081-04-20'),('2081-04-21'),('2081-04-22'),('2081-04-23'),('2081-04-24'),('2081-04-25'),('2081-04-26'),('2081-04-27'),('2081-04-28'),('2081-04-29'),('2081-04-30'),('2081-05-01'),('2081-05-02'),('2081-05-03'),('2081-05-04'),('2081-05-05'),('2081-05-06'),('2081-05-07'),('2081-05-08'),('2081-05-09'),('2081-05-10'),('2081-05-11'),('2081-05-12'),('2081-05-13'),('2081-05-14'),('2081-05-15'),('2081-05-16'),('2081-05-17'),('2081-05-18'),('2081-05-19'),('2081-05-20'),('2081-05-21'),('2081-05-22'),('2081-05-23'),('2081-05-24'),('2081-05-25'),('2081-05-26'),('2081-05-27'),('2081-05-28'),('2081-05-29'),('2081-05-30'),('2081-05-31'),('2081-06-01'),('2081-06-02'),('2081-06-03'),('2081-06-04'),('2081-06-05'),('2081-06-06'),('2081-06-07'),('2081-06-08'),('2081-06-09'),('2081-06-10'),('2081-06-11'),('2081-06-12'),('2081-06-13'),('2081-06-14'),('2081-06-15'),('2081-06-16'),('2081-06-17'),('2081-06-18'),('2081-06-19'),('2081-06-20'),('2081-06-21'),('2081-06-22'),('2081-06-23'),('2081-06-24'),('2081-06-25'),('2081-06-26'),('2081-06-27'),('2081-06-28'),('2081-06-29'),('2081-06-30'),('2081-07-01'),('2081-07-02'),('2081-07-03'),('2081-07-04'),('2081-07-05'),('2081-07-06'),('2081-07-07'),('2081-07-08'),('2081-07-09'),('2081-07-10'),('2081-07-11'),('2081-07-12'),('2081-07-13'),('2081-07-14'),('2081-07-15'),('2081-07-16'),('2081-07-17'),('2081-07-18'),('2081-07-19'),('2081-07-20'),('2081-07-21'),('2081-07-22'),('2081-07-23'),('2081-07-24'),('2081-07-25'),('2081-07-26'),('2081-07-27'),('2081-07-28'),('2081-07-29'),('2081-07-30'),('2081-07-31'),('2081-08-01'),('2081-08-02'),('2081-08-03'),('2081-08-04'),('2081-08-05'),('2081-08-06'),('2081-08-07'),('2081-08-08'),('2081-08-09'),('2081-08-10'),('2081-08-11'),('2081-08-12'),('2081-08-13'),('2081-08-14'),('2081-08-15'),('2081-08-16'),('2081-08-17'),('2081-08-18'),('2081-08-19'),('2081-08-20'),('2081-08-21'),('2081-08-22'),('2081-08-23'),('2081-08-24'),('2081-08-25'),('2081-08-26'),('2081-08-27'),('2081-08-28'),('2081-08-29'),('2081-08-30'),('2081-08-31'),('2081-09-01'),('2081-09-02'),('2081-09-03'),('2081-09-04'),('2081-09-05'),('2081-09-06'),('2081-09-07'),('2081-09-08'),('2081-09-09'),('2081-09-10'),('2081-09-11'),('2081-09-12'),('2081-09-13'),('2081-09-14'),('2081-09-15'),('2081-09-16'),('2081-09-17'),('2081-09-18'),('2081-09-19'),('2081-09-20'),('2081-09-21'),('2081-09-22'),('2081-09-23'),('2081-09-24'),('2081-09-25'),('2081-09-26'),('2081-09-27'),('2081-09-28'),('2081-09-29'),('2081-09-30'),('2081-10-01'),('2081-10-02'),('2081-10-03'),('2081-10-04'),('2081-10-05'),('2081-10-06'),('2081-10-07'),('2081-10-08'),('2081-10-09'),('2081-10-10'),('2081-10-11'),('2081-10-12'),('2081-10-13'),('2081-10-14'),('2081-10-15'),('2081-10-16'),('2081-10-17'),('2081-10-18'),('2081-10-19'),('2081-10-20'),('2081-10-21'),('2081-10-22'),('2081-10-23'),('2081-10-24'),('2081-10-25'),('2081-10-26'),('2081-10-27'),('2081-10-28'),('2081-10-29'),('2081-10-30'),('2081-10-31'),('2081-11-01'),('2081-11-02'),('2081-11-03'),('2081-11-04'),('2081-11-05'),('2081-11-06'),('2081-11-07'),('2081-11-08'),('2081-11-09'),('2081-11-10'),('2081-11-11'),('2081-11-12'),('2081-11-13'),('2081-11-14'),('2081-11-15'),('2081-11-16'),('2081-11-17'),('2081-11-18'),('2081-11-19'),('2081-11-20'),('2081-11-21'),('2081-11-22'),('2081-11-23'),('2081-11-24'),('2081-11-25'),('2081-11-26'),('2081-11-27'),('2081-11-28'),('2081-11-29'),('2081-11-30'),('2081-12-01'),('2081-12-02'),('2081-12-03'),('2081-12-04'),('2081-12-05'),('2081-12-06'),('2081-12-07'),('2081-12-08'),('2081-12-09'),('2081-12-10'),('2081-12-11'),('2081-12-12'),('2081-12-13'),('2081-12-14'),('2081-12-15'),('2081-12-16'),('2081-12-17'),('2081-12-18'),('2081-12-19'),('2081-12-20'),('2081-12-21'),('2081-12-22'),('2081-12-23'),('2081-12-24'),('2081-12-25'),('2081-12-26'),('2081-12-27'),('2081-12-28'),('2081-12-29'),('2081-12-30'),('2081-12-31'),('2082-01-01'),('2082-01-02'),('2082-01-03'),('2082-01-04'),('2082-01-05'),('2082-01-06'),('2082-01-07'),('2082-01-08'),('2082-01-09'),('2082-01-10'),('2082-01-11'),('2082-01-12'),('2082-01-13'),('2082-01-14'),('2082-01-15'),('2082-01-16'),('2082-01-17'),('2082-01-18'),('2082-01-19'),('2082-01-20'),('2082-01-21'),('2082-01-22'),('2082-01-23'),('2082-01-24'),('2082-01-25'),('2082-01-26'),('2082-01-27'),('2082-01-28'),('2082-01-29'),('2082-01-30'),('2082-01-31'),('2082-02-01'),('2082-02-02'),('2082-02-03'),('2082-02-04'),('2082-02-05'),('2082-02-06'),('2082-02-07'),('2082-02-08'),('2082-02-09'),('2082-02-10'),('2082-02-11'),('2082-02-12'),('2082-02-13'),('2082-02-14'),('2082-02-15'),('2082-02-16'),('2082-02-17'),('2082-02-18'),('2082-02-19'),('2082-02-20'),('2082-02-21'),('2082-02-22'),('2082-02-23'),('2082-02-24'),('2082-02-25'),('2082-02-26'),('2082-02-27'),('2082-02-28'),('2082-03-01'),('2082-03-02'),('2082-03-03'),('2082-03-04'),('2082-03-05'),('2082-03-06'),('2082-03-07'),('2082-03-08'),('2082-03-09'),('2082-03-10'),('2082-03-11'),('2082-03-12'),('2082-03-13'),('2082-03-14'),('2082-03-15'),('2082-03-16'),('2082-03-17'),('2082-03-18'),('2082-03-19'),('2082-03-20'),('2082-03-21'),('2082-03-22'),('2082-03-23'),('2082-03-24'),('2082-03-25'),('2082-03-26'),('2082-03-27'),('2082-03-28'),('2082-03-29'),('2082-03-30'),('2082-03-31'),('2082-04-01'),('2082-04-02'),('2082-04-03'),('2082-04-04'),('2082-04-05'),('2082-04-06'),('2082-04-07'),('2082-04-08'),('2082-04-09'),('2082-04-10'),('2082-04-11'),('2082-04-12'),('2082-04-13'),('2082-04-14'),('2082-04-15'),('2082-04-16'),('2082-04-17'),('2082-04-18'),('2082-04-19'),('2082-04-20'),('2082-04-21'),('2082-04-22'),('2082-04-23'),('2082-04-24'),('2082-04-25'),('2082-04-26'),('2082-04-27'),('2082-04-28'),('2082-04-29'),('2082-04-30'),('2082-05-01'),('2082-05-02'),('2082-05-03'),('2082-05-04'),('2082-05-05'),('2082-05-06'),('2082-05-07'),('2082-05-08'),('2082-05-09'),('2082-05-10'),('2082-05-11'),('2082-05-12'),('2082-05-13'),('2082-05-14'),('2082-05-15'),('2082-05-16'),('2082-05-17'),('2082-05-18'),('2082-05-19'),('2082-05-20'),('2082-05-21'),('2082-05-22'),('2082-05-23'),('2082-05-24'),('2082-05-25'),('2082-05-26'),('2082-05-27'),('2082-05-28'),('2082-05-29'),('2082-05-30'),('2082-05-31'),('2082-06-01'),('2082-06-02'),('2082-06-03'),('2082-06-04'),('2082-06-05'),('2082-06-06'),('2082-06-07'),('2082-06-08'),('2082-06-09'),('2082-06-10'),('2082-06-11'),('2082-06-12'),('2082-06-13'),('2082-06-14'),('2082-06-15'),('2082-06-16'),('2082-06-17'),('2082-06-18'),('2082-06-19'),('2082-06-20'),('2082-06-21'),('2082-06-22'),('2082-06-23'),('2082-06-24'),('2082-06-25'),('2082-06-26'),('2082-06-27'),('2082-06-28'),('2082-06-29'),('2082-06-30'),('2082-07-01'),('2082-07-02'),('2082-07-03'),('2082-07-04'),('2082-07-05'),('2082-07-06'),('2082-07-07'),('2082-07-08'),('2082-07-09'),('2082-07-10'),('2082-07-11'),('2082-07-12'),('2082-07-13'),('2082-07-14'),('2082-07-15'),('2082-07-16'),('2082-07-17'),('2082-07-18'),('2082-07-19'),('2082-07-20'),('2082-07-21'),('2082-07-22'),('2082-07-23'),('2082-07-24'),('2082-07-25'),('2082-07-26'),('2082-07-27'),('2082-07-28'),('2082-07-29'),('2082-07-30'),('2082-07-31'),('2082-08-01'),('2082-08-02'),('2082-08-03'),('2082-08-04'),('2082-08-05'),('2082-08-06'),('2082-08-07'),('2082-08-08'),('2082-08-09'),('2082-08-10'),('2082-08-11'),('2082-08-12'),('2082-08-13'),('2082-08-14'),('2082-08-15'),('2082-08-16'),('2082-08-17'),('2082-08-18'),('2082-08-19'),('2082-08-20'),('2082-08-21'),('2082-08-22'),('2082-08-23'),('2082-08-24'),('2082-08-25'),('2082-08-26'),('2082-08-27'),('2082-08-28'),('2082-08-29'),('2082-08-30'),('2082-08-31'),('2082-09-01'),('2082-09-02'),('2082-09-03'),('2082-09-04'),('2082-09-05'),('2082-09-06'),('2082-09-07'),('2082-09-08'),('2082-09-09'),('2082-09-10'),('2082-09-11'),('2082-09-12'),('2082-09-13'),('2082-09-14'),('2082-09-15'),('2082-09-16'),('2082-09-17'),('2082-09-18'),('2082-09-19'),('2082-09-20'),('2082-09-21'),('2082-09-22'),('2082-09-23'),('2082-09-24'),('2082-09-25'),('2082-09-26'),('2082-09-27'),('2082-09-28'),('2082-09-29'),('2082-09-30'),('2082-10-01'),('2082-10-02'),('2082-10-03'),('2082-10-04'),('2082-10-05'),('2082-10-06'),('2082-10-07'),('2082-10-08'),('2082-10-09'),('2082-10-10'),('2082-10-11'),('2082-10-12'),('2082-10-13'),('2082-10-14'),('2082-10-15'),('2082-10-16'),('2082-10-17'),('2082-10-18'),('2082-10-19'),('2082-10-20'),('2082-10-21'),('2082-10-22'),('2082-10-23'),('2082-10-24'),('2082-10-25'),('2082-10-26'),('2082-10-27'),('2082-10-28'),('2082-10-29'),('2082-10-30'),('2082-10-31'),('2082-11-01'),('2082-11-02'),('2082-11-03'),('2082-11-04'),('2082-11-05'),('2082-11-06'),('2082-11-07'),('2082-11-08'),('2082-11-09'),('2082-11-10'),('2082-11-11'),('2082-11-12'),('2082-11-13'),('2082-11-14'),('2082-11-15'),('2082-11-16'),('2082-11-17'),('2082-11-18'),('2082-11-19'),('2082-11-20'),('2082-11-21'),('2082-11-22'),('2082-11-23'),('2082-11-24'),('2082-11-25'),('2082-11-26'),('2082-11-27'),('2082-11-28'),('2082-11-29'),('2082-11-30'),('2082-12-01'),('2082-12-02'),('2082-12-03'),('2082-12-04'),('2082-12-05'),('2082-12-06'),('2082-12-07'),('2082-12-08'),('2082-12-09'),('2082-12-10'),('2082-12-11'),('2082-12-12'),('2082-12-13'),('2082-12-14'),('2082-12-15'),('2082-12-16'),('2082-12-17'),('2082-12-18'),('2082-12-19'),('2082-12-20'),('2082-12-21'),('2082-12-22'),('2082-12-23'),('2082-12-24'),('2082-12-25'),('2082-12-26'),('2082-12-27'),('2082-12-28'),('2082-12-29'),('2082-12-30'),('2082-12-31'),('2083-01-01'),('2083-01-02'),('2083-01-03'),('2083-01-04'),('2083-01-05'),('2083-01-06'),('2083-01-07'),('2083-01-08'),('2083-01-09'),('2083-01-10'),('2083-01-11'),('2083-01-12'),('2083-01-13'),('2083-01-14'),('2083-01-15'),('2083-01-16'),('2083-01-17'),('2083-01-18'),('2083-01-19'),('2083-01-20'),('2083-01-21'),('2083-01-22'),('2083-01-23'),('2083-01-24'),('2083-01-25'),('2083-01-26'),('2083-01-27'),('2083-01-28'),('2083-01-29'),('2083-01-30'),('2083-01-31'),('2083-02-01'),('2083-02-02'),('2083-02-03'),('2083-02-04'),('2083-02-05'),('2083-02-06'),('2083-02-07'),('2083-02-08'),('2083-02-09'),('2083-02-10'),('2083-02-11'),('2083-02-12'),('2083-02-13'),('2083-02-14'),('2083-02-15'),('2083-02-16'),('2083-02-17'),('2083-02-18'),('2083-02-19'),('2083-02-20'),('2083-02-21'),('2083-02-22'),('2083-02-23'),('2083-02-24'),('2083-02-25'),('2083-02-26'),('2083-02-27'),('2083-02-28'),('2083-03-01'),('2083-03-02'),('2083-03-03'),('2083-03-04'),('2083-03-05'),('2083-03-06'),('2083-03-07'),('2083-03-08'),('2083-03-09'),('2083-03-10'),('2083-03-11'),('2083-03-12'),('2083-03-13'),('2083-03-14'),('2083-03-15'),('2083-03-16'),('2083-03-17'),('2083-03-18'),('2083-03-19'),('2083-03-20'),('2083-03-21'),('2083-03-22'),('2083-03-23'),('2083-03-24'),('2083-03-25'),('2083-03-26'),('2083-03-27'),('2083-03-28'),('2083-03-29'),('2083-03-30'),('2083-03-31'),('2083-04-01'),('2083-04-02'),('2083-04-03'),('2083-04-04'),('2083-04-05'),('2083-04-06'),('2083-04-07'),('2083-04-08'),('2083-04-09'),('2083-04-10'),('2083-04-11'),('2083-04-12'),('2083-04-13'),('2083-04-14'),('2083-04-15'),('2083-04-16'),('2083-04-17'),('2083-04-18'),('2083-04-19'),('2083-04-20'),('2083-04-21'),('2083-04-22'),('2083-04-23'),('2083-04-24'),('2083-04-25'),('2083-04-26'),('2083-04-27'),('2083-04-28'),('2083-04-29'),('2083-04-30'),('2083-05-01'),('2083-05-02'),('2083-05-03'),('2083-05-04'),('2083-05-05'),('2083-05-06'),('2083-05-07'),('2083-05-08'),('2083-05-09'),('2083-05-10'),('2083-05-11'),('2083-05-12'),('2083-05-13'),('2083-05-14'),('2083-05-15'),('2083-05-16'),('2083-05-17'),('2083-05-18'),('2083-05-19'),('2083-05-20'),('2083-05-21'),('2083-05-22'),('2083-05-23'),('2083-05-24'),('2083-05-25'),('2083-05-26'),('2083-05-27'),('2083-05-28'),('2083-05-29'),('2083-05-30'),('2083-05-31'),('2083-06-01'),('2083-06-02'),('2083-06-03'),('2083-06-04'),('2083-06-05'),('2083-06-06'),('2083-06-07'),('2083-06-08'),('2083-06-09'),('2083-06-10'),('2083-06-11'),('2083-06-12'),('2083-06-13'),('2083-06-14'),('2083-06-15'),('2083-06-16'),('2083-06-17'),('2083-06-18'),('2083-06-19'),('2083-06-20'),('2083-06-21'),('2083-06-22'),('2083-06-23'),('2083-06-24'),('2083-06-25'),('2083-06-26'),('2083-06-27'),('2083-06-28'),('2083-06-29'),('2083-06-30'),('2083-07-01'),('2083-07-02'),('2083-07-03'),('2083-07-04'),('2083-07-05'),('2083-07-06'),('2083-07-07'),('2083-07-08'),('2083-07-09'),('2083-07-10'),('2083-07-11'),('2083-07-12'),('2083-07-13'),('2083-07-14'),('2083-07-15'),('2083-07-16'),('2083-07-17'),('2083-07-18'),('2083-07-19'),('2083-07-20'),('2083-07-21'),('2083-07-22'),('2083-07-23'),('2083-07-24'),('2083-07-25'),('2083-07-26'),('2083-07-27'),('2083-07-28'),('2083-07-29'),('2083-07-30'),('2083-07-31'),('2083-08-01'),('2083-08-02'),('2083-08-03'),('2083-08-04'),('2083-08-05'),('2083-08-06'),('2083-08-07'),('2083-08-08'),('2083-08-09'),('2083-08-10'),('2083-08-11'),('2083-08-12'),('2083-08-13'),('2083-08-14'),('2083-08-15'),('2083-08-16'),('2083-08-17'),('2083-08-18'),('2083-08-19'),('2083-08-20'),('2083-08-21'),('2083-08-22'),('2083-08-23'),('2083-08-24'),('2083-08-25'),('2083-08-26'),('2083-08-27'),('2083-08-28'),('2083-08-29'),('2083-08-30'),('2083-08-31'),('2083-09-01'),('2083-09-02'),('2083-09-03'),('2083-09-04'),('2083-09-05'),('2083-09-06'),('2083-09-07'),('2083-09-08'),('2083-09-09'),('2083-09-10'),('2083-09-11'),('2083-09-12'),('2083-09-13'),('2083-09-14'),('2083-09-15'),('2083-09-16'),('2083-09-17'),('2083-09-18'),('2083-09-19'),('2083-09-20'),('2083-09-21'),('2083-09-22'),('2083-09-23'),('2083-09-24'),('2083-09-25'),('2083-09-26'),('2083-09-27'),('2083-09-28'),('2083-09-29'),('2083-09-30'),('2083-10-01'),('2083-10-02'),('2083-10-03'),('2083-10-04'),('2083-10-05'),('2083-10-06'),('2083-10-07'),('2083-10-08'),('2083-10-09'),('2083-10-10'),('2083-10-11'),('2083-10-12'),('2083-10-13'),('2083-10-14'),('2083-10-15'),('2083-10-16'),('2083-10-17'),('2083-10-18'),('2083-10-19'),('2083-10-20'),('2083-10-21'),('2083-10-22'),('2083-10-23'),('2083-10-24'),('2083-10-25'),('2083-10-26'),('2083-10-27'),('2083-10-28'),('2083-10-29'),('2083-10-30'),('2083-10-31'),('2083-11-01'),('2083-11-02'),('2083-11-03'),('2083-11-04'),('2083-11-05'),('2083-11-06'),('2083-11-07'),('2083-11-08'),('2083-11-09'),('2083-11-10'),('2083-11-11'),('2083-11-12'),('2083-11-13'),('2083-11-14'),('2083-11-15'),('2083-11-16'),('2083-11-17'),('2083-11-18'),('2083-11-19'),('2083-11-20'),('2083-11-21'),('2083-11-22'),('2083-11-23'),('2083-11-24'),('2083-11-25'),('2083-11-26'),('2083-11-27'),('2083-11-28'),('2083-11-29'),('2083-11-30'),('2083-12-01'),('2083-12-02'),('2083-12-03'),('2083-12-04'),('2083-12-05'),('2083-12-06'),('2083-12-07'),('2083-12-08'),('2083-12-09'),('2083-12-10'),('2083-12-11'),('2083-12-12'),('2083-12-13'),('2083-12-14'),('2083-12-15'),('2083-12-16'),('2083-12-17'),('2083-12-18'),('2083-12-19'),('2083-12-20'),('2083-12-21'),('2083-12-22'),('2083-12-23'),('2083-12-24'),('2083-12-25'),('2083-12-26'),('2083-12-27'),('2083-12-28'),('2083-12-29'),('2083-12-30'),('2083-12-31'),('2084-01-01'),('2084-01-02'),('2084-01-03'),('2084-01-04'),('2084-01-05'),('2084-01-06'),('2084-01-07'),('2084-01-08'),('2084-01-09'),('2084-01-10'),('2084-01-11'),('2084-01-12'),('2084-01-13'),('2084-01-14'),('2084-01-15'),('2084-01-16'),('2084-01-17'),('2084-01-18'),('2084-01-19'),('2084-01-20'),('2084-01-21'),('2084-01-22'),('2084-01-23'),('2084-01-24'),('2084-01-25'),('2084-01-26'),('2084-01-27'),('2084-01-28'),('2084-01-29'),('2084-01-30'),('2084-01-31'),('2084-02-01'),('2084-02-02'),('2084-02-03'),('2084-02-04'),('2084-02-05'),('2084-02-06'),('2084-02-07'),('2084-02-08'),('2084-02-09'),('2084-02-10'),('2084-02-11'),('2084-02-12'),('2084-02-13'),('2084-02-14'),('2084-02-15'),('2084-02-16'),('2084-02-17'),('2084-02-18'),('2084-02-19'),('2084-02-20'),('2084-02-21'),('2084-02-22'),('2084-02-23'),('2084-02-24'),('2084-02-25'),('2084-02-26'),('2084-02-27'),('2084-02-28'),('2084-02-29'),('2084-03-01'),('2084-03-02'),('2084-03-03'),('2084-03-04'),('2084-03-05'),('2084-03-06'),('2084-03-07'),('2084-03-08'),('2084-03-09'),('2084-03-10'),('2084-03-11'),('2084-03-12'),('2084-03-13'),('2084-03-14'),('2084-03-15'),('2084-03-16'),('2084-03-17'),('2084-03-18'),('2084-03-19'),('2084-03-20'),('2084-03-21'),('2084-03-22'),('2084-03-23'),('2084-03-24'),('2084-03-25'),('2084-03-26'),('2084-03-27'),('2084-03-28'),('2084-03-29'),('2084-03-30'),('2084-03-31'),('2084-04-01'),('2084-04-02'),('2084-04-03'),('2084-04-04'),('2084-04-05'),('2084-04-06'),('2084-04-07'),('2084-04-08'),('2084-04-09'),('2084-04-10'),('2084-04-11'),('2084-04-12'),('2084-04-13'),('2084-04-14'),('2084-04-15'),('2084-04-16'),('2084-04-17'),('2084-04-18'),('2084-04-19'),('2084-04-20'),('2084-04-21'),('2084-04-22'),('2084-04-23'),('2084-04-24'),('2084-04-25'),('2084-04-26'),('2084-04-27'),('2084-04-28'),('2084-04-29'),('2084-04-30'),('2084-05-01'),('2084-05-02'),('2084-05-03'),('2084-05-04'),('2084-05-05'),('2084-05-06'),('2084-05-07'),('2084-05-08'),('2084-05-09'),('2084-05-10'),('2084-05-11'),('2084-05-12'),('2084-05-13'),('2084-05-14'),('2084-05-15'),('2084-05-16'),('2084-05-17'),('2084-05-18'),('2084-05-19'),('2084-05-20'),('2084-05-21'),('2084-05-22'),('2084-05-23'),('2084-05-24'),('2084-05-25'),('2084-05-26'),('2084-05-27'),('2084-05-28'),('2084-05-29'),('2084-05-30'),('2084-05-31'),('2084-06-01'),('2084-06-02'),('2084-06-03'),('2084-06-04'),('2084-06-05'),('2084-06-06'),('2084-06-07'),('2084-06-08'),('2084-06-09'),('2084-06-10'),('2084-06-11'),('2084-06-12'),('2084-06-13'),('2084-06-14'),('2084-06-15'),('2084-06-16'),('2084-06-17'),('2084-06-18'),('2084-06-19'),('2084-06-20'),('2084-06-21'),('2084-06-22'),('2084-06-23'),('2084-06-24'),('2084-06-25'),('2084-06-26'),('2084-06-27'),('2084-06-28'),('2084-06-29'),('2084-06-30'),('2084-07-01'),('2084-07-02'),('2084-07-03'),('2084-07-04'),('2084-07-05'),('2084-07-06'),('2084-07-07'),('2084-07-08'),('2084-07-09'),('2084-07-10'),('2084-07-11'),('2084-07-12'),('2084-07-13'),('2084-07-14'),('2084-07-15'),('2084-07-16'),('2084-07-17'),('2084-07-18'),('2084-07-19'),('2084-07-20'),('2084-07-21'),('2084-07-22'),('2084-07-23'),('2084-07-24'),('2084-07-25'),('2084-07-26'),('2084-07-27'),('2084-07-28'),('2084-07-29'),('2084-07-30'),('2084-07-31'),('2084-08-01'),('2084-08-02'),('2084-08-03'),('2084-08-04'),('2084-08-05'),('2084-08-06'),('2084-08-07'),('2084-08-08'),('2084-08-09'),('2084-08-10'),('2084-08-11'),('2084-08-12'),('2084-08-13'),('2084-08-14'),('2084-08-15'),('2084-08-16'),('2084-08-17'),('2084-08-18'),('2084-08-19'),('2084-08-20'),('2084-08-21'),('2084-08-22'),('2084-08-23'),('2084-08-24'),('2084-08-25'),('2084-08-26'),('2084-08-27'),('2084-08-28'),('2084-08-29'),('2084-08-30'),('2084-08-31'),('2084-09-01'),('2084-09-02'),('2084-09-03'),('2084-09-04'),('2084-09-05'),('2084-09-06'),('2084-09-07'),('2084-09-08'),('2084-09-09'),('2084-09-10'),('2084-09-11'),('2084-09-12'),('2084-09-13'),('2084-09-14'),('2084-09-15'),('2084-09-16'),('2084-09-17'),('2084-09-18'),('2084-09-19'),('2084-09-20'),('2084-09-21'),('2084-09-22'),('2084-09-23'),('2084-09-24'),('2084-09-25'),('2084-09-26'),('2084-09-27'),('2084-09-28'),('2084-09-29'),('2084-09-30'),('2084-10-01'),('2084-10-02'),('2084-10-03'),('2084-10-04'),('2084-10-05'),('2084-10-06'),('2084-10-07'),('2084-10-08'),('2084-10-09'),('2084-10-10'),('2084-10-11'),('2084-10-12'),('2084-10-13'),('2084-10-14'),('2084-10-15'),('2084-10-16'),('2084-10-17'),('2084-10-18'),('2084-10-19'),('2084-10-20'),('2084-10-21'),('2084-10-22'),('2084-10-23'),('2084-10-24'),('2084-10-25'),('2084-10-26'),('2084-10-27'),('2084-10-28'),('2084-10-29'),('2084-10-30'),('2084-10-31'),('2084-11-01'),('2084-11-02'),('2084-11-03'),('2084-11-04'),('2084-11-05'),('2084-11-06'),('2084-11-07'),('2084-11-08'),('2084-11-09'),('2084-11-10'),('2084-11-11'),('2084-11-12'),('2084-11-13'),('2084-11-14'),('2084-11-15'),('2084-11-16'),('2084-11-17'),('2084-11-18'),('2084-11-19'),('2084-11-20'),('2084-11-21'),('2084-11-22'),('2084-11-23'),('2084-11-24'),('2084-11-25'),('2084-11-26'),('2084-11-27'),('2084-11-28'),('2084-11-29'),('2084-11-30'),('2084-12-01'),('2084-12-02'),('2084-12-03'),('2084-12-04'),('2084-12-05'),('2084-12-06'),('2084-12-07'),('2084-12-08'),('2084-12-09'),('2084-12-10'),('2084-12-11'),('2084-12-12'),('2084-12-13'),('2084-12-14'),('2084-12-15'),('2084-12-16'),('2084-12-17'),('2084-12-18'),('2084-12-19'),('2084-12-20'),('2084-12-21'),('2084-12-22'),('2084-12-23'),('2084-12-24'),('2084-12-25'),('2084-12-26'),('2084-12-27'),('2084-12-28'),('2084-12-29'),('2084-12-30'),('2084-12-31'),('2085-01-01'),('2085-01-02'),('2085-01-03'),('2085-01-04'),('2085-01-05'),('2085-01-06'),('2085-01-07'),('2085-01-08'),('2085-01-09'),('2085-01-10'),('2085-01-11'),('2085-01-12'),('2085-01-13'),('2085-01-14'),('2085-01-15'),('2085-01-16'),('2085-01-17'),('2085-01-18'),('2085-01-19'),('2085-01-20'),('2085-01-21'),('2085-01-22'),('2085-01-23'),('2085-01-24'),('2085-01-25'),('2085-01-26'),('2085-01-27'),('2085-01-28'),('2085-01-29'),('2085-01-30'),('2085-01-31'),('2085-02-01'),('2085-02-02'),('2085-02-03'),('2085-02-04'),('2085-02-05'),('2085-02-06'),('2085-02-07'),('2085-02-08'),('2085-02-09'),('2085-02-10'),('2085-02-11'),('2085-02-12'),('2085-02-13'),('2085-02-14'),('2085-02-15'),('2085-02-16'),('2085-02-17'),('2085-02-18'),('2085-02-19'),('2085-02-20'),('2085-02-21'),('2085-02-22'),('2085-02-23'),('2085-02-24'),('2085-02-25'),('2085-02-26'),('2085-02-27'),('2085-02-28'),('2085-03-01'),('2085-03-02'),('2085-03-03'),('2085-03-04'),('2085-03-05'),('2085-03-06'),('2085-03-07'),('2085-03-08'),('2085-03-09'),('2085-03-10'),('2085-03-11'),('2085-03-12'),('2085-03-13'),('2085-03-14'),('2085-03-15'),('2085-03-16'),('2085-03-17'),('2085-03-18'),('2085-03-19'),('2085-03-20'),('2085-03-21'),('2085-03-22'),('2085-03-23'),('2085-03-24'),('2085-03-25'),('2085-03-26'),('2085-03-27'),('2085-03-28'),('2085-03-29'),('2085-03-30'),('2085-03-31'),('2085-04-01'),('2085-04-02'),('2085-04-03'),('2085-04-04'),('2085-04-05'),('2085-04-06'),('2085-04-07'),('2085-04-08'),('2085-04-09'),('2085-04-10'),('2085-04-11'),('2085-04-12'),('2085-04-13'),('2085-04-14'),('2085-04-15'),('2085-04-16'),('2085-04-17'),('2085-04-18'),('2085-04-19'),('2085-04-20'),('2085-04-21'),('2085-04-22'),('2085-04-23'),('2085-04-24'),('2085-04-25'),('2085-04-26'),('2085-04-27'),('2085-04-28'),('2085-04-29'),('2085-04-30'),('2085-05-01'),('2085-05-02'),('2085-05-03'),('2085-05-04'),('2085-05-05'),('2085-05-06'),('2085-05-07'),('2085-05-08'),('2085-05-09'),('2085-05-10'),('2085-05-11'),('2085-05-12'),('2085-05-13'),('2085-05-14'),('2085-05-15'),('2085-05-16'),('2085-05-17'),('2085-05-18'),('2085-05-19'),('2085-05-20'),('2085-05-21'),('2085-05-22'),('2085-05-23'),('2085-05-24'),('2085-05-25'),('2085-05-26'),('2085-05-27'),('2085-05-28'),('2085-05-29'),('2085-05-30'),('2085-05-31'),('2085-06-01'),('2085-06-02'),('2085-06-03'),('2085-06-04'),('2085-06-05'),('2085-06-06'),('2085-06-07'),('2085-06-08'),('2085-06-09'),('2085-06-10'),('2085-06-11'),('2085-06-12'),('2085-06-13'),('2085-06-14'),('2085-06-15'),('2085-06-16'),('2085-06-17'),('2085-06-18'),('2085-06-19'),('2085-06-20'),('2085-06-21'),('2085-06-22'),('2085-06-23'),('2085-06-24'),('2085-06-25'),('2085-06-26'),('2085-06-27'),('2085-06-28'),('2085-06-29'),('2085-06-30'),('2085-07-01'),('2085-07-02'),('2085-07-03'),('2085-07-04'),('2085-07-05'),('2085-07-06'),('2085-07-07'),('2085-07-08'),('2085-07-09'),('2085-07-10'),('2085-07-11'),('2085-07-12'),('2085-07-13'),('2085-07-14'),('2085-07-15'),('2085-07-16'),('2085-07-17'),('2085-07-18'),('2085-07-19'),('2085-07-20'),('2085-07-21'),('2085-07-22'),('2085-07-23'),('2085-07-24'),('2085-07-25'),('2085-07-26'),('2085-07-27'),('2085-07-28'),('2085-07-29'),('2085-07-30'),('2085-07-31'),('2085-08-01'),('2085-08-02'),('2085-08-03'),('2085-08-04'),('2085-08-05'),('2085-08-06'),('2085-08-07'),('2085-08-08'),('2085-08-09'),('2085-08-10'),('2085-08-11'),('2085-08-12'),('2085-08-13'),('2085-08-14'),('2085-08-15'),('2085-08-16'),('2085-08-17'),('2085-08-18'),('2085-08-19'),('2085-08-20'),('2085-08-21'),('2085-08-22'),('2085-08-23'),('2085-08-24'),('2085-08-25'),('2085-08-26'),('2085-08-27'),('2085-08-28'),('2085-08-29'),('2085-08-30'),('2085-08-31'),('2085-09-01'),('2085-09-02'),('2085-09-03'),('2085-09-04'),('2085-09-05'),('2085-09-06'),('2085-09-07'),('2085-09-08'),('2085-09-09'),('2085-09-10'),('2085-09-11'),('2085-09-12'),('2085-09-13'),('2085-09-14'),('2085-09-15'),('2085-09-16'),('2085-09-17'),('2085-09-18'),('2085-09-19'),('2085-09-20'),('2085-09-21'),('2085-09-22'),('2085-09-23'),('2085-09-24'),('2085-09-25'),('2085-09-26'),('2085-09-27'),('2085-09-28'),('2085-09-29'),('2085-09-30'),('2085-10-01'),('2085-10-02'),('2085-10-03'),('2085-10-04'),('2085-10-05'),('2085-10-06'),('2085-10-07'),('2085-10-08'),('2085-10-09'),('2085-10-10'),('2085-10-11'),('2085-10-12'),('2085-10-13'),('2085-10-14'),('2085-10-15'),('2085-10-16'),('2085-10-17'),('2085-10-18'),('2085-10-19'),('2085-10-20'),('2085-10-21'),('2085-10-22'),('2085-10-23'),('2085-10-24'),('2085-10-25'),('2085-10-26'),('2085-10-27'),('2085-10-28'),('2085-10-29'),('2085-10-30'),('2085-10-31'),('2085-11-01'),('2085-11-02'),('2085-11-03'),('2085-11-04'),('2085-11-05'),('2085-11-06'),('2085-11-07'),('2085-11-08'),('2085-11-09'),('2085-11-10'),('2085-11-11'),('2085-11-12'),('2085-11-13'),('2085-11-14'),('2085-11-15'),('2085-11-16'),('2085-11-17'),('2085-11-18'),('2085-11-19'),('2085-11-20'),('2085-11-21'),('2085-11-22'),('2085-11-23'),('2085-11-24'),('2085-11-25'),('2085-11-26'),('2085-11-27'),('2085-11-28'),('2085-11-29'),('2085-11-30'),('2085-12-01'),('2085-12-02'),('2085-12-03'),('2085-12-04'),('2085-12-05'),('2085-12-06'),('2085-12-07'),('2085-12-08'),('2085-12-09'),('2085-12-10'),('2085-12-11'),('2085-12-12'),('2085-12-13'),('2085-12-14'),('2085-12-15'),('2085-12-16'),('2085-12-17'),('2085-12-18'),('2085-12-19'),('2085-12-20'),('2085-12-21'),('2085-12-22'),('2085-12-23'),('2085-12-24'),('2085-12-25'),('2085-12-26'),('2085-12-27'),('2085-12-28'),('2085-12-29'),('2085-12-30'),('2085-12-31'),('2086-01-01'),('2086-01-02'),('2086-01-03'),('2086-01-04'),('2086-01-05'),('2086-01-06'),('2086-01-07'),('2086-01-08'),('2086-01-09'),('2086-01-10'),('2086-01-11'),('2086-01-12'),('2086-01-13'),('2086-01-14'),('2086-01-15'),('2086-01-16'),('2086-01-17'),('2086-01-18'),('2086-01-19'),('2086-01-20'),('2086-01-21'),('2086-01-22'),('2086-01-23'),('2086-01-24'),('2086-01-25'),('2086-01-26'),('2086-01-27'),('2086-01-28'),('2086-01-29'),('2086-01-30'),('2086-01-31'),('2086-02-01'),('2086-02-02'),('2086-02-03'),('2086-02-04'),('2086-02-05'),('2086-02-06'),('2086-02-07'),('2086-02-08'),('2086-02-09'),('2086-02-10'),('2086-02-11'),('2086-02-12'),('2086-02-13'),('2086-02-14'),('2086-02-15'),('2086-02-16'),('2086-02-17'),('2086-02-18'),('2086-02-19'),('2086-02-20'),('2086-02-21'),('2086-02-22'),('2086-02-23'),('2086-02-24'),('2086-02-25'),('2086-02-26'),('2086-02-27'),('2086-02-28'),('2086-03-01'),('2086-03-02'),('2086-03-03'),('2086-03-04'),('2086-03-05'),('2086-03-06'),('2086-03-07'),('2086-03-08'),('2086-03-09'),('2086-03-10'),('2086-03-11'),('2086-03-12'),('2086-03-13'),('2086-03-14'),('2086-03-15'),('2086-03-16'),('2086-03-17'),('2086-03-18'),('2086-03-19'),('2086-03-20'),('2086-03-21'),('2086-03-22'),('2086-03-23'),('2086-03-24'),('2086-03-25'),('2086-03-26'),('2086-03-27'),('2086-03-28'),('2086-03-29'),('2086-03-30'),('2086-03-31'),('2086-04-01'),('2086-04-02'),('2086-04-03'),('2086-04-04'),('2086-04-05'),('2086-04-06'),('2086-04-07'),('2086-04-08'),('2086-04-09'),('2086-04-10'),('2086-04-11'),('2086-04-12'),('2086-04-13'),('2086-04-14'),('2086-04-15'),('2086-04-16'),('2086-04-17'),('2086-04-18'),('2086-04-19'),('2086-04-20'),('2086-04-21'),('2086-04-22'),('2086-04-23'),('2086-04-24'),('2086-04-25'),('2086-04-26'),('2086-04-27'),('2086-04-28'),('2086-04-29'),('2086-04-30'),('2086-05-01'),('2086-05-02'),('2086-05-03'),('2086-05-04'),('2086-05-05'),('2086-05-06'),('2086-05-07'),('2086-05-08'),('2086-05-09'),('2086-05-10'),('2086-05-11'),('2086-05-12'),('2086-05-13'),('2086-05-14'),('2086-05-15'),('2086-05-16'),('2086-05-17'),('2086-05-18'),('2086-05-19'),('2086-05-20'),('2086-05-21'),('2086-05-22'),('2086-05-23'),('2086-05-24'),('2086-05-25'),('2086-05-26'),('2086-05-27'),('2086-05-28'),('2086-05-29'),('2086-05-30'),('2086-05-31'),('2086-06-01'),('2086-06-02'),('2086-06-03'),('2086-06-04'),('2086-06-05'),('2086-06-06'),('2086-06-07'),('2086-06-08'),('2086-06-09'),('2086-06-10'),('2086-06-11'),('2086-06-12'),('2086-06-13'),('2086-06-14'),('2086-06-15'),('2086-06-16'),('2086-06-17'),('2086-06-18'),('2086-06-19'),('2086-06-20'),('2086-06-21'),('2086-06-22'),('2086-06-23'),('2086-06-24'),('2086-06-25'),('2086-06-26'),('2086-06-27'),('2086-06-28'),('2086-06-29'),('2086-06-30'),('2086-07-01'),('2086-07-02'),('2086-07-03'),('2086-07-04'),('2086-07-05'),('2086-07-06'),('2086-07-07'),('2086-07-08'),('2086-07-09'),('2086-07-10'),('2086-07-11'),('2086-07-12'),('2086-07-13'),('2086-07-14'),('2086-07-15'),('2086-07-16'),('2086-07-17'),('2086-07-18'),('2086-07-19'),('2086-07-20'),('2086-07-21'),('2086-07-22'),('2086-07-23'),('2086-07-24'),('2086-07-25'),('2086-07-26'),('2086-07-27'),('2086-07-28'),('2086-07-29'),('2086-07-30'),('2086-07-31'),('2086-08-01'),('2086-08-02'),('2086-08-03'),('2086-08-04'),('2086-08-05'),('2086-08-06'),('2086-08-07'),('2086-08-08'),('2086-08-09'),('2086-08-10'),('2086-08-11'),('2086-08-12'),('2086-08-13'),('2086-08-14'),('2086-08-15'),('2086-08-16'),('2086-08-17'),('2086-08-18'),('2086-08-19'),('2086-08-20'),('2086-08-21'),('2086-08-22'),('2086-08-23'),('2086-08-24'),('2086-08-25'),('2086-08-26'),('2086-08-27'),('2086-08-28'),('2086-08-29'),('2086-08-30'),('2086-08-31'),('2086-09-01'),('2086-09-02'),('2086-09-03'),('2086-09-04'),('2086-09-05'),('2086-09-06'),('2086-09-07'),('2086-09-08'),('2086-09-09'),('2086-09-10'),('2086-09-11'),('2086-09-12'),('2086-09-13'),('2086-09-14'),('2086-09-15'),('2086-09-16'),('2086-09-17'),('2086-09-18'),('2086-09-19'),('2086-09-20'),('2086-09-21'),('2086-09-22'),('2086-09-23'),('2086-09-24'),('2086-09-25'),('2086-09-26'),('2086-09-27'),('2086-09-28'),('2086-09-29'),('2086-09-30'),('2086-10-01'),('2086-10-02'),('2086-10-03'),('2086-10-04'),('2086-10-05'),('2086-10-06'),('2086-10-07'),('2086-10-08'),('2086-10-09'),('2086-10-10'),('2086-10-11'),('2086-10-12'),('2086-10-13'),('2086-10-14'),('2086-10-15'),('2086-10-16'),('2086-10-17'),('2086-10-18'),('2086-10-19'),('2086-10-20'),('2086-10-21'),('2086-10-22'),('2086-10-23'),('2086-10-24'),('2086-10-25'),('2086-10-26'),('2086-10-27'),('2086-10-28'),('2086-10-29'),('2086-10-30'),('2086-10-31'),('2086-11-01'),('2086-11-02'),('2086-11-03'),('2086-11-04'),('2086-11-05'),('2086-11-06'),('2086-11-07'),('2086-11-08'),('2086-11-09'),('2086-11-10'),('2086-11-11'),('2086-11-12'),('2086-11-13'),('2086-11-14'),('2086-11-15'),('2086-11-16'),('2086-11-17'),('2086-11-18'),('2086-11-19'),('2086-11-20'),('2086-11-21'),('2086-11-22'),('2086-11-23'),('2086-11-24'),('2086-11-25'),('2086-11-26'),('2086-11-27'),('2086-11-28'),('2086-11-29'),('2086-11-30'),('2086-12-01'),('2086-12-02'),('2086-12-03'),('2086-12-04'),('2086-12-05'),('2086-12-06'),('2086-12-07'),('2086-12-08'),('2086-12-09'),('2086-12-10'),('2086-12-11'),('2086-12-12'),('2086-12-13'),('2086-12-14'),('2086-12-15'),('2086-12-16'),('2086-12-17'),('2086-12-18'),('2086-12-19'),('2086-12-20'),('2086-12-21'),('2086-12-22'),('2086-12-23'),('2086-12-24'),('2086-12-25'),('2086-12-26'),('2086-12-27'),('2086-12-28'),('2086-12-29'),('2086-12-30'),('2086-12-31'),('2087-01-01'),('2087-01-02'),('2087-01-03'),('2087-01-04'),('2087-01-05'),('2087-01-06'),('2087-01-07'),('2087-01-08'),('2087-01-09'),('2087-01-10'),('2087-01-11'),('2087-01-12'),('2087-01-13'),('2087-01-14'),('2087-01-15'),('2087-01-16'),('2087-01-17'),('2087-01-18'),('2087-01-19'),('2087-01-20'),('2087-01-21'),('2087-01-22'),('2087-01-23'),('2087-01-24'),('2087-01-25'),('2087-01-26'),('2087-01-27'),('2087-01-28'),('2087-01-29'),('2087-01-30'),('2087-01-31'),('2087-02-01'),('2087-02-02'),('2087-02-03'),('2087-02-04'),('2087-02-05'),('2087-02-06'),('2087-02-07'),('2087-02-08'),('2087-02-09'),('2087-02-10'),('2087-02-11'),('2087-02-12'),('2087-02-13'),('2087-02-14'),('2087-02-15'),('2087-02-16'),('2087-02-17'),('2087-02-18'),('2087-02-19'),('2087-02-20'),('2087-02-21'),('2087-02-22'),('2087-02-23'),('2087-02-24'),('2087-02-25'),('2087-02-26'),('2087-02-27'),('2087-02-28'),('2087-03-01'),('2087-03-02'),('2087-03-03'),('2087-03-04'),('2087-03-05'),('2087-03-06'),('2087-03-07'),('2087-03-08'),('2087-03-09'),('2087-03-10'),('2087-03-11'),('2087-03-12'),('2087-03-13'),('2087-03-14'),('2087-03-15'),('2087-03-16'),('2087-03-17'),('2087-03-18'),('2087-03-19'),('2087-03-20'),('2087-03-21'),('2087-03-22'),('2087-03-23'),('2087-03-24'),('2087-03-25'),('2087-03-26'),('2087-03-27'),('2087-03-28'),('2087-03-29'),('2087-03-30'),('2087-03-31'),('2087-04-01'),('2087-04-02'),('2087-04-03'),('2087-04-04'),('2087-04-05'),('2087-04-06'),('2087-04-07'),('2087-04-08'),('2087-04-09'),('2087-04-10'),('2087-04-11'),('2087-04-12'),('2087-04-13'),('2087-04-14'),('2087-04-15'),('2087-04-16'),('2087-04-17'),('2087-04-18'),('2087-04-19'),('2087-04-20'),('2087-04-21'),('2087-04-22'),('2087-04-23'),('2087-04-24'),('2087-04-25'),('2087-04-26'),('2087-04-27'),('2087-04-28'),('2087-04-29'),('2087-04-30'),('2087-05-01'),('2087-05-02'),('2087-05-03'),('2087-05-04'),('2087-05-05'),('2087-05-06'),('2087-05-07'),('2087-05-08'),('2087-05-09'),('2087-05-10'),('2087-05-11'),('2087-05-12'),('2087-05-13'),('2087-05-14'),('2087-05-15'),('2087-05-16'),('2087-05-17'),('2087-05-18'),('2087-05-19'),('2087-05-20'),('2087-05-21'),('2087-05-22'),('2087-05-23'),('2087-05-24'),('2087-05-25'),('2087-05-26'),('2087-05-27'),('2087-05-28'),('2087-05-29'),('2087-05-30'),('2087-05-31'),('2087-06-01'),('2087-06-02'),('2087-06-03'),('2087-06-04'),('2087-06-05'),('2087-06-06'),('2087-06-07'),('2087-06-08'),('2087-06-09'),('2087-06-10'),('2087-06-11'),('2087-06-12'),('2087-06-13'),('2087-06-14'),('2087-06-15'),('2087-06-16'),('2087-06-17'),('2087-06-18'),('2087-06-19'),('2087-06-20'),('2087-06-21'),('2087-06-22'),('2087-06-23'),('2087-06-24'),('2087-06-25'),('2087-06-26'),('2087-06-27'),('2087-06-28'),('2087-06-29'),('2087-06-30'),('2087-07-01'),('2087-07-02'),('2087-07-03'),('2087-07-04'),('2087-07-05'),('2087-07-06'),('2087-07-07'),('2087-07-08'),('2087-07-09'),('2087-07-10'),('2087-07-11'),('2087-07-12'),('2087-07-13'),('2087-07-14'),('2087-07-15'),('2087-07-16'),('2087-07-17'),('2087-07-18'),('2087-07-19'),('2087-07-20'),('2087-07-21'),('2087-07-22'),('2087-07-23'),('2087-07-24'),('2087-07-25'),('2087-07-26'),('2087-07-27'),('2087-07-28'),('2087-07-29'),('2087-07-30'),('2087-07-31'),('2087-08-01'),('2087-08-02'),('2087-08-03'),('2087-08-04'),('2087-08-05'),('2087-08-06'),('2087-08-07'),('2087-08-08'),('2087-08-09'),('2087-08-10'),('2087-08-11'),('2087-08-12'),('2087-08-13'),('2087-08-14'),('2087-08-15'),('2087-08-16'),('2087-08-17'),('2087-08-18'),('2087-08-19'),('2087-08-20'),('2087-08-21'),('2087-08-22'),('2087-08-23'),('2087-08-24'),('2087-08-25'),('2087-08-26'),('2087-08-27'),('2087-08-28'),('2087-08-29'),('2087-08-30'),('2087-08-31'),('2087-09-01'),('2087-09-02'),('2087-09-03'),('2087-09-04'),('2087-09-05'),('2087-09-06'),('2087-09-07'),('2087-09-08'),('2087-09-09'),('2087-09-10'),('2087-09-11'),('2087-09-12'),('2087-09-13'),('2087-09-14'),('2087-09-15'),('2087-09-16'),('2087-09-17'),('2087-09-18'),('2087-09-19'),('2087-09-20'),('2087-09-21'),('2087-09-22'),('2087-09-23'),('2087-09-24'),('2087-09-25'),('2087-09-26'),('2087-09-27'),('2087-09-28'),('2087-09-29'),('2087-09-30'),('2087-10-01'),('2087-10-02'),('2087-10-03'),('2087-10-04'),('2087-10-05'),('2087-10-06'),('2087-10-07'),('2087-10-08'),('2087-10-09'),('2087-10-10'),('2087-10-11'),('2087-10-12'),('2087-10-13'),('2087-10-14'),('2087-10-15'),('2087-10-16'),('2087-10-17'),('2087-10-18'),('2087-10-19'),('2087-10-20'),('2087-10-21'),('2087-10-22'),('2087-10-23'),('2087-10-24'),('2087-10-25'),('2087-10-26'),('2087-10-27'),('2087-10-28'),('2087-10-29'),('2087-10-30'),('2087-10-31'),('2087-11-01'),('2087-11-02'),('2087-11-03'),('2087-11-04'),('2087-11-05'),('2087-11-06'),('2087-11-07'),('2087-11-08'),('2087-11-09'),('2087-11-10'),('2087-11-11'),('2087-11-12'),('2087-11-13'),('2087-11-14'),('2087-11-15'),('2087-11-16'),('2087-11-17'),('2087-11-18'),('2087-11-19'),('2087-11-20'),('2087-11-21'),('2087-11-22'),('2087-11-23'),('2087-11-24'),('2087-11-25'),('2087-11-26'),('2087-11-27'),('2087-11-28'),('2087-11-29'),('2087-11-30'),('2087-12-01'),('2087-12-02'),('2087-12-03'),('2087-12-04'),('2087-12-05'),('2087-12-06'),('2087-12-07'),('2087-12-08'),('2087-12-09'),('2087-12-10'),('2087-12-11'),('2087-12-12'),('2087-12-13'),('2087-12-14'),('2087-12-15'),('2087-12-16'),('2087-12-17'),('2087-12-18'),('2087-12-19'),('2087-12-20'),('2087-12-21'),('2087-12-22'),('2087-12-23'),('2087-12-24'),('2087-12-25'),('2087-12-26'),('2087-12-27'),('2087-12-28'),('2087-12-29'),('2087-12-30'),('2087-12-31'),('2088-01-01'),('2088-01-02'),('2088-01-03'),('2088-01-04'),('2088-01-05'),('2088-01-06'),('2088-01-07'),('2088-01-08'),('2088-01-09'),('2088-01-10'),('2088-01-11'),('2088-01-12'),('2088-01-13'),('2088-01-14'),('2088-01-15'),('2088-01-16'),('2088-01-17'),('2088-01-18'),('2088-01-19'),('2088-01-20'),('2088-01-21'),('2088-01-22'),('2088-01-23'),('2088-01-24'),('2088-01-25'),('2088-01-26'),('2088-01-27'),('2088-01-28'),('2088-01-29'),('2088-01-30'),('2088-01-31'),('2088-02-01'),('2088-02-02'),('2088-02-03'),('2088-02-04'),('2088-02-05'),('2088-02-06'),('2088-02-07'),('2088-02-08'),('2088-02-09'),('2088-02-10'),('2088-02-11'),('2088-02-12'),('2088-02-13'),('2088-02-14'),('2088-02-15'),('2088-02-16'),('2088-02-17'),('2088-02-18'),('2088-02-19'),('2088-02-20'),('2088-02-21'),('2088-02-22'),('2088-02-23'),('2088-02-24'),('2088-02-25'),('2088-02-26'),('2088-02-27'),('2088-02-28'),('2088-02-29'),('2088-03-01'),('2088-03-02'),('2088-03-03'),('2088-03-04'),('2088-03-05'),('2088-03-06'),('2088-03-07'),('2088-03-08'),('2088-03-09'),('2088-03-10'),('2088-03-11'),('2088-03-12'),('2088-03-13'),('2088-03-14'),('2088-03-15'),('2088-03-16'),('2088-03-17'),('2088-03-18'),('2088-03-19'),('2088-03-20'),('2088-03-21'),('2088-03-22'),('2088-03-23'),('2088-03-24'),('2088-03-25'),('2088-03-26'),('2088-03-27'),('2088-03-28'),('2088-03-29'),('2088-03-30'),('2088-03-31'),('2088-04-01'),('2088-04-02'),('2088-04-03'),('2088-04-04'),('2088-04-05'),('2088-04-06'),('2088-04-07'),('2088-04-08'),('2088-04-09'),('2088-04-10'),('2088-04-11'),('2088-04-12'),('2088-04-13'),('2088-04-14'),('2088-04-15'),('2088-04-16'),('2088-04-17'),('2088-04-18'),('2088-04-19'),('2088-04-20'),('2088-04-21'),('2088-04-22'),('2088-04-23'),('2088-04-24'),('2088-04-25'),('2088-04-26'),('2088-04-27'),('2088-04-28'),('2088-04-29'),('2088-04-30'),('2088-05-01'),('2088-05-02'),('2088-05-03'),('2088-05-04'),('2088-05-05'),('2088-05-06'),('2088-05-07'),('2088-05-08'),('2088-05-09'),('2088-05-10'),('2088-05-11'),('2088-05-12'),('2088-05-13'),('2088-05-14'),('2088-05-15'),('2088-05-16'),('2088-05-17'),('2088-05-18'),('2088-05-19'),('2088-05-20'),('2088-05-21'),('2088-05-22'),('2088-05-23'),('2088-05-24'),('2088-05-25'),('2088-05-26'),('2088-05-27'),('2088-05-28'),('2088-05-29'),('2088-05-30'),('2088-05-31'),('2088-06-01'),('2088-06-02'),('2088-06-03'),('2088-06-04'),('2088-06-05'),('2088-06-06'),('2088-06-07'),('2088-06-08'),('2088-06-09'),('2088-06-10'),('2088-06-11'),('2088-06-12'),('2088-06-13'),('2088-06-14'),('2088-06-15'),('2088-06-16'),('2088-06-17'),('2088-06-18'),('2088-06-19'),('2088-06-20'),('2088-06-21'),('2088-06-22'),('2088-06-23'),('2088-06-24'),('2088-06-25'),('2088-06-26'),('2088-06-27'),('2088-06-28'),('2088-06-29'),('2088-06-30'),('2088-07-01'),('2088-07-02'),('2088-07-03'),('2088-07-04'),('2088-07-05'),('2088-07-06'),('2088-07-07'),('2088-07-08'),('2088-07-09'),('2088-07-10'),('2088-07-11'),('2088-07-12'),('2088-07-13'),('2088-07-14'),('2088-07-15'),('2088-07-16'),('2088-07-17'),('2088-07-18'),('2088-07-19'),('2088-07-20'),('2088-07-21'),('2088-07-22'),('2088-07-23'),('2088-07-24'),('2088-07-25'),('2088-07-26'),('2088-07-27'),('2088-07-28'),('2088-07-29'),('2088-07-30'),('2088-07-31'),('2088-08-01'),('2088-08-02'),('2088-08-03'),('2088-08-04'),('2088-08-05'),('2088-08-06'),('2088-08-07'),('2088-08-08'),('2088-08-09'),('2088-08-10'),('2088-08-11'),('2088-08-12'),('2088-08-13'),('2088-08-14'),('2088-08-15'),('2088-08-16'),('2088-08-17'),('2088-08-18'),('2088-08-19'),('2088-08-20'),('2088-08-21'),('2088-08-22'),('2088-08-23'),('2088-08-24'),('2088-08-25'),('2088-08-26'),('2088-08-27'),('2088-08-28'),('2088-08-29'),('2088-08-30'),('2088-08-31'),('2088-09-01'),('2088-09-02'),('2088-09-03'),('2088-09-04'),('2088-09-05'),('2088-09-06'),('2088-09-07'),('2088-09-08'),('2088-09-09'),('2088-09-10'),('2088-09-11'),('2088-09-12'),('2088-09-13'),('2088-09-14'),('2088-09-15'),('2088-09-16'),('2088-09-17'),('2088-09-18'),('2088-09-19'),('2088-09-20'),('2088-09-21'),('2088-09-22'),('2088-09-23'),('2088-09-24'),('2088-09-25'),('2088-09-26'),('2088-09-27'),('2088-09-28'),('2088-09-29'),('2088-09-30'),('2088-10-01'),('2088-10-02'),('2088-10-03'),('2088-10-04'),('2088-10-05'),('2088-10-06'),('2088-10-07'),('2088-10-08'),('2088-10-09'),('2088-10-10'),('2088-10-11'),('2088-10-12'),('2088-10-13'),('2088-10-14'),('2088-10-15'),('2088-10-16'),('2088-10-17'),('2088-10-18'),('2088-10-19'),('2088-10-20'),('2088-10-21'),('2088-10-22'),('2088-10-23'),('2088-10-24'),('2088-10-25'),('2088-10-26'),('2088-10-27'),('2088-10-28'),('2088-10-29'),('2088-10-30'),('2088-10-31'),('2088-11-01'),('2088-11-02'),('2088-11-03'),('2088-11-04'),('2088-11-05'),('2088-11-06'),('2088-11-07'),('2088-11-08'),('2088-11-09'),('2088-11-10'),('2088-11-11'),('2088-11-12'),('2088-11-13'),('2088-11-14'),('2088-11-15'),('2088-11-16'),('2088-11-17'),('2088-11-18'),('2088-11-19'),('2088-11-20'),('2088-11-21'),('2088-11-22'),('2088-11-23'),('2088-11-24'),('2088-11-25'),('2088-11-26'),('2088-11-27'),('2088-11-28'),('2088-11-29'),('2088-11-30'),('2088-12-01'),('2088-12-02'),('2088-12-03'),('2088-12-04'),('2088-12-05'),('2088-12-06'),('2088-12-07'),('2088-12-08'),('2088-12-09'),('2088-12-10'),('2088-12-11'),('2088-12-12'),('2088-12-13'),('2088-12-14'),('2088-12-15'),('2088-12-16'),('2088-12-17'),('2088-12-18'),('2088-12-19'),('2088-12-20'),('2088-12-21'),('2088-12-22'),('2088-12-23'),('2088-12-24'),('2088-12-25'),('2088-12-26'),('2088-12-27'),('2088-12-28'),('2088-12-29'),('2088-12-30'),('2088-12-31'),('2089-01-01'),('2089-01-02'),('2089-01-03'),('2089-01-04'),('2089-01-05'),('2089-01-06'),('2089-01-07'),('2089-01-08'),('2089-01-09'),('2089-01-10'),('2089-01-11'),('2089-01-12'),('2089-01-13'),('2089-01-14'),('2089-01-15'),('2089-01-16'),('2089-01-17'),('2089-01-18'),('2089-01-19'),('2089-01-20'),('2089-01-21'),('2089-01-22'),('2089-01-23'),('2089-01-24'),('2089-01-25'),('2089-01-26'),('2089-01-27'),('2089-01-28'),('2089-01-29'),('2089-01-30'),('2089-01-31'),('2089-02-01'),('2089-02-02'),('2089-02-03'),('2089-02-04'),('2089-02-05'),('2089-02-06'),('2089-02-07'),('2089-02-08'),('2089-02-09'),('2089-02-10'),('2089-02-11'),('2089-02-12'),('2089-02-13'),('2089-02-14'),('2089-02-15'),('2089-02-16'),('2089-02-17'),('2089-02-18'),('2089-02-19'),('2089-02-20'),('2089-02-21'),('2089-02-22'),('2089-02-23'),('2089-02-24'),('2089-02-25'),('2089-02-26'),('2089-02-27'),('2089-02-28'),('2089-03-01'),('2089-03-02'),('2089-03-03'),('2089-03-04'),('2089-03-05'),('2089-03-06'),('2089-03-07'),('2089-03-08'),('2089-03-09'),('2089-03-10'),('2089-03-11'),('2089-03-12'),('2089-03-13'),('2089-03-14'),('2089-03-15'),('2089-03-16'),('2089-03-17'),('2089-03-18'),('2089-03-19'),('2089-03-20'),('2089-03-21'),('2089-03-22'),('2089-03-23'),('2089-03-24'),('2089-03-25'),('2089-03-26'),('2089-03-27'),('2089-03-28'),('2089-03-29'),('2089-03-30'),('2089-03-31'),('2089-04-01'),('2089-04-02'),('2089-04-03'),('2089-04-04'),('2089-04-05'),('2089-04-06'),('2089-04-07'),('2089-04-08'),('2089-04-09'),('2089-04-10'),('2089-04-11'),('2089-04-12'),('2089-04-13'),('2089-04-14'),('2089-04-15'),('2089-04-16'),('2089-04-17'),('2089-04-18'),('2089-04-19'),('2089-04-20'),('2089-04-21'),('2089-04-22'),('2089-04-23'),('2089-04-24'),('2089-04-25'),('2089-04-26'),('2089-04-27'),('2089-04-28'),('2089-04-29'),('2089-04-30'),('2089-05-01'),('2089-05-02'),('2089-05-03'),('2089-05-04'),('2089-05-05'),('2089-05-06'),('2089-05-07'),('2089-05-08'),('2089-05-09'),('2089-05-10'),('2089-05-11'),('2089-05-12'),('2089-05-13'),('2089-05-14'),('2089-05-15'),('2089-05-16'),('2089-05-17'),('2089-05-18'),('2089-05-19'),('2089-05-20'),('2089-05-21'),('2089-05-22'),('2089-05-23'),('2089-05-24'),('2089-05-25'),('2089-05-26'),('2089-05-27'),('2089-05-28'),('2089-05-29'),('2089-05-30'),('2089-05-31'),('2089-06-01'),('2089-06-02'),('2089-06-03'),('2089-06-04'),('2089-06-05'),('2089-06-06'),('2089-06-07'),('2089-06-08'),('2089-06-09'),('2089-06-10'),('2089-06-11'),('2089-06-12'),('2089-06-13'),('2089-06-14'),('2089-06-15'),('2089-06-16'),('2089-06-17'),('2089-06-18'),('2089-06-19'),('2089-06-20'),('2089-06-21'),('2089-06-22'),('2089-06-23'),('2089-06-24'),('2089-06-25'),('2089-06-26'),('2089-06-27'),('2089-06-28'),('2089-06-29'),('2089-06-30'),('2089-07-01'),('2089-07-02'),('2089-07-03'),('2089-07-04'),('2089-07-05'),('2089-07-06'),('2089-07-07'),('2089-07-08'),('2089-07-09'),('2089-07-10'),('2089-07-11'),('2089-07-12'),('2089-07-13'),('2089-07-14'),('2089-07-15'),('2089-07-16'),('2089-07-17'),('2089-07-18'),('2089-07-19'),('2089-07-20'),('2089-07-21'),('2089-07-22'),('2089-07-23'),('2089-07-24'),('2089-07-25'),('2089-07-26'),('2089-07-27'),('2089-07-28'),('2089-07-29'),('2089-07-30'),('2089-07-31'),('2089-08-01'),('2089-08-02'),('2089-08-03'),('2089-08-04'),('2089-08-05'),('2089-08-06'),('2089-08-07'),('2089-08-08'),('2089-08-09'),('2089-08-10'),('2089-08-11'),('2089-08-12'),('2089-08-13'),('2089-08-14'),('2089-08-15'),('2089-08-16'),('2089-08-17'),('2089-08-18'),('2089-08-19'),('2089-08-20'),('2089-08-21'),('2089-08-22'),('2089-08-23'),('2089-08-24'),('2089-08-25'),('2089-08-26'),('2089-08-27'),('2089-08-28'),('2089-08-29'),('2089-08-30'),('2089-08-31'),('2089-09-01'),('2089-09-02'),('2089-09-03'),('2089-09-04'),('2089-09-05'),('2089-09-06'),('2089-09-07'),('2089-09-08'),('2089-09-09'),('2089-09-10'),('2089-09-11'),('2089-09-12'),('2089-09-13'),('2089-09-14'),('2089-09-15'),('2089-09-16'),('2089-09-17'),('2089-09-18'),('2089-09-19'),('2089-09-20'),('2089-09-21'),('2089-09-22'),('2089-09-23'),('2089-09-24'),('2089-09-25'),('2089-09-26'),('2089-09-27'),('2089-09-28'),('2089-09-29'),('2089-09-30'),('2089-10-01'),('2089-10-02'),('2089-10-03'),('2089-10-04'),('2089-10-05'),('2089-10-06'),('2089-10-07'),('2089-10-08'),('2089-10-09'),('2089-10-10'),('2089-10-11'),('2089-10-12'),('2089-10-13'),('2089-10-14'),('2089-10-15'),('2089-10-16'),('2089-10-17'),('2089-10-18'),('2089-10-19'),('2089-10-20'),('2089-10-21'),('2089-10-22'),('2089-10-23'),('2089-10-24'),('2089-10-25'),('2089-10-26'),('2089-10-27'),('2089-10-28'),('2089-10-29'),('2089-10-30'),('2089-10-31'),('2089-11-01'),('2089-11-02'),('2089-11-03'),('2089-11-04'),('2089-11-05'),('2089-11-06'),('2089-11-07'),('2089-11-08'),('2089-11-09'),('2089-11-10'),('2089-11-11'),('2089-11-12'),('2089-11-13'),('2089-11-14'),('2089-11-15'),('2089-11-16'),('2089-11-17'),('2089-11-18'),('2089-11-19'),('2089-11-20'),('2089-11-21'),('2089-11-22'),('2089-11-23'),('2089-11-24'),('2089-11-25'),('2089-11-26'),('2089-11-27'),('2089-11-28'),('2089-11-29'),('2089-11-30'),('2089-12-01'),('2089-12-02'),('2089-12-03'),('2089-12-04'),('2089-12-05'),('2089-12-06'),('2089-12-07'),('2089-12-08'),('2089-12-09'),('2089-12-10'),('2089-12-11'),('2089-12-12'),('2089-12-13'),('2089-12-14'),('2089-12-15'),('2089-12-16'),('2089-12-17'),('2089-12-18'),('2089-12-19'),('2089-12-20'),('2089-12-21'),('2089-12-22'),('2089-12-23'),('2089-12-24'),('2089-12-25'),('2089-12-26'),('2089-12-27'),('2089-12-28'),('2089-12-29'),('2089-12-30'),('2089-12-31'),('2090-01-01'),('2090-01-02'),('2090-01-03'),('2090-01-04'),('2090-01-05'),('2090-01-06'),('2090-01-07'),('2090-01-08'),('2090-01-09'),('2090-01-10'),('2090-01-11'),('2090-01-12'),('2090-01-13'),('2090-01-14'),('2090-01-15'),('2090-01-16'),('2090-01-17'),('2090-01-18'),('2090-01-19'),('2090-01-20'),('2090-01-21'),('2090-01-22'),('2090-01-23'),('2090-01-24'),('2090-01-25'),('2090-01-26'),('2090-01-27'),('2090-01-28'),('2090-01-29'),('2090-01-30'),('2090-01-31'),('2090-02-01'),('2090-02-02'),('2090-02-03'),('2090-02-04'),('2090-02-05'),('2090-02-06'),('2090-02-07'),('2090-02-08'),('2090-02-09'),('2090-02-10'),('2090-02-11'),('2090-02-12'),('2090-02-13'),('2090-02-14'),('2090-02-15'),('2090-02-16'),('2090-02-17'),('2090-02-18'),('2090-02-19'),('2090-02-20'),('2090-02-21'),('2090-02-22'),('2090-02-23'),('2090-02-24'),('2090-02-25'),('2090-02-26'),('2090-02-27'),('2090-02-28'),('2090-03-01'),('2090-03-02'),('2090-03-03'),('2090-03-04'),('2090-03-05'),('2090-03-06'),('2090-03-07'),('2090-03-08'),('2090-03-09'),('2090-03-10'),('2090-03-11'),('2090-03-12'),('2090-03-13'),('2090-03-14'),('2090-03-15'),('2090-03-16'),('2090-03-17'),('2090-03-18'),('2090-03-19'),('2090-03-20'),('2090-03-21'),('2090-03-22'),('2090-03-23'),('2090-03-24'),('2090-03-25'),('2090-03-26'),('2090-03-27'),('2090-03-28'),('2090-03-29'),('2090-03-30'),('2090-03-31'),('2090-04-01'),('2090-04-02'),('2090-04-03'),('2090-04-04'),('2090-04-05'),('2090-04-06'),('2090-04-07'),('2090-04-08'),('2090-04-09'),('2090-04-10'),('2090-04-11'),('2090-04-12'),('2090-04-13'),('2090-04-14'),('2090-04-15'),('2090-04-16'),('2090-04-17'),('2090-04-18'),('2090-04-19'),('2090-04-20'),('2090-04-21'),('2090-04-22'),('2090-04-23'),('2090-04-24'),('2090-04-25'),('2090-04-26'),('2090-04-27'),('2090-04-28'),('2090-04-29'),('2090-04-30'),('2090-05-01'),('2090-05-02'),('2090-05-03'),('2090-05-04'),('2090-05-05'),('2090-05-06'),('2090-05-07'),('2090-05-08'),('2090-05-09'),('2090-05-10'),('2090-05-11'),('2090-05-12'),('2090-05-13'),('2090-05-14'),('2090-05-15'),('2090-05-16'),('2090-05-17'),('2090-05-18'),('2090-05-19'),('2090-05-20'),('2090-05-21'),('2090-05-22'),('2090-05-23'),('2090-05-24'),('2090-05-25'),('2090-05-26'),('2090-05-27'),('2090-05-28'),('2090-05-29'),('2090-05-30'),('2090-05-31'),('2090-06-01'),('2090-06-02'),('2090-06-03'),('2090-06-04'),('2090-06-05'),('2090-06-06'),('2090-06-07'),('2090-06-08'),('2090-06-09'),('2090-06-10'),('2090-06-11'),('2090-06-12'),('2090-06-13'),('2090-06-14'),('2090-06-15'),('2090-06-16'),('2090-06-17'),('2090-06-18'),('2090-06-19'),('2090-06-20'),('2090-06-21'),('2090-06-22'),('2090-06-23'),('2090-06-24'),('2090-06-25'),('2090-06-26'),('2090-06-27'),('2090-06-28'),('2090-06-29'),('2090-06-30'),('2090-07-01'),('2090-07-02'),('2090-07-03'),('2090-07-04'),('2090-07-05'),('2090-07-06'),('2090-07-07'),('2090-07-08'),('2090-07-09'),('2090-07-10'),('2090-07-11'),('2090-07-12'),('2090-07-13'),('2090-07-14'),('2090-07-15'),('2090-07-16'),('2090-07-17'),('2090-07-18'),('2090-07-19'),('2090-07-20'),('2090-07-21'),('2090-07-22'),('2090-07-23'),('2090-07-24'),('2090-07-25'),('2090-07-26'),('2090-07-27'),('2090-07-28'),('2090-07-29'),('2090-07-30'),('2090-07-31'),('2090-08-01'),('2090-08-02'),('2090-08-03'),('2090-08-04'),('2090-08-05'),('2090-08-06'),('2090-08-07'),('2090-08-08'),('2090-08-09'),('2090-08-10'),('2090-08-11'),('2090-08-12'),('2090-08-13'),('2090-08-14'),('2090-08-15'),('2090-08-16'),('2090-08-17'),('2090-08-18'),('2090-08-19'),('2090-08-20'),('2090-08-21'),('2090-08-22'),('2090-08-23'),('2090-08-24'),('2090-08-25'),('2090-08-26'),('2090-08-27'),('2090-08-28'),('2090-08-29'),('2090-08-30'),('2090-08-31'),('2090-09-01'),('2090-09-02'),('2090-09-03'),('2090-09-04'),('2090-09-05'),('2090-09-06'),('2090-09-07'),('2090-09-08'),('2090-09-09'),('2090-09-10'),('2090-09-11'),('2090-09-12'),('2090-09-13'),('2090-09-14'),('2090-09-15'),('2090-09-16'),('2090-09-17'),('2090-09-18'),('2090-09-19'),('2090-09-20'),('2090-09-21'),('2090-09-22'),('2090-09-23'),('2090-09-24'),('2090-09-25'),('2090-09-26'),('2090-09-27'),('2090-09-28'),('2090-09-29'),('2090-09-30'),('2090-10-01'),('2090-10-02'),('2090-10-03'),('2090-10-04'),('2090-10-05'),('2090-10-06'),('2090-10-07'),('2090-10-08'),('2090-10-09'),('2090-10-10'),('2090-10-11'),('2090-10-12'),('2090-10-13'),('2090-10-14'),('2090-10-15'),('2090-10-16'),('2090-10-17'),('2090-10-18'),('2090-10-19'),('2090-10-20'),('2090-10-21'),('2090-10-22'),('2090-10-23'),('2090-10-24'),('2090-10-25'),('2090-10-26'),('2090-10-27'),('2090-10-28'),('2090-10-29'),('2090-10-30'),('2090-10-31'),('2090-11-01'),('2090-11-02'),('2090-11-03'),('2090-11-04'),('2090-11-05'),('2090-11-06'),('2090-11-07'),('2090-11-08'),('2090-11-09'),('2090-11-10'),('2090-11-11'),('2090-11-12'),('2090-11-13'),('2090-11-14'),('2090-11-15'),('2090-11-16'),('2090-11-17'),('2090-11-18'),('2090-11-19'),('2090-11-20'),('2090-11-21'),('2090-11-22'),('2090-11-23'),('2090-11-24'),('2090-11-25'),('2090-11-26'),('2090-11-27'),('2090-11-28'),('2090-11-29'),('2090-11-30'),('2090-12-01'),('2090-12-02'),('2090-12-03'),('2090-12-04'),('2090-12-05'),('2090-12-06'),('2090-12-07'),('2090-12-08'),('2090-12-09'),('2090-12-10'),('2090-12-11'),('2090-12-12'),('2090-12-13'),('2090-12-14'),('2090-12-15'),('2090-12-16'),('2090-12-17'),('2090-12-18'),('2090-12-19'),('2090-12-20'),('2090-12-21'),('2090-12-22'),('2090-12-23'),('2090-12-24'),('2090-12-25'),('2090-12-26'),('2090-12-27'),('2090-12-28'),('2090-12-29'),('2090-12-30'),('2090-12-31'),('2091-01-01'),('2091-01-02'),('2091-01-03'),('2091-01-04'),('2091-01-05'),('2091-01-06'),('2091-01-07'),('2091-01-08'),('2091-01-09'),('2091-01-10'),('2091-01-11'),('2091-01-12'),('2091-01-13'),('2091-01-14'),('2091-01-15'),('2091-01-16'),('2091-01-17'),('2091-01-18'),('2091-01-19'),('2091-01-20'),('2091-01-21'),('2091-01-22'),('2091-01-23'),('2091-01-24'),('2091-01-25'),('2091-01-26'),('2091-01-27'),('2091-01-28'),('2091-01-29'),('2091-01-30'),('2091-01-31'),('2091-02-01'),('2091-02-02'),('2091-02-03'),('2091-02-04'),('2091-02-05'),('2091-02-06'),('2091-02-07'),('2091-02-08'),('2091-02-09'),('2091-02-10'),('2091-02-11'),('2091-02-12'),('2091-02-13'),('2091-02-14'),('2091-02-15'),('2091-02-16'),('2091-02-17'),('2091-02-18'),('2091-02-19'),('2091-02-20'),('2091-02-21'),('2091-02-22'),('2091-02-23'),('2091-02-24'),('2091-02-25'),('2091-02-26'),('2091-02-27'),('2091-02-28'),('2091-03-01'),('2091-03-02'),('2091-03-03'),('2091-03-04'),('2091-03-05'),('2091-03-06'),('2091-03-07'),('2091-03-08'),('2091-03-09'),('2091-03-10'),('2091-03-11'),('2091-03-12'),('2091-03-13'),('2091-03-14'),('2091-03-15'),('2091-03-16'),('2091-03-17'),('2091-03-18'),('2091-03-19'),('2091-03-20'),('2091-03-21'),('2091-03-22'),('2091-03-23'),('2091-03-24'),('2091-03-25'),('2091-03-26'),('2091-03-27'),('2091-03-28'),('2091-03-29'),('2091-03-30'),('2091-03-31'),('2091-04-01'),('2091-04-02'),('2091-04-03'),('2091-04-04'),('2091-04-05'),('2091-04-06'),('2091-04-07'),('2091-04-08'),('2091-04-09'),('2091-04-10'),('2091-04-11'),('2091-04-12'),('2091-04-13'),('2091-04-14'),('2091-04-15'),('2091-04-16'),('2091-04-17'),('2091-04-18'),('2091-04-19'),('2091-04-20'),('2091-04-21'),('2091-04-22'),('2091-04-23'),('2091-04-24'),('2091-04-25'),('2091-04-26'),('2091-04-27'),('2091-04-28'),('2091-04-29'),('2091-04-30'),('2091-05-01'),('2091-05-02'),('2091-05-03'),('2091-05-04'),('2091-05-05'),('2091-05-06'),('2091-05-07'),('2091-05-08'),('2091-05-09'),('2091-05-10'),('2091-05-11'),('2091-05-12'),('2091-05-13'),('2091-05-14'),('2091-05-15'),('2091-05-16'),('2091-05-17'),('2091-05-18'),('2091-05-19'),('2091-05-20'),('2091-05-21'),('2091-05-22'),('2091-05-23'),('2091-05-24'),('2091-05-25'),('2091-05-26'),('2091-05-27'),('2091-05-28'),('2091-05-29'),('2091-05-30'),('2091-05-31'),('2091-06-01'),('2091-06-02'),('2091-06-03'),('2091-06-04'),('2091-06-05'),('2091-06-06'),('2091-06-07'),('2091-06-08'),('2091-06-09'),('2091-06-10'),('2091-06-11'),('2091-06-12'),('2091-06-13'),('2091-06-14'),('2091-06-15'),('2091-06-16'),('2091-06-17'),('2091-06-18'),('2091-06-19'),('2091-06-20'),('2091-06-21'),('2091-06-22'),('2091-06-23'),('2091-06-24'),('2091-06-25'),('2091-06-26'),('2091-06-27'),('2091-06-28'),('2091-06-29'),('2091-06-30'),('2091-07-01'),('2091-07-02'),('2091-07-03'),('2091-07-04'),('2091-07-05'),('2091-07-06'),('2091-07-07'),('2091-07-08'),('2091-07-09'),('2091-07-10'),('2091-07-11'),('2091-07-12'),('2091-07-13'),('2091-07-14'),('2091-07-15'),('2091-07-16'),('2091-07-17'),('2091-07-18'),('2091-07-19'),('2091-07-20'),('2091-07-21'),('2091-07-22'),('2091-07-23'),('2091-07-24'),('2091-07-25'),('2091-07-26'),('2091-07-27'),('2091-07-28'),('2091-07-29'),('2091-07-30'),('2091-07-31'),('2091-08-01'),('2091-08-02'),('2091-08-03'),('2091-08-04'),('2091-08-05'),('2091-08-06'),('2091-08-07'),('2091-08-08'),('2091-08-09'),('2091-08-10'),('2091-08-11'),('2091-08-12'),('2091-08-13'),('2091-08-14'),('2091-08-15'),('2091-08-16'),('2091-08-17'),('2091-08-18'),('2091-08-19'),('2091-08-20'),('2091-08-21'),('2091-08-22'),('2091-08-23'),('2091-08-24'),('2091-08-25'),('2091-08-26'),('2091-08-27'),('2091-08-28'),('2091-08-29'),('2091-08-30'),('2091-08-31'),('2091-09-01'),('2091-09-02'),('2091-09-03'),('2091-09-04'),('2091-09-05'),('2091-09-06'),('2091-09-07'),('2091-09-08'),('2091-09-09'),('2091-09-10'),('2091-09-11'),('2091-09-12'),('2091-09-13'),('2091-09-14'),('2091-09-15'),('2091-09-16'),('2091-09-17'),('2091-09-18'),('2091-09-19'),('2091-09-20'),('2091-09-21'),('2091-09-22'),('2091-09-23'),('2091-09-24'),('2091-09-25'),('2091-09-26'),('2091-09-27'),('2091-09-28'),('2091-09-29'),('2091-09-30'),('2091-10-01'),('2091-10-02'),('2091-10-03'),('2091-10-04'),('2091-10-05'),('2091-10-06'),('2091-10-07'),('2091-10-08'),('2091-10-09'),('2091-10-10'),('2091-10-11'),('2091-10-12'),('2091-10-13'),('2091-10-14'),('2091-10-15'),('2091-10-16'),('2091-10-17'),('2091-10-18'),('2091-10-19'),('2091-10-20'),('2091-10-21'),('2091-10-22'),('2091-10-23'),('2091-10-24'),('2091-10-25'),('2091-10-26'),('2091-10-27'),('2091-10-28'),('2091-10-29'),('2091-10-30'),('2091-10-31'),('2091-11-01'),('2091-11-02'),('2091-11-03'),('2091-11-04'),('2091-11-05'),('2091-11-06'),('2091-11-07'),('2091-11-08'),('2091-11-09'),('2091-11-10'),('2091-11-11'),('2091-11-12'),('2091-11-13'),('2091-11-14'),('2091-11-15'),('2091-11-16'),('2091-11-17'),('2091-11-18'),('2091-11-19'),('2091-11-20'),('2091-11-21'),('2091-11-22'),('2091-11-23'),('2091-11-24'),('2091-11-25'),('2091-11-26'),('2091-11-27'),('2091-11-28'),('2091-11-29'),('2091-11-30'),('2091-12-01'),('2091-12-02'),('2091-12-03'),('2091-12-04'),('2091-12-05'),('2091-12-06'),('2091-12-07'),('2091-12-08'),('2091-12-09'),('2091-12-10'),('2091-12-11'),('2091-12-12'),('2091-12-13'),('2091-12-14'),('2091-12-15'),('2091-12-16'),('2091-12-17'),('2091-12-18'),('2091-12-19'),('2091-12-20'),('2091-12-21'),('2091-12-22'),('2091-12-23'),('2091-12-24'),('2091-12-25'),('2091-12-26'),('2091-12-27'),('2091-12-28'),('2091-12-29'),('2091-12-30'),('2091-12-31'),('2092-01-01'),('2092-01-02'),('2092-01-03'),('2092-01-04'),('2092-01-05'),('2092-01-06'),('2092-01-07'),('2092-01-08'),('2092-01-09'),('2092-01-10'),('2092-01-11'),('2092-01-12'),('2092-01-13'),('2092-01-14'),('2092-01-15'),('2092-01-16'),('2092-01-17'),('2092-01-18'),('2092-01-19'),('2092-01-20'),('2092-01-21'),('2092-01-22'),('2092-01-23'),('2092-01-24'),('2092-01-25'),('2092-01-26'),('2092-01-27'),('2092-01-28'),('2092-01-29'),('2092-01-30'),('2092-01-31'),('2092-02-01'),('2092-02-02'),('2092-02-03'),('2092-02-04'),('2092-02-05'),('2092-02-06'),('2092-02-07'),('2092-02-08'),('2092-02-09'),('2092-02-10'),('2092-02-11'),('2092-02-12'),('2092-02-13'),('2092-02-14'),('2092-02-15'),('2092-02-16'),('2092-02-17'),('2092-02-18'),('2092-02-19'),('2092-02-20'),('2092-02-21'),('2092-02-22'),('2092-02-23'),('2092-02-24'),('2092-02-25'),('2092-02-26'),('2092-02-27'),('2092-02-28'),('2092-02-29'),('2092-03-01'),('2092-03-02'),('2092-03-03'),('2092-03-04'),('2092-03-05'),('2092-03-06'),('2092-03-07'),('2092-03-08'),('2092-03-09'),('2092-03-10'),('2092-03-11'),('2092-03-12'),('2092-03-13'),('2092-03-14'),('2092-03-15'),('2092-03-16'),('2092-03-17'),('2092-03-18'),('2092-03-19'),('2092-03-20'),('2092-03-21'),('2092-03-22'),('2092-03-23'),('2092-03-24'),('2092-03-25'),('2092-03-26'),('2092-03-27'),('2092-03-28'),('2092-03-29'),('2092-03-30'),('2092-03-31'),('2092-04-01'),('2092-04-02'),('2092-04-03'),('2092-04-04'),('2092-04-05'),('2092-04-06'),('2092-04-07'),('2092-04-08'),('2092-04-09'),('2092-04-10'),('2092-04-11'),('2092-04-12'),('2092-04-13'),('2092-04-14'),('2092-04-15'),('2092-04-16'),('2092-04-17'),('2092-04-18'),('2092-04-19'),('2092-04-20'),('2092-04-21'),('2092-04-22'),('2092-04-23'),('2092-04-24'),('2092-04-25'),('2092-04-26'),('2092-04-27'),('2092-04-28'),('2092-04-29'),('2092-04-30'),('2092-05-01'),('2092-05-02'),('2092-05-03'),('2092-05-04'),('2092-05-05'),('2092-05-06'),('2092-05-07'),('2092-05-08'),('2092-05-09'),('2092-05-10'),('2092-05-11'),('2092-05-12'),('2092-05-13'),('2092-05-14'),('2092-05-15'),('2092-05-16'),('2092-05-17'),('2092-05-18'),('2092-05-19'),('2092-05-20'),('2092-05-21'),('2092-05-22'),('2092-05-23'),('2092-05-24'),('2092-05-25'),('2092-05-26'),('2092-05-27'),('2092-05-28'),('2092-05-29'),('2092-05-30'),('2092-05-31'),('2092-06-01'),('2092-06-02'),('2092-06-03'),('2092-06-04'),('2092-06-05'),('2092-06-06'),('2092-06-07'),('2092-06-08'),('2092-06-09'),('2092-06-10'),('2092-06-11'),('2092-06-12'),('2092-06-13'),('2092-06-14'),('2092-06-15'),('2092-06-16'),('2092-06-17'),('2092-06-18'),('2092-06-19'),('2092-06-20'),('2092-06-21'),('2092-06-22'),('2092-06-23'),('2092-06-24'),('2092-06-25'),('2092-06-26'),('2092-06-27'),('2092-06-28'),('2092-06-29'),('2092-06-30'),('2092-07-01'),('2092-07-02'),('2092-07-03'),('2092-07-04'),('2092-07-05'),('2092-07-06'),('2092-07-07'),('2092-07-08'),('2092-07-09'),('2092-07-10'),('2092-07-11'),('2092-07-12'),('2092-07-13'),('2092-07-14'),('2092-07-15'),('2092-07-16'),('2092-07-17'),('2092-07-18'),('2092-07-19'),('2092-07-20'),('2092-07-21'),('2092-07-22'),('2092-07-23'),('2092-07-24'),('2092-07-25'),('2092-07-26'),('2092-07-27'),('2092-07-28'),('2092-07-29'),('2092-07-30'),('2092-07-31'),('2092-08-01'),('2092-08-02'),('2092-08-03'),('2092-08-04'),('2092-08-05'),('2092-08-06'),('2092-08-07'),('2092-08-08'),('2092-08-09'),('2092-08-10'),('2092-08-11'),('2092-08-12'),('2092-08-13'),('2092-08-14'),('2092-08-15'),('2092-08-16'),('2092-08-17'),('2092-08-18'),('2092-08-19'),('2092-08-20'),('2092-08-21'),('2092-08-22'),('2092-08-23'),('2092-08-24'),('2092-08-25'),('2092-08-26'),('2092-08-27'),('2092-08-28'),('2092-08-29'),('2092-08-30'),('2092-08-31'),('2092-09-01'),('2092-09-02'),('2092-09-03'),('2092-09-04'),('2092-09-05'),('2092-09-06'),('2092-09-07'),('2092-09-08'),('2092-09-09'),('2092-09-10'),('2092-09-11'),('2092-09-12'),('2092-09-13'),('2092-09-14'),('2092-09-15'),('2092-09-16'),('2092-09-17'),('2092-09-18'),('2092-09-19'),('2092-09-20'),('2092-09-21'),('2092-09-22'),('2092-09-23'),('2092-09-24'),('2092-09-25'),('2092-09-26'),('2092-09-27'),('2092-09-28'),('2092-09-29'),('2092-09-30'),('2092-10-01'),('2092-10-02'),('2092-10-03'),('2092-10-04'),('2092-10-05'),('2092-10-06'),('2092-10-07'),('2092-10-08'),('2092-10-09'),('2092-10-10'),('2092-10-11'),('2092-10-12'),('2092-10-13'),('2092-10-14'),('2092-10-15'),('2092-10-16'),('2092-10-17'),('2092-10-18'),('2092-10-19'),('2092-10-20'),('2092-10-21'),('2092-10-22'),('2092-10-23'),('2092-10-24'),('2092-10-25'),('2092-10-26'),('2092-10-27'),('2092-10-28'),('2092-10-29'),('2092-10-30'),('2092-10-31'),('2092-11-01'),('2092-11-02'),('2092-11-03'),('2092-11-04'),('2092-11-05'),('2092-11-06'),('2092-11-07'),('2092-11-08'),('2092-11-09'),('2092-11-10'),('2092-11-11'),('2092-11-12'),('2092-11-13'),('2092-11-14'),('2092-11-15'),('2092-11-16'),('2092-11-17'),('2092-11-18'),('2092-11-19'),('2092-11-20'),('2092-11-21'),('2092-11-22'),('2092-11-23'),('2092-11-24'),('2092-11-25'),('2092-11-26'),('2092-11-27'),('2092-11-28'),('2092-11-29'),('2092-11-30'),('2092-12-01'),('2092-12-02'),('2092-12-03'),('2092-12-04'),('2092-12-05'),('2092-12-06'),('2092-12-07'),('2092-12-08'),('2092-12-09'),('2092-12-10'),('2092-12-11'),('2092-12-12'),('2092-12-13'),('2092-12-14'),('2092-12-15'),('2092-12-16'),('2092-12-17'),('2092-12-18'),('2092-12-19'),('2092-12-20'),('2092-12-21'),('2092-12-22'),('2092-12-23'),('2092-12-24'),('2092-12-25'),('2092-12-26'),('2092-12-27'),('2092-12-28'),('2092-12-29'),('2092-12-30'),('2092-12-31'),('2093-01-01'),('2093-01-02'),('2093-01-03'),('2093-01-04'),('2093-01-05'),('2093-01-06'),('2093-01-07'),('2093-01-08'),('2093-01-09'),('2093-01-10'),('2093-01-11'),('2093-01-12'),('2093-01-13'),('2093-01-14'),('2093-01-15'),('2093-01-16'),('2093-01-17'),('2093-01-18'),('2093-01-19'),('2093-01-20'),('2093-01-21'),('2093-01-22'),('2093-01-23'),('2093-01-24'),('2093-01-25'),('2093-01-26'),('2093-01-27'),('2093-01-28'),('2093-01-29'),('2093-01-30'),('2093-01-31'),('2093-02-01'),('2093-02-02'),('2093-02-03'),('2093-02-04'),('2093-02-05'),('2093-02-06'),('2093-02-07'),('2093-02-08'),('2093-02-09'),('2093-02-10'),('2093-02-11'),('2093-02-12'),('2093-02-13'),('2093-02-14'),('2093-02-15'),('2093-02-16'),('2093-02-17'),('2093-02-18'),('2093-02-19'),('2093-02-20'),('2093-02-21'),('2093-02-22'),('2093-02-23'),('2093-02-24'),('2093-02-25'),('2093-02-26'),('2093-02-27'),('2093-02-28'),('2093-03-01'),('2093-03-02'),('2093-03-03'),('2093-03-04'),('2093-03-05'),('2093-03-06'),('2093-03-07'),('2093-03-08'),('2093-03-09'),('2093-03-10'),('2093-03-11'),('2093-03-12'),('2093-03-13'),('2093-03-14'),('2093-03-15'),('2093-03-16'),('2093-03-17'),('2093-03-18'),('2093-03-19'),('2093-03-20'),('2093-03-21'),('2093-03-22'),('2093-03-23'),('2093-03-24'),('2093-03-25'),('2093-03-26'),('2093-03-27'),('2093-03-28'),('2093-03-29'),('2093-03-30'),('2093-03-31'),('2093-04-01'),('2093-04-02'),('2093-04-03'),('2093-04-04'),('2093-04-05'),('2093-04-06'),('2093-04-07'),('2093-04-08'),('2093-04-09'),('2093-04-10'),('2093-04-11'),('2093-04-12'),('2093-04-13'),('2093-04-14'),('2093-04-15'),('2093-04-16'),('2093-04-17'),('2093-04-18'),('2093-04-19'),('2093-04-20'),('2093-04-21'),('2093-04-22'),('2093-04-23'),('2093-04-24'),('2093-04-25'),('2093-04-26'),('2093-04-27'),('2093-04-28'),('2093-04-29'),('2093-04-30'),('2093-05-01'),('2093-05-02'),('2093-05-03'),('2093-05-04'),('2093-05-05'),('2093-05-06'),('2093-05-07'),('2093-05-08'),('2093-05-09'),('2093-05-10'),('2093-05-11'),('2093-05-12'),('2093-05-13'),('2093-05-14'),('2093-05-15'),('2093-05-16'),('2093-05-17'),('2093-05-18'),('2093-05-19'),('2093-05-20'),('2093-05-21'),('2093-05-22'),('2093-05-23'),('2093-05-24'),('2093-05-25'),('2093-05-26'),('2093-05-27'),('2093-05-28'),('2093-05-29'),('2093-05-30'),('2093-05-31'),('2093-06-01'),('2093-06-02'),('2093-06-03'),('2093-06-04'),('2093-06-05'),('2093-06-06'),('2093-06-07'),('2093-06-08'),('2093-06-09'),('2093-06-10'),('2093-06-11'),('2093-06-12'),('2093-06-13'),('2093-06-14'),('2093-06-15'),('2093-06-16'),('2093-06-17'),('2093-06-18'),('2093-06-19'),('2093-06-20'),('2093-06-21'),('2093-06-22'),('2093-06-23'),('2093-06-24'),('2093-06-25'),('2093-06-26'),('2093-06-27'),('2093-06-28'),('2093-06-29'),('2093-06-30'),('2093-07-01'),('2093-07-02'),('2093-07-03'),('2093-07-04'),('2093-07-05'),('2093-07-06'),('2093-07-07'),('2093-07-08'),('2093-07-09'),('2093-07-10'),('2093-07-11'),('2093-07-12'),('2093-07-13'),('2093-07-14'),('2093-07-15'),('2093-07-16'),('2093-07-17'),('2093-07-18'),('2093-07-19'),('2093-07-20'),('2093-07-21'),('2093-07-22'),('2093-07-23'),('2093-07-24'),('2093-07-25'),('2093-07-26'),('2093-07-27'),('2093-07-28'),('2093-07-29'),('2093-07-30'),('2093-07-31'),('2093-08-01'),('2093-08-02'),('2093-08-03'),('2093-08-04'),('2093-08-05'),('2093-08-06'),('2093-08-07'),('2093-08-08'),('2093-08-09'),('2093-08-10'),('2093-08-11'),('2093-08-12'),('2093-08-13'),('2093-08-14'),('2093-08-15'),('2093-08-16'),('2093-08-17'),('2093-08-18'),('2093-08-19'),('2093-08-20'),('2093-08-21'),('2093-08-22'),('2093-08-23'),('2093-08-24'),('2093-08-25'),('2093-08-26'),('2093-08-27'),('2093-08-28'),('2093-08-29'),('2093-08-30'),('2093-08-31'),('2093-09-01'),('2093-09-02'),('2093-09-03'),('2093-09-04'),('2093-09-05'),('2093-09-06'),('2093-09-07'),('2093-09-08'),('2093-09-09'),('2093-09-10'),('2093-09-11'),('2093-09-12'),('2093-09-13'),('2093-09-14'),('2093-09-15'),('2093-09-16'),('2093-09-17'),('2093-09-18'),('2093-09-19'),('2093-09-20'),('2093-09-21'),('2093-09-22'),('2093-09-23'),('2093-09-24'),('2093-09-25'),('2093-09-26'),('2093-09-27'),('2093-09-28'),('2093-09-29'),('2093-09-30'),('2093-10-01'),('2093-10-02'),('2093-10-03'),('2093-10-04'),('2093-10-05'),('2093-10-06'),('2093-10-07'),('2093-10-08'),('2093-10-09'),('2093-10-10'),('2093-10-11'),('2093-10-12'),('2093-10-13'),('2093-10-14'),('2093-10-15'),('2093-10-16'),('2093-10-17'),('2093-10-18'),('2093-10-19'),('2093-10-20'),('2093-10-21'),('2093-10-22'),('2093-10-23'),('2093-10-24'),('2093-10-25'),('2093-10-26'),('2093-10-27'),('2093-10-28'),('2093-10-29'),('2093-10-30'),('2093-10-31'),('2093-11-01'),('2093-11-02'),('2093-11-03'),('2093-11-04'),('2093-11-05'),('2093-11-06'),('2093-11-07'),('2093-11-08'),('2093-11-09'),('2093-11-10'),('2093-11-11'),('2093-11-12'),('2093-11-13'),('2093-11-14'),('2093-11-15'),('2093-11-16'),('2093-11-17'),('2093-11-18'),('2093-11-19'),('2093-11-20'),('2093-11-21'),('2093-11-22'),('2093-11-23'),('2093-11-24'),('2093-11-25'),('2093-11-26'),('2093-11-27'),('2093-11-28'),('2093-11-29'),('2093-11-30'),('2093-12-01'),('2093-12-02'),('2093-12-03'),('2093-12-04'),('2093-12-05'),('2093-12-06'),('2093-12-07'),('2093-12-08'),('2093-12-09'),('2093-12-10'),('2093-12-11'),('2093-12-12'),('2093-12-13'),('2093-12-14'),('2093-12-15'),('2093-12-16'),('2093-12-17'),('2093-12-18'),('2093-12-19'),('2093-12-20'),('2093-12-21'),('2093-12-22'),('2093-12-23'),('2093-12-24'),('2093-12-25'),('2093-12-26'),('2093-12-27'),('2093-12-28'),('2093-12-29'),('2093-12-30'),('2093-12-31'),('2094-01-01'),('2094-01-02'),('2094-01-03'),('2094-01-04'),('2094-01-05'),('2094-01-06'),('2094-01-07'),('2094-01-08'),('2094-01-09'),('2094-01-10'),('2094-01-11'),('2094-01-12'),('2094-01-13'),('2094-01-14'),('2094-01-15'),('2094-01-16'),('2094-01-17'),('2094-01-18'),('2094-01-19'),('2094-01-20'),('2094-01-21'),('2094-01-22'),('2094-01-23'),('2094-01-24'),('2094-01-25'),('2094-01-26'),('2094-01-27'),('2094-01-28'),('2094-01-29'),('2094-01-30'),('2094-01-31'),('2094-02-01'),('2094-02-02'),('2094-02-03'),('2094-02-04'),('2094-02-05'),('2094-02-06'),('2094-02-07'),('2094-02-08'),('2094-02-09'),('2094-02-10'),('2094-02-11'),('2094-02-12'),('2094-02-13'),('2094-02-14'),('2094-02-15'),('2094-02-16'),('2094-02-17'),('2094-02-18'),('2094-02-19'),('2094-02-20'),('2094-02-21'),('2094-02-22'),('2094-02-23'),('2094-02-24'),('2094-02-25'),('2094-02-26'),('2094-02-27'),('2094-02-28'),('2094-03-01'),('2094-03-02'),('2094-03-03'),('2094-03-04'),('2094-03-05'),('2094-03-06'),('2094-03-07'),('2094-03-08'),('2094-03-09'),('2094-03-10'),('2094-03-11'),('2094-03-12'),('2094-03-13'),('2094-03-14'),('2094-03-15'),('2094-03-16'),('2094-03-17'),('2094-03-18'),('2094-03-19'),('2094-03-20'),('2094-03-21'),('2094-03-22'),('2094-03-23'),('2094-03-24'),('2094-03-25'),('2094-03-26'),('2094-03-27'),('2094-03-28'),('2094-03-29'),('2094-03-30'),('2094-03-31'),('2094-04-01'),('2094-04-02'),('2094-04-03'),('2094-04-04'),('2094-04-05'),('2094-04-06'),('2094-04-07'),('2094-04-08'),('2094-04-09'),('2094-04-10'),('2094-04-11'),('2094-04-12'),('2094-04-13'),('2094-04-14'),('2094-04-15'),('2094-04-16'),('2094-04-17'),('2094-04-18'),('2094-04-19'),('2094-04-20'),('2094-04-21'),('2094-04-22'),('2094-04-23'),('2094-04-24'),('2094-04-25'),('2094-04-26'),('2094-04-27'),('2094-04-28'),('2094-04-29'),('2094-04-30'),('2094-05-01'),('2094-05-02'),('2094-05-03'),('2094-05-04'),('2094-05-05'),('2094-05-06'),('2094-05-07'),('2094-05-08'),('2094-05-09'),('2094-05-10'),('2094-05-11'),('2094-05-12'),('2094-05-13'),('2094-05-14'),('2094-05-15'),('2094-05-16'),('2094-05-17'),('2094-05-18'),('2094-05-19'),('2094-05-20'),('2094-05-21'),('2094-05-22'),('2094-05-23'),('2094-05-24'),('2094-05-25'),('2094-05-26'),('2094-05-27'),('2094-05-28'),('2094-05-29'),('2094-05-30'),('2094-05-31'),('2094-06-01'),('2094-06-02'),('2094-06-03'),('2094-06-04'),('2094-06-05'),('2094-06-06'),('2094-06-07'),('2094-06-08'),('2094-06-09'),('2094-06-10'),('2094-06-11'),('2094-06-12'),('2094-06-13'),('2094-06-14'),('2094-06-15'),('2094-06-16'),('2094-06-17'),('2094-06-18'),('2094-06-19'),('2094-06-20'),('2094-06-21'),('2094-06-22'),('2094-06-23'),('2094-06-24'),('2094-06-25'),('2094-06-26'),('2094-06-27'),('2094-06-28'),('2094-06-29'),('2094-06-30'),('2094-07-01'),('2094-07-02'),('2094-07-03'),('2094-07-04'),('2094-07-05'),('2094-07-06'),('2094-07-07'),('2094-07-08'),('2094-07-09'),('2094-07-10'),('2094-07-11'),('2094-07-12'),('2094-07-13'),('2094-07-14'),('2094-07-15'),('2094-07-16'),('2094-07-17'),('2094-07-18'),('2094-07-19'),('2094-07-20'),('2094-07-21'),('2094-07-22'),('2094-07-23'),('2094-07-24'),('2094-07-25'),('2094-07-26'),('2094-07-27'),('2094-07-28'),('2094-07-29'),('2094-07-30'),('2094-07-31'),('2094-08-01'),('2094-08-02'),('2094-08-03'),('2094-08-04'),('2094-08-05'),('2094-08-06'),('2094-08-07'),('2094-08-08'),('2094-08-09'),('2094-08-10'),('2094-08-11'),('2094-08-12'),('2094-08-13'),('2094-08-14'),('2094-08-15'),('2094-08-16'),('2094-08-17'),('2094-08-18'),('2094-08-19'),('2094-08-20'),('2094-08-21'),('2094-08-22'),('2094-08-23'),('2094-08-24'),('2094-08-25'),('2094-08-26'),('2094-08-27'),('2094-08-28'),('2094-08-29'),('2094-08-30'),('2094-08-31'),('2094-09-01'),('2094-09-02'),('2094-09-03'),('2094-09-04'),('2094-09-05'),('2094-09-06'),('2094-09-07'),('2094-09-08'),('2094-09-09'),('2094-09-10'),('2094-09-11'),('2094-09-12'),('2094-09-13'),('2094-09-14'),('2094-09-15'),('2094-09-16'),('2094-09-17'),('2094-09-18'),('2094-09-19'),('2094-09-20'),('2094-09-21'),('2094-09-22'),('2094-09-23'),('2094-09-24'),('2094-09-25'),('2094-09-26'),('2094-09-27'),('2094-09-28'),('2094-09-29'),('2094-09-30'),('2094-10-01'),('2094-10-02'),('2094-10-03'),('2094-10-04'),('2094-10-05'),('2094-10-06'),('2094-10-07'),('2094-10-08'),('2094-10-09'),('2094-10-10'),('2094-10-11'),('2094-10-12'),('2094-10-13'),('2094-10-14'),('2094-10-15'),('2094-10-16'),('2094-10-17'),('2094-10-18'),('2094-10-19'),('2094-10-20'),('2094-10-21'),('2094-10-22'),('2094-10-23'),('2094-10-24'),('2094-10-25'),('2094-10-26'),('2094-10-27'),('2094-10-28'),('2094-10-29'),('2094-10-30'),('2094-10-31'),('2094-11-01'),('2094-11-02'),('2094-11-03'),('2094-11-04'),('2094-11-05'),('2094-11-06'),('2094-11-07'),('2094-11-08'),('2094-11-09'),('2094-11-10'),('2094-11-11'),('2094-11-12'),('2094-11-13'),('2094-11-14'),('2094-11-15'),('2094-11-16'),('2094-11-17'),('2094-11-18'),('2094-11-19'),('2094-11-20'),('2094-11-21'),('2094-11-22'),('2094-11-23'),('2094-11-24'),('2094-11-25'),('2094-11-26'),('2094-11-27'),('2094-11-28'),('2094-11-29'),('2094-11-30'),('2094-12-01'),('2094-12-02'),('2094-12-03'),('2094-12-04'),('2094-12-05'),('2094-12-06'),('2094-12-07'),('2094-12-08'),('2094-12-09'),('2094-12-10'),('2094-12-11'),('2094-12-12'),('2094-12-13'),('2094-12-14'),('2094-12-15'),('2094-12-16'),('2094-12-17'),('2094-12-18'),('2094-12-19'),('2094-12-20'),('2094-12-21'),('2094-12-22'),('2094-12-23'),('2094-12-24'),('2094-12-25'),('2094-12-26'),('2094-12-27'),('2094-12-28'),('2094-12-29'),('2094-12-30'),('2094-12-31'),('2095-01-01'),('2095-01-02'),('2095-01-03'),('2095-01-04'),('2095-01-05'),('2095-01-06'),('2095-01-07'),('2095-01-08'),('2095-01-09'),('2095-01-10'),('2095-01-11'),('2095-01-12'),('2095-01-13'),('2095-01-14'),('2095-01-15'),('2095-01-16'),('2095-01-17'),('2095-01-18'),('2095-01-19'),('2095-01-20'),('2095-01-21'),('2095-01-22'),('2095-01-23'),('2095-01-24'),('2095-01-25'),('2095-01-26'),('2095-01-27'),('2095-01-28'),('2095-01-29'),('2095-01-30'),('2095-01-31'),('2095-02-01'),('2095-02-02'),('2095-02-03'),('2095-02-04'),('2095-02-05'),('2095-02-06'),('2095-02-07'),('2095-02-08'),('2095-02-09'),('2095-02-10'),('2095-02-11'),('2095-02-12'),('2095-02-13'),('2095-02-14'),('2095-02-15'),('2095-02-16'),('2095-02-17'),('2095-02-18'),('2095-02-19'),('2095-02-20'),('2095-02-21'),('2095-02-22'),('2095-02-23'),('2095-02-24'),('2095-02-25'),('2095-02-26'),('2095-02-27'),('2095-02-28'),('2095-03-01'),('2095-03-02'),('2095-03-03'),('2095-03-04'),('2095-03-05'),('2095-03-06'),('2095-03-07'),('2095-03-08'),('2095-03-09'),('2095-03-10'),('2095-03-11'),('2095-03-12'),('2095-03-13'),('2095-03-14'),('2095-03-15'),('2095-03-16'),('2095-03-17'),('2095-03-18'),('2095-03-19'),('2095-03-20'),('2095-03-21'),('2095-03-22'),('2095-03-23'),('2095-03-24'),('2095-03-25'),('2095-03-26'),('2095-03-27'),('2095-03-28'),('2095-03-29'),('2095-03-30'),('2095-03-31'),('2095-04-01'),('2095-04-02'),('2095-04-03'),('2095-04-04'),('2095-04-05'),('2095-04-06'),('2095-04-07'),('2095-04-08'),('2095-04-09'),('2095-04-10'),('2095-04-11'),('2095-04-12'),('2095-04-13'),('2095-04-14'),('2095-04-15'),('2095-04-16'),('2095-04-17'),('2095-04-18'),('2095-04-19'),('2095-04-20'),('2095-04-21'),('2095-04-22'),('2095-04-23'),('2095-04-24'),('2095-04-25'),('2095-04-26'),('2095-04-27'),('2095-04-28'),('2095-04-29'),('2095-04-30'),('2095-05-01'),('2095-05-02'),('2095-05-03'),('2095-05-04'),('2095-05-05'),('2095-05-06'),('2095-05-07'),('2095-05-08'),('2095-05-09'),('2095-05-10'),('2095-05-11'),('2095-05-12'),('2095-05-13'),('2095-05-14'),('2095-05-15'),('2095-05-16'),('2095-05-17'),('2095-05-18'),('2095-05-19'),('2095-05-20'),('2095-05-21'),('2095-05-22'),('2095-05-23'),('2095-05-24'),('2095-05-25'),('2095-05-26'),('2095-05-27'),('2095-05-28'),('2095-05-29'),('2095-05-30'),('2095-05-31'),('2095-06-01'),('2095-06-02'),('2095-06-03'),('2095-06-04'),('2095-06-05'),('2095-06-06'),('2095-06-07'),('2095-06-08'),('2095-06-09'),('2095-06-10'),('2095-06-11'),('2095-06-12'),('2095-06-13'),('2095-06-14'),('2095-06-15'),('2095-06-16'),('2095-06-17'),('2095-06-18'),('2095-06-19'),('2095-06-20'),('2095-06-21'),('2095-06-22'),('2095-06-23'),('2095-06-24'),('2095-06-25'),('2095-06-26'),('2095-06-27'),('2095-06-28'),('2095-06-29'),('2095-06-30'),('2095-07-01'),('2095-07-02'),('2095-07-03'),('2095-07-04'),('2095-07-05'),('2095-07-06'),('2095-07-07'),('2095-07-08'),('2095-07-09'),('2095-07-10'),('2095-07-11'),('2095-07-12'),('2095-07-13'),('2095-07-14'),('2095-07-15'),('2095-07-16'),('2095-07-17'),('2095-07-18'),('2095-07-19'),('2095-07-20'),('2095-07-21'),('2095-07-22'),('2095-07-23'),('2095-07-24'),('2095-07-25'),('2095-07-26'),('2095-07-27'),('2095-07-28'),('2095-07-29'),('2095-07-30'),('2095-07-31'),('2095-08-01'),('2095-08-02'),('2095-08-03'),('2095-08-04'),('2095-08-05'),('2095-08-06'),('2095-08-07'),('2095-08-08'),('2095-08-09'),('2095-08-10'),('2095-08-11'),('2095-08-12'),('2095-08-13'),('2095-08-14'),('2095-08-15'),('2095-08-16'),('2095-08-17'),('2095-08-18'),('2095-08-19'),('2095-08-20'),('2095-08-21'),('2095-08-22'),('2095-08-23'),('2095-08-24'),('2095-08-25'),('2095-08-26'),('2095-08-27'),('2095-08-28'),('2095-08-29'),('2095-08-30'),('2095-08-31'),('2095-09-01'),('2095-09-02'),('2095-09-03'),('2095-09-04'),('2095-09-05'),('2095-09-06'),('2095-09-07'),('2095-09-08'),('2095-09-09'),('2095-09-10'),('2095-09-11'),('2095-09-12'),('2095-09-13'),('2095-09-14'),('2095-09-15'),('2095-09-16'),('2095-09-17'),('2095-09-18'),('2095-09-19'),('2095-09-20'),('2095-09-21'),('2095-09-22'),('2095-09-23'),('2095-09-24'),('2095-09-25'),('2095-09-26'),('2095-09-27'),('2095-09-28'),('2095-09-29'),('2095-09-30'),('2095-10-01'),('2095-10-02'),('2095-10-03'),('2095-10-04'),('2095-10-05'),('2095-10-06'),('2095-10-07'),('2095-10-08'),('2095-10-09'),('2095-10-10'),('2095-10-11'),('2095-10-12'),('2095-10-13'),('2095-10-14'),('2095-10-15'),('2095-10-16'),('2095-10-17'),('2095-10-18'),('2095-10-19'),('2095-10-20'),('2095-10-21'),('2095-10-22'),('2095-10-23'),('2095-10-24'),('2095-10-25'),('2095-10-26'),('2095-10-27'),('2095-10-28'),('2095-10-29'),('2095-10-30'),('2095-10-31'),('2095-11-01'),('2095-11-02'),('2095-11-03'),('2095-11-04'),('2095-11-05'),('2095-11-06'),('2095-11-07'),('2095-11-08'),('2095-11-09'),('2095-11-10'),('2095-11-11'),('2095-11-12'),('2095-11-13'),('2095-11-14'),('2095-11-15'),('2095-11-16'),('2095-11-17'),('2095-11-18'),('2095-11-19'),('2095-11-20'),('2095-11-21'),('2095-11-22'),('2095-11-23'),('2095-11-24'),('2095-11-25'),('2095-11-26'),('2095-11-27'),('2095-11-28'),('2095-11-29'),('2095-11-30'),('2095-12-01'),('2095-12-02'),('2095-12-03'),('2095-12-04'),('2095-12-05'),('2095-12-06'),('2095-12-07'),('2095-12-08'),('2095-12-09'),('2095-12-10'),('2095-12-11'),('2095-12-12'),('2095-12-13'),('2095-12-14'),('2095-12-15'),('2095-12-16'),('2095-12-17'),('2095-12-18'),('2095-12-19'),('2095-12-20'),('2095-12-21'),('2095-12-22'),('2095-12-23'),('2095-12-24'),('2095-12-25'),('2095-12-26'),('2095-12-27'),('2095-12-28'),('2095-12-29'),('2095-12-30'),('2095-12-31'),('2096-01-01'),('2096-01-02'),('2096-01-03'),('2096-01-04'),('2096-01-05'),('2096-01-06'),('2096-01-07'),('2096-01-08'),('2096-01-09'),('2096-01-10'),('2096-01-11'),('2096-01-12'),('2096-01-13'),('2096-01-14'),('2096-01-15'),('2096-01-16'),('2096-01-17'),('2096-01-18'),('2096-01-19'),('2096-01-20'),('2096-01-21'),('2096-01-22'),('2096-01-23'),('2096-01-24'),('2096-01-25'),('2096-01-26'),('2096-01-27'),('2096-01-28'),('2096-01-29'),('2096-01-30'),('2096-01-31'),('2096-02-01'),('2096-02-02'),('2096-02-03'),('2096-02-04'),('2096-02-05'),('2096-02-06'),('2096-02-07'),('2096-02-08'),('2096-02-09'),('2096-02-10'),('2096-02-11'),('2096-02-12'),('2096-02-13'),('2096-02-14'),('2096-02-15'),('2096-02-16'),('2096-02-17'),('2096-02-18'),('2096-02-19'),('2096-02-20'),('2096-02-21'),('2096-02-22'),('2096-02-23'),('2096-02-24'),('2096-02-25'),('2096-02-26'),('2096-02-27'),('2096-02-28'),('2096-02-29'),('2096-03-01'),('2096-03-02'),('2096-03-03'),('2096-03-04'),('2096-03-05'),('2096-03-06'),('2096-03-07'),('2096-03-08'),('2096-03-09'),('2096-03-10'),('2096-03-11'),('2096-03-12'),('2096-03-13'),('2096-03-14'),('2096-03-15'),('2096-03-16'),('2096-03-17'),('2096-03-18'),('2096-03-19'),('2096-03-20'),('2096-03-21'),('2096-03-22'),('2096-03-23'),('2096-03-24'),('2096-03-25'),('2096-03-26'),('2096-03-27'),('2096-03-28'),('2096-03-29'),('2096-03-30'),('2096-03-31'),('2096-04-01'),('2096-04-02'),('2096-04-03'),('2096-04-04'),('2096-04-05'),('2096-04-06'),('2096-04-07'),('2096-04-08'),('2096-04-09'),('2096-04-10'),('2096-04-11'),('2096-04-12'),('2096-04-13'),('2096-04-14'),('2096-04-15'),('2096-04-16'),('2096-04-17'),('2096-04-18'),('2096-04-19'),('2096-04-20'),('2096-04-21'),('2096-04-22'),('2096-04-23'),('2096-04-24'),('2096-04-25'),('2096-04-26'),('2096-04-27'),('2096-04-28'),('2096-04-29'),('2096-04-30'),('2096-05-01'),('2096-05-02'),('2096-05-03'),('2096-05-04'),('2096-05-05'),('2096-05-06'),('2096-05-07'),('2096-05-08'),('2096-05-09'),('2096-05-10'),('2096-05-11'),('2096-05-12'),('2096-05-13'),('2096-05-14'),('2096-05-15'),('2096-05-16'),('2096-05-17'),('2096-05-18'),('2096-05-19'),('2096-05-20'),('2096-05-21'),('2096-05-22'),('2096-05-23'),('2096-05-24'),('2096-05-25'),('2096-05-26'),('2096-05-27'),('2096-05-28'),('2096-05-29'),('2096-05-30'),('2096-05-31'),('2096-06-01'),('2096-06-02'),('2096-06-03'),('2096-06-04'),('2096-06-05'),('2096-06-06'),('2096-06-07'),('2096-06-08'),('2096-06-09'),('2096-06-10'),('2096-06-11'),('2096-06-12'),('2096-06-13'),('2096-06-14'),('2096-06-15'),('2096-06-16'),('2096-06-17'),('2096-06-18'),('2096-06-19'),('2096-06-20'),('2096-06-21'),('2096-06-22'),('2096-06-23'),('2096-06-24'),('2096-06-25'),('2096-06-26'),('2096-06-27'),('2096-06-28'),('2096-06-29'),('2096-06-30'),('2096-07-01'),('2096-07-02'),('2096-07-03'),('2096-07-04'),('2096-07-05'),('2096-07-06'),('2096-07-07'),('2096-07-08'),('2096-07-09'),('2096-07-10'),('2096-07-11'),('2096-07-12'),('2096-07-13'),('2096-07-14'),('2096-07-15'),('2096-07-16'),('2096-07-17'),('2096-07-18'),('2096-07-19'),('2096-07-20'),('2096-07-21'),('2096-07-22'),('2096-07-23'),('2096-07-24'),('2096-07-25'),('2096-07-26'),('2096-07-27'),('2096-07-28'),('2096-07-29'),('2096-07-30'),('2096-07-31'),('2096-08-01'),('2096-08-02'),('2096-08-03'),('2096-08-04'),('2096-08-05'),('2096-08-06'),('2096-08-07'),('2096-08-08'),('2096-08-09'),('2096-08-10'),('2096-08-11'),('2096-08-12'),('2096-08-13'),('2096-08-14'),('2096-08-15'),('2096-08-16'),('2096-08-17'),('2096-08-18'),('2096-08-19'),('2096-08-20'),('2096-08-21'),('2096-08-22'),('2096-08-23'),('2096-08-24'),('2096-08-25'),('2096-08-26'),('2096-08-27'),('2096-08-28'),('2096-08-29'),('2096-08-30'),('2096-08-31'),('2096-09-01'),('2096-09-02'),('2096-09-03'),('2096-09-04'),('2096-09-05'),('2096-09-06'),('2096-09-07'),('2096-09-08'),('2096-09-09'),('2096-09-10'),('2096-09-11'),('2096-09-12'),('2096-09-13'),('2096-09-14'),('2096-09-15'),('2096-09-16'),('2096-09-17'),('2096-09-18'),('2096-09-19'),('2096-09-20'),('2096-09-21'),('2096-09-22'),('2096-09-23'),('2096-09-24'),('2096-09-25'),('2096-09-26'),('2096-09-27'),('2096-09-28'),('2096-09-29'),('2096-09-30'),('2096-10-01'),('2096-10-02'),('2096-10-03'),('2096-10-04'),('2096-10-05'),('2096-10-06'),('2096-10-07'),('2096-10-08'),('2096-10-09'),('2096-10-10'),('2096-10-11'),('2096-10-12'),('2096-10-13'),('2096-10-14'),('2096-10-15'),('2096-10-16'),('2096-10-17'),('2096-10-18'),('2096-10-19'),('2096-10-20'),('2096-10-21'),('2096-10-22'),('2096-10-23'),('2096-10-24'),('2096-10-25'),('2096-10-26'),('2096-10-27'),('2096-10-28'),('2096-10-29'),('2096-10-30'),('2096-10-31'),('2096-11-01'),('2096-11-02'),('2096-11-03'),('2096-11-04'),('2096-11-05'),('2096-11-06'),('2096-11-07'),('2096-11-08'),('2096-11-09'),('2096-11-10'),('2096-11-11'),('2096-11-12'),('2096-11-13'),('2096-11-14'),('2096-11-15'),('2096-11-16'),('2096-11-17'),('2096-11-18'),('2096-11-19'),('2096-11-20'),('2096-11-21'),('2096-11-22'),('2096-11-23'),('2096-11-24'),('2096-11-25'),('2096-11-26'),('2096-11-27'),('2096-11-28'),('2096-11-29'),('2096-11-30'),('2096-12-01'),('2096-12-02'),('2096-12-03'),('2096-12-04'),('2096-12-05'),('2096-12-06'),('2096-12-07'),('2096-12-08'),('2096-12-09'),('2096-12-10'),('2096-12-11'),('2096-12-12'),('2096-12-13'),('2096-12-14'),('2096-12-15'),('2096-12-16'),('2096-12-17'),('2096-12-18'),('2096-12-19'),('2096-12-20'),('2096-12-21'),('2096-12-22'),('2096-12-23'),('2096-12-24'),('2096-12-25'),('2096-12-26'),('2096-12-27'),('2096-12-28'),('2096-12-29'),('2096-12-30'),('2096-12-31'),('2097-01-01'),('2097-01-02'),('2097-01-03'),('2097-01-04'),('2097-01-05'),('2097-01-06'),('2097-01-07'),('2097-01-08'),('2097-01-09'),('2097-01-10'),('2097-01-11'),('2097-01-12'),('2097-01-13'),('2097-01-14'),('2097-01-15'),('2097-01-16'),('2097-01-17'),('2097-01-18'),('2097-01-19'),('2097-01-20'),('2097-01-21'),('2097-01-22'),('2097-01-23'),('2097-01-24'),('2097-01-25'),('2097-01-26'),('2097-01-27'),('2097-01-28'),('2097-01-29'),('2097-01-30'),('2097-01-31'),('2097-02-01'),('2097-02-02'),('2097-02-03'),('2097-02-04'),('2097-02-05'),('2097-02-06'),('2097-02-07'),('2097-02-08'),('2097-02-09'),('2097-02-10'),('2097-02-11'),('2097-02-12'),('2097-02-13'),('2097-02-14'),('2097-02-15'),('2097-02-16'),('2097-02-17'),('2097-02-18'),('2097-02-19'),('2097-02-20'),('2097-02-21'),('2097-02-22'),('2097-02-23'),('2097-02-24'),('2097-02-25'),('2097-02-26'),('2097-02-27'),('2097-02-28'),('2097-03-01'),('2097-03-02'),('2097-03-03'),('2097-03-04'),('2097-03-05'),('2097-03-06'),('2097-03-07'),('2097-03-08'),('2097-03-09'),('2097-03-10'),('2097-03-11'),('2097-03-12'),('2097-03-13'),('2097-03-14'),('2097-03-15'),('2097-03-16'),('2097-03-17'),('2097-03-18'),('2097-03-19'),('2097-03-20'),('2097-03-21'),('2097-03-22'),('2097-03-23'),('2097-03-24'),('2097-03-25'),('2097-03-26'),('2097-03-27'),('2097-03-28'),('2097-03-29'),('2097-03-30'),('2097-03-31'),('2097-04-01'),('2097-04-02'),('2097-04-03'),('2097-04-04'),('2097-04-05'),('2097-04-06'),('2097-04-07'),('2097-04-08'),('2097-04-09'),('2097-04-10'),('2097-04-11'),('2097-04-12'),('2097-04-13'),('2097-04-14'),('2097-04-15'),('2097-04-16'),('2097-04-17'),('2097-04-18'),('2097-04-19'),('2097-04-20'),('2097-04-21'),('2097-04-22'),('2097-04-23'),('2097-04-24'),('2097-04-25'),('2097-04-26'),('2097-04-27'),('2097-04-28'),('2097-04-29'),('2097-04-30'),('2097-05-01'),('2097-05-02'),('2097-05-03'),('2097-05-04'),('2097-05-05'),('2097-05-06'),('2097-05-07'),('2097-05-08'),('2097-05-09'),('2097-05-10'),('2097-05-11'),('2097-05-12'),('2097-05-13'),('2097-05-14'),('2097-05-15'),('2097-05-16'),('2097-05-17'),('2097-05-18'),('2097-05-19'),('2097-05-20'),('2097-05-21'),('2097-05-22'),('2097-05-23'),('2097-05-24'),('2097-05-25'),('2097-05-26'),('2097-05-27'),('2097-05-28'),('2097-05-29'),('2097-05-30'),('2097-05-31'),('2097-06-01'),('2097-06-02'),('2097-06-03'),('2097-06-04'),('2097-06-05'),('2097-06-06'),('2097-06-07'),('2097-06-08'),('2097-06-09'),('2097-06-10'),('2097-06-11'),('2097-06-12'),('2097-06-13'),('2097-06-14'),('2097-06-15'),('2097-06-16'),('2097-06-17'),('2097-06-18'),('2097-06-19'),('2097-06-20'),('2097-06-21'),('2097-06-22'),('2097-06-23'),('2097-06-24'),('2097-06-25'),('2097-06-26'),('2097-06-27'),('2097-06-28'),('2097-06-29'),('2097-06-30'),('2097-07-01'),('2097-07-02'),('2097-07-03'),('2097-07-04'),('2097-07-05'),('2097-07-06'),('2097-07-07'),('2097-07-08'),('2097-07-09'),('2097-07-10'),('2097-07-11'),('2097-07-12'),('2097-07-13'),('2097-07-14'),('2097-07-15'),('2097-07-16'),('2097-07-17'),('2097-07-18'),('2097-07-19'),('2097-07-20'),('2097-07-21'),('2097-07-22'),('2097-07-23'),('2097-07-24'),('2097-07-25'),('2097-07-26'),('2097-07-27'),('2097-07-28'),('2097-07-29'),('2097-07-30'),('2097-07-31'),('2097-08-01'),('2097-08-02'),('2097-08-03'),('2097-08-04'),('2097-08-05'),('2097-08-06'),('2097-08-07'),('2097-08-08'),('2097-08-09'),('2097-08-10'),('2097-08-11'),('2097-08-12'),('2097-08-13'),('2097-08-14'),('2097-08-15'),('2097-08-16'),('2097-08-17'),('2097-08-18'),('2097-08-19'),('2097-08-20'),('2097-08-21'),('2097-08-22'),('2097-08-23'),('2097-08-24'),('2097-08-25'),('2097-08-26'),('2097-08-27'),('2097-08-28'),('2097-08-29'),('2097-08-30'),('2097-08-31'),('2097-09-01'),('2097-09-02'),('2097-09-03'),('2097-09-04'),('2097-09-05'),('2097-09-06'),('2097-09-07'),('2097-09-08'),('2097-09-09'),('2097-09-10'),('2097-09-11'),('2097-09-12'),('2097-09-13'),('2097-09-14'),('2097-09-15'),('2097-09-16'),('2097-09-17'),('2097-09-18'),('2097-09-19'),('2097-09-20'),('2097-09-21'),('2097-09-22'),('2097-09-23'),('2097-09-24'),('2097-09-25'),('2097-09-26'),('2097-09-27'),('2097-09-28'),('2097-09-29'),('2097-09-30'),('2097-10-01'),('2097-10-02'),('2097-10-03'),('2097-10-04'),('2097-10-05'),('2097-10-06'),('2097-10-07'),('2097-10-08'),('2097-10-09'),('2097-10-10'),('2097-10-11'),('2097-10-12'),('2097-10-13'),('2097-10-14'),('2097-10-15'),('2097-10-16'),('2097-10-17'),('2097-10-18'),('2097-10-19'),('2097-10-20'),('2097-10-21'),('2097-10-22'),('2097-10-23'),('2097-10-24'),('2097-10-25'),('2097-10-26'),('2097-10-27'),('2097-10-28'),('2097-10-29'),('2097-10-30'),('2097-10-31'),('2097-11-01'),('2097-11-02'),('2097-11-03'),('2097-11-04'),('2097-11-05'),('2097-11-06'),('2097-11-07'),('2097-11-08'),('2097-11-09'),('2097-11-10'),('2097-11-11'),('2097-11-12'),('2097-11-13'),('2097-11-14'),('2097-11-15'),('2097-11-16'),('2097-11-17'),('2097-11-18'),('2097-11-19'),('2097-11-20'),('2097-11-21'),('2097-11-22'),('2097-11-23'),('2097-11-24'),('2097-11-25'),('2097-11-26'),('2097-11-27'),('2097-11-28'),('2097-11-29'),('2097-11-30'),('2097-12-01'),('2097-12-02'),('2097-12-03'),('2097-12-04'),('2097-12-05'),('2097-12-06'),('2097-12-07'),('2097-12-08'),('2097-12-09'),('2097-12-10'),('2097-12-11'),('2097-12-12'),('2097-12-13'),('2097-12-14'),('2097-12-15'),('2097-12-16'),('2097-12-17'),('2097-12-18'),('2097-12-19'),('2097-12-20'),('2097-12-21'),('2097-12-22'),('2097-12-23'),('2097-12-24'),('2097-12-25'),('2097-12-26'),('2097-12-27'),('2097-12-28'),('2097-12-29'),('2097-12-30'),('2097-12-31'),('2098-01-01'),('2098-01-02'),('2098-01-03'),('2098-01-04'),('2098-01-05'),('2098-01-06'),('2098-01-07'),('2098-01-08'),('2098-01-09'),('2098-01-10'),('2098-01-11'),('2098-01-12'),('2098-01-13'),('2098-01-14'),('2098-01-15'),('2098-01-16'),('2098-01-17'),('2098-01-18'),('2098-01-19'),('2098-01-20'),('2098-01-21'),('2098-01-22'),('2098-01-23'),('2098-01-24'),('2098-01-25'),('2098-01-26'),('2098-01-27'),('2098-01-28'),('2098-01-29'),('2098-01-30'),('2098-01-31'),('2098-02-01'),('2098-02-02'),('2098-02-03'),('2098-02-04'),('2098-02-05'),('2098-02-06'),('2098-02-07'),('2098-02-08'),('2098-02-09'),('2098-02-10'),('2098-02-11'),('2098-02-12'),('2098-02-13'),('2098-02-14'),('2098-02-15'),('2098-02-16'),('2098-02-17'),('2098-02-18'),('2098-02-19'),('2098-02-20'),('2098-02-21'),('2098-02-22'),('2098-02-23'),('2098-02-24'),('2098-02-25'),('2098-02-26'),('2098-02-27'),('2098-02-28'),('2098-03-01'),('2098-03-02'),('2098-03-03'),('2098-03-04'),('2098-03-05'),('2098-03-06'),('2098-03-07'),('2098-03-08'),('2098-03-09'),('2098-03-10'),('2098-03-11'),('2098-03-12'),('2098-03-13'),('2098-03-14'),('2098-03-15'),('2098-03-16'),('2098-03-17'),('2098-03-18'),('2098-03-19'),('2098-03-20'),('2098-03-21'),('2098-03-22'),('2098-03-23'),('2098-03-24'),('2098-03-25'),('2098-03-26'),('2098-03-27'),('2098-03-28'),('2098-03-29'),('2098-03-30'),('2098-03-31'),('2098-04-01'),('2098-04-02'),('2098-04-03'),('2098-04-04'),('2098-04-05'),('2098-04-06'),('2098-04-07'),('2098-04-08'),('2098-04-09'),('2098-04-10'),('2098-04-11'),('2098-04-12'),('2098-04-13'),('2098-04-14'),('2098-04-15'),('2098-04-16'),('2098-04-17'),('2098-04-18'),('2098-04-19'),('2098-04-20'),('2098-04-21'),('2098-04-22'),('2098-04-23'),('2098-04-24'),('2098-04-25'),('2098-04-26'),('2098-04-27'),('2098-04-28'),('2098-04-29'),('2098-04-30'),('2098-05-01'),('2098-05-02'),('2098-05-03'),('2098-05-04'),('2098-05-05'),('2098-05-06'),('2098-05-07'),('2098-05-08'),('2098-05-09'),('2098-05-10'),('2098-05-11'),('2098-05-12'),('2098-05-13'),('2098-05-14'),('2098-05-15'),('2098-05-16'),('2098-05-17'),('2098-05-18'),('2098-05-19'),('2098-05-20'),('2098-05-21'),('2098-05-22'),('2098-05-23'),('2098-05-24'),('2098-05-25'),('2098-05-26'),('2098-05-27'),('2098-05-28'),('2098-05-29'),('2098-05-30'),('2098-05-31'),('2098-06-01'),('2098-06-02'),('2098-06-03'),('2098-06-04'),('2098-06-05'),('2098-06-06'),('2098-06-07'),('2098-06-08'),('2098-06-09'),('2098-06-10'),('2098-06-11'),('2098-06-12'),('2098-06-13'),('2098-06-14'),('2098-06-15'),('2098-06-16'),('2098-06-17'),('2098-06-18'),('2098-06-19'),('2098-06-20'),('2098-06-21'),('2098-06-22'),('2098-06-23'),('2098-06-24'),('2098-06-25'),('2098-06-26'),('2098-06-27'),('2098-06-28'),('2098-06-29'),('2098-06-30'),('2098-07-01'),('2098-07-02'),('2098-07-03'),('2098-07-04'),('2098-07-05'),('2098-07-06'),('2098-07-07'),('2098-07-08'),('2098-07-09'),('2098-07-10'),('2098-07-11'),('2098-07-12'),('2098-07-13'),('2098-07-14'),('2098-07-15'),('2098-07-16'),('2098-07-17'),('2098-07-18'),('2098-07-19'),('2098-07-20'),('2098-07-21'),('2098-07-22'),('2098-07-23'),('2098-07-24'),('2098-07-25'),('2098-07-26'),('2098-07-27'),('2098-07-28'),('2098-07-29'),('2098-07-30'),('2098-07-31'),('2098-08-01'),('2098-08-02'),('2098-08-03'),('2098-08-04'),('2098-08-05'),('2098-08-06'),('2098-08-07'),('2098-08-08'),('2098-08-09'),('2098-08-10'),('2098-08-11'),('2098-08-12'),('2098-08-13'),('2098-08-14'),('2098-08-15'),('2098-08-16'),('2098-08-17'),('2098-08-18'),('2098-08-19'),('2098-08-20'),('2098-08-21'),('2098-08-22'),('2098-08-23'),('2098-08-24'),('2098-08-25'),('2098-08-26'),('2098-08-27'),('2098-08-28'),('2098-08-29'),('2098-08-30'),('2098-08-31'),('2098-09-01'),('2098-09-02'),('2098-09-03'),('2098-09-04'),('2098-09-05'),('2098-09-06'),('2098-09-07'),('2098-09-08'),('2098-09-09'),('2098-09-10'),('2098-09-11'),('2098-09-12'),('2098-09-13'),('2098-09-14'),('2098-09-15'),('2098-09-16'),('2098-09-17'),('2098-09-18'),('2098-09-19'),('2098-09-20'),('2098-09-21'),('2098-09-22'),('2098-09-23'),('2098-09-24'),('2098-09-25'),('2098-09-26'),('2098-09-27'),('2098-09-28'),('2098-09-29'),('2098-09-30'),('2098-10-01'),('2098-10-02'),('2098-10-03'),('2098-10-04'),('2098-10-05'),('2098-10-06'),('2098-10-07'),('2098-10-08'),('2098-10-09'),('2098-10-10'),('2098-10-11'),('2098-10-12'),('2098-10-13'),('2098-10-14'),('2098-10-15'),('2098-10-16'),('2098-10-17'),('2098-10-18'),('2098-10-19'),('2098-10-20'),('2098-10-21'),('2098-10-22'),('2098-10-23'),('2098-10-24'),('2098-10-25'),('2098-10-26'),('2098-10-27'),('2098-10-28'),('2098-10-29'),('2098-10-30'),('2098-10-31'),('2098-11-01'),('2098-11-02'),('2098-11-03'),('2098-11-04'),('2098-11-05'),('2098-11-06'),('2098-11-07'),('2098-11-08'),('2098-11-09'),('2098-11-10'),('2098-11-11'),('2098-11-12'),('2098-11-13'),('2098-11-14'),('2098-11-15'),('2098-11-16'),('2098-11-17'),('2098-11-18'),('2098-11-19'),('2098-11-20'),('2098-11-21'),('2098-11-22'),('2098-11-23'),('2098-11-24'),('2098-11-25'),('2098-11-26'),('2098-11-27'),('2098-11-28'),('2098-11-29'),('2098-11-30'),('2098-12-01'),('2098-12-02'),('2098-12-03'),('2098-12-04'),('2098-12-05'),('2098-12-06'),('2098-12-07'),('2098-12-08'),('2098-12-09'),('2098-12-10'),('2098-12-11'),('2098-12-12'),('2098-12-13'),('2098-12-14'),('2098-12-15'),('2098-12-16'),('2098-12-17'),('2098-12-18'),('2098-12-19'),('2098-12-20'),('2098-12-21'),('2098-12-22'),('2098-12-23'),('2098-12-24'),('2098-12-25'),('2098-12-26'),('2098-12-27'),('2098-12-28'),('2098-12-29'),('2098-12-30'),('2098-12-31'),('2099-01-01'),('2099-01-02'),('2099-01-03'),('2099-01-04'),('2099-01-05'),('2099-01-06'),('2099-01-07'),('2099-01-08'),('2099-01-09'),('2099-01-10'),('2099-01-11'),('2099-01-12'),('2099-01-13'),('2099-01-14'),('2099-01-15'),('2099-01-16'),('2099-01-17'),('2099-01-18'),('2099-01-19'),('2099-01-20'),('2099-01-21'),('2099-01-22'),('2099-01-23'),('2099-01-24'),('2099-01-25'),('2099-01-26'),('2099-01-27'),('2099-01-28'),('2099-01-29'),('2099-01-30'),('2099-01-31'),('2099-02-01'),('2099-02-02'),('2099-02-03'),('2099-02-04'),('2099-02-05'),('2099-02-06'),('2099-02-07'),('2099-02-08'),('2099-02-09'),('2099-02-10'),('2099-02-11'),('2099-02-12'),('2099-02-13'),('2099-02-14'),('2099-02-15'),('2099-02-16'),('2099-02-17'),('2099-02-18'),('2099-02-19'),('2099-02-20'),('2099-02-21'),('2099-02-22'),('2099-02-23'),('2099-02-24'),('2099-02-25'),('2099-02-26'),('2099-02-27'),('2099-02-28'),('2099-03-01'),('2099-03-02'),('2099-03-03'),('2099-03-04'),('2099-03-05'),('2099-03-06'),('2099-03-07'),('2099-03-08'),('2099-03-09'),('2099-03-10'),('2099-03-11'),('2099-03-12'),('2099-03-13'),('2099-03-14'),('2099-03-15'),('2099-03-16'),('2099-03-17'),('2099-03-18'),('2099-03-19'),('2099-03-20'),('2099-03-21'),('2099-03-22'),('2099-03-23'),('2099-03-24'),('2099-03-25'),('2099-03-26'),('2099-03-27'),('2099-03-28'),('2099-03-29'),('2099-03-30'),('2099-03-31'),('2099-04-01'),('2099-04-02'),('2099-04-03'),('2099-04-04'),('2099-04-05'),('2099-04-06'),('2099-04-07'),('2099-04-08'),('2099-04-09'),('2099-04-10'),('2099-04-11'),('2099-04-12'),('2099-04-13'),('2099-04-14'),('2099-04-15'),('2099-04-16'),('2099-04-17'),('2099-04-18'),('2099-04-19'),('2099-04-20'),('2099-04-21'),('2099-04-22'),('2099-04-23'),('2099-04-24'),('2099-04-25'),('2099-04-26'),('2099-04-27'),('2099-04-28'),('2099-04-29'),('2099-04-30'),('2099-05-01'),('2099-05-02'),('2099-05-03'),('2099-05-04'),('2099-05-05'),('2099-05-06'),('2099-05-07'),('2099-05-08'),('2099-05-09'),('2099-05-10'),('2099-05-11'),('2099-05-12'),('2099-05-13'),('2099-05-14'),('2099-05-15'),('2099-05-16'),('2099-05-17'),('2099-05-18'),('2099-05-19'),('2099-05-20'),('2099-05-21'),('2099-05-22'),('2099-05-23'),('2099-05-24'),('2099-05-25'),('2099-05-26'),('2099-05-27'),('2099-05-28'),('2099-05-29'),('2099-05-30'),('2099-05-31'),('2099-06-01'),('2099-06-02'),('2099-06-03'),('2099-06-04'),('2099-06-05'),('2099-06-06'),('2099-06-07'),('2099-06-08'),('2099-06-09'),('2099-06-10'),('2099-06-11'),('2099-06-12'),('2099-06-13'),('2099-06-14'),('2099-06-15'),('2099-06-16'),('2099-06-17'),('2099-06-18'),('2099-06-19'),('2099-06-20'),('2099-06-21'),('2099-06-22'),('2099-06-23'),('2099-06-24'),('2099-06-25'),('2099-06-26'),('2099-06-27'),('2099-06-28'),('2099-06-29'),('2099-06-30'),('2099-07-01'),('2099-07-02'),('2099-07-03'),('2099-07-04'),('2099-07-05'),('2099-07-06'),('2099-07-07'),('2099-07-08'),('2099-07-09'),('2099-07-10'),('2099-07-11'),('2099-07-12'),('2099-07-13'),('2099-07-14'),('2099-07-15'),('2099-07-16'),('2099-07-17'),('2099-07-18'),('2099-07-19'),('2099-07-20'),('2099-07-21'),('2099-07-22'),('2099-07-23'),('2099-07-24'),('2099-07-25'),('2099-07-26'),('2099-07-27'),('2099-07-28'),('2099-07-29'),('2099-07-30'),('2099-07-31'),('2099-08-01'),('2099-08-02'),('2099-08-03'),('2099-08-04'),('2099-08-05'),('2099-08-06'),('2099-08-07'),('2099-08-08'),('2099-08-09'),('2099-08-10'),('2099-08-11'),('2099-08-12'),('2099-08-13'),('2099-08-14'),('2099-08-15'),('2099-08-16'),('2099-08-17'),('2099-08-18'),('2099-08-19'),('2099-08-20'),('2099-08-21'),('2099-08-22'),('2099-08-23'),('2099-08-24'),('2099-08-25'),('2099-08-26'),('2099-08-27'),('2099-08-28'),('2099-08-29'),('2099-08-30'),('2099-08-31'),('2099-09-01'),('2099-09-02'),('2099-09-03'),('2099-09-04'),('2099-09-05'),('2099-09-06'),('2099-09-07'),('2099-09-08'),('2099-09-09'),('2099-09-10'),('2099-09-11'),('2099-09-12'),('2099-09-13'),('2099-09-14'),('2099-09-15'),('2099-09-16'),('2099-09-17'),('2099-09-18'),('2099-09-19'),('2099-09-20'),('2099-09-21'),('2099-09-22'),('2099-09-23'),('2099-09-24'),('2099-09-25'),('2099-09-26'),('2099-09-27'),('2099-09-28'),('2099-09-29'),('2099-09-30'),('2099-10-01'),('2099-10-02'),('2099-10-03'),('2099-10-04'),('2099-10-05'),('2099-10-06'),('2099-10-07'),('2099-10-08'),('2099-10-09'),('2099-10-10'),('2099-10-11'),('2099-10-12'),('2099-10-13'),('2099-10-14'),('2099-10-15'),('2099-10-16'),('2099-10-17'),('2099-10-18'),('2099-10-19'),('2099-10-20'),('2099-10-21'),('2099-10-22'),('2099-10-23'),('2099-10-24'),('2099-10-25'),('2099-10-26'),('2099-10-27'),('2099-10-28'),('2099-10-29'),('2099-10-30'),('2099-10-31'),('2099-11-01'),('2099-11-02'),('2099-11-03'),('2099-11-04'),('2099-11-05'),('2099-11-06'),('2099-11-07'),('2099-11-08'),('2099-11-09'),('2099-11-10'),('2099-11-11'),('2099-11-12'),('2099-11-13'),('2099-11-14'),('2099-11-15'),('2099-11-16'),('2099-11-17'),('2099-11-18'),('2099-11-19'),('2099-11-20'),('2099-11-21'),('2099-11-22'),('2099-11-23'),('2099-11-24'),('2099-11-25'),('2099-11-26'),('2099-11-27'),('2099-11-28'),('2099-11-29'),('2099-11-30'),('2099-12-01'),('2099-12-02'),('2099-12-03'),('2099-12-04'),('2099-12-05'),('2099-12-06'),('2099-12-07'),('2099-12-08'),('2099-12-09'),('2099-12-10'),('2099-12-11'),('2099-12-12'),('2099-12-13'),('2099-12-14'),('2099-12-15'),('2099-12-16'),('2099-12-17'),('2099-12-18'),('2099-12-19'),('2099-12-20'),('2099-12-21'),('2099-12-22'),('2099-12-23'),('2099-12-24'),('2099-12-25'),('2099-12-26'),('2099-12-27'),('2099-12-28'),('2099-12-29'),('2099-12-30'),('2099-12-31'),('2100-01-01'),('2100-01-02'),('2100-01-03'),('2100-01-04'),('2100-01-05'),('2100-01-06'),('2100-01-07'),('2100-01-08'),('2100-01-09'),('2100-01-10'),('2100-01-11'),('2100-01-12'),('2100-01-13'),('2100-01-14'),('2100-01-15'),('2100-01-16'),('2100-01-17'),('2100-01-18'),('2100-01-19'),('2100-01-20'),('2100-01-21'),('2100-01-22'),('2100-01-23'),('2100-01-24'),('2100-01-25'),('2100-01-26'),('2100-01-27'),('2100-01-28'),('2100-01-29'),('2100-01-30'),('2100-01-31'),('2100-02-01'),('2100-02-02'),('2100-02-03'),('2100-02-04'),('2100-02-05'),('2100-02-06'),('2100-02-07'),('2100-02-08'),('2100-02-09'),('2100-02-10'),('2100-02-11'),('2100-02-12'),('2100-02-13'),('2100-02-14'),('2100-02-15'),('2100-02-16'),('2100-02-17'),('2100-02-18'),('2100-02-19'),('2100-02-20'),('2100-02-21'),('2100-02-22'),('2100-02-23'),('2100-02-24'),('2100-02-25'),('2100-02-26'),('2100-02-27'),('2100-02-28'),('2100-03-01'),('2100-03-02'),('2100-03-03'),('2100-03-04'),('2100-03-05'),('2100-03-06'),('2100-03-07'),('2100-03-08'),('2100-03-09'),('2100-03-10'),('2100-03-11'),('2100-03-12'),('2100-03-13'),('2100-03-14'),('2100-03-15'),('2100-03-16'),('2100-03-17'),('2100-03-18'),('2100-03-19'),('2100-03-20'),('2100-03-21'),('2100-03-22'),('2100-03-23'),('2100-03-24'),('2100-03-25'),('2100-03-26'),('2100-03-27'),('2100-03-28'),('2100-03-29'),('2100-03-30'),('2100-03-31'),('2100-04-01'),('2100-04-02'),('2100-04-03'),('2100-04-04'),('2100-04-05'),('2100-04-06'),('2100-04-07'),('2100-04-08'),('2100-04-09'),('2100-04-10'),('2100-04-11'),('2100-04-12'),('2100-04-13'),('2100-04-14'),('2100-04-15'),('2100-04-16'),('2100-04-17'),('2100-04-18'),('2100-04-19'),('2100-04-20'),('2100-04-21'),('2100-04-22'),('2100-04-23'),('2100-04-24'),('2100-04-25'),('2100-04-26'),('2100-04-27'),('2100-04-28'),('2100-04-29'),('2100-04-30'),('2100-05-01'),('2100-05-02'),('2100-05-03'),('2100-05-04'),('2100-05-05'),('2100-05-06'),('2100-05-07'),('2100-05-08'),('2100-05-09'),('2100-05-10'),('2100-05-11'),('2100-05-12'),('2100-05-13'),('2100-05-14'),('2100-05-15'),('2100-05-16'),('2100-05-17'),('2100-05-18'),('2100-05-19'),('2100-05-20'),('2100-05-21'),('2100-05-22'),('2100-05-23'),('2100-05-24'),('2100-05-25'),('2100-05-26'),('2100-05-27'),('2100-05-28'),('2100-05-29'),('2100-05-30'),('2100-05-31'),('2100-06-01'),('2100-06-02'),('2100-06-03'),('2100-06-04'),('2100-06-05'),('2100-06-06'),('2100-06-07'),('2100-06-08'),('2100-06-09'),('2100-06-10'),('2100-06-11'),('2100-06-12'),('2100-06-13'),('2100-06-14'),('2100-06-15'),('2100-06-16'),('2100-06-17'),('2100-06-18'),('2100-06-19'),('2100-06-20'),('2100-06-21'),('2100-06-22'),('2100-06-23'),('2100-06-24'),('2100-06-25'),('2100-06-26'),('2100-06-27'),('2100-06-28'),('2100-06-29'),('2100-06-30'),('2100-07-01'),('2100-07-02'),('2100-07-03'),('2100-07-04'),('2100-07-05'),('2100-07-06'),('2100-07-07'),('2100-07-08'),('2100-07-09'),('2100-07-10'),('2100-07-11'),('2100-07-12'),('2100-07-13'),('2100-07-14'),('2100-07-15'),('2100-07-16'),('2100-07-17'),('2100-07-18'),('2100-07-19'),('2100-07-20'),('2100-07-21'),('2100-07-22'),('2100-07-23'),('2100-07-24'),('2100-07-25'),('2100-07-26'),('2100-07-27'),('2100-07-28'),('2100-07-29'),('2100-07-30'),('2100-07-31'),('2100-08-01'),('2100-08-02'),('2100-08-03'),('2100-08-04'),('2100-08-05'),('2100-08-06'),('2100-08-07'),('2100-08-08'),('2100-08-09'),('2100-08-10'),('2100-08-11'),('2100-08-12'),('2100-08-13'),('2100-08-14'),('2100-08-15'),('2100-08-16'),('2100-08-17'),('2100-08-18'),('2100-08-19'),('2100-08-20'),('2100-08-21'),('2100-08-22'),('2100-08-23'),('2100-08-24'),('2100-08-25'),('2100-08-26'),('2100-08-27'),('2100-08-28'),('2100-08-29'),('2100-08-30'),('2100-08-31'),('2100-09-01'),('2100-09-02'),('2100-09-03'),('2100-09-04'),('2100-09-05'),('2100-09-06'),('2100-09-07'),('2100-09-08'),('2100-09-09'),('2100-09-10'),('2100-09-11'),('2100-09-12'),('2100-09-13'),('2100-09-14'),('2100-09-15'),('2100-09-16'),('2100-09-17'),('2100-09-18'),('2100-09-19'),('2100-09-20'),('2100-09-21'),('2100-09-22'),('2100-09-23'),('2100-09-24'),('2100-09-25'),('2100-09-26'),('2100-09-27'),('2100-09-28'),('2100-09-29'),('2100-09-30'),('2100-10-01'),('2100-10-02'),('2100-10-03'),('2100-10-04'),('2100-10-05'),('2100-10-06'),('2100-10-07'),('2100-10-08'),('2100-10-09'),('2100-10-10'),('2100-10-11'),('2100-10-12'),('2100-10-13'),('2100-10-14'),('2100-10-15'),('2100-10-16'),('2100-10-17'),('2100-10-18'),('2100-10-19'),('2100-10-20'),('2100-10-21'),('2100-10-22'),('2100-10-23'),('2100-10-24'),('2100-10-25'),('2100-10-26'),('2100-10-27'),('2100-10-28'),('2100-10-29'),('2100-10-30'),('2100-10-31'),('2100-11-01'),('2100-11-02'),('2100-11-03'),('2100-11-04'),('2100-11-05'),('2100-11-06'),('2100-11-07'),('2100-11-08'),('2100-11-09'),('2100-11-10'),('2100-11-11'),('2100-11-12'),('2100-11-13'),('2100-11-14'),('2100-11-15'),('2100-11-16'),('2100-11-17'),('2100-11-18'),('2100-11-19'),('2100-11-20'),('2100-11-21'),('2100-11-22'),('2100-11-23'),('2100-11-24'),('2100-11-25'),('2100-11-26'),('2100-11-27'),('2100-11-28'),('2100-11-29'),('2100-11-30'),('2100-12-01'),('2100-12-02'),('2100-12-03'),('2100-12-04'),('2100-12-05'),('2100-12-06'),('2100-12-07'),('2100-12-08'),('2100-12-09'),('2100-12-10'),('2100-12-11'),('2100-12-12'),('2100-12-13'),('2100-12-14'),('2100-12-15'),('2100-12-16'),('2100-12-17'),('2100-12-18'),('2100-12-19'),('2100-12-20'),('2100-12-21'),('2100-12-22'),('2100-12-23'),('2100-12-24'),('2100-12-25'),('2100-12-26'),('2100-12-27'),('2100-12-28'),('2100-12-29'),('2100-12-30'),('2100-12-31'),('2101-01-01'),('2101-01-02'),('2101-01-03'),('2101-01-04'),('2101-01-05'),('2101-01-06'),('2101-01-07'),('2101-01-08'),('2101-01-09'),('2101-01-10'),('2101-01-11'),('2101-01-12'),('2101-01-13'),('2101-01-14'),('2101-01-15'),('2101-01-16'),('2101-01-17'),('2101-01-18'),('2101-01-19'),('2101-01-20'),('2101-01-21'),('2101-01-22'),('2101-01-23'),('2101-01-24'),('2101-01-25'),('2101-01-26'),('2101-01-27'),('2101-01-28'),('2101-01-29'),('2101-01-30'),('2101-01-31'),('2101-02-01'),('2101-02-02'),('2101-02-03'),('2101-02-04'),('2101-02-05'),('2101-02-06'),('2101-02-07'),('2101-02-08'),('2101-02-09'),('2101-02-10'),('2101-02-11'),('2101-02-12'),('2101-02-13'),('2101-02-14'),('2101-02-15'),('2101-02-16'),('2101-02-17'),('2101-02-18'),('2101-02-19'),('2101-02-20'),('2101-02-21'),('2101-02-22'),('2101-02-23'),('2101-02-24'),('2101-02-25'),('2101-02-26'),('2101-02-27'),('2101-02-28'),('2101-03-01'),('2101-03-02'),('2101-03-03'),('2101-03-04'),('2101-03-05'),('2101-03-06'),('2101-03-07'),('2101-03-08'),('2101-03-09'),('2101-03-10'),('2101-03-11'),('2101-03-12'),('2101-03-13'),('2101-03-14'),('2101-03-15'),('2101-03-16'),('2101-03-17'),('2101-03-18'),('2101-03-19'),('2101-03-20'),('2101-03-21'),('2101-03-22'),('2101-03-23'),('2101-03-24'),('2101-03-25'),('2101-03-26'),('2101-03-27'),('2101-03-28'),('2101-03-29'),('2101-03-30'),('2101-03-31'),('2101-04-01'),('2101-04-02'),('2101-04-03'),('2101-04-04'),('2101-04-05'),('2101-04-06'),('2101-04-07'),('2101-04-08'),('2101-04-09'),('2101-04-10'),('2101-04-11'),('2101-04-12'),('2101-04-13'),('2101-04-14'),('2101-04-15'),('2101-04-16'),('2101-04-17'),('2101-04-18'),('2101-04-19'),('2101-04-20'),('2101-04-21'),('2101-04-22'),('2101-04-23'),('2101-04-24'),('2101-04-25'),('2101-04-26'),('2101-04-27'),('2101-04-28'),('2101-04-29'),('2101-04-30'),('2101-05-01'),('2101-05-02'),('2101-05-03'),('2101-05-04'),('2101-05-05'),('2101-05-06'),('2101-05-07'),('2101-05-08'),('2101-05-09'),('2101-05-10'),('2101-05-11'),('2101-05-12'),('2101-05-13'),('2101-05-14'),('2101-05-15'),('2101-05-16'),('2101-05-17'),('2101-05-18'),('2101-05-19'),('2101-05-20'),('2101-05-21'),('2101-05-22'),('2101-05-23'),('2101-05-24'),('2101-05-25'),('2101-05-26'),('2101-05-27'),('2101-05-28'),('2101-05-29'),('2101-05-30'),('2101-05-31'),('2101-06-01'),('2101-06-02'),('2101-06-03'),('2101-06-04'),('2101-06-05'),('2101-06-06'),('2101-06-07'),('2101-06-08'),('2101-06-09'),('2101-06-10'),('2101-06-11'),('2101-06-12'),('2101-06-13'),('2101-06-14'),('2101-06-15'),('2101-06-16'),('2101-06-17'),('2101-06-18'),('2101-06-19'),('2101-06-20'),('2101-06-21'),('2101-06-22'),('2101-06-23'),('2101-06-24'),('2101-06-25'),('2101-06-26'),('2101-06-27'),('2101-06-28'),('2101-06-29'),('2101-06-30'),('2101-07-01'),('2101-07-02'),('2101-07-03'),('2101-07-04'),('2101-07-05'),('2101-07-06'),('2101-07-07'),('2101-07-08'),('2101-07-09'),('2101-07-10'),('2101-07-11'),('2101-07-12'),('2101-07-13'),('2101-07-14'),('2101-07-15'),('2101-07-16'),('2101-07-17'),('2101-07-18'),('2101-07-19'),('2101-07-20'),('2101-07-21'),('2101-07-22'),('2101-07-23'),('2101-07-24'),('2101-07-25'),('2101-07-26'),('2101-07-27'),('2101-07-28'),('2101-07-29'),('2101-07-30'),('2101-07-31'),('2101-08-01'),('2101-08-02'),('2101-08-03'),('2101-08-04'),('2101-08-05'),('2101-08-06'),('2101-08-07'),('2101-08-08'),('2101-08-09'),('2101-08-10'),('2101-08-11'),('2101-08-12'),('2101-08-13'),('2101-08-14'),('2101-08-15'),('2101-08-16'),('2101-08-17'),('2101-08-18'),('2101-08-19'),('2101-08-20'),('2101-08-21'),('2101-08-22'),('2101-08-23'),('2101-08-24'),('2101-08-25'),('2101-08-26'),('2101-08-27'),('2101-08-28'),('2101-08-29'),('2101-08-30'),('2101-08-31'),('2101-09-01'),('2101-09-02'),('2101-09-03'),('2101-09-04'),('2101-09-05'),('2101-09-06'),('2101-09-07'),('2101-09-08'),('2101-09-09'),('2101-09-10'),('2101-09-11'),('2101-09-12'),('2101-09-13'),('2101-09-14'),('2101-09-15'),('2101-09-16'),('2101-09-17'),('2101-09-18'),('2101-09-19'),('2101-09-20'),('2101-09-21'),('2101-09-22'),('2101-09-23'),('2101-09-24'),('2101-09-25'),('2101-09-26'),('2101-09-27'),('2101-09-28'),('2101-09-29'),('2101-09-30'),('2101-10-01'),('2101-10-02'),('2101-10-03'),('2101-10-04'),('2101-10-05'),('2101-10-06'),('2101-10-07'),('2101-10-08'),('2101-10-09'),('2101-10-10'),('2101-10-11'),('2101-10-12'),('2101-10-13'),('2101-10-14'),('2101-10-15'),('2101-10-16'),('2101-10-17'),('2101-10-18'),('2101-10-19'),('2101-10-20'),('2101-10-21'),('2101-10-22'),('2101-10-23'),('2101-10-24'),('2101-10-25'),('2101-10-26'),('2101-10-27'),('2101-10-28'),('2101-10-29'),('2101-10-30'),('2101-10-31'),('2101-11-01'),('2101-11-02'),('2101-11-03'),('2101-11-04'),('2101-11-05'),('2101-11-06'),('2101-11-07'),('2101-11-08'),('2101-11-09'),('2101-11-10'),('2101-11-11'),('2101-11-12'),('2101-11-13'),('2101-11-14'),('2101-11-15'),('2101-11-16'),('2101-11-17'),('2101-11-18'),('2101-11-19'),('2101-11-20'),('2101-11-21'),('2101-11-22'),('2101-11-23'),('2101-11-24'),('2101-11-25'),('2101-11-26'),('2101-11-27'),('2101-11-28'),('2101-11-29'),('2101-11-30'),('2101-12-01'),('2101-12-02'),('2101-12-03'),('2101-12-04'),('2101-12-05'),('2101-12-06'),('2101-12-07'),('2101-12-08'),('2101-12-09'),('2101-12-10'),('2101-12-11'),('2101-12-12'),('2101-12-13'),('2101-12-14'),('2101-12-15'),('2101-12-16'),('2101-12-17'),('2101-12-18'),('2101-12-19'),('2101-12-20'),('2101-12-21'),('2101-12-22'),('2101-12-23'),('2101-12-24'),('2101-12-25'),('2101-12-26'),('2101-12-27'),('2101-12-28'),('2101-12-29'),('2101-12-30'),('2101-12-31'),('2102-01-01'),('2102-01-02'),('2102-01-03'),('2102-01-04'),('2102-01-05'),('2102-01-06'),('2102-01-07'),('2102-01-08'),('2102-01-09'),('2102-01-10'),('2102-01-11'),('2102-01-12'),('2102-01-13'),('2102-01-14'),('2102-01-15'),('2102-01-16'),('2102-01-17'),('2102-01-18'),('2102-01-19'),('2102-01-20'),('2102-01-21'),('2102-01-22'),('2102-01-23'),('2102-01-24'),('2102-01-25'),('2102-01-26'),('2102-01-27'),('2102-01-28'),('2102-01-29'),('2102-01-30'),('2102-01-31'),('2102-02-01'),('2102-02-02'),('2102-02-03'),('2102-02-04'),('2102-02-05'),('2102-02-06'),('2102-02-07'),('2102-02-08'),('2102-02-09'),('2102-02-10'),('2102-02-11'),('2102-02-12'),('2102-02-13'),('2102-02-14'),('2102-02-15'),('2102-02-16'),('2102-02-17'),('2102-02-18'),('2102-02-19');
/*!40000 ALTER TABLE `sla_calendar_dates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sla_calendar_override_history`
--

DROP TABLE IF EXISTS `sla_calendar_override_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sla_calendar_override_history` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `calendar_override_id` bigint(20) unsigned NOT NULL,
  `calendar_id` int(10) unsigned NOT NULL,
  `override_date` date NOT NULL,
  `override_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_business_day` tinyint(1) NOT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_code` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `changed_by` int(10) unsigned NOT NULL,
  `changed_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_sla_override_history_date` (`calendar_id`,`override_date`,`changed_at`,`id`),
  KEY `idx_sla_override_history_record` (`calendar_override_id`,`id`),
  KEY `fk_sla_override_history_actor` (`changed_by`),
  CONSTRAINT `fk_sla_override_history_actor` FOREIGN KEY (`changed_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_sla_override_history_calendar` FOREIGN KEY (`calendar_id`) REFERENCES `sla_calendars` (`id`),
  CONSTRAINT `fk_sla_override_history_override` FOREIGN KEY (`calendar_override_id`) REFERENCES `sla_calendar_overrides` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sla_calendar_override_history`
--

LOCK TABLES `sla_calendar_override_history` WRITE;
/*!40000 ALTER TABLE `sla_calendar_override_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `sla_calendar_override_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sla_calendar_overrides`
--

DROP TABLE IF EXISTS `sla_calendar_overrides`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sla_calendar_overrides` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `calendar_id` int(10) unsigned NOT NULL,
  `override_date` date NOT NULL,
  `override_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_business_day` tinyint(1) NOT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_by` int(10) unsigned NOT NULL,
  `updated_by` int(10) unsigned DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_sla_calendar_override_date` (`calendar_id`,`override_date`),
  KEY `idx_sla_calendar_overrides_date_status` (`override_date`,`status`),
  KEY `fk_sla_calendar_overrides_created_by` (`created_by`),
  KEY `fk_sla_calendar_overrides_updated_by` (`updated_by`),
  CONSTRAINT `fk_sla_calendar_overrides_calendar` FOREIGN KEY (`calendar_id`) REFERENCES `sla_calendars` (`id`),
  CONSTRAINT `fk_sla_calendar_overrides_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_sla_calendar_overrides_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sla_calendar_overrides`
--

LOCK TABLES `sla_calendar_overrides` WRITE;
/*!40000 ALTER TABLE `sla_calendar_overrides` DISABLE KEYS */;
/*!40000 ALTER TABLE `sla_calendar_overrides` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sla_calendar_weekdays`
--

DROP TABLE IF EXISTS `sla_calendar_weekdays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sla_calendar_weekdays` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `calendar_id` int(10) unsigned NOT NULL,
  `weekday_number` tinyint(3) unsigned NOT NULL,
  `weekday_name` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_business_day` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_sla_calendar_weekday` (`calendar_id`,`weekday_number`),
  CONSTRAINT `fk_sla_calendar_weekdays_calendar` FOREIGN KEY (`calendar_id`) REFERENCES `sla_calendars` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sla_calendar_weekdays`
--

LOCK TABLES `sla_calendar_weekdays` WRITE;
/*!40000 ALTER TABLE `sla_calendar_weekdays` DISABLE KEYS */;
INSERT INTO `sla_calendar_weekdays` VALUES (1,1,1,'Monday',1),(2,1,2,'Tuesday',1),(3,1,3,'Wednesday',1),(4,1,4,'Thursday',1),(5,1,5,'Friday',1),(6,1,6,'Saturday',0),(7,1,7,'Sunday',0);
/*!40000 ALTER TABLE `sla_calendar_weekdays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sla_calendars`
--

DROP TABLE IF EXISTS `sla_calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sla_calendars` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `calendar_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `timezone_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'America/Port_of_Spain',
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `created_by` int(10) unsigned DEFAULT NULL,
  `updated_by` int(10) unsigned DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_sla_calendars_code` (`calendar_code`),
  KEY `idx_sla_calendars_status_default` (`status`,`is_default`),
  KEY `fk_sla_calendars_created_by` (`created_by`),
  KEY `fk_sla_calendars_updated_by` (`updated_by`),
  CONSTRAINT `fk_sla_calendars_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_sla_calendars_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sla_calendars`
--

LOCK TABLES `sla_calendars` WRITE;
/*!40000 ALTER TABLE `sla_calendars` DISABLE KEYS */;
INSERT INTO `sla_calendars` VALUES (1,'TTO_PORTAL_OPERATIONS','Trinidad & Tobago / Portal Operations','Default national service calendar. Monday to Friday are business days; weekend and date-specific exceptions are configured separately.','America/Port_of_Spain','active',1,NULL,NULL,'2026-10-15 14:18:19.194052','2026-10-15 14:18:19.194052');
/*!40000 ALTER TABLE `sla_calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sla_instance_events`
--

DROP TABLE IF EXISTS `sla_instance_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sla_instance_events` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sla_instance_id` bigint(20) unsigned NOT NULL,
  `event_code` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_state_code` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `to_state_code` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `event_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `source_entity_type` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_entity_id` bigint(20) unsigned NOT NULL,
  `actor_user_id` int(10) unsigned DEFAULT NULL,
  `notes` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_sla_instance_event` (`sla_instance_id`,`event_code`),
  KEY `idx_sla_instance_events_timeline` (`sla_instance_id`,`event_at`,`id`),
  KEY `idx_sla_instance_events_source` (`source_entity_type`,`source_entity_id`,`event_code`),
  KEY `fk_sla_instance_events_from` (`from_state_code`),
  KEY `fk_sla_instance_events_to` (`to_state_code`),
  KEY `fk_sla_instance_events_actor` (`actor_user_id`),
  CONSTRAINT `fk_sla_instance_events_actor` FOREIGN KEY (`actor_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_sla_instance_events_from` FOREIGN KEY (`from_state_code`) REFERENCES `sla_instance_states` (`code`),
  CONSTRAINT `fk_sla_instance_events_instance` FOREIGN KEY (`sla_instance_id`) REFERENCES `sla_instances` (`id`),
  CONSTRAINT `fk_sla_instance_events_to` FOREIGN KEY (`to_state_code`) REFERENCES `sla_instance_states` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sla_instance_events`
--

LOCK TABLES `sla_instance_events` WRITE;
/*!40000 ALTER TABLE `sla_instance_events` DISABLE KEYS */;
INSERT INTO `sla_instance_events` VALUES (1,1,'STARTED','PENDING','ACTIVE','2026-10-20 21:02:29.000000','ticket_district_approval',1,1,NULL),(2,1,'COMPLETED','ACTIVE','COMPLETED_WITHIN_SLA','2026-10-20 21:03:20.416877','logistics_handoff',1,1,NULL),(3,2,'STARTED','PENDING','ACTIVE','2026-10-20 21:03:29.000000','logistics_handoff',2,1,NULL),(4,3,'STARTED','PENDING','ACTIVE','2026-10-20 21:03:46.000000','repair_job',1,1,NULL),(5,2,'COMPLETED','ACTIVE','COMPLETED_WITHIN_SLA','2026-10-20 21:04:06.134346','repair_assessment',1,1,NULL),(6,3,'COMPLETED','ACTIVE','COMPLETED_WITHIN_SLA','2026-10-20 21:28:19.680172','repair_job',1,1,NULL),(7,4,'STARTED','PENDING','ACTIVE','2026-10-20 21:28:19.000000','logistics_case',1,1,NULL),(8,4,'COMPLETED','ACTIVE','COMPLETED_WITHIN_SLA','2026-10-20 21:29:05.341750','logistics_handoff',4,1,NULL),(9,5,'STARTED','PENDING','ACTIVE','2026-10-20 21:31:44.000000','ticket_district_approval',2,1,NULL),(10,5,'COMPLETED','ACTIVE','COMPLETED_WITHIN_SLA','2026-10-20 21:32:07.219803','logistics_handoff',5,1,NULL),(11,6,'STARTED','PENDING','ACTIVE','2026-10-20 21:32:15.000000','logistics_handoff',6,1,NULL),(12,7,'STARTED','PENDING','ACTIVE','2026-10-20 21:32:43.000000','repair_job',2,1,NULL),(13,6,'COMPLETED','ACTIVE','COMPLETED_WITHIN_SLA','2026-10-20 21:33:34.355262','repair_assessment',2,1,NULL),(14,7,'CANCELLED','ACTIVE','CANCELLED','2026-10-20 21:33:45.000000','repair_job',2,1,'Local repair ended in a non-local disposition.'),(15,8,'STARTED','PENDING','ACTIVE','2026-10-20 21:35:23.000000','permanent_replacement_case',1,1,NULL),(16,8,'CANCELLED','ACTIVE','CANCELLED','2026-10-20 21:46:45.603869','permanent_replacement_case',1,1,'Permanent replacement reused the selected temporary spare; return logistics no longer applies.');
/*!40000 ALTER TABLE `sla_instance_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sla_instance_states`
--

DROP TABLE IF EXISTS `sla_instance_states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sla_instance_states` (
  `code` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` smallint(5) unsigned NOT NULL,
  `is_terminal` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sla_instance_states`
--

LOCK TABLES `sla_instance_states` WRITE;
/*!40000 ALTER TABLE `sla_instance_states` DISABLE KEYS */;
INSERT INTO `sla_instance_states` VALUES ('ACTIVE','Active',20,0),('AT_RISK','At Risk',30,0),('BREACHED','Breached',40,0),('CANCELLED','Cancelled',70,1),('COMPLETED_OUTSIDE_SLA','Completed Outside SLA',60,1),('COMPLETED_WITHIN_SLA','Completed Within SLA',50,1),('PENDING','Pending',10,0);
/*!40000 ALTER TABLE `sla_instance_states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sla_instances`
--

DROP TABLE IF EXISTS `sla_instances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sla_instances` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `idempotency_key` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `policy_id` int(10) unsigned NOT NULL,
  `policy_version_id` bigint(20) unsigned NOT NULL,
  `policy_code_snapshot` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `target_business_days_snapshot` decimal(6,2) unsigned NOT NULL,
  `calendar_id` int(10) unsigned NOT NULL,
  `ticket_id` int(10) unsigned NOT NULL,
  `logistics_case_id` int(10) unsigned DEFAULT NULL,
  `repair_job_id` int(10) unsigned DEFAULT NULL,
  `device_id` int(10) unsigned DEFAULT NULL,
  `effective_device_id` int(10) unsigned DEFAULT NULL,
  `source_workflow` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_entity_type` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_entity_id` bigint(20) unsigned NOT NULL,
  `current_state_code` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `started_at` datetime(6) NOT NULL,
  `due_at` datetime(6) NOT NULL,
  `at_risk_at` datetime(6) DEFAULT NULL,
  `breached_at` datetime(6) DEFAULT NULL,
  `completed_at` datetime(6) DEFAULT NULL,
  `cancelled_at` datetime(6) DEFAULT NULL,
  `completion_event` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `started_by_user_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_sla_instances_idempotency` (`idempotency_key`),
  KEY `idx_sla_instances_policy_state_due` (`policy_code_snapshot`,`current_state_code`,`due_at`),
  KEY `idx_sla_instances_ticket` (`ticket_id`,`started_at`),
  KEY `idx_sla_instances_logistics` (`logistics_case_id`,`policy_code_snapshot`),
  KEY `idx_sla_instances_repair` (`repair_job_id`,`policy_code_snapshot`),
  KEY `idx_sla_instances_source` (`source_workflow`,`source_entity_type`,`source_entity_id`),
  KEY `fk_sla_instances_policy` (`policy_id`),
  KEY `fk_sla_instances_policy_version` (`policy_version_id`),
  KEY `fk_sla_instances_calendar` (`calendar_id`),
  KEY `fk_sla_instances_device` (`device_id`),
  KEY `fk_sla_instances_effective_device` (`effective_device_id`),
  KEY `fk_sla_instances_state` (`current_state_code`),
  KEY `fk_sla_instances_started_by` (`started_by_user_id`),
  CONSTRAINT `fk_sla_instances_calendar` FOREIGN KEY (`calendar_id`) REFERENCES `sla_calendars` (`id`),
  CONSTRAINT `fk_sla_instances_device` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_sla_instances_effective_device` FOREIGN KEY (`effective_device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_sla_instances_logistics` FOREIGN KEY (`logistics_case_id`) REFERENCES `ticket_logistics_cases` (`id`),
  CONSTRAINT `fk_sla_instances_policy` FOREIGN KEY (`policy_id`) REFERENCES `sla_policies` (`id`),
  CONSTRAINT `fk_sla_instances_policy_version` FOREIGN KEY (`policy_version_id`) REFERENCES `sla_policy_versions` (`id`),
  CONSTRAINT `fk_sla_instances_repair` FOREIGN KEY (`repair_job_id`) REFERENCES `repair_jobs` (`id`),
  CONSTRAINT `fk_sla_instances_started_by` FOREIGN KEY (`started_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_sla_instances_state` FOREIGN KEY (`current_state_code`) REFERENCES `sla_instance_states` (`code`),
  CONSTRAINT `fk_sla_instances_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sla_instances`
--

LOCK TABLES `sla_instances` WRITE;
/*!40000 ALTER TABLE `sla_instances` DISABLE KEYS */;
INSERT INTO `sla_instances` VALUES (1,'PICKUP:TICKET:1',1,2,'PICKUP',2.00,1,1,NULL,NULL,NULL,NULL,'PICKUP','ticket_district_approval',1,'COMPLETED_WITHIN_SLA','2026-10-20 21:02:29.000000','2026-10-21 23:59:59.000000',NULL,NULL,'2026-10-20 21:03:20.416877',NULL,'SCHOOL_TO_TTPOST_RECEIVED',1,'2026-10-20 21:02:29.936879','2026-10-20 21:03:20.421154'),(2,'DIAGNOSIS:LOGISTICS:1',2,1,'DIAGNOSIS',1.00,1,1,1,NULL,1,1,'REPAIR_CENTRE_DIAGNOSIS','logistics_handoff',2,'COMPLETED_WITHIN_SLA','2026-10-20 21:03:29.000000','2026-10-20 23:59:59.000000',NULL,NULL,'2026-10-20 21:04:06.134346',NULL,'REPAIR_CENTRE_ASSESSMENT_RECORDED',1,'2026-10-20 21:03:29.489544','2026-10-20 21:04:06.138711'),(3,'REPAIR:JOB:1',3,4,'REPAIR',3.00,1,1,1,1,1,1,'LOCAL_REPAIR','repair_job',1,'COMPLETED_WITHIN_SLA','2026-10-20 21:03:46.000000','2026-10-22 23:59:59.000000',NULL,NULL,'2026-10-20 21:28:19.680172',NULL,'LOCAL_REPAIR_COMPLETED_SUCCESSFULLY',1,'2026-10-20 21:03:46.537978','2026-10-20 21:28:19.684913'),(4,'RETURN_LOGISTICS:LOGISTICS:1',5,5,'RETURN_LOGISTICS',2.00,1,1,1,1,1,1,'NORMAL_RETURN','logistics_case',1,'COMPLETED_WITHIN_SLA','2026-10-20 21:28:19.000000','2026-10-21 23:59:59.000000',NULL,NULL,'2026-10-20 21:29:05.341750',NULL,'TTPOST_TO_SCHOOL_RECEIVED',1,'2026-10-20 21:28:19.702336','2026-10-20 21:29:05.343670'),(5,'PICKUP:TICKET:2',1,2,'PICKUP',2.00,1,2,NULL,NULL,NULL,NULL,'PICKUP','ticket_district_approval',2,'COMPLETED_WITHIN_SLA','2026-10-20 21:31:44.000000','2026-10-21 23:59:59.000000',NULL,NULL,'2026-10-20 21:32:07.219803',NULL,'SCHOOL_TO_TTPOST_RECEIVED',1,'2026-10-20 21:31:44.508329','2026-10-20 21:32:07.222819'),(6,'DIAGNOSIS:LOGISTICS:2',2,1,'DIAGNOSIS',1.00,1,2,2,NULL,1,1,'REPAIR_CENTRE_DIAGNOSIS','logistics_handoff',6,'COMPLETED_WITHIN_SLA','2026-10-20 21:32:15.000000','2026-10-20 23:59:59.000000',NULL,NULL,'2026-10-20 21:33:34.355262',NULL,'REPAIR_CENTRE_ASSESSMENT_RECORDED',1,'2026-10-20 21:32:15.317888','2026-10-20 21:33:34.358604'),(7,'REPAIR:JOB:2',3,4,'REPAIR',3.00,1,2,2,2,1,1,'LOCAL_REPAIR','repair_job',2,'CANCELLED','2026-10-20 21:32:43.000000','2026-10-22 23:59:59.000000',NULL,NULL,NULL,'2026-10-20 21:33:45.000000',NULL,1,'2026-10-20 21:32:43.547339','2026-10-20 21:33:45.775172'),(8,'RETURN_LOGISTICS:LOGISTICS:2',5,5,'RETURN_LOGISTICS',2.00,1,2,2,2,1,2,'PERMANENT_REPLACEMENT_RETURN','permanent_replacement_case',1,'CANCELLED','2026-10-20 21:35:23.000000','2026-10-21 23:59:59.000000',NULL,NULL,NULL,'2026-10-20 21:46:45.603869',NULL,1,'2026-10-20 21:35:23.944382','2026-10-20 21:46:45.611402');
/*!40000 ALTER TABLE `sla_instances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sla_policies`
--

DROP TABLE IF EXISTS `sla_policies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sla_policies` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `policy_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` int(10) unsigned DEFAULT NULL,
  `updated_by` int(10) unsigned DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_sla_policies_code` (`policy_code`),
  KEY `fk_sla_policies_created_by` (`created_by`),
  KEY `fk_sla_policies_updated_by` (`updated_by`),
  CONSTRAINT `fk_sla_policies_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_sla_policies_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sla_policies`
--

LOCK TABLES `sla_policies` WRITE;
/*!40000 ALTER TABLE `sla_policies` DISABLE KEYS */;
INSERT INTO `sla_policies` VALUES (1,'PICKUP',NULL,NULL,'2026-10-15 14:18:19.199816','2026-10-15 14:18:19.199816'),(2,'DIAGNOSIS',NULL,NULL,'2026-10-15 14:18:19.199816','2026-10-15 14:18:19.199816'),(3,'REPAIR',NULL,NULL,'2026-10-15 14:18:19.199816','2026-10-15 14:18:19.199816'),(4,'QA',NULL,NULL,'2026-10-15 14:18:19.199816','2026-10-17 15:06:40.656791'),(5,'RETURN_LOGISTICS',NULL,1,'2026-10-15 14:18:19.199816','2026-10-19 08:08:11.000000');
/*!40000 ALTER TABLE `sla_policies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sla_policy_versions`
--

DROP TABLE IF EXISTS `sla_policy_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sla_policy_versions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `policy_id` int(10) unsigned NOT NULL,
  `version_number` int(10) unsigned NOT NULL,
  `name` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `calendar_id` int(10) unsigned NOT NULL,
  `target_business_days` decimal(6,2) unsigned NOT NULL,
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT '100',
  `start_event_code` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `completion_event_code` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pause_condition_code` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` int(10) unsigned DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_sla_policy_version` (`policy_id`,`version_number`),
  KEY `idx_sla_policy_versions_calendar_status` (`calendar_id`,`status`),
  KEY `fk_sla_policy_versions_actor` (`created_by`),
  CONSTRAINT `fk_sla_policy_versions_actor` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_sla_policy_versions_calendar` FOREIGN KEY (`calendar_id`) REFERENCES `sla_calendars` (`id`),
  CONSTRAINT `fk_sla_policy_versions_policy` FOREIGN KEY (`policy_id`) REFERENCES `sla_policies` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sla_policy_versions`
--

LOCK TABLES `sla_policy_versions` WRITE;
/*!40000 ALTER TABLE `sla_policy_versions` DISABLE KEYS */;
INSERT INTO `sla_policy_versions` VALUES (1,2,1,'Diagnosis','Target for initial diagnosis.',1,1.00,'active',20,NULL,NULL,NULL,NULL,'2026-10-15 14:18:19.200531'),(2,1,1,'Pickup','Target for authorized pickup processing.',1,2.00,'active',10,NULL,NULL,NULL,NULL,'2026-10-15 14:18:19.200531'),(3,4,1,'Quality Assurance','Target for quality assurance after repair.',1,1.00,'active',40,NULL,NULL,NULL,NULL,'2026-10-15 14:18:19.200531'),(4,3,1,'Repair','Maximum standard local repair target; configured at the upper end of the 2–3 business day range.',1,3.00,'active',30,NULL,NULL,NULL,NULL,'2026-10-15 14:18:19.200531'),(5,5,1,'Return Logistics','Target for return logistics after repair completion.',1,2.00,'active',50,NULL,NULL,NULL,NULL,'2026-10-15 14:18:19.200531');
/*!40000 ALTER TABLE `sla_policy_versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spare_pools`
--

DROP TABLE IF EXISTS `spare_pools`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spare_pools` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pool_code` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `service_location_id` int(10) unsigned NOT NULL,
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `is_default` tinyint(1) NOT NULL DEFAULT '1',
  `active_default_key` tinyint(3) unsigned DEFAULT '1',
  `created_by` int(10) unsigned DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` int(10) unsigned DEFAULT NULL,
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_spare_pool_code` (`pool_code`),
  UNIQUE KEY `uq_spare_pool_active_default` (`service_location_id`,`active_default_key`),
  KEY `fk_spare_pool_created_by` (`created_by`),
  KEY `fk_spare_pool_updated_by` (`updated_by`),
  CONSTRAINT `fk_spare_pool_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_spare_pool_location` FOREIGN KEY (`service_location_id`) REFERENCES `service_locations` (`id`),
  CONSTRAINT `fk_spare_pool_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spare_pools`
--

LOCK TABLES `spare_pools` WRITE;
/*!40000 ALTER TABLE `spare_pools` DISABLE KEYS */;
INSERT INTO `spare_pools` VALUES (1,'ARIMA-SPARE-POOL','SPARE POOL',2,'active',1,1,1,'2026-10-20 21:15:10.058655',1,'2026-10-20 21:17:39.729194');
/*!40000 ALTER TABLE `spare_pools` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `students` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `school_id` int(10) unsigned NOT NULL,
  `student_reference` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `school_student_id_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `school_start_date` date DEFAULT NULL,
  `first_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_by_user_id` int(10) unsigned DEFAULT NULL,
  `updated_by_user_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_students_student_reference` (`student_reference`),
  KEY `idx_students_school_status` (`school_id`,`status`),
  KEY `idx_students_last_first` (`last_name`,`first_name`),
  KEY `idx_students_created_by` (`created_by_user_id`),
  KEY `idx_students_updated_by` (`updated_by_user_id`),
  CONSTRAINT `fk_students_created_by` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_students_school` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`),
  CONSTRAINT `fk_students_updated_by` FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (1,1,'jluise','000001','2026-10-20','JERRY','LUISE','active',1,1,'2026-10-20 20:46:58','2026-10-20 20:46:58');
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temporary_loan_cases`
--

DROP TABLE IF EXISTS `temporary_loan_cases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temporary_loan_cases` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `loan_number` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ticket_id` int(10) unsigned NOT NULL,
  `repair_job_id` int(10) unsigned NOT NULL,
  `original_device_id` int(10) unsigned NOT NULL,
  `origin_district_id` int(10) unsigned NOT NULL,
  `origin_school_id` int(10) unsigned DEFAULT NULL,
  `repair_service_location_id` int(10) unsigned NOT NULL,
  `spare_pool_id` int(10) unsigned NOT NULL,
  `current_status_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `requested_by` int(10) unsigned NOT NULL,
  `requested_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `request_reason_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `request_notes` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `authorized_by` int(10) unsigned DEFAULT NULL,
  `authorized_at` datetime(6) DEFAULT NULL,
  `authorization_notes` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rejected_by` int(10) unsigned DEFAULT NULL,
  `rejected_at` datetime(6) DEFAULT NULL,
  `rejection_reason` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `selected_spare_device_id` int(10) unsigned DEFAULT NULL,
  `selected_by` int(10) unsigned DEFAULT NULL,
  `selected_at` datetime(6) DEFAULT NULL,
  `issued_at` datetime(6) DEFAULT NULL,
  `issued_by` int(10) unsigned DEFAULT NULL,
  `return_requested_by` int(10) unsigned DEFAULT NULL,
  `return_requested_at` datetime(6) DEFAULT NULL,
  `return_reason_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `return_notes` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `return_condition_code` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `returned_by` int(10) unsigned DEFAULT NULL,
  `returned_at` datetime(6) DEFAULT NULL,
  `conversion_status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `conversion_request_id` bigint(20) unsigned DEFAULT NULL,
  `active_record_key` tinyint(3) unsigned DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `closed_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_temporary_loan_number` (`loan_number`),
  UNIQUE KEY `uq_temporary_loan_active` (`ticket_id`,`original_device_id`,`active_record_key`),
  KEY `idx_temporary_loan_district` (`origin_district_id`,`current_status_code`),
  KEY `idx_temporary_loan_repair` (`repair_service_location_id`,`current_status_code`),
  KEY `idx_temporary_loan_ticket` (`ticket_id`,`created_at`),
  KEY `fk_temporary_loan_status` (`current_status_code`),
  KEY `fk_temporary_loan_job` (`repair_job_id`),
  KEY `fk_temporary_loan_original` (`original_device_id`),
  KEY `fk_temporary_loan_school` (`origin_school_id`),
  KEY `fk_temporary_loan_pool` (`spare_pool_id`),
  KEY `fk_temporary_loan_requested_by` (`requested_by`),
  KEY `fk_temporary_loan_authorized_by` (`authorized_by`),
  KEY `fk_temporary_loan_rejected_by` (`rejected_by`),
  KEY `fk_temporary_loan_selected` (`selected_spare_device_id`),
  KEY `idx_temporary_loan_selected_by` (`selected_by`),
  KEY `idx_temporary_loan_issued_by` (`issued_by`),
  KEY `idx_temporary_loan_return_requested_by` (`return_requested_by`),
  KEY `idx_temporary_loan_returned_by` (`returned_by`),
  KEY `fk_temporary_loan_return_reason` (`return_reason_code`),
  KEY `fk_temporary_loan_return_condition` (`return_condition_code`),
  KEY `idx_temporary_loan_conversion_request` (`conversion_request_id`),
  CONSTRAINT `fk_temporary_loan_authorized_by` FOREIGN KEY (`authorized_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_temporary_loan_conversion_request` FOREIGN KEY (`conversion_request_id`) REFERENCES `temporary_loan_conversion_requests` (`id`),
  CONSTRAINT `fk_temporary_loan_district` FOREIGN KEY (`origin_district_id`) REFERENCES `districts` (`id`),
  CONSTRAINT `fk_temporary_loan_issued_by` FOREIGN KEY (`issued_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_temporary_loan_job` FOREIGN KEY (`repair_job_id`) REFERENCES `repair_jobs` (`id`),
  CONSTRAINT `fk_temporary_loan_location` FOREIGN KEY (`repair_service_location_id`) REFERENCES `service_locations` (`id`),
  CONSTRAINT `fk_temporary_loan_original` FOREIGN KEY (`original_device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_temporary_loan_pool` FOREIGN KEY (`spare_pool_id`) REFERENCES `spare_pools` (`id`),
  CONSTRAINT `fk_temporary_loan_rejected_by` FOREIGN KEY (`rejected_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_temporary_loan_requested_by` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_temporary_loan_return_condition` FOREIGN KEY (`return_condition_code`) REFERENCES `temporary_loan_return_conditions` (`code`),
  CONSTRAINT `fk_temporary_loan_return_reason` FOREIGN KEY (`return_reason_code`) REFERENCES `temporary_loan_return_reasons` (`code`),
  CONSTRAINT `fk_temporary_loan_return_requested_by` FOREIGN KEY (`return_requested_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_temporary_loan_returned_by` FOREIGN KEY (`returned_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_temporary_loan_school` FOREIGN KEY (`origin_school_id`) REFERENCES `schools` (`id`),
  CONSTRAINT `fk_temporary_loan_selected` FOREIGN KEY (`selected_spare_device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_temporary_loan_selected_by` FOREIGN KEY (`selected_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_temporary_loan_status` FOREIGN KEY (`current_status_code`) REFERENCES `temporary_loan_statuses` (`code`),
  CONSTRAINT `fk_temporary_loan_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temporary_loan_cases`
--

LOCK TABLES `temporary_loan_cases` WRITE;
/*!40000 ALTER TABLE `temporary_loan_cases` DISABLE KEYS */;
INSERT INTO `temporary_loan_cases` VALUES (1,'TL1',1,1,1,6,1,2,1,'RETURNED',1,'2026-10-20 21:18:18.699857','REPAIR_UNAVAILABLE',NULL,1,'2026-10-20 21:18:50.000000',NULL,NULL,NULL,NULL,2,1,'2026-10-20 21:26:19.000000','2026-10-20 21:26:32.000000',1,1,'2026-10-20 21:29:30.000000','ORIGINAL_DEVICE_RETURNED',NULL,'SERVICEABLE',1,'2026-10-20 21:30:04.000000',NULL,NULL,NULL,'2026-10-20 21:18:18.699857','2026-10-20 21:30:04.585175','2026-10-20 21:30:04.000000'),(2,'TL2',2,2,1,6,1,2,1,'CONVERTED_PERMANENT',1,'2026-10-20 21:32:52.349322','REPAIR_UNAVAILABLE',NULL,1,'2026-10-20 21:33:02.000000',NULL,NULL,NULL,NULL,2,1,'2026-10-20 21:33:08.000000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'CONVERTED_PERMANENT',NULL,NULL,'2026-10-20 21:32:52.349322','2026-10-20 21:46:45.607961','2026-10-20 21:46:45.603869');
/*!40000 ALTER TABLE `temporary_loan_cases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temporary_loan_conversion_decisions`
--

DROP TABLE IF EXISTS `temporary_loan_conversion_decisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temporary_loan_conversion_decisions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `conversion_request_id` bigint(20) unsigned NOT NULL,
  `decision_code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `decided_by` int(10) unsigned NOT NULL,
  `decided_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `decision_notes` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_tl_conversion_decision_request` (`conversion_request_id`),
  KEY `fk_tl_conversion_decided_by` (`decided_by`),
  CONSTRAINT `fk_tl_conversion_decided_by` FOREIGN KEY (`decided_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_tl_conversion_decision_request` FOREIGN KEY (`conversion_request_id`) REFERENCES `temporary_loan_conversion_requests` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temporary_loan_conversion_decisions`
--

LOCK TABLES `temporary_loan_conversion_decisions` WRITE;
/*!40000 ALTER TABLE `temporary_loan_conversion_decisions` DISABLE KEYS */;
/*!40000 ALTER TABLE `temporary_loan_conversion_decisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temporary_loan_conversion_reasons`
--

DROP TABLE IF EXISTS `temporary_loan_conversion_reasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temporary_loan_conversion_reasons` (
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temporary_loan_conversion_reasons`
--

LOCK TABLES `temporary_loan_conversion_reasons` WRITE;
/*!40000 ALTER TABLE `temporary_loan_conversion_reasons` DISABLE KEYS */;
INSERT INTO `temporary_loan_conversion_reasons` VALUES ('ADMINISTRATIVE_DECISION','Administrative decision',1,40),('LOAN_DEVICE_SUITABLE_FOR_PERMANENT_USE','Loan device suitable for permanent use',1,30),('ORIGINAL_UNRECOVERABLE','Original device unrecoverable',1,10),('OTHER','Other',1,50),('REPLACEMENT_REQUIRED','Replacement required',1,20);
/*!40000 ALTER TABLE `temporary_loan_conversion_reasons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temporary_loan_conversion_requests`
--

DROP TABLE IF EXISTS `temporary_loan_conversion_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temporary_loan_conversion_requests` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `conversion_request_number` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `temporary_loan_case_id` int(10) unsigned NOT NULL,
  `status_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reason_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `request_notes` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `original_custody_level` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `original_district_id` int(10) unsigned DEFAULT NULL,
  `original_school_id` int(10) unsigned DEFAULT NULL,
  `original_student_id` int(10) unsigned DEFAULT NULL,
  `original_district_allocation_id` int(10) unsigned DEFAULT NULL,
  `original_school_allocation_id` int(10) unsigned DEFAULT NULL,
  `original_student_assignment_id` int(10) unsigned DEFAULT NULL,
  `requested_by` int(10) unsigned NOT NULL,
  `requested_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `active_record_key` tinyint(3) unsigned DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_tl_conversion_number` (`conversion_request_number`),
  UNIQUE KEY `uq_tl_conversion_active` (`temporary_loan_case_id`,`active_record_key`),
  KEY `idx_tl_conversion_status` (`status_code`,`requested_at`),
  KEY `idx_tl_conversion_reason` (`reason_code`),
  KEY `fk_tl_conversion_requested_by` (`requested_by`),
  CONSTRAINT `fk_tl_conversion_loan` FOREIGN KEY (`temporary_loan_case_id`) REFERENCES `temporary_loan_cases` (`id`),
  CONSTRAINT `fk_tl_conversion_reason` FOREIGN KEY (`reason_code`) REFERENCES `temporary_loan_conversion_reasons` (`code`),
  CONSTRAINT `fk_tl_conversion_requested_by` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_tl_conversion_status` FOREIGN KEY (`status_code`) REFERENCES `temporary_loan_conversion_statuses` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temporary_loan_conversion_requests`
--

LOCK TABLES `temporary_loan_conversion_requests` WRITE;
/*!40000 ALTER TABLE `temporary_loan_conversion_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `temporary_loan_conversion_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temporary_loan_conversion_statuses`
--

DROP TABLE IF EXISTS `temporary_loan_conversion_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temporary_loan_conversion_statuses` (
  `code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_terminal` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temporary_loan_conversion_statuses`
--

LOCK TABLES `temporary_loan_conversion_statuses` WRITE;
/*!40000 ALTER TABLE `temporary_loan_conversion_statuses` DISABLE KEYS */;
INSERT INTO `temporary_loan_conversion_statuses` VALUES ('APPROVED','Approved',1),('PENDING','Pending Head Office',0),('REJECTED','Rejected',1);
/*!40000 ALTER TABLE `temporary_loan_conversion_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temporary_loan_custody_history`
--

DROP TABLE IF EXISTS `temporary_loan_custody_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temporary_loan_custody_history` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `temporary_loan_case_id` int(10) unsigned NOT NULL,
  `device_id` int(10) unsigned NOT NULL,
  `from_custody_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `to_custody_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `actor_user_id` int(10) unsigned NOT NULL,
  `notes` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_temporary_loan_custody_case` (`temporary_loan_case_id`,`created_at`,`id`),
  KEY `idx_temporary_loan_custody_device` (`device_id`,`created_at`,`id`),
  KEY `fk_temporary_loan_custody_actor` (`actor_user_id`),
  CONSTRAINT `fk_temporary_loan_custody_actor` FOREIGN KEY (`actor_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_temporary_loan_custody_case` FOREIGN KEY (`temporary_loan_case_id`) REFERENCES `temporary_loan_cases` (`id`),
  CONSTRAINT `fk_temporary_loan_custody_device` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temporary_loan_custody_history`
--

LOCK TABLES `temporary_loan_custody_history` WRITE;
/*!40000 ALTER TABLE `temporary_loan_custody_history` DISABLE KEYS */;
INSERT INTO `temporary_loan_custody_history` VALUES (1,1,2,'REPAIR_CENTRE_STOCK','TEMPORARY_LOAN_ISSUED',1,'Temporary loan asset activated at Repair Centre; recipient handoff and receipt are not recorded.','2026-10-20 21:26:32.373882'),(2,1,2,'TEMPORARY_LOAN_ISSUED','TEMPORARY_LOAN_RETURN_REQUIRED',1,'Temporary spare return requested; physical receipt is not confirmed.','2026-10-20 21:29:30.628694'),(3,1,2,'TEMPORARY_LOAN_RETURN_REQUIRED','REPAIR_CENTRE_STOCK',1,'Serviceable temporary spare physically received and returned to Repair Centre stock.','2026-10-20 21:30:04.585875');
/*!40000 ALTER TABLE `temporary_loan_custody_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temporary_loan_decisions`
--

DROP TABLE IF EXISTS `temporary_loan_decisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temporary_loan_decisions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `temporary_loan_case_id` int(10) unsigned NOT NULL,
  `decision_code` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `actor_user_id` int(10) unsigned NOT NULL,
  `notes` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_temporary_loan_decision_case` (`temporary_loan_case_id`),
  KEY `fk_temporary_loan_decision_actor` (`actor_user_id`),
  CONSTRAINT `fk_temporary_loan_decision_actor` FOREIGN KEY (`actor_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_temporary_loan_decision_case` FOREIGN KEY (`temporary_loan_case_id`) REFERENCES `temporary_loan_cases` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temporary_loan_decisions`
--

LOCK TABLES `temporary_loan_decisions` WRITE;
/*!40000 ALTER TABLE `temporary_loan_decisions` DISABLE KEYS */;
INSERT INTO `temporary_loan_decisions` VALUES (1,1,'APPROVE',1,NULL,'2026-10-20 21:18:50.196148'),(2,2,'APPROVE',1,NULL,'2026-10-20 21:33:02.537575');
/*!40000 ALTER TABLE `temporary_loan_decisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temporary_loan_return_conditions`
--

DROP TABLE IF EXISTS `temporary_loan_return_conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temporary_loan_return_conditions` (
  `code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_serviceable` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temporary_loan_return_conditions`
--

LOCK TABLES `temporary_loan_return_conditions` WRITE;
/*!40000 ALTER TABLE `temporary_loan_return_conditions` DISABLE KEYS */;
INSERT INTO `temporary_loan_return_conditions` VALUES ('DAMAGED','Damaged',0,1),('LOST','Lost',0,1),('OTHER','Other / unverified',0,1),('SERVICEABLE','Serviceable',1,1),('STOLEN','Stolen',0,1);
/*!40000 ALTER TABLE `temporary_loan_return_conditions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temporary_loan_return_reasons`
--

DROP TABLE IF EXISTS `temporary_loan_return_reasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temporary_loan_return_reasons` (
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temporary_loan_return_reasons`
--

LOCK TABLES `temporary_loan_return_reasons` WRITE;
/*!40000 ALTER TABLE `temporary_loan_return_reasons` DISABLE KEYS */;
INSERT INTO `temporary_loan_return_reasons` VALUES ('ADMINISTRATIVE_RECALL','Administrative recall',1,40),('LOAN_NO_LONGER_REQUIRED','Loan no longer required',1,30),('ORIGINAL_DEVICE_RETURNED','Original device returned',1,10),('OTHER','Other',1,50),('PERMANENT_REPLACEMENT_AVAILABLE','Permanent replacement available',1,20);
/*!40000 ALTER TABLE `temporary_loan_return_reasons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temporary_loan_spare_reservations`
--

DROP TABLE IF EXISTS `temporary_loan_spare_reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temporary_loan_spare_reservations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `temporary_loan_case_id` int(10) unsigned NOT NULL,
  `device_id` int(10) unsigned NOT NULL,
  `reservation_status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'RESERVED',
  `active_record_key` tinyint(3) unsigned DEFAULT '1',
  `reserved_by` int(10) unsigned NOT NULL,
  `reserved_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `consumed_by` int(10) unsigned DEFAULT NULL,
  `consumed_at` datetime(6) DEFAULT NULL,
  `released_by` int(10) unsigned DEFAULT NULL,
  `released_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_temporary_loan_spare_device_active` (`device_id`,`active_record_key`),
  UNIQUE KEY `uq_temporary_loan_spare_case_active` (`temporary_loan_case_id`,`active_record_key`),
  KEY `idx_temporary_loan_reservation_case` (`temporary_loan_case_id`,`reservation_status`),
  KEY `fk_temporary_loan_reservation_actor` (`reserved_by`),
  KEY `fk_temporary_loan_reservation_consumed_by` (`consumed_by`),
  KEY `fk_temporary_loan_reservation_released_by` (`released_by`),
  CONSTRAINT `fk_temporary_loan_reservation_actor` FOREIGN KEY (`reserved_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_temporary_loan_reservation_case` FOREIGN KEY (`temporary_loan_case_id`) REFERENCES `temporary_loan_cases` (`id`),
  CONSTRAINT `fk_temporary_loan_reservation_consumed_by` FOREIGN KEY (`consumed_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_temporary_loan_reservation_device` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_temporary_loan_reservation_released_by` FOREIGN KEY (`released_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temporary_loan_spare_reservations`
--

LOCK TABLES `temporary_loan_spare_reservations` WRITE;
/*!40000 ALTER TABLE `temporary_loan_spare_reservations` DISABLE KEYS */;
INSERT INTO `temporary_loan_spare_reservations` VALUES (1,1,2,'CONSUMED',NULL,1,'2026-10-20 21:26:19.827192',1,'2026-10-20 21:26:32.000000',NULL,NULL),(2,2,2,'CONSUMED',NULL,1,'2026-10-20 21:33:08.484467',1,'2026-10-20 21:46:45.603869',NULL,NULL);
/*!40000 ALTER TABLE `temporary_loan_spare_reservations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temporary_loan_status_history`
--

DROP TABLE IF EXISTS `temporary_loan_status_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temporary_loan_status_history` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `temporary_loan_case_id` int(10) unsigned NOT NULL,
  `from_status_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `to_status_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `actor_user_id` int(10) unsigned NOT NULL,
  `notes` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_temporary_loan_history` (`temporary_loan_case_id`,`created_at`,`id`),
  KEY `fk_temporary_loan_history_from` (`from_status_code`),
  KEY `fk_temporary_loan_history_to` (`to_status_code`),
  KEY `fk_temporary_loan_history_actor` (`actor_user_id`),
  CONSTRAINT `fk_temporary_loan_history_actor` FOREIGN KEY (`actor_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_temporary_loan_history_case` FOREIGN KEY (`temporary_loan_case_id`) REFERENCES `temporary_loan_cases` (`id`),
  CONSTRAINT `fk_temporary_loan_history_from` FOREIGN KEY (`from_status_code`) REFERENCES `temporary_loan_statuses` (`code`),
  CONSTRAINT `fk_temporary_loan_history_to` FOREIGN KEY (`to_status_code`) REFERENCES `temporary_loan_statuses` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temporary_loan_status_history`
--

LOCK TABLES `temporary_loan_status_history` WRITE;
/*!40000 ALTER TABLE `temporary_loan_status_history` DISABLE KEYS */;
INSERT INTO `temporary_loan_status_history` VALUES (1,1,NULL,'PENDING_DISTRICT_APPROVAL',1,'Temporary spare authorization requested.','2026-10-20 21:18:18.707878'),(2,1,'PENDING_DISTRICT_APPROVAL','AUTHORIZED',1,'District authorized temporary spare.','2026-10-20 21:18:50.199437'),(3,1,'AUTHORIZED','SPARE_SELECTED',1,'Temporary spare selected and reserved.','2026-10-20 21:26:19.828605'),(4,1,'SPARE_SELECTED','ACTIVE_LOAN',1,'Temporary spare issued and activated.','2026-10-20 21:26:32.385288'),(5,1,'ACTIVE_LOAN','RETURN_REQUIRED',1,'Temporary spare return requested for reason: ORIGINAL_DEVICE_RETURNED.','2026-10-20 21:29:30.629466'),(6,1,'RETURN_REQUIRED','RETURNED',1,'Serviceable spare reclaimed by the Repair Centre.','2026-10-20 21:30:04.595556'),(7,2,NULL,'PENDING_DISTRICT_APPROVAL',1,'Temporary spare authorization requested.','2026-10-20 21:32:52.352472'),(8,2,'PENDING_DISTRICT_APPROVAL','AUTHORIZED',1,'District authorized temporary spare.','2026-10-20 21:33:02.540401'),(9,2,'AUTHORIZED','SPARE_SELECTED',1,'Temporary spare selected and reserved.','2026-10-20 21:33:08.485928'),(10,2,'SPARE_SELECTED','CONVERTED_PERMANENT',1,'Completed through permanent replacement PR1 using the same device. No temporary-spare return is required.','2026-10-20 21:46:45.608538');
/*!40000 ALTER TABLE `temporary_loan_status_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temporary_loan_statuses`
--

DROP TABLE IF EXISTS `temporary_loan_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temporary_loan_statuses` (
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` smallint(5) unsigned NOT NULL,
  `is_terminal` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temporary_loan_statuses`
--

LOCK TABLES `temporary_loan_statuses` WRITE;
/*!40000 ALTER TABLE `temporary_loan_statuses` DISABLE KEYS */;
INSERT INTO `temporary_loan_statuses` VALUES ('ACTIVE_LOAN','Active Loan',40,0),('AUTHORIZED','Authorized',20,0),('CANCELLED','Cancelled',95,1),('CONVERSION_PENDING_HEAD_OFFICE','Conversion Pending Head Office',70,0),('CONVERTED_PERMANENT','Converted to Permanent',80,1),('PENDING_DISTRICT_APPROVAL','Pending District Approval',10,0),('REJECTED','Rejected',90,1),('RETURN_REQUIRED','Return Required',50,0),('RETURNED','Returned',60,1),('SPARE_SELECTED','Spare Selected',30,0);
/*!40000 ALTER TABLE `temporary_loan_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_assignments`
--

DROP TABLE IF EXISTS `ticket_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_assignments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(10) unsigned NOT NULL,
  `assigned_to_user_id` int(10) unsigned NOT NULL,
  `assigned_by_user_id` int(10) unsigned NOT NULL,
  `assigned_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ended_at` datetime DEFAULT NULL,
  `ended_by_user_id` int(10) unsigned DEFAULT NULL,
  `end_reason` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active_record_key` tinyint(3) unsigned DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_ticket_assignments_active` (`ticket_id`,`active_record_key`),
  KEY `idx_ticket_assignments_assignee_active` (`assigned_to_user_id`,`active_record_key`),
  KEY `idx_ticket_assignments_assigned_at` (`assigned_at`),
  KEY `idx_ticket_assignments_ended_at` (`ended_at`),
  KEY `idx_ticket_assignments_assigned_by` (`assigned_by_user_id`),
  KEY `idx_ticket_assignments_ended_by` (`ended_by_user_id`),
  CONSTRAINT `fk_ticket_assignments_assigned_by` FOREIGN KEY (`assigned_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_ticket_assignments_assigned_to` FOREIGN KEY (`assigned_to_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_ticket_assignments_ended_by` FOREIGN KEY (`ended_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_ticket_assignments_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_assignments`
--

LOCK TABLES `ticket_assignments` WRITE;
/*!40000 ALTER TABLE `ticket_assignments` DISABLE KEYS */;
INSERT INTO `ticket_assignments` VALUES (1,1,1,1,'2026-10-20 21:02:10',NULL,NULL,NULL,1,'2026-10-20 21:02:10','2026-10-20 21:02:10'),(2,2,1,1,'2026-10-20 21:31:33',NULL,NULL,NULL,1,'2026-10-20 21:31:33','2026-10-20 21:31:33');
/*!40000 ALTER TABLE `ticket_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_comments`
--

DROP TABLE IF EXISTS `ticket_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_comments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(10) unsigned NOT NULL,
  `comment_type` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comment_text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by_user_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_internal` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_ticket_comments_ticket_created` (`ticket_id`,`created_at`),
  KEY `idx_ticket_comments_created_by` (`created_by_user_id`),
  CONSTRAINT `fk_ticket_comments_created_by` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_ticket_comments_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_comments`
--

LOCK TABLES `ticket_comments` WRITE;
/*!40000 ALTER TABLE `ticket_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_diagnoses`
--

DROP TABLE IF EXISTS `ticket_diagnoses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_diagnoses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(10) unsigned NOT NULL,
  `diagnosis_summary` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `recommended_action` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `diagnosed_by_user_id` int(10) unsigned NOT NULL,
  `diagnosed_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ticket_diagnoses_ticket_diagnosed` (`ticket_id`,`diagnosed_at`),
  KEY `idx_ticket_diagnoses_diagnosed_by` (`diagnosed_by_user_id`),
  CONSTRAINT `fk_ticket_diagnoses_diagnosed_by` FOREIGN KEY (`diagnosed_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_ticket_diagnoses_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_diagnoses`
--

LOCK TABLES `ticket_diagnoses` WRITE;
/*!40000 ALTER TABLE `ticket_diagnoses` DISABLE KEYS */;
INSERT INTO `ticket_diagnoses` VALUES (1,1,'Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.',NULL,1,'2026-10-20 21:02:19.669125','2026-10-20 21:02:19'),(2,2,'Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus','Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus',1,'2026-10-20 21:31:39.037862','2026-10-20 21:31:39');
/*!40000 ALTER TABLE `ticket_diagnoses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_district_approvals`
--

DROP TABLE IF EXISTS `ticket_district_approvals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_district_approvals` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(10) unsigned NOT NULL,
  `decision` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `decision_note` text COLLATE utf8mb4_unicode_ci,
  `decided_by_user_id` int(10) unsigned NOT NULL,
  `decided_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ticket_district_approvals_ticket_decided` (`ticket_id`,`decided_at`),
  KEY `idx_ticket_district_approvals_decided_by` (`decided_by_user_id`),
  KEY `idx_ticket_district_approvals_decision` (`decision`),
  CONSTRAINT `fk_ticket_district_approvals_decided_by` FOREIGN KEY (`decided_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_ticket_district_approvals_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_district_approvals`
--

LOCK TABLES `ticket_district_approvals` WRITE;
/*!40000 ALTER TABLE `ticket_district_approvals` DISABLE KEYS */;
INSERT INTO `ticket_district_approvals` VALUES (1,1,'APPROVED',NULL,1,'2026-10-20 21:02:29','2026-10-20 21:02:29'),(2,2,'APPROVED',NULL,1,'2026-10-20 21:31:44','2026-10-20 21:31:44');
/*!40000 ALTER TABLE `ticket_district_approvals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_logistics_cases`
--

DROP TABLE IF EXISTS `ticket_logistics_cases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_logistics_cases` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `logistics_number` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ticket_id` int(10) unsigned NOT NULL,
  `device_id` int(10) unsigned NOT NULL,
  `pickup_school_id` int(10) unsigned NOT NULL,
  `repair_centre_location_id` int(10) unsigned DEFAULT NULL,
  `current_status_id` int(10) unsigned NOT NULL,
  `requested_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `closed_at` datetime(6) DEFAULT NULL,
  `closed_by_user_id` int(10) unsigned DEFAULT NULL,
  `close_reason` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by_user_id` int(10) unsigned NOT NULL,
  `updated_by_user_id` int(10) unsigned DEFAULT NULL,
  `active_record_key` tinyint(3) unsigned DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_ticket_logistics_cases_number` (`logistics_number`),
  UNIQUE KEY `uq_ticket_logistics_cases_ticket_active` (`ticket_id`,`active_record_key`),
  UNIQUE KEY `uq_ticket_logistics_cases_device_active` (`device_id`,`active_record_key`),
  KEY `idx_ticket_logistics_cases_current_status` (`current_status_id`),
  KEY `idx_ticket_logistics_cases_pickup_school` (`pickup_school_id`),
  KEY `idx_ticket_logistics_cases_repair_location` (`repair_centre_location_id`),
  KEY `idx_ticket_logistics_cases_requested_at` (`requested_at`),
  KEY `idx_ticket_logistics_cases_created_by` (`created_by_user_id`),
  KEY `idx_ticket_logistics_cases_updated_by` (`updated_by_user_id`),
  KEY `idx_ticket_logistics_cases_closed_by` (`closed_by_user_id`),
  CONSTRAINT `fk_ticket_logistics_cases_closed_by` FOREIGN KEY (`closed_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_ticket_logistics_cases_created_by` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_ticket_logistics_cases_current_status` FOREIGN KEY (`current_status_id`) REFERENCES `logistics_statuses` (`id`),
  CONSTRAINT `fk_ticket_logistics_cases_device` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_ticket_logistics_cases_pickup_school` FOREIGN KEY (`pickup_school_id`) REFERENCES `schools` (`id`),
  CONSTRAINT `fk_ticket_logistics_cases_repair_location` FOREIGN KEY (`repair_centre_location_id`) REFERENCES `service_locations` (`id`),
  CONSTRAINT `fk_ticket_logistics_cases_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`),
  CONSTRAINT `fk_ticket_logistics_cases_updated_by` FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_logistics_cases`
--

LOCK TABLES `ticket_logistics_cases` WRITE;
/*!40000 ALTER TABLE `ticket_logistics_cases` DISABLE KEYS */;
INSERT INTO `ticket_logistics_cases` VALUES (1,'LOG00000001',1,1,1,2,7,'2026-10-20 21:02:46.000000','2026-10-20 21:29:05.000000',NULL,NULL,1,1,NULL,'2026-10-20 21:02:46.213827','2026-10-20 21:29:05.332037'),(2,'LOG00000002',2,1,1,2,9,'2026-10-20 21:31:47.000000','2026-10-20 21:46:45.603869',1,'TEMPORARY_LOAN_CONVERSION',1,1,1,'2026-10-20 21:31:47.017189','2026-10-20 21:46:45.609877');
/*!40000 ALTER TABLE `ticket_logistics_cases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_status_history`
--

DROP TABLE IF EXISTS `ticket_status_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_status_history` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(10) unsigned NOT NULL,
  `from_status_id` int(10) unsigned DEFAULT NULL,
  `to_status_id` int(10) unsigned NOT NULL,
  `changed_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `changed_by_user_id` int(10) unsigned DEFAULT NULL,
  `reason` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ticket_status_history_ticket_changed` (`ticket_id`,`changed_at`),
  KEY `idx_ticket_status_history_from_status` (`from_status_id`),
  KEY `idx_ticket_status_history_to_status` (`to_status_id`),
  KEY `idx_ticket_status_history_changed_by` (`changed_by_user_id`),
  CONSTRAINT `fk_ticket_status_history_changed_by` FOREIGN KEY (`changed_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_ticket_status_history_from_status` FOREIGN KEY (`from_status_id`) REFERENCES `ticket_statuses` (`id`),
  CONSTRAINT `fk_ticket_status_history_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`),
  CONSTRAINT `fk_ticket_status_history_to_status` FOREIGN KEY (`to_status_id`) REFERENCES `ticket_statuses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_status_history`
--

LOCK TABLES `ticket_status_history` WRITE;
/*!40000 ALTER TABLE `ticket_status_history` DISABLE KEYS */;
INSERT INTO `ticket_status_history` VALUES (1,1,NULL,1,'2026-10-20 21:01:51.000000',1,NULL,NULL,'2026-10-20 21:01:51'),(2,1,1,3,'2026-10-20 21:02:29.000000',1,NULL,NULL,'2026-10-20 21:02:29'),(3,1,3,4,'2026-10-20 21:03:20.401571',1,NULL,NULL,'2026-10-20 21:03:20'),(4,1,4,5,'2026-10-20 21:03:29.474017',1,NULL,NULL,'2026-10-20 21:03:29'),(5,1,5,6,'2026-10-20 21:28:19.648051',1,'Repair completed and ready for return logistics.',NULL,'2026-10-20 21:28:19'),(6,1,6,7,'2026-10-20 21:29:05.334976',1,NULL,NULL,'2026-10-20 21:29:05'),(7,2,NULL,1,'2026-10-20 21:31:27.000000',1,NULL,NULL,'2026-10-20 21:31:27'),(8,2,1,3,'2026-10-20 21:31:44.000000',1,NULL,NULL,'2026-10-20 21:31:44'),(9,2,3,4,'2026-10-20 21:32:07.205244',1,NULL,NULL,'2026-10-20 21:32:07'),(10,2,4,5,'2026-10-20 21:32:15.307411',1,NULL,NULL,'2026-10-20 21:32:15'),(11,2,5,6,'2026-10-20 21:35:23.934676',1,'Permanent replacement accepted; return logistics is pending.',NULL,'2026-10-20 21:35:23');
/*!40000 ALTER TABLE `ticket_status_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_statuses`
--

DROP TABLE IF EXISTS `ticket_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_statuses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` smallint(5) unsigned NOT NULL,
  `is_terminal` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_ticket_statuses_code` (`code`),
  KEY `idx_ticket_statuses_active_sort` (`is_active`,`sort_order`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_statuses`
--

LOCK TABLES `ticket_statuses` WRITE;
/*!40000 ALTER TABLE `ticket_statuses` DISABLE KEYS */;
INSERT INTO `ticket_statuses` VALUES (1,'SUBMITTED','Submitted','Ticket submitted for school review.',10,0,1,'2026-10-11 08:41:30','2026-10-11 08:41:30'),(2,'NEEDS_CLARIFICATION','Needs Clarification','Additional information is required.',20,0,1,'2026-10-11 08:41:30','2026-10-11 08:41:30'),(3,'APPROVED_FOR_PICKUP','Approved for Pickup','Approved to proceed to the pickup workflow.',30,0,1,'2026-10-11 08:41:30','2026-10-11 08:41:30'),(4,'IN_TRANSIT','In Transit','Device is in an authorized transit stage.',40,0,1,'2026-10-11 08:41:30','2026-10-11 08:41:30'),(5,'UNDER_REPAIR','Under Repair','Device is undergoing repair.',50,0,1,'2026-10-11 08:41:30','2026-10-11 08:41:30'),(6,'COMPLETED','Completed','Repair or support work is complete; physical return may remain.',60,0,1,'2026-10-11 08:41:30','2026-10-11 08:41:30'),(7,'RETURNED','Returned','Device has been returned and the ticket process is terminal.',70,1,1,'2026-10-11 08:41:30','2026-10-11 08:41:30'),(8,'CANCELLED','Cancelled','Ticket was cancelled.',80,1,1,'2026-10-11 08:41:30','2026-10-11 08:41:30');
/*!40000 ALTER TABLE `ticket_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tickets`
--

DROP TABLE IF EXISTS `tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_number` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `device_id` int(10) unsigned NOT NULL,
  `origin_district_id` int(10) unsigned DEFAULT NULL,
  `origin_school_id` int(10) unsigned DEFAULT NULL,
  `origin_student_id` int(10) unsigned DEFAULT NULL,
  `requester_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `requester_name` varchar(220) COLLATE utf8mb4_unicode_ci NOT NULL,
  `requester_email` varchar(254) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `requester_phone` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subject` varchar(220) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `current_status_id` int(10) unsigned NOT NULL,
  `created_by_user_id` int(10) unsigned DEFAULT NULL,
  `updated_by_user_id` int(10) unsigned DEFAULT NULL,
  `submitted_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `closed_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_tickets_ticket_number` (`ticket_number`),
  KEY `idx_tickets_device` (`device_id`),
  KEY `idx_tickets_current_status` (`current_status_id`),
  KEY `idx_tickets_origin_district` (`origin_district_id`),
  KEY `idx_tickets_origin_school` (`origin_school_id`),
  KEY `idx_tickets_origin_student` (`origin_student_id`),
  KEY `idx_tickets_submitted_at` (`submitted_at`),
  KEY `idx_tickets_created_at` (`created_at`),
  KEY `idx_tickets_created_by` (`created_by_user_id`),
  KEY `idx_tickets_updated_by` (`updated_by_user_id`),
  CONSTRAINT `fk_tickets_created_by` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_tickets_current_status` FOREIGN KEY (`current_status_id`) REFERENCES `ticket_statuses` (`id`),
  CONSTRAINT `fk_tickets_device` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_tickets_origin_district` FOREIGN KEY (`origin_district_id`) REFERENCES `districts` (`id`),
  CONSTRAINT `fk_tickets_origin_school` FOREIGN KEY (`origin_school_id`) REFERENCES `schools` (`id`),
  CONSTRAINT `fk_tickets_origin_student` FOREIGN KEY (`origin_student_id`) REFERENCES `students` (`id`),
  CONSTRAINT `fk_tickets_updated_by` FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tickets`
--

LOCK TABLES `tickets` WRITE;
/*!40000 ALTER TABLE `tickets` DISABLE KEYS */;
INSERT INTO `tickets` VALUES (1,'TKT00000001',1,6,1,1,'STUDENT','JERRY LUISE','JLUISE@TEST.COM','(868)456-3345','Wifi Not Working','Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.',7,1,1,'2026-10-20 21:01:51',NULL,'2026-10-20 21:01:51','2026-10-20 21:29:05'),(2,'TKT00000002',1,6,1,1,'STUDENT','JERRY LUISE','JLUISE@TEST.COM','(868)647-3590','Wifi Not Working','Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus',6,1,1,'2026-10-20 21:31:27',NULL,'2026-10-20 21:31:27','2026-10-20 21:35:23');
/*!40000 ALTER TABLE `tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_administration_lock`
--

DROP TABLE IF EXISTS `user_administration_lock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_administration_lock` (
  `id` tinyint(3) unsigned NOT NULL,
  `touched_at` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_administration_lock`
--

LOCK TABLES `user_administration_lock` WRITE;
/*!40000 ALTER TABLE `user_administration_lock` DISABLE KEYS */;
INSERT INTO `user_administration_lock` VALUES (1,'2026-10-20 17:52:22.000');
/*!40000 ALTER TABLE `user_administration_lock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_district_scopes`
--

DROP TABLE IF EXISTS `user_district_scopes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_district_scopes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `district_id` int(10) unsigned NOT NULL,
  `status` enum('active','revoked') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `assigned_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `assigned_by` int(10) unsigned DEFAULT NULL,
  `revoked_at` datetime DEFAULT NULL,
  `revoked_by` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_district_scopes_user_status` (`user_id`,`status`),
  KEY `idx_user_district_scopes_district_status` (`district_id`,`status`),
  KEY `fk_user_district_scopes_assigned_by` (`assigned_by`),
  KEY `fk_user_district_scopes_revoked_by` (`revoked_by`),
  CONSTRAINT `fk_user_district_scopes_assigned_by` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_user_district_scopes_district` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`),
  CONSTRAINT `fk_user_district_scopes_revoked_by` FOREIGN KEY (`revoked_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_user_district_scopes_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_district_scopes`
--

LOCK TABLES `user_district_scopes` WRITE;
/*!40000 ALTER TABLE `user_district_scopes` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_district_scopes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `user_effective_permissions`
--

DROP TABLE IF EXISTS `user_effective_permissions`;
/*!50001 DROP VIEW IF EXISTS `user_effective_permissions`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `user_effective_permissions` AS SELECT 
 1 AS `user_id`,
 1 AS `permission_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `user_login_identities`
--

DROP TABLE IF EXISTS `user_login_identities`;
/*!50001 DROP VIEW IF EXISTS `user_login_identities`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `user_login_identities` AS SELECT 
 1 AS `id`,
 1 AS `login_identifier`,
 1 AS `password_hash`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `user_national_scopes`
--

DROP TABLE IF EXISTS `user_national_scopes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_national_scopes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `status` enum('active','revoked') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `assigned_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `assigned_by` int(10) unsigned DEFAULT NULL,
  `revoked_at` datetime DEFAULT NULL,
  `revoked_by` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_national_scopes_user_status` (`user_id`,`status`),
  KEY `idx_user_national_scopes_status` (`status`),
  KEY `fk_user_national_scopes_assigned_by` (`assigned_by`),
  KEY `fk_user_national_scopes_revoked_by` (`revoked_by`),
  CONSTRAINT `fk_user_national_scopes_assigned_by` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_user_national_scopes_revoked_by` FOREIGN KEY (`revoked_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_user_national_scopes_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_national_scopes`
--

LOCK TABLES `user_national_scopes` WRITE;
/*!40000 ALTER TABLE `user_national_scopes` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_national_scopes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_roles` (
  `user_id` int(10) unsigned NOT NULL,
  `role_id` int(10) unsigned NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `idx_user_roles_role_id` (`role_id`),
  CONSTRAINT `fk_user_roles_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_roles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES (1,1,'2026-10-17 15:06:55');
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_school_scopes`
--

DROP TABLE IF EXISTS `user_school_scopes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_school_scopes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `school_id` int(10) unsigned NOT NULL,
  `status` enum('active','revoked') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `assigned_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `assigned_by` int(10) unsigned DEFAULT NULL,
  `revoked_at` datetime DEFAULT NULL,
  `revoked_by` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_school_scopes_user_status` (`user_id`,`status`),
  KEY `idx_user_school_scopes_school_status` (`school_id`,`status`),
  KEY `fk_user_school_scopes_assigned_by` (`assigned_by`),
  KEY `fk_user_school_scopes_revoked_by` (`revoked_by`),
  CONSTRAINT `fk_user_school_scopes_assigned_by` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_user_school_scopes_revoked_by` FOREIGN KEY (`revoked_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_user_school_scopes_school` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`),
  CONSTRAINT `fk_user_school_scopes_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_school_scopes`
--

LOCK TABLES `user_school_scopes` WRITE;
/*!40000 ALTER TABLE `user_school_scopes` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_school_scopes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_service_location_scopes`
--

DROP TABLE IF EXISTS `user_service_location_scopes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_service_location_scopes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `service_location_id` int(10) unsigned NOT NULL,
  `status` enum('active','revoked') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `assigned_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `assigned_by` int(10) unsigned DEFAULT NULL,
  `revoked_at` datetime DEFAULT NULL,
  `revoked_by` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_service_location_scopes_user_status` (`user_id`,`status`),
  KEY `idx_user_service_location_scopes_location_status` (`service_location_id`,`status`),
  KEY `fk_user_service_location_scopes_assigned_by` (`assigned_by`),
  KEY `fk_user_service_location_scopes_revoked_by` (`revoked_by`),
  CONSTRAINT `fk_user_service_location_scopes_assigned_by` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_user_service_location_scopes_location` FOREIGN KEY (`service_location_id`) REFERENCES `service_locations` (`id`),
  CONSTRAINT `fk_user_service_location_scopes_revoked_by` FOREIGN KEY (`revoked_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_user_service_location_scopes_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_service_location_scopes`
--

LOCK TABLES `user_service_location_scopes` WRITE;
/*!40000 ALTER TABLE `user_service_location_scopes` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_service_location_scopes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(254) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(220) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('active','disabled','locked') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `auth_version` int(10) unsigned NOT NULL DEFAULT '1',
  `password_reset_throttle_touched_at` datetime(3) DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `password_changed_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_username` (`username`),
  UNIQUE KEY `uq_users_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'yarycling','yarycling@yahoo.com','$argon2id$v=19$m=65536,t=3,p=4$8NeGhl0HOxGqDE1gTUZEZg$8zlJur+zXm5bRSSszH3u166cC5QaKMXVJa5bzTrZQf4','Super','Administrator','Super Administrator','active',2,'2026-10-18 07:42:59.000','2026-10-21 08:51:36','2026-10-17 18:48:43','2026-10-17 15:06:55','2026-10-21 08:51:36');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `v_device_active_primary_student_assignments`
--

DROP TABLE IF EXISTS `v_device_active_primary_student_assignments`;
/*!50001 DROP VIEW IF EXISTS `v_device_active_primary_student_assignments`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_device_active_primary_student_assignments` AS SELECT 
 1 AS `student_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_device_current_custody`
--

DROP TABLE IF EXISTS `v_device_current_custody`;
/*!50001 DROP VIEW IF EXISTS `v_device_current_custody`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_device_current_custody` AS SELECT 
 1 AS `device_id`,
 1 AS `current_custody_level`,
 1 AS `district_allocation_id`,
 1 AS `district_id`,
 1 AS `school_allocation_id`,
 1 AS `school_id`,
 1 AS `student_assignment_id`,
 1 AS `student_id`,
 1 AS `student_assignment_type`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_device_current_stock_location`
--

DROP TABLE IF EXISTS `v_device_current_stock_location`;
/*!50001 DROP VIEW IF EXISTS `v_device_current_stock_location`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_device_current_stock_location` AS SELECT 
 1 AS `stock_location_id`,
 1 AS `device_id`,
 1 AS `service_location_id`,
 1 AS `service_location_code`,
 1 AS `service_location_name`,
 1 AS `stock_status`,
 1 AS `reason_code`,
 1 AS `placed_at`,
 1 AS `placed_by`,
 1 AS `physical_custody_code`,
 1 AS `physical_custody_name`,
 1 AS `replacement_case_id`,
 1 AS `is_reserved_for_replacement`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_device_stock_intake_eligibility`
--

DROP TABLE IF EXISTS `v_device_stock_intake_eligibility`;
/*!50001 DROP VIEW IF EXISTS `v_device_stock_intake_eligibility`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_device_stock_intake_eligibility` AS SELECT 
 1 AS `device_id`,
 1 AS `serial_number`,
 1 AS `asset_tag`,
 1 AS `manufacturer_name`,
 1 AS `model_name`,
 1 AS `lifecycle_code`,
 1 AS `allocation_level`,
 1 AS `district_id`,
 1 AS `district_name`,
 1 AS `school_id`,
 1 AS `school_name`,
 1 AS `has_active_stock`,
 1 AS `has_active_logistics`,
 1 AS `has_active_manufacturer_return`,
 1 AS `has_active_repair`,
 1 AS `has_replacement_reservation`,
 1 AS `has_replacement_consumption`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_device_stock_queue`
--

DROP TABLE IF EXISTS `v_device_stock_queue`;
/*!50001 DROP VIEW IF EXISTS `v_device_stock_queue`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_device_stock_queue` AS SELECT 
 1 AS `stock_location_id`,
 1 AS `device_id`,
 1 AS `serial_number`,
 1 AS `asset_tag`,
 1 AS `manufacturer_name`,
 1 AS `model_name`,
 1 AS `lifecycle_code`,
 1 AS `allocation_level`,
 1 AS `district_id`,
 1 AS `district_name`,
 1 AS `school_id`,
 1 AS `school_name`,
 1 AS `service_location_id`,
 1 AS `service_location_code`,
 1 AS `service_location_name`,
 1 AS `stock_status`,
 1 AS `physical_custody_code`,
 1 AS `physical_custody_name`,
 1 AS `placed_at`,
 1 AS `placed_by`,
 1 AS `is_reserved_for_replacement`,
 1 AS `replacement_case_id`,
 1 AS `has_active_logistics`,
 1 AS `has_active_manufacturer_return`,
 1 AS `has_active_repair`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_escalation_case_targets`
--

DROP TABLE IF EXISTS `v_escalation_case_targets`;
/*!50001 DROP VIEW IF EXISTS `v_escalation_case_targets`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_escalation_case_targets` AS SELECT 
 1 AS `escalation_case_id`,
 1 AS `assignment_id`,
 1 AS `level_snapshot`,
 1 AS `trigger_snapshot`,
 1 AS `target_role_id`,
 1 AS `target_role_name_snapshot`,
 1 AS `reason_snapshot`,
 1 AS `assigned_at`,
 1 AS `assigned_by`,
 1 AS `current_state_code`,
 1 AS `current_level`,
 1 AS `district_id`,
 1 AS `school_id`,
 1 AS `repair_centre_location_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_escalation_operational_queue`
--

DROP TABLE IF EXISTS `v_escalation_operational_queue`;
/*!50001 DROP VIEW IF EXISTS `v_escalation_operational_queue`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_escalation_operational_queue` AS SELECT 
 1 AS `escalation_case_id`,
 1 AS `escalation_number`,
 1 AS `sla_instance_id`,
 1 AS `policy_code_snapshot`,
 1 AS `ticket_id`,
 1 AS `ticket_number`,
 1 AS `logistics_case_id`,
 1 AS `logistics_number`,
 1 AS `repair_job_id`,
 1 AS `district_id`,
 1 AS `district_name`,
 1 AS `school_id`,
 1 AS `school_name`,
 1 AS `repair_centre_location_id`,
 1 AS `repair_centre_name`,
 1 AS `current_level`,
 1 AS `current_trigger`,
 1 AS `current_state_code`,
 1 AS `current_state_name`,
 1 AS `reason_snapshot`,
 1 AS `opened_at`,
 1 AS `acknowledged_at`,
 1 AS `opened_at_display`,
 1 AS `acknowledged_at_display`,
 1 AS `acknowledged_by`,
 1 AS `acknowledged_by_name`,
 1 AS `acknowledgement_note`,
 1 AS `resolved_at`,
 1 AS `cancelled_at`,
 1 AS `resolved_at_display`,
 1 AS `cancelled_at_display`,
 1 AS `sla_state_code`,
 1 AS `sla_state_name`,
 1 AS `sla_started_at`,
 1 AS `sla_due_at`,
 1 AS `sla_at_risk_at`,
 1 AS `sla_breached_at`,
 1 AS `sla_completed_at`,
 1 AS `sla_cancelled_at`,
 1 AS `sla_started_at_display`,
 1 AS `sla_due_at_display`,
 1 AS `responsible_roles`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_logistics_case_detail_context`
--

DROP TABLE IF EXISTS `v_logistics_case_detail_context`;
/*!50001 DROP VIEW IF EXISTS `v_logistics_case_detail_context`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_logistics_case_detail_context` AS SELECT 
 1 AS `logistics_case_id`,
 1 AS `logistics_number`,
 1 AS `ticket_id`,
 1 AS `ticket_number`,
 1 AS `device_id`,
 1 AS `original_device_id`,
 1 AS `device_source`,
 1 AS `replacement_case_id`,
 1 AS `replacement_number`,
 1 AS `temporary_loan_case_id`,
 1 AS `serial_number`,
 1 AS `asset_tag`,
 1 AS `original_serial_number`,
 1 AS `original_asset_tag`,
 1 AS `pickup_school_id`,
 1 AS `pickup_school_name`,
 1 AS `pickup_district_id`,
 1 AS `pickup_district_name`,
 1 AS `repair_centre_location_id`,
 1 AS `repair_centre_name`,
 1 AS `current_logistics_status_id`,
 1 AS `current_logistics_status_code`,
 1 AS `current_logistics_status_name`,
 1 AS `requested_at`,
 1 AS `closed_at`,
 1 AS `active_record_key`,
 1 AS `is_active`,
 1 AS `returned_physical_state_code`,
 1 AS `ticket_current_status_id`,
 1 AS `ticket_current_status_code`,
 1 AS `allocation_custody_level`,
 1 AS `allocation_district_id`,
 1 AS `allocation_school_id`,
 1 AS `allocation_school_name`,
 1 AS `allocation_student_id`,
 1 AS `device_lifecycle_code`,
 1 AS `device_lifecycle_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_logistics_current_context`
--

DROP TABLE IF EXISTS `v_logistics_current_context`;
/*!50001 DROP VIEW IF EXISTS `v_logistics_current_context`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_logistics_current_context` AS SELECT 
 1 AS `logistics_case_id`,
 1 AS `logistics_number`,
 1 AS `ticket_id`,
 1 AS `ticket_number`,
 1 AS `device_id`,
 1 AS `serial_number`,
 1 AS `asset_tag`,
 1 AS `original_device_id`,
 1 AS `device_source`,
 1 AS `replacement_case_id`,
 1 AS `replacement_number`,
 1 AS `temporary_loan_case_id`,
 1 AS `pickup_school_id`,
 1 AS `pickup_school_name`,
 1 AS `pickup_district_id`,
 1 AS `pickup_district_name`,
 1 AS `repair_centre_location_id`,
 1 AS `repair_centre_name`,
 1 AS `current_logistics_status_id`,
 1 AS `current_logistics_status_code`,
 1 AS `current_logistics_status_name`,
 1 AS `requested_at`,
 1 AS `closed_at`,
 1 AS `active_record_key`,
 1 AS `is_active`,
 1 AS `pending_handoff_id`,
 1 AS `pending_handoff_type`,
 1 AS `pending_handoff_dispatched_at`,
 1 AS `ticket_current_status_id`,
 1 AS `ticket_current_status_code`,
 1 AS `allocation_custody_level`,
 1 AS `allocation_district_id`,
 1 AS `allocation_school_id`,
 1 AS `allocation_student_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_logistics_physical_custody`
--

DROP TABLE IF EXISTS `v_logistics_physical_custody`;
/*!50001 DROP VIEW IF EXISTS `v_logistics_physical_custody`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_logistics_physical_custody` AS SELECT 
 1 AS `logistics_case_id`,
 1 AS `logistics_number`,
 1 AS `ticket_id`,
 1 AS `original_device_id`,
 1 AS `device_id`,
 1 AS `device_source`,
 1 AS `replacement_case_id`,
 1 AS `replacement_number`,
 1 AS `temporary_loan_case_id`,
 1 AS `logistics_status_id`,
 1 AS `logistics_status_code`,
 1 AS `ticket_status_id`,
 1 AS `ticket_status_code`,
 1 AS `physical_state_code`,
 1 AS `current_service_location_id`,
 1 AS `current_service_location_code`,
 1 AS `current_service_location_name`,
 1 AS `pending_handoff_id`,
 1 AS `pending_handoff_type`,
 1 AS `pending_handoff_device_id`,
 1 AS `pending_since`,
 1 AS `handoff_dispatched_by_user_id`,
 1 AS `last_completed_handoff_id`,
 1 AS `last_completed_handoff_type`,
 1 AS `last_completed_handoff_device_id`,
 1 AS `last_handoff_received_at`,
 1 AS `handoff_received_by_user_id`,
 1 AS `ttpost_location_id`,
 1 AS `ttpost_location_code`,
 1 AS `ttpost_location_name`,
 1 AS `repair_centre_location_id`,
 1 AS `repair_centre_location_code`,
 1 AS `repair_centre_location_name`,
 1 AS `pending_repair_handoff_id`,
 1 AS `allocation_custody_level`,
 1 AS `allocation_district_id`,
 1 AS `allocation_school_id`,
 1 AS `allocation_school_name`,
 1 AS `allocation_student_id`,
 1 AS `device_lifecycle_code`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_logistics_return_device`
--

DROP TABLE IF EXISTS `v_logistics_return_device`;
/*!50001 DROP VIEW IF EXISTS `v_logistics_return_device`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_logistics_return_device` AS SELECT 
 1 AS `logistics_case_id`,
 1 AS `original_device_id`,
 1 AS `return_device_id`,
 1 AS `completed_replacement_case_id`,
 1 AS `replacement_physical_custody_code`,
 1 AS `original_replacement_physical_custody_code`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_manufacturer_return_physical_custody`
--

DROP TABLE IF EXISTS `v_manufacturer_return_physical_custody`;
/*!50001 DROP VIEW IF EXISTS `v_manufacturer_return_physical_custody`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_manufacturer_return_physical_custody` AS SELECT 
 1 AS `manufacturer_return_case_id`,
 1 AS `ticket_id`,
 1 AS `original_device_id`,
 1 AS `repair_centre_location_id`,
 1 AS `manufacturer_return_status_code`,
 1 AS `current_outcome_code`,
 1 AS `outbound_carrier_id`,
 1 AS `outbound_carrier_type`,
 1 AS `return_carrier_id`,
 1 AS `return_carrier_type`,
 1 AS `physical_custody_code`,
 1 AS `has_ttpost_participation`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_manufacturer_return_queue`
--

DROP TABLE IF EXISTS `v_manufacturer_return_queue`;
/*!50001 DROP VIEW IF EXISTS `v_manufacturer_return_queue`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_manufacturer_return_queue` AS SELECT 
 1 AS `manufacturer_return_case_id`,
 1 AS `manufacturer_return_number`,
 1 AS `ticket_id`,
 1 AS `ticket_number`,
 1 AS `logistics_number`,
 1 AS `logistics_status_code`,
 1 AS `logistics_status_name`,
 1 AS `phase7_physical_state_code`,
 1 AS `original_device_id`,
 1 AS `serial_number`,
 1 AS `asset_tag`,
 1 AS `manufacturer_id`,
 1 AS `manufacturer_name`,
 1 AS `repair_centre_location_id`,
 1 AS `repair_centre_name`,
 1 AS `origin_school_id`,
 1 AS `origin_school_name`,
 1 AS `origin_district_id`,
 1 AS `origin_district_name`,
 1 AS `manufacturer_return_status_code`,
 1 AS `manufacturer_return_status_name`,
 1 AS `exception_status_code`,
 1 AS `exception_status_name`,
 1 AS `outbound_carrier_id`,
 1 AS `outbound_carrier_name`,
 1 AS `outbound_carrier_type`,
 1 AS `return_carrier_id`,
 1 AS `return_carrier_name`,
 1 AS `return_carrier_type`,
 1 AS `current_outcome_code`,
 1 AS `current_outcome_name`,
 1 AS `started_at`,
 1 AS `updated_at`,
 1 AS `closed_at`,
 1 AS `physical_custody_code`,
 1 AS `has_ttpost_participation`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_notification_inbox`
--

DROP TABLE IF EXISTS `v_notification_inbox`;
/*!50001 DROP VIEW IF EXISTS `v_notification_inbox`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_notification_inbox` AS SELECT 
 1 AS `recipient_id`,
 1 AS `notification_event_id`,
 1 AS `user_id`,
 1 AS `recipient_role_code`,
 1 AS `delivered_in_app_at`,
 1 AS `read_at`,
 1 AS `read_by`,
 1 AS `archived_at`,
 1 AS `read_state`,
 1 AS `idempotency_key`,
 1 AS `event_type_code`,
 1 AS `event_type_name`,
 1 AS `source_type`,
 1 AS `source_id`,
 1 AS `ticket_id`,
 1 AS `ticket_number`,
 1 AS `origin_school_id`,
 1 AS `school_name`,
 1 AS `origin_district_id`,
 1 AS `district_name`,
 1 AS `serial_number`,
 1 AS `asset_tag`,
 1 AS `sla_instance_id`,
 1 AS `sla_policy_code`,
 1 AS `escalation_case_id`,
 1 AS `escalation_number`,
 1 AS `escalation_level`,
 1 AS `escalation_state_code`,
 1 AS `logistics_case_id`,
 1 AS `logistics_number`,
 1 AS `handoff_type`,
 1 AS `repair_job_id`,
 1 AS `repair_centre_location_id`,
 1 AS `repair_centre_name`,
 1 AS `temporary_loan_case_id`,
 1 AS `permanent_replacement_case_id`,
 1 AS `severity_code`,
 1 AS `severity_name`,
 1 AS `title`,
 1 AS `message`,
 1 AS `action_type`,
 1 AS `action_reference`,
 1 AS `created_at`,
 1 AS `created_at_display`,
 1 AS `created_by_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_notification_unread_recipients`
--

DROP TABLE IF EXISTS `v_notification_unread_recipients`;
/*!50001 DROP VIEW IF EXISTS `v_notification_unread_recipients`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_notification_unread_recipients` AS SELECT 
 1 AS `id`,
 1 AS `notification_event_id`,
 1 AS `user_id`,
 1 AS `read_at`,
 1 AS `read_by`,
 1 AS `archived_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_permanent_replacement_inventory_candidates`
--

DROP TABLE IF EXISTS `v_permanent_replacement_inventory_candidates`;
/*!50001 DROP VIEW IF EXISTS `v_permanent_replacement_inventory_candidates`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_permanent_replacement_inventory_candidates` AS SELECT 
 1 AS `replacement_case_id`,
 1 AS `stock_location_id`,
 1 AS `device_id`,
 1 AS `serial_number`,
 1 AS `asset_tag`,
 1 AS `manufacturer_name`,
 1 AS `model_name`,
 1 AS `lifecycle_code`,
 1 AS `allocation_level`,
 1 AS `district_id`,
 1 AS `district_name`,
 1 AS `school_id`,
 1 AS `school_name`,
 1 AS `service_location_id`,
 1 AS `service_location_name`,
 1 AS `stock_status`,
 1 AS `is_reserved_for_replacement`,
 1 AS `lifecycle_status_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_permanent_replacement_queue`
--

DROP TABLE IF EXISTS `v_permanent_replacement_queue`;
/*!50001 DROP VIEW IF EXISTS `v_permanent_replacement_queue`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_permanent_replacement_queue` AS SELECT 
 1 AS `replacement_case_id`,
 1 AS `replacement_number`,
 1 AS `exception_case_id`,
 1 AS `temporary_loan_case_id`,
 1 AS `loan_number`,
 1 AS `conversion_request_number`,
 1 AS `ticket_id`,
 1 AS `ticket_number`,
 1 AS `logistics_case_id`,
 1 AS `logistics_number`,
 1 AS `logistics_status_code`,
 1 AS `logistics_status_name`,
 1 AS `repair_job_id`,
 1 AS `original_device_id`,
 1 AS `original_serial_number`,
 1 AS `original_asset_tag`,
 1 AS `original_model_name`,
 1 AS `original_manufacturer_name`,
 1 AS `replacement_source_type`,
 1 AS `staged_manufacturer_unit_id`,
 1 AS `staged_serial_number`,
 1 AS `staged_model_description`,
 1 AS `replacement_device_id`,
 1 AS `replacement_serial_number`,
 1 AS `replacement_asset_tag`,
 1 AS `repair_service_location_id`,
 1 AS `repair_centre_name`,
 1 AS `origin_school_id`,
 1 AS `origin_school_name`,
 1 AS `origin_district_id`,
 1 AS `origin_district_name`,
 1 AS `replacement_status_code`,
 1 AS `replacement_status_name`,
 1 AS `exception_status_code`,
 1 AS `ticket_status_code`,
 1 AS `ticket_status_name`,
 1 AS `original_device_lifecycle_code`,
 1 AS `original_device_lifecycle_name`,
 1 AS `phase5_custody_level`,
 1 AS `phase5_district_id`,
 1 AS `phase5_school_id`,
 1 AS `phase5_student_id`,
 1 AS `created_by`,
 1 AS `created_at`,
 1 AS `updated_by`,
 1 AS `updated_at`,
 1 AS `completed_by`,
 1 AS `completed_at`,
 1 AS `closed_at`,
 1 AS `active_record_key`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_repair_current_context`
--

DROP TABLE IF EXISTS `v_repair_current_context`;
/*!50001 DROP VIEW IF EXISTS `v_repair_current_context`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_repair_current_context` AS SELECT 
 1 AS `logistics_case_id`,
 1 AS `logistics_number`,
 1 AS `ticket_id`,
 1 AS `ticket_number`,
 1 AS `device_id`,
 1 AS `serial_number`,
 1 AS `asset_tag`,
 1 AS `repair_centre_location_id`,
 1 AS `repair_centre_code`,
 1 AS `repair_centre_name`,
 1 AS `repair_centre_location_code`,
 1 AS `repair_centre_location_name`,
 1 AS `physical_state_code`,
 1 AS `logistics_status_code`,
 1 AS `ticket_status_code`,
 1 AS `allocation_custody_level`,
 1 AS `allocation_district_id`,
 1 AS `allocation_school_id`,
 1 AS `allocation_student_id`,
 1 AS `device_lifecycle_code`,
 1 AS `repair_job_id`,
 1 AS `started_at`,
 1 AS `started_by_user_id`,
 1 AS `started_by_display_name`,
 1 AS `completed_at`,
 1 AS `completed_by_user_id`,
 1 AS `completed_by_display_name`,
 1 AS `outcome_id`,
 1 AS `outcome_code`,
 1 AS `outcome_name`,
 1 AS `outcome_is_return_ready`,
 1 AS `is_return_ready`,
 1 AS `assessment_count`,
 1 AS `work_log_count`,
 1 AS `repair_state_code`,
 1 AS `repair_state`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_sla_calendar_business_dates`
--

DROP TABLE IF EXISTS `v_sla_calendar_business_dates`;
/*!50001 DROP VIEW IF EXISTS `v_sla_calendar_business_dates`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_sla_calendar_business_dates` AS SELECT 
 1 AS `calendar_id`,
 1 AS `calendar_date`,
 1 AS `business_due_at`,
 1 AS `is_business_day`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_sla_completion_context`
--

DROP TABLE IF EXISTS `v_sla_completion_context`;
/*!50001 DROP VIEW IF EXISTS `v_sla_completion_context`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_sla_completion_context` AS SELECT 
 1 AS `id`,
 1 AS `idempotency_key`,
 1 AS `current_state_code`,
 1 AS `due_at`,
 1 AS `policy_code_snapshot`,
 1 AS `calendar_id`,
 1 AS `timezone_name`,
 1 AS `completion_business_datetime`,
 1 AS `timezone_resolution_error`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_sla_evaluation_queue`
--

DROP TABLE IF EXISTS `v_sla_evaluation_queue`;
/*!50001 DROP VIEW IF EXISTS `v_sla_evaluation_queue`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_sla_evaluation_queue` AS SELECT 
 1 AS `id`,
 1 AS `policy_code_snapshot`,
 1 AS `current_state_code`,
 1 AS `due_at`,
 1 AS `at_risk_at`,
 1 AS `source_entity_type`,
 1 AS `source_entity_id`,
 1 AS `calendar_id`,
 1 AS `timezone_name`,
 1 AS `evaluation_business_datetime`,
 1 AS `due_business_date`,
 1 AS `evaluation_business_date`,
 1 AS `is_breached`,
 1 AS `is_at_risk`,
 1 AS `timezone_resolution_error`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_sla_operational_queue`
--

DROP TABLE IF EXISTS `v_sla_operational_queue`;
/*!50001 DROP VIEW IF EXISTS `v_sla_operational_queue`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_sla_operational_queue` AS SELECT 
 1 AS `sla_instance_id`,
 1 AS `idempotency_key`,
 1 AS `policy_code_snapshot`,
 1 AS `policy_name`,
 1 AS `target_business_days_snapshot`,
 1 AS `current_state_code`,
 1 AS `current_state_name`,
 1 AS `started_at`,
 1 AS `due_at`,
 1 AS `at_risk_at`,
 1 AS `breached_at`,
 1 AS `completed_at`,
 1 AS `cancelled_at`,
 1 AS `started_at_display`,
 1 AS `due_at_display`,
 1 AS `at_risk_at_display`,
 1 AS `breached_at_display`,
 1 AS `completed_at_display`,
 1 AS `cancelled_at_display`,
 1 AS `completion_event`,
 1 AS `ticket_id`,
 1 AS `ticket_number`,
 1 AS `origin_district_id`,
 1 AS `origin_district_name`,
 1 AS `origin_school_id`,
 1 AS `origin_school_name`,
 1 AS `logistics_case_id`,
 1 AS `logistics_number`,
 1 AS `repair_centre_location_id`,
 1 AS `repair_job_id`,
 1 AS `device_id`,
 1 AS `effective_device_id`,
 1 AS `source_workflow`,
 1 AS `source_entity_type`,
 1 AS `source_entity_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_sla_policy_current`
--

DROP TABLE IF EXISTS `v_sla_policy_current`;
/*!50001 DROP VIEW IF EXISTS `v_sla_policy_current`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_sla_policy_current` AS SELECT 
 1 AS `policy_id`,
 1 AS `policy_code`,
 1 AS `policy_version_id`,
 1 AS `version_number`,
 1 AS `name`,
 1 AS `description`,
 1 AS `calendar_id`,
 1 AS `calendar_code`,
 1 AS `calendar_name`,
 1 AS `target_business_days`,
 1 AS `status`,
 1 AS `sort_order`,
 1 AS `start_event_code`,
 1 AS `completion_event_code`,
 1 AS `pause_condition_code`,
 1 AS `version_created_by`,
 1 AS `version_created_at`,
 1 AS `policy_created_at`,
 1 AS `policy_updated_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_sla_policy_version_history`
--

DROP TABLE IF EXISTS `v_sla_policy_version_history`;
/*!50001 DROP VIEW IF EXISTS `v_sla_policy_version_history`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_sla_policy_version_history` AS SELECT 
 1 AS `policy_version_id`,
 1 AS `policy_id`,
 1 AS `policy_code`,
 1 AS `version_number`,
 1 AS `name`,
 1 AS `description`,
 1 AS `calendar_id`,
 1 AS `calendar_code`,
 1 AS `calendar_name`,
 1 AS `target_business_days`,
 1 AS `status`,
 1 AS `sort_order`,
 1 AS `start_event_code`,
 1 AS `completion_event_code`,
 1 AS `pause_condition_code`,
 1 AS `created_by`,
 1 AS `created_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_temporary_loan_queue`
--

DROP TABLE IF EXISTS `v_temporary_loan_queue`;
/*!50001 DROP VIEW IF EXISTS `v_temporary_loan_queue`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_temporary_loan_queue` AS SELECT 
 1 AS `temporary_loan_case_id`,
 1 AS `loan_number`,
 1 AS `ticket_id`,
 1 AS `ticket_number`,
 1 AS `original_device_id`,
 1 AS `original_serial_number`,
 1 AS `original_asset_tag`,
 1 AS `origin_district_id`,
 1 AS `origin_district_name`,
 1 AS `origin_school_id`,
 1 AS `origin_school_name`,
 1 AS `repair_job_id`,
 1 AS `repair_service_location_id`,
 1 AS `repair_centre_name`,
 1 AS `spare_pool_id`,
 1 AS `pool_code`,
 1 AS `spare_pool_name`,
 1 AS `current_status_code`,
 1 AS `loan_status_name`,
 1 AS `request_reason_code`,
 1 AS `requested_by`,
 1 AS `requested_at`,
 1 AS `request_notes`,
 1 AS `logistics_case_id`,
 1 AS `authorized_by`,
 1 AS `authorized_at`,
 1 AS `authorization_notes`,
 1 AS `rejected_by`,
 1 AS `rejected_at`,
 1 AS `rejection_reason`,
 1 AS `selected_spare_device_id`,
 1 AS `selected_by`,
 1 AS `selected_at`,
 1 AS `issued_by`,
 1 AS `issued_at`,
 1 AS `return_requested_by`,
 1 AS `return_requested_at`,
 1 AS `return_reason_code`,
 1 AS `return_reason_name`,
 1 AS `return_notes`,
 1 AS `return_condition_code`,
 1 AS `returned_by`,
 1 AS `returned_at`,
 1 AS `conversion_status`,
 1 AS `conversion_request_id`,
 1 AS `active_record_key`,
 1 AS `created_at`,
 1 AS `updated_at`,
 1 AS `closed_at`,
 1 AS `ticket_status_code`,
 1 AS `logistics_status_code`,
 1 AS `repair_completed_at`,
 1 AS `manufacturer_return_status_code`,
 1 AS `selected_spare_serial_number`,
 1 AS `selected_spare_asset_tag`,
 1 AS `selected_spare_manufacturer_name`,
 1 AS `selected_spare_model_name`,
 1 AS `selected_spare_lifecycle_code`,
 1 AS `selected_spare_stock_status`,
 1 AS `selected_spare_stock_location_id`,
 1 AS `spare_reservation_status`,
 1 AS `spare_reservation_active`,
 1 AS `physical_custody_code`,
 1 AS `custody_recorded_at`,
 1 AS `latest_conversion_request_id`,
 1 AS `conversion_request_number`,
 1 AS `conversion_request_status`,
 1 AS `conversion_reason_code`,
 1 AS `conversion_reason_name`,
 1 AS `conversion_request_notes`,
 1 AS `conversion_requested_by`,
 1 AS `conversion_requested_by_name`,
 1 AS `conversion_requested_at`,
 1 AS `conversion_decision`,
 1 AS `conversion_decided_by`,
 1 AS `conversion_decided_by_name`,
 1 AS `conversion_decided_at`,
 1 AS `conversion_decision_notes`,
 1 AS `permanent_replacement_case_id`,
 1 AS `permanent_replacement_number`,
 1 AS `permanent_replacement_status`,
 1 AS `original_device_lifecycle_code`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_temporary_loan_request_context`
--

DROP TABLE IF EXISTS `v_temporary_loan_request_context`;
/*!50001 DROP VIEW IF EXISTS `v_temporary_loan_request_context`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_temporary_loan_request_context` AS SELECT 
 1 AS `ticket_id`,
 1 AS `ticket_number`,
 1 AS `original_device_id`,
 1 AS `origin_district_id`,
 1 AS `origin_school_id`,
 1 AS `ticket_status_code`,
 1 AS `logistics_case_id`,
 1 AS `repair_service_location_id`,
 1 AS `logistics_status_code`,
 1 AS `repair_job_id`,
 1 AS `original_lifecycle_code`,
 1 AS `spare_pool_id`,
 1 AS `pool_code`,
 1 AS `spare_pool_name`,
 1 AS `can_request`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_temporary_loan_spare_candidates`
--

DROP TABLE IF EXISTS `v_temporary_loan_spare_candidates`;
/*!50001 DROP VIEW IF EXISTS `v_temporary_loan_spare_candidates`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_temporary_loan_spare_candidates` AS SELECT 
 1 AS `temporary_loan_case_id`,
 1 AS `repair_service_location_id`,
 1 AS `spare_pool_id`,
 1 AS `stock_location_id`,
 1 AS `device_id`,
 1 AS `serial_number`,
 1 AS `asset_tag`,
 1 AS `manufacturer_name`,
 1 AS `model_name`,
 1 AS `lifecycle_code`,
 1 AS `stock_status`,
 1 AS `service_location_id`,
 1 AS `service_location_name`,
 1 AS `allocation_level`,
 1 AS `is_reserved_for_replacement`,
 1 AS `has_active_logistics`,
 1 AS `has_active_manufacturer_return`,
 1 AS `has_active_repair`,
 1 AS `lifecycle_status_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_ticket_activity`
--

DROP TABLE IF EXISTS `v_ticket_activity`;
/*!50001 DROP VIEW IF EXISTS `v_ticket_activity`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_ticket_activity` AS SELECT 
 1 AS `ticket_id`,
 1 AS `activity_at`,
 1 AS `activity_type`,
 1 AS `activity_code`,
 1 AS `related_record_id`,
 1 AS `actor_user_id`,
 1 AS `subject_user_id`,
 1 AS `from_status_id`,
 1 AS `to_status_id`,
 1 AS `reference_code`,
 1 AS `activity_sort_order`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_ticket_activity_08d_a`
--

DROP TABLE IF EXISTS `v_ticket_activity_08d_a`;
/*!50001 DROP VIEW IF EXISTS `v_ticket_activity_08d_a`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_ticket_activity_08d_a` AS SELECT 
 1 AS `ticket_id`,
 1 AS `activity_at`,
 1 AS `activity_type`,
 1 AS `activity_code`,
 1 AS `related_record_id`,
 1 AS `actor_user_id`,
 1 AS `subject_user_id`,
 1 AS `from_status_id`,
 1 AS `to_status_id`,
 1 AS `reference_code`,
 1 AS `activity_sort_order`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_ticket_activity_08d_b`
--

DROP TABLE IF EXISTS `v_ticket_activity_08d_b`;
/*!50001 DROP VIEW IF EXISTS `v_ticket_activity_08d_b`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_ticket_activity_08d_b` AS SELECT 
 1 AS `ticket_id`,
 1 AS `activity_at`,
 1 AS `activity_type`,
 1 AS `activity_code`,
 1 AS `related_record_id`,
 1 AS `actor_user_id`,
 1 AS `subject_user_id`,
 1 AS `from_status_id`,
 1 AS `to_status_id`,
 1 AS `reference_code`,
 1 AS `activity_sort_order`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_ticket_activity_08d_e`
--

DROP TABLE IF EXISTS `v_ticket_activity_08d_e`;
/*!50001 DROP VIEW IF EXISTS `v_ticket_activity_08d_e`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_ticket_activity_08d_e` AS SELECT 
 1 AS `ticket_id`,
 1 AS `activity_at`,
 1 AS `activity_type`,
 1 AS `activity_code`,
 1 AS `related_record_id`,
 1 AS `actor_user_id`,
 1 AS `subject_user_id`,
 1 AS `from_status_id`,
 1 AS `to_status_id`,
 1 AS `reference_code`,
 1 AS `activity_sort_order`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_ticket_current_context`
--

DROP TABLE IF EXISTS `v_ticket_current_context`;
/*!50001 DROP VIEW IF EXISTS `v_ticket_current_context`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_ticket_current_context` AS SELECT 
 1 AS `ticket_id`,
 1 AS `ticket_number`,
 1 AS `device_id`,
 1 AS `serial_number`,
 1 AS `asset_tag`,
 1 AS `current_status_id`,
 1 AS `current_status_code`,
 1 AS `current_status_name`,
 1 AS `origin_district_id`,
 1 AS `origin_school_id`,
 1 AS `origin_student_id`,
 1 AS `requester_type`,
 1 AS `active_assignment_id`,
 1 AS `assigned_to_user_id`,
 1 AS `submitted_at`,
 1 AS `closed_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_ticket_effective_device`
--

DROP TABLE IF EXISTS `v_ticket_effective_device`;
/*!50001 DROP VIEW IF EXISTS `v_ticket_effective_device`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_ticket_effective_device` AS SELECT 
 1 AS `ticket_id`,
 1 AS `logistics_case_id`,
 1 AS `original_device_id`,
 1 AS `effective_device_id`,
 1 AS `device_source`,
 1 AS `replacement_case_id`,
 1 AS `replacement_number`,
 1 AS `temporary_loan_case_id`,
 1 AS `replacement_completed_at`,
 1 AS `exception_case_id`,
 1 AS `exception_status_code`,
 1 AS `replacement_source_type`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_ticket_operational_metrics`
--

DROP TABLE IF EXISTS `v_ticket_operational_metrics`;
/*!50001 DROP VIEW IF EXISTS `v_ticket_operational_metrics`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_ticket_operational_metrics` AS SELECT 
 1 AS `ticket_id`,
 1 AS `ticket_number`,
 1 AS `device_id`,
 1 AS `origin_district_id`,
 1 AS `origin_school_id`,
 1 AS `origin_student_id`,
 1 AS `requester_type`,
 1 AS `current_status_id`,
 1 AS `current_status_code`,
 1 AS `current_status_name`,
 1 AS `is_terminal`,
 1 AS `submitted_at`,
 1 AS `closed_at`,
 1 AS `active_assignment_id`,
 1 AS `assigned_to_user_id`,
 1 AS `assigned_at`,
 1 AS `latest_status_at`,
 1 AS `first_diagnosed_at`,
 1 AS `latest_diagnosed_at`,
 1 AS `first_approved_at`,
 1 AS `ticket_age_minutes`,
 1 AS `ticket_age_bucket`,
 1 AS `current_status_age_minutes`,
 1 AS `assignment_age_minutes`,
 1 AS `time_to_first_diagnosis_minutes`,
 1 AS `time_to_approval_minutes`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'laptop_tickets_db'
--

--
-- Current Database: `laptop_tickets_db`
--

USE `laptop_tickets_db`;

--
-- Final view structure for view `admin_security_groups`
--

/*!50001 DROP VIEW IF EXISTS `admin_security_groups`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `admin_security_groups` AS select `r`.`id` AS `id`,`r`.`name` AS `name`,`r`.`label` AS `label`,`r`.`description` AS `description`,`p`.`scope_type` AS `scope_type`,`p`.`assignable` AS `assignable`,(select count(0) from `user_roles` `ur` where (`ur`.`role_id` = `r`.`id`)) AS `user_count` from (`roles` `r` join `role_administration_profiles` `p` on((`p`.`role_id` = `r`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `admin_user_directory`
--

/*!50001 DROP VIEW IF EXISTS `admin_user_directory`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `admin_user_directory` AS select `u`.`id` AS `id`,`u`.`username` AS `username`,`u`.`email` AS `email`,`u`.`display_name` AS `display_name`,`u`.`status` AS `status`,`u`.`last_login_at` AS `last_login_at`,`u`.`password_changed_at` AS `password_changed_at`,`u`.`created_at` AS `created_at`,`u`.`updated_at` AS `updated_at`,`u`.`auth_version` AS `auth_version`,(select group_concat(`r`.`label` order by `r`.`name` ASC separator ', ') from `admin_user_roles` `r` where (`r`.`user_id` = `u`.`id`)) AS `security_groups`,(select concat('|',group_concat(`r`.`name` order by `r`.`name` ASC separator '|'),'|') from `admin_user_roles` `r` where (`r`.`user_id` = `u`.`id`)) AS `role_codes`,coalesce((select group_concat(`s`.`label` order by `s`.`scope_type` ASC,`s`.`entity_id` ASC separator '; ') from `admin_user_scopes` `s` where (`s`.`user_id` = `u`.`id`)),(case when exists(select 1 from `admin_user_roles` `r` where ((`r`.`user_id` = `u`.`id`) and (`r`.`name` = 'SUPER_ADMIN'))) then 'Global' when exists(select 1 from `admin_user_roles` `r` where ((`r`.`user_id` = `u`.`id`) and (`r`.`name` = 'TTPOST_LOGISTICS'))) then 'National logistics' else 'No assigned scope' end)) AS `scope_summary`,(select concat('|',convert(group_concat(distinct `s`.`district_id` separator '|') using utf8mb4),'|') from `admin_user_scopes` `s` where ((`s`.`user_id` = `u`.`id`) and (`s`.`district_id` is not null))) AS `district_ids` from `users` `u` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `admin_user_roles`
--

/*!50001 DROP VIEW IF EXISTS `admin_user_roles`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `admin_user_roles` AS select `ur`.`user_id` AS `user_id`,`r`.`id` AS `id`,`r`.`name` AS `name`,`r`.`label` AS `label`,`r`.`description` AS `description`,`p`.`scope_type` AS `scope_type`,`p`.`assignable` AS `assignable` from ((`user_roles` `ur` join `roles` `r` on((`r`.`id` = `ur`.`role_id`))) left join `role_administration_profiles` `p` on((`p`.`role_id` = `r`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `admin_user_scopes`
--

/*!50001 DROP VIEW IF EXISTS `admin_user_scopes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `admin_user_scopes` AS select `s`.`id` AS `id`,`s`.`user_id` AS `user_id`,'NATIONAL' AS `scope_type`,NULL AS `entity_id`,NULL AS `district_id`,'National' AS `label`,1 AS `entity_active` from `user_national_scopes` `s` where (`s`.`status` = 'active') union all select `s`.`id` AS `id`,`s`.`user_id` AS `user_id`,'DISTRICT' AS `DISTRICT`,`d`.`id` AS `id`,`d`.`id` AS `id`,`d`.`name` AS `name`,(`d`.`status` = 'active') AS `d.status='active'` from (`user_district_scopes` `s` join `districts` `d` on((`d`.`id` = `s`.`district_id`))) where (`s`.`status` = 'active') union all select `s`.`id` AS `id`,`s`.`user_id` AS `user_id`,'SCHOOL' AS `SCHOOL`,`sch`.`id` AS `id`,`sch`.`district_id` AS `district_id`,concat(`d`.`name`,' / ',`sch`.`name`) AS `CONCAT(d.name,' / ',sch.name)`,((`sch`.`status` = 'active') and (`d`.`status` = 'active')) AS `sch.status='active' AND d.status='active'` from ((`user_school_scopes` `s` join `schools` `sch` on((`sch`.`id` = `s`.`school_id`))) join `districts` `d` on((`d`.`id` = `sch`.`district_id`))) where (`s`.`status` = 'active') union all select `s`.`id` AS `id`,`s`.`user_id` AS `user_id`,'REPAIR_LOCATION' AS `REPAIR_LOCATION`,`l`.`id` AS `id`,NULL AS `NULL`,`l`.`name` AS `name`,((`l`.`is_active` = 1) and (`l`.`location_type` = 'REPAIR_CENTRE')) AS `l.is_active=1 AND l.location_type='REPAIR_CENTRE'` from (`user_service_location_scopes` `s` join `service_locations` `l` on((`l`.`id` = `s`.`service_location_id`))) where (`s`.`status` = 'active') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `user_effective_permissions`
--

/*!50001 DROP VIEW IF EXISTS `user_effective_permissions`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `user_effective_permissions` AS select distinct `ur`.`user_id` AS `user_id`,`p`.`name` AS `permission_name` from ((((`user_roles` `ur` join `roles` `r` on((`r`.`id` = `ur`.`role_id`))) join `role_permissions` `rp` on((`rp`.`role_id` = `r`.`id`))) join `permissions` `p` on((`p`.`id` = `rp`.`permission_id`))) join `users` `u` on((`u`.`id` = `ur`.`user_id`))) where (`u`.`status` = 'active') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `user_login_identities`
--

/*!50001 DROP VIEW IF EXISTS `user_login_identities`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `user_login_identities` AS select `users`.`id` AS `id`,`users`.`username` AS `login_identifier`,`users`.`password_hash` AS `password_hash` from `users` where (`users`.`status` = 'active') union select `users`.`id` AS `id`,`users`.`email` AS `login_identifier`,`users`.`password_hash` AS `password_hash` from `users` where ((`users`.`email` is not null) and (`users`.`email` <> '') and (`users`.`status` = 'active')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_device_active_primary_student_assignments`
--

/*!50001 DROP VIEW IF EXISTS `v_device_active_primary_student_assignments`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_device_active_primary_student_assignments` AS select `assignment`.`student_id` AS `student_id` from `device_student_assignments` `assignment` where ((`assignment`.`assignment_type` = 'PRIMARY') and (`assignment`.`active_record_key` = 1)) group by `assignment`.`student_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_device_current_custody`
--

/*!50001 DROP VIEW IF EXISTS `v_device_current_custody`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_device_current_custody` AS select `d`.`id` AS `device_id`,(case when (`sa`.`id` is not null) then 'STUDENT' when (`sha`.`id` is not null) then 'SCHOOL' when (`da`.`id` is not null) then 'DISTRICT' else 'CENTRAL' end) AS `current_custody_level`,`da`.`id` AS `district_allocation_id`,`da`.`district_id` AS `district_id`,`sha`.`id` AS `school_allocation_id`,`sha`.`school_id` AS `school_id`,`sa`.`id` AS `student_assignment_id`,`sa`.`student_id` AS `student_id`,`sa`.`assignment_type` AS `student_assignment_type` from (((`devices` `d` left join `device_district_allocations` `da` on(((`da`.`device_id` = `d`.`id`) and (`da`.`active_record_key` = 1)))) left join `device_school_allocations` `sha` on(((`sha`.`device_id` = `d`.`id`) and (`sha`.`district_allocation_id` = `da`.`id`) and (`sha`.`active_record_key` = 1)))) left join `device_student_assignments` `sa` on(((`sa`.`device_id` = `d`.`id`) and (`sa`.`school_allocation_id` = `sha`.`id`) and (`sa`.`active_record_key` = 1)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_device_current_stock_location`
--

/*!50001 DROP VIEW IF EXISTS `v_device_current_stock_location`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_device_current_stock_location` AS select `sl`.`id` AS `stock_location_id`,`sl`.`device_id` AS `device_id`,`sl`.`service_location_id` AS `service_location_id`,`loc`.`code` AS `service_location_code`,`loc`.`name` AS `service_location_name`,`sl`.`stock_status` AS `stock_status`,`sl`.`reason_code` AS `reason_code`,`sl`.`placed_at` AS `placed_at`,`sl`.`placed_by` AS `placed_by`,'REPAIR_CENTRE_STOCK' AS `physical_custody_code`,'Repair Centre Stock' AS `physical_custody_name`,`reservation`.`id` AS `replacement_case_id`,(case when isnull(`reservation`.`id`) then 0 else 1 end) AS `is_reserved_for_replacement` from ((`device_stock_locations` `sl` join `service_locations` `loc` on((`loc`.`id` = `sl`.`service_location_id`))) left join `permanent_replacement_cases` `reservation` on(((`reservation`.`replacement_device_id` = `sl`.`device_id`) and (`reservation`.`active_selection_key` = (convert(concat('DEVICE:',`sl`.`device_id`) using utf8mb4) collate utf8mb4_unicode_ci)) and (`reservation`.`current_status_code` in ('REPLACEMENT_SELECTED','AWAITING_ACCEPTANCE'))))) where ((`sl`.`active_record_key` = 1) and (`sl`.`stock_status` = 'IN_STOCK') and isnull(`sl`.`removed_at`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_device_stock_intake_eligibility`
--

/*!50001 DROP VIEW IF EXISTS `v_device_stock_intake_eligibility`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_device_stock_intake_eligibility` AS select `d`.`id` AS `device_id`,`d`.`serial_number` AS `serial_number`,`d`.`asset_tag` AS `asset_tag`,`m`.`name` AS `manufacturer_name`,`dm`.`model_name` AS `model_name`,`life`.`code` AS `lifecycle_code`,`allocation`.`current_custody_level` AS `allocation_level`,`allocation`.`district_id` AS `district_id`,`district`.`name` AS `district_name`,`allocation`.`school_id` AS `school_id`,`school`.`name` AS `school_name`,(case when isnull(`active_stock`.`stock_location_id`) then 0 else 1 end) AS `has_active_stock`,(case when exists(select 1 from `ticket_logistics_cases` `lc` where ((`lc`.`device_id` = `d`.`id`) and (`lc`.`active_record_key` = 1) and isnull(`lc`.`closed_at`))) then 1 else 0 end) AS `has_active_logistics`,(case when exists(select 1 from `manufacturer_return_cases` `mrc` where ((`mrc`.`original_device_id` = `d`.`id`) and (`mrc`.`active_record_key` = 1) and isnull(`mrc`.`closed_at`) and (`mrc`.`current_status_code` not in ('COMPLETED','CANCELLED')))) then 1 else 0 end) AS `has_active_manufacturer_return`,(case when exists(select 1 from (`repair_jobs` `job` join `ticket_logistics_cases` `lc` on((`lc`.`id` = `job`.`logistics_case_id`))) where ((`lc`.`device_id` = `d`.`id`) and isnull(`job`.`completed_at`))) then 1 else 0 end) AS `has_active_repair`,(case when exists(select 1 from `permanent_replacement_cases` `prc` where ((`prc`.`replacement_device_id` = `d`.`id`) and (`prc`.`current_status_code` in ('REPLACEMENT_SELECTED','AWAITING_ACCEPTANCE')))) then 1 else 0 end) AS `has_replacement_reservation`,(case when exists(select 1 from `device_replacements` `dr` where (`dr`.`replacement_device_id` = `d`.`id`)) then 1 else 0 end) AS `has_replacement_consumption` from (((((((`devices` `d` join `device_lifecycle_statuses` `life` on((`life`.`id` = `d`.`lifecycle_status_id`))) join `device_models` `dm` on((`dm`.`id` = `d`.`device_model_id`))) join `manufacturers` `m` on((`m`.`id` = `dm`.`manufacturer_id`))) join `v_device_current_custody` `allocation` on((`allocation`.`device_id` = `d`.`id`))) left join `districts` `district` on((`district`.`id` = `allocation`.`district_id`))) left join `schools` `school` on((`school`.`id` = `allocation`.`school_id`))) left join `v_device_current_stock_location` `active_stock` on((`active_stock`.`device_id` = `d`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_device_stock_queue`
--

/*!50001 DROP VIEW IF EXISTS `v_device_stock_queue`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_device_stock_queue` AS select `stock`.`stock_location_id` AS `stock_location_id`,`stock`.`device_id` AS `device_id`,`eligibility`.`serial_number` AS `serial_number`,`eligibility`.`asset_tag` AS `asset_tag`,`eligibility`.`manufacturer_name` AS `manufacturer_name`,`eligibility`.`model_name` AS `model_name`,`eligibility`.`lifecycle_code` AS `lifecycle_code`,`eligibility`.`allocation_level` AS `allocation_level`,`eligibility`.`district_id` AS `district_id`,`district`.`name` AS `district_name`,`eligibility`.`school_id` AS `school_id`,`school`.`name` AS `school_name`,`stock`.`service_location_id` AS `service_location_id`,`stock`.`service_location_code` AS `service_location_code`,`stock`.`service_location_name` AS `service_location_name`,`stock`.`stock_status` AS `stock_status`,`stock`.`physical_custody_code` AS `physical_custody_code`,`stock`.`physical_custody_name` AS `physical_custody_name`,`stock`.`placed_at` AS `placed_at`,`stock`.`placed_by` AS `placed_by`,`stock`.`is_reserved_for_replacement` AS `is_reserved_for_replacement`,`stock`.`replacement_case_id` AS `replacement_case_id`,`eligibility`.`has_active_logistics` AS `has_active_logistics`,`eligibility`.`has_active_manufacturer_return` AS `has_active_manufacturer_return`,`eligibility`.`has_active_repair` AS `has_active_repair` from (((`v_device_current_stock_location` `stock` join `v_device_stock_intake_eligibility` `eligibility` on((`eligibility`.`device_id` = `stock`.`device_id`))) left join `districts` `district` on((`district`.`id` = `eligibility`.`district_id`))) left join `schools` `school` on((`school`.`id` = `eligibility`.`school_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_escalation_case_targets`
--

/*!50001 DROP VIEW IF EXISTS `v_escalation_case_targets`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_escalation_case_targets` AS select `a`.`escalation_case_id` AS `escalation_case_id`,`a`.`id` AS `assignment_id`,`a`.`level_snapshot` AS `level_snapshot`,`a`.`trigger_snapshot` AS `trigger_snapshot`,`a`.`target_role_id` AS `target_role_id`,`a`.`target_role_name_snapshot` AS `target_role_name_snapshot`,`a`.`reason_snapshot` AS `reason_snapshot`,`a`.`assigned_at` AS `assigned_at`,`a`.`assigned_by` AS `assigned_by`,`ec`.`current_state_code` AS `current_state_code`,`ec`.`current_level` AS `current_level`,`ec`.`district_id` AS `district_id`,`ec`.`school_id` AS `school_id`,`ec`.`repair_centre_location_id` AS `repair_centre_location_id` from (`escalation_assignments` `a` join `escalation_cases` `ec` on((`ec`.`id` = `a`.`escalation_case_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_escalation_operational_queue`
--

/*!50001 DROP VIEW IF EXISTS `v_escalation_operational_queue`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_escalation_operational_queue` AS select `ec`.`id` AS `escalation_case_id`,`ec`.`escalation_number` AS `escalation_number`,`ec`.`sla_instance_id` AS `sla_instance_id`,`ec`.`policy_code_snapshot` AS `policy_code_snapshot`,`ec`.`ticket_id` AS `ticket_id`,`t`.`ticket_number` AS `ticket_number`,`ec`.`logistics_case_id` AS `logistics_case_id`,`lc`.`logistics_number` AS `logistics_number`,`ec`.`repair_job_id` AS `repair_job_id`,`ec`.`district_id` AS `district_id`,`d`.`name` AS `district_name`,`ec`.`school_id` AS `school_id`,`s`.`name` AS `school_name`,`ec`.`repair_centre_location_id` AS `repair_centre_location_id`,`loc`.`name` AS `repair_centre_name`,`ec`.`current_level` AS `current_level`,`ec`.`current_trigger` AS `current_trigger`,`ec`.`current_state_code` AS `current_state_code`,`es`.`name` AS `current_state_name`,`ec`.`reason_snapshot` AS `reason_snapshot`,`ec`.`opened_at` AS `opened_at`,`ec`.`acknowledged_at` AS `acknowledged_at`,date_format(`ec`.`opened_at`,'%b %e, %Y %l:%i %p') AS `opened_at_display`,date_format(`ec`.`acknowledged_at`,'%b %e, %Y %l:%i %p') AS `acknowledged_at_display`,`ec`.`acknowledged_by` AS `acknowledged_by`,`au`.`display_name` AS `acknowledged_by_name`,`ec`.`acknowledgement_note` AS `acknowledgement_note`,`ec`.`resolved_at` AS `resolved_at`,`ec`.`cancelled_at` AS `cancelled_at`,date_format(`ec`.`resolved_at`,'%b %e, %Y %l:%i %p') AS `resolved_at_display`,date_format(`ec`.`cancelled_at`,'%b %e, %Y %l:%i %p') AS `cancelled_at_display`,`i`.`current_state_code` AS `sla_state_code`,`ist`.`name` AS `sla_state_name`,`i`.`started_at` AS `sla_started_at`,`i`.`due_at` AS `sla_due_at`,`i`.`at_risk_at` AS `sla_at_risk_at`,`i`.`breached_at` AS `sla_breached_at`,`i`.`completed_at` AS `sla_completed_at`,`i`.`cancelled_at` AS `sla_cancelled_at`,date_format(`i`.`started_at`,'%b %e, %Y %l:%i %p') AS `sla_started_at_display`,date_format(`i`.`due_at`,'%b %e, %Y %l:%i %p') AS `sla_due_at_display`,group_concat(distinct concat(`a`.`target_role_name_snapshot`,'|',`a`.`level_snapshot`) order by `a`.`level_snapshot` ASC separator ',') AS `responsible_roles` from ((((((((((`escalation_cases` `ec` join `tickets` `t` on((`t`.`id` = `ec`.`ticket_id`))) join `escalation_states` `es` on((`es`.`code` = `ec`.`current_state_code`))) join `sla_instances` `i` on((`i`.`id` = `ec`.`sla_instance_id`))) join `sla_instance_states` `ist` on((`ist`.`code` = `i`.`current_state_code`))) left join `ticket_logistics_cases` `lc` on((`lc`.`id` = `ec`.`logistics_case_id`))) left join `districts` `d` on((`d`.`id` = `ec`.`district_id`))) left join `schools` `s` on((`s`.`id` = `ec`.`school_id`))) left join `service_locations` `loc` on((`loc`.`id` = `ec`.`repair_centre_location_id`))) left join `users` `au` on((`au`.`id` = `ec`.`acknowledged_by`))) left join `escalation_assignments` `a` on((`a`.`escalation_case_id` = `ec`.`id`))) group by `ec`.`id`,`ec`.`escalation_number`,`ec`.`sla_instance_id`,`ec`.`policy_code_snapshot`,`ec`.`ticket_id`,`t`.`ticket_number`,`ec`.`logistics_case_id`,`lc`.`logistics_number`,`ec`.`repair_job_id`,`ec`.`district_id`,`d`.`name`,`ec`.`school_id`,`s`.`name`,`ec`.`repair_centre_location_id`,`loc`.`name`,`ec`.`current_level`,`ec`.`current_trigger`,`ec`.`current_state_code`,`es`.`name`,`ec`.`reason_snapshot`,`ec`.`opened_at`,`ec`.`acknowledged_at`,`ec`.`acknowledged_by`,`au`.`display_name`,`ec`.`acknowledgement_note`,`ec`.`resolved_at`,`ec`.`cancelled_at`,`i`.`current_state_code`,`ist`.`name`,`i`.`started_at`,`i`.`due_at`,`i`.`at_risk_at`,`i`.`breached_at`,`i`.`completed_at`,`i`.`cancelled_at` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_logistics_case_detail_context`
--

/*!50001 DROP VIEW IF EXISTS `v_logistics_case_detail_context`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_logistics_case_detail_context` AS select `c`.`id` AS `logistics_case_id`,`c`.`logistics_number` AS `logistics_number`,`c`.`ticket_id` AS `ticket_id`,`t`.`ticket_number` AS `ticket_number`,`effective`.`effective_device_id` AS `device_id`,`effective`.`original_device_id` AS `original_device_id`,`effective`.`device_source` AS `device_source`,`effective`.`replacement_case_id` AS `replacement_case_id`,`effective`.`replacement_number` AS `replacement_number`,`effective`.`temporary_loan_case_id` AS `temporary_loan_case_id`,`d`.`serial_number` AS `serial_number`,`d`.`asset_tag` AS `asset_tag`,`original`.`serial_number` AS `original_serial_number`,`original`.`asset_tag` AS `original_asset_tag`,`c`.`pickup_school_id` AS `pickup_school_id`,`s`.`name` AS `pickup_school_name`,`s`.`district_id` AS `pickup_district_id`,`district`.`name` AS `pickup_district_name`,`c`.`repair_centre_location_id` AS `repair_centre_location_id`,`repair_location`.`name` AS `repair_centre_name`,`c`.`current_status_id` AS `current_logistics_status_id`,`ls`.`code` AS `current_logistics_status_code`,`ls`.`name` AS `current_logistics_status_name`,`c`.`requested_at` AS `requested_at`,`c`.`closed_at` AS `closed_at`,`c`.`active_record_key` AS `active_record_key`,((`c`.`active_record_key` = 1) and isnull(`c`.`closed_at`)) AS `is_active`,(case when (`ls`.`code` = 'RETURNED_TO_SCHOOL') then 'RETURNED_TO_SCHOOL' else NULL end) AS `returned_physical_state_code`,`t`.`current_status_id` AS `ticket_current_status_id`,`ts`.`code` AS `ticket_current_status_code`,`allocation`.`current_custody_level` AS `allocation_custody_level`,`allocation`.`district_id` AS `allocation_district_id`,`allocation`.`school_id` AS `allocation_school_id`,`allocation_school`.`name` AS `allocation_school_name`,`allocation`.`student_id` AS `allocation_student_id`,`lifecycle`.`code` AS `device_lifecycle_code`,`lifecycle`.`name` AS `device_lifecycle_name` from ((((((((((((`ticket_logistics_cases` `c` join `tickets` `t` on((`t`.`id` = `c`.`ticket_id`))) join `v_ticket_effective_device` `effective` on((`effective`.`logistics_case_id` = `c`.`id`))) join `devices` `d` on((`d`.`id` = `effective`.`effective_device_id`))) join `devices` `original` on((`original`.`id` = `effective`.`original_device_id`))) join `device_lifecycle_statuses` `lifecycle` on((`lifecycle`.`id` = `d`.`lifecycle_status_id`))) join `schools` `s` on((`s`.`id` = `c`.`pickup_school_id`))) join `districts` `district` on((`district`.`id` = `s`.`district_id`))) join `logistics_statuses` `ls` on((`ls`.`id` = `c`.`current_status_id`))) join `ticket_statuses` `ts` on((`ts`.`id` = `t`.`current_status_id`))) left join `service_locations` `repair_location` on((`repair_location`.`id` = `c`.`repair_centre_location_id`))) left join `v_device_current_custody` `allocation` on((`allocation`.`device_id` = `effective`.`effective_device_id`))) left join `schools` `allocation_school` on((`allocation_school`.`id` = `allocation`.`school_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_logistics_current_context`
--

/*!50001 DROP VIEW IF EXISTS `v_logistics_current_context`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_logistics_current_context` AS select `lc`.`id` AS `logistics_case_id`,`lc`.`logistics_number` AS `logistics_number`,`t`.`id` AS `ticket_id`,`t`.`ticket_number` AS `ticket_number`,`d`.`id` AS `device_id`,`d`.`serial_number` AS `serial_number`,`d`.`asset_tag` AS `asset_tag`,`effective`.`original_device_id` AS `original_device_id`,`effective`.`device_source` AS `device_source`,`effective`.`replacement_case_id` AS `replacement_case_id`,`effective`.`replacement_number` AS `replacement_number`,`effective`.`temporary_loan_case_id` AS `temporary_loan_case_id`,`lc`.`pickup_school_id` AS `pickup_school_id`,`pickup_school`.`name` AS `pickup_school_name`,`pickup_school`.`district_id` AS `pickup_district_id`,`pickup_district`.`name` AS `pickup_district_name`,`lc`.`repair_centre_location_id` AS `repair_centre_location_id`,`repair_location`.`name` AS `repair_centre_name`,`lc`.`current_status_id` AS `current_logistics_status_id`,`logistics_status`.`code` AS `current_logistics_status_code`,`logistics_status`.`name` AS `current_logistics_status_name`,`lc`.`requested_at` AS `requested_at`,`lc`.`closed_at` AS `closed_at`,`lc`.`active_record_key` AS `active_record_key`,((`lc`.`active_record_key` = 1) and isnull(`lc`.`closed_at`)) AS `is_active`,`pending_handoff`.`id` AS `pending_handoff_id`,`pending_handoff`.`handoff_type` AS `pending_handoff_type`,`pending_handoff`.`dispatched_at` AS `pending_handoff_dispatched_at`,`t`.`current_status_id` AS `ticket_current_status_id`,`ticket_status`.`code` AS `ticket_current_status_code`,`allocation`.`current_custody_level` AS `allocation_custody_level`,`allocation`.`district_id` AS `allocation_district_id`,`allocation`.`school_id` AS `allocation_school_id`,`allocation`.`student_id` AS `allocation_student_id` from ((((((((((`ticket_logistics_cases` `lc` join `tickets` `t` on((`t`.`id` = `lc`.`ticket_id`))) join `v_ticket_effective_device` `effective` on((`effective`.`logistics_case_id` = `lc`.`id`))) join `devices` `d` on((`d`.`id` = `effective`.`effective_device_id`))) join `schools` `pickup_school` on((`pickup_school`.`id` = `lc`.`pickup_school_id`))) join `districts` `pickup_district` on((`pickup_district`.`id` = `pickup_school`.`district_id`))) left join `service_locations` `repair_location` on((`repair_location`.`id` = `lc`.`repair_centre_location_id`))) join `logistics_statuses` `logistics_status` on((`logistics_status`.`id` = `lc`.`current_status_id`))) join `ticket_statuses` `ticket_status` on((`ticket_status`.`id` = `t`.`current_status_id`))) left join `logistics_handoffs` `pending_handoff` on(((`pending_handoff`.`logistics_case_id` = `lc`.`id`) and (`pending_handoff`.`active_record_key` = 1)))) left join `v_device_current_custody` `allocation` on((`allocation`.`device_id` = `effective`.`effective_device_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_logistics_physical_custody`
--

/*!50001 DROP VIEW IF EXISTS `v_logistics_physical_custody`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_logistics_physical_custody` AS select `c`.`id` AS `logistics_case_id`,`c`.`logistics_number` AS `logistics_number`,`c`.`ticket_id` AS `ticket_id`,`effective`.`original_device_id` AS `original_device_id`,`effective`.`effective_device_id` AS `device_id`,`effective`.`device_source` AS `device_source`,`effective`.`replacement_case_id` AS `replacement_case_id`,`effective`.`replacement_number` AS `replacement_number`,`effective`.`temporary_loan_case_id` AS `temporary_loan_case_id`,`c`.`current_status_id` AS `logistics_status_id`,`ls`.`code` AS `logistics_status_code`,`t`.`current_status_id` AS `ticket_status_id`,`ts`.`code` AS `ticket_status_code`,(case when ((`ls`.`code` = 'FULFILLED_AT_RECIPIENT') and (`effective`.`device_source` = 'TEMPORARY_LOAN_CONVERSION')) then 'WITH_RECIPIENT' when ((`ls`.`code` = 'ACCEPTED') and (`pending`.`handoff_type` = 'SCHOOL_TO_TTPOST')) then 'PENDING_TTPOST_RECEIPT' when (`ls`.`code` = 'ACCEPTED') then 'AWAITING_SCHOOL_HANDOFF' when ((`ls`.`code` = 'OUTBOUND_IN_TRANSIT') and (`pending`.`handoff_type` = 'TTPOST_TO_REPAIR_CENTRE')) then 'PENDING_REPAIR_CENTRE_RECEIPT' when ((`ls`.`code` = 'OUTBOUND_IN_TRANSIT') and (`completed`.`handoff_type` = 'SCHOOL_TO_TTPOST')) then 'TTPOST_CUSTODY' when ((`ls`.`code` in ('AT_REPAIR_CENTRE','READY_FOR_RETURN')) and (`pending`.`handoff_type` = 'REPAIR_CENTRE_TO_TTPOST')) then 'PENDING_TTPOST_RETURN_RECEIPT' when ((`ls`.`code` in ('AT_REPAIR_CENTRE','READY_FOR_RETURN')) and (`completed`.`handoff_type` = 'TTPOST_TO_REPAIR_CENTRE')) then 'REPAIR_CENTRE_CUSTODY' when ((`ls`.`code` = 'RETURN_IN_TRANSIT') and (`pending`.`handoff_type` = 'TTPOST_TO_SCHOOL')) then 'PENDING_SCHOOL_RETURN_RECEIPT' when ((`ls`.`code` = 'RETURN_IN_TRANSIT') and (`completed`.`handoff_type` = 'REPAIR_CENTRE_TO_TTPOST')) then 'TTPOST_RETURN_CUSTODY' else NULL end) AS `physical_state_code`,(case when ((`ls`.`code` = 'OUTBOUND_IN_TRANSIT') and (`completed`.`handoff_type` = 'SCHOOL_TO_TTPOST')) then `completed`.`to_service_location_id` when ((`ls`.`code` in ('AT_REPAIR_CENTRE','READY_FOR_RETURN')) and (`completed`.`handoff_type` = 'TTPOST_TO_REPAIR_CENTRE')) then `completed`.`to_service_location_id` when ((`ls`.`code` = 'RETURN_IN_TRANSIT') and (`completed`.`handoff_type` = 'REPAIR_CENTRE_TO_TTPOST')) then `completed`.`to_service_location_id` else NULL end) AS `current_service_location_id`,(case when ((`ls`.`code` = 'OUTBOUND_IN_TRANSIT') and (`completed`.`handoff_type` = 'SCHOOL_TO_TTPOST')) then `completed_location`.`code` when ((`ls`.`code` in ('AT_REPAIR_CENTRE','READY_FOR_RETURN')) and (`completed`.`handoff_type` = 'TTPOST_TO_REPAIR_CENTRE')) then `completed_location`.`code` when ((`ls`.`code` = 'RETURN_IN_TRANSIT') and (`completed`.`handoff_type` = 'REPAIR_CENTRE_TO_TTPOST')) then `completed_location`.`code` else NULL end) AS `current_service_location_code`,(case when ((`ls`.`code` = 'OUTBOUND_IN_TRANSIT') and (`completed`.`handoff_type` = 'SCHOOL_TO_TTPOST')) then `completed_location`.`name` when ((`ls`.`code` in ('AT_REPAIR_CENTRE','READY_FOR_RETURN')) and (`completed`.`handoff_type` = 'TTPOST_TO_REPAIR_CENTRE')) then `completed_location`.`name` when ((`ls`.`code` = 'RETURN_IN_TRANSIT') and (`completed`.`handoff_type` = 'REPAIR_CENTRE_TO_TTPOST')) then `completed_location`.`name` else NULL end) AS `current_service_location_name`,`pending`.`id` AS `pending_handoff_id`,`pending`.`handoff_type` AS `pending_handoff_type`,`pending`.`device_id` AS `pending_handoff_device_id`,`pending`.`dispatched_at` AS `pending_since`,`pending`.`dispatched_by_user_id` AS `handoff_dispatched_by_user_id`,`completed`.`id` AS `last_completed_handoff_id`,`completed`.`handoff_type` AS `last_completed_handoff_type`,`completed`.`device_id` AS `last_completed_handoff_device_id`,`completed`.`received_at` AS `last_handoff_received_at`,`completed`.`received_by_user_id` AS `handoff_received_by_user_id`,(case when (`pending`.`handoff_type` = 'SCHOOL_TO_TTPOST') then `pending`.`to_service_location_id` when (`completed`.`handoff_type` = 'SCHOOL_TO_TTPOST') then `completed`.`to_service_location_id` when ((`ls`.`code` = 'RETURN_IN_TRANSIT') and (`pending`.`handoff_type` = 'TTPOST_TO_SCHOOL')) then `pending`.`from_service_location_id` when ((`ls`.`code` = 'RETURN_IN_TRANSIT') and (`completed`.`handoff_type` = 'REPAIR_CENTRE_TO_TTPOST')) then `completed`.`to_service_location_id` else NULL end) AS `ttpost_location_id`,(case when (`pending`.`handoff_type` = 'SCHOOL_TO_TTPOST') then `pending_location`.`code` when (`completed`.`handoff_type` = 'SCHOOL_TO_TTPOST') then `completed_location`.`code` when ((`ls`.`code` = 'RETURN_IN_TRANSIT') and (`pending`.`handoff_type` = 'TTPOST_TO_SCHOOL')) then `pending_from_location`.`code` when ((`ls`.`code` = 'RETURN_IN_TRANSIT') and (`completed`.`handoff_type` = 'REPAIR_CENTRE_TO_TTPOST')) then `completed_location`.`code` else NULL end) AS `ttpost_location_code`,(case when (`pending`.`handoff_type` = 'SCHOOL_TO_TTPOST') then `pending_location`.`name` when (`completed`.`handoff_type` = 'SCHOOL_TO_TTPOST') then `completed_location`.`name` when ((`ls`.`code` = 'RETURN_IN_TRANSIT') and (`pending`.`handoff_type` = 'TTPOST_TO_SCHOOL')) then `pending_from_location`.`name` when ((`ls`.`code` = 'RETURN_IN_TRANSIT') and (`completed`.`handoff_type` = 'REPAIR_CENTRE_TO_TTPOST')) then `completed_location`.`name` else NULL end) AS `ttpost_location_name`,coalesce(`pending_repair`.`to_service_location_id`,`c`.`repair_centre_location_id`) AS `repair_centre_location_id`,`repair_location`.`code` AS `repair_centre_location_code`,`repair_location`.`name` AS `repair_centre_location_name`,`pending_repair`.`id` AS `pending_repair_handoff_id`,`allocation`.`current_custody_level` AS `allocation_custody_level`,`allocation`.`district_id` AS `allocation_district_id`,`allocation`.`school_id` AS `allocation_school_id`,`allocation_school`.`name` AS `allocation_school_name`,`allocation`.`student_id` AS `allocation_student_id`,`lifecycle`.`code` AS `device_lifecycle_code` from ((((((((((((((((`laptop_tickets_db`.`ticket_logistics_cases` `c` join `laptop_tickets_db`.`tickets` `t` on((`t`.`id` = `c`.`ticket_id`))) join `laptop_tickets_db`.`logistics_statuses` `ls` on((`ls`.`id` = `c`.`current_status_id`))) join `laptop_tickets_db`.`ticket_statuses` `ts` on((`ts`.`id` = `t`.`current_status_id`))) join `laptop_tickets_db`.`v_ticket_effective_device` `effective` on((`effective`.`logistics_case_id` = `c`.`id`))) join `laptop_tickets_db`.`devices` `d` on((`d`.`id` = `effective`.`effective_device_id`))) join `laptop_tickets_db`.`device_lifecycle_statuses` `lifecycle` on((`lifecycle`.`id` = `d`.`lifecycle_status_id`))) left join `laptop_tickets_db`.`logistics_handoffs` `pending` on(((`pending`.`logistics_case_id` = `c`.`id`) and (`pending`.`active_record_key` = 1) and isnull(`pending`.`received_at`)))) left join `laptop_tickets_db`.`logistics_handoffs` `pending_repair` on(((`pending_repair`.`logistics_case_id` = `c`.`id`) and (`pending_repair`.`handoff_type` = 'TTPOST_TO_REPAIR_CENTRE') and (`pending_repair`.`active_record_key` = 1) and isnull(`pending_repair`.`received_at`)))) left join (select `h`.`logistics_case_id` AS `logistics_case_id`,max(`h`.`id`) AS `id` from `laptop_tickets_db`.`logistics_handoffs` `h` where (`h`.`received_at` is not null) group by `h`.`logistics_case_id`) `completed_id` on((`completed_id`.`logistics_case_id` = `c`.`id`))) left join `laptop_tickets_db`.`logistics_handoffs` `completed` on((`completed`.`id` = `completed_id`.`id`))) left join `laptop_tickets_db`.`service_locations` `pending_location` on((`pending_location`.`id` = `pending`.`to_service_location_id`))) left join `laptop_tickets_db`.`service_locations` `pending_from_location` on((`pending_from_location`.`id` = `pending`.`from_service_location_id`))) left join `laptop_tickets_db`.`service_locations` `completed_location` on((`completed_location`.`id` = `completed`.`to_service_location_id`))) left join `laptop_tickets_db`.`service_locations` `repair_location` on((`repair_location`.`id` = coalesce(`pending_repair`.`to_service_location_id`,`c`.`repair_centre_location_id`)))) left join `laptop_tickets_db`.`v_device_current_custody` `allocation` on((`allocation`.`device_id` = `effective`.`effective_device_id`))) left join `laptop_tickets_db`.`schools` `allocation_school` on((`allocation_school`.`id` = `allocation`.`school_id`))) where ((`c`.`active_record_key` = 1) and (isnull(`c`.`closed_at`) or ((`ls`.`code` = 'FULFILLED_AT_RECIPIENT') and (`effective`.`device_source` = 'TEMPORARY_LOAN_CONVERSION')))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_logistics_return_device`
--

/*!50001 DROP VIEW IF EXISTS `v_logistics_return_device`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_logistics_return_device` AS select `e`.`logistics_case_id` AS `logistics_case_id`,`e`.`original_device_id` AS `original_device_id`,`e`.`effective_device_id` AS `return_device_id`,`e`.`replacement_case_id` AS `completed_replacement_case_id`,(case when (`e`.`replacement_case_id` is not null) then coalesce(`pc`.`physical_state_code`,(case when (`ls`.`code` = 'RETURNED_TO_SCHOOL') then 'RETURNED_TO_SCHOOL' else 'REPAIR_CENTRE_RETURN_RECEIVED' end)) else NULL end) AS `replacement_physical_custody_code`,(case when ((`e`.`replacement_case_id` is not null) and (`mpc`.`physical_custody_code` = 'MANUFACTURER_RETAINED_PENDING_REPLACEMENT')) then 'MANUFACTURER_RETAINED_REPLACED' when (`e`.`replacement_case_id` is not null) then 'REPAIR_CENTRE_REPLACED_PENDING_DISPOSITION' else NULL end) AS `original_replacement_physical_custody_code` from (((((`laptop_tickets_db`.`v_ticket_effective_device` `e` join `laptop_tickets_db`.`ticket_logistics_cases` `lc` on((`lc`.`id` = `e`.`logistics_case_id`))) join `laptop_tickets_db`.`logistics_statuses` `ls` on((`ls`.`id` = `lc`.`current_status_id`))) left join `laptop_tickets_db`.`v_logistics_physical_custody` `pc` on((`pc`.`logistics_case_id` = `e`.`logistics_case_id`))) left join `laptop_tickets_db`.`manufacturer_return_cases` `mrc` on((`mrc`.`id` = (select max(`m`.`id`) from `laptop_tickets_db`.`manufacturer_return_cases` `m` where ((`m`.`exception_case_id` = `e`.`exception_case_id`) and (`e`.`replacement_source_type` = 'MANUFACTURER_SUPPLIED')))))) left join `laptop_tickets_db`.`v_manufacturer_return_physical_custody` `mpc` on((`mpc`.`manufacturer_return_case_id` = `mrc`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_manufacturer_return_physical_custody`
--

/*!50001 DROP VIEW IF EXISTS `v_manufacturer_return_physical_custody`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_manufacturer_return_physical_custody` AS select `c`.`id` AS `manufacturer_return_case_id`,`c`.`ticket_id` AS `ticket_id`,`c`.`original_device_id` AS `original_device_id`,`c`.`repair_centre_location_id` AS `repair_centre_location_id`,`c`.`current_status_code` AS `manufacturer_return_status_code`,`outc`.`outcome_code` AS `current_outcome_code`,`outbound`.`carrier_id` AS `outbound_carrier_id`,`outbound`.`carrier_type` AS `outbound_carrier_type`,`returned`.`carrier_id` AS `return_carrier_id`,`returned`.`carrier_type` AS `return_carrier_type`,(case when (`c`.`current_status_code` = 'PREPARATION_REQUIRED') then 'REPAIR_CENTRE_MANUFACTURER_PREPARATION' when (`c`.`current_status_code` = 'AWAITING_OUTBOUND_CARRIER_PICKUP') then 'PENDING_OUTBOUND_CARRIER_PICKUP' when ((`c`.`current_status_code` = 'OUTBOUND_IN_TRANSIT') and (`outbound`.`carrier_type` = 'TTPOST')) then 'TTPOST_MANUFACTURER_OUTBOUND_CUSTODY' when (`c`.`current_status_code` = 'OUTBOUND_IN_TRANSIT') then 'EXTERNAL_COURIER_OUTBOUND_CUSTODY' when ((`c`.`current_status_code` = 'AT_MANUFACTURER') and isnull(`outc`.`outcome_code`)) then 'MANUFACTURER_CUSTODY' when (`c`.`current_status_code` = 'AT_MANUFACTURER') then 'MANUFACTURER_CUSTODY' when (`c`.`current_status_code` = 'AWAITING_RETURN_CARRIER_PICKUP') then 'PENDING_RETURN_CARRIER_PICKUP' when ((`c`.`current_status_code` = 'RETURN_IN_TRANSIT') and (`returned`.`carrier_type` = 'TTPOST')) then 'TTPOST_MANUFACTURER_RETURN_CUSTODY' when (`c`.`current_status_code` = 'RETURN_IN_TRANSIT') then 'EXTERNAL_COURIER_RETURN_CUSTODY' when ((`c`.`current_status_code` = 'COMPLETED') and (`outc`.`outcome_code` = 'REPLACEMENT_SUPPLIED')) then 'MANUFACTURER_RETAINED_PENDING_REPLACEMENT' when (`c`.`current_status_code` = 'COMPLETED') then 'REPAIR_CENTRE_RETURN_RECEIVED' else 'UNKNOWN' end) AS `physical_custody_code`,(case when ((`outbound`.`carrier_type` = 'TTPOST') or (`returned`.`carrier_type` = 'TTPOST')) then 1 else 0 end) AS `has_ttpost_participation` from (((`laptop_tickets_db`.`manufacturer_return_cases` `c` left join (select `o`.`manufacturer_return_case_id` AS `manufacturer_return_case_id`,`o`.`outcome_code` AS `outcome_code` from (`laptop_tickets_db`.`manufacturer_return_outcomes` `o` join (select `laptop_tickets_db`.`manufacturer_return_outcomes`.`manufacturer_return_case_id` AS `manufacturer_return_case_id`,max(`laptop_tickets_db`.`manufacturer_return_outcomes`.`id`) AS `latest_id` from `laptop_tickets_db`.`manufacturer_return_outcomes` group by `laptop_tickets_db`.`manufacturer_return_outcomes`.`manufacturer_return_case_id`) `latest` on((`latest`.`latest_id` = `o`.`id`)))) `outc` on((`outc`.`manufacturer_return_case_id` = `c`.`id`))) left join (select `s`.`manufacturer_return_case_id` AS `manufacturer_return_case_id`,`s`.`carrier_id` AS `carrier_id`,`cr`.`carrier_type` AS `carrier_type` from (`laptop_tickets_db`.`manufacturer_return_shipments` `s` join `laptop_tickets_db`.`carriers` `cr` on((`cr`.`id` = `s`.`carrier_id`))) where (`s`.`direction` = 'OUTBOUND')) `outbound` on((`outbound`.`manufacturer_return_case_id` = `c`.`id`))) left join (select `s`.`manufacturer_return_case_id` AS `manufacturer_return_case_id`,`s`.`carrier_id` AS `carrier_id`,`cr`.`carrier_type` AS `carrier_type` from (`laptop_tickets_db`.`manufacturer_return_shipments` `s` join `laptop_tickets_db`.`carriers` `cr` on((`cr`.`id` = `s`.`carrier_id`))) where (`s`.`direction` = 'RETURN')) `returned` on((`returned`.`manufacturer_return_case_id` = `c`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_manufacturer_return_queue`
--

/*!50001 DROP VIEW IF EXISTS `v_manufacturer_return_queue`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_manufacturer_return_queue` AS select `c`.`id` AS `manufacturer_return_case_id`,`c`.`manufacturer_return_number` AS `manufacturer_return_number`,`c`.`ticket_id` AS `ticket_id`,`t`.`ticket_number` AS `ticket_number`,`lc`.`logistics_number` AS `logistics_number`,`ls`.`code` AS `logistics_status_code`,`ls`.`name` AS `logistics_status_name`,`lp`.`physical_state_code` AS `phase7_physical_state_code`,`c`.`original_device_id` AS `original_device_id`,`d`.`serial_number` AS `serial_number`,`d`.`asset_tag` AS `asset_tag`,`c`.`manufacturer_id` AS `manufacturer_id`,`m`.`name` AS `manufacturer_name`,`c`.`repair_centre_location_id` AS `repair_centre_location_id`,`loc`.`name` AS `repair_centre_name`,`t`.`origin_school_id` AS `origin_school_id`,`school`.`name` AS `origin_school_name`,`t`.`origin_district_id` AS `origin_district_id`,`dist`.`name` AS `origin_district_name`,`c`.`current_status_code` AS `manufacturer_return_status_code`,`ms`.`name` AS `manufacturer_return_status_name`,`ec`.`current_status_code` AS `exception_status_code`,`es`.`name` AS `exception_status_name`,`pc`.`outbound_carrier_id` AS `outbound_carrier_id`,`oc`.`name` AS `outbound_carrier_name`,`pc`.`outbound_carrier_type` AS `outbound_carrier_type`,`pc`.`return_carrier_id` AS `return_carrier_id`,`rc`.`name` AS `return_carrier_name`,`pc`.`return_carrier_type` AS `return_carrier_type`,`pc`.`current_outcome_code` AS `current_outcome_code`,(case `pc`.`current_outcome_code` when 'REPAIRED_ORIGINAL' then 'Repaired Original' when 'REPLACEMENT_SUPPLIED' then 'Replacement Supplied' when 'WARRANTY_REJECTED' then 'Warranty Rejected' when 'BEYOND_ECONOMICAL_REPAIR' then 'Beyond Economical Repair' else NULL end) AS `current_outcome_name`,`c`.`started_at` AS `started_at`,`c`.`updated_at` AS `updated_at`,`c`.`closed_at` AS `closed_at`,`pc`.`physical_custody_code` AS `physical_custody_code`,`pc`.`has_ttpost_participation` AS `has_ttpost_participation` from (((((((((((((((`laptop_tickets_db`.`manufacturer_return_cases` `c` join `laptop_tickets_db`.`v_manufacturer_return_physical_custody` `pc` on((`pc`.`manufacturer_return_case_id` = `c`.`id`))) join `laptop_tickets_db`.`ticket_logistics_cases` `lc` on((`lc`.`id` = `c`.`logistics_case_id`))) join `laptop_tickets_db`.`logistics_statuses` `ls` on((`ls`.`id` = `lc`.`current_status_id`))) left join `laptop_tickets_db`.`v_logistics_physical_custody` `lp` on((`lp`.`logistics_case_id` = `lc`.`id`))) join `laptop_tickets_db`.`tickets` `t` on((`t`.`id` = `c`.`ticket_id`))) join `laptop_tickets_db`.`devices` `d` on((`d`.`id` = `c`.`original_device_id`))) join `laptop_tickets_db`.`manufacturers` `m` on((`m`.`id` = `c`.`manufacturer_id`))) left join `laptop_tickets_db`.`service_locations` `loc` on((`loc`.`id` = `c`.`repair_centre_location_id`))) left join `laptop_tickets_db`.`schools` `school` on((`school`.`id` = `t`.`origin_school_id`))) left join `laptop_tickets_db`.`districts` `dist` on((`dist`.`id` = `t`.`origin_district_id`))) join `laptop_tickets_db`.`manufacturer_return_statuses` `ms` on((`ms`.`code` = `c`.`current_status_code`))) join `laptop_tickets_db`.`repair_exception_cases` `ec` on((`ec`.`id` = `c`.`exception_case_id`))) left join `laptop_tickets_db`.`exception_case_statuses` `es` on((`es`.`code` = `ec`.`current_status_code`))) left join `laptop_tickets_db`.`carriers` `oc` on((`oc`.`id` = `pc`.`outbound_carrier_id`))) left join `laptop_tickets_db`.`carriers` `rc` on((`rc`.`id` = `pc`.`return_carrier_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_notification_inbox`
--

/*!50001 DROP VIEW IF EXISTS `v_notification_inbox`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_notification_inbox` AS select `nr`.`id` AS `recipient_id`,`nr`.`notification_event_id` AS `notification_event_id`,`nr`.`user_id` AS `user_id`,`nr`.`recipient_role_code` AS `recipient_role_code`,`nr`.`delivered_in_app_at` AS `delivered_in_app_at`,`nr`.`read_at` AS `read_at`,`nr`.`read_by` AS `read_by`,`nr`.`archived_at` AS `archived_at`,if(isnull(`nr`.`read_at`),0,1) AS `read_state`,`e`.`idempotency_key` AS `idempotency_key`,`e`.`event_type_code` AS `event_type_code`,`et`.`name` AS `event_type_name`,`e`.`source_type` AS `source_type`,`e`.`source_id` AS `source_id`,`e`.`ticket_id` AS `ticket_id`,`t`.`ticket_number` AS `ticket_number`,`t`.`origin_school_id` AS `origin_school_id`,`school`.`name` AS `school_name`,`t`.`origin_district_id` AS `origin_district_id`,`district`.`name` AS `district_name`,`device`.`serial_number` AS `serial_number`,`device`.`asset_tag` AS `asset_tag`,`e`.`sla_instance_id` AS `sla_instance_id`,coalesce(`ec`.`policy_code_snapshot`,`si`.`policy_code_snapshot`) AS `sla_policy_code`,`e`.`escalation_case_id` AS `escalation_case_id`,`ec`.`escalation_number` AS `escalation_number`,`ec`.`current_level` AS `escalation_level`,`ec`.`current_state_code` AS `escalation_state_code`,`e`.`logistics_case_id` AS `logistics_case_id`,`lc`.`logistics_number` AS `logistics_number`,`h`.`handoff_type` AS `handoff_type`,`e`.`repair_job_id` AS `repair_job_id`,coalesce(`rj`.`repair_centre_location_id`,`lc`.`repair_centre_location_id`) AS `repair_centre_location_id`,`location`.`name` AS `repair_centre_name`,`e`.`temporary_loan_case_id` AS `temporary_loan_case_id`,`e`.`permanent_replacement_case_id` AS `permanent_replacement_case_id`,`e`.`severity_code` AS `severity_code`,`sv`.`name` AS `severity_name`,`e`.`title` AS `title`,`e`.`message` AS `message`,`e`.`action_type` AS `action_type`,`e`.`action_reference` AS `action_reference`,`e`.`created_at` AS `created_at`,date_format(`e`.`created_at`,'%b %e, %Y %l:%i %p') AS `created_at_display`,`creator`.`display_name` AS `created_by_name` from ((((((((((((((`notification_recipients` `nr` join `notification_events` `e` on((`e`.`id` = `nr`.`notification_event_id`))) join `notification_event_types` `et` on((`et`.`code` = `e`.`event_type_code`))) join `notification_severities` `sv` on((`sv`.`code` = `e`.`severity_code`))) left join `tickets` `t` on((`t`.`id` = `e`.`ticket_id`))) left join `schools` `school` on((`school`.`id` = `t`.`origin_school_id`))) left join `districts` `district` on((`district`.`id` = `t`.`origin_district_id`))) left join `devices` `device` on((`device`.`id` = `t`.`device_id`))) left join `ticket_logistics_cases` `lc` on((`lc`.`id` = `e`.`logistics_case_id`))) left join `logistics_handoffs` `h` on(((`e`.`source_type` = 'LOGISTICS_HANDOFF') and (`h`.`id` = cast(`e`.`source_id` as unsigned))))) left join `repair_jobs` `rj` on((`rj`.`id` = `e`.`repair_job_id`))) left join `service_locations` `location` on((`location`.`id` = coalesce(`rj`.`repair_centre_location_id`,`lc`.`repair_centre_location_id`)))) left join `sla_instances` `si` on((`si`.`id` = `e`.`sla_instance_id`))) left join `escalation_cases` `ec` on((`ec`.`id` = `e`.`escalation_case_id`))) left join `users` `creator` on((`creator`.`id` = `e`.`created_by`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_notification_unread_recipients`
--

/*!50001 DROP VIEW IF EXISTS `v_notification_unread_recipients`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_notification_unread_recipients` AS select `notification_recipients`.`id` AS `id`,`notification_recipients`.`notification_event_id` AS `notification_event_id`,`notification_recipients`.`user_id` AS `user_id`,`notification_recipients`.`read_at` AS `read_at`,`notification_recipients`.`read_by` AS `read_by`,`notification_recipients`.`archived_at` AS `archived_at` from `notification_recipients` where (isnull(`notification_recipients`.`read_at`) and isnull(`notification_recipients`.`archived_at`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_permanent_replacement_inventory_candidates`
--

/*!50001 DROP VIEW IF EXISTS `v_permanent_replacement_inventory_candidates`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_permanent_replacement_inventory_candidates` AS select `prc`.`id` AS `replacement_case_id`,`stock`.`stock_location_id` AS `stock_location_id`,`stock`.`device_id` AS `device_id`,`stock`.`serial_number` AS `serial_number`,`stock`.`asset_tag` AS `asset_tag`,`stock`.`manufacturer_name` AS `manufacturer_name`,`stock`.`model_name` AS `model_name`,`stock`.`lifecycle_code` AS `lifecycle_code`,`stock`.`allocation_level` AS `allocation_level`,`stock`.`district_id` AS `district_id`,`stock`.`district_name` AS `district_name`,`stock`.`school_id` AS `school_id`,`stock`.`school_name` AS `school_name`,`stock`.`service_location_id` AS `service_location_id`,`stock`.`service_location_name` AS `service_location_name`,`stock`.`stock_status` AS `stock_status`,`stock`.`is_reserved_for_replacement` AS `is_reserved_for_replacement`,`candidate`.`lifecycle_status_id` AS `lifecycle_status_id` from (((((`permanent_replacement_cases` `prc` join `repair_exception_cases` `exception_case` on((`exception_case`.`id` = `prc`.`exception_case_id`))) join `v_device_current_custody` `original_allocation` on((`original_allocation`.`device_id` = `prc`.`original_device_id`))) join `v_device_stock_queue` `stock` on((`stock`.`service_location_id` = `prc`.`repair_service_location_id`))) join `service_locations` `repair_centre` on((`repair_centre`.`id` = `stock`.`service_location_id`))) join `devices` `candidate` on((`candidate`.`id` = `stock`.`device_id`))) where ((`prc`.`active_record_key` = 1) and (`prc`.`current_status_code` = 'SELECTION_REQUIRED') and isnull(`prc`.`replacement_source_type`) and isnull(`prc`.`active_selection_key`) and (`exception_case`.`current_status_code` = 'REPLACEMENT_APPROVED') and (`repair_centre`.`location_type` = 'REPAIR_CENTRE') and (`repair_centre`.`is_active` = 1) and (`stock`.`device_id` <> `prc`.`original_device_id`) and (`stock`.`lifecycle_code` = 'AVAILABLE') and (`stock`.`stock_status` = 'IN_STOCK') and (`stock`.`allocation_level` <> 'STUDENT') and (`stock`.`is_reserved_for_replacement` = 0) and (`stock`.`has_active_logistics` = 0) and (`stock`.`has_active_manufacturer_return` = 0) and (`stock`.`has_active_repair` = 0) and (not(exists(select 1 from `device_replacements` `consumed` where (`consumed`.`replacement_device_id` = `stock`.`device_id`)))) and (not(exists(select 1 from `permanent_replacement_cases` `reserved` where ((`reserved`.`replacement_device_id` = `stock`.`device_id`) and (`reserved`.`active_selection_key` is not null))))) and ((`stock`.`allocation_level` = 'CENTRAL') or ((`stock`.`allocation_level` = 'DISTRICT') and (`original_allocation`.`district_id` is not null) and (`stock`.`district_id` = `original_allocation`.`district_id`)) or ((`stock`.`allocation_level` = 'SCHOOL') and (`original_allocation`.`school_id` is not null) and (`stock`.`school_id` = `original_allocation`.`school_id`)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_permanent_replacement_queue`
--

/*!50001 DROP VIEW IF EXISTS `v_permanent_replacement_queue`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_permanent_replacement_queue` AS select `prc`.`id` AS `replacement_case_id`,`prc`.`replacement_number` AS `replacement_number`,`prc`.`exception_case_id` AS `exception_case_id`,`prc`.`temporary_loan_case_id` AS `temporary_loan_case_id`,`loan`.`loan_number` AS `loan_number`,`conversion_request`.`conversion_request_number` AS `conversion_request_number`,`prc`.`ticket_id` AS `ticket_id`,`t`.`ticket_number` AS `ticket_number`,`prc`.`logistics_case_id` AS `logistics_case_id`,`tlc`.`logistics_number` AS `logistics_number`,`ls`.`code` AS `logistics_status_code`,`ls`.`name` AS `logistics_status_name`,`prc`.`repair_job_id` AS `repair_job_id`,`prc`.`original_device_id` AS `original_device_id`,`od`.`serial_number` AS `original_serial_number`,`od`.`asset_tag` AS `original_asset_tag`,`dm`.`model_name` AS `original_model_name`,`m`.`name` AS `original_manufacturer_name`,`prc`.`replacement_source_type` AS `replacement_source_type`,`prc`.`staged_manufacturer_unit_id` AS `staged_manufacturer_unit_id`,`msu`.`serial_number` AS `staged_serial_number`,`msu`.`model_description` AS `staged_model_description`,`prc`.`replacement_device_id` AS `replacement_device_id`,`rd`.`serial_number` AS `replacement_serial_number`,`rd`.`asset_tag` AS `replacement_asset_tag`,`prc`.`repair_service_location_id` AS `repair_service_location_id`,`sl`.`name` AS `repair_centre_name`,`t`.`origin_school_id` AS `origin_school_id`,`s`.`name` AS `origin_school_name`,`t`.`origin_district_id` AS `origin_district_id`,`d`.`name` AS `origin_district_name`,`prc`.`current_status_code` AS `replacement_status_code`,`prs`.`name` AS `replacement_status_name`,`ec`.`current_status_code` AS `exception_status_code`,`tss`.`code` AS `ticket_status_code`,`tss`.`name` AS `ticket_status_name`,`lc`.`code` AS `original_device_lifecycle_code`,`lc`.`name` AS `original_device_lifecycle_name`,`vc`.`current_custody_level` AS `phase5_custody_level`,`vc`.`district_id` AS `phase5_district_id`,`vc`.`school_id` AS `phase5_school_id`,`vc`.`student_id` AS `phase5_student_id`,`prc`.`created_by` AS `created_by`,`prc`.`created_at` AS `created_at`,`prc`.`updated_by` AS `updated_by`,`prc`.`updated_at` AS `updated_at`,`prc`.`completed_by` AS `completed_by`,`prc`.`completed_at` AS `completed_at`,`prc`.`closed_at` AS `closed_at`,`prc`.`active_record_key` AS `active_record_key` from ((((((((((((((((((`permanent_replacement_cases` `prc` left join `repair_exception_cases` `ec` on((`ec`.`id` = `prc`.`exception_case_id`))) left join `temporary_loan_cases` `loan` on((`loan`.`id` = `prc`.`temporary_loan_case_id`))) left join `temporary_loan_conversion_requests` `conversion_request` on((`conversion_request`.`id` = `loan`.`conversion_request_id`))) join `tickets` `t` on((`t`.`id` = `prc`.`ticket_id`))) join `ticket_logistics_cases` `tlc` on((`tlc`.`id` = `prc`.`logistics_case_id`))) join `logistics_statuses` `ls` on((`ls`.`id` = `tlc`.`current_status_id`))) join `ticket_statuses` `tss` on((`tss`.`id` = `t`.`current_status_id`))) join `devices` `od` on((`od`.`id` = `prc`.`original_device_id`))) join `device_lifecycle_statuses` `lc` on((`lc`.`id` = `od`.`lifecycle_status_id`))) join `device_models` `dm` on((`dm`.`id` = `od`.`device_model_id`))) join `manufacturers` `m` on((`m`.`id` = `dm`.`manufacturer_id`))) join `service_locations` `sl` on((`sl`.`id` = `prc`.`repair_service_location_id`))) join `permanent_replacement_statuses` `prs` on((`prs`.`code` = `prc`.`current_status_code`))) left join `schools` `s` on((`s`.`id` = `t`.`origin_school_id`))) left join `districts` `d` on((`d`.`id` = `t`.`origin_district_id`))) left join `manufacturer_supplied_units` `msu` on((`msu`.`id` = `prc`.`staged_manufacturer_unit_id`))) left join `devices` `rd` on((`rd`.`id` = `prc`.`replacement_device_id`))) left join `v_device_current_custody` `vc` on((`vc`.`device_id` = `prc`.`original_device_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_repair_current_context`
--

/*!50001 DROP VIEW IF EXISTS `v_repair_current_context`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_repair_current_context` AS select `p`.`logistics_case_id` AS `logistics_case_id`,`p`.`logistics_number` AS `logistics_number`,`p`.`ticket_id` AS `ticket_id`,`t`.`ticket_number` AS `ticket_number`,`p`.`device_id` AS `device_id`,`d`.`serial_number` AS `serial_number`,`d`.`asset_tag` AS `asset_tag`,`p`.`repair_centre_location_id` AS `repair_centre_location_id`,`p`.`repair_centre_location_code` AS `repair_centre_code`,`p`.`repair_centre_location_name` AS `repair_centre_name`,`p`.`repair_centre_location_code` AS `repair_centre_location_code`,`p`.`repair_centre_location_name` AS `repair_centre_location_name`,`p`.`physical_state_code` AS `physical_state_code`,`p`.`logistics_status_code` AS `logistics_status_code`,`p`.`ticket_status_code` AS `ticket_status_code`,`p`.`allocation_custody_level` AS `allocation_custody_level`,`p`.`allocation_district_id` AS `allocation_district_id`,`p`.`allocation_school_id` AS `allocation_school_id`,`p`.`allocation_student_id` AS `allocation_student_id`,`ls`.`code` AS `device_lifecycle_code`,`j`.`id` AS `repair_job_id`,`j`.`started_at` AS `started_at`,`j`.`started_by_user_id` AS `started_by_user_id`,`started_by`.`display_name` AS `started_by_display_name`,`j`.`completed_at` AS `completed_at`,`j`.`completed_by_user_id` AS `completed_by_user_id`,`completed_by`.`display_name` AS `completed_by_display_name`,`o`.`id` AS `outcome_id`,`o`.`code` AS `outcome_code`,`o`.`name` AS `outcome_name`,`o`.`is_return_ready` AS `outcome_is_return_ready`,`o`.`is_return_ready` AS `is_return_ready`,(select count(0) from `laptop_tickets_db`.`repair_assessments` `ra` where (`ra`.`repair_job_id` = `j`.`id`)) AS `assessment_count`,(select count(0) from `laptop_tickets_db`.`repair_work_logs` `rw` where (`rw`.`repair_job_id` = `j`.`id`)) AS `work_log_count`,(case when isnull(`j`.`id`) then 'AWAITING_REPAIR_START' when isnull(`j`.`completed_at`) then 'IN_PROGRESS' when (`o`.`is_return_ready` = 1) then 'READY_FOR_RETURN' else 'DISPOSITION_RECORDED' end) AS `repair_state_code`,(case when isnull(`j`.`id`) then 'AWAITING_REPAIR_START' when isnull(`j`.`completed_at`) then 'IN_PROGRESS' when (`o`.`is_return_ready` = 1) then 'READY_FOR_RETURN' else 'DISPOSITION_RECORDED' end) AS `repair_state` from (((((((`laptop_tickets_db`.`v_logistics_physical_custody` `p` join `laptop_tickets_db`.`tickets` `t` on((`t`.`id` = `p`.`ticket_id`))) join `laptop_tickets_db`.`devices` `d` on((`d`.`id` = `p`.`device_id`))) join `laptop_tickets_db`.`device_lifecycle_statuses` `ls` on((`ls`.`id` = `d`.`lifecycle_status_id`))) left join `laptop_tickets_db`.`repair_jobs` `j` on((`j`.`logistics_case_id` = `p`.`logistics_case_id`))) left join `laptop_tickets_db`.`repair_outcomes` `o` on((`o`.`id` = `j`.`outcome_id`))) left join `laptop_tickets_db`.`users` `started_by` on((`started_by`.`id` = `j`.`started_by_user_id`))) left join `laptop_tickets_db`.`users` `completed_by` on((`completed_by`.`id` = `j`.`completed_by_user_id`))) where (`p`.`physical_state_code` = 'REPAIR_CENTRE_CUSTODY') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_sla_calendar_business_dates`
--

/*!50001 DROP VIEW IF EXISTS `v_sla_calendar_business_dates`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_sla_calendar_business_dates` AS select `c`.`id` AS `calendar_id`,`d`.`calendar_date` AS `calendar_date`,date_format(timestamp(`d`.`calendar_date`,'23:59:59'),'%Y-%m-%d %H:%i:%s') AS `business_due_at`,(case when (`o`.`id` is not null) then `o`.`is_business_day` else coalesce(`w`.`is_business_day`,0) end) AS `is_business_day` from (((`sla_calendars` `c` join `sla_calendar_dates` `d`) left join `sla_calendar_weekdays` `w` on(((`w`.`calendar_id` = `c`.`id`) and (`w`.`weekday_number` = (weekday(`d`.`calendar_date`) + 1))))) left join `sla_calendar_overrides` `o` on(((`o`.`calendar_id` = `c`.`id`) and (`o`.`override_date` = `d`.`calendar_date`) and (`o`.`status` = 'active')))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_sla_completion_context`
--

/*!50001 DROP VIEW IF EXISTS `v_sla_completion_context`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_sla_completion_context` AS select `i`.`id` AS `id`,`i`.`idempotency_key` AS `idempotency_key`,`i`.`current_state_code` AS `current_state_code`,date_format(`i`.`due_at`,'%Y-%m-%d %H:%i:%s.%f') AS `due_at`,`i`.`policy_code_snapshot` AS `policy_code_snapshot`,`i`.`calendar_id` AS `calendar_id`,`c`.`timezone_name` AS `timezone_name`,date_format(convert_tz(utc_timestamp(6),'+00:00',`c`.`timezone_name`),'%Y-%m-%d %H:%i:%s.%f') AS `completion_business_datetime`,(case when isnull(convert_tz(utc_timestamp(6),'+00:00',`c`.`timezone_name`)) then 1 else 0 end) AS `timezone_resolution_error` from (`sla_instances` `i` join `sla_calendars` `c` on((`c`.`id` = `i`.`calendar_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_sla_evaluation_queue`
--

/*!50001 DROP VIEW IF EXISTS `v_sla_evaluation_queue`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_sla_evaluation_queue` AS select `evaluated`.`id` AS `id`,`evaluated`.`policy_code_snapshot` AS `policy_code_snapshot`,`evaluated`.`current_state_code` AS `current_state_code`,`evaluated`.`due_at` AS `due_at`,`evaluated`.`at_risk_at` AS `at_risk_at`,`evaluated`.`source_entity_type` AS `source_entity_type`,`evaluated`.`source_entity_id` AS `source_entity_id`,`evaluated`.`calendar_id` AS `calendar_id`,`evaluated`.`timezone_name` AS `timezone_name`,`evaluated`.`evaluation_business_datetime` AS `evaluation_business_datetime`,cast(`evaluated`.`due_at` as date) AS `due_business_date`,cast(`evaluated`.`evaluation_business_datetime` as date) AS `evaluation_business_date`,(case when ((`evaluated`.`evaluation_business_datetime` is not null) and (`evaluated`.`evaluation_business_datetime` > `evaluated`.`due_at`)) then 1 else 0 end) AS `is_breached`,(case when ((`evaluated`.`evaluation_business_datetime` is not null) and (`evaluated`.`current_state_code` = 'ACTIVE') and (cast(`evaluated`.`evaluation_business_datetime` as date) = cast(`evaluated`.`due_at` as date)) and (`evaluated`.`evaluation_business_datetime` <= `evaluated`.`due_at`)) then 1 else 0 end) AS `is_at_risk`,(case when isnull(`evaluated`.`evaluation_business_datetime`) then 1 else 0 end) AS `timezone_resolution_error` from (select `i`.`id` AS `id`,`i`.`policy_code_snapshot` AS `policy_code_snapshot`,`i`.`current_state_code` AS `current_state_code`,`i`.`due_at` AS `due_at`,`i`.`at_risk_at` AS `at_risk_at`,`i`.`source_entity_type` AS `source_entity_type`,`i`.`source_entity_id` AS `source_entity_id`,`i`.`calendar_id` AS `calendar_id`,`c`.`timezone_name` AS `timezone_name`,convert_tz(utc_timestamp(6),'+00:00',`c`.`timezone_name`) AS `evaluation_business_datetime` from (`laptop_tickets_db`.`sla_instances` `i` join `laptop_tickets_db`.`sla_calendars` `c` on((`c`.`id` = `i`.`calendar_id`)))) `evaluated` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_sla_operational_queue`
--

/*!50001 DROP VIEW IF EXISTS `v_sla_operational_queue`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_sla_operational_queue` AS select `i`.`id` AS `sla_instance_id`,`i`.`idempotency_key` AS `idempotency_key`,`i`.`policy_code_snapshot` AS `policy_code_snapshot`,`pv`.`name` AS `policy_name`,`i`.`target_business_days_snapshot` AS `target_business_days_snapshot`,`i`.`current_state_code` AS `current_state_code`,`st`.`name` AS `current_state_name`,`i`.`started_at` AS `started_at`,`i`.`due_at` AS `due_at`,`i`.`at_risk_at` AS `at_risk_at`,`i`.`breached_at` AS `breached_at`,`i`.`completed_at` AS `completed_at`,`i`.`cancelled_at` AS `cancelled_at`,date_format(`i`.`started_at`,'%b %e, %Y %l:%i %p') AS `started_at_display`,date_format(`i`.`due_at`,'%b %e, %Y %l:%i %p') AS `due_at_display`,date_format(`i`.`at_risk_at`,'%b %e, %Y %l:%i %p') AS `at_risk_at_display`,date_format(`i`.`breached_at`,'%b %e, %Y %l:%i %p') AS `breached_at_display`,date_format(`i`.`completed_at`,'%b %e, %Y %l:%i %p') AS `completed_at_display`,date_format(`i`.`cancelled_at`,'%b %e, %Y %l:%i %p') AS `cancelled_at_display`,`i`.`completion_event` AS `completion_event`,`i`.`ticket_id` AS `ticket_id`,`t`.`ticket_number` AS `ticket_number`,`t`.`origin_district_id` AS `origin_district_id`,`d`.`name` AS `origin_district_name`,`t`.`origin_school_id` AS `origin_school_id`,`s`.`name` AS `origin_school_name`,`i`.`logistics_case_id` AS `logistics_case_id`,`lc`.`logistics_number` AS `logistics_number`,`lc`.`repair_centre_location_id` AS `repair_centre_location_id`,`i`.`repair_job_id` AS `repair_job_id`,`i`.`device_id` AS `device_id`,`i`.`effective_device_id` AS `effective_device_id`,`i`.`source_workflow` AS `source_workflow`,`i`.`source_entity_type` AS `source_entity_type`,`i`.`source_entity_id` AS `source_entity_id` from ((((((`sla_instances` `i` join `sla_instance_states` `st` on((`st`.`code` = `i`.`current_state_code`))) join `sla_policy_versions` `pv` on((`pv`.`id` = `i`.`policy_version_id`))) join `tickets` `t` on((`t`.`id` = `i`.`ticket_id`))) left join `districts` `d` on((`d`.`id` = `t`.`origin_district_id`))) left join `schools` `s` on((`s`.`id` = `t`.`origin_school_id`))) left join `ticket_logistics_cases` `lc` on((`lc`.`id` = `i`.`logistics_case_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_sla_policy_current`
--

/*!50001 DROP VIEW IF EXISTS `v_sla_policy_current`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_sla_policy_current` AS select `p`.`id` AS `policy_id`,`p`.`policy_code` AS `policy_code`,`v`.`id` AS `policy_version_id`,`v`.`version_number` AS `version_number`,`v`.`name` AS `name`,`v`.`description` AS `description`,`v`.`calendar_id` AS `calendar_id`,`c`.`calendar_code` AS `calendar_code`,`c`.`name` AS `calendar_name`,`v`.`target_business_days` AS `target_business_days`,`v`.`status` AS `status`,`v`.`sort_order` AS `sort_order`,`v`.`start_event_code` AS `start_event_code`,`v`.`completion_event_code` AS `completion_event_code`,`v`.`pause_condition_code` AS `pause_condition_code`,`v`.`created_by` AS `version_created_by`,`v`.`created_at` AS `version_created_at`,`p`.`created_at` AS `policy_created_at`,`p`.`updated_at` AS `policy_updated_at` from ((`sla_policies` `p` join `sla_policy_versions` `v` on((`v`.`policy_id` = `p`.`id`))) join `sla_calendars` `c` on((`c`.`id` = `v`.`calendar_id`))) where (not(exists(select 1 from `sla_policy_versions` `newer` where ((`newer`.`policy_id` = `v`.`policy_id`) and (`newer`.`version_number` > `v`.`version_number`))))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_sla_policy_version_history`
--

/*!50001 DROP VIEW IF EXISTS `v_sla_policy_version_history`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_sla_policy_version_history` AS select `v`.`id` AS `policy_version_id`,`v`.`policy_id` AS `policy_id`,`p`.`policy_code` AS `policy_code`,`v`.`version_number` AS `version_number`,`v`.`name` AS `name`,`v`.`description` AS `description`,`v`.`calendar_id` AS `calendar_id`,`c`.`calendar_code` AS `calendar_code`,`c`.`name` AS `calendar_name`,`v`.`target_business_days` AS `target_business_days`,`v`.`status` AS `status`,`v`.`sort_order` AS `sort_order`,`v`.`start_event_code` AS `start_event_code`,`v`.`completion_event_code` AS `completion_event_code`,`v`.`pause_condition_code` AS `pause_condition_code`,`v`.`created_by` AS `created_by`,`v`.`created_at` AS `created_at` from ((`sla_policy_versions` `v` join `sla_policies` `p` on((`p`.`id` = `v`.`policy_id`))) join `sla_calendars` `c` on((`c`.`id` = `v`.`calendar_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_temporary_loan_queue`
--

/*!50001 DROP VIEW IF EXISTS `v_temporary_loan_queue`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_temporary_loan_queue` AS select `loan`.`id` AS `temporary_loan_case_id`,`loan`.`loan_number` AS `loan_number`,`loan`.`ticket_id` AS `ticket_id`,`t`.`ticket_number` AS `ticket_number`,`loan`.`original_device_id` AS `original_device_id`,`original`.`serial_number` AS `original_serial_number`,`original`.`asset_tag` AS `original_asset_tag`,`loan`.`origin_district_id` AS `origin_district_id`,`district`.`name` AS `origin_district_name`,`loan`.`origin_school_id` AS `origin_school_id`,`school`.`name` AS `origin_school_name`,`loan`.`repair_job_id` AS `repair_job_id`,`loan`.`repair_service_location_id` AS `repair_service_location_id`,`centre`.`name` AS `repair_centre_name`,`loan`.`spare_pool_id` AS `spare_pool_id`,`pool`.`pool_code` AS `pool_code`,`pool`.`name` AS `spare_pool_name`,`loan`.`current_status_code` AS `current_status_code`,`status`.`name` AS `loan_status_name`,`loan`.`request_reason_code` AS `request_reason_code`,`loan`.`requested_by` AS `requested_by`,`loan`.`requested_at` AS `requested_at`,`loan`.`request_notes` AS `request_notes`,`lc`.`id` AS `logistics_case_id`,`loan`.`authorized_by` AS `authorized_by`,`loan`.`authorized_at` AS `authorized_at`,`loan`.`authorization_notes` AS `authorization_notes`,`loan`.`rejected_by` AS `rejected_by`,`loan`.`rejected_at` AS `rejected_at`,`loan`.`rejection_reason` AS `rejection_reason`,`loan`.`selected_spare_device_id` AS `selected_spare_device_id`,`loan`.`selected_by` AS `selected_by`,`loan`.`selected_at` AS `selected_at`,`loan`.`issued_by` AS `issued_by`,`loan`.`issued_at` AS `issued_at`,`loan`.`return_requested_by` AS `return_requested_by`,`loan`.`return_requested_at` AS `return_requested_at`,`loan`.`return_reason_code` AS `return_reason_code`,`return_reason`.`name` AS `return_reason_name`,`loan`.`return_notes` AS `return_notes`,`loan`.`return_condition_code` AS `return_condition_code`,`loan`.`returned_by` AS `returned_by`,`loan`.`returned_at` AS `returned_at`,`loan`.`conversion_status` AS `conversion_status`,`loan`.`conversion_request_id` AS `conversion_request_id`,`loan`.`active_record_key` AS `active_record_key`,`loan`.`created_at` AS `created_at`,`loan`.`updated_at` AS `updated_at`,`loan`.`closed_at` AS `closed_at`,`ts`.`code` AS `ticket_status_code`,`ls`.`code` AS `logistics_status_code`,`rj`.`completed_at` AS `repair_completed_at`,(select `m`.`current_status_code` from `manufacturer_return_cases` `m` where (`m`.`ticket_id` = `loan`.`ticket_id`) order by `m`.`id` desc limit 1) AS `manufacturer_return_status_code`,`spare`.`serial_number` AS `selected_spare_serial_number`,`spare`.`asset_tag` AS `selected_spare_asset_tag`,`manufacturer`.`name` AS `selected_spare_manufacturer_name`,`model`.`model_name` AS `selected_spare_model_name`,`spare_lifecycle`.`code` AS `selected_spare_lifecycle_code`,(case when isnull(`spare`.`id`) then NULL when isnull(`active_stock`.`id`) then 'NOT_IN_FREE_STOCK' else `active_stock`.`stock_status` end) AS `selected_spare_stock_status`,`active_stock`.`service_location_id` AS `selected_spare_stock_location_id`,`reservation`.`reservation_status` AS `spare_reservation_status`,(case when (`reservation`.`active_record_key` = 1) then 1 else 0 end) AS `spare_reservation_active`,(case when (`loan`.`current_status_code` = 'CONVERTED_PERMANENT') then 'WITH_RECIPIENT' else `latest_custody`.`to_custody_code` end) AS `physical_custody_code`,`latest_custody`.`created_at` AS `custody_recorded_at`,`conversion`.`id` AS `latest_conversion_request_id`,`conversion`.`conversion_request_number` AS `conversion_request_number`,`conversion`.`status_code` AS `conversion_request_status`,`conversion`.`reason_code` AS `conversion_reason_code`,`conversion_reason`.`name` AS `conversion_reason_name`,`conversion`.`request_notes` AS `conversion_request_notes`,`conversion`.`requested_by` AS `conversion_requested_by`,`requester`.`display_name` AS `conversion_requested_by_name`,`conversion`.`requested_at` AS `conversion_requested_at`,`decision`.`decision_code` AS `conversion_decision`,`decision`.`decided_by` AS `conversion_decided_by`,`decider`.`display_name` AS `conversion_decided_by_name`,`decision`.`decided_at` AS `conversion_decided_at`,`decision`.`decision_notes` AS `conversion_decision_notes`,`replacement_case`.`id` AS `permanent_replacement_case_id`,`replacement_case`.`replacement_number` AS `permanent_replacement_number`,`replacement_case`.`current_status_code` AS `permanent_replacement_status`,`original_lifecycle`.`code` AS `original_device_lifecycle_code` from ((((((((((((((((((((((((((`temporary_loan_cases` `loan` join `tickets` `t` on((`t`.`id` = `loan`.`ticket_id`))) join `ticket_statuses` `ts` on((`ts`.`id` = `t`.`current_status_id`))) join `devices` `original` on((`original`.`id` = `loan`.`original_device_id`))) join `device_lifecycle_statuses` `original_lifecycle` on((`original_lifecycle`.`id` = `original`.`lifecycle_status_id`))) join `districts` `district` on((`district`.`id` = `loan`.`origin_district_id`))) left join `schools` `school` on((`school`.`id` = `loan`.`origin_school_id`))) join `service_locations` `centre` on((`centre`.`id` = `loan`.`repair_service_location_id`))) join `spare_pools` `pool` on((`pool`.`id` = `loan`.`spare_pool_id`))) join `temporary_loan_statuses` `status` on((`status`.`code` = `loan`.`current_status_code`))) left join `temporary_loan_return_reasons` `return_reason` on((`return_reason`.`code` = `loan`.`return_reason_code`))) join `repair_jobs` `rj` on((`rj`.`id` = `loan`.`repair_job_id`))) join `ticket_logistics_cases` `lc` on((`lc`.`id` = `rj`.`logistics_case_id`))) join `logistics_statuses` `ls` on((`ls`.`id` = `lc`.`current_status_id`))) left join `devices` `spare` on((`spare`.`id` = `loan`.`selected_spare_device_id`))) left join `device_lifecycle_statuses` `spare_lifecycle` on((`spare_lifecycle`.`id` = `spare`.`lifecycle_status_id`))) left join `device_models` `model` on((`model`.`id` = `spare`.`device_model_id`))) left join `manufacturers` `manufacturer` on((`manufacturer`.`id` = `model`.`manufacturer_id`))) left join `device_stock_locations` `active_stock` on(((`active_stock`.`device_id` = `spare`.`id`) and (`active_stock`.`active_record_key` = 1) and (`active_stock`.`stock_status` = 'IN_STOCK')))) left join `temporary_loan_spare_reservations` `reservation` on((`reservation`.`id` = (select max(`r`.`id`) from `temporary_loan_spare_reservations` `r` where (`r`.`temporary_loan_case_id` = `loan`.`id`))))) left join `temporary_loan_custody_history` `latest_custody` on((`latest_custody`.`id` = (select max(`ch`.`id`) from `temporary_loan_custody_history` `ch` where (`ch`.`temporary_loan_case_id` = `loan`.`id`))))) left join `temporary_loan_conversion_requests` `conversion` on((`conversion`.`id` = (select max(`cr`.`id`) from `temporary_loan_conversion_requests` `cr` where (`cr`.`temporary_loan_case_id` = `loan`.`id`))))) left join `temporary_loan_conversion_reasons` `conversion_reason` on((`conversion_reason`.`code` = `conversion`.`reason_code`))) left join `users` `requester` on((`requester`.`id` = `conversion`.`requested_by`))) left join `temporary_loan_conversion_decisions` `decision` on((`decision`.`conversion_request_id` = `conversion`.`id`))) left join `users` `decider` on((`decider`.`id` = `decision`.`decided_by`))) left join `permanent_replacement_cases` `replacement_case` on((`replacement_case`.`temporary_loan_case_id` = `loan`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_temporary_loan_request_context`
--

/*!50001 DROP VIEW IF EXISTS `v_temporary_loan_request_context`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_temporary_loan_request_context` AS select `t`.`id` AS `ticket_id`,`t`.`ticket_number` AS `ticket_number`,`t`.`device_id` AS `original_device_id`,`t`.`origin_district_id` AS `origin_district_id`,`t`.`origin_school_id` AS `origin_school_id`,`ts`.`code` AS `ticket_status_code`,`lc`.`id` AS `logistics_case_id`,`lc`.`repair_centre_location_id` AS `repair_service_location_id`,`ls`.`code` AS `logistics_status_code`,`rj`.`id` AS `repair_job_id`,`life`.`code` AS `original_lifecycle_code`,`pool`.`id` AS `spare_pool_id`,`pool`.`pool_code` AS `pool_code`,`pool`.`name` AS `spare_pool_name`,(case when ((`ts`.`code` = 'UNDER_REPAIR') and (`ls`.`code` = 'AT_REPAIR_CENTRE') and (`rj`.`id` is not null) and (`lc`.`active_record_key` = 1) and isnull(`lc`.`closed_at`) and (`life`.`code` in ('IN_REPAIR','MANUFACTURER_RETURN')) and (`pool`.`id` is not null) and (not(exists(select 1 from `permanent_replacement_cases` `pr` where ((`pr`.`ticket_id` = `t`.`id`) and (`pr`.`current_status_code` = 'COMPLETED'))))) and (not(exists(select 1 from `temporary_loan_cases` `loan` where ((`loan`.`ticket_id` = `t`.`id`) and (`loan`.`original_device_id` = `t`.`device_id`) and (`loan`.`active_record_key` = 1)))))) then 1 else 0 end) AS `can_request` from ((((((((`tickets` `t` join `ticket_statuses` `ts` on((`ts`.`id` = `t`.`current_status_id`))) join `devices` `original` on((`original`.`id` = `t`.`device_id`))) join `device_lifecycle_statuses` `life` on((`life`.`id` = `original`.`lifecycle_status_id`))) left join `ticket_logistics_cases` `lc` on((`lc`.`id` = (select `x`.`id` from `ticket_logistics_cases` `x` where (`x`.`ticket_id` = `t`.`id`) order by `x`.`id` desc limit 1)))) left join `logistics_statuses` `ls` on((`ls`.`id` = `lc`.`current_status_id`))) left join `repair_jobs` `rj` on((`rj`.`logistics_case_id` = `lc`.`id`))) left join `service_locations` `loc` on((`loc`.`id` = `lc`.`repair_centre_location_id`))) left join `spare_pools` `pool` on(((`pool`.`service_location_id` = `loc`.`id`) and (`pool`.`status` = 'active') and (`pool`.`is_default` = 1) and (`pool`.`active_default_key` = 1)))) where ((`loc`.`location_type` = 'REPAIR_CENTRE') and (`loc`.`is_active` = 1)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_temporary_loan_spare_candidates`
--

/*!50001 DROP VIEW IF EXISTS `v_temporary_loan_spare_candidates`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_temporary_loan_spare_candidates` AS select `loan`.`id` AS `temporary_loan_case_id`,`loan`.`repair_service_location_id` AS `repair_service_location_id`,`loan`.`spare_pool_id` AS `spare_pool_id`,`stock`.`stock_location_id` AS `stock_location_id`,`stock`.`device_id` AS `device_id`,`stock`.`serial_number` AS `serial_number`,`stock`.`asset_tag` AS `asset_tag`,`stock`.`manufacturer_name` AS `manufacturer_name`,`stock`.`model_name` AS `model_name`,`stock`.`lifecycle_code` AS `lifecycle_code`,`stock`.`stock_status` AS `stock_status`,`stock`.`service_location_id` AS `service_location_id`,`stock`.`service_location_name` AS `service_location_name`,`stock`.`allocation_level` AS `allocation_level`,`stock`.`is_reserved_for_replacement` AS `is_reserved_for_replacement`,`stock`.`has_active_logistics` AS `has_active_logistics`,`stock`.`has_active_manufacturer_return` AS `has_active_manufacturer_return`,`stock`.`has_active_repair` AS `has_active_repair`,`lifecycle`.`id` AS `lifecycle_status_id` from (((((`temporary_loan_cases` `loan` join `spare_pools` `pool` on((`pool`.`id` = `loan`.`spare_pool_id`))) join `service_locations` `centre` on((`centre`.`id` = `loan`.`repair_service_location_id`))) join `v_device_stock_queue` `stock` on((`stock`.`service_location_id` = `loan`.`repair_service_location_id`))) join `devices` `candidate` on((`candidate`.`id` = `stock`.`device_id`))) join `device_lifecycle_statuses` `lifecycle` on((`lifecycle`.`id` = `candidate`.`lifecycle_status_id`))) where ((`loan`.`current_status_code` = 'AUTHORIZED') and (`loan`.`active_record_key` = 1) and (`pool`.`status` = 'active') and (`pool`.`is_default` = 1) and (`pool`.`service_location_id` = `loan`.`repair_service_location_id`) and (`centre`.`location_type` = 'REPAIR_CENTRE') and (`centre`.`is_active` = 1) and (`stock`.`stock_status` = 'IN_STOCK') and (`stock`.`lifecycle_code` = 'AVAILABLE') and (`stock`.`allocation_level` = 'CENTRAL') and (`stock`.`device_id` <> `loan`.`original_device_id`) and (`stock`.`is_reserved_for_replacement` = 0) and (`stock`.`has_active_logistics` = 0) and (`stock`.`has_active_manufacturer_return` = 0) and (`stock`.`has_active_repair` = 0) and (not(exists(select 1 from `temporary_loan_spare_reservations` `reservation` where ((`reservation`.`device_id` = `stock`.`device_id`) and (`reservation`.`active_record_key` = 1) and (`reservation`.`reservation_status` = 'RESERVED'))))) and (not(exists(select 1 from `temporary_loan_cases` `other_loan` where ((`other_loan`.`selected_spare_device_id` = `stock`.`device_id`) and (`other_loan`.`active_record_key` = 1) and (`other_loan`.`current_status_code` in ('SPARE_SELECTED','ACTIVE_LOAN')))))) and (not(exists(select 1 from `permanent_replacement_cases` `replacement_case` where ((`replacement_case`.`replacement_device_id` = `stock`.`device_id`) and (`replacement_case`.`active_selection_key` is not null))))) and (not(exists(select 1 from `device_replacements` `replacement` where (`replacement`.`replacement_device_id` = `stock`.`device_id`)))) and (not(exists(select 1 from `device_student_assignments` `assignment` where ((`assignment`.`device_id` = `stock`.`device_id`) and (`assignment`.`active_record_key` = 1) and isnull(`assignment`.`returned_at`)))))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_ticket_activity`
--

/*!50001 DROP VIEW IF EXISTS `v_ticket_activity`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_ticket_activity` AS select `tsh`.`ticket_id` AS `ticket_id`,`tsh`.`changed_at` AS `activity_at`,'STATUS_CHANGE' AS `activity_type`,cast(`tsh`.`to_status_id` as char charset utf8) AS `activity_code`,`tsh`.`id` AS `related_record_id`,`tsh`.`changed_by_user_id` AS `actor_user_id`,NULL AS `subject_user_id`,`tsh`.`from_status_id` AS `from_status_id`,`tsh`.`to_status_id` AS `to_status_id`,cast(NULL as char(50) charset utf8) AS `reference_code`,(case when (`st`.`code` = 'RETURNED') then 10 else 40 end) AS `activity_sort_order` from (`ticket_status_history` `tsh` left join `ticket_statuses` `st` on((`st`.`id` = `tsh`.`to_status_id`))) union all select `c`.`ticket_id` AS `ticket_id`,`h`.`changed_at` AS `changed_at`,'LOGISTICS' AS `LOGISTICS`,'PICKUP_REQUESTED' AS `PICKUP_REQUESTED`,`h`.`id` AS `id`,`h`.`changed_by_user_id` AS `changed_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`logistics_number` AS `logistics_number`,40 AS `40` from ((`logistics_status_history` `h` join `ticket_logistics_cases` `c` on((`c`.`id` = `h`.`logistics_case_id`))) join `logistics_statuses` `st` on((`st`.`id` = `h`.`to_status_id`))) where (isnull(`h`.`from_status_id`) and (`st`.`code` = 'REQUESTED')) union all select `c`.`ticket_id` AS `ticket_id`,`h`.`changed_at` AS `changed_at`,'LOGISTICS' AS `LOGISTICS`,'PICKUP_REQUEST_ACCEPTED' AS `PICKUP_REQUEST_ACCEPTED`,`h`.`id` AS `id`,`h`.`changed_by_user_id` AS `changed_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`logistics_number` AS `logistics_number`,40 AS `40` from (((`logistics_status_history` `h` join `ticket_logistics_cases` `c` on((`c`.`id` = `h`.`logistics_case_id`))) join `logistics_statuses` `sf` on((`sf`.`id` = `h`.`from_status_id`))) join `logistics_statuses` `st` on((`st`.`id` = `h`.`to_status_id`))) where ((`sf`.`code` = 'REQUESTED') and (`st`.`code` = 'ACCEPTED')) union all select `td`.`ticket_id` AS `ticket_id`,`td`.`diagnosed_at` AS `diagnosed_at`,'DIAGNOSIS' AS `DIAGNOSIS`,'DIAGNOSIS_RECORDED' AS `DIAGNOSIS_RECORDED`,`td`.`id` AS `id`,`td`.`diagnosed_by_user_id` AS `diagnosed_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,cast(NULL as char(50) charset utf8) AS `CAST(NULL AS CHAR(50))`,40 AS `40` from `ticket_diagnoses` `td` union all select `tc`.`ticket_id` AS `ticket_id`,`tc`.`created_at` AS `created_at`,`tc`.`comment_type` AS `comment_type`,`tc`.`comment_type` AS `comment_type`,`tc`.`id` AS `id`,`tc`.`created_by_user_id` AS `created_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,cast(NULL as char(50) charset utf8) AS `CAST(NULL AS CHAR(50))`,40 AS `40` from `ticket_comments` `tc` where (`tc`.`comment_type` in ('CLARIFICATION_REQUEST','CLARIFICATION_RESPONSE')) union all select `tda`.`ticket_id` AS `ticket_id`,`tda`.`decided_at` AS `decided_at`,'DISTRICT_APPROVAL' AS `DISTRICT_APPROVAL`,`tda`.`decision` AS `decision`,`tda`.`id` AS `id`,`tda`.`decided_by_user_id` AS `decided_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,cast(NULL as char(50) charset utf8) AS `CAST(NULL AS CHAR(50))`,40 AS `40` from `ticket_district_approvals` `tda` union all select `ta`.`ticket_id` AS `ticket_id`,`ta`.`assigned_at` AS `assigned_at`,'ASSIGNMENT_STARTED' AS `ASSIGNMENT_STARTED`,'ASSIGNED' AS `ASSIGNED`,`ta`.`id` AS `id`,`ta`.`assigned_by_user_id` AS `assigned_by_user_id`,`ta`.`assigned_to_user_id` AS `assigned_to_user_id`,NULL AS `NULL`,NULL AS `NULL`,cast(NULL as char(50) charset utf8) AS `CAST(NULL AS CHAR(50))`,40 AS `40` from `ticket_assignments` `ta` union all select `ta`.`ticket_id` AS `ticket_id`,`ta`.`ended_at` AS `ended_at`,'ASSIGNMENT_ENDED' AS `ASSIGNMENT_ENDED`,'ENDED' AS `ENDED`,`ta`.`id` AS `id`,`ta`.`ended_by_user_id` AS `ended_by_user_id`,`ta`.`assigned_to_user_id` AS `assigned_to_user_id`,NULL AS `NULL`,NULL AS `NULL`,cast(NULL as char(50) charset utf8) AS `CAST(NULL AS CHAR(50))`,40 AS `40` from `ticket_assignments` `ta` where (`ta`.`ended_at` is not null) union all select `c`.`ticket_id` AS `ticket_id`,`h`.`dispatched_at` AS `dispatched_at`,'LOGISTICS' AS `LOGISTICS`,'SCHOOL_TTPOST_HANDOFF_DISPATCHED' AS `SCHOOL_TTPOST_HANDOFF_DISPATCHED`,`h`.`id` AS `id`,`h`.`dispatched_by_user_id` AS `dispatched_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`logistics_number` AS `logistics_number`,40 AS `40` from (`logistics_handoffs` `h` join `ticket_logistics_cases` `c` on((`c`.`id` = `h`.`logistics_case_id`))) where ((`h`.`handoff_type` = 'SCHOOL_TO_TTPOST') and (`h`.`dispatched_at` is not null)) union all select `c`.`ticket_id` AS `ticket_id`,`h`.`received_at` AS `received_at`,'LOGISTICS' AS `LOGISTICS`,'TTPOST_DEVICE_RECEIVED' AS `TTPOST_DEVICE_RECEIVED`,`h`.`id` AS `id`,`h`.`received_by_user_id` AS `received_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`logistics_number` AS `logistics_number`,40 AS `40` from (`logistics_handoffs` `h` join `ticket_logistics_cases` `c` on((`c`.`id` = `h`.`logistics_case_id`))) where ((`h`.`handoff_type` = 'SCHOOL_TO_TTPOST') and (`h`.`received_at` is not null)) union all select `c`.`ticket_id` AS `ticket_id`,`sh`.`changed_at` AS `changed_at`,'LOGISTICS' AS `LOGISTICS`,'OUTBOUND_TRANSIT_STARTED' AS `OUTBOUND_TRANSIT_STARTED`,`sh`.`id` AS `id`,`sh`.`changed_by_user_id` AS `changed_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`logistics_number` AS `logistics_number`,40 AS `40` from (((`logistics_status_history` `sh` join `ticket_logistics_cases` `c` on((`c`.`id` = `sh`.`logistics_case_id`))) join `logistics_statuses` `sf` on((`sf`.`id` = `sh`.`from_status_id`))) join `logistics_statuses` `st` on((`st`.`id` = `sh`.`to_status_id`))) where ((`sf`.`code` = 'ACCEPTED') and (`st`.`code` = 'OUTBOUND_IN_TRANSIT')) union all select `c`.`ticket_id` AS `ticket_id`,`h`.`dispatched_at` AS `dispatched_at`,'LOGISTICS' AS `LOGISTICS`,'REPAIR_HANDOFF_DISPATCHED' AS `REPAIR_HANDOFF_DISPATCHED`,`h`.`id` AS `id`,`h`.`dispatched_by_user_id` AS `dispatched_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`logistics_number` AS `logistics_number`,40 AS `40` from (`logistics_handoffs` `h` join `ticket_logistics_cases` `c` on((`c`.`id` = `h`.`logistics_case_id`))) where ((`h`.`handoff_type` = 'TTPOST_TO_REPAIR_CENTRE') and (`h`.`dispatched_at` is not null)) union all select `c`.`ticket_id` AS `ticket_id`,`h`.`received_at` AS `received_at`,'LOGISTICS' AS `LOGISTICS`,'REPAIR_CENTRE_DEVICE_RECEIVED' AS `REPAIR_CENTRE_DEVICE_RECEIVED`,`h`.`id` AS `id`,`h`.`received_by_user_id` AS `received_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`logistics_number` AS `logistics_number`,40 AS `40` from (`logistics_handoffs` `h` join `ticket_logistics_cases` `c` on((`c`.`id` = `h`.`logistics_case_id`))) where ((`h`.`handoff_type` = 'TTPOST_TO_REPAIR_CENTRE') and (`h`.`received_at` is not null)) union all select `c`.`ticket_id` AS `ticket_id`,`sh`.`changed_at` AS `changed_at`,'LOGISTICS' AS `LOGISTICS`,'ARRIVED_AT_REPAIR_CENTRE' AS `ARRIVED_AT_REPAIR_CENTRE`,`sh`.`id` AS `id`,`sh`.`changed_by_user_id` AS `changed_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`logistics_number` AS `logistics_number`,40 AS `40` from (((`logistics_status_history` `sh` join `ticket_logistics_cases` `c` on((`c`.`id` = `sh`.`logistics_case_id`))) join `logistics_statuses` `sf` on((`sf`.`id` = `sh`.`from_status_id`))) join `logistics_statuses` `st` on((`st`.`id` = `sh`.`to_status_id`))) where ((`sf`.`code` = 'OUTBOUND_IN_TRANSIT') and (`st`.`code` = 'AT_REPAIR_CENTRE')) union all select `c`.`ticket_id` AS `ticket_id`,`j`.`started_at` AS `started_at`,'REPAIR' AS `REPAIR`,'REPAIR_STARTED' AS `REPAIR_STARTED`,`j`.`id` AS `id`,`j`.`started_by_user_id` AS `started_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`logistics_number` AS `logistics_number`,40 AS `40` from (`repair_jobs` `j` join `ticket_logistics_cases` `c` on((`c`.`id` = `j`.`logistics_case_id`))) union all select `c`.`ticket_id` AS `ticket_id`,`a`.`created_at` AS `created_at`,'REPAIR' AS `REPAIR`,'REPAIR_ASSESSMENT_RECORDED' AS `REPAIR_ASSESSMENT_RECORDED`,`a`.`id` AS `id`,`a`.`created_by_user_id` AS `created_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`logistics_number` AS `logistics_number`,40 AS `40` from ((`repair_assessments` `a` join `repair_jobs` `j` on((`j`.`id` = `a`.`repair_job_id`))) join `ticket_logistics_cases` `c` on((`c`.`id` = `j`.`logistics_case_id`))) union all select `c`.`ticket_id` AS `ticket_id`,`w`.`created_at` AS `created_at`,'REPAIR' AS `REPAIR`,'REPAIR_WORK_RECORDED' AS `REPAIR_WORK_RECORDED`,`w`.`id` AS `id`,`w`.`created_by_user_id` AS `created_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`logistics_number` AS `logistics_number`,40 AS `40` from ((`repair_work_logs` `w` join `repair_jobs` `j` on((`j`.`id` = `w`.`repair_job_id`))) join `ticket_logistics_cases` `c` on((`c`.`id` = `j`.`logistics_case_id`))) union all select `c`.`ticket_id` AS `ticket_id`,`j`.`completed_at` AS `completed_at`,'REPAIR' AS `REPAIR`,(case when (`o`.`is_return_ready` = 1) then 'REPAIR_COMPLETED' else 'REPAIR_DISPOSITION_RECORDED' end) AS `Name_exp_191`,`j`.`id` AS `id`,`j`.`completed_by_user_id` AS `completed_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`logistics_number` AS `logistics_number`,40 AS `40` from ((`repair_jobs` `j` join `repair_outcomes` `o` on((`o`.`id` = `j`.`outcome_id`))) join `ticket_logistics_cases` `c` on((`c`.`id` = `j`.`logistics_case_id`))) where (`j`.`completed_at` is not null) union all select `c`.`ticket_id` AS `ticket_id`,`sh`.`changed_at` AS `changed_at`,'LOGISTICS' AS `LOGISTICS`,'READY_FOR_RETURN' AS `READY_FOR_RETURN`,`sh`.`id` AS `id`,`sh`.`changed_by_user_id` AS `changed_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`logistics_number` AS `logistics_number`,40 AS `40` from (((`logistics_status_history` `sh` join `ticket_logistics_cases` `c` on((`c`.`id` = `sh`.`logistics_case_id`))) join `logistics_statuses` `sf` on((`sf`.`id` = `sh`.`from_status_id`))) join `logistics_statuses` `st` on((`st`.`id` = `sh`.`to_status_id`))) where ((`sf`.`code` = 'AT_REPAIR_CENTRE') and (`st`.`code` = 'READY_FOR_RETURN')) union all select `c`.`ticket_id` AS `ticket_id`,`h`.`dispatched_at` AS `dispatched_at`,'LOGISTICS' AS `LOGISTICS`,'RETURN_HANDOFF_DISPATCHED' AS `RETURN_HANDOFF_DISPATCHED`,`h`.`id` AS `id`,`h`.`dispatched_by_user_id` AS `dispatched_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`logistics_number` AS `logistics_number`,40 AS `40` from (`logistics_handoffs` `h` join `ticket_logistics_cases` `c` on((`c`.`id` = `h`.`logistics_case_id`))) where ((`h`.`handoff_type` = 'REPAIR_CENTRE_TO_TTPOST') and (`h`.`dispatched_at` is not null)) union all select `c`.`ticket_id` AS `ticket_id`,`h`.`received_at` AS `received_at`,'LOGISTICS' AS `LOGISTICS`,'RETURN_TTPOST_DEVICE_RECEIVED' AS `RETURN_TTPOST_DEVICE_RECEIVED`,`h`.`id` AS `id`,`h`.`received_by_user_id` AS `received_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`logistics_number` AS `logistics_number`,20 AS `20` from (`logistics_handoffs` `h` join `ticket_logistics_cases` `c` on((`c`.`id` = `h`.`logistics_case_id`))) where ((`h`.`handoff_type` = 'REPAIR_CENTRE_TO_TTPOST') and (`h`.`received_at` is not null)) union all select `c`.`ticket_id` AS `ticket_id`,`sh`.`changed_at` AS `changed_at`,'LOGISTICS' AS `LOGISTICS`,'RETURN_TRANSIT_STARTED' AS `RETURN_TRANSIT_STARTED`,`sh`.`id` AS `id`,`sh`.`changed_by_user_id` AS `changed_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`logistics_number` AS `logistics_number`,10 AS `10` from (((`logistics_status_history` `sh` join `ticket_logistics_cases` `c` on((`c`.`id` = `sh`.`logistics_case_id`))) join `logistics_statuses` `sf` on((`sf`.`id` = `sh`.`from_status_id`))) join `logistics_statuses` `st` on((`st`.`id` = `sh`.`to_status_id`))) where ((`sf`.`code` = 'READY_FOR_RETURN') and (`st`.`code` = 'RETURN_IN_TRANSIT')) union all select `c`.`ticket_id` AS `ticket_id`,`h`.`dispatched_at` AS `dispatched_at`,'LOGISTICS' AS `LOGISTICS`,'SCHOOL_RETURN_HANDOFF_DISPATCHED' AS `SCHOOL_RETURN_HANDOFF_DISPATCHED`,`h`.`id` AS `id`,`h`.`dispatched_by_user_id` AS `dispatched_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`logistics_number` AS `logistics_number`,40 AS `40` from (`logistics_handoffs` `h` join `ticket_logistics_cases` `c` on((`c`.`id` = `h`.`logistics_case_id`))) where ((`h`.`handoff_type` = 'TTPOST_TO_SCHOOL') and (`h`.`dispatched_at` is not null)) union all select `c`.`ticket_id` AS `ticket_id`,`h`.`received_at` AS `received_at`,'LOGISTICS' AS `LOGISTICS`,'SCHOOL_RETURN_DEVICE_RECEIVED' AS `SCHOOL_RETURN_DEVICE_RECEIVED`,`h`.`id` AS `id`,`h`.`received_by_user_id` AS `received_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`logistics_number` AS `logistics_number`,30 AS `30` from (`logistics_handoffs` `h` join `ticket_logistics_cases` `c` on((`c`.`id` = `h`.`logistics_case_id`))) where ((`h`.`handoff_type` = 'TTPOST_TO_SCHOOL') and (`h`.`received_at` is not null)) union all select `c`.`ticket_id` AS `ticket_id`,`sh`.`changed_at` AS `changed_at`,'LOGISTICS' AS `LOGISTICS`,'RETURNED_TO_SCHOOL' AS `RETURNED_TO_SCHOOL`,`sh`.`id` AS `id`,`sh`.`changed_by_user_id` AS `changed_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`logistics_number` AS `logistics_number`,20 AS `20` from (((`logistics_status_history` `sh` join `ticket_logistics_cases` `c` on((`c`.`id` = `sh`.`logistics_case_id`))) join `logistics_statuses` `sf` on((`sf`.`id` = `sh`.`from_status_id`))) join `logistics_statuses` `st` on((`st`.`id` = `sh`.`to_status_id`))) where ((`sf`.`code` = 'RETURN_IN_TRANSIT') and (`st`.`code` = 'RETURNED_TO_SCHOOL')) union all select `ec`.`ticket_id` AS `ticket_id`,`h`.`created_at` AS `created_at`,'EXCEPTION' AS `EXCEPTION`,'EXCEPTION_REVIEW_STARTED' AS `EXCEPTION_REVIEW_STARTED`,`ec`.`id` AS `id`,`h`.`actor_user_id` AS `actor_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,cast(NULL as char(50) charset utf8) AS `CAST(NULL AS CHAR(50))`,40 AS `40` from (`exception_case_status_history` `h` join `repair_exception_cases` `ec` on((`ec`.`id` = `h`.`exception_case_id`))) where (`h`.`to_status_code` in ('PENDING_DISTRICT_APPROVAL','PENDING_DISTRICT_DECISION','PENDING_HEAD_OFFICE_APPROVAL')) union all select `ec`.`ticket_id` AS `ticket_id`,`a`.`created_at` AS `created_at`,'EXCEPTION' AS `EXCEPTION`,'EXCEPTION_ASSESSMENT_RECORDED' AS `EXCEPTION_ASSESSMENT_RECORDED`,`a`.`id` AS `id`,`a`.`created_by_user_id` AS `created_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,cast(NULL as char(50) charset utf8) AS `CAST(NULL AS CHAR(50))`,40 AS `40` from (`exception_financial_assessments` `a` join `repair_exception_cases` `ec` on((`ec`.`id` = `a`.`exception_case_id`))) union all select `ec`.`ticket_id` AS `ticket_id`,`d`.`created_at` AS `created_at`,'EXCEPTION' AS `EXCEPTION`,'MANUFACTURER_RETURN_APPROVED' AS `MANUFACTURER_RETURN_APPROVED`,`d`.`id` AS `id`,`d`.`actor_user_id` AS `actor_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,cast(NULL as char(50) charset utf8) AS `CAST(NULL AS CHAR(50))`,40 AS `40` from (`exception_decisions` `d` join `repair_exception_cases` `ec` on((`ec`.`id` = `d`.`exception_case_id`))) where ((`d`.`decision_type_code` in ('DISTRICT_MANUFACTURER_APPROVAL','DISTRICT_DISPOSITION_DECISION')) and (`d`.`selected_disposition_code` = 'MANUFACTURER_RETURN') and (`d`.`decision_code` in ('APPROVED','SELECTED'))) union all select `ec`.`ticket_id` AS `ticket_id`,`d`.`created_at` AS `created_at`,'EXCEPTION' AS `EXCEPTION`,'REPLACEMENT_APPROVAL_REQUESTED' AS `REPLACEMENT_APPROVAL_REQUESTED`,`d`.`id` AS `id`,`d`.`actor_user_id` AS `actor_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,cast(NULL as char(50) charset utf8) AS `CAST(NULL AS CHAR(50))`,40 AS `40` from (`exception_decisions` `d` join `repair_exception_cases` `ec` on((`ec`.`id` = `d`.`exception_case_id`))) where ((`d`.`decision_type_code` = 'DISTRICT_DISPOSITION_DECISION') and (`d`.`selected_disposition_code` = 'PERMANENT_REPLACEMENT') and (`d`.`decision_code` = 'SELECTED')) union all select `ec`.`ticket_id` AS `ticket_id`,`d`.`created_at` AS `created_at`,'EXCEPTION' AS `EXCEPTION`,'REPLACEMENT_APPROVED' AS `REPLACEMENT_APPROVED`,`d`.`id` AS `id`,`d`.`actor_user_id` AS `actor_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,cast(NULL as char(50) charset utf8) AS `CAST(NULL AS CHAR(50))`,40 AS `40` from (`exception_decisions` `d` join `repair_exception_cases` `ec` on((`ec`.`id` = `d`.`exception_case_id`))) where ((`d`.`decision_type_code` = 'HEAD_OFFICE_REPLACEMENT_APPROVAL') and (`d`.`decision_code` = 'APPROVED')) union all select `ec`.`ticket_id` AS `ticket_id`,`d`.`created_at` AS `created_at`,'EXCEPTION' AS `EXCEPTION`,'EXCEPTION_RETURNED_FOR_REVIEW' AS `EXCEPTION_RETURNED_FOR_REVIEW`,`d`.`id` AS `id`,`d`.`actor_user_id` AS `actor_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,cast(NULL as char(50) charset utf8) AS `CAST(NULL AS CHAR(50))`,40 AS `40` from (`exception_decisions` `d` join `repair_exception_cases` `ec` on((`ec`.`id` = `d`.`exception_case_id`))) where (`d`.`decision_type_code` = 'RETURN_FOR_REVIEW') union all select `c`.`ticket_id` AS `ticket_id`,`c`.`started_at` AS `started_at`,'MANUFACTURER_RETURN' AS `MANUFACTURER_RETURN`,'MANUFACTURER_RETURN_STARTED' AS `MANUFACTURER_RETURN_STARTED`,`c`.`id` AS `id`,`c`.`started_by` AS `started_by`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,81 AS `81` from `manufacturer_return_cases` `c` union all select `c`.`ticket_id` AS `ticket_id`,`s`.`prepared_at` AS `prepared_at`,'MANUFACTURER_RETURN' AS `MANUFACTURER_RETURN`,'MANUFACTURER_OUTBOUND_PREPARED' AS `MANUFACTURER_OUTBOUND_PREPARED`,`s`.`id` AS `id`,`s`.`prepared_by_user_id` AS `prepared_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,82 AS `82` from (`manufacturer_return_cases` `c` join `manufacturer_return_shipments` `s` on((`s`.`manufacturer_return_case_id` = `c`.`id`))) where (`s`.`direction` = 'OUTBOUND') union all select `c`.`ticket_id` AS `ticket_id`,`s`.`carrier_pickup_at` AS `carrier_pickup_at`,'MANUFACTURER_RETURN' AS `MANUFACTURER_RETURN`,'MANUFACTURER_CARRIER_PICKUP' AS `MANUFACTURER_CARRIER_PICKUP`,`s`.`id` AS `id`,`s`.`carrier_pickup_by_user_id` AS `carrier_pickup_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,83 AS `83` from (`manufacturer_return_cases` `c` join `manufacturer_return_shipments` `s` on((`s`.`manufacturer_return_case_id` = `c`.`id`))) where ((`s`.`direction` = 'OUTBOUND') and (`s`.`carrier_pickup_at` is not null)) union all select `c`.`ticket_id` AS `ticket_id`,`s`.`destination_received_at` AS `destination_received_at`,'MANUFACTURER_RETURN' AS `MANUFACTURER_RETURN`,'MANUFACTURER_RECEIVED' AS `MANUFACTURER_RECEIVED`,`s`.`id` AS `id`,`s`.`destination_received_by_user_id` AS `destination_received_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,84 AS `84` from (`manufacturer_return_cases` `c` join `manufacturer_return_shipments` `s` on((`s`.`manufacturer_return_case_id` = `c`.`id`))) where ((`s`.`direction` = 'OUTBOUND') and (`s`.`destination_received_at` is not null)) union all select `c`.`ticket_id` AS `ticket_id`,`o`.`created_at` AS `created_at`,'MANUFACTURER_RETURN' AS `MANUFACTURER_RETURN`,'MANUFACTURER_OUTCOME_RECORDED' AS `MANUFACTURER_OUTCOME_RECORDED`,`o`.`id` AS `id`,`o`.`created_by` AS `created_by`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,85 AS `85` from (`manufacturer_return_cases` `c` join `manufacturer_return_outcomes` `o` on((`o`.`manufacturer_return_case_id` = `c`.`id`))) union all select `c`.`ticket_id` AS `ticket_id`,`s`.`prepared_at` AS `prepared_at`,'MANUFACTURER_RETURN' AS `MANUFACTURER_RETURN`,'MANUFACTURER_RETURN_PREPARED' AS `MANUFACTURER_RETURN_PREPARED`,`s`.`id` AS `id`,`s`.`prepared_by_user_id` AS `prepared_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,86 AS `86` from (`manufacturer_return_cases` `c` join `manufacturer_return_shipments` `s` on((`s`.`manufacturer_return_case_id` = `c`.`id`))) where (`s`.`direction` = 'RETURN') union all select `c`.`ticket_id` AS `ticket_id`,`s`.`carrier_pickup_at` AS `carrier_pickup_at`,'MANUFACTURER_RETURN' AS `MANUFACTURER_RETURN`,'MANUFACTURER_RETURN_CARRIER_PICKUP' AS `MANUFACTURER_RETURN_CARRIER_PICKUP`,`s`.`id` AS `id`,`s`.`carrier_pickup_by_user_id` AS `carrier_pickup_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,87 AS `87` from (`manufacturer_return_cases` `c` join `manufacturer_return_shipments` `s` on((`s`.`manufacturer_return_case_id` = `c`.`id`))) where ((`s`.`direction` = 'RETURN') and (`s`.`carrier_pickup_at` is not null)) union all select `c`.`ticket_id` AS `ticket_id`,`s`.`destination_received_at` AS `destination_received_at`,'MANUFACTURER_RETURN' AS `MANUFACTURER_RETURN`,'MANUFACTURER_RETURN_RECEIVED' AS `MANUFACTURER_RETURN_RECEIVED`,`s`.`id` AS `id`,`s`.`destination_received_by_user_id` AS `destination_received_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,88 AS `88` from (`manufacturer_return_cases` `c` join `manufacturer_return_shipments` `s` on((`s`.`manufacturer_return_case_id` = `c`.`id`))) where ((`s`.`direction` = 'RETURN') and (`s`.`destination_received_at` is not null)) union all select `c`.`ticket_id` AS `ticket_id`,(case when (`o`.`outcome_code` = 'REPAIRED_ORIGINAL') then `returned`.`destination_received_at` else `o`.`created_at` end) AS `Name_exp_431`,'MANUFACTURER_RETURN' AS `MANUFACTURER_RETURN`,(case `o`.`outcome_code` when 'REPAIRED_ORIGINAL' then 'MANUFACTURER_REPAIR_COMPLETED' when 'REPLACEMENT_SUPPLIED' then 'MANUFACTURER_REPLACEMENT_RECEIVED' when 'WARRANTY_REJECTED' then 'MANUFACTURER_WARRANTY_REJECTED' else 'MANUFACTURER_BER_RECORDED' end) AS `Name_exp_433`,`o`.`id` AS `id`,`o`.`created_by` AS `created_by`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,89 AS `89` from ((`manufacturer_return_cases` `c` join `manufacturer_return_outcomes` `o` on((`o`.`manufacturer_return_case_id` = `c`.`id`))) left join `manufacturer_return_shipments` `returned` on(((`returned`.`manufacturer_return_case_id` = `c`.`id`) and (`returned`.`direction` = 'RETURN')))) where ((`o`.`outcome_code` <> 'REPAIRED_ORIGINAL') or (`returned`.`destination_received_at` is not null)) union all select `c`.`ticket_id` AS `ticket_id`,`c`.`created_at` AS `created_at`,'PERMANENT_REPLACEMENT' AS `PERMANENT_REPLACEMENT`,'PERMANENT_REPLACEMENT_STARTED' AS `PERMANENT_REPLACEMENT_STARTED`,`c`.`id` AS `id`,`c`.`created_by` AS `created_by`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`replacement_number` AS `replacement_number`,90 AS `90` from `permanent_replacement_cases` `c` union all select `c`.`ticket_id` AS `ticket_id`,`c`.`selected_at` AS `selected_at`,'PERMANENT_REPLACEMENT' AS `PERMANENT_REPLACEMENT`,'PERMANENT_REPLACEMENT_SELECTED' AS `PERMANENT_REPLACEMENT_SELECTED`,`c`.`id` AS `id`,`c`.`selected_by` AS `selected_by`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`replacement_number` AS `replacement_number`,91 AS `91` from `permanent_replacement_cases` `c` where (`c`.`selected_at` is not null) union all select `c`.`ticket_id` AS `ticket_id`,`c`.`completed_at` AS `completed_at`,'PERMANENT_REPLACEMENT' AS `PERMANENT_REPLACEMENT`,'PERMANENT_REPLACEMENT_COMPLETED' AS `PERMANENT_REPLACEMENT_COMPLETED`,`c`.`id` AS `id`,`c`.`completed_by` AS `completed_by`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`replacement_number` AS `replacement_number`,92 AS `92` from `permanent_replacement_cases` `c` where ((`c`.`current_status_code` = 'COMPLETED') and (`c`.`completed_at` is not null)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_ticket_activity_08d_a`
--

/*!50001 DROP VIEW IF EXISTS `v_ticket_activity_08d_a`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_ticket_activity_08d_a` AS select `v_ticket_activity`.`ticket_id` AS `ticket_id`,`v_ticket_activity`.`activity_at` AS `activity_at`,`v_ticket_activity`.`activity_type` AS `activity_type`,`v_ticket_activity`.`activity_code` AS `activity_code`,`v_ticket_activity`.`related_record_id` AS `related_record_id`,`v_ticket_activity`.`actor_user_id` AS `actor_user_id`,`v_ticket_activity`.`subject_user_id` AS `subject_user_id`,`v_ticket_activity`.`from_status_id` AS `from_status_id`,`v_ticket_activity`.`to_status_id` AS `to_status_id`,`v_ticket_activity`.`reference_code` AS `reference_code`,`v_ticket_activity`.`activity_sort_order` AS `activity_sort_order` from `v_ticket_activity` union all select `c`.`ticket_id` AS `ticket_id`,`h`.`created_at` AS `created_at`,'TEMPORARY_LOAN' AS `TEMPORARY_LOAN`,(case `h`.`to_status_code` when 'PENDING_DISTRICT_APPROVAL' then 'TEMPORARY_LOAN_REQUESTED' when 'AUTHORIZED' then 'TEMPORARY_LOAN_AUTHORIZED' when 'REJECTED' then 'TEMPORARY_LOAN_REJECTED' when 'CANCELLED' then 'TEMPORARY_LOAN_CANCELLED' end) AS `Name_exp_15`,`h`.`id` AS `id`,`h`.`actor_user_id` AS `actor_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`c`.`loan_number` AS `loan_number`,40 AS `40` from (`temporary_loan_status_history` `h` join `temporary_loan_cases` `c` on((`c`.`id` = `h`.`temporary_loan_case_id`))) where (`h`.`to_status_code` in ('PENDING_DISTRICT_APPROVAL','AUTHORIZED','REJECTED','CANCELLED')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_ticket_activity_08d_b`
--

/*!50001 DROP VIEW IF EXISTS `v_ticket_activity_08d_b`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_ticket_activity_08d_b` AS select `v_ticket_activity_08d_a`.`ticket_id` AS `ticket_id`,`v_ticket_activity_08d_a`.`activity_at` AS `activity_at`,`v_ticket_activity_08d_a`.`activity_type` AS `activity_type`,`v_ticket_activity_08d_a`.`activity_code` AS `activity_code`,`v_ticket_activity_08d_a`.`related_record_id` AS `related_record_id`,`v_ticket_activity_08d_a`.`actor_user_id` AS `actor_user_id`,`v_ticket_activity_08d_a`.`subject_user_id` AS `subject_user_id`,`v_ticket_activity_08d_a`.`from_status_id` AS `from_status_id`,`v_ticket_activity_08d_a`.`to_status_id` AS `to_status_id`,`v_ticket_activity_08d_a`.`reference_code` AS `reference_code`,`v_ticket_activity_08d_a`.`activity_sort_order` AS `activity_sort_order` from `v_ticket_activity_08d_a` union all select `loan`.`ticket_id` AS `ticket_id`,`history`.`created_at` AS `created_at`,'TEMPORARY_LOAN' AS `TEMPORARY_LOAN`,(case `history`.`to_status_code` when 'SPARE_SELECTED' then 'TEMPORARY_SPARE_SELECTED' when 'ACTIVE_LOAN' then 'TEMPORARY_LOAN_ISSUED' when 'RETURN_REQUIRED' then 'TEMPORARY_LOAN_RETURN_REQUIRED' when 'RETURNED' then 'TEMPORARY_LOAN_RETURNED' when 'CONVERSION_PENDING_HEAD_OFFICE' then 'TEMPORARY_LOAN_CONVERSION_REQUESTED' when 'CONVERTED_PERMANENT' then 'TEMPORARY_LOAN_CONVERTED_PERMANENT' end) AS `Name_exp_15`,`history`.`id` AS `id`,`history`.`actor_user_id` AS `actor_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`loan`.`loan_number` AS `loan_number`,40 AS `40` from (`temporary_loan_status_history` `history` join `temporary_loan_cases` `loan` on((`loan`.`id` = `history`.`temporary_loan_case_id`))) where (`history`.`to_status_code` in ('SPARE_SELECTED','ACTIVE_LOAN','RETURN_REQUIRED','RETURNED','CONVERSION_PENDING_HEAD_OFFICE','CONVERTED_PERMANENT')) union all select `loan`.`ticket_id` AS `ticket_id`,`decision`.`decided_at` AS `decided_at`,'TEMPORARY_LOAN' AS `TEMPORARY_LOAN`,'TEMPORARY_LOAN_CONVERSION_REJECTED' AS `TEMPORARY_LOAN_CONVERSION_REJECTED`,`decision`.`id` AS `id`,`decision`.`decided_by` AS `decided_by`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`loan`.`loan_number` AS `loan_number`,41 AS `41` from ((`temporary_loan_conversion_decisions` `decision` join `temporary_loan_conversion_requests` `request` on((`request`.`id` = `decision`.`conversion_request_id`))) join `temporary_loan_cases` `loan` on((`loan`.`id` = `request`.`temporary_loan_case_id`))) where (`decision`.`decision_code` = 'REJECT') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_ticket_activity_08d_e`
--

/*!50001 DROP VIEW IF EXISTS `v_ticket_activity_08d_e`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_ticket_activity_08d_e` AS select `v_ticket_activity_08d_b`.`ticket_id` AS `ticket_id`,`v_ticket_activity_08d_b`.`activity_at` AS `activity_at`,`v_ticket_activity_08d_b`.`activity_type` AS `activity_type`,`v_ticket_activity_08d_b`.`activity_code` AS `activity_code`,`v_ticket_activity_08d_b`.`related_record_id` AS `related_record_id`,`v_ticket_activity_08d_b`.`actor_user_id` AS `actor_user_id`,`v_ticket_activity_08d_b`.`subject_user_id` AS `subject_user_id`,`v_ticket_activity_08d_b`.`from_status_id` AS `from_status_id`,`v_ticket_activity_08d_b`.`to_status_id` AS `to_status_id`,`v_ticket_activity_08d_b`.`reference_code` AS `reference_code`,`v_ticket_activity_08d_b`.`activity_sort_order` AS `activity_sort_order` from `v_ticket_activity_08d_b` union all select `lc`.`ticket_id` AS `ticket_id`,greatest(`h`.`changed_at`,(`conversion_history`.`created_at` + interval 1 microsecond)) AS `Name_exp_13`,'LOGISTICS' AS `LOGISTICS`,'SERVICE_FULFILLED_AT_RECIPIENT' AS `SERVICE_FULFILLED_AT_RECIPIENT`,`h`.`id` AS `id`,`h`.`changed_by_user_id` AS `changed_by_user_id`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,`lc`.`logistics_number` AS `logistics_number`,45 AS `45` from (((((`logistics_status_history` `h` join `ticket_logistics_cases` `lc` on((`lc`.`id` = `h`.`logistics_case_id`))) join `logistics_statuses` `fulfilled` on((`fulfilled`.`id` = `h`.`to_status_id`))) join `permanent_replacement_cases` `pr` on(((`pr`.`logistics_case_id` = `lc`.`id`) and (`pr`.`replacement_source_type` = 'TEMPORARY_LOAN_CONVERSION')))) join `temporary_loan_cases` `loan` on((`loan`.`id` = `pr`.`temporary_loan_case_id`))) join `temporary_loan_status_history` `conversion_history` on(((`conversion_history`.`temporary_loan_case_id` = `loan`.`id`) and (`conversion_history`.`to_status_code` = 'CONVERTED_PERMANENT')))) where ((`fulfilled`.`code` = 'FULFILLED_AT_RECIPIENT') and (`h`.`reason` = 'TEMPORARY_LOAN_CONVERSION')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_ticket_current_context`
--

/*!50001 DROP VIEW IF EXISTS `v_ticket_current_context`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_ticket_current_context` AS select `t`.`id` AS `ticket_id`,`t`.`ticket_number` AS `ticket_number`,`t`.`device_id` AS `device_id`,`d`.`serial_number` AS `serial_number`,`d`.`asset_tag` AS `asset_tag`,`t`.`current_status_id` AS `current_status_id`,`ts`.`code` AS `current_status_code`,`ts`.`name` AS `current_status_name`,`t`.`origin_district_id` AS `origin_district_id`,`t`.`origin_school_id` AS `origin_school_id`,`t`.`origin_student_id` AS `origin_student_id`,`t`.`requester_type` AS `requester_type`,`ta`.`id` AS `active_assignment_id`,`ta`.`assigned_to_user_id` AS `assigned_to_user_id`,`t`.`submitted_at` AS `submitted_at`,`t`.`closed_at` AS `closed_at` from (((`tickets` `t` join `devices` `d` on((`d`.`id` = `t`.`device_id`))) join `ticket_statuses` `ts` on((`ts`.`id` = `t`.`current_status_id`))) left join `ticket_assignments` `ta` on(((`ta`.`ticket_id` = `t`.`id`) and (`ta`.`active_record_key` = 1)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_ticket_effective_device`
--

/*!50001 DROP VIEW IF EXISTS `v_ticket_effective_device`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_ticket_effective_device` AS select `lc`.`ticket_id` AS `ticket_id`,`lc`.`id` AS `logistics_case_id`,`lc`.`device_id` AS `original_device_id`,(case when isnull(`prc`.`id`) then `lc`.`device_id` else `prc`.`replacement_device_id` end) AS `effective_device_id`,(case when (`prc`.`replacement_source_type` = 'TEMPORARY_LOAN_CONVERSION') then 'TEMPORARY_LOAN_CONVERSION' when isnull(`prc`.`id`) then 'ORIGINAL_DEVICE' else 'PERMANENT_REPLACEMENT' end) AS `device_source`,`prc`.`id` AS `replacement_case_id`,`prc`.`replacement_number` AS `replacement_number`,`prc`.`temporary_loan_case_id` AS `temporary_loan_case_id`,`prc`.`completed_at` AS `replacement_completed_at`,`prc`.`exception_case_id` AS `exception_case_id`,`ec`.`current_status_code` AS `exception_status_code`,`prc`.`replacement_source_type` AS `replacement_source_type` from ((`ticket_logistics_cases` `lc` left join `permanent_replacement_cases` `prc` on((`prc`.`id` = (select `p`.`id` from `permanent_replacement_cases` `p` where ((`p`.`logistics_case_id` = `lc`.`id`) and (`p`.`current_status_code` = 'COMPLETED')) order by `p`.`completed_at` desc,`p`.`id` desc limit 1)))) left join `repair_exception_cases` `ec` on((`ec`.`id` = `prc`.`exception_case_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_ticket_operational_metrics`
--

/*!50001 DROP VIEW IF EXISTS `v_ticket_operational_metrics`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `v_ticket_operational_metrics` AS select `t`.`id` AS `ticket_id`,`t`.`ticket_number` AS `ticket_number`,`t`.`device_id` AS `device_id`,`t`.`origin_district_id` AS `origin_district_id`,`t`.`origin_school_id` AS `origin_school_id`,`t`.`origin_student_id` AS `origin_student_id`,`t`.`requester_type` AS `requester_type`,`t`.`current_status_id` AS `current_status_id`,`ts`.`code` AS `current_status_code`,`ts`.`name` AS `current_status_name`,`ts`.`is_terminal` AS `is_terminal`,`t`.`submitted_at` AS `submitted_at`,`t`.`closed_at` AS `closed_at`,`ctx`.`active_assignment_id` AS `active_assignment_id`,`ctx`.`assigned_to_user_id` AS `assigned_to_user_id`,`active_assignment`.`assigned_at` AS `assigned_at`,`status_times`.`latest_status_at` AS `latest_status_at`,`diagnosis_times`.`first_diagnosed_at` AS `first_diagnosed_at`,`diagnosis_times`.`latest_diagnosed_at` AS `latest_diagnosed_at`,`approval_times`.`first_approved_at` AS `first_approved_at`,(case when (timestampdiff(MINUTE,`t`.`submitted_at`,(case when ((`ts`.`is_terminal` = 1) and (`t`.`closed_at` is not null)) then `t`.`closed_at` else now() end)) >= 0) then timestampdiff(MINUTE,`t`.`submitted_at`,(case when ((`ts`.`is_terminal` = 1) and (`t`.`closed_at` is not null)) then `t`.`closed_at` else now() end)) else NULL end) AS `ticket_age_minutes`,(case when (`ts`.`is_terminal` = 1) then NULL when (timestampdiff(MINUTE,`t`.`submitted_at`,now()) < 0) then NULL when (timestampdiff(MINUTE,`t`.`submitted_at`,now()) < 1440) then 'LESS_THAN_24_HOURS' when (timestampdiff(MINUTE,`t`.`submitted_at`,now()) < 4320) then 'ONE_TO_THREE_DAYS' when (timestampdiff(MINUTE,`t`.`submitted_at`,now()) < 10080) then 'FOUR_TO_SEVEN_DAYS' else 'MORE_THAN_SEVEN_DAYS' end) AS `ticket_age_bucket`,(case when ((`status_times`.`latest_status_at` is not null) and (timestampdiff(MINUTE,`status_times`.`latest_status_at`,now()) >= 0)) then timestampdiff(MINUTE,`status_times`.`latest_status_at`,now()) else NULL end) AS `current_status_age_minutes`,(case when ((`active_assignment`.`assigned_at` is not null) and (timestampdiff(MINUTE,`active_assignment`.`assigned_at`,now()) >= 0)) then timestampdiff(MINUTE,`active_assignment`.`assigned_at`,now()) else NULL end) AS `assignment_age_minutes`,(case when ((`diagnosis_times`.`first_diagnosed_at` is not null) and (timestampdiff(MINUTE,`t`.`submitted_at`,`diagnosis_times`.`first_diagnosed_at`) >= 0)) then timestampdiff(MINUTE,`t`.`submitted_at`,`diagnosis_times`.`first_diagnosed_at`) else NULL end) AS `time_to_first_diagnosis_minutes`,(case when ((`approval_times`.`first_approved_at` is not null) and (timestampdiff(MINUTE,`t`.`submitted_at`,`approval_times`.`first_approved_at`) >= 0)) then timestampdiff(MINUTE,`t`.`submitted_at`,`approval_times`.`first_approved_at`) else NULL end) AS `time_to_approval_minutes` from ((((((`laptop_tickets_db`.`tickets` `t` join `laptop_tickets_db`.`ticket_statuses` `ts` on((`ts`.`id` = `t`.`current_status_id`))) join `laptop_tickets_db`.`v_ticket_current_context` `ctx` on((`ctx`.`ticket_id` = `t`.`id`))) left join `laptop_tickets_db`.`ticket_assignments` `active_assignment` on(((`active_assignment`.`id` = `ctx`.`active_assignment_id`) and (`active_assignment`.`active_record_key` = 1)))) left join (select `laptop_tickets_db`.`ticket_status_history`.`ticket_id` AS `ticket_id`,max(`laptop_tickets_db`.`ticket_status_history`.`changed_at`) AS `latest_status_at` from `laptop_tickets_db`.`ticket_status_history` group by `laptop_tickets_db`.`ticket_status_history`.`ticket_id`) `status_times` on((`status_times`.`ticket_id` = `t`.`id`))) left join (select `laptop_tickets_db`.`ticket_diagnoses`.`ticket_id` AS `ticket_id`,min(`laptop_tickets_db`.`ticket_diagnoses`.`diagnosed_at`) AS `first_diagnosed_at`,max(`laptop_tickets_db`.`ticket_diagnoses`.`diagnosed_at`) AS `latest_diagnosed_at` from `laptop_tickets_db`.`ticket_diagnoses` group by `laptop_tickets_db`.`ticket_diagnoses`.`ticket_id`) `diagnosis_times` on((`diagnosis_times`.`ticket_id` = `t`.`id`))) left join (select `laptop_tickets_db`.`ticket_district_approvals`.`ticket_id` AS `ticket_id`,min(`laptop_tickets_db`.`ticket_district_approvals`.`decided_at`) AS `first_approved_at` from `laptop_tickets_db`.`ticket_district_approvals` where (`laptop_tickets_db`.`ticket_district_approvals`.`decision` = 'APPROVED') group by `laptop_tickets_db`.`ticket_district_approvals`.`ticket_id`) `approval_times` on((`approval_times`.`ticket_id` = `t`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-22 17:40:42
