param location_eastus string = 'eastus'

var virtualNetwork_CoreServices_Name = 'CoreServicesVnet'

resource virtualNetwork_CoreServices 'Microsoft.Network/virtualNetworks@2023-09-01' = {
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
