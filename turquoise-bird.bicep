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
param virtualNetwork_Mask string = '24'
param virtualNetwork_PrefixFirstOct string = '10'
param virtualNetwork_PrefixSecondOct string = '1'
param virtualNetwork_PrefixThirdOct string = '0'
param virtualNetwork_DNSServers array = []
//////////////////////////////////  Virtual Network //////////////////////////////////

//////////////////////////////////  VARIABLES //////////////////////////////////

var tags = {
  Environment: 'Training'
  CostCenter: '00001'
  MSDN: 'MSDN'
}

var virtualNetwork_RG_Name = 'T-TB-VNET-RG01'

var virtualNetwork_Name = 'T-TB-VNET-O1'

var virtualNetwork_Subnets = [
  {
    name: 'CoreSubnet'
    properties: {
      addressPrefix: '${virtualNetwork_PrefixFirstOct}.${virtualNetwork_PrefixSecondOct}.${virtualNetwork_PrefixThirdOct}.0/24' // '172.17.1.0/24' //
    }
  }
]

////////////////////////////////// RESOURCES //////////////////////////////////

////////////////////////////////// Resource Groups //////////////////////////////////
module virtualNetwork_RG '.modules/resources/resourceGroup.bicep' = {
  name: virtualNetwork_RG_Name
  params: {
    tags: tags
    resourceGroup_Name: virtualNetwork_RG_Name
  }
}
////////////////////////////////// Resource Groups //////////////////////////////////

module virtualNetwork '.modules/network/virtualNetwork.bicep' = {
  name: virtualNetwork_Name
  scope: resourceGroup(virtualNetwork_RG.name)
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

//////////////////////////////////  OUTPUT  //////////////////////////////////
