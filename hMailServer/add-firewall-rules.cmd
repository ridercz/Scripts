@ECHO OFF

REM -- Enable e-mail related protocols for hMailServer in Windows Firewall
netsh advfirewall firewall add rule name="hMailServer SMTP-025" program="C:\Program Files (x86)\hMailServer\Bin\hMailServer.exe" dir=in action=allow protocol=TCP localport=025
netsh advfirewall firewall add rule name="hMailServer POP3-110" program="C:\Program Files (x86)\hMailServer\Bin\hMailServer.exe" dir=in action=allow protocol=TCP localport=110
netsh advfirewall firewall add rule name="hMailServer IMAP-143" program="C:\Program Files (x86)\hMailServer\Bin\hMailServer.exe" dir=in action=allow protocol=TCP localport=143
netsh advfirewall firewall add rule name="hMailServer SMTP-587" program="C:\Program Files (x86)\hMailServer\Bin\hMailServer.exe" dir=in action=allow protocol=TCP localport=587
