# Module
$AadModule = Get-Module -Name AzureAD -ListAvailable
if ($AadModule -eq $null) {
    Install-Module -Name AzureAD -Force
    Import-Module -Name AzureAd -Force
}

# Function to get the authentication token
function Get-AuthToken {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true)]
        $User
    )

    $userUpn = New-Object "System.Net.Mail.MailAddress" -ArgumentList $User
    $tenant = $userUpn.Host

    # Getting path to ActiveDirectory Assemblies
    if ($AadModule.count -gt 1) {
        $Latest_Version = ($AadModule | select version | Sort-Object)[-1]
        $aadModule = $AadModule | ? { $_.version -eq $Latest_Version.version }

        if ($AadModule.count -gt 1) {
            $aadModule = $AadModule | select -Unique
        }

        $adal = Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
        $adalforms = Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll"
    } else {
        $adal = Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
        $adalforms = Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll"
    }

    [System.Reflection.Assembly]::LoadFrom($adal) | Out-Null
    [System.Reflection.Assembly]::LoadFrom($adalforms) | Out-Null

    $clientId = "d1ddf0e4-d672-4dae-b554-9d5bdfd93547"
    $redirectUri = "urn:ietf:wg:oauth:2.0:oob"
    $resourceAppIdURI = "https://graph.microsoft.com"
    $authority = "https://login.microsoftonline.com/$Tenant"

    try {
        $authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority
        $platformParameters = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters" -ArgumentList "Auto"
        $userId = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.UserIdentifier" -ArgumentList ($User, "OptionalDisplayableId")
        $authResult = $authContext.AcquireTokenAsync($resourceAppIdURI, $clientId, $redirectUri, $platformParameters, $userId).Result

        if ($authResult.AccessToken) {
            $authHeader = @{
                'Content-Type' = 'application/json'
                'Authorization' = "Bearer " + $authResult.AccessToken
                'ExpiresOn' = $authResult.ExpiresOn
            }

            return $authHeader
        } else {
            Write-Host
            Write-Host "Authorization Access Token is null, please re-run authentication..." -ForegroundColor Red
            Write-Host
            break
        }
    } catch {
        write-host $_.Exception.Message -f Red
        write-host $_.Exception.ItemName -f Red
        write-host
        break
    }
}

# Function to get Win10 Intune Managed Devices
function Get-Win10IntuneManagedDevice {
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$deviceName
    )

    $graphApiVersion = "beta"

    try {
        if ($deviceName) {
            $Resource = "deviceManagement/managedDevices?`$filter=deviceName eq '$deviceName'"
            $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
            (Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).value
        } else {
            $Resource = "deviceManagement/managedDevices?`$filter=(((deviceType eq 'desktop') or (deviceType eq 'windowsRT') or (deviceType eq 'winEmbedded') or (deviceType eq 'surfaceHub')))"
            $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
            (Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).value
        }
    } catch {
        $ex = $_.Exception
        $errorResponse = $ex.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorResponse)
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        $responseBody = $reader.ReadToEnd()
        Write-Host "Response content:`n$responseBody" -f Red
        Write-Error "Request to $Uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription)"
        throw "Get-IntuneManagedDevices error"
    }
}

# Function to get AAD User
Function Get-AADUser {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Identity
    )

    $graphApiVersion = "v1.0"
    $User_resource = "users"

    try {
        if ($Identity.Contains("@")) {
            # UPN
            $filter = "userPrincipalName eq '$Identity'"
        } else {
            # mailNickname
            $filter = "mailNickname eq '$Identity'"
        }

        $uri = "https://graph.microsoft.com/$graphApiVersion/$($User_resource)?`$filter=$filter"
        Write-Verbose $uri
        $response = Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get

        if ($response.value.Count -gt 0) {
            $response.value | Select-Object -First 1
        } else {
            $null
        }
    } catch {
        $null
    }
}

# Function to get Intune Device Primary User
function Get-IntuneDevicePrimaryUser {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$deviceId
    )

    $graphApiVersion = "beta"
    $Resource = "deviceManagement/managedDevices"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)" + "/" + $deviceId + "/users"

    try {
        $primaryUser = Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get
        return $primaryUser.value."id"
    } catch {
        $null
    }
}

# Function to set Intune Device Primary User
function Set-IntuneDevicePrimaryUser {
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $IntuneDeviceId,
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $UserId
    )

    $graphApiVersion = "beta"
    $Resource = "deviceManagement/managedDevices('$IntuneDeviceId')/users/`$ref"

    try {
        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
        $userUri = "https://graph.microsoft.com/$graphApiVersion/users/" + $UserId
        $id = "@odata.id"
        $JSON = @{ $id = "$userUri" } | ConvertTo-Json -Compress
        Invoke-RestMethod -Uri $uri -Headers $authToken -Method Post -Body $JSON -ContentType "application/json"
    } catch {
        $ex = $_.Exception
        $errorResponse = $ex.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorResponse)
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        $responseBody = $reader.ReadToEnd()
        Write-Host "Response content:`n$responseBody" -f Red
        Write-Error "Request to $Uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription)"
    }
}

#region Authentication

write-host

# Checking if authToken exists before running authentication
if ($global:authToken) {
    $DateTime = (Get-Date).ToUniversalTime()
    $TokenExpires = ($authToken.ExpiresOn.datetime - $DateTime).Minutes

    if ($TokenExpires -le 0) {
        write-host "Authentication Token expired" $TokenExpires "minutes ago" -ForegroundColor Yellow
        write-host

        if ($User -eq $null -or $User -eq "") {
            $User = Read-Host -Prompt "Please specify your user principal name for Azure Authentication"
            Write-Host
        }

        $global:authToken = Get-AuthToken -User $User
    }
} else {
    if ($User -eq $null -or $User -eq "") {
        $User = Read-Host -Prompt "Please specify your user principal name for Azure Authentication"
        Write-Host
    }

    $global:authToken = Get-AuthToken -User $User
}

#endregion

Add-Type -AssemblyName System.Windows.Forms

$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Set-PrimaryUser v0.1 | LastUpdate 25-06-2023"
$Form.Size = New-Object System.Drawing.Size(500, 250)
$Form.StartPosition = "CenterScreen"

$LabelUser = New-Object System.Windows.Forms.Label
$LabelUser.Text = "Liste des utilisateurs :"
$LabelUser.AutoSize = $true
$LabelUser.Location = New-Object System.Drawing.Point(20, 20)

$TextBoxUser = New-Object System.Windows.Forms.TextBox
$TextBoxUser.Width = 250
$TextBoxUser.Height = 100
$TextBoxUser.Multiline = $true
$TextBoxUser.ScrollBars = "Vertical"
$TextBoxUser.Location = New-Object System.Drawing.Point(20, 40)
$TextBoxUser.ForeColor = [System.Drawing.Color]::Gray

# cue banner list users
$cueBannerUser = "Enter the UPN and/or samAccountName per line" + [Environment]::NewLine + "E.g.: FirstName.LastName@contoso.ca"

# cue banner list users
$TextBoxUser.Text = $cueBannerUser

$TextBoxUser.Add_Enter({
    if ($TextBoxUser.Text -eq $cueBannerUser) {
        $TextBoxUser.Text = ""
        $TextBoxUser.ForeColor = [System.Drawing.Color]::Black
    }
})

$TextBoxUser.Add_Leave({
    if ([string]::IsNullOrEmpty($TextBoxUser.Text)) {
        $TextBoxUser.ForeColor = [System.Drawing.Color]::Gray
        $TextBoxUser.Text = $cueBannerUser
    }
})

$LabelDevice = New-Object System.Windows.Forms.Label
$LabelDevice.Text = "Liste des appareils :"
$LabelDevice.AutoSize = $true
$LabelDevice.Location = New-Object System.Drawing.Point(280, 20)

$TextBoxDevice = New-Object System.Windows.Forms.TextBox
$TextBoxDevice.Width = 200
$TextBoxDevice.Height = 100
$TextBoxDevice.Multiline = $true
$TextBoxDevice.ScrollBars = "Vertical"
$TextBoxDevice.Location = New-Object System.Drawing.Point(280, 40)
$TextBoxDevice.ForeColor = [System.Drawing.Color]::Gray

# cue banner device
$cueBannerDevice = "Enter the device per line" + [Environment]::NewLine + "E.g.: WX<SerialNumber>"

# cue banner device
$TextBoxDevice.Text = $cueBannerDevice

$TextBoxDevice.Add_Enter({
    if ($TextBoxDevice.Text -eq $cueBannerDevice) {
        $TextBoxDevice.Text = ""
        $TextBoxDevice.ForeColor = [System.Drawing.Color]::Black
    }
})

$TextBoxDevice.Add_Leave({
    if ([string]::IsNullOrEmpty($TextBoxDevice.Text)) {
        $TextBoxDevice.ForeColor = [System.Drawing.Color]::Gray
        $TextBoxDevice.Text = $cueBannerDevice
    }
})

$ButtonOK = New-Object System.Windows.Forms.Button
$ButtonOK.Text = "OK"
$ButtonOK.Location = New-Object System.Drawing.Point(150, 150)
$ButtonOK.Add_Click({
    $devices = $TextBoxDevice.Text -split "`r`n"
    $users = $TextBoxUser.Text -split "`r`n"

    $lines = [Math]::Max($devices.Count, $users.Count)

    for ($i = 0; $i -lt $lines; $i++) {
        $deviceName = $devices[$i]
        $userName = $users[$i]

        if ([string]::IsNullOrWhiteSpace($deviceName) -or [string]::IsNullOrWhiteSpace($userName)) {
            continue
        }

        $deviceObject = Get-Win10IntuneManagedDevice -deviceName $deviceName
        $userObject = Get-AADUser -Identity $userName

        if (-not $deviceObject) {
            Write-Host "Device '$deviceName' not found." -ForegroundColor Red
        }

        if (-not $userObject) {
            Write-Host "User '$userName' not found." -ForegroundColor Red
        }

        if ($deviceObject -and $userObject) {
            $userId = $userObject.id
            Write-Host "Setting primary user for device $deviceName to user $($userObject.userPrincipalName)" -ForegroundColor Yellow
            Set-IntuneDevicePrimaryUser -IntuneDeviceId $deviceObject.id -UserId $userId
            Write-Host "Successfully set the Primary User for device $deviceName" -ForegroundColor Green
        }
    }

    $Form.Close()
})

$ButtonCancel = New-Object System.Windows.Forms.Button
$ButtonCancel.Text = "Annuler"
$ButtonCancel.Location = New-Object System.Drawing.Point(300, 150)
$ButtonCancel.Add_Click({ $Form.Close() })

$Form.Controls.Add($LabelUser)
$Form.Controls.Add($TextBoxUser)
$Form.Controls.Add($LabelDevice)
$Form.Controls.Add($TextBoxDevice)
$Form.Controls.Add($ButtonOK)
$Form.Controls.Add($ButtonCancel)

$Form.Add_Shown({ 
    $Form.Activate() 
    $ButtonCancel.Focus() 
})

[void]$Form.ShowDialog()
