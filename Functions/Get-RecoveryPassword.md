# Get-RecoveryPassword.ps1

## Intro
* get the clef of BitLocker for computer

## Function
````powershell
Function get-RecoveryPassword{
    #Switch ADComputer
    param([parameter(Mandatory=$true)] [String]$ADComputer)
    
    $DN = Get-ADComputer $ADComputer | Select-Object -ExpandProperty DistinguishedName

    $ADobj = get-adobject -Filter {objectclass -eq 'msFVE-RecoveryInformation'} -SearchBase $DN -Properties 'msFVE-RecoveryPassword' | Select-Object Name,msFVE-RecoveryPassword

    [Ordered]@{

    Computer = $ADComputer
    RecoveryPassword = $ADobj.'msFVE-RecoveryPassword'
    Date = Get-Date -Date ($ADobj.Name ).Split('{')[0]
    BitlocerKeyID = (($ADobj.Name ).Split('{')[1]).TrimEnd('}')

    }
}
````
