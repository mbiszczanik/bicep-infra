## Login
```Powershell
Connect-AzAccount
Select-AzSubscription 
```

## Deploy resources
```Powershell
New-AzSubscriptionDeployment `
-Name "VNet-Manager-demo" `
-TemplateFile .\demos\VNet-manager-main.bicep `
-Location "North Europe" `
-Verbose
```

## Clean up resources
```Powershell
Remove-AzResourceGroup -Name Hub01-WEU-VNET-RG -Force -AsJob
Remove-AzResourceGroup -Name Spoke01-WEU-VNET-RG -Force -AsJob
Remove-AzResourceGroup -Name Spoke02-WEU-VNET-RG -Force -AsJob
```