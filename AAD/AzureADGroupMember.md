# AzureADGroupMember

---

## Requirement
````ps1
# Module
Import-Module AzureAD -Force

# Connect
Connect-AzureAD
````

---

## Get

---

## Add


```ps1
# all members in a group
Get-AzureADGroupMember -ObjectId <string> -all $true |
select ObjectId,ObjectId

$Devices = Import-Csv $env:list_deviceID.txt -Delimiter ";"

# ObjectId = adGroup
# RefObjectId  = DeviceId
foreach ($Device in $devices){
 Add-AzureADGroupMember -ObjectId "<string>" -RefObjectId $Device.ObjectId
}
````
