
function Test-IfAdmin {
    <#
    .DESCRIPTION
    Author: Mark Go
    The Test-IfAdmin function checks if the current user has administrator privileges by attempting to perform an administrative operation. It requires elevated (run as administrator) privileges to accurately determine if the user is an administrator.

    .OUTPUTS
    [PSCustomObject]
    Returns a custom object with the following properties:
    - IsAdmin: [bool] Indicates if the current user has administrator privileges.
    - UserName: [string] The name of the current user.
    #>

    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($identity)
    # Check if the user is a member of the Administrators group
    $isAdmin = $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
    $userName = $identity.Name

    $userData = [PSCustomObject]@{
        Date = (Get-Date -format 'yyyyMMMdd-HHmmss')
        UserName = $userName
        IsAdmin = $isAdmin
        Identity = $identity
        Principal = $principal
        RandomValue = Get-Random
    }

    return $userData
}

Test-IfAdmin | ft


