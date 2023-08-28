# PUG Beginner/Intermediate Series - "Helper CommandLets"

## Topics Covered:
1. Using VSCode as scripting environment (for real this time)
2. Let's talk about the pipeline
3. "Helper" Commandlets
4. Working with CSV files

## About the Pipeline

https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_pipelines?view=powershell-7.3

In PowerShell, a pipeline is a series of commands connected by pipeline operator/s. It is inspired by and based on the concept of a pipeline in Unix shells, which allows multiple commands to be chained together with the output of the previous command being piped to the input of the next. 

In unix/linux, command outputs are text-based, so commands in a pipeline are hardcoded to parse the output of the previous command. User control over the output is limited to the command's options and parameters.

In PowerShell, the pipeline is object-based, so the output of a command is an object that can be passed to the next command in the pipeline. This allows for much more flexibility and control over the output.

```
Command-1 | Command-2 | Command-3
```
For example:

```
Get-ChildItem -Path C:\temp\* -Recurse| Where-Object {$_.Length -gt 1MB} | Sort-Object -Property Length -Descending | Format-Table -Property Length,FullName
```

Or, using aliases:

```
gci C:\temp\* -r | ? {$_.Length -gt 1MB} | Sort Length -d | ft Length,FullName
```

`Get-ChildItem` is the primary commandlet that generates the objects that can be sent down the pipeline.

`Where-Object` is a filtering cmdlet for selecting objects that meet a criteria or condition.

`Sort-Object` sorts the objects by the specified property.

`Format-Table` formats the output as a table that displays the name and length properties of each object.

## Helper Commandlets (alias in parenthesis)

These commandlets are useful for inspecting, filtering, sorting, selecting, formatting, grouping, exporting, importing, etc.. They do not produce any output on their own, but rather, they are used to modify the output of other commandlets.

### Inspecting/Interrogating
- Get-Member (`gm`)
- Select-Object (`select`)
- Format-List (`fl`)

### Filtering
- Where-Object (`?`)

### Sorting
- Sort-Object (`sort`)

### Selecting
- Select-Object (`select`)

### Formatting
- Format-List (`fl`)
- Format-Table (`ft`)

### Grouping
- Group-Object (`group`)

### Exporting
- Out-File 
- Export-CSV (`epcsv`)
- Out-GridView (`ogv`) 

### Importing
- Get-Content (`gc`)
- Import-CSV (`ipcsv`)
- ConvertFrom-CSV (`cfcsv`)

## Scenario One

We have a customer complaining that their Citrix application is stuck. There's an error pop-up window that they're unable to close. We need to find the process that is associated with the window and kill it.

### Step 1. Let's collect a list of running processes using `Get-Process` and assign it to a variable `$p`

```
$p = Get-Process
$p
```

Note: Assigning the result of a commandlet to a variable is like taking a snapshot of the data at that point in time. This is useful when you want to perform multiple operations on the same data. It is also less taxing on the system than re-running the commandlet multiple times.

If you need to refresh the set of data, you will need to re-run the commandlet, e.g., `$p = gps`

### Step 2. Let's "interrogate" the objects in the array. Let's see what properties are available for each process object. 
<br>

- Use `Get-Member -Force` to see all the properties of an object, including hidden properties, but actual property values will not be displayed only Names, e.g., `$p | gm` or `$p | gm -f`

- Use `Select-Object -Property *` to see all the property values of an object and you still intend to pipe the object to another commandlet, or create custom properties, e.g., `$p | Select-Object -First 1 -Property *` or `$p | select -f 1 -p *`

- Use `Format-List -Property *` to see all the properties of an object, but "read-only", so you cannot pipe the object to another commandlet, or create custom properties. Slightly quicker to type when using the alias `fl *` e.g., `$p[10] | fl *`

Tip: When working with arrays, you can use the index operator `[ ]` to access a specific object in the array. The index starts at 0, so the first object in the array is `$p[0]`, the second object is `$p[1]`, etc.. 

```
$p[5] | select *
$p[32] | fl *

Name                       : brave
Id                         : 24200
PriorityClass              : Normal
FileVersion                : 114.1.52.129
HandleCount                : 237
Handles                    : 237
Path                       : C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe
ProductVersion             : 114.1.52.129
Description                : Brave Browser
Product                    : Brave Browser
__NounName                 : Process
BasePriority               : 8
ExitCode                   :
HasExited                  : False
ExitTime                   :
Handle                     : 5624
Responding                 : True
SessionId                  : 2
StartInfo                  : System.Diagnostics.ProcessStartInfo
StartTime                  : 7/4/2023 4:10:06 PM
Threads                    : {18716, 18464, 10840, 22704...}
UserProcessorTime          : 00:00:00.2343750
VirtualMemorySize64        : 2306838650880
EnableRaisingEvents        : False
WorkingSet64               : 24428544
```
*(Redacted results for training purposes..there're additional properties)*

Let's hone in on the Name and Path properties.

### Step  3. Filter do some filtering.

Let's filter the array of processes to only show objects that contain the word "Citrix" in the Name property.

```
$p | Where-Object {$_.ProcessName -like "*Citrix*"}
```

No results. 

Well, what about querying the Path property instead. 

```
$p | Where-Object {$_.Path -like "*Citrix*"}

Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
-------  ------    -----      -----     ------     --  -- -----------
    425      29     7816      28016       0.84   1724   2 AuthManSvr
    369      26     9920      22048       0.00  21748   2 concentr
    890      52    20136      44320      12.11  10512   2 Receiver
   1155      78    78488     126944       1.94  23908   2 SelfService
    693      45    23324      47156       0.45  10380   2 SelfServicePlugin
    398      31     6708      23280       0.05  16876   2 wfcrun32

```
### Step 4. Kill the processes

So, now that we have a method for finding out which processes are associated with the Citrix application, we can kill them.

```
# Gentler method
$p | Where-Object {$_.Path -like "*Citrix*"} | Stop-Process -Force

# More aggressive method
$p |? {$_.Path -like "*Citrix*"} | kill -f
```

## Scenario Two

In this scenario, one of our servers is running low on disk space. We need to find out which files are taking up the most space.

### Step  1. Let's collect a list of files and assign it to a variable `$files`. 

```
$path = "C:\Temp"
$files = Get-ChildItem -Path $path -Recurse

# Alias: 
# $files = gci $path -r
```

### Step  2. Let's apply a bit of filtering to the array of files to only show files that are greater than 1MB in size.

```
$files | Where-Object {$_.Length -gt 1MB}

# Alias:
# $files | ? {$_.Length -gt 1MB}
```

### Step  3. Let's sort the array of files by the Length property in descending order.

```
$files | Where-Object {$_.Length -gt 1MB} | Sort-Object -Property Length -Descending

# Alias:
# $files | ? {$_.Length -gt 1MB} | sort Length -d
```

### Step  4. Let's select only the Length and FullName properties of each file object, and just the first 10

```
$files | Where-Object {$_.Length -gt 1MB} | Sort-Object -Property Length -Descending | Select-Object -Property Length,FullName -First 10 

# Alias:
# $files | ? {$_.Length -gt 1MB} | sort Length -d | select Length,FullName -f 10
```

### Step  5. Let's format the output as a table.

```
$files | Where-Object {$_.Length -gt 1MB} | Sort-Object -Property Length -Descending | Select-Object -Property Length,FullName -f 10 | Format-Table -Property Length,FullName

# Alias:
# $files | ? {$_.Length -gt 1MB} | sort Length -d | ft Length,FullName
# or, $files | ? {$_.Length -gt 1MB} | sort Length -d | select Length,FullName -f 10 | ft Length,FullName
```

Tip! By using Select-Object, we are only selecting the properties we want to display, which can be helpful for performance reasons.

### Step  6. Let's export the output to a CSV file for documentation purposes.

```
$files | Where-Object {$_.Length -gt 1MB} | Sort-Object -Property Length -Descending | Select-Object -Property Length,FullName | Export-CSV -Path C:\Temp\LargeFiles.csv -NoTypeInformation

# Alias:
# $files | ? {$_.Length -gt 1MB} | sort Length -d | select Length,FullName | epcsv C:\Temp\LargeFiles.csv -NoType
```

### Step  7. Delete the files

```
$bigfiles = $files | Where-Object {$_.Length -gt 1MB} | Sort-Object -Property Length -Descending | Select-Object -Property Length,FullName

$bigfiles | ForEach-Object {Remove-Item -Path $_.FullName -Force}

# Alias:
# $bigfiles | % {rm $_.FullName -f}
```

Alternatively, we could import the CSV file generated in step 6, and pipe the objects to the ForEach-Object and Remove-Item cmdlets.

```
$bigfiles = Import-CSV -Path C:\Temp\LargeFiles.csv
$bigfiles | ForEach-Object {Remove-Item -Path $_.FullName -Force}
```

Extra: 
According to ChatGPT, this would be the equivalent command in unix/linux: (Untested)

```
find /path/to/directory -type f -size +1M -exec ls -lh {} + | awk '{print $5 "\t" $9}'
```

# Scenario Three

We need to 
