## 1. Login
```Powershell
Connect-AzAccount
Set-AzContext -Subscription <subscription name or id>
```
## 2. Deploy Bicep or use script AVNM.ps1
```Powershell
New-AzSubscriptionDeployment `
-Name "VNet-Manager-demo" `
-TemplateFile .\demos\avnm\VNet-manager-main.bicep `
-Location "North Europe" `
-Verbose
```
## Clean up resources
```Powershell
Remove-AzResourceGroup -Name Hub01-WEU-VNET-RG -Force -AsJob
Remove-AzResourceGroup -Name Spoke01-NEU-VNET-RG -Force -AsJob
Remove-AzResourceGroup -Name Spoke02-NEU-VNET-RG -Force -AsJob
```