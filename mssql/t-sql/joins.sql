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
-- The next problem is to find out the dates on which no order has been placed
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
SELECT 
	DATEADD(day, n, CAST('20200101' AS DATE)) AS orderdate
FROM 
	TSQLV6.dbo.Nums
WHERE n <= DATEDIFF(day, '20200101', '20221231')
ORDER BY orderdate;






SELECT * FROM TSQLV6.Sales.Orders;
--
SELECT * FROM TSQLV6.Sales.Customers;

