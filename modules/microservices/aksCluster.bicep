/*
SUMMARY: AKS cluster resource
DESCRIPTION: 
AUTHOR/S: Marcin Biszczanik
VERSION: 1.0
*/

//////////////////////////////////  PARAMETERS //////////////////////////////////
param aks_Name string
param aks_Location string
param aks_Version string = '1.19.7'
param aks_DiskSize int = 0
param aks_AgentCount int = 3
param aks_VMSize string = 'Standard_B2s'
param aks_AdminUsername string = 'adminroot'
param aks_SshPublicKey string

//////////////////////////////////  RESOURCES //////////////////////////////////
resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-06-01' = {
  name: aks_Name
  location: aks_Location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    kubernetesVersion: aks_Version
    dnsPrefix: 'dnsprefix'
    enableRBAC: true
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: aks_DiskSize
        count: aks_AgentCount
        vmSize: aks_VMSize
        osType: 'Linux'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: aks_AdminUsername
      ssh: {
        publicKeys: [
          {
            path: 
            keyData: aks_SshPublicKey
          }
        ]
      }
    }
  }
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
output controlPlaneFQDN string = aksCluster.properties.fqdn
