/*
SUMMARY: Az-700 hands-on labs
DESCRIPTION: M02-Unit 3 Create and configure a virtual network gateway
AUTHOR/S: Marcin Biszczanik
VERSION: 1.0.0
URI: https://learn.microsoft.com/en-us/training/modules/design-implement-hybrid-networking/3-exercise-create-configure-local-network-gateway
     https://microsoftlearning.github.io/AZ-700-Designing-and-Implementing-Microsoft-Azure-Networking-Solutions/Instructions/Exercises/M02-Unit%203%20Create%20and%20configure%20a%20virtual%20network%20gateway.html

Task 1: Deploy azuredeploy.bicep
Task 2: Deploy CoreServicesVM.bicep
Task 3: Deploy ManufacturingVM.bicep
Task 4: Test connection
Task 5: Create CoreServicesVnet Gateway
Task 6: Create ManufacturingVnet Gateway
Task 7: Test connection

New-AzResourceGroupDeployment `
-Name "Az-700" `
-ResourceGroupName "ContosoResourceGroup" `
-TemplateFile .\m02-u3-main.bicep `
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
param virtualNetwork_ManufacturingVnetSubnet_PIP_name string = 'ManufacturingVnetGateway-PIP'

param CoreServicesVnetGateway_Connection_name string = 'CoreServicesGW-to-ManufacturingGW'
param ManufacturingVnetGateway_Connection_name string = 'ManufacturingGW-to-CoreServicesGW'

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
    vpnType: 'RouteBased'
    activeActive: false
  }
  dependsOn: [
    publicIPAdress_CoreServicesVnetGateway
  ]
}

resource ManufacturingVnetGateway 'Microsoft.Network/virtualNetworkGateways@2023-05-01' = {
  name: virtualNetwork_ManufacturingVnetGateway_name
  location: location_westeurope
  properties: {
    ipConfigurations: [
      {
        name: virtualNetwork_ManufacturingVnetGateway_name
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId(resourceGroup_name, 'Microsoft.Network/virtualNetworks/subnets', virtualNetowrk_ManufacturingVnet_name, virtualNetwork_ManufacturingVnetSubnet_name)
          }
          publicIPAddress: {
            id: resourceId(resourceGroup_name, 'Microsoft.Network/publicIPAddresses', virtualNetwork_ManufacturingVnetSubnet_PIP_name)
          }
        }
      }
    ]
    sku: {
      name: 'VpnGw1'
      tier: 'VpnGw1'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    activeActive: false
  }
  dependsOn: [
    publicIPAdress_ManufacturingVnetGateway
  ]
}

resource virtualNetowrk_ManufacturingVnet 'Microsoft.Network/virtualNetworks@2023-05-01' existing = {
  name: virtualNetowrk_ManufacturingVnet_name
}

resource virtualNetworks_ManufacturingVnet_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' = {
  parent: virtualNetowrk_ManufacturingVnet
  name: virtualNetwork_ManufacturingVnetSubnet_name
  properties: {
    addressPrefix: '10.30.0.0/27'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource publicIPAdress_CoreServicesVnetGateway 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: virtualNetwork_CoreServicesVnetSubnet_PIP_name
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

resource publicIPAdress_ManufacturingVnetGateway 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: virtualNetwork_ManufacturingVnetSubnet_PIP_name
  location: location_westeurope
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource CoreServicesVnetGateway_Connection 'Microsoft.Network/connections@2023-05-01' = {
  name: CoreServicesVnetGateway_Connection_name
  location: location_eastus
  properties: {
    virtualNetworkGateway1: {
      id: CoreServicesVnetGateway.id
      properties: {}
    }
    virtualNetworkGateway2: {
      id: ManufacturingVnetGateway.id
      properties: {}
    }
    connectionType: 'Vnet2Vnet'
    sharedKey: 'sharedkey'
  }
}

resource ManufacturingVnetGateway_Connection 'Microsoft.Network/connections@2023-05-01' = {
  name: ManufacturingVnetGateway_Connection_name
  location: location_westeurope
  properties: {
    virtualNetworkGateway1: {
      id: ManufacturingVnetGateway.id
      properties: {}
    }
    virtualNetworkGateway2: {
      id: CoreServicesVnetGateway.id
      properties: {}
    }
    connectionType: 'Vnet2Vnet'
    sharedKey: 'sharedkey'
  }
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
