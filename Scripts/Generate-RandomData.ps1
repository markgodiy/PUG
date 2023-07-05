function Generate-RandomData {
    param(
        [int]$Count,
        $OutputPath = "C:\Temp\RandomData.csv"
    )
    $Hostnames = @(
        "Window",
        "Rocket",
        "Sphere",
        "Planet",
        "Dragon",
        "Castle",
        "Forest",
        "Guitar",
        "Pillow",
        "Orange",
        "Circle",
        "Anchor",
        "Banana",
        "Spirit"
    )

    $arrRandomData = @()
    
    $randomData = for ($i = 1; $i -le $Count; $i++) {
        $hostname = "WKSTN$($($hostnames | Get-Random).ToUpper())$((Get-Random -Minimum 1 -Maximum 9))"
        $ipAddress = "192.168.$((Get-Random -Minimum 100 -Maximum 253)).$((Get-Random -Minimum 100 -Maximum 253))"
        
        $obj = [PsCustomObject]@{
            Hostname = $hostname
            IPAddress = $ipAddress
        }
        $arrRandomData += $obj
    }
            
    $arrRandomData | Export-Csv -Path $OutputPath -NoTypeInformation

    Write-Host "Random list of $Count Hosts with IPAddresses has been saved to $OutputPath"

}

# Usage example:
Generate-RandomData -Count 10

