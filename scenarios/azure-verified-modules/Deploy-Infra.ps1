$location = 'swedencentral'
$resourceGroupName = 'd-avm-swc-rg-01'

New-AzResourceGroup -Name $resourceGroupName -Location $location -Tag @{ 'CostCenter' = 'MSDN' }

New-AzResourceGroupDeployment `
-Name "Azure-Verified-Modules" `
-ResourceGroupName $resourceGroupName `
-TemplateFile .\avm-main.bicep `
-Verbose