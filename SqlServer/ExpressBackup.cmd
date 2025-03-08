@ECHO OFF

REM *******************************************************************************
REM ** ALL DATABASES BACKUP SCRIPT FOR MICROSOFT SQL SERVER EXPRESS EDITION      **
REM ** Copyright (c) Michal A. Valasek, Altairis, 2009-2025                      **
REM ** http://www.altair.blog/ | http://www.altairis.cz/ | http://www.rider.cz/  **
REM *******************************************************************************

REM -- Set backup folder path without the trailing backslash
SET BackupFilePath=C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup

REM -- Call SQLCMD with parameters needed to connect to SQL Server
ECHO Backing up all databases...
sqlcmd -S .\SqlExpress -E -i %~dp0\ExpressBackup.sql -o "%BackupFilePath%\ExpressBackup.log"

REM -- Delete all backup files older than 7 days
ECHO Deleting backups older than 7 days...
FORFILES /P "%BackupFilePath%" /M *.bak /D -7 /C "CMD /C DEL /Q @FILE"