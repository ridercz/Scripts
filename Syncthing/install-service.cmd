mkdir C:\Syncthing\config
icacls C:\Syncthing\config /grant "NT AUTHORITY\NETWORK SERVICE:(OI)(CI)(F)"

nssm install Syncthing C:\Syncthing\bin\syncthing.exe
nssm set Syncthing AppParameters --no-restart --no-browser --no-default-folder --home="C:\Syncthing\config"
nssm set Syncthing Description Syncthing synchronization service
nssm set Syncthing Start SERVICE_DELAYED_AUTO_START
nssm set Syncthing ObjectName "NT AUTHORITY\NETWORK SERVICE"
nssm set Syncthing AppNoConsole 1
nssm set Syncthing AppStopMethodConsole 10000
nssm set Syncthing AppStopMethodWindow 10000
nssm set Syncthing AppStopMethodThreads 10000
nssm set Syncthing AppExit Default Exit
nssm set Syncthing AppExit 0 Exit
nssm set Syncthing AppExit 3 Restart
nssm set Syncthing AppExit 4 Restart

net start syncthing
start http://localhost:8384/
