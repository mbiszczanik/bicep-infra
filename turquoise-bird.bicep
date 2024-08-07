/*
SUMMARY: Turquoise bird
DESCRIPTION: n/a
AUTHOR/S: Marcin Biszczanik
VERSION: 0.0.1
*/

targetScope = 'subscription'

//////////////////////////////////  PARAMETERS //////////////////////////////////

//////////////////////////////////  Virtual Network //////////////////////////////////
param virtualNetwork_Location string = deployment().location
param virtualNetwork_Mask string = '16'
param virtualNetwork_PrefixFirstOct string = '10'
param virtualNetwork_PrefixSecondOct string = '1'
param virtualNetwork_PrefixThirdOct string = '0'
param virtualNetwork_DNSServers array = []
param virtualNetwork_RGName_Sub string = 'T-TB-VNET-RG01'
param virtualNetwork_Name_Sub string = 'T-TB-VNET-O1'
param virtualNetwork_SubnetName string = 'CoreSubnet'
param subscriptionId string
//////////////////////////////////  Virtual Network //////////////////////////////////

param networkInterface_PrivateIpAddress string = '10.1.1.1'
param networkInterface_SubnetId string = resourceId(
  subscriptionId,
  virtualNetwork_RGName_Sub,
  'Microsoft.Network/virtualNetworks/subnets',
  virtualNetwork_Name_Sub,
  virtualNetwork_SubnetName
)

@secure()
param virtualMachine_AdminPassword string

param networkSecurityGroup_Rules array = []

//////////////////////////////////  VARIABLES //////////////////////////////////

var tags = {
  Environment: 'Training'
  CostCenter: '00001'
  MSDN: 'MSDN'
}

var virtualNetwork_RGName = 'T-TB-VNET-RG01'
var virtualMachine_RGName = 'T-TB-VM-RG01'

var virtualNetwork_Name = 'T-TB-VNET-01'
var virtualMachine_Name = 'T-TB-VM-01'

var virtualNetwork_Subnets = [
  {
    name: 'CoreSubnet'
    properties: {
      addressPrefix: '${virtualNetwork_PrefixFirstOct}.${virtualNetwork_PrefixSecondOct}.${int(virtualNetwork_PrefixThirdOct)+1}.0/24'
    }
  }
]

////////////////////////////////// RESOURCES //////////////////////////////////

////////////////////////////////// Resource Groups //////////////////////////////////
module virtualNetwork_RG '.modules/resources/resourceGroup.bicep' = {
  name: virtualNetwork_RGName
  params: {
    tags: tags
    resourceGroup_Name: virtualNetwork_RGName
  }
}

module virtualMachine_RG '.modules/resources/resourceGroup.bicep' = {
  name: virtualMachine_RGName
  params: {
    tags: tags
    resourceGroup_Name: virtualMachine_RGName
  }
}
////////////////////////////////// Resource Groups //////////////////////////////////

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2024-01-01' existing = {
  name: '${virtualMachine_Name}-NSG'
  scope: resourceGroup(virtualMachine_RG.name)
}

module virtualNetwork '.modules/network/virtualNetwork.bicep' = {
  scope: resourceGroup(virtualNetwork_RG.name)
  name: virtualNetwork_Name
  params: {
    tags: tags
    virtualNetwork_Location: virtualNetwork_Location
    virtualNetwork_Mask: virtualNetwork_Mask
    virtualNetwork_Name: virtualNetwork_Name
    virtualNetwork_PrefixFirstOct: virtualNetwork_PrefixFirstOct
    virtualNetwork_PrefixSecondOct: virtualNetwork_PrefixSecondOct
    virtualNetwork_PrefixThirdOct: virtualNetwork_PrefixThirdOct
    virtualNetwork_Subnets: virtualNetwork_Subnets
    virtualNetwork_DNSServers: virtualNetwork_DNSServers
  }
}

// module virtualMachine '.modules/compute/vmWindows.bicep' = {
//   scope: resourceGroup(virtualMachine_RG.name)
//   name: virtualMachine_Name
//   params: {
//     tags: tags
//     networkInterface_NetworkSecurityGroupId: networkSecurityGroup.id
//     networkSecurityGroup_Rules: networkSecurityGroup_Rules
//     networkInterface_PrivateIpAddress: networkInterface_PrivateIpAddress
//     networkInterface_SubnetId: networkInterface_SubnetId
//     virtualMachine_AdminPassword: virtualMachine_AdminPassword
//     virtualMachine_Name: virtualMachine_Name
//   }
//   dependsOn: [
//     networkSecurityGroup
//   ]
// }

//////////////////////////////////  OUTPUT  //////////////////////////////////
