# User PowerShell to get a list of installed applications

## To get a list of applications installed on the local machine: 

One-Liner:
```
Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" | Select-Object PSChildName,DisplayName,DisplayVersion,InstallSource,UninstallString | Sort-Object Displayname | Format-Table
```
## To get a list of applications installed for the current user:

One-Liner:
```
Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" | Select-Object PSChildName,DisplayName,DisplayVersion,InstallSource,UninstallString | Sort-Object Displayname | Format-Table
```

