-- SQL Server APPLY Operators
-- Author: Sabyasachi Mitra
-- Date: 02/17/2025
-- Description: APPLY Operators
--
USE TSQLV6;
-- In the following SQL first a row from Cutomer table is selected
-- Each row is then joined with the right side result set. The right
-- set result set fetches three top rows (according to given Order By)
-- and three rows are joined with the left side table's row.
-- So it works like a inner join however in INNER JOIN you cannot order
-- the rows of the right set table/set and join to the left side table.
-- 
SELECT C.custid, A.orderid, A.orderdate
FROM Sales.Customers AS C
CROSS APPLY
(
	SELECT TOP (3) 
		orderid, 
		empid, 
		orderdate, 
		requireddate
FROM 
		Sales.Orders AS O
WHERE 
		O.custid = C.custid
ORDER BY orderdate DESC, orderid DESC
) AS A;
--
-- If you compare the following query with the above one, you may 
-- observe that while they're same, the rows are not in the same order.
--
SELECT C.custid, O.orderid, O.orderdate
FROM Sales.Customers AS C
INNER JOIN
Sales.Orders AS O
ON C.custid = o.custid
ORDER BY orderdate DESC, orderid DESC;
--
--
