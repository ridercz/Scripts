Certificate authority suite
---------------------------

To setup, run _setup.cmd.

To revoke certificate, use:

bin\openssl ca -config [AxCA.cfg] -revoke [certfile.crt] -crl_reason [unspecified, keyCompromise, CACompromise, affiliationChanged, superseded, cessationOfOperation, certificateHold]

To request SAN certificate:
bin\openssl genrsa -out mustang.key 2048
bin\openssl req -config AICA.cfg -new -sha256 -key mustang.key -out mustang.csr -subj "/CN=mustang.letna.corp.altairis.cz/O=Altairis, s. r. o./OU=Network Operations Center/C=CZ/emailAddress=hostmaster@altairis.cz/subjectAltName=DNS.1=stage-1.mx.altairis.cz,DNS.2=stage-1.app.altairis.cz"
