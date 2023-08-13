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
param virtualNetwork_Location string 
param virtualNetwork_Mask string 
param virtualNetwork_PrefixFirstOct string 
param virtualNetwork_PrefixSecondOct string 
param virtualNetwork_PrefixThirdOct string
///// VNET /////



//////////////////////////////////  VARIABLES //////////////////////////////////
var resourceGroup_Name = 'G-Common-WEU-VNET-RG'
var virtualNetwork_Name = 'G-Common-WEU-VNET01'


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
    tags: {
    }
    virtualNetwork_Location: virtualNetwork_Location
    virtualNetwork_Mask: virtualNetwork_Mask
    virtualNetwork_Name: virtualNetwork_Name
    virtualNetwork_PrefixFirstOct: virtualNetwork_PrefixFirstOct
    virtualNetwork_PrefixSecondOct: virtualNetwork_PrefixSecondOct
    virtualNetwork_PrefixThirdOct: virtualNetwork_PrefixThirdOct
  }
}
