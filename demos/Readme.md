# 






## Retrieve detailed error information for a specific operation:
```Powershell
# Define the resource group and deployment name
$resourceGroupName = "Contoso-WEU-VNET-RG"
$deploymentName = "TestContosoVM"

# Get the deployment operations
$operations = Get-AzResourceGroupDeploymentOperation -ResourceGroupName $resourceGroupName -DeploymentName $deploymentName

# Display the operations with their status
$operations | Format-Table -Property OperationId, StatusCode, StatusMessage

# Get detailed error information for a specific operation
$operationId = "12345678-1234-1234-1234-1234567890ab" # Replace with the OperationId from the previous output
$operationDetails = $operations | Where-Object { $_.OperationId -eq $operationId }

# Display the detailed error information
$operationDetails.Properties.StatusMessage | ConvertTo-Json -Depth 10
```


## Clean up resources
```Powershell
Remove-AzResourceGroup -Name Contoso-WEU-VNET-RG -Force -AsJob
Remove-AzResourceGroup -Name Fabrikam-WEU-VNET-RG -Force -AsJob
Remove-AzResourceGroup -Name Tailwind-WEU-VNET-RG -Force -AsJob
```