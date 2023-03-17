# SCCM

---

## Requirement
````ps1
 get-psDrive |
 ?{$_.Provider -like '*cmSite*'} |
 fl name,provider,root


Name     : PRI
Provider : AdminUI.PS\CMSite
Root     : SCCM01.MTL.local

# Change location (SiteCode = PRI:\)
Set-Location PRI:\
````
