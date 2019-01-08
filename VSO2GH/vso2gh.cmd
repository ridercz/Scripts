@ECHO OFF
SETLOCAL

ECHO -------------------------------------------------------------------------------
ECHO VSO2GH version 1.0.0 - (c) Michal A. Valasek - Altairis, 2019
ECHO                            www.altair.blog * www.rider.cz * www.altairis.cz
ECHO -------------------------------------------------------------------------------
ECHO.

IF "%1" EQU "" GOTO HELP
IF "%2" EQU "" GOTO HELP
IF "%3" EQU "" GOTO HELP

SET SOURCE=https://%1.visualstudio.com/DefaultCollection/%3/_git/%3
IF "%4" EQU "" (
    SET TARGET=https://github.com/%2/%3.git
) ELSE (
    SET TARGET=https://github.com/%2/%4.git
)


ECHO Migrate git repository from Azure DevOps (ex- Visual Studio Online) to GitHub:
ECHO Source: %SOURCE%
ECHO Target: %TARGET%
CHOICE /M "Do you want to continue?"
IF %ERRORLEVEL% NEQ 1 EXIT /B
ECHO.

REM -- First, clone the original repository
git clone %SOURCE%

REM -- Remove original remote origin
CD %3
git remote rm origin

REM -- Add GitHub as new remote origin
git remote add origin %TARGET%

REM -- Push the repository there
git push -u origin master

REM -- Configure
git config master.remote origin
git config master.merge refs/heads/master

CD ..
EXIT /B

:HELP
ECHO Migrate git repository from Azure DevOps (ex- Visual Studio Online) to GitHub.
ECHO.
ECHO USAGE vso2gh hostname username vsoproject [ghproject]
ECHO hostname      the custom part of *.visualstudio.com
ECHO username      GitHub user name
ECHO vsoproject    repository name in Azure DevOps/VSO
ECHO ghproject     empty GitHub project name, defaults to vsoproject
