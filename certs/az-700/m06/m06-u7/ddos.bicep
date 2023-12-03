/*

New-AzResourceGroupDeployment `
-Name 'Firewall' `
-ResourceGroupName 'Test-FW-RG' `
-TemplateFile .\ddos.bicep `
-TemplateParameterFile .\.ori\ddos.parameters.json

*/
@description('description')
param vmName1 string

@description('description')
param nicName1 string

@description('Virtual machine size')
param vmSize string = 'Standard_D2s_v3'

@description('Admin username')
param adminUsername string

@description('Admin password')
@secure()
param adminPassword string

var virtualNetworkName = 'MyVirtualNetwork'
var subnetName = 'default'
var nsgName1 = 'MyVirtualMachine-nsg'
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
          id: nic1.id
        }
      ]
      networkSecurityGroup: {
        id: nsg1.id
      }
    }
  }
}

resource nsg1 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: nsgName1
  location: resourceGroup().location
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
