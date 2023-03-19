cls
# Load the assembly to generate Windows Forms
Add-type -AssemblyName System.Windows.Forms

# Create the GUI form
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Add AD Users to AD Groups (v19-03-2023)"
$Form.Size = New-Object System.Drawing.Size(650, 500)

# Create the Labels for User and Group Textboxes
$UserListLabel = New-Object System.Windows.Forms.Label
$UserListLabel.Location = New-Object System.Drawing.Point(25, 50)
$UserListLabel.Width = 150
$UserListLabel.Text = "User List :"
$Form.Controls.Add($UserListLabel)

$GroupListLabel = New-Object System.Windows.Forms.Label
$GroupListLabel.Location = New-Object System.Drawing.Point(325, 50)
$GroupListLabel.Width = 150
$GroupListLabel.Text = "Group List :"
$Form.Controls.Add($GroupListLabel)

# Create the Textboxes for Users and Groups
$UserTextbox = New-Object System.Windows.Forms.TextBox
$UserTextbox.Location = New-Object System.Drawing.Point(25, 80)
$UserTextbox.Width = 250
$UserTextbox.Height = 300
$UserTextbox.Multiline = $true
$UserTextbox.ScrollBars = "Both"
$UserTextbox.Text = "Enter the UserPrincipalName and/or samAccountName per line"
$UserTextbox.Add_MouseClick({
    $UserTextbox.Text = ""
})
$Form.Controls.Add($UserTextbox)

$GroupTextbox = New-Object System.Windows.Forms.TextBox
$GroupTextbox.Location = New-Object System.Drawing.Point(325, 80)
$GroupTextbox.Width = 270
$GroupTextbox.Height = 300
$GroupTextbox.Multiline = $true
$GroupTextbox.ScrollBars = "Both"
$Form.Controls.Add($GroupTextbox)

# Button to Add Users to Groups
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(250, 420)
$OKButton.Size = New-Object System.Drawing.Size(75, 23)
$OKButton.Text = "OK"
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$Form.AcceptButton = $OKButton
$Form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(350, 420)
$CancelButton.Size = New-Object System.Drawing.Size(75, 23)
$CancelButton.Text = "Cancel"
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$Form.CancelButton = $CancelButton
$Form.Controls.Add($CancelButton)

# Display the form
if ($Form.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    $Users = $UserTextbox.Text -split "`r`n" | Where-Object { $_ -ne "" }
    $Groups = $GroupTextbox.Text -split "`r`n" | Where-Object { $_ -ne "" }

    $Log = @()
    foreach ($Group in $Groups) {
        if (!(Get-ADGroup -Filter { Name -eq $Group })) {
            $LogEntry = [PSCustomObject]@{
                Users = ""
                Groups = $Group
                Error = "$Group does not exist"
                Warning = ""
                Ajout = ""
            }
            $LogEntry | Format-Table -AutoSize
            $Log += $LogEntry
            continue
        }
        foreach ($User in $Users) {
            $UserAccount = $null
            try {
                $UserAccount = Get-ADUser -Filter { UserPrincipalName -eq $User } -ErrorAction Stop
            }
            catch {
                Write-Verbose "User with UPN '$User' not found. Trying with SamAccountName."
            }

            if (!$UserAccount) {
                $UserAccount = Get-ADUser -Filter { SamAccountName -eq $User } -ErrorAction SilentlyContinue
            }

            if (!$UserAccount) {
                $LogEntry = [PSCustomObject]@{
                    Users = $User
                    Groups = ""
                    Error = "$User does not exist"
                    Warning = ""
                    Ajout = ""
                }
                $LogEntry | Format-Table -AutoSize
                $Log += $LogEntry
                continue
            }
            else {
                $UserName = $UserAccount.SamAccountName
            }

            $PDC = Get-ADDomain | Select -ExpandProperty PDCEmulator
            if (Get-ADGroupMember -Identity $Group | Where-Object { $_.SamAccountName -eq $UserName }) {
                $LogEntry = [PSCustomObject]@{
                    Users = $User
                    Groups = $Group
                    Error = ""
                    Warning = "$User is already a member of $Group"
                    Ajout = ""
                }
                $Log += $LogEntry
            }
            else {
                try {
                    Add-ADGroupMember -Identity $Group -Members $UserName -Server $PDC -ErrorAction Stop
                    $LogEntry = [PSCustomObject]@{
                        Users = $User
                        Groups = $Group
                        Error = ""
                        Warning = ""
                        Ajout = "Added"
                    }
                    $LogEntry | Format-Table -AutoSize
                    $Log += $LogEntry
                }
                catch {
                    $LogEntry = [PSCustomObject]@{
                        Users = $User
                        Groups = $Group
                        Error = "Error adding $User to $Group $($PSItem.Exception.Message)"
                        Warning = ""
                        Ajout = ""
                    }
                    $LogEntry | Format-Table -AutoSize
                    $Log += $LogEntry
                }
            }
        }
    }

    $TimeStamp = Get-Date -Format "dd-MM-yyyy-hh:mm:ss tt"
    $Log | Export-Csv -Path "C:\temp\Rapport_Add_users_to_mul_groups_$TimeStamp.csv" -NoTypeInformation -Encoding UTF8 -Delimiter ";" -Force -Append

    # Afficher en rouge les erreurs et en vert les ajouts et en jaune les warnings dans la console PowerShell
    $Log | Where-Object { $_.Error -ne "" } | ForEach-Object {
        Write-Host $_ -ForegroundColor Red
    }

    $Log | Where-Object { $_.Ajout -eq "Added" } | ForEach-Object {
        Write-Host $_ -ForegroundColor Green
    }

    $Log | Where-Object { $_.Warning -ne "" } | ForEach-Object {
        Write-Host $_ -ForegroundColor Yellow
    }
}
