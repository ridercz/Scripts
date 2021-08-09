@ECHO OFF

REM --------------------------------------------------------------------------
REM -- Altair's IIS Setup Script: Phase 2
REM -- This will setup IIS after installation of required components.
REM --------------------------------------------------------------------------
REM -- (c) Michal A. Valasek - Altairis, 2008-2021
REM -- www.rider.cz - www.altairis.cz - github.com/ridercz/Scripts
REM --------------------------------------------------------------------------

REM -- Set root folder for web hosting sites
SET ROOT_FOLDER=D:\WWW-servers\LocalUser

REM -- Set path to appcmd utility
SET APPCMD=%SYSTEMROOT%\System32\inetsrv\appcmd.exe

REM -- Delete webdeploy.msi downloaded by phase 1
DEL webdeploy.msi

REM -- Enable Web Management Service and remote access
SC config wmsvc start=auto
REG ADD HKLM\SOFTWARE\Microsoft\WebManagement\Server /v EnableRemoteManagement /t REG_DWORD /d 1 /f

REM -- Use AP identity as anonymous request identity
%APPCMD% set config -section:system.webServer/security/authentication/anonymousAuthentication /userName:"" /commit:apphost

REM -- Create Customers group
NET LOCALGROUP Customers /ADD

REM -- Create web root folder
MKDIR %ROOT_FOLDER%

REM -- Copy scripts to web root folder
COPY newcust.cmd %ROOT_FOLDER%\newcust.cmd
COPY newsite.cmd %ROOT_FOLDER%\newsite.cmd

REM -- Fix SChannel settings in Azure template incompatible with IIS Crypto tool
ECHO Fixing SChannel settings in Azure template incompatible with IIS Crypto tool...
REG DELETE "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128" /f
REG DELETE "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128" /f
REG DELETE "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128" /f
REG DELETE "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client" /f
REG DELETE "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server" /f

REM -- Configure SChannel best practices settings 
ECHO Applying IIS Crypto best practices template...
iiscryptocli /template best

REM -- Reboot computer after completing phase 2
ECHO.
ECHO Phase 2 Done. Your server will be rebooted to apply settings.
PAUSE
SHUTDOWN /r /t 0 /d p:4:2
