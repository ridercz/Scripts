@ECHO OFF

REM --------------------------------------------------------------------------
REM -- Altair's IIS Setup Script: Phase 1
REM -- This will configure operating system and install required software.
REM --------------------------------------------------------------------------
REM -- (c) Michal A. Valasek - Altairis, 2008-2025
REM -- www.rider.cz - www.altairis.cz - github.com/ridercz/Scripts
REM --------------------------------------------------------------------------

REM -- Show filename extensions
ECHO Showing filename extensions...
REG ADD HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt /t REG_DWORD /d 0 /f

REM -- Disable server manager at logon
ECHO Disabling Server Manager...
REG ADD HKCU\Software\Microsoft\ServerManager /V DoNotOpenServerManagerAtLogon /t REG_DWORD /d 1 /f

REM -- Enable unsigned PowerShell scripts
ECHO Enabling unsigned PowerShell scripts...
powershell Set-ExecutionPolicy RemoteSigned

REM -- Install standard IIS components
ECHO Installing web server...
powershell Install-WindowsFeature -name Web-Server, Web-Request-Monitor, Web-Http-Tracing, Web-Dyn-Compression, Web-CertProvider, Web-IP-Security, Web-Url-Auth, Web-Net-Ext45, Web-AppInit, Web-Asp-Net45, Web-WebSockets, Web-Ftp-Server, Web-Scripting-Tools, Web-Mgmt-Service -IncludeManagementTools      

REM -- Install server packages via WinGet
winget install 7zip.7zip Altap.Salamander Microsoft.WebDeploy Microsoft.Sysinternals.Suite Microsoft.DotNet.HostingBundle.8 Microsoft.DotNet.HostingBundle.9 Microsoft.DotNet.HostingBundle.10 NartacSoftwareInc.IISCryptoCLI --accept-package-agreements --accept-source-agreements

REM -- Install URL Rewrite Module and ARR
ECHO Installing URL Rewrite Module...
curl -o rewrite.msi https://download.microsoft.com/download/1/2/8/128E2E22-C1B9-44A4-BE2A-5859ED1D4592/rewrite_amd64_en-US.msi
msiexec /i rewrite.msi /quiet
del rewrite.msi
ECHO Installing Application Request Routing...
curl -o arr.msi https://download.microsoft.com/download/E/9/8/E9849D6A-020E-47E4-9FD0-A023E99B54EB/requestRouter_amd64.msi
msiexec /i arr.msi /quiet
del arr.msi

REM -- Reboot computer after completing phase 1
ECHO.
ECHO Phase 1 Done. Your server will be rebooted to apply settings.
PAUSE
SHUTDOWN /r /t 0 /d p:4:2
