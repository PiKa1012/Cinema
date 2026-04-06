-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: cinema
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `t_hall`
--

DROP TABLE IF EXISTS `t_hall`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_hall` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `col_count` int DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `row_count` int DEFAULT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_3hpiw5dmb8034wwsm36jjioow` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_hall`
--

LOCK TABLES `t_hall` WRITE;
/*!40000 ALTER TABLE `t_hall` DISABLE KEYS */;
INSERT INTO `t_hall` VALUES (1,10,'2026-04-04 13:56:30.105719','测试放映厅',8,'普通'),(2,3,'2026-04-04 16:29:32.752801','vip放映厅',3,'VIP'),(3,4,'2026-04-04 17:11:07.417875','放映厅一号',4,'普通');
/*!40000 ALTER TABLE `t_hall` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_movie`
--

DROP TABLE IF EXISTS `t_movie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_movie` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `actors` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `description` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `director` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `duration` int DEFAULT NULL,
  `genre` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `poster` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rating` decimal(38,2) DEFAULT NULL,
  `release_date` date DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_movie`
--

LOCK TABLES `t_movie` WRITE;
/*!40000 ALTER TABLE `t_movie` DISABLE KEYS */;
INSERT INTO `t_movie` VALUES (1,'皮卡',NULL,'测试','皮卡',123,'科幻','/uploads/14fdb843-9a64-449a-8f40-c488aac35fab.jpg',NULL,NULL,'showing','测试'),(6,'皮卡丘',NULL,'hello呀','皮卡丘',124,'科幻','/uploads/efea7258-4695-4d28-be6c-c7df5b951931.jpg',NULL,NULL,'showing','皮卡世界'),(7,'YES',NULL,'pika','NICE',222,'科幻','/uploads/efea7258-4695-4d28-be6c-c7df5b951931.jpg',NULL,NULL,'showing','Home'),(8,'番茄',NULL,'测试用例','番茄',23,'科幻','/uploads/efea7258-4695-4d28-be6c-c7df5b951931.jpg',NULL,NULL,'coming','番茄'),(9,'葡萄',NULL,'测试','葡萄',32,'科幻','/uploads/efea7258-4695-4d28-be6c-c7df5b951931.jpg',NULL,NULL,'off','葡萄'),(12,'y','2026-04-04 20:28:13.021878','她','y',2,'科幻','/uploads/efea7258-4695-4d28-be6c-c7df5b951931.jpg',NULL,NULL,'showing','y'),(13,'h','2026-04-04 20:50:12.978493','测试','g',11,'科幻','/uploads/efea7258-4695-4d28-be6c-c7df5b951931.jpg',NULL,NULL,'showing','g'),(15,'j','2026-04-04 21:02:57.872862','突然','h',22,'科幻','/uploads/efea7258-4695-4d28-be6c-c7df5b951931.jpg',NULL,NULL,'showing','t'),(17,'2','2026-04-04 21:19:41.717843','2','2',2,'2','/uploads/efea7258-4695-4d28-be6c-c7df5b951931.jpg',NULL,NULL,'showing','2'),(18,'jk','2026-04-04 21:20:43.859560','w','hj',11,'科幻','/uploads/efea7258-4695-4d28-be6c-c7df5b951931.jpg',NULL,NULL,'showing','jk'),(19,'看','2026-04-04 21:29:28.102684','222','看',1,'科幻','/uploads/efea7258-4695-4d28-be6c-c7df5b951931.jpg',NULL,NULL,'showing','看'),(21,'2','2026-04-04 22:22:35.905003','233','2',23,'2','/uploads/a3cb8fd0-6984-40ac-80f1-72cad8683392.jpg',NULL,NULL,'showing','2333332'),(22,'45','2026-04-04 22:24:01.358269','2333','454',19,'科幻','/uploads/69596b43-305e-413b-910c-38f1050f3bcb.jpg',NULL,NULL,'showing','455');
/*!40000 ALTER TABLE `t_movie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_order`
--

DROP TABLE IF EXISTS `t_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) DEFAULT NULL,
  `order_no` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_price` decimal(38,2) NOT NULL,
  `session_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_fjie9ovlyccw6819bahkq6b59` (`order_no`),
  KEY `FK8oygvy4iqdsvpnptr9upnp3y8` (`session_id`),
  KEY `FKho2r4qgj3txpy8964fnla95ub` (`user_id`),
  CONSTRAINT `FK8oygvy4iqdsvpnptr9upnp3y8` FOREIGN KEY (`session_id`) REFERENCES `t_session` (`id`),
  CONSTRAINT `FKho2r4qgj3txpy8964fnla95ub` FOREIGN KEY (`user_id`) REFERENCES `t_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_order`
--

LOCK TABLES `t_order` WRITE;
/*!40000 ALTER TABLE `t_order` DISABLE KEYS */;
INSERT INTO `t_order` VALUES (1,'2026-04-04 13:57:16.769068','d31f717e3097412985ed17038172fa9a','confirmed',400.00,1,7),(2,'2026-04-04 14:10:30.634446','f53141288f2b4039a6da206aa16756bf','confirmed',112.00,5,7),(3,'2026-04-04 14:33:06.934687','695884feda634ca09f263886b810c3b7','confirmed',56.00,5,7),(4,'2026-04-04 14:33:11.325574','075b8dbc5ddf4a0e94d07888efd76abf','confirmed',112.00,6,7),(5,'2026-04-04 16:00:16.645394','d1d60da994c34d9f97b579964db7c7b5','confirmed',150.00,1,7),(6,'2026-04-04 16:23:05.551080','fc794e09fa6245558bd29dd5ee2876a4','confirmed',42.00,5,7),(7,'2026-04-04 16:26:24.247346','124efb2ea7fe4281883afd77679800eb','confirmed',150.00,1,8),(8,'2026-04-04 16:30:20.950217','b4ec5ae119354e5aab316bcce73a7c9e','confirmed',891.00,7,8),(9,'2026-04-04 16:30:37.540759','9c416024414344d191e514b44966dea3','confirmed',445.50,7,7),(10,'2026-04-04 17:15:43.171854','dbb36bf1a4d9466aabed756c0d701b35','confirmed',84.00,11,2),(11,'2026-04-04 17:15:48.471193','caf219cc97ae4d8e86db9d1534e96e66','confirmed',67.50,9,2),(12,'2026-04-04 18:09:40.657500','b98d9f59c36c4b25a8d4df9428a35ff7','confirmed',24.00,8,9),(13,'2026-04-04 18:19:30.672970','c042b18894e3467cafe281a4cfff0582','confirmed',540.00,9,2),(14,'2026-04-04 21:50:16.007256','7e5370fe872a437592a0b79676727a1b','confirmed',28.00,5,10),(15,'2026-04-04 22:14:08.031302','b1e50c41c30b4a3b950934d076311d74','confirmed',56.00,5,11),(16,'2026-04-04 22:14:19.873190','14499002dfc34fe9846904a34c46e07f','confirmed',50.00,1,7),(17,'2026-04-05 01:28:59.892813','55eb3a8ed85445fb84dcaed912fb6081','confirmed',84.00,11,7);
/*!40000 ALTER TABLE `t_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_order_seat`
--

DROP TABLE IF EXISTS `t_order_seat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_order_seat` (
  `order_id` bigint NOT NULL,
  `seat_id` bigint NOT NULL,
  KEY `FKr7pcnt7hyyrvwheqsj4y6srhx` (`seat_id`),
  KEY `FK46e2dee3ecgbl067s14grbqot` (`order_id`),
  CONSTRAINT `FK46e2dee3ecgbl067s14grbqot` FOREIGN KEY (`order_id`) REFERENCES `t_order` (`id`),
  CONSTRAINT `FKr7pcnt7hyyrvwheqsj4y6srhx` FOREIGN KEY (`seat_id`) REFERENCES `t_seat` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_order_seat`
--

LOCK TABLES `t_order_seat` WRITE;
/*!40000 ALTER TABLE `t_order_seat` DISABLE KEYS */;
INSERT INTO `t_order_seat` VALUES (1,90),(1,99),(1,108),(1,117),(1,126),(1,135),(1,144),(1,153),(2,809),(2,810),(2,800),(2,799),(3,841),(3,842),(4,902),(4,912),(5,136),(5,125),(6,844),(7,84),(7,85),(7,86),(8,939),(8,942),(8,938),(8,941),(8,937),(8,940),(9,936),(9,935),(9,934),(10,1008),(11,982),(12,973),(13,981),(13,983),(13,980),(13,979),(13,978),(13,975),(13,976),(13,977),(14,817),(15,788),(15,789),(16,139),(17,1007);
/*!40000 ALTER TABLE `t_order_seat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_seat`
--

DROP TABLE IF EXISTS `t_seat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_seat` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `available` bit(1) DEFAULT NULL,
  `col_num` int NOT NULL,
  `row_num` int NOT NULL,
  `seat_no` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hall_id` bigint NOT NULL,
  `session_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKcqxyg4djshecdh7cr1deaxxe8` (`hall_id`),
  KEY `FKp7i880mf87chken2i65f1e090` (`session_id`),
  CONSTRAINT `FKcqxyg4djshecdh7cr1deaxxe8` FOREIGN KEY (`hall_id`) REFERENCES `t_hall` (`id`),
  CONSTRAINT `FKp7i880mf87chken2i65f1e090` FOREIGN KEY (`session_id`) REFERENCES `t_session` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1009 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_seat`
--

LOCK TABLES `t_seat` WRITE;
/*!40000 ALTER TABLE `t_seat` DISABLE KEYS */;
INSERT INTO `t_seat` VALUES (1,_binary '',1,1,'A1','普通',1,NULL),(2,_binary '',2,1,'A2','普通',1,NULL),(3,_binary '',3,1,'A3','普通',1,NULL),(4,_binary '',4,1,'A4','普通',1,NULL),(5,_binary '',5,1,'A5','普通',1,NULL),(6,_binary '',6,1,'A6','普通',1,NULL),(7,_binary '',7,1,'A7','普通',1,NULL),(8,_binary '',8,1,'A8','普通',1,NULL),(9,_binary '',9,1,'A9','普通',1,NULL),(10,_binary '',10,1,'A10','普通',1,NULL),(11,_binary '',1,2,'B1','普通',1,NULL),(12,_binary '',2,2,'B2','普通',1,NULL),(13,_binary '',3,2,'B3','普通',1,NULL),(14,_binary '',4,2,'B4','普通',1,NULL),(15,_binary '',5,2,'B5','普通',1,NULL),(16,_binary '',6,2,'B6','普通',1,NULL),(17,_binary '',7,2,'B7','普通',1,NULL),(18,_binary '',8,2,'B8','普通',1,NULL),(19,_binary '',9,2,'B9','普通',1,NULL),(20,_binary '',10,2,'B10','普通',1,NULL),(21,_binary '',1,3,'C1','普通',1,NULL),(22,_binary '',2,3,'C2','普通',1,NULL),(23,_binary '',3,3,'C3','普通',1,NULL),(24,_binary '',4,3,'C4','普通',1,NULL),(25,_binary '',5,3,'C5','普通',1,NULL),(26,_binary '',6,3,'C6','普通',1,NULL),(27,_binary '',7,3,'C7','普通',1,NULL),(28,_binary '',8,3,'C8','普通',1,NULL),(29,_binary '',9,3,'C9','普通',1,NULL),(30,_binary '',10,3,'C10','普通',1,NULL),(31,_binary '',1,4,'D1','普通',1,NULL),(32,_binary '',2,4,'D2','普通',1,NULL),(33,_binary '',3,4,'D3','普通',1,NULL),(34,_binary '',4,4,'D4','普通',1,NULL),(35,_binary '',5,4,'D5','普通',1,NULL),(36,_binary '',6,4,'D6','普通',1,NULL),(37,_binary '',7,4,'D7','普通',1,NULL),(38,_binary '',8,4,'D8','普通',1,NULL),(39,_binary '',9,4,'D9','普通',1,NULL),(40,_binary '',10,4,'D10','普通',1,NULL),(41,_binary '',1,5,'E1','普通',1,NULL),(42,_binary '',2,5,'E2','普通',1,NULL),(43,_binary '',3,5,'E3','普通',1,NULL),(44,_binary '',4,5,'E4','普通',1,NULL),(45,_binary '',5,5,'E5','普通',1,NULL),(46,_binary '',6,5,'E6','普通',1,NULL),(47,_binary '',7,5,'E7','普通',1,NULL),(48,_binary '',8,5,'E8','普通',1,NULL),(49,_binary '',9,5,'E9','普通',1,NULL),(50,_binary '',10,5,'E10','普通',1,NULL),(51,_binary '',1,6,'F1','普通',1,NULL),(52,_binary '',2,6,'F2','普通',1,NULL),(53,_binary '',3,6,'F3','普通',1,NULL),(54,_binary '',4,6,'F4','普通',1,NULL),(55,_binary '',5,6,'F5','普通',1,NULL),(56,_binary '',6,6,'F6','普通',1,NULL),(57,_binary '',7,6,'F7','普通',1,NULL),(58,_binary '',8,6,'F8','普通',1,NULL),(59,_binary '',9,6,'F9','普通',1,NULL),(60,_binary '',10,6,'F10','普通',1,NULL),(61,_binary '',1,7,'G1','普通',1,NULL),(62,_binary '',2,7,'G2','普通',1,NULL),(63,_binary '',3,7,'G3','普通',1,NULL),(64,_binary '',4,7,'G4','普通',1,NULL),(65,_binary '',5,7,'G5','普通',1,NULL),(66,_binary '',6,7,'G6','普通',1,NULL),(67,_binary '',7,7,'G7','普通',1,NULL),(68,_binary '',8,7,'G8','普通',1,NULL),(69,_binary '',9,7,'G9','普通',1,NULL),(70,_binary '',10,7,'G10','普通',1,NULL),(71,_binary '',1,8,'H1','普通',1,NULL),(72,_binary '',2,8,'H2','普通',1,NULL),(73,_binary '',3,8,'H3','普通',1,NULL),(74,_binary '',4,8,'H4','普通',1,NULL),(75,_binary '',5,8,'H5','普通',1,NULL),(76,_binary '',6,8,'H6','普通',1,NULL),(77,_binary '',7,8,'H7','普通',1,NULL),(78,_binary '',8,8,'H8','普通',1,NULL),(79,_binary '',9,8,'H9','普通',1,NULL),(80,_binary '',10,8,'H10','普通',1,NULL),(81,_binary '',1,1,'A1','VIP',1,1),(82,_binary '',2,1,'A2','普通',1,1),(83,_binary '',3,1,'A3','普通',1,1),(84,_binary '',4,1,'A4','普通',1,1),(85,_binary '',5,1,'A5','普通',1,1),(86,_binary '',6,1,'A6','普通',1,1),(87,_binary '',7,1,'A7','普通',1,1),(88,_binary '',8,1,'A8','普通',1,1),(89,_binary '',9,1,'A9','普通',1,1),(90,_binary '',10,1,'A10','普通',1,1),(91,_binary '',1,2,'B1','普通',1,1),(92,_binary '',2,2,'B2','VIP',1,1),(93,_binary '',3,2,'B3','普通',1,1),(94,_binary '',4,2,'B4','普通',1,1),(95,_binary '',5,2,'B5','普通',1,1),(96,_binary '',6,2,'B6','普通',1,1),(97,_binary '',7,2,'B7','普通',1,1),(98,_binary '',8,2,'B8','普通',1,1),(99,_binary '',9,2,'B9','普通',1,1),(100,_binary '',10,2,'B10','普通',1,1),(101,_binary '',1,3,'C1','普通',1,1),(102,_binary '',2,3,'C2','普通',1,1),(103,_binary '',3,3,'C3','VIP',1,1),(104,_binary '',4,3,'C4','普通',1,1),(105,_binary '',5,3,'C5','普通',1,1),(106,_binary '',6,3,'C6','普通',1,1),(107,_binary '',7,3,'C7','普通',1,1),(108,_binary '',8,3,'C8','普通',1,1),(109,_binary '',9,3,'C9','普通',1,1),(110,_binary '',10,3,'C10','普通',1,1),(111,_binary '',1,4,'D1','普通',1,1),(112,_binary '',2,4,'D2','普通',1,1),(113,_binary '',3,4,'D3','普通',1,1),(114,_binary '',4,4,'D4','VIP',1,1),(115,_binary '',5,4,'D5','普通',1,1),(116,_binary '',6,4,'D6','普通',1,1),(117,_binary '',7,4,'D7','普通',1,1),(118,_binary '',8,4,'D8','普通',1,1),(119,_binary '',9,4,'D9','普通',1,1),(120,_binary '',10,4,'D10','普通',1,1),(121,_binary '',1,5,'E1','普通',1,1),(122,_binary '',2,5,'E2','普通',1,1),(123,_binary '',3,5,'E3','普通',1,1),(124,_binary '',4,5,'E4','普通',1,1),(125,_binary '',5,5,'E5','VIP',1,1),(126,_binary '',6,5,'E6','普通',1,1),(127,_binary '',7,5,'E7','普通',1,1),(128,_binary '',8,5,'E8','普通',1,1),(129,_binary '',9,5,'E9','普通',1,1),(130,_binary '',10,5,'E10','普通',1,1),(131,_binary '',1,6,'F1','普通',1,1),(132,_binary '',2,6,'F2','普通',1,1),(133,_binary '',3,6,'F3','普通',1,1),(134,_binary '',4,6,'F4','普通',1,1),(135,_binary '',5,6,'F5','普通',1,1),(136,_binary '',6,6,'F6','VIP',1,1),(137,_binary '',7,6,'F7','普通',1,1),(138,_binary '',8,6,'F8','普通',1,1),(139,_binary '',9,6,'F9','普通',1,1),(140,_binary '',10,6,'F10','普通',1,1),(141,_binary '',1,7,'G1','普通',1,1),(142,_binary '',2,7,'G2','普通',1,1),(143,_binary '',3,7,'G3','普通',1,1),(144,_binary '',4,7,'G4','普通',1,1),(145,_binary '',5,7,'G5','普通',1,1),(146,_binary '',6,7,'G6','普通',1,1),(147,_binary '',7,7,'G7','VIP',1,1),(148,_binary '',8,7,'G8','普通',1,1),(149,_binary '',9,7,'G9','普通',1,1),(150,_binary '',10,7,'G10','普通',1,1),(151,_binary '',1,8,'H1','普通',1,1),(152,_binary '',2,8,'H2','普通',1,1),(153,_binary '',3,8,'H3','普通',1,1),(154,_binary '',4,8,'H4','普通',1,1),(155,_binary '',5,8,'H5','普通',1,1),(156,_binary '',6,8,'H6','普通',1,1),(157,_binary '',7,8,'H7','普通',1,1),(158,_binary '',8,8,'H8','VIP',1,1),(159,_binary '',9,8,'H9','普通',1,1),(160,_binary '',10,8,'H10','普通',1,1),(765,_binary '',1,1,'A1','普通',1,5),(766,_binary '',2,1,'A2','普通',1,5),(767,_binary '',3,1,'A3','普通',1,5),(768,_binary '',4,1,'A4','普通',1,5),(769,_binary '',5,1,'A5','普通',1,5),(770,_binary '',6,1,'A6','普通',1,5),(771,_binary '',7,1,'A7','普通',1,5),(772,_binary '',8,1,'A8','普通',1,5),(773,_binary '',9,1,'A9','普通',1,5),(774,_binary '',10,1,'A10','VIP',1,5),(775,_binary '',1,2,'B1','普通',1,5),(776,_binary '',2,2,'B2','普通',1,5),(777,_binary '',3,2,'B3','普通',1,5),(778,_binary '',4,2,'B4','普通',1,5),(779,_binary '',5,2,'B5','普通',1,5),(780,_binary '',6,2,'B6','普通',1,5),(781,_binary '',7,2,'B7','普通',1,5),(782,_binary '',8,2,'B8','普通',1,5),(783,_binary '',9,2,'B9','普通',1,5),(784,_binary '',10,2,'B10','VIP',1,5),(785,_binary '',1,3,'C1','普通',1,5),(786,_binary '',2,3,'C2','普通',1,5),(787,_binary '',3,3,'C3','普通',1,5),(788,_binary '',4,3,'C4','普通',1,5),(789,_binary '',5,3,'C5','普通',1,5),(790,_binary '',6,3,'C6','普通',1,5),(791,_binary '',7,3,'C7','普通',1,5),(792,_binary '',8,3,'C8','普通',1,5),(793,_binary '',9,3,'C9','普通',1,5),(794,_binary '',10,3,'C10','VIP',1,5),(795,_binary '',1,4,'D1','普通',1,5),(796,_binary '',2,4,'D2','普通',1,5),(797,_binary '',3,4,'D3','普通',1,5),(798,_binary '',4,4,'D4','普通',1,5),(799,_binary '',5,4,'D5','普通',1,5),(800,_binary '',6,4,'D6','普通',1,5),(801,_binary '',7,4,'D7','普通',1,5),(802,_binary '',8,4,'D8','普通',1,5),(803,_binary '',9,4,'D9','普通',1,5),(804,_binary '',10,4,'D10','VIP',1,5),(805,_binary '',1,5,'E1','普通',1,5),(806,_binary '',2,5,'E2','普通',1,5),(807,_binary '',3,5,'E3','普通',1,5),(808,_binary '',4,5,'E4','普通',1,5),(809,_binary '',5,5,'E5','普通',1,5),(810,_binary '',6,5,'E6','普通',1,5),(811,_binary '',7,5,'E7','普通',1,5),(812,_binary '',8,5,'E8','普通',1,5),(813,_binary '',9,5,'E9','普通',1,5),(814,_binary '',10,5,'E10','VIP',1,5),(815,_binary '',1,6,'F1','普通',1,5),(816,_binary '',2,6,'F2','普通',1,5),(817,_binary '',3,6,'F3','普通',1,5),(818,_binary '',4,6,'F4','普通',1,5),(819,_binary '',5,6,'F5','普通',1,5),(820,_binary '',6,6,'F6','普通',1,5),(821,_binary '',7,6,'F7','普通',1,5),(822,_binary '',8,6,'F8','普通',1,5),(823,_binary '',9,6,'F9','普通',1,5),(824,_binary '',10,6,'F10','VIP',1,5),(825,_binary '',1,7,'G1','普通',1,5),(826,_binary '',2,7,'G2','普通',1,5),(827,_binary '',3,7,'G3','普通',1,5),(828,_binary '',4,7,'G4','普通',1,5),(829,_binary '',5,7,'G5','普通',1,5),(830,_binary '',6,7,'G6','普通',1,5),(831,_binary '',7,7,'G7','普通',1,5),(832,_binary '',8,7,'G8','普通',1,5),(833,_binary '',9,7,'G9','普通',1,5),(834,_binary '',10,7,'G10','VIP',1,5),(835,_binary '',1,8,'H1','普通',1,5),(836,_binary '',2,8,'H2','普通',1,5),(837,_binary '',3,8,'H3','普通',1,5),(838,_binary '',4,8,'H4','普通',1,5),(839,_binary '',5,8,'H5','普通',1,5),(840,_binary '',6,8,'H6','普通',1,5),(841,_binary '',7,8,'H7','普通',1,5),(842,_binary '',8,8,'H8','普通',1,5),(843,_binary '',9,8,'H9','普通',1,5),(844,_binary '',10,8,'H10','VIP',1,5),(845,_binary '',1,1,'A1','普通',1,6),(846,_binary '',2,1,'A2','普通',1,6),(847,_binary '',3,1,'A3','普通',1,6),(848,_binary '',4,1,'A4','VIP',1,6),(849,_binary '',5,1,'A5','普通',1,6),(850,_binary '',6,1,'A6','普通',1,6),(851,_binary '',7,1,'A7','普通',1,6),(852,_binary '',8,1,'A8','普通',1,6),(853,_binary '',9,1,'A9','普通',1,6),(854,_binary '',10,1,'A10','普通',1,6),(855,_binary '',1,2,'B1','普通',1,6),(856,_binary '',2,2,'B2','普通',1,6),(857,_binary '',3,2,'B3','普通',1,6),(858,_binary '',4,2,'B4','VIP',1,6),(859,_binary '',5,2,'B5','普通',1,6),(860,_binary '',6,2,'B6','普通',1,6),(861,_binary '',7,2,'B7','普通',1,6),(862,_binary '',8,2,'B8','普通',1,6),(863,_binary '',9,2,'B9','普通',1,6),(864,_binary '',10,2,'B10','普通',1,6),(865,_binary '',1,3,'C1','普通',1,6),(866,_binary '',2,3,'C2','普通',1,6),(867,_binary '',3,3,'C3','普通',1,6),(868,_binary '',4,3,'C4','VIP',1,6),(869,_binary '',5,3,'C5','普通',1,6),(870,_binary '',6,3,'C6','普通',1,6),(871,_binary '',7,3,'C7','普通',1,6),(872,_binary '',8,3,'C8','普通',1,6),(873,_binary '',9,3,'C9','普通',1,6),(874,_binary '',10,3,'C10','普通',1,6),(875,_binary '',1,4,'D1','普通',1,6),(876,_binary '',2,4,'D2','普通',1,6),(877,_binary '',3,4,'D3','普通',1,6),(878,_binary '',4,4,'D4','VIP',1,6),(879,_binary '',5,4,'D5','普通',1,6),(880,_binary '',6,4,'D6','普通',1,6),(881,_binary '',7,4,'D7','普通',1,6),(882,_binary '',8,4,'D8','普通',1,6),(883,_binary '',9,4,'D9','普通',1,6),(884,_binary '',10,4,'D10','普通',1,6),(885,_binary '',1,5,'E1','普通',1,6),(886,_binary '',2,5,'E2','普通',1,6),(887,_binary '',3,5,'E3','普通',1,6),(888,_binary '',4,5,'E4','VIP',1,6),(889,_binary '',5,5,'E5','普通',1,6),(890,_binary '',6,5,'E6','普通',1,6),(891,_binary '',7,5,'E7','普通',1,6),(892,_binary '',8,5,'E8','普通',1,6),(893,_binary '',9,5,'E9','普通',1,6),(894,_binary '',10,5,'E10','普通',1,6),(895,_binary '',1,6,'F1','普通',1,6),(896,_binary '',2,6,'F2','普通',1,6),(897,_binary '',3,6,'F3','普通',1,6),(898,_binary '',4,6,'F4','VIP',1,6),(899,_binary '',5,6,'F5','普通',1,6),(900,_binary '',6,6,'F6','普通',1,6),(901,_binary '',7,6,'F7','普通',1,6),(902,_binary '',8,6,'F8','普通',1,6),(903,_binary '',9,6,'F9','普通',1,6),(904,_binary '',10,6,'F10','普通',1,6),(905,_binary '',1,7,'G1','普通',1,6),(906,_binary '',2,7,'G2','普通',1,6),(907,_binary '',3,7,'G3','普通',1,6),(908,_binary '',4,7,'G4','VIP',1,6),(909,_binary '',5,7,'G5','普通',1,6),(910,_binary '',6,7,'G6','普通',1,6),(911,_binary '',7,7,'G7','普通',1,6),(912,_binary '',8,7,'G8','普通',1,6),(913,_binary '',9,7,'G9','普通',1,6),(914,_binary '',10,7,'G10','普通',1,6),(915,_binary '',1,8,'H1','普通',1,6),(916,_binary '',2,8,'H2','普通',1,6),(917,_binary '',3,8,'H3','普通',1,6),(918,_binary '',4,8,'H4','VIP',1,6),(919,_binary '',5,8,'H5','普通',1,6),(920,_binary '',6,8,'H6','普通',1,6),(921,_binary '',7,8,'H7','普通',1,6),(922,_binary '',8,8,'H8','普通',1,6),(923,_binary '',9,8,'H9','普通',1,6),(924,_binary '',10,8,'H10','普通',1,6),(925,_binary '',1,1,'A1','VIP',2,NULL),(926,_binary '',2,1,'A2','VIP',2,NULL),(927,_binary '',3,1,'A3','VIP',2,NULL),(928,_binary '',1,2,'B1','VIP',2,NULL),(929,_binary '',2,2,'B2','VIP',2,NULL),(930,_binary '',3,2,'B3','VIP',2,NULL),(931,_binary '',1,3,'C1','VIP',2,NULL),(932,_binary '',2,3,'C2','VIP',2,NULL),(933,_binary '',3,3,'C3','VIP',2,NULL),(934,_binary '',1,1,'A1','VIP',2,7),(935,_binary '',2,1,'A2','VIP',2,7),(936,_binary '',3,1,'A3','VIP',2,7),(937,_binary '',1,2,'B1','VIP',2,7),(938,_binary '',2,2,'B2','VIP',2,7),(939,_binary '',3,2,'B3','VIP',2,7),(940,_binary '',1,3,'C1','VIP',2,7),(941,_binary '',2,3,'C2','VIP',2,7),(942,_binary '',3,3,'C3','VIP',2,7),(943,_binary '',1,1,'A1','普通',3,NULL),(944,_binary '',2,1,'A2','普通',3,NULL),(945,_binary '',3,1,'A3','普通',3,NULL),(946,_binary '',4,1,'A4','普通',3,NULL),(947,_binary '',1,2,'B1','普通',3,NULL),(948,_binary '',2,2,'B2','普通',3,NULL),(949,_binary '',3,2,'B3','普通',3,NULL),(950,_binary '',4,2,'B4','普通',3,NULL),(951,_binary '',1,3,'C1','普通',3,NULL),(952,_binary '',2,3,'C2','普通',3,NULL),(953,_binary '',3,3,'C3','普通',3,NULL),(954,_binary '',4,3,'C4','普通',3,NULL),(955,_binary '',1,4,'D1','普通',3,NULL),(956,_binary '',2,4,'D2','普通',3,NULL),(957,_binary '',3,4,'D3','普通',3,NULL),(958,_binary '',4,4,'D4','普通',3,NULL),(959,_binary '',1,1,'A1','普通',3,8),(960,_binary '',2,1,'A2','普通',3,8),(961,_binary '',3,1,'A3','普通',3,8),(962,_binary '',4,1,'A4','普通',3,8),(963,_binary '',1,2,'B1','普通',3,8),(964,_binary '',2,2,'B2','普通',3,8),(965,_binary '',3,2,'B3','普通',3,8),(966,_binary '',4,2,'B4','普通',3,8),(967,_binary '',1,3,'C1','普通',3,8),(968,_binary '',2,3,'C2','普通',3,8),(969,_binary '',3,3,'C3','普通',3,8),(970,_binary '',4,3,'C4','普通',3,8),(971,_binary '',1,4,'D1','普通',3,8),(972,_binary '',2,4,'D2','普通',3,8),(973,_binary '',3,4,'D3','普通',3,8),(974,_binary '',4,4,'D4','普通',3,8),(975,_binary '',1,1,'A1','VIP',2,9),(976,_binary '',2,1,'A2','VIP',2,9),(977,_binary '',3,1,'A3','VIP',2,9),(978,_binary '',1,2,'B1','VIP',2,9),(979,_binary '',2,2,'B2','VIP',2,9),(980,_binary '',3,2,'B3','VIP',2,9),(981,_binary '',1,3,'C1','VIP',2,9),(982,_binary '',2,3,'C2','VIP',2,9),(983,_binary '',3,3,'C3','VIP',2,9),(984,_binary '',1,1,'A1','普通',3,10),(985,_binary '',2,1,'A2','普通',3,10),(986,_binary '',3,1,'A3','普通',3,10),(987,_binary '',4,1,'A4','普通',3,10),(988,_binary '',1,2,'B1','普通',3,10),(989,_binary '',2,2,'B2','普通',3,10),(990,_binary '',3,2,'B3','普通',3,10),(991,_binary '',4,2,'B4','普通',3,10),(992,_binary '',1,3,'C1','普通',3,10),(993,_binary '',2,3,'C2','普通',3,10),(994,_binary '',3,3,'C3','普通',3,10),(995,_binary '',4,3,'C4','普通',3,10),(996,_binary '',1,4,'D1','普通',3,10),(997,_binary '',2,4,'D2','普通',3,10),(998,_binary '',3,4,'D3','普通',3,10),(999,_binary '',4,4,'D4','普通',3,10),(1000,_binary '',1,1,'A1','VIP',2,11),(1001,_binary '',2,1,'A2','VIP',2,11),(1002,_binary '',3,1,'A3','VIP',2,11),(1003,_binary '',1,2,'B1','VIP',2,11),(1004,_binary '',2,2,'B2','VIP',2,11),(1005,_binary '',3,2,'B3','VIP',2,11),(1006,_binary '',1,3,'C1','VIP',2,11),(1007,_binary '',2,3,'C2','VIP',2,11),(1008,_binary '',3,3,'C3','VIP',2,11);
/*!40000 ALTER TABLE `t_seat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_session`
--

DROP TABLE IF EXISTS `t_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_session` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) DEFAULT NULL,
  `end_time` datetime(6) NOT NULL,
  `price` decimal(38,2) NOT NULL,
  `start_time` datetime(6) NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hall_id` bigint NOT NULL,
  `movie_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK35ujm1wgbvcyrakmbptolgsww` (`hall_id`),
  KEY `FKryfkpn73rs44x8ryn13vf5acs` (`movie_id`),
  CONSTRAINT `FK35ujm1wgbvcyrakmbptolgsww` FOREIGN KEY (`hall_id`) REFERENCES `t_hall` (`id`),
  CONSTRAINT `FKryfkpn73rs44x8ryn13vf5acs` FOREIGN KEY (`movie_id`) REFERENCES `t_movie` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_session`
--

LOCK TABLES `t_session` WRITE;
/*!40000 ALTER TABLE `t_session` DISABLE KEYS */;
INSERT INTO `t_session` VALUES (1,'2026-04-04 13:56:54.700749','2026-04-04 09:01:00.000000',50.00,'2026-04-04 09:01:00.000000','available',1,1),(5,'2026-04-04 14:08:58.087383','2026-04-19 18:08:00.000000',28.00,'2026-04-19 18:08:00.000000','available',1,1),(6,'2026-04-04 14:10:06.816860','2026-04-26 18:10:00.000000',56.00,'2026-04-26 18:10:00.000000','available',1,1),(7,'2026-04-04 16:29:46.042971','2026-04-26 16:31:00.000000',99.00,'2026-04-26 16:31:00.000000','available',2,6),(8,'2026-04-04 17:11:28.536603','2026-04-12 17:11:00.000000',24.00,'2026-04-12 17:11:00.000000','available',3,7),(9,'2026-04-04 17:11:37.284351','2026-04-17 17:11:00.000000',45.00,'2026-04-17 17:11:00.000000','available',2,6),(10,'2026-04-04 17:12:00.763028','2026-04-18 17:11:00.000000',56.00,'2026-04-18 17:11:00.000000','available',3,6),(11,'2026-04-04 17:12:23.606652','2026-04-17 17:12:00.000000',56.00,'2026-04-17 17:12:00.000000','available',2,7);
/*!40000 ALTER TABLE `t_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_user`
--

DROP TABLE IF EXISTS `t_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nickname` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_jhib4legehrm4yscx9t3lirqi` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_user`
--

LOCK TABLES `t_user` WRITE;
/*!40000 ALTER TABLE `t_user` DISABLE KEYS */;
INSERT INTO `t_user` VALUES (2,'2026-04-04 01:48:58.355373',NULL,'admin','$2a$10$zUOzsHutkaCw/.RMFM9xyOxo4qr78KcXLfMq2Cut3eATpkFMI/NYq',NULL,'ADMIN','admin'),(7,'2026-04-04 13:57:08.248205',NULL,'test','$2a$10$hemKZ/yX7lndGX78lLCJ.unZs798bjXkjkryPWUixQyDmnEy4.Jty',NULL,'USER','test'),(8,'2026-04-04 16:26:17.399764',NULL,'user','$2a$10$LzjbqdYeorf3ahvmQ2y5MOIsMu6tt2SD7mDijKobSyCR9w9L5UTTS',NULL,'USER','user'),(9,'2026-04-04 18:09:27.727828',NULL,'home1','$2a$10$z1BRWyrSxeV0RsxtVzCAgOFtRXhn08zE/yjkcol7bQ4RaKnn3ymMe',NULL,'USER','home1'),(10,'2026-04-04 21:47:45.640993',NULL,'1','$2a$10$I5Mz1Q9fgr0bqpIdVBUB/e3ZLRVA.lCQxRk4OVm3AkntfXpZMA/hm',NULL,'USER','1'),(11,'2026-04-04 22:09:56.102127',NULL,'11','$2a$10$tTg13vdwpvyhfxVpftS2ROUTiuFyqNR/zx19jfVsgNpmEH7piWbVC',NULL,'USER','11');
/*!40000 ALTER TABLE `t_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-05 11:45:53
