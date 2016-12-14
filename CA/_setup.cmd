@ECHO OFF
CLS

ECHO This script will create CA structure using OpenSSL on local computer
CHOICE /M "Do you want to continue"
IF %ERRORLEVEL% NEQ 1 EXIT /B 

REM -- Check for existing folders
IF NOT EXIST bin GOTO NOOPENSSL
IF NOT EXIST bin\openssl.exe GOTO NOOPENSSL
IF EXIST ARCA GOTO EXISTS
IF EXIST AICA GOTO EXISTS
IF EXIST ACCA GOTO EXISTS 

REM -- Create folders and files for all CAs
MKDIR ARCA
MKDIR ARCA\Issued
ECHO 01>ARCA\serial.txt
ECHO 01>ARCA\crlnumber.txt
COPY nul ARCA\index.txt >NUL 2>NUL

MKDIR AICA
MKDIR AICA\Issued
ECHO 01>AICA\serial.txt
ECHO 01>AICA\crlnumber.txt
COPY nul AICA\index.txt >NUL 2>NUL

MKDIR ACCA
MKDIR ACCA\Issued
ECHO 01>ACCA\serial.txt
ECHO 01>ACCA\crlnumber.txt
COPY nul ACCA\index.txt >NUL 2>NUL

REM -- Create self-signed root CA (ARCA) certificate and private key
bin\openssl req -config ARCA.cfg -newkey rsa:4096 -x509 -sha256 -days 7300 -nodes -keyout ARCA\ARCA.key -out ARCA\ARCA.crt -subj "/CN=Altairis Root CA/O=Altairis, s. r. o./OU=Network Operations Center/C=CZ/emailAddress=caoperator@corp.altairis.cz" -extensions ext_root

REM -- Generate and sign keys of Infrastructure CA (AICA)
bin\openssl genrsa -out AICA\AICA.key 4096
bin\openssl req -config AICA.cfg -new -sha256 -key AICA\AICA.key -out AICA\AICA.csr -subj "/CN=Altairis Infrastructure CA/O=Altairis, s. r. o./OU=Network Operations Center/C=CZ/emailAddress=caoperator@corp.altairis.cz"
bin\openssl ca -config ARCA.cfg -batch -extensions ext_sub -days 3650 -notext -md sha256 -in AICA\AICA.csr -out AICA\AICA.crt

REM -- Generate and sign keys of Corporate CA (ACCA)
bin\openssl genrsa -out ACCA\ACCA.key 4096
bin\openssl req -config ACCA.cfg -new -sha256 -key ACCA\ACCA.key -out ACCA\ACCA.csr -subj "/CN=Altairis Corporate CA/O=Altairis, s. r. o./OU=Network Operations Center/C=CZ/emailAddress=caoperator@corp.altairis.cz"
bin\openssl ca -config ARCA.cfg -batch -extensions ext_sub -days 3650 -notext -md sha256 -in ACCA\ACCA.csr -out ACCA\ACCA.crt

REM -- Generate initial CRLs
CALL update_crls.cmd

REM -- Cleanup
DEL AICA\AICA.csr
DEL ACCA\ACCA.csr
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
