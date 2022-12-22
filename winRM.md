# winRM

---

## Doc
1. [winrm-https-certificate-socail-tech-MS](https://social.technet.microsoft.com/Forums/en-US/232081d3-c275-4735-a426-e17469a76283/winrm-https-certificate)

---

## Get
|n|name|e.g.|O/P|
|-|----|----|---|
|1|Listener|winrm enumerate winrm/config/listener |Listener<br/>&ensp;Address = *<br/>&ensp;Transport = HTTP<br/>&ensp;Port = 5985<br/>&ensp;Hostname<br/>&ensp;Enabled = true<br/>&ensp;URLPrefix = wsman<br/>&ensp;CertificateThumbprint<br/>&ensp;ListeningOn = 10.46.0.7, 127.0.0.1, ::1<br/><br/>Listener<br/>&ensp;Address = *<br/>&ensp;Transport = HTTPS<br/>&ensp;Port = 5986<br/>&ensp;Hostname = PC01.moskva.loval<br/>&ensp;Enabled = true<br/>&ensp;URLPrefix = wsman<br/>&ensp;CertificateThumbprint = 41 a8 2q 8w 21 b0 d9 c1 96 21 66 ii 70 8f fc 02f6 01 53 ff<br/>&ensp;ListeningOn = 10.46.0.30, 127.0.0.1, ::1|
