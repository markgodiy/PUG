function PSPasswordManager {
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Check for existing data
$script:SecretFile = $(Join-Path $env:APPDATA "Secrets.json")

if (Test-Path $script:SecretFile) {
    $existingData = Get-Content -Raw -Path $script:SecretFile | ConvertFrom-Json
} else {
    $existingData = @()
    $existingData | ConvertTo-Json | Out-File -FilePath $script:SecretFile -Encoding UTF8
}

# Create the main form and controls
$form = New-Object System.Windows.Forms.Form
$form.Text = "PowerShell - Password Manager"
$form.Size = New-Object System.Drawing.Size(600, 400)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# Create a status bar
$statusBar = New-Object System.Windows.Forms.StatusStrip
$statusLabel = New-Object System.Windows.Forms.ToolStripStatusLabel
$statusBar.Items.Add($statusLabel)

$lblSystemName = New-Object System.Windows.Forms.Label
$lblSystemName.Location = New-Object System.Drawing.Point(20, 20)
$lblSystemName.Size = New-Object System.Drawing.Size(100, 20)
$lblSystemName.Text = "System Name:"

$txtSystemName = New-Object System.Windows.Forms.TextBox
$txtSystemName.Location = New-Object System.Drawing.Point(120, 20)
$txtSystemName.Size = New-Object System.Drawing.Size(200, 20)
$txtSystemName.Text = ""

$btnAdd = New-Object System.Windows.Forms.Button
$btnAdd.Location = New-Object System.Drawing.Point(20, 70)
$btnAdd.Size = New-Object System.Drawing.Size(100, 30)
$btnAdd.Text = "Add"

# Create a button to save the input array
$btnRefresh = New-Object System.Windows.Forms.Button
$btnRefresh.Location = New-Object System.Drawing.Point(130, 70)
$btnRefresh.Size = New-Object System.Drawing.Size(100, 30)
$btnRefresh.Text = "Refresh"

# Create a button to save the input array
$btnDelete = New-Object System.Windows.Forms.Button
$btnDelete.Location = New-Object System.Drawing.Point(240, 70)
$btnDelete.Size = New-Object System.Drawing.Size(100, 30)
$btnDelete.Text = "Delete"

# Create a DataGridView control
$dataGridView = New-Object System.Windows.Forms.DataGridView
$dataGridView.Location = New-Object System.Drawing.Point(20, 120)
$dataGridView.Size = New-Object System.Drawing.Size(550, 200)
$dataGridView.AllowUserToAddRows = $false
$dataGridView.ColumnCount = 4
$dataGridView.Columns[0].Name = "System Name"
$dataGridView.Columns[1].Name = "User Name"
$dataGridView.Columns[2].Name = "Password"
$dataGridView.Columns[3].Name = "Actual Password"
# Set the "Actual Password" column to be hidden
$dataGridView.Columns["Actual Password"].Visible = $false

$form.Controls.AddRange(@($lblSystemName, $txtSystemName, $btnAdd, $btnRefresh,$btnDelete, $dataGridView,$statusBar))

# Load existing input data from file
function Load_Secrets {
    $dataGridView.Rows.Clear()
    $existingData = Get-Content -Raw -Path $SecretFile | ConvertFrom-Json
    if ($existingData) {
        foreach ($item in $existingData) {
            $systemName = $item.SystemName
            $userName = $item.UserName
            $password = "********"  # Masked password value
            $actualPassword = $item.Password
            $dataGridView.Rows.Add($systemName, $userName, $password, $actualPassword) | out-null
        }
    }
}

# Functions
Function Add_NewSecret($systemName = $txtSystemName.Text) {
    if ($systemName) {
        $credentials = Get-Credential
        $secretObject = @{
            "SystemName" = $systemName
            "UserName"   = $credentials.UserName
            "Password"   = $credentials.Password | ConvertFrom-SecureString
        }
        Save_Secrets($secretObject)
        Load_Secrets
        StatusMsg("Added username and password to secret file...")
        $txtSystemName.Text = $null
    } else {
        StatusMsg("SystemName is required...")
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
    $secureString = $password | ConvertTo-SecureString
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString)
    $plaintextPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    $plaintextPassword | Set-Clipboard
    StatusMsg("Password copied to clipboard.")
}

Function Delete_Secret {

    if ($dataGridView.SelectedCells.Count -gt 0) {
        $selectedCell = $dataGridView.SelectedCells[0]
        $selectedRow = $dataGridView.Rows[$selectedCell.RowIndex]

        $systemName = $selectedRow.Cells[0].Value

        # Show confirmation dialog
        $confirmResult = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to delete the secret for '$systemName'?", 
            "Confirmation", 
            [System.Windows.Forms.MessageBoxButtons]::YesNo, 
            [System.Windows.Forms.MessageBoxIcon]::Warning
            )

        if ($confirmResult -eq "Yes") {
            $existingData = Get-Content -Raw -Path $script:SecretFile | ConvertFrom-Json
            $existingData = $existingData | Where-Object { $_.SystemName -ne $systemName }
            $existingData | ConvertTo-Json | Out-File -FilePath $script:SecretFile -Encoding UTF8

            Load_Secrets
            StatusMsg("Secret for '$systemName' deleted.")
        }
    }
}

function StatusMsg($msg){
    $statusLabel.Text = $msg
    Start-Sleep -Seconds 2
    $statusLabel.Text = ""
}

### Form Events

$btnAdd.Add_Click({ Add_NewSecret($txtSystemName.Text) })

$btnRefresh.Add_Click({
    Load_Secrets
})

$btnDelete.Add_Click({ Delete_Secret })

# Add double-click event for copying password to clipboard
$dataGridView.Add_CellDoubleClick({
    if ($dataGridView.SelectedCells.Count -gt 0) {
        $selectedCell = $dataGridView.SelectedCells[0]
        $columnName = $selectedCell.OwningColumn.Name
        if ($columnName -eq "Password") {
            $selectedRow = $dataGridView.Rows[$selectedCell.RowIndex]
            if ($selectedRow) {
                $actualPassword = $selectedRow.Cells[3].Value
                DecryptSecret($actualPassword)
            }
        }
    }
})


# Populate grid 
Load_Secrets

# Display the form
$form.ShowDialog()

}