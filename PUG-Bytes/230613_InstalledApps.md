# User PowerShell to get a list of installed applications

Cmdlets Used:
`Get-ItemProperty`
`Select-Object`
`Sort-Object`
`Format-Table`

Applications are typically installed on the Local Machine and available to all users, but some applications are only available to the Current User, so it's good to know how to look for both types. 

## To get a list of applications installed on the local machine: 

One-Liner:
```
Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" | Select-Object PSChildName,DisplayName,DisplayVersion,InstallSource,UninstallString | Sort-Object Displayname | Format-Table
```
## To get a list of applications installed and associated only with the current user:

One-Liner:
```
Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" | Select-Object PSChildName,DisplayName,DisplayVersion,InstallSource,UninstallString | Sort-Object Displayname | Format-Table
```

