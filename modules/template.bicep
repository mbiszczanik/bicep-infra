/*
SUMMARY: 
DESCRIPTION: 
AUTHOR/S:
VERSION:
URI: 

@@@---------- MANUAL TESTING & DEPLOYMENT ----------@@@
Connect-AzAccount -TenantId <Azure Tenant ID>

Select-AzSubscription <Azure Subscription>

###---------- Development ----------###
New-AzSubscriptionDeployment `
-Name "XYZ" `
-Location "North Europe" `
-TemplateFile .\main.bicep `
-TemplateParameterFile .\parameters\development.bicepparam `
-Verbose `
-Whatif

*/

/////---------- TARGET SCOPE ----------/////

/////---------- PARAMETERS ----------/////

/////---------- VARIABLES ----------/////

/////---------- RESOURCES ----------/////

/////---------- OUTPUTS ----------/////
