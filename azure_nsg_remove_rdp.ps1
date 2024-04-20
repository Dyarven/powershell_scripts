Connect-AzAccount

# get network security groups
$nsgs = Get-AzNetworkSecurityGroup

foreach ($nsg in $nsgs) {
    $nsgRules = Get-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg 

    foreach ($nsgRule in $nsgRules) { 
        if ($nsgRule.Name -like "*Allow-RDP*") {
            Write-Output "Removing rule $($nsgRule.Name) from $($nsg.Name)"
            Remove-AzNetworkSecurityRuleConfig -Name $nsgRule.Name -NetworkSecurityGroup $nsg -Force
        } 
    }

    # only set the NSG if rules were removed
    if ($nsgRules -ne $null) {
        $nsg | Set-AzNetworkSecurityGroup
    }
}
