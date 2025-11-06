--SQL Server Functions
USE AdventureWorks2019;
--
SELECT BusinessEntityID, FirstName + ' ' + LastName AS [Full Name]
FROM Person.Person;
--
SELECT BusinessEntityID, LastName + ',' + FirstName AS [Full Name]
FROM Person.Person;
--
--CONCAT
DECLARE @fname VARCHAR(30) = 'Sabyasachi'
DECLARE @lname VARCHAR(30) = 'Mitra'
DECLARE @space VARCHAR(1) = ' '
SELECT CONCAT (@fname, @space, @lname) AS Name;
--
DECLARE @fnamen VARCHAR(30) = 'Sabyasachi'
DECLARE @lnamen VARCHAR(30) = NULL
DECLARE @spacen VARCHAR(1) = ' '
--
SELECT @fnamen + @spacen + @lnamen as Name; -- adding null to strig produces NULL.
SELECT CONCAT (@fnamen, @spacen, @lnamen) AS Name; -- CONCAT removes NULL.
--
-- ISNULL AND COALESCE
--
DECLARE @firstname VARCHAR(30) = 'Sabyasachi'
DECLARE @middlename VARCHAR(20) = NULL;
DECLARE @lastname VARCHAR(30) = 'Mitra'
DECLARE @seperator VARCHAR(1) = ' '
--
-- If middlename is NULL then replace with space
--
SELECT @firstname + ISNULL(@middlename, @seperator) + @lastname as Name;
--
-- 
DECLARE @firstnamec VARCHAR(30) = 'Subhash'
DECLARE @middlenamec1 VARCHAR(20) = 'Chandra'
DECLARE @middlenamec2 VARCHAR(20) = NULL
DECLARE @lastnamec VARCHAR(30) = 'Bose'
-- @middlenamec1 is NOT NULL so N' ' + @middlenamec1 is also not NULL and returns ' Chandra'.
SELECT @firstnamec + COALESCE(N' ' + @middlenamec1, '') + N' ' + @lastnamec as Name;
-- @middlenamec1 is NULL so N' ' + @middlenamec1 is also NULL so empty string is returned
SELECT @firstnamec + COALESCE(N' ' + @middlenamec2, '') + N' ' + @lastnamec as Name;
--
SELECT BusinessEntityID, FirstName + COALESCE(' ' + MiddleName,'') +
' ' + LastName AS [Full Name]
FROM Person.Person;
--
SELECT BusinessEntityID, FirstName + MiddleName +
' ' + LastName AS [Full Name]
FROM Person.Person;
--
USE TSQLV6;
--
-- location is NULL because region is NULL in many rows
SELECT custid, country, region, city,
country + N',' + region + N',' + city AS location
FROM Sales.Customers;
--
-- Using COALESCE
SELECT custid, country, ISNULL(region, N'Not Found') AS region, city,
country + COALESCE(N',' + region, '') + N',' + city AS location
FROM Sales.Customers;
--
-- CAST and CONVERT
--
USE AdventureWorks2019;
--
SELECT CAST(BusinessEntityID AS NVARCHAR) + ': ' + LastName
+ ', ' + FirstName AS ID_Name
FROM Person.Person;
--
SELECT CONVERT(NVARCHAR(30), BusinessEntityID) + ': ' + LastName
+ ', ' + FirstName AS ID_Name
FROM Person.Person;
--
-- LEFT AND RIGHT
--
SELECT FirstName, LastName, LEFT(FirstName, 4) AS LFNAME, RIGHT(FirstName, 4) AS RFNAME 
FROM Person.Person;
--
-- LEN and DATALENH
-- For NCHAR or NVARCHAR data types, up to two bytes per character so DATALENGTH is twice
-- as much as LEN
SELECT FirstName, LEN(FirstName) AS "Length", DATALENGTH(FirstName) AS "Internal Data Length"
FROM Person.Person;
--
-- CHARINDEX
--
SELECT CHARINDEX('b','Sabyasachi', 2);
--
-- SUBSTRING
--
SELECT FirstName, SUBSTRING (FirstName, 1, 4) AS FNAME
FROM Person.Person;
