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
-- Use: CROSS APPLY may be useful when you want to restrict the number of rows 
-- to be joined from the right side set to the left side. In this example, 3 rows
-- from right side result set are joined to each Customer ID which restricts the 
-- number of orders per Customer ID returned in the final result set to 3.
-- Such requirement cannot achieved by INNER JOIN with TOP and ORDER BY.
-- 
-- The below SQL will return three latest orders for each customer.
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
-- In the below SQL, rows from right side would be joined with left side for match customer IDs
-- There is no way to limit the number of rows from the right side to be joined to left side.
--
SELECT C.custid, O.orderid, O.orderdate
FROM Sales.Customers AS C
INNER JOIN
Sales.Orders AS O
ON C.custid = o.custid
ORDER BY C.custid, orderdate DESC, orderid DESC;
--
-- In the following SQL, we tried to achieve the same result as the first one but it did not work
-- because the right side result set is not co-related which is the case with CROSS APPLY
-- 
SELECT C.custid, A.orderid, A.orderdate
FROM Sales.Customers AS C
INNER JOIN
(
	SELECT TOP (3) 
		orderid,
		custid,
		empid, 
		orderdate, 
		requireddate
FROM 
		Sales.Orders AS O
WHERE O.custid = C.custid
ORDER BY orderdate DESC, orderid DESC
) AS A
ON A.custid = C.custid
--
-- OUTER APPLY
-- 
