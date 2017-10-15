@ECHO OFF

SET ROOT_FOLDER=D:\WWW-servers\LocalUser
SET APPCMD=%SYSTEMROOT%\System32\inetsrv\appcmd.exe
SET WEBPICMD="C:\Program Files\Microsoft\Web Platform Installer\WebpiCmd-x64.exe"

REM -- Install IIS components via WPI 
%WEBPICMD% /Install /AcceptEula /Products:"IIS7,ARRv3_0,ASPNET45,FTPServer,IISManagementScriptsAndTools,ManagementService,NetFxExtensibility45,UrlRewrite2,WDeploy36,WDeploy_2_1,AppWarmUp,BasicAuthentication,CertProvider,CustomLogging,DynamicContentCompression,FTPExtensibility,HTTPRedirection,IPSecurity,Tracing,URLAuthorization"

REM -- Use AP identity as anonymous request identity
%APPCMD% set config -section:system.webServer/security/authentication/anonymousAuthentication /userName:"" /commit:apphost

REM -- Create Customers group
NET LOCALGROUP Customers /ADD

REM -- Create web root folder
MKDIR %ROOT_FOLDER%

REM -- Copy scripts to web root folder
COPY newcust.cmd %ROOT_FOLDER%\newcust.cmd
COPY newsite.cmd %ROOT_FOLDER%\newsite.cmd