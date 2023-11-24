/* 

New-AzResourceGroupDeployment `
-Name "Az-700" `
-ResourceGroupName "ContosoResourceGroup" `
-TemplateFile .\ManufacturingVMazuredeploy.bicep `
-Verbose

Start-AzVM -ResourceGroupName -Name "ManufacturingVM" "ContosoResourceGroup"

Stop-AzVM -ResourceGroupName -Name "ManufacturingVM" "ContosoResourceGroup" 

*/

@description('description')
param vmName1 string = 'ManufacturingVM'

@description('description')
param nicName1 string = 'ManufacturingVM-nic'

@description('Virtual machine size')
param vmSize string = 'Standard_B2ms'

@description('Admin username')
param adminUsername string

@description('Admin password')
@secure()
param adminPassword string

var virtualNetworkName = 'ManufacturingVnet'
var nsgName1 = 'ManufacturingVM-nsg'
var PIPName1 = 'ManufacturingVM-ip'
var subnetName = 'ManufacturingSystemSubnet'
var subnetRef = resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
var location = 'West Europe'

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
          publicIPAddress: {
            id: PIP1.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg1.id
    }
  }
}

resource nsg1 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: nsgName1
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

resource PIP1 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: PIPName1
  location: location
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
  }
}
