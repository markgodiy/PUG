function Ping-MyServer {
<#

Very basic script: 
1. Ping a server
2. If server responds to ping, start winrm service
3. If winrm service is running, invoke-command and 
then get DNS using get-netipconfiguration
4. Include some feedback on the shell screen so it's easier to follow the script as it executes. 
5. Added the parameter ComputerName to make the function reusable. 
#>

param(
$ComputerName
)

write-host "Server is $ComputerName"

$pingtest = test-connection $ComputerName -count 1 -ea 0 -quiet

if($pingtest){
	write-host "$ComputerName responded."
	
	Get-Service WinRM -Computername $ComputerName | start-service

	
	if(Get-Service WinRM -Computername $ComputerName) {
		Write-host "WinRM is running on $ComputerName"
	 invoke-command $ComputerName {
		Get-NetIPConfiguration
	 }
	}
	} else {
	Write-Host "$ComputerName is not responding to ping"
	}
} 

Ping-MyServer
