-- Common Table Expression (CTE)
-- Author: Sabyasachi Mitra
-- Date: 01/13/2025
--
-- Description: Demonstrate CTEs
--
-- CTE with WITH clause
--
USE TSQLV6;
--
WITH USACusts AS 
(
	SELECT 
		custid,
		companyname
	FROM 
		Sales.Customers C
	WHERE C.country = 'USA'
			
)
SELECT * FROM USACusts;
--
-- Assign column alias - external form
--
WITH C(orderyear, custid) AS
(
SELECT YEAR(orderdate), custid
FROM Sales.Orders
)
SELECT orderyear, COUNT(DISTINCT custid) AS numcusts
FROM C
GROUP BY C.orderyear;
--
-- Multiple references in CTEs
--
WITH YearlyCount AS 
(
	SELECT 
			YEAR(orderdate) AS orderyear,
			COUNT(DISTINCT custid) AS numcusts
		FROM 
			Sales.Orders
		GROUP BY YEAR(orderdate)
)
SELECT 
	Cur.orderyear,
	Cur.numcusts AS Current_Year_Num_Customer, 
	Prv.numcusts AS Prev_Year_Num_Customer,
	Cur.numcusts - Prv.numcusts AS Growth
FROM 
	YearlyCount AS Cur
LEFT OUTER JOIN
	YearlyCount AS Prv
ON Cur.orderyear = Prv.orderyear + 1;
--
-- Recursive CTE
--
-- mgrid is empid. An employee reports to a manager who is also an employee.
--
SELECT * FROM HR.Employees;
--
-- Requirement is to list employees and their subordinates.The following is an example 
-- of hierarchial query. It first run the first query (called anchor) inside WITH clause
-- and select empid = 1. It then run the second query (called recursive member) by joining
-- the result of the first query with HR.Employees on empid = mgrid and returns all the
-- employees whose manager is emppid = 1 which return employee with empid 2. It then joins
-- that records with HR.Employees again on empid = mgrid and returns all the employees whose
-- manager is empid = 2 and returns employees with empid 3 and 5. The process continues 
-- recursively till all the records in HR.Employees are exhaused (empid = mgrid returns no rows).
--
-- Note: SQL Server stores the intermediate result sets returned by the anchor and recursive
-- members in a work table in tempdb; If you have a runway query the worN table will quickly 
-- get very large, and the query will never finish. SQL Server OPTION(MAXRECURSION n) option
-- restricts the number of times a recursive member can be invoked which be default 100. The 
-- code will fail if recursive member is invoked more than 100 times. Maximum is 32,767 and 
-- if you specify it 0 the restriction is removed.
--
With EmpCTE AS
(
	SELECT 
		empid,
		mgrid, 
		firstname,
		lastname,
		title
	FROM 
		HR.Employees
	WHERE empid = 1
	UNION ALL
	SELECT 
		e.empid,
		e.mgrid, 
		e.firstname,
		e.lastname,
		e.title
	FROM 
		EmpCTE ec
	INNER JOIN
		HR.Employees e
	ON e.mgrid = ec.empid
)
SELECT * FROM EmpCTE;
--
