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
-- SCHEMABINDING option : Does not allow the underlying table or columns to be dropped 
--
-- create a new table from existing Customer table
--
SELECT * INTO Sales.Cust
FROM Sales.Customers;
--
-- create the view
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
	Sales.Cust
WHERE country = 'USA';
--
-- table is dropped without error
--
DROP TABLE SAles.Cust;
--
-- create view with SCHEMABINDING option
--
CREATE OR ALTER VIEW Sales.USCust
WITH SCHEMABINDING
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
	Sales.Cust
WHERE country = 'USA';
-- 
-- try to drop a column from the table; it gives an error.
--
ALTER TABLE Sales.Cust DROP address;
--
-- ENCRYPTION Option : When you create a db objects such as 
-- stored procedure, UDF, views or triigers with ENCRYPTION
-- SQL Server stores the text of the definition in obfuscated
-- format.
--
-- to see a view in catalog
USE TSQLV6;
SELECT OBJECT_DEFINITION(OBJECT_ID('Sales.USCust')) AS TEXT;
--
CREATE OR ALTER VIEW Sales.USCust WITH ENCRYPTION
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
	Sales.Cust
WHERE country = 'USA';
--
-- the statement will return NULL
--
SELECT OBJECT_DEFINITION(OBJECT_ID('Sales.USCust')) AS TEXT;
--
