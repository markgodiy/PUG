function Ping-MyServer {
<#
.DESCRIPTION
Admin required to run the following commandlets in this script: 
Start-Service
Invoke-Command

Very basic script: 
1. Ping a server
2. If server responds to ping, start winrm service
3. If winrm service is running, invoke-command and 
then get DNS using get-netipconfiguration
4. Include some feedback on the shell screen so it's easier to follow the script as it executes. 
5. Added the parameter ComputerName to make the function reusable. 

.EXAMPLE
Ping-MyServer <serverhostname or IP>

#>

param(
	$ComputerName
)

Write-Host "Server is $ComputerName"

$pingtest = Test-Connection $ComputerName -Count 1 -ErrorAction 0 -Quiet

if ($pingtest) {
	Write-Host "$ComputerName responded."
	
	Get-Service WinRM -Computername $ComputerName | Start-Service
	
	if (Get-Service WinRM -Computername $ComputerName) {
	
		Write-host "WinRM is running on $ComputerName"
		
		Invoke-Command $ComputerName {
			Get-NetIPConfiguration
		}
	}
}
else {
	Write-Host "$ComputerName is not responding to ping"
}
} 

Ping-MyServer
