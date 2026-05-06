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
-- Table structure for table `loans_settings`
--

DROP TABLE IF EXISTS `loans_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `loans_settings` (
  `id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `loan_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `debit_issuer_id` char(36) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `credit_engine_id` char(36) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `payroll_margin_register_id` char(36) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `investment_funds_id` char(36) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL,
  `complience_partner_id` char(36) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_LOANS_SETTINGS_LOANS_IDX` (`loan_id`),
  KEY `IDX_LOANS_SETTINGS_NAME` (`name`),
  KEY `FK_LOANS_SETTINGS_DEBIT_ISSUERS` (`debit_issuer_id`),
  KEY `FK_LOANS_SETTINGS_CREDIT_ENGINES_IDX` (`credit_engine_id`),
  KEY `FK_LOANS_SETTINGS_PAYROLL_MARGIN_REGISTRARS_IDX` (`payroll_margin_register_id`),
  KEY `FK_LOANS_SETTINGS_INVESTMENT_FUNDS_IDX` (`investment_funds_id`),
  KEY `IDX_LOANS_SETTINGS_CREATED_AT` (`created_at`),
  KEY `IDX_LOANS_SETTINGS_DELETED_AT` (`deleted_at`),
  KEY `FK_LOANS_SETTINGS_COMPLIENCE_PRTNER_IDX` (`complience_partner_id`),
  CONSTRAINT `FK_LOANS_SETTINGS_COMPLIENCE_PRTNER_IDX` FOREIGN KEY (`complience_partner_id`) REFERENCES `complience_partners` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `FK_LOANS_SETTINGS_CREDIT_ENGINES` FOREIGN KEY (`credit_engine_id`) REFERENCES `credit_engines` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_LOANS_SETTINGS_DEBIT_ISSUERS` FOREIGN KEY (`debit_issuer_id`) REFERENCES `debit_issuers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_LOANS_SETTINGS_INVESTMENT_FUNDS` FOREIGN KEY (`investment_funds_id`) REFERENCES `investment_funds` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_LOANS_SETTINGS_LOANS` FOREIGN KEY (`loan_id`) REFERENCES `loans` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_LOANS_SETTINGS_PAYROLL_MARGIN_REGISTRARS` FOREIGN KEY (`payroll_margin_register_id`) REFERENCES `payroll_margin_registrars` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
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

-- Dump completed on 2026-01-23 17:10:44
