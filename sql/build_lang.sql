-- build_lang.sql 
-- Author: Nikolas Wolfe 
-- Version: 0.1

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT=0;
START TRANSACTION;
SET time_zone = "+00:00";

--DROP DATABASE IF EXISTS clap_lang;
--CREATE DATABASE clap_lang;
USE languages;

-- table of country names
DROP TABLE IF EXISTS country;
CREATE TABLE IF NOT EXISTS country (
	ID bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	NAME varchar(128) NOT NULL,
	PRIMARY KEY (ID),
	UNIQUE KEY(NAME)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=0;

-- list of countries
INSERT INTO country (NAME) VALUES 
("Ghana"), 				-- id 1
("United States"), 		-- id 2
("Denmark"), 			-- id 3
("China"),				-- id 4
("Mali"),				-- id 5
("Brazil"),				-- id 6
("Burkina Faso"),		-- id 7
("Togo");				-- id 8

-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------

-- area qualifier
DROP TABLE IF EXISTS area_qualifier;
CREATE TABLE IF NOT EXISTS area_qualifier (
	ID bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	QUALIFIER varchar(128) NOT NULL,
	PRIMARY KEY (ID),
	UNIQUE KEY (QUALIFIER)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=0;

-- list of area_qualifiers
INSERT INTO area_qualifier (QUALIFIER) VALUES 
("REGION"),				-- id 1
("STATE"),				-- id 2
("PROVINCE"),			-- id 3
("CITY"),				-- id 4
("COUNTY"),				-- id 5
("VILLAGE"),			-- id 6
("TOWNSHIP"),			-- id 7
("TERRITORY");			-- id 8

-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------

-- table of regions
DROP TABLE IF EXISTS region;
CREATE TABLE IF NOT EXISTS region (
	ID bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	COUNTRY_ID bigint(20) unsigned NOT NULL,
	NAME varchar(128) NOT NULL,
	QUALIFIER_ID bigint(20) unsigned NOT NULL,
	PRIMARY KEY (ID, NAME),
	CONSTRAINT FOREIGN KEY (COUNTRY_ID) REFERENCES country (ID),
	CONSTRAINT FOREIGN KEY (QUALIFIER_ID) REFERENCES area_qualifier (ID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=0;

-- list of regions
INSERT INTO region (COUNTRY_ID, NAME, QUALIFIER_ID) VALUES
(1, "Greater Accra", 1),	-- id 1
(1, "Eastern", 1),			-- id 2
(1, "Ashanti", 1),			-- id 3
(1, "Volta", 1),			-- id 4
(1, "Northern", 1),			-- id 5
(1, "Central", 1),			-- id 6
(1, "Brong Ahafo", 1),		-- id 7
(1, "Upper West", 1),		-- id 8
(1, "Upper East", 1),		-- id 9
(1, "Western", 1),			-- id 10	
(5, "Koulikoro", 1),		-- id 11
(2, "Florida", 2);			-- id 12

-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------

-- table of areas (sub-regions and cities)
DROP TABLE IF EXISTS area;
CREATE TABLE IF NOT EXISTS area (
	ID bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	REGION_ID bigint(20) unsigned NOT NULL,
	NAME varchar(128) NOT NULL,
	QUALIFIER_ID bigint(20) unsigned,
	PRIMARY KEY (ID, NAME),
	CONSTRAINT FOREIGN KEY (REGION_ID) REFERENCES region (ID),
	CONSTRAINT FOREIGN KEY (QUALIFIER_ID) REFERENCES area_qualifier (ID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=0;

-- list of regions
INSERT INTO area (REGION_ID, NAME, QUALIFIER_ID) VALUES
(2, "Akropong", 7),			-- id 1
(8, "Jirapa", 4),			-- id 2
(7, "Sampa", 4),			-- id 3
(11, "Koulikoro", 4),		-- id 4
(5, "Tamale", 4),			-- id 5
(6, "Cape Coast", 4),		-- id 6
(4, "Akatsi", 7),			-- id 7
(8, "Dupare", 6),			-- id 8
(5, "Bole", 7),				-- id 9
(1, "Accra", 4),			-- id 10
(7, "Sunyani", 4),			-- id 11
(3, "Kumasi", 4),			-- id 12
(12, "Miami", 4);			-- id 13

-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------

-- table of languages
DROP TABLE IF EXISTS lang;
CREATE TABLE IF NOT EXISTS lang (
	ID bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	NAME varchar(128) NOT NULL,
	PRIMARY KEY (ID),
	UNIQUE KEY (NAME)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=0;

-- list of languages and area identifiers
INSERT INTO lang (NAME) VALUES
("Twi"),				-- id 1
("Dagaare"),			-- id 2
("Jula"),				-- id 3
("Nafaanra"),			-- id 4
("Bambara"),			-- id 5
("Dagbani"),			-- id 6
("Fante"),				-- id 7
("Ewe"),				-- id 8
("Waale"),				-- id 9
("Gonja"),				-- id 10
("Ga"),					-- id 11
("English"),			-- id 12
("Spanish");			-- id 13

-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------

-- table of dialects
DROP TABLE IF EXISTS dialect;
CREATE TABLE IF NOT EXISTS dialect (
	ID bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	NAME varchar(128) NOT NULL,
	LANG_ID bigint(20) unsigned NOT NULL,
	PRIMARY KEY (ID, NAME),
	CONSTRAINT FOREIGN KEY (LANG_ID) REFERENCES lang (ID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=0;

-- list of languages and area identifiers
INSERT INTO dialect (NAME, LANG_ID) VALUES
("Akuapem", 1),		-- id 1
("Bono", 1),		-- id 2
("Asante", 1);		-- id 3

-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------

-- table of language mappings
DROP TABLE IF EXISTS lang_map;
CREATE TABLE IF NOT EXISTS lang_map (
	ID bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	LANG_ID bigint(20) unsigned NOT NULL,
	AREA_ID bigint(20) unsigned DEFAULT NULL,
	REGION_ID bigint(20) unsigned DEFAULT NULL,
	COUNTRY_ID bigint(20) unsigned DEFAULT NULL,
	PRIMARY KEY (ID),
	CONSTRAINT FOREIGN KEY (LANG_ID) REFERENCES lang (ID),
	CONSTRAINT FOREIGN KEY (AREA_ID) REFERENCES area (ID),
	CONSTRAINT FOREIGN KEY (REGION_ID) REFERENCES region (ID),
	CONSTRAINT FOREIGN KEY (COUNTRY_ID) REFERENCES country (ID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=0;

-- list of languages and area identifiers
INSERT INTO lang_map (LANG_ID, AREA_ID, REGION_ID, COUNTRY_ID) VALUES
(1, 1, NULL, NULL),		-- Twi, Akropong
(1, 11, NULL, NULL),	-- Twi, Sunyani
(1, 12, NULL, NULL),	-- Twi, Kumasi
(1, NULL, 1, NULL),		-- Twi, Greater Accra
(1, NULL, 2, NULL),		-- Twi, Eastern
(1, NULL, 3, NULL),		-- Twi, Ashanti
(1, NULL, 6, NULL),		-- Twi, Central
(1, NULL, 7, NULL),		-- Twi, Brong Ahafo
(1, NULL, 10, NULL),	-- Twi, Western
(2, 2, NULL, NULL),		-- Dagaare, Jirapa
(2, NULL, 8, NULL),		-- Dagaare, Upper West
(3, 3, NULL, NULL),		-- Jula, Sampa
(3, NULL, 7, NULL),		-- Jula, Brong Ahafo
(3, NULL, 7, NULL),		-- Jula, Upper West
(4, 3, NULL, NULL),		-- Nafaanra, Sampa
(4, NULL, 7, NULL),		-- Nafaanra, Brong Ahafo
(5, 4, NULL, NULL),		-- Bambara, Koulikoro City
(5, NULL, 11, NULL),	-- Bambara, Koulikoro Region
(5, NULL, NULL, 5),		-- Bambara, Mali
(6, 5, NULL, NULL),		-- Dagbani, Tamale
(6, NULL, 5, NULL),		-- Dagbani, Northern
(7, 6, NULL, NULL),		-- Fante, Cape Coast
(7, NULL, 6, NULL),		-- Fante, Central
(8, 7, NULL, NULL),		-- Ewe, Akatsi
(8, NULL, 4, NULL),		-- Ewe, Volta
(8, NULL, NULL, 8),		-- Ewe, Togo
(9, 8, NULL, NULL),		-- Waale, Dupare
(9, NULL, 8, NULL),		-- Waale, Upper West
(10, 9, NULL, NULL),	-- Gonja, Bole
(10, NULL, 5, NULL),	-- Gonja, Northern Region
(11, 10, NULL, NULL),	-- Ga, Accra
(11, NULL, 1, NULL),	-- Ga, Greater Accra
(12, NULL, NULL, 1),	-- English, Ghana
(12, NULL, NULL, 2),	-- English, USA
(13, NULL, NULL, 2),	-- Spanish, USA
(13, NULL, 12, NULL),	-- Spanish, Florida
(13, 13, NULL, NULL),	-- Spanish, Miami
(12, NULL, 12, NULL),	-- English, Florida
(12, 13, NULL, NULL);	-- English, Miami

-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------

-- table of language mappings
DROP TABLE IF EXISTS dialect_map;
CREATE TABLE IF NOT EXISTS dialect_map (
	ID bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	DIALECT_ID bigint(20) unsigned NOT NULL,
	AREA_ID bigint(20) unsigned DEFAULT NULL,
	REGION_ID bigint(20) unsigned DEFAULT NULL,
	COUNTRY_ID bigint(20) unsigned DEFAULT NULL,
	PRIMARY KEY (ID),
	CONSTRAINT FOREIGN KEY (DIALECT_ID) REFERENCES dialect (ID),
	CONSTRAINT FOREIGN KEY (AREA_ID) REFERENCES area (ID),
	CONSTRAINT FOREIGN KEY (REGION_ID) REFERENCES region (ID),
	CONSTRAINT FOREIGN KEY (COUNTRY_ID) REFERENCES country (ID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=0;

-- list of languages and area identifiers
INSERT INTO dialect_map (DIALECT_ID, AREA_ID, REGION_ID, COUNTRY_ID) VALUES
(1, 1, NULL, NULL),		-- Akuapem, Akropong
(2, 11, NULL, NULL),	-- Bono, Sunyani
(2, NULL, 7, NULL),		-- Bono, Brong Ahafo
(3, 12, NULL, NULL),	-- Asante, Kumasi
(3, NULL, 3, NULL);		-- Asante, Ashanti

-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------

-- table of language lessons
DROP TABLE IF EXISTS lang_lesson;
CREATE TABLE IF NOT EXISTS lang_lesson (
	ID bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	LANG_ID bigint(20) unsigned DEFAULT NULL,
	DIALECT_ID bigint(20) unsigned DEFAULT NULL,
	DISPLAY_NAME varchar(128) NOT NULL,
	URL varchar(128) DEFAULT NULL,
	PRIMARY KEY (ID),
	CONSTRAINT FOREIGN KEY (LANG_ID) REFERENCES lang (ID),
	CONSTRAINT FOREIGN KEY (DIALECT_ID) REFERENCES dialect (ID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=0;

-- inserts
INSERT INTO lang_lesson (LANG_ID, DIALECT_ID, DISPLAY_NAME, URL) VALUES
-- Akuapem
(NULL, 1, "Akuapem Lesson 1", "/akuapem/audio/Akuapem Lesson 1.mp3"),
(NULL, 1, "Akuapem Lesson 2", "/akuapem/audio/Akuapem Lesson 2.mp3"),
(NULL, 1, "Akuapem Lesson 3", "/akuapem/audio/Akuapem Lesson 3.mp3"),
(NULL, 1, "Akuapem Lesson 4", "/akuapem/audio/Akuapem Lesson 4.mp3"),
(NULL, 1, "Akuapem Lesson 5", "/akuapem/audio/Akuapem Lesson 5.mp3"),
(NULL, 1, "Akuapem Lesson 6", "/akuapem/audio/Akuapem Lesson 6.mp3"),
(NULL, 1, "Akuapem Lesson 7", "/akuapem/audio/Akuapem Lesson 7.mp3"),
(NULL, 1, "Akuapem Lesson 8", "/akuapem/audio/Akuapem Lesson 8.mp3"),
(NULL, 1, "Akuapem Lesson 9", "/akuapem/audio/Akuapem Lesson 9.mp3"),
(NULL, 1, "Akuapem Lesson 10", "/akuapem/audio/Akuapem Lesson 10.mp3"),
-- Bambara
(5, NULL, "Bambara Lesson 1", "/bambara/audio/Bambara Lesson 1.mp3"),
(5, NULL, "Bambara Lesson 2", "/bambara/audio/Bambara Lesson 2.mp3"),
(5, NULL, "Bambara Lesson 3", "/bambara/audio/Bambara Lesson 3.mp3"),
(5, NULL, "Bambara Lesson 4", "/bambara/audio/Bambara Lesson 4.mp3"),
(5, NULL, "Bambara Lesson 5", "/bambara/audio/Bambara Lesson 5.mp3"),
(5, NULL, "Bambara Lesson 6", "/bambara/audio/Bambara Lesson 6.mp3"),
(5, NULL, "Bambara Lesson 7", "/bambara/audio/Bambara Lesson 7.mp3"),
(5, NULL, "Bambara Lesson 8", "/bambara/audio/Bambara Lesson 8.mp3"),
(5, NULL, "Bambara Lesson 9", "/bambara/audio/Bambara Lesson 9.mp3"),
(5, NULL, "Bambara Lesson 10", "/bambara/audio/Bambara Lesson 10.mp3"),
-- Dagaare
(2, NULL, "Dagaare Lesson 1", "/dagaare/audio/Dagaare Lesson 1.mp3"),
(2, NULL, "Dagaare Lesson 2", "/dagaare/audio/Dagaare Lesson 2.mp3"),
(2, NULL, "Dagaare Lesson 3", "/dagaare/audio/Dagaare Lesson 3.mp3"),
(2, NULL, "Dagaare Lesson 4", "/dagaare/audio/Dagaare Lesson 4.mp3"),
(2, NULL, "Dagaare Lesson 5", "/dagaare/audio/Dagaare Lesson 5.mp3"),
(2, NULL, "Dagaare Lesson 6", "/dagaare/audio/Dagaare Lesson 6.mp3"),
(2, NULL, "Dagaare Lesson 7", "/dagaare/audio/Dagaare Lesson 7.mp3"),
(2, NULL, "Dagaare Lesson 8", "/dagaare/audio/Dagaare Lesson 8.mp3"),
(2, NULL, "Dagaare Lesson 9", "/dagaare/audio/Dagaare Lesson 9.mp3"),
(2, NULL, "Dagaare Lesson 10", "/dagaare/audio/Dagaare Lesson 10.mp3"),
-- Dagbani
(6, NULL, "Dagbani Lesson 1", "/dagbani/audio/Dagbani Lesson 1.mp3"),
(6, NULL, "Dagbani Lesson 2", "/dagbani/audio/Dagbani Lesson 2.mp3"),
(6, NULL, "Dagbani Lesson 3", "/dagbani/audio/Dagbani Lesson 3.mp3"),
(6, NULL, "Dagbani Lesson 4", "/dagbani/audio/Dagbani Lesson 4.mp3"),
(6, NULL, "Dagbani Lesson 5", "/dagbani/audio/Dagbani Lesson 5.mp3"),
(6, NULL, "Dagbani Lesson 6", "/dagbani/audio/Dagbani Lesson 6.mp3"),
(6, NULL, "Dagbani Lesson 7", "/dagbani/audio/Dagbani Lesson 7.mp3"),
(6, NULL, "Dagbani Lesson 8", "/dagbani/audio/Dagbani Lesson 8.mp3"),
(6, NULL, "Dagbani Lesson 9", "/dagbani/audio/Dagbani Lesson 9.mp3"),
(6, NULL, "Dagbani Lesson 10", "/dagbani/audio/Dagbani Lesson 10.mp3"),
-- Ewe
(8, NULL, "Ewe Lesson 1", "/ewe/audio/Ewe Lesson 1.mp3"),
(8, NULL, "Ewe Lesson 2", "/ewe/audio/Ewe Lesson 2.mp3"),
(8, NULL, "Ewe Lesson 3", "/ewe/audio/Ewe Lesson 3.mp3"),
(8, NULL, "Ewe Lesson 4", "/ewe/audio/Ewe Lesson 4.mp3"),
(8, NULL, "Ewe Lesson 5", "/ewe/audio/Ewe Lesson 5.mp3"),
(8, NULL, "Ewe Lesson 6", "/ewe/audio/Ewe Lesson 6.mp3"),
(8, NULL, "Ewe Lesson 7", "/ewe/audio/Ewe Lesson 7.mp3"),
(8, NULL, "Ewe Lesson 8", "/ewe/audio/Ewe Lesson 8.mp3"),
(8, NULL, "Ewe Lesson 9", "/ewe/audio/Ewe Lesson 9.mp3"),
(8, NULL, "Ewe Lesson 10", "/ewe/audio/Ewe Lesson 10.mp3"),
-- Fante
(7, NULL, "Fante Lesson 1", "/fante/audio/Fante Lesson 1.mp3"),
(7, NULL, "Fante Lesson 2", "/fante/audio/Fante Lesson 2.mp3"),
(7, NULL, "Fante Lesson 3", "/fante/audio/Fante Lesson 3.mp3"),
(7, NULL, "Fante Lesson 4", "/fante/audio/Fante Lesson 4.mp3"),
(7, NULL, "Fante Lesson 5", "/fante/audio/Fante Lesson 5.mp3"),
(7, NULL, "Fante Lesson 6", "/fante/audio/Fante Lesson 6.mp3"),
(7, NULL, "Fante Lesson 7", "/fante/audio/Fante Lesson 7.mp3"),
(7, NULL, "Fante Lesson 8", "/fante/audio/Fante Lesson 8.mp3"),
(7, NULL, "Fante Lesson 9", "/fante/audio/Fante Lesson 9.mp3"),
(7, NULL, "Fante Lesson 10", "/fante/audio/Fante Lesson 10.mp3"),
-- Gonja
(10, NULL, "Gonja Lesson 1", "/gonja/audio/Gonja Lesson 1.mp3"),
(10, NULL, "Gonja Lesson 2", "/gonja/audio/Gonja Lesson 2.mp3"),
(10, NULL, "Gonja Lesson 3", "/gonja/audio/Gonja Lesson 3.mp3"),
(10, NULL, "Gonja Lesson 4", "/gonja/audio/Gonja Lesson 4.mp3"),
(10, NULL, "Gonja Lesson 5", "/gonja/audio/Gonja Lesson 5.mp3"),
(10, NULL, "Gonja Lesson 6", "/gonja/audio/Gonja Lesson 6.mp3"),
(10, NULL, "Gonja Lesson 7", "/gonja/audio/Gonja Lesson 7.mp3"),
(10, NULL, "Gonja Lesson 8", "/gonja/audio/Gonja Lesson 8.mp3"),
(10, NULL, "Gonja Lesson 9", "/gonja/audio/Gonja Lesson 9.mp3"),
(10, NULL, "Gonja Lesson 10", "/gonja/audio/Gonja Lesson 10.mp3"),
-- Jula
(3, NULL, "Jula Lesson 1", "/jula/audio/Jula Lesson 1.mp3"),
(3, NULL, "Jula Lesson 2", "/jula/audio/Jula Lesson 2.mp3"),
(3, NULL, "Jula Lesson 3", "/jula/audio/Jula Lesson 3.mp3"),
(3, NULL, "Jula Lesson 4", "/jula/audio/Jula Lesson 4.mp3"),
(3, NULL, "Jula Lesson 5", "/jula/audio/Jula Lesson 5.mp3"),
(3, NULL, "Jula Lesson 6", "/jula/audio/Jula Lesson 6.mp3"),
(3, NULL, "Jula Lesson 7", "/jula/audio/Jula Lesson 7.mp3"),
(3, NULL, "Jula Lesson 8", "/jula/audio/Jula Lesson 8.mp3"),
(3, NULL, "Jula Lesson 9", "/jula/audio/Jula Lesson 9.mp3"),
(3, NULL, "Jula Lesson 10", "/jula/audio/Jula Lesson 10.mp3"),
-- Nafaanra
(4, NULL, "Nafaanra Lesson 1", NULL),
(4, NULL, "Nafaanra Lesson 2", NULL),
(4, NULL, "Nafaanra Lesson 3", NULL),
(4, NULL, "Nafaanra Lesson 4", NULL),
(4, NULL, "Nafaanra Lesson 5", NULL),
(4, NULL, "Nafaanra Lesson 6", NULL),
(4, NULL, "Nafaanra Lesson 7", NULL),
(4, NULL, "Nafaanra Lesson 8", NULL),
(4, NULL, "Nafaanra Lesson 9", NULL),
(4, NULL, "Nafaanra Lesson 10", NULL),
-- Waale
(9, NULL, "Waale Lesson 1", "/waale/audio/Waale Lesson 1.mp3"),
(9, NULL, "Waale Lesson 2", "/waale/audio/Waale Lesson 2.mp3"),
(9, NULL, "Waale Lesson 3", "/waale/audio/Waale Lesson 3.mp3"),
(9, NULL, "Waale Lesson 4", "/waale/audio/Waale Lesson 4.mp3"),
(9, NULL, "Waale Lesson 5", "/waale/audio/Waale Lesson 5.mp3"),
(9, NULL, "Waale Lesson 6", "/waale/audio/Waale Lesson 6.mp3"),
(9, NULL, "Waale Lesson 7", "/waale/audio/Waale Lesson 7.mp3"),
(9, NULL, "Waale Lesson 8", "/waale/audio/Waale Lesson 8.mp3"),
(9, NULL, "Waale Lesson 9", "/waale/audio/Waale Lesson 9.mp3"),
(9, NULL, "Waale Lesson 10", "/waale/audio/Waale Lesson 10.mp3");

-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------

-- table of language scripts
DROP TABLE IF EXISTS lang_script;
CREATE TABLE IF NOT EXISTS lang_script (
	ID bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	LANG_ID bigint(20) unsigned DEFAULT NULL,
	DIALECT_ID bigint(20) unsigned DEFAULT NULL,
	DISPLAY_NAME varchar(128) NOT NULL,
	URL varchar(255) DEFAULT NULL,
	PRIMARY KEY (ID),
	CONSTRAINT FOREIGN KEY (LANG_ID) REFERENCES lang (ID),
	CONSTRAINT FOREIGN KEY (DIALECT_ID) REFERENCES dialect (ID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=0;

-- inserts
INSERT INTO lang_script (LANG_ID, DIALECT_ID, DISPLAY_NAME, URL) VALUES
-- Akuapem
(NULL, 1, "Akuapem Lesson 1", "/akuapem/Akuapem Lesson 1.doc"),
(NULL, 1, "Akuapem Lesson 2", "/akuapem/Akuapem Lesson 2.doc"),
(NULL, 1, "Akuapem Lesson 3", "/akuapem/Akuapem Lesson 3.doc"),
(NULL, 1, "Akuapem Lesson 4", "/akuapem/Akuapem Lesson 4.doc"),
(NULL, 1, "Akuapem Lesson 5", "/akuapem/Akuapem Lesson 5.doc"),
(NULL, 1, "Akuapem Lesson 6", "/akuapem/Akuapem Lesson 6.doc"),
(NULL, 1, "Akuapem Lesson 7", "/akuapem/Akuapem Lesson 7.doc"),
(NULL, 1, "Akuapem Lesson 8", "/akuapem/Akuapem Lesson 8.doc"),
(NULL, 1, "Akuapem Lesson 9", "/akuapem/Akuapem Lesson 9.doc"),
(NULL, 1, "Akuapem Lesson 10", "/akuapem/Akuapem Lesson 10.doc"),
-- Bambara
(5, NULL, "Bambara Lesson 1", "/bambara/Lesson 1.xls"),
(5, NULL, "Bambara Lesson 2", "/bambara/Lesson 2.xls"),
(5, NULL, "Bambara Lesson 3", "/bambara/Lesson 3.xls"),
(5, NULL, "Bambara Lesson 4", "/bambara/Lesson 4.xls"),
(5, NULL, "Bambara Lesson 5", "/bambara/Lesson 5.xls"),
(5, NULL, "Bambara Lesson 6", "/bambara/Lesson 6.xls"),
(5, NULL, "Bambara Lesson 7", "/bambara/Lesson 7.xls"),
(5, NULL, "Bambara Lesson 8", "/bambara/Lesson 8.xls"),
(5, NULL, "Bambara Lesson 9", "/bambara/Lesson 9.xls"),
(5, NULL, "Bambara Lesson 10", "/bambara/Lesson 10.xls"),
-- Dagaare
(2, NULL, "Dagaare Lesson 1", "/dagaare/Lesson 1.xls"),
(2, NULL, "Dagaare Lesson 2", "/dagaare/Lesson 2.xls"),
(2, NULL, "Dagaare Lesson 3", "/dagaare/Lesson 3.xls"),
(2, NULL, "Dagaare Lesson 4", "/dagaare/Lesson 4.xls"),
(2, NULL, "Dagaare Lesson 5", "/dagaare/Lesson 5.xls"),
(2, NULL, "Dagaare Lesson 6", "/dagaare/Lesson 6.xls"),
(2, NULL, "Dagaare Lesson 7", "/dagaare/Lesson 7.xls"),
(2, NULL, "Dagaare Lesson 8", "/dagaare/Lesson 8.xls"),
(2, NULL, "Dagaare Lesson 9", "/dagaare/Lesson 9.xls"),
(2, NULL, "Dagaare Lesson 10", "/dagaare/Lesson 10.xls"),
-- Dagbani
(6, NULL, "Dagbani Lesson 1", "/dagbani/Dagbani Lesson 1.doc"),
(6, NULL, "Dagbani Lesson 2", "/dagbani/Dagbani Lesson 2.doc"),
(6, NULL, "Dagbani Lesson 3", "/dagbani/Dagbani Lesson 3.doc"),
(6, NULL, "Dagbani Lesson 4", "/dagbani/Dagbani Lesson 4.doc"),
(6, NULL, "Dagbani Lesson 5", "/dagbani/Dagbani Lesson 5.doc"),
(6, NULL, "Dagbani Lesson 6", "/dagbani/Dagbani Lesson 6.doc"),
(6, NULL, "Dagbani Lesson 7", "/dagbani/Dagbani Lesson 7.doc"),
(6, NULL, "Dagbani Lesson 8", "/dagbani/Dagbani Lesson 8.doc"),
(6, NULL, "Dagbani Lesson 9", "/dagbani/Dagbani Lesson 9.doc"),
(6, NULL, "Dagbani Lesson 10", "/dagbani/Dagbani Lesson 10.doc"),
-- Ewe
(8, NULL, "Ewe Lesson 1", "/ewe/Lesson 1.xls"),
(8, NULL, "Ewe Lesson 2", "/ewe/Lesson 2.xls"),
(8, NULL, "Ewe Lesson 3", "/ewe/Lesson 3.xls"),
(8, NULL, "Ewe Lesson 4", "/ewe/Lesson 4.xls"),
(8, NULL, "Ewe Lesson 5", "/ewe/Lesson 5.xls"),
(8, NULL, "Ewe Lesson 6", "/ewe/Lesson 6.xls"),
(8, NULL, "Ewe Lesson 7", "/ewe/Lesson 7.xls"),
(8, NULL, "Ewe Lesson 8", "/ewe/Lesson 8.xls"),
(8, NULL, "Ewe Lesson 9", "/ewe/Lesson 9.xls"),
(8, NULL, "Ewe Lesson 10", "/ewe/Lesson 10.xls"),
-- Fante
(7, NULL, "Fante Lesson 1", "/fante/Mfantse Lesson 1.doc"),
(7, NULL, "Fante Lesson 2", "/fante/Mfantse Lesson 2.doc"),
(7, NULL, "Fante Lesson 3", "/fante/Mfantse Lesson 3.doc"),
(7, NULL, "Fante Lesson 4", "/fante/Mfantse Lesson 4.doc"),
(7, NULL, "Fante Lesson 5", "/fante/Mfantse Lesson 5.doc"),
(7, NULL, "Fante Lesson 6", "/fante/Mfantse Lesson 6.doc"),
(7, NULL, "Fante Lesson 7", "/fante/Mfantse Lesson 7.doc"),
(7, NULL, "Fante Lesson 8", "/fante/Mfantse Lesson 8.doc"),
(7, NULL, "Fante Lesson 9", "/fante/Mfantse Lesson 9.doc"),
(7, NULL, "Fante Lesson 10", "/fante/Mfantse Lesson 10.doc"),
-- Gonja
(10, NULL, "Gonja Lesson 1", "/gonja/Lesson 1.xls"),
(10, NULL, "Gonja Lesson 2", "/gonja/Lesson 2.xls"),
(10, NULL, "Gonja Lesson 3", "/gonja/Lesson 3.xls"),
(10, NULL, "Gonja Lesson 4", "/gonja/Lesson 4.xls"),
(10, NULL, "Gonja Lesson 5", "/gonja/Lesson 5.xls"),
(10, NULL, "Gonja Lesson 6", "/gonja/Lesson 6.xls"),
(10, NULL, "Gonja Lesson 7", "/gonja/Lesson 7.xls"),
(10, NULL, "Gonja Lesson 8", "/gonja/Lesson 8.xls"),
(10, NULL, "Gonja Lesson 9", "/gonja/Lesson 9.xls"),
(10, NULL, "Gonja Lesson 10", "/gonja/Lesson 10.xls"),
-- Jula
(3, NULL, "Jula Lesson 1", "/jula/Lesson 1.xls"),
(3, NULL, "Jula Lesson 2", "/jula/Lesson 2.xls"),
(3, NULL, "Jula Lesson 3", "/jula/Lesson 3.xls"),
(3, NULL, "Jula Lesson 4", "/jula/Lesson 4.xls"),
(3, NULL, "Jula Lesson 5", "/jula/Lesson 5.xls"),
(3, NULL, "Jula Lesson 6", "/jula/Lesson 6.xls"),
(3, NULL, "Jula Lesson 7", "/jula/Lesson 7.xls"),
(3, NULL, "Jula Lesson 8", "/jula/Lesson 8.xls"),
(3, NULL, "Jula Lesson 9", "/jula/Lesson 9.xls"),
(3, NULL, "Jula Lesson 10", "/jula/Lesson 10.xls"),
-- Nafaanra
(4, NULL, "Nafaanra Lesson 1", "/nafaanra/Lesson 1.xls"),
(4, NULL, "Nafaanra Lesson 2", "/nafaanra/Lesson 2.xls"),
(4, NULL, "Nafaanra Lesson 3", "/nafaanra/Lesson 3.xls"),
(4, NULL, "Nafaanra Lesson 4", "/nafaanra/Lesson 4.xls"),
(4, NULL, "Nafaanra Lesson 5", "/nafaanra/Lesson 5.xls"),
(4, NULL, "Nafaanra Lesson 6", "/nafaanra/Lesson 6.xls"),
(4, NULL, "Nafaanra Lesson 7", "/nafaanra/Lesson 7.xls"),
(4, NULL, "Nafaanra Lesson 8", "/nafaanra/Lesson 8.xls"),
(4, NULL, "Nafaanra Lesson 9", "/nafaanra/Lesson 9.xls"),
(4, NULL, "Nafaanra Lesson 10", "/nafaanra/Lesson 10.xls"),
-- Waale
(9, NULL, "Waale Lesson 1", "/waale/Lesson 1.xls"),
(9, NULL, "Waale Lesson 2", "/waale/Lesson 2.xls"),
(9, NULL, "Waale Lesson 3", "/waale/Lesson 3.xls"),
(9, NULL, "Waale Lesson 4", "/waale/Lesson 4.xls"),
(9, NULL, "Waale Lesson 5", "/waale/Lesson 5.xls"),
(9, NULL, "Waale Lesson 6", "/waale/Lesson 6.xls"),
(9, NULL, "Waale Lesson 7", "/waale/Lesson 7.xls"),
(9, NULL, "Waale Lesson 8", "/waale/Lesson 8.xls"),
(9, NULL, "Waale Lesson 9", "/waale/Lesson 9.xls"),
(9, NULL, "Waale Lesson 10", "/waale/Lesson 10.xls");

-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------

-- table of unique phrases
DROP TABLE IF EXISTS phrase;
CREATE TABLE IF NOT EXISTS phrase (
	ID bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	PHRASE_TEXT varchar(255) NOT NULL,
	PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=0;

-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------

-- table of phrase mappings -- mad hard
DROP TABLE IF EXISTS phrase_map;
CREATE TABLE IF NOT EXISTS phrase_map (
	ID bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	PHRASE_ID bigint(20) unsigned NOT NULL,
	LANG_ID bigint(20) unsigned DEFAULT NULL,
	DIALECT_ID bigint(20) unsigned DEFAULT NULL,
	LESSON_ID bigint(20) unsigned DEFAULT NULL,
	PHRASE_KEY varchar(128) DEFAULT NULL,
	TRANSLATION_TEXT varchar(255) NOT NULL,
	URL_MP3 varchar(255) DEFAULT NULL,
	URL_WAV varchar(255) DEFAULT NULL,
	PRIMARY KEY (ID),
	CONSTRAINT FOREIGN KEY (PHRASE_ID) REFERENCES phrase (ID),
	CONSTRAINT FOREIGN KEY (LANG_ID) REFERENCES lang (ID),
	CONSTRAINT FOREIGN KEY (DIALECT_ID) REFERENCES dialect (ID),
	CONSTRAINT FOREIGN KEY (LESSON_ID) REFERENCES lang_lesson (ID)
	ON UPDATE CASCADE
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=0;

-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------

-- table of JSON arrays for the order of the lessons
DROP TABLE IF EXISTS lesson_order;
CREATE TABLE IF NOT EXISTS lesson_order (
	ID bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	LESSON_ID bigint(20) unsigned NOT NULL,
	JSON_STRING text,
	PRIMARY KEY (ID),
	CONSTRAINT FOREIGN KEY (LESSON_ID) REFERENCES lang_lesson (ID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=0;

COMMIT;
