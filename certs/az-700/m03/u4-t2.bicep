param resourceGroup_name string = 'ContosoResourceGroup'
param location_eastus string = 'eastus'
param vNETGateway_CoreServices_name string = 'CoreServicesVnetGateway'
param publicIPAdress_Gateway_CoreServices_name string = 'CoreServicesVnetGateway-IP'

var virtualNetwork_Subnet_CoreServices_Name = '	GatewaySubnet'

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
