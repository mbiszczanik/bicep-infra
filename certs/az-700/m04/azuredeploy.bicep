/*

New-AzResourceGroupDeployment `
-Name "Az-700" `
-ResourceGroupName "IntLB-VNet" `
-TemplateFile .\azuredeploy.bicep `
-TemplateParameterFile .\.ori\azuredeploy.parameters.vm1.json `
-Verbose

New-AzResourceGroupDeployment `
-Name "Az-700" `
-ResourceGroupName "IntLB-VNet" `
-TemplateFile .\azuredeploy.bicep `
-TemplateParameterFile .\.ori\azuredeploy.parameters.vm2.json `
-Verbose

New-AzResourceGroupDeployment `
-Name "Az-700" `
-ResourceGroupName "IntLB-VNet" `
-TemplateFile .\azuredeploy.bicep `
-TemplateParameterFile .\.ori\azuredeploy.parameters.vm3.json `
-Verbose

*/

@description('description')
param vmName string

param location string = resourceGroup().location

@description('description')
param nicName string

@description('Virtual machine size')
param vmSize string = 'Standard_B2ms'

@description('Admin username')
param adminUsername string

@description('Admin password')
@secure()
param adminPassword string

var virtualNetworkName = 'IntLB-VNet'
var nsgName = 'myNSG'
var subnetName = 'myBackendSubnet'
var subnetRef = resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)

resource vm 'Microsoft.Compute/virtualMachines@2023-07-01' = {
  name: vmName
  location: location
  properties: {
    osProfile: {
      computerName: vmName
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
          storageAccountType: 'Standard_LRS'
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
          id: nic.id
        }
      ]
    }
  }
}

resource vmName_VMConfig 'Microsoft.Compute/virtualMachines/extensions@2023-07-01' = {
  parent: vm
  name: 'VMConfig'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.7'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        'https://raw.githubusercontent.com/tiagocostapt/az-700-labs/master/install-iis.ps1'
      ]
      commandToExecute: 'powershell.exe -ExecutionPolicy Unrestricted -File install-iis.ps1'
    }
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: nicName
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
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-rdp'
        properties: {
          priority: 1000
          sourceAddressPrefix: '*'
          protocol: 'Tcp'
          destinationPortRange: '3389'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}
