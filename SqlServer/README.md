# Automatic backup for SQL Server Express databases

This script solves one problem with the Express Edition of Microsoft SQL Server: lack of automated backup solution. It will perform backup of all user databases to local folder and optionally to Azure Blob Storage.

## How to use

### Installation

Save the files [`ExpressBackup.sql`](ExpressBackup.sql) and [`ExpressBackup.cmd`](ExpressBackup.cmd) to `C:\ExpressBackup` (or any other folder and modify the commands accordingly).

### Setup Azure Blob Storage (optional)

1. [Create Azure Storage Account](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-portal). 
1. Create blob container called `sqlbackup`.
1. Define named credential in SQL Server. You do this only once. Run the following TSQL command, replacing `IDENTITY` and `SECRET` with your storage account name and access key:

```sql
CREATE CREDENTIAL ExpressBackup WITH 
    IDENTITY = 'expressbackuptest',
    SECRET = 'K+/CRAgwSKS+rUppSMg1P5YXVxSDZK12D8mCAzvn63R46E/YBBfQJ9bLJ3RVvy1YGWGDemZpCoYz+AStYu2ShA=='
```

### Run backup manually

1. Open the [`ExpressBackup.sql`](ExpressBackup.sql) file in SQL Server Management Studio.
1. Enable SQLCMD mode from menu _Query > SQLCMD Mode_.
1. Set values in lines starting with `:setvar` accordingly -- to point to your chosen backup folder and storage account. **Both values must end with trailing slash!**
1. Run the script and examine its output to verify everything was performed correctly.

### Run backup automatically

1. Edit [`ExpressBackup.cmd`](ExpressBackup.cmd) file and set the `BackupFilePath` variable to path where your backup files are. **Do not include the trailing slash this time!**
1. Run the following command in command line to create scheduled task called _ExpressBackup_, that will backup all databases every day at 05:00:

```
schtasks /create /tn ExpressBackup /tr C:\ExpressBackup\ExpressBackup.cmd /sc daily /st 05:00 /np
```