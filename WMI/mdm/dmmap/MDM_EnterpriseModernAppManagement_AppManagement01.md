# MDM_EnterpriseModernAppManagement_AppManagement01

---

## doc
1. [How to force update of Windows Store Apps without launching the Store App?](https://social.technet.microsoft.com/Forums/windows/en-US/5ac7daa9-54e6-43c0-9746-293dcb8ef2ec/how-to-force-update-of-windows-store-apps-without-launching-the-store-app?forum=win10itprosetup)

---

##
````ps1
$namespaceName = "root\cimv2\mdm\dmmap"
$className = "MDM_EnterpriseModernAppManagement_AppManagement01"
$wmiObj = Get-WmiObject -Namespace $namespaceName -Class $className
$result = $wmiObj.UpdateScanMethod()

# Start update Windows Store
$result
````
