# HardDisk.md

---

## Requirement
1. PS ver 6.x or higher

---

## Connect
````ps1
# Pass-through
Connect-VIServer -Server vce01
````

---

## Get
|n|name|e.g.|O/P|
|-|----|----|---|
|1|default|Get-HardDisk sql01 \|<br/>?{$\_.capacityGB -like "*130*" -or $_.capacityGB -like "*550*"} \|<br/>fl name,capacityGB,fileName|
