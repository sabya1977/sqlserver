-- SQL Server views
-- Author: Sabyasachi Mitra
-- Date: 02/09/2025
-- Description: Demonstrate Inline table-valued function or TVF
--
USE TSQLV6;
--
-- inline TVF is an inline table function which accepts parameters
-- inline TVFs are implemented as FUNCTION with input parameters.
--
-- get column details of Sales.Orders
--
exec sp_columns 'Orders', 'Sales'
--
CREATE OR ALTER FUNCTION Sales.GetUSCustOrd 
(@shipcnty AS VARCHAR(30)) RETURNS TABLE
AS
RETURN
SELECT 
	orderid, 
	custid, 
	empid, 
	orderdate, 
	requireddate,
	shippeddate, 
	shipperid, 
	freight, 
	shipname, 
	shipaddress, 
	shipcity,
	shipregion, 
	shippostalcode, 
	shipcountry
FROM 
	Sales.Orders 
WHERE shipcountry = @shipcnty;
GO
--
-- select from inline TVF
SELECT * 
FROM 
	Sales.GetUSCustOrd (N'USA') AS O
WHERE O.custid = 65;
--

