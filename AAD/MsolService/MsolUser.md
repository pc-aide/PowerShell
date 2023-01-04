
## Requirement
````ps1
# Module
Install-Module MSOnline -Force

# Connect
Connect-MsolService
````

---

## List
|n|name|e.g.|O/P|
|-|----|----|---|
|1|UPN |Get-MsolUser -UserPrincipalName "Max.Tarte@utr.com"||
