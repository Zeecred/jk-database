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
-- Table structure for table `proposal_installments`
--

DROP TABLE IF EXISTS `proposal_installments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `proposal_installments` (
  `id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `proposal_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `number` smallint(5) unsigned NOT NULL DEFAULT 1,
  `due_date` date DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `iof_amount` decimal(10,2) DEFAULT NULL,
  `status` enum('OPEN','PAID','LATE','CANCELLED') NOT NULL DEFAULT 'OPEN',
  `paid_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_PROPOSAL_INSTALLMENTS_PROPOSAL_ID_IDX` (`proposal_id`),
  KEY `UNQ_PROPOSAL_INSTALLMENTS_PROPOSAL_ID_NUMBER` (`proposal_id`,`number`,`created_at`),
  KEY `IDX_PROPOSAL_INSTALLMENTS_DELETED_DUE` (`proposal_id`,`deleted_at`,`due_date`),
  KEY `IDX_PROPOSAL_INSTALLMENTS_DELETED_NUMBER` (`proposal_id`,`deleted_at`,`number`),
  KEY `IDX_PROPOSAL_INSTALLMENTS_STATUS_DELETED_DUE` (`status`,`deleted_at`,`due_date`),
  KEY `IDX_PROPOSAL_INSTALLMENTS_PAIT_AT_PROPOSAL` (`paid_at`,`proposal_id`),
  KEY `IDX_PROPOSAL_INSTALLMENTS_DELETED_AT` (`deleted_at`),
  CONSTRAINT `FK_PROPOSAL_INSTALLMENTS_PROPOSALS` FOREIGN KEY (`proposal_id`) REFERENCES `proposals` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
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

-- Dump completed on 2026-01-23 17:07:10
