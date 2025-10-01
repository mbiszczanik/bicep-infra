```PowerShell
$RGName = "CreatePrivateEndpointQS-rg"

New-AzResourceGroup -Name $RGName -Location 'EastUS'

New-AzResourceGroupDeployment -ResourceGroupName $RGName -TemplateFile main.bicep -TemplateParameterFile azuredeploy.parameters.json
```
