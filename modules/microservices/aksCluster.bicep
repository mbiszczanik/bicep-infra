/*
SUMMARY: AKS cluster resource
DESCRIPTION: Deploys an Azure Kubernetes Service (AKS) cluster with configurable agent pool, version, and authentication. Follows Bicep style and parameter conventions.
AUTHOR/S: Marcin Biszczanik
VERSION: 1.1
*/

/*******************
*   Target Scope   *
*******************/
targetScope = 'resourceGroup'

/*******************
*    Parameters    *
*******************/
@description('The name of the AKS cluster.')
param parAksName string

@description('The Azure region for the AKS cluster.')
param parLocation string = resourceGroup().location

@description('The Kubernetes version for the AKS cluster.')
param parAksVersion string

@description('The OS disk size in GB for each node. Default is 0 (platform default).')
param parAksDiskSize int = 0

@description('The number of agent nodes. Default is 3.')
@allowed([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
param parAksAgentCount int = 3

@description('The VM size for the agent nodes.')
param parAksVmSize string

@description('The admin username for Linux nodes. Default is adminroot.')
param parAksAdminUsername string = 'adminroot'

@description('The SSH public key for the Linux admin user.')
param parAksSshPublicKey string

/*******************
*    Variables     *
*******************/
// Add variables here if needed for naming, tags, or logic

/*******************
*    Resources     *
*******************/
resource resAksCluster 'Microsoft.ContainerService/managedClusters@2023-06-01' = {
  name: parAksName
  location: parLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    kubernetesVersion: parAksVersion
    dnsPrefix: '${parAksName}-dns'
    enableRBAC: true
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: parAksDiskSize
        count: parAksAgentCount
        vmSize: parAksVmSize
        osType: 'Linux'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: parAksAdminUsername
      ssh: {
        publicKeys: [
          {
            keyData: parAksSshPublicKey
          }
        ]
      }
    }
  }
}

/******************
*     Outputs     *
******************/
output controlPlaneFqdn string = resAksCluster.properties.fqdn
