# Unit 4
## Task 1: Create the virtual network
```Powershell
$RGName = "IntLB-RG"
New-AzResourceGroup -Name $RGName -Location "East US"
New-AzResourceGroupDeployment `
-Name 'Deploy_U4-T1' `
-ResourceGroupName $RGName `
-TemplateFile .\u4-t1-Vnets.bicep `
-Verbose
```

## Task 2: Create backend servers
```Powershell
New-AzResourceGroupDeployment -ResourceGroupName $RGName -TemplateFile azuredeploy.bicep -TemplateParameterFile .arm\azuredeploy.parameters.vm1.json -AsJob
New-AzResourceGroupDeployment -ResourceGroupName $RGName -TemplateFile azuredeploy.bicep -TemplateParameterFile .arm\azuredeploy.parameters.vm2.json -AsJob
New-AzResourceGroupDeployment -ResourceGroupName $RGName -TemplateFile azuredeploy.bicep -TemplateParameterFile .arm\azuredeploy.parameters.vm3.json -AsJob
```

## Task 3: Create the load balancer / Task 4: Create load balancer resources
```Powershell
New-AzResourceGroupDeployment `
-Name 'Deploy_U4-T3' `
-ResourceGroupName $RGName `
-TemplateFile .\u4-t3-Vnets.bicep `
-Verbose
```
## Task 5: Test the load balancer
Log in to any of the machines using Azure Bastion and test the solution, if there is a problem with switching you can turn off one machine and see if the traffic is redirected.

## Clean up resources
```Powershell
Remove-AzResourceGroup -Name $RGName -Force -AsJob
```

