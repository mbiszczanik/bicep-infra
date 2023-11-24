/*
SUMMARY: Az-700 hands-on labs
DESCRIPTION: M02-Unit 7 Create a Virtual WAN by using Azure Portal
AUTHOR/S: Marcin Biszczanik
VERSION: 1.0.0
URI: https://learn.microsoft.com/en-us/training/modules/design-implement-hybrid-networking/7-exercise-create-virtual-wan-by-using-azure-portal
     https://microsoftlearning.github.io/AZ-700-Designing-and-Implementing-Microsoft-Azure-Networking-Solutions/Instructions/Exercises/M02-Unit%207%20Create%20a%20Virtual%20WAN%20by%20using%20Azure%20Portal.html#task-3-connect-a-vnet-to-the-virtual-hub

New-AzResourceGroupDeployment `
-Name "Az-700" `
-ResourceGroupName "ContosoResourceGroup" `
-TemplateFile .\m02-u7.bicep `
-Verbose

Lack of Virtual network connection - can be added to the code.
Connection name: ContosoVirtualWAN-to-ResearchVNet
Hubs: ContosoVirtualWANHub-WestUS
Subscription: no changes
Resource Group: ContosoResourceGroup
Virtual network: ResearchVNet
Propagate to none: Yes

*/

//////////////////////////////////  PARAMETERS //////////////////////////////////

param location_southeastasia string = 'southeastasia'
param location_westus string = 'westus'

param virtualWan_name string = 'ContosoVirtualWAN'
param virtualHub_name string = 'ContosoVirtualWANHub-WestUS'

//////////////////////////////////  VARIABLES //////////////////////////////////

var virtualNetwork_ResearchVnet_Name = 'ResearchVnet'

////////////////////////////////// RESOURCES //////////////////////////////////

resource virtualNetwork_ResearchVnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: virtualNetwork_ResearchVnet_Name
  location: location_southeastasia
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.40.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'ResearchSystemSubnet'
        properties: {
          addressPrefix: '10.40.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

resource ContosoVirtualWAN 'Microsoft.Network/virtualWans@2023-05-01' = {
  name: virtualWan_name
  location: 'global'
  properties: {
    type: 'Standard'
    disableVpnEncryption: false
    allowBranchToBranchTraffic: true
    allowVnetToVnetTraffic: true
  }
}

resource ContosoVirtualWANHub_WESTUS 'Microsoft.Network/virtualHubs@2023-05-01' = {
  name: virtualHub_name
  location: location_westus
  properties: {
    addressPrefix: '10.60.0.0/24'
    virtualWan: {
      id: ContosoVirtualWAN.id
    }
  }
}

resource vpnSite 'Microsoft.Network/vpnSites@2023-05-01' = {
  name: 'VPNSite'
}

resource vpnGateway 'Microsoft.Network/vpnGateways@2023-05-01' = {
  name: 'VPNGateway'
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
