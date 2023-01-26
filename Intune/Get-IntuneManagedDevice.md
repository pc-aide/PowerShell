# Get-IntuneManagedDevice

---

## new cmdLet
````ps1
# psVersion 5.x
# not work 7.x

# Module
Install-Module microsoft.graph.intune -Force

# Login graph
Connect-MSGraph

# login AAD
connect-azureAD
````

---

## List
|n|name|e.g.|O/P|
|-|----|----|---|
|1|Get-IntuneManagedDevice \| <br/> Get-MSGraphAllPages \| <br/> ?{$_.deviceName -eq "ebm23321"} \| <br/> fl userId,managedDeviceOwnerType,lastSyncDateTime,complianceState,userPrincipalName,complianceGracePeriodExpirationDateTime,serialNumber,manufacturer||
|2|Device + UPN|$list_AADGroupMember = (Get-AzureADGroupMember -ObjectId "c72c7b18-c270-4ed3-b376-5c68d874c83e" -All $true).DisplayName<br/><br/>foreach ($list_deviceIntune in $list_AADGroupMember){<br/>&ensp;Get-IntuneManagedDevice \| Get-MSGraphAllPages \| ?{$_.deviceName -eq $list_deviceIntune } \|<br/>&ensp;select deviceName,UserPrincipalName<br/>}|
