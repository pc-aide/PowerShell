# Member of User (AD) 

Function Get-MemberAD{ 

# Switch UserName 

param([parameter(Mandatory=$true)] [String]$UserName) 

(New-Object System.DirectoryServices.DirectorySearcher("(&(objectCategory=User)(samAccountName=$($UserName)))")).FindOne().GetDirectoryEntry().memberOf 

} 
