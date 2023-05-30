# PowerShell Tips and Tricks

## TAB Completion

1. **CmdLet Prediction** Start typing a partial name of a Cmdlet, then hit the TAB key to cycle through the options available. 

    BonusTip: `Up Arrow` to repeat the last command.

2. **CmdLet Parameter Prediction and Browsing** When typing a parameter or the value for a parameter, you can also hit the TAB key to cycle through the options available.

    BonusTip: `CTRL+SpaceBar` to display all available parameter options.

3. **Filename/path Prediction** Tab completion also works for file names and file paths.

*Note: In order to predict your intent, PowerShell first needs to collect local system information. This initialization process can take some time and PowerShell may appear frozen or unresponsive.*

## CmdLet Aliases 

Learning and using common cmdlet aliases increases efficiency. 

However -- Aliases are detrimental to script readability, therefore, it is generally recommend to write the full cmdlet names in scripts.

1. To search if your favorite alias is available in PowerShell:
```
Get-Alias | Where {$_.Name -like 'cd'}

CommandType     Name         
-----------     ----         
Alias           cd -> Set-Location
```

2. To search if a command has an alias:
```
Get-Alias | where {$_.ReferencedCommand -like 'Export-CSV'}

CommandType     Name        
-----------     ----        
Alias           epcsv -> Export-Csv
```

```
$a = 'Get-ChildItem -Path "C:\Users\MyUser\Documents" | Where-Object { $_.Name -like "*.txt" } | Select-Object Name, Length | Sort-Object -Property Length -Descending | Export-Csv -Path "C:\Users\MyUser\Documents\files.csv" -NoTypeInformation'

$b = 'gci "C:\Users\MyUser\Documents" | ? { $_.Name -like "*.txt" } | select Name, Length | sort Length -Descending | epcsv "C:\Users\MyUser\Documents\files.csv" -NoType'

$a.Length - $b.Length

```

Bonus Tip: Check out the help file for `Set-Alias`, if you'd like to create your own custom aliases

## Regular Expressions

Using pattern matching and Regular Expressions (regex) further extends the versatility of PowerShell. 

(Great site for composing and testing regex: https://www.regex101.com/)

1. Make scripts more efficient. To search if your favorite alias is available in PowerShell, with and without regex:
```
Get-Alias | Where {$_.Name -like '*cd*' -or $_.Name -like '*dir*' -or $_.Name -like '*ls*'}

Get-Alias | Where {$_.Name -match 'cd|dir|ls'}

CommandType     Name   
-----------     ----   
Alias           cd -> Set-Location
Alias           chdir -> Set-Location
Alias           cls -> Clear-Host
Alias           dir -> Get-ChildItem
Alias           ls -> Get-ChildItem
Alias           rmdir -> Remove-Item
Alias           sls -> Select-String
```
2. Validate IP Address by pattern matching

```
$ipregex = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"

$ip = @('192.168.1.300','192.168.1.3') 

$ip | Foreach-Object {if ($_ -match $ipregex) {echo "$_ : Valid"} else {echo "$_ : Invalid"}
}
```

3. Extract Text
```
$emailregexpattern = "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b"
$text = "My email is john@example.com"
$email = [regex]::Match($text, $emailregexpattern).Value
Write-Output "Extracted email: $email"
```

## Double-quotes and Single-quotes

1. **Double-Quotes** String values wrapped in double-quotes are evaluated before processing.

2. **Single-Quotes** In contrast, string values wrapped in single-quotes will be processed as-is.

```

Write-Output "$env:AppData"
# Result will be: C:\Users\user1\AppData\Roaming


Write-Output '$env:AppData'
# Result will be: $env:AppData
```

## Interrogating/Exploring Objects and Properties

1. Get-Member (`gm`) - displays various methods, types, and properties of an object, but does not display property values. Displays "hidden" properties when used with `-Force` parameter. 

 ```

(Get-Service)[0] | Get-Member
    
    TypeName: System.ServiceProcess.ServiceController
Name                      MemberType    Definition
----                      ----------    ----------
Name                      AliasProperty Name = ServiceName
Close                     Method        void Close()
DisplayName               Property      string DisplayName {get;set;}
ToString                  ScriptMethod  System.Object ToString();
```


2. Select-Object (`select`) - displays properties and values, allows pipeline passthru

```

(Get-Service)[0] | Select-Object *

Name                : AarSvc_9e257
RequiredServices    : {}
CanPauseAndContinue : False
CanShutdown         : False
CanStop             : False
DisplayName         : Agent Activation Runtime_9e257
...

```

3. Format-List (`fl`) - quicker to type, displays properties and values like `Select-Object`, but does not allow pipeline passthru

    **`$object | Format-List *`**

## Intrinsic Behaviors

`$_.Count` and `$_.Length` are automatic built-in properties in PowerShell. Particularly useful when processing data list and arrays. 

## PowerShell Custom Objects

 PowerShell supports PSCustomObject which allows you to define custom object properties. It provides a way to structure and organize data in a convenient and flexible manner. You can use PSCustomObject to define and manipulate data within functions or scripts. Here's an example of using PSCustomObject within a function:

 ```
 Function Get-User {
    $user = [PSCustomObject]@{
        Name = "John Doe"
        Age = 30
        Email = "johndoe@example.com"
    }
    return $user
}

Get-User
```

## Calculated Expressions 

Calculated expressions allow you to perform calculations or transformations on properties or values within objects. 


```
$mb =  @{
        Name="Size(MB)";
        Expression={ [Math]::Round($_.Length/1MB, 2) }
        }

Get-ChildItem -Path "C:\Path\to\Folder" |
    Select-Object Name,Length,$mb
```
```
Get-ChildItem -Path "C:\Path\to\Folder" |
    Select-Object Name, Length,@{Name="Size(MB)";Expression={ [Math]::Round($_.Length/1MB, 2) }}

```

## Splatting

In PowerShell, splatting is a technique that allows you to pass a collection of parameter values to a command using a hashtable or an array. It provides a way to organize and pass multiple parameters in a more readable and flexible manner, especially when dealing with commands that have numerous parameters.

Splatting is denoted by the @ symbol followed by the variable name containing the hashtable or array. The keys of the hashtable or the elements of the array correspond to the parameter names of the command you want to invoke. Here's an example to illustrate splatting:

```
$parameters = @{
    FilePath = "C:\Path\to\File.txt"
    Encoding = "UTF8"
    Force = $true
}

Set-Content @parameters
```

## Machine-Learning and Artificial Intelligence

Machine-learning and "Artificial Intelligence" (AI) as educational tools can be extremely valuable. The advent of AI applications, such as ChatGPT, has revolutionized the learning landscape, significantly enhancing learners' capacity to comprehend complex concepts and even produce practical scripts with remarkable speed and efficiency. 

| Pros  | Cons   | Mitigations |
|----|----| --- |
| Access to a vast repository of knowledge    | Dependent on limitations of training data, Limited contextual understanding, Limited adaptability to unique scenarios, High potential for errors or vulnerabilities       |  Remember: AI is just one of many available resources |
| Streamlined script generation and reduction in manual scripting | Overreliance on AI without critical thinking  | Don't just Copy and Paste, start simple and small, type out the code
| Excellent resource for explaining concepts, Capable of summarizing and adapting to defined learning levels (i.e., "Explain PowerShell like I just heard about it last week.") | |

## Most Valuable Learning Resources 

1. **Online Search**: "PowerShell [insert thing you're trying to do]", e.g., "Powershell ping multiple hosts"

2. **ChatGPT** Learning accelerator! 

    - "Within the PowerShell framework, explain everything about variables, but talk to me like I just started learning PowerShell since 1 week ago."

    - "With the PowerShell framework, explain how I can use assemblies and .NET classes and methods. Give me some common and useful examples"

    - "Using PowerShell, generate a function called "Ping-MultipleHosts" that I can use to ping multiple IPaddresses from a text file"

3. **Microsoft Learn**

    - PowerShell Scripting Blog series. From August 2004, retired February 2021. Excellent collection of blog-style articles related to PowerShell, varying from simple examples to deep-dives into various applications of PowerShell.

    - PowerShell Online Documentation

4. **AdamtheAutomator**

    - Excellent collection of PowerShell tutorials and walkthroughs
    https://adamtheautomator.com/tag/powershell/?_tags=powershell
    
5. **PDQ PowerShell Podcast**
    
    - https://powershellpodcast.podbean.com/ 

    - https://youtube.com/playlist?list=PL1mL90yFExsjUS8DRkzfLUcHds7vlxqgM

6. **Reddit**: 
    - PowerShell SubReddit https://www.reddit.com/r/PowerShell/, highly recommended to peruse the pinned *What have you done with PowerShell this month?* monthly topics.

