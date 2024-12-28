USE [TSQLV6]
GO

INSERT INTO [Sales].[Customers]
           ([companyname]
           ,[contactname]
           ,[contacttitle]
           ,[address]
           ,[city]
           ,[region]
           ,[postalcode]
           ,[country]
           ,[phone]
           ,[fax])
     VALUES
           (
           'Customer YYDCB',
           'Swaminathan',
           'Owner',
           'Plot No 185',
           'Hyderabad',
           'South',
           '500081',
           'India',
           '9849408776',
           '899702230'
           )
GO
--



