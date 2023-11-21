/*
SUMMARY: Az-700 hands-on labs
DESCRIPTION: M01 - Unit 4 Design and implement a Virtual Network in Azure
AUTHOR/S: Marcin Biszczanik
VERSION: 1.0
URI: https://learn.microsoft.com/en-us/training/modules/introduction-to-azure-virtual-networks/4-exercise-design-implement-virtual-network-azure
*/

// New-AzSubscriptionDeployment -TemplateFile .\m01-u4.bicep -Location 'eastus' -Name "Az-700" -Verbose

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

var virtualNetwork_Subnet_CoreServices = [
  {
    name: 'GatewaySubnet'
    properties: {
      adressPrefix: '10.20.0.0/27'
      delegations: []
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
    }
  }
  {
    name: 'SharedServicesSubnet'
    properties: {
      adressPrefix: '10.20.10.0/24'
      delegations: []
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
    }
  }
  {
    name: 'DatabaseSubnet'
    properties: {
      adressPrefix: '10.20.0.0/24'
      delegations: []
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
    }
  }
  {
    name: 'PublicWebServiceSubnet'
    properties: {
      adressPrefix: '10.20.30.0/24'
      delegations: []
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
    }
  }
]

var virtualNetwork_Subnet_Manufacturing = [
  {
    name: 'ManufacturingSystemSubnet'
    properties: {
      adressPrefix: '10.30.10.0/24'
      delegations: []
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
    }
  }
  {
    name: 'SensorSubnet1'
    properties: {
      adressPrefix: '10.30.20.0/24'
      delegations: []
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
    }
  }
  {
    name: 'SensorSubnet2'
    properties: {
      adressPrefix: '10.30.21.0/24'
      delegations: []
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
    }
  }
  {
    name: 'SensorSubnet3'
    properties: {
      adressPrefix: '10.30.22.0/24'
      delegations: []
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
    }
  }
]

var virtualNetwork_Subnet_Research = [
  {
    name: 'ResearchSystemSubnet'
    properties: {
      adressPrefix: '10.40.0.0/24'
      delegations: []
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
    }
  }
]

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
    virtualNetwork_Subnets: virtualNetwork_Subnet_CoreServices
  }
  dependsOn:[
    resourceGroup_VNET
  ]
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
    virtualNetwork_Subnets: virtualNetwork_Subnet_Manufacturing
  }
  dependsOn:[
    resourceGroup_VNET
  ]
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
    virtualNetwork_Subnets: virtualNetwork_Subnet_Research
  }
  dependsOn:[
    resourceGroup_VNET
  ]
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
