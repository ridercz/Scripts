# Remove bundled software
Get-AppxPackage Microsoft.Xbox.TCUI | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxIdentityProvider | Remove-AppxPackage
Get-AppxPackage Microsoft.MicrosoftSolitaireCollection | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxGameOverlay | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxSpeechToTextOverlay | Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsFeedbackHub | Remove-AppxPackage
Get-AppxPackage Microsoft.People | Remove-AppxPackage
Get-AppxPackage Microsoft.GetHelp | Remove-AppxPackage
Get-AppxPackage Microsoft.MicrosoftOfficeHub | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxGamingOverlay | Remove-AppxPackage
Get-AppxPackage Microsoft.ZuneVideo | Remove-AppxPackage
Get-AppxPackage Microsoft.ZuneMusic | Remove-AppxPackage
Get-AppxPackage Microsoft.BingNews | Remove-AppxPackage
Get-AppxPackage Microsoft.GamingApp | Remove-AppxPackage
Get-AppxPackage MicrosoftTeams | Remove-AppxPackage
Get-AppxPackage Clipchamp.Clipchamp | Remove-AppxPackage

# Disable blur on logon screen
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "DisableAcrylicBackgroundOnLogon" -Type DWord -Value 1

# Disable Autoplay
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1

# Ignore RDP remote keyboard layout
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout" -Name "IgnoreRemoteKeyboardLayout" -Type DWord -Value 1