param
(
[parameter(Mandatory=$false)]
$DeviceName
)

function Get-AuthToken {
[cmdletbinding()]

param
(
    [Parameter(Mandatory=$true)]
    $User
)

$userUpn = New-Object "System.Net.Mail.MailAddress" -ArgumentList $User

$tenant = $userUpn.Host

Write-Host "Checking for AzureAD module..."

    $AadModule = Get-Module -Name "AzureAD" -ListAvailable

    if ($AadModule -eq $null) {

        Write-Host "AzureAD PowerShell module not found, looking for AzureADPreview"
        $AadModule = Get-Module -Name "AzureADPreview" -ListAvailable

    }

    if ($AadModule -eq $null) {
        write-host
        write-host "AzureAD Powershell module not installed..." -f Red
        write-host "Install by running 'Install-Module AzureAD' or 'Install-Module AzureADPreview' from an elevated PowerShell prompt" -f Yellow
        write-host "Script can't continue..." -f Red
        write-host
        exit
    }

# Getting path to ActiveDirectory Assemblies
# If the module count is greater than 1 find the latest version

    if($AadModule.count -gt 1){

        $Latest_Version = ($AadModule | select version | Sort-Object)[-1]

        $aadModule = $AadModule | ? { $_.version -eq $Latest_Version.version }

            # Checking if there are multiple versions of the same module found

            if($AadModule.count -gt 1){

            $aadModule = $AadModule | select -Unique

            }

        $adal = Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
        $adalforms = Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll"

    }

    else {

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

    # https://msdn.microsoft.com/en-us/library/azure/microsoft.identitymodel.clients.activedirectory.promptbehavior.aspx
    # Change the prompt behaviour to force credentials each time: Auto, Always, Never, RefreshSession

    $platformParameters = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters" -ArgumentList "Auto"

    $userId = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.UserIdentifier" -ArgumentList ($User, "OptionalDisplayableId")

    $authResult = $authContext.AcquireTokenAsync($resourceAppIdURI,$clientId,$redirectUri,$platformParameters,$userId).Result

        # If the accesstoken is valid then create the authentication header

        if($authResult.AccessToken){

        # Creating header for Authorization token

        $authHeader = @{
            'Content-Type'='application/json'
            'Authorization'="Bearer " + $authResult.AccessToken
            'ExpiresOn'=$authResult.ExpiresOn
            }

        return $authHeader

        }

        else {

        Write-Host
        Write-Host "Authorization Access Token is null, please re-run authentication..." -ForegroundColor Red
        }

    }

    catch {

    write-host $_.Exception.Message -f Red
    write-host $_.Exception.ItemName -f Red
    write-host

    }

}

function Get-Win10IntuneManagedDevice {
[cmdletbinding()]
param
(
[parameter(Mandatory=$false)]
[ValidateNotNullOrEmpty()]
[string]$deviceName
)
    
    $graphApiVersion = "beta"

    try {

        if($deviceName){

            $Resource = "deviceManagement/managedDevices?`$filter=deviceName eq '$deviceName'"
	        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)" 

            (Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).value

        }

        else {

            $Resource = "deviceManagement/managedDevices?`$filter=(((deviceType%20eq%20%27desktop%27)%20or%20(deviceType%20eq%20%27windowsRT%27)%20or%20(deviceType%20eq%20%27winEmbedded%27)%20or%20(deviceType%20eq%20%27surfaceHub%27)))"
	        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
        
            (Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).value

        }

	} catch {
		$ex = $_.Exception
		$errorResponse = $ex.Response.GetResponseStream()
		$reader = New-Object System.IO.StreamReader($errorResponse)
		$reader.BaseStream.Position = 0
		$reader.DiscardBufferedData()
		$responseBody = $reader.ReadToEnd();
		Write-Host "Response content:`n$responseBody" -f Red
		Write-Error "Request to $Uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription)"
		throw "Get-IntuneManagedDevices error"
	}

}

function Get-AADDeviceId {
[cmdletbinding()]

param
(
    [Parameter(Mandatory=$true)]
    [string] $deviceId
)
    $graphApiVersion = "beta"
    $Resource = "devices"
	$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)?`$filter=deviceId eq '$deviceId'"

    try {
        $device = Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get

        return $device.value."id"

	} catch {
		$ex = $_.Exception
		$errorResponse = $ex.Response.GetResponseStream()
		$reader = New-Object System.IO.StreamReader($errorResponse)
		$reader.BaseStream.Position = 0
		$reader.DiscardBufferedData()
		$responseBody = $reader.ReadToEnd();
		Write-Host "Response content:`n$responseBody" -f Red
		Write-Error "Request to $Uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription)"
		throw "Get-AADDeviceId error"
	}
}

function Get-IntuneDevicePrimaryUser {
[cmdletbinding()]

param
(
    [Parameter(Mandatory=$true)]
    [string] $deviceId
)
    
    $graphApiVersion = "beta"
    $Resource = "deviceManagement/managedDevices"
	$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)" + "/" + $deviceId + "/users"

    try {
        
        $primaryUser = Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get

        return $primaryUser.value."id"
        
	} catch {
		$ex = $_.Exception
		$errorResponse = $ex.Response.GetResponseStream()
		$reader = New-Object System.IO.StreamReader($errorResponse)
		$reader.BaseStream.Position = 0
		$reader.DiscardBufferedData()
		$responseBody = $reader.ReadToEnd();
		Write-Host "Response content:`n$responseBody" -f Red
		Write-Error "Request to $Uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription)"
		throw "Get-IntuneDevicePrimaryUser error"
	}
}

function Delete-IntuneDevicePrimaryUser {

<#
.SYNOPSIS
This deletes the Intune device primary user
.DESCRIPTION
This deletes the Intune device primary user
.EXAMPLE
Delete-IntuneDevicePrimaryUser
.NOTES
NAME: Delete-IntuneDevicePrimaryUser
#>

[cmdletbinding()]

param
(
[parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
$IntuneDeviceId
)
    
    $graphApiVersion = "beta"
    $Resource = "deviceManagement/managedDevices('$IntuneDeviceId')/users/`$ref"

    try {

        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"

        Invoke-RestMethod -Uri $uri -Headers $authToken -Method Delete

	}

    catch {

		$ex = $_.Exception
		$errorResponse = $ex.Response.GetResponseStream()
		$reader = New-Object System.IO.StreamReader($errorResponse)
		$reader.BaseStream.Position = 0
		$reader.DiscardBufferedData()
		$responseBody = $reader.ReadToEnd();
		Write-Host "Response content:`n$responseBody" -f Red
		Write-Error "Request to $Uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription)"
		throw "Delete-IntuneDevicePrimaryUser error"
	
    }

}

function Get-AADDevicesRegisteredOwners {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string] $deviceId
    )

    $graphApiVersion = "beta"
    $Resource = "devices"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)/$deviceId/registeredOwners"

    try {
        $registeredOwners = Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get

        if(@($registeredOwners.value).count -ge 1){
            $owners = @()
            foreach($owner in $registeredOwners.value){
                $owners += $owner.userPrincipalName
            }
            return $owners -join ","
        }
        
    } catch {
        $ex = $_.Exception
        $errorResponse = $ex.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorResponse)
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        $responseBody = $reader.ReadToEnd();
        Write-Host "Response content:`n$responseBody" -f Red
        Write-Error "Request to $Uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription)"
        throw "Get-AADDevicesRegisteredOwners error"
    }
}




# region Authentication

write-host

# Checking if authToken exists before running authentication
if($global:authToken){

    # Setting DateTime to Universal time to work in all timezones
    $DateTime = (Get-Date).ToUniversalTime()

    # If the authToken exists checking when it expires
    $TokenExpires = ($authToken.ExpiresOn.datetime - $DateTime).Minutes

    if($TokenExpires -le 0){

        write-host "Authentication Token expired" $TokenExpires "minutes ago" -ForegroundColor Yellow
        write-host

        # Defining User Principal Name if not present

        if($User -eq $null -or $User -eq ""){
            $User = Read-Host -Prompt "Please specify your user principal name for Azure Authentication"
            Write-Host
        }

        $global:authToken = Get-AuthToken -User $User
    }
}

# Authentication doesn't exist, calling Get-AuthToken function

else {

    if($User -eq $null -or $User -eq "") {
        $User = Read-Host -Prompt "Please specify your user principal name for Azure Authentication"
        Write-Host
    }

    # Getting the authorization token
    $global:authToken = Get-AuthToken -User $User
}

if($DeviceName){

    $Devices = Get-Win10IntuneManagedDevice -deviceName $DeviceName

}

else {

    $Devices = Get-Win10IntuneManagedDevice

}

# Créer la GUI
Add-Type -AssemblyName System.Windows.Forms
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "PrimaryUser v0.1 - LastUpdate 15-04-2023"
$Form.Width = 400
$Form.Height = 350

$LabelUPN = New-Object System.Windows.Forms.Label
$LabelUPN.Text = "Enter UPN:"
$LabelUPN.AutoSize = $true
$LabelUPN.Location = New-Object System.Drawing.Point(10, 20)
$Form.Controls.Add($LabelUPN)

$LabelDevicesList = New-Object System.Windows.Forms.Label
$LabelDevicesList.Text = "Devices List:"
$LabelDevicesList.AutoSize = $true
$LabelDevicesList.Location = New-Object System.Drawing.Point(10, 60)
$Form.Controls.Add($LabelDevicesList)

$TextBoxEnterUPN = New-Object System.Windows.Forms.TextBox
$TextBoxEnterUPN.Width = 250
$TextBoxEnterUPN.Location = New-Object System.Drawing.Point(100, 18)
$Form.Controls.Add($TextBoxEnterUPN)

$TextBoxEnterUPN.Add_KeyDown({
    if ($_.KeyCode -eq 'Enter') {
        $OKButton.PerformClick()
    }
})


# Create the TextBox for displaying the results
$TextBoxDeviceList = New-Object System.Windows.Forms.TextBox
$TextBoxDeviceList.Multiline = $true
$TextBoxDeviceList.ScrollBars = 'Vertical'
$TextBoxDeviceList.Width = 250
$TextBoxDeviceList.Height = 100
$TextBoxDeviceList.Location = New-Object System.Drawing.Point(100, 60)
$Form.Controls.Add($TextBoxDeviceList)

# Ajout du Radio Button Group
$LabelMethod = New-Object System.Windows.Forms.Label
$LabelMethod.Text = "Method:"
$LabelMethod.AutoSize = $true
$LabelMethod.Location = New-Object System.Drawing.Point(10, 120)
$Form.Controls.Add($LabelMethod)

$RadioButtonGet = New-Object System.Windows.Forms.RadioButton
$RadioButtonGet.Text = "Get"
$RadioButtonGet.Location = New-Object System.Drawing.Point(15, 135)
$RadioButtonGet.Checked = $true
$Form.Controls.Add($RadioButtonGet)

$RadioButtonRemove = New-Object System.Windows.Forms.RadioButton
$RadioButtonRemove.Text = "Remove"
$RadioButtonRemove.Width = 80
$RadioButtonRemove.Location = New-Object System.Drawing.Point(15, 155)
$Form.Controls.Add($RadioButtonRemove)

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Text = "OK"
$OKButton.Location = New-Object System.Drawing.Point(100, 180)
$OKButton.Add_Click(
{
     if ($RadioButtonGet.Checked) {
        $TextBoxDeviceList.ForeColor = 'Green'
        $TextBoxDeviceList.Text = "Traitement en cours..."
        $EnterUPN = $TextBoxEnterUPN.Text
        if($Devices){
            $DevicesList = @()

            foreach($device in $Devices){
                $IntuneDevicePrimaryUser = Get-IntuneDevicePrimaryUser -deviceId $device.id

                if($IntuneDevicePrimaryUser -eq $null){
                    $PrimaryUser = "No Intune Primary User Id set for Intune Managed Device"
                }
                else {
                    $PrimaryUser = $IntuneDevicePrimaryUser
                }

                $aadDeviceId = Get-AADDeviceId -deviceId $device."azureActiveDirectoryDeviceId"

                $registeredOwners = Get-AADDevicesRegisteredOwners -deviceId $aadDeviceId

                if($registeredOwners -like "*$EnterUPN*"){
                    $DevicesList += [PSCustomObject]@{
                        DeviceName = $device."deviceName"
                    }
                }
            }
            if ($DevicesList.count -eq 0)
            {
                # jaune fonce
                $TextBoxDeviceList.ForeColor = [System.Drawing.Color]::FromArgb(204, 204, 0)
                $TextBoxDeviceList.Text = "Aucun resultat"
            }
            else{
                $TextBoxDeviceList.ForeColor = 'Black'
                $TextBoxDeviceList.Text = ($DevicesList | Format-Table -AutoSize -HideTableHeaders | Out-String).Trim()
            }
        }
        else {
            $TextBoxDeviceList.Text = "No Windows 10 devices found..."
        }
    }
    elseif ($RadioButtonRemove.Checked){
        $DeviceNames = $TextBoxDeviceList.Text -split "`r`n"
        
        foreach ($DeviceName in $DeviceNames) {
    $Device = Get-Win10IntuneManagedDevices -deviceName "$DeviceName"

    if ($Device) {
        Write-Host
        Write-Host "Device name:" $device."deviceName" -ForegroundColor Cyan
        $IntuneDevicePrimaryUser = Get-IntuneDevicePrimaryUser -deviceId $Device.id

        Write-Host "Intune Device Primary User:" $IntuneDevicePrimaryUser

        try {
            $DeleteIntuneDevicePrimaryUser = Delete-IntuneDevicePrimaryUser -IntuneDeviceId $Device.id

            if ($DeleteIntuneDevicePrimaryUser -eq "") {
                Write-Host "User deleted as Primary User from the device '$DeviceName'..." -ForegroundColor Green
            }
        }
        catch {
            Write-Host "An error occurred while deleting the primary user for the device '$DeviceName': $_" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "Intune Device '$DeviceName' can't be found..." -ForegroundColor Red
    }
}
    }
})


$Form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Text = "Cancel"
$CancelButton.Location = New-Object System.Drawing.Point(200, 180)
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$Form.Controls.Add($CancelButton)

$Form.CancelButton = $CancelButton

$Form.ShowDialog()
