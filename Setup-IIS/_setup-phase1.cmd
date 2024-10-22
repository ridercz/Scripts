@ECHO OFF

REM --------------------------------------------------------------------------
REM -- Altair's IIS Setup Script: Phase 1
REM -- This will configure operating system and install required software.
REM --------------------------------------------------------------------------
REM -- (c) Michal A. Valasek - Altairis, 2008-2024
REM -- www.rider.cz - www.altairis.cz - github.com/ridercz/Scripts
REM --------------------------------------------------------------------------

REM -- Show filename extensions
ECHO Showing filename extensions...
REG ADD HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt /t REG_DWORD /d 0 /f

REM -- Disable PowerShell in Win+X menu
ECHO Disabling PowerShell in Win+X menu...
REG ADD HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v DontUsePowerShellOnWinX /t REG_DWORD /d 1 /f

REM -- Disable server manager at logon
ECHO Disabling Server Manager...
REG ADD HKCU\Software\Microsoft\ServerManager /V DoNotOpenServerManagerAtLogon /t REG_DWORD /d 1 /f

REM -- Enable unsigned PowerShell scripts
ECHO Enabling unsigned PowerShell scripts...
powershell Set-ExecutionPolicy RemoteSigned

REM -- Install standard IIS components
ECHO Installing web server...
powershell Install-WindowsFeature -name Web-Server -IncludeManagementTools
ECHO Installing common web server features...
powershell Enable-WindowsOptionalFeature -Online -FeatureName IIS-RequestMonitor,IIS-HttpTracing,IIS-IPSecurity,IIS-HttpCompressionDynamic
ECHO Installing ASP.NET...
powershell Enable-WindowsOptionalFeature -Online -FeatureName NetFx4Extended-ASPNET45,IIS-ApplicationDevelopment,IIS-ApplicationInit,IIS-ISAPIExtensions,IIS-ISAPIFilter,IIS-NetFxExtensibility45,IIS-ASPNET45,IIS-WebSockets
ECHO Installing management tools...
powershell Enable-WindowsOptionalFeature -Online -FeatureName IIS-ManagementScriptingTools,IIS-ManagementService
ECHO Installing FTP server...
powershell Enable-WindowsOptionalFeature -Online -FeatureName IIS-FTPServer,IIS-FTPSvc
ECHO Installing Centralized Certificate Store...
powershell Enable-WindowsOptionalFeature -Online -FeatureName IIS-CertProvider

REM -- Install Chocolatey
ECHO Installing Chocolatey...
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

REM -- Install server packages via Chocolatey
choco install 7zip sysinternals iiscrypto-cli altap-salamander iis-arr dotnet-8.0-windowshosting -y

REM -- Install IIS Web Deploy (manually, because Chocolatey package for it is broken ATM)
ECHO Installing IIS Web Deploy...
powershell Invoke-WebRequest "https://download.microsoft.com/download/0/1/D/01DC28EA-638C-4A22-A57B-4CEF97755C6C/WebDeploy_amd64_en-US.msi" -OutFile webdeploy.msi
msiexec /i webdeploy.msi /passive /norestart ADDLOCAL=all

REM -- Reboot computer after completing phase 1
ECHO.
ECHO Phase 1 Done. Your server will be rebooted to apply settings.
PAUSE
SHUTDOWN /r /t 0 /d p:4:2
