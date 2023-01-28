# Get-IntuneManagedDevice

---

## new cmdLet
````ps1
# Module
Install-Module microsoft.graph.intune -Force

# Login graph
Connect-MSGraph

# Optional
connect-azureAD
````

---

## List
|n|name|e.g.|O/P|
|-|----|----|---|
|1|Get-IntuneManagedDevice \| <br/> Get-MSGraphAllPages \| <br/> ?{$_.deviceName -eq "ebm23321"} \| <br/> fl userId,managedDeviceOwnerType,lastSyncDateTime,complianceState,userPrincipalName,complianceGracePeriodExpirationDateTime,serialNumber,manufacturer||
|2|Device + UPN|$list_AADGroupMember = (Get-AzureADGroupMember -ObjectId "c72c7b18-c270-4ed3-b376-5c68d874c83e" -All $true).DisplayName<br/><br/>foreach ($list_deviceIntune in $list_AADGroupMember){<br/>&ensp;Get-IntuneManagedDevice \| Get-MSGraphAllPages \| ?{$_.deviceName -eq $list_deviceIntune } \|<br/>&ensp;select deviceName,UserPrincipalName<br/>}|

---

## Out
|n|name|e.g.|O/P|
|-|----|----|---|
|1|id = ObjectId (AAD) & azureADDeviceId = RefObjectId (AAD)   |# Out, it's the properties for O/P<br/> Get-IntuneManagedDevice \| Get-MSGraphAllPages \| ?{$_.deviceName -eq "TZVP18RZTW"} \|<br/>select id,azureADDeviceId|
