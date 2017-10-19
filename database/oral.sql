-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: 2016-07-29 08:41:56
-- 服务器版本： 5.6.17
-- PHP Version: 5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `oral`
--

DELIMITER $$
--
-- 存储过程
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_article`(IN `_bookId` BIGINT UNSIGNED, IN `_title` VARCHAR(100), IN `_authorName` VARCHAR(45), OUT `id` BIGINT UNSIGNED)
main: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_book`(IN `name` VARCHAR(100), IN `author` VARCHAR(45), IN `isbn` VARCHAR(45), OUT `id` BIGINT UNSIGNED)
main: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_sentenceText`(IN `_parentId` BIGINT UNSIGNED, IN `_articleId` BIGINT UNSIGNED, IN `_content` TINYTEXT, IN `_lang` VARCHAR(45), OUT `id` BIGINT UNSIGNED)
main: BEGIN
		
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_sentenceVoice`(IN `_textId` BIGINT UNSIGNED, IN `_content` BLOB, OUT `id` BIGINT UNSIGNED)
main: BEGIN
	case when _textId is null || _textId <= 0 then begin set id := 0; leave main; end;
		 when _content is null then begin set id := 0; leave main; end;
	else begin end;
    end case;
    
	start transaction;
    insert into SentenceVoice(textId, content) values(_textId, _content);
	set id := last_insert_id();
    commit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_user`(IN `_username` VARCHAR(20), IN `_password` VARCHAR(100), OUT `id` BIGINT UNSIGNED)
main: BEGIN
	case when _username is null || _username = '' then begin set id := 0; leave main; end;
		 when _password is null || _password = '' then begin set id := 0; leave main; end;
         else begin end;
    end case;

	start transaction;
    insert into `User`(username, `password`) values(_username, md5(_password));
	set id := last_insert_id();
    commit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `attach_article_opts`(IN `_articleId` BIGINT UNSIGNED, IN `_akey` VARCHAR(20), IN `_avalue` VARCHAR(45))
main:BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `attach_book_opts`(IN `_bookid` BIGINT UNSIGNED, IN `_akey` VARCHAR(20), IN `_avalue` VARCHAR(45))
main:BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `attach_voice_opts`(IN `_voiceId` BIGINT UNSIGNED, IN `_akey` VARCHAR(20), IN `_avalue` VARCHAR(45))
main:BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_article_info`(IN `_id` BIGINT UNSIGNED, IN `verbose` BOOLEAN)
BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_book_info`(IN `_id` BIGINT UNSIGNED, IN `verbose` BOOLEAN)
BEGIN
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
-- 表的结构 `listen_book`
--

CREATE TABLE IF NOT EXISTS `listen_book` (
  `bookId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `categoryId` int(10) unsigned NOT NULL,
  `bookName` varchar(100) NOT NULL,
  `authorName` varchar(45) NOT NULL,
  `bookIsbn` varchar(45) NOT NULL,
  `description` tinytext NOT NULL,
  `imageUrl` tinytext NOT NULL,
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`bookId`),
  UNIQUE KEY `bookName_UNIQUE` (`bookName`),
  UNIQUE KEY `bookIsbn_UNIQUE` (`bookIsbn`),
  KEY `FK_book_category_idx` (`categoryId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=101 ;

--
-- 转存表中的数据 `listen_book`
--

INSERT INTO `listen_book` (`bookId`, `categoryId`, `bookName`, `authorName`, `bookIsbn`, `description`, `imageUrl`, `updateTime`) VALUES
(100, 1, 'book1', 'q', 'q', 'q', 'www.198.com\\upload\\listen\\book1\\51db5f89750ead2d574f2bfa45288f12.jpg', '2016-07-28 20:58:43');

-- --------------------------------------------------------

--
-- 表的结构 `listen_category`
--

CREATE TABLE IF NOT EXISTS `listen_category` (
  `categoryId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `categoryName` varchar(100) NOT NULL,
  `description` tinytext NOT NULL,
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`categoryId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `listen_category`
--

INSERT INTO `listen_category` (`categoryId`, `categoryName`, `description`, `updateTime`) VALUES
(1, '1', '         1       ', '2016-07-28 20:58:21');

-- --------------------------------------------------------

--
-- 表的结构 `listen_section`
--

CREATE TABLE IF NOT EXISTS `listen_section` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(10) unsigned DEFAULT NULL,
  `text` varchar(100) NOT NULL,
  `remark` tinytext,
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `unitId` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_pid_id_idx` (`pid`),
  KEY `fk_listen_section_listen_unit1_idx` (`unitId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=10000003 ;

--
-- 转存表中的数据 `listen_section`
--

INSERT INTO `listen_section` (`id`, `pid`, `text`, `remark`, `updateTime`, `unitId`) VALUES
(10000000, NULL, '去', '去', '2016-07-28 21:55:39', 10001),
(10000001, 10000000, '去', '去', '2016-07-28 21:55:51', 10001),
(10000002, NULL, '2', '2', '2016-07-28 21:59:23', 10002);

-- --------------------------------------------------------

--
-- 表的结构 `listen_sentence`
--

CREATE TABLE IF NOT EXISTS `listen_sentence` (
  `sentenceId` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `orderId` int(10) unsigned NOT NULL,
  `unitId` bigint(20) unsigned NOT NULL,
  `sectionId` int(10) unsigned NOT NULL,
  `english` text NOT NULL,
  `chinese` text,
  `voiceUrl` tinytext NOT NULL,
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`sentenceId`),
  KEY `FK_sentence_unit_idx` (`unitId`),
  KEY `FK_sentence_section_idx` (`sectionId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=28 ;

--
-- 转存表中的数据 `listen_sentence`
--

INSERT INTO `listen_sentence` (`sentenceId`, `orderId`, `unitId`, `sectionId`, `english`, `chinese`, `voiceUrl`, `updateTime`) VALUES
(23, 2, 10001, 10000001, '2', '2', 'www.198.com\\upload\\listen\\book1\\q\\So Deep.mp3', '2016-07-29 11:49:49'),
(25, 1, 10001, 10000001, '4', '4', 'www.198.com\\upload\\listen\\book1\\q\\So Deep.mp3', '2016-07-29 11:50:55');

-- --------------------------------------------------------

--
-- 表的结构 `listen_unit`
--

CREATE TABLE IF NOT EXISTS `listen_unit` (
  `unitId` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bookId` int(10) unsigned NOT NULL,
  `unitNum` varchar(20) NOT NULL,
  `unitName` varchar(100) NOT NULL,
  `unitDetail` varchar(100) NOT NULL,
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`unitId`),
  KEY `FK_unit_book_idx` (`bookId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=10003 ;

--
-- 转存表中的数据 `listen_unit`
--

INSERT INTO `listen_unit` (`unitId`, `bookId`, `unitNum`, `unitName`, `unitDetail`, `updateTime`) VALUES
(10001, 100, 'q', 'q', 'q', '2016-07-28 21:01:23'),
(10002, 100, '2', '2', '2', '2016-07-28 21:59:11');

-- --------------------------------------------------------

--
-- 表的结构 `speak_article`
--

CREATE TABLE IF NOT EXISTS `speak_article` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bookId` bigint(20) NOT NULL,
  `articleTitle` varchar(100) NOT NULL,
  `authorName` varchar(45) NOT NULL,
  `description` tinytext NOT NULL,
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `title_UNIQUE` (`articleTitle`),
  KEY `FK_article_book_idx` (`bookId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=100000001 ;

--
-- 转存表中的数据 `speak_article`
--

INSERT INTO `speak_article` (`id`, `bookId`, `articleTitle`, `authorName`, `description`, `updateTime`) VALUES
(100000000, 100, '1', '1', '1', '2016-07-28 20:58:01');

-- --------------------------------------------------------

--
-- 表的结构 `speak_book`
--

CREATE TABLE IF NOT EXISTS `speak_book` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `categoryId` int(11) NOT NULL,
  `bookName` varchar(100) NOT NULL,
  `authorName` varchar(45) NOT NULL,
  `bookIsbn` varchar(45) NOT NULL,
  `description` text NOT NULL,
  `imageUrl` tinytext NOT NULL,
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bookName_UNIQUE` (`bookName`),
  UNIQUE KEY `bookISBN_UNIQUE` (`bookIsbn`),
  KEY `FK_book_category_idx` (`categoryId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=101 ;

--
-- 转存表中的数据 `speak_book`
--

INSERT INTO `speak_book` (`id`, `categoryId`, `bookName`, `authorName`, `bookIsbn`, `description`, `imageUrl`, `updateTime`) VALUES
(100, 1, '1', '1', '1', '1', 'www.198.com\\upload\\speak\\1\\b2de9c82d158ccbf0bb0c18618d8bc3eb1354179.jpg', '2016-07-28 20:57:49');

-- --------------------------------------------------------

--
-- 表的结构 `speak_category`
--

CREATE TABLE IF NOT EXISTS `speak_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `categoryName` varchar(100) NOT NULL,
  `description` tinytext NOT NULL,
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `speak_category`
--

INSERT INTO `speak_category` (`id`, `categoryName`, `description`, `updateTime`) VALUES
(1, '1', '                1', '2016-07-28 20:57:32');

-- --------------------------------------------------------

--
-- 表的结构 `speak_score`
--

CREATE TABLE IF NOT EXISTS `speak_score` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `userId` bigint(20) NOT NULL,
  `bookId` bigint(20) NOT NULL,
  `articleId` bigint(20) NOT NULL,
  `score` int(10) unsigned NOT NULL,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_score_book_idx` (`bookId`),
  KEY `FK_score_article_idx` (`articleId`),
  KEY `FK_score_user_idx` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `speak_sentence`
--

CREATE TABLE IF NOT EXISTS `speak_sentence` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `articleId` bigint(20) NOT NULL,
  `english` text NOT NULL,
  `chinese` text NOT NULL,
  `voiceUrl` tinytext NOT NULL,
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_sentence_article_idx` (`articleId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `speak_sentence`
--

INSERT INTO `speak_sentence` (`id`, `articleId`, `english`, `chinese`, `voiceUrl`, `updateTime`) VALUES
(1, 100000000, 'w', '我', 'www.198.com\\upload\\speak\\1\\1\\So Deep.mp3', '2016-07-29 14:40:48');

-- --------------------------------------------------------

--
-- 表的结构 `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `gender` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_UNIQUE` (`account`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `user`
--

INSERT INTO `user` (`id`, `account`, `password`, `gender`, `email`, `updateTime`) VALUES
(1, 'admin', '827ccb0eea8a706c4c34a16891f84e7b', '男', '222@qq.com', '2016-07-28 13:28:00');

--
-- 限制导出的表
--

--
-- 限制表 `listen_book`
--
ALTER TABLE `listen_book`
  ADD CONSTRAINT `FK_listen_book_category` FOREIGN KEY (`categoryId`) REFERENCES `listen_category` (`categoryId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `listen_section`
--
ALTER TABLE `listen_section`
  ADD CONSTRAINT `FK_pid_id` FOREIGN KEY (`pid`) REFERENCES `listen_section` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_section_unit` FOREIGN KEY (`unitId`) REFERENCES `listen_unit` (`unitId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `listen_sentence`
--
ALTER TABLE `listen_sentence`
  ADD CONSTRAINT `FK_sentence_section` FOREIGN KEY (`sectionId`) REFERENCES `listen_section` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_sentence_unit` FOREIGN KEY (`unitId`) REFERENCES `listen_unit` (`unitId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `listen_unit`
--
ALTER TABLE `listen_unit`
  ADD CONSTRAINT `FK_unit_book` FOREIGN KEY (`bookId`) REFERENCES `listen_book` (`bookId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `speak_article`
--
ALTER TABLE `speak_article`
  ADD CONSTRAINT `FK_article_book` FOREIGN KEY (`bookId`) REFERENCES `speak_book` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `speak_book`
--
ALTER TABLE `speak_book`
  ADD CONSTRAINT `Fk_book_category` FOREIGN KEY (`categoryId`) REFERENCES `speak_category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `speak_score`
--
ALTER TABLE `speak_score`
  ADD CONSTRAINT `FK_score_article` FOREIGN KEY (`articleId`) REFERENCES `speak_article` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK_score_book` FOREIGN KEY (`bookId`) REFERENCES `speak_book` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK_score_user` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- 限制表 `speak_sentence`
--
ALTER TABLE `speak_sentence`
  ADD CONSTRAINT `FK_id_articleId` FOREIGN KEY (`articleId`) REFERENCES `speak_article` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
