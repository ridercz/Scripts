@ECHO OFF

ECHO Generating CRL for the Altairis Root CA (ARCA)...
bin\openssl ca -config ARCA.cfg -gencrl -crlexts ext_crl -out ARCA\ARCA.crl
ECHO.

ECHO Generating CRL for the Altairis Infrastructure CA (AICA)...
bin\openssl ca -config AICA.cfg -gencrl -crlexts ext_crl -out AICA\AICA.crl
ECHO.

ECHO Generating CRL for the Altairis Corporate CA (ACCA)...
bin\openssl ca -config ACCA.cfg -gencrl -crlexts ext_crl -out ACCA\ACCA.crl
ECHO.

ECHO Copying files to wwwroot
COPY /Y ARCA\ARCA.crt D:\WWW-Servers\LocalUser\ca\ca.altairis.cz\files
COPY /Y ARCA\ARCA.crl D:\WWW-Servers\LocalUser\ca\ca.altairis.cz\files
COPY /Y AICA\AICA.crt D:\WWW-Servers\LocalUser\ca\ca.altairis.cz\files
COPY /Y AICA\AICA.crl D:\WWW-Servers\LocalUser\ca\ca.altairis.cz\files
COPY /Y ACCA\ACCA.crt D:\WWW-Servers\LocalUser\ca\ca.altairis.cz\files
COPY /Y ACCA\ACCA.crl D:\WWW-Servers\LocalUser\ca\ca.altairis.cz\files