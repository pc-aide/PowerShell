function Get-RecordsDNS {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Hostname
    )

    $DomainName = "mtl.local"
    $ServerName = "DNS01"
    $Output = @{}

    try {
        $ARecord = Get-DnsServerResourceRecord -ZoneName $DomainName -ComputerName $ServerName -Name $Hostname -ErrorAction Stop |
                    Select-Object hostname, recordType -ExpandProperty recordData

        $IPv4Address = ($ARecord | Where-Object { $_.recordType -eq 'A' }).IPv4Address

        $Output += @{
            ARecord = @{
                Hostname = $ARecord.hostname
                RecordType = $ARecord.recordType
                IPv4Address = $IPv4Address
            }
        }
    }
    catch {
        Write-Output "Failed to get A record."
    }
    
    $ReverseIP = ($Hostname -split '\.')[-1..-4] -join '.'
    $PTRZoneName = "10.in-addr.arpa"

    $PTRRecord = Get-DnsServerResourceRecord -ZoneName $PTRZoneName -ComputerName $ServerName -RRType Ptr |
                 Where-Object { $_.RecordData.PtrDomainName -like "*$Hostname*" } |
                 Select-Object hostname, RecordType -ExpandProperty RecordData

    if ($PTRRecord) {
        $Output += @{
            PTRRecord = @{
                Hostname = $PTRRecord.hostname
                RecordType = $PTRRecord.RecordType
                PtrDomainName = $PTRRecord.PtrDomainName
            }
        }
    }
    else {
        Write-Output "No PTR record found."
    }

    if ($Output.ARecord) {
        $Output.ARecord
        Write-Output "`n" # Add an empty line
    }
    
    if ($Output.PTRRecord) {
        $Output.PTRRecord
    }
}
