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
--name g-common-main \
--template-file .\g-common-main.bicep \
--location northeurope \
```

## PowerShell
```
Connect-AzAccount
Get-AzSubscription
Select-AzSubscription [Subscription ID]

New-AzSubscriptionDeployment `
-Mode Complete `
-Confirm `
-Name "g-common-main" `
-TemplateFile .\g-common-main.bicep `
-Location "North Europe"
```

# To be added:
- AKS
- VM
- Bastion
- CI/CD
