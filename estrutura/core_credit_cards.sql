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
-- Table structure for table `credit_cards`
--

DROP TABLE IF EXISTS `credit_cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `credit_cards` (
  `id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `customer_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `token` varchar(255) DEFAULT NULL,
  `number` char(16) NOT NULL COMMENT 'últimos 4 dígitos para exibição',
  `credit_limit` decimal(8,2) NOT NULL COMMENT 'limite total',
  `brand` enum('mastercard','visa','elo') DEFAULT NULL COMMENT 'Visa, MasterCard, Elo',
  `cardholder_name` varchar(255) NOT NULL COMMENT 'Nome do Titular do Cartão',
  `expiry_month` smallint(6) NOT NULL COMMENT 'Mês do Vencimento do cartão',
  `expiry_year` smallint(6) NOT NULL COMMENT 'Ano do Vencimento do cartão 4 dígitos (ex: 2029)',
  `statement_day` smallint(6) NOT NULL COMMENT 'dia de fechamento da fatura',
  `due_day` smallint(6) NOT NULL COMMENT 'dia de vencimento da fatura',
  `is_active` tinyint(4) NOT NULL DEFAULT 1 COMMENT '0 ou 1',
  `type` enum('physical','virtual') NOT NULL DEFAULT 'virtual',
  `status` enum('locked','unlocked') NOT NULL DEFAULT 'locked',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_CREDIT_CARDS_CUSTOMER_ID_IDX` (`customer_id`),
  KEY `IDX_CREDIT_CARDS_TOKEN` (`token`),
  KEY `IDX_CREDIT_CARDS_LAST4` (`number`),
  KEY `IDX_CREDIT_CARDS_DELETED_AT` (`deleted_at`),
  KEY `IDX_CREDIT_CARDS_IS_ACTIVE` (`is_active`),
  KEY `IDX_CREDIT_CARDS_TYPE` (`type`),
  KEY `IDX_CREDIT_CARDS_STATUS` (`status`),
  CONSTRAINT `FK_CREDIT_CARDS_CUSTOMERS` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
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

-- Dump completed on 2026-01-23 17:07:36
