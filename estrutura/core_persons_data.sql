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
-- Table structure for table `persons_data`
--

DROP TABLE IF EXISTS `persons_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `persons_data` (
  `id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `person_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `key` varchar(45) NOT NULL,
  `value` varchar(255) NOT NULL,
  `type` enum('boolean','int','decimal','date','datetime','string') NOT NULL DEFAULT 'string',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNQ_PERSONS_DATA` (`person_id`,`key`),
  KEY `IDX_PERSONS_DATA_CREATED_AT` (`created_at`),
  KEY `IDX_PERSONS_DATA_VALUE` (`value`),
  KEY `IDX_PERSONS_DATA_PERSON_ID_VALUE` (`person_id`,`value`),
  CONSTRAINT `FK_PERSONS_DATA_PERSONS` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabela destinada a armazenar dados não normalizados, como chave valor, nessa tabela irei armazenar os dados: \n\nObs: Para armazenamento de datas parciais vamos completar os campos restantes com 0 (Ex: 2025-01-00 00:00:00) para manter o padrão ISO8601.\n\n* ————— Persons Individual —————\n1 - data de nascimento,\n2 - nacionalidade\n3 - sexo\n4 - estado civil\n5 - renda mensal\n6 - bandeira se é aposentado\n\n1 - birth_date: date \n2 - nationality: string\n3 - gender: int\n   1 - Masculino\n   2 - Feminino\n   3 - Não Informar\n4 - marital_status: int\n   1 - Casado\n   2 - Solteiro\n   3 - Viúvo\n   4 - Desquitado\n   5 - Divorciado\n   6 - Não Informado\n   7 - Separado Judicialmente\n   8 - União Estável\n   9 - Outro\n5 - monthly_income: decimal\n6 - is_retired: int\n\n* ————— Persons Business ————————\n1 - data de funcacao,\n2 - capital social\n3 - tipo de controle\n4 - tipo de instituição\n5 - optante do simples\n\n1 - foundation_date: date \n2 - share_capital: decinal\n3 - control_type: int\n   1 - Privado\n   2 - Público Federal\n   3 - Público Estadual ou Distrital\n   4 - Público Municipal\n4 - control_nature: int\n   1 - Instituição Financeira\n   2 - Investidores Institucionais\n   3 - Outras Pessoas Jurídicas\n   4 - Pessoa Física\n5 - is_simple: boolean';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-23 17:07:23
