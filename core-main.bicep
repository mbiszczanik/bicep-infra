/*
SUMMARY: Backbone resources for infrastracture repo
DESCRIPTION: TBA
AUTHOR/S: Marcin Biszczanik
VERSION: 0.0.3
*/

///// SCOPE
targetScope = 'subscription'


//////////////////////////////////  PARAMETERS //////////////////////////////////
///// RESOURCEGROUP /////
param resourceGroup_Location string = deployment().location
///// RESOURCEGROUP /////

///// VNET /////
param virtualNetwork_Location string = deployment().location
param virtualNetwork_Mask string = '24'
param virtualNetwork_PrefixFirstOct string = '172' 
param virtualNetwork_PrefixSecondOct string = '17'
param virtualNetwork_PrefixThirdOct string = '1'
param virtualNetwork_DNSServers array = []
///// VNET /////



//////////////////////////////////  VARIABLES //////////////////////////////////
var tags = {
  Environment: 'General'
  Location: 'North Europe'
}

var resourceGroup_Name = 'Core-WEU-VNET-RG'

var virtualNetwork_Name = 'Core-WEU-VNET01'
var virtualNetwork_Subnets = [
  {
    name: 'CoreSubnet'
    properties:{
      addressPrefix: '172.17.1.0/24' // '${virtualNetwork_PrefixFirstOct}.${virtualNetwork_PrefixSecondOct}.${virtualNetwork_PrefixThirdOct}.0./24'
    }
  }
]


////////////////////////////////// EXISTING RESOURCES //////////////////////////////////



////////////////////////////////// RESOURCES //////////////////////////////////
///// RESOURCE GROUP /////
module resourceGroup_VNET 'modules/resources/resourceGroup.bicep' = {
  name: resourceGroup_Name
  params: {
    resourceGroup_Location: resourceGroup_Location
    resourceGroup_Name: resourceGroup_Name
    tags: {
    }
  }
}

///// VNET /////
module virtualNetwork 'modules/network/virtualNetwork.bicep' = {
  scope: resourceGroup(resourceGroup_VNET.name)
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
