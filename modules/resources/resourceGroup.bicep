/*
SUMMARY: Resource Group resource
DESCRIPTION: 
AUTHOR/S: Marcin Biszczanik
VERSION: 1.0
*/

targetScope = 'subscription'

//////////////////////////////////  PARAMETERS //////////////////////////////////
param resourceGroup_Name string
param resourceGroup_Location string
param tags object

//////////////////////////////////  RESOURCES //////////////////////////////////
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroup_Name
  location: resourceGroup_Location
  tags: tags
}


//////////////////////////////////  OUTPUT  //////////////////////////////////
output resourceGroup_Name string = resourceGroup.name
output resourceGroup_Id string = resourceGroup.id



