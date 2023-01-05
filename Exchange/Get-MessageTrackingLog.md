# Get-MessageTrackingLog

---

## Requirement
````ps1
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
````

---

## Get
|n|name|e.g.|O/P|
|-|----|----|---|
|1|Recipients|Get-MessageTrackingLog -Start (Get-Date).AddHours(-1) -ResultSize Unlimited \|<br/> ? {$_.recipients -like "*gmail.com"}||
|2|Sender|Get-MessageTrackingLog -Sender Alan.Reid@exchangeserverpro.net -Recipients alex.heyne@exchangeserverpro.net||
|3|All exchanges|$list_exch = get-TransportServer<br/><br/>foreach ($exch in $list_exch){<br/>&ensp;get-MessageTrackingLog -Sender "samme@hotmail.com" -Recipients "tax@.mxt.com" -ResultSize unlimited –server $exch.name<br/>}|
