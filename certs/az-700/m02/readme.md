# Unit 3
## Task 1: Create the Contoso resource group
```Powershell
$RGName = "ContosoResourceGroup"
New-AzResourceGroup -Name $RGName -Location "East US"
```
## Task 1: Create CoreServicesVnet and ManufacturingVnet
```Powershell
New-AzResourceGroupDeployment `
-Name 'Deploy_U3-T1' `
-ResourceGroupName $RGName `
-TemplateFile .\u3-t1-Vnets.bicep `
-Verbose
```

## Task 2: Create CoreServicesVM
```Powershell
New-AzResourceGroupDeployment `
-Name 'Deploy_U3-T2' `
-ResourceGroupName $RGName `
-TemplateFile .\u3-t2-CoreServicesVM.bicep `
-Verbose

Start-AzVM -ResourceGroupName $RGName -Name "CoreServicesVM" 
Stop-AzVM -ResourceGroupName $RGName -Name "CoreServicesVM" 
```

## Task 3: Create ManufacturingVM
```Powershell
New-AzResourceGroupDeployment `
-Name 'Deploy_U3-T3' `
-ResourceGroupName $RGName `
-TemplateFile .\u3-t3-ManufacturingVM.bicep `
-Verbose

Start-AzVM -ResourceGroupName $RGName -Name "ManufacturingVM" 
Stop-AzVM -ResourceGroupName $RGName -Name "ManufacturingVM" 
```

# Unit 8
## Task 1: Create a Virtual Machine to test the configuration
```Powershell
New-AzResourceGroupDeployment `
-Name 'Deploy_U8-T1' `
-ResourceGroupName $RGName `
-TemplateFile .\u8-t1-deploy.bicep `
-Verbose
```

## Task 4: Create VNet peerings between CoreServicesVnet and ManufacturingVnet
```Powershell
New-AzResourceGroupDeployment `
-Name 'Deploy_U8-T4' `
-ResourceGroupName $RGName `
-TemplateFile .\u8-t4.bicep `
-Verbose
```

## Clean up resources
```Powershell
Remove-AzResourceGroup -Name $RGName -Force -AsJob
```