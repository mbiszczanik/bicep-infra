/*
Task 2: Create a hub
*/
param virtualWan_name string = 'ContosoVirtualWAN'
param virtualHub_name string = 'ContosoVirtualWANHub-WestUS'
param location_westus string = 'westus'

resource virtualWANHub_Contoso_WESTUS 'Microsoft.Network/virtualHubs@2023-05-01' = {
  name: virtualHub_name
  location: location_westus
  properties: {
    addressPrefix: '10.60.0.0/24'
    virtualWan: {
      id: resourceId('Microsoft.Network/virtualWans', virtualWan_name)
    }
  }
}
