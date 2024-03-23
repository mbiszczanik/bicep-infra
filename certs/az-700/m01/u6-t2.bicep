// Task 2: Link subnet for auto registration

param privateDNSZone_Name string = 'contoso.com'
param privateDnsZones_contoso_com_name_resource string = resourceId('Microsoft.Network/privateDnsZones', privateDNSZone_Name)
param virtualNetworks_CoreServicesVnet_externalid string = '/subscriptions/033dd423-eb29-4416-90cd-a47c6bebf420/resourceGroups/ContosoResourceGroup/providers/Microsoft.Network/virtualNetworks/CoreServicesVnet'


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
