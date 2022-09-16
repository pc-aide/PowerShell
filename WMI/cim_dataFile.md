# cim_dataFile

---

## List
|n|name|eg|O/P|
|-|----|--|---|
|1|fileSize|# psComputerName (aliasProperty)<br/>gwmi cim_dataFile -filter "drive='d:' and path='\\\vDisk\\\' and fileName like '%std_09_2022%'" -computer cps01 \| <br/> select fileName,FileSieze,psComputerName|[<img src="https://i.imgur.com/BphsVV6.png">](https://i.imgur.com/BphsVV6.png)|
