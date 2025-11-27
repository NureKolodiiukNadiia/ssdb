-- Визначити імена всіх індексів в поточній БД

SELECT t.name TableName,
       ind.name IndexName,
       ind.type_desc
FROM sys.indexes ind
INNER JOIN sys.tables t ON ind.object_id = t.object_id
ORDER BY t.name;

-- Визначити всі наявні зовнішні ключ.

SELECT fk.name ForeignKeyName,
       tp.name ParentTable,
       tr.name ReferencedTable
FROM sys.foreign_keys fk
INNER JOIN sys.tables tp ON fk.parent_object_id = tp.object_id
INNER JOIN sys.tables tr ON fk.referenced_object_id = tr.object_id
ORDER BY fk.name;

-- Визначити таблиці БД, мають тільки батьківські таблиці (нижній рівень ієрархії).

SELECT t.name ChildTable
FROM sys.tables t
WHERE t.object_id IN (
    SELECT parent_object_id FROM sys.foreign_keys
)
AND t.object_id NOT IN (
    SELECT referenced_object_id FROM sys.foreign_keys
);

-- Визначити імена всіх збережених процедур в поточній БД.

SELECT name ProcedureName
FROM sys.procedures
ORDER BY name;

-- Визначити імена всіх обмежень в поточній БД.

SELECT name ConstraintName,
       type_desc ConstraintType
FROM sys.objects
WHERE type IN ('C', 'F', 'PK', 'UQ', 'D')
ORDER BY name;

-- Визначити імена всіх куп (таблиць без кластерізованного індексу) в поточній БД.

SELECT t.name HeapTableName
FROM sys.tables t
WHERE OBJECTPROPERTY(t.object_id, 'TableHasClustIndex') = 0
ORDER BY t.name;

--  Визначити всі стовпці, у яких задано властивість IDENTITY.

SELECT t.name TableName,
       c.name ColumnName
FROM sys.columns c
INNER JOIN sys.tables t ON c.object_id = t.object_id
WHERE c.is_identity = 1
ORDER BY t.name, c.column_id;

-- Визначити залежні таблиці в БД (є або батьківським або дочірніми таблицями.

SELECT
    OBJECT_NAME(fk.parent_object_id) ChildTable,
    OBJECT_NAME(fk.referenced_object_id) ParentTable
FROM sys.foreign_keys fk
ORDER BY ParentTable, ChildTable;

-- Визначити імена всіх таблиць в поточній БД.
SELECT name
FROM sys.tables
ORDER BY name;

-- Визначити імена всіх синонімів в усіх користувацьких БД.

EXEC sp_MSforeachdb '
USE ?;
IF DB_ID() > 4
    SELECT DB_NAME()  DatabaseName, name  SynonymName
    FROM sys.synonyms;
';
