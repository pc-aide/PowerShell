function Get-Wallpaper {
    param (
        [Parameter(Mandatory=$false)]
        [switch]$Swap
    )

    # Les noms de GPO statiques
    $GpoNames = @("wallpaper_Std", "wwallpaper_Std_2","Wallpaper_Dev","Wallpaper_Dev_2")

    foreach ($GpoName in $GpoNames) {
        # Récupérer tous les GPOs
        $AllGpos = Get-GPO -All

        # Recherche du GPO spécifié
        $TargetGpo = $AllGpos | Where-Object { $_.DisplayName -eq $GpoName }

        if ($TargetGpo) {
            $OUs = Get-ADOrganizationalUnit -Filter *
            $GpoFound = $false
            foreach ($OU in $OUs) {
                $GpoLinks = Get-GPInheritance -Target $OU.DistinguishedName | Select-Object -ExpandProperty GpoLinks
                $TargetGpoLink = $GpoLinks | Where-Object { $_.GpoId.Guid -eq $TargetGpo.Id.Guid }

                if ($TargetGpoLink) {
                    $GpoFound = $true
                    if ($Swap) {
                        if ($TargetGpoLink.Enabled -eq [Microsoft.GroupPolicy.EnableLink]::Yes) {
                            Set-GPLink -Guid $TargetGpoLink.GpoId.Guid -Target $OU.DistinguishedName -LinkEnabled "No" | Out-Null
                            $Status = "Disabled"
                        } else {
                            Set-GPLink -Guid $TargetGpoLink.GpoId.Guid -Target $OU.DistinguishedName -LinkEnabled "Yes" | Out-Null
                            $Status = "Enabled"
                        }
                    } else {
                        $Status = if ($TargetGpoLink.Enabled -eq [Microsoft.GroupPolicy.EnableLink]::Yes) { "Enabled" } else { "Disabled" }
                    }
                    $outputObject = [PSCustomObject]@{
                        GPOName      = $TargetGpo.DisplayName
                        Path         = $OU.DistinguishedName
                        LinkEnabled  = $Status
                    }
                    Write-Output $outputObject | Format-List
                }
            }

            if (-not $GpoFound) {
                Write-Output "GPO Link not found for the specified GPO."
            }
        } else {
            Write-Output "Specified GPO not found."
        }
    }
}

# Utilisation de la fonction Get-Wallpaper
Get-Wallpaper -Swap
