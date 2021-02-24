@ECHO OFF

ECHO Generating CRL for the Root CA (RCA)...
bin\openssl ca -config openssl.cfg -name ca_rca -gencrl -crlexts ext_crl_rca -out rca\rca.crl
ECHO.

ECHO Generating CRL for the Infrastructure CA (ICA)...
bin\openssl ca -config openssl.cfg -name ca_ica -gencrl -crlexts ext_crl_ica -out ica\ica.crl
ECHO.

ECHO Generating CRL for the Corporate CA (cca)...
bin\openssl ca -config openssl.cfg -name ca_cca -gencrl -crlexts ext_crl_cca -out cca\cca.crl
ECHO.

ECHO Copying files to wwwroot
MKDIR www
COPY /Y rca\rca.crt www
COPY /Y rca\rca.crl www
COPY /Y ica\ica.crt www
COPY /Y ica\ica.crl www
COPY /Y cca\cca.crt www
COPY /Y cca\cca.crl www