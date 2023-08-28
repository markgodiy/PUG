# PowerShell in Domain/Non-Domain Environments

## Domain Environment - Active Directory

 Active Directory is a centralized database that stores information about network resources (users, computers, groups, etc.) and provides services like authentication and authorization. 
 
 PowerShell in an Active Directory domain environment offers simplified Remote Management. Admins can use PowerShell to remotely manage domain-joined computers using commands like `Enter-PSSession`, `Invoke-Command`, `Get-CimInstance` or `Get-WmiObject`.

 As long as the Windows Remote Management (WinRM) service is enabled and running on the remote host, PowerShell remote management simply works.

 Verify WinRM service is running on the remote host with `Test-WSMan` or `Get-Service`
 
 ```
 Test-WSMan -ComputerName <hostname>
 ```

 ```
 Get-Service -Name WinRM -ComputerName <hostname>
 ```

## Non-Domain Environment

In a Non-Domain environment, such as most local home networks, remote management is slightly less simple. 


**Local Admin Credentials**: When connecting remotely, administrators need to provide appropriate local administrator credentials of the target machine.

It's important to note that in non-domain environments, managing a large number of workgroup machines individually can be challenging, as there's no central user and group management, Group Policy application, or other domain-wide management features available. Therefore, using automation and scripting becomes even more critical to streamline administrative tasks in such scenarios.

Overall, PowerShell's versatility makes it a valuable tool in both domain and non-domain environments, offering system administrators powerful capabilities to manage and automate various tasks efficiently.

## Setting up PowerShell Session in a Non-Domain Environment