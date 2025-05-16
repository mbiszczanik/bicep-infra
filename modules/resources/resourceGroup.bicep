/*
SUMMARY: Resource Group resource
DESCRIPTION: Deploys an Azure Resource Group with tags.
AUTHOR/S: Marcin Biszczanik
VERSION: 1.1
*/

/*******************
*   Target Scope   *
*******************/
targetScope = 'subscription'

/*******************
*    Parameters    *
*******************/
@description('The name of the Resource Group.')
param parResourceGroupName string

@description('The Azure region for the Resource Group.')
param parLocation string = deployment().location

@description('Tags to be applied to the Resource Group.')
param parTags object = {}

/*******************
*    Variables     *
*******************/
var varResourceGroupName = parResourceGroupName

/*******************
*    Resources     *
*******************/
resource resResourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: varResourceGroupName
  location: parLocation
  tags: parTags
}

/******************
*     Outputs     *
******************/
output resourceGroupName string = resResourceGroup.name
output resourceGroupId string = resResourceGroup.id



