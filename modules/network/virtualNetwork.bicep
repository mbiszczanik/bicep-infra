/*
SUMMARY: Virtual Network resource
DESCRIPTION: 
AUTHOR/S: Marcin Biszczanik
VERSION: 1.0
*/

//////////////////////////////////  PARAMETERS //////////////////////////////////
@description('The VNET resource name.')
param virtualNetwork_Name string
@description('The VNET location name.')
param virtualNetwork_Location string
@description('The VNET tags.')
param tags object

@description('The first octet of the VNET IP range.')
param virtualNetwork_PrefixFirstOct string
@description('The second octet of the VNET IP range.')
param virtualNetwork_PrefixSecondOct string
@description('The third octet of the VNET IP range.')
param virtualNetwork_PrefixThirdOct string
@description('The mask of the VNET.')
param virtualNetwork_Mask string
@description('List of DNS servers')
param virtualNetwork_DNSServers array = []
@description('List of subnets in the VNET')
param virtualNetwork_Subnets array = []

//////////////////////////////////  RESOURCES //////////////////////////////////
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: virtualNetwork_Name
  location: virtualNetwork_Location
  tags: tags
  properties:{
    addressSpace:{
      addressPrefixes:[ 
        '${virtualNetwork_PrefixFirstOct}.${virtualNetwork_PrefixSecondOct}.${virtualNetwork_PrefixThirdOct}.0/${virtualNetwork_Mask}'
      ]
    }
    dhcpOptions:{
      dnsServers: virtualNetwork_DNSServers
    }
    subnets: virtualNetwork_Subnets
  }
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
output virtualNetwork_Name string = virtualNetwork.name
output virtualNetwork_Id string = virtualNetwork.id
output virtualNetwork_ResourceGroupName string = resourceGroup().name
