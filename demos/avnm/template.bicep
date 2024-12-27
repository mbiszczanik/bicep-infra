param networkManagers_Hub01_WEU_AVNM01_name string = 'Hub01-WEU-AVNM01'
param virtualNetworks_Hub01_WEU_VNET01_name string = 'Hub01-WEU-VNET01'
param virtualNetworks_Spoke01_NEU_VNET01_externalid string = '/subscriptions/033dd423-eb29-4416-90cd-a47c6bebf420/resourceGroups/Spoke01-NEU-VNET-RG/providers/Microsoft.Network/virtualNetworks/Spoke01-NEU-VNET01'
param virtualNetworks_Spoke02_NEU_VNET01_externalid string = '/subscriptions/033dd423-eb29-4416-90cd-a47c6bebf420/resourceGroups/Spoke02-NEU-VNET-RG/providers/Microsoft.Network/virtualNetworks/Spoke02-NEU-VNET01'

resource networkManagers_Hub01_WEU_AVNM01_name_resource 'Microsoft.Network/networkManagers@2024-01-01' = {
  name: networkManagers_Hub01_WEU_AVNM01_name
  location: 'West Europe'
  tags: {
    costCenter: 'MSDN'
  }
  properties: {
    networkManagerScopes: {
      managementGroups: []
      subscriptions: [
        '/subscriptions/033dd423-eb29-4416-90cd-a47c6bebf420'
      ]
    }
    networkManagerScopeAccesses: [
      'Connectivity'
    ]
  }
}

resource virtualNetworks_Hub01_WEU_VNET01_name_resource 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: virtualNetworks_Hub01_WEU_VNET01_name
  location: 'westeurope'
  tags: {
    CostCenter: 'MSDN'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    dhcpOptions: {
      dnsServers: []
    }
    subnets: [
      {
        name: 'ContosoSubnet'
        id: virtualNetworks_Hub01_WEU_VNET01_name_ContosoSubnet.id
        properties: {
          addressPrefix: '10.0.0.0/24'
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'ANM_22740FFA83EB4B03043CC7E_${virtualNetworks_Hub01_WEU_VNET01_name}_Spoke01-NEU-VNET01_4564971656'
        id: virtualNetworks_Hub01_WEU_VNET01_name_ANM_22740FFA83EB4B03043CC7E_virtualNetworks_Hub01_WEU_VNET01_name_Spoke01_NEU_VNET01_4564971656.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_Spoke01_NEU_VNET01_externalid
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: true
          allowGatewayTransit: false
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          peerCompleteVnets: true
          remoteAddressSpace: {
            addressPrefixes: [
              '10.1.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.1.0.0/16'
            ]
          }
        }
        type: 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings'
      }
      {
        name: 'ANM_22740FFA83EB4B03043CC7E_${virtualNetworks_Hub01_WEU_VNET01_name}_Spoke02-NEU-VNET01_1213784172'
        id: virtualNetworks_Hub01_WEU_VNET01_name_ANM_22740FFA83EB4B03043CC7E_virtualNetworks_Hub01_WEU_VNET01_name_Spoke02_NEU_VNET01_1213784172.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_Spoke02_NEU_VNET01_externalid
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: true
          allowGatewayTransit: false
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          peerCompleteVnets: true
          remoteAddressSpace: {
            addressPrefixes: [
              '10.2.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.2.0.0/16'
            ]
          }
        }
        type: 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings'
      }
    ]
    enableDdosProtection: false
  }
}

resource networkManagers_Hub01_WEU_AVNM01_name_AVNM_NG 'Microsoft.Network/networkManagers/networkGroups@2024-01-01' = {
  parent: networkManagers_Hub01_WEU_AVNM01_name_resource
  name: 'AVNM-NG'
  properties: {}
}

resource virtualNetworks_Hub01_WEU_VNET01_name_ContosoSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' = {
  name: '${virtualNetworks_Hub01_WEU_VNET01_name}/ContosoSubnet'
  properties: {
    addressPrefix: '10.0.0.0/24'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_Hub01_WEU_VNET01_name_resource
  ]
}

resource virtualNetworks_Hub01_WEU_VNET01_name_ANM_22740FFA83EB4B03043CC7E_virtualNetworks_Hub01_WEU_VNET01_name_Spoke01_NEU_VNET01_4564971656 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = {
  name: '${virtualNetworks_Hub01_WEU_VNET01_name}/ANM_22740FFA83EB4B03043CC7E_${virtualNetworks_Hub01_WEU_VNET01_name}_Spoke01-NEU-VNET01_4564971656'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_Spoke01_NEU_VNET01_externalid
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    remoteAddressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_Hub01_WEU_VNET01_name_resource
  ]
}

resource virtualNetworks_Hub01_WEU_VNET01_name_ANM_22740FFA83EB4B03043CC7E_virtualNetworks_Hub01_WEU_VNET01_name_Spoke02_NEU_VNET01_1213784172 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = {
  name: '${virtualNetworks_Hub01_WEU_VNET01_name}/ANM_22740FFA83EB4B03043CC7E_${virtualNetworks_Hub01_WEU_VNET01_name}_Spoke02-NEU-VNET01_1213784172'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_Spoke02_NEU_VNET01_externalid
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    remoteAddressSpace: {
      addressPrefixes: [
        '10.2.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.2.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_Hub01_WEU_VNET01_name_resource
  ]
}

resource networkManagers_Hub01_WEU_AVNM01_name_AVNM_NG_eszqzrhwhqstn 'Microsoft.Network/networkManagers/networkGroups/staticMembers@2024-01-01' = {
  parent: networkManagers_Hub01_WEU_AVNM01_name_AVNM_NG
  name: 'eszqzrhwhqstn'
  properties: {
    resourceId: virtualNetworks_Spoke01_NEU_VNET01_externalid
  }
  dependsOn: [
    networkManagers_Hub01_WEU_AVNM01_name_resource
  ]
}

resource networkManagers_Hub01_WEU_AVNM01_name_AVNM_NG_vktzqwnjkfict 'Microsoft.Network/networkManagers/networkGroups/staticMembers@2024-01-01' = {
  parent: networkManagers_Hub01_WEU_AVNM01_name_AVNM_NG
  name: 'vktzqwnjkfict'
  properties: {
    resourceId: virtualNetworks_Spoke02_NEU_VNET01_externalid
  }
  dependsOn: [
    networkManagers_Hub01_WEU_AVNM01_name_resource
  ]
}

resource networkManagers_Hub01_WEU_AVNM01_name_HUB_Spoke_Model 'Microsoft.Network/networkManagers/connectivityConfigurations@2024-01-01' = {
  parent: networkManagers_Hub01_WEU_AVNM01_name_resource
  name: 'HUB_Spoke_Model'
  properties: {
    connectivityTopology: 'HubAndSpoke'
    hubs: [
      {
        resourceType: 'Microsoft.Network/virtualNetworks'
        resourceId: virtualNetworks_Hub01_WEU_VNET01_name_resource.id
      }
    ]
    appliesToGroups: [
      {
        networkGroupId: networkManagers_Hub01_WEU_AVNM01_name_AVNM_NG.id
        groupConnectivity: 'DirectlyConnected'
        useHubGateway: 'False'
        isGlobal: 'False'
      }
    ]
    deleteExistingPeering: 'False'
    isGlobal: 'False'
  }
}
