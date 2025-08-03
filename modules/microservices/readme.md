# Module: Microservices

Reusable Bicep module for deploying Azure Kubernetes Service (AKS) clusters.

## Module
- `aksCluster.bicep` — Azure Kubernetes Service (AKS) Cluster

## Usage Example
```bicep
module aks 'aksCluster.bicep' = {
  name: 'aks'
  params: {
    // ...parameters...
  }
}
```

See the module file for input parameters and outputs.
