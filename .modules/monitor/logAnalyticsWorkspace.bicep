/*
SUMMARY: 
DESCRIPTION: 
AUTHOR/S: Marcin Biszczanik
VERSION:
URI: https://learn.microsoft.com/en-us/azure/templates/microsoft.operationalinsights/workspaces?pivots=deployment-language-bicep
*/

//////////////////////////////////  PARAMETERS //////////////////////////////////

param logAnalytics_Name string
param logAnalytics_Location string = resourceGroup().location
param tags object

param logAnalytics_RetentionInDays int = 120
param logAnalytics_Sku string = 'Free'

//////////////////////////////////  VARIABLES //////////////////////////////////


////////////////////////////////// RESOURCES //////////////////////////////////

resource logAnaylits 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalytics_Name
  location: logAnalytics_Location
  tags: tags
  properties: {
    retentionInDays: logAnalytics_RetentionInDays 
    sku: {
      name: logAnalytics_Sku
    }
  }
  
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
output logAnalytics_Name string = logAnaylits.name
output logAnalytics_Id string = logAnaylits.id
