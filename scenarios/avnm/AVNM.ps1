# RGs
$location1 = "West Europe"
$rg1 = @{
    Name     = 'Hub01-WEU-VNET-RG'
    Location = $location1
    Tag      = @{
        'CostCenter' = 'MSDN'
    }
}
New-AzResourceGroup @rg1

$location2 = "North Europe"
$rg2 = @{
    Name     = 'Spoke01-NEU-VNET-RG'
    Location = $location2
    Tag      = @{
        'CostCenter' = 'MSDN'
    }
}
New-AzResourceGroup @rg2

$rg3 = @{
    Name     = 'Spoke02-NEU-VNET-RG'
    Location = $location2
    Tag      = @{
        'CostCenter' = 'MSDN'
    }
}
New-AzResourceGroup @rg3

# VNETs
$vnethub001 = @{
    Name              = 'Hub01-WEU-VNET01'
    ResourceGroupName = $rg1.Name
    Location          = $location1
    AddressPrefix     = '10.0.0.0/16'
    Tag               = @{
        'CostCenter' = 'MSDN'
    }    
}
$vnet_hub_001 = New-AzVirtualNetwork @vnethub001

$vnetspoke001 = @{
    Name              = 'Spoke01-NEU-VNET01'
    ResourceGroupName = $rg2.Name
    Location          = $location2
    AddressPrefix     = '10.1.0.0/16'
    Tag               = @{
        'CostCenter' = 'MSDN'
    }    
}
$vnet_spoke_001 = New-AzVirtualNetwork @vnetspoke001

$vnetspoke002 = @{
    Name              = 'Spoke02-NEU-VNET01'
    ResourceGroupName = $rg3.Name
    Location          = $location2
    AddressPrefix     = '10.2.0.0/16'
    Tag               = @{
        'CostCenter' = 'MSDN'
    }    
}
$vnet_spoke_002 = New-AzVirtualNetwork @vnetspoke002

# Subnets
$subnet_vnet_hub_001 = @{
    Name           = 'ContosoSubnet'
    VirtualNetwork = $vnet_hub_001
    AddressPrefix  = '10.0.0.0/24'
}
$subnetConfig_vnet_hub_001 = Add-AzVirtualNetworkSubnetConfig @subnet_vnet_hub_001
$vnet_hub_001 | Set-AzVirtualNetwork

$subnet_vnetspoke001 = @{
    Name           = 'FabrikamSubnet'
    VirtualNetwork = $vnet_spoke_001
    AddressPrefix  = '10.1.0.0/24'
}
$subnetConfig_vnetspoke001 = Add-AzVirtualNetworkSubnetConfig @subnet_vnetspoke001
$vnet_spoke_001 | Set-AzVirtualNetwork

$subnet_vnetspoke002 = @{
    Name           = 'TailwindSubnet'
    VirtualNetwork = $vnet_spoke_002
    AddressPrefix  = '10.2.0.0/24'
}
$subnetConfig_vnetspoke002 = Add-AzVirtualNetworkSubnetConfig @subnet_vnetspoke002
$vnet_spoke_002 | Set-AzVirtualNetwork

# Scope
# Prompt the user to enter the subscription ID
$subID = Read-Host -Prompt "Please enter your subscription ID"

# Display the entered subscription ID
Write-Host "You entered subscription ID: $subID"

[System.Collections.Generic.List[string]]$subGroup = @()  
$subGroup.Add("/subscriptions/$subID")

[System.Collections.Generic.List[String]]$access = @()  
$access.Add("Connectivity"); 
$access.Add("SecurityAdmin"); 

$scope = New-AzNetworkManagerScope -Subscription $subGroup

# AVNM
$avnm = @{
    Name                      = 'Hub01-WEU-AVNM01'
    ResourceGroupName         = $rg1.Name
    NetworkManagerScope       = $scope
    NetworkManagerScopeAccess = $access
    Location                  = $location1
    Tag                       = @{
        'CostCenter' = 'MSDN'
    }
}
$networkManager = New-AzNetworkManager @avnm

# Network Group
$ng = @{
    Name               = 'AVNM-NG'
    ResourceGroupName  = $rg1.Name
    NetworkManagerName = $networkManager.Name
}
$ng = New-AzNetworkManagerGroup @ng

# AVNM Network Group Static Member
function Get-UniqueString ([string]$id, $length = 13) {
    $hashArray = (new-object System.Security.Cryptography.SHA512Managed).ComputeHash($id.ToCharArray())
    -join ($hashArray[1..$length] | ForEach-Object { [char]($_ % 26 + [byte][char]'a') })
}

$sm_vnetspoke001 = @{
    Name               = Get-UniqueString $vnet_spoke_001.Id
    ResourceGroupName  = $rg1.Name
    NetworkGroupName   = $ng.Name
    NetworkManagerName = $networkManager.Name
    ResourceId         = $vnet_spoke_001.Id
}
$sm_vnetspoke001 = New-AzNetworkManagerStaticMember @sm_vnetspoke001

$sm_vnetspoke002 = @{
    Name               = Get-UniqueString $vnet_spoke_002.Id
    ResourceGroupName  = $rg1.Name
    NetworkGroupName   = $ng.Name
    NetworkManagerName = $networkManager.Name
    ResourceId         = $vnet_spoke_002.Id
}
$sm_vnetspoke002 = New-AzNetworkManagerStaticMember @sm_vnetspoke002

# Connectivity configuration
$gi1 = @{
    NetworkGroupId = $vnet_spoke_001.Id
}
$gi1 = New-AzNetworkManagerConnectivityGroupItem @gi1

$gi2 = @{
    NetworkGroupId = $vnet_spoke_002.Id
}
$gi2 = New-AzNetworkManagerConnectivityGroupItem @gi2

# Network Manager Hub
$hub = @{
    ResourceId   = $vnet_hub_001.Id
    ResourceType = "Microsoft.Network/virtualNetworks"
}
$hub = New-AzNetworkManagerHub @hub

# Create a list of Connectivity Group Items
[System.Collections.Generic.List[Microsoft.Azure.Commands.Network.Models.NetworkManager.PSNetworkManagerConnectivityGroupItem]]$configGroup = @()
$configGroup.Add($gi1)
$configGroup.Add($gi2)

$config = @{
    Name                 = 'HUB_Spoke_Model'
    ResourceGroupName    = $rg1.Name
    NetworkManagerName   = $networkManager.Name
    ConnectivityTopology = 'HubAndSpoke'
    AppliesToGroup       = $configGroup
    Hub                  = $hub
}
$config = New-AzNetworkManagerConnectivityConfiguration @config -Verbose

# Adding Deployment
