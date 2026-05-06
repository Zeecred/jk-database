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
-- Table structure for table `credit_engine_proposals`
--

DROP TABLE IF EXISTS `credit_engine_proposals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `credit_engine_proposals` (
  `id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `employment_relationships_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `external_id` varchar(50) NOT NULL,
  `fund_name` varchar(255) NOT NULL,
  `installments` int(11) NOT NULL,
  `disbursement_value` decimal(10,2) NOT NULL,
  `estimated_financed_value` decimal(10,2) NOT NULL,
  `estimated_nominal_value` decimal(10,2) NOT NULL,
  `monthly_interest_percent` decimal(8,4) NOT NULL,
  `estimated_cet_monthly_interest_rate` decimal(10,2) NOT NULL,
  `premium_value` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `net_value` decimal(10,2) NOT NULL,
  `insured` tinyint(1) NOT NULL DEFAULT 0,
  `insured_value` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_CREDIT_ENGINE_PROPOSALS_EMPLOYMENT_RELATIONSHIPS_ID_IDX` (`employment_relationships_id`),
  KEY `IDX_CREDIT_ENGINE_PROPOSALS_EXTERNAL_ID` (`external_id`),
  CONSTRAINT `FK_CREDIT_ENGINE_PROPOSALS_EMPLOYMENT_RELATIONSHIPS` FOREIGN KEY (`employment_relationships_id`) REFERENCES `employment_relationships` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
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

-- Dump completed on 2026-01-23 17:12:46
