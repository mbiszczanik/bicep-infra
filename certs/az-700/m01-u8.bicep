/*
SUMMARY: Az-700 hands-on labs
DESCRIPTION: M01-Unit 8 Connect two Azure Virtual Networks using global virtual network peering
AUTHOR/S: Marcin Biszczanik
VERSION: 1.0.0
URI: https://learn.microsoft.com/en-us/training/modules/introduction-to-azure-virtual-networks/8-exercise-connect-two-azure-virtual-networks-global
     https://microsoftlearning.github.io/AZ-700-Designing-and-Implementing-Microsoft-Azure-Networking-Solutions/Instructions/Exercises/M01-Unit%208%20Connect%20two%20Azure%20Virtual%20Networks%20using%20global%20virtual%20network%20peering.html

Task 1: Deploy ManufacturingVMazuredeploy.bicep
Task 2: Check connection
Task 3: Deploy m01-u8.bicep
Task 4: Check connection

New-AzResourceGroupDeployment `
-Name "Az-700" `
-ResourceGroupName "ContosoResourceGroup" `
-TemplateFile .\m01-u8.bicep `
-Verbose

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
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId(existingRemoteVirtualNetworkResourceGroupName, 'Microsoft.Network/virtualNetworks', existingRemoteVirtualNetworkName)
    }
  }
}

resource existingRemoteVirtualNetworkName_peering_to_local_vnet 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-05-01' = {
  name: '${existingRemoteVirtualNetworkName}/ManufacturingVnet-to-CoreServicesVnet'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId(existingRemoteVirtualNetworkResourceGroupName, 'Microsoft.Network/virtualNetworks', existingLocalVirtualNetworkName)
    }
  }
}

////////////////////////////////// MODULES //////////////////////////////////

//////////////////////////////////  OUTPUT  //////////////////////////////////
