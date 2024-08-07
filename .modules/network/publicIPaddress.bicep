/*
SUMMARY: Public IP adress
DESCRIPTION: 
AUTHOR/S: Marcin Biszczanik
VERSION: 1.0
URI: 
*/

//////////////////////////////////  PARAMETERS //////////////////////////////////

param publicIpAddress_Name string
param publicIpAddress_Location string = resourceGroup().location
param tags object

@allowed([
  'Basic'
  'Standard'
])
@description('Name of a public IP address SKU.')
param publicIpAddress_SkuName string = 'Basic'

@allowed([
  'Global'
  'Regional'
])
@description('Tier of a public IP address SKU.')
param publicIpAddress_SkuTier string = 'Regional'

@allowed([
  'Delete'
  'Detach'
])
@description('Specify what happens to the public IP address when the VM using it is deleted.')
param publicIpAddress_DeleteOption string = 'Detach'

@allowed([
  'IPv4'
  'IPv6'
])
@description('IP address version.')
param publicIpAddress_IPAddressVersion  string = 'IPv4'

@allowed([
  'Dynamic'
  'Static'
])
@description('IP address allocation method.')
param publicIpAddress_IPAllocationMethod string = 'Static'

//////////////////////////////////  VARIABLES //////////////////////////////////

////////////////////////////////// RESOURCES //////////////////////////////////

resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2024-01-01' = {
  name: publicIpAddress_Name
  location: publicIpAddress_Location
  tags: tags
  sku: {
    name: publicIpAddress_SkuName
    tier: publicIpAddress_SkuTier
  }
  properties: {
    deleteOption: publicIpAddress_DeleteOption
    publicIPAddressVersion: publicIpAddress_IPAddressVersion 
    publicIPAllocationMethod: publicIpAddress_IPAllocationMethod
  }
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
output publicIpAddress_Name string = publicIpAddress.name
output publicIpAddress_Id string = publicIpAddress.id
