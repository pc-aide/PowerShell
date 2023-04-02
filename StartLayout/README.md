# StartLayout

---

## default
[<img src="https://i.imgur.com/qhLKlPY.png">](https://i.imgur.com/qhLKlPY.png)


---

## Test
1. Customize Start Menu
2. `Export-StartLayout c:\temp\LayoutModification.xml`
3. `Copy-item c:\temp\LayoutModification.xml -destination "c:\Users\Default\AppData\Local\Microsoft\Windows\Shell -Force"`
4. `Import-StartLayout -LayoutPath "C:\temp\LayoutModification.xml" -MountPath "$($env:SystemDrive)\"`
5. log on with different user
