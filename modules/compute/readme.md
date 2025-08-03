# Module: Compute

Reusable Bicep modules for deploying compute resources in Azure.

## Modules
- `vmSimpleLinux.bicep` — Simple Linux VM deployment
- `vmWindows.bicep` — Simple Windows VM deployment

## Usage Example
```bicep
module linuxVm 'vmSimpleLinux.bicep' = {
  name: 'linuxVm'
  params: {
    // ...parameters...
  }
}
```

See each module file for input parameters and outputs.
