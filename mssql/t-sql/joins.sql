-- Explain SQL Server 2022 Outer and Inner joins
-- Author: Sabyasachi Mitra
-- Date: 12/22/2024
--
-- Description: The formal way to think of Inner Join is based on relational algebra.
-- First, the join performs a Cartesian product between the two tables and then apply 
-- the ON operator condition. So Inner join has two logical phases. 
--
-- The Outer join has a third logical phase,which, after applying the ON condition,
-- adds the rows from the preserved table to the result set which does not match the
-- ON condition. it uses NULLs as placeholders for the attributes from the
-- non-preserved side of the join in those outer rows.
--
SELECT 
	C.custid, 
	C.companyname, 
	O.orderid
FROM 
	TSQLV6.Sales.Customers AS C -- preserved table
LEFT OUTER JOIN 
	TSQLV6.Sales.Orders AS O    -- non-preserved table
ON C.custid = O.custid;
--
-- The following query will show the records from the 
-- preserved table which did not have a mtching records
-- in the non-preserved table.
--
SELECT 
	C.custid, 
	C.companyname, 
	O.orderid
FROM 
	TSQLV6.Sales.Customers AS C -- preserved table
LEFT OUTER JOIN 
	TSQLV6.Sales.Orders AS O    -- non-preserved table
ON C.custid = O.custid
WHERE O.orderid IS NULL;
--
-- A common question about outer joins that is the source of a lot 
-- of confusion is whether to specify a predicate in the ON or WHERE
-- clause of a query. We can see that with respect to rows from the
-- preserved side of an outer Moin, the filter based on the ON predicate
-- is not final because the rows from the preserved table will be added
-- after the ON clause is executed. The ON clause rather determines what
-- rows will be joined than what rows will be displayed in the output.
-- Therefore, we should mention those predicates in ON clause which
-- determine what rows to be joined. When you need a filter to be applied 
-- after outer rows are produced, and you want the filter to be final, specify
-- the predicate in the WHERE clause.
-- WHERE clause is processed after the FROM clause, that is, after the all rows from
-- the preserved table is added to the output so WHERE clause can determine the final
-- output.
--
-- In a nutshell, To recap, in the ON clause you specify nonfinal, or matching, 
-- predicates. In the WHERE clause you specify final, or filtering, predicates.
--
-- The below query gives WRONG output!
--
-- The requirement is to show all Indian customers with their orders.
-- If no order is placed, it should show NULL for order id.
-- But it gives all the records from preserverd table (customer) 
-- with order id NULL for even for customers who placed at least
-- one order. The order id is NULL because country is not India for
-- all records except three records (so it makes all records' order
-- id NULL since country predicate is in ON).
-- Secondly, it displays all records from the preserved table since
-- there is no WHERE clause to filter only India records.
-- The issue is the country predicate refers to the preserved table.
--
SELECT 
	C.custid, 
	C.companyname, 
	O.orderid,
	C.country
FROM 
	TSQLV6.Sales.Customers AS C -- preserved table
LEFT OUTER JOIN 
	TSQLV6.Sales.Orders AS O    -- non-preserved table
ON C.custid = O.custid AND C.country = 'India';
--
-- Now we will place the predicate in ON clause which 
-- refer to the non-preserved table (Orders).
-- The problem with the below query is only orders with
-- shipping destination India participated in the join
-- but all the rows from preserved rows appears in output
--
SELECT 
	C.custid, 
	C.companyname, 
	O.orderid,
	C.country
FROM 
	TSQLV6.Sales.Customers AS C -- preserved table
LEFT OUTER JOIN 
	TSQLV6.Sales.Orders AS O    -- non-preserved table
ON C.custid = O.custid AND O.shipcountry = 'India';
--
-- If we move the predicate condition to WHERE clause, it works!
--
SELECT 
	C.custid, 
	C.companyname, 
	O.orderid,
	C.country
FROM 
	TSQLV6.Sales.Customers AS C -- preserved table
LEFT OUTER JOIN 
	TSQLV6.Sales.Orders AS O    -- non-preserved table
ON C.custid = O.custid
WHERE C.country = 'India';
--
-- Finding missing values in a temporal table
-- The next problem is to find out the dates on which no order has been placed.
--
-- To achieve this solution we will have a number table which we will use
-- to generate all dates (in a specified range) and left join the result 
-- with the order table.
--
SELECT * FROM TSQLV6.dbo.Nums;
--
-- The below query will produce all dates starting 1/1 of 2020 to 10/16 of 2293
--
SELECT 
	DATEADD(day, n, CAST('20200101' AS DATE)) AS orderdate
FROM 
	TSQLV6.dbo.Nums
ORDER BY orderdate;
--
-- The below query will add each number, starting 0 (first number - 1 from Nums)
-- till the number derived from DATEDIFF between 20200101 and 20221231.
-- In other words, it will generate all dates between 01/01/2020 and 12/31/2022
--
SELECT 
	DATEADD(day, n-1, CAST('20200101' AS DATE)) AS orderdate
FROM 
	TSQLV6.dbo.Nums
WHERE n <= DATEDIFF(day, '20200101', '20221231') + 1
ORDER BY orderdate;
--
-- The below query will show all the dates in which at least one order 
-- is place as well as the dates when no order was placed at all.
--
WITH Dummy AS
(
SELECT 
	DATEADD(day, n-1, CAST('20200101' AS DATE)) AS orderdate
FROM 
	TSQLV6.dbo.Nums
WHERE n <= DATEDIFF(day, '20200101', '20221231') + 1
)
SELECT
	O.orderid,
	O.custid,
	O.empid,
	D.orderdate
FROM
	Dummy D
LEFT OUTER JOIN
	TSQLV6.Sales.Orders O
ON D.orderdate = O.orderdate
ORDER BY D.orderdate;
--
-- Filtering non-preserved table rows in WHERE clause.
-- In the below query, the non-preserved table is filtered 
-- out hence the non-matching rows from the preserved table 
-- are all filtered out making OUTER JOIN meaningless
--
SELECT 
	C.custid, 
	C.companyname, 
	O.orderid, 
	O.orderdate
FROM 
	TSQLV6.Sales.Customers AS C
LEFT OUTER JOIN 
	TSQLV6.Sales.Orders AS O
ON C.custid = O.custid
WHERE O.shipcountry = 'India';
--
-- Outer join with Inner join:
-- Suppose you write a multi-join query with an outer join 
-- between two tables, followed by an inner join with a third
-- table. 
--
-- Issue: In the below query, Customer table is outer joined with Orders table
-- For custid 22, 57, 92, and 93, the orderid returns NULL from Orders 
-- table because these customers didn't place any orders.
-- This result set is then INNER Joined with OrderDetails table on
-- orderid but since orderid is NULL for these custid, NULL = OD.orderid
-- returns UKNOWN and consequently eliminated from the final result.
--
SELECT 
	C.custid, 
	O.orderid, 
	OD.productid, 
	OD.qty
FROM 
	TSQLV6.Sales.Customers AS C
LEFT OUTER JOIN 
	TSQLV6.Sales.Orders AS O
ON C.custid = O.custid
INNER JOIN 
	TSQLV6.Sales.OrderDetails AS OD
ON O.orderid = OD.orderid
WHERE C.custid IN (22, 57, 93, 92, 94);
--
-- Solution 1: Use LEFT OUTER JOIN for all tables.
--
SELECT 
	C.custid, 
	O.orderid, 
	OD.productid,
	O.shippeddate,
	O.shipname,
	OD.qty
FROM 
	TSQLV6.Sales.Customers AS C
LEFT OUTER JOIN 
	TSQLV6.Sales.Orders AS O
ON C.custid = O.custid
LEFT OUTER JOIN  
	TSQLV6.Sales.OrderDetails AS OD
ON O.orderid = OD.orderid
WHERE C.custid IN (22, 57, 93, 92, 94);
--
-- Solution 2: If you want to discard a row if it does not have any order details
--
SELECT 
	C.custid, 
	O.orderid, 
	OD.productid,
	O.shippeddate,
	O.shipname,
	OD.qty
FROM 
	TSQLV6.Sales.Orders AS O
INNER JOIN
	TSQLV6.Sales.OrderDetails AS OD
ON O.orderid = OD.orderid
RIGHT OUTER JOIN
	TSQLV6.Sales.Customers AS C
ON C.custid = O.custid
WHERE C.custid IN (22, 57, 93, 92, 94);
--
-- Write a query that returns all customers, but matches them with their respective orders
-- only if they were placed on February 12, 2022:
--
SELECT 
	C.custid,
	C.companyname,
	O.orderid,
	O.orderdate,
	CASE 
		WHEN o.orderid IS NULL THEN
			'No'
		ELSE
			'Yes'
	END AS HasOrderOn20220212
FROM 
	TSQLV6.Sales.Customers C
LEFT OUTER JOIN
	TSQLV6.Sales.Orders O
ON C.custid = O.custid AND O.orderdate = CAST ('2022-02-12' AS date)


SELECT * FROM TSQLV6.Sales.Orders WHERE orderid = 11078;
--
SELECT * FROM TSQLV6.Sales.OrderDetails WHERE orderid = 11078;
--
SELECT * FROM TSQLV6.Sales.Customers;
--
SELECT CAST ('2022-02-12' AS date)
