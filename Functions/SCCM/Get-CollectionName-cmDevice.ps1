# CollectionName for cmDevice 

Function Get-CollectionName-cmDevice { 

  # Switch Hostname 
  param([parameter(Mandatory=$true)] [String]$HostName) 

  # ComputerName : <FQDN_SCCM> & root/SMS/site_<3_charactes_of_SCCM>
  (Get-WmiObject -ComputerName <FQDN_SCCM>  -Namespace root/SMS/site_<3_charactes_of_SCCM> ` 

  -Query "SELECT SMS_Collection.* FROM SMS_FullCollectionMembership, 

  SMS_Collection where name = '$HostName' 

  and SMS_FullCollectionMembership.CollectionID = SMS_Collection.CollectionID").Name 

} 
