/*
Task 4: Create VNet peerings between CoreServicesVnet and ManufacturingVnet
*/

//////////////////////////////////  PARAMETERS //////////////////////////////////

@description('Set the local VNet name')
param existingLocalVirtualNetworkName string = 'CoreServicesVnet'
@description('Set the remote VNet name')
param existingRemoteVirtualNetworkName string = 'ManufacturingVnet'
@description('Sets the remote VNet Resource group')
param existingRemoteVirtualNetworkResourceGroupName string = 'ContosoResourceGroup'

//////////////////////////////////  VARIABLES //////////////////////////////////

////////////////////////////////// RESOURCES //////////////////////////////////

resource existingLocalVirtualNetworkName_peering_to_remote_vnet 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: '${existingLocalVirtualNetworkName}/CoreServicesVnet-to-ManufacturingVnet'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId(
        existingRemoteVirtualNetworkResourceGroupName,
        'Microsoft.Network/virtualNetworks',
        existingRemoteVirtualNetworkName
      )
    }
  }
}

resource existingRemoteVirtualNetworkName_peering_to_local_vnet 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: '${existingRemoteVirtualNetworkName}/ManufacturingVnet-to-CoreServicFesVnet'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId(
        existingRemoteVirtualNetworkResourceGroupName,
        'Microsoft.Network/virtualNetworks',
        existingLocalVirtualNetworkName
      )
    }
  }
}

////////////////////////////////// MODULES //////////////////////////////////

//////////////////////////////////  OUTPUT  //////////////////////////////////
