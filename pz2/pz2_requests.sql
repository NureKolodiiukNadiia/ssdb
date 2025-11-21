-- -- 1. Запит 1:
-- SELECT Id, Label, Quantity FROM Goods WHERE Quantity < 100;
--
-- -- 2. Запит 2:
-- SELECT Id, Label FROM Goods WHERE Price > 100.0 AND InputDate = GETDATE();
--
-- -- 3. Запит 3:
-- SELECT InputDate, SUM(Quantity) as 'Count' FROM Goods GROUP BY InputDate;


-- CREATE DATABASE Pz2DB;
-- GO
--
-- USE Pz2DB;
-- GO
--
-- CREATE SCHEMA pz;
-- GO
--
-- CREATE TABLE pz.Goods
-- (
--     Id int NOT NULL,
--     Label nvarchar(100),
--     Manufacturer nvarchar(50),
--     Price float,
--     Quantity int,
--     InputDate datetime
-- );
--
-- GO

-- ;WITH Tally AS (     SELECT TOP (50000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n     FROM sys.all_objects a     CROSS JOIN sys.all_objects b ) INSERT INTO pz.Goods (Id, Label, Manufacturer, Price, Quantity, InputDate) SELECT     n AS Id,     LEFT(N'Product-' + REPLACE(CONVERT(nvarchar(36), NEWID()), N'-', N''), 100) AS Label,     CASE (ABS(CHECKSUM(NEWID())) % 10)         WHEN 0 THEN N'Acme' WHEN 1 THEN N'Contoso' WHEN 2 THEN N'Globex' WHEN 3 THEN N'Initech'         WHEN 4 THEN N'Umbrella' WHEN 5 THEN N'Soylent' WHEN 6 THEN N'Stark' WHEN 7 THEN N'Wayne'         WHEN 8 THEN N'Wonka' WHEN 9 THEN N'Hooli' END AS Manufacturer,     CAST((ABS(CHECKSUM(NEWID())) % 100000) / 100.0 AS decimal(10,2)) AS Price,     ABS(CHECKSUM(NEWID())) % 1000 AS Quantity,     DATEADD(day, - (ABS(CHECKSUM(NEWID())) % 3650), GETDATE()) AS InputDate FROM Tally;
-- USE Pz2DB;
-- GO
-- SELECT SUSER_NAME();
-- ALTER USER [sa] WITH DEFAULT_SCHEMA = pz;

-- SET STATISTICS IO ON;
-- Індекс 1: Оптимізація для Запиту 1 (Quantity < 100)
-- CREATE NONCLUSTERED INDEX IX_Goods_Quantity_Include
--     ON pz.Goods(Quantity)
--     INCLUDE (Id, Label);
-- Покриваючий індекс для швидкого відбору за Quantity
-- ALTER INDEX IX_Goods_Quantity_Include ON pz.Goods DISABLE;

-- Індекс 2: Оптимізація для Запиту 2 (Price AND InputDate)
-- CREATE NONCLUSTERED INDEX IX_Goods_InputDate_Price_Include
--     ON pz.Goods(InputDate, Price)
--     INCLUDE (Id, Label);
-- InputDate на першому місці, бо використовується рівність (=)
-- ALTER INDEX IX_Goods_InputDate_Price_Include ON pz.Goods DISABLE;
-- -- Індекс 3: Оптимізація для Запиту 3 (GROUP BY InputDate)
-- CREATE NONCLUSTERED INDEX IX_Goods_InputDate_Quantity
--     ON pz.Goods(InputDate)
--     INCLUDE (Quantity);
-- Покриваючий індекс для агрегації по InputDate
-- SELECT t.name AS TableName, ind.name AS IndexName, ind.type_desc
-- FROM sys.indexes ind
--          JOIN sys.tables t ON ind.object_id = t.object_id
-- ORDER BY t.name;

-- Кластеризований індекс (рекомендується на первинний ключ)
-- sql
-- 1) confirm current DB
-- SELECT DB_NAME() AS CurrentDatabase;
--
--
-- -- -- -- 2) list indexes and status for pz.Goods

SELECT name,
       index_id,
       type_desc,
       is_disabled,
       is_primary_key,
       is_unique,
       fill_factor
FROM sys.indexes
WHERE object_id = OBJECT_ID(N'pz.Goods');
--
-- -- 3) show any existing clustered index explicitly
-- SELECT name AS ClusteredIndexName
-- FROM sys.indexes
-- WHERE object_id = OBJECT_ID(N'pz.Goods')
--   AND type_desc = 'CLUSTERED';
--
-- -- 4) if your index exists but is disabled, rebuild (enables it)
-- IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'pz.Goods') AND name = N'IX_Goods_Id_Clustered' AND is_disabled = 1)
-- BEGIN
--     PRINT 'Rebuilding IX_Goods_Id_Clustered...';
--     ALTER INDEX IX_Goods_Id_Clustered ON pz.Goods REBUILD;
-- END
--
-- -- 5) create clustered index only if no clustered index exists
-- IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'pz.Goods') AND type_desc = 'CLUSTERED')
-- BEGIN
--     PRINT 'Creating clustered index IX_Goods_Id_Clustered...';
--     CREATE CLUSTERED INDEX IX_Goods_Id_Clustered ON pz.Goods(Id);
-- END
-- ELSE
-- BEGIN
--     PRINT 'A clustered index already exists; drop the PK/clustered index first if you want to replace it.';
-- END

-- ALTER INDEX IX_Goods_Id_Clustered ON pz.Goods REBUILD;
-- ALTER INDEX IX_Goods_InputDate_Quantity ON pz.Goods REBUILD;
-- ALTER INDEX IX_Goods_InputDate_Price_Include ON pz.Goods REBUILD;
-- ALTER INDEX IX_Goods_Quantity_Include ON pz.Goods REBUILD;

-- DROP INDEX IX_Goods_Id_Clustered ON pz.Goods;
-- ALTER INDEX IX_Goods_InputDate_Quantity ON pz.Goods DISABLE;
-- ALTER INDEX IX_Goods_InputDate_Price_Include ON pz.Goods DISABLE;
-- ALTER INDEX IX_Goods_Quantity_Include ON pz.Goods DISABLE;
-- ALTER INDEX IX_Goods_Id_Clustered ON pz.Goods DISABLE;

-- CREATE CLUSTERED INDEX IX_Goods_Id_Clustered
--     ON pz.Goods(Id);

SELECT Id, Label, Quantity FROM pz.Goods WHERE Quantity < 100;
-- SELECT Id, Label FROM pz.Goods WHERE Price > 100.0 AND InputDate = GETDATE();
-- SELECT InputDate, SUM(Quantity) as 'Count' FROM pz.Goods GROUP BY InputDate;
