# Bicep infrastructure
Small projects and templates for Bicep

# How to:
az bicep install && az bicep upgrade

## PowerShell
```
Connect-AzAccount
Get-AzSubscription
Select-AzSubscription [Subscription ID]

# Current way deployment
New-AzSubscriptionDeployment -Name "Core-main" -Location "North Europe" -TemplateFile .\core-main.bicep -Verbose

# Working on what-if condition
New-AzSubscriptionDeployment `
-Confirm `
-WhatIfResultFormat FullResourcePayloads `
-Name "core-main" `
-TemplateFile .\core-main.bicep `
-Location "North Europe" `
-Verbose

# Check -mode flag
# -Mode Complete `
```

## Az CLI
```
az login
az account list
az account set --subscription {Subscription ID}

# Working on what-if deployment
az deployment sub create \
--mode Complete \
--confirm-with-what-if \
--result-format FullResourcePayloads \
--name core-main \
--template-file .\core-main.bicep \
--location northeurope \
--verbose

```

# To be added:
- AKS
- VM
- Bastion
- CI/CD
