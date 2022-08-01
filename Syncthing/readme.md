# Syncthing configuration

## Autostart via Task Scheduler

1. Download [Syncthing](https://github.com/syncthing/syncthing/releases/latest).
1. Extract archive to `C:\Syncthing\bin`.
1. Using _Scheduled Tasks_ import the file `scheduled-tasks.xml` to run on system startup.

## Autostart as a service

1. Download [Syncthing](https://github.com/syncthing/syncthing/releases/latest).
1. Extract archive to `C:\Syncthing\bin`.
1. Download [NSSM](https://nssm.cc/download).
1. Extract `nssm.exe` to `C:\Syncthing`.
1. Run `install-service.cmd` to register Syncthing as a service running under `NT AUTHORITY\NETWORK SERVICE`.

All synchronized folders need to be accessible to `NT AUTHORITY\NETWORK SERVICE` identity. Use the following command to add the _Full Control_ access:

```cmd
icacls C:\some\folder /grant "NT AUTHORITY\NETWORK SERVICE:(OI)(CI)(F)"
```