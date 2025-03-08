/******************************************************************************
** ALL DATABASES BACKUP SCRIPT FOR MICROSOFT SQL SERVER EXPRESS              **
** Copyright (c) Michal A. Valasek, Altairis, 2009-2025                      **
** http://www.altair.blog/ | http://www.altairis.cz/ | http://www.rider.cz/  **
** ------------------------------------------------------------------------- **
** When running from SQL Management Studio, enable Query -> SQLCMD mode      **
******************************************************************************/

-- Create Azure credential for backup (run manually and only once, with your credentials)
/*
CREATE CREDENTIAL ExpressBackup WITH 
    IDENTITY = 'expressbackuptest',
    SECRET = 'K+/CRAgwSKS+rUppSMg1P5YXVxSDZK12D8mCAzvn63R46E/YBBfQJ9bLJ3RVvy1YGWGDemZpCoYz+AStYu2ShA=='
*/

-- Configuration - include trailing slashes in BackupFilePath and AzureBaseUrl
:setvar BackupFilePath "C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\"
:setvar AzureBaseUrl "https://expressbackuptest.blob.core.windows.net/sqlbackup/"
:setvar AzureCredentialName "ExpressBackup"

-- Declare variables used in the script
DECLARE
    @timestamp		AS nvarchar(20),
    @current_id		AS int,
    @current_name	AS nvarchar(max),
    @current_file	AS nvarchar(max),
	@current_url	AS nvarchar(max)

-- Create file name timestamp (YYYYMMDD_hhmmss format)
SET @timestamp = CONVERT(nvarchar, GETDATE(), 20)
SET @timestamp = REPLACE(@timestamp, '-', '')
SET @timestamp = REPLACE(@timestamp, ':', '')
SET @timestamp = REPLACE(@timestamp, ' ', '_')

-- Verify that there are credentials for Azure backup
IF NOT EXISTS (SELECT * FROM sys.credentials WHERE NAME = '$(AzureCredentialName)') BEGIN
    PRINT 'Azure credentials "$(AzureCredentialName)" not found, Azure backup is disabled.'
    PRINT NULL
END

-- Get initial database ID
SELECT @current_id = MIN(database_id) FROM sys.databases WHERE owner_sid != 0x01

-- Go trough all databases
WHILE @current_id IS NOT NULL BEGIN
    -- Get database name and backup file
    SELECT @current_name = name FROM sys.databases WHERE database_id = @current_id
    SET @current_file = '$(BackupFilePath)' + @current_name + '_' + @timestamp + '.bak'
    
    -- Backup database to local disk
    PRINT 'Backing up database ' + @current_name + ' to ' + @current_file
    BACKUP DATABASE @current_name TO  DISK = @current_file WITH NOINIT
    PRINT NULL

    -- Backup database to Azure Storage
    IF EXISTS (SELECT * FROM sys.credentials WHERE NAME = '$(AzureCredentialName)') BEGIN
        SET @current_url = '$(AzureBaseUrl)' + @current_name + '_' + @timestamp + '.bak'
        PRINT 'Backing up database ' + @current_name + ' to ' + @current_url
        BACKUP DATABASE @current_name TO URL = @current_url WITH CREDENTIAL = '$(AzureCredentialName)'
        PRINT NULL
    END
    
    -- Get next database
    SELECT @current_id = MIN(database_id) FROM sys.databases WHERE owner_sid != 0x01 AND database_id > @current_id
END

PRINT 'Backup of all databases completed.'