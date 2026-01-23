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
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `entity_type` varchar(50) NOT NULL,
  `person_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `white_label_id` char(36) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `master_id` char(36) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `promoter_id` char(36) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `seller_id` char(36) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `customer_id` char(36) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `status` enum('active','inactive','pending','deleted','suspended') NOT NULL DEFAULT 'pending',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_fe0bb3f6520ee0469504521e710` (`username`),
  KEY `IDX_USERS_PERSONS_ID` (`person_id`),
  KEY `IDX_USERS_SELLERS_ID` (`seller_id`),
  KEY `IDX_USERS_PROMOTERS_ID` (`promoter_id`),
  KEY `IDX_USERS_CUSTOMERS_ID` (`customer_id`),
  KEY `IDX_USERS_MASTERS_ID` (`master_id`),
  KEY `IDX_USERS_WHITE_LABELS_ID` (`white_label_id`),
  KEY `IDX_USERS_STATUS` (`status`),
  CONSTRAINT `FK_07e9fcb5d21c90715401da54e6a` FOREIGN KEY (`master_id`) REFERENCES `masters` (`id`),
  CONSTRAINT `FK_4db1a3a7126c295f0b238a34e35` FOREIGN KEY (`white_label_id`) REFERENCES `white_labels` (`id`),
  CONSTRAINT `FK_597f8bee971f705120ae20474a2` FOREIGN KEY (`seller_id`) REFERENCES `sellers` (`id`),
  CONSTRAINT `FK_5ed72dcd00d6e5a88c6a6ba3d18` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `FK_96e10c7d88e60613c9a76bc8da2` FOREIGN KEY (`promoter_id`) REFERENCES `promoters` (`id`),
  CONSTRAINT `FK_c7bc1ffb56c570f42053fa7503b` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
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

-- Dump completed on 2026-01-23 17:08:16
