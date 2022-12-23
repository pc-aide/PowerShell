# Get-IntuneManagedDevice

---

## new cmdLet
````ps1
# psVersion 5.x
# not work 7.x

# Module
Install-Module microsoft.graph.intune -Force

# Login
Connect-MSGraph
````

---

## List
|n|name|e.g.|O/P|
|-|----|----|---|
|1|Get-IntuneManagedDevice \| <br/> Get-MSGraphAllPages \| <br/> ?{$_.deviceName -eq "ebm23321"} \| <br/> fl userId,managedDeviceOwnerType,lastSyncDateTime,complianceState,userPrincipalName,complianceGracePeriodExpirationDateTime,serialNumber,manufacturer||
