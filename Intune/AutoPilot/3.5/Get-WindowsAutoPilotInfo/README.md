# Get-WindowsAutoPilotInfo

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

---

## ISOUSB22h2
1. create new ISO USB 22h2 Windows install
2. in new ISO
3. Create a folder AutoPilot
4. go to the new folder
5. autoPilot.cmd
````cmd
c:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe -executionPolicy bypass -command c:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -Command d:\scripts\Get-WindowsAutoPilotInfo.ps1 -Online -TenantId <tenantId> -appid <appId> -appSecret <appSecret>
````
6. [Get-WindowsAutoPilotInfo.ps1](https://github.com/pc-aide/PowerShell/blob/main/Intune/AutoPilot/3.5/Get-WindowsAutoPilotInfo/Get-WindowsAutoPilotInfo.ps1)

[<img src="https://i.imgur.com/Podf465.png">](https://i.imgur.com/Podf465.png)
