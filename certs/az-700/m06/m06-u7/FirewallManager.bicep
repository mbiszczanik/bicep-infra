/*

New-AzResourceGroupDeployment `
-Name 'Firewall' `
-ResourceGroupName 'Test-FW-RG' `
-TemplateFile .\FirewallManager.bicep `
-TemplateParameterFile .\.ori\FirewallManager.parameters.json

*/
@description('description')
param vmName1 string

@description('description')
param nicName1 string

@description('description')
param vmName2 string

@description('description')
param nicName2 string

@description('Virtual machine size')
param vmSize string = 'Standard_D2s_v3'

@description('Admin username')
param adminUsername string

@description('Admin password')
@secure()
param adminPassword string

var virtualNetworkName = 'Spoke-01'
var subnetName = 'Workload-01-SN'
var virtualNetworkName2 = 'Spoke-02'
var subnetName2 = 'Workload-02-SN'
var subnetRef = resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
var subnetRef2 = resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName2, subnetName2)

resource vm1 'Microsoft.Compute/virtualMachines@2023-07-01' = {
  name: vmName1
  location: resourceGroup().location
  properties: {
    osProfile: {
      computerName: vmName1
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
      }
    }
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'fromImage'
      }
      dataDisks: []
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: nic1.id
        }
      ]
    }
  }
}

resource nic1 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: nicName1
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetRef
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
  dependsOn: []
}

resource vm2 'Microsoft.Compute/virtualMachines@2023-07-01' = {
  name: vmName2
  location: resourceGroup().location
  properties: {
    osProfile: {
      computerName: vmName2
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVmAgent: 'true'
      }
    }
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'fromImage'
      }
      dataDisks: []
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: nic2.id
        }
      ]
    }
  }
}

resource nic2 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: nicName2
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetRef2
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
  dependsOn: []
}
