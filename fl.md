# fl

---

## Alias
1. fl - format-list

---

## 
````ps1
ls "\\tst23212\C$\Users\cestar02\AppData\Local\Microsoft\Outlook" |
 fl mode,lastWriteTime,name,
 @{n="Size(GB)";e={[math]::round($_.Length*1MB/1GB,4)}}
````
