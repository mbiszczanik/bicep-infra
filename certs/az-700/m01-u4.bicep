/*
SUMMARY: Az-700 hands-on labs
DESCRIPTION: M01 - Unit 4 Design and implement a Virtual Network in Azure
AUTHOR/S: Marcin Biszczanik
VERSION: 1.0
URI: https://learn.microsoft.com/en-us/training/modules/introduction-to-azure-virtual-networks/4-exercise-design-implement-virtual-network-azure

New-AzResourceGroupDeployment -TemplateFile .\m01-u4.bicep -Location 'eastus' -Name "Az-700" -Verbose

*/

//////////////////////////////////  PARAMETERS //////////////////////////////////

param location_eastus string = 'eastus'
param location_westeurope string = 'westeurope'
param location_southeastasia string = 'southeastasia'

//////////////////////////////////  VARIABLES //////////////////////////////////

var tags = {
  Environment: 'Training'
}

var virtualNetwork_ResearchVnet_Name = 'ResearchVnet'
var virtualNetwork_CoreServicesVnet_Name = 'CoreServicesVnet'
var virtualNetwork_ManufacturingVnet_Name = 'ManufacturingVnet'

////////////////////////////////// RESOURCES //////////////////////////////////

resource virtualNetwork_CoreServicesVnet 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetwork_ResearchVnet_Name
  location: location_eastus
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.20.0.0/27'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'DatabaseSubnet'
        properties: {
          addressPrefix: '10.20.20.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'SharedServiceSubnet'
        properties: {
          addressPrefix: '10.20.10.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'PublicWebServiceSubnet'
        properties: {
          addressPrefix: '10.20.30.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

resource virtualNetwork_ManufacturingVnet 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetwork_CoreServicesVnet_Name
  location: location_westeurope
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.30.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'ManufacturingSystemSubnet'
        properties: {
          addressPrefix: '10.30.10.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'SensorSubnet1'
        properties: {
          addressPrefix: '10.30.20.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'SensorSubnet2'
        properties: {
          addressPrefix: '10.30.21.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'SensorSubnet3'
        properties: {
          addressPrefix: '10.30.22.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

resource virtualNetwork_ResearchVnet 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetwork_ManufacturingVnet_Name
  location: location_southeastasia
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.40.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'ResearchSystemSubnet'
        properties: {
          addressPrefix: '10.40.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
