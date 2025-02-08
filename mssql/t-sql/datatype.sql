-- Explain SQL Server 2022 Data types
-- Author: Sabyasachi Mitra
-- Date: 01/03/2025
--
-- Description: Different data types and related functions
--
-- Date and Time data types
--
-- T-SQL doesn’t provide the means to express a date and time literal; instead, 
-- you can specify a literal of a different type that can be converted—explicitly
-- implicitly—to a date and time data type.
--
USE TSQLV6;
--
-- SQL Server recognize the character string VARCHAR. The column orderdate
-- is DATE data type. SQL Server converts the varchar literal to DATE data
-- type because VARCHAR is lower (28) in data type precedence order than 
-- DATE data type (9). This is implicit conversion.
--
SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate = '20220212';
--
-- You can convert the VARCHAR literal explicitly to DATE data type using CAST
--
SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate = CAST ('20220212' AS DATE);
--
-- Note that some character-string formats of date and time literals 
-- are language dependent. Language can be overridden by SET LANGUAGE
-- though it's not recommended. DATEFORMAT language setting determines
-- how SQL Server interprets the literals you enter when they are converted
-- from a character-string type to a date and time type. 
-- For example, British language setting sets the DATEFORMAT to dmy
-- while us_english sets it to mdy format. 
--
SET DATEFORMAT dmy;
DECLARE @datevar DATE = '31/12/2022';
SELECT @datevar;
--
-- The below query will fail as 31 is not a valid month
--
SET DATEFORMAT mdy;
DECLARE @datev DATE = '31/12/2022';
SELECT @datev;
--
-- Note that the DATEFORMAT setting affects only the way the values 
-- you enter are interpreted; these settings have no impact on the 
-- format used in the output for presentation purposes.
--
-- Output format is determined by the database interface used by the
-- client tool (such as ODBC). OLE DB and ODBC present DATE values in the
-- format 'YYYY-MM-DD'.
--
-- Recommended date and time format
--
-- DATETIME - YYYYMMDD/YYYY-MM_DD hh:mm:ss.nnn - nnn is miliseconds
--
SELECT CAST ('99991231 12:30:15.00' AS DATETIME)
--
-- SMALLDATETIME - YYYYMMDD hh:mm:ss or YYYY-MM-DD hh:mm:ss
--
SELECT CAST ('2079-06-06 12:30:15' AS SMALLDATETIME)
--
-- DATE - YYYY-MM-DD or YYYYMMDD
-- 
SELECT CAST ('9999-12-31' AS DATE)
--
-- TIME - hh:mm:ss.nnnnnnn - 100 nanoseconds
--
SELECT CAST ('15:30:23.8975551' AS TIME)
--
-- DATETIME2 [ (fractional seconds precision) ] - YYYY-MM-DD hh:mm:ss.nnnnnnn - 100 nanoseconds
-- fractional seconds precision = 0 to 7 digits. Default 7.
-- minimum character size 19 (yyyy-MM-dd HH:mm:ss) and maximum character size 27 (yyyy-MM-dd HH:mm:ss.0000000)
--
DECLARE @datetime2 AS DATETIME2(7) = '2024-01-12'
SELECT  @datetime2
--
SELECT CAST ('2014-01-31 15:30:23.8975551' AS DATETIME2)
--
-- DATETIMEOFFSET [ (fractional seconds precision) ] - YYYY-MM-DD hh:mm:ss.nnnnnnn+/-hh:mm (timezone respect to UTC)
-- +5:30 is IST
-- Character length (precision): 26 to 34
-- Scale: 0 to 7 (given as fractional seconds precision)
--
SELECT CAST ('2014-01-31 15:30:23.8975551 +5:30' AS datetimeoffset)
--
-- Here is an example to convert the timezone from IST to EST using SWITCHOFFSET
--
DECLARE @istoffset datetimeoffset (7) = '2025-01-12 02:30:10.8975551 +5:30';
SELECT 
	@istoffset AS IST_TIME,
	SWITCHOFFSET (@istoffset, '-05:00') EST_EQV
--
-- Convert date to other date and time types
--
-- From date to dateime
--
DECLARE @date AS DATE = '01-13-25';

DECLARE @datetime AS DATETIME = @date;

SELECT @date AS '@date',
       @datetime AS '@datetime';
--
-- From date to datetimeoffset
-- 
DECLARE @datelv AS DATE = '1912-10-25';

DECLARE @datetimeoffset AS DATETIMEOFFSET (4) = @datelv;

SELECT @datelv AS '@date',
       @datetimeoffset AS '@datetimeoffset';
--
-- from time to datetime2
--
DECLARE @time AS TIME(7) = '12:10:16.1234567';
DECLARE @datetime2v AS DATETIME2 = @time;
SELECT @datetime2v AS '@datetime2',
       @time AS '@time';
--
-- Numeric and Decimal
--
-- decimal [ ( p [ , s ] ) ] and numeric [ ( p [ , s ] ) ]
-- 
-- precision: The maximum total number of decimal digits to be stored.
-- This number includes both the left and the right sides of the decimal point.
-- Min: 1, Max: 38, Default: 18
--
-- scale: The number of decimal digits that are stored to the right of the decimal point.
-- This number is subtracted from p to determine the maximum number of digits to the left
-- of the decimal point. 
-- Min: 0, Max: precision - 0 <= s <= p
--
-- Storage - Min: 5 bytes, Max: 17 bytes
--
DECLARE @mydecimal1 AS DECIMAL (5,2) = 123;
DECLARE @mydecimal2 AS DECIMAL (10,5) = 1245.12;
SELECT @mydecimal1, @mydecimal2;
--
-- money and smallmoney
-- Stores data accirate to ten-thousandth place.
-- stores decimal point 
--
DECLARE @mymoney AS MONEY = $1267.99;
SELECT @mymoney
--
-- Data type precedence
--


