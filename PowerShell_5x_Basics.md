# PowerShell 5.1 Basics | Part I 

## Equivalents

| PowerShell Cmdlet    | Purpose                        | Windows Command Equivalent | Linux Equivalent  |
|----------------------|--------------------------------|----------------------------|-------------------|
| Get-Process          | Get process information        | tasklist                   | ps                |
| Get-Service          | Get service information        | sc query                   | systemctl        |
| Get-ChildItem        | Get files and directories      | dir                        | ls                |
| Set-Location         | Change current location        | cd                         | cd                |
| Get-Content          | Get content of a file          | type                       | cat               |
| Set-Content          | Set content of a file          | echo                       | echo              |
| Copy-Item            | Copy files and directories     | copy                       | cp                |
| Remove-Item          | Remove files and directories   | del                        | rm                |
| New-Item             | Create a new item (file)       | type or echo               | touch             |
| New-Item             | Create a new item (directory)  | mkdir                      | mkdir             |
| Rename-Item          | Rename an item                 | ren                        | mv                |
| Invoke-WebRequest    | Send HTTP requests             | curl                       | curl              |
| Test-Connection      | Test network connectivity      | ping                       | ping              |
| Start-Process        | Start a process                | start                      | NONE              |
| Stop-Process         | Stop a process                 | taskkill                   | NONE              |
| Get-EventLog         | Get event log information      | Get-EventLog               | journalctl        |
| Get-WmiObject        | Get WMI object information     | wmic                       | NONE              |
| Write-Host           | Write output to the console    | echo                       | echo              |
| Get-Help             | Get help for cmdlets           | help                       | man               |
| Get-Command          | Get available commands         | help                       | help              |


## Getting Help
- Get-Command (gcm): List available commands.
  **Example:** `Get-Command -Module ActiveDirectory` or `gcm -Module ActiveDirectory`
- Get-Help (man): Get help for PowerShell itself.
  **Example:** `Get-Help about_Variables` or `man about_Variables`
- Get-Help <cmdlet> (help): Get help for a specific cmdlet.
  **Example:** `Get-Help Get-Process` or `help Get-Process`

## Working with Objects
- Get-Process (gps): Get running processes.
  **Example:** `Get-Process` or `gps`
- Get-Service (gs): Get system services.
  **Example:** `Get-Service -DisplayName "Print Spooler"` or `gs -DisplayName "Print Spooler"`
- Get-ChildItem (gci): List files and directories.
  **Example:** `Get-ChildItem C:\` or `gci C:\`
- Select-Object (select): Select specific properties of objects.
  **Example:** `Get-Process | Select-Object Name, CPU` or `gps | select Name, CPU`
- Sort-Object (sort): Sort objects by property.
  **Example:** `Get-Service | Sort-Object Status` or `gs | sort Status`
## Working with Variables
- $variable = <value>`: Assign a value to a variable.
  **Example:** `$name = "John"`
- Get-Variable (gv): List defined variables.
  **Example:** `Get-Variable` or `gv`
- Remove-Variable (rv): Remove a variable.
  **Example:** `Remove-Variable name` or `rv name`
## Working with Files
- Set-Location (cd): Change current directory.
  **Example:** `Set-Location C:\Scripts` or `cd C:\Scripts`
- Get-Content (gc): Read the content of a file.
  **Example:** `Get-Content file.txt` or `gc file.txt`
- Set-Content (sc): Write content to a file.
  **Example:** `"Hello, world!" | Set-Content file.txt` or `"Hello, world!" | sc file.txt`
- Rename-Item (ren): Rename a file or directory.
  **Example:** `Rename-Item file.txt newfile.txt` or `ren file.txt newfile.txt`
- Remove-Item (ri): Remove a file or directory.
  **Example:** `Remove-Item file.txt` or `ri file.txt`

# PowerShell 5.1 Basics | Part 2

## Filtering and Searching
- Where-Object (where): Filter objects based on a condition.
  **Example:** `Get-Process | Where-Object {$_.CPU -gt 50}` or `gps | where {$_.CPU -gt 50}`
- Select-String (sls): Search for text in files or strings.
  **Example:** `Get-Content file.txt | Select-String "error"` or `gc file.txt | sls "error"`
- Compare-Object (compare): Compare two sets of objects.
  **Example:** `Compare-Object $list1 $list2` or `compare $list1 $list2`

## Working with Modules
- Import-Module (ipmo): Import a PowerShell module.
  **Example:** `Import-Module ActiveDirectory` or `ipmo ActiveDirectory`
- Get-Module (gmo): List loaded modules.
  **Example:** `Get-Module` or `gmo`
- Remove-Module (rm): Remove a loaded module.
  **Example:** `Remove-Module ActiveDirectory` or `rm ActiveDirectory`
## Remote Management
- Enter-PSSession (etsn): Start an interactive session with a remote computer.
  **Example:** `Enter-PSSession -ComputerName Server01` or `etsn -ComputerName Server01`
- Invoke-Command (icm): Run a command on a remote computer.
  **Example:** `Invoke-Command -ComputerName Server01 -ScriptBlock { Get-Service }` or `icm -ComputerName Server01 -ScriptBlock { Get-Service }`
- Copy-Item (cp): Copy files and directories to a remote computer.
  **Example:** `Copy-Item C:\file.txt -Destination \\Server01\Share` or `cp C:\file.txt \\Server01\Share`
## Scripting
- Set-ExecutionPolicy (Set-ExecutionPolicy): Set the script execution policy.
  **Example:** `Set-ExecutionPolicy RemoteSigned` or `Set-ExecutionPolicy RemoteSigned`
- Get-ExecutionPolicy (Get-ExecutionPolicy): Get the current script execution policy.
  **Example:** `Get-ExecutionPolicy` or `Get-ExecutionPolicy`
- .\script.ps1`: Execute a PowerShell script.
  **Example:** `.\myscript.ps1`

## Control Flow
- if(condition) { ... }`: If statement.
  **Example:** `if($x -gt 5) { "Greater than 5" }`
  **Example:**
  ``` 
  if() { ... 
    } elseif() { ... 
    } else { ... 
    }
  ```
- switch(variable) { ... }`: Switch statement.
  **Example:** 
  ```
  switch($day) { 
    "Monday" { "Start of the week" } 
    "Friday" { "End of the week" } 
    }
  ```
- foreach(variable in list) { ... }`: Foreach loop.
  **Example:** 
  ```
  foreach($item in $list) {
     "Processing: $item" 
     }
  ```

- while(condition) { ... }`: While loop.
  **Example:** `$i = 0; while($i -lt 5) { "Iteration: $i"; $i++ }`
