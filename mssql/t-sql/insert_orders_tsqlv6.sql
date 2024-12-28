USE [TSQLV6]
GO

INSERT INTO [Sales].[Orders]
           ([custid]
           ,[empid]
           ,[orderdate]
           ,[requireddate]
           ,[shippeddate]
           ,[shipperid]
           ,[freight]
           ,[shipname]
           ,[shipaddress]
           ,[shipcity]
           ,[shipregion]
           ,[shippostalcode]
           ,[shipcountry])
     VALUES
           (94,
           7,
           '2024-09-12',
           '2024-10-12',
           '2024-09-14',
           3,
           24.5,
           'Destination SNPXM',
           'Kharagpur, Kharida',
           'Kharida bazar',
           'East',
           '721301',
           'India'
           )
GO


