# adUser

---

## URL
1. [adminCout = 1 & reset pwd AAD\User issue](https://appds.uk/blog/azure-ad-user-password-reset-issues)

---

## Get
|n|name|e.g.|O/P|
|-|----|----|---|
|1|adminCount|# optional : -SearchBase <br/>get-aduser -Filter {admincount -eq 0} -Properties adminCount -ResultSetSize $null \|<br/> fl adminCount,distinguishedName,UserPrincipalName|
|2|accountExpires|get-aduser maxtar04 -Properties * \|<br/>fl name,<br/>@{n='accountExpires';e={[datetime]::FromFileTime($_."accountExpires")}}|name : max tarte<br/>accountExpires: 12-04-21 00:00:00|

---

## Set
|n|name|e.g.|O/P|
|-|----|----|---|
|1|adminCount=0| get-ADUser $user -Properties adminCount \|<br/> set-adObject -Replace @{adminCount=0}|
