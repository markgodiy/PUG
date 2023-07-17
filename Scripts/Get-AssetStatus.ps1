function Get-AssetStatus {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('FilePath')]
        [string]$InputFile
    )
    
    $IsAdmin = [bool](New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $IsAdmin) {
        $result = @()
        $hostnames = Get-Content -Path $InputFile
        
        foreach ($hostname in $hostnames) {
            $pingResult = Test-Connection -ComputerName $hostname -Count 1 -Quiet
            
            $status = if ($pingResult) {
                'Online'
            } else {
                'Offline'
            }
            
            $result += [PSCustomObject]@{
                'Hostname' = $hostname
                'Status' = $status
            }
        }
        
        return $result
    }
    else {
        $result = @()
        $hostnames = Get-Content -Path $InputFile
        
        foreach ($hostname in $hostnames) {
            $pingResult = Test-Connection -ComputerName $hostname -Count 1 -Quiet
            
            $status = if ($pingResult) {
                'Online'
            } else {
                'Offline'
            }
            
            $osInfo = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $hostname
            $diskInfo = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $hostname -Filter "DeviceID = 'C:'"
            $lastBootTime = $osInfo.LastBootUpTime
            $freeSpace = $diskInfo.FreeSpace / 1GB
            $totalSpace = $diskInfo.Size / 1GB
            
            $result += [PSCustomObject]@{
                'Hostname' = $hostname
                'Status' = $status
                'OS' = $osInfo.Caption
                'Version' = $osInfo.Version
                'TotalSpace(GB)' = $totalSpace
                'FreeSpace(GB)' = $freeSpace
                'CurrentUser' = $osInfo.RegisteredUser
                'LastBootTime' = $lastBootTime
            }
            
            # Start the WinRM service
            Start-Service -Name 'WinRM' -ComputerName $hostname -ErrorAction SilentlyContinue
        }
        
        return $result
    }
}
