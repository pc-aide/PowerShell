# get-eventLog

---

## Security
|n|name|e.g.|O/P|
|-|----|----|---|
|1|newUser|get-adDomain \|<br/> select -expandProperty ReplicaDirectoryServers<br/><br/>get-eventLog -logname security -computer DC01 \|<br/> ?{$_.eventId -eq 4720} \|<br/> select -property *
|2|delete ADGroup|$DCs = Get-ADDomainController -Filter *<br/><br/>Foreach($DC in $DCs){<br/>&ensp;Get-EventLog -LogName security -ComputerName $DC.name \|<br/>&ensp;?{$_.eventId -eq 4726} \|<br/>&ensp;select -Property *<br/>}||
