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
-- Table structure for table `proposal_logs`
--

DROP TABLE IF EXISTS `proposal_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `proposal_logs` (
  `id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `proposal_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `customer_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `commission_installment_id` char(36) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `loan_settings_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `proposal_status_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `user_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `operator_id` char(36) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `principal_amount` decimal(10,2) DEFAULT NULL,
  `interest_amount` decimal(10,2) DEFAULT NULL,
  `fees_amount` decimal(10,2) DEFAULT NULL,
  `bonus_amount` decimal(10,2) DEFAULT NULL,
  `iof_amount` decimal(10,2) DEFAULT NULL,
  `total_amount` decimal(10,2) DEFAULT NULL,
  `disbursement_amount` decimal(10,2) DEFAULT NULL,
  `installments_count` smallint(5) unsigned DEFAULT 1,
  `installment_value` decimal(10,2) DEFAULT NULL,
  `monthly_rate` decimal(10,4) DEFAULT NULL,
  `cet_annual` decimal(10,4) DEFAULT NULL,
  `disbursement_type` enum('pix','ted') DEFAULT 'pix',
  `first_due_date` date DEFAULT NULL,
  `last_due_date` date DEFAULT NULL,
  `formalization_type` enum('digital','manual') DEFAULT 'digital',
  `action` enum('create','update','delete','restore','error') NOT NULL DEFAULT 'create',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `FK_PROPOSAL_LOGS_CUSTOMER_ID_IDX` (`customer_id`),
  KEY `FK_PROPOSAL_LOGS_COMMISSION_INSTALLMENT_ID_IDX` (`commission_installment_id`),
  KEY `FK_PROPOSAL_LOGS_LOAN_SETTINGS_ID_IDX` (`loan_settings_id`),
  KEY `FK_PROPOSAL_LOGS_USER_ID_IDX` (`user_id`),
  KEY `IDX_PROPOSAL_LOGS_CREATED_AT` (`created_at`),
  KEY `IDX_PROPOSAL_LOGS_USER_ID_CREATED_AT` (`user_id`,`created_at`),
  KEY `IDX_PROPOSAL_LOGS_COMMISSION_INSTALLMENT_ID_CREATED_AT` (`commission_installment_id`,`created_at`),
  KEY `IDX_PROPOSAL_LOGS_LOAN_SETTINGS_ID_CREATED_AT` (`loan_settings_id`,`created_at`),
  KEY `IDX_PROPOSAL_LOGS_TOTAL_AMOUNT` (`total_amount`),
  KEY `FK_PROPOSAL_LOGS_PROPOSAL_STATUS_ID_IDX` (`proposal_status_id`),
  KEY `FK_PROPOSAL_LOGS_OPERATOR_ID_IDX` (`operator_id`),
  KEY `FK_PROPOSAL_LOGS_PROPOSAL_ID_IDX` (`proposal_id`),
  CONSTRAINT `FK_PROPOSAL_LOGS_COMMISSIONS_INSTALLMENTS` FOREIGN KEY (`commission_installment_id`) REFERENCES `commissions_installments` (`id`),
  CONSTRAINT `FK_PROPOSAL_LOGS_CUSTOMERS` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  CONSTRAINT `FK_PROPOSAL_LOGS_LOANS_SETTINGS` FOREIGN KEY (`loan_settings_id`) REFERENCES `loans_settings` (`id`),
  CONSTRAINT `FK_PROPOSAL_LOGS_OPERATORS` FOREIGN KEY (`operator_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FK_PROPOSAL_LOGS_PROPOSALS` FOREIGN KEY (`proposal_id`) REFERENCES `proposals` (`id`),
  CONSTRAINT `FK_PROPOSAL_LOGS_STATUS` FOREIGN KEY (`proposal_status_id`) REFERENCES `proposal_status` (`id`),
  CONSTRAINT `FK_PROPOSAL_LOGS_USERS` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
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

-- Dump completed on 2026-01-23 17:10:18
