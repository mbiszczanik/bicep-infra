/*
SUMMARY: Az-700 hands-on labs
DESCRIPTION: M02-Unit 3 Create and configure a virtual network gateway
AUTHOR/S: Marcin Biszczanik
VERSION: 1.0.0
URI: 

Task 6: Create CoreServicesVnet Gateway

New-AzResourceGroupDeployment `
-Name "Az-700" `
-ResourceGroupName "ContosoResourceGroup" `
-TemplateFile .\m02-u3.bicep `
-Verbose


*/

//////////////////////////////////  PARAMETERS //////////////////////////////////

param resourceGroup_name string = 'ContosoResourceGroup'
param location_eastus string = 'eastus'
param location_westeurope string = 'westeurope'

param virtualNetwork_CoreServicesVnetGateway_name string = 'CoreServicesVnetGateway'
param virtualNetowrk_CoreServicesVnet_name string = 'CoreServicesVnet'
param virtualNetwork_CoreServicesVnetSubnet_name string = 'GatewaySubnet'
param virtualNetwork_CoreServicesVnetSubnet_PIP_name string = 'CoreServicesVnetGateway-PIP'

param virtualNetwork_ManufacturingVnetGateway_name string = 'ManufacturingVnetGateway'
param virtualNetowrk_ManufacturingVnet_name string = 'ManufacturingVnet'
param virtualNetwork_ManufacturingVnetSubnet_name string = 'GatewaySubnet'
param virtualNetwork_ManufacturingVnetSubnet_PIP_name string = 'ManufacturingVnetGateway-ip'

//////////////////////////////////  VARIABLES //////////////////////////////////


////////////////////////////////// RESOURCES //////////////////////////////////

resource CoreServicesVnetGateway 'Microsoft.Network/virtualNetworkGateways@2023-05-01' = {
  name: virtualNetwork_CoreServicesVnetGateway_name
  location: location_eastus
  properties: {
    ipConfigurations: [
      {
        name: virtualNetwork_CoreServicesVnetGateway_name
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId(resourceGroup_name, 'Microsoft.Network/virtualNetworks/subnets', virtualNetowrk_CoreServicesVnet_name, virtualNetwork_CoreServicesVnetSubnet_name)
          }
          publicIPAddress: {
            id: resourceId(resourceGroup_name, 'Microsoft.Network/publicIPAddresses', virtualNetwork_CoreServicesVnetSubnet_PIP_name)
          }
        }
      }
    ]
    sku: {
      name: 'VpnGw1'
      tier: 'VpnGw1'
    }
    gatewayType: 'Vpn'
    vpnType: 'Route-based'
    activeActive: false
  }
}

// resource ManufacturingVnetGateway 'Microsoft.Network/virtualNetworkGateways@2023-05-01' = {
//   name: virtualNetwork_ManufacturingVnetGateway_name
//   location: location_westeurope
//   properties: {
//     ipConfigurations: [
//       {
//         name: virtualNetwork_ManufacturingVnetGateway_name
//         properties: {
//           privateIPAllocationMethod: 'Dynamic'
//           subnet: {
//             id: resourceId(resourceGroup_name, 'Microsoft.Network/virtualNetworks/subnets', virtualNetowrk_ManufacturingVnet_name , virtualNetwork_ManufacturingVnetSubnet_name)
//           }
//           publicIPAddress: {
//             id: resourceId(resourceGroup_name, 'Microsoft.Network/publicIPAddresses', virtualNetwork_ManufacturingVnetSubnet_PIP_name)
//           }
//         }
//       }
//     ]
//     sku: {
//       name: 'VpnGw1'
//       tier: 'VpnGw1'
//     }
//     gatewayType: 'Vpn'
//     vpnType: 'Route-based'
//     activeActive: false
//   }
// }


//////////////////////////////////  OUTPUT  //////////////////////////////////
