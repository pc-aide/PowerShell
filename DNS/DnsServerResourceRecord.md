# DnsServerResourceRecord

---

## Acronym
1. PTR - PoinTer Record

---

## Add
|n|name|e.g.|O/P|
|-|----|----|---|
|1|A   |Add-DnsServerResourceRecord -ZoneName "moskva.local" -A -Name "rapToc" -IPv4Address "10.46.0.32" -CreatePtr -ComputerName DNS01||

---

## Get
|n|name|e.g.|O/P|
|-|----|----|---|
|1|PTR | Get-DnsServerResourceRecord -ZoneName 10.in-addr.arpa -ComputerName T04DNS0023 -RRType Ptr \|<br/> ?{$_.RecordData.PtrDomainName -like '*L01FIL0001*'} \|<br/>select hostname,RecordType -ExpandProperty RecordData \|<br/>fl hostname,RecordType,PtrDomainName||
|2|DNS|$lst_DNS \| % {Get-DnsServerResourceRecord -ZoneName MTL.local -ComputerName T04DNS0023 -Name $_ \|<br/>select hostname,recordType -ExpandProperty recordData \|<br/>fl hostname,recordtype,IPv4Address}||
|3|%|$computerNames = @("pc01", "pc02", "pc03")<br/><br/>$computerNames \| % {<br/>&ensp;$computerName = $\_<br/>&ensp;Get-DnsServerResourceRecord -ZoneName 10.in-addr.arpa -ComputerName DNS01 -RRType Ptr \|<br/>&ensp;? {$_.RecordData.PtrDomainName -like "*$computerName*"} \|<br/>&ensp;select hostname, RecordType -ExpandProperty RecordData \|<br/>&ensp;fl hostname, RecordType, PtrDomainName<br/>}|

---

## Remove
|n|name|e.g.|O/P|
|-|----|----|---|
|1|DNS |Remove-DnsServerResourceRecord -ZoneName mtq.local -ComputerName A01DNS0001 -Name T01ASR0002 -RRType A -Force||
|2|DNS & PTR|$node = get-DnsServerResourceRecord -ZoneName srt.local -ComputerName DNS01 -Name TAR1<br/>Remove-DnsServerResourceRecord -ZoneName srt.local -ComputerName DNS01 -InputObject $Node -Force
|3|PTR|# name = IP<br/>Remove-DnsServerResourceRecord -ZoneName 10.in-addr.arpa -RRType "PTR" -ComputerName DNS01 -Name "131.102.90" -Force|
