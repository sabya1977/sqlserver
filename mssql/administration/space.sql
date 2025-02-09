DECLARE @owner NVARCHAR(128) = 'dbo'; -- Replace with the schema name you want to filter by

WITH ObjectSizes AS (
    SELECT 
        t.name AS table_name,
        s.name AS owner,
        SUM(a.total_pages) * 8 / 1024 AS size_mb -- Convert pages to MB (1 page = 8 KB)
    FROM 
        sys.tables t
    INNER JOIN 
        sys.schemas s ON t.schema_id = s.schema_id
    INNER JOIN 
        sys.indexes i ON t.object_id = i.object_id
    INNER JOIN 
        sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
    INNER JOIN 
        sys.allocation_units a ON p.partition_id = a.container_id
    WHERE 
        s.name = @owner
    GROUP BY 
        t.name, s.name

    UNION ALL

    SELECT 
        t.name AS table_name,
        s.name AS owner,
        SUM(a.total_pages) * 8 / 1024 AS size_mb
    FROM 
        sys.tables t
    INNER JOIN 
        sys.schemas s ON t.schema_id = s.schema_id
    INNER JOIN 
        sys.indexes i ON t.object_id = i.object_id
    INNER JOIN 
        sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
    INNER JOIN 
        sys.allocation_units a ON p.partition_id = a.container_id
    WHERE 
        s.name = @owner
        AND i.type = 2 -- Filter for LOB indexes (type 2)
    GROUP BY 
        t.name, s.name
)
SELECT 
    owner,
    table_name,
    size_mb,
    ROUND(size_mb * 100.0 / SUM(size_mb) OVER (), 2) AS percent
FROM 
    ObjectSizes
WHERE 
    size_mb > 10 -- Ignore really small tables
ORDER BY 
    size_mb DESC;
--
/*
Explanation of the SQL Server Query:

1. DECLARE @owner
This variable is used to filter the results for a specific schema (owner). Replace 'dbo' with the schema name you want to query.

2. WITH ObjectSizes AS
This Common Table Expression (CTE) calculates the size of tables, indexes, and LOBs for the specified schema.

3. sys.tables, sys.schemas, sys.indexes, sys.partitions, and sys.allocation_units
These system views are used to retrieve metadata about tables, indexes, partitions, and storage allocation.

sys.tables: Contains information about user-defined tables.

sys.schemas: Contains information about schemas (owners).

sys.indexes: Contains information about indexes.

sys.partitions: Contains information about partitions.

sys.allocation_units: Contains information about storage allocation.

4. SUM(a.total_pages) * 8 / 1024 AS size_mb
Calculates the size of each object in MB. In SQL Server, 1 page = 8 KB, so:

total_pages * 8 converts pages to KB.

/ 1024 converts KB to MB.

5. UNION ALL
Combines the sizes of tables, indexes, and LOBs into a single result set.

6. ROUND(size_mb * 100.0 / SUM(size_mb) OVER (), 2) AS percent
Calculates the percentage of the total size that each object occupies. The SUM(size_mb) OVER () computes the total size of all objects.

7. WHERE size_mb > 10
Filters out objects smaller than 10 MB.

8. ORDER BY size_mb DESC
Sorts the results by size in descending order.
*/
--
WITH TableStorage AS (
    SELECT 
        s.name AS schema_name,
        t.name AS table_name,
        SUM(a.total_pages) * 8 / 1024 AS Megabytes
    FROM sys.tables t
    JOIN sys.schemas s ON t.schema_id = s.schema_id
    JOIN sys.indexes i ON t.object_id = i.object_id
    JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
    JOIN sys.allocation_units a ON p.partition_id = a.container_id
    WHERE i.index_id IN (0, 1)  -- Heap (0) or Clustered Index (1)
    GROUP BY s.name, t.name
),
IndexStorage AS (
    SELECT 
        s.name AS schema_name,
        t.name AS table_name,
        SUM(a.total_pages) * 8 / 1024 AS Megabytes
    FROM sys.tables t
    JOIN sys.schemas s ON t.schema_id = s.schema_id
    JOIN sys.indexes i ON t.object_id = i.object_id
    JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
    JOIN sys.allocation_units a ON p.partition_id = a.container_id
    WHERE i.index_id > 1  -- Non-clustered Indexes
    GROUP BY s.name, t.name
),
LobStorage AS (
    SELECT 
        s.name AS schema_name,
        t.name AS table_name,
        SUM(a.total_pages) * 8 / 1024 AS Megabytes
    FROM sys.tables t
    JOIN sys.schemas s ON t.schema_id = s.schema_id
    JOIN sys.indexes i ON t.object_id = i.object_id
    JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
    JOIN sys.allocation_units a ON p.partition_id = a.container_id
    WHERE a.type IN (2, 3)  -- LOB Data and Row-overflow data
    GROUP BY s.name, t.name
)
SELECT 
    ts.schema_name,
    ts.table_name,
    FLOOR(ts.Megabytes + ISNULL(isg.Megabytes, 0) + ISNULL(ls.Megabytes, 0)) AS Meg,
    ROUND((ts.Megabytes + ISNULL(isg.Megabytes, 0) + ISNULL(ls.Megabytes, 0)) * 100.0 /
          SUM(ts.Megabytes + ISNULL(isg.Megabytes, 0) + ISNULL(ls.Megabytes, 0)) OVER (), 2) AS Percent
FROM TableStorage ts
LEFT JOIN IndexStorage isg ON ts.schema_name = isg.schema_name AND ts.table_name = isg.table_name
LEFT JOIN LobStorage ls ON ts.schema_name = ls.schema_name AND ts.table_name = ls.table_name
WHERE ts.schema_name = UPPER(@SchemaName)  -- Replace @SchemaName with the desired schema
AND (ts.Megabytes + ISNULL(isg.Megabytes, 0) + ISNULL(ls.Megabytes, 0)) > 10 -- Ignore small tables
ORDER BY Meg DESC;
