-- MySQL dump 10.13  Distrib 8.0.26, for Win64 (x86_64)
--
-- Host: localhost    Database: store_db
-- ------------------------------------------------------
-- Server version	8.0.26

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
-- Table structure for table `cart_tb`
--

DROP TABLE IF EXISTS `cart_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_tb` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `count` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_product` (`user_id`,`product_id`),
  KEY `fk_cart_product` (`product_id`),
  CONSTRAINT `fk_cart_product` FOREIGN KEY (`product_id`) REFERENCES `product_tb` (`id`),
  CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `user_tb` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_tb`
--

LOCK TABLES `cart_tb` WRITE;
/*!40000 ALTER TABLE `cart_tb` DISABLE KEYS */;
INSERT INTO `cart_tb` VALUES (2,1,3,1),(3,1,7,1),(4,1,6,1),(5,1,2,1);
/*!40000 ALTER TABLE `cart_tb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorite_tb`
--

DROP TABLE IF EXISTS `favorite_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorite_tb` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_product_fav` (`user_id`,`product_id`),
  KEY `fk_fav_product` (`product_id`),
  CONSTRAINT `fk_fav_product` FOREIGN KEY (`product_id`) REFERENCES `product_tb` (`id`),
  CONSTRAINT `fk_fav_user` FOREIGN KEY (`user_id`) REFERENCES `user_tb` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite_tb`
--

LOCK TABLES `favorite_tb` WRITE;
/*!40000 ALTER TABLE `favorite_tb` DISABLE KEYS */;
INSERT INTO `favorite_tb` VALUES (5,1,2);
/*!40000 ALTER TABLE `favorite_tb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_tb`
--

DROP TABLE IF EXISTS `product_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_tb` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` text,
  `company` text,
  `price` int DEFAULT NULL,
  `img_url` text,
  `category` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_tb`
--

LOCK TABLES `product_tb` WRITE;
/*!40000 ALTER TABLE `product_tb` DISABLE KEYS */;
INSERT INTO `product_tb` VALUES (1,'상품5','B사',2345,'img\\products\\1.png','카테고리2'),(2,'상품7','B사',3000,'img\\products\\2.png','카테고리2'),(3,'상품10','B사',3300,'img\\products\\3.png','카테고리4'),(4,'상품14','C사',1230,'img\\products\\4.png','카테고리3'),(5,'상품3','C사',5678,'img\\products\\4.png','카테고리3'),(6,'상품13','B사',9900,'img\\products\\3.png','카테고리2'),(7,'상품15','C사',3450,'img\\products\\6.png','카테고리1'),(8,'상품1','A사',5792,'img\\products\\6.png','카테고리1'),(9,'상품8','B사',7000,'img\\products\\5.png','카테고리3'),(10,'상품15','B사',4560,'img\\products\\1.png','카테고리2'),(11,'상품11','A사',1234,'img\\products\\4.png','카테고리2'),(12,'상품4','B사',3900,'img\\products\\3.png','카테고리4'),(13,'상품1','C사',2354,'img\\products\\4.png','카테고리2'),(14,'상품11','B사',5500,'img\\products\\5.png','카테고리2'),(15,'상품6','A사',2109,'img\\products\\3.png','카테고리2'),(16,'상품4','A사',6789,'img\\products\\6.png','카테고리3'),(17,'상품1','B사',8123,'img\\products\\3.png','카테고리3'),(18,'상품12','A사',9876,'img\\products\\5.png','카테고리4'),(19,'상품2','A사',4589,'img\\products\\1.png','카테고리4'),(20,'상품14','A사',4000,'img\\products\\3.png','카테고리4'),(21,'상품12','C사',6600,'img\\products\\6.png','카테고리3'),(22,'상품10','A사',3456,'img\\products\\2.png','카테고리3'),(23,'상품9','C사',8000,'img\\products\\6.png','카테고리4'),(24,'상품13','C사',8800,'img\\products\\2.png','카테고리1'),(25,'상품7','C사',1000,'img\\products\\6.png','카테고리1'),(26,'상품16','A사',9000,'img\\products\\6.png','카테고리1'),(27,'상품8','C사',5000,'img\\products\\4.png','카테고리1'),(28,'상품12','B사',7700,'img\\products\\1.png','카테고리4'),(29,'상품15','A사',6000,'img\\products\\5.png','카테고리2'),(30,'상품2','B사',3456,'img\\products\\1.png','카테고리4'),(31,'상품6','B사',5678,'img\\products\\4.png','카테고리3'),(32,'상품9','A사',8765,'img\\products\\6.png','카테고리4'),(33,'상품13','A사',2000,'img\\products\\1.png','카테고리3'),(34,'상품11','C사',4400,'img\\products\\4.png','카테고리1'),(35,'상품2','C사',9231,'img\\products\\2.png','카테고리2'),(36,'상품6','C사',7890,'img\\products\\3.png','카테고리1'),(37,'상품9','B사',1100,'img\\products\\1.png','카테고리2'),(38,'상품14','B사',2340,'img\\products\\5.png','카테고리4'),(39,'상품15','C사',3450,'img\\products\\6.png','카테고리1'),(40,'상품4','C사',1500,'img\\products\\1.png','카테고리3'),(41,'상품8','A사',4100,'img\\products\\4.png','카테고리2'),(42,'상품3','A사',1234,'img\\products\\5.png','카테고리1'),(43,'상품3','B사',9876,'img\\products\\5.png','카테고리4');
/*!40000 ALTER TABLE `product_tb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_tb`
--

DROP TABLE IF EXISTS `user_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_tb` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_tb`
--

LOCK TABLES `user_tb` WRITE;
/*!40000 ALTER TABLE `user_tb` DISABLE KEYS */;
INSERT INTO `user_tb` VALUES (1,'chan1111','Qwer1234!');
/*!40000 ALTER TABLE `user_tb` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-08 22:08:23
