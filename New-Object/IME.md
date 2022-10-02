# IME

---

## Acronym
1. IME - Intune Management Extension

---

## URL
1. [Triggering Intune Management Extension (IME) Sync](https://oliverkieselbach.com/2020/11/03/triggering-intune-management-extension-ime-sync/)

---

## Trigger
|n|name|e.g.|O/P|
|-|----|----|---|
|1|syncApp|# %ProgramData%\Microsoft\IntuneManagementExtension\Logs\IntuneManagementExtension.log\ <br/> `$Shell = New-Object -ComObject Shell.Application` <br/> `$Shell.open("intunemanagementextension://syncapp")`|[<img src="https://i.imgur.com/RghuRaI.png">](https://i.imgur.com/RghuRaI.png) <br/> # eventViewer\Apps&ServicesLogs\Windows\DeviceManagment-Enterprise-Diagnostics-Provider\Operational <br/> [<img src="https://i.imgur.com/7O88TQL.png">](https://i.imgur.com/7O88TQL.png)|
