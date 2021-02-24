@ECHO OFF

IF "%1"=="" (
    ECHO This script will create new server certificate and private key from
    ECHO scratch and save it to 'newfile.crt' and 'newfile.pfx'.
    ECHO.
    ECHO USAGE: create_server newfile
    EXIT /B
)

REM -- Generate 2048-bit private key
bin\openssl genrsa -out %1.key 2048

REM -- Generate certificate signing request
bin\openssl req -config openssl.cfg -new -sha256 -key %1.key -out %1.csr

REM -- Sign it with Infrastructure CA
bin\openssl ca -config openssl.cfg -name ca_ica -batch -notext -extensions ext_server -days 365 -in %1.csr -out %1.crt

REM -- Convert PEM private key to PFX
bin\openssl pkcs12 -export -password pass: -inkey %1.key -in %1.crt -out %1.pfx

REM -- Cleanup
DEL %1.key
