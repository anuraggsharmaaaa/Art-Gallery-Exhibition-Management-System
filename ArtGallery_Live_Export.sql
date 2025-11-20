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
-- Current Database: `ArtGallery`
--

/*!40000 DROP DATABASE IF EXISTS `ArtGallery`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ArtGallery` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `ArtGallery`;

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
  `CommissionRate` decimal(4,2) DEFAULT '0.30',
  PRIMARY KEY (`ArtistID`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Artists`
--

LOCK TABLES `Artists` WRITE;
/*!40000 ALTER TABLE `Artists` DISABLE KEYS */;
INSERT INTO `Artists` VALUES (1,'Vincent van Gogh','Dutch',0.30),(2,'Pablo Picasso','Spanish',0.40),(3,'Leonardo da Vinci','Italian',0.50),(4,'Frida Kahlo','Mexican',0.35),(5,'Johannes Vermeer','Dutch',0.30),(6,'Edvard Munch','Norwegian',0.25),(7,'Sandro Botticelli','Italian',0.50),(8,'Rembrandt','Dutch',0.45),(9,'Claude Monet','French',0.30),(10,'Gustav Klimt','Austrian',0.30),(11,'Grant Wood','American',0.20),(12,'Salvador Dalí','Spanish',0.45),(13,'Georgia O\'Keeffe','American',0.25),(14,'Caravaggio','Italian',0.60);
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
  `Description` text,
  `ArtistID` int DEFAULT NULL,
  PRIMARY KEY (`ArtworkID`),
  KEY `ArtistID` (`ArtistID`),
  FULLTEXT KEY `Title` (`Title`,`Description`),
  CONSTRAINT `artworks_ibfk_1` FOREIGN KEY (`ArtistID`) REFERENCES `Artists` (`ArtistID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Artworks`
--

LOCK TABLES `Artworks` WRITE;
/*!40000 ALTER TABLE `Artworks` DISABLE KEYS */;
INSERT INTO `Artworks` VALUES (1,'The Starry Night',1889,'Iconic view from the asylum.',1),(2,'Guernica',1937,'A powerful anti-war statement.',2),(3,'Mona Lisa',1503,'The most famous portrait.',3),(4,'The Two Fridas',1939,'A double self-portrait.',4),(5,'The Persistence of Memory',1931,'Melting clocks in a dreamscape.',2),(6,'Girl with a Pearl Earring',1665,'Mona Lisa of the North.',5),(7,'The Scream',1893,'Symbolizes existential anxiety.',6),(8,'The Birth of Venus',1486,'A cornerstone of the Renaissance.',7),(9,'The Night Watch',1642,'Dramatic use of light and shadow.',8),(10,'Water Lilies',1919,'Obsession with light and reflection.',9),(11,'The Kiss',1908,'Highpoint of Klimt\'s \"Golden Period\".',10),(12,'American Gothic',1930,'Stoic farmer and his daughter.',11),(13,'The Elephants',1948,'Surrealist depiction of long-legged elephants.',12),(14,'Jimson Weed',1936,'Iconic large-scale flower painting.',13),(15,'The Calling of St. Matthew',1600,'A masterpiece of chiaroscuro.',14),(16,'David with the Head of Goliath',1610,'A dark, psychological self-portrait.',14),(17,'Ram\'s Head White Hollyhock and Little Hills',1935,'A symbol of the American desert.',13),(18,'Landscape with Butterflies',1956,'A surrealist landscape by Dalí.',12);
/*!40000 ALTER TABLE `Artworks` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AuditLog`
--

LOCK TABLES `AuditLog` WRITE;
/*!40000 ALTER TABLE `AuditLog` DISABLE KEYS */;
INSERT INTO `AuditLog` VALUES (1,'New Ticket Sale: TicketID 1 sold to UserID 5 for GalleryID 1','2025-11-13 04:21:47'),(2,'New Sale: InventoryID 1 sold to UserID 5','2025-11-13 06:16:18'),(3,'New Sale: InventoryID 8 sold to UserID 5','2025-11-13 06:16:32'),(4,'New Ticket Sale: TicketID 2 sold to UserID 5 for GalleryID 1','2025-11-13 06:16:48'),(5,'New Sale: InventoryID 9 sold to UserID 5','2025-11-14 08:44:41');
/*!40000 ALTER TABLE `AuditLog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DailyRevenueReport`
--

DROP TABLE IF EXISTS `DailyRevenueReport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DailyRevenueReport` (
  `ReportID` int NOT NULL AUTO_INCREMENT,
  `ReportDate` date DEFAULT NULL,
  `GalleryID` int DEFAULT NULL,
  `ArtRevenue` decimal(12,2) DEFAULT NULL,
  `TicketRevenue` decimal(12,2) DEFAULT NULL,
  `TotalRevenue` decimal(12,2) DEFAULT NULL,
  `TotalArtSales` int DEFAULT NULL,
  `TotalTicketsSold` int DEFAULT NULL,
  PRIMARY KEY (`ReportID`),
  KEY `GalleryID` (`GalleryID`),
  CONSTRAINT `dailyrevenuereport_ibfk_1` FOREIGN KEY (`GalleryID`) REFERENCES `Galleries` (`GalleryID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DailyRevenueReport`
--

LOCK TABLES `DailyRevenueReport` WRITE;
/*!40000 ALTER TABLE `DailyRevenueReport` DISABLE KEYS */;
INSERT INTO `DailyRevenueReport` VALUES (1,'2025-11-14',1,0.00,0.00,0.00,0,0),(2,'2025-11-14',2,0.00,0.00,0.00,0,0),(3,'2025-11-14',3,0.00,0.00,0.00,0,0),(4,'2025-11-16',1,0.00,0.00,0.00,0,0),(5,'2025-11-16',2,0.00,0.00,0.00,0,0),(6,'2025-11-16',3,0.00,0.00,0.00,0,0),(7,'2025-11-18',1,0.00,0.00,0.00,0,0),(8,'2025-11-18',2,0.00,0.00,0.00,0,0),(9,'2025-11-18',3,0.00,0.00,0.00,0,0),(10,'2025-11-19',1,0.00,0.00,0.00,0,0),(11,'2025-11-19',2,0.00,0.00,0.00,0,0),(12,'2025-11-19',3,0.00,0.00,0.00,0,0);
/*!40000 ALTER TABLE `DailyRevenueReport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Exhibition_Artworks`
--

DROP TABLE IF EXISTS `Exhibition_Artworks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Exhibition_Artworks` (
  `ExhibitionID` int NOT NULL,
  `InventoryID` int NOT NULL,
  PRIMARY KEY (`ExhibitionID`,`InventoryID`),
  KEY `InventoryID` (`InventoryID`),
  CONSTRAINT `exhibition_artworks_ibfk_1` FOREIGN KEY (`ExhibitionID`) REFERENCES `Exhibitions` (`ExhibitionID`) ON DELETE CASCADE,
  CONSTRAINT `exhibition_artworks_ibfk_2` FOREIGN KEY (`InventoryID`) REFERENCES `Inventory` (`InventoryID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Exhibition_Artworks`
--

LOCK TABLES `Exhibition_Artworks` WRITE;
/*!40000 ALTER TABLE `Exhibition_Artworks` DISABLE KEYS */;
INSERT INTO `Exhibition_Artworks` VALUES (1,2),(1,3),(3,4),(3,5),(3,6),(5,11),(5,13),(5,20),(9,23);
/*!40000 ALTER TABLE `Exhibition_Artworks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Exhibitions`
--

DROP TABLE IF EXISTS `Exhibitions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Exhibitions` (
  `ExhibitionID` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(255) NOT NULL,
  `Description` text,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `GalleryID` int DEFAULT NULL,
  PRIMARY KEY (`ExhibitionID`),
  KEY `GalleryID` (`GalleryID`),
  CONSTRAINT `exhibitions_ibfk_1` FOREIGN KEY (`GalleryID`) REFERENCES `Galleries` (`GalleryID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Exhibitions`
--

LOCK TABLES `Exhibitions` WRITE;
/*!40000 ALTER TABLE `Exhibitions` DISABLE KEYS */;
INSERT INTO `Exhibitions` VALUES (1,'Picasso: War and Grief','Works from the Spanish Civil War.','2025-11-01','2025-12-15',1),(2,'Dalí\'s Dreamscape','Enter the surreal mind of Salvador Dalí.','2025-11-15','2026-02-15',1),(3,'American Modernism','O\'Keeffe and Wood in contrast.','2025-12-01','2026-03-01',1),(4,'Leaving Soon: Van Gogh','Works created in Saint-Rémy.','2025-10-01','2025-11-30',1),(5,'The Italian Masters','Da Vinci, Caravaggio, and Botticelli.','2025-11-20','2026-03-15',2),(6,'Vienna Secession','The golden works of Gustav Klimt.','2025-12-10','2026-02-20',2),(7,'Frida Kahlo: Beyond the Pain','An intimate look at her life and work.','2026-01-15','2026-05-01',2),(8,'Dutch Masters: Extended','The Golden Age of Dutch painting.','2025-10-20','2026-02-10',2),(9,'Caravaggio in Rome','A spotlight on his revolutionary use of light.','2025-11-05','2026-01-20',3),(10,'The Birth of Impressionism','Monet and the dawn of a new movement.','2025-11-25','2026-02-28',3),(11,'The Face of Anxiety','A special feature on Edvard Munch\'s \"The Scream\".','2026-02-01','2026-04-15',3),(12,'Treasures of the Louvre','A temporary display of iconic works.','2026-03-01','2026-07-01',3);
/*!40000 ALTER TABLE `Exhibitions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Galleries`
--

DROP TABLE IF EXISTS `Galleries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Galleries` (
  `GalleryID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `City` varchar(100) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `ImageURL` text,
  `Hours` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`GalleryID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Galleries`
--

LOCK TABLES `Galleries` WRITE;
/*!40000 ALTER TABLE `Galleries` DISABLE KEYS */;
INSERT INTO `Galleries` VALUES (1,'Art Gallery - New York','New York','123 Main St, NY','ny.jpeg','10:00 AM - 6:00 PM Daily'),(2,'Art Gallery - London','London','456 Gallery Rd, UK','london.jpeg','9:00 AM - 5:00 PM (Closed Tuesdays)'),(3,'Art Gallery - Paris','Paris','789 Rue de Art, FR','paris.jpeg','11:00 AM - 8:00 PM (Closed Mondays)');
/*!40000 ALTER TABLE `Galleries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Inventory`
--

DROP TABLE IF EXISTS `Inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Inventory` (
  `InventoryID` int NOT NULL AUTO_INCREMENT,
  `ArtworkID` int DEFAULT NULL,
  `GalleryID` int DEFAULT NULL,
  `Status` enum('Available','Sold','On Loan') NOT NULL DEFAULT 'Available',
  `PurchasePrice` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`InventoryID`),
  KEY `ArtworkID` (`ArtworkID`),
  KEY `GalleryID` (`GalleryID`),
  CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`ArtworkID`) REFERENCES `Artworks` (`ArtworkID`),
  CONSTRAINT `inventory_ibfk_2` FOREIGN KEY (`GalleryID`) REFERENCES `Galleries` (`GalleryID`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Inventory`
--

LOCK TABLES `Inventory` WRITE;
/*!40000 ALTER TABLE `Inventory` DISABLE KEYS */;
INSERT INTO `Inventory` VALUES (1,1,1,'Sold',15000000.00),(2,2,1,'Available',27500000.00),(3,5,1,'Available',13000000.00),(4,12,1,'Available',9000000.00),(5,14,1,'Available',44000000.00),(6,17,1,'Available',35000000.00),(7,18,1,'On Loan',2000000.00),(8,13,1,'Sold',4000000.00),(9,4,1,'Sold',5000000.00),(10,7,1,'Available',22000000.00),(11,3,2,'Available',100000000.00),(12,4,2,'Available',4000000.00),(13,16,2,'Available',75000000.00),(14,11,2,'Available',13500000.00),(15,1,2,'Available',16000000.00),(16,2,2,'On Loan',28000000.00),(17,5,2,'Available',13500000.00),(18,14,2,'Available',45000000.00),(19,13,2,'Available',4200000.00),(20,8,2,'Available',6000000.00),(21,7,3,'Available',22000000.00),(22,8,3,'Available',6500000.00),(23,15,3,'Available',80000000.00),(24,18,3,'Available',2100000.00),(25,17,3,'On Loan',33000000.00),(26,1,3,'Available',15500000.00),(27,3,3,'Available',110000000.00),(28,2,3,'Available',27000000.00),(29,4,3,'Available',4100000.00),(30,11,3,'Available',14000000.00),(31,14,1,'On Loan',60000000.00);
/*!40000 ALTER TABLE `Inventory` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_AfterItemDelete` AFTER DELETE ON `inventory` FOR EACH ROW BEGIN
    INSERT INTO AuditLog (Action)
    VALUES (CONCAT('DELETED: InventoryItem (ArtworkID: ', OLD.ArtworkID, ') was deleted.'));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Sales`
--

DROP TABLE IF EXISTS `Sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Sales` (
  `SaleID` int NOT NULL AUTO_INCREMENT,
  `SaleDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `SalePrice` decimal(12,2) DEFAULT NULL,
  `InventoryID` int DEFAULT NULL,
  `UserID` int DEFAULT NULL,
  `PaymentMethod` varchar(50) DEFAULT NULL,
  `GalleryRevenue` decimal(12,2) DEFAULT NULL,
  `ArtistPayout` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`SaleID`),
  UNIQUE KEY `InventoryID` (`InventoryID`),
  KEY `UserID` (`UserID`),
  CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`InventoryID`) REFERENCES `Inventory` (`InventoryID`),
  CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`UserID`) REFERENCES `Users` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sales`
--

LOCK TABLES `Sales` WRITE;
/*!40000 ALTER TABLE `Sales` DISABLE KEYS */;
INSERT INTO `Sales` VALUES (1,'2025-11-13 06:16:18',15000000.00,1,5,'UPI',10500000.00,4500000.00),(2,'2025-11-13 06:16:32',4000000.00,8,5,'Net Banking',2200000.00,1800000.00),(3,'2025-11-14 08:44:41',5000000.00,9,5,'UPI',3250000.00,1750000.00);
/*!40000 ALTER TABLE `Sales` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_AfterSaleInsert` AFTER INSERT ON `sales` FOR EACH ROW BEGIN
    INSERT INTO AuditLog (Action)
    VALUES (CONCAT('New Sale: InventoryID ', NEW.InventoryID, ' sold to UserID ', NEW.UserID));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Staff`
--

DROP TABLE IF EXISTS `Staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Staff` (
  `StaffID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Position` varchar(100) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `GalleryID` int DEFAULT NULL,
  PRIMARY KEY (`StaffID`),
  UNIQUE KEY `Email` (`Email`),
  KEY `GalleryID` (`GalleryID`),
  CONSTRAINT `staff_ibfk_1` FOREIGN KEY (`GalleryID`) REFERENCES `Galleries` (`GalleryID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Staff`
--

LOCK TABLES `Staff` WRITE;
/*!40000 ALTER TABLE `Staff` DISABLE KEYS */;
INSERT INTO `Staff` VALUES (1,'David Chen','Gallery Director','david.chen@artgallery.com',1),(2,'Emily White','Curator','emily.white@artgallery.com',1),(3,'Sophie Dubois','Gallery Director','sophie.dubois@artgallery.com',3),(4,'James Smith','Curator','james.smith@artgallery.com',2);
/*!40000 ALTER TABLE `Staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tickets`
--

DROP TABLE IF EXISTS `Tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tickets` (
  `TicketID` int NOT NULL AUTO_INCREMENT,
  `UserID` int DEFAULT NULL,
  `GalleryID` int DEFAULT NULL,
  `VisitDate` date NOT NULL,
  `TicketPrice` decimal(10,2) DEFAULT '25.00',
  `PaymentMethod` varchar(50) DEFAULT NULL,
  `PurchaseDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`TicketID`),
  KEY `UserID` (`UserID`),
  KEY `GalleryID` (`GalleryID`),
  CONSTRAINT `tickets_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `Users` (`UserID`),
  CONSTRAINT `tickets_ibfk_2` FOREIGN KEY (`GalleryID`) REFERENCES `Galleries` (`GalleryID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tickets`
--

LOCK TABLES `Tickets` WRITE;
/*!40000 ALTER TABLE `Tickets` DISABLE KEYS */;
INSERT INTO `Tickets` VALUES (1,5,1,'2026-02-02',25.00,'UPI','2025-11-13 04:21:47'),(2,5,1,'2025-12-01',25.00,'Credit Card','2025-11-13 06:16:48');
/*!40000 ALTER TABLE `Tickets` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_AfterTicketSale` AFTER INSERT ON `tickets` FOR EACH ROW BEGIN
    INSERT INTO AuditLog (Action)
    VALUES (CONCAT('New Ticket Sale: TicketID ', NEW.TicketID, ' sold to UserID ', NEW.UserID, ' for GalleryID ', NEW.GalleryID));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
  `GalleryID` int DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `City` varchar(100) DEFAULT NULL,
  `ZipCode` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Email` (`Email`),
  KEY `GalleryID` (`GalleryID`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`GalleryID`) REFERENCES `Galleries` (`GalleryID`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (1,'Admin NY','admin-ny@gallery.com','scrypt:32768:8:1$f4o7rJfeV7yQu0Mo$3f6d2627d54122a862fde847050546316eb11f1721dc2e413c4ba5daa63c8077ecceb28394d1f741764d4a74e17208884aa81289d94af31dc07552a34dfba03b','admin',1,'1 Main St','New York','10001'),(2,'Admin London','admin-london@gallery.com','placeholder','admin',2,'1 Abbey Rd','London','NW8 9AY'),(3,'Admin Paris','admin-paris@gallery.com','placeholder','admin',3,'1 Rue de Rivoli','Paris','75001'),(4,'Customer 1','customer@gallery.com','placeholder','customer',NULL,'123 Customer Ave','Miami','33101'),(5,'ABC','abc@login','scrypt:32768:8:1$ps93OUQzGESwqQ3V$e051c5dac0376a27f15fb80c202f3ce207e7ce885dca0ec5375e8fbaa0345207c8331421fa94596c2adeec546d320dfa473ccc9ac5ce0dbcced353d16df486dc','customer',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_all_transactions`
--

DROP TABLE IF EXISTS `v_all_transactions`;
/*!50001 DROP VIEW IF EXISTS `v_all_transactions`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_all_transactions` AS SELECT 
 1 AS `TransactionType`,
 1 AS `TransactionID`,
 1 AS `TransactionDate`,
 1 AS `GalleryName`,
 1 AS `CustomerName`,
 1 AS `ItemName`,
 1 AS `Price`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_sales_dashboard_details`
--

DROP TABLE IF EXISTS `v_sales_dashboard_details`;
/*!50001 DROP VIEW IF EXISTS `v_sales_dashboard_details`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_sales_dashboard_details` AS SELECT 
 1 AS `SaleID`,
 1 AS `SaleDate`,
 1 AS `SalePrice`,
 1 AS `PaymentMethod`,
 1 AS `CustomerName`,
 1 AS `InventoryID`,
 1 AS `GalleryID`,
 1 AS `GalleryName`,
 1 AS `ArtworkTitle`,
 1 AS `ArtistName`,
 1 AS `GalleryRevenue`,
 1 AS `ArtistPayout`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_ticket_sales_details`
--

DROP TABLE IF EXISTS `v_ticket_sales_details`;
/*!50001 DROP VIEW IF EXISTS `v_ticket_sales_details`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_ticket_sales_details` AS SELECT 
 1 AS `TicketID`,
 1 AS `PurchaseDate`,
 1 AS `VisitDate`,
 1 AS `TicketPrice`,
 1 AS `PaymentMethod`,
 1 AS `CustomerName`,
 1 AS `GalleryID`,
 1 AS `GalleryName`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'ArtGallery'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `e_NightlySalesReport` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `e_NightlySalesReport` ON SCHEDULE EVERY 1 DAY STARTS '2025-11-12 01:00:00' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    -- 1. Get Art Revenue
    CREATE TEMPORARY TABLE IF NOT EXISTS TempArtRevenue
    SELECT
        i.GalleryID,
        SUM(s.SalePrice) AS ArtRevenue,
        COUNT(s.SaleID) AS TotalArtSales
    FROM Sales s
    JOIN Inventory i ON s.InventoryID = i.InventoryID
    WHERE DATE(s.SaleDate) = CURDATE()
    GROUP BY i.GalleryID;
    
    -- 2. Get Ticket Revenue
    CREATE TEMPORARY TABLE IF NOT EXISTS TempTicketRevenue
    SELECT
        GalleryID,
        SUM(TicketPrice) AS TicketRevenue,
        COUNT(TicketID) AS TotalTicketsSold
    FROM Tickets
    WHERE DATE(PurchaseDate) = CURDATE()
    GROUP BY GalleryID;

    -- 3. Insert the combined report
    INSERT INTO DailyRevenueReport (ReportDate, GalleryID, ArtRevenue, TicketRevenue, TotalRevenue, TotalArtSales, TotalTicketsSold)
    SELECT
        CURDATE(),
        g.GalleryID,
        COALESCE(ar.ArtRevenue, 0),
        COALESCE(tr.TicketRevenue, 0),
        COALESCE(ar.ArtRevenue, 0) + COALESCE(tr.TicketRevenue, 0),
        COALESCE(ar.TotalArtSales, 0),
        COALESCE(tr.TotalTicketsSold, 0)
    FROM Galleries g
    LEFT JOIN TempArtRevenue ar ON g.GalleryID = ar.GalleryID
    LEFT JOIN TempTicketRevenue tr ON g.GalleryID = tr.GalleryID;
    
    -- 4. Clean up
    DROP TEMPORARY TABLE TempArtRevenue;
    DROP TEMPORARY TABLE TempTicketRevenue;
END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'ArtGallery'
--
/*!50003 DROP FUNCTION IF EXISTS `GetTotalRevenue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetTotalRevenue`() RETURNS decimal(12,2)
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(12, 2);
    SELECT SUM(SalePrice) INTO total FROM Sales;
    RETURN total;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
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
    INSERT INTO Artists (Name, Nationality) VALUES (in_Name, in_Nationality);
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_BuyArtwork`(IN in_UserID INT, IN in_InventoryID INT, IN in_PaymentMethod VARCHAR(50))
BEGIN
    DECLARE v_Price DECIMAL(12, 2); DECLARE v_Rate DECIMAL(4, 2);
    DECLARE v_GalleryCut DECIMAL(12, 2); DECLARE v_ArtistCut DECIMAL(12, 2);
    DECLARE exit handler FOR sqlexception BEGIN ROLLBACK; END;
    
    SELECT i.PurchasePrice, ar.CommissionRate
    INTO v_Price, v_Rate
    FROM Inventory i
    JOIN Artworks aw ON i.ArtworkID = aw.ArtworkID
    JOIN Artists ar ON aw.ArtistID = ar.ArtistID
    WHERE i.InventoryID = in_InventoryID AND i.Status = 'Available'
    FOR UPDATE;
    
    START TRANSACTION;
    IF v_Price IS NOT NULL THEN
        SET v_GalleryCut = v_Price * (1.0 - v_Rate);
        SET v_ArtistCut = v_Price * v_Rate;
        INSERT INTO Sales (SalePrice, InventoryID, UserID, PaymentMethod, GalleryRevenue, ArtistPayout)
        VALUES (v_Price, in_InventoryID, in_UserID, in_PaymentMethod, v_GalleryCut, v_ArtistCut);
        UPDATE Inventory SET Status = 'Sold' WHERE InventoryID = in_InventoryID;
        SELECT LAST_INSERT_ID() AS NewSaleID;
        COMMIT;
    ELSE ROLLBACK;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_BuyTicket` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_BuyTicket`(IN in_UserID INT, IN in_GalleryID INT, IN in_VisitDate DATE, IN in_PaymentMethod VARCHAR(50))
BEGIN
    -- We'll just use the default price of 25.00
    INSERT INTO Tickets (UserID, GalleryID, VisitDate, PaymentMethod)
    VALUES (in_UserID, in_GalleryID, in_VisitDate, in_PaymentMethod);
    
    SELECT LAST_INSERT_ID() AS NewTicketID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Current Database: `ArtGallery`
--

USE `ArtGallery`;

--
-- Final view structure for view `v_all_transactions`
--

/*!50001 DROP VIEW IF EXISTS `v_all_transactions`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_all_transactions` AS select 'Art Sale' AS `TransactionType`,`v_sales_dashboard_details`.`SaleID` AS `TransactionID`,`v_sales_dashboard_details`.`SaleDate` AS `TransactionDate`,`v_sales_dashboard_details`.`GalleryName` AS `GalleryName`,`v_sales_dashboard_details`.`CustomerName` AS `CustomerName`,`v_sales_dashboard_details`.`ArtworkTitle` AS `ItemName`,`v_sales_dashboard_details`.`SalePrice` AS `Price` from `v_sales_dashboard_details` union all select 'Ticket Sale' AS `TransactionType`,`v_ticket_sales_details`.`TicketID` AS `TransactionID`,`v_ticket_sales_details`.`PurchaseDate` AS `TransactionDate`,`v_ticket_sales_details`.`GalleryName` AS `GalleryName`,`v_ticket_sales_details`.`CustomerName` AS `CustomerName`,concat('Ticket for ',`v_ticket_sales_details`.`GalleryName`) AS `ItemName`,`v_ticket_sales_details`.`TicketPrice` AS `Price` from `v_ticket_sales_details` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_sales_dashboard_details`
--

/*!50001 DROP VIEW IF EXISTS `v_sales_dashboard_details`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_sales_dashboard_details` AS select `s`.`SaleID` AS `SaleID`,`s`.`SaleDate` AS `SaleDate`,`s`.`SalePrice` AS `SalePrice`,`s`.`PaymentMethod` AS `PaymentMethod`,`u`.`Name` AS `CustomerName`,`inv`.`InventoryID` AS `InventoryID`,`inv`.`GalleryID` AS `GalleryID`,`g`.`Name` AS `GalleryName`,`aw`.`Title` AS `ArtworkTitle`,`ar`.`Name` AS `ArtistName`,`s`.`GalleryRevenue` AS `GalleryRevenue`,`s`.`ArtistPayout` AS `ArtistPayout` from (((((`sales` `s` join `users` `u` on((`s`.`UserID` = `u`.`UserID`))) join `inventory` `inv` on((`s`.`InventoryID` = `inv`.`InventoryID`))) join `galleries` `g` on((`inv`.`GalleryID` = `g`.`GalleryID`))) join `artworks` `aw` on((`inv`.`ArtworkID` = `aw`.`ArtworkID`))) left join `artists` `ar` on((`aw`.`ArtistID` = `ar`.`ArtistID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_ticket_sales_details`
--

/*!50001 DROP VIEW IF EXISTS `v_ticket_sales_details`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_ticket_sales_details` AS select `t`.`TicketID` AS `TicketID`,`t`.`PurchaseDate` AS `PurchaseDate`,`t`.`VisitDate` AS `VisitDate`,`t`.`TicketPrice` AS `TicketPrice`,`t`.`PaymentMethod` AS `PaymentMethod`,`u`.`Name` AS `CustomerName`,`g`.`GalleryID` AS `GalleryID`,`g`.`Name` AS `GalleryName` from ((`tickets` `t` join `users` `u` on((`t`.`UserID` = `u`.`UserID`))) join `galleries` `g` on((`t`.`GalleryID` = `g`.`GalleryID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-20 19:53:06
