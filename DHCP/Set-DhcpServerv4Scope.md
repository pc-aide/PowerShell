# Set-DhcpServerv4Scope

---

## List
|n|name|e.g.|O/P|
|-|----|----|----|


$list_ScopeID | % { Set-DhcpServerv4Scope -ScopeId $_ -State Active -ComputerName DHCP01}
