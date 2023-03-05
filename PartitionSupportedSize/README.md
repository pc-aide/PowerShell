# PartitionSupportedSize

---

## Extend volume
|n|name|eg|O/P|
|-|----|--|---|
|1|add 126GB in C|$drive_letter = "C"<br/><br/>$size = (Get-PartitionSupportedSize -DriveLetter $drive_letter)<br/>Resize-Partition -DriveLetter $drive_letter -Size $size.SizeMax|[<img src="https://i.imgur.com/GqLF9Hw.png">](https://i.imgur.com/GqLF9Hw.png)|
