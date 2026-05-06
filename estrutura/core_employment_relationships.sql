/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.6.22-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: core
-- ------------------------------------------------------
-- Server version	10.11.13-MariaDB-0ubuntu0.24.04.1-log

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
-- Table structure for table `employment_relationships`
--

DROP TABLE IF EXISTS `employment_relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `employment_relationships` (
  `id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `employment_consults_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `status` enum('pending','processing','finished','failed') NOT NULL DEFAULT 'pending',
  `external_id` varchar(50) NOT NULL,
  `registration_number` varchar(50) NOT NULL,
  `eligible` tinyint(1) NOT NULL,
  `due_total` decimal(10,2) NOT NULL COMMENT 'valor devido total',
  `margin_base` decimal(10,2) NOT NULL COMMENT 'valor da margem base',
  `margin_aval` decimal(10,2) NOT NULL COMMENT 'valor da margem disponível',
  `admission_date` date NOT NULL,
  `termination_date` date NOT NULL,
  `company_name` varchar(255) NOT NULL,
  `company_document` varchar(20) NOT NULL,
  `company_activity_start_date` timestamp NOT NULL,
  `name` varchar(255) NOT NULL,
  `document` varchar(20) NOT NULL,
  `political_exposition` varchar(50) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `birth_date` date NOT NULL,
  `mother_name` varchar(255) NOT NULL,
  `worker_category_code` varchar(36) NOT NULL,
  `termination_reason_code` varchar(36) NOT NULL,
  `nationality_code` varchar(36) NOT NULL,
  `occupation_code` varchar(36) NOT NULL,
  `economic_activity_code` varchar(36) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `fail_message` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_EMPLOYMENT_RELATIONSHIPS_EMPLOYMENT_CONSULTS_ID_IDX` (`employment_consults_id`),
  KEY `IDX_EMPLOYMENT_RELATIONSHIPS_EXTERNAL_ID` (`external_id`),
  KEY `IDX_EMPLOYMENT_RELATIONSHIPS_STATUS` (`status`),
  CONSTRAINT `FK_EMPLOYMENT_RELATIONSHIPS_EMPLOYMENT_CONSULTS` FOREIGN KEY (`employment_consults_id`) REFERENCES `employment_consults` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-23 17:11:30
