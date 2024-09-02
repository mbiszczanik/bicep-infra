/*
SUMMARY: NIC resource
DESCRIPTION: 
AUTHOR/S: Marcin Biszczanik
VERSION: 1.0
*/

//////////////////////////////////  PARAMETERS //////////////////////////////////
param networkInterface_Name string
param networkInterface_Location string = resourceGroup().location
param tags object

param networkInterface_SubnetId string

param networkInterface_NetworkSecurityGroupId string

@description('IP address version.')
param networkInterface_IPAddressVersion string = 'IPv4'

@allowed([
  'Dynamic'
  'Static'
])
@description('IP address allocation method')
param networkInterface_PrivateIpAllocationMethod string = 'Static'

@description('Private IP address resource')
param networkInterface_PrivateIpAddress string

@description('Application Security Group where IP config is attached')
param networkInterface_ApplicationSecurityGroupId array = []

@description('Public IP address resource.')
param networkInterface_PublicIPAddressId string = ''

@allowed([
  'Elastic'
  'Standard'
])
@description('Type network interface resource')
param networkInterface_Type string = 'Standard'

////////////////////////////////// RESOURCES //////////////////////////////////
resource networkInterface 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: networkInterface_Name
  location: networkInterface_Location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddressVersion: networkInterface_IPAddressVersion
          privateIPAllocationMethod: networkInterface_PrivateIpAllocationMethod
          privateIPAddress: networkInterface_PrivateIpAddress
          applicationSecurityGroups: networkInterface_ApplicationSecurityGroupId
          publicIPAddress: networkInterface_PublicIPAddressId == '' ? null : {
            id: networkInterface_PublicIPAddressId
          }   
          subnet: {
            id: networkInterface_SubnetId
          }
        }
      }
    ]
    // If there is an ID, an object with it inside is created, if not, it passes null.
    networkSecurityGroup: (networkInterface_NetworkSecurityGroupId != '') ? {id: networkInterface_NetworkSecurityGroupId} : null
    nicType: networkInterface_Type

  }
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
output networkInterface_Id string = networkInterface.id
output networkInterface_Name string = networkInterface.name
