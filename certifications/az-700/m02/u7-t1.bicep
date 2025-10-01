/*
Task 1: Create a Virtual WAN
*/
param virtualWan_name string = 'ContosoVirtualWAN'
param location string = 'westus'

resource virtualWAN_Contoso 'Microsoft.Network/virtualWans@2023-05-01' = {
  name: virtualWan_name
  location: location
  properties: {
    type: 'Standard'
    disableVpnEncryption: false
    allowBranchToBranchTraffic: true
    allowVnetToVnetTraffic: true
  }
}
