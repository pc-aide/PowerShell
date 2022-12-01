# Get-DnsServerResourceRecord

---

## Acronym
1. PTR - PoinTer Record

---

## List
|n|name|e.g.|O/P|
|-|----|----|---|
|1|PTR | Get-DnsServerResourceRecord -ZoneName 10.in-addr.arpa -ComputerName T04DNS0023 -RRType Ptr \|<br/> ?{$_.RecordData.PtrDomainName -like '*L01FIL0001*'} \|<br/>select hostname,RecordType -ExpandProperty RecordData \|<br/>fl hostname,RecordType,PtrDomainName||
|2|DNS|$lst_DNS \| % {Get-DnsServerResourceRecord -ZoneName MTL.local -ComputerName T04DNS0023 -Name $_ \|<br/>select hostname,recordType -ExpandProperty recordData \|<br/>fl hostname,recordtype,IPv4Address}||
