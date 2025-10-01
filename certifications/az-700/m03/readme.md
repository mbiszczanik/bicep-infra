# Unit 04
## Task 1:
```Powershell
New-AzResourceGroup -Name ContosoResourceGroup -Location "East US"


New-AzResourceGroupDeployment `
-Name "Az-700" `
-ResourceGroupName "ContosoResourceGroup" `
-TemplateFile .\u4-t1.bicep `
-Verbose


New-AzResourceGroupDeployment `
-Name "Az-700" `
-ResourceGroupName "ContosoResourceGroup" `
-TemplateFile .\u4-t2.bicep `
-Verbose
```


# Unit 05
## Task 1: Create and provision an ExpressRoute circuit
```Powershell
New-AzResourceGroup -Name ExpressRouteResourceGroup -Location "East US2"


New-AzResourceGroupDeployment `
-Name "Az-700" `
-ResourceGroupName "ExpressRouteResourceGroup" `
-TemplateFile .\u5-t1.bicep `
-Verbose
```

## Clean up resources
```Powershell
Remove-AzResourceGroup -Name 'ContosoResourceGroup' -Force -AsJob
Remove-AzResourceGroup -Name 'ExpressRouteResourceGroup' -Force -AsJob
```