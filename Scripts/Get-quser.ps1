Function Get-quser {

<#
.DESCRIPTION
Author: Mark Go
Object-Oriented version of CMD quser.exe 

.EXAMPLE
Get-quser <hostname>
#>

    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)][Array]$ComputerName
    )
   
    $UserList = @()
    $sessions = quser /server:$ComputerName | Select-Object -Skip 1
    
    foreach ($line in $sessions) {
           
        $sessionUsr = ($line -split ' +')[1]
        $tryGetID = ($line -split ' +')[2]

        if ($tryGetID -match "[a-z]") {
            $sessionName = ($line -split ' +')[2]
            $sessionIds = ($line -split ' +')[3]
            $sessionState = ($line -split ' +')[4]
            $sessionIdle = ($line -split ' +')[5]
            $sessionLogon = ($line -split ' +')[6]
        }
        else {
            $sessionIds = $tryGetID
            $sessionState = ($line -split ' +')[3]
            $sessionIdle = ($line -split ' +')[4]
            $sessionLogon = ($line -split ' +')[5]
        }
        $obj = New-Object -TypeName PSobject
        $objRowInfo = [Ordered]@{
            ID          = $sessionIds
            
            USER        = $sessionUsr
            SESSIONNAME = $sessionName
            STATE       = $sessionState
            IDLETIME    = $sessionIdle
            LOGON       = $sessionLogon
        }
        $obj | Add-Member -NotePropertyMembers $objRowInfo -Force
        $UserList = $UserList + $obj
    }
    Return $UserList
}


