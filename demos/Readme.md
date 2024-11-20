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
Remove-AzResourceGroup -Name Contoso-WEU-VNET-RG -Force -AsJob
Remove-AzResourceGroup -Name Fabrikam-WEU-VNET-RG -Force -AsJob
Remove-AzResourceGroup -Name Tailwind-WEU-VNET-RG -Force -AsJob
```