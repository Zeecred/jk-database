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
-- Table structure for table `proposals`
--

DROP TABLE IF EXISTS `proposals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `proposals` (
  `id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `customer_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `commission_installment_id` char(36) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `loan_settings_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `user_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `proposal_status_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `principal_amount` decimal(10,2) NOT NULL,
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
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_PROPOSALS_CUSTOMER_ID_IDX` (`customer_id`),
  KEY `FK_PROPOSALS_COMMISSION_INSTALLMENT_ID_IDX` (`commission_installment_id`),
  KEY `FK_PROPOSALS_LOAN_SETTINGS_ID_IDX` (`loan_settings_id`),
  KEY `FK_PROPOSALS_USER_ID_IDX` (`user_id`),
  KEY `IDX_PROPOSALS_DELETED_AT` (`deleted_at`),
  KEY `IDX_PROPOSALS_CREATED_AT` (`created_at`),
  KEY `IDX_PROPOSALS_USER_ID_DELETED_AT_CREATED_AT` (`user_id`,`deleted_at`,`created_at`),
  KEY `IDX_PROPOSALS_COMMISSION_INSTALLMENT_ID_CREATED_AT` (`commission_installment_id`,`created_at`),
  KEY `IDX_PROPOSALS_LOAN_SETTINGS_ID_CREATED_AT` (`loan_settings_id`,`created_at`),
  KEY `IDX_PROPOSALS_TOTAL_AMOUNT` (`total_amount`),
  KEY `FK_PROPOSALS_PROPOSAL_STATUS_ID_IDX` (`proposal_status_id`),
  CONSTRAINT `FK_PROPOSALS_COMMISSIONS_INSTALLMENTS` FOREIGN KEY (`commission_installment_id`) REFERENCES `commissions_installments` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_PROPOSALS_CUSTOMERS` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_PROPOSALS_LOANS_SETTINGS` FOREIGN KEY (`loan_settings_id`) REFERENCES `loans_settings` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_PROPOSALS_PROPOSAL_STATUS_ID` FOREIGN KEY (`proposal_status_id`) REFERENCES `proposal_status` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_PROPOSALS_USERS` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
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

-- Dump completed on 2026-01-23 17:07:07
