-- phpMyAdmin SQL Dump
-- version 4.6.0
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Sep 06, 2016 at 05:52 PM
-- Server version: 5.7.11
-- PHP Version: 5.5.9-1ubuntu4.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `oral`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_article` (IN `_bookId` BIGINT UNSIGNED, IN `_title` VARCHAR(100), IN `_authorName` VARCHAR(45), OUT `id` BIGINT UNSIGNED)  main: BEGIN
	case when _bookId is null || _bookId <= 0 then begin set id := 0; leave main; end;
		 when _title is null || _title = '' then begin set id := 0; leave main; end;
         when _authorName is null || _authorName = '' then begin set id := 0; leave main; end;
         else begin end;
    end case;

	start transaction;
    insert into Article(bookId, title, authorName) values(_bookId, _title, _authorName);
	set id := last_insert_id();
    commit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_book` (IN `name` VARCHAR(100), IN `author` VARCHAR(45), IN `isbn` VARCHAR(45), OUT `id` BIGINT UNSIGNED)  main: BEGIN
	case when name is null || name = '' then begin set id := 0; leave main; end;
		 when author is null || author = '' then begin set id := 0; leave main; end;
         when isbn is null || isbn = '' then begin set id := 0; leave main; end;
         else begin end;
    end case;

	start transaction;
    insert into Book(bookName, authorName, bookIsbn) values(name, author, isbn);
	set id := last_insert_id();
    commit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_sentenceText` (IN `_parentId` BIGINT UNSIGNED, IN `_articleId` BIGINT UNSIGNED, IN `_content` TINYTEXT, IN `_lang` VARCHAR(45), OUT `id` BIGINT UNSIGNED)  main: BEGIN
		
		case when not ( _parentId xor _articleId )  then begin set id := 0; leave main; end;
			 when _content is null || _content = '' then begin set id := 0; leave main; end;
             when _lang is null || _lang = '' then begin set id := 0; leave main; end;
        else begin end;
        end case;
        
        start transaction;
			insert into SentenceText(parentId, articleId, content, lang) 
				values(_parentId, _articleId, _content, _lang);
        commit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_sentenceVoice` (IN `_textId` BIGINT UNSIGNED, IN `_content` BLOB, OUT `id` BIGINT UNSIGNED)  main: BEGIN
	case when _textId is null || _textId <= 0 then begin set id := 0; leave main; end;
		 when _content is null then begin set id := 0; leave main; end;
	else begin end;
    end case;
    
	start transaction;
    insert into SentenceVoice(textId, content) values(_textId, _content);
	set id := last_insert_id();
    commit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_user` (IN `_username` VARCHAR(20), IN `_password` VARCHAR(100), OUT `id` BIGINT UNSIGNED)  main: BEGIN
	case when _username is null || _username = '' then begin set id := 0; leave main; end;
		 when _password is null || _password = '' then begin set id := 0; leave main; end;
         else begin end;
    end case;

	start transaction;
    insert into `User`(username, `password`) values(_username, md5(_password));
	set id := last_insert_id();
    commit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `attach_article_opts` (IN `_articleId` BIGINT UNSIGNED, IN `_akey` VARCHAR(20), IN `_avalue` VARCHAR(45))  main:BEGIN
	declare  areadlyKey varchar(20) default ''; 
	case when _articleId is null || _articleId <= 0 then leave main;
		 when _akey is null || _akey = '' then leave main;
         when _avalue is null || _avalue = '' then leave main;
         else begin end;
    end case;
    
	select aKey from Article_Options where articleId = _articleId limit 1 into areadlyKey;
    if _akey = areadlyKey then
		begin
			update Article_Options set aValue = _avalue where articleId = _articleId && aKey = _akey;
        end;
	else 
		begin
			insert into Article_Options(articleId, aKey, aValue) values (_articleId, _akey, _avalue);
		end;
	end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `attach_book_opts` (IN `_bookid` BIGINT UNSIGNED, IN `_akey` VARCHAR(20), IN `_avalue` VARCHAR(45))  main:BEGIN
	declare  areadlyKey varchar(20) default ''; 
	case when _bookid is null || _bookid = 0 then leave main;
		 when _akey is null || _akey = '' then leave main;
         when _avalue is null || _avalue = '' then leave main;
         else begin end;
    end case;
    
	select aKey from Book_Options where bookId = _bookid limit 1 into areadlyKey;
    if _akey = areadlyKey then
		begin
			update Book_Options set aValue = _avalue where bookId = _bookid && aKey = _akey;
        end;
	else 
		begin
			insert into Book_Options(bookId, aKey, aValue) values (_bookid, _akey, _avalue);
		end;
	end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `attach_voice_opts` (IN `_voiceId` BIGINT UNSIGNED, IN `_akey` VARCHAR(20), IN `_avalue` VARCHAR(45))  main:BEGIN
	declare  areadlyKey varchar(20) default ''; 
	case when _articleId is null || _articleId <= 0 then leave main;
		 when _akey is null || _akey = '' then leave main;
         when _avalue is null || _avalue = '' then leave main;
         else begin end;
    end case;
    
	select aKey from SentenceVoice_Options where voiceId = _voiceId limit 1 into areadlyKey;
    if _akey = areadlyKey then
		begin
			update SentenceVoice_Options set aValue = _avalue where voiceId = _voiceId && aKey = _akey;
        end;
	else 
		begin
			insert into SentenceVoice_Options(voiceId, aKey, aValue) values (_voiceId, _akey, _avalue);
		end;
	end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_article_info` (IN `_id` BIGINT UNSIGNED, IN `verbose` BOOLEAN)  BEGIN
	if not verbose then
		begin
			select * from Article where id = _id;
        end;
	else 
		begin 			declare i bigint unsigned;
			declare k varchar(20);
            declare v varchar(45);
			declare cur cursor for select id, aKey, aValue from Article_Options where articleId =  _id;
            open cur;
            
								select * from Article where id = _id;
                select id, aKey, aValue from Article_Options where articleId =  _id; 
            close cur;
        end;
	end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_book_info` (IN `_id` BIGINT UNSIGNED, IN `verbose` BOOLEAN)  BEGIN
	if not verbose then
		begin
			select * from Book where id = _id;
        end;
	else 
		begin 			declare i bigint unsigned;
			declare k varchar(20);
            declare v varchar(45);
			declare cur cursor for select id, aKey, aValue from Book_Options where bookId =  _id;
            open cur;
            
								select * from Book where id = _id;
                select id, aKey, aValue from Book_Options where bookId =  _id; 
            close cur;
        end;
	end if;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `listen_book`
--

CREATE TABLE `listen_book` (
  `bookId` int(10) UNSIGNED NOT NULL,
  `categoryId` int(10) UNSIGNED NOT NULL,
  `bookName` varchar(100) NOT NULL,
  `authorName` varchar(45) NOT NULL,
  `bookIsbn` varchar(45) NOT NULL,
  `description` tinytext NOT NULL,
  `imageUrl` tinytext NOT NULL,
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `listen_book`
--

INSERT INTO `listen_book` (`bookId`, `categoryId`, `bookName`, `authorName`, `bookIsbn`, `description`, `imageUrl`, `updateTime`) VALUES
(108, 2, '21世纪大学英语视听说教程1', '姜荷梅   娄萌 杨秋云', '978-7-309-10406-6', '本套教材旨在通过真实而有时代气息的场景、地道而生动的语言、实用而又丰富的知识、多样而又活泼的练习提高学生的英语听说能力。', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程/1.jpg', '2016-07-29 15:30:34');

-- --------------------------------------------------------

--
-- Table structure for table `listen_category`
--

CREATE TABLE `listen_category` (
  `categoryId` int(10) UNSIGNED NOT NULL,
  `categoryName` varchar(100) NOT NULL,
  `description` tinytext NOT NULL,
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `listen_category`
--

INSERT INTO `listen_category` (`categoryId`, `categoryName`, `description`, `updateTime`) VALUES
(2, '21世纪大学英语视听说', '主要练习大学生日常口语和听力         ', '2016-07-29 15:02:34');

-- --------------------------------------------------------

--
-- Table structure for table `listen_section`
--

CREATE TABLE `listen_section` (
  `id` int(10) UNSIGNED NOT NULL,
  `pid` int(10) UNSIGNED DEFAULT NULL,
  `text` varchar(100) NOT NULL,
  `remark` tinytext,
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `unitId` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `listen_section`
--

INSERT INTO `listen_section` (`id`, `pid`, `text`, `remark`, `updateTime`, `unitId`) VALUES
(10000019, NULL, 'Lead-in', '听', '2016-07-29 15:51:17', 10004),
(10000020, NULL, 'Section Two Intensive Listening', '听', '2016-07-29 15:51:56', 10004),
(10000021, 10000020, 'I. Listening Focus', '听', '2016-07-29 15:52:15', 10004),
(10000022, 10000020, 'II. Listening Practice ', '听\n', '2016-07-29 15:52:41', 10004),
(10000023, 10000021, '1. Phonetics: Loss of Plosion', '听 ', '2016-07-29 15:57:17', 10004),
(10000024, 10000021, '2. Phonetics: Liaison', '听', '2016-07-29 15:57:55', 10004),
(10000025, 10000023, 'A', '听', '2016-07-29 15:58:12', 10004),
(10000026, 10000023, 'B', '听', '2016-07-29 15:58:24', 10004),
(10000027, 10000024, 'A', '听', '2016-07-29 15:58:37', 10004),
(10000028, 10000024, 'B', '听', '2016-07-29 15:58:46', 10004),
(10000029, 10000022, '1. Short Conversations', '听', '2016-07-29 15:59:18', 10004),
(10000030, 10000022, '2. Long Conversation', '听', '2016-07-29 15:59:51', 10004),
(10000035, NULL, 'Lead-in', '听', '2016-07-29 16:09:07', 10005),
(10000036, NULL, 'Section Two Intensive Listening', '听', '2016-07-29 16:09:40', 10005),
(10000037, 10000036, 'I. Listening Focus', '听', '2016-07-29 16:10:19', 10005),
(10000038, 10000036, 'II. Listening Practice', '听', '2016-07-29 16:10:50', 10005),
(10000039, 10000037, '1. Word Stress', '听', '2016-07-29 16:11:14', 10005),
(10000040, 10000037, '2. Sentence Stress', '听', '2016-07-29 16:11:34', 10005),
(10000041, 10000039, 'A', '听', '2016-07-29 16:11:44', 10005),
(10000042, 10000039, 'B', '听', '2016-07-29 16:11:53', 10005),
(10000043, 10000040, 'A', '听', '2016-07-29 16:12:00', 10005),
(10000044, 10000040, 'B', '听', '2016-07-29 16:12:29', 10005),
(10000045, 10000040, 'C', '听', '2016-07-29 16:13:15', 10005),
(10000046, 10000038, '1. Short Conversations', '听', '2016-07-29 16:13:39', 10005),
(10000047, 10000038, '2. Long Conversation   ', '听', '2016-07-29 16:13:56', 10005),
(10000048, 10000038, '3. Passages', '听', '2016-07-29 16:14:27', 10005),
(10000051, 10000038, '4. Dictation', '听', '2016-07-29 16:15:11', 10005),
(10000052, NULL, 'Lead-in', '听', '2016-07-29 16:16:20', 10006),
(10000053, NULL, 'Section Two Intensive Listening', '听', '2016-07-29 16:16:51', 10006),
(10000056, 10000053, 'I. Listening Focus', '听', '2016-07-29 16:18:08', 10006),
(10000057, 10000053, 'II. Listening Practice', '听', '2016-07-29 16:18:25', 10006),
(10000058, 10000056, '1. Phonetics: Rhyming', '听', '2016-07-29 16:18:50', 10006),
(10000059, 10000056, ' 2. Homonyms', '听', '2016-07-29 16:19:10', 10006),
(10000060, 10000058, 'A', '听', '2016-07-29 16:19:21', 10006),
(10000061, 10000058, 'B', '听', '2016-07-29 16:19:28', 10006),
(10000062, 10000058, 'C', '听', '2016-07-29 16:19:38', 10006),
(10000063, 10000059, 'A', '听', '2016-07-29 16:19:49', 10006),
(10000064, 10000059, 'B', '听', '2016-07-29 16:20:00', 10006),
(10000065, 10000057, '1. Short Conversations', '听', '2016-07-29 16:20:19', 10006),
(10000067, 10000057, '2. Long Conversation', '听', '2016-07-29 16:20:41', 10006),
(10000069, 10000057, '3. Passages', '听', '2016-07-29 16:20:57', 10006),
(10000073, 10000057, '4. Dictation', '听', '2016-07-29 16:22:40', 10006),
(10000118, 10000022, '3. Passages', '听', '2016-08-01 09:12:52', 10004),
(10000119, 10000118, 'A', '听', '2016-08-01 09:13:02', 10004),
(10000120, 10000118, 'B', '听', '2016-08-01 09:13:10', 10004),
(10000121, 10000022, '4. Dictation', '听 ', '2016-08-01 09:13:28', 10004),
(10000122, 10000048, 'A', '听', '2016-08-01 09:37:27', 10005),
(10000123, 10000048, 'B', '听', '2016-08-01 09:37:47', 10005),
(10000124, 10000069, 'A', '听', '2016-08-01 09:39:21', 10006),
(10000125, 10000069, 'B', '听', '2016-08-01 09:39:29', 10006),
(10000126, NULL, 'Lead-in', '听', '2016-08-01 09:40:04', 10007),
(10000127, NULL, 'Section Two  Intensive Listening', '听', '2016-08-01 09:42:14', 10007),
(10000128, 10000127, 'I. Listening Focus', '听', '2016-08-01 09:44:52', 10007),
(10000131, 10000128, '1. Cardinal Numbers', '听', '2016-08-01 09:47:44', 10007),
(10000132, 10000131, 'A', '听', '2016-08-01 09:47:57', 10007),
(10000133, 10000131, 'B', '听', '2016-08-01 09:48:04', 10007),
(10000134, 10000128, '2. Ordinal Numbers', '听', '2016-08-01 09:48:49', 10007),
(10000135, 10000134, 'A', '听', '2016-08-01 09:49:00', 10007),
(10000136, 10000134, 'B', '听', '2016-08-01 09:49:08', 10007),
(10000137, 10000127, 'II. Listening Practice', '听', '2016-08-01 09:49:53', 10007),
(10000138, 10000137, '1. Short Conversations', '听', '2016-08-01 09:55:04', 10007),
(10000139, 10000137, '2. Long Conversations', '听', '2016-08-01 09:59:36', 10007),
(10000140, 10000137, '3. Passages', '听', '2016-08-01 09:59:57', 10007),
(10000141, 10000137, '4. Dictation', '听', '2016-08-01 10:00:19', 10007),
(10000142, 10000139, 'A', '听', '2016-08-01 10:00:36', 10007),
(10000143, 10000139, 'B', '听', '2016-08-01 10:00:44', 10007),
(10000144, 10000140, 'A', '听', '2016-08-01 10:00:53', 10007),
(10000145, 10000140, 'B', '听', '2016-08-01 10:01:01', 10007),
(10000146, NULL, 'Lead-in', '听', '2016-08-01 10:30:14', 10008),
(10000147, NULL, 'Section Two Intensive Listening', '听', '2016-08-01 10:32:29', 10008),
(10000148, 10000147, 'I. Listening Focus', '听', '2016-08-01 10:40:10', 10008),
(10000149, 10000147, 'II. Listening Practice', '听', '2016-08-01 10:40:40', 10008),
(10000150, 10000148, '1. Teens and Tens', '听', '2016-08-01 10:41:09', 10008),
(10000151, 10000148, '2. Ordinal Numbers ', '听', '2016-08-01 10:41:53', 10008),
(10000152, 10000150, 'A', '听', '2016-08-01 10:45:01', 10008),
(10000153, 10000150, 'B', '听', '2016-08-01 10:45:07', 10008),
(10000154, 10000151, 'A', '听', '2016-08-01 10:45:24', 10008),
(10000155, 10000151, 'B', '听', '2016-08-01 10:45:33', 10008),
(10000156, 10000149, '1. Short Conversations', '听', '2016-08-01 10:46:27', 10008),
(10000157, 10000149, '2. Long Conversations', '听', '2016-08-01 10:46:53', 10008),
(10000158, 10000157, 'A', '听', '2016-08-01 10:47:08', 10008),
(10000159, 10000157, 'B', '听', '2016-08-01 10:47:18', 10008),
(10000160, 10000149, '3. Passages ', '听', '2016-08-01 10:47:49', 10008),
(10000161, 10000160, 'A', '听', '2016-08-01 10:47:59', 10008),
(10000162, 10000160, 'B', '听', '2016-08-01 10:48:06', 10008),
(10000163, 10000149, '4. Dictation', '听', '2016-08-01 10:48:20', 10008),
(10000164, NULL, 'Lead-in', '听', '2016-08-01 10:50:20', 10009),
(10000165, NULL, 'Section Two  Intensive Listening ', '听', '2016-08-01 10:51:12', 10009),
(10000166, 10000165, 'I. Listening Focus', '听', '2016-08-01 10:51:29', 10009),
(10000167, 10000165, 'II. Listening Practice', '听', '2016-08-01 10:51:53', 10009),
(10000168, 10000166, '1. Dates and Time', '听', '2016-08-01 10:52:35', 10009),
(10000169, 10000166, '2. Temperatures', '听', '2016-08-01 10:53:04', 10009),
(10000170, 10000168, 'A', '听', '2016-08-01 10:53:21', 10009),
(10000171, 10000168, 'B', '听', '2016-08-01 10:53:29', 10009),
(10000172, 10000169, 'A', '听', '2016-08-01 10:53:37', 10009),
(10000173, 10000169, 'B', '听', '2016-08-01 10:53:45', 10009),
(10000174, 10000167, '1. Short Conversations', '听', '2016-08-01 10:54:20', 10009),
(10000175, 10000167, '2. Long Conversations', '听', '2016-08-01 10:55:32', 10009),
(10000176, 10000167, '3. Passages', '听', '2016-08-01 10:55:50', 10009),
(10000177, 10000167, '4. Dictation', '听', '2016-08-01 10:56:03', 10009),
(10000178, 10000175, 'A', '听', '2016-08-01 10:56:28', 10009),
(10000179, 10000175, 'B', '听', '2016-08-01 10:56:36', 10009),
(10000180, 10000176, 'A', '听', '2016-08-01 10:56:44', 10009),
(10000181, 10000176, 'B', '听', '2016-08-01 10:56:51', 10009),
(10000182, NULL, 'Lead-in', '听', '2016-08-01 10:59:39', 10010),
(10000183, NULL, 'Section Two   Intensive Listening', '听', '2016-08-01 11:00:46', 10010),
(10000184, 10000183, 'I. Listening Focus', '听', '2016-08-01 11:01:23', 10010),
(10000185, 10000183, 'II. Listening Practice', '听', '2016-08-01 11:01:46', 10010),
(10000186, 10000184, '1. Sizes and Prices', '听', '2016-08-01 11:02:51', 10010),
(10000187, 10000184, '2. Addresses and Phone Numbers ', '听', '2016-08-01 11:03:39', 10010),
(10000188, 10000186, 'A', '听', '2016-08-01 11:03:50', 10010),
(10000189, 10000186, 'B', '听', '2016-08-01 11:03:59', 10010),
(10000190, 10000187, 'A', '听', '2016-08-01 11:04:06', 10010),
(10000191, 10000187, 'B', '听', '2016-08-01 11:04:15', 10010),
(10000192, 10000185, '1. Short Conversations', '听', '2016-08-01 11:04:37', 10010),
(10000193, 10000185, '2. Long Conversations', '听', '2016-08-01 11:04:55', 10010),
(10000194, 10000185, '3. Passages', '听', '2016-08-01 11:05:07', 10010),
(10000195, 10000185, '4. Dictation', '听', '2016-08-01 11:05:21', 10010),
(10000196, 10000193, 'A', '听', '2016-08-01 11:05:40', 10010),
(10000197, 10000193, 'B', '听', '2016-08-01 11:05:47', 10010),
(10000198, 10000194, 'A', '听', '2016-08-01 11:05:54', 10010),
(10000199, 10000194, 'B', '听', '2016-08-01 11:06:03', 10010),
(10000226, 10000029, 'A', '听', '2016-08-03 09:59:19', 10004),
(10000227, 10000030, 'A', '听', '2016-08-03 09:59:31', 10004),
(10000228, 10000121, 'A', '听', '2016-08-03 09:59:50', 10004),
(10000229, 10000046, 'A', '听', '2016-08-03 10:05:52', 10005),
(10000230, 10000047, 'A', '听', '2016-08-03 10:06:04', 10005),
(10000231, 10000051, 'A', '听', '2016-08-03 10:06:23', 10005),
(10000232, 10000065, 'A', '听', '2016-08-03 10:11:13', 10006),
(10000233, 10000067, 'A', '听', '2016-08-03 10:11:23', 10006),
(10000234, 10000073, 'A', '听', '2016-08-03 10:11:35', 10006),
(10000235, 10000138, 'A', '听', '2016-08-03 10:16:22', 10007),
(10000236, 10000141, 'A', '听', '2016-08-03 10:16:37', 10007),
(10000237, 10000156, 'A', '听', '2016-08-03 10:19:59', 10008),
(10000238, 10000163, 'A', '听', '2016-08-03 10:20:09', 10008),
(10000239, 10000174, 'A', '听', '2016-08-03 10:23:32', 10009),
(10000240, 10000177, 'A', '听', '2016-08-03 10:23:45', 10009),
(10000241, 10000192, 'A', '听', '2016-08-03 10:28:19', 10010),
(10000242, 10000195, 'A', '听', '2016-08-03 10:28:30', 10010),
(10000243, NULL, 'Lead-in', 'ting', '2016-09-06 08:38:36', 10003),
(10000244, NULL, 'Section Two Intensive Listening', 'ting', '2016-09-06 08:39:23', 10003),
(10000245, 10000244, 'I. Listening Focus', 'ting\n', '2016-09-06 08:40:44', 10003),
(10000246, 10000244, 'II. Listening Practice', 'ting', '2016-09-06 08:41:12', 10003),
(10000247, 10000245, '1. Phonetics: Sound Recognition-Confusing Vowels', 'ting', '2016-09-06 08:42:28', 10003),
(10000248, 10000245, '2. Phonetics: Sound Recognition-Confusing Consonants', 'ting', '2016-09-06 08:43:17', 10003),
(10000249, 10000246, '1. Short Conversations', 'ting', '2016-09-06 08:44:42', 10003),
(10000250, 10000246, '2. Long Conversation', 'ting', '2016-09-06 08:45:19', 10003),
(10000251, 10000246, '3. Passages', 'ting', '2016-09-06 08:45:32', 10003),
(10000252, 10000246, '4. Dictation', 'ting', '2016-09-06 08:45:48', 10003),
(10000253, 10000247, 'A', 'ting', '2016-09-06 08:46:27', 10003),
(10000254, 10000247, 'B', 'ting', '2016-09-06 08:46:41', 10003),
(10000255, 10000248, 'A', 'ting', '2016-09-06 08:46:53', 10003),
(10000256, 10000248, 'B', 'ting', '2016-09-06 08:47:00', 10003),
(10000257, 10000251, 'A', 'ting', '2016-09-06 08:47:41', 10003),
(10000258, 10000251, 'B', 'ting', '2016-09-06 08:47:49', 10003),
(10000259, 10000250, 'A', 't', '2016-09-06 11:23:07', 10003),
(10000260, 10000249, 'A', '', '2016-09-06 11:24:51', 10003),
(10000261, 10000252, 'A', 't', '2016-09-06 11:48:59', 10003);

-- --------------------------------------------------------

--
-- Table structure for table `listen_sentence`
--

CREATE TABLE `listen_sentence` (
  `sentenceId` bigint(20) UNSIGNED NOT NULL,
  `orderId` int(10) UNSIGNED NOT NULL,
  `unitId` bigint(20) UNSIGNED NOT NULL,
  `sectionId` int(10) UNSIGNED NOT NULL,
  `english` text NOT NULL,
  `chinese` text,
  `voiceUrl` tinytext NOT NULL,
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `listen_sentence`
--

INSERT INTO `listen_sentence` (`sentenceId`, `orderId`, `unitId`, `sectionId`, `english`, `chinese`, `voiceUrl`, `updateTime`) VALUES
(50, 1, 10004, 10000019, 'Thankfulness is the beginning of gratitude.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 2 Expressing Gratitude/Lead-in 1.mp3', '2016-08-01 09:52:39'),
(51, 2, 10004, 10000019, 'Gratitude is the completion of thankfulness. ', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 2 Expressing Gratitude/Lead-in 2.mp3', '2016-08-01 09:53:24'),
(52, 3, 10004, 10000019, 'Thankfulness may consist merely of words.\r\n', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 2 Expressing Gratitude/Lead-in 3.mp3', '2016-08-01 09:54:59'),
(53, 4, 10004, 10000019, 'Gratitude is shown in acts.\r\n', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 2 Expressing Gratitude/Lead-in 4.mp3', '2016-08-01 09:56:15'),
(54, 1, 10004, 10000025, 'You are going to hear fifteen phrases. Repeat what you hear and underline the consonants that undergo loss of plosion. ', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 2 Expressing Gratitude/Listening Focus 1-A.mp3', '2016-08-01 10:12:40'),
(55, 1, 10004, 10000026, 'You are going to hear ten sentences. Repeat what you hear and underline the consonants that undergo loss of plosion.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 2 Expressing Gratitude/Listening Focus 1-Bmp3.mp3', '2016-08-01 10:14:45'),
(56, 1, 10004, 10000027, ' Native English speakers don’t separate all their words in their speech; in fact, they 	join them together whenever possible. This is called linking, or liaison, which is important for listening comprehension. You are going to hear fifteen phrases. Listen carefully and mark the linking parts. Then repeat what you hear. ', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 2 Expressing Gratitude/Listening Focus 2-Amp3.mp3', '2016-08-01 10:18:01'),
(57, 1, 10004, 10000028, ' Listen to the following sentences and mark the linking parts. Repeat what you hear and also pay attention to the loss of plosion in each sentence.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 2 Expressing Gratitude/Listening Focus 2-B.mp3', '2016-08-01 10:21:43'),
(60, 1, 10004, 10000119, 'Listen to the following passage and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 2 Expressing Gratitude/Listening Practice 3-A.mp3', '2016-08-01 10:28:00'),
(61, 1, 10004, 10000120, 'Listen to the following passage and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 2 Expressing Gratitude/Listening Practice 3-B.mp3', '2016-08-01 10:30:09'),
(64, 1, 10005, 10000035, 'In most cases,parting means more than simply \r\nsaying “Goodbye.”\r\n', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 3 Partings/lead-in 1.mp3', '2016-08-01 10:36:01'),
(65, 2, 10005, 10000035, 'People often use the occasion as an opportunity to imply a future meeting,extend an invitation, express good wishes and/or show gratitude and/or concern.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 3 Partings/lead-in 2.mp3', '2016-08-01 10:37:20'),
(66, 3, 10005, 10000035, 'People choose different  expressions of farewell according to the particular time, place and the relationship between those partings.\r\n', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 3 Partings/lead-in 3.mp3', '2016-08-01 10:38:24'),
(67, 1, 10005, 10000041, 'Word stress refers to the emphasis of one syllable in a word over another, or others. Listen to the following 15 words and mark the stress in each word you hear.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 3 Partings/Listening Focus 1-A.mp3', '2016-08-01 10:40:22'),
(68, 1, 10005, 10000042, 'Listen to the following phrases carefully and mark the words that are stressed.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 3 Partings/Listening Focus 1-B.mp3', '2016-08-01 10:41:37'),
(69, 1, 10005, 10000043, 'Sentence stress refers to the emphasis of notional words such as nouns, verbs and adjectives in a sentence. Function words, such as articles, prepositions and conjunctives are usually unstressed.  Listen to the following sentences carefully and underline the words that are stressed.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 3 Partings/Listening Focus 2-A.mp3', '2016-08-01 10:42:46'),
(70, 1, 10005, 10000044, 'Consider the meaning of the following sentences which stress certain words in bold. Next, read each sentence aloud and strongly stress the word in bold.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 3 Partings/Listening Focus 2-B.mp3', '2016-08-01 10:44:14'),
(71, 1, 10005, 10000045, 'Read the following sentences aloud stressing each bolded word. Then match each stressed sentence with its corresponding meaning below.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 3 Partings/Listening Focus 2-C.mp3', '2016-08-01 10:45:26'),
(74, 1, 10005, 10000122, 'Listen to the following passage and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 3 Partings/Listening Practice 3-A.mp3', '2016-08-01 10:51:08'),
(75, 1, 10005, 10000123, 'Listen to the following passage and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 3 Partings/Listening Practice 3-B.mp3', '2016-08-01 10:52:20'),
(77, 1, 10006, 10000052, 'Everyone makes mistakes, and everyone needs to know what to say and what to do after making a mistake.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 4 Apologies/lead-in 1.mp3', '2016-08-01 10:59:16'),
(78, 2, 10006, 10000052, 'When you do something wrong or fail to do something necessary, you can save yourself a lot of trouble by apologizing first before \r\nsomeone complains to you.\r\n', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 4 Apologies/lead-in 2.mp3', '2016-08-01 11:00:10'),
(79, 3, 10006, 10000052, 'When you apologize, sometimes you want to offer an excuse or reason. ', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 4 Apologies/lead-in 3.mp3', '2016-08-01 11:00:42'),
(80, 4, 10006, 10000052, 'The excuse is normally given immediately after the apology. ', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 4 Apologies/lead-in 4.mp3', '2016-08-01 11:01:25'),
(81, 5, 10006, 10000052, 'It is also important to make sure how to respond properly when someone apologizes to you.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 4 Apologies/lead-in 5.mp3', '2016-08-01 11:01:57'),
(82, 6, 10006, 10000052, 'This unit focuses on apologies, and its aim is to help you know how to make and respond to apologies.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 4 Apologies/lead-in 6.mp3', '2016-08-01 11:02:31'),
(83, 1, 10006, 10000060, 'Rhyming refers to a pair or series of words, or lines of poetry, which end with the same vowel-consonant sound, such as “house” and “mouse,” “school” and “fool.” Listen and choose the word from each group that is read aloud.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 4 Apologies/listening Focus1-A.mp3', '2016-08-01 11:04:54'),
(84, 1, 10006, 10000061, 'Listen and write down the word you hear in each blank; then choose the letter beside the word that rhymes with what you hear.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 4 Apologies/listening Focus1-B.mp3', '2016-08-01 11:05:58'),
(85, 1, 10006, 10000062, ' Listen to the following poem and underline the rhymed words; then read along.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 4 Apologies/listening Focus1-C.mp3', '2016-08-01 11:07:08'),
(86, 1, 10006, 10000063, 'Homonyms are words that are pronounced the same but have different spellings and meanings. Listen to the following ten sentences, choose the \r\nword you hear.\r\n', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 4 Apologies/listening Focus2-A.mp3', '2016-08-01 11:08:10'),
(87, 1, 10006, 10000064, ' In this part you\'ll hear ten sentences. Listen carefully and write down the homonyms you hear.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 4 Apologies/listening Focus2-B.mp3', '2016-08-01 11:09:20'),
(90, 1, 10006, 10000124, 'Listen to the following passage and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 4 Apologies/listening Practice3-A.mp3', '2016-08-01 11:14:15'),
(91, 1, 10006, 10000125, 'Listen to the following passage and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 4 Apologies/listening Practice3-B.mp3', '2016-08-01 11:15:30'),
(93, 1, 10007, 10000126, '“Invitation”is a familiar word, frequently making its appearance in our daily life and social activities. ', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 5  Invitations/lead-in 1.mp3', '2016-08-01 11:18:22'),
(94, 2, 10007, 10000126, 'Mastering this unit will help you to handle all kinds of invitations.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 5  Invitations/lead-in 2.mp3', '2016-08-01 11:18:55'),
(95, 1, 10007, 10000132, 'Listen to the following short passage and then complete the table below with the cardinal numbers you hear.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 5  Invitations/Listenning Focus 1-A.mp3', '2016-08-01 11:19:59'),
(96, 1, 10007, 10000133, 'Listen and complete the table below with the cardinal numbers you hear. About half of them have already been done. (With large numbers, starting from the left, you pronounce the numerals just before the first comma as “billions,” the second one “millions,” and the third one “thousands.”)', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 5  Invitations/Listenning Focus 1-B.mp3', '2016-08-01 11:21:17'),
(97, 1, 10007, 10000135, 'You will hear some sentences with ordinal numbers in them. As you listen, choose the correct ordinal number.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 5  Invitations/Listenning Focus 2-A.mp3', '2016-08-01 11:22:42'),
(98, 1, 10007, 10000136, 'Listen to the following sentences with ordinal numbers in them. Write down the correct numbers in the blanks. ', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 5  Invitations/Listenning Focus 2-B.mp3', '2016-08-01 11:23:50'),
(100, 1, 10007, 10000142, 'Listen to the following long conversation and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 5  Invitations/Listenning Practice 2-A.mp3', '2016-08-01 11:26:19'),
(101, 1, 10007, 10000143, 'Listen to the following long conversation and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 5  Invitations/Listenning Practice 2-B.mp3', '2016-08-01 11:27:21'),
(102, 1, 10007, 10000144, 'Listen to the following passage and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 5  Invitations/Listenning Practice 3-A.mp3', '2016-08-01 11:28:45'),
(103, 1, 10007, 10000145, 'Listen to the following passage and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 5  Invitations/Listenning Practice 3-B.mp3', '2016-08-01 11:29:54'),
(106, 1, 10008, 10000146, 'One day, while I was walking on the street, a foreigner stopped me to ask for directions. ', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 6 Asking for and Giving Directions/Lead-in 1.mp3', '2016-08-01 11:37:08'),
(107, 2, 10008, 10000146, 'Even though I listen to the English radio programs quite often, I still had trouble understanding his English.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 6 Asking for and Giving Directions/Lead-in 2.mp3', '2016-08-01 11:37:34'),
(108, 3, 10008, 10000146, 'I took out my pen and a piece of paper to draw a rough map for him.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 6 Asking for and Giving Directions/Lead-in 3.mp3', '2016-08-01 11:38:02'),
(109, 4, 10008, 10000146, 'After a few words of thanks he took my map and left.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 6 Asking for and Giving Directions/Lead-in 4.mp3', '2016-08-01 11:38:26'),
(110, 5, 10008, 10000146, 'People are usually helpful to strangers. ', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 6 Asking for and Giving Directions/Lead-in 5.mp3', '2016-08-01 11:38:49'),
(111, 6, 10008, 10000146, 'If you get lost, don\\\'t hesitate to ask for directions. ', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 6 Asking for and Giving Directions/Lead-in 6.mp3', '2016-08-01 11:39:13'),
(112, 7, 10008, 10000146, 'Now, get together in pairs and try to answer the following questions.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 6 Asking for and Giving Directions/Lead-in 7.mp3', '2016-08-01 11:39:47'),
(113, 1, 10008, 10000152, ' Listen to the following sentences carefully and choose the numbers you 	hear.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 6 Asking for and Giving Directions/Listening Focus 1-A.mp3', '2016-08-01 11:41:22'),
(114, 1, 10008, 10000153, 'Listen to the following short dialogues carefully and write down the numbers you hear.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 6 Asking for and Giving Directions/Listening Focus 1-B.mp3', '2016-08-01 11:42:28'),
(115, 1, 10008, 10000154, 'Listen to the following ten statements and choose the answers closest in meaning to them.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 6 Asking for and Giving Directions/Listening Focus 2-A.mp3', '2016-08-01 11:43:39'),
(116, 1, 10008, 10000155, 'Listen to the following short dialogues and  for each question below, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 6 Asking for and Giving Directions/Listening Focus 2-B.mp3', '2016-08-01 11:44:48'),
(118, 1, 10008, 10000158, 'Listen to the following long conversation and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 6 Asking for and Giving Directions/Listening Practice 2-A.mp3', '2016-08-01 11:47:17'),
(119, 1, 10008, 10000159, 'Listen to the following long conversation and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 6 Asking for and Giving Directions/Listening Practice 2-B.mp3', '2016-08-01 11:48:22'),
(120, 1, 10008, 10000161, 'Listen to the following passage and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 6 Asking for and Giving Directions/Listening Practice 3-A.mp3', '2016-08-01 11:49:26'),
(121, 1, 10008, 10000162, 'Listen to the following passage and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 6 Asking for and Giving Directions/Listening Practice 3-B.mp3', '2016-08-01 11:50:33'),
(123, 1, 10009, 10000164, 'Weather plays a very important role in people\\\'s daily life.\r\n', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 7 Weather/Lead-in 1.mp3', '2016-08-01 14:10:27'),
(124, 2, 10009, 10000164, 'There is a great difference in the climate between the northern part and the southern part of China.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 7 Weather/Lead-in 2.mp3', '2016-08-01 14:11:30'),
(125, 3, 10009, 10000164, 'In the South, summer is very hot and muggy with a lot of rain，while winter is mild with no snow at all.\r\n\r\n', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 7 Weather/Lead-in 3.mp3', '2016-08-01 14:12:31'),
(126, 4, 10009, 10000164, 'In the North, summer is sunny and mild，while winter is windy and cold with a lot of snow.\r\n', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 7 Weather/Lead-in 4.mp3', '2016-08-01 14:13:28'),
(127, 1, 10009, 10000170, 'Listen to the following statements and write down the date for each holiday.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 7 Weather/Listening Focus 1-A.mp3', '2016-08-01 14:14:53'),
(128, 1, 10009, 10000171, 'Listen to the following passage and write down the accurate time in each blank.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 7 Weather/Listening Focus 1-B.mp3', '2016-08-01 14:17:11'),
(129, 1, 10009, 10000172, 'Listen to the following short passage and fill in the accurate temperatures.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 7 Weather/Listening Focus 2-A.mp3', '2016-08-01 14:20:24'),
(130, 1, 10009, 10000173, 'Listen to the following statements and blacken the thermometer in each case to show the accurate temperature.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 7 Weather/Listening Focus 2-B.mp3', '2016-08-01 14:21:32'),
(132, 1, 10009, 10000178, 'Listen to the following long conversation and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 7 Weather/Listening Practice 2-A.mp3', '2016-08-01 14:24:09'),
(133, 1, 10009, 10000179, 'Listen to the following long conversation and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 7 Weather/Listening Practice 2-B.mp3', '2016-08-01 14:25:40'),
(134, 1, 10009, 10000180, 'Listen to the following passage and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 7 Weather/Listening Practice 3-A.mp3', '2016-08-01 14:27:16'),
(135, 1, 10009, 10000181, 'Listen to the following passage and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 7 Weather/Listening Practice 3-B.mp3', '2016-08-01 14:28:46'),
(137, 1, 10010, 10000182, 'When we have telephone conversations, we often need to leave a message or we may offer to take a message for others.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 8 Leaving and Taking Messages/Lead-in 1.mp3', '2016-08-01 14:31:53'),
(138, 2, 10010, 10000182, 'This unit will help us to be clear about how to leave and take telephone messages.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 8 Leaving and Taking Messages/Lead-in 2.mp3', '2016-08-01 14:33:02'),
(139, 1, 10010, 10000188, ' You will hear a series of sentences indicating certain sizes. As you listen, choose the correct size in each sentence.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 8 Leaving and Taking Messages/Listening Focus 1-A.mp3', '2016-08-01 14:34:23'),
(140, 1, 10010, 10000189, 'Listen to the following sentences and complete them by choosing the 	prices you hear.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 8 Leaving and Taking Messages/Listening Focus 1-B.mp3', '2016-08-01 14:35:17'),
(141, 1, 10010, 10000190, ' Listen to the following sentences and fill in the missing information.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 8 Leaving and Taking Messages/Listening Focus 2-A.mp3', '2016-08-01 14:36:21'),
(142, 1, 10010, 10000191, ' Listen to the following sentences and fill in the missing telephone numbers.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 8 Leaving and Taking Messages/Listening Focus 2-B.mp3', '2016-08-01 14:37:26'),
(144, 1, 10010, 10000196, 'Listen to the following long conversation and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 8 Leaving and Taking Messages/Listening Practice 2-A.mp3', '2016-08-01 14:39:30'),
(145, 1, 10010, 10000197, 'Listen to the following long conversation and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 8 Leaving and Taking Messages/Listening Practice 2-B.mp3', '2016-08-01 14:40:50'),
(146, 1, 10010, 10000198, 'Listen to the following passage and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 8 Leaving and Taking Messages/Listening Practice 3-A.mp3', '2016-08-01 14:42:05'),
(147, 1, 10010, 10000199, 'Listen to the following passage and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 8 Leaving and Taking Messages/Listening Practice 3-B.mp3', '2016-08-01 14:43:15'),
(153, 1, 10004, 10000226, 'Listen to the following five short conversations and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 2 Expressing Gratitude/Listening Practice 1.mp3', '2016-08-03 10:02:01'),
(154, 1, 10004, 10000227, 'Listen to the following long conversation and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 2 Expressing Gratitude/Listening Practice 2.mp3', '2016-08-03 10:03:22'),
(155, 1, 10004, 10000228, 'Listen to the following passage and then fill in the blanks with the exact words you have just heard.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 2 Expressing Gratitude/Listening Practice 4.mp3', '2016-08-03 10:04:36'),
(156, 1, 10005, 10000229, 'Listen to the following five short conversations and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 3 Partings/Listening Practice 1.mp3', '2016-08-03 10:07:32'),
(157, 1, 10005, 10000230, 'Listen to the following long conversation and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 3 Partings/Listening Practice 2.mp3', '2016-08-03 10:08:57'),
(158, 1, 10005, 10000231, 'Listen to the following passage and then fill in the blanks with the exact words you have just heard.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 3 Partings/Listening Practice 4.mp3', '2016-08-03 10:10:06'),
(159, 1, 10006, 10000232, 'Listen to the following five short conversations and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 4 Apologies/listening Practice1.mp3', '2016-08-03 10:12:41'),
(160, 1, 10006, 10000233, 'Listen to the following long conversation and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 4 Apologies/listening Practice2.mp3', '2016-08-03 10:14:11'),
(161, 1, 10006, 10000234, 'Listen to the following passage and then fill in the blanks with the exact words you have just heard. ', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 4 Apologies/listening Practice4.mp3', '2016-08-03 10:15:18'),
(162, 1, 10007, 10000235, 'Listen to the following five short conversations and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 5  Invitations/Listenning Practice 1.mp3', '2016-08-03 10:17:54'),
(163, 1, 10007, 10000236, 'Listen to the following passage and then fill in the blanks with the exact words you have just heard.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 5  Invitations/Listenning Practice 4.mp3', '2016-08-03 10:19:11'),
(164, 1, 10008, 10000237, 'Listen to the following five short conversations and then, for each question, select the best answer from among four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 6 Asking for and Giving Directions/Listening Practice 1.mp3', '2016-08-03 10:20:59'),
(165, 1, 10008, 10000238, 'Listen to the following passage and then fill in the blanks with the exact words you have just heard.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 6 Asking for and Giving Directions/Listening Practice 4.mp3', '2016-08-03 10:22:39'),
(166, 1, 10009, 10000239, 'Listen to the following five short conversations and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 7 Weather/Listening Practice 1.mp3', '2016-08-03 10:24:54'),
(167, 1, 10009, 10000240, 'Listen to the following passage and then fill in the blanks with the exact words you have just heard.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 7 Weather/Listening Practice 4.mp3', '2016-08-03 10:27:20'),
(168, 1, 10010, 10000241, 'Listen to the following five short conversations and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 8 Leaving and Taking Messages/Listening Practice 1.mp3', '2016-08-03 10:29:32'),
(169, 1, 10010, 10000242, 'Listen to the following passage and then fill in the blanks with the exact words you have just heard.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 8 Leaving and Taking Messages/Listening Practice 4.mp3', '2016-08-03 10:30:57'),
(176, 1, 10003, 10000243, 'What do you say when you want to start a conversation with someone you don\'t know', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 1 Greetings and Introductions/lead-in 1.mp3', '2016-09-06 11:15:22'),
(177, 2, 10003, 10000243, 'You could ask him where he lives', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 1 Greetings and Introductions/lead-in 2.mp3', '2016-09-06 11:16:40'),
(178, 1, 10003, 10000253, 'You will hear one word read aloud from each group. Select the appropriate choice, paying attention to the pronunciation of the different vowels.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 1 Greetings and Introductions/Listening Focus1-A.mp3', '2016-09-06 11:17:33'),
(179, 3, 10003, 10000243, 'But a sudden Where do you live sounds a little strange and rude', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 1 Greetings and Introductions/lead-in 3.mp3', '2016-09-06 11:17:47'),
(180, 1, 10003, 10000254, 'You will hear ten sentences. Each sentence contains two words which sound similar. Listen carefully and choose the word you hear. 	', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 1 Greetings and Introductions/Listening Focus1-B.mp3', '2016-09-06 11:18:20'),
(181, 1, 10003, 10000255, 'Listen to the following ten groups of words and choose the word in each group which contains the same consonant as the first word.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 1 Greetings and Introductions/Listening Focus2-A.mp3', '2016-09-06 11:19:58'),
(182, 4, 10003, 10000243, 'You could introduce yourself by saying Hello I\'m... ', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 1 Greetings and Introductions/lead-in 4.mp3', '2016-09-06 11:20:12'),
(183, 1, 10003, 10000256, 'You will hear fifteen sentences. Each sentence contains two words which sound similar. Listen carefully and choose the word you hear. ', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 1 Greetings and Introductions/Listening Focus2-B.mp3', '2016-09-06 11:20:37'),
(184, 1, 10003, 10000249, 'Listen to the following five short conversations and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 1 Greetings and Introductions/Listening Practice1.mp3', '2016-09-06 11:21:13'),
(187, 5, 10003, 10000243, 'There are two kinds of introductions introducing yourself and introducing someone else', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 1 Greetings and Introductions/lead-in 5.mp3', '2016-09-06 11:26:40'),
(188, 1, 10003, 10000260, 'Listen to the following five short conversations and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 1 Greetings and Introductions/Listening Practice1.mp3', '2016-09-06 11:26:48'),
(189, 1, 10003, 10000259, 'Listen to the following long conversation and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 1 Greetings and Introductions/Listening Practice2.mp3', '2016-09-06 11:28:02'),
(190, 6, 10003, 10000243, 'And there are also two kinds of greetings formal and informal greetings', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 1 Greetings and Introductions/lead-in 6.mp3', '2016-09-06 11:28:31'),
(191, 1, 10003, 10000257, 'Listen to the following passage and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 1 Greetings and Introductions/Listening Practice3-A.mp3', '2016-09-06 11:28:41'),
(192, 7, 10003, 10000243, 'In this unit you will learn how introductions and greeting are made', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 1 Greetings and Introductions/lead-in 7.mp3', '2016-09-06 11:29:13'),
(193, 1, 10003, 10000258, 'Listen to the following passage and then, for each question, select the best answer from among the four choices given.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 1 Greetings and Introductions/Listening Practice3-B.mp3', '2016-09-06 11:29:47'),
(195, 1, 10003, 10000261, 'Listen to the following passage and then fill in the blanks with the exact words you have just heard.', 't', 'english.bigtreechina.com/upload/listen/21世纪大学英语视听说教程1/Unit 1 Greetings and Introductions/Listening Practice4.mp3', '2016-09-06 11:49:29');

-- --------------------------------------------------------

--
-- Table structure for table `listen_unit`
--

CREATE TABLE `listen_unit` (
  `unitId` bigint(20) UNSIGNED NOT NULL,
  `bookId` int(10) UNSIGNED NOT NULL,
  `unitNum` varchar(20) NOT NULL,
  `unitName` varchar(100) NOT NULL,
  `unitDetail` varchar(100) NOT NULL,
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `listen_unit`
--

INSERT INTO `listen_unit` (`unitId`, `bookId`, `unitNum`, `unitName`, `unitDetail`, `updateTime`) VALUES
(10003, 108, '1', 'Unit 1 Greetings and Introductions', 'In this unit you will learn how introductions and greetings are made.', '2016-07-29 15:33:00'),
(10004, 108, '2', 'Unit 2 Expressing Gratitude', 'In this unit you will learn how to express gratitude.', '2016-07-29 15:34:29'),
(10005, 108, '3', 'Unit 3 Partings', 'You will learn how to express yourself appropriately when parting.', '2016-07-29 16:07:15'),
(10006, 108, '4', 'Unit 4 Apologies', 'Students are expected to know how to make an apology when necessary.', '2016-07-29 16:08:50'),
(10007, 108, '5', 'Unit 5  Invitations', 'In this unit you will be familiar with expressions about invitations.', '2016-07-29 16:24:55'),
(10008, 108, '6', 'Unit 6 Asking for and Giving Directions', 'Students should understand the language for asking for and giving directions.', '2016-08-01 10:17:38'),
(10009, 108, '7', 'Unit 7 Weather', 'What students should learn in this unit is to know how to describe  weather and climate.', '2016-08-01 10:21:30'),
(10010, 108, '8', 'Unit 8 Leaving and Taking Messages', 'Students are able to leave and take telephone messages.', '2016-08-01 10:26:44');

-- --------------------------------------------------------

--
-- Table structure for table `speak_article`
--

CREATE TABLE `speak_article` (
  `id` bigint(20) NOT NULL,
  `bookId` bigint(20) NOT NULL,
  `articleTitle` varchar(100) NOT NULL,
  `authorName` varchar(45) NOT NULL,
  `description` tinytext NOT NULL,
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `speak_article`
--

INSERT INTO `speak_article` (`id`, `bookId`, `articleTitle`, `authorName`, `description`, `updateTime`) VALUES
(100000001, 101, 'HelloWord', 'Jr.simith', 'helloWord', '2016-08-01 10:49:05');

-- --------------------------------------------------------

--
-- Table structure for table `speak_book`
--

CREATE TABLE `speak_book` (
  `id` bigint(20) NOT NULL,
  `categoryId` int(11) NOT NULL,
  `bookName` varchar(100) NOT NULL,
  `authorName` varchar(45) NOT NULL,
  `bookIsbn` varchar(45) NOT NULL,
  `description` text NOT NULL,
  `imageUrl` tinytext NOT NULL,
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `speak_book`
--

INSERT INTO `speak_book` (`id`, `categoryId`, `bookName`, `authorName`, `bookIsbn`, `description`, `imageUrl`, `updateTime`) VALUES
(101, 2, '大学英语教材1', '张君宝', '12345678', '搜集大学生日常用语100句', 'english.bigtreechina.com/upload/speak/大学英语教材1/863328641764645259.jpg', '2016-08-01 10:48:02');

-- --------------------------------------------------------

--
-- Table structure for table `speak_category`
--

CREATE TABLE `speak_category` (
  `id` int(11) NOT NULL,
  `categoryName` varchar(100) NOT NULL,
  `description` tinytext NOT NULL,
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `speak_category`
--

INSERT INTO `speak_category` (`id`, `categoryName`, `description`, `updateTime`) VALUES
(2, '日常口语练习', '大学英语常见口语100句', '2016-07-29 16:01:40');

-- --------------------------------------------------------

--
-- Table structure for table `speak_score`
--

CREATE TABLE `speak_score` (
  `id` bigint(20) NOT NULL,
  `userId` bigint(20) NOT NULL,
  `bookId` bigint(20) NOT NULL,
  `articleId` bigint(20) NOT NULL,
  `score` int(10) UNSIGNED NOT NULL,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `speak_sentence`
--

CREATE TABLE `speak_sentence` (
  `id` bigint(20) NOT NULL,
  `articleId` bigint(20) NOT NULL,
  `english` text NOT NULL,
  `chinese` text NOT NULL,
  `voiceUrl` tinytext NOT NULL,
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `speak_sentence`
--

INSERT INTO `speak_sentence` (`id`, `articleId`, `english`, `chinese`, `voiceUrl`, `updateTime`) VALUES
(2, 100000001, 'What do you say when you want to start a conversation with someone you don\'t know', 'gfergew', 'english.bigtreechina.com/upload/speak/大学英语教材1/HelloWord/lead-in 1.mp3', '2016-08-01 10:49:44'),
(3, 100000001, 'You could ask him where he lives', 'fwfw', '', '2016-08-01 10:50:08');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` bigint(20) NOT NULL,
  `account` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `gender` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `status` varchar(15) NOT NULL,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `account`, `password`, `gender`, `email`, `status`, `updateTime`) VALUES
(1, 'admin', '827ccb0eea8a706c4c34a16891f84e7b', '男', '222@qq.com', 'teacher', '2016-07-28 13:28:00'),
(2, '20160801', '25d55ad283aa400af464c76d713c07ad', '女', '724706059@qq.com', 'student', '2016-08-01 02:17:15'),
(3, '20160802', '25d55ad283aa400af464c76d713c07ad', '', '123456789@qq.com', 'student', '2016-08-04 01:26:41'),
(4, 'test1', '25d55ad283aa400af464c76d713c07ad', '男', '222@qq.com', 'student', '2016-08-29 03:42:46'),
(5, '12345678', '25d55ad283aa400af464c76d713c07ad', '', '1205149887@qq.com', 'student', '2016-08-30 07:11:43'),
(6, '20160831', '25d55ad283aa400af464c76d713c07ad', '女', '724706059@qq.com', 'student', '2016-08-31 01:38:21'),
(7, '11111111', '25d55ad283aa400af464c76d713c07ad', '', '123456789@qq.com', 'student', '2016-08-31 01:59:36'),
(8, '1302040101', '25d55ad283aa400af464c76d713c07ad', '', '1456494771@qq.com', 'student', '2016-09-05 02:16:26'),
(9, '', 'd41d8cd98f00b204e9800998ecf8427e', '男', '', 'student', '2016-09-05 06:33:20'),
(10, '14', '25f9e794323b453885f5181f1b624d0b', '男', '14', 'student', '2016-09-05 07:56:44'),
(11, '55', 'd41d8cd98f00b204e9800998ecf8427e', '男', '', 'student', '2016-09-05 08:20:41'),
(12, '20160905', '25d55ad283aa400af464c76d713c07ad', '女', '724706059@qq.com', 'student', '2016-09-05 12:10:22');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `listen_book`
--
ALTER TABLE `listen_book`
  ADD PRIMARY KEY (`bookId`),
  ADD UNIQUE KEY `bookName_UNIQUE` (`bookName`),
  ADD UNIQUE KEY `bookIsbn_UNIQUE` (`bookIsbn`),
  ADD KEY `FK_book_category_idx` (`categoryId`);

--
-- Indexes for table `listen_category`
--
ALTER TABLE `listen_category`
  ADD PRIMARY KEY (`categoryId`);

--
-- Indexes for table `listen_section`
--
ALTER TABLE `listen_section`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_pid_id_idx` (`pid`),
  ADD KEY `fk_listen_section_listen_unit1_idx` (`unitId`);

--
-- Indexes for table `listen_sentence`
--
ALTER TABLE `listen_sentence`
  ADD PRIMARY KEY (`sentenceId`),
  ADD KEY `FK_sentence_unit_idx` (`unitId`),
  ADD KEY `FK_sentence_section_idx` (`sectionId`);

--
-- Indexes for table `listen_unit`
--
ALTER TABLE `listen_unit`
  ADD PRIMARY KEY (`unitId`),
  ADD KEY `FK_unit_book_idx` (`bookId`);

--
-- Indexes for table `speak_article`
--
ALTER TABLE `speak_article`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `title_UNIQUE` (`articleTitle`),
  ADD KEY `FK_article_book_idx` (`bookId`);

--
-- Indexes for table `speak_book`
--
ALTER TABLE `speak_book`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `bookName_UNIQUE` (`bookName`),
  ADD UNIQUE KEY `bookISBN_UNIQUE` (`bookIsbn`),
  ADD KEY `FK_book_category_idx` (`categoryId`);

--
-- Indexes for table `speak_category`
--
ALTER TABLE `speak_category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `speak_score`
--
ALTER TABLE `speak_score`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_score_book_idx` (`bookId`),
  ADD KEY `FK_score_article_idx` (`articleId`),
  ADD KEY `FK_score_user_idx` (`userId`);

--
-- Indexes for table `speak_sentence`
--
ALTER TABLE `speak_sentence`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_sentence_article_idx` (`articleId`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `account_UNIQUE` (`account`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `listen_book`
--
ALTER TABLE `listen_book`
  MODIFY `bookId` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=109;
--
-- AUTO_INCREMENT for table `listen_category`
--
ALTER TABLE `listen_category`
  MODIFY `categoryId` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `listen_section`
--
ALTER TABLE `listen_section`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10000262;
--
-- AUTO_INCREMENT for table `listen_sentence`
--
ALTER TABLE `listen_sentence`
  MODIFY `sentenceId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=196;
--
-- AUTO_INCREMENT for table `listen_unit`
--
ALTER TABLE `listen_unit`
  MODIFY `unitId` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10011;
--
-- AUTO_INCREMENT for table `speak_article`
--
ALTER TABLE `speak_article`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100000002;
--
-- AUTO_INCREMENT for table `speak_book`
--
ALTER TABLE `speak_book`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;
--
-- AUTO_INCREMENT for table `speak_category`
--
ALTER TABLE `speak_category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `speak_score`
--
ALTER TABLE `speak_score`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `speak_sentence`
--
ALTER TABLE `speak_sentence`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `listen_book`
--
ALTER TABLE `listen_book`
  ADD CONSTRAINT `FK_listen_book_category` FOREIGN KEY (`categoryId`) REFERENCES `listen_category` (`categoryId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `listen_section`
--
ALTER TABLE `listen_section`
  ADD CONSTRAINT `FK_pid_id` FOREIGN KEY (`pid`) REFERENCES `listen_section` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_section_unit` FOREIGN KEY (`unitId`) REFERENCES `listen_unit` (`unitId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `listen_sentence`
--
ALTER TABLE `listen_sentence`
  ADD CONSTRAINT `FK_sentence_section` FOREIGN KEY (`sectionId`) REFERENCES `listen_section` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_sentence_unit` FOREIGN KEY (`unitId`) REFERENCES `listen_unit` (`unitId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `listen_unit`
--
ALTER TABLE `listen_unit`
  ADD CONSTRAINT `FK_unit_book` FOREIGN KEY (`bookId`) REFERENCES `listen_book` (`bookId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `speak_article`
--
ALTER TABLE `speak_article`
  ADD CONSTRAINT `FK_article_book` FOREIGN KEY (`bookId`) REFERENCES `speak_book` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `speak_book`
--
ALTER TABLE `speak_book`
  ADD CONSTRAINT `Fk_book_category` FOREIGN KEY (`categoryId`) REFERENCES `speak_category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `speak_score`
--
ALTER TABLE `speak_score`
  ADD CONSTRAINT `FK_score_article` FOREIGN KEY (`articleId`) REFERENCES `speak_article` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK_score_book` FOREIGN KEY (`bookId`) REFERENCES `speak_book` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK_score_user` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `speak_sentence`
--
ALTER TABLE `speak_sentence`
  ADD CONSTRAINT `FK_id_articleId` FOREIGN KEY (`articleId`) REFERENCES `speak_article` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
