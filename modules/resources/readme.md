# Module: Resources

Reusable Bicep module for deploying Azure Resource Groups.

## Module
- `resourceGroup.bicep` — Azure Resource Group

## Usage Example
```bicep
module rg 'resourceGroup.bicep' = {
  name: 'rg'
  params: {
    // ...parameters...
  }
}
```

See the module file for input parameters and outputs.
