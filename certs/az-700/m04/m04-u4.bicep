/*
SUMMARY: 
DESCRIPTION: 
AUTHOR/S: Marcin Biszczanik
VERSION:
URI: 

New-AzResourceGroupDeployment `
-Name "Az-700" `
-ResourceGroupName "ContosoResourceGroup" `
-TemplateFile .\m04-u4.bicep `
-Verbose

*/

//////////////////////////////////  PARAMETERS //////////////////////////////////

param location_eastus string = 'eastus'

param virtualNetwork_Name string = 'IntLB-VNet'

param virtualNetworks_myBackendSubnet_Name string = 'myBackendSubnet'
param virtualNetworks_myFrontEndSubnet_Name string = 'myFrontEndSubnet'

param publicIPAdress_Bastion_Name string = 'myBastionIP'

param bastionHost_Name string = 'bastionHost_Name'

//////////////////////////////////  VARIABLES //////////////////////////////////


////////////////////////////////// RESOURCES //////////////////////////////////

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetwork_Name
  location: location_eastus
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'myBackendSubnet'
        properties: {
          addressPrefix: '10.1.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'myFrontEndSubnet'
        properties: {
          addressPrefix: '10.1.2.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

resource virtualNetworks_myBackendSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetwork
  name: virtualNetworks_myBackendSubnet_Name
  properties: {
    addressPrefix: '10.1.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_myFrontEndSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetwork
  name: virtualNetworks_myFrontEndSubnet_Name
  properties: {
    addressPrefix: '10.1.2.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource publicIPAdress_Bastion 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: publicIPAdress_Bastion_Name
  location: location_eastus
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource bastionHost 'Microsoft.Network/bastionHosts@2023-05-01' = {
  name: bastionHost_Name
  location: location_eastus
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: virtualNetworks_myFrontEndSubnet.id
          }
          publicIPAddress: {
            id: publicIPAdress_Bastion.id
          }
        }
      }
    ]
  }
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
