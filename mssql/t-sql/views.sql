-- SQL Server views
-- Author: Sabyasachi Mitra
-- Date: 02/08/2025
-- Description: Demonstrate Views
--
-- creating view
--
USE TSQLV6;
--
CREATE OR ALTER VIEW Sales.USCust
AS
SELECT 
	custid, 
	companyname, 
	contactname, 
	contacttitle, 
	address,
	city, 
	region, 
	postalcode, 
	country, 
	phone, 
	fax
FROM 
	Sales.Customers
WHERE country = N'USA';
GO
--
SELECT * from Sales.USCust;
--
-- ORDER BY not allowed
-- following statement will throw error
--
CREATE OR ALTER VIEW Sales.USCust
AS
SELECT 
	custid, 
	companyname, 
	contactname, 
	contacttitle, 
	address,
	city, 
	region, 
	postalcode, 
	country, 
	phone, 
	fax
FROM 
	Sales.Customers
WHERE country = 'USA'
ORDER BY region;
--
-- ORDER BY is allowed with TOP, OFFSET-Fetch but order is not gurranted unless ORDER BY
-- is specified in the outer query.
--
CREATE OR ALTER VIEW Sales.USCust
AS
SELECT TOP (10)
	custid, 
	companyname, 
	contactname, 
	contacttitle, 
	address,
	city, 
	region, 
	postalcode, 
	country, 
	phone, 
	fax
FROM 
	Sales.Customers
WHERE country = 'USA'
ORDER BY region;
--
-- View options
--
-- CHECK option
-- Prevent DML statements (INSERT, DELETE, UPDATE) of records 
-- which violates the filter criteria of the SELECT statement 
-- of the VIEW.
-- Example
INSERT INTO Sales.USCust
(companyname, contactname, contacttitle, address,
city, region, postalcode, country, phone, fax)
VALUES ('Customer ABCDE', 'Contact ABCDE', 'Title ABCDE', 'Address ABCDE',
'London', NULL, '12345', 'UK', '012-3456789', '012-3456789');
--
-- value is missing in view
SELECT * FROM SAles.USCust;
-- 
-- value is present in the table
--
SELECT * FROM Sales.Customers WHERE country = 'UK';
--
-- redefine the view with CHECK option
--
CREATE OR ALTER VIEW Sales.USCust
AS
SELECT 
	custid, 
	companyname, 
	contactname, 
	contacttitle, 
	address,
	city, 
	region, 
	postalcode, 
	country, 
	phone, 
	fax
FROM 
	Sales.Customers
WHERE country = 'USA'
WITH CHECK OPTION;
--
-- the statement will give error
--
INSERT INTO Sales.USCust
(companyname, contactname, contacttitle, address,
city, region, postalcode, country, phone, fax)
VALUES ('China Shipping', 'Shipping Office', 'China Shipping Corp.', 'Shanghai',
'Shanghai', NULL, '12345', 'CN', '86-3456789', '86-3456789');
--