/*
SUMMARY: Metric Alert resource
DESCRIPTION: 
AUTHOR/S: Marcin Biszczanik
VERSION: 1.1
URI: https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/metricalerts?pivots=deployment-language-bicep
*/

//////////////////////////////////  PARAMETERS //////////////////////////////////
param metricAlert_Name string
param location string = 'global'
param tags object

@description('The description of the metric alert that will be included in the alert email.')
param metricAlert_Description string
@description('Defines the specific alert criteria information.')
param metricAlert_Criteria object
/* Example
{
      allOf: [
        {
          threshold: 85
          name: 'Metric1'
          metricNamespace: 'Microsoft.Sql/servers/databases'
          metricName: 'cpu_percent'
          operator: 'GreaterThan'
          timeAggregation: 'Average'
          skipMetricValidation: false
          criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
*/
@description('How often the metric alert is evaluated represented in ISO 8601 duration format e.g. PT1M.')
param metricAlert_EvalFrequency string
@description('The list of resource ids that this metric alert is scoped to.')
param metricAlert_Scope string[]
/* Example
    [
      lemonEdgeDataBase.outputs.azureSqlDbId
    ]
*/

@description('Alert severity {0, 1, 2, 3, 4}')
param metricAlert_Severity int
@description('The period of time (in ISO 8601 duration format) that is used to monitor alert activity based on the threshold e.g. PT15M')
param metricAlert_WindowsSize string
@description('The array of actions that are performed when the alert rule becomes active, and when an alert condition is resolved.')
param metricAlert_Action array
/* Example
    [
      {
        actionGroupId: mod_ActionGroup.outputs.out_Action_Group_ID
        webHookProperties: {}
      }
    ]
*/

@description('The resource type of the target resource(s) on which the alert is created/updated. Mandatory if the scope contains a subscription, resource group, or more than one resource.')
param metricAlert_Target_ResourceType string
@description('The region of the target resource(s) on which the alert is created/updated. Mandatory if the scope contains a subscription, resource group, or more than one resource.')
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
