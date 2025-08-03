# Module: Network

Reusable Bicep modules for deploying network resources in Azure.

## Modules
- `virtualNetwork.bicep` — Virtual Network
- `networkInterface.bicep` — Network Interface
- `networkSecurityGroup.bicep` — Network Security Group
- `publicIPaddress.bicep` — Public IP Address

## Usage Example
```bicep
module vnet 'virtualNetwork.bicep' = {
  name: 'vnet'
  params: {
    // ...parameters...
  }
}
```

See each module file for input parameters and outputs.
