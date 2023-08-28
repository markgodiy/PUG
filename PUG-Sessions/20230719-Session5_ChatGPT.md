# PUG Learning Series - "ChatGPT and PowerShell scripting"

## Objective: Use ChatGPT to generate a PowerShell function called Get-AssetStatus 

Generate PowerShell function called Get-AssetStatus: 

Script/Function capabilities:

- Accept a text file containing a list of hostnames as input
- Test if current user is an administrator. If $true, set function parameter $IsAdmin = $true, otherwise, $IsAdmin = $faslse
- If user is not admin, then ping each hostname and return a table array showing hostname, and if remote host is online or offline. 
- if user is admin, then also start the WinRM service and get the remote host's OS type and display version, C:\ drive total space, and avaialble free space, current user, and the last time the host was restarted. 


Other script ideas: 

Get-InstalledKBUpdates: Get list of installed KB from Get-Hotfix and registry, show KB number and installed date