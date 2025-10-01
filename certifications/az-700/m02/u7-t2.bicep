/*
Task 2: Create a hub
*/
param virtualWan_name string = 'ContosoVirtualWAN'
param virtualHub_name string = 'ContosoVirtualWANHub-WestUS'
param location_westus string = 'westus'
param vpnGateways_eastus_gw_name string = 'ContosoVirtualWAN-VPNGW'
param virtualHubs_ContosoVirtualWANHub_WestUS_externalid string = resourceId(
  'Microsoft.Network/virtualHubs',
  virtualHub_name
)

resource virtualWANHub_Contoso_WESTUS 'Microsoft.Network/virtualHubs@2023-05-01' = {
  name: virtualHub_name
  location: location_westus
  properties: {
    addressPrefix: '10.60.0.0/24'
    virtualWan: {
      id: resourceId('Microsoft.Network/virtualWans', virtualWan_name)
    }
  }
}

resource vpnGateways_eastus_gw_name_resource 'Microsoft.Network/vpnGateways@2023-09-01' = {
  name: vpnGateways_eastus_gw_name
  location: 'eastus'
  properties: {
    connections: []
    virtualHub: {
      id: virtualHubs_ContosoVirtualWANHub_WestUS_externalid
    }
    bgpSettings: {
      asn: 65515
      peerWeight: 0
      bgpPeeringAddresses: [
        {
          ipconfigurationId: 'Instance0'
          customBgpIpAddresses: []
        }
        {
          ipconfigurationId: 'Instance1'
          customBgpIpAddresses: []
        }
      ]
    }
    vpnGatewayScaleUnit: 1
    natRules: []
    enableBgpRouteTranslationForNat: false
    isRoutingPreferenceInternet: false
  }
}
