/*
SUMMARY: 
DESCRIPTION: 
AUTHOR/S: Marcin Biszczanik
VERSION:
URI: https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/actiongroups?pivots=deployment-language-bicep
*/

//////////////////////////////////  PARAMETERS //////////////////////////////////
param actionGroup_Name string
param actionGroup_Short_Name string
@description('The list of email receivers that are part of this action group.')
param actionGroup_Email_Receivers array = []
@description('The list of SMS receivers that are part of this action group.')
param actionGroup_SMS_Receivers array = []
@description('The list of webhook receivers that are part of this action group.')
param actionGroup_Webhook_Receivers array = []
@description('The list of event hub receivers that are part of this action group.')
param actionGroup_Event_Hub_Receivers array = []
@description('The list of ITSM receivers that are part of this action group.')
param actionGroup_ITSM_Receivers array = []
@description('The list of ITSM receivers that are part of this action group.')
param actionGroup_Azure_App_Push_Receivers array = []
@description('The list of AutomationRunbook receivers that are part of this action group.')
param actionGroup_Automation_Runbook_Receivers array = []
@description('The list of voice receivers that are part of this action group.')
param actionGroup_Voice_Receivers array = []
@description('The list of logic app receivers that are part of this action group.')
param actionGroup_Logic_App_Receivers array = []
@description('The list of logic app receivers that are part of this action group.')
param actionGroup_Azure_Function_Receivers array = []
@description('The list of ARM role receivers that are part of this action group. Roles are Azure RBAC roles and only built-in roles are supported.')
param actionGroup_ARM_Role_Receivers array = []

////////////////////////////////// RESOURCES //////////////////////////////////
resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: actionGroup_Name
  location: 'Global'
  properties: {
    groupShortName: actionGroup_Short_Name
    enabled: true
    emailReceivers: actionGroup_Email_Receivers
    smsReceivers: actionGroup_SMS_Receivers
    webhookReceivers: actionGroup_Webhook_Receivers
    eventHubReceivers: actionGroup_Event_Hub_Receivers
    itsmReceivers: actionGroup_ITSM_Receivers
    azureAppPushReceivers: actionGroup_Azure_App_Push_Receivers
    automationRunbookReceivers: actionGroup_Automation_Runbook_Receivers
    voiceReceivers: actionGroup_Voice_Receivers
    logicAppReceivers: actionGroup_Logic_App_Receivers
    azureFunctionReceivers: actionGroup_Azure_Function_Receivers
    armRoleReceivers: actionGroup_ARM_Role_Receivers
  }
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
output actionGroup_Name string = actionGroup.name
output actionGroup_Id string = actionGroup.id
