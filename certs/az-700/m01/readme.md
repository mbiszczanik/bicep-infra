# Unit 04
## Task 1: Create the Contoso resource group
```Powershell
$DeploymentName = "Az700"
$RGName = "ContosoResourceGroup"
New-AzResourceGroup -Name $RGName -Location "East US"
```

## Task 3, 4, 5;
```Powershell
New-AzResourceGroupDeployment `
-Name $DeploymentName `
-ResourceGroupName $RGName `
-TemplateFile .\m01-u4-main.bicep `
-Verbose
```

# Unit 06
## Task 1: Create a private DNS Zone
```Powershell
New-AzResourceGroupDeployment `
-Name $DeploymentName `
-ResourceGroupName $RGName `
-TemplateFile .\u6-t1.bicep `
-Verbose
```

## Task 2: Link subnet for auto registration
```Powershell
New-AzResourceGroupDeployment `
-Name $DeploymentName `
-ResourceGroupName $RGName `
-TemplateFile .\u6-t2.bicep `
-Verbose
```

## Task 3: Create Virtual Machines to test the configuration
```Powershell
New-AzResourceGroupDeployment `
-Name $DeploymentName `
-ResourceGroupName $RGName `
-TemplateFile .\u6-t3-deploy.bicep `
-Verbose

Start-AzVM -ResourceGroupName -Name "testvm1" $RGName
Stop-AzVM -ResourceGroupName -Name "testvm1" $RGName 
```

# Unit 08
## Task 1: Create a Virtual Machine to test the configuration
```Powershell
New-AzResourceGroupDeployment `
-Name $DeploymentName `
-ResourceGroupName $RGName `
-TemplateFile .\u8-t1-deploy.bicep `
-Verbose
```

## Task 4: Create VNet peerings between CoreServicesVnet and ManufacturingVnet
```Powershell
New-AzResourceGroupDeployment `
-Name $DeploymentName `
-ResourceGroupName $RGName `
-TemplateFile .\u8-t4.bicep `
-Verbose
```

## Clean up resources
```Powershell
Remove-AzResourceGroup -Name $RGName -Force -AsJob
```