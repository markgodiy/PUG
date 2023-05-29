<#

MUST READ 

Adding an IP address to the WSMAN (Windows Remote Management) trusted hosts list can introduce certain risks and considerations:

1. Increased Attack Surface: By adding an IP address to the trusted hosts list, you're allowing remote connections from that specific IP address. If the IP address belongs to a compromised or malicious system, it can potentially gain unauthorized access to your computer.

2. Trusting Untrusted Systems: Adding an IP address to the trusted hosts list means you're explicitly trusting that system. If the system is not under your control or is not properly secured, it can pose a security risk.

3. IP Spoofing: Attackers can potentially spoof the IP address of a trusted system, tricking your computer into accepting connections from an unauthorized source.

4. Lack of Authentication: By solely relying on IP address-based trust, you're bypassing authentication mechanisms such as usernames and passwords. This can be a security concern if someone gains access to the trusted IP address.

5. Lack of Granularity: Adding an IP address to the trusted hosts list applies the trust broadly to all connections from that IP. It may be preferable to use more granular authentication mechanisms, such as certificates or domain authentication, to establish trust on a per-user or per-system basis.

To mitigate these risks, it's generally recommended to follow these best practices:

a. Use Secure Connections: Ensure that remote connections to your computer are encrypted using protocols like HTTPS or SSL/TLS.

b. Implement Proper Authentication: Consider using authentication mechanisms such as certificates, domain authentication, or multi-factor authentication to establish trust instead of solely relying on IP addresses.

c. Limit Access to Trusted Networks: If possible, restrict remote connections to trusted networks or use a VPN to establish secure connections.

d. Regularly Review and Update Trusted Hosts: Continuously monitor and review the trusted hosts list to remove any outdated or unnecessary entries.

By carefully evaluating the risks and implementing appropriate security measures, you can minimize the potential vulnerabilities associated with adding IP addresses to the WSMAN trusted hosts list.

#>

function Get-TrustedHosts {
    <#
    .DESCRIPTION
    Name: Get-TrustedHosts,
    Author: Mark Go,
    Purpose: Display IP Addresses from WSMan:\localhost\Client\TrustedHosts
    #>
    
    # Get TrustedHost value
    $trustedhosts = Get-Item WSMan:\localhost\Client\TrustedHosts | select-object -ExpandProperty Value
        
    $hosts = @()
    $i = 0

    # Use RegEx to check for commas in the value. 
    # If comma found, split TrustedHosts value using the comma as delimiter
    # Then, add hosts data into pscustomobject array

    if ($trustedhosts -match ".*\,.*") {
        $Trustedhosts = $trustedhosts -split ","

        foreach($h in $Trustedhosts) {
            $hdata = [PSCustomObject]@{
                ArrayID = $i
                IPAddress = $h
            }
            $hosts += $hdata
            $i++
        }
    }

    Return $hosts
}


function Add-TrustedHost {
    <#
    .DESCRIPTION
    Name: Add-TrustedHost,
    Author: Mark Go,
    Purpose: Add an IP Addresses to WSMan:\localhost\Client\TrustedHosts
    #>

    Param (
        [Parameter(Mandatory = $true)]$IPAddress
    )
    
    $TrustedValue = $false
    # Get TrustedHost value
    $trustedhosts = Get-Item WSMan:\localhost\Client\TrustedHosts | select-object -ExpandProperty Value

    # Split TrustedHosts value using the comma character as the delimiter
    $arrayTrustedhosts = @()
    $arrayTrustedhosts = $trustedhosts -split ","


    foreach ($trustedhost in $arrayTrustedhosts) {
        if ($trustedhost -eq $IPAddress) {
            Write-Output "$IPAddress is already a trusted Host"
            $TrustedValue = $true
            Break
        }
    }

    if (!($TrustedValue)) {
        Write-Output "Adding $IPAddress as a new trusted Host"
        Set-Item WSMan:\localhost\Client\TrustedHosts -Value $("$trustedhosts" + ",$IPAddress")
    }
    
}
function Remove-TrustedHosts {
    <#
    .DESCRIPTION
    Name: Remove-TrustedHost,
    Author: Mark,
    Purpose: Remove all IPAddresses from WSMan:\localhost\Client\TrustedHosts  
    #>

    Set-Item WSMan:\localhost\Client\TrustedHosts -Value "$null"

}

