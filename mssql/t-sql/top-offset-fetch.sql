-- SQL Server views
-- Author: Sabyasachi Mitra
-- Date: 02/09/2025
-- Description: Demonstrate TOP and OFFSET-FETCH
--
USE AdventureWorks2022;
SELECT   FirstName,
         LastName
FROM     Person.Person
ORDER BY LastName
--
SELECT   TOP (5) FirstName,
         LastName
FROM     Person.Person
ORDER BY LastName;
--
-- DISTINCT with TOP: DISTIINCT is applied before TOP
--
SELECT DISTINCT TOP(10) FirstName,
         LastName
FROM     Person.Person
ORDER BY LastName;
