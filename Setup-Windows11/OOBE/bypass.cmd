curl -L -o C:\Windows\Panther\unattend.xml https://raw.githubusercontent.com/ridercz/Scripts/refs/heads/main/Setup-Windows11/OOBE/unattend.xml
C:\Windows\System32\Sysprep\Sysprep.exe /oobe /unattend:C:\Windows\Panther\unattend.xml /reboot
