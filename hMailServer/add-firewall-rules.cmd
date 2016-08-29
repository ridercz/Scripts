@ECHO OFF

REM -- Enable e-mail related protocols for hMailServer in Windows Firewall
netsh advfirewall firewall add rule name="hMailServer SMTP" program="C:\Program Files (x86)\hMailServer\Bin\hMailServer.exe" service=hMailServer dir=in action=allow protocol=TCP localport=25
netsh advfirewall firewall add rule name="hMailServer POP3" program="C:\Program Files (x86)\hMailServer\Bin\hMailServer.exe" service=hMailServer dir=in action=allow protocol=TCP localport=110
netsh advfirewall firewall add rule name="hMailServer IMAP" program="C:\Program Files (x86)\hMailServer\Bin\hMailServer.exe" service=hMailServer dir=in action=allow protocol=TCP localport=143
netsh advfirewall firewall add rule name="hMailServer SMTP-587" program="C:\Program Files (x86)\hMailServer\Bin\hMailServer.exe" service=hMailServer dir=in action=allow protocol=TCP localport=587
