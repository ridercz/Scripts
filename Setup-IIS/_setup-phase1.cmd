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
powershell Install-WindowsFeature -name Web-Server -IncludeManagementTools
powershell Install-WindowsFeature -name Web-Request-Monitor    
powershell Install-WindowsFeature -name Web-Http-Tracing       
powershell Install-WindowsFeature -name Web-Dyn-Compression    
powershell Install-WindowsFeature -name Web-CertProvider       
powershell Install-WindowsFeature -name Web-IP-Security        
powershell Install-WindowsFeature -name Web-Url-Auth           
powershell Install-WindowsFeature -name Web-Net-Ext45          
powershell Install-WindowsFeature -name Web-AppInit            
powershell Install-WindowsFeature -name Web-Asp-Net45          
powershell Install-WindowsFeature -name Web-WebSockets         
powershell Install-WindowsFeature -name Web-Ftp-Server         
powershell Install-WindowsFeature -name Web-Scripting-Tools    
powershell Install-WindowsFeature -name Web-Mgmt-Service       

REM -- Install Chocolatey
ECHO Installing Chocolatey...
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

REM -- Install server packages via Chocolatey
choco install 7zip sysinternals iiscrypto-cli altap-salamander iis-arr dotnet-8.0-windowshosting -y
REM -- Install .NET 9.0 hosting package (ignore dependencies, because they are already installed and the package is not aware of it)
choco install dotnet-9.0-windowshosting -y --ignore-dependencies

REM -- Install IIS Web Deploy 4.0 (manually, because Chocolatey package for it does not exist)
ECHO Installing IIS Web Deploy...
powershell Invoke-WebRequest "https://download.microsoft.com/download/b/d/8/bd882ec4-12e0-481a-9b32-0fae8e3c0b78/webdeploy_amd64_en-US.msi" -OutFile webdeploy.msi
msiexec /i webdeploy.msi /passive /norestart ADDLOCAL=all

REM -- Reboot computer after completing phase 1
ECHO.
ECHO Phase 1 Done. Your server will be rebooted to apply settings.
PAUSE
SHUTDOWN /r /t 0 /d p:4:2
