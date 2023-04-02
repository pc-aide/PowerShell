# Win32_LoggedOnUser

---

## draft
````ps1
try {
    # Vérifier s'il y a un utilisateur connecté
    $users = Get-WmiObject -Class Win32_LoggedOnUser | Select-Object Antecedent -Unique

    if ($users) {
        # Forcer la déconnexion de l'utilisateur
        foreach ($user in $users) {
            $user = ($user.Antecedent -split "Name=`"")[1] -replace '`,SID=.*$'
            $session = quser /server:localhost | Where-Object { $_ -match $user }
            if ($session) {
                $id = ($session -split " +")[2]
                logoff $id /server:localhost
            }
        }
    }
} catch {
    Write-Host "Une erreur s'est produite : $_"
}

````
