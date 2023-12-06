# Example prompt function for use in the PowerShell profiles. 

Start PowerShell as Admin, then run command `notepad $PROFILE.CurrentUserAllhosts` and copy the function, then save. 

Function must be named `function prompt {}`

```powershell
#Style default PowerShell Console
$shell = $Host.UI.RawUI
$shell.WindowTitle= "MORE POWERRRRRR!!!!"
$shell.BackgroundColor = "Black"
$shell.ForegroundColor = "Green"

function prompt {

    #Assign Windows Title Text
    $host.ui.RawUI.WindowTitle = "PWD:$pwd"

    #Configure current user, current folder and date outputs
    $CmdPromptCurrentFolder = Split-Path -Path $pwd -Leaf
    $CmdPromptUser = [Security.Principal.WindowsIdentity]::GetCurrent();
    $Date = Get-Date -Format 'yyMMMdd:HHmmss'

    # Test for Admin / Elevated
    $IsAdmin = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

    #Decorate the CMD Prompt
    Write-Host "$Date " -ForegroundColor DarkGray -Backgroundcolor White -nonewline
    Write-host ($(if ($IsAdmin) { ' ADMIN ' } else { '' })) -BackgroundColor DarkRed -ForegroundColor White -NoNewline

    If ($CmdPromptCurrentFolder -like "*:*")
        {Write-Host "$CmdPromptCurrentFolder" -ForegroundColor White -BackgroundColor DarkGray -NoNewline}
        else {Write-Host ".\$CmdPromptCurrentFolder\"  -ForegroundColor White -BackgroundColor DarkGray -NoNewline}
	Return " PS> "

} #end prompt function

```

