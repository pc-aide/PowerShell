cls
# Load the assembly to generate Windows Forms
Add-type -AssemblyName System.Windows.Forms

# Create the GUI form
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Add/Remove ADUsers to/from ADGroups (v26-03-2023)"
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

# Create the Textboxes for Users
$UserTextbox = New-Object System.Windows.Forms.TextBox
$UserTextbox.Location = New-Object System.Drawing.Point(25, 80)
$UserTextbox.Width = 250
$UserTextbox.Height = 210
$UserTextbox.Multiline = $true
$UserTextbox.ScrollBars = "Both"
$UserTextbox.ForeColor = [System.Drawing.Color]::Gray
# cue_banner
$UserTextbox.Text = "Enter the UserPrincipalName and/or samAccountName per line"

$UserTextbox.Add_Enter({
    if ($UserTextbox.Text -eq "Enter the UserPrincipalName and/or samAccountName per line") {
        $UserTextbox.Text = ""
        $UserTextbox.ForeColor = [System.Drawing.Color]::Black
    }
})

$UserTextbox.Add_Leave({
    if ([string]::IsNullOrEmpty($UserTextbox.Text)) {
        $UserTextbox.ForeColor = [System.Drawing.Color]::Gray
        $UserTextbox.Text = "Enter the UserPrincipalName and/or samAccountName per line"
    }
})

$Form.Controls.Add($UserTextbox)

# Add error label for UerText
$UserErrorLabel = New-Object System.Windows.Forms.Label
$UserErrorLabel.Location = New-Object System.Drawing.Point(25, 311)
$UserErrorLabel.Width = 100
$UserErrorLabel.Height = 20
$UserErrorLabel.Text = "Error :"
$Form.Controls.Add($UserErrorLabel)

# Add real-time validation for UserTextbox
$UserErrorRichTextbox = New-Object System.Windows.Forms.RichTextBox
$UserErrorRichTextbox.Location = New-Object System.Drawing.Point(25, 330)
$UserErrorRichTextbox.Width = 250
$UserErrorRichTextbox.Height = 60
$UserErrorRichTextbox.ReadOnly = $true
$UserErrorRichTextbox.ScrollBars = "Vertical"
$Form.Controls.Add($UserErrorRichTextbox)

$UserTextbox.Add_TextChanged({
        $UserErrorRichTextbox.Clear()
        $Users = $UserTextbox.Text -split "`r`n" | Where-Object { $_ -ne "" }
        foreach ($User in $Users) {
            $UserAccount = Get-ADUser -Filter { UserPrincipalName -eq $User -or SamAccountName -eq $User } -ErrorAction SilentlyContinue
            if (!$UserAccount) {
                $UserErrorRichTextbox.SelectionColor = [System.Drawing.Color]::Red
                $UserErrorRichTextbox.AppendText("User '$User' does not exist.`n")
            }
        }
    })

# Create the Textboxes for Groups
$GroupTextbox = New-Object System.Windows.Forms.TextBox
$GroupTextbox.Location = New-Object System.Drawing.Point(325, 80)
$GroupTextbox.Width = 270
$GroupTextbox.Height = 210
$GroupTextbox.Multiline = $true
$GroupTextbox.ScrollBars = "Both"
$GroupTextbox.ForeColor = [System.Drawing.Color]::Gray
# cue_banner
$GroupTextbox.Text = "Enter the ADGroup Name per line"

$GroupTextbox.Add_Enter({
    if ($GroupTextbox.Text -eq "Enter the ADGroup Name per line") {
        $GroupTextbox.Text = ""
        $GroupTextbox.ForeColor = [System.Drawing.Color]::Black
    }
})

$GroupTextbox.Add_Leave({
    if ([string]::IsNullOrEmpty($GroupTextbox.Text)) {
        $GroupTextbox.ForeColor = [System.Drawing.Color]::Gray
        $GroupTextbox.Text = "Enter the ADGroup Name per line"
    }
})

$Form.Controls.Add($GroupTextbox)

# Add error label for groupText
$GroupErrorLabel = New-Object System.Windows.Forms.Label
$GroupErrorLabel.Location = New-Object System.Drawing.Point(325, 311)
$GroupErrorLabel.Width = 100
$GroupErrorLabel.Height = 20
$GroupErrorLabel.Text = "Error :"
$Form.Controls.Add($GroupErrorLabel)

# Add real-time validation for GroupTextbox
$GroupErrorRichTextbox = New-Object System.Windows.Forms.RichTextBox
$GroupErrorRichTextbox.Location = New-Object System.Drawing.Point(325, 330)
$GroupErrorRichTextbox.Width = 250
$GroupErrorRichTextbox.Height = 60
$GroupErrorRichTextbox.ReadOnly = $true
$GroupErrorRichTextbox.ScrollBars = "Vertical"
$Form.Controls.Add($GroupErrorRichTextbox)

$GroupTextbox.Add_TextChanged({
        $GroupErrorRichTextbox.Clear()
        $Groups = $GroupTextbox.Text -split "`r`n" | Where-Object { $_ -ne "" }
        foreach ($Group in $Groups) {
            $GroupAccount = Get-ADGroup -Filter { Name -eq $Group } -ErrorAction SilentlyContinue
            if (!$GroupAccount) {
                $GroupErrorRichTextbox.SelectionColor = [System.Drawing.Color]::Red
                $GroupErrorRichTextbox.AppendText("Group '$Group' does not exist.`n")
            }
        }
    })


# Create the Radio Button for selecting Add or Remove
$ActionGroupBox = New-Object System.Windows.Forms.GroupBox
$ActionGroupBox.Location = New-Object System.Drawing.Point(25, 400)
$ActionGroupBox.Size = New-Object System.Drawing.Size(165, 50)
$ActionGroupBox.Text = "Action"
$Form.Controls.Add($ActionGroupBox)

$AddRadioButton = New-Object System.Windows.Forms.RadioButton
$AddRadioButton.Location = New-Object System.Drawing.Point(10, 20)
$AddRadioButton.Size = New-Object System.Drawing.Size(90, 20)
$AddRadioButton.Text = "Add"
$AddRadioButton.Checked = $true
$ActionGroupBox.Controls.Add($AddRadioButton)

$RemoveRadioButton = New-Object System.Windows.Forms.RadioButton
$RemoveRadioButton.Location = New-Object System.Drawing.Point(100, 20)
$RemoveRadioButton.Size = New-Object System.Drawing.Size(80, 20)
$RemoveRadioButton.Text = "Remove"
$ActionGroupBox.Controls.Add($RemoveRadioButton)

# Create Button OK
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(250, 420)
$OKButton.Size = New-Object System.Drawing.Size(75, 23)
$OKButton.Text = "OK"
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$Form.AcceptButton = $OKButton
$Form.Controls.Add($OKButton)

# Create Button Cancel
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
    $Action = "Add"

    if ($RemoveRadioButton.Checked) {
        $Action = "Remove"
    }

    $Log = @()
    foreach ($Group in $Groups) {
        if (!(Get-ADGroup -Filter { Name -eq $Group })) {
            $LogEntry = [PSCustomObject]@{
                Users   = ""
                Groups  = $Group
                Action  = $Action
                Error   = "$Group does not exist"
                Warning = ""
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
                    Users   = $User
                    Groups  = ""
                    Action  = $Action
                    Error   = "$User does not exist"
                    Warning = ""
                }
                $LogEntry | Format-Table -AutoSize
                $Log += $LogEntry
                continue
            }
            else {
                $UserName = $UserAccount.SamAccountName
            }

            $PDC = Get-ADDomain | Select -ExpandProperty PDCEmulator
            if ($Action -eq "Add") {
                if (Get-ADGroupMember -Identity $Group | Where-Object { $_.SamAccountName -eq $UserName }) {
                    $LogEntry = [PSCustomObject]@{
                        Users   = $User
                        Groups  = $Group
                        Action  = $Action
                        Error   = ""
                        Warning = "$User is already a member of $Group"
                        Ajout   = ""
                    }
                    $Log += $LogEntry
                }
                else {
                    try {
                        Add-ADGroupMember -Identity $Group -Members $UserName -Server $PDC -ErrorAction Stop
                        $LogEntry = [PSCustomObject]@{
                            Users   = $User
                            Groups  = $Group
                            Action  = $Action
                            Error   = ""
                            Warning = ""
                            Ajout   = "Added"
                        }
                        $LogEntry | Format-Table -AutoSize
                        $Log += $LogEntry
                    }
                    catch {
                        $LogEntry = [PSCustomObject]@{
                            Users   = $User
                            Groups  = $Group
                            Action  = $Action
                            Error   = "Error adding $User to $Group $($PSItem.Exception.Message)"
                            Warning = ""
                            Ajout   = ""
                        }
                        $LogEntry | Format-Table -AutoSize
                        $Log += $LogEntry
                    }
                }
            }
            elseif ($Action -eq "Remove") {
                if (!(Get-ADGroupMember -Identity $Group | Where-Object { $_.SamAccountName -eq $UserName })) {
                    $LogEntry =
                    [PSCustomObject]@{
                        Users   = $User
                        Groups  = $Group
                        Action  = $Action
                        Error   = ""
                        Warning = "$User is not a member of $Group"
                        Removal = ""
                    }
                    $LogEntry | Format-Table -AutoSize
                    $Log += $LogEntry
                }
                else {
                    try {
                        $UserIsMember = Get-ADGroupMember -Identity $Group -Server $PDC | Where-Object { $_.SamAccountName -eq $UserName }

                        if ($UserIsMember) {
                            Remove-ADGroupMember -Identity $Group -Members $UserName -Confirm:$false -Server $PDC -ErrorAction Stop
                            $LogEntry = [PSCustomObject]@{
                                Users   = $User
                                Groups  = $Group
                                Action  = $Action
                                Error   = ""
                                Warning = ""
                                Removal = "Removed"
                            }
                            $LogEntry | Format-Table -AutoSize
                            $Log += $LogEntry
                        }
                        else {
                            $LogEntry = [PSCustomObject]@{
                                Users   = $User
                                Groups  = $Group
                                Action  = $Action
                                Error   = ""
                                Warning = "$User is not a member of $Group"
                                Removal = ""
                            }
                            $LogEntry | Format-Table -AutoSize
                            $Log += $LogEntry
                        }
                    }
                    catch {
                        $LogEntry = [PSCustomObject]@{
                            Users   = $User
                            Groups  = $Group
                            Action  = $Action
                            Error   = "Error removing $User from $Group $($PSItem.Exception.Message)"
                            Warning = ""
                            Removal = ""
                        }
                        $LogEntry | Format-Table -AutoSize
                        $Log += $LogEntry
                    }
                }
            }

        }
    }

    $TimeStamp = Get-Date -Format "dd-MM-yyyy-HH-mm-ss"
    $Log | Export-Csv -Path "C:\temp\Rapport_Add_or_Remove_ADUsers_to_mul_ADGroups_$TimeStamp.csv" -NoTypeInformation -Encoding UTF8 -Delimiter ";" -Force -Append

    # Afficher en rouge les erreurs, en vert les ajouts ou les retraits, en jaune les warnings dans la console PowerShell
    $Log | Where-Object { $_.Error -ne "" } | ForEach-Object {
        Write-Host $_ -ForegroundColor Red
    }

    $Log | Where-Object { $_.Ajout -eq "Added" } | ForEach-Object {
        Write-Host $_ -ForegroundColor Green
    }

    $Log | Where-Object { $_.Warning -ne "" } | ForEach-Object {
        Write-Host $_ -ForegroundColor Yellow
    }

    $Log | Where-Object { $_.Removal -eq "Removed" } | ForEach-Object {
        Write-Host $_ -ForegroundColor Green
    }
}
