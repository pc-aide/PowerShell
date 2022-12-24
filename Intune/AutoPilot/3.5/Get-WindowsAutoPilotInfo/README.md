# Get-WindowsAutoPilotInfo

---

## Requirement
1. Enroll Device Intune AutoPilot, need cable ethernet


---

## Doc
1. [Get-WindowsAutoPilotInfo-powershellGallery](https://www.powershellgallery.com/packages/Get-WindowsAutoPilotInfo/3.5)
2. [Upload Windows Autopilot hardware hash easily](https://powershellisfun.com/2022/07/09/upload-windows-autopilot-hardware-hash/)

---

## App Registrations
1. AAD\app registrations\New
2. Name : EnrollDevicesAutoPilot
3. Supproted account types : Accounts in this organizational directory only (<tenantName> only - Single tenant) 
4. Register
5. Overview\Application (client) ID take it in the clipboard
6. API permissions
7. Add a permission : Microsoft Graph
8. What type of permissions does your application require : Application permissions
9. Select permissions : DeviceManagementServiceConfig.ReadWrite.All
10. Add permissions
11. Grant admin consent for it
12. Certificate & secrets\New client secret
13 Add a client secret\Description : EnrollDevicesAutoPilot
14. Expire : 12 months
15. clipboard : the value 
16. optional - test your new cred
````ps1
Import-Module Microsoft.Graph.Intune
Import-Module WindowsAutopilotIntune

$tenant = “string.onmicrosoft.com"
$authority = “https://login.windows.net/$tenant"
# AAD\app registrations\<yourAppReg>\Overview\Application (client) ID
$clientId = “clientId"
# # AAD\app registrations\<yourAppReg>\cert & secrets\<Value>
$clientSecret = “clientSecret"

Update-MSGraphEnvironment -AppId $clientId -Quiet
Update-MSGraphEnvironment -AuthUrl $authority -Quiet
Connect-MSGraph -ClientSecret $ClientSecret -Quiet

Get-AutopilotDevice
````

---

## ISOUSB22h2
1. create new ISO USB 22h2 Windows install
2. in new ISO
3. Create a folder AutoPilot
4. go to the new folder
5. autoPilot.cmd
````cmd
C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -Command d:\scripts\autoPilot.ps1
````
6. autoPilot.ps1
````
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Confirm:$false -Force:$true
PowerShell -ExecutionPolicy Bypass -File d:\autoPilot\Get-WindowsAutoPilotInfo.ps1 `
  -Online -TenantId <tenantId> -appId <appId> -appSecret <appSecret> -AssignedComputerName "$("TV"+(gwmi win32_bios).serialNumber)"
Restart-Computer -Force
````
7. [Get-WindowsAutoPilotInfo.ps1](https://github.com/pc-aide/PowerShell/blob/main/Intune/AutoPilot/3.5/Get-WindowsAutoPilotInfo/Get-WindowsAutoPilotInfo.ps1)



---

## Test
### Boot USB
1. Clear all disks

[<img src="https://i.imgur.com/IOTsSLh.png">](https://i.imgur.com/IOTsSLh.png)

2. Next after delete all drive
3. Installing Windows 

[<img src="https://i.imgur.com/MPdXWAz.png">](https://i.imgur.com/MPdXWAz.png)

4. after reboot
5. getting ready
6. just a moment ...

----

### Lets start with region. is this right ?
1. start cmd (shift + F10)
2. go to the USB\autoPilot\
3. autoPilot.cmd # Time ~5m
  
---
  
### set up for an organization
1. set up for an organization
  
---
  
## Windows Autopilot devices
  
[<img src="https://i.imgur.com/iTxCBQ7.png">](https://i.imgur.com/iTxCBQ7.png)
