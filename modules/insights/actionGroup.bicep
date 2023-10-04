/*
SUMMARY: 
DESCRIPTION: 
AUTHOR/S: Marcin Biszczanik
VERSION:
URI: https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/actiongroups?pivots=deployment-language-bicep
*/

//////////////////////////////////  PARAMETERS //////////////////////////////////

param par_Name string
param par_Short_Name string
@description('The list of email receivers that are part of this action group.')
param par_Email_Receivers array = []
@description('The list of SMS receivers that are part of this action group.')
param par_SMS_Receivers array = []
@description('The list of webhook receivers that are part of this action group.')
param par_Webhook_Receivers array = []
@description('The list of event hub receivers that are part of this action group.')
param par_Event_Hub_Receivers array = []
@description('The list of ITSM receivers that are part of this action group.')
param par_ITSM_Receivers array = []
@description('The list of ITSM receivers that are part of this action group.')
param par_Azure_App_Push_Receivers array = []
@description('The list of AutomationRunbook receivers that are part of this action group.')
param par_Automation_Runbook_Receivers array = []
@description('The list of voice receivers that are part of this action group.')
param par_Voice_Receivers array = []
@description('The list of logic app receivers that are part of this action group.')
param par_Logic_App_Receivers array = []
@description('The list of logic app receivers that are part of this action group.')
param par_Azure_Function_Receivers array = []
@description('The list of ARM role receivers that are part of this action group. Roles are Azure RBAC roles and only built-in roles are supported.')
param par_ARM_Role_Receivers array = []

////////////////////////////////// RESOURCES //////////////////////////////////
resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: par_Name
  location: 'Global'
  properties: {
    groupShortName: par_Short_Name
    enabled: true
    emailReceivers: par_Email_Receivers
    smsReceivers: par_SMS_Receivers
    webhookReceivers: par_Webhook_Receivers
    eventHubReceivers: par_Event_Hub_Receivers
    itsmReceivers: par_ITSM_Receivers
    azureAppPushReceivers: par_Azure_App_Push_Receivers
    automationRunbookReceivers: par_Automation_Runbook_Receivers
    voiceReceivers: par_Voice_Receivers
    logicAppReceivers: par_Logic_App_Receivers
    azureFunctionReceivers: par_Azure_Function_Receivers
    armRoleReceivers: par_ARM_Role_Receivers
  }
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
output actionGroup_Name string = actionGroup.name
output actionGroup_Id string = actionGroup.id
