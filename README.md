# Bicep infrastructure
Small projects and templates for Bicep

# How to:
az bicep install && az bicep upgrade

## Bash
```
az login
az account list
az account set --subscription {Subscription ID}
az deployment sub create --name g-common-main --location northeurope --template-file .\g-common-main.bicep --verbose

```

## PowerShell
```
Connect-AzAccount
Get-AzSubscription
Select-AzSubscription [Subscription ID]
New-AzSubscriptionDeployment -Name "g-common-main" -Location "North Europe" -TemplateFile .\g-common-main.bicep -Verbose

-TemplateParameterFile .\.parameters\g-common-main.json
```

# To be added:
- AKS
- VM
- Bastion
- CI/CD
