@ECHO OFF

SET ROOT_FOLDER=D:\WWW-servers\LocalUser
SET APPCMD=%SYSTEMROOT%\System32\inetsrv\appcmd.exe
SET WEBPICMD="C:\Program Files\Microsoft\Web Platform Installer\WebpiCmd-x64.exe"

REM -- Disable IE ESC
ECHO Disabling IE ESC...
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" /v "IsInstalled" /t REG_DWORD /d 0 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" /v "IsInstalled" /t REG_DWORD /d 0 /f
Rundll32 iesetup.dll, IEHardenLMSettings
Rundll32 iesetup.dll, IEHardenUser
Rundll32 iesetup.dll, IEHardenAdmin
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
choco install 7zip sysinternals webpi webpicmd iiscrypto-cli -y

REM -- Install IIS components via WPI 
%WEBPICMD% /Install /AcceptEula /Products:"IIS7,ARRv3_0,ASPNET45,NetFxExtensibility45"
%WEBPICMD% /Install /AcceptEula /Products:"FTPServer,IISManagementScriptsAndTools,ManagementService,UrlRewrite2,WDeploy36,WDeploy_2_1,AppWarmUp,BasicAuthentication,CertProvider,CustomLogging,DynamicContentCompression,FTPExtensibility,HTTPRedirection,IPSecurity,Tracing,URLAuthorization"

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

ECHO Done. Your server will be rebooted to apply settings.
PAUSE
SHUTDOWN /r /t 0 /d p:4:2
