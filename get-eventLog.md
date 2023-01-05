# get-eventLog

---

## Security
|n|name|e.g.|O/P|
|-|----|----|---|
|1|newUser|get-adDomain \|<br/> select -expandProperty ReplicaDirectoryServers<br/><br/>get-eventLog -logname security -computer DC01 \|<br/> ?{$_.eventId -eq 4720} \|<br/> select -property *

````ps1
$DCs = Get-ADDomainController -Filter *

$dcs.name
````
