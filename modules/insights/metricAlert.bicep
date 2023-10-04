/*
SUMMARY: Metric Alert resource
DESCRIPTION: 
AUTHOR/S: Marcin Biszczanik
VERSION: 1.0
URI: https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/metricalerts?pivots=deployment-language-bicep
*/

//////////////////////////////////  PARAMETERS //////////////////////////////////
param metricAlert_Name string
param location string = 'global'
param tags object

param metricAlert_Description string
param metricAlert_Criteria object
param metricAlert_EvalFrequency string
param metricAlert_Scope string[]
param metricAlert_Severity int
param metricAlert_WindowsSize string
param metricAlert_Action array
param metricAlert_Target_ResourceType string
param metricAlert_Target_ResourceRegion string


////////////////////////////////// RESOURCES //////////////////////////////////
resource metricAlertRule 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: metricAlert_Name
  location: location
  properties: {
    description: metricAlert_Description
    criteria: metricAlert_Criteria
    enabled: true
    evaluationFrequency: metricAlert_EvalFrequency 
    scopes: metricAlert_Scope
    severity: metricAlert_Severity
    windowSize: metricAlert_WindowsSize
    actions: metricAlert_Action
    autoMitigate: true
    targetResourceType: metricAlert_Target_ResourceType
    targetResourceRegion: metricAlert_Target_ResourceRegion
  }
  tags: tags
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
output metricAlert_Name string = metricAlertRule.name
output metricAlert_Id string = metricAlertRule.id

