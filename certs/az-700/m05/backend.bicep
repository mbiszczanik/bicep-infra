/*

New-AzResourceGroupDeployment `
-Name "Az-700" `
-ResourceGroupName "ContosoResourceGroup" `
-TemplateFile .\backend.bicep `
-TemplateParameterFile .\.ori\backend.parameters.json `
-Verbose


*/

@description('description')
param vmName1 string

@description('description')
param nicName1 string

@description('description')
param vmName2 string

@description('description')
param nicName2 string

param location string = resourceGroup().location

@description('Virtual machine size')
param vmSize string = 'Standard_D2s_v3'

@description('Admin username')
param adminUsername string

@description('Admin password')
@secure()
param adminPassword string

var virtualNetworkName = 'ContosoVnet'
var subnetName = 'BackendSubnet'
var subnetRef = resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)

resource vm1 'Microsoft.Compute/virtualMachines@2023-07-01' = {
  name: vmName1
  location: location
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
  location: location
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
}

resource vm2 'Microsoft.Compute/virtualMachines@2023-07-01' = {
  name: vmName2
  location: location
  properties: {
    osProfile: {
      computerName: vmName2
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
          id: nic2.id
        }
      ]
    }
  }
}

resource nic2 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: nicName2
  location: location
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
}

resource vmName1_VMConfig 'Microsoft.Compute/virtualMachines/extensions@2023-07-01' = {
  parent: vm1
  name: 'VMConfig'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.7'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        'https://raw.githubusercontent.com/MicrosoftLearning/AZ-700-Designing-and-Implementing-Microsoft-Azure-Networking-Solutions/master/Allfiles/Exercises/M05/install-iis.ps1'
      ]
      commandToExecute: 'powershell.exe -ExecutionPolicy Unrestricted -File install-iis.ps1'
    }
  }
}

resource vmName2_VMConfig 'Microsoft.Compute/virtualMachines/extensions@2023-07-01' = {
  parent: vm2
  name: 'VMConfig'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.7'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        'https://raw.githubusercontent.com/MicrosoftLearning/AZ-700-Designing-and-Implementing-Microsoft-Azure-Networking-Solutions/master/Allfiles/Exercises/M05/install-iis.ps1'
      ]
      commandToExecute: 'powershell.exe -ExecutionPolicy Unrestricted -File install-iis.ps1'
    }
  }
}
