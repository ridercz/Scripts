@ECHO OFF
CLS

ECHO This script will create CA structure using OpenSSL on local computer
CHOICE /M "Do you want to continue"
IF %ERRORLEVEL% NEQ 1 EXIT /B 

REM -- Check for existing folders
IF NOT EXIST bin GOTO NOOPENSSL
IF NOT EXIST bin\openssl.exe GOTO NOOPENSSL
IF EXIST rca GOTO EXISTS
IF EXIST ica GOTO EXISTS
IF EXIST cca GOTO EXISTS 

REM -- Create folders and files for all CAs
MKDIR rca
MKDIR rca\issued
ECHO 01>rca\serial.txt
ECHO 01>rca\crlnumber.txt
COPY nul rca\index.txt >NUL 2>NUL
ECHO unique_subject = no > rca\index.txt.attr

MKDIR ica
MKDIR ica\issued
ECHO 01>ica\serial.txt
ECHO 01>ica\crlnumber.txt
COPY nul ica\index.txt >NUL 2>NUL
ECHO unique_subject = no > ica\index.txt.attr

MKDIR cca
MKDIR cca\issued
ECHO 01>cca\serial.txt
ECHO 01>cca\crlnumber.txt
COPY nul cca\index.txt >NUL 2>NUL
ECHO unique_subject = no > cca\index.txt.attr

REM -- Create self-signed root CA (rca) certificate and private key
ECHO.
ECHO -------------------------------------------------------------------------------
ECHO ENTER DATA FOR THE ROOT CERTIFICATION AUTHORITY
ECHO -------------------------------------------------------------------------------
ECHO.
bin\openssl req -config openssl.cfg -newkey rsa:4096 -x509 -sha256 -days 7300 -nodes -keyout rca\rca.key -out rca\rca.crt -extensions ext_root

REM -- Generate and sign keys of Infrastructure CA (ica)
bin\openssl genrsa -out ica\ica.key 4096
ECHO.
ECHO -------------------------------------------------------------------------------
ECHO ENTER DATA FOR THE INFRASTRUCTURE CERTIFICATION AUTHORITY
ECHO -------------------------------------------------------------------------------
ECHO.
bin\openssl req -config openssl.cfg -new -sha256 -key ica\ica.key -out ica\ica.csr
bin\openssl ca -config openssl.cfg -name ca_rca -batch -extensions ext_sub -days 3650 -notext -md sha256 -in ica\ica.csr -out ica\ica.crt

REM -- Generate and sign keys of Corporate CA (cca)
bin\openssl genrsa -out cca\cca.key 4096
ECHO.
ECHO -------------------------------------------------------------------------------
ECHO ENTER DATA FOR THE CORPORATE CERTIFICATION AUTHORITY
ECHO -------------------------------------------------------------------------------
ECHO.
bin\openssl req -config openssl.cfg -new -sha256 -key cca\cca.key -out cca\cca.csr
bin\openssl ca -config openssl.cfg -name ca_rca -batch -extensions ext_sub -days 3650 -notext -md sha256 -in cca\cca.csr -out cca\cca.crt

REM -- Generate initial CRLs
CALL update_crls.cmd

REM -- Cleanup
DEL ica\ica.csr
DEL cca\cca.csr
EXIT /B

:NOOPENSSL
ECHO.
ECHO Please install OpenSSL binaries into the 'bin' folder.
ECHO You may download OpenSSL for Windows from the following URL:
ECHO https://slproweb.com/products/Win32OpenSSL.html
EXIT /B

:EXISTS
ECHO.
ECHO It looks like CA was already setup here. If you want to recreate it, 
ECHO please delete the CA folders and run setup again.
