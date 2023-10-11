# PUG: Beginner PowerShell Script Writing Series

Objective: 
Write a script that will:
1. Import Data
2. Process Data and create custom properties
3. Export Data

PreRequisites:
1. Alt Token for code signing
2. Files:
    - Zip file with practice datasets

## Topics covered

1. Script Execution and Security
    - `Set-ExecutionPolicy`
        - RemoteSigned
        - AllSigned
        - Restricted
    - Code Signing
        - Get Code Signing Certificate (alt token)  
        - AuthenticodeSignature

2. Object-Oriented Scripting
    - Text/String output
    - `Get-Member`

3. "Anatomy" of a simple .PS1 script
    - Functions

4. Importing Data
    - File Formats
        - Text = `Get-Content`
        - CSV = `Import-CSV`, `Convertfrom-CSV`
        - JSON = `Convertfrom-JSON`
        - XML = `Import-Clixml`
    - Popular 3rd Party module, `Import-Excel`

5. Processing Data
    - Variables
    - Arrays
    - `Foreach-Object` cmdlet
    - `Foreach()` statement
    - `Select-Object` CustomProperties
    - PsCustomObjects
    - Regular Expressions

6. Exporting Data
    - `Out-*`
    - `Export-*`
    - `ConvertTo-*`
    - Sending by Email

------------------------------

### Script Execution and Security
- `Set-ExecutionPolicy`
    - RemoteSigned
    - AllSigned
- Code Signing
    - Get Code Signing Certificate (alt token) 
    - `Set-AuthenticodeSignature`

https://www.informit.com/articles/article.aspx?p=729101&seqNum=7

### Anatomy of a simple .ps1 script:

```
# Step 1: Define parameters (optional)
param (
    [string]$InputFilePath = "data.csv"
)

# Step 2: Import data from a CSV file
$data = Import-Csv -Path $InputFilePath

# Step 3: Process custom properties (e.g., calculate a new property)
$processedData = $data | ForEach-Object {
    $item = $_
    $customProperty = $item.Property1 + $item.Property2  # Example custom property calculation
    $item | Add-Member -MemberType NoteProperty -Name "CustomProperty" -Value $customProperty
    $item  # Return the modified item
}

# Step 4: Return the processed data as an array
$processedData
```
