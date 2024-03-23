# Unit 04
## Task 1:
```Powershell
New-AzResourceGroup -Name ContosoResourceGroup -Location "East US"
```

# Unit 05
## Task 1: Create and provision an ExpressRoute circuit
```Powershell
New-AzResourceGroup -Name ExpressRouteResourceGroup -Location "East US2"
```

## Task 4: Clean up resources
```Powershell
Remove-AzResourceGroup -Name 'ContosoResourceGroup' -Force -AsJob
Remove-AzResourceGroup -Name 'ExpressRouteResourceGroup' -Force -AsJob
```