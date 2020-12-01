@ECHO OFF

REM --------------------------------------------------------------------------
REM -- Altair's IIS Setup Script: Phase 1
REM --------------------------------------------------------------------------
REM -- This will configure operating system and install required software 
REM -- using Chocolatey and Web Platform Installer.
REM --------------------------------------------------------------------------
REM -- (c) Michal A. Valasek - Altairis, 2008-2020
REM -- www.rider.cz - www.altairis.cz - github.com/ridercz/Scripts
REM --------------------------------------------------------------------------

REM -- Set path to Web Platform Installer application
SET WEBPICMD="C:\Program Files\Microsoft\Web Platform Installer\WebpiCmd-x64.exe"

REM -- Disable IE ESC
ECHO Disabling IE ESC...
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" /v "IsInstalled" /t REG_DWORD /d 0 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" /v "IsInstalled" /t REG_DWORD /d 0 /f
RUNDLL32 iesetup.dll, IEHardenLMSettings
RUNDLL32 iesetup.dll, IEHardenUser
RUNDLL32 iesetup.dll, IEHardenAdmin
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" /f /va
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" /f /va
REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main" /v "First Home Page" /f
REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main" /v "Default_Page_URL" /t REG_SZ /d "about:blank" /f
REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main" /v "Start Page" /t REG_SZ /d "about:blank" /f

REM -- Show filename extensions
ECHO Showing filename extensions...
REG ADD HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt /t REG_DWORD /d 0 /f

REM -- Disable server manager at logon
ECHO Disabling Server Manager...
REG ADD HKCU\Software\Microsoft\ServerManager /V DoNotOpenServerManagerAtLogon /t REG_DWORD /D 0x1 /F

REM -- Enable unsigned PowerShell scripts
ECHO Enabling unsigned PowerShell scripts...
powershell Set-ExecutionPolicy RemoteSigned

REM -- Install Chocolatey
ECHO Installing Chocolatey...
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

REM -- Install WPI and other server packages via Chocolatey
choco install 7zip sysinternals webpi webpicmd iiscrypto-cli altap-salamander -y

REM -- Install IIS components via WPI 
%WEBPICMD% /Install /AcceptEula /Products:"IIS7,ARRv3_0,ASPNET45,NetFxExtensibility45,FTPServer,IISManagementScriptsAndTools,ManagementService,UrlRewrite2,WDeploy36,WDeploy_2_1,AppWarmUp,BasicAuthentication,CertProvider,CustomLogging,DynamicContentCompression,FTPExtensibility,HTTPRedirection,IPSecurity,Tracing,URLAuthorization"

REM -- Reboot computer after completing phase 1