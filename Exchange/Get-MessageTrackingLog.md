# Get-MessageTrackingLog

---

## Get
|n|name|e.g.|O/P|
|-|----|----|---|
|1|Recipients|Get-MessageTrackingLog -Start (Get-Date).AddHours(-1) -ResultSize Unlimited \|<br/> ? {$_.recipients -like "*gmail.com"}||
|2|Sender|Get-MessageTrackingLog -Sender Alan.Reid@exchangeserverpro.net -Recipients alex.heyne@exchangeserverpro.net||
|3|all SRV exchanges|Get-TransportServer \|<br/>Get-MessageTrackingLog -Recipients samuel.brochu@intel.ca -sender samuelBrochu@yahoo.fr -EventId Fail -Start (get-date).AddHours(-12) -ResultSize unlimited \|<br/>fl||
