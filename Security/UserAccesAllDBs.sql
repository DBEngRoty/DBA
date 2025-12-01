CREATE LOGIN [SQLHKTUsr] WITH PASSWORD = 'SkyIsBlue4!Today';

 
DECLARE @DBName SYSNAME;
DECLARE @SQL NVARCHAR(MAX);
DECLARE db_cursor CURSOR FOR
SELECT name FROM sys.databases WHERE database_id > 4  -- Exclude system DBs AND state_desc = 'ONLINE';

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @DBName;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = '
    USE [' + @DBName + '];
    IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = ''SQLHKTUsr'')
    BEGIN
        CREATE USER [SQLHKTUsr] FOR LOGIN [SQLHKTUsr];
    END;
    EXEC sp_addrolemember ''db_owner'', ''SQLHKTUsr'';';
    PRINT @SQL;  -- For debugging
    EXEC sp_executesql @SQL;
    FETCH NEXT FROM db_cursor INTO @DBName;
END;

CLOSE db_cursor;
DEALLOCATE db_cursor;

 
