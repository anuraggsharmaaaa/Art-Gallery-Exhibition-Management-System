-- MySQL dump 10.13  Distrib 9.4.0, for macos15.4 (arm64)
--
-- Host: localhost    Database: ArtGallery
-- ------------------------------------------------------
-- Server version	9.4.0

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
-- Table structure for table `Artists`
--

DROP TABLE IF EXISTS `Artists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Artists` (
  `ArtistID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Nationality` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ArtistID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Artists`
--

LOCK TABLES `Artists` WRITE;
/*!40000 ALTER TABLE `Artists` DISABLE KEYS */;
INSERT INTO `Artists` VALUES (1,'Vincent van Gogh','Dutch'),(2,'Pablo Picasso','Spanish'),(3,'Leonardo da Vinci','Italian'),(4,'Frida Kahlo','Mexican'),(5,'Test Artist','American');
/*!40000 ALTER TABLE `Artists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Artworks`
--

DROP TABLE IF EXISTS `Artworks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Artworks` (
  `ArtworkID` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(255) NOT NULL,
  `Year` int DEFAULT NULL,
  `Price` decimal(10,2) NOT NULL,
  `Status` enum('Available','Sold') DEFAULT 'Available',
  `ArtistID` int DEFAULT NULL,
  `Description` text,
  PRIMARY KEY (`ArtworkID`),
  KEY `ArtistID` (`ArtistID`),
  CONSTRAINT `artworks_ibfk_1` FOREIGN KEY (`ArtistID`) REFERENCES `Artists` (`ArtistID`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Artworks`
--

LOCK TABLES `Artworks` WRITE;
/*!40000 ALTER TABLE `Artworks` DISABLE KEYS */;
INSERT INTO `Artworks` VALUES (2,'Guernica',1937,7500000.00,'Available',2,'One of history\'s most powerful anti-war statements. Picasso painted this in response to the bombing of a Basque town by Nazi Germany during the Spanish Civil War.'),(3,'Mona Lisa',1503,10000000.00,'Available',3,'Arguably the most famous painting in the world, its enigmatic smile and the subject\'s mysterious identity have captivated viewers for centuries. Its fame was amplified after a major theft in 1911.'),(4,'The Persistence of Memory',1931,3000000.00,'Available',2,'Dalí described this piece as a \"hand-painted dream photograph.\" The melting clocks represent a dreamlike state where time is fluid and irrelevant.'),(5,'The Two Fridas',1939,4000000.00,'Available',4,'This double self-portrait represents Kahlo\'s dual heritage (Mexican and European) and the immense pain she felt after her divorce from fellow artist Diego Rivera.'),(6,'Café Terrace at Night',1888,6000000.00,'Available',1,'This was the first painting in which Van Gogh used his iconic, starry background. He was so enchanted by the location that he set up his easel and painted it at night.'),(7,'The Weeping Woman',1937,4500000.00,'Available',2,'A companion piece to \"Guernica,\" this work focuses on a single person\'s grief, showing the universal suffering that war inflicts on individuals, especially women and children.'),(8,'Self-Portrait with Thorn Necklace and Hummingbird',1940,3800000.00,'Available',4,'A powerful piece of symbolism. The thorn necklace represents her physical and emotional pain, while the hummingbird (a symbol of luck) is dead, yet she remains stoic.'),(9,'Salvator Mundi',1500,9000000.00,'Available',3,'Meaning \"Savior of the World,\" this depiction of Christ was lost for centuries. After its rediscovery, it became the most expensive painting ever sold at auction.');
/*!40000 ALTER TABLE `Artworks` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_AfterArtworkDelete` AFTER DELETE ON `artworks` FOR EACH ROW BEGIN
    INSERT INTO AuditLog (Action)
    VALUES (CONCAT('DELETED: Artwork "', OLD.Title, '" (ID: ', OLD.ArtworkID, ') was deleted.'));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `AuditLog`
--

DROP TABLE IF EXISTS `AuditLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AuditLog` (
  `LogID` int NOT NULL AUTO_INCREMENT,
  `Action` varchar(255) DEFAULT NULL,
  `Timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`LogID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AuditLog`
--

LOCK TABLES `AuditLog` WRITE;
/*!40000 ALTER TABLE `AuditLog` DISABLE KEYS */;
/*!40000 ALTER TABLE `AuditLog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Sales`
--

DROP TABLE IF EXISTS `Sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Sales` (
  `SaleID` int NOT NULL AUTO_INCREMENT,
  `SaleDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `SalePrice` decimal(10,2) DEFAULT NULL,
  `ArtworkID` int DEFAULT NULL,
  `UserID` int DEFAULT NULL,
  PRIMARY KEY (`SaleID`),
  UNIQUE KEY `ArtworkID` (`ArtworkID`),
  KEY `UserID` (`UserID`),
  CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`ArtworkID`) REFERENCES `Artworks` (`ArtworkID`),
  CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`UserID`) REFERENCES `Users` (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sales`
--

LOCK TABLES `Sales` WRITE;
/*!40000 ALTER TABLE `Sales` DISABLE KEYS */;
/*!40000 ALTER TABLE `Sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `UserID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Role` enum('customer','admin') NOT NULL DEFAULT 'customer',
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (1,'Admin User','admin@gallery.com','scrypt:32768:8:1$cFbJCRnZmxDbukc6$078b9153dfdcdecc86f64ab7e45bcfa2ca03bf814ffacc7960bfd3e66a9352cf9281a9f561939c7c9c36c0948a3f4d0a00dd8f8f9c8a8b8ececcc489dfc1cbc7','admin'),(2,'John Doe','john@example.com','placeholder_password','customer'),(3,'Jane Smith','jane@example.com','placeholder_password','customer'),(4,'ABC','abc@login','scrypt:32768:8:1$Bc7GCBPwRaqiRbKW$866a73ccb27b7107317b8e3dabaecb58a7cb36ae21af286a1d1ef58eef072a0fc25434f679f56e565e539407c3972ebbaad4fc16d5732d7451fd4cc972829983','customer');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'ArtGallery'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_AddArtist` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_AddArtist`(IN in_Name VARCHAR(255), IN in_Nationality VARCHAR(100))
BEGIN
    INSERT INTO Artists (Name, Nationality)
    VALUES (in_Name, in_Nationality);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_BuyArtwork` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_BuyArtwork`(IN in_UserID INT, IN in_ArtworkID INT)
BEGIN
    DECLARE current_price DECIMAL(10, 2);
    
    -- Get the price from the Artworks table
    SELECT Price INTO current_price FROM Artworks 
    WHERE ArtworkID = in_ArtworkID AND Status = 'Available';
    
    -- Only proceed if the artwork is available
    IF current_price IS NOT NULL THEN
        -- 1. Insert the sale (using UserID)
        INSERT INTO Sales (SalePrice, ArtworkID, UserID)
        VALUES (current_price, in_ArtworkID, in_UserID);
        
        -- 2. Update the artwork status
        UPDATE Artworks
        SET Status = 'Sold'
        WHERE ArtworkID = in_ArtworkID;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-05 22:05:09
