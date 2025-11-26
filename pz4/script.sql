-- 1. Встановіть модель відновлення (Full)
USE master;
ALTER DATABASE AdventureWorks SET RECOVERY FULL;
GO

-- 2. Зніміть повний бекап даних
BACKUP DATABASE AdventureWorks
TO DISK = N'/var/opt/mssql/backups/AdventureWorks.bak'
WITH FORMAT, INIT, NAME = N'Full Backup AdventureWorks';
GO

-- 3. Перевірте файл

-- 4. Замініть посаду (UPDATE)
USE AdventureWorks;
GO

UPDATE HumanResources.Employee
SET JobTitle = N'Manager'
WHERE BusinessEntityID IN (
    SELECT BusinessEntityID FROM Person.Person WHERE FirstName = N'ALFKI'
);
GO

-- 5. Засічіть час та проведіть руйнівні дії
SELECT GETDATE() AS CurrentTime;
GO

DROP TABLE IF EXISTS Sales.Currency;
DROP TABLE IF EXISTS HumanResources.Employee;
GO

-- 6. Створіть резервну копію лога транзакцій
BACKUP LOG AdventureWorks
TO DISK = N'/var/opt/mssql/backups/AdventureWorks_Log.trn'
WITH FORMAT, INIT, NAME = N'Log Backup AdventureWorks';
GO

-- 7. Видаліть базу даних
USE master;
ALTER DATABASE AdventureWorks SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE IF EXISTS AdventureWorks;
GO

-- 8. Відновіть повну копію в режимі NORECOVERY
RESTORE DATABASE AdventureWorks
FROM DISK = N'/var/opt/mssql/backups/AdventureWorks.bak'
WITH NORECOVERY, REPLACE;
GO

-- 9. Відновіть лог транзакцій на момент часу
RESTORE LOG AdventureWorks
FROM DISK = N'/var/opt/mssql/backups/AdventureWorks_Log.trn'
WITH RECOVERY,
STOPAT = 'YYYY-MM-DD HH:MM:SS';
GO

-- 10. Перевірка
USE AdventureWorks;
GO

SELECT e.JobTitle, p.FirstName
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
WHERE p.FirstName = N'ALFKI';
GO

SELECT * FROM Sales.Currency;
GO
