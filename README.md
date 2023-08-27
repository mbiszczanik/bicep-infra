# Bicep infrastructure
Small projects and templates for Bicep

# How to:
az bicep install && az bicep upgrade

## Az CLI
```
az login
az account list
az account set --subscription {Subscription ID}

az deployment sub create \
--mode Complete \
--confirm-with-what-if \
--result-format FullResourcePayloads \
--name core-main \
--template-file .\core-main.bicep \
--location northeurope \
--verbose

az deployment sub create --mode Complete --confirm-with-what-if --result-format FullResourcePayloads --name g-core-main --location northeurope 

```

## PowerShell
```
Connect-AzAccount
Get-AzSubscription
Select-AzSubscription [Subscription ID]

New-AzSubscriptionDeployment `
-Confirm `
-WhatIfResultFormat FullResourcePayloads `
-Name "core-main" `
-TemplateFile .\core-main.bicep `
-Location "North Europe" `
-Verbose

-Mode Complete `
```

# To be added:
- AKS
- VM
- Bastion
- CI/CD
