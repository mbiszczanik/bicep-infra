```PowerShell
New-AzResourceGroupDeployment `
-Name 'm08-u3-1' `
-ResourceGroupName 'IntLB-RG' `
-TemplateFile azuredeploy.json `
-TemplateParameterFile azuredeploy.parameters.vm1.json `
-Verbose

New-AzResourceGroupDeployment `
-Name 'm08-u3-2' `
-ResourceGroupName 'IntLB-RG' `
-TemplateFile azuredeploy.json `
-TemplateParameterFile azuredeploy.parameters.vm2.json `

New-AzResourceGroupDeployment `
-Name 'm08-u3-3' `
-ResourceGroupName 'IntLB-RG' `
-TemplateFile azuredeploy.json `
-TemplateParameterFile azuredeploy.parameters.vm3.json `
-Verbose

Remove-AzResourceGroup -Name 'IntLB-RG' -Force -AsJob

```