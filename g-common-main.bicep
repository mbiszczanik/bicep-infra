/*
SUMMARY: Backbone resources for infrastracture repo
DESCRIPTION: TBA
AUTHOR/S: Marcin Biszczanik
VERSION: 0.0.2
*/

///// SCOPE
targetScope = 'subscription'


//////////////////////////////////  PARAMETERS //////////////////////////////////
///// VNET 
param virtualNetwork_Location string 
param virtualNetwork_Mask string 
param virtualNetwork_PrefixFirstOct string 
param virtualNetwork_PrefixSecondOct string 
param virtualNetwork_PrefixThirdOct string
///// VNET /////



//////////////////////////////////  VARIABLES //////////////////////////////////
var virtualNetwork_Name = 'G-Common-WEU-VNET-RG'


////////////////////////////////// EXISTING RESOURCES //////////////////////////////////



////////////////////////////////// RESOURCES //////////////////////////////////
module virtualNetwork 'modules/network/virtualNetwork.bicep' = {
  scope: resourceGroup()
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
