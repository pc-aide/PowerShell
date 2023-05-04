function Get-RecordsDNS {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Hostname,

        [Parameter(Mandatory=$false)]
        [string]$NewIPv4Address
    )

    $ForwardLookupZone = "mtl.local"
    $ServerName = "DNS01"
    $PTRZoneName = "10.in-addr.arpa"

    if ($NewIPv4Address) {
        $ExistingRecord = Get-DnsServerResourceRecord -ZoneName $ForwardLookupZone -ComputerName $ServerName -RRType A |
                          Where-Object { $_.RecordData.IPv4Address -eq $NewIPv4Address }

        if ($ExistingRecord) {
            Write-Host "The provided IPv4 address is already in use by another machine. Update aborted." -ForegroundColor Yellow
            return
        }

        # Récupérer l'enregistrement "A" existant
        $ARecord = Get-DnsServerResourceRecord -ZoneName $ForwardLookupZone -ComputerName $ServerName -Name $Hostname -RRType A

        # Cloner le CIM instance de l'enregistrement "A" existant
        $NewARecord = [Microsoft.Management.Infrastructure.CimInstance]::new($ARecord)

        # Mettre à jour la propriété "IPv4Address" du nouveau CIM instance avec la nouvelle adresse IP
        $NewARecord.CimInstanceProperties['RecordData'].Value.'IPv4Address' = $NewIPv4Address

        # Mettre à jour l'enregistrement "A" avec la nouvelle CIM instance
        Set-DnsServerResourceRecord -ZoneName $ForwardLookupZone -ComputerName $ServerName -OldInputObject $ARecord -NewInputObject $NewARecord
    }

    $ARecord = Get-DnsServerResourceRecord -ZoneName $ForwardLookupZone -ComputerName $ServerName -Name $Hostname |
                Select-Object hostname, recordType -ExpandProperty recordData

    $IPv4Address = ($ARecord | Where-Object { $_.recordType -eq 'A' }).IPv4Address
    $ReverseIP = ($IPv4Address -split '\.')[-1..-4] -join '.'
    
    $PTRRecord = Get-DnsServerResourceRecord -ZoneName $PTRZoneName -ComputerName $ServerName -RRType Ptr |
                 Where-Object { $_.RecordData.PtrDomainName -like "*$Hostname*" } |
                 Select-Object hostname, RecordType -ExpandProperty RecordData -ErrorAction SilentlyContinue

    $Output = @{
    ARecord = @{
        Hostname = $ARecord.hostname
        RecordType = $ARecord.recordType
        IPv4Address = $IPv4Address
    }
    PTRRecord = @{
        Hostname = if ($PTRRecord) { $PTRRecord.hostname } else { '' }
        RecordType = if ($PTRRecord) { $PTRRecord.RecordType } else { '' }
        PtrDomainName = if ($PTRRecord) { $PTRRecord.PtrDomainName } else { "No PTR record found for $Hostname" }
    }
}


    $Output.ARecord
    Write-Output "`n" # Add an empty line
    $Output.PTRRecord
}
