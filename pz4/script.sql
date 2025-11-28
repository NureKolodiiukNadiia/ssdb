---- 1. Встановіть модель відновлення (Full)
--USE master;
--ALTER DATABASE AdventureWorks2022 SET RECOVERY FULL;
--GO

---- 2. Зробіть повний бекап даних
--BACKUP DATABASE AdventureWorks2022
--TO DISK = N'/var/opt/mssql/backups/AdventureWorks.bak'
--WITH FORMAT, INIT, NAME = N'Full Backup AdventureWorks2022';
--GO

-- 3. Перевірка створення файла

---- 4. Замініть посаду 
--USE AdventureWorks2022; 
--GO

--UPDATE HumanResources.Employee 
--SET JobTitle = N'Manager' 
--WHERE BusinessEntityID IN ( 
-- SELECT BusinessEntityID FROM Person.Person WHERE LastName = N'Tamburello' 
--); 
--GO 

-- 5. Засічіть час та проведіть руйнівні дії 
--SELECT GETDATE() AS CurrentTime; 
--GO 
--ALTER TABLE HumanResources.EmployeeDepartmentHistory
--DROP CONSTRAINT FK_EmployeeDepartmentHistory_Shift_ShiftID;

--DROP TABLE IF EXISTS HumanResources.Shift; 
--GO

-- 6. Створіть резервну копію логу транзакцій
--BACKUP LOG AdventureWorks2022
--TO DISK = N'/var/opt/mssql/backups/AdventureWorks_Log.trn'
--WITH FORMAT, INIT, NAME = N'Log Backup AdventureWorks2022';
--GO

---- 7. Видаліть базу даних
--USE master;
--GO
--ALTER DATABASE AdventureWorks2022 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
--DROP DATABASE IF EXISTS AdventureWorks2022;
--GO

---- 8. Відновіть повний бекап у режимі NORECOVERY
--RESTORE DATABASE AdventureWorks2022
--FROM DISK = N'/var/opt/mssql/backups/AdventureWorks.bak'
--WITH NORECOVERY, REPLACE;
--GO

---- 9. Відновіть лог транзакцій до моменту перед критичними змінами
--RESTORE LOG AdventureWorks2022
--FROM DISK = N'/var/opt/mssql/backups/AdventureWorks_Log.trn'
--WITH RECOVERY,
--STOPAT = '2025-11-28 00:01:00';
--GO

---- 10. Перевірка
--USE AdventureWorks2022;
--GO

--SELECT e.JobTitle, p.LastName
--FROM HumanResources.Employee e
--INNER JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
--WHERE p.LastName = N'Tamburello';
--GO

--SELECT * FROM HumanResources.Shift;
--GO
