# CollectionName for cmDevice 

Function Get-CollectionName-cmDevice { 

  # Switch Hostname 
  param([parameter(Mandatory=$true)] [String]$HostName) 

  (Get-WmiObject -ComputerName MMTRLPALPINF151.Prod.MJQ.Local  -Namespace root/SMS/site_mjq ` 

  -Query "SELECT SMS_Collection.* FROM SMS_FullCollectionMembership, 

  SMS_Collection where name = '$HostName' 

  and SMS_FullCollectionMembership.CollectionID = SMS_Collection.CollectionID").Name 

} 
