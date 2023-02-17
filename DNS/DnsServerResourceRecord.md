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

---

## Remove
|n|name|e.g.|O/P|
|-|----|----|---|
|1|DNS |Remove-DnsServerResourceRecord -ZoneName mtq.local -ComputerName A01DNS0001 -Name T01ASR0002 -RRType A -Force||
|2|DNS & PTR|$node = get-DnsServerResourceRecord -ZoneName srt.local -ComputerName DNS01 -Name TAR1<br/>Remove-DnsServerResourceRecord -ZoneName srt.local -ComputerName DNS01 -InputObject $Node -Force
