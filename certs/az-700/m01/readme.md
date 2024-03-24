# Unit 4
## Task 1: Create the Contoso resource group
```Powershell
$RGName = "ContosoResourceGroup"
New-AzResourceGroup -Name $RGName -Location "East US"
```

## Task 3, 4, 5;
```Powershell
New-AzResourceGroupDeployment `
-Name 'Deploy_U4' `
-ResourceGroupName $RGName `
-TemplateFile .\m01-u4-main.bicep `
-Verbose
```

# Unit 6
## Task 1: Create a private DNS Zone
```Powershell
New-AzResourceGroupDeployment `
-Name 'Deploy_U6-T1' `
-ResourceGroupName $RGName `
-TemplateFile .\u6-t1.bicep `
-Verbose
```

## Task 2: Link subnet for auto registration
```Powershell
New-AzResourceGroupDeployment `
-Name 'Deploy_U6-T2' `
-ResourceGroupName $RGName `
-TemplateFile .\u6-t2.bicep `
-Verbose
```

## Task 3: Create Virtual Machines to test the configuration
```Powershell
New-AzResourceGroupDeployment `
-Name 'Deploy_U6-T3' `
-ResourceGroupName $RGName `
-TemplateFile .\u6-t3-deploy.bicep `
-Verbose

Start-AzVM -ResourceGroupName $RGName -Name "testvm1" 
Stop-AzVM -ResourceGroupName $RGName -Name "testvm1" 
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