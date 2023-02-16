# WindowsDriver

---

## FileRepository
|n|name|e.g.|O/P|
|-|----|----|---|
|1|all INFs|C:\Windows\System32\DriverStore\FileRepository||

---

## Get
### get-member -memberType properties
|n|name|e.g.|O/P|
|-|----|----|---|
|1|default|Driver (<name>.inf)<br/>OriginalFileName (installDir)<br/>Inbox (bool)<br/>className<br/>BootCritical (bool)<br/>ProviderName<br/>Date<br/>Version|

|n|name|e.g.|O/P|
|-|----|----|---|
|1|all INFs|Get-WindowsDriver -Online -All||
