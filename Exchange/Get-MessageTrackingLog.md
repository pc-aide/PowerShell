# Get-MessageTrackingLog

---

## List
|n|name|e.g.|O/P|
|-|----|----|---|
|1|Recipients|Get-MessageTrackingLog -Start (Get-Date).AddHours(-1) -ResultSize Unlimited \|<br/> ? {$_.recipients -like "*gmail.com"}||
|2|Sender|Get-MessageTrackingLog -Sender Alan.Reid@exchangeserverpro.net -Recipients alex.heyne@exchangeserverpro.net||
