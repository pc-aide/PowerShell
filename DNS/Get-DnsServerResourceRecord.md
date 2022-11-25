# Get-DnsServerResourceRecord

---

## List
|n|name|e.g.|O/P|
|-|----|----|---|
|1|PTR | Get-DnsServerResourceRecord -ZoneName 10.in-addr.arpa -ComputerName T04DNS0023 -RRType Ptr \|<br/> ?{$_.RecordData.PtrDomainName -like '*L01FIC0001*'} \|<br/>select hostname,RecordType -ExpandProperty RecordData \|<br/>fl hostname,RecordType,PtrDomainName||


$lst_DNS | % {Get-DnsServerResourceRecord -ZoneName MTL.local -ComputerName T04DNS0023 -Name $_ |
select hostname,recordType -ExpandProperty recordData |
fl hostname,recordtype,IPv4Address}
