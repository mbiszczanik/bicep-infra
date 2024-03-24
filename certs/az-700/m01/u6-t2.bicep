/*
// Task 2: Link subnet for auto registration

To be verified
*/

param privateDNSZone_Name string = 'contoso.com'
param privateDnsZones_contoso_com_name_resource string = resourceId('Microsoft.Network/privateDnsZones', privateDNSZone_Name)
param virtualNetworks_CoreServicesVnet_externalid string = '/subscriptions/033dd423-eb29-4416-90cd-a47c6bebf420/resourceGroups/ContosoResourceGroup/providers/Microsoft.Network/virtualNetworks/CoreServicesVnet'
param virtualNetworks_ManufacturingVnet_externalid string = '/subscriptions/033dd423-eb29-4416-90cd-a47c6bebf420/resourceGroups/ContosoResourceGroup/providers/Microsoft.Network/virtualNetworks/ManufacturingVnet'
param virtualNetworks_ResearchVnet_externalid string = '/subscriptions/033dd423-eb29-4416-90cd-a47c6bebf420/resourceGroups/ContosoResourceGroup/providers/Microsoft.Network/virtualNetworks/ResearchVnet'

resource privateDnsZones_contoso_com_name_coreservicesvnetlink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  name: '${privateDnsZones_contoso_com_name_resource}/coreservicesvnetlink'
  location: 'global'
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: virtualNetworks_CoreServicesVnet_externalid
    }
  }
}

resource privateDnsZones_contoso_com_name_manufacturingvnetlink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  name: '${privateDnsZones_contoso_com_name_resource}/manufacturingvnetlink'
  location: 'global'
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: virtualNetworks_ManufacturingVnet_externalid
    }
  }
}

resource privateDnsZones_contoso_com_name_researchvnetlink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  name: '${privateDnsZones_contoso_com_name_resource}/researchvnetlink'
  location: 'global'
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: virtualNetworks_ResearchVnet_externalid
    }
  }
}

