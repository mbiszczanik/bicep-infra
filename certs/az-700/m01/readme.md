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