/*
SUMMARY: Az-700 hands-on labs
DESCRIPTION: First lab
AUTHOR/S: Marcin Biszczanik
VERSION: 1.0
URI: 
*/

targetScope = 'subscription'

//////////////////////////////////  PARAMETERS //////////////////////////////////

param deploymentLocation string = deployment().location

//////////////////////////////////  Variables //////////////////////////////////
var tags = {
  Environment: 'Training'
}

var resourceGroup_VNET_Name = 'ContosoResourceGroup'
var virtualNetwork_ResearchVnet_Name = 'ResearchVnet'
var virtualNetwork_CoreServicesVnet_Name = 'CoreServicesVnet'
var virtualNetwork_ManufacturingVnet_Name = 'ManufacturingVnet'

////////////////////////////////// RESOURCES //////////////////////////////////
module resourceGroup_VNET '../../modules/resources/resourceGroup.bicep' = {
  name: resourceGroup_VNET_Name
  params: {
    resourceGroup_Name: resourceGroup_VNET_Name
    tags: tags
    resourceGroup_Location: deploymentLocation
  }
}

module virtualNetwork_CoreServicesVnet '../../modules/network/virtualNetwork.bicep' = {
  scope: resourceGroup(resourceGroup_VNET.name)
  name: virtualNetwork_CoreServicesVnet_Name
  params: {
    tags: tags
    virtualNetwork_Location: 'eastus'
    virtualNetwork_Mask: '16'
    virtualNetwork_Name: virtualNetwork_CoreServicesVnet_Name
    virtualNetwork_PrefixFirstOct: '10'
    virtualNetwork_PrefixSecondOct: '20'
    virtualNetwork_PrefixThirdOct: '0'
  }
}

module virtualNetwork_ManufacturingVnet '../../modules/network/virtualNetwork.bicep' = {
  scope: resourceGroup(resourceGroup_VNET.name)
  name: virtualNetwork_ManufacturingVnet_Name
  params: {
    tags: tags
    virtualNetwork_Location: 'westeurope'
    virtualNetwork_Mask: '16'
    virtualNetwork_Name: virtualNetwork_ManufacturingVnet_Name
    virtualNetwork_PrefixFirstOct: '10'
    virtualNetwork_PrefixSecondOct: '30'
    virtualNetwork_PrefixThirdOct: '0'
  }
}

module virtualNetwork_ResearchVnet '../../modules/network/virtualNetwork.bicep' = {
  scope: resourceGroup(resourceGroup_VNET.name)
  name: virtualNetwork_ResearchVnet_Name
  params: {
    tags: tags
    virtualNetwork_Location: 'southeastasia'
    virtualNetwork_Mask: '16'
    virtualNetwork_Name: virtualNetwork_ResearchVnet_Name
    virtualNetwork_PrefixFirstOct: '10'
    virtualNetwork_PrefixSecondOct: '40'
    virtualNetwork_PrefixThirdOct: '0'
  }
}



//////////////////////////////////  OUTPUT  //////////////////////////////////




