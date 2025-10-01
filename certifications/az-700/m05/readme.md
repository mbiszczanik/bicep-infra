# Unit 4
## Task 1: Create the virtual network
```Powershell
$RGName = ""
New-AzResourceGroup -Name $RGName -Location "East US"
New-AzResourceGroupDeployment `
-Name 'Deploy_U4-T1' `
-ResourceGroupName $RGName `
-TemplateFile .\u4-t1.bicep `
-Verbose
```

## Task 2: Create virtual machines
```Powershell
New-AzResourceGroupDeployment `
-Name 'Deploy_U4-T2' `
-ResourceGroupName $RGName `
-TemplateFile .\u4-t2-deploy.bicep `
-Verbose
```


## Clean up resources
```Powershell
Remove-AzResourceGroup -Name $RGName -Force -AsJob
```

