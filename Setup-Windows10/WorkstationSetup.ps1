# Uninstall some Windows components
Get-AppxPackage "Microsoft.BingFinance" | Remove-AppxPackage
Get-AppxPackage "Microsoft.BingNews" | Remove-AppxPackage
Get-AppxPackage "Microsoft.BingSports" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Getstarted" | Remove-AppxPackage
Get-AppxPackage "Microsoft.MicrosoftOfficeHub" | Remove-AppxPackage
Get-AppxPackage "Microsoft.MicrosoftSolitaireCollection" | Remove-AppxPackage
Get-AppxPackage "Microsoft.People" | Remove-AppxPackage
Get-AppxPackage "Microsoft.SkypeApp" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Windows.Photos" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WindowsAlarms" | Remove-AppxPackage
Get-AppxPackage "microsoft.windowscommunicationsapps" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WindowsMaps" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WindowsPhone" | Remove-AppxPackage
Get-AppxPackage "Microsoft.XboxApp" | Remove-AppxPackage
Get-AppxPackage "Microsoft.ZuneMusic" | Remove-AppxPackage
Get-AppxPackage "Microsoft.ZuneVideo" | Remove-AppxPackage
Get-AppxPackage "Microsoft.MicrosoftStickyNotes" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Office.Sway" | Remove-AppxPackage
Get-AppxPackage "9E2F88E3.Twitter" | Remove-AppxPackage
Get-AppxPackage "king.com.CandyCrushSodaSaga" | Remove-AppxPackage
Get-AppxPackage "4DF9E0F8.Netflix" | Remove-AppxPackage
Get-AppxPackage "Drawboard.DrawboardPDF" | Remove-AppxPackage
Get-AppxPackage "D52A8D61.FarmVille2CountryEscape" | Remove-AppxPackage
Get-AppxPackage "GAMELOFTSA.Asphalt8Airborne" | Remove-AppxPackage
Get-AppxPackage "Microsoft.MinecraftUWP" | Remove-AppxPackage
Get-AppxPackage "flaregamesGmbH.RoyalRevolt2" | Remove-AppxPackage
Get-AppxPackage "AdobeSystemsIncorporated.AdobePhotoshopExpress" | Remove-AppxPackage
Get-AppxPackage "ActiproSoftwareLLC.562882FEEB491" | Remove-AppxPackage
Get-AppxPackage "D5EA27B7.Duolingo-LearnLanguagesforFree" | Remove-AppxPackage
Get-AppxPackage "Facebook.Facebook" | Remove-AppxPackage
Get-AppxPackage "46928bounde.EclipseManager" | Remove-AppxPackage
Get-AppxPackage "A278AB0D.MarchofEmpires" | Remove-AppxPackage

# Disable Xbox DVR
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR")) {
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Type DWord -Value 0

# Disable Start Menu suggestions
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0

# Disable Feedback
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {
	New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0

# Disable Advertising ID
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo")) {
	New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Type DWord -Value 0

# Disable Remote Assistance
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 0

# Disable Autoplay
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1

# Disable Autoplay
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1

# Disable Autorun for all drives
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
	New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Type DWord -Value 255

# Disable Sticky keys prompt
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"

# Hide Search button / box
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0

# Hide Task View button
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0

# Show small icons in taskbar
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -Type DWord -Value 1

# Show titles in taskbar
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Type DWord -Value 1

# Show all tray icons
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Type DWord -Value 0

# Show known file extensions
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0

# Change default Explorer view to This PC
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1

# Uninstall Work Folders Client
dism /online /Disable-Feature /FeatureName:WorkFolders-Client /Quiet /NoRestart

# Disable blur on logon screen
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "DisableAcrylicBackgroundOnLogon" -Type DWord -Value 1
