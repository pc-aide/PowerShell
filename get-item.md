# get-item

---

## List
|n|name|e.g.|O/P|
|-|----|----|---|
|1|in GB|$fileName = d:\ps\csv\powershell-eventLogs.csv <br/>(get-item -path $fileName).length/1GB||
|2|format|get-item .\pcbesetup.exe \|<br/> select @{n='Size(MB)';e={"{0:F2}"-f($_.Length/1mb)}}||
