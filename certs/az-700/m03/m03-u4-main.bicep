/*
SUMMARY: Az-700 hands-on labs
DESCRIPTION: M03-Unit 4 Configure an ExpressRoute Gateway
AUTHOR/S: Marcin Biszczanik
VERSION: 1.0.0
URI: https://learn.microsoft.com/en-us/training/modules/design-implement-azure-expressroute/4-exercise-configure-expressroute-gateway
     https://microsoftlearning.github.io/AZ-700-Designing-and-Implementing-Microsoft-Azure-Networking-Solutions/Instructions/Exercises/M03-Unit%204%20Configure%20an%20ExpressRoute%20Gateway.html

Compatibility with the exercise to be tested.
The code was not tested.

*/

param resourceGroup_name string = 'ContosoResourceGroup'

param location_eastus string = 'eastus'

param vNETGateway_CoreServices_name string = 'CoreServicesVnetGateway'

param publicIPAdress_Gateway_CoreServices_name string = 'CoreServicesVnetGateway-IP'

var virtualNetwork_CoreServices_Name = 'CoreServicesVnet'
var virtualNetwork_Subnet_CoreServices_Name = '	GatewaySubnet'

resource virtualNetwork_CoreServices 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetwork_CoreServices_Name
  location: location_eastus
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.20.0.0/27'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

resource publicIPAdress_Gateway_CoreServices 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: publicIPAdress_Gateway_CoreServices_name
  location: location_eastus
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource vNETGateway_CoreServices 'Microsoft.Network/virtualNetworkGateways@2023-05-01' = {
  name: vNETGateway_CoreServices_name
  location: location_eastus
  properties: {
    ipConfigurations: [
      {
        name: vNETGateway_CoreServices_name
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId(resourceGroup_name, 'Microsoft.Network/virtualNetworks/subnets', vNETGateway_CoreServices_name, virtualNetwork_Subnet_CoreServices_Name)
          }
          publicIPAddress: {
            id: publicIPAdress_Gateway_CoreServices.id
          }
        }
      }
    ]
    sku: {
      name: 'Standard'
      tier: 'Standard'
    }
    gatewayType: 'ExpressRoute'
    vpnType: 'RouteBased'
    activeActive: false
  }
}
