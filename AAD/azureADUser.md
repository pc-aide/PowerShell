# azureADUser

````ps1
# a tester
# Demander les informations d'identification du compte Azure AD sous forme de boîte de dialogue de connexion
$azureAdCred = Get-Credential -Message 'Entrez vos informations d'identification Azure AD'

# Connecter Azure AD avec les informations d'identification fournies
Connect-AzureAD -Credential $azureAdCred

# Liste des utilisateurs Azure AD
Get-AzureADUser
````

---

## get
|n|name|e.g.|O/P|
|-|----|----|---|
|1|azureADUser
