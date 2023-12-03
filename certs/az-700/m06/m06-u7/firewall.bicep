/*

# Deployment
New-AzResourceGroupDeployment `
-Name 'Firewall' `
-ResourceGroupName 'Test-FW-RG' `
-TemplateFile .\firewall.bicep `
-TemplateParameterFile .\.ori\firewall.parameters.json


Task 3: Create a virtual machine

*/

@description('description')
param vmName1 string

@description('description')
param nicName1 string

@description('Virtual machine size')
param vmSize string = 'Standard_B2ms'

@description('Admin username')
param adminUsername string

@description('Admin password')
@secure()
param adminPassword string

var virtualNetworkName = 'Test-FW-VN'
var subnetName = 'Workload-SN'
var subnetRef = resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)

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
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
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
