# MsolDevice

---

## Req
````ps1
Install-Module MSOnline -Force

Connect-MsolService
````

---

## get
|n|name|e.g.|O/P|
|-|----|----|---|
|1|all (Iphone, device, android, etc) |Get-MsolDevice -All||
|2|device intune|Get-MsolDevice -RegisteredOwnerUpn "akira.yaller@zamour.jap" \|<br/>?{$_.DeviceOsType -ne "android"} \|<br/>fl displayName,DeviceOsType,ApproximateLastLogonTimestamp,DeviceTrustLevel|
