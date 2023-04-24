# Dernière modification par

# Définition de la variable de l'emplacement du script 
# [string]$ScriptPath = $MyInvocation.MyCommand.Path.Substring(0,$MyInvocation.MyCommand.Path.Length - $MyInvocation.MyCommand.Name.Length)
 
# Force l'exécution de ce script en tant qu'administrateur 
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# Bypass l'execution de script
Set-ExecutionPolicy -ExecutionPolicy Bypass -Force

$logPath = "C:\temp\error.txt"
# Chemin vers le fichier CitrixWorkspaceApp.exe
$installerPath = "C:\temp\CitrixWorkspaceApp.exe"

try
{
    # Détecter toutes les instances de Citrix Workspace
    $CitrixWorkspaceInstances = Get-WmiObject -Class Win32_Product -Filter "Name LIKE 'Citrix Workspace%'"

    if ($CitrixWorkspaceInstances) {
        Write-Host "Instances de Citrix Workspace détectées."

        # Supprimer toutes les instances de Citrix Workspace de manière silencieuse sans redémarrage
        foreach ($instance in $CitrixWorkspaceInstances) {
            $versionNumber = [version]$instance.Version
            $minimumVersion = [version]"2303.0.0"

            if ($versionNumber -lt $minimumVersion) {
                Write-Host "Suppression de $($instance.Name) version $($instance.Version)..."

                # Utiliser msiexec.exe pour désinstaller avec l'identifiant du produit
                $productCode = $instance.IdentifyingNumber
                Start-Process -FilePath "msiexec.exe" -ArgumentList "/x $productCode /qn /norestart" -Wait -NoNewWindow
                Start-Sleep -Seconds 5

                # Trouver le répertoire de TrolleyExpress.exe
                $trolleyExpressPath = Get-ChildItem -Path "C:\Program Files (x86)\Citrix" -Recurse -Filter "TrolleyExpress.exe" | Select-Object -ExpandProperty FullName -First 1

                if ($trolleyExpressPath) {
                    # Supprimer les fichiers associés en utilisant TrolleyExpress.exe
                    Start-Process -FilePath $trolleyExpressPath -ArgumentList "/silent /uninstall /cleanup" -Wait -NoNewWindow
                    Start-Sleep -Seconds 5
                }
            }
        }

        Write-Host "Suppression des instances de Citrix Workspace terminée."
    } else {
        Write-Host "Citrix Workspace non détecté."
    }
}
catch
 {
    $errorMessage = "Une erreur s'est produite : " + $_.Exception.Message
    Write-Host $errorMessage
    if (!(Test-Path $logPath)) {
        New-Item -ItemType File -Path $logPath -Force
    }
    Add-Content -Path $logPath -Value $errorMessage
}

# Installation Citrix Workspace App 2302
Try {
    Write-Host "Installation Citrix Workspace App 2302 en cours..." -ForegroundColor Yellow
    $installProcess = Start-Process -FilePath $installerPath -ArgumentList "/silent /noreboot /AutoUpdateCheck=disabled" -PassThru -ErrorAction Stop
    $installProcess.WaitForExit()
    if ($installProcess.ExitCode -eq 0) {
        Write-Host "L'installation s'est terminée avec succès." -ForegroundColor Green
    } else {
        Write-host "L'installation a échoué avec le code de sortie $($installProcess.ExitCode)." -ForegroundColor Red
    }
} Catch {
    Write-Host "Erreur lors de l'installation : $($_.Exception.Message)" -ForegroundColor Red
    $errorMessage = "Erreur lors de l'installation : $($_.Exception.Message)"
    $errorMessage | Out-File -FilePath $logPath -Append
}
