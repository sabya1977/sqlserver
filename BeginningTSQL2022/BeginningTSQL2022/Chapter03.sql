--Filtering on Date and Time
USE AdventureWorks2019;
CREATE TABLE #DateTimeExample (
ID INT NOT NULL IDENTITY PRIMARY KEY,
MyDate DATETIME2(0) NOT NULL,
MyValue VARCHAR(25) NOT NULL
);
--
INSERT INTO #DateTimeExample (MyDate,MyValue)
VALUES 
('2020-01-02 10:30','Bike'),
('2020-01-03 13:00','Trike'),
('2020-01-03 13:10','Bell'),
('2020-01-03 17:35','Seat');
--
SELECT * FROM #DateTimeExample;
-- returns no results as there is no value 2020-01-03 00:00:00
SELECT ID, MyDate, MyValue
FROM #DateTimeExample
WHERE MyDate = '2020-01-03';
--  
SELECT ID, MyDate, MyValue
FROM #DateTimeExample
WHERE MyDate BETWEEN '2020-01-03 00:00:00' AND '2020-01-03 23:59:59';
--
SELECT BusinessEntityID, LoginID, JobTitle
FROM 
HumanResources.Employee 
WHERE JobTitle = 'Research and Development Engineer';
--
SELECT * FROM Production.ProductCostHistory WHERE StandardCost BETWEEN 10 AND 13;
--
SELECT BusinessEntityID, LoginID, JobTitle
FROM 
HumanResources.Employee 
WHERE JobTitle <> 'Research and Development Engineer';
--
USE WideWorldImporters;
--
SELECT CityName, LatestRecordedPopulation
FROM Application.Cities WHERE CityName = 'Simi Valley';
--
SELECT * FROM Sales.Customers WHERE AccountOpenedDate BETWEEN '2016-01-01' AND '2016-12-31';
--
SELECT * FROM Sales.Customers WHERE YEAR(AccountOpenedDate) = 2016;
--
CREATE TABLE DATETIME_Ex
(
ID INT NOT NULL PRIMARY KEY,
ADM_DT DATETIME2(0)
);
--
INSERT INTO DATETIME_Ex (ID, ADM_DT)
VALUES (5, '2018-01-01 00:00'),
		(6, '2018-12-31 23:59');
--
-- DATETIME BETWEEN is all inclusive
SELECT * FROM DATETIME_Ex WHERE ADM_DT BETWEEN '2017-01-01' AND '2018-01-01';
--
USE AdventureWorks2019;
--
SELECT SalesOrderID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader WHERE OrderDate BETWEEN '2012-09-01 00:00:00' AND
'2012-09-30 23:59:59';
--
SELECT SalesOrderID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader 
WHERE TotalDue >= 10000 OR SalesOrderID < 43000;
--
USE WideWorldImporters;
--
SELECT * FROM Application.StateProvinces WHERE StateProvinceID NOT IN (1, 45);
--
-- Working with NULL
--
SELECT NULL + NULL AS "NULL + NULL";
--
SELECT NULL + 1 AS "NULL + 1";
--
SELECT 1 AS "NULL > 1" WHERE NULL > 1;
--
SELECT 1 AS "NULL=NULL" WHERE NULL = NULL;
--
SELECT 1 AS "NULL<>NULL" WHERE NULL <> NULL;
--
SELECT 1 AS "NULL= 0" WHERE NULL = 0;
--
SELECT 1 AS "NULL != 10" WHERE NULL != 10;
--
SELECT 1 AS "NULL != 'B'" WHERE NULL != 'B';
--
SELECT 1 AS "NULL IS NULL" WHERE NULL IS NULL;
--
USE AdventureWorks2019;
--
SELECT * FROM Production.Product WHERE Color IS NOT NULL;
--
-- using index
--
USE AdventureWorks2019;
--
SELECT LastName, FirstName
FROM Person.Person
WHERE LastName = 'Mitra';
--
SELECT LastName, FirstName
FROM Person.Person
WHERE FirstName = 'Ken';
--
SELECT ModifiedDate
FROM Person.Person
WHERE ModifiedDate BETWEEN '2011-01-01' and '2011-01-31';