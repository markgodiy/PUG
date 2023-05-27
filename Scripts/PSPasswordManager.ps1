function PSPasswordManager {
    
    #############################
    #### Declare Script Variables
    #############################
    $script:SecretFile = $(Join-Path $env:APPDATA "Secrets.json")
     
    #############################
    #### Create the main form and controls
    #############################
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "PowerShell - Password Manager"
    $form.Size = New-Object System.Drawing.Size(600, 400)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    
    # Add Status bar
    $statusBar = New-Object System.Windows.Forms.StatusStrip
    $statusLabel = New-Object System.Windows.Forms.ToolStripStatusLabel
    $statusBar.Items.Add($statusLabel)
    
    # Add Textfields, with labels
    $lblSystemName = New-Object System.Windows.Forms.Label
    $lblSystemName.Location = New-Object System.Drawing.Point(20, 20)
    $lblSystemName.Text = "System Name:"
    
    $txtSystemName = New-Object System.Windows.Forms.TextBox
    $txtSystemName.Location = New-Object System.Drawing.Point(120, 20)
    $txtSystemName.Size = New-Object System.Drawing.Size(180, 20)
    $txtSystemName.Text = ""

    $lblIPAddress = New-Object System.Windows.Forms.Label
    $lblIPAddress.Location = New-Object System.Drawing.Point(310, 20)
    $lblIPAddress.Size = New-Object System.Drawing.Size(30, 20)
    $lblIPAddress.Text = "IP:"
    
    $txtIPAddress = New-Object System.Windows.Forms.TextBox
    $txtIPAddress.Location = New-Object System.Drawing.Point(350, 20)
    $txtIPAddress.Size = New-Object System.Drawing.Size(200, 20)
    $txtIPAddress.Text = ""
    
    # Add Buttons 
    $btnAdd = New-Object System.Windows.Forms.Button
    $btnAdd.Location = New-Object System.Drawing.Point(20, 70)
    $btnAdd.Size = New-Object System.Drawing.Size(100, 30)
    $btnAdd.Text = "Add"
    
    $btnRefresh = New-Object System.Windows.Forms.Button
    $btnRefresh.Location = New-Object System.Drawing.Point(130, 70)
    $btnRefresh.Size = New-Object System.Drawing.Size(100, 30)
    $btnRefresh.Text = "Refresh"
    
    $btnDelete = New-Object System.Windows.Forms.Button
    $btnDelete.Location = New-Object System.Drawing.Point(240, 70)
    $btnDelete.Size = New-Object System.Drawing.Size(100, 30)
    $btnDelete.Text = "Delete"

    $btnEdit = New-Object System.Windows.Forms.Button
    $btnEdit.Location = New-Object System.Drawing.Point(350, 70)
    $btnEdit.Size = New-Object System.Drawing.Size(100, 30)
    $btnEdit.Text = "Edit"

    
    # Add Datagridview
    $dataGridView = New-Object System.Windows.Forms.DataGridView
    $dataGridView.Location = New-Object System.Drawing.Point(20, 120)
    $dataGridView.Size = New-Object System.Drawing.Size(550, 200)
    $dataGridView.AllowUserToAddRows = $false
    $dataGridView.ColumnCount = 5
    $dataGridView.Columns[0].Name = "SystemName"
    $dataGridView.Columns[1].Name = "IPAddress"
    $dataGridView.Columns[2].Name = "UserName"
    $dataGridView.Columns[3].Name = "Password"
    $dataGridView.Columns[4].Name = "EncryptedPassword"
    $dataGridView.Columns["EncryptedPassword"].Visible = $false # Set the "Actual Password" column to be hidden
    
    # Add all controls to the form, otherwise it will be blank
    $form.Controls.AddRange(@($lblSystemName, $txtSystemName, $lblIPAddress, $txtIPAddress, $btnAdd, $btnRefresh, $btnDelete, $dataGridView, $statusBar))
    $form.Controls.AddRange(@($lblSystemName, $txtSystemName, $lblIPAddress, $txtIPAddress, $btnAdd, $btnRefresh, $btnDelete, $btnEdit, $dataGridView, $statusBar))

    
    #############################
    #### Functions Region 
    #############################

    # Load existing input data from file
    function Load_Secrets {
        $dataGridView.Rows.Clear()
        $existingData = Get-Content -Raw -Path $SecretFile | ConvertFrom-Json
        if ($existingData) {
            foreach ($item in $existingData) {
                $systemName = $item.SystemName
                $ipaddress = $item.IPAddress
                $userName = $item.UserName
                $password = "********"  # Masked password value
                $actualPassword = $item.Password
                $dataGridView.Rows.Add($systemName, $ipaddress, $userName, $password, $actualPassword) | out-null
            }
        }
    }
    
    Function Add_NewSecret($systemName = $txtSystemName.Text) {
        if ($systemName) {
            $credentials = Get-Credential
            $secretObject = [ordered]@{
                "ID" = "$(Get-Date -Format "yymmddHHmm")$(Get-Random -Minimum 100 -maximum 999)"
                "SystemName" = $systemName
                "IPAddress"  = $txtIPAddress.Text
                "UserName"   = $credentials.UserName
                "Password"   = $credentials.Password | ConvertFrom-SecureString
            }
            try {
                Save_Secrets($secretObject)
                Load_Secrets
                StatusMsg("Added username and password to secret file...")
                $txtSystemName.Text = $null
                $txtIPAddress.Text = $null
            } 
            catch {
                StatusMsg("Unable to add new data to secrets ...")
            }
        }
        else {
            StatusMsg("System name is required...")
        }
        Load_Secrets
    }
    
    # Save New Secret, Append to JSON file
    Function Save_Secrets($newSecret) {
        $existingData = Get-Content -Raw -Path $script:SecretFile | ConvertFrom-Json
        $existingData = @($existingData) + @($newSecret)
        $existingData | ConvertTo-Json | Out-File -FilePath $script:SecretFile -Encoding UTF8
    }
    
    function DecryptSecret($password) {

        Try {
            $secureString = $password | ConvertTo-SecureString
            $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString)
            $plaintextPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
            $plaintextPassword | Set-Clipboard
            StatusMsg("Password copied to clipboard.")
        }
        catch {
            StatusMsg("Decryption Failed. $($Error[0].Exception)")
        }
    
    }
    
    Function Delete_Secret {
    
        if ($dataGridView.SelectedCells.Count -gt 0) {
            $selectedCell = $dataGridView.SelectedCells[0]
            $selectedRow = $dataGridView.Rows[$selectedCell.RowIndex]
    
            $systemName = $selectedRow.Cells[0].Value
    
            # Show confirmation dialog
            $confirmResult = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to delete the secret for '$systemName'?", "Confirmation", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Warning)
    
            if ($confirmResult -eq "Yes") {
                $existingData = Get-Content -Raw -Path $script:SecretFile | ConvertFrom-Json
                $existingData = $existingData | Where-Object { $_.SystemName -ne $systemName }
                $existingData | ConvertTo-Json | Out-File -FilePath $script:SecretFile -Encoding UTF8
    
                Load_Secrets
                StatusMsg("'$systemName' data deleted.")
            }
        }
    }

    Function Edit_Secret {



        if ($dataGridView.SelectedCells.Count -gt 0) {
            $selectedCell = $dataGridView.SelectedCells[0]
            $selectedRow = $dataGridView.Rows[$selectedCell.RowIndex]
    
            # Get the existing values of the selected row
            $systemName = $selectedRow.Cells[0].Value
            $ipAddress = $selectedRow.Cells[1].Value

            # Show a dialog to allow editing of the values
            $editForm = New-Object System.Windows.Forms.Form
            $editForm.Text = "Edit Secret"
            $editForm.Size = New-Object System.Drawing.Size(320, 220)
            $editForm.StartPosition = "CenterScreen"
   
            function Add-DynamicFormControl {
                param(
                    [Parameter(Mandatory = $true)][System.Windows.Forms.Form]$Form,
                    [Parameter(Mandatory = $true)][string]$ControlType,
                    [Parameter(Mandatory = $true)][string]$ControlName,
                    [Parameter(Mandatory = $true)][int]$Left,
                    [Parameter(Mandatory = $true)][int]$Top,
                    [int]$Width = 100,
                    [int]$Height = 20,
                    [string]$Text = ""
                )
                Add-Type -AssemblyName System.Windows.Forms
                Add-Type -AssemblyName System.Drawing
                            
                # Create the form control object based on the control type
                $control = New-Object "System.Windows.Forms.$ControlType"
                $control.Name = $ControlName
                $control.Location = New-Object System.Drawing.Point($Left, $Top)
                $control.Width = $Width
                $control.Height = $Height
                $control.Text = $Text
            
                # Create a hashtable or custom object to hold the control's value
                $value = @{ Name = $ControlName; Control = $control; Value = $null }
            
                # Add the control and its value to the form
                $editForm.Controls.Add($control)
                $editForm.Tag = $Form.Tag + $value
            }



            Add-DynamicFormControl -Form $editForm -ControlType "Label" -ControlName "lblEditSystemName" -Left 20 -Top 20 -Text "System Name:"

            Add-DynamicFormControl -Form $editForm -ControlType "Text" -ControlName "txtEditSystemName" -Left 120 -Top 20 -Text "$systemName"
    
            Add-DynamicFormControl -Form $editForm -ControlType "Text" -ControlName "lblEditIPAddress" -Left 20 -Top 50 -Text "IP Address:"

            Add-DynamicFormControl -Form $editForm -ControlType "Text" -ControlName "txtEditIPAddress" -Left 120 -Top 50 -Text "$ipAddress"
    
              $lblEditUsername = New-Object System.Windows.Forms.Label
            $lblEditUsername.Location = New-Object System.Drawing.Point(20, 80)
            $lblEditUsername.Text = "Username:"
            $editForm.Controls.Add($lblEditUsername)

            $txtEditUsername = New-Object System.Windows.Forms.TextBox
            $txtEditUsername.Location = New-Object System.Drawing.Point(120, 80)
            $txtEditUsername.Size = New-Object System.Drawing.Size(160, 20)
            $txtEditUsername.Text = $selectedRow.Cells[2].Value
            $editForm.Controls.Add($txtEditUsername)

            $lblEditPassword = New-Object System.Windows.Forms.Label
            $lblEditPassword.Location = New-Object System.Drawing.Point(20, 110)
            $lblEditPassword.Text = "Password:"
            $editForm.Controls.Add($lblEditPassword)

            $txtEditPassword = New-Object System.Windows.Forms.TextBox
            $txtEditPassword.Location = New-Object System.Drawing.Point(120, 110)
            $txtEditPassword.Size = New-Object System.Drawing.Size(160, 20)
            $txtEditPassword.Text = $selectedRow.Cells[3].Value
            $editForm.Controls.Add($txtEditPassword)
            
            $btnSave = New-Object System.Windows.Forms.Button
            $btnSave.Location = New-Object System.Drawing.Point(120, 140)
            $btnSave.Size = New-Object System.Drawing.Size(75, 23)
            $btnSave.Text = "Save"

            $editForm.Controls.Add($btnSave)
    
            $editForm.ShowDialog()
        }
    }
        
    function StatusMsg($msg) {
        $statusLabel.Text = $msg
        Start-Sleep -Seconds 2
        $statusLabel.Text = ""
    }
    
    #############################
    ### Form Events Region
    #############################
    
    $btnAdd.Add_Click({ Add_NewSecret($txtSystemName.Text) })
    
    $btnRefresh.Add_Click({ Load_Secrets })
    
    $btnDelete.Add_Click({ Delete_Secret })

    $btnEdit.Add_Click({ Edit_Secret })

    
    # Add double-click event for copying password to clipboard
    $dataGridView.Add_CellDoubleClick({

            if ($dataGridView.SelectedCells.Count -gt 0) {
            
                $selectedCell = $dataGridView.SelectedCells[0]
                $columnName = $selectedCell.OwningColumn.Name
            
                switch ($columnName) {
                    "Password" {
                        $selectedRow = $dataGridView.Rows[$selectedCell.RowIndex]
                        $actualPassword = $selectedRow.Cells[4].Value
                        DecryptSecret($actualPassword)
                    }
                    "UserName" {
                        $selectedRow = $dataGridView.Rows[$selectedCell.RowIndex]
                        $UserName = $selectedRow.Cells[2].Value
                        $UserName | Set-Clipboard
                        StatusMsg("'$($selectedRow.Cells[0].Value)' Username copied to clipboard...")

                    }
                    "IPAddress" {
                        $selectedRow = $dataGridView.Rows[$selectedCell.RowIndex]
                        $IPAddress = $selectedRow.Cells[1].Value
                        $IPAddress | Set-Clipboard
                        StatusMsg("''$($selectedRow.Cells[0].Value)'' IPAddress copied to clipboard...")
                    }
                    "SystemName" {
                        # PlaceHolder. Code for editing properties.
                    }   
                }
            }
        })
    
    #############################
    ### Initialize Form
    #############################

    if (Test-Path $script:SecretFile) {
        $existingData = Get-Content -Raw -Path $script:SecretFile | ConvertFrom-Json
    }
    else {
        $existingData = @()
        $existingData | ConvertTo-Json | Out-File -FilePath $script:SecretFile -Encoding UTF8
    }

    # Display the form
    Load_Secrets
    $form.ShowDialog()
    
}
