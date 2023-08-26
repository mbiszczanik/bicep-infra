/*
SUMMARY: NSG resource
DESCRIPTION: 
AUTHOR/S: Marcin Biszczanik
VERSION: 1.0
*/

//////////////////////////////////  PARAMETERS //////////////////////////////////
param networkSecurityGroup_Name string
param networkSecurityGroup_Location string = resourceGroup().location
param tags object

param networkSecurityGroup_Rules array = []

////////////////////////////////// RESOURCES //////////////////////////////////
resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: networkSecurityGroup_Name
  location: networkSecurityGroup_Location
  tags: tags
  properties:{
    securityRules: networkSecurityGroup_Rules
  }
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
output networkSecurityGroup_Id string = networkSecurityGroup.id
output networkSecurityGroup_Name string = networkSecurityGroup.name
