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

REM -- Install server packages via WinGet
winget install 7zip.7zip Altap.Salamander Microsoft.WebDeploy Microsoft.Sysinternals Microsoft.DotNet.HostingBundle.8 Microsoft.DotNet.HostingBundle.9 NartacSoftwareInc.IISCryptoCLI

REM -- Reboot computer after completing phase 1
ECHO.
ECHO Phase 1 Done. Your server will be rebooted to apply settings.
PAUSE
SHUTDOWN /r /t 0 /d p:4:2
