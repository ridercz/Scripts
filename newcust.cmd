@ECHO OFF

REM -- Configuration
SET ROOT_FOLDER=D:\WWW-servers\LocalUser
SET APPCMD=%SYSTEMROOT%\System32\inetsrv\appcmd.exe
SET FTP_GROUP_NAME=Customers

REM -- Banner
ECHO Create new customer script
ECHO Copyright (c) Michal A. Valasek - Altairis, 2009-2016
ECHO.

REM -- Validate
IF .%1.==.. GOTO HELP
IF .%2.==.. GOTO HELP
IF .%3.==.. GOTO HELP
IF EXIST %ROOT_FOLDER%\%2 (
  ECHO ERROR: Folder %ROOT_FOLDER%\%2 already exists!
  EXIT /B
)

REM -- Perform operations

ECHO Creating IIS Application pool "AP_%2"...
%APPCMD% ADD APPPOOL /name:"AP_%2"

ECHO Creating user "%2" in group "%FTP_GROUP_NAME%"...
NET USER /ADD %2 %3 /FULLNAME:"FTP for %2"
NET LOCALGROUP %FTP_GROUP_NAME% %2 /ADD

ECHO Creating folder "%ROOT_FOLDER%\%2\%1"...
MKDIR %ROOT_FOLDER%\%2\%1

ECHO Setting ACL for FTP user...
ICACLS "%ROOT_FOLDER%\%2" /grant "%2":"(OI)(CI)F" /T /Q

ECHO Setting ACL for AP identity...
ICACLS "%ROOT_FOLDER%\%2" /grant "IIS APPPOOL\AP_%2":"(OI)(CI)F" /T /Q

ECHO Creating web site "%2-%1"...
%APPCMD% ADD SITE /name:"%2-%1" /bindings:"http://%1:80" /physicalPath:"%ROOT_FOLDER%\%2\%1"
%APPCMD% SET APP "%2-%1/" /applicationPool:"AP_%2"

EXIT /B

:HELP
ECHO USAGE:
ECHO newcust site_url new_user_name password
ECHO.
ECHO EXAMPLE:
ECHO newcust www.contoso.com contoso topsecret

:END
