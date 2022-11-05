# get-VHD

---

## Requirement
1. hyper-V installed
2. Hyper-V-PowerShell ?

---

## List
|n|name|e.g.|O/P|
|-|----|----|---|
|1||Get-VHD "*.vhdx" \| <br/> fl vhdType,path, <br/> @{N='FileSize(GB)';E={$_.filesize/1gb -as [int]}}, <br/> @{N='Size(GB)';E={$_.size/1gb -as [int]}}
