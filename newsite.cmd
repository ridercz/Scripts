@ECHO OFF

REM -- Configuration
SET ROOT_FOLDER=D:\WWW-servers\LocalUser
SET APPCMD=%SYSTEMROOT%\System32\inetsrv\appcmd.exe

REM -- Banner
ECHO Create new site script
ECHO Copyright (c) Michal A. Valasek - Altairis, 2010-2016
ECHO.

REM -- Validate
IF .%1.==.. GOTO HELP
IF .%2.==.. GOTO HELP

IF NOT EXIST %ROOT_FOLDER%\%2 (
  ECHO ERROR: Folder %ROOT_FOLDER%\%2 not found!
  EXIT /B
)

REM -- Perform operations

ECHO Creating folder "%ROOT_FOLDER%\%2\%1"...
MKDIR %ROOT_FOLDER%\%2\%1

ECHO Creating web site "%2-%1"...
%APPCMD% ADD SITE /name:"%2-%1" /bindings:"http://%1:80" /physicalPath:"%ROOT_FOLDER%\%2\%1"
%APPCMD% SET APP "%2-%1/" /applicationPool:"AP_%2"
EXIT /B

:HELP
ECHO USAGE:
ECHO newsite site_url user_name
ECHO.
ECHO EXAMPLE:
ECHO newsite www.contoso.com contoso
