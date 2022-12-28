# LogicalDisk

---

## DeviceID
1. Unknown : 0
2. No Root Directory : 1
3. Removable Disk : 2
4. Local Disk : 3
5. Network Drive : 4
6. Compact Disc : 5
7. RAM Disk : 6

---

## Properties
|n|name|e.g.|O/P|
|-|----|----|---|
|1|default|gwmi win32_logicalDisk \|<br/>fl DeviceID,DriveType,VolumeName,<br/>@{n="FreeSpace(GB)";e={"{0:N2}" -f ($_.FreeSpace/1GB)}}|DeviceID      : C:<br/>DriveType     : 3<br/>VolumeName    :<br/>FreeSpace(GB) : 202.28||
