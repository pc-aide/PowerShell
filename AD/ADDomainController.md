# ADDomainController

---

## Doc
1. [getting-ad-accounts-created-in-the-last-24hs](https://woshub.com/getting-ad-accounts-created-in-the-last-24-hours/)

---

## ps1
````
$Report = @()
$time = (get-date) - (new-timespan -hour 24)
$AllDCs = Get-ADDomainController -Filter *
ForEach($DC in $AllDCs)
{
Get-WinEvent -ComputerName $dc.Name -FilterHashtable @{LogName="Security";ID=4720;StartTime=$Time}| Foreach {
$event = [xml]$_.ToXml()
if($event)
{
$Time = Get-Date $_.TimeCreated -UFormat "%Y-%m-%d %H:%M:%S"
$CreatorUser = $event.Event.EventData.Data[4]."#text"
$NewUser = $event.Event.EventData.Data[0]."#text"
$objReport = [PSCustomObject]@{
User = $NewUser
Creator = $CreatorUser
DC = $event.Event.System.computer
CreationDate = $Time
}
}
$Report += $objReport
}
}
$Report
````
