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


## Task 3: Create the load balancer
## Task 4: Create load balancer resources