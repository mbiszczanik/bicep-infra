param expressRouteCircuits_TestERCircuit_name string = 'TestERCircuit'
param Location string = 'eastus2'

resource expressRouteCircuits_TestERCircuit_name_resource 'Microsoft.Network/expressRouteCircuits@2023-09-01' = {
  name: expressRouteCircuits_TestERCircuit_name
  location: Location
  sku: {
    name: 'Standard_MeteredData'
    tier: 'Standard'
    family: 'MeteredData'
  }
  properties: {
    peerings: []
    authorizations: []
    serviceProviderProperties: {
      serviceProviderName: 'Equinix'
      peeringLocation: 'Seattle'
      bandwidthInMbps: 50
    }
    circuitProvisioningState: 'Enabled'
    allowClassicOperations: false
    serviceKey: '18119406-da38-4023-b41a-7f1804a00d79'
    serviceProviderProvisioningState: 'NotProvisioned'
    globalReachEnabled: false
  }
}
