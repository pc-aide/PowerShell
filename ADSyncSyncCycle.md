# ADSyncSyncCycle

---

## Requirement
````ps1
Install-Module ADSync -Force
````

---

## List
|n|name|e.g.|O/P|
|-|----|----|---|
|1|Basic|Start-ADSyncSyncCycle -PolicyType Delta<br/><br/>get-ADSyncScheduler \|<br/>fl NextSyncCycleStartTimeInUTC,NextSyncCyclePolicyType,SyncCycleInProgress||
