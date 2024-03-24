# Unit 04
## Task 1: Create the Contoso resource group
```Powershell
New-AzResourceGroup -Name ContosoResourceGroup -Location "East US"
```

## Task 3, 4, 5;
```Powershell
New-AzResourceGroupDeployment `
-Name "Az-700" `
-ResourceGroupName "ContosoResourceGroup" `
-TemplateFile .\m01-u4-main.bicep `
-Verbose
```

# Unit 06
## Task 1: Create a private DNS Zone
```Powershell
New-AzResourceGroupDeployment `
-Name "Az-700" `
-ResourceGroupName "ContosoResourceGroup" `
-TemplateFile .\u6-t1.bicep `
-Verbose
```

## Task 2: Link subnet for auto registration
```Powershell
New-AzResourceGroupDeployment `
-Name "Az-700" `
-ResourceGroupName "ContosoResourceGroup" `
-TemplateFile .\u6-t2.bicep `
-Verbose
```

## Task 3: Create Virtual Machines to test the configuration
```Powershell
New-AzResourceGroupDeployment `
-Name "Az-700" `
-ResourceGroupName "ContosoResourceGroup" `
-TemplateFile .\u6-t3-deploy.bicep `
-Verbose

Start-AzVM -ResourceGroupName -Name "testvm1" "ContosoResourceGroup"
Stop-AzVM -ResourceGroupName -Name "testvm1" "ContosoResourceGroup" 
```

## Clean up resources
```Powershell
Remove-AzResourceGroup -Name 'ContosoResourceGroup' -Force -AsJob
```