Function get-CollectionName-cmDevice { 

  # Switch Hostname 
  param([parameter(Mandatory=$true)] [String]$HostName) 
  # ComputerName = FQDN of our sccM
  $ComputerName = "SCCM01.local"
  # Site = 3x characteres of our site
  $Site = "PRD"

(Get-WmiObject -ComputerName $ComputerName  -Namespace root/SMS/site_$Site `
    -Query "SELECT SMS_Collection.* FROM SMS_FullCollectionMembership,
    SMS_Collection where name = '$HostName' 
    and SMS_FullCollectionMembership.CollectionID = SMS_Collection.CollectionID").Name 
} 
