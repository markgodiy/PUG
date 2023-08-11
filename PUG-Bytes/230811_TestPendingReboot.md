# Test-PendingReboot.ps1

## Background

During my never-ending quest for PowerShell scripts for System Admins, I came accross this `Test-PendingReboot` script by Brian Wilhite. 

I'm amazed at how elegant of a solution it is to a common issue for SA's "Do I need to reboot?". Operationally, it's simple and fast. 

This example returns the ComputerName and IsRebootPending properties.

```
PS C:\>Test-PendingReboot

ComputerName IsRebootPending
------------ ---------------
WKS01                   True
```

This example returns the ComputerName and IsRebootPending properties of a remote computer.

```
PS C:\> Test-PendingReboot -ComputerName WKS02

ComputerName IsRebootPending
------------ ---------------
WKS02                   True

```
This example will return a bool value based on the pending reboot test for the local computer.
```
PS C:\>(Test-PendingReboot).IsRebootPending

True
```

This example will test the pending reboot status for dc01, providing detailed information
```
PS C:\>Test-PendingReboot -ComputerName DC01 -Detailed

ComputerName                     : dc01
ComponentBasedServicing          : True
PendingComputerRenameDomainJoin  : False
PendingFileRenameOperations      : False
PendingFileRenameOperationsValue :
SystemCenterConfigManager        : False
WindowsUpdateAutoUpdate          : True
IsRebootPending                  : True
```

Check it out! 

## What the script actually does (According to ChatGPT analysis): 

This PowerShell script defines a function named `Test-PendingReboot` that checks whether a system is pending a reboot due to various reasons. The script appears to be designed for system administrators and IT professionals to assess the reboot status of local and remote computers. The script's purpose seems to be legitimate and not malicious, as it focuses on querying system states and registry keys related to reboot requirements. Here's an overview of what the script is doing:

1. The script begins with comments that provide an overview of the purpose and usage of the function.

2. The function accepts several parameters:
   - `$ComputerName`: Specifies the name of the computer(s) to check. Default is the local machine's name.
   - `$Credential`: Allows specifying credentials for remote authentication.
   - `$Detailed`: When present, provides detailed information about the pending reboot reasons.
   - `$SkipConfigurationManagerClientCheck`: Skips checking for pending reboot status related to Configuration Manager client.
   - `$SkipPendingFileRenameOperationsCheck`: Skips checking for pending file rename operations.

3. The `process` block of the function processes each computer name specified in the `$ComputerName` parameter.

4. Inside the loop, the script performs various checks to determine if the system is pending a reboot due to different reasons, such as component-based servicing, Windows updates, pending computer rename/domain join, pending file rename operations, Configuration Manager client status, etc. The script follows these steps:

   - It constructs parameters for WMI queries to the registry using the `Invoke-WmiMethod` cmdlet.

   - It queries specific registry keys and checks for the presence of specific values that indicate pending reboots or operations.

   - It calculates whether a reboot is pending based on the results of these queries and checks.

   - If the `-Detailed` parameter is used, the script creates a custom object containing various pieces of information about the pending reboot status, including individual flags for each type of pending reboot reason.

5. If any errors occur during the checks for a particular computer, the script outputs a verbose message indicating the computer name and the specific error.

Overall, the script seems to have a legitimate purpose, which is to help administrators identify whether systems are pending a reboot due to a variety of potential reasons. There is no apparent malicious intent in the script; it primarily interacts with the registry and WMI to gather system status information. It's important, however, to verify the source and ensure that the script comes from a reputable and trusted source before using it on any system.

## Links

Original: https://github.com/bcwilhite/PendingReboot/blob/master/source/Public/Test-PendingReboot.ps1

Raw: https://raw.githubusercontent.com/bcwilhite/PendingReboot/master/source/Public/Test-PendingReboot.ps1

It appears that the script is popular enough that Brian Wilhite converted it to a module. More info here: 
https://github.com/bcwilhite/PendingReboot/tree/master


## Script (Copy & Paste into a PowerShell terminal)

``` 
<#
    .SYNOPSIS
        Test the pending reboot status on a local and/or remote computer.

    .DESCRIPTION
        This function will query the registry on a local and/or remote computer and determine if the
        system is pending a reboot, from Microsoft/Windows updates, Configuration Manager Client SDK, Pending
        Computer Rename, Domain Join, Pending File Rename Operations and Component Based Servicing.

        ComponentBasedServicing = Component Based Servicing
        WindowsUpdate = Windows Update / Auto Update
        CCMClientSDK = SCCM 2012 Clients only (DetermineifRebootPending method) otherwise $null value
        PendingComputerRenameDomainJoin = Detects a pending computer rename and/or pending domain join
        PendingFileRenameOperations = PendingFileRenameOperations, when this property returns true,
                                    it can be a false positive
        PendingFileRenameOperationsValue = PendingFilerenameOperations registry value; used to filter if need be,
                                        Anti-Virus will leverage this key property for def/dat removal,
                                        giving a false positive

    .PARAMETER ComputerName
        A single computer name or an array of computer names.  The default is localhost ($env:COMPUTERNAME).

    .PARAMETER Credential
        Specifies a user account that has permission to perform this action. The default is the current user.
        Type a username, such as User01, Domain01\User01, or User@Contoso.com. Or, enter a PSCredential object,
        such as an object that is returned by the Get-Credential cmdlet. When you type a user name, you are
        prompted for a password.

    .PARAMETER Detailed
        Indicates that this function returns a detailed result of pending reboot information, why the system is
        pending a reboot, not just a true/false response.

    .PARAMETER SkipConfigurationManagerClientCheck
        Indicates that this function will not test the Client SDK WMI class that is provided by the System
        Center Configuration Manager Client.  This parameter is useful when SCCM is not used/installed on
        the targeted systems.

    .PARAMETER SkipPendingFileRenameOperationsCheck
        Indicates that this function will not test the PendingFileRenameOperations MultiValue String property
        of the Session Manager registry key.  This parameter is useful for eliminating possible false positives.
        Many Anti-Virus packages will use the PendingFileRenameOperations MultiString Value in order to remove
        stale definitions and/or .dat files.

    .EXAMPLE
        PS C:\> Test-PendingReboot

        ComputerName IsRebootPending
        ------------ ---------------
        WKS01                   True

        This example returns the ComputerName and IsRebootPending properties.

    .EXAMPLE
        PS C:\> (Test-PendingReboot).IsRebootPending
        True

        This example will return a bool value based on the pending reboot test for the local computer.

    .EXAMPLE
        PS C:\> Test-PendingReboot -ComputerName DC01 -Detailed

        ComputerName                     : dc01
        ComponentBasedServicing          : True
        PendingComputerRenameDomainJoin  : False
        PendingFileRenameOperations      : False
        PendingFileRenameOperationsValue :
        SystemCenterConfigManager        : False
        WindowsUpdateAutoUpdate          : True
        IsRebootPending                  : True

        This example will test the pending reboot status for dc01, providing detailed information

    .EXAMPLE
        PS C:\> Test-PendingReboot -ComputerName DC01 -SkipConfigurationManagerClientCheck -SkipPendingFileRenameOperationsCheck -Detailed

        CommputerName                    : dc01
        ComponentBasedServicing          : True
        PendingComputerRenameDomainJoin  : False
        PendingFileRenameOperations      : False
        PendingFileRenameOperationsValue :
        SystemCenterConfigManager        :
        WindowsUpdateAutoUpdate          : True
        IsRebootPending                  : True

    .LINK
        Background:
        https://blogs.technet.microsoft.com/heyscriptingguy/2013/06/10/determine-pending-reboot-statuspowershell-style-part-1/
        https://blogs.technet.microsoft.com/heyscriptingguy/2013/06/11/determine-pending-reboot-statuspowershell-style-part-2/

        Component-Based Servicing:
        http://technet.microsoft.com/en-us/library/cc756291(v=WS.10).aspx

        PendingFileRename/Auto Update:
        http://support.microsoft.com/kb/2723674
        http://technet.microsoft.com/en-us/library/cc960241.aspx
        http://blogs.msdn.com/b/hansr/archive/2006/02/17/patchreboot.aspx

        CCM_ClientSDK:
        http://msdn.microsoft.com/en-us/library/jj902723.aspx

    .NOTES
        Author:  Brian Wilhite
        Email:   bcwilhite (at) live.com
#>

function Test-PendingReboot
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("CN", "Computer")]
        [String[]]
        $ComputerName = $env:COMPUTERNAME,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential,

        [Parameter()]
        [Switch]
        $Detailed,

        [Parameter()]
        [Switch]
        $SkipConfigurationManagerClientCheck,

        [Parameter()]
        [Switch]
        $SkipPendingFileRenameOperationsCheck
    )

    process
    {
        foreach ($computer in $ComputerName)
        {
            try
            {
                $invokeWmiMethodParameters = @{
                    Namespace    = 'root/default'
                    Class        = 'StdRegProv'
                    Name         = 'EnumKey'
                    ComputerName = $computer
                    ErrorAction  = 'Stop'
                }

                $hklm = [UInt32] "0x80000002"

                if ($PSBoundParameters.ContainsKey('Credential'))
                {
                    $invokeWmiMethodParameters.Credential = $Credential
                }

                ## Query the Component Based Servicing Reg Key
                $invokeWmiMethodParameters.ArgumentList = @($hklm, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\')
                $registryComponentBasedServicing = (Invoke-WmiMethod @invokeWmiMethodParameters).sNames -contains 'RebootPending'

                ## Query WUAU from the registry
                $invokeWmiMethodParameters.ArgumentList = @($hklm, 'SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\')
                $registryWindowsUpdateAutoUpdate = (Invoke-WmiMethod @invokeWmiMethodParameters).sNames -contains 'RebootRequired'

                ## Query JoinDomain key from the registry - These keys are present if pending a reboot from a domain join operation
                $invokeWmiMethodParameters.ArgumentList = @($hklm, 'SYSTEM\CurrentControlSet\Services\Netlogon')
                $registryNetlogon = (Invoke-WmiMethod @invokeWmiMethodParameters).sNames
                $pendingDomainJoin = ($registryNetlogon -contains 'JoinDomain') -or ($registryNetlogon -contains 'AvoidSpnSet')

                ## Query ComputerName and ActiveComputerName from the registry and setting the MethodName to GetMultiStringValue
                $invokeWmiMethodParameters.Name = 'GetMultiStringValue'
                $invokeWmiMethodParameters.ArgumentList = @($hklm, 'SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName\', 'ComputerName')
                $registryActiveComputerName = Invoke-WmiMethod @invokeWmiMethodParameters

                $invokeWmiMethodParameters.ArgumentList = @($hklm, 'SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName\', 'ComputerName')
                $registryComputerName = Invoke-WmiMethod @invokeWmiMethodParameters

                $pendingComputerRename = $registryActiveComputerName -ne $registryComputerName -or $pendingDomainJoin

                ## Query PendingFileRenameOperations from the registry
                if (-not $PSBoundParameters.ContainsKey('SkipPendingFileRenameOperationsCheck'))
                {
                    $invokeWmiMethodParameters.ArgumentList = @($hklm, 'SYSTEM\CurrentControlSet\Control\Session Manager\', 'PendingFileRenameOperations')
                    $registryPendingFileRenameOperations = (Invoke-WmiMethod @invokeWmiMethodParameters).sValue
                    $registryPendingFileRenameOperationsBool = [bool]$registryPendingFileRenameOperations
                }

                ## Query ClientSDK for pending reboot status, unless SkipConfigurationManagerClientCheck is present
                if (-not $PSBoundParameters.ContainsKey('SkipConfigurationManagerClientCheck'))
                {
                    $invokeWmiMethodParameters.NameSpace = 'ROOT\ccm\ClientSDK'
                    $invokeWmiMethodParameters.Class = 'CCM_ClientUtilities'
                    $invokeWmiMethodParameters.Name = 'DetermineifRebootPending'
                    $invokeWmiMethodParameters.Remove('ArgumentList')

                    try
                    {
                        $sccmClientSDK = Invoke-WmiMethod @invokeWmiMethodParameters
                        $systemCenterConfigManager = $sccmClientSDK.ReturnValue -eq 0 -and ($sccmClientSDK.IsHardRebootPending -or $sccmClientSDK.RebootPending)
                    }
                    catch
                    {
                        $systemCenterConfigManager = $null
                        Write-Verbose -Message ($script:localizedData.invokeWmiClientSDKError -f $computer)
                    }
                }

                $isRebootPending = $registryComponentBasedServicing -or `
                    $pendingComputerRename -or `
                    $pendingDomainJoin -or `
                    $registryPendingFileRenameOperationsBool -or `
                    $systemCenterConfigManager -or `
                    $registryWindowsUpdateAutoUpdate

                if ($PSBoundParameters.ContainsKey('Detailed'))
                {
                    [PSCustomObject]@{
                        ComputerName                     = $computer
                        ComponentBasedServicing          = $registryComponentBasedServicing
                        PendingComputerRenameDomainJoin  = $pendingComputerRename
                        PendingFileRenameOperations      = $registryPendingFileRenameOperationsBool
                        PendingFileRenameOperationsValue = $registryPendingFileRenameOperations
                        SystemCenterConfigManager        = $systemCenterConfigManager
                        WindowsUpdateAutoUpdate          = $registryWindowsUpdateAutoUpdate
                        IsRebootPending                  = $isRebootPending
                    }
                }
                else
                {
                    [PSCustomObject]@{
                        ComputerName    = $computer
                        IsRebootPending = $isRebootPending
                    }
                }
            }

            catch
            {
                Write-Verbose "$Computer`: $_"
            }
        }
    }
}
```
