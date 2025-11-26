;WITH Tally AS (
    SELECT TOP (50000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b ) INSERT INTO pz2.Goods (Id, Label, Manufacturer, Price, Quantity, InputDate)
    SELECT n AS Id,     LEFT(N'Product-' + REPLACE(CONVERT(nvarchar(36), NEWID()), N'-', N''), 100) AS Label,
    CASE (ABS(CHECKSUM(NEWID())) % 10)
    WHEN 0 THEN N'Acme'
    WHEN 1 THEN N'Contoso'
    WHEN 2 THEN N'Globex'
    WHEN 3 THEN N'Initech'
    WHEN 4 THEN N'Umbrella'
    WHEN 5 THEN N'Soylent'
    WHEN 6 THEN N'Stark'
    WHEN 7 THEN N'Wayne'
    WHEN 8 THEN N'Wonka'
    WHEN 9 THEN N'Hooli'
    END AS Manufacturer,
    CAST((ABS(CHECKSUM(NEWID())) % 100000) / 100.0 AS decimal(10,2)) AS Price,
    ABS(CHECKSUM(NEWID())) % 1000 AS Quantity,
    DATEADD(day, - (ABS(CHECKSUM(NEWID())) % 3650),
    GETDATE()) AS InputDate FROM Tally;
