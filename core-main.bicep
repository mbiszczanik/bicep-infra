/*
SUMMARY: Backbone resources for infrastracture repo
DESCRIPTION: TBA
AUTHOR/S: Marcin Biszczanik
VERSION: 0.0.3
*/

///// SCOPE
targetScope = 'subscription'


//////////////////////////////////  PARAMETERS //////////////////////////////////
param deploymentLocation string = deployment().location

///// VNET /////
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

var resourceGroup_VNET_Name = 'Core-WEU-VNET-RG'
var resourceGroup_AKS_Name = 'Core-WEU-AKS-RG'

var virtualNetwork_Name = 'Core-WEU-VNET01'
var virtualNetwork_Subnets = [
  {
    name: 'CoreSubnet'
    properties:{
      addressPrefix: '172.17.1.0/24' // '${virtualNetwork_PrefixFirstOct}.${virtualNetwork_PrefixSecondOct}.${virtualNetwork_PrefixThirdOct}.0./24'
    }
  }
]

var aksCluster_Name = 'Core-WEU-AKS01'

////////////////////////////////// EXISTING RESOURCES //////////////////////////////////



////////////////////////////////// RESOURCES //////////////////////////////////
///// RESOURCE GROUP /////
module resourceGroup_VNET 'modules/resources/resourceGroup.bicep' = {
  name: resourceGroup_VNET_Name
  params: {
    resourceGroup_Location: deploymentLocation
    resourceGroup_Name: resourceGroup_VNET_Name
    tags: tags
  }
}

module resourceGroup_AKSCluster 'modules/resources/resourceGroup.bicep' = {
  name: resourceGroup_AKS_Name
  params: {
    resourceGroup_Location: deploymentLocation
    resourceGroup_Name: resourceGroup_AKS_Name
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
    virtualNetwork_Location: deploymentLocation
    virtualNetwork_Mask: virtualNetwork_Mask
    virtualNetwork_Name: virtualNetwork_Name
    virtualNetwork_PrefixFirstOct: virtualNetwork_PrefixFirstOct
    virtualNetwork_PrefixSecondOct: virtualNetwork_PrefixSecondOct
    virtualNetwork_PrefixThirdOct: virtualNetwork_PrefixThirdOct
    virtualNetwork_Subnets: virtualNetwork_Subnets
    virtualNetwork_DNSServers: virtualNetwork_DNSServers
  }
}

module aksCluster 'modules/microservices/aksCluster.bicep' = {
  scope: resourceGroup(resourceGroup_AKSCluster.name)
  name: aksCluster_Name
  params: {
    aks_Location: deploymentLocation
    aks_Name: aksCluster_Name
    aks_SshPublicKey: ''
  }
}
