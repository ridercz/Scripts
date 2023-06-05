@echo off

REM -- Disable password expiration
NET ACCOUNTS /maxpwage:unlimited

REM -- Enable automatic updates
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 0 /f
