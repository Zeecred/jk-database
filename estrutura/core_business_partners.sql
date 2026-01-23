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
-- Table structure for table `business_partners`
--

DROP TABLE IF EXISTS `business_partners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_partners` (
  `id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `business_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT 'ID da empresa',
  `partner_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT 'ID do sócio, podendo ser uma outra empresa ou uma pessoa física',
  `participation_percent` decimal(5,2) NOT NULL DEFAULT 100.00 COMMENT 'Participação societária em %',
  `is_administrator` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 = sócio administrador, 0 = não',
  `entry_date` date NOT NULL COMMENT 'Data de entrada na sociedade',
  `exit_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_ENTRY_DATE_IDX` (`entry_date`),
  KEY `FK_BUSINESS_PARTNERS_BUSINESS_ID_IDX` (`business_id`),
  KEY `FK_BUSINESS_PARTNERS_PARTNER_ID_IDX` (`partner_id`),
  KEY `IDX_BUSINESS_PARTNERS_DELETED_AT` (`deleted_at`),
  CONSTRAINT `FK_BUSINESS_PARTNERS_BUSINESS` FOREIGN KEY (`business_id`) REFERENCES `persons_business` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_BUSINESS_PARTNERS_PARENT` FOREIGN KEY (`partner_id`) REFERENCES `persons` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabela para armazenamento dos sócios de uma empresa, os sócios podem ser pessoas físicas ou jurídicas';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-23 17:08:19
