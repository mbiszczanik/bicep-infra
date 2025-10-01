/*
SUMMARY: Az-700 hands-on labs
DESCRIPTION: M01 - Unit 6 Configure DNS settings in Azure; Task 2: Link subnet for auto registration
AUTHOR/S: Marcin Biszczanik
VERSION: 1.0.0
URI: https://learn.microsoft.com/en-us/training/modules/introduction-to-azure-virtual-networks/6-exercise-configure-domain-name-servers-configuration-azure
     https://microsoftlearning.github.io/AZ-700-Designing-and-Implementing-Microsoft-Azure-Networking-Solutions/Instructions/Exercises/M01-Unit%206%20Configure%20DNS%20settings%20in%20Azure.html
     
*/

//////////////////////////////////  PARAMETERS //////////////////////////////////

param privateDNSZone_Name string = 'contoso.com'
param virtualNetwork_CoreServicesVnet_Name string = 'CoreServicesVnet'
param virtualNetwork_ManufacturingVnet_Name string = 'ManufacturingVnet'
param virtualNetwork_ResearchVnet_Name string = 'ResearchVnet'

//////////////////////////////////  VARIABLES //////////////////////////////////

var tags = {
  Environment: 'Training'
  CostCenter: '00001'
  MSDN: 'MSDN'
}

////////////////////////////////// RESOURCES //////////////////////////////////

// Invoke existing resources deployed in previous tasks.
resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateDNSZone_Name
}

resource virtualNetwork_CoreServicesVnet 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  name: virtualNetwork_CoreServicesVnet_Name
}

resource virtualNetwork_ManufacturingVnet 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  name: virtualNetwork_ManufacturingVnet_Name
}

resource virtualNetwork_ResearchVnet 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  name: virtualNetwork_ResearchVnet_Name
}

// Task 2: Link subnet for auto registration
resource privateDnsZoneLink_CoreServicesVnet 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZone
  name: 'CoreServicesVnetLink'
  location: 'global'
  tags: tags
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: virtualNetwork_CoreServicesVnet.id
    }
  }
}

resource privateDnsZoneLink_ManufacturingVnet 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZone
  name: 'ManufacturingVnetLink'
  location: 'global'
  tags: tags
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: virtualNetwork_ManufacturingVnet.id
    }
  }
}

resource privateDnsZoneLink_ResearchVnet 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZone
  name: 'ResearchVnetLink'
  location: 'global'
  tags: tags
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: virtualNetwork_ResearchVnet.id
    }
  }
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
