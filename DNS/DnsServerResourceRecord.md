# Get-DnsServerResourceRecord

---

## Acronym
1. PTR - PoinTer Record

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
