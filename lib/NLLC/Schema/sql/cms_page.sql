-- MySQL dump 10.11
--
-- Host: localhost    Database: nllc
-- ------------------------------------------------------
-- Server version	5.0.86

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
-- Table structure for table `cms_page`
--

DROP TABLE IF EXISTS `cms_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_page` (
  `page_id` int(11) NOT NULL auto_increment,
  `name` varchar(24) default NULL,
  `body` text,
  `last_edit` int(11) default NULL,
  PRIMARY KEY  (`page_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_page`
--

LOCK TABLES `cms_page` WRITE;
/*!40000 ALTER TABLE `cms_page` DISABLE KEYS */;
INSERT INTO `cms_page` VALUES (1,'Timeline','<h1>Spring Session 2010 Time Line</h1>\r\n\r\n<p>February 15: Program Proposal and Alternate Contribution Forms Available</p>\r\n<p>February 22: Program Proposals due</p>\r\n<p>March 12: Winter Classes End</p>\r\n<p>March 15: Enrollment Begins</p>\r\n<p>March 22: Enrollment Deadline</p>\r\n<p>April 5: Enrollment results announced</p>\r\n\r\n<p>April 12 - June 4, 2010: Spring Session (8 weeks)<p>',NULL),(2,'Contacts (Members)','<h1>NLLC BOARD</h1>\r\n\r\n<table>\r\n  <tr>\r\n       <td>Ilana Houseknecht</td>\r\n       <td>Board Chair</td>\r\n       <td><a href=\"mailto:icoyote69@verizen.net\">icoyote69@verizon.net</a></td>\r\n\r\n       <td>272-5079</td>\r\n  </tr>\r\n   <tr>\r\n       <td>Jenn Colt-Demaree</td>\r\n       <td>Board Co-Chair</td>\r\n       <td><a href=\"mailto:jenncd@gmail.com\">jenncd@gmail.com</a></td>\r\n       <td>275-0010</td>\r\n\r\n  </tr>\r\n\r\n  <tr>\r\n     <td>Crista Shopis</td>\r\n     <td>Board Secretary</td>\r\n     <td><a href=\"mailto:cshopis@yahoo.com\">cshopis@yahoo.com</a></td>\r\n     <td>277-6602</td>\r\n\r\n  </tr>\r\n   <tr>\r\n       <td>Robert Hones</td>\r\n     <td>Board Treasurer</td>\r\n     <td><a href=\"mailto:roberthones@yahoo.com\">roberthones@yahoo.com</a></td>\r\n     <td>273-6250</td>\r\n  </tr>\r\n\r\n  <tr>\r\n     <td>ShelleyLovelace</td>\r\n     <td>Board Member</td>\r\n     <td><a href=\"mailto:shelley.lovelace@yahoo.com\">shelley.lovelace@yahoo.com</a></td>\r\n     <td>273-6250</td>\r\n  </tr>\r\n   \r\n  <tr>\r\n\r\n     <td>Annie Carpenter</td>\r\n     <td>Board Member</td>\r\n     <td><a href=\"mailto:sevenfolks@aol.com\">sevenfolks@aol.com</a></td>\r\n     <td>277-4204</td>\r\n  </tr>\r\n\r\n\r\n  <tr>\r\n\r\n       <td>Inge Johnson</td>\r\n       <td>Board Member</td>\r\n       <td><a href=\"mailto:kristeninge@yahoo.com\">kristeninge@yahoo.com</a></td>\r\n       <td>280-2750</td>\r\n  </tr>\r\n  <tr>\r\n       <td>Chris Oxley</td>\r\n\r\n       <td>Board Member</td>\r\n     <td><a href=\"mailto:christinaoxley@hotmail.com\">christinaoxley@hotmail.com</a></td>\r\n    <td>546-4483</td>\r\n  </tr>\r\n</table>\r\n<p>Please send board agenda items to either Ilana or Jenn.</p>\r\n\r\n<h1>COORDINATORS</h1>\r\n\r\n<table cellpadding=\"3\" cellspacing=\"1\" rules=\"ROWS\" frame=\"HSIDES\">\r\n  <tr>\r\n    <td>Financial Coordinator</td>\r\n    <td>Robin Tuttle</td>\r\n    <td><a href=\"mailto:robintuttle@mac.com\">robintuttle@mac.com</a></td>\r\n    <td>257-2911</td>\r\n  </tr>\r\n\r\n    <td></td>\r\n    <td colspan=\"3\">collects membership dues, pays bills, manages accounts</td>\r\n  </tr>\r\n  <tr>\r\n    <td>Alternate Contributions</td>\r\n    <td>Stephanie Haskins</td>\r\n    <td><a href=\"mailto:shaskins@htva.net\">shaskins@htva.net</a></td>\r\n\r\n    <td>277-7279</td>\r\n  </tr>\r\n  <tr>\r\n    <td>\r\n    <td colspan=\"3\">arranges alternate contributions for members who aren\'t teaching classes</td>\r\n  </tr>\r\n  <tr>\r\n    <td>Membership Coordinator</td>\r\n\r\n    <td>Tamara Thomas</td>\r\n    <td><a href=\"mailto:thistleluna@yahoo.com\">thistleluna@yahoo.com</a></td>\r\n    <td>(315) 497-0929</td>\r\n  </tr>\r\n  <tr>\r\n    <td></td>\r\n    <td colspan=\"3\">registers new members,  changes member status (active or inactive), gives out membership information.</td>\r\n\r\n  </tr>\r\n  <tr>\r\n    <td>Website Development/Design</td>  \r\n    <td>Gerda Shank</td>\r\n    <td><a href=\"mailto:gerda.shank@gmail.com\">gerda.shank@gmail.com</a></td>\r\n    <td>273-4709</td>\r\n    <td></td>\r\n\r\n  </tr>\r\n  <tr>\r\n    <td>Scheduling Coordinator</td>  \r\n    <td>Gina Varrichio</td>\r\n    <td><a href=\"mailto:zealth_1@yahoo.com\">zealth_1@yahoo.com</a></td>\r\n    <td>659-3567</td>\r\n  </tr>\r\n\r\n  <tr>\r\n    <td></td>\r\n    <td colspan=\"3\">schedules the classes for each session</td>\r\n  </tr>\r\n  <tr>\r\n    <td>Enrollment Coordinator</td>\r\n    <td>Jennifer Moran</td>\r\n\r\n    <td><a href=\"mailto:sharing_minds@verizon.net\">sharing_minds@verizon.net</a></td>\r\n    <td>257-5020</td>\r\n  <tr>\r\n    <td></td>\r\n    <td colspan=\"3\">co-manages enrollment of members in classes</td>\r\n  <tr>\r\n    <td>Enrollment Coordinator</td>\r\n\r\n    <td>Chris Oxley</td>\r\n    <td><a href=\"mailto:christinaoxley@hotmail.com\">christinaoxley@hotmail.com</a></td>\r\n    <td>546-4483</td>\r\n  </tr>\r\n  <tr>\r\n    <td></td>\r\n    <td colspan=\"3\">co-manages enrollment of members in classes</td>\r\n\r\n  </tr>\r\n  <tr>\r\n    <td>Timeline Coordinator</td>\r\n    <td>Sarah-Spaulding Lydon</td>\r\n    <td><a href=\"mailto:whalesong@empacc.net\">whalesong@empacc.net</a></td>\r\n    <td>546-2667</td>\r\n  </tr>\r\n\r\n  <tr>\r\n    <td></td>\r\n    <td colspan=\"3\">facilitates setting of deadlines and reminds coordinators about deadlines and responsibilities</td>\r\n  </tr>\r\n  <tr>\r\n    <td>Communication Coordinator</td>\r\n    <td>Rebecca Root</td>\r\n\r\n    <td><a href=\"mailto:rebeccaroot@hotmail.com\">rebeccaroot@hotmail.com</a></td>\r\n    <td>(h)319-4453<br>\r\n(c)226-3523</td>\r\n  </tr>\r\n  <tr>\r\n    <td></td>\r\n    <td colspan=\"3\">Prints weekly calendars, maintains bulletin boards, other communication duties</td>\r\n\r\n  </tr>\r\n  <tr>\r\n    <td>Cleaning Coordinator</td>\r\n    <td>Lorraine Bard</td>\r\n    <td>wildmtmama@hotmail.com</td>\r\n    <td>(h)273-2613<br>\r\n(c)280-0092</td>\r\n\r\n  </tr>\r\n  <tr>\r\n    <td></td>\r\n    <td colspan=\"3\">coordinates members who clean the space as their alternate contribution, sends out reminders about cleaning other spaces, keeps track of cleaning supplies</td>\r\n  </tr>\r\n  <tr>\r\n    <td>Program Development</td>\r\n    <td>Mike Carpenter</td>\r\n\r\n    <td>sevenfolks@aol.com</td>\r\n    <td>(h)277-4204<br>\r\n(c)280-0171</td>\r\n  </tr>\r\n  <tr>\r\n    <td></td>\r\n    <td colspan=\"3\">oversees programming for the whole of membership, coordinates program development with the age reps, helps with class fee collection and other class issues when needed.</td>\r\n\r\n  </tr>\r\n\r\n</table>\r\n\r\n<h1>Age Reps</h1>\r\n<p>Meets with members re: programming for particular age group, serve as resource to scheduling coordinator.\r\n</p>\r\n\r\n<h2>12+ Age Reps</h2>\r\n<table cellpadding=\"3\" cellspacing=\"1\">\r\n  <tr>\r\n    <td>Carol Bobertz</td>\r\n\r\n    <td><a href=\"mailto:sgmom2@yahoo.com\">sgmom2@yahoo.com</a></td>\r\n    <td>387-4393</td>\r\n  </tr>\r\n  <tr>\r\n    <td>Julie Humphrey</td>\r\n    <td><a href=\"mailto:JAnn1027@aol.com\">JAnn1027@aol.com</a></td>\r\n    <td>868-7631</td>\r\n\r\n  </tr>\r\n</table>\r\n\r\n<h2>7-11 years  Age Reps</h2>\r\n<table cellpadding=\"3\" cellspacing=\"1\">\r\n  <tr>\r\n    <td>Madhurima Agarwal</td>\r\n    <td><a href=\"mailto:ma24@cornell.edu\">ma24@cornell.edu</a></td>\r\n    <td>546-2094</td>\r\n\r\n  </tr>\r\n  <tr>\r\n    <td>Lauren Korfine</td>\r\n    <td><a href=\"mailto:lk79@cornell.edu\">lk79@cornell.edu</a></td>\r\n    <td>256-0132</td>\r\n  </tr>\r\n</table>\r\n\r\n<h2>6 and under Age Rep</h2>\r\n<table cellpadding=\"3\" cellspacing=\"1\">\r\n  <tr>\r\n    <td>Poppy Singer</td>\r\n    <td><a href=\"mailto:poppys@twcny.rr.com\">poppys@twcnyr.rr.com</a></td>\r\n    <td>273-4041</td>\r\n  </tr>\r\n</table>',NULL),(3,'Contact (public)','If you have any questions about NLLC, please contact Jane Markarchuk at dazyjane@gmail.com or 256-7553, or Tamara Thomas at thistleluna@yahoo.com or 315-497-0929.',NULL);
/*!40000 ALTER TABLE `cms_page` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-02-22 21:12:39
